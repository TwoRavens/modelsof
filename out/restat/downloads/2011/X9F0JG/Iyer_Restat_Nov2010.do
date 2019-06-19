/*****Stata do file for article: "Direct versus Indirect Colonial Rule in India: Long-Term Consequences"***/
/****this runs on Stata version 10***/

version 10
set more off
clear
clear matrix
set mem 700m
set matsize 800
capture log close
log using Iyer_Restat_Nov2010.log, replace



***********************************************************************************
/***table 2: differences in geography and demographics***/
***********************************************************************************
use rawfiles/dist_brit_instru.dta, clear
foreach X of varlist lat alt totrain coastdummy sands91 barrenrocky91 so_black so_all so_red {
ttest `X', by(britdum)
regress `X' britdum, cluster(kcode1)
}




***********************************************************************************
/**table 3: differences in agricultural investments and productivity: OLS***/
***********************************************************************************
use table3.dta, clear

regress irr_g britdum  , cluster(kcode1)
outreg britdum using table3.out, replace se coefastr 3aster title("Table 3 results: Ignore first column")

foreach  X of varlist irr_g pfert phtot lyld lyrice lywhet {
/***col 1: no controls****/
regress `X' britdum , cluster(kcode1)
outreg britdum using table3.out, append se coefastr 3aster

/****col 2: GEOGRAPHY CONTROLS****/
regress `X' britdum lat totrain coastal alt so_black so_all so_red sands91 barrenrocky91, cluster(kcode1)
outreg britdum using table3.out, append se coefastr 3aster


/****col 3: DIFFERENT MODES OF CONQUEST****/
regress `X' ann_conquest ann_ceded ann_misrule ann_lapse lat totrain coastal alt so_black so_all so_red sands91 barrenrocky91, cluster(kcode1)
outreg ann_conquest ann_ceded ann_misrule ann_lapse using table3.out, append se coefastr 3aster

/****col 4: YEARS OF DIRECT BRITISH RULE****/
regress `X' ydirbrit lat totrain coastal alt so_black so_all so_red sands91 barrenrocky91, cluster(kcode1)
outreg ydirbrit using table3.out, append se coefastr 3aster
}


***********************************************************************************
/***table 4: differences in public goods levels: OLS***/
***********************************************************************************
use table4.dta, clear
regress pprimary britdum, cluster(kcode1)
outreg britdum using table4.out, replace se coefastr 3aster title ("Table 4, public goods OLS, ignore first column")

