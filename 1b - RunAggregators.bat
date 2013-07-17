REM DESCRIPTION: 
REM This script aggregates data from multiple SimpleDwC tables to a 
REM single Simple Darwin Core CSV file.

REM ASSUMPTIONS: 
REM This script assumes that the SimpleDwC tables have already been 
REM created and linked properly in the local version of the 
REM AggregatorTemplate.mdb database.
REM
REM This script assumes the directory structure:
REM    .\ (where this script is located)
REM    .\templates (where the Access database templates are located)
REM    .\workspace (where previous migration databases are located)
REM    .\ForIPT (where the aggregated CSV file for IPT is located)
REM
REM This script assumes the executability of gawk to run error tests on
REM the resulting CSV file.
REM
REM This script assumes the executability of gzip to archive the resulting 
REM CSV file.

REM NOTE: 
REM Make sure the paths in this script point correctly to the location 
REM of the Microsoft Access application.
REM
REM Make sure the destination of the output CSV file is correct in the 
REM TransferText action of the "Export SimpleDwC" macro in the 
REM AggregatorTemplate.mdb database.

REM This script assumes one of two locations for Microsoft Office. Chance the value
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
copy templates\AggregatorTemplate.mdb workspace\Aggregator.mdb

REM Run the "Export SimpleDwC" macro to create a new aggregated Simple Darwin Core CSV file for IPT.
REM Makes a single UTF8-encoded CSV file for the combined data sources created in the RunMigrators
REM script.
REM Also optionally makes a DwC2 table conforming to Darwin Core 1.21 (MaNIS/HerpNet/ORNIS).
REM "C:\Program Files\Microsoft Office\OFFICE11\MSACCESS.EXE" %CD%\workspace\Aggregator.mdb /x "Aggregate and Export"
%accessexe% %CD%\workspace\Aggregator.mdb /x "Aggregate and Export"

REM Remove previous outputs from the folder
del ForIPT\SimpleDwCForVertNet.zip
del ForIPT\SimpleDwCForVertNet.csv.gz
del ForIPT\SimpleDwCForVertNet.zip

REM Run script to prepend UTF8 Byte Order Marker bytes.
gawk -f utf8er.awk ForIPT\SimpleDwCForVertNet.csv>ForIPT\testout.csv
del ForIPT\SimpleDwCForVertNet.csv
del ForIPT\SimpleDwCForVertNetPrepurge.csv
move ForIPT\testout.csv ForIPT\SimpleDwCForVertNetPrepurge.csv

REM Run scripts to report potential errors in the output file.
gawk -f EncodingIssues.awk ForIPT\SimpleDwCForVertNetPrepurge.csv>ForIPT\EncodingIssues.txt
gawk -f NewLineIssues.awk ForIPT\SimpleDwCForVertNetPrepurge.csv>ForIPT\NewLineIssues.txt
gawk -f BlankLineIssues.awk ForIPT\SimpleDwCForVertNetPrepurge.csv>ForIPT\BlankLineIssues.txt

REM Run script to remove non-printing control characters \r \n \f \v \t in data fields.
REM Note that large files may cause out of memory errors resulting in an empty SimpleDwCForVertNet.csv file.
REM split the file into parts of 100000 lines or less each and purge them separately.
REM Set to split on 100M records by default so that this only has to be edited if a memory error is encountered.
split -l 100000000 ForIPT\SimpleDwCForVertNetPrePurge.csv ForIPT\part
sh PurgeNonprintingCharacters.sh ForIPT\partaa
REM sh PurgeNonprintingCharacters.sh ForIPT\partab
REM sh PurgeNonprintingCharacters.sh ForIPT\partac
cd ForIPT
REM cat partaa partab partac > SimpleDwCForVertNet.csv
cat partaa > SimpleDwCForVertNet.csv
rm parta*
diff SimpleDwCForVertNetPrepurge.csv SimpleDwCForVertNet.csv > purge_diffs.txt
cd ..
copy ForIPT\purge_diffs.txt reports\Report-LinesWithNonprintingCharacters.txt
REM copy ForIPT\simpledwcforvertnetprepurge.csv ForIPT\SimpleDwCForVertNet.csv
REM sh PurgeNonprintingCharacters.sh ForIPT\SimpleDwCForVertNet.csv

REM Run NewLine reporting script again after purging new lines and carriage returns in data
gawk -f NewLineIssues.awk ForIPT\SimpleDwCForVertNet.csv>ForIPT\NewLineIssuesAfterCRLFRemoval.txt

REM Now import the purged results to Access again and make the DwC2 table for DiGIR.
REM For source data having no nonprinting characters, it is not necessary to import again
REM as this should  be done in the macro 'Aggregate and Export' before exporting.
REM "C:\Program Files\Microsoft Office\OFFICE11\MSACCESS.EXE" %CD%\ForDiGIR\Aggregator.mdb /x "Import and Make DwC2"
%accessexe% %CD%\workspace\Aggregator.mdb /x "Import and Make DwC2"

REM Put the resulting database in place of the previous version of it.
del ForDiGIR\VertebratesDwC2ForDiGIR.mdb
move workspace\Aggregator.mdb ForDiGIR\VertebratesDwC2ForDiGIR.mdb

REM Archive the resulting SimpleDwCForVertNet file with gzip.
REM cd ForIPT
REM gzip SimpleDwCForVertNet.csv
REM cd ..

:end