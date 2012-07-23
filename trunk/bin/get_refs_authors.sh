rm *.bib
for year in {2000..2012}; do
  ./get_refs_author.sh "S*Vogel" $year HIPPO LUJAN
  ./get_refs_author.sh "Y*Zhao" $year HIPPO LUJAN
  ./get_refs_author.sh "J*Zhang" $year HIPPO LUJAN
  ./get_refs_author.sh "H*Xu" $year HIPPO LUJAN
  ./get_refs_author.sh "T*Proffen" $year NPDF LUJAN
  ./get_refs_author.sh "K*Page" $year NPDF LUJAN
  ./get_refs_author.sh "D*Brown" $year SMARTS LUJAN
  ./get_refs_author.sh "B*Clausen" $year SMARTS LUJAN
  ./get_refs_author.sh "T*Sisneros" $year SMARTS  LUJAN
  ./get_refs_author.sh "A*Llobet" $year HIPD LUJAN
  ./get_refs_author.sh "H*Nakotte" $year SCD LUJAN
  ./get_refs_author.sh "L*Daemen" $year FDS LUJAN
  ./get_refs_author.sh "J*Majewski" $year SPEAR LUJAN
  ./get_refs_author.sh "M*Hartl" $year LQD LUJAN
  ./get_refs_author.sh "R*Hjelm" $year LQD LUJAN
  ./get_refs_author.sh "M*Fitzsimmons" $year ASTERIX LUJAN
  ./get_refs_author.sh "B*Schoenborn" $year PCS LUJAN
  ./get_refs_author.sh "Z*Fisher" $year PCS LUJAN
  ./get_refs_author.sh "P*Langan" $year PCS LUJAN
  ./get_refs_author.sh "F*Trouw" $year PHAROS LUJAN
  ./get_refs_author.sh "G*Muhrer" $year SPALLATION LUJAN
  ./get_refs_author.sh "M*Mocko" $year SPALLATION LUJAN
  ./get_refs_author.sh "G*Russell" $year SPALLATION LUJAN
  ./get_refs_author.sh "A*Hurd" $year MANAGEMENT LUJAN
  ./get_refs_author.sh "J*Rhyne" $year MANAGEMENT LUJAN
  ./get_refs_author.sh "P*Lewis" $year MANAGEMENT LUJAN

  ./get_refs_author.sh "S*Wender" $year WNR WNR
  ./get_refs_author.sh "J*Ullman" $year DANCE WNR
  ./get_refs_author.sh "B*Haight" $year WNR WNR
  ./get_refs_author.sh "F*Tovesson" $year WNR WNR
  ./get_refs_author.sh "T*Taddeucci" $year WNR WNR
  ./get_refs_author.sh "R*Nelson" $year WNR WNR
done
