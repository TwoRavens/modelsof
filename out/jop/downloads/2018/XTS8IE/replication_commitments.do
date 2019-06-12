/**************************************************************************
** 
** File name   : replication_commitments.do
** Date        : October 5th, 2018
** Author      : Christina J. Schneider (cjschneider@ucsd.edu)
** Purpose     : Replicates tables and figures for "Public Commitments as Signals of
					Responsiveness in the European Union" (JOP)
** Requires    : replication_commitments.dta, coefplot.ado
** Output      : replication_commitments.log,fig1.eps, table1.tex, appendixB.tex
					appendixC-1.tex, appendixC-2.tex
**
**************************************************************************/

clear
clear matrix
clear mata
set more off
set maxvar 32000
version 14

log using replication_commitments, replace

cd "" /*choose your directory*/

#delimit ;

use replication_commitments, clear;


/**************
**Figure 1**
**************/

graph hbar defense_no defense_yes if country_id!=5 & country_id!=16 & country_id!=17 & country_id!=18 & country_id!=22 
& country_id!=23, over(country_id1, sort(2) gap(120) label(labsize(small))) bar(2, color(gs11)) bar(3, color(black)) 
intensity(100) bargap(3) scheme(s1mono) yline(.4,lpattern(shortdash) lcolor(gray)) legend(size(vsmall) 
rows(1) order(1 "No Election" 2 "Election"));

graph export fig1.eps, replace;


/**************
**Table 1**
**************/
#delimit ;

local controlvars saliency qmv sscouncil_pct_rev positiondistance_ep positiondistance_com distancep multidimensional;

meprobit defense election_neg `controlvars'  || prnrnmc: , vce(robust);

estimates store m1;

meprobit defense election_neg `controlvars'   if legmonth<36 || prnrnmc:  , vce(robust);
estimates store m2;


meprobit defense election_neg_new `controlvars'  || prnrnmc: , vce(robust);
estimates store m3;


meprobit defense m6fin `controlvars'  || prnrnmc: , vce(robust);
estimates store m4;


esttab m1 m2 m3 m4 using table1.tex, replace modelwidth(10) addnote("Standard errors in parentheses") 
 starlevels(* 0.10 ** 0.05) mlabel("Main" "Proposal-Restricted" "Election-Restricted" "Placebo") 
legend cells(b(star fmt(3)) se(par)) stats(chi2 N, star labels("chi" "Observations" ) )
label varwidth(30)  collabels(none);



/**************
**Figure 2**
**************/

#delimit ;
use replication_experiment, clear;

xtset uniqueID;

histogram supportfinance, scheme(s1mono) xscale(range(1/5) noextend) percent xla(1/5, valuelabel labs(vsmall)) 
discrete ylabel(0(5)40,grid) ytitle("Number of Responses (%)") 
xtitle("Support for Financial Rescue Package",height(8));

graph export figure2-a.eps, replace;

histogram supportimmigration, scheme(s1mono) xscale(range(1/5) noextend) percent 
xla(1/5, valuelabel labs(vsmall)) discrete ylabel(0(5)40,grid) 
ytitle("Support for Refugee Inflow (%)") xtitle("",height(8));

graph export figure2-b.eps, replace;


/**************
**Figure 3**
**************/

#delimit ;
reg support_c i.defense i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c 
if similarity_pos==1 & refugee==0 [pweight=_webal],  vce(cluster uniqueID) ;
estimates store m1;

reg support_c i.defense i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c 
if similarity_pos==0 & refugee==0 [pweight=_webal],  vce(cluster uniqueID) ;
estimates store m2;


reg support_c i.defense i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c 
if similarity_pos==1  & refugee==1 [pweight=_webal],  vce(cluster uniqueID); 
estimates store m3;

reg support_c i.defense i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c 
if similarity_pos==0  & refugee==1 [pweight=_webal],  vce(cluster uniqueID) ;
estimates store m4;


#delimit ;
coefplot (m1, label(Voters with policy position similar to politician's)) (m2, label(Voters with policy position different from politician's)), bylabel(Bailout)
|| (m3, label(Voters with policy position similar to politician's)) (m4, label(Voters with policy position different from politician's)), bylabel(Refugees)
 ||,  drop(_cons) level(90) ///
