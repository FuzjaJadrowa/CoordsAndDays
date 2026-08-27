# Config
$version = "1.0.1+26.3"
$datapackDir = "datapack"
$resourcepackDir = "resourcepack"
$buildDir = "build"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
if ($scriptDir) { Set-Location $scriptDir }

$datapackZip = "$buildDir\CoordsAndDays-datapack-$version.zip"
$resourcepackZip = "$buildDir\CoordsAndDays-resourcepack-$version.zip"
$modJar = "$buildDir\CoordsAndDays-fabric-$version.jar"

Write-Host "Building Coords & Days packages (Version: $version)..." -ForegroundColor Cyan

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
        [string]$datapackDir,
        [string]$resourcepackDir,
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
        
        if (Test-Path "$resourcepackDir\pack.png") {
            $iconPath = (Resolve-Path "$resourcepackDir\pack.png").Path
            [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $iconPath, "pack.png") | Out-Null
        }
        
        if (Test-Path "$datapackDir\data") {
            $srcPath = (Resolve-Path "$datapackDir\data").Path
            $files = Get-ChildItem -Path $srcPath -Recurse -File
            foreach ($file in $files) {
                $srcPathNormalized = $srcPath.TrimEnd('\') + '\'
                $relative = $file.FullName.Substring($srcPathNormalized.Length)
                $entryName = "data/" + $relative.Replace('\', '/')
                [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $file.FullName, $entryName) | Out-Null
            }
        }
        
        if (Test-Path "$resourcepackDir\assets") {
            $srcPath = (Resolve-Path "$resourcepackDir\assets").Path
            $files = Get-ChildItem -Path $srcPath -Recurse -File
            foreach ($file in $files) {
                $srcPathNormalized = $srcPath.TrimEnd('\') + '\'
                $relative = $file.FullName.Substring($srcPathNormalized.Length)
                $entryName = "assets/" + $relative.Replace('\', '/')
                [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $file.FullName, $entryName) | Out-Null
            }
        }
    } finally {
        $archive.Dispose()
    }
}

if (Test-Path $datapackDir) {
    Zip-FolderContents -srcDir $datapackDir -destZip $datapackZip
} else {
    Write-Warning "Datapack directory not found at $datapackDir"
}

if (Test-Path $resourcepackDir) {
    Zip-FolderContents -srcDir $resourcepackDir -destZip $resourcepackZip
} else {
    Write-Warning "Resourcepack directory not found at $resourcepackDir"
}

if ((Test-Path $datapackDir) -and (Test-Path $resourcepackDir)) {
    Zip-FabricMod -datapackDir $datapackDir -resourcepackDir $resourcepackDir -destJar $modJar
} else {
    Write-Warning "Cannot build Fabric mod because datapack or resourcepack directory is missing."
}

Write-Host "Build completed! Output folder: $buildDir" -ForegroundColor Green