foreach var of varlist pprimary pmiddle phigh pphc pphs pcanal pproad {
/***col 1: no controls****/
	regress `var' britdum, cluster(kcode1)
	outreg britdum using table4.out, append se coefastr 3aster

/****col 2: geography controls***/
	regress `var' britdum lat totrain coastdummy sands91 barrenrocky91 , cluster(kcode1)
outreg britdum using table4.out, append se coefastr 3aster


/****WB agri dataset controls****/
regress `var' britdum lat totrain coastdummy sands91 barrenrocky91 so_black so_all so_red, cluster(kcode1)
outreg britdum using table4.out ,append se coefastr 3aster

/****col 4: by mode of conquest****/
regress `var' ann_conquest ann_ceded ann_misrule ann_lapse lat totrain coastdummy sands91 barrenrocky91 , cluster(kcode1)
outreg ann_conquest ann_ceded ann_misrule ann_lapse using table4.out ,append se coefastr 3aster


/***using number of years of direct British rule***/
regress `var' ydirbrit lat totrain coastdummy sands91 barrenrocky91 , cluster(kcode1)
outreg ydirbrit using table4.out ,append se coefastr 3aster

}


***********************************************************************************
/***table 6: first stage of IV strategy****/
***********************************************************************************
use table4.dta, clear

regress britdum instru if dtannex>1847, cluster(kcode1)
outreg instru using table6.out, replace se coefastr 3aster title("Table 6: first stage results")

regress britdum instru lat totrain coastdummy sands91 barrenrocky91  if dtannex>1847, cluster(kcode1)
outreg instru lat totrain coastdummy sands91 barrenrocky91 using table6.out, append se coefastr 3aster

regress britdum instru lat totrain coastdummy sands91 barrenrocky91 alt so_black so_all so_red if dtannex>1847, cluster(kcode1)
outreg instru lat totrain coastdummy sands91 barrenrocky91 alt so_black so_all so_red using table6.out, append se coefastr 3aster

regress britdum instru dspever death1848to56 lat totrain coastdummy sands91 barrenrocky91  if dtannex>1847, cluster(kcode1)
outreg instru dspever death1848to56 lat totrain coastdummy sands91 barrenrocky91 using table6.out, append se coefastr 3aster

regress britdum instru dspever death1848to56 lat totrain coastdummy sands91 barrenrocky91 if keep==1 & dtannex>1847, cluster(kcode1)
outreg instru dspever death1848to56 lat totrain coastdummy sands91 barrenrocky91 using table6.out, append se coefastr 3aster

***********************************************************************************
/***table 7: differences in agricultural investments and productivity: IV estimates***/
***********************************************************************************
use table7.dta, clear

/***column 1: means***/
summ irr_g pfert phtot lyld lyrice lywhet 

/***col 2: same as Table 3, Column 2****/

regress irr_g britdum  , cluster(kcode1)
outreg britdum using table7.out, replace se coefastr 3aster title("Table 7 results: Ignore first column")

foreach  X of varlist irr_g pfert phtot lyld lyrice lywhet {

/***col 3: OLS for post-1847 sample****/
regress `X' britdum lat totrain coastal so_black so_all so_red sands91 barrenrocky91 if dtannex>1847, cluster(kcode1)
outreg britdum using table7.out, append se coefastr 3aster

/***col 4: IV regressions***/
ivreg `X' (britdum=instru)  lat totrain coastal so_black so_all so_red sands91 barrenrocky91 if dtannex>1847, cluster(kcode1)
outreg britdum using table7.out, append se coefastr 3aster

/**** col 5: IV regressions dropping Punjab, Oudh and Berar****/
ivreg `X' (britdum=instru) lat totrain coastal  so_black so_all so_red sands91 barrenrocky91 if keep==1 & dtannex>1847, cluster(kcode1)
outreg britdum using table7.out, append se coefastr 3aster
}

***********************************************************************************
/***table 8: differences in public goods levels: IV estimates****/
***********************************************************************************
use table4.dta, clear
regress pprimary britdum, cluster(kcode1)
outreg britdum using table8.out, replace se coefastr 3aster title("Table 8, ignore first column")

foreach var of varlist pprimary pmiddle phigh pphc pphs pcanal pproad {

/***ols in restricted sample***/
	regress `var' britdum lat totrain coastdummy sands91 barrenrocky91 if dtannex>1847, cluster(kcode1)
	outreg britdum using table8.out, append se coefastr 3aster

/***IV estimates***/
ivreg `var' (britdum=instru) lat totrain coastdummy sands91 barrenrocky91 if dtannex>1847, cluster(kcode1)
outreg britdum using table8.out ,append se coefastr 3aster


/***IV estimates dropping Punjab, Berar, Oudh***/
ivreg `var' (britdum=instru) lat totrain coastdummy sands91 barrenrocky91 if dtannex>1847 & keep==1, cluster(kcode1)
outreg britdum using table8.out ,append se coefastr 3aster

}

***********************************************************************************
/****table 9: health and education outcomes***/
***********************************************************************************
use tablea1.dta, clear
****literacy rates
xi i.year
regress plit britdum lat totrain coastdummy sands91 barrenrocky91 _Iyear* ,cluster(kcode1)
outreg britdum lat totrain coastdummy sands91 barrenrocky91 using table9a.out, replace se coefastr 3aster title("Table 9, literacy and infant mortality")

ivreg plit (britdum=instru) lat totrain coastdummy sands91 barrenrocky91 _Iyear* if dtannex>1847,cluster(kcode1)
outreg britdum lat totrain coastdummy sands91 barrenrocky91 using table9a.out, append se coefastr 3aster

****infant mortality rates
use table9a.dta, clear
regress infmort britdum lat totrain coastdummy sands91 barrenrocky91 if year==1981 , cluster(kcode1)
outreg britdum using table9a.out, append se coefastr 3aster
regress infmort britdum lat totrain coastdummy sands91 barrenrocky91 if year==1991 , cluster(kcode1)
outreg britdum using table9a.out, append se coefastr 3aster
ivreg infmort (britdum=instru) lat totrain coastdummy sands91 barrenrocky91 so_* if year==1981 & dtannex>1847, cluster(kcode1)
outreg britdum using table9a.out, append se coefastr 3aster
ivreg infmort (britdum=instru) lat totrain coastdummy sands91 barrenrocky91 so_* if year==1991  & dtannex>1847, cluster(kcode1)
outreg britdum using table9a.out, append se coefastr 3aster


***********************************************************************************
/***9b: poverty and inequality****/
***********************************************************************************
use table9b.dta, clear
regress inpov britdum
outreg britdum using table9b.out, replace se coefastr 3aster title("Table 9, poverty and inequality, ignore first column")

foreach  num of numlist 38 43 50  {
foreach var of varlist inpov stdlog {

	regress `var' britdum lat totrain coastdummy sands91 barrenrocky91 if round==`num',cluster(kcode1)
	outreg britdum using table9b.out, append se coefastr 3aster

	ivreg `var' (britdum=instru) lat totrain coastdummy sands91 barrenrocky91 if dtannex>1847 & round==`num',cluster(kcode1)
	outreg britdum using table9b.out, append se coefastr 3aster

}
}


