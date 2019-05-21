
/*******************************************************************************
REPLICATION MATERIALS FOR	 
Show Me Your Friends: A Survey Experiment on the Effect of Coalition Signals
Albert Falcó-Gimeno and Jordi Muñoz
Department of Political Science, University of Barcelona
E-mail: afalcogimeno@ub.edu - jordi.munoz@ub.edu
*******************************************************************************/

*Set WD
cd "/Users/jordimunoz/Dropbox/Projecte EPOLTERROR/Coalition signals/dades_def/"
/*Encoding 
unicode encoding set ISO-8859-1
clear
unicode translate ABBAES_70505_20150518.dta*/

*packages
ssc install spineplot
ssc install tab_chi
ssc install estout
ssc install coefplot
*File
use ABBAES_70505_20150518.dta, clear

********************************************************************************
****************************RECODES*********************************************
********************************************************************************

{
recode P11 (4/6=.) (1=1 "Rule Out") (2=2 "Cs-PP") (3=3 "Cs-PSOE") (7=0 "Placebo"), gen(exp_cs)
recode P11 (1/3=.) (4=1 "Rule Out") (5=2 "PSOE-Cs") (6=3 "PSOE-Left") (7=0 "Placebo"), gen(exp_psoe)
format P6_* P7_* P14_* P15_* P16_* P17_* P18_* %9.2f
*For randomization test
gen p8ok=(P8==4)
gen p9ok=(P9==2)
gen p10ok=(P10==3)
gen sophis=p8ok+p9ok+p10ok
label var sophis "Political Sophistication"
tab sophis
recode P1 (1=3 "High") (2=2 "Mild") (3=1 "Small") (4=0 "None"), gen(polint)
gen education=NIVEST-1
gen age=EDAD-18
gen agesq=age^2
recode SEXO (1=0 "Male") (2=1 "Female"), gen(female)

*Correct anwers
gen correct=.
replace correct=1 if P11==1 & P20C==3
replace correct=1 if P11==2 & P20C==1
replace correct=1 if P11==3 & P20C==2
replace correct=1 if P11==4 & P20A==3
replace correct=1 if P11==5 & P20A==1
replace correct=1 if P11==6 & P20A==2
replace correct=1 if P11==76 & P20D==1
replace correct=1 if P11==7 & P20D==1
recode correct .=0
replace correct=2 if P20A==4
replace correct=2 if P20C==4
replace correct=2 if P20D==4

*Coalition expectations
label define belief_cs 1"Right-leaning" 2"Left-leaning" 3"Alone"
gen belief_cs=P22
label values belief_cs belief_cs

label define belief_psoe 1"Right-leaning" 2"Left-leaning" 3"Alone"
gen belief_psoe=P21
label values belief_psoe belief_psoe

*Noncompliance
recode P20C (4=.), gen(mancs)
recode P20A (4=.), gen(manpsoe)
recode mancs 1=2 3=1 2=3
recode manpsoe 1=2 3=1 2=3
recode mancs .=0 if P20D==1
recode mancs .=0 if P20D==1
recode mancs .=4 if exp_cs!=.
recode mancs 4=0 if exp_cs!=0
recode mancs 4=0
recode manpsoe .=0 if exp_psoe!=.
}



*We save the file that will be used in the analyses run in R
*See replication_mediation_showme.R 
save ABBAES_70505_20150518_run.dta, replace
********************************************************************************
****************************ANALYSIS********************************************
********************************************************************************

*Figure 2

*Cs
reg P15_1 i.exp_cs
coefplot, xline(0) drop(_cons) levels(95 90) title("Liberals (Cs)") subtitle(" ") xtitle("") ytitle("") ///
	ylabel(1 "Rule Out" 2 "Right-leaning" 3 "Left-leaning", labsize(small) angle(vertical)) ///
	xlabel(-.5(.25)1, labsize(medsmall)) xline(0, lp(shortdash) lc(black)) ///
	msymbol(O) msize(medlarge) mlwidth(medthick) mfcolor(gs14) mlcolor(ply3) ///
	ciopts(lwidth(medium thick) lcolor(ply3 ply3))
graph save ip_cs_v2.gph, replace

*PSOE
reg P15_3 i.exp_psoe
coefplot, xline(0) drop(_cons) levels(95 90) title("Social-Democrats (PSOE)") subtitle(" ") xtitle("") ytitle("") ///
	ylabel(1 "Rule Out" 2 "Right-leaning" 3 "Left-leaning", labsize(small) angle(vertical)) ///
	xlabel(-.5(.25)1, labsize(medsmall)) xline(0, lp(shortdash) lc(black)) ///
	msymbol(O) msize(medlarge) mlwidth(medthick) mfcolor(gs14) mlcolor(plr1) ///
	ciopts(lwidth(medium thick) lcolor(plr1 plr1))
graph save ip_psoe_v2.gph, replace

*Combine
graph combine ip_cs_v2.gph ip_psoe_v2.gph, row(1) saving(complete_mg_ip_v2, replace)


*Table 2: analyses Run in R. See replication materials

********************************************************************************
****************************APPENDIX********************************************
********************************************************************************

