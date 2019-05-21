/*****************************************************
**01_CoreAnalysisFile.do
**This performs all of the analysis that appears in the text of 
**"Institutional Sources of Legitimate Authority: An Experimental Investigation"
**Dickson, Gordon, Huber. AJPS, 2014.
**Input: sourcedata\merged_individualleveldata.dta
**Output: Tables 1-4, Figures 1-8, additional analysis and auxiliary figures, output\01_CoreAnalysis.log
**Last Updated: February 26, 2014
******************************************************/


set more off

local outputlocation="Output\"
log using "`outputlocation'01_CoreAnalysis.log", replace

*include SubProgram_LoadAndPreProcessIndividualFiles.do	
*clear

/************* Create Figure 1, Panels A and B, Group History Graphs, Full Info ******************/

clear
use "sourcedata\Merged_individualleveldata.dta"

keep if isenforcer==1
sort group period
replace gptext=subinstr(gptext,"No Info","Lim. Info",.) if treatment>4

#delimit ;
twoway (line g_totcontributedtopg period, ytitle("Total # Contributed to Public Good in Period", size(vsmall)))
(scatter g_assistorhinder period if g_legitenfo==1 & g_punishsuccess==1, mcolor(black) msymbol(triangle) yaxis(2) ytitle("Alt?", size(vsmall) axis(2)))
(scatter g_assistorhinder period if g_legitenfo==1 & g_punishsuccess==0, mcolor(black) msymbol(triangle_hollow) yaxis(2))
(scatter g_assistorhinder period if g_legitenfo==-1 & g_punishsuccess==1, mcolor(black) msymbol(square) yaxis(2))
(scatter g_assistorhinder period if g_legitenfo==-1 & g_punishsuccess==0, mcolor(black) msymbol(square_hollow) yaxis(2))
if id==5 & treatment == 1,
xtitle(, size(vsmall))
ylabel(0(1)4)
ylabel(, nogrid)
ylabel(-3(1)3, axis(2))
ylabel(, nogrid axis(2)) 
yline(0, lpattern(dash) lcolor(black) axis(2))
scheme(s1mono)
by(gptext, legend(off) imargin(vsmall) iscale(*.60) cols(4) note("") caption(""))
name(Fig1Top_salary_fullinfo_data, replace)
subtitle(, box fcolor(none));

graph export "`outputlocation'Figure1_TopPanel.pdf", replace;

twoway (line g_totcontributedtopg period, ytitle("Total # Contributed to Public Good in Period", size(vsmall)))
(scatter g_assistorhinder period if g_legitenfo==1 & g_punishsuccess==1, mcolor(black) msymbol(triangle) yaxis(2) ytitle("Alt?", size(vsmall) axis(2)))
(scatter g_assistorhinder period if g_legitenfo==1 & g_punishsuccess==0, mcolor(black) msymbol(triangle_hollow) yaxis(2))
(scatter g_assistorhinder period if g_legitenfo==-1 & g_punishsuccess==1, mcolor(black) msymbol(square) yaxis(2))
(scatter g_assistorhinder period if g_legitenfo==-1 & g_punishsuccess==0, mcolor(black) msymbol(square_hollow) yaxis(2))
if id==5 & treatment == 2,
xtitle(, size(vsmall))
ylabel(0(1)4)
ylabel(, nogrid)
ylabel(-3(1)3, axis(2))
ylabel(, nogrid axis(2)) 
yline(0, lpattern(dash) lcolor(black) axis(2))
scheme(s1mono)
by(gptext, legend(off) imargin(vsmall) iscale(*.60) cols(4) note("") caption(""))
name(Fig1Bottom_approp_fullinfo_data, replace)
subtitle(, box fcolor(none));

graph export "`outputlocation'Figure1_BottomPanel.pdf", replace;
# delimit cr

/***************** Create Tables 1 and 3, First Order Resoluteness and Predation Incentives, Full and Limited Info ******************/

clear
use "sourcedata\Merged_individualleveldata.dta"

* isfarm is defined only for full info salary and appropriation
label var isfarm "Appropriations Treament (1=yes, 0=Salary)"
label values isfarm isfarmbinary

* salary_noinfo is defined only for full and no info salary
label var salary_noinfo "Salary, Full (0) No Info (1)"

* Only keep full info salary and appropriation treatments
* Get rid of all instances in which there was ever illegitimate enforcement

*Resoluteness and predation at the enforcer-period level
keep if isenforcer == 1
drop if g_legitenfo == -1 & g_totcontributedtopg<4
gen approp = (treatment == 2 | treatment == 6)
gen fullcont = g_totcontrib==4
matrix res = J(6,11,.)
ttest e_anyenforce if fullcont == 0 & (treatment ==1 | treatment == 2), by(treatment) unequal
matrix res[1,1]=r(mu_1)
matrix res[1,3]=r(mu_2)
matrix res[1,5]=r(mu_2)-r(mu_1)
matrix res[2,1]=r(sd_1)/sqrt(r(N_1))
matrix res[2,3]=r(sd_2)/sqrt(r(N_2))
matrix res[2,5]=r(se)
ttest e_anyenforce if fullcont == 1 & (treatment ==1 | treatment == 2), by(treatment) unequal
matrix res[1,7]=r(mu_1)
matrix res[1,9]=r(mu_2)
matrix res[1,11]=r(mu_2)-r(mu_1)
matrix res[2,7]=r(sd_1)/sqrt(r(N_1))
matrix res[2,9]=r(sd_2)/sqrt(r(N_2))
matrix res[2,11]=r(se)
ttest e_anyenforce if fullcont == 0 & (treatment ==5 | treatment == 6), by(treatment) unequal
matrix res[3,1]=r(mu_1)
matrix res[3,3]=r(mu_2)
matrix res[3,5]=r(mu_2)-r(mu_1)
matrix res[4,1]=r(sd_1)/sqrt(r(N_1))
matrix res[4,3]=r(sd_2)/sqrt(r(N_2))
matrix res[4,5]=r(se)
ttest e_anyenforce if fullcont == 1 & (treatment ==5 | treatment == 6), by(treatment) unequal
matrix res[3,7]=r(mu_1)
matrix res[3,9]=r(mu_2)
matrix res[3,11]=r(mu_2)-r(mu_1)
matrix res[4,7]=r(sd_1)/sqrt(r(N_1))
matrix res[4,9]=r(sd_2)/sqrt(r(N_2))
matrix res[4,11]=r(se)
ttest e_anyenforce if fullcont == 0, by(approp) unequal
matrix res[5,1]=r(mu_1)
matrix res[5,3]=r(mu_2)
matrix res[5,5]=r(mu_2)-r(mu_1)
matrix res[6,1]=r(sd_1)/sqrt(r(N_1))
matrix res[6,3]=r(sd_2)/sqrt(r(N_2))
matrix res[6,5]=r(se)
ttest e_anyenforce if fullcont == 1, by(approp) unequal
matrix res[5,7]=r(mu_1)
matrix res[5,9]=r(mu_2)
matrix res[5,11]=r(mu_2)-r(mu_1)
matrix res[6,7]=r(sd_1)/sqrt(r(N_1))
matrix res[6,9]=r(sd_2)/sqrt(r(N_2))
matrix res[6,11]=r(se)
svmat res
outsheet res1-res11 using "`outputlocation'Table1_res_and_pred_FullInfo.csv" in 1/2, comma nonames replace
outsheet res1-res11 using "`outputlocation'Table3_res_and_pred_LimitedInfo.csv" in 3/4, comma nonames replace

