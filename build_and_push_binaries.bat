@echo off
D:
cd %~dp0
set ProjectFolder=%~dp0
set /p UnrealBuildBatchPath=<%~dp0UnrealBuildBatchPath.txt

for %%f in (*.uproject) do (
    if "%%~xf"==".uproject" set ProjectName=%%~nf
)

@rd /s /q "%ProjectFolder%\Binaries"
call %UnrealBuildBatchPath% %ProjectName%Editor Win64 Development -Project="%ProjectFolder%\%ProjectName%.uproject" -WaitMutex -FromMsBuild
call %ProjectFolder%\push_binaries.bat