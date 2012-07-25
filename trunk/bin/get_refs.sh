for instr in NPDF SMARTS HIPD HIPPO SCD FDS SPEAR LQD ASTERIX PCS PHAROS; do
  for year in {2000..2012}; do
    ./get_refs_instr.sh $instr $year
  done
done

exit
# old stuff

./get_refs_instr.sh NPDF 2007
./get_refs_instr.sh NPDF 2008
./get_refs_instr.sh NPDF 2009
./get_refs_instr.sh NPDF 2010
./get_refs_instr.sh NPDF 2011

./get_refs_instr.sh SMARTS 2007
./get_refs_instr.sh SMARTS 2008
./get_refs_instr.sh SMARTS 2009
./get_refs_instr.sh SMARTS 2010
./get_refs_instr.sh SMARTS 2011

./get_refs_instr.sh HIPD 2007
./get_refs_instr.sh HIPD 2008
./get_refs_instr.sh HIPD 2009
./get_refs_instr.sh HIPD 2010
./get_refs_instr.sh HIPD 2011

./get_refs_instr.sh HIPPO 2007
./get_refs_instr.sh HIPPO 2008
./get_refs_instr.sh HIPPO 2009
./get_refs_instr.sh HIPPO 2010
./get_refs_instr.sh HIPPO 2011

./get_refs_instr.sh SCD 2007
./get_refs_instr.sh SCD 2008
./get_refs_instr.sh SCD 2009
./get_refs_instr.sh SCD 2010
./get_refs_instr.sh SCD 2011

./get_refs_instr.sh FDS 2007
./get_refs_instr.sh FDS 2008
./get_refs_instr.sh FDS 2009
./get_refs_instr.sh FDS 2010
./get_refs_instr.sh FDS 2011

./get_refs_instr.sh SPEAR 2007
./get_refs_instr.sh SPEAR 2008
./get_refs_instr.sh SPEAR 2009
./get_refs_instr.sh SPEAR 2010
./get_refs_instr.sh SPEAR 2011

./get_refs_instr.sh LQD 2007
./get_refs_instr.sh LQD 2008
./get_refs_instr.sh LQD 2009
./get_refs_instr.sh LQD 2010
./get_refs_instr.sh LQD 2011

./get_refs_instr.sh ASTERIX 2007
./get_refs_instr.sh ASTERIX 2008
./get_refs_instr.sh ASTERIX 2009
./get_refs_instr.sh ASTERIX 2010
./get_refs_instr.sh ASTERIX 2011

./get_refs_instr.sh PCS 2007
./get_refs_instr.sh PCS 2008
./get_refs_instr.sh PCS 2009
./get_refs_instr.sh PCS 2010
./get_refs_instr.sh PCS 2011

./get_refs_instr.sh PHAROS 2007
./get_refs_instr.sh PHAROS 2008
./get_refs_instr.sh PHAROS 2009
./get_refs_instr.sh PHAROS 2010
./get_refs_instr.sh PHAROS 2011


exit