/************************************ Figure 2, Deterrence Effects, Full Info ****************/

clear
use "sourcedata\Merged_individualleveldata.dta"

*Generate deterrence measure: Pr(enforcement|noncontribution)-Pr(enforcement|contribution)
keep if isenforcer==1
sort group period
gen g_notcontributedtopg = 4-g_totcontributedtopg
gen g_tot_legitenfo = g_punishsuccess==1 & g_targetcont==0
gen g_tot_illegitenfo=g_punishsuccess==1 & g_targetcont==1
by group: gen lag_totcontrib = sum(g_totcontributedtopg)-g_totcontributedtopg
by group: gen lag_notcontrib = sum(g_notcontributedtopg)-g_notcontributedtopg
by group: gen lag_totlegitenfo = sum(g_tot_legitenfo)-g_tot_legitenfo
by group: gen lag_totillegitenfo = sum(g_tot_illegitenfo)-g_tot_illegitenfo

keep group period g_totcontributedtopg g_notcontributedtopg- lag_totillegitenfo treatment
drop if period == 1
gen deterrence = lag_totlegitenfo/lag_notcontrib-lag_totillegitenfo/lag_totcontrib

#delimit;
gen gp=g_totcontributedtopg+0.1;
gen gm=g_totcontributedtopg-0.1;
twoway (lpolyci g_totcontributedtopg deterrence if treatment==2, lwidth(medthick) lpattern(solid) lcolor(white) ciplot(rline) blcolor(white) blpattern(dash))
       (lpolyci g_totcontributedtopg deterrence if treatment==1, lwidth(medthick) lpattern(solid) lcolor(black) ciplot(rline) blcolor(black) blpattern(dash))
       (scatter gp deterrence if treatment==1, mcolor(black)  msize(small) msymbol(circle) jitter(3))
       (scatter gm deterrence if treatment==2,mcolor(black) mfcolor(white) msize(small) msymbol(circle) jitter(3))
,
legend(order(5 6) label(5 "Salary") label(6 "Appropriation"))
/*y-axis options*/
ytitle("Contributions", margin(zero) alignment(bottom)) 
yscale(titlegap(2) outergap(0)) 
ylabel(, labsize(small) labgap(tiny) nogrid)
/*x-axis options*/
xtitle("Lagged Deterrence Index", alignment(bottom)) 
xscale(titlegap(2) outergap(0)) 
xlabel(0(0.25)1, labsize(small) labgap(small) nogrid) 
/*General*/
xsize(2.5) ysize(2.5) 
aspectratio(.75) 
graphregion(margin(small) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) 
plotregion(margin(small) fcolor(gs13) lcolor(gs13) ifcolor(gs13) ilcolor(gs13))
yline(0 1 2 3 4, lcolor(white) lwidth(vvthin))
xline(0 .25 .5 .75 1, lcolor(white) lwidth(vvthin))
name(Fig2_pure_deterrence_fullinfo, replace);
drop gp gm;
#delimit cr

graph export "`outputlocation'Figure2_pure_deterrence_fullinfo.pdf", replace

qui tab period, gen(pd_)
xtreg g_totcontributedtopg deterrence pd_* if treatment < 3, fe i(group)


/*********************************** Figure 3 Contribution Rates in the Full Information Setting****************/

clear
use "sourcedata\Merged_individualleveldata.dta"
keep if isenforcer==1

#delimit;
gen gp=g_totcontributedtopg+0.1;
gen gm=g_totcontributedtopg-0.1;
twoway (lpolyci g_totcontributedtopg period if treatment==2, lwidth(medthick) lpattern(solid) lcolor(white) ciplot(rline) blcolor(white) blpattern(dash))
       (lpolyci g_totcontributedtopg period if treatment==1, lwidth(medthick) lpattern(solid) lcolor(black) ciplot(rline) blcolor(black) blpattern(dash))
       (scatter gp period if treatment==1, mcolor(black)  msize(small) msymbol(circle) jitter(3))
       (scatter gm period if treatment==2,mcolor(black) mfcolor(white) msize(small) msymbol(circle) jitter(3))
,
legend(order(5 6) label(5 "Salary") label(6 "Appropriation"))
/*y-axis options*/
ytitle("Contributions", margin(zero) alignment(bottom)) 
yscale(titlegap(2) outergap(0)) 
ylabel(, labsize(small) labgap(tiny) nogrid)
/*x-axis options*/
xtitle("Period", alignment(bottom)) 
xscale(titlegap(2) outergap(0)) 
xlabel(1 5 10 15 20, labsize(small) labgap(small) nogrid) 
/*General*/
xsize(2.5) ysize(2.5) 
aspectratio(.75) 
graphregion(margin(small) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) 
plotregion(margin(small) fcolor(gs13) lcolor(gs13) ifcolor(gs13) ilcolor(gs13))
yline(0 1 2 3 4, lcolor(white) lwidth(vvthin))
xline(5 10 15 20, lcolor(white) lwidth(vvthin))
name(Fig3_contrib_full, replace);
drop gp gm;
#delimit cr

graph export "`outputlocation'Figure3_contrib_full.pdf", replace

bysort period: ttest g_totcontributed if treatment<3, by(treatment) unequal
ttest g_totcontributed if treatment < 3, by(treatment) unequal

reg g_totcontributed treatment if treatment <3, cluster(group)
reg g_totcontributed treatment pd_* if treatment <3, cluster(group)
collapse (mean) g_totcontributedtopg treatment if treatment < 3, by(group)
ttest g_totcontributed if treatment < 3, by(treatment) unequal


/******************Figure 4, Help/Hinder Graphs, Full Info **********************/
clear
use "sourcedata\Merged_individualleveldata.dta"
keep if isenforcer==1