*Table A1

mean P15_1, over(exp_cs)
mean P15_3, over(exp_psoe)

*Table B1: Sample characteristics
tab1 SEXO EDAD_R NIVEST P6_1  
	*comparison face-to-face probability survey CIS. Frecuencies available at: 
	*http://www.cis.es/cis/export/sites/default/-Archivos/Marginales/3060_3079/3066/es3066mar.html 

*Table C1: Manipulation checks

tab exp_cs correct, row nofreq
tab exp_psoe correct, row nofreq

*Table C2: Randomization test
mlog P11 sophis polint education female age agesq P6_1 P7_1 P7_2 P7_3 P7_4 P7_5 P7_6
est store rando
esttab rando using tablesappendix.tex, unstack cell(b(star fmt (%9.2f)) se(par)) ///
 stats(N ll df_m chi2 p r2_p, fmt(%9.0g %9.3f %9.0g %9.3f) ///
	labels("N" "log likelihood" "Degrees of freedom" "Chi squared" "P-value" "Pseudo-r2")) /// 
	starlevels(* 0.1 ** 0.05 *** 0.01) legend label varlabels(_cons Constant) nobaselevels ///
	 title("Randomization test") mtitles replace

*Table and figure D1: Effects on expectations
tab exp_cs belief_cs, col row nofreq chi
tabchi exp_cs belief_cs, adj noo noe
spineplot belief_cs exp_cs, legend(pos(6) row(1) size(medsmall) symxsize(5) keygap(1)) title("Liberals (Cs)") xtitle("", axis(1)) xtitle("Treatment", axis(2)) xlabel(none, axis(1)) xlabel(, labsize(medsmall) axis(2)) ytitle("", axis(2)) ylabel(0(.2)1, axis(2)) bar1(color(orange)) bar2(color(dkorange)) bar3(color(sand))
graph save manip_cs.gph, replace

tab exp_psoe belief_psoe, col row nofreq chi
tabchi exp_psoe belief_psoe, adj noo noe
spineplot belief_psoe exp_psoe, legend(pos(6) row(1) size(medsmall) symxsize(5) keygap(1)) title("Social-Democrats (PSOE)") xtitle("", axis(1)) xtitle("Treatment", axis(2)) xlabel(none, axis(1)) xlabel(, labsize(medsmall) axis(2)) ytitle("", axis(2)) ylabel(0(.2)1, axis(2)) bar1(color(red)) bar2(color(cranberry)) bar3(color(erose))
graph save manip_psoe.gph, replace

graph combine manip_cs.gph manip_psoe.gph, row(1) saving(complete_manip, replace)


*Figure D2: Effects on non-spatial characteristics
ologit P17_1 i.exp_cs, or
margins, dydx(exp_cs) expression(predict(outcome(3))+predict(outcome(4))) saving(mg_policy_cs, replace)
marginsplot, level(95) recast(dot) recastci(rspike) title("Liberals (Cs)") subtitle("") xtitle("") ytitle("") xlabel(2 "Rule Out" 3 "Right-leaning" 4 "Left-leaning", labsize(small) angle(vertical)) ylabel(-.2(.05).1, labsize(medsmall)) yline(0, lp(dash) lc(red)) xscale(range(1.75 4.25)) plotopts(mlcolor(dkorange)) ciopts(lcolor(dkorange))
graph save mg_pol_cs.gph, replace
ologit P17_3 i.exp_psoe, or
margins, dydx(exp_psoe) expression(predict(outcome(3))+predict(outcome(4))) saving(mg_policy_cs, replace)
marginsplot, level(95) recast(dot) recastci(rspike) title("Social-Democrats (PSOE)") subtitle("") xtitle("") ytitle("") xlabel(2 "Rule Out" 3 "Right-leaning" 4 "Left-leaning", labsize(small) angle(vertical)) ylabel(-.2(.05).1, labsize(medsmall)) yline(0, lp(dash) lc(red)) xscale(range(1.75 4.25)) plotopts(mlcolor(cranberry)) ciopts(lcolor(cranberry))
graph save mg_pol_psoe.gph, replace
graph combine mg_pol_cs.gph mg_pol_psoe.gph, saving(complete_mg_pol, replace)

*Compliance 

*Table E1
mean P15_1 if correct==1, over(exp_cs)
*Table E2
mean P15_3 if correct==1, over(exp_psoe)

*Table E3
ivregress 2sls P15_3 (i.manpsoe=i.exp_psoe)
est store cace_p_psoe
reg P15_3 i.exp_psoe if manpsoe!=.
est store itt_p_psoe

esttab itt_p_psoe cace_p_psoe using "tablesappendix.tex", cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N")) legend ///
 nobaselevels  collabels(,none) varwidth(20) compress append
 
*Table E4
ivregress 2sls P15_1 (i.mancs=i.exp_cs)
est store cace_p_cs
reg P15_1 i.exp_cs
est store itt_p_cs

esttab itt_p_psoe cace_p_psoe using "tablesappendix.tex", cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N")) legend ///
 nobaselevels  collabels(,none) varwidth(20) compress append

*Mediation - see replication_show.R

