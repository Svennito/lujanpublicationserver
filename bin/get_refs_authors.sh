for year in {2012..2013}; do
#   ./get_refs_author.sh "S*Vogel" $year HIPPO LUJAN
#   ./get_refs_author.sh "J*Zhang" $year HIPPO LUJAN
#   ./get_refs_author.sh "H*Xu" $year HIPPO LUJAN
# 
#   ./get_refs_author.sh "K*Page" $year NPDF LUJAN
# 
#   ./get_refs_author.sh "M*Bourke" $year SMARTS LUJAN
#   ./get_refs_author.sh "D*Brown" $year SMARTS LUJAN
#   ./get_refs_author.sh "B*Clausen" $year SMARTS LUJAN
  ./get_refs_author.sh "T*Sisneros" $year SMARTS  LUJAN

  ./get_refs_author.sh "A*Llobet" $year HIPD LUJAN

  ./get_refs_author.sh "H*Nakotte" $year SCD LUJAN

  ./get_refs_author.sh "L*Daemen" $year FDS LUJAN

  ./get_refs_author.sh "J*Majewski" $year SPEAR LUJAN

  ./get_refs_author.sh "M*Hartl" $year LQD LUJAN
  ./get_refs_author.sh "R*Hjelm" $year LQD LUJAN

  ./get_refs_author.sh "M*Fitzsimmons" $year ASTERIX LUJAN

  ./get_refs_author.sh "Z*Fisher" $year PCS LUJAN

  ./get_refs_author.sh "F*Trouw" $year PHAROS LUJAN
  ./get_refs_author.sh "A*Lawson" $year PHAROS LUJAN

   ./get_refs_author.sh "G*Muhrer" $year SPALLATION LUJAN
   ./get_refs_author.sh "C*Kelsey" $year SPALLATION LUJAN
   ./get_refs_author.sh "M*Mocko" $year SPALLATION LUJAN
   ./get_refs_author.sh "G*Russell" $year SPALLATION LUJAN
done

exit	# for the recount of gmail scholar account owners and Angus

# special cases for those who left or came later, add a year after departure for publication lag
# folks who retired didn't do much afterwards and may stay in the upper, complete loop
for year in {2000..2012}; do
  ./get_refs_author.sh "Y*Zhao" $year HIPPO LUJAN
  ./get_refs_author.sh "T*Proffen" $year NPDF LUJAN
  ./get_refs_author.sh "B*Schoenborn" $year PCS LUJAN
  ./get_refs_author.sh "P*Langan" $year PCS LUJAN
done

for year in {2000..2012}; do
  ./get_refs_author.sh "A*Hurd" $year MANAGEMENT LUJAN
  ./get_refs_author.sh "G*Cooper" $year MANAGEMENT LUJAN
done

for year in {2000..2010}; do
  ./get_refs_author.sh "M*Hehlen" $year PHAROS LUJAN
done

for year in {2000..2013}; do
  ./get_refs_author.sh "J*Rhyne" $year MANAGEMENT LUJAN
  ./get_refs_author.sh "P*Lewis" $year MANAGEMENT LUJAN
done


for year in {2010..2013}; do
  ./get_refs_author.sh "L*Balogh" $year SMARTS LUJAN
done

for year in {2008..2013}; do
  ./get_refs_author.sh "J*Siewenie" $year NPDF LUJAN
done

for year in {2011..2013}; do
  ./get_refs_author.sh "C*White" $year NPDF LUJAN
done

for year in {2011..2013}; do
  ./get_refs_author.sh "S*Singh" $year SPEAR LUJAN
done

for year in {2009..2013}; do
  ./get_refs_author.sh "T*Huegle" $year SPEAR LUJAN
done