#delimit;
twoway (lpolyci g_assistorhinder period if treatment==2, lwidth(medthick) lpattern(solid) lcolor(white) ciplot(rline) blcolor(white) blpattern(dash))
       (lpolyci g_assistorhinder period if treatment==1, lwidth(medthick) lpattern(solid) lcolor(black) ciplot(rline) blcolor(black) blpattern(dash))
       (scatter g_assistorhinder period if treatment==1, mcolor(black)  msize(small) msymbol(circle) jitter(3))
       (scatter g_assistorhinder period if treatment==2,mcolor(black) mfcolor(white) msize(small) msymbol(circle) jitter(3))
,
legend(order(5 6) label(5 "Salary") label(6 "Appropriation"))
/*y-axis options*/
ytitle("Net Assistance (Assist-Hinder)", margin(zero) alignment(bottom)) 
yscale(titlegap(2) outergap(0)) 
ylabel(-3(1)3, labsize(small) labgap(tiny) nogrid)
/*x-axis options*/
xtitle("Period", alignment(bottom)) 
xscale(titlegap(2) outergap(0)) 
xlabel(1 5 10 15 20, labsize(small) labgap(small) nogrid) 
/*General*/
xsize(2.5) ysize(2.5) 
aspectratio(.75) 
graphregion(margin(small) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) 
plotregion(margin(small) fcolor(gs13) lcolor(gs13) ifcolor(gs13) ilcolor(gs13))
yline(-3 -2 -1 0 1 2 3, lcolor(white) lwidth(vvthin))
xline(1 5 10 15 20, lcolor(white) lwidth(vvthin))
name(Fig4Left_helphinderpart1_full, replace)
;

twoway (lpolyci g_assistorhinder g_avglagcontpg if treatment==2, lwidth(medthick) lpattern(solid) lcolor(white) ciplot(rline) blcolor(white) blpattern(dash))
       (lpolyci g_assistorhinder g_avglagcontpg if treatment==1, lwidth(medthick) lpattern(solid) lcolor(black) ciplot(rline) blcolor(black) blpattern(dash))
       (scatter g_assistorhinder g_avglagcontpg if treatment==1, mcolor(black)  msize(small) msymbol(circle) jitter(3))
       (scatter g_assistorhinder g_avglagcontpg if treatment==2,mcolor(black) mfcolor(white) msize(small) msymbol(circle) jitter(3))
,
legend(order(5 6) label(5 "Salary") label(6 "Appropriation"))
/*y-axis options*/
ytitle("", margin(zero) alignment(bottom)) 
yscale(titlegap(2) outergap(0)) 
ylabel(-3(1)3, labsize(small) labgap(tiny) nogrid)
/*x-axis options*/
xtitle("Average Previous Contributions", alignment(bottom)) 
xscale(titlegap(2) outergap(0)) 
xlabel(0(1)4, labsize(small) labgap(small) nogrid) 
/*General*/
xsize(2.5) ysize(2.5) 
aspectratio(.75) 
graphregion(margin(small) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) 
plotregion(margin(small) fcolor(gs13) lcolor(gs13) ifcolor(gs13) ilcolor(gs13))
yline(-3 -2 -1 0 1 2 3, lcolor(white) lwidth(vvthin))
xline(0 1 2 3 4, lcolor(white) lwidth(vvthin))
name(Fig4Right_helphinderpart2_full, replace)
;

#delimit;
grc1leg Fig4Left_helphinderpart1_full Fig4Right_helphinderpart2_full, imargin(zero) graphregion(margin(zero) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) 
plotregion(margin(zero) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) name(Fig4_helphinderpartcombined_full, replace) position(6) xsize(5) ysize(3);
#delimit;
graph export "`outputlocation'Figure4_helphinderpartcombined_full.pdf", replace;
#delimit cr

/********************* Table 2, Regressions for Confirm Summary/graphical main analysis, Full Info *********************/

clear
use "sourcedata\Merged_individualleveldata.dta"
keep if isenforcer==1
sort group period

matrix results = J(10,6,.)

regress g_assistorhinder isfarm i.period if isenforcer==1, cluster(group)
matrix b1 = e(b)
matrix V1=e(V)
matrix results[1,1]=b1[1,1]
matrix results[2,1]=sqrt(V1[1,1])
matrix results[9,1]=e(r2)
matrix results[10,1]=e(N)

regress g_assistorhinder isfarm g_avglagcontpg g_lagresolute g_lagpropbadtargeting i.period if isenforcer==1, cluster(group)
matrix b1 = e(b)
matrix V1=e(V)
matrix results[1,2]=b1[1,1]
matrix results[2,2]=sqrt(V1[1,1])
matrix results[3,2]=b1[1,2]
matrix results[4,2]=sqrt(V1[2,2])
matrix results[5,2]=b1[1,3]
matrix results[6,2]=sqrt(V1[3,3])
matrix results[7,2]=b1[1,4]
matrix results[8,2]=sqrt(V1[4,4])
matrix results[9,2]=e(r2)
matrix results[10,2]=e(N)

/*Alternative Explanation: Alienation due to bad enforcer behavior*/
regress g_assistorhinder isfarm i.period if g_legitenfo ==1 & g_cum_anyillegittargeting==0, cluster(group)
matrix b1 = e(b)
matrix V1=e(V)
matrix results[1,3]=b1[1,1]
matrix results[2,3]=sqrt(V1[1,1])
matrix results[9,3]=e(r2)
matrix results[10,3]=e(N)

regress g_assistorhinder isfarm g_avglagcontpg g_lagresolute i.period if g_legitenfo ==1 & g_cum_anyillegittargeting==0, cluster(group)
matrix b1 = e(b)
matrix V1=e(V)
matrix results[1,4]=b1[1,1]
matrix results[2,4]=sqrt(V1[1,1])
matrix results[3,4]=b1[1,2]
matrix results[4,4]=sqrt(V1[2,2])
matrix results[5,4]=b1[1,3]
matrix results[6,4]=sqrt(V1[3,3])
matrix results[9,4]=e(r2)
matrix results[10,4]=e(N)

*These regressions aren't in the table, but they show that even if we fix lagged resoluteness at 1 (never failing to target given NC), we still find big effects.
regress g_assistorhinder isfarm i.period if g_legitenfo ==1 & g_cum_anyillegittargeting==0 & g_lagresolute==1, cluster(group)
regress g_assistorhinder isfarm g_avglagcontpg g_lagresolute i.period if g_legitenfo ==1 & g_cum_anyillegittargeting==0 & g_lagresolute==1, cluster(group)

/*Alternative Explanation: Citizens in salary treatment are substituting for irresolute enforcement*/
regress g_assistorhinder g_avglagcontpg g_lagresolute g_lagpropbadtargeting  i.period if isfarm == 0
matrix b1 = e(b)
matrix V1=e(V)
matrix results[3,5]=b1[1,1]
matrix results[4,5]=sqrt(V1[1,1])
matrix results[5,5]=b1[1,2]
matrix results[6,5]=sqrt(V1[2,2])
matrix results[7,5]=b1[1,3]
matrix results[8,5]=sqrt(V1[3,3])
matrix results[9,5]=e(r2)
matrix results[10,5]=e(N)

