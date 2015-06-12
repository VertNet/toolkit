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
REM CALL DwC2migration-Audio.bat
REM CALL DwC2migration-Aves.bat
REM CALL DwC2migration-Eggs.bat
REM CALL DwC2migration-Ent.bat
REM CALL DwC2migration-Fish.bat
REM CALL DwC2migration-Fossils.bat
REM CALL DwC2migration-Fungi.bat
REM CALL DwC2migration-Herps.bat
REM CALL DwC2migration-Mammals.bat
CALL DwC2migration-Verts.bat