*** REPLICATION FILE FOR PSRM PAPER. GOOCH & VAVRECK 3/4/2016.  
** This file produces Tables 1 - 4 and Figures 1-2.  

*Open the datasetclear
use "GoochVavreck_PSRM1.dta"
*** BATCH ONE ***
** CONFIRM TREATMENT ASSIGNMENT.  505 PER CONDITION.tab treat
************* Calcuating Grand Averages in Non-Response Groups by Treatment*********
*First, save working data for manipulation and ease of recall	
save working.dta, replace
		
** TABLE 2 AVERAGES BY ROW 

clear 
u working

* These are the questions with EXPLICIT DKs (row 1, table 2)
#delimit ;
keep DKfavorbo DKfavorjh DKfavormr DKfavormuslim DKfavormormon DKfavortea
	DKideo DKideobo DKideomr DKideojh DKmatch_mr DKmatch_jh DKpluto DKdefense DKchur DKtaxes DKimmi DKhealth 
	DKmeds DKretro DKturnout DKchoice DKgym DKreg DKdrink treat;

#delimit crset more off		
mean DK* if treat == 1
stack DK* if treat == 1, into(DK) clear
mean DK 
** Mean = .17
************************
clear 
u working
************************
#delimit ;
keep DKfavorbo DKfavorjh DKfavormr DKfavormuslim DKfavormormon DKfavortea
	DKideo DKideobo DKideomr DKideojh DKmatch_mr DKmatch_jh DKpluto DKdefense DKchur DKtaxes DKimmi DKhealth 
	DKmeds DKretro DKturnout DKchoice DKgym DKreg DKdrink treat;

#delimit crset more off		
mean DK* if treat == 2
stack DK* if treat == 2, into(DK) clear
mean DK
** Mean == .20

*******************************************************************
clear 
u working

* These are the questions with VOLUNTARY DKs & SKIPS (row 2, table 2)
#delimit ;
keep DKmoby DKteaparty DKgaymar
	DKwsum1 DKwsum2 DKwsum5 DKwsum4 DKrr_1 DKrr_2 DKrr_3 DKrr_4 DKbible DKpartyid 
	DKinterest DKnewsp DKsmoke DKabort
	DKdentis DKincome DKtech DKrace DKeduc DKtrust treat;
	
#delimit crset more off		
mean DK* if treat == 1
stack DK* if treat == 1, into(DK) clear
mean DK 
** Mean = .06
************************
clear 
u working
************************
#delimit ;
keep DKmoby DKteaparty DKgaymar
	DKwsum1 DKwsum2 DKwsum5 DKwsum4 DKrr_1 DKrr_2 DKrr_3 DKrr_4 DKbible DKpartyid 
	DKinterest DKnewsp DKsmoke DKabort
	DKdentis DKincome DKtech DKrace DKeduc DKtrust treat;
	
#delimit crset more off		
mean DK* if treat == 2
stack DK* if treat == 2, into(DK) clear
mean DK 
** Mean == .08
	
*******************************************************************

clear 
u working

* These are the questions with OPEN ENDS (row 3, table 2)
#delimit ;
keep DKvpcode DKprimecode DKrobertscode treat;
	
#delimit crset more off		
mean DK* if treat == 1
stack DK* if treat == 1, into(DK) clear
mean DK 
** Mean = .66
************************
clear 
u working
************************
#delimit ;
keep DKvpcode DKprimecode DKrobertscode treat;
	
#delimit crset more off		
mean DK* if treat == 2
stack DK* if treat == 2, into(DK) clear
mean DK 
** Mean == .69
	
*******************************************************************
** Last row, table 2
clear 
u working

tab DKtrust treat, col chi
* .03 SC/.01 FTF







*** BATCH TWO STARTS HERE (this takes a while to run, be patient!) *** 
****************************** T-Tests and FIGURES 1 & 2 *************************************
** CALCULATING MEAN DIFFERENCES ACROSS MODE FOR REMAINING FIGS AND TABLES.  NOTE: MEANDIFF HAS 51 OBS (questions)
clear 
u working

set matsize 1000

gen meandiff = .
gen sediff = .
gen str30 name = ""

