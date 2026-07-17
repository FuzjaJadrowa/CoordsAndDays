# Config
$version = "1.0.0+26.3"
$datapackDir = "datapack"
$resourcepackDir = "resourcepack"
$buildDir = "build"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
if ($scriptDir) { Set-Location $scriptDir }

$datapackZip = "$buildDir\CoordsAndDays-datapack-$version.zip"
$resourcepackZip = "$buildDir\CoordsAndDays-resourcepack-$version.zip"

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
    
    $srcPath = Resolve-Path $srcDir
    $destPath = [System.IO.Path]::GetFullPath($destZip)
    
    Write-Host "Compressing contents of '$srcDir' into '$destZip'..." -ForegroundColor Green
    
    Get-ChildItem -Path "$srcPath\*" | Compress-Archive -DestinationPath $destPath -Force
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

Write-Host "Build completed! Output folder: $buildDir" -ForegroundColor Green