***********************************************************************************
/***table 10: reduced form regressions for public goods: robustness checks****/
***********************************************************************************
use table10.dta, clear
regress pprimary instru, cluster(kcode1)
outreg instru using table10.out, replace se coefastr 3aster title ("Table 10 reduced form (ignore first column)")

foreach X in pprimary pmiddle phigh pphc pphs pcanal pproad {
***col1: base spec
regress `X' instru  lat totrain coastdummy sands91 barrenrocky91 if dtannex>1847, cluster(kcode1)
outreg instru  using table10.out, append se coefastr 3aster

***col2: with main effects
regress `X' instru dspever death1848to56 lat totrain coastdummy sands91 barrenrocky91 if dtannex>1847, cluster(kcode1)
outreg instru  using table10.out, append se coefastr 3aster

/****col 3: falsification exercise****/
regress `X' instru_fake lat totrain coastdummy sands91 barrenrocky91 if britdum==0, cluster(kcode1)
outreg instru_fake  using table10.out, append se coefastr 3aster

/***col 4: with state fixed effects****/
regress `X' instru lat totrain coastdummy  sands91 barrenrocky91 statedum* if dtannex>1847, cluster(kcode1)
outreg instru  using table10.out, append se coefastr 3aster
}

/****col 5: randomization infernece: exact p-values****/
capture drop dupking
sort kcode1 dcode_full
qui by kcode1: gen dupking=cond(_N==1,0,_n)
tab dupking

keep if dtannex>1847

set seed 2345
randinf instru, trials(400) mixtype(2) command ("regress pprimary instru lat totrain coastdummy sands91 barrenrocky91 ")
set seed 2345
randinf instru, trials(400) mixtype(2) command ("regress pmiddle instru lat totrain coastdummy sands91 barrenrocky91 ")
set seed 2345
randinf instru, trials(400) mixtype(2) command ("regress phigh instru lat totrain coastdummy sands91 barrenrocky91 ")
set seed 2345
randinf instru, trials(400) mixtype(2) command ("regress pphc instru lat totrain coastdummy sands91 barrenrocky91 ")
set seed 2345
randinf instru, trials(400) mixtype(2) command ("regress pphs instru lat totrain coastdummy sands91 barrenrocky91 ")
set seed 2345
randinf instru, trials(400) mixtype(2) command ("regress pcanal instru lat totrain coastdummy sands91 barrenrocky91 ")
set seed 2345
randinf instru, trials(400) mixtype(2) command ("regress pproad instru lat totrain coastdummy sands91 barrenrocky91 ")

/****col 6: running propensity score matching****/
/***calculating propensity score****/
keep if dtannex>1847
pscore instru lat totrain coastdummy sands91 barrenrocky91, pscore(psmvar1)
keep if psmvar1~=.