#delimit ;
set more off;
local i = 1;
foreach v in DKmoby DKteaparty DKgaymar
	DKwsum1 DKwsum2 DKwsum5 DKwsum4 DKrr_1 DKrr_2 DKrr_3 DKrr_4 DKbible DKpartyid 
	DKinterest DKnewsp DKsmoke DKvpcode DKprimecode DKrobertscode
	DKdentis DKincome DKtech DKrace DKeduc DKtrust
	DKfavorbo DKfavorjh DKfavormr DKfavormuslim DKfavormormon DKfavortea
	DKideo DKideobo DKideomr DKideojh DKmatch_mr DKmatch_jh DKpluto DKdefense DKchur DKtaxes DKimmi DKhealth 
	DKmeds DKretro DKturnout DKchoice DKgym DKreg DKdrink DKabort {;
		qui reg `v' treat i.block;
		qui replace name = "`v'" in `i';
		qui replace meandiff = _b[treat] in `i';
		qui replace sediff = _se[treat] in `i';
		local i = `i' + 1;
	};
	
	
/*
*** BATCH THREE STARTS HERE ***	
* Calculate confidence intervals.
*/

# delimit cr
	
gen CIlo = meandiff + (sediff*-1.96)
gen CIhi = meandiff + (sediff*1.96)

* Shortcut variables for whether mean difference is sigificantly positive (or negative)
gen sig = .
replace sig = 1 if CIlo >0
replace sig = 0 if CIlo <=0
replace sig = . if CIlo == .
replace sig = -1 if CIhi<0

* Turn these measures into percentages
replace meandiff = meandiff*100
replace CIlo = CIlo*100
replace CIhi = CIhi*100



*** Next, create the "class" of variables as in Table 1: 
*** For FIGURE 1 (explicit DK), Figure 2 (others), open-ends, and the Trust question (mixed DK) 
set more off
 
* VARS in FIGURE 1 
# delimit ;
capture drop FIG1;
gen FIG1 = .;
foreach i in DKfavorbo DKfavorjh DKfavormr DKfavormuslim DKfavormormon DKfavortea
	DKideo DKideobo DKideomr DKideojh DKmatch_mr DKmatch_jh DKpluto DKdefense DKchur DKtaxes DKimmi DKhealth 
	DKmeds DKretro DKturnout DKchoice DKgym DKreg DKdrink {;
		replace FIG1 = 1 if name == "`i'";
		};

* VARS in FIGURE 2		
# delimit ;
foreach i in DKmoby DKteaparty DKgaymar
	DKwsum1 DKwsum2 DKwsum5 DKwsum4 DKrr_1 DKrr_2 DKrr_3 DKrr_4 DKbible DKpartyid 
	DKinterest DKnewsp DKsmoke DKabort
	DKdentis DKincome DKtech DKrace DKeduc DKabort{;
		replace FIG1 = 0 if name == "`i'";
		};


* VARS in open-ends;
#delimit cr
foreach i in DKvpcode DKprimecode DKrobertscode {
	replace FIG1 = -1 if name == "`i'"
	}

* TRUST QUESTION w/mixed DK OPTIONS
replace FIG1 = -2 if name == "DKtrust"



*** BATCH FOUR STARTS HERE ***


************************************* BACK TO TABLES *******************************************
*** FOR "CLASSES" OF DK TYPES (in Table 2) RUN T-TEST
*** TABLE 2 T-TESTS: Is average difference significant? Yes. Asks: is the average difference 0?
set more off

ttest meandiff= 0 if FIG1 ==1
ttest meandiff= 0 if FIG1 ==0

***TABLE 3 (TTESTS):
prtest sig == .025 if sig >=0 & FIG1 == 1
prtest sig == .025 if sig >=0 & FIG1 == 0

* This shows proportions for three classes of questions in Table 3
tab sig FIG1 if FIG1 > -2,col chi

* Testing independence for the categories in Fig 1 and 2 only
tab sig FIG1 if FIG1 >=0, col chi




********* FIGURES 1 and 2.  These are mock-ups, production figures made by different program.
# delimit ;graph dot meandiff CIlo CIhi if meandiff != . & FIG1 == 1, ysize(10) xsize(9)over(name, sort(meandiff) descending label(labcolor(gray) labsize(vsmall)) axis(lcolor(gray))) marker(1, msymbol(circle) msize(vsmall) mcolor(black))
		marker(2, msymbol(plus) msize(small) mcolor(dimgray)) 
		marker(3, msymbol(plus) msize(small) mcolor(dimgray)) linetype(line) lines(lcolor(dimgray) 
lpattern(solid) lwidth(vvthin)) ytitle("Percentage Point Difference", size(vsmall) color(gray) margin(medium)) yscale(lcolor(gray)) 
ylabel(, tlcolor(gray) labcolor(gray) labsize(small)) 
yline(0, lcolor(dimgray))
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) 
plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
legend(off);# delimit ;graph dot meandiff CIlo CIhi if meandiff != . & FIG1 == 0, ysize(10) xsize(9)over(name, sort(meandiff) descending label(labcolor(gray) labsize(vsmall)) axis(lcolor(gray))) marker(1, msymbol(circle) msize(vsmall) mcolor(black))
		marker(2, msymbol(plus) msize(small) mcolor(dimgray)) 
		marker(3, msymbol(plus) msize(small) mcolor(dimgray)) linetype(line) lines(lcolor(dimgray) 
lpattern(solid) lwidth(vvthin)) ytitle("Percentage Point Difference", size(vsmall) color(gray) margin(medium)) yscale(lcolor(gray)) 
ylabel(, tlcolor(gray) labcolor(gray) labsize(small)) 
yline(0, lcolor(dimgray))
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) 
plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
legend(off);

	