#!/bin/bash
if [ "$1" == "" ]; then
  echo "Please call with facility, year and/or instrument as parameters."
  echo "At least the facility is required. "
  exit
fi

if [ "$2" == "" ]; then
  echo "No year or instrument given, exporting the complete publication list for $1."
  echo "select entry from bibtab where facility='$1' AND isnull(falsehit);" > temp.sql
else
  if [ "$3" == "" ]; then
    if  [[ "$2" =~ ^-?[0-9]+$ ]]; then
      echo "Year but no instrument given, exporting the publication list for $1 for year $2."
      echo "select entry from bibtab where facility='$1' AND year=$2 AND isnull(falsehit);" > temp.sql
    else 
      echo "Instrument but no year given, exporting the publication list for $1 for instrument $2."
      echo "select entry from bibtab where facility='$1' AND instrument like '%$2%' AND isnull(falsehit);" > temp.sql
    fi
  else
    echo "Exporting the publication list for $1 for year $2 and the $3 instrument."
    echo "select entry from bibtab where facility='$1' AND year=$2 AND instrument like '%$3%' AND isnull(falsehit);" > temp.sql
  fi
fi

# issue the query to mysql
mysql --skip-column-names -ubibtex -pbibtex bibtex < temp.sql > temp.bib

# clean up the bib file
sed  "s/\\\n/\\`echo -e '\r'`/g" temp.bib > export_$1_$2_$3.bib

# make a nice html file out of this
java -jar ~/Downloads/JabRef-2.9.2.jar -n -i export_$1_$2_$3.bib -o export_$1_$2_$3.html,lujan
