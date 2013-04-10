#!/bin/bash
# Make HTML with publications of the whole facility
for facility in {Lujan,WNR}; do
  ./export_bibtex.sh $facility
done

# Make HTML with publications per year for facilities
for facility in {Lujan,WNR}; do
  for year in {2000..2013}; do
    ./export_bibtex.sh $facility $year
  done
done

# Make HTML with publications of each instrument, with all years
for instrument in {NPDF,SMARTS,HIPD,HIPPO,SCD,FDS,SPEAR,LQD,ASTERIX,PCS,PHAROS,MANAGEMENT,SPALLATION}; do
  ./export_bibtex.sh Lujan $instrument
done

