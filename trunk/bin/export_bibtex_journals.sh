#!/bin/bash
if [ "$1" == "" ]; then
  echo "Please call with journal (in double quotes), start year, end year."
  exit
fi

if [ "$2" == "" ]; then
  echo "Please call with journal (in double quotes), start year, end year."
  exit
fi

if [ "$3" == "" ]; then
  echo "Please call with journal (in double quotes), start year, end year."
  exit
fi

echo "Exporting papers in <$1> published between $2 and $3."
echo "select entry from bibtab where journal like '$1' AND year between $2 and $3 AND isnull(falsehit);" > temp.sql

filename=$1
# issue the query to mysql
mysql --skip-column-names -h sls.lansce.lanl.gov -ubibtex -pbibtex bibtex < temp.sql > temp.bib
# mysql --skip-column-names -ubibtex -pbibtex bibtex < temp.sql > temp.bib

# clean up the bib file
sed  "s/\\\n/\\`echo -e '\r'`/g" temp.bib > export_${filename// /_}_$2_$3.bib

# make a nice html file out of this
java -jar ~/Downloads/JabRef-2.9.2.jar -n -i export_${filename// /_}_$2_$3.bib -o export_${filename// /_}_$2_$3.html,lujan
# java -jar ~/Downloads/JabRef-2.9.2.jar -n -i export_${filename// /_}_$2_$3.bib -o export_${filename// /_}_$2_$3.html,tablerefsabsbib