/****PSM using Kernel matching method and bootstrapped standard errors****/
attk pprimary instru lat totrain coastdummy sands91 barrenrocky91 if dtannex>1847, pscore(psmvar1) bootstrap
attk pmiddle instru lat totrain coastdummy sands91 barrenrocky91 if dtannex>1847, pscore(psmvar1) bootstrap
attk phigh instru lat totrain coastdummy sands91 barrenrocky91 if dtannex>1847, pscore(psmvar1) bootstrap
attk pphc instru lat totrain coastdummy sands91 barrenrocky91 if dtannex>1847, pscore(psmvar1) bootstrap
attk pphs instru lat totrain coastdummy sands91 barrenrocky91 if dtannex>1847, pscore(psmvar1) bootstrap
attk pcanal instru lat totrain coastdummy sands91 barrenrocky91 if dtannex>1847, pscore(psmvar1) bootstrap
attk pproad instru lat totrain coastdummy sands91 barrenrocky91 if dtannex>1847, pscore(psmvar1) bootstrap



***********************************************************************************
/***table 11: differences in public goods levels in 1961 and 1911***/
***********************************************************************************

***********************************************************************************
/***table 11a: 1961 public goods***/
***********************************************************************************
use table11a.dta, clear

regress pprimary britdum , cluster(kcode1)
outreg britdum using table11a.out, replace se coefastr 3aster title("Table 11, 1961 public goods (ignore first column)")

foreach X of varlist pprimary pmiddle phigh pdisp pruralhc pcanal proad {
***OLS, full sample
regress `X' britdum lat totrain coastdummy sands91 barrenrocky91, cluster(kcode1)
outreg britdum using table11a.out, append se coefastr 3aster

***IV for post-1847 sample
ivreg `X' (britdum=instru) lat totrain coastdummy sands91 barrenrocky91 if dtannex>1847, cluster(kcode1)
outreg britdum using table11a.out, append se coefastr 3aster

****IV dropping Punjab, Oudh, Berar
ivreg `X' (britdum=instru) lat totrain coastdummy sands91 barrenrocky91 if dtannex>1847 & keep==1, cluster(kcode1)
outreg britdum using table11a.out, append se coefastr 3aster
}

***********************************************************************************
/***table 11b: 1911 literacy***/
***********************************************************************************

use table11b.dta, clear

/****OLS regressions****/
regress plit britdum tpop sexratio if plit<0.5 & pakistan~=1, cluster(kcode1)
/***IV regressions***/
ivreg plit (britdum=instru) tpop sexratio if plit<0.5 & pakistan~=1, cluster(kcode1)
/***IV excluding Punjab, Berar, Oudh, Panchmahals***/
ivreg plit (britdum=instru) tpop sexratio if plit<0.5 & pakistan~=1 & kcode1~=1003 & kcode1~=1030 & kcode1~=1035 & kcode1~=1029, cluster(kcode1)


***********************************************************************************
/****table 12: the role of tax revenues, institutions and ruler quality***/
***********************************************************************************
****col 2: interaction with tax revenue per capita: TBD
use table4.dta, clear

regress pprimary britdum 
outreg britdum using table12a.out, replace se coefastr 3aster title("Table 12, Tax revenue per capita, ignore first column")

foreach var of varlist pprimary pmiddle phigh pphc pphs pcanal pproad {
ivreg `var' (britdum=instru) revpop  lat totrain coastdummy sands91 barrenrocky91 if dtannex>1847, cluster(kcode1)
outreg britdum revpop using table12a.out, append se coefastr 3aster
}

****col 3: interaction with land tenure system
use tablea2.dta, clear
regress pprimary britdum mahrai
outreg britdum mahrai using table12b.out, replace se coefastr 3aster title("Table 12, Land tenure system, ignore first column")

foreach var of varlist pprimary pmiddle phigh pphc pphs pcanal pproad {
ivreg `var' (britdum=instru) mahrai lat totrain coastdummy sands91 barrenrocky91 if dtannex>1847, cluster(kcode1)
outreg britdum mahrai using table12b.out, append se coefastr 3aster
}

*****col 4: ruler ever deposed
use table12c.dta, clear
regress pphc britdum depose_1858 
outreg britdum depose_1858 using table12c.out, replace se coefastr 3aster title ("Table 12, column 4 (ignore first column)")

foreach var of varlist pprimary pmiddle phigh pphc pphs pcanal pproad {

ivreg `var' (britdum=instru) depose_1858 lat totrain coastdummy sands91 barrenrocky91 if dtannex>1847, cluster(kcode1)
outreg britdum depose_1858 using table12c.out, append se coefastr 3aster
test britdum-depose_1858=0

}

