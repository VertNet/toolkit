REM DESCRIPTION: 
REM This script migrates data from an original source 
REM into an Access database with a table that can be used as the source
REM for a DiGIR provider resource. It also extracts a Simple Darwin 
REM Core table version from the original source using collection-specific
REM metadata in the CollectionMetadata table of the Extractor template
REM database, which should be updated for the current collection prior
REM to running this script.

REM ASSUMPTIONS: 
REM This script assumes that a DwC2 table representing a previous 
REM migration has already been created and linked properly in the
REM DwC2 template databases.
REM
REM This script assumes the directory structure:
REM    .\ (where this script is located)
REM    .\bkp (where the previously created migration database gets saved)
REM    .\templates (where the Access database templates are located)
REM    .\workspace (where previous migration databases are located)
REM
REM NOTE: 
REM Make sure the paths in this script point correctly to the 
REM location of the Microsoft Access application.
REM
REM The Access databases created by this process replace the ones
REM created in a previous run.

REM This script assumes one of The following locations for Microsoft Office. 
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

REM Make a copy of the current data source to the previous migration backup folder.
del bkp\FossilsDwC2.mdb
copy workspace\FossilsDwC2.mdb bkp\FossilsDwC2.mdb

REM Make an access database in which to process the current data migration.
copy templates\DwC2Extracttemplate-Fossils.mdb workspace\tempFossils.mdb

REM Run the "Do DwC2 Migration" macro to build the new data source and update the DateLastModified.
%accessexe% %CD%\workspace\tempFossils.mdb /x "Do DwC2 Migration"

REM Remove the previous processed access database.
REM The script sometimes can't make this step if the Access Locking file exists. 
REM Need to find a way to force that to close.
del workspace\FossilsDwC2.mdb

REM move the new data source into the root data provider folder.
move workspace\tempFossils.mdb workspace\FossilsDwC2.mdb

move "reports\Report - indeterminate Geography.csv"              "reports\Report - Fossils - indeterminate Geography.csv"
move "reports\Report - coordinatePrecision not numeric.csv"      "reports\Report - Fossils - coordinatePrecision not numeric.csv"
move "reports\Report - coordinatePrecision out of Range.csv"     "reports\Report - Fossils - coordinatePrecision out of Range.csv"
move "reports\Report - coordinateUncertainties not numeric.csv"  "reports\Report - Fossils - coordinateUncertainties not numeric.csv"
move "reports\Report - coordinateUncertainties out of range.csv" "reports\Report - Fossils - coordinateUncertainties out of range.csv"
move "reports\Report - Day out of range.csv"                     "reports\Report - Fossils - Day out of range.csv"
move "reports\Report - decimalLatLong both 0.csv"                "reports\Report - Fossils - decimalLatLong both 0.csv"
move "reports\Report - decimalLatLong not numeric.csv"           "reports\Report - Fossils - decimalLatLong not numeric.csv"
move "reports\Report - decimalLatLong out of range.csv"          "reports\Report - Fossils - decimalLatLong out of range.csv"
move "reports\Report - duplicate catalogNumber.csv"              "reports\Report - Fossils - duplicate catalogNumber.csv"
move "reports\Report - missing catalogNumber.csv"                "reports\Report - Fossils - missing catalogNumber.csv"
move "reports\Report - missing coordinate.csv"                   "reports\Report - Fossils - missing coordinate.csv"
move "reports\Report - Month out of range.csv"                   "reports\Report - Fossils - Month out of range.csv"
move "reports\Report - non-standard Continent.csv"               "reports\Report - Fossils - non-standard Continent.csv"
move "reports\Report - non-standard Country.csv"                 "reports\Report - Fossils - non-standard Country.csv"
move "reports\Report - non-standard County.csv"                  "reports\Report - Fossils - non-standard County.csv"
move "reports\Report - non-standard Family.csv"                  "reports\Report - Fossils - non-standard Family.csv"
move "reports\Report - non-standard Genus.csv"                   "reports\Report - Fossils - non-standard Genus.csv"
move "reports\Report - non-standard Island.csv"                  "reports\Report - Fossils - non-standard Island.csv"
move "reports\Report - non-standard IslandGroup.csv"             "reports\Report - Fossils - non-standard IslandGroup.csv"
move "reports\Report - non-standard Municipality.csv"            "reports\Report - Fossils - non-standard Municipality.csv"
move "reports\Report - non-standard Order.csv"                   "reports\Report - Fossils - non-standard Order.csv"
move "reports\Report - non-standard StateProvince.csv"           "reports\Report - Fossils - non-standard StateProvince.csv"
move "reports\Report - non-standard WaterBody.csv"               "reports\Report - Fossils - non-standard WaterBody.csv"
move "reports\Report - not higherGeography.csv"                  "reports\Report - Fossils - not higherGeography.csv"
move "reports\Report - Year out of range.csv"                    "reports\Report - Fossils - Year out of range.csv"

:end