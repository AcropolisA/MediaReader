@echo off
setlocal

set VERSION=2.1.6

set OUTPUT=c:\NuGet\

if exist "%ProgramFiles%\MSBuild\12.0\Bin\msbuild.exe" (
    set BUILD="%ProgramFiles%\MSBuild\12.0\Bin\msbuild.exe"
)
if exist "%ProgramFiles(x86)%\MSBuild\12.0\Bin\msbuild.exe" (
    set BUILD="%ProgramFiles(x86)%\MSBuild\12.0\Bin\msbuild.exe"
)

if exist "%ProgramFiles%\Git\cmd\git.exe" (
    set GIT="%ProgramFiles%\Git\cmd\git.exe"
)
if exist "%ProgramFiles(x86)%\Git\cmd\git.exe" (
    set GIT="%ProgramFiles(x86)%\Git\cmd\git.exe"
)

REM Clean
call .\clean.cmd

REM Build
%BUILD% .\pack.sln /maxcpucount /target:build /nologo /p:Configuration=Release /p:Platform=Win32
%BUILD% .\pack.sln /maxcpucount /target:build /nologo /p:Configuration=Release /p:Platform=x64
%BUILD% .\pack.sln /maxcpucount /target:build /nologo /p:Configuration=Release /p:Platform=ARM

REM Pack
%OUTPUT%nuget.exe pack MMaitre.MediaCaptureReader.nuspec -OutputDirectory %OUTPUT%Packages -Prop NuGetVersion=%VERSION% -NoPackageAnalysis
%OUTPUT%nuget.exe pack MMaitre.MediaCaptureReader.Symbols.nuspec -OutputDirectory %OUTPUT%Symbols -Prop NuGetVersion=%VERSION% -NoPackageAnalysis

REM Tag
%GIT% tag --force %VERSION%