***********************************************************************************
/***table A1: impact of colonial rule on structural change***/
***********************************************************************************
use tablea1.dta, clear
xi i.year

regress pmanuf britdum
outreg britdum using tablea1.out, replace se coefastr 3aster title("Table A.1, ignore first column")

foreach var of varlist pmanuf pfarm {
	regress `var' britdum lat totrain coastdummy sands91 barrenrocky91 _Iyear* ,cluster(kcode1)
	outreg britdum lat totrain coastdummy sands91 barrenrocky91 using tablea1.out, append se coefastr 3aster

	ivreg `var' (britdum=instru) lat totrain coastdummy sands91 barrenrocky91 _Iyear* if dtannex>1847,cluster(kcode1)
	outreg britdum lat totrain coastdummy sands91 barrenrocky91 using tablea1.out, append se coefastr 3aster
}

foreach var of varlist pmanufr pfarmr {
	regress `var' britdum lat totrain coastdummy sands91 barrenrocky91 if year==1991,cluster(kcode1)
	outreg britdum lat totrain coastdummy sands91 barrenrocky91 using tablea1.out, append se coefastr 3aster

	ivreg `var' (britdum=instru) lat totrain coastdummy sands91 barrenrocky91 if year==1991 & dtannex>1847,cluster(kcode1)
	outreg britdum lat totrain coastdummy sands91 barrenrocky91 using tablea1.out, append se coefastr 3aster
	}

***********************************************************************************
/***table A2: does the religion of hte ruler make a difference***/
***********************************************************************************
use tablea2.dta, clear
regress pphc britdum kmuslim ksikh lat totrain coastdummy sands91 barrenrocky91 if dtannex>1847, cluster(kcode1)
outreg britdum kmuslim ksikh using tablea2.out, replace se coefastr 3aster title("Table A.2, ignore first column")

