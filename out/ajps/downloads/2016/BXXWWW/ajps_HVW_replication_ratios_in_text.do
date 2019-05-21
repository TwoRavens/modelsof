* Replication file for Hitt, Volden, Wiseman, American Journal of Political Science, 2016 Table 1
* Scholar needs to import ajps_HVW_tables_replication.dta file into the same directory as this .do file before executing .do file
* ajps_HVW_tables_replication.dta is formated for Stata version 13

* First, need to create variable for minority extremists
sum dwnom1 if majority==0 & dem==0, d
gen minextreme=0
replace minextreme=. if majority==1
label var minextreme "1 = minority extremist, 0 = minority centrist, . = majority member"
replace minextreme=1 if dwnom1>0.327 & majority==0 & dem==0
sum dwnom1 if majority==0 & dem==1, d
replace minextreme=1 if dwnom1<-0.405 & majority==0 & dem==1

* Then generate the bill-level summaries for the difference in proportions test
sum all_bills all_abc if minextreme==1
sum all_bills all_abc if minextreme==0

*generate total number of bills introduced by minority extremists and total number of bills that received action in committee that were introduced by minority extremists

di 1977*13.05766
di 1977*.6646434

*generate total number of bills introduced by minority centrists and total number of bills that received action in committee that were introduced by minority centrists

di 2081*16.37578
di 2081*.72321


* Then generate bill-level summaries for House passage rates test
sum all_abc all_pass all_law if majority==1
sum all_abc all_pass all_law if majority==0

*generate total number of bills that received action beyond committee, passed house, and became law for majority party members

di 5311*2.569573
di 5311*2.048202
di 5311*.9979288

*generate total number of bills that received action beyond committee, passed house, and became law for minority party members

di 4058*.6946772
di 4058*.5911779
di 4058*.3270084

* Then conduct difference in proportions tests (done in Excell)
