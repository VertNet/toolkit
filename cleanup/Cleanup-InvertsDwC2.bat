REM DESCRIPTION: 
REM This removes tables that are only used in processing, to minimize the 
REM size of the remaining database by compacting it.

REM ASSUMPTIONS: 
REM This script assumes the directory structure:
REM    .\ (where this script is located)
REM    .\workspace (where previous migration databases are located)
REM
REM NOTE: 
REM Make sure the paths in this script point correctly to the 
REM location of the Microsoft Access application.

REM This script assumes one of the following locations for Microsoft Office. 
REM Change the value of accessexe if it is not in one of these locations.
set accessexe="C:\Program Files\Microsoft Office\OFFICE11\MSACCESS.EXE"
if exist %accessexe% goto accessfound
set accessexe="C:\Program Files (x86)\Microsoft Office\OFFICE11\MSACCESS.EXE"
if exist %accessexe% goto accessfound
set accessexe="C:\Program Files\Microsoft Office\Office14\MSACCESS.exe"
if exist %accessexe% goto accessfound
set accessexe="C:\Program Files (x86)\Microsoft Office\Office14\MSACCESS.exe"
if exist %accessexe% goto accessfound
set accessexe="C:\Program Files\Microsoft Office\Office15\MSACCESS.exe"
if not exist %accessexe% goto end
:accessfound

REM Run the "Cleanup Unneeded Tables" macro to remove tables from the processed database.
%accessexe% %CD%\workspace\InvertsDwC2.mdb /x "Cleanup Unneeded Tables"

REM Compact the database to reduce its size.
%accessexe% %CD%\workspace\InvertsDwC2.mdb /compact

:end