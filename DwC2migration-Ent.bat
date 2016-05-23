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
if not exist %accessexe% goto end
:accessfound

REM Make a copy of the current data source to the previous migration backup folder.
del bkp\EntDwC2.mdb
copy workspace\EntDwC2.mdb bkp\EntDwC2.mdb

REM Make an access database in which to process the current data migration.
copy templates\DwC2Extracttemplate-Ent.mdb workspace\tempEnt.mdb

REM Run the "Do DwC2 Migration" macro to build the new data source and update the DateLastModified.
REM "C:\Program Files\Microsoft Office\OFFICE11\MSACCESS.EXE" %CD%\workspace\tempEnt.mdb /x "Do DwC2 Migration"
%accessexe% %CD%\workspace\tempEnt.mdb /x "Do DwC2 Migration"

REM Remove the previous processed access database.
REM The script sometimes can't make this step if the Access Locking file exists. 
REM Need to find a way to force that to close.
del workspace\EntDwC2.mdb

REM move the new data source into the root data provider folder.
move workspace\tempEnt.mdb workspace\EntDwC2.mdb

move "reports\Report - indeterminate Geography.txt"              "reports\Report - Ent - indeterminate Geography.txt"
move "reports\Report - coordinatePrecision not numeric.txt"      "reports\Report - Ent - coordinatePrecision not numeric.txt"
move "reports\Report - coordinatePrecision out of Range.txt"     "reports\Report - Ent - coordinatePrecision out of Range.txt"
move "reports\Report - coordinateUncertainties not numeric.txt"  "reports\Report - Ent - coordinateUncertainties not numeric.txt"
move "reports\Report - coordinateUncertainties out of range.txt" "reports\Report - Ent - coordinateUncertainties out of range.txt"
move "reports\Report - Day out of range.txt"                     "reports\Report - Ent - Day out of range.txt"
move "reports\Report - decimalLatLong both 0.txt"                "reports\Report - Ent - decimalLatLong both 0.txt"
move "reports\Report - decimalLatLong not numeric.txt"           "reports\Report - Ent - decimalLatLong not numeric.txt"
move "reports\Report - decimalLatLong out of range.txt"          "reports\Report - Ent - decimalLatLong out of range.txt"
move "reports\Report - duplicate occurrenceIDs.txt"              "reports\Report - Ent - duplicate occurrenceIDs.txt"
move "reports\Report - duplicate catalogNumber.txt"              "reports\Report - Ent - duplicate catalogNumber.txt"
move "reports\Report - individualCount out of range.txt"         "reports\Report - Ent - individualCount out of range.txt"
move "reports\Report - missing catalogNumber.csv"                "reports\Report - Ent - missing catalogNumber.csv"
move "reports\Report - missing coordinate.txt"                   "reports\Report - Ent - missing coordinate.txt"
move "reports\Report - Month out of range.txt"                   "reports\Report - Ent - Month out of range.txt"
move "reports\Report - non-standard Continent.txt"               "reports\Report - Ent - non-standard Continent.txt"
move "reports\Report - non-standard Country.txt"                 "reports\Report - Ent - non-standard Country.txt"
move "reports\Report - non-standard County.txt"                  "reports\Report - Ent - non-standard County.txt"
move "reports\Report - non-standard Family.txt"                  "reports\Report - Ent - non-standard Family.txt"
move "reports\Report - non-standard Genus.txt"                   "reports\Report - Ent - non-standard Genus.txt"
move "reports\Report - non-standard Island.txt"                  "reports\Report - Ent - non-standard Island.txt"
move "reports\Report - non-standard IslandGroup.txt"             "reports\Report - Ent - non-standard IslandGroup.txt"
move "reports\Report - non-standard Municipality.txt"            "reports\Report - Ent - non-standard Municipality.txt"
move "reports\Report - non-standard Order.txt"                   "reports\Report - Ent - non-standard Order.txt"
move "reports\Report - non-standard StateProvince.txt"           "reports\Report - Ent - non-standard StateProvince.txt"
move "reports\Report - non-standard WaterBody.txt"               "reports\Report - Ent - non-standard WaterBody.txt"
move "reports\Report - not higherGeography.txt"                  "reports\Report - Ent - not higherGeography.txt"
move "reports\Report - Year out of range.txt"                    "reports\Report - Ent - Year out of range.txt"

:end