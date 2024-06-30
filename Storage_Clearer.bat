@echo off
setlocal enabledelayedexpansion

set "targetFolder=AppData\Local\Microsoft\teams"
set "targetFolder2=AppData\Local\Microsoft\edge"
set "targetFolder3=AppData\Local\Google\"

for /D %%i in (C:\Users\*) do (
    set "profilePath=%%i"
    set "targetPath=!profilePath!\!targetFolder!"
    set "targetPath2=!profilePath!\!targetFolder2!"
    set "targetPath3=!profilePath!\!targetFolder3!"

    if exist "!targetPath!" (
        echo Deleting: !targetPath!
        rd /s /q "!targetPath!"
    )

    if exist "!targetPath2!" (
        echo Deleting: !targetPath2!
        rd /s /q "!targetPath2!"
    )

    if exist "!targetPath3!" (
        echo Deleting: !targetPath3!
        rd /s /q "!targetPath3!"
    )
)

echo Complete.
pause
