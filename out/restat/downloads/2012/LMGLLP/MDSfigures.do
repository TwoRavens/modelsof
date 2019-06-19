/* This file creates Figure 1 for "Divisions within Academia"

cd K:/AcademicNetworks/  */


use Econ

mds imit-ijohns if  rank<=20, id(univ) meas(L1) config noplot
mdsconfig, mlabsize(vsmall)  title("Economics: Top 20") /* mlabangle(10)
*/ t2title(" ")  saving(econ20,replace)

mds imit-iucberkeley  inorthwestern-iminnesota  ipennsylvania-ijohns if  rank<=20 &NAmer==1 , /* 
*/ id(univ) meas(L1) config noplot
mdsconfig, mlabsize(vsmall)  title("Economics: US Top 17") t2title(" ")  /*
*/   saving(econUS17,replace) xnegate ynegate


clear


use Math

mds ipri-ipenns if  rank<=20, id(univ) meas(L1) config noplot
mdsconfig, mlabsize(vsmall)  title("Mathematics: US Top 20") t2title(" ") /*
*/ saving(math20,replace) xnegate ynegate


use CompLit /* drop Toronto (rank=20 as non-US  */

mds iyale-iwashington iwashingtonstl if (rank<=19 | rank==21) , id(univ) meas(L1) config noplot
mdsconfig, mlabsize(vsmall) title("Comparative Literature: US Top 20")/*
*/  t2title(" ") saving(comp20,replace) xnegate


gr combine econ20.gph econUS17.gph, saving(Fig1n2,replace)
more
gr combine math20.gph comp20.gph, saving(Fig3n4,replace)

clear