regress g_assistorhinder g_avglagcontpg g_lagresolute g_lagpropbadtargeting  i.period if isfarm == 1 
matrix b1 = e(b)
matrix V1=e(V)
matrix results[3,6]=b1[1,1]
matrix results[4,6]=sqrt(V1[1,1])
matrix results[5,6]=b1[1,2]
matrix results[6,6]=sqrt(V1[2,2])
matrix results[7,6]=b1[1,3]
matrix results[8,6]=sqrt(V1[3,3])
matrix results[9,6]=e(r2)
matrix results[10,6]=e(N)

svmat results
outsheet results1-results6 in 1/10 using "`outputlocation'Table02_full_info_regressions.csv", comma names replace

/************* Figure 5, Group History Graphs, Limited Info ******************/

clear
use "sourcedata\Merged_individualleveldata.dta"

keep if isenforcer==1
sort group period
replace gptext=subinstr(gptext,"No Info","Lim. Info",.) if treatment>4

#delimit ;
twoway (line g_totcontributedtopg period, ytitle("Total # Contributed to Public Good in Period", size(vsmall)))
(scatter g_assistorhinder period if g_legitenfo==1 & g_punishsuccess==1, mcolor(black) msymbol(triangle) yaxis(2) ytitle("Alt?", size(vsmall) axis(2)))
(scatter g_assistorhinder period if g_legitenfo==1 & g_punishsuccess==0, mcolor(black) msymbol(triangle_hollow) yaxis(2))
(scatter g_assistorhinder period if g_legitenfo==-1 & g_punishsuccess==1, mcolor(black) msymbol(square) yaxis(2))
(scatter g_assistorhinder period if g_legitenfo==-1 & g_punishsuccess==0, mcolor(black) msymbol(square_hollow) yaxis(2))
if id==5 & treatment == 5,
xtitle(, size(vsmall))
ylabel(0(1)4)
ylabel(, nogrid)
ylabel(-3(1)3, axis(2))
ylabel(, nogrid axis(2)) 
yline(0, lpattern(dash) lcolor(black) axis(2))
scheme(s1mono)
by(gptext, legend(off) imargin(vsmall) iscale(*.60) cols(4) note("") caption(""))
name(Fig5Top_salary_liminfo_data, replace)
subtitle(, box fcolor(none));

graph export "`outputlocation'Figure5_TopPanel.pdf", replace;

twoway (line g_totcontributedtopg period, ytitle("Total # Contributed to Public Good in Period", size(vsmall)))
(scatter g_assistorhinder period if g_legitenfo==1 & g_punishsuccess==1, mcolor(black) msymbol(triangle) yaxis(2) ytitle("Alt?", size(vsmall) axis(2)))
(scatter g_assistorhinder period if g_legitenfo==1 & g_punishsuccess==0, mcolor(black) msymbol(triangle_hollow) yaxis(2))
(scatter g_assistorhinder period if g_legitenfo==-1 & g_punishsuccess==1, mcolor(black) msymbol(square) yaxis(2))
(scatter g_assistorhinder period if g_legitenfo==-1 & g_punishsuccess==0, mcolor(black) msymbol(square_hollow) yaxis(2))
if id==5 & treatment == 6,
xtitle(, size(vsmall))
ylabel(0(1)4)
ylabel(, nogrid)
ylabel(-3(1)3, axis(2))
ylabel(, nogrid axis(2)) 
yline(0, lpattern(dash) lcolor(black) axis(2))
scheme(s1mono)
by(gptext, legend(off) imargin(vsmall) iscale(*.60) cols(4) note("") caption(""))
name(Fig5Bottom_approp_liminfo_data, replace)
subtitle(, box fcolor(none));

graph export "`outputlocation'Figure5_BottomPanel.pdf", replace;
# delimit cr

/************************************ Figure 6, Deterrence Effects -- Limited Info ****************/

clear
use "sourcedata\Merged_individualleveldata.dta"

*Generate deterrence measure: Pr(enforcement|noncontribution)-Pr(enforcement|contribution)
keep if isenforcer==1
sort group period
gen g_notcontributedtopg = 4-g_totcontributedtopg
gen g_tot_legitenfo = g_punishsuccess==1 & g_targetcont==0
gen g_tot_illegitenfo=g_punishsuccess==1 & g_targetcont==1
by group: gen lag_totcontrib = sum(g_totcontributedtopg)-g_totcontributedtopg
by group: gen lag_notcontrib = sum(g_notcontributedtopg)-g_notcontributedtopg
by group: gen lag_totlegitenfo = sum(g_tot_legitenfo)-g_tot_legitenfo
by group: gen lag_totillegitenfo = sum(g_tot_illegitenfo)-g_tot_illegitenfo

keep group period g_totcontributedtopg g_notcontributedtopg- lag_totillegitenfo treatment
drop if period == 1
gen deterrence = lag_totlegitenfo/lag_notcontrib-lag_totillegitenfo/lag_totcontrib

#delimit;
gen gp=g_totcontributedtopg+0.1;
gen gm=g_totcontributedtopg-0.1;
twoway (lpolyci g_totcontributedtopg deterrence if treatment==6, lwidth(medthick) lpattern(solid) lcolor(white) ciplot(rline) blcolor(white) blpattern(dash))
       (lpolyci g_totcontributedtopg deterrence if treatment==5, lwidth(medthick) lpattern(solid) lcolor(black) ciplot(rline) blcolor(black) blpattern(dash))
       (scatter gp deterrence if treatment==5, mcolor(black)  msize(small) msymbol(circle) jitter(3))
       (scatter gm deterrence if treatment==6, mcolor(black) mfcolor(white) msize(small) msymbol(circle) jitter(3))
,
legend(order(5 6) label(5 "Salary") label(6 "Appropriation"))
/*y-axis options*/
ytitle("Contributions", margin(zero) alignment(bottom)) 
yscale(titlegap(2) outergap(0)) 
ylabel(, labsize(small) labgap(tiny) nogrid)
/*x-axis options*/
xtitle("Lagged Deterrence Index", alignment(bottom)) 
xscale(titlegap(2) outergap(0)) 
xlabel(-.25(0.25)1, labsize(small) labgap(small) nogrid) 
/*General*/
xsize(2.5) ysize(2.5) 
aspectratio(.75) 
graphregion(margin(small) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) 
plotregion(margin(small) fcolor(gs13) lcolor(gs13) ifcolor(gs13) ilcolor(gs13))
yline(0 1 2 3 4, lcolor(white) lwidth(vvthin))
xline(-.25 0 .25 .5 .75 1, lcolor(white) lwidth(vvthin))
name(Fig6_pure_deterrence_liminfo, replace);
drop gp gm;
#delimit cr

