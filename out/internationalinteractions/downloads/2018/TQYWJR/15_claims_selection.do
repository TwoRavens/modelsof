* Replication package for 
* "The Economic Leverage of International Organizations in Interstate Disputes"
* Johannes Karreth
* June 30, 2017
* jkarreth@ursinus.edu

* This file: 15_claims_selection.do
* Purpose: Estimate Heckman Probit model of using force in claims

* cd "..."
import delimited "claims_selection.csv"

label var igo_lev3_count_use "IGOs with high leverage"
label var salint "Intangible salience of claim"
label var saltan "Tangible salience of claim"
label var terriss "Territorial claim"
label var jointpol7 "Joint democracy"
label var rivalry_th "Strategic rivalry"
label var idealpointdistance "UNGA ideal point difference"
label var atopally "Allies"
label var idealpointdistance_l1 "UNGA ideal point difference (lagged)"
label var contig "Contiguity"

heckprobit useforce igo_lev3_count_use salint saltan terriss jointpol7 rivalry_th idealpointdistance atopally, select(claimonset = igo_lev3_count_use idealpointdistance_l1 rivalry_th contig) vce(cluster dyadid) difficult technique(bfgs) nolog

esttab using "Output_Tables-and-Figures/claims_selection_table.tex", cells(b(star fmt(a2)) se(fmt(a2) par) ) starlevels(* 0.1) stats(N) style(tex) booktabs label replace
