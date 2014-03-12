#!/bin/bash
now=$(date +"%Y%m%d")
filename=backup_bibtex_$now.sql
echo "Filename : $filename"
# mysqldump -h localhost -u bibtex -pbibtex bibtex > $filename
mysqldump -h sls.lansce.lanl.gov -u bibtex -pbibtex bibtex > $filename
ls -lrth $filename
echo "Done. Use"
echo "mysql -u bibtex -pbibtex < $filename"
echo "to restore."
