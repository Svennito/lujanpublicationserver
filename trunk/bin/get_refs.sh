#for instr in NPDF SMARTS HIPD HIPPO SCD FDS SPEAR LQD ASTERIX PCS PHAROS; do
for instr in HIPPO SCD FDS SPEAR LQD ASTERIX PCS PHAROS; do
  for year in {2012..2014}; do
    ./get_refs_instr.sh $instr $year  LUJAN
  done
done
