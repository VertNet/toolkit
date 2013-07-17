REM DESCRIPTION: 
REM This script gets the latest vocabularies from the Vocabulary repository into the local
REM VertNetVocabulariesManager.mdb file opens the vocabularies for review. When they have been
REM updated to satisfacation in the local database, run the macro 
REM "Replace MySQL Vocabularies from Local Copy" to save the work to the repository, completely
REM replacing what is there with the local version.

REM ASSUMPTIONS: 
REM This script assumes that the VertNetVocabulariesManager.mdb file is in .\source and
REM that the database is able to connect to the repository tables through a
REM DSN that allows inserting and updating.

REM This script assumes the directory structure:
REM    . (where this script is located and all of those it calls are located)
REM    .\source (where the VertNetVocabularies.mdb file is located)

set accessexe="C:\Program Files\Microsoft Office\OFFICE11\MSACCESS.EXE"
if exist %accessexe% goto accessfound
set accessexe="C:\Program Files (x86)\Microsoft Office\OFFICE11\MSACCESS.EXE"
if exist %accessexe% goto accessfound
set accessexe="C:\Program Files\Microsoft Office\Office14\MSACCESS.exe"
if exist %accessexe% goto accessfound
set accessexe="C:\Program Files (x86)\Microsoft Office\Office14\MSACCESS.exe"
if not exist %accessexe% goto end
:accessfound

REM "C:\Program Files\Microsoft Office\OFFICE11\MSACCESS.EXE" %CD%\source\VertNetVocabulariesManager.mdb /x "0) Update local Vocabularies from MySQL"
REM "C:\Program Files\Microsoft Office\OFFICE11\MSACCESS.EXE" %CD%\source\VertNetVocabulariesManager.mdb /x "1) Check Local Vocabularies"
%accessexe% %CD%\source\VertNetVocabulariesManager.mdb /x "1) Check Local Vocabularies"

:end