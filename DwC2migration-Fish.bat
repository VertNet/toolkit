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
if exist %accessexe% goto accessfound
set accessexe="C:\Program Files (x86)\Microsoft Office\root\Office16\MSACCESS.exe"
if not exist %accessexe% goto end
:accessfound

REM Make a copy of the current data source to the previous migration backup folder.
del bkp\FishDwC2.mdb
copy workspace\FishDwC2.mdb bkp\FishDwC2.mdb

REM Make an access database in which to process the current data migration.
copy templates\DwC2Extracttemplate-Fish.mdb workspace\tempFish.mdb

REM Run the "Do DwC2 Migration" macro to build the new data source and update the DateLastModified.
%accessexe% %CD%\workspace\tempFish.mdb /x "Do DwC2 Migration"

REM Remove the previous processed access database.
REM The script sometimes can't make this step if the Access Locking file exists. 
REM Need to find a way to force that to close.
del workspace\FishDwC2.mdb

REM move the new data source into the root data provider folder.
move workspace\tempFish.mdb workspace\FishDwC2.mdb

move "reports\Report - indeterminate Geography.txt"              "reports\Report - Fish - indeterminate Geography.txt"
move "reports\Report - coordinatePrecision not numeric.txt"      "reports\Report - Fish - coordinatePrecision not numeric.txt"
move "reports\Report - coordinatePrecision out of Range.txt"     "reports\Report - Fish - coordinatePrecision out of Range.txt"
move "reports\Report - coordinateUncertainties not numeric.txt"  "reports\Report - Fish - coordinateUncertainties not numeric.txt"
move "reports\Report - coordinateUncertainties out of range.txt" "reports\Report - Fish - coordinateUncertainties out of range.txt"
move "reports\Report - Day out of range.txt"                     "reports\Report - Fish - Day out of range.txt"
move "reports\Report - decimalLatLong both 0.txt"                "reports\Report - Fish - decimalLatLong both 0.txt"
move "reports\Report - decimalLatLong not numeric.txt"           "reports\Report - Fish - decimalLatLong not numeric.txt"
move "reports\Report - decimalLatLong out of range.txt"          "reports\Report - Fish - decimalLatLong out of range.txt"
move "reports\Report - duplicate occurrenceIDs.txt"              "reports\Report - Fish - duplicate occurrenceIDs.txt"
move "reports\Report - duplicate catalogNumber.txt"              "reports\Report - Fish - duplicate catalogNumber.txt"
move "reports\Report - individualCount out of range.txt"         "reports\Report - Fish - individualCount out of range.txt"
move "reports\Report - missing catalogNumber.csv"                "reports\Report - Fish - missing catalogNumber.csv"
move "reports\Report - missing coordinate.txt"                   "reports\Report - Fish - missing coordinate.txt"
move "reports\Report - Month out of range.txt"                   "reports\Report - Fish - Month out of range.txt"
move "reports\Report - non-standard Continent.txt"               "reports\Report - Fish - non-standard Continent.txt"
move "reports\Report - non-standard Country.txt"                 "reports\Report - Fish - non-standard Country.txt"
move "reports\Report - non-standard County.txt"                  "reports\Report - Fish - non-standard County.txt"
move "reports\Report - non-standard Family.txt"                  "reports\Report - Fish - non-standard Family.txt"
move "reports\Report - non-standard Genus.txt"                   "reports\Report - Fish - non-standard Genus.txt"
move "reports\Report - non-standard Island.txt"                  "reports\Report - Fish - non-standard Island.txt"
move "reports\Report - non-standard IslandGroup.txt"             "reports\Report - Fish - non-standard IslandGroup.txt"
move "reports\Report - non-standard Municipality.txt"            "reports\Report - Fish - non-standard Municipality.txt"
move "reports\Report - non-standard Order.txt"                   "reports\Report - Fish - non-standard Order.txt"
move "reports\Report - non-standard StateProvince.txt"           "reports\Report - Fish - non-standard StateProvince.txt"
move "reports\Report - non-standard WaterBody.txt"               "reports\Report - Fish - non-standard WaterBody.txt"
move "reports\Report - not higherGeography.txt"                  "reports\Report - Fish - not higherGeography.txt"
move "reports\Report - Year out of range.txt"                    "reports\Report - Fish - Year out of range.txt"

:end