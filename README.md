# 3D Printing Slicer Selector for Windows
Provides a native Windows Dialog to select the slicer if you have multiple installed.

The supported slicers are:
* Bambu Studio
* Prusa Slicer
* Creality Print
* Snapmaker Orca
* Orca Slicer

# Step 1 - Download
Save the exe or alternativly download the ps1.
To compile the ps1 to an exe use the following cmdlet: Invoke-PS2EXE .\slicer-selector.ps1 .\slicer-selector.exe -iconFile .\slicer-selector.ico -noConsole 

# Step 2 - Set as Default
1) Open the "Default Apps" settings utility in Windows
2) Search for the extensions you would like to associate this with, common extensions are .3mf and .stl
3) Click on the extension and a dialog box should popup, select "Choose an app on this PC"
4) Find the executable you just downloaded or compiled and select it

# Step 3 - Enjoy!
Double click a .3mf or .stl and you should be prompted to use any of the installed slicers.