graph export "`outputlocation'Figure6_pure_deterrence_liminfo.pdf", replace

qui tab period, gen(pd_)
xtreg g_totcontributedtopg deterrence pd_* if treatment == 5 | treatment==6, fe i(group)

/***********************************Figure 7, Contribution Rates in the Limited Information Setting****************/

clear
use "sourcedata\Merged_individualleveldata.dta"
keep if isenforcer==1

#delimit;
gen gp=g_totcontributedtopg+0.1;
gen gm=g_totcontributedtopg-0.1;
twoway (lpolyci g_totcontributedtopg period if treatment==6, lwidth(medthick) lpattern(solid) lcolor(white) ciplot(rline) blcolor(white) blpattern(dash))
       (lpolyci g_totcontributedtopg period if treatment==5, lwidth(medthick) lpattern(solid) lcolor(black) ciplot(rline) blcolor(black) blpattern(dash))
       (scatter gp period if treatment==5, mcolor(black)  msize(small) msymbol(circle) jitter(3))
       (scatter gm period if treatment==6,mcolor(black) mfcolor(white) msize(small) msymbol(circle) jitter(3))
,
legend(order(5 6) label(5 "Salary") label(6 "Appropriation"))
/*y-axis options*/
ytitle("Contributions", margin(zero) alignment(bottom)) 
yscale(titlegap(2) outergap(0)) 
ylabel(, labsize(small) labgap(tiny) nogrid)
/*x-axis options*/
xtitle("Period", alignment(bottom)) 
xscale(titlegap(2) outergap(0)) 
xlabel(1 5 10 15 20, labsize(small) labgap(small) nogrid) 
/*General*/
xsize(2.5) ysize(2.5) 
aspectratio(.75) 
graphregion(margin(small) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) 
plotregion(margin(small) fcolor(gs13) lcolor(gs13) ifcolor(gs13) ilcolor(gs13))
yline(0 1 2 3 4, lcolor(white) lwidth(vvthin))
xline(5 10 15 20, lcolor(white) lwidth(vvthin))
name(Fig7_contrib_lim, replace);
drop gp gm;
#delimit cr

graph export "`outputlocation'Figure7_contrib_lim.pdf", replace

bysort period: ttest g_totcontributed if treatment==5 | treatment==6, by(treatment) unequal
ttest g_totcontributed if treatment==5 | treatment==6, by(treatment) unequal

reg g_totcontributed treatment if treatment==5 | treatment==6, cluster(group)
reg g_totcontributed treatment pd_* if treatment==5 | treatment==63, cluster(group)
collapse (mean) g_totcontributedtopg treatment if treatment==5 | treatment==6, by(group)
ttest g_totcontributed if treatment==5 | treatment==6, by(treatment) unequal

/******************Figure 8, Recreate Help/Hinder Graphs Limited Info **********************/

clear
use "sourcedata\Merged_individualleveldata.dta"
keep if isenforcer==1

#delimit;
twoway (lpolyci g_assistorhinder period if treatment==6, lwidth(medthick) lpattern(solid) lcolor(white) ciplot(rline) blcolor(white) blpattern(dash))
       (lpolyci g_assistorhinder period if treatment==5, lwidth(medthick) lpattern(solid) lcolor(black) ciplot(rline) blcolor(black) blpattern(dash))
       (scatter g_assistorhinder period if treatment==5, mcolor(black)  msize(small) msymbol(circle) jitter(3))
       (scatter g_assistorhinder period if treatment==6,mcolor(black) mfcolor(white) msize(small) msymbol(circle) jitter(3))
,
legend(order(5 6) label(5 "Salary") label(6 "Appropriation"))
/*y-axis options*/
ytitle("Net Assistance (Assist-Hinder)", margin(zero) alignment(bottom)) 
yscale(titlegap(2) outergap(0)) 
ylabel(-3(1)3, labsize(small) labgap(tiny) nogrid)
/*x-axis options*/
xtitle("Period", alignment(bottom)) 
xscale(titlegap(2) outergap(0)) 
xlabel(1 5 10 15 20, labsize(small) labgap(small) nogrid) 
/*General*/
xsize(2.5) ysize(2.5) 
aspectratio(.75) 
graphregion(margin(small) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) 
plotregion(margin(small) fcolor(gs13) lcolor(gs13) ifcolor(gs13) ilcolor(gs13))
yline(-3 -2 -1 0 1 2 3, lcolor(white) lwidth(vvthin))
xline(1 5 10 15 20, lcolor(white) lwidth(vvthin))
name(Fig8Left_helphinderpart1_lim, replace)
;

twoway (lpolyci g_assistorhinder g_avglagcontpg if treatment==6, lwidth(medthick) lpattern(solid) lcolor(white) ciplot(rline) blcolor(white) blpattern(dash))
       (lpolyci g_assistorhinder g_avglagcontpg if treatment==5, lwidth(medthick) lpattern(solid) lcolor(black) ciplot(rline) blcolor(black) blpattern(dash))
       (scatter g_assistorhinder g_avglagcontpg if treatment==5, mcolor(black)  msize(small) msymbol(circle) jitter(3))
       (scatter g_assistorhinder g_avglagcontpg if treatment==6,mcolor(black) mfcolor(white) msize(small) msymbol(circle) jitter(3))
,
legend(order(5 6) label(5 "Salary") label(6 "Appropriation"))
/*y-axis options*/
ytitle("", margin(zero) alignment(bottom)) 
yscale(titlegap(2) outergap(0)) 
ylabel(-3(1)3, labsize(small) labgap(tiny) nogrid)
/*x-axis options*/
xtitle("Average Previous Contributions", alignment(bottom)) 
xscale(titlegap(2) outergap(0)) 
xlabel(0(1)4, labsize(small) labgap(small) nogrid) 
/*General*/
xsize(2.5) ysize(2.5) 
aspectratio(.75) 
graphregion(margin(small) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) 
plotregion(margin(small) fcolor(gs13) lcolor(gs13) ifcolor(gs13) ilcolor(gs13))
yline(-3 -2 -1 0 1 2 3, lcolor(white) lwidth(vvthin))
xline(0 1 2 3 4, lcolor(white) lwidth(vvthin))
name(Fig8Right_helphinderpart2_lim, replace)
;

#delimit;
grc1leg Fig8Left_helphinderpart1_lim Fig8Right_helphinderpart2_lim, imargin(zero) graphregion(margin(zero) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) 
plotregion(margin(zero) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) name(helphinderpartcombined_lim, replace) position(6) xsize(5) ysize(3);
#delimit;
graph export "`outputlocation'Figure8_helphinderpartcombined_lim.pdf", replace;
#delimit cr

