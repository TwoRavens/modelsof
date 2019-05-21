**************************RESULTS study 1*************************************************
******************************************************************************************
/*THIS FILE REPRODUCES THE ESTIMATES OF STUDY 1:
FIGURE 1 
TABLE 1 
FIGURE 2 
FIGURE A1 IN THE APPENDIX
TABLE A1 IN THE APPENDIX
TABLE A2 IN THE APPENDIX
TABLE A3 IN THE APPENDIX
*/
******************************************************************************************
/*
Hardware: MacBook Pro (13-inch, 2017)
Software: macOS Mojave 10.14.1; stata 15 
Sources of data-sets used in study 1: 
Dutch election study 2002/03: https://www.nkodata.nl/study_units/view/8 (ungated) 
German election study 1983: https://dbk.gesis.org/dbksearch/sdesc2.asp?no=1276&db=e&doi=10.4232/1.11458 (gated)
*/

*use "/Users/`=c(username)'/Dropbox/MarkusDaniel/LeadFollowPaper/data/3_DelecstudRR.dta", clear
************************************************************************
******************************INSTALL PACKAGES**************************
************************************************************************
/*
ssc install g538schemes, replace all
set scheme 538w, permanently
ssc install estout, replace all
*/

************************************************************************
******************************PROGRAMS:*********************************
************************************************************************
drop _all 
program drop _all

*
use "3_Netherlands2002.dta", clear

*create a little wrapper to export no. of clusters: 
program estadd_cluster, eclass
	ereturn scalar cluster = e(N_clust)
end

************************************************************************
******************************FIGURE 1**********************************
************************************************************************
tw (lpolyci polarization time if time<0, fcolor(538bs9%50) acolor(538bs9%50) level(95)) ///
(lpolyci polarization time if time<0, lcol(538b) fcolor(538bs6%50) acolor(538bs6%50) level(83.4)) ///
(lpolyci polarization time if time>=0, lcol(538r) fcolor(538rs9%50) acolor(538rs9%50) level(95))  ///
(lpolyci polarization time if time>=0, lcol(538r) fcolor(538rs6%50) acolor(538rs6%50) level(83.4)),  ///
xline(0, lpattern(solid) lcol(black)) xtitle("days until election") ///
ytitle("polarization") ///
legend(off) xlabel(-28 -21 -14 -7 0 "election" 7 14 21 28 35 42) ///
yline(1.618956, lcol(538bs5)) ///
yline(1.73399, lcol(538rs5)) ///
title("{bf:Did public polarization increase after the LPF entry? Yes.}")
graph export "fig1.pdf", replace

************************************************************************
******************************TALBE 1***********************************
************************************************************************
*estimates
eststo clear
xtset id wave 
eststo: reg polarization treated interviewdistance if sample==1, cluster(id)
eststo: reg polarization treated pvda vvd cda lpf ///
age female rural sclass polkno religion ///
interviewdistance  if sample==1, cluster(id) 
eststo: xtreg polarization treated  if sample==1, cluster(id) fe
eststo: reg polarization fortuyn if wave==1
eststo: teffects psmatch (polarization) (fortuyn polkno pvda vvd cda lpf age female rural sclass religion) if wave==1
*table
estadd cluster : *
estadd local fixed "\checkmark" , replace
*
esttab using tbl1.tex, replace se nostar nobaselevels ///
drop(pvda vvd cda lpf female rural sclass polkno religion) ///
indicate("Controls = age" "Interview timing = interviewdistance", labels(\checkmark ) )  ///
stats(fixed r2 N cluster, labels("Individual FE" "\$R^2$" "Obs." "\$N$")) label ///
title("Did polarization increase after the LPF entrance (Netherlands 2002)? Yes.") ///
rename(fortuyn treated r1vs0.pre/post treated) ///
mtitles("Pre/post comparison" "Pre/post comparison" "Pre/post comparison" "Placebo: Fortuyn" "Placebo: Fortuyn")  ///
note("Models (1)-(3) clustered standard errors by panel id;} \\ \multicolumn{5}{l}{\footnotesize Model (5) propensity score matching, 1-match per respondent before Fortuyn murder;") ///
substitute(\_ _)

************************************************************************
******************************FIGURE 2**********************************
************************************************************************
*shift right vs. left:
eststo clear 
eststo: reg dlr rightid if date>edate
eststo: reg dlr leftid if date>edate
coefplot ///
(est1, mlabels(rightid = 1 "right ID")) ///
(est2, mlabels(leftid = 11 "left ID")) ///
, xline(0, lpattern(solid) lcol(black)) drop(_cons) legend(off) cismooth  ylabel("") ///
xtitle("{&Delta}LR=LR{sub: post}-LR{sub: pre}") ///
title("{bf:Who shifted? Left vs. right party identifiers}") ///
note("{it:(based on pre-election party identifiers)}")
graph export "fig2a.pdf", replace
*shift per party vote:
eststo clear 
eststo: reg dlr lpf_id_broad if date>edate
eststo: reg dlr vvd_id_broad if date>edate
eststo: reg dlr cu_id_broad  if date>edate
eststo: reg dlr cda_id_broad if date>edate
eststo: reg dlr d66_id_broad if date>edate
eststo: reg dlr pvda_id_broad if date>edate
eststo: reg dlr gl_id_broad  if date>edate
eststo: reg dlr sp_id_broad if date>edate
coefplot ///
(est1, mlabels(lpf_id_broad = 1 "LPF") pstyle(p4)) ///
(est2, mlabels(vvd_id_broad = 11 "VVD") pstyle(p6)) ///
(est3, mlabels(cu_id_broad = 1 "CU") pstyle(p1)) ///
(est4, mlabels(cda_id_broad = 1 "CDA") pstyle(p9)) ///
(est5, mlabels(d66_id_broad = 1 "D66") pstyle(p7)) ///
(est6, mlabels(pvda_id_broad = 1 "PvdA") pstyle(p2)) ///
(est7, mlabels(gl_id_broad = 1 "GL") pstyle(p3)) ///
(est8, mlabels(sp_id_broad = 1 "SP") pstyle(p5)) ///
, xline(0, lpattern(solid) lcol(black)) drop(_cons) legend(off) cismooth  ylabel("") ///
xtitle("{&Delta}LR=LR{sub: post}-LR{sub: pre}") ///
title("{bf:Who shifted? Shifts for set of party identifiers}") ///
note("{it:(based on pre-election set of party identifiers)}")
graph export "fig2b.pdf", replace

