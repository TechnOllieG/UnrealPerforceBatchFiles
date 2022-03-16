@echo off

rem Login
echo Welcome to the ultra 1337 h4x0r perforce setup program!
echo Running this will help set up your workspace to work smoothly with programmers because Unreal is kinda doodoo on that front.
echo If there are any issues or questions, hit up your local friendly programmer.
echo.
pause

echo.
echo Step 1. Login
echo.
echo (Protip, the stuff in [...] will be defaulted if nothing is entered)
echo.

set /p port="Server (in the form IP:PORT) [%P4PORT%]: " || set port=%P4PORT%
set /p user="Username [%P4USER%]: " || set user=%P4USER%
setx P4PORT %port% > nul
setx P4USER %user% > nul
set P4PORT=%port%
set P4USER=%user%

p4 login

if ERRORLEVEL 1 (
	rem Failed login..
	goto error
)

echo.
echo Step 2. Depot
echo This should be in the form 'FG20FT_GP3_TeamX'
echo (so for example FG20FT_GP3_TeamX or FG20FT_GP3_TeamX etc.)
echo.

set /p depot="Depot Name: "

echo.
echo Step 3. Workspace Name
echo This is up to you, but name it something useful and UNIQUE! Like '%P4USER%_GP3' or '%P4USER%_GP3_Desktop' for example.
echo.

set /p workspace="Workspace Name [%P4USER%_GP3]: " || set workspace=%P4USER%_GP3

echo.
echo Step 4. Workspace Root
echo This is where your project is gonna be located. Choose wisely, please dont put it on the desktop!
echo.
echo IMPORTANT! When CREATING the Unreal Project (at the beginning of the project)
echo 	make sure that you put the project (IE the .uproject file) directly in the workspace root, NOT in a subfolder. 
echo If you put the Unreal Project in a subfolder the workspace mappings wont work and you wont be able to use my cool scripts :( sadge
echo.

set /p workspace_root="Workspace Root [%cd%]: " || set workspace_root=%cd%
set workspace_root=%workspace_root:/=\%
md %workspace_root% > nul
pushd %workspace_root%

rem Init the ignore list
set view_mapping=--field "View=//%depot%/... //%workspace%/..."
set view_mapping=%view_mapping% --field "View+=-//%depot%/Intermediate/... //%workspace%/Intermediate/..."
set view_mapping=%view_mapping% --field "View+=-//%depot%/Build/... //%workspace%/Build/..."
set view_mapping=%view_mapping% --field "View+=-//%depot%/DerivedDataCache/... //%workspace%/DerivedDataCache/..."
set view_mapping=%view_mapping% --field "View+=-//%depot%/Saved/... //%workspace%/Saved/..."

rem Choose what you are
echo.
echo Step 5. Choose your class
echo What are you? (Type the number)
echo 1. Human being
echo 2. Programmer
echo.
choice /n /c:12 /m "Choose option: "
if %ERRORLEVEL%==1 goto setup_other
if %ERRORLEVEL%==2 goto setup_programmer

:setup_other
echo.
echo Setting up workspace...

p4 %view_mapping% --field "Root=%cd%" client -o %workspace% | p4 client -i
if ERRORLEVEL 1 (
	echo.
	echo Uh oh!!! Error when creating workspace. Did you enter depot '%depot%' correctly?
	echo.
	goto error
)

echo.
echo Done! Nothing more is required of you, just hit up P4V, select workspace '%workspace%' and have a blast!
echo Best of luck! Mwah~
echo.

goto done

:setup_programmer
rem Add programmer ignores
set view_mapping=%view_mapping% --field "View+=-//%depot%/Binaries/... //%workspace%/Binaries/..."
set view_mapping=%view_mapping% --field "View+=-//%depot%/.vs/... //%workspace%/.vs/..."
set view_mapping=%view_mapping% --field "View+=-//%depot%/.idea/... //%workspace%/.idea/..."
set view_mapping=%view_mapping% --field "View+=-//%depot%/*.sln //%workspace%/*.sln"
set view_mapping=%view_mapping% --field "View+=-//%depot%/*.user //%workspace%/*.user"
set view_mapping=%view_mapping% --field "View+=-//%depot%/*.bat //%workspace%/*.bat"
set view_mapping=%view_mapping% --field "View+=-//%depot%/*.txt //%workspace%/*.txt"

echo.
echo Setting up workspace...

p4 %view_mapping% --field "Root=%cd%" client -o %workspace% | p4 client -i
if ERRORLEVEL 1 (
	echo.
	echo Uh oh!!! Error when creating workspace. Did you enter depot '%depot%' correctly?
	echo.
	goto error
)

rem Setup build workspace
echo.
echo Setting up build workspace...

set build_workspace=%workspace%_BUILD
p4 --field "Options=allwrite" --field "Root=%cd%" --field "View=//%depot%/Binaries/... //%build_workspace%/Binaries/..." client -o %build_workspace% | p4 client -i
if ERRORLEVEL 1 (
	echo.
	echo Error when creating build workspace '%build_workspace%', uhhh ping Emil
	echo.
	goto error
)

echo %workspace%> WorkspaceName.txt

echo.
echo Done!
echo When working, use workspace '%workspace%' in P4V.
echo If the binaries are currently read-only, it might be because you got latest before running this script. You can just right click the folder and un-check 'Read Only'.
echo Whenever you want to push binaries (usually every time you push new source code), just run 'push_binaries.bat' AFTER you've compiled for Development Editor.
echo Or if you want to build and push in one step run 'build_and_push_binaries', this will delete the binaries folder, rebuild for development editor and then push binaries.
echo.

goto done

:done
:error
popd
pause