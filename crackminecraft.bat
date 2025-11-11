@echo off
setlocal EnableDelayedExpansion

set "MinecraftExe=Minecraft.Windows.exe"
set "ModLoaderDll=ModLoader.dll"
set "VCRuntimeName=vcruntime140_1.dll"
set "FreeDll=MinecraftForFree.dll"

for /f "usebackq delims=" %%A in (`powershell -NoProfile -Command ^
    "try{(Get-AppxPackage Microsoft.MinecraftUWP).InstallLocation}catch{exit 1}" 2^>nul`) do (
    set "InstallDir=%%A"
)

if not defined InstallDir (
    echo NotFound
    goto End
)

if not exist "!InstallDir!\%MinecraftExe%" (
    echo NotFound
    goto End
)

if not exist "%CD%\%ModLoaderDll%" (
    echo Missing
    goto End
)

copy /Y "%CD%\%ModLoaderDll%" "!InstallDir!\%VCRuntimeName%" >nul 2>&1

for /f "usebackq tokens=*" %%A in (`powershell -NoProfile -Command ^
    "[Environment]::GetFolderPath('ApplicationData')"`) do set "AppData=%%A"

set "TargetDir=!AppData!\Minecraft Bedrock\mods"

if not exist "!AppData!\Minecraft Bedrock" mkdir "!AppData!\Minecraft Bedrock"
if not exist "!TargetDir!" mkdir "!TargetDir!"

if not exist "%CD%\%FreeDll%" (
    echo Missing
    goto End
)

copy /Y "%CD%\%FreeDll%" "!TargetDir!\%FreeDll%" >nul 2>&1

if !errorlevel! equ 0 (
    echo Done
) else (
    echo Failed
)

:End
endlocal
exit /b