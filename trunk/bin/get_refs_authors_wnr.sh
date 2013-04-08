for year in {2006..2013}; do
  ./get_refs_author.sh "S*Wender" $year WNR WNR
  ./get_refs_author.sh "J*Ullman" $year DANCE WNR
  ./get_refs_author.sh "B*Haight" $year WNR WNR
  ./get_refs_author.sh "F*Tovesson" $year WNR WNR
  ./get_refs_author.sh "T*Taddeucci" $year WNR WNR
  ./get_refs_author.sh "R*Nelson" $year WNR WNR
  ./get_refs_author.sh "M*Devlin" $year WNR WNR
  ./get_refs_author.sh "N*Fotiades" $year WNR WNR
  ./get_refs_author.sh "L*Bitteker" $year WNR WNR
done

