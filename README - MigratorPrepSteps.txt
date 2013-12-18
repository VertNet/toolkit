For a new migrator installation:

1) Make a copy of a template from the templates folder that most closely matches the one you are about to customize.
2) Open the template database and remove the linked table called "Source"
3) Make a linked table from the source data and call it "Source". For text files, use the UTF8 code page in advanced options.
4) Remove the SpecimensTemplate table.
5) Copy the structure (only) of the Source table to a new SpecimensTemplate table.
6) Open the SpecimensTemplate table in design view and add a primary key called ID with the Autonumber data type.
7) Remove the Specimens table.
8) Copy the SpecimensTemplate table to a table called Specimens.
9) Edit the query called "Append Source Data to Specimens" to import each needed field from the source.
10) Edit the contents of the LookupCollectionMetadata table to match the collection being migrated. Get institutionCode and collectionCode from 
11) Edit the query called "SimpleDwC-verbatim from Specimens" to turn Specimens into the first pass of verbatim data in SimpleDwC.
12) Edit the query called "LegacyData from Specimens" to populate LegacyData table with fields that don't fit directly into SimpleDwC-verbatim, such a DMS georeferences or maximumerrordistances with units.
13) Edit the query called "Prepend verbatim geography to verbatimLocality" to make verbatimLocality preserve all original geography.
14) Edit the query called "Update higherClassification with verbatim taxonomy" to make higherClassification preserve all original classification.
15) Edit the query called "Update Preparations for Tissues" to make preparations include tissue information.
16) Edit the query called "Update Month from Lookup" so that it maps the month field in Specimens to the Month field in LookupMonth. If there is no month field in Specimens, turn off the query "Update Month from Lookup" in the macro "Do DwC2 migration".
17) Edit the macro "Do DwC2 Migration" to set the names of the report output files to match the resource being processed. This is to distinguish reports from distinct resources. The TransferText commands for reports are among the last steps in the macro. Highlight the action and edit the File Name. For example, for a mammal resource, set the file name for duplicate catalog number to "C:\tempvertnetprocessing\reports\Report - Mammals - duplicate catalogNumber.csv"
18) Copy the latest Vocabulary databases (VertNetVocabularies.mdb and VertNetVocabulariesManager.mdb) from Dropbox\Vocabularies to .\source. Make sure there is no Vocabulary editing in progress elsewhere. If there is, wait for that to be done and get the copies from Dropbox afterwards.
19) Set the correct migrators to be run for the institution in the script "1a - RunMigrators.bat".
20) Set the correct migrators to be aggregated in the macro "Aggregate and Export" in templates\AggregatorTemple.mdb.
21) Test the migrator by running the appropriate collection-level script, such as "DwC2migration-Aves.bat".
22) Fix any errors that occur by editing the template database in the .\template folder (not the database made in the .\workspace folder by the RunMigrators script).
23) Iterate through steps 17 and 18 until no errors occur.
24) Check the results of the migration by looking at the data in the SimpleDwC table in the migrated database in the folder .\workspace.
25) Make any adjustments needed to populate the SimpleDwC table as completely as possible by editing queries and turning them on or off in the macro "Do DwC2 migration".
26) Run the collection-level script (e.g., "DwC2migration-Aves.bat") again.
27) Iterate through steps 20 through 22 until the data are complete.
28) Open the database .\source\VertNetVocabulariesManager.mdb and run the macro "Check Vocabularies". This will open windows showing new terms that haven't been resolved yet in the vocabulary manager. 
29) Edit the open vocabularies to map to standard versions of the terms. Some of these may be deferred, such as preparations and lifestage, which are incredibly diverse. Try especially to resolve Classifications and Geography (USA for sure).
30) When the vocabularies are checked to satisfaction, make sure they are saved in the MySQL archive by running the macro "Replace MySQL Vocabularies from Local Copy" to completion.
31) Run the script "1a - RunMigrators.bat" to make a copy of the SimpleDwC table with vocabulary lookups included.
32) Run the script "1b - RunAggregators.bat" to make a final migration data set, error reports, and data quality assessments.
33) Copy the error report files called "Report -*" in the source file to the appropriate Dropbox folder of the data publisher. Alert the publisher about these reports so they can improve their data at the source, if desired.
34) Look at the Data Quality reports "StatsCompleteness" and "StatsDifferences" to see if there is anything of concern.