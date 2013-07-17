REM DESCRIPTION: 
REM This script pulls vocabularies from a repository into a local database
REM where they are used to do lookups and to find new terms in need of 
REM mapping to standard values. The process for maintaining the vocabularies
REM is to run this script once before running a migration, to get the vocabularies.
REM Then, after the first successful run of the migration, have someone with 
REM vocabulary update permissions use the VertNetVocabularies.mdb database to 
REM provide standard values for new terms and save those new terms to the 
REM VertNet vocabularies repository. Vocabulary 

REM ASSUMPTIONS: 
REM This script assumes that the VertNetVocabularies.mdb file is in .\source and
REM that the database is able to connect to the repository tables through a
REM DSN that allows selecting and inserting.

REM This script assumes the directory structure:
REM    . (where this script is located and all of those it calls are located)
REM    .\source (where the VertNetVocabularies.mdb file is located)

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

REM Get copies of the vocabularies databases from Dropbox if the directory exists. If
REM it doesn't, the assumptions is that the files are already in the source folder.
set vocabulariesdir=C:\Dropbox\Vocabularies
if exist %vocabulariesdir% goto vocabsfound
	set vocabulariesdir=I:\Dropbox\VertNetIPT_Unshared\Vocabularies
	if not exist %vocabulariesdir% goto novocabs
:vocabsfound
    xcopy %vocabulariesdir% source\ /E /Y
:novocabs

%accessexe% %CD%\source\VertNetVocabularies.mdb /x "Sync Local Tables From MySQL"
REM "C:\Program Files\Microsoft Office\OFFICE11\MSACCESS.EXE" %CD%\source\VertNetVocabularies.mdb /x "Sync Local Tables From MySQL"

:end