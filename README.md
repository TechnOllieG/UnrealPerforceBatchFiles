# UnrealPerforceBatchFiles
Bat files to setup workspace in p4 for unreal and to push binaries and a script for first building binaries and then pushing.

Run the setup_p4.bat to setup your workspace. Then if you work with code in unreal and need to build and push binaries put the rest of the files in your workspace root.
Make sure to edit your UnrealBuildBatchPath.txt with the path to your specific build.bat file for the specific version of unreal engine you are using for this project.
Run build_and_push_binaries.bat to first delete the binaries folder, build the project for development editor and then push binaries.
Run push_binaries.bat if you have already built the correct binaries and just want to push them.
