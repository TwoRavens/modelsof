* Replication File for
* Title: "Prioritized Interests: Diverse Lobbying Coalitions and Congressional Committee Agenda-Setting"
* Author: Geoffrey Miles Lorenz
* Journal of Politics


*use "Data Prioritized Interests Replication.dta"

* All results checked 


*****************************
**** MAIN ARTICLE ***********
*****************************

* Figure 1.  Checked 180824
 melogit ocout netsupport_subdiv net_PACmaxall netsupport_num i.majority  i.cong  || major :
est sto est1
melogit ocout netsupport_subdiv net_PACmaxall netsupport_num  interested competitive cosponsors i.cong  || major :
est sto est2
melogit ocout netsupport_subdiv net_PACmaxall netsupport_num i.majority#i.mref i.chref i.united i.cong  || major :
est sto est3

* Full Model
melogit ocout netsupport_subdiv net_PACmaxall netsupport_num interested competitive cosponsors i.majority#i.mref i.chref i.united i.cong || major :
est sto est4

* Plot figure
coefplot est1 est2 est3 est4, keep(netsupport_subdiv net_PACmaxall netsupport_num) xline(0)  mlabel format(%9.3f) mlabposition(12) mlabgap(*2) nokey msize(medlarge)
* Modify display parameters individually to exactly reproduce the figure's aesthetic aspects 


* Figure 2. Checked 180824

melogit ocout netsupport_subdiv net_PACmaxall netsupport_num interested competitive cosponsors i.majority#i.mref i.chref i.united i.cong  || major :

margins, at(netsupport_subdiv = (-50(5)95)) atmeans vsquish 
marginsplot, recast(line) recastci(rline)


margins, at(net_PACmaxall = (-100(5)300)) atmeans vsquish 
marginsplot, recast(line) recastci(rline)


margins, at(netsupport_num = (-195(5)260)) atmeans vsquish
 
marginsplot, recast(line) recastci(rline)

* As above, the aesthethic parameters need to be tweaked to have it exactly replicate these aspects of the figure


* Table 1: Checked 180824
*Majority
melogit ocout netsupport_subdiv net_PACmaxall netsupport_num interested competitive cosponsors  i.majority#i.mref i.chref i.united i.cong if majority == 1 || major :  
est sto maj

*Minority
melogit ocout netsupport_subdiv net_PACmaxall netsupport_num interested competitive cosponsors  i.majority#i.mref i.chref i.united i.cong if  majority == 0 || major :
est sto min

*Unified
melogit ocout netsupport_subdiv net_PACmaxall netsupport_num interested competitive cosponsors  i.majority#i.mref i.chref i.united i.cong if  united == 1 || major :
est sto uni

*Divided
melogit ocout netsupport_subdiv net_PACmaxall netsupport_num interested competitive cosponsors  i.majority#i.mref i.chref i.united i.cong if  united == 0 || major :
est sto div



*****************************
***** ONLINE APPENDIX *******
*****************************

* Section 1. Summary Stats Checked 180824

*Table 1. Checked 180824
sum ocout ocmark ocreport reportorigincomm house_majparty netsupport_subdiv net_PACmaxall netsupport_num competitive interested cosponsors majority mref chref united numbersubjects_pcntofall 


* Section 2. Full Results Tables

*see models in main paper for Figure 1