scheme(s1mono) xline(0,lpattern(dash) lcolor(gray)) ylabel(,labsize(small)) legend(size(small)) xtitle("Change in the probability of voting for the politician",size(vsmall)) ///
headings(1.defense = "{bf:Public Commitment}" 1.position_c = "{bf:Position}" 1.vote_c = "{bf:Vote}" 1.outcome_c = "{bf:Outcome}"  ///
1.party_sim = "{bf:Partisanship}" 1.gender_sim = "{bf:Gender}" 2.experience_c = "{bf:Experience}",labsize(small))
byopts(xrescale) legend(rows(2));


graph export figure3.eps, replace;


/**************
**APPENDICES**
**************/


/**************
**Appendix B**
**************/

use replication_commitments, clear;

local controlvars defense election_neg_new saliency qmv sscouncil_pct_rev positiondistance_ep positiondistance_com distancep multidimensional;

quietly gen x = uniform();
quietly regress x `controlvars' ;
estadd summ, mean sd min max;

esttab using appendixB.tex, replace  cells("mean sd min max") stats(N) drop(_cons) mlabels(,none) label varwidth(30);
drop x;


/**************
**Appendix C.1**
**************/


local controlvars saliency qmv sscouncil_pct_rev positiondistance_ep positiondistance_com distancep multidimensional;

meprobit defense election_neg `controlvars' i.country_id || prnrnmc: , vce(robust);
estimates store m1;

label var finactyear "Year of Adoption";

meprobit defense election_neg `controlvars' finactyear || prnrnmc: , vce(robust);
estimates store m2;

meprobit defense election_neg `controlvars' agriculture ecofin general || prnrnmc: , vce(robust);
estimates store m3;

meprobit defense election_neg saliency qmv gdp_ln positiondistance_ep positiondistance_com distancep multidimensional || prnrnmc: , vce(robust);
estimates store m4;

meprobit defense election_neg salienced qmv sscouncil_pct_rev positiondistance_ep positiondistance_com distancep multidimensional || prnrnmc: , vce(robust);
estimates store m5;

probit defense election_neg `controlvars', robust;
estimates store m6;

#delimit ;

esttab m1 m2 m3 m4 m5 m6 using appendixC-1.tex, replace modelwidth(10) addnote("Standard errors in parentheses") 
 starlevels(* 0.108 ** 0.05) mlabel("Country FE" "Time" "Control I" "Control II" "Control III" "Probit") 
legend cells(b(star fmt(3)) se(par)) stats(N chi2, star labels("Observations" "chi") )
label varwidth(30)  collabels(none);

#delimit cr

/**************
**Appendix C.2**
**************/


local controlvars saliency qmv sscouncil_pct_rev positiondistance_ep positiondistance_com distancep multidimensional

meprobit defense election_neg `controlvars' minority || prnrnmc: , vce(robust)
estimates store m1

meprobit defense election_neg `controlvars' coalition || prnrnmc: , vce(robust)
estimates store m2

meprobit defense election_neg `controlvars' govoth_PI || prnrnmc: , vce(robust)
estimates store m3

meprobit defense election_neg `controlvars' govfrac_PI || prnrnmc: , vce(robust)
estimates store m4

meprobit defense election_neg `controlvars' herfgov_PI  || prnrnmc: , vce(robust)
estimates store m5

#delimit ;

esttab m1 m2 m3 m4 m5 using appendixC-2.tex, replace modelwidth(10) addnote("Standard errors in parentheses") 
 starlevels(* 0.108 ** 0.05) mlabel("Minority" "Coalition" "Number of Parties" "Fractionalization" "Herfindahl") 
legend cells(b(star fmt(3)) se(par)) stats(N chi2, star labels("Observations" "chi") )
label varwidth(30)  collabels(none);

#delimit cr

/**************
**Appendix H**
**************/

use replication_experiment, clear

xtset uniqueID


reg support_c i.defense i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==1 & refugee==0,  vce(cluster uniqueID) 
estimates store m1

reg support_c i.defense i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==0 & refugee==0 ,  vce(cluster uniqueID) 
estimates store m2


reg support_c i.defense i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==1  & refugee==1,  vce(cluster uniqueID) 
estimates store m3

reg support_c i.defense i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==0  & refugee==1,  vce(cluster uniqueID) 
estimates store m4

