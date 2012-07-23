# call with 
# - author search string without spaces
# - year
# - instrument
# - facility
#
# e.g.
#
# ./get_refs_author.sh "S*Vogel" $year HIPPO LUJAN
#
./gscholar.py -d -a -f $2 -t $2 -i $3.bib -c $4 -n $3 -w "$1" "$1"
echo "Sleeping a minute to stay friends with google..."
sleep 30
