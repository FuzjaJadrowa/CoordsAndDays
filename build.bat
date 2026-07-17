@echo off
title Coords & Days Builder
echo Running build script...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0build.ps1"
echo.
pause