#delimit ;
coefplot (m1, label(Voters with policy position similar politician's)) (m2, label(Voters with policy position different from politician's)), bylabel(Bailout)
||  (m3, label(Voters with policy position similar politician's)) (m4, label(Voters with policy position different from politician's)), bylabel(Refugees)
||,  drop(_cons) level(90) ///
scheme(s1mono) xline(0,lpattern(dash) lcolor(gray)) ylabel(,labsize(small)) legend(size(small)) xtitle("Change in the probability of voting for the politician",size(vsmall)) ///
headings(1.defense = "{bf:Public Commitment}" 1.position_c = "{bf:Position}" 1.vote_c = "{bf:Vote}" 1.outcome_c = "{bf:Outcome}"  ///
1.party_sim = "{bf:Partisanship}" 1.gender_sim = "{bf:Gender}" 2.experience_c = "{bf:Experience}",labsize(small))
byopts(xrescale) legend(rows(2));
#delimit cr

graph export appendixH.eps, replace

/**************
**Appendix I**
**************/


reg support_cont_c i.defense i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==1 & refugee==0 [pweight=_webal],  vce(cluster uniqueID) 
estimates store m1

reg support_cont_c i.defense i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==0 & refugee==0 [pweight=_webal],  vce(cluster uniqueID) 
estimates store m2


reg support_cont_c i.defense i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==1  & refugee==1 [pweight=_webal],  vce(cluster uniqueID) 
estimates store m3

reg support_cont_c i.defense i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==0  & refugee==1 [pweight=_webal],  vce(cluster uniqueID) 
estimates store m4

#delimit ;

coefplot (m1, label(Voters with policy position similar to politician's)) (m2, label(Voters with policy position different from politician's)), bylabel(Bailout)
|| (m3, label(Voters with policy position similar to politician's)) (m4, label(Voters with policy position different from politician's)), bylabel(Refugees)
 ||,  drop(_cons) level(90) ///
scheme(s1mono) xline(0,lpattern(dash) lcolor(gray)) ylabel(,labsize(small)) legend(size(small)) xtitle("Change in the probability of voting for the politician",size(vsmall)) ///
headings(1.defense = "{bf:Public Commitment}" 1.position_c = "{bf:Position}" 1.vote_c = "{bf:Vote}" 1.outcome_c = "{bf:Outcome}"  ///
1.party_sim = "{bf:Partisanship}" 1.gender_sim = "{bf:Gender}" 2.experience_c = "{bf:Experience}",labsize(small))
byopts(xrescale) legend(rows(2));
#delimit cr

graph export appendixI.eps, replace

/**************
**Appendix J**
**************/

reg support_c i.defense i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==1 & refugee==0 &knowledge>1 [pweight=_webal],  vce(cluster uniqueID) 
estimates store m1

reg support_c i.defense i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==0 & refugee==0 &knowledge>1 [pweight=_webal],  vce(cluster uniqueID) 
estimates store m2


reg support_c i.defense i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==1  & refugee==1 &knowledge>1 [pweight=_webal],  vce(cluster uniqueID) 
estimates store m3

reg support_c i.defense i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==0  & refugee==1 &knowledge>1 [pweight=_webal],  vce(cluster uniqueID) 
estimates store m4


#delimit ;

coefplot (m1, label(Voters with policy position similar to politician's)) (m2, label(Voters with policy position different from politician's)), bylabel(Bailout)
||  (m3, label(Voters with policy position similar to politician's)) (m4, label(Voters with policy position different from politician's)), bylabel(Refugees)
||,  drop(_cons) level(90) ///
scheme(s1mono) xline(0,lpattern(dash) lcolor(gray)) ylabel(,labsize(small)) legend(size(small)) xtitle("Change in the probability of voting for the politician",size(vsmall)) ///
headings(1.defense = "{bf:Public Commitment}" 1.position_c = "{bf:Position}" 1.vote_c = "{bf:Vote}" 1.outcome_c = "{bf:Outcome}"  ///
1.party_sim = "{bf:Partisanship}" 1.gender_sim = "{bf:Gender}" 2.experience_c = "{bf:Experience}",labsize(small))
byopts(xrescale) legend(rows(2));
#delimit cr

graph export appendixJ.eps, replace

/**************
**Appendix K**
**************/

reg support_c i.defense i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==1 & refugee==0 &screenerCorrect=="correct" [pweight=_webal],  vce(cluster uniqueID) 
estimates store m1

