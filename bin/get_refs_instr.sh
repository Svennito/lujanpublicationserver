#./gscholar.py -d -a  -e $1 -f $2 -t $2 -i $1.bib "$1 neutron"
# make an instrument entry
./gscholar.py -d -a  -e $1 -f $2 -t $2 -i $1.bib -n $1 -c $3 "\"$1\" neutron"
echo "Sleeping a minute to stay friends with google..."
sleep 30
