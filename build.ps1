# Config
$ErrorActionPreference = "Stop"
$version = "1.0.1+26.3"
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
        
        if (Test-Path "$packDir\pack.png") {
            $iconPath = (Resolve-Path "$packDir\pack.png").Path
            [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $iconPath, "pack.png") | Out-Null
        }
        
        foreach ($folder in @("data", "assets")) {
            $srcPath = (Resolve-Path "$packDir\$folder").Path
            $files = Get-ChildItem -Path $srcPath -Recurse -File
            foreach ($file in $files) {
                $srcPathNormalized = $srcPath.TrimEnd('\') + '\'
                $relative = $file.FullName.Substring($srcPathNormalized.Length)
                $entryName = "$folder/" + $relative.Replace('\', '/')
                [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $file.FullName, $entryName) | Out-Null
            }
        }
    } finally {
        $archive.Dispose()
    }
}

Zip-FolderContents -srcDir $packDir -destZip $packZip
Zip-FabricMod -packDir $packDir -destJar $modJar

Write-Host "Build completed! Output folder: $buildDir" -ForegroundColor Green
