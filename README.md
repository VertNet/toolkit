# VertNet Darwin Core Data Migrator


Scripts and databases to migrate source data to Darwin Core ready for publication via IPT.

- BlankLineIssues.awk - Script to report unexpected blank lines in a CSV file.
- NewLineIssues.awk - Script to report records having a new line in the field content in a CSV file.
- EncodingIssues.awk - Script to report records having UTF8 encoding issues.
- PurgeNonprintingCharacters.sh - Script to substitute '.' for non-printing characters in data content.
- README - MigratorPrepSteps.txt - Explanation of customization workflow for a new migration installation.
- utf8er.awk - Script to prepend Byte Order Marker (0xEF 0xBB 0xBF) to CSV file known to be utf8-encoded.
