# Config
$ErrorActionPreference = "Stop"
$version = "1.1.0+26.X"
$packDir = "pack"
$buildDir = "build"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
if ($scriptDir) { Set-Location $scriptDir }

$fileVersion = $version.Replace('+', '-')
$packZip = "$buildDir\CoordsAndDays-pack-$fileVersion.zip"
$modJar = "$buildDir\CoordsAndDays-fabric-$version.jar"

Write-Host "Building Coords & Days packages (Version: $version)..." -ForegroundColor Cyan

foreach ($requiredPath in @("$packDir\pack.mcmeta", "$packDir\assets", "$packDir\data")) {
    if (-not (Test-Path -LiteralPath $requiredPath)) {
        throw "Required pack content not found at $requiredPath"
    }
}

$packMetadata = Get-Content -LiteralPath "$packDir\pack.mcmeta" -Raw -Encoding UTF8 | ConvertFrom-Json
foreach ($overlay in $packMetadata.overlays.entries) {
    if (-not (Test-Path -LiteralPath "$packDir\$($overlay.directory)" -PathType Container)) {
        throw "Overlay directory not found: $($overlay.directory)"
    }
}

if (-not (Test-Path $buildDir)) {
    Write-Host "Creating build directory..." -ForegroundColor Gray
    New-Item -ItemType Directory -Path $buildDir -Force | Out-Null
}

function Zip-FolderContents {
    param (
        [string]$srcDir,
        [string]$destZip
    )
    if (Test-Path $destZip) {
        Write-Host "Removing existing $destZip..." -ForegroundColor Yellow
        Remove-Item $destZip -Force
    }
    
    $srcPath = (Resolve-Path $srcDir).Path
    $destPath = [System.IO.Path]::GetFullPath($destZip)
    
    Write-Host "Compressing contents of '$srcDir' into '$destZip'..." -ForegroundColor Green
    
    Add-Type -AssemblyName System.IO.Compression
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    
    $archive = [System.IO.Compression.ZipFile]::Open($destPath, [System.IO.Compression.ZipArchiveMode]::Create)
    try {
        $files = Get-ChildItem -Path $srcPath -Recurse -File
        foreach ($file in $files) {
            $srcPathNormalized = $srcPath.TrimEnd('\') + '\'
            $relative = $file.FullName.Substring($srcPathNormalized.Length)
            $entryName = $relative.Replace('\', '/')
            [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $file.FullName, $entryName) | Out-Null
        }
    } finally {
        $archive.Dispose()
    }
}

function Zip-FabricMod {
    param (
        [string]$packDir,
        [string]$destJar
    )
    if (Test-Path $destJar) {
        Write-Host "Removing existing $destJar..." -ForegroundColor Yellow
        Remove-Item $destJar -Force
    }
    
    $destPath = [System.IO.Path]::GetFullPath($destJar)
    
    Write-Host "Building mod jar into '$destJar'..." -ForegroundColor Green
    
    Add-Type -AssemblyName System.IO.Compression
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    
    $archive = [System.IO.Compression.ZipFile]::Open($destPath, [System.IO.Compression.ZipArchiveMode]::Create)
    try {
        if (Test-Path "fabric.mod.json") {
            $jsonContent = Get-Content -Raw -Path "fabric.mod.json"
            $jsonContent = $jsonContent -replace '"version":\s*"[^"]*"', "`"version`": `"$version`""
            
            $tempFile = [System.IO.Path]::GetTempFileName()
            Set-Content -Path $tempFile -Value $jsonContent -Encoding UTF8
            [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $tempFile, "fabric.mod.json") | Out-Null
            Remove-Item $tempFile -Force
        }
        
        $srcPath = (Resolve-Path $packDir).Path
        $srcPathNormalized = $srcPath.TrimEnd('\') + '\'
        foreach ($file in (Get-ChildItem -Path $srcPath -Recurse -File)) {
            $relative = $file.FullName.Substring($srcPathNormalized.Length)
            $entryName = $relative.Replace('\', '/')
            [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $file.FullName, $entryName) | Out-Null
        }
    } finally {
        $archive.Dispose()
    }
}

Zip-FolderContents -srcDir $packDir -destZip $packZip
Zip-FabricMod -packDir $packDir -destJar $modJar

Write-Host "Build completed! Output folder: $buildDir" -ForegroundColor Green