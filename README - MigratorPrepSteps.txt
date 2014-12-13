For a new migrator installation:

1) Make a copy of the template database to DwC2ExtractTemplate-XXXX.mdb and rename it to match the scope of the data set for which the migrator will be made, where XXXX is "Aves", "Eggs", "Fish", "Fossils", "Herps", "Mammals", "Verts". If you use any other template name, you will have to modify the script "1a - RunMigrators.bat", add queries for the reports in the macro "Do DwC2 Migration" and the modify the database AggregatorTemplate.mdb to be able to process it.
2) Open the new template database and remove the linked table called "Occurrence".
3) Make a linked table from the source data and call it "Occurrence". For text files, use the UTF8 code page in advanced options.
4) Remove the SpecimensTemplate table.
5) Copy the structure (only) of the Occurrence table to a new SpecimensTemplate table.
6) Open the SpecimensTemplate table in design view and add a primary key called processingID with the Autonumber data type.
7) Remove the Specimens table.
8) Copy the SpecimensTemplate table to a table called Specimens.
9) Edit the contents of the LookupCollectionMetadata table to match the collection being migrated. Get institutionCode and collectionCode and the corresponding IDs from GRBio (http://grbio.org/).
10) Open the macro "Do DwC2 Migration". Turn on and off steps as appropriate and edit any queries that require customization. These are usually marked with an asterisk (*) in the comment field in the macro, though you should check them all unless you know well what their affects will be. These steps are listed below.
11) Edit the query "Source" to filter the table "Occurrence" if necessary.
12) Edit the query called "SimpleDwC-verbatim from Specimens" or the query "SimpleDwC-verbatim from Specimens - common" (uncommon fields removed to facilitate faster mapping) to turn Specimens into the first pass of verbatim data in SimpleDwC. This mapping should include only fields that can be mapped directly. Any other processing should occur once the data are in the SimpleDwC table later in the process. Check that the query is visible without errors in Datasheet view without running it (as that would attempt to append data to the Specimens table).
13) Edit and enable encumbrances if necessary.
14) Edit the query called "Prepend verbatim geography to verbatimLocality" to make verbatimLocality preserve all original higher geography whether in Darwin Core fields or not. Separate with " | " and go from least specific (continent) to most specific.
15) Edit the query called "Update higherClassification with verbatim taxonomy" to make higherClassification preserve all original classification. Separate with " | " and go from least specific (kingdom) to most specific (subgenus).
16) Edit and enable the queries called "LegacyXXX from Specimens" (where XXXX is "Coordinates", "CoordinateUncertainty", "Dates", "Depths", "Elevations", or "ScientificNames") to populate Legacy Data tables with fields that don't fit directly into SimpleDwC-verbatim or for fields that require special processing (multi-step or joins to other tables) to transform the original data into the recommended Darwin Core fields and formats.
17) Add, customize and enable queries for dynamicProperties if necessary. If any dynamicProperties are enabled, be sure to enable the query "*Update dynamicProperties to close". This puts the closing bracket ({) on the JSON content in the dynamicProperties field.
18) Edit and enable the query "Update Preparations for Tissues" to make preparations include tissue information if it does not already.
19) Enable the appropriate reports based on the scope of the resource (Aves, EggsNests, Fish, Fossils, Herps, Mammals, Verts). Check the following queries to be sure they are mapped correctly before proceeding:
"Report - missing catalogNumber"
{List here any others found}
20) Copy the latest Vocabulary databases (VertNetVocabularies.mdb and VertNetVocabulariesManager.mdb) from Dropbox\Vocabularies to .\source. Make sure there is no Vocabulary editing in progress elsewhere. If there is, wait for that to be done and get the copies from Dropbox afterwards.
21) Set the correct migrators to be run for the institution in the script "1a - RunMigrators.bat".
22) Set the correct migrators to be aggregated in the macro "Aggregate and Export" in templates\AggregatorTemple.mdb.
23) Test the migrator by running the appropriate collection-level script, such as "DwC2migration-Aves.bat".
24) Fix any errors that occur by editing the template database in the .\template folder (not the database made in the .\workspace folder by the RunMigrators script).
25) Iterate through steps 23 and 24 until no errors occur.
26) Check the results of the migration by looking at the data in the SimpleDwC table in the migrated database in the folder .\workspace.
27) Make any adjustments needed to populate the SimpleDwC table as completely as possible by editing queries and turning them on or off in the macro "Do DwC2 migration".
28) Run the collection-level script (e.g., "DwC2migration-Aves.bat") again.
29) Iterate through steps 26 through 28 until the data are complete.
30) Open the database .\source\VertNetVocabulariesManager.mdb and run the macro "Check Vocabularies". This will open windows showing new terms that haven't been resolved yet in the vocabulary manager. 
31) Edit the open vocabularies to map to standard versions of the terms. Some of these may be deferred, such as preparations and lifestage, which are incredibly diverse. Try especially to resolve Classifications and Geography (USA for sure).
32) Run the script "1a - RunMigrators.bat" to make a copy of the SimpleDwC table with vocabulary lookups included.
33) Run the script "1b - RunAggregators.bat" to make a final migration data set, error reports, and data quality assessments.
34) Compare the counts on output to SimpleDwCForVertNet.csv with the expecte number from the processed collection SimpleDwC tables. Resolve any discrepencies.
35) Copy the error report files called "Report -*" in the source file to the appropriate Dropbox folder of the data publisher. Alert the publisher about these reports so they can improve their data at the source, if desired.
36) Zip and the copy the SimpleDwCForVertNet.csv file to Dropbox for review by the data publisher.
37) Upload the file SimpleDwCForVertNet.zip to the resource on the IPT when it is authorized by the data publisher.