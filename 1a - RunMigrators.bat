REM DESCRIPTION: 
REM This script migrates data from multiple original sources 
REM into corresponding Access databases that can be used as the source for
REM a DiGIR provider resource as well as for producing a Simple Darwin Core
REM CSV file.

REM ASSUMPTIONS: 
REM This script assumes that the it will be run to completion 
REM in the directory in which the individually CALLed scripts reside.
REM
REM This script assumes that the assumptions in all of its called scripts have 
REM been met.

REM Run the migrators.
REM CALL DwC2migration.bat Audio
REM CALL DwC2migration.bat Aves
REM CALL DwC2migration.bat Eggs
REM CALL DwC2migration.bat Ent
REM CALL DwC2migration.bat Fish
REM CALL DwC2migration.bat Fossils
REM CALL DwC2migration.bat Fungi
REM CALL DwC2migration.bat Herps
REM CALL DwC2migration.bat Inverts
REM CALL DwC2migration.bat Mammals
REM CALL DwC2migration.bat Plants
CALL DwC2migration.bat Verts