reg support_c i.defense i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==0 & refugee==0 &screenerCorrect=="correct" [pweight=_webal],  vce(cluster uniqueID) 
estimates store m2


reg support_c i.defense i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==1  & refugee==1 &screenerCorrect=="correct" [pweight=_webal],  vce(cluster uniqueID) 
estimates store m3

reg support_c i.defense i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==0  & refugee==1 &screenerCorrect=="correct" [pweight=_webal],  vce(cluster uniqueID) 
estimates store m4


#delimit ;

coefplot (m1, label(Voters with policy position similar to politician's)) (m2, label(Voters with policy position different from politician's)), bylabel(Bailout)
||  (m3, label(Voters with policy position similar to politician's)) (m4, label(Voters with policy position different from politician's)), bylabel(Refugees) ||,  drop(_cons) level(90) ///
scheme(s1mono) xline(0,lpattern(dash) lcolor(gray)) ylabel(,labsize(small)) legend(size(small)) xtitle("Change in the probability of voting for the politician",size(vsmall)) ///
headings(1.defense = "{bf:Public Commitment}" 1.position_c = "{bf:Position}" 1.vote_c = "{bf:Vote}" 1.outcome_c = "{bf:Outcome}"  ///
1.party_sim = "{bf:Partisanship}" 1.gender_sim = "{bf:Gender}" 2.experience_c = "{bf:Experience}",labsize(small))
byopts(xrescale) legend(rows(2));
#delimit cr

graph export appendixK.eps, replace

/**************
**Appendix L**
**************/

hist supportimmigration if partyID_DE=="CDU/CSU" & refugee==1, scheme(s1mono) xscale(range(1/5) noextend) percent xla(1/5, valuelabel labs(vsmall)) discrete ylabel(0(5)40,grid) ytitle("Number of Responses (%)") xtitle("Support for Refugee Inflow (CDU/CSU)",height(8))
graph export immigration_cdu.eps, replace
hist supportimmigration if partyID_DE=="SPD" & refugee==1, scheme(s1mono) xscale(range(1/5) noextend) percent xla(1/5, valuelabel labs(vsmall)) discrete ylabel(0(5)40,grid) ytitle("Number of Responses (%)") xtitle("Support for Refugee Inflow (SPD)",height(8))
graph export immigration_spd.eps, replace
hist supportimmigration if partyID_DE=="BÙndnis 90/Die GrÙnen" & refugee==1, scheme(s1mono) xscale(range(1/5) noextend) percent xla(1/5, valuelabel labs(vsmall)) discrete ylabel(0(5)40,grid) ytitle("Number of Responses (%)") xtitle("Support for Refugee Inflow (Greens)",height(8))
graph export immigration_greens.eps, replace
hist supportimmigration if partyID_DE=="FDP" & refugee==1, scheme(s1mono) xscale(range(1/5) noextend) percent xla(1/5, valuelabel labs(vsmall)) discrete ylabel(0(5)40,grid) ytitle("Number of Responses (%)") xtitle("Support for Refugee Inflow (FDP)",height(8))
graph export immigration_fdp.eps, replace
hist supportimmigration if partyID_DE=="AfD" & refugee==1, scheme(s1mono) xscale(range(1/5) noextend) percent xla(1/5, valuelabel labs(vsmall)) discrete ylabel(0(5)40,grid) ytitle("Number of Responses (%)") xtitle("Support for Refugee Inflow (AfD)",height(8))
graph export immigration_afd.eps, replace