*Table 2. Checked 180824
esttab est1 est2 est3 est4, se aic bic compress replace title(Net Interest Diversity, Net PAC Contributions, and Net Side Size: Full Results from Four Model Specifications ) mtitles ("" "" "" "") coeflabels(netsupport_num "Net Side Size" netsupport_subdiv "Net Interest Diversity" net_PACmaxall "Net PAC Contributions" interested "\# Groups Lobbying" cosponsors "\# of Cosponsors" competitive "Competitiveness" majority "Majority Party" mref "On Committee" 1.majority#0.mref "Majority Party, Not on Committee" 1.majority#1.mref "Majority Party, on Committee" 0.majority#1.mref "Minority Party, on Committee" 1.chref "Committee Chair" 1.united "Unified Government") drop(0.majority 0.chref 0.united 109.cong 110.cong 111.cong 112.cong 113.cong 0.majority#0.mref) nogaps

* Table 3. Checked 180824

esttab maj min uni div  , se aic bic compress replace title(Association Between Coalition Attributes and Committee Consideration Changes with Institutional Conditions (Full Results) ) mtitles("Majority" "Minority" "Unified Govt" "Divided Govt") coeflabels(netsupport_num "Net Side Size" netsupport_subdiv "Net Interest Diversity" net_PACmaxall "Net PAC Contributions" interested "\# Groups Lobbying" cosponsors "\# of Cosponsors" competitive "Competitiveness" majority "Majority Party" mref "On Committee" 1.majority#0.mref "Majority Party, Not on Committee" 1.majority#1.mref "Majority Party, on Committee" 0.majority#1.mref "Minority Party, on Committee" 1.chref "Committee Chair" 1.united "Unified Government") drop(0.chref 0.united 109.cong 110.cong 111.cong 112.cong 113.cong 0.majority#0.mref) nogaps


* Section 3


melogit reportorigincomm netsupport_subdiv net_PACmaxall netsupport_num interested competitive cosponsors i.majority#i.mref i.chref i.united i.cong || major :

est sto CBPreporgcomm

melogit ocmark netsupport_subdiv net_PACmaxall netsupport_num interested competitive cosponsors i.majority#i.mref i.chref i.united i.cong || major :

est sto OCmarkup

melogit ocreport netsupport_subdiv net_PACmaxall netsupport_num interested competitive cosponsors i.majority#i.mref i.chref i.united i.cong || major :

est sto OCreport

melogit ocout netsupport_subdiv net_PACmaxall netsupport_num interested competitive cosponsors i.majority#i.mref i.chref i.united i.cong || major :

est sto OCconsideration

* Table 4. Checked 180824
esttab OCconsideration OCmarkup OCreport CBPreporgcomm  , se aic bic compress replace title(Lobbying and Committee Consideration of Legislation) mtitles("Any Consideration (Govtrack)" "Markup (Govtrack)" "Reporting (Govtrack)" "Reported from Origin Chamber Committee (CBP)") coeflabels(netsupport_num "Net Side Size" netsupport_subdiv "Net Interest Diversity" net_PACmaxall "Net PAC Contributions" interested "\# Groups Lobbying" cosponsors "\# of Cosponsors" competitive "Competitiveness" majority "Majority Party" mref "On Committee" 1.majority#0.mref "Majority Party, Not on Committee" 1.majority#1.mref "Majority Party, on Committee" 0.majority#1.mref "Minority Party, on Committee" 1.chref "Committee Chair" 1.united "Unified Government") drop(0.chref 0.united 109.cong 110.cong 111.cong 112.cong 113.cong 0.majority#0.mref) nogaps


* Section 4


melogit house_majparty netsupport_subdiv net_PACmaxall netsupport_num  i.cong if chamber == 0 & majority == 1 & ocout == 0 || major :

eststo party1

melogit house_majparty netsupport_subdiv net_PACmaxall netsupport_num interested competitive cosponsors i.cong if chamber == 0 & majority == 1 & ocout == 0 || major :

eststo party2

melogit house_majparty netsupport_subdiv net_PACmaxall netsupport_num i.mref i.chref i.united i.cong if  chamber == 0 & majority == 1 & ocout == 0 || major :

eststo party3

melogit house_majparty netsupport_subdiv net_PACmaxall netsupport_num interested competitive cosponsors i.mref i.chref i.united i.cong if  chamber == 0 & majority == 1 & ocout == 0 || major :

eststo party4

* Table 5. Checked 180824
esttab party1 party2 party3 party4 , se aic bic compress replace title(Lobbying and Committee Consideration of Legislation)  coeflabels(netsupport_num "Net Side Size" netsupport_subdiv "Net Interest Diversity" net_PACmaxall "Net PAC Contributions" interested "\# Groups Lobbying" cosponsors "\# of Cosponsors" competitive "Competitiveness" majority "Majority Party" mref "On Committee" 1.chref "Committee Chair" 1.united "Unified Government") drop(0.chref 0.united 109.cong 110.cong 111.cong 112.cong 113.cong ) nogaps




* Section 5

* Table 6. Checked 180824

melogit ocout netsupport_subdiv net_PACmaxall netsupport_num i.majority  i.cong if house_majparty == 0 || major :
est sto mest1
melogit ocout netsupport_subdiv net_PACmaxall netsupport_num  interested competitive cosponsors i.cong if  house_majparty == 0 || major :
est sto mest2
melogit ocout netsupport_subdiv net_PACmaxall netsupport_num i.majority#i.mref i.chref i.united i.cong if  house_majparty == 0 || major :
est sto mest3
melogit ocout netsupport_subdiv net_PACmaxall netsupport_num interested competitive cosponsors i.majority#i.mref i.chref i.united i.cong if  house_majparty == 0 || major :
est sto mest4

esttab mest1 mest2 mest3 mest4 , se aic bic compress replace title(Results Do Not Change When Majority Priority Legislation is Excluded) coeflabels(netsupport_num "Net Side Size" netsupport_subdiv "Net Interest Diversity" net_PACmaxall "Net PAC Contributions") keep(netsupport_subdiv net_PACmaxall netsupport_num) nogaps



* Section 6
* Table 7. Checked 180824


melogit ocout netsupport_subdiv net_PACmaxall netsupport_num numbersubjects_pcntofall interested competitive cosponsors i.majority#i.mref i.chref i.united i.cong  || major :

est sto wnumsub

esttab wnumsub  , se aic bic compress replace title(Lobbying and Committee Consideration of Legislation) mtitles("Any Consideration (Govtrack)" "Markup (Govtrack)" "Reporting (Govtrack)" "Reported from Origin Chamber Committee (CBP)") coeflabels(netsupport_num "Net Side Size" netsupport_subdiv "Net Interest Diversity" net_PACmaxall "Net PAC Contributions" interested "\# Groups Lobbying" cosponsors "\# of Cosponsors" competitive "Competitiveness" majority "Majority Party" mref "On Committee" 1.majority#0.mref "Majority Party, Not on Committee" 1.majority#1.mref "Majority Party, on Committee" 0.majority#1.mref "Minority Party, on Committee" 1.chref "Committee Chair" 1.united "Unified Government") drop(0.chref 0.united 109.cong 110.cong 111.cong 112.cong 113.cong 0.majority#0.mref) nogaps



* Section 7
*Table 8. Checked 180824

melogit ocout netsupport_subdiv net_PACmaxall netsupport_num interested competitive cosponsors i.majority#i.mref chref i.major   || cong : united

est sto me_unitedon2nd

melogit ocout netsupport_subdiv net_PACmaxall netsupport_num interested competitive cosponsors i.majority#i.mref chref i.united i.major i.cong , vce(cluster simpletitlestemmed)

est sto clust_bill


melogit ocout netsupport_subdiv net_PACmaxall netsupport_num interested competitive cosponsors i.majority#i.mref chref i.united i.major  i.cong || simpletitlestemmed:

est sto me_bill

* Warning: this last model works but takes a long time to converge
melogit ocout netsupport_subdiv net_PACmaxall netsupport_num interested competitive cosponsors i.majority#i.mref i.chref i.major  || cong : united || simpletitlestemmed:  

est sto bills_in_cong

esttab me_unitedon2nd clust_bill me_bill bills_in_cong , se aic bic compress replace title(Alternative Assumed Error Structures) mtitles("RI CONG: UNITED" "FE CLUST BILL" "RI BILLS" "RI BILLS IN CONG") coeflabels(netsupport_num "Net Side Size" netsupport_subdiv "Net Interest Diversity" net_PACmaxall "Net PAC Contributions" interested "\# Groups Lobbying" cosponsors "\# of Cosponsors" competitive "Competitiveness" majority "Majority Party" mref "On Committee" 1.majority#0.mref "Majority Party, Not on Committee" 1.majority#1.mref "Majority Party, on Committee" 0.majority#1.mref "Minority Party, on Committee" 1.chref "Committee Chair" chref "Committee Chair" 1.united "Unified Government") drop(0.chref 0.united 109.cong 110.cong 111.cong 112.cong 113.cong 0.majority#0.mref *.major) nogaps



* Section 8

* Table 9. Checked 180824

melogit ocout netsupport_subdiv  i.cong  || major :

est sto nid_base

melogit ocout netsupport_subdiv interested competitive cosponsors i.majority i.cong || major :

est sto nid_igvars

melogit ocout netsupport_subdiv  i.majority#i.mref i.chref i.united i.cong  || major :

est sto nid_existing

melogit ocout netsupport_subdiv interested competitive cosponsors i.majority#i.mref i.chref i.united i.cong  || major :

eststo nid_full

melogit ocout  netsupport_num  i.cong || major :

eststo num_base

melogit ocout  netsupport_num interested competitive cosponsors i.majority i.cong  || major :

eststo num_igvars

melogit ocout  netsupport_num i.majority#i.mref i.chref i.united i.cong  || major :

eststo num_existing

melogit ocout  netsupport_num interested competitive cosponsors i.majority#i.mref i.chref i.united i.cong  || major :

eststo num_full



esttab nid_base nid_igvars nid_existing nid_full, se aic bic compress replace title(Robustness of Negative Coefficient on Net Side Size) mtitles("Simple Model" "W_IGvars" "W_Expected" "Full") coeflabels(netsupport_num "Net Side Size" netsupport_subdiv "Net Interest Diversity" net_PACmaxall "Net PAC Contributions") nogaps keep(netsupport_subdiv)


esttab num_base num_igvars num_existing num_full    , se aic bic compress replace title(Robustness of Negative Coefficient on Net Side Size) mtitles("Simple Model" "W_IGvars" "W_Expected" "Full") coeflabels(netsupport_num "Net Side Size" netsupport_subdiv "Net Interest Diversity" net_PACmaxall "Net PAC Contributions") nogaps keep(netsupport_num)

 
