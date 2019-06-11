*This code loads the xtfevd ado file and help file.
*This is necessary for the replication of the simulations.

cd c:\ado\
capture mkdir plus
cd plus
capture mkdir x
cd x
capture copy http://www.polsci.org/pluemper/xtfevd.ado xtfevd.ado
capture copy http://www.polsci.org/pluemper/xtfevd.hlp xtfevd.hlp
