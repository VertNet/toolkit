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
REM TransferText action of the "Aggregate and Export" macro in the 
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
if exist %accessexe% goto accessfound
set accessexe="C:\Program Files\Microsoft Office\Office15\MSACCESS.exe"
if exist %accessexe% goto accessfound
set accessexe="C:\Program Files\Microsoft Office\Office16\MSACCESS.exe"
if exist %accessexe% goto accessfound
set accessexe="C:\Program Files (x86)\Microsoft Office\root\Office16\MSACCESS.exe"
if not exist %accessexe% goto end
set accessexe="C:\Archivos de programa\Microsoft Office\Office16\MSACCESS.exe"
if not exist %accessexe% goto end
set accessexe="C:\Archivos de programa (x86)\Microsoft Office\Office16\MSACCESS.exe"
if not exist %accessexe% goto end
:accessfound

REM Make a copy of the Aggregator.
copy templates\AggregatorTemplate.mdb workspace\Aggregator.mdb

REM Run the "Aggregate and Export" macro to create a new aggregated Simple Darwin Core CSV file for IPT.
REM Makes a single UTF8-encoded CSV file for the combined data sources created in the RunMigrators
REM script.
%accessexe% %CD%\workspace\Aggregator.mdb /x "Aggregate and Export"

REM Remove previous outputs from the folder
del ForIPT\SimpleDwCForIPT.zip
del ForIPT\SimpleDwCForIPT.csv.gz
del ForIPT\SimpleDwCForIPT.zip

REM Run script to prepend UTF8 Byte Order Marker bytes.
REM The resulting file has rows ending only in LF, with a final row of only a LF.
gawk -f utf8er.awk ForIPT\SimpleDwCForIPT.csv>ForIPT\testout.csv
del ForIPT\SimpleDwCForIPT.csv
del ForIPT\SimpleDwCForIPTPrepurge.csv
move ForIPT\testout.csv ForIPT\SimpleDwCForIPTPrepurge.csv

REM Run scripts to report potential errors in the output file.
gawk -f EncodingIssues.awk ForIPT\SimpleDwCForIPTPrepurge.csv>ForIPT\EncodingIssues.txt
gawk -f NewLineIssues.awk ForIPT\SimpleDwCForIPTPrepurge.csv>ForIPT\NewLineIssues.txt
gawk -f BlankLineIssues.awk ForIPT\SimpleDwCForIPTPrepurge.csv>ForIPT\BlankLineIssues.txt

REM Run script to remove non-printing control characters \r \n \f \v \t in data fields.
REM Note that large files may cause out of memory errors resulting in an empty SimpleDwCForIPT.csv 
REM file. Hence, split the file into parts of 50000 lines or less each and purge them separately.
REM Make sure that the there are sufficient calls to PurgeNonprintingCharacters.sh to process the 
REM original SimpleDwCForIPTPrePurge.csv file.
split -l 50000 ForIPT\SimpleDwCForIPTPrePurge.csv ForIPT\part
REM At this point the part files each have 50000 rows or less with LF ending each row and LF only in the last row.
REM Now, for each of the split files, remove non-printing characters and spaces leading up to a double quote.
sh PurgeNonprintingCharacters.sh ForIPT\partaa
sh PurgeNonprintingCharacters.sh ForIPT\partab
REM >100000 records
sh PurgeNonprintingCharacters.sh ForIPT\partac
sh PurgeNonprintingCharacters.sh ForIPT\partad
REM >200000 records
sh PurgeNonprintingCharacters.sh ForIPT\partae
sh PurgeNonprintingCharacters.sh ForIPT\partaf
REM >300000 records
sh PurgeNonprintingCharacters.sh ForIPT\partag
sh PurgeNonprintingCharacters.sh ForIPT\partah
REM >400000 records
sh PurgeNonprintingCharacters.sh ForIPT\partai
sh PurgeNonprintingCharacters.sh ForIPT\partaj
REM >500000 records
sh PurgeNonprintingCharacters.sh ForIPT\partak
sh PurgeNonprintingCharacters.sh ForIPT\partal
REM <=600000 records
cd ForIPT
cat partaa partab partac partad partae partaf partag partah partai partaj partak partal > SimpleDwCForIPT.csv
REM cat partaa > SimpleDwCForIPT.csv
rm parta*
REM diff SimpleDwCForIPTPrepurge.csv SimpleDwCForIPT.csv > purge_diffs.txt
cd ..
REM copy ForIPT\purge_diffs.txt reports\Report-LinesWithNonprintingCharacters.txt
REM copy ForIPT\SimpleDwCForIPTprepurge.csv ForIPT\SimpleDwCForIPT.csv
REM sh PurgeNonprintingCharacters.sh ForIPT\SimpleDwCForIPT.csv

REM Run NewLine reporting script again after purging new lines and carriage returns in data
gawk -f NewLineIssues.awk ForIPT\SimpleDwCForIPT.csv>ForIPT\NewLineIssuesAfterCRLFRemoval.txt

REM Remove the working copy of the Aggregator
REM mv workspace\Aggregator.mdb bkp\Aggregator.mdb

REM Archive the resulting SimpleDwCForIPT file with gzip.
REM cd ForIPT
REM gzip SimpleDwCForIPT.csv
REM cd ..

:end