foreach var of varlist pprimary pmiddle phigh pphc pphs pcanal pproad {

ivreg `var' (britdum=instru) kmuslim ksikh lat totrain coastdummy sands91 barrenrocky91 if dtannex>1847, cluster(kcode1)
outreg britdum kmuslim ksikh using tablea2.out, append se coefastr 3aster
}




***********************************************************************************
/***table A3: is there convergence in public goods provision?****/
***********************************************************************************
use table10.dta, clear
regress pprimary britdum pprimary61, cluster(kcode1)
outreg britdum pprimary61 using tableA3.out, replace se coefastr 3aster title ("Table A3, ignore first column")

foreach var of varlist pprimary pmiddle phigh pphc pcanal pproad {
regress `var'  britdum lat totrain coastdummy sands91 barrenrocky91  so_black so_all so_red `var'61, cluster(kcode1)
outreg britdum `var'61 using tableA3.out, append se coefastr 3aster

ivreg `var'  (britdum=instru) lat totrain coastdummy sands91 barrenrocky91  so_black so_all so_red `var'61 if dtannex>1847, cluster(kcode1)
outreg britdum `var'61 using tableA3.out, append se coefastr 3aster

}



***********************************************************************************
/***table A4: political participation and competition****/
***********************************************************************************
*********voter turnout and winning maring for state elections in the 1960s
use tablea4a.dta, clear
regress turnout britdum
outreg britdum using tablea4.out, replace se coefastr 3aster title("Table A.4, ignore first column")

foreach var of varlist turnout winmargin {

	regress `var' britdum lat totrain coastdummy sands91 barrenrocky91 ,cluster(kcode1)
	outreg britdum using tablea4.out, append se coefastr 3aster
	ivreg `var' (britdum=instru) lat totrain coastdummy sands91 barrenrocky91 if dtannex>1847,cluster(kcode1)
	outreg britdum using tablea4.out, append se coefastr 3aster
}


****Voter turnout and winning margin for state elections in post-1980 period
use tablea4b.dta, clear
foreach X of varlist total_turnout votemargin_share {
regress `X' britdum lat totrain coastdummy sands barrenrocky, cluster(kcode1)
outreg britdum using tablea4.out, append se coefastr 3aster

ivreg `X' (britdum=instru_brit) lat totrain coastdummy sands barrenrocky if dtannex>1847, cluster(kcode1)
outreg britdum using tablea4.out, append se coefastr 3aster
}
***********************************************************************************
/***table A5: impact of land tenure systems****/
***********************************************************************************
use tablea2.dta, clear
regress pphc britdum 
outreg britdum using tablea5.out, replace se coefastr 3aster title("Table A.5, ignore first column")

foreach var of varlist pprimary pmiddle phigh pphc pphs pcanal pproad {
regress `var' mahrai lat totrain coastdummy sands91 barrenrocky91 if britdum==1, cluster(kcode1)
outreg mahrai  lat totrain coastdummy sands91 barrenrocky91 using tablea5.out, append se coefastr 3aster

regress `var' mahrai lat totrain coastdummy sands91 barrenrocky91 if britdum==0, cluster(kcode1)
outreg mahrai  lat totrain coastdummy sands91 barrenrocky91 using tablea5.out, append se coefastr 3aster
}


***********************************************************************************
/***Regressions for combined public goods****/
***********************************************************************************
use combined.dta, clear
/****Table 4: OLS REGRESSIONS****/
/***no controls****/
regress public britdum _Ipubtype*, cluster(kcode1)
outreg britdum using public_combined1.out, replace se coefastr 3aster title("Tables 4, 8, 10, combined public goods results")
/****sandy/barren proportion****/
regress public britdum lat totrain coastdummy sands91 barrenrocky91 _Ipubtype*, cluster(kcode1)
outreg britdum lat totrain coastdummy sands91 barrenrocky91 using public_combined1.out ,append se coefastr 3aster
/***soil dummies****/
regress public britdum lat totrain coastdummy sands91 barrenrocky91 so_black so_all so_red _Ipubtype*, cluster(kcode1)
outreg britdum lat totrain coastdummy sands91 barrenrocky91 so_black so_all so_red using public_combined1.out ,append se coefastr 3aster
/****by mode of conquest****/
regress public ann_conquest ann_ceded ann_misrule ann_lapse lat totrain coastdummy sands91 barrenrocky91    _Ipubtype*, cluster(kcode1)
outreg ann_conquest ann_ceded ann_misrule ann_lapse lat totrain coastdummy sands91 barrenrocky91 using public_combined1.out ,append se coefastr 3aster
/***using number of years of direct British rule***/
regress public ydirbrit lat totrain coastdummy sands91 barrenrocky91 _Ipubtype* , cluster(kcode1)
outreg ydirbrit lat totrain coastdummy sands91 barrenrocky91 using public_combined1.out ,append se coefastr 3aster

/******Table 8: IV regressions****/
/***col 3: OLS in post-1847 sample***/
regress public britdum lat totrain coastdummy sands91 barrenrocky91 _Ipubtype* if dtannex>1847 , cluster(kcode1)
outreg britdum lat totrain coastdummy sands91 barrenrocky91 using public_combined1.out ,append se coefastr 3aster
***col 4: IV
ivreg public (britdum=instru)  lat totrain coastdummy sands91 barrenrocky91 _Ipubtype* if dtannex>1847, cluster(kcode1)
outreg britdum lat totrain coastdummy sands91 barrenrocky91 using public_combined1.out, append se coefastr 3aster
/*****col 5: dropping punjab, oudh and berar*****/
ivreg public (britdum=instru)  lat totrain coastdummy sands91 barrenrocky91 _Ipubtype* if keep==1, cluster(kcode1)
outreg britdum lat totrain coastdummy sands91 barrenrocky91 using public_combined1.out, append se coefastr 3aster


/******Table 10: reduced form*****/
/***col 1: for post-1847 sample*****/
regress public instru  lat totrain coastdummy sands91 barrenrocky91 _Ipubtype* if dtannex>1847, cluster(kcode1)
outreg instru  lat totrain coastdummy sands91 barrenrocky91 using public_combined1.out, append se coefastr 3aster
/***excluding primary schools***/
regress public instru  lat totrain coastdummy sands91 barrenrocky91 _Ipubtype* if dtannex>1847 & pubtype~=1, cluster(kcode1)
outreg instru  lat totrain coastdummy sands91 barrenrocky91 using public_combined_woprimary.out, replace se coefastr 3aster title("Table 10, combined public goods excluding primary schools")

/***col2: with main effects****/
regress public instru dspever death1848to56 lat totrain coastdummy sands91 barrenrocky91 _Ipubtype* if dtannex>1847, cluster(kcode1)
outreg instru  lat totrain coastdummy sands91 barrenrocky91 dspever death1848to56 using public_combined1.out, append se coefastr 3aster
regress public instru dspever death1848to56 lat totrain coastdummy sands91 barrenrocky91 _Ipubtype* if dtannex>1847 & pubtype~=1, cluster(kcode1)
outreg instru  lat totrain coastdummy sands91 barrenrocky91 dspever death1848to56 using public_combined_woprimary.out, append se coefastr 3aster

/****col 3: falsification exercise****/
regress public instru_fake lat totrain coastdummy sands91 barrenrocky91 _Ipubtype* if britdum==0, cluster(kcode1)
outreg instru_fake  lat totrain coastdummy sands91 barrenrocky91 using public_combined1.out, append se coefastr 3aster
regress public instru_fake lat totrain coastdummy sands91 barrenrocky91 _Ipubtype* if britdum==0 & pubtype~=1, cluster(kcode1)
outreg instru_fake  lat totrain coastdummy sands91 barrenrocky91 using public_combined_woprimary.out, append se coefastr 3aster

/****col 4: with state fixed effects***/
gen state=int(dcode_full/100)
xi i.state i.pubtype
regress public instru lat totrain coastdummy sands91 barrenrocky91 _Ipubtype* _Istate* if dtannex>1847, cluster(kcode1)
outreg instru  lat totrain coastdummy sands91 barrenrocky91 using public_combined1.out, append se coefastr 3aster
regress public instru lat totrain coastdummy sands91 barrenrocky91 _Ipubtype* _Istate* if dtannex>1847 & pubtype~=1, cluster(kcode1)
outreg instru  lat totrain coastdummy sands91 barrenrocky91 using public_combined_woprimary.out, append se coefastr 3aster

/****col 5 and col 6: randomization inference and propensity score matching****/
keep if dtannex>1847
capture drop dupking
sort kcode1 dcode_full
qui by kcode1: gen dupking=cond(_N==1,0,_n)
tab dupking

set seed 2345
randinf instru, trials(400) mixtype(2) command ("regress public instru lat totrain coastdummy sands91 barrenrocky91 _Ipubtype* ")

/****PSM using Kernel matching method and bootstrapped standard errors****/
pscore instru lat totrain coastdummy sands91 barrenrocky91 if pubtype==4, pscore(psmvar1)
egen mpsm=mean(psmvar1), by(dcode_full)
replace psmvar1=mpsm if psmvar1==.
keep if psmvar1~=.
set seed 2345
attk public instru lat totrain coastdummy sands91 barrenrocky91 _Ipubtype*, pscore(psmvar1) bootstrap

/***col 5 and 6 without primary schools****/
keep if pubtype~=1
set seed 2345
randinf instru, trials(400) mixtype(2) command ("regress public instru lat totrain coastdummy sands91 barrenrocky91 _Ipubtype* ")
set seed 2345
attk public instru lat totrain coastdummy sands91 barrenrocky91 _Ipubtype* if pubtype~=1, pscore(psmvar1) bootstrap

/*****Table 12, combined public goods*****/
use combined.dta, clear
ivreg public (britdum=instru) revpop  lat totrain coastdummy sands91 barrenrocky91 _Ipubtype* if dtannex>1847, cluster(kcode1)
outreg britdum revpop using combined_table12.out, replace se coefastr 3aster title("Table 12, combined public goods results")

ivreg public (britdum=instru) mahrai lat totrain coastdummy sands91 barrenrocky91 _Ipubtype* if dtannex>1847, cluster(kcode1)
outreg britdum mahrai using combined_table12.out, append se coefastr 3aster

ivreg public (britdum=instru) depose_1858 lat totrain coastdummy sands91 barrenrocky91 _Ipubtype* if dtannex>1847, cluster(kcode1)
outreg britdum depose_1858 using combined_table12.out, append se coefastr 3aster

