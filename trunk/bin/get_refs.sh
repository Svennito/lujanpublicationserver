#for instr in NPDF SMARTS HIPD HIPPO SCD FDS SPEAR LQD ASTERIX PCS PHAROS; do
for instr in SMARTS HIPD HIPPO SCD FDS SPEAR LQD ASTERIX PCS PHAROS; do
  for year in {2009..2013}; do
    ./get_refs_instr.sh $instr $year  LUJAN
  done
done
