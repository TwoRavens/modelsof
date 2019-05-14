#delimit;
cap cd "C:\Users\ejm5\Dropbox\PartipationCompliance\AER-QJE-The Moon\Replication";
use "Data\20181106_RCT_Clean.dta", clear;
set more off;



/*************************************Figure 2: Manipulation Checks********************************/

/*Analysis to firms that answered endline interview (status==1)*/


/*Heard of Law*/
#delimit;
cibar knowledge if status==1, over1(group) level(95) graphopts(scheme(s1mono) ylab(0(.1).8, 
labsize(small)) ytitle("Heard of Draft Law (Share of Firms)", 
size(medium) margin(medium)) legend(cols(1) size(small) position(11) ring(0)) title("Awareness")) barcolor(gs7 gs14 gs4) ;
graph save awareness.gph, replace;


/*Understanding*/
#delimit;
cibar understanding if status==1, over1(group) level(95) graphopts(scheme(s1mono) ylab(1(.25)2, 
labsize(small)) ytitle("Average Understanding Score (5=A Lot; 1=None)", 
size(medium) margin(medium)) legend(off) title("Understanding")) barcolor(gs7 gs14 gs4)   ;
graph save understanding.gph, replace;


/*Quality*/
#delimit;
cibar c0b if status==1, over1(group) level(95) graphopts(scheme(s1mono) ylab(1(.25)2, 
labsize(small)) ytitle("Average Quality Score (5=High; 1=Low)", 
size(medium) margin(medium)) legend(off) title("Quality")) barcolor(gs7 gs14 gs4) ;
graph save quality.gph, replace;

#delimit;
graph combine awareness.gph understanding.gph quality.gph, rows(1) xcommon imargin(tiny) 
	scheme(s1mono);
graph save "Figures\Figure2_RandomizationCheck.gph", replace;
graph export "Figures\Figure2_RandomizationCheck.pdf", as(pdf) replace;


/*****************************Appendix I3********************************/

/*Regression Analysis of Quality as measure of legitimacy.  Shows results are robust to regression analysis.*/


#delimit;
set more off;
xi: reg c0b treatment1 treatment2 if status==1,  cluster(fe_provcatsector);
outreg2 using "Tables\TableI3", tdec(3) bdec(3) e(all) replace;
xi: reg c0b treatment1 treatment2 hanoi female i.r1_emp   if status==1, cluster(fe_provcatsector);
outreg2 using "Tables\TableI3", tdec(3) bdec(3) e(all);
xi: reg c0b treatment1 treatment2 hanoi female i.r1_emp   i.r1_catsector if status==1, cluster(fe_provcatsector);
outreg2 using "Tables\TableI3", tdec(3) bdec(3) e(all);
xi: reg c0b treatment1 treatment2 hanoi female i.r1_emp   i.r1_catsector i.enumerator if status==1, cluster(fe_provcatsector);
outreg2 using "Tables\TableI3", tdec(3) bdec(3) e(all) excel;


/*********************Figure 3: Justification of Access Assumption******************************/
#delimit;
ttest quality, by(access);
ttest rents, by(access);
ttest gov_understands_dich, by(access);

replace quality=quality*100;
replace rents=rents*100;
replace gov_understands_dich=gov_understands_dich*100;

#delimit;
graph bar (mean) quality, over(access, descending label(labsize(medsmall))) blabel(bar, format(%9.2f)) bar(1, fcolor(gs4)) 
ytitle("", size(medium) margin(medium)) title("Regulation is High Quality?", size(medsmall) margin(medium))
scheme(s1mono) note("t-value=-4.53; p-value=0.00", size(small) position(2) ring(0));
graph save access_quality.gph, replace;

#delimit;
graph bar (mean) rents, over(access, descending label(labsize(medsmall))) blabel(bar, format(%9.2f)) bar(1, fcolor(gs8))
ytitle("", size(medium) margin(medium)) title("Regulations to Extract Bribes?", size(medsmall) margin(medium))
scheme(s1mono) note("t-value=1.93; p-value=0.027", size(small) position(2) ring(0));
graph save access_rents.gph, replace;

#delimit;
graph bar (mean) gov_understands_dic, over(access, descending label(labsize(medsmall))) blabel(bar, format(%9.2f)) bar(1, fcolor(gs12))
ytitle("", size(medium) margin(medium)) title("Gov. Understands Business?", size(medsmall) margin(medium))
scheme(s1mono) note("t-value=-1.53; p-value=0.06 ", size(small) position(2) ring(0));
graph save access_under.gph, replace;

#delimit;
graph combine  access_quality.gph  access_under.gph  access_rents.gph, xcommon ycommon imargin(medsmall) scheme(s1mono) col(3)
title("Firms Agreeing with Criteria (%)", size(medium) margin(medium) position(9) orientation(vertical))
subtitle("Firm Allowed Access to Factory?", size(medium) margin(medium) position(6));
graph save "Figures\Figure3_assumption.gph", replace;
graph export "Figures\Figure3_assumption.pdf", as(pdf) replace;

/*****************************************************************************************************************/
