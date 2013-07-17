REM DESCRIPTION: 
REM This script does a full migration to prepare data for publishing.
REM To prepare a migrator for the first time, do the following steps:
REM   1) Make a copy of the migrator processing directory and all of
REM      its contents into a new directory at the location
REM      c:\tempvertnetprocessing. It is important to configure the 
REM      migrator databases in this location so that the linked tables
REM      are set up as they will be during processing. The migrator 
REM      can be made to run in any location, but the hardcoded path
REM      for the Simple Darwin Core CSV file will have to be set in 
REM      TransferText action of the "Export SimpleDwC" macro in the 
REM      .\templates\AggregatorTemplate.mdb database and the temporary
REM      processing directory will have to be changed in this script.
REM      By default this scripts creates a temporary working directory
REM      at c:\tempvertnetprocessing, does the processing there, then
REM      copies the results back into the appropriate directories based 
REM      on the directory from which this script is called.
REM   2) Put the source data files into the .\source subdirectory.
REM   3) Configure the .\templates\DwC2ExtractTemplates databases for 
REM      all collections that have data in .\sources. This
REM      configuration includes linking to the sources, updating the
REM      mapping in the PreDwC2prepration Query, creating or updating
REM      queries to do collection-specific processing (field or record 
REM      encumbrances, measurements, coordinates, collectors, etc.), 
REM      enabling and disabling actions as appropriate in the 
REM      "Do DwC2 migration" macro, and updating the lookup tables that 
REM      have names beginning with "Lookup".
REM   4) Test that the .\templates\DwC2ExtractTemplates produce expected 
REM      output by running the .\RunMigrators.bat script and looking at 
REM      the resulting records in the DwC2 and SimpleDwC tables in the 
REM      resulting databases in the .\workspace subdirectory.
REM   5) Close all files and move the entire tempvertnetprocessing 
REM      directory to an archival location from which this script can be 
REM      executed. For example, to C:\VertNet\[InstCode]\processing, where 
REM      [InstCode] is replaced by the institution code for source data.
REM   6) Run this script from its archival location to test that it 
REM      functions completely and correctly. There should be no errors 
REM      while running this script, and the results in the .\ForDiGIR and 
REM      .\ForIPT subdirectories should be checked for expected content. 
REM      If any errors occur, move the entire folder to 
REM      c:\tempvertnetprocessing (or other temporary execution location
REM      is so configured) again and return to step 3. Repeat this 
REM      development cycle until this script runs correctly to completion 
REM      with the desired publishing results.
REM   7) Check the data error reports in the ForIPT folder to see if there
REM      were any new line characters or incorrect UTF8 encoded characters
REM      in the data that would cause problems with downstream data 
REM      publishing. Correct these data at the source and rerun the scripts
REM      before publishing.
REM   8) (Optional) Create, enable, and test a ScheduledTask to run the 
REM      FullDataPrepration.bat script from its archival location. 

REM ASSUMPTIONS: 
REM This script assumes the directory structure:
REM    . (where this script is located and all of those it calls are located)
REM    .\bkp (where the previously created migration database will be saved)
REM    .\ForDiGIR (where the aggregated Access database for DiGIR will be located)
REM    .\ForIPT (where the aggregated CSV file for IPT will be located)
REM    .\source (where the original data to be processed are located)
REM    .\templates (where the Access database templates are located)
REM    .\workspace (where previous migration databases are located)
REM
REM This script assumes that the assumptions noted in all of its called scripts have 
REM been met.
REM
REM The SimpleDwCAggregationForIPT.bat script CALLed by this script uses an
REM Access database to do the aggregation for the Simple Darwin Core CSV file.
REM Hardcoded into the TransferText action of the macro called "Export SimpleDwC" 
REM in that database is a path to the output destination for the file, which by
REM default is C:\vertnetprocessing\ForIPT\SimpleDwCForVertNet.csv. If the 
REM temporary processing directory set in the %processingdir% variable below is 
REM changed below in this script, then the TransferText output path must be 
REM changed in .\templates\AggregatorTemplate.mdb to match it.
REM
REM This script assumes that when it is run, the appropriate conditions are 
REM in place to create a directory in the location given in the following set
REM command:
set processingdir=C:\tempvertnetprocessing
set sourcedir=%CD%

REM If the processing directory is not the same as the source directory, then
REM make a directory within which to do the processing and move the entire contents
REM of the current directory there. Change into that directory to begin processing.
REM Results will be copied back to the sourcedir directory structure when processing
REM is finished.
if not %processingdir%==%sourcedir% (
	mkdir %processingdir%
	xcopy * %processingdir% /E /Y
	cd %processingdir%
)

REM Run the migrators for distinct collections or datasets.
CALL "1a - RunMigrators.bat"

REM Aggregate data sources for publishing. 
CALL "1b - RunAggregators.bat"

REM If the source and processing directories are the same, do not copy back the results
REM and do not remove the processing directory and go directly to the finish line.
if not %processingdir%==%sourcedir% (

	REM Copy the results of processing back into the archival directory from which
	REM this script was run.
	xcopy bkp\*.* %sourcedir%\bkp /E /Y
	xcopy ForDiGIR\*.* %sourcedir%\ForDiGIR /E /Y
	xcopy ForIPT\*.* %sourcedir%\ForIPT /E /Y
	xcopy reports\*.* %sourcedir%\reports /E /Y
	xcopy source\*.* %sourcedir%\source /E /Y
	xcopy workspace\*.* %sourcedir%\workspace /E /Y

	REM Change current directory back to the archival directory.
	cd %sourcedir%

	REM Remove the temporary processing directory
	rd /S /Q %processingdir%
)