/*********************************** Table 4 Regressions for Confirm Summary/graphical main analysis, limited info case ********************************/

set more off
clear
use "sourcedata\Merged_individualleveldata.dta"
keep if isenforcer==1
sort group period

gen appropriation=(treatment==2 | treatment==6)
gen limitedinfo=(treatment==5 | treatment==6)

regress g_assistorhinder appropriation i.period if isenforcer==1 & (treatment==5 | treatment==6), cluster(group)
outreg using "`outputlocation'Table4_AdditionalRegressions.out", se tdec(3) bdec(3) replace

regress g_assistorhinder appropriation g_avglagcontpg g_lagresolute g_lagpropbadtargeting i.period if isenforcer==1 & (treatment==5 | treatment==6), cluster(group)
outreg using "`outputlocation'Table4_AdditionalRegressions.out", se tdec(3) bdec(3) append

*regress g_assistorhinder appropriation g_lagresolute g_lagpropbadtargeting i.period if isenforcer==1 & (treatment==5 | treatment==6) & g_cum_anyillegittargeting==0, cluster(group)

regress g_assistorhinder limitedinfo i.period if isenforcer==1 & (treatment==1 | treatment==5), cluster(group)
outreg using "`outputlocation'Table4_AdditionalRegressions.out", se tdec(3) bdec(3) append

regress g_assistorhinder limitedinfo g_avglagcontpg g_lagresolute g_lagpropbadtargeting i.period if isenforcer==1 & (treatment==1 | treatment==5), cluster(group)
outreg using "`outputlocation'Table4_AdditionalRegressions.out", se tdec(3) bdec(3) append

*regress g_assistorhinder limitedinfo g_avglagcontpg g_lagresolute g_lagpropbadtargeting i.period if isenforcer==1 & (treatment==1 | treatment==5) & g_cum_anyillegittargeting==0, cluster(group)

regress g_assistorhinder limitedinfo i.period if isenforcer==1 & (treatment==2 | treatment==6), cluster(group)
outreg using "`outputlocation'Table4_AdditionalRegressions.out", se tdec(3) bdec(3) append

regress g_assistorhinder limitedinfo g_avglagcontpg g_lagresolute g_lagpropbadtargeting i.period if isenforcer==1 & (treatment==2 | treatment==6), cluster(group)
outreg using "`outputlocation'Table4_AdditionalRegressions.out", se tdec(3) bdec(3) append

*regress g_assistorhinder limitedinfo g_avglagcontpg g_lagresolute g_lagpropbadtargeting i.period if isenforcer==1 & (treatment==2 | treatment==6) & g_cum_anyillegittargeting==0, cluster(group)


/*******************************************************************************************************************************************************************************************/

* Additional analysis, not in tables or figures

/*******************************************************************************************************************************************************************************************/

/*Summary descriptions of full info treatment case*/

* Rates of targeting contributors
clear
use "sourcedata\Merged_individualleveldata.dta"

keep if isenforcer
replace  g_targetcont=0 if  g_targetcont==.
collapse (max) maxt=g_targetcont (sum) sumt=g_targetcont, by(group treatment)
tab treatment maxt
tab treatment sumt if maxt>0

* Rates of perverse targeting. Note: can only have perverse targeting if neither everyone nor nobody contributed.
clear
use "sourcedata\Merged_individualleveldata.dta"
keep if isenforcer & (g_totcontributedtopg~=4 & g_totcontributedtopg~=0)
replace  g_targetcont=0 if  g_targetcont==.
tab treatment g_targetcont

* Counts of resoluteness and predation, excluding perverse
clear
use "sourcedata\Merged_individualleveldata.dta"
keep if isenforcer
* Get rid of perverse case
drop if (g_totcontributedtopg~=4 & g_totcontributedtopg~=0) & g_targetcont==1
* now tab resoluteness and predation
* Resoluteness
tab treatment g_anyenforcement if g_totcontributedtopg~=4, row
* Predation
tab treatment g_anyenforcement if g_totcontributedtopg==4, row

* Helping and hindering, conditional on guilt of target summary description
clear
use "sourcedata\Merged_individualleveldata.dta"
drop if isenforcer | p_istargeted

tab treatment p_assistorhinder if g_legitenfo==1 & (treatment==1 | treatment==2), row
tab treatment p_assistorhinder if g_legitenfo==-1 & (treatment==1 | treatment==2), row

/*
  Differences in helping/hindering accounting for period 1 contributions, full info

  This comparison is of differences in helping and hindering fixing period 1 group contributions and that quantity interacted with treatment
  We undertake this comparison to rule out differences in citizen types--as measured by period 1 contributions--as explaining differences in helping and hindering
*/

clear
use "sourcedata\Merged_individualleveldata.dta"
keep if isenforcer==1
sort group period

tab g_period1cont, gen(g1_)
gen isfarm1 = isfarm*g1_1
gen isfarm2 = isfarm*g1_2
gen isfarm3 = isfarm*g1_3
gen isfarm4 = isfarm*g1_4
gen sal1 = (1-isfarm)*g1_1
gen sal2 = (1-isfarm)*g1_2
gen sal3 = (1-isfarm)*g1_3
gen sal4 = (1-isfarm)*g1_4

