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
REM CALL Cleanup-AvesDwC2.bat
REM CALL Cleanup-EggsDwC2.bat
REM CALL Cleanup-FishDwC2.bat
REM CALL Cleanup-FossilsDwC2.bat
REM CALL Cleanup-HerpsDwC2.bat
REM CALL Cleanup-MammalsDwC2.bat
CALL Cleanup-VertsDwC2.bat