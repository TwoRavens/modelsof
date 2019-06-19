/* This do-file creates Figure 2 for "Divisions within Academia " */

* cd D:/AcademicNetworks

/* Economics US Top 16 = Top 20 with UK and JohnsHopkins removed */

use Econ

quietly cluster  averagelinkage imit-iucb imin ipennsy-icolu if rank<=20 & /*
*/ univ!="Oxford" & univ!="Cambridge" & univ!="LSE" & univ!="JohnsHopkins", Manhattan

quietly cluster dendrogram, labels(university) title("Economics") ytitle("") /*
*/ xlabel(,angle(90) labsize(*0.7))  saving(econdendroUStop16,replace)

clear
/* Math US Top 16 */

use Math

quietly cluster  averagelinkage iprince-ipennsy if rank<=16, Manhattan
quietly cluster dendrogram, labels(university) title("Mathematics") ytitle("") /*
*/ xlabel(,angle(90) labsize(*0.7))  saving(mathdendroUStop16,replace)

clear


/* CompLit US Top 16 */

use CompLit

quietly cluster  averagelinkage iyale-iindiana if rank<=16, Manhattan
quietly cluster dendrogram, labels(university) title("Comparative Literature") ytitle("") /*
*/ xlabel(,angle(90) labsize(*0.7))  saving(compdendroUStop16,replace)

clear

/* COMBINED GRAPH */

gr combine econdendroUStop16.gph mathdendroUStop16.gph compdendroUStop16.gph,/*
*/ saving(dendros,replace)