regress g_assistorhinder sal1-sal4 isfarm1-isfarm4 i.period if isenforcer==1, cluster(group) nocons
matrix b = e(b)
matrix v = e(V)
matrix goodtypes = J(4,7,.)
matrix goodtypes[1,1]=1
matrix goodtypes[2,1]=2
matrix goodtypes[3,1]=3
matrix goodtypes[4,1]=4
matrix goodtypes[1,2]=b[1,1]
matrix goodtypes[2,2]=b[1,2]
matrix goodtypes[3,2]=b[1,3]
matrix goodtypes[4,2]=b[1,4]
matrix goodtypes[1,5]=b[1,5]
matrix goodtypes[2,5]=b[1,6]
matrix goodtypes[3,5]=b[1,7]
matrix goodtypes[4,5]=b[1,8]
matrix goodtypes[1,3]=b[1,1]-sqrt(v[1,1])*invttail(e(df_m) ,0.025)
matrix goodtypes[1,4]=b[1,1]+sqrt(v[1,1])*invttail(e(df_m) ,0.025)
matrix goodtypes[2,3]=b[1,2]-sqrt(v[2,2])*invttail(e(df_m) ,0.025)
matrix goodtypes[2,4]=b[1,2]+sqrt(v[2,2])*invttail(e(df_m) ,0.025)
matrix goodtypes[3,3]=b[1,3]-sqrt(v[3,3])*invttail(e(df_m) ,0.025)
matrix goodtypes[3,4]=b[1,3]+sqrt(v[3,3])*invttail(e(df_m) ,0.025)
matrix goodtypes[4,3]=b[1,4]-sqrt(v[4,4])*invttail(e(df_m) ,0.025)
matrix goodtypes[4,4]=b[1,4]+sqrt(v[4,4])*invttail(e(df_m) ,0.025)
matrix goodtypes[1,6]=b[1,5]-sqrt(v[5,5])*invttail(e(df_m) ,0.025)
matrix goodtypes[1,7]=b[1,5]+sqrt(v[5,5])*invttail(e(df_m) ,0.025)
matrix goodtypes[2,6]=b[1,6]-sqrt(v[6,6])*invttail(e(df_m) ,0.025)
matrix goodtypes[2,7]=b[1,6]+sqrt(v[6,6])*invttail(e(df_m) ,0.025)
matrix goodtypes[3,6]=b[1,7]-sqrt(v[7,7])*invttail(e(df_m) ,0.025)
matrix goodtypes[3,7]=b[1,7]+sqrt(v[7,7])*invttail(e(df_m) ,0.025)
matrix goodtypes[4,6]=b[1,8]-sqrt(v[8,8])*invttail(e(df_m) ,0.025)
matrix goodtypes[4,7]=b[1,8]+sqrt(v[8,8])*invttail(e(df_m) ,0.025)
svmat goodtypes
gen contmin=goodtypes1-0.025
gen contplus=goodtypes1+0.025

#delimit;
twoway (rspike goodtypes3 goodtypes4 contmin in 1/4, lcolor(black) lwidth(medthick) lpattern(solid))
	   (rspike goodtypes6 goodtypes7 contplus in 1/4, lcolor(white) lwidth(medthick) lpattern(solid))
	   (scatter goodtypes2 contmin in 1/4, mcolor(black)  msize(large) msymbol(circle))
	   (scatter goodtypes5 contplus in 1/4, mcolor(black) mfcolor(white) msize(large) msymbol(circle)),
legend(order(3 4) label(3 "Salary") label(4 "Appropriation"))
	   /*y-axis options*/
ytitle("Predicted Net Assistance (Assist-Hinder)", margin(zero) alignment(bottom)) 
yscale(titlegap(2) outergap(0)) 
ylabel(-1(1)3, labsize(small) labgap(tiny) nogrid)
/*x-axis options*/
xtitle("Period 1 Contribution Level", alignment(bottom)) 
xscale(titlegap(2) outergap(0)) 
xlabel(, labsize(small) labgap(small) nogrid) 
/*General*/
yline(-1 0 1 2 3, lcolor(white) lwidth(vvthin))
xsize(2.5) ysize(2.5) 
aspectratio(.75) 
graphregion(margin(small) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) 
plotregion(margin(small) fcolor(gs13) lcolor(gs13) ifcolor(gs13) ilcolor(gs13))
name(SF01_helphinderbyp1cont_full, replace)
	   ;
#delimit cr
graph export "`outputlocation'AuxFigure01_helphinderbyp1cont_full.pdf", replace

lincom sal1-isfarm1
lincom sal2-isfarm2
lincom sal3-isfarm3
lincom sal4-isfarm4

/************Help or Hinder General, Full Info ************/
clear
use "sourcedata\Merged_individualleveldata.dta"
keep if isenforcer ==0 
tab p_assistorhinder if g_legitenfo==1 & treatment<3
tab p_assistorhinder if g_legitenfo==-1 & treatment<3

/******************Recreate Help/Hinder Graphs DELETING PREDATORY ENFORCERS Full Info **********************/
clear
use "sourcedata\Merged_individualleveldata.dta"
keep if isenforcer==1
sort group period
gen illegit = (g_legit==-1)
by group: gen sum_illegit = sum(illegit)
keep if sum_illegit ==0

#delimit;
twoway (lpolyci g_assistorhinder period if treatment==2, lwidth(medthick) lpattern(solid) lcolor(white) ciplot(rline) blcolor(white) blpattern(dash))
       (lpolyci g_assistorhinder period if treatment==1, lwidth(medthick) lpattern(solid) lcolor(black) ciplot(rline) blcolor(black) blpattern(dash))
       (scatter g_assistorhinder period if treatment==1, mcolor(black)  msize(small) msymbol(circle) jitter(3))
       (scatter g_assistorhinder period if treatment==2,mcolor(black) mfcolor(white) msize(small) msymbol(circle) jitter(3))
,
legend(order(5 6) label(5 "Salary") label(6 "Appropriation"))
/*y-axis options*/
ytitle("Net Assistance (Assist-Hinder)", margin(zero) alignment(bottom)) 
yscale(titlegap(2) outergap(0)) 
ylabel(-3(1)3, labsize(small) labgap(tiny) nogrid)
/*x-axis options*/
xtitle("Period", alignment(bottom)) 
xscale(titlegap(2) outergap(0)) 
xlabel(1 5 10 15 20, labsize(small) labgap(small) nogrid) 
/*General*/
xsize(2.5) ysize(2.5) 
aspectratio(.75) 
graphregion(margin(small) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) 
plotregion(margin(small) fcolor(gs13) lcolor(gs13) ifcolor(gs13) ilcolor(gs13))
yline(-3 -2 -1 0 1 2 3, lcolor(white) lwidth(vvthin))
xline(1 5 10 15 20, lcolor(white) lwidth(vvthin))
name(SF02L_helphinderpart1_full_noill, replace)
;

twoway (lpolyci g_assistorhinder g_avglagcontpg if treatment==2, lwidth(medthick) lpattern(solid) lcolor(white) ciplot(rline) blcolor(white) blpattern(dash))
       (lpolyci g_assistorhinder g_avglagcontpg if treatment==1, lwidth(medthick) lpattern(solid) lcolor(black) ciplot(rline) blcolor(black) blpattern(dash))
       (scatter g_assistorhinder g_avglagcontpg if treatment==1, mcolor(black)  msize(small) msymbol(circle) jitter(3))
       (scatter g_assistorhinder g_avglagcontpg if treatment==2,mcolor(black) mfcolor(white) msize(small) msymbol(circle) jitter(3))
