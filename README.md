# VertNet Darwin Core Data Migrator Toolkit


Scripts and databases to migrate source data to Darwin Core ready for publication via IPT.

A description of the steps required to be modified to create a migrator customized for a given data set is given in the file README - MigratorPrepSteps.txt.

The migrator uses Microsoft Access, and requires that the system on which it runs has unix shell command capability enabled in the environment on which the migrator DOS .BAT scripts are invoked.

- BlankLineIssues.awk - Script to report unexpected blank lines in a CSV file.
- NewLineIssues.awk - Script to report records having a new line in the field content in a CSV file.
- EncodingIssues.awk - Script to report records having UTF8 encoding issues.
- PurgeNonprintingCharacters.sh - Script to substitute '.' for non-printing characters in data content.
- PurgeNuls.sh - Script to remove the NUL characters in a file encoded as utf16 to render utf8.
- PurgeVerticalTabs.sh - Script to remove all vertical tab characters from a file.
- RemoveLastLine.sh - Script to remove the final line in a file.
- utf8er.awk - Script to prepend Byte Order Marker (0xEF 0xBB 0xBF) to CSV file known to be utf8-encoded.