hist supportfinance if partyID_DE=="CDU/CSU" & refugee==0, scheme(s1mono) xscale(range(1/5) noextend) percent xla(1/5, valuelabel labs(vsmall)) discrete ylabel(0(5)40,grid) ytitle("Number of Responses (%)") xtitle("Support for Bailout (CDU/CSU)",height(8))
graph export bailout_cdu.eps, replace
hist supportfinance if partyID_DE=="SPD" & refugee==0, scheme(s1mono) xscale(range(1/5) noextend) percent xla(1/5, valuelabel labs(vsmall)) discrete ylabel(0(5)40,grid) ytitle("Number of Responses (%)") xtitle("Support for Bailout (SPD)",height(8))
graph export bailout_spd.eps, replace
hist supportfinance if partyID_DE=="BÙndnis 90/Die GrÙnen" & refugee==0, scheme(s1mono) xscale(range(1/5) noextend) percent xla(1/5, valuelabel labs(vsmall)) discrete ylabel(0(5)40,grid) ytitle("Number of Responses (%)") xtitle("Support for Bailout (Greens)",height(8))
graph export bailout_greens.eps, replace
hist supportfinance if partyID_DE=="FDP" & refugee==0, scheme(s1mono) xscale(range(1/5) noextend) percent xla(1/5, valuelabel labs(vsmall)) discrete ylabel(0(5)40,grid) ytitle("Number of Responses (%)") xtitle("Support for Bailout (FDP)",height(8))
graph export bailout_fdp.eps, replace
hist supportfinance if partyID_DE=="AfD" & refugee==0, scheme(s1mono) xscale(range(1/5) noextend) percent xla(1/5, valuelabel labs(vsmall)) discrete ylabel(0(5)40,grid) ytitle("Number of Responses (%)") xtitle("Support for Bailout (AfD)",height(8))
graph export bailout_afd.eps, replace


reg support_c i.defense i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==1 & refugee==0 & partyID_DE!="AfD"  [pweight=_webal],  vce(cluster uniqueID) 
estimates store m1

reg support_c i.defense i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==0 & refugee==0 & partyID_DE!="AfD" [pweight=_webal],  vce(cluster uniqueID) 
estimates store m2


reg support_c i.defense i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==1  & refugee==1 & partyID_DE!="AfD" [pweight=_webal],  vce(cluster uniqueID) 
estimates store m3

reg support_c i.defense i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==0  & refugee==1 & partyID_DE!="AfD" [pweight=_webal],  vce(cluster uniqueID) 
estimates store m4


#delimit ;

coefplot (m1, label(Voters with policy position similar to politician's)) (m2, label(Voters with policy position different from politician's)), bylabel(Bailout)
|| (m3, label(Voters with policy position similar to politician's)) (m4, label(Voters with policy position different from politician's)), bylabel(Refugees)
 ||,  drop(_cons) level(90) ///
scheme(s1mono) xline(0,lpattern(dash) lcolor(gray)) ylabel(,labsize(small)) legend(size(small)) xtitle("Change in the probability of voting for the politician",size(vsmall)) ///
headings(1.defense = "{bf:Public Commitment}" 1.position_c = "{bf:Position}" 1.vote_c = "{bf:Vote}" 1.outcome_c = "{bf:Outcome}"  ///
1.party_sim = "{bf:Partisanship}" 1.gender_sim = "{bf:Gender}" 2.experience_c = "{bf:Experience}",labsize(small))
byopts(xrescale) legend(rows(2));
#delimit cr

graph export appendixL.eps, replace

/**************
**Appendix M**
**************/


reg support_c i.defense i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==1 & refugee==0 [pweight=_webal],  vce(cluster uniqueID) 
estimates store m1

reg support_c i.defense i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==0 & refugee==0 [pweight=_webal],  vce(cluster uniqueID) 
estimates store m2


reg support_c i.defense i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==1  & refugee==1 [pweight=_webal],  vce(cluster uniqueID) 
estimates store m3

reg support_c i.defense i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==0  & refugee==1 [pweight=_webal],  vce(cluster uniqueID) 
estimates store m4

#delimit ;

esttab m1 m2 m3 m4 using appendixM.tex, replace modelwidth(10) addnote("Standard errors in parentheses") 
 starlevels(* 0.10 ** 0.05) mlabel("Responsive" "Nonresponsive" "Responsive" "Nonresponsive") 
legend cells(b(star fmt(3)) se(par)) stats(N, labels("Observations") )
label varwidth(30)  collabels(none);
#delimit cr

/**************
**Appendix N**
**************/

reg support_c  i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c  if supportfinance<4 & refugee==0 [pweight=_webal],  vce(cluster uniqueID) 
estimates store m1

reg support_c i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if supportfinance>3 & refugee==0 [pweight=_webal],  vce(cluster uniqueID) 
estimates store m2


reg support_c  i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if supportimmigration<4  & refugee==1 [pweight=_webal],  vce(cluster uniqueID) 
estimates store m3

reg support_c  i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if supportimmigration>3 & refugee==1 [pweight=_webal],  vce(cluster uniqueID) 
estimates store m4

#delimit ;