,
legend(order(5 6) label(5 "Salary") label(6 "Appropriation"))
/*y-axis options*/
ytitle("", margin(zero) alignment(bottom)) 
yscale(titlegap(2) outergap(0)) 
ylabel(-3(1)3, labsize(small) labgap(tiny) nogrid)
/*x-axis options*/
xtitle("Average Previous Contributions", alignment(bottom)) 
xscale(titlegap(2) outergap(0)) 
xlabel(0(1)4, labsize(small) labgap(small) nogrid) 
/*General*/
xsize(2.5) ysize(2.5) 
aspectratio(.75) 
graphregion(margin(small) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) 
plotregion(margin(small) fcolor(gs13) lcolor(gs13) ifcolor(gs13) ilcolor(gs13))
yline(-3 -2 -1 0 1 2 3, lcolor(white) lwidth(vvthin))
xline(0 1 2 3 4, lcolor(white) lwidth(vvthin))
name(SF02R_helphinderpart2_full_noill, replace)
;

#delimit;
grc1leg SF02L_helphinderpart1_full_noill SF02R_helphinderpart2_full_noill, imargin(zero) graphregion(margin(zero) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) 
plotregion(margin(zero) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) name(SF02_hhinderpartcomb_full_noill, replace) position(6) xsize(5) ysize(3);
#delimit;
graph export "`outputlocation'AuxFigure02_helphinderpartcomb_full_noill.pdf", replace;
#delimit cr

/******************Recreate Help/Hinder Graphs DELETING PREDATORY ENFORCERS Limited Info **********************/
clear
use "sourcedata\Merged_individualleveldata.dta"
keep if isenforcer==1
sort group period
gen illegit = (g_legit==-1)
by group: gen sum_illegit = sum(illegit)
keep if sum_illegit ==0

#delimit;
twoway (lpolyci g_assistorhinder period if treatment==6, lwidth(medthick) lpattern(solid) lcolor(white) ciplot(rline) blcolor(white) blpattern(dash))
       (lpolyci g_assistorhinder period if treatment==5, lwidth(medthick) lpattern(solid) lcolor(black) ciplot(rline) blcolor(black) blpattern(dash))
       (scatter g_assistorhinder period if treatment==5, mcolor(black)  msize(small) msymbol(circle) jitter(3))
       (scatter g_assistorhinder period if treatment==6,mcolor(black) mfcolor(white) msize(small) msymbol(circle) jitter(3))
,
legend(order(5 6) label(5 "Salary") label(6 "Appropriation"))
/*y-axis options*/
ytitle("Net Assistance (Assist-Hinder)", margin(zero) alignment(bottom)) 
yscale(titlegap(2) outergap(0)) 
ylabel(-3(1)3, labsize(small) labgap(tiny) nogrid)
/*x-axis options*/
xtitle("Period", alignment(bottom)) 
xscale(titlegap(2) outergap(0)) 
xlabel(1 5 10 15 20, labsize(small) labgap(small) nogrid) 
/*General*/
xsize(2.5) ysize(2.5) 
aspectratio(.75) 
graphregion(margin(small) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) 
plotregion(margin(small) fcolor(gs13) lcolor(gs13) ifcolor(gs13) ilcolor(gs13))
yline(-3 -2 -1 0 1 2 3, lcolor(white) lwidth(vvthin))
xline(1 5 10 15 20, lcolor(white) lwidth(vvthin))
name(SF03L_helphinderpart1_lim_noill, replace)
;

twoway (lpolyci g_assistorhinder g_avglagcontpg if treatment==6, lwidth(medthick) lpattern(solid) lcolor(white) ciplot(rline) blcolor(white) blpattern(dash))
       (lpolyci g_assistorhinder g_avglagcontpg if treatment==5, lwidth(medthick) lpattern(solid) lcolor(black) ciplot(rline) blcolor(black) blpattern(dash))
       (scatter g_assistorhinder g_avglagcontpg if treatment==5, mcolor(black)  msize(small) msymbol(circle) jitter(3))
       (scatter g_assistorhinder g_avglagcontpg if treatment==6,mcolor(black) mfcolor(white) msize(small) msymbol(circle) jitter(3))
,
legend(order(5 6) label(5 "Salary") label(6 "Appropriation"))
/*y-axis options*/
ytitle("", margin(zero) alignment(bottom)) 
yscale(titlegap(2) outergap(0)) 
ylabel(-3(1)3, labsize(small) labgap(tiny) nogrid)
/*x-axis options*/
xtitle("Average Previous Contributions", alignment(bottom)) 
xscale(titlegap(2) outergap(0)) 
xlabel(0(1)4, labsize(small) labgap(small) nogrid) 
/*General*/
xsize(2.5) ysize(2.5) 
aspectratio(.75) 
graphregion(margin(small) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) 
plotregion(margin(small) fcolor(gs13) lcolor(gs13) ifcolor(gs13) ilcolor(gs13))
yline(-3 -2 -1 0 1 2 3, lcolor(white) lwidth(vvthin))
xline(0 1 2 3 4, lcolor(white) lwidth(vvthin))
name(SF03R_helphinderpart2_lim_noill, replace)
;

#delimit;
grc1leg SF03L_helphinderpart1_lim_noill SF03R_helphinderpart2_lim_noill, imargin(zero) graphregion(margin(zero) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) 
plotregion(margin(zero) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) name(SF03_hhpartcomb_lim_noill, replace) position(6) xsize(5) ysize(3);
#delimit;
graph export "`outputlocation'AuxFigure03_helphinderpartcomb_lim_noill.pdf", replace;
#delimit cr

/* Difference in deterrence history, full and limited information */

* This is a measure of deterrence history, calculated from individual players' histories
* up to the group level as the proportion of time on average that they don't contribute
* and are punished minus the proportion of time they contribute and are punished

clear
use "sourcedata\Merged_individualleveldata.dta"
keep if isenforcer==0

gen p_cont=p_contributedtopg == 1
gen p_cont_pun=0 if p_cont==1
replace p_cont_pun=1 if p_punishedsuccess==1 & p_cont==1

gen p_notcont=p_contributedtopg == 0
gen p_notcont_pun=0 if p_notcont==1
replace p_notcont_pun=1 if p_punishedsuccess==1 & p_notcont==1

tab p_cont p_cont_pun, mis
tab p_notcont p_notcont_pun, mis

sort treatment group period
collapse (sum) p_notcont p_notcont_pun p_cont p_cont_pun, by(treatment group period)

sort  group period
by group: gen l_p_cont = sum(p_cont)-p_cont
by group: gen l_p_cont_pun = sum(p_cont_pun)-p_cont_pun

by group: gen l_p_notcont = sum(p_notcont)-p_notcont
by group: gen l_p_notcont_pun = sum(p_notcont_pun)-p_notcont_pun

gen d1=l_p_notcont_pun/l_p_notcont
gen d2=l_p_cont_pun/l_p_cont

gen deter=d1
replace deter = deter-d2 if d2~=.

* This is whether the deterrence index is above or below the critical value
gen dcut=0 if deter~=.
replace dcut=1 if deter>=8/30 & deter~=.

table treatment, c(mean deter mean dcut)
tab treatment dcut, row

log close