************************************************************************
******************************APPENDIX**********************************
************************************************************************

************************************************************************
******************************FIGURE A1**********************************
************************************************************************
histogram postlr if lprelr==6, xtitle("post left−right self−placement of pre lr=6") discrete ///
xlabel(1(1)11)
graph export "fig1a.pdf", replace

************************************************************************
******************************TABLE A1**********************************
************************************************************************
eststo clear
*baseline model 1
eststo: reg postlr ///
lpf_id_broad vvd_id_broad cu_id_broad cda_id_broad d66_id_broad pvda_id_broad gl_id_broad sp_id_broad ///
lprelr  
*controls model 1
eststo: reg postlr ///
lpf_id_broad vvd_id_broad cu_id_broad cda_id_broad d66_id_broad pvda_id_broad gl_id_broad sp_id_broad ///
lprelr ///
asylum crime euthanasia inequality ///
female age sclass polkno rural religion   
*baseline model 2
eststo: reg dlr ///
lpf_id_broad vvd_id_broad cu_id_broad cda_id_broad d66_id_broad pvda_id_broad gl_id_broad sp_id_broad 
*controls model 2
eststo: reg dlr ///
lpf_id_broad vvd_id_broad cu_id_broad cda_id_broad d66_id_broad pvda_id_broad gl_id_broad sp_id_broad ///
asylum crime euthanasia inequality ///
female age sclass polkno rural religion 
*table:
esttab using tblA1.tex, replace se nostar nobaselevels ///
stats(r2 N) label ///
title("Is there a backlash \& legitimization effect after LPF enters? Yes.") ///
mtitles("Pre/post comparison" "Pre/post comparison + controls" "Post$_{lr}$-Pre$_{lr}$" "Post$_{lr}$-Pre$_{lr}$ + controls")  ///
substitute(\_ _)  

************************************************************************
******************************TABLE A2**********************************
************************************************************************
eststo clear
*baseline model 1
eststo: tobit postlr ///
lpf_id_broad vvd_id_broad cu_id_broad cda_id_broad d66_id_broad pvda_id_broad gl_id_broad sp_id_broad ///
lprelr, ll(1)  ul(11)  
*control model 1
eststo: tobit postlr ///
lpf_id_broad vvd_id_broad cu_id_broad cda_id_broad d66_id_broad pvda_id_broad gl_id_broad sp_id_broad ///
lprelr ///
asylum crime euthanasia inequality ///
female age sclass polkno rural religion, ll(1)  ul(11) 
*baseline model 2
eststo: tobit dlr ///
lpf_id_broad vvd_id_broad cu_id_broad cda_id_broad d66_id_broad pvda_id_broad gl_id_broad sp_id_broad ///
, ll(-10)  ul(10) 
*control model 2
eststo: tobit dlr ///
lpf_id_broad vvd_id_broad cu_id_broad cda_id_broad d66_id_broad pvda_id_broad gl_id_broad sp_id_broad ///
asylum crime euthanasia inequality ///
female age sclass polkno rural religion, ll(-10)  ul(10) 
esttab using tblA2.tex, replace se nostar nobaselevels ///
stats(r2 N) label ///
title("Tobit models: Is there a backlash \& legitimization effect after LPF enters? Yes.") ///
mtitles("Pre/post comparison" "Pre/post comparison + controls" "Post$_{lr}$-Pre$_{lr}$" "Post$_{lr}$-Pre$_{lr}$ + controls")  ///
substitute(\_ _)   

************************************************************************
******************************TABLE A3**********************************
************************************************************************
use "3_Germany83.dta", clear 
*
xtset id wave 
*
eststo clear 
eststo: reg polarization treated interviewdistance, cluster(id)
eststo: reg polarization treated cdu spd fdp gru ///
age female rural polkno religion ///
interviewdistance, cluster(id) 
eststo: xtreg polarization treated, cluster(id) fe
*table
estadd local fixed "\checkmark" , replace
estadd cluster : *
*
esttab using tblA3.tex, replace se nostar nobaselevels ///
drop(cdu spd fdp gru female rural polkno religion) ///
indicate("Controls = age" "Interview timing = interviewdistance", labels(\checkmark ) )  ///
stats(fixed r2 N cluster, labels("Individual FE" "\$R^2$" "Obs." "\$N$")) label ///
title("Did polarization increase after Green entrance (Germany 1983)? No.") ///
mtitles("DE" "DE" "DE")  ///
note("all models use clustered standard errors by panel id;} \\ \multicolumn{4}{l}{\footnotesize  controls (age, gender, urban vs. rural, social class,;} \\ \multicolumn{4}{l}{\footnotesize  voting preference, political knowledge, religiosity) omitted from table.") ///
substitute(\_ _)


 