coefplot (m1, label(Voters in favor of the policy)) (m2, label(Voters opposed to the policy)), bylabel(Bailout)
|| (m3, label(Voters in favor of the policy)) (m4, label(Voters opposed to the policy)), bylabel(Refugees)
 ||,  drop(_cons) level(90) ///
scheme(s1mono) xline(0,lpattern(dash) lcolor(gray)) ylabel(,labsize(small)) legend(size(small)) xtitle("Change in the probability of voting for the politician",size(vsmall)) ///
headings(1.position_c = "{bf:Position}" 1.vote_c = "{bf:Vote}" 1.outcome_c = "{bf:Outcome}"  ///
1.party_sim = "{bf:Partisanship}" 1.gender_sim = "{bf:Gender}" 2.experience_c = "{bf:Experience}",labsize(small))
byopts(xrescale) legend(rows(2));
#delimit cr

graph export appendixN.eps, replace

/**************
**Appendix O**
**************/

label define complb 1 "yes" 2 "no"
label values  competence_ind complb 


reg support_c i.defense i.competence_ind i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==1 & refugee==0 [pweight=_webal],  vce(cluster uniqueID) 
estimates store m1

reg support_c i.defense i.competence_ind i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==0 & refugee==0 [pweight=_webal],  vce(cluster uniqueID) 
estimates store m2


reg support_c i.defense i.competence_ind i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==1  & refugee==1 [pweight=_webal],  vce(cluster uniqueID) 
estimates store m3

reg support_c i.defense i.competence_ind i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==0  & refugee==1 [pweight=_webal],  vce(cluster uniqueID) 
estimates store m4


#delimit ;

coefplot (m1, label(Voters with policy position similar politician's)) (m2, label(Voters with policy position different from politician's)), bylabel(Bailout)
||  (m3, label(Voters with policy position similar politician's)) (m4, label(Voters with policy position different from politician's)), bylabel(Refugees)
||,  drop(_cons) level(90) ///
scheme(s1mono) xline(0,lpattern(dash) lcolor(gray)) ylabel(,labsize(small)) legend(size(small)) xtitle("Change in the probability of voting for the politician",size(vsmall)) ///
headings(1.defense = "{bf:Public Commitment}" 1.competence_ind = "{bf: Success}" 1.position_c = "{bf:Position}" 1.vote_c = "{bf:Vote}" 1.outcome_c = "{bf:Outcome}"  ///
1.party_sim = "{bf:Partisanship}" 1.gender_sim = "{bf:Gender}" 2.experience_c = "{bf:Experience}",labsize(small))
byopts(xrescale) legend(rows(2));
#delimit cr

graph export appendixO-1.eps, replace


reg support_c i.defense i.competence_ind1 i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==1 & refugee==0 [pweight=_webal],  vce(cluster uniqueID) 
estimates store m1

reg support_c i.defense i.competence_ind1 i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==0 & refugee==0 [pweight=_webal] ,  vce(cluster uniqueID) 
estimates store m2


reg support_c i.defense i.competence_ind1 i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==1  & refugee==1 [pweight=_webal],  vce(cluster uniqueID) 
estimates store m3

reg support_c i.defense i.competence_ind1 i.position_c i.vote_c i.outcome_c i.party_sim i.gender_sim i.experience_c if similarity_pos==0  & refugee==1 [pweight=_webal],  vce(cluster uniqueID) 
estimates store m4


#delimit ;

coefplot (m1, label(Voters with policy position similar politician's)) (m2, label(Voters with policy position different from politician's)), bylabel(Bailout)
||  (m3, label(Voters with policy position similar politician's)) (m4, label(Voters with policy position different from politician's)), bylabel(Refugees)
||,  drop(_cons) level(90) ///
scheme(s1mono) xline(0,lpattern(dash) lcolor(gray)) ylabel(,labsize(small)) legend(size(small)) xtitle("Change in the probability of voting for the politician",size(vsmall)) ///
headings(1.defense = "{bf:Public Commitment}" 1.competence_ind1 = "{bf:Success}" 1.position_c = "{bf:Position}" 1.vote_c = "{bf:Vote}" 1.outcome_c = "{bf:Outcome}"  ///
1.party_sim = "{bf:Partisanship}" 1.gender_sim = "{bf:Gender}" 2.experience_c = "{bf:Experience}",labsize(small))
byopts(xrescale) legend(rows(2));
#delimit cr

graph export appendixO-2.eps, replace
			
log close
exit
