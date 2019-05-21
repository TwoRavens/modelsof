/*
Citation: Djupe, Paul A., Jacob R. Neiheisel, and Anand E. Sokhey. Forthcoming. “Reconsidering the Role of Politics in Leaving Religion: The Importance of Affiliation.” American Journal of Political Science.
Do: 2006 Franklin County Republican Primary Study.
Bill of Lading: This file takes the relevant data from the two waves of the study, recodes, labels (select variables), and analyzes the data, and produces select data displays.
It includes code for Table 1, Table 3, Figure 2, Table A1, Table A2, Table A3. (Figures/Tables beginning with "A" are in the SI).
All "v" prefix variables are from wave 1; all "f" variables are from the followup wave 2.	
*/
*Located directory and use the data file
cd "{directory of 2006_panel.dta}"
use 2006_panel.dta

/*INDEPENDENT VARIABLES*/

*Attendance, wave 1
gen attend=7-v15 // now higher is more.
la def att 1"Never" 2"Seldom" 3"1x-2x Month" 4"Few x year" 5"1x Week" 6"2-3x Week",replace
la val attend att

*Female
gen female=v39-1 //0=male, 1=female

*Differences with Congregation Index
gen theodiff=1 if v20a==1|v20a==3
replace theodiff=0 if v20a==2

gen partydiff=1 if v20b==1|v20b==3
replace partydiff=0 if v20b==2

gen racediff=1 if v20c==1|v20c==3
replace racediff=0 if v20c==2

gen ssdiff=1 if v20d==1|v20d==3
replace ssdiff=0 if v20d==2

gen rrdiff=1 if v20e==1|v20e==3
replace rrdiff=0 if v20e==2

gen polactdiff=1 if v20f==1|v20f==3
replace polactdiff=0 if v20f==2

egen diffs=anycount(theodiff partydiff racediff ssdiff rrdiff polactdiff),values(1)
alpha theodiff partydiff racediff ssdiff rrdiff polactdiff 

*Feelings toward the Religious Right
recode v38a v38b v38f v38g (5=.a)(4=1)(3=2)(2=3)(1=4),gen(v38as v38bs v38fs v38gs) // 5=dk and flips the scale so support is high

egen v38crtot=rowtotal(v38as v38bs v38fs v38gs) // sum support

egen v38crct=rownonmiss(v38as v38bs v38fs v38gs) // create a counter of nonmissing opinions

gen v38crav=v38crtot/v38crct if v38crct>0 // average support for religious right groups

*Church-based Friends
recode p1_v27 p2_v27 p3_v27 p4_v27 (2=0) // 1=yes, 0=no
egen church_tot=rowtotal(p1_v27 p2_v27 p3_v27 p4_v27)
egen church_cnt=rownonmiss(p1_v27 p2_v27 p3_v27 p4_v27)
gen propchurch=church_tot/church_cnt

*Reltrad
gen evangelical=0
replace evangelical=1 if (v12==2 | v12==4) & (v13_1==1 | v13_2==1 | v13_4ba==1 | v13_4cha==1) & v44==1

gen mainline=0
replace mainline=1 if (v12==2 | v12==4) & evangelical==0 & v44==1

recode v12 (1=1)(else=0), gen(catholic)


/*DEPENDENT VARIABLES*/ 
*Apostasy, leaving a church by wave 2
gen apostate=0
replace apostate=1 if attend>1 & f31==2

*Attendance, wave 2
gen attend2=6-f33


/*MODELS AND DATA DISPLAYS*/
*Table 1 - The Prevalence of Reported Differences from Other Church Members
sum partydiff polactdiff ssdiff rrdiff theodiff racediff   

*Table 3 - Predicting Worship Attendance and Disaffiliation by Perceived Differences with the Congregation 
*Note: the Brant test called after the ordered logit requires the installation of s-post.  To install s-post, type: "findit spost13_ado"
ologit attend2 attend diffs propchurch female v38crav mainline catholic, vsquish
brant
logit apostate c.attend##c.diffs propchurch female v38crav mainline catholic, vsquish

*Figure 2 - The Marginal Effect of a Difference with the Congregation on Disaffiliation, given Wave 1 Attendance (Estimates from Table 3 – 90% CIs are presented)
margins,dydx(diffs) at (attend=(1(1)6)) l(90)
marginsplot, graphregion(color(white)) ytitle("Marginal Effect on the Disaffiliation Rate") xtitle("Church Attendance, Wave 1") title("") ///
		yline(0) xscale(range(1 6.2)) recastci(rspike) ciopt(lc(gs10)) plot1op(ms(O) mc(black) lc(black)) xlabel(, val)

*Table A1 - Predicting Worship Attendance by Perceived Differences with the Congregation (ordered logit regression)
ologit attend2 attend diffs propchurch female v38crav mainline catholic, vsquish
ologit attend2 attend partydiff polactdiff theodiff racediff ssdiff rrdiff propchurch female v38crav mainline catholic, vsquish

*Table A2 - Predicting Leaving a Church by Perceived Differences with the Congregation (logistic regression)
logit apostate c.attend##c.diffs propchurch female v38crav mainline catholic, vsquish
logit apostate attend partydiff polactdiff theodiff racediff ssdiff rrdiff propchurch female v38crav mainline catholic, vsquish

*Table A3 - Tetrachoric Correlations Among Dimensions of Feeling Different from the Congregation, 2006
tetrachoric partydiff polactdiff theodiff racediff ssdiff rrdiff 
