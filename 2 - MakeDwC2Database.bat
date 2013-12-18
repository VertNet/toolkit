REM DESCRIPTION: 
REM This script uses a Simple Darein Core source file and produces an 
REM Access Database for a DiGIR provider using DwC2 table conforming to 
REM Darwin Core 1.21 (MaNIS/HerpNet/ORNIS).

REM ASSUMPTIONS: 
REM This script assumes that the SimpleDwC file has already been 
REM created and linked properly as ProcessedSimpleDwCForVertNet in the 
REM local version of the DwC2MakerTemplate.mdb database.
REM
REM This script assumes the directory structure:
REM    .\ (where this script is located)
REM    .\templates (where the Access database templates are located)
REM    .\workspace (where the work actually happens when this script is run)
REM    .\ForIPT (where the SimpleDwCForVertNet.csv file for IPT is located)

REM NOTE: 
REM Make sure the paths in this script point correctly to the location 
REM of the Microsoft Access application.
REM

REM This script checks possible locations for Microsoft Office. Change the value
REM of accessexe if it is not in one of these locations.
set accessexe="C:\Program Files\Microsoft Office\OFFICE11\MSACCESS.EXE"
if exist %accessexe% goto accessfound
set accessexe="C:\Program Files (x86)\Microsoft Office\OFFICE11\MSACCESS.EXE"
if exist %accessexe% goto accessfound
set accessexe="C:\Program Files\Microsoft Office\Office14\MSACCESS.exe"
if exist %accessexe% goto accessfound
set accessexe="C:\Program Files (x86)\Microsoft Office\Office14\MSACCESS.exe"
if not exist %accessexe% goto end
:accessfound

REM Make a copy of the Aggregator.
copy templates\DwC2MakerTemplate.mdb workspace\DwC2Maker.mdb

REM Import a clean (no non-printing characters) Simple Darwin Core file and make the DwC2 
REM table for DiGIR.
%accessexe% %CD%\workspace\DwC2Maker.mdb /x "Import and Make DwC2"

REM Put the resulting database in place of the previous version of it.
del ForDiGIR\VertebratesDwC2ForDiGIR.mdb
move workspace\DwC2Maker.mdb ForDiGIR\VertebratesDwC2ForDiGIR.mdb

:end