clear
set virtual on
set memory 7000g
set maxvar 20000
global pathdata "/Users/michaelkoetter/Documents/Research/Published/CUS/Replication"
global pathout "/Users/michaelkoetter/Documents/Research/Published/CUS/Replication"
cd $pathdata
set more off

use 2a_QLH, clear
tabstat lerner* ce pe, s(mean) by(year) c(v) format(%9.3f)
sort entity year
merge entity year using 2b_QLH
drop _merge

*****************************************
* Dstats on Lerner indices, MC, p & Eff *
*****************************************
label var ar "Average returns predicted by profit SFA"
label var p "Average returns observed"
label var pe "Alternative profit efficiency"
label var ce "Cost efficiency"
label var lerner_1 "Lerner index OLS"
label var lerner_5 "Lerner index SFA"
label var mc_ols "Marginal cost from OLS cost function"
label var mc "Marginal cost from SFA cost frontier"
tabstat mc* p ar lerner_1 lerner_5 ce pe, stats( mean sd p95 p5) col(stat)
corr lerner_1 lerner_5 ce pe
**********************************
* Risk proxies and fixed effects *
**********************************
bysort year: egen RANKTA=rank(1/TA)
gen TOPHUN=1 if RANKTA<101
replace TOPHUN=0 if RANKTA>100
label var TOPHUN "Among largest 100 banks"
bysort year: egen SUMTA=sum(TA)
bysort year: egen SUMTA100=sum(TA) if TOPHUN==1
bysort year: gen test=SUMTA100/SUMTA
bysort year: egen CR100=mean(test)
label var CR100 "Asset concentration ratio largest 100 banks"
drop test

bysort year state: egen RANK_TA_STATE=rank(1/TA)
bysort year state: egen SUM_TA_STATE=sum(TA)
bysort year state: egen SUMTA5=sum(TA) if RANK_TA_STATE<6
bysort year state: gen test=SUMTA5/SUM_TA_STATE if RANK_TA_STATE<6
bysort year state: egen CR5_state=mean(test)
label var CR5_state "Asset concentration ratio largest 5 banks per state"drop test
gen MS_state=TA/SUM_TA_STATE*100
label var MS_state "Asset market share per state"
bysort year county: egen RANK_TA_COUNTY=rank(1/TA)
bysort year county: egen SUM_TA_COUNTY=sum(TA)
bysort year county: egen help=sum(TA) if RANK_TA_COUNTY<6
bysort year county: gen test=help/SUM_TA_COUNTY if RANK_TA_COUNTY<6
bysort year county: egen CR5_county=mean(test)
label var CR5_county "Asset concentration ratio largest 5 banks per county"drop test help
gen MS_county=TA/SUM_TA_COUNTY*100
label var MS_county "Asset market share per county"

*gen OBSshare=OBS/TA*100
gen SEC=Y2/TA*100
label var SEC "securites share of total assets"
egen help=rowtotal(REL AL CIL IL)
gen OL=ToLoLe-help
gen SY1=(REL/ToLoLe)^2
gen SY2=(AL/ToLoLe)^2
gen SY3=(CIL/ToLoLe)^2
gen SY4=(IL/ToLoLe)^2
gen SY5=(OL/ToLoLe)^2
egen SCOPE=rowtotal(SY1 SY2 SY3 SY4 SY5)
drop help
label var SCOPE "HHI index across five loan categories"

gen INC= LoInc/OI*100
label var INC "Loan interest and fees of operating income"
drop if INC>100 | INC==.
gen LLPshare=LLP/ToLoLe*100
label var LLPshare "Loan loss provision to total loans"
gen LLRshare=LLR/ToLoLe*100
label var LLRshare "Loan loss reserves to total loans"

sum lerner* TOPHUN CR5* CR100 MS* SEC SCOPE INC ZSCORE LLPshare LLRshare
replace CR5_state=CR5_state*100
replace CR5_county=CR5_county*100

tab state, gen(DSTATE)
tab year, gen(DYEAR)
************************************************************
* Deregulation indicators and dummies for Strahan approach *
************************************************************
tsset entity year
gen INTRA=0
replace INTRA=1 if intra1<=year
gen INTER=0
replace INTER=1 if inter<=year
gen INTRAL1=INTRA*l.lerner_1
gen INTRAL5=INTRA*l.lerner_5
gen INTERL1=INTER*l.lerner_1
gen INTERL5=INTER*l.lerner_5
************************************************************
* Deregulation indicators and dummies from Rice (97-04) *
************************************************************
ren bri BRI
ins BRI
tab year BRI /* coded such that a '1' indicates more restricve regulation. Recode to align with Strahan paper */
local BRI="bri1 bri2 bri3 bri4 bri5"
foreach x of local BRI{
	replace `x'=2 if `x'==1
	replace `x'=1 if `x'==0
	replace `x'=0 if `x'==2
}

local BRI="BRI bri1 bri2 bri3 bri4 bri5"
foreach x of local BRI{
	gen `x'L1=`x'*l.lerner_1
	label var `x'L1 "Interaction of `x' and Lerner OLS"
	gen `x'L5=`x'*l.lerner_5	
	label var `x'L5 "Interaction of `x' and Lerner SFA"
}
*********************
* Instrument choice *
*********************
sort entity year
tsset entity year
gen LAGlerner1=l.lerner_1 
gen LAGlerner5=l.lerner_5 
*********************
* Ethnicity inditrs *
*********************
egen Asian=rowtotal(eth1 eth2 eth3 eth4 eth5 eth6 eth7 eth8 eth9 eth10 eth11)
egen Hispanic=rowtotal(eth16 eth17 eth18 eth19)
egen Pacific=rowtotal(eth12 eth13 eth14 eth15)
mvdecode Asian Hispanic Pacific, mv(0)
local ETH="Asian Pacific Hispanic"
foreach e of local ETH{
	forval t=1980(10)1990{
		bysort state: gen `e'_`t'=`e' if year==`t'
		bysort state: egen Mean_`e'_`t'=mean(`e'_`t')
	}
}

local ETH="Asian Pacific Hispanic"
foreach e of local ETH{
	replace `e'=Mean_`e'_1980 if year<1986 & `e'==.
	replace `e'=Mean_`e'_1990 if year>1985 & `e'==.
	label var `e' "Census years 1980 and 1990 population of `e' ethnicity"
	gen Share`e'=`e'/Lnsa*100
	label var Share`e' "Share of ethnicity `e' population of total labourers"
}

egen Sum_eth=rowtotal(Asian Pacific Hispanic)
local ETH="Asian Pacific Hispanic"
foreach e of local ETH{
	gen Share_`e'=`e'/Sum_eth
	label var Share_`e' "Share of ethnicity `e' of total ethnicities"
}
gen ETH_HHI=Share_Asian^2+Share_Hispanic^2+Share_Pacific^2
drop Asian_* Pacific_* Hispanic_* Mean_* Share_* Sum_eth

*****************
* Human capital *
*****************
local HC="hd bd"
foreach e of local HC{
	forval t=1980(10)2000{
		bysort state: gen `e'_`t'=`e' if year==`t'
		bysort state: egen Mean_`e'_`t'=mean(`e'_`t')
	}
}

local HC="hd bd"
foreach e of local HC{
	replace `e'=Mean_`e'_1980 if year<1986 & `e'==.
	replace `e'=Mean_`e'_1990 if year>1985 & year<1996 & `e'==.	
	replace `e'=Mean_`e'_2000 if year>1995 & `e'==.
	label var `e' "Population share with hihg-school (hd) or bachelor (bd) degree"
}
drop hd_* bd_* Mean_*

*******************************************
* GSP, (D)PI, unemployment, consolidation *
*******************************************
gen GSP=.
replace GSP=GSP2 if year<1997
replace GSP=GSP1 if year>1996

ipolate PI GSP, gen(PII)
label var PII "Personal income, interpolated before 1983"
ipolate DPI GSP, gen(DPII)
label var DPII "Disposable personal income, interpolated before 1983"

bysort state year: egen Merger=sum(Acquisition)
label var Merger "Number of acquisitions per state"

mvencode Acquisition, mv(0)

global INST="LAGlerner5 LAGlerner1 ShareAsian SharePacific ShareHispanic ETH_HHI GSP PII DPII hd bd unsa usa Merger Acquisition INTRA INTER BRI"
sum $INST
global BANK="MS_state TOPHUN SEC SCOPE INC LLPshare LLRshare ZSCORE ER"
sort entity year
**********************************************************
* Baseline 2SLS; Tables 6 and 7 (mislabelled 3) in paper *
**********************************************************
ivregress 2sls pe (lerner_5= LAGlerner5 SharePacific DPII) $BANK DYEAR* DSTATE*, robust
estat overid
scalar OIscore=r(score)
scalar OIpval=r(p_score)
estat endogenous
scalar EDGFpval=r(p_regF)
scalar EDGF=r(regF)	
scalar EDGScpval=r(p_r_score)
scalar EDGSc=r(r_score)
estat firststage
matrix def First=r(singleresults)
matrix First_PE_L5_All=First'
outreg2 using $pathout\INST, ct(PE-L5) se bdec(4) bracket label excel keep(lerner_5 $BANK) addstat("Wooldridge (1995) overidentification: Chi2", OIscore, ///
"Wooldridge (1995) overidentification: p-value", OIpval, "Wooldridge (1995) exogeneity test: score", EDGSc, "Wooldridge (1995) exogeneity test: p-value", EDGScpval, ///
"Robust exogeneity test: F statistic", EDGF, "Robust exogeneity test: p-value", EDGFpval) replace

ivregress 2sls ce (lerner_5= LAGlerner5 SharePacific DPII) $BANK DYEAR* DSTATE*, robust
estat overid
scalar OIscore=r(score)
scalar OIpval=r(p_score)
estat endogenous
scalar EDGFpval=r(p_regF)
scalar EDGF=r(regF)	
scalar EDGScpval=r(p_r_score)
scalar EDGSc=r(r_score)
estat firststage
matrix def First=r(singleresults)
matrix First_CE_L5_All=First'
outreg2 using $pathout\INST, ct(CE-L5) se bdec(4) bracket label excel keep(lerner_5 $BANK) addstat("Wooldridge (1995) overidentification: Chi2", OIscore, ///
"Wooldridge (1995) overidentification: p-value", OIpval, "Wooldridge (1995) exogeneity test: score", EDGSc, "Wooldridge (1995) exogeneity test: p-value", EDGScpval, ///
"Robust exogeneity test: F statistic", EDGF, "Robust exogeneity test: p-value", EDGFpval) append

ivregress 2sls pe (lerner_1= LAGlerner1 SharePacific) $BANK DYEAR* DSTATE*, robust
estat overid
scalar OIscore=r(score)
scalar OIpval=r(p_score)
estat endogenous
scalar EDGFpval=r(p_regF)
scalar EDGF=r(regF)	
scalar EDGScpval=r(p_r_score)
scalar EDGSc=r(r_score)
estat firststage
matrix def First=r(singleresults)
matrix First_PE_L1_All=First'
outreg2 using $pathout\INST, ct(PE-L1) se bdec(4) bracket label excel keep(lerner_1 $BANK) addstat("Wooldridge (1995) overidentification: Chi2", OIscore, ///
"Wooldridge (1995) overidentification: p-value", OIpval, "Wooldridge (1995) exogeneity test: score", EDGSc, "Wooldridge (1995) exogeneity test: p-value", EDGScpval, ///
"Robust exogeneity test: F statistic", EDGF, "Robust exogeneity test: p-value", EDGFpval) append

ivregress 2sls ce (lerner_1= LAGlerner1 SharePacific Merger) $BANK DYEAR* DSTATE*, robust
estat overid
scalar OIscore=r(score)
scalar OIpval=r(p_score)
estat endogenous
scalar EDGFpval=r(p_regF)
scalar EDGF=r(regF)	
scalar EDGScpval=r(p_r_score)
scalar EDGSc=r(r_score)
estat firststage
matrix def First=r(singleresults)
matrix First_CE_L1_All=First'
outreg2 using $pathout\INST, ct(CE-L1) se bdec(4) bracket label excel keep(lerner_1 $BANK) addstat("Wooldridge (1995) overidentification: Chi2", OIscore, ///
"Wooldridge (1995) overidentification: p-value", OIpval, "Wooldridge (1995) exogeneity test: score", EDGSc, "Wooldridge (1995) exogeneity test: p-value", EDGScpval, ///
"Robust exogeneity test: F statistic", EDGF, "Robust exogeneity test: p-value", EDGFpval) append


ivregress 2sls pe (lerner_5=LAGlerner5 SharePacific hd Acquisition) $BANK DSTATE* DYEAR* if year<1997, robust
estat overid
scalar OIscore=r(score)
scalar OIpval=r(p_score)
estat endogenous
scalar EDGFpval=r(p_regF)
scalar EDGF=r(regF)	
scalar EDGScpval=r(p_r_score)
scalar EDGSc=r(r_score)
estat firststage
matrix def First=r(singleresults)
matrix First_PE_L5_1997=First'
outreg2 using $pathout\INST, ct(PE-L5-1997) se bdec(4) bracket label excel keep(lerner_5 $BANK) addstat("Wooldridge (1995) overidentification: Chi2", OIscore, ///
"Wooldridge (1995) overidentification: p-value", OIpval, "Wooldridge (1995) exogeneity test: score", EDGSc, "Wooldridge (1995) exogeneity test: p-value", EDGScpval, ///
"Robust exogeneity test: F statistic", EDGF, "Robust exogeneity test: p-value", EDGFpval) append

ivregress 2sls ce (lerner_5=LAGlerner5 Acquisition) $BANK $DSTATE $DYEAR if year<1997, robust
estat overid
scalar OIscore=r(score)
scalar OIpval=r(p_score)
estat endogenous
scalar EDGFpval=r(p_regF)
scalar EDGF=r(regF)	
scalar EDGScpval=r(p_r_score)
scalar EDGSc=r(r_score)
estat firststage
matrix def First=r(singleresults)
matrix First_CE_L5_1997=First'
outreg2 using $pathout\INST, ct(CE-L5-1997) se bdec(4) bracket label excel keep(lerner_5 $BANK) addstat("Wooldridge (1995) overidentification: Chi2", OIscore, ///
"Wooldridge (1995) overidentification: p-value", OIpval, "Wooldridge (1995) exogeneity test: score", EDGSc, "Wooldridge (1995) exogeneity test: p-value", EDGScpval, ///
"Robust exogeneity test: F statistic", EDGF, "Robust exogeneity test: p-value", EDGFpval) append

ivregress 2sls pe (lerner_1=LAGlerner1 SharePacific) $BANK DSTATE* DYEAR* if year<1997, robust
estat overid
scalar OIscore=r(score)
scalar OIpval=r(p_score)
estat endogenous
scalar EDGFpval=r(p_regF)
scalar EDGF=r(regF)	
scalar EDGScpval=r(p_r_score)
scalar EDGSc=r(r_score)
estat firststage
matrix def First=r(singleresults)
matrix First_PE_L1_1997=First'
outreg2 using $pathout\INST, ct(PE-L1-1997) se bdec(4) bracket label excel keep(lerner_1 $BANK) addstat("Wooldridge (1995) overidentification: Chi2", OIscore, ///
"Wooldridge (1995) overidentification: p-value", OIpval, "Wooldridge (1995) exogeneity test: score", EDGSc, "Wooldridge (1995) exogeneity test: p-value", EDGScpval, ///
"Robust exogeneity test: F statistic", EDGF, "Robust exogeneity test: p-value", EDGFpval) append

qui ivregress 2sls ce (lerner_1= SharePacific Acquisition) $BANK $DSTATE $DYEAR if LAGlerner1!=. & year<1997, robust
estat overid
scalar OIscore=r(score)
scalar OIpval=r(p_score)
estat endogenous
scalar EDGFpval=r(p_regF)
scalar EDGF=r(regF)	
scalar EDGScpval=r(p_r_score)
scalar EDGSc=r(r_score)
estat firststage
matrix def First=r(singleresults)
matrix First_CE_L1_1997=First'
outreg2 using $pathout\INST, ct(CE-L1-1997) se bdec(4) bracket label excel keep(lerner_1 $BANK) addstat("Wooldridge (1995) overidentification: Chi2", OIscore, ///
"Wooldridge (1995) overidentification: p-value", OIpval, "Wooldridge (1995) exogeneity test: score", EDGSc, "Wooldridge (1995) exogeneity test: p-value", EDGScpval, ///
"Robust exogeneity test: F statistic", EDGF, "Robust exogeneity test: p-value", EDGFpval) append

ivregress 2sls pe (lerner_5= BRI ShareHispanic Acquisition bd unsa) $BANK DSTATE* DYEAR* if year>1996 & year<2006, robust
estat overid
scalar OIscore=r(score)
scalar OIpval=r(p_score)
estat endogenous
scalar EDGFpval=r(p_regF)
scalar EDGF=r(regF)	
scalar EDGScpval=r(p_r_score)
scalar EDGSc=r(r_score)
estat firststage
matrix def First=r(singleresults)
matrix First_PE_L5_2005=First'
outreg2 using $pathout\INST, ct(PE-L5-2005) se bdec(4) bracket label excel keep(lerner_5 $BANK) addstat("Wooldridge (1995) overidentification: Chi2", OIscore, ///
"Wooldridge (1995) overidentification: p-value", OIpval, "Wooldridge (1995) exogeneity test: score", EDGSc, "Wooldridge (1995) exogeneity test: p-value", EDGScpval, ///
"Robust exogeneity test: F statistic", EDGF, "Robust exogeneity test: p-value", EDGFpval) append

ivregress 2sls ce (lerner_5= BRI ShareHispanic Merger hd unsa) $BANK DSTATE* DYEAR* if year>1996 & year<2006, robust
estat overid
scalar OIscore=r(score)
scalar OIpval=r(p_score)
estat endogenous
scalar EDGFpval=r(p_regF)
scalar EDGF=r(regF)	
scalar EDGScpval=r(p_r_score)
scalar EDGSc=r(r_score)
estat firststage
matrix def First=r(singleresults)
matrix First_CE_L5_2005=First'
outreg2 using $pathout\INST, ct(CE-L5-2005) se bdec(4) bracket label excel keep(lerner_5 $BANK) addstat("Wooldridge (1995) overidentification: Chi2", OIscore, ///
"Wooldridge (1995) overidentification: p-value", OIpval, "Wooldridge (1995) exogeneity test: score", EDGSc, "Wooldridge (1995) exogeneity test: p-value", EDGScpval, ///
"Robust exogeneity test: F statistic", EDGF, "Robust exogeneity test: p-value", EDGFpval) append

ivregress 2sls pe (lerner_1= LAGlerner1 Merger ETH_HHI) $BANK DYEAR* DSTATE* if year>1996 & year<2006, robust
estat overid
scalar OIscore=r(score)
scalar OIpval=r(p_score)
estat endogenous
scalar EDGFpval=r(p_regF)
scalar EDGF=r(regF)	
scalar EDGScpval=r(p_r_score)
scalar EDGSc=r(r_score)
estat firststage
matrix def First=r(singleresults)
matrix First_PE_L1_2005=First'
outreg2 using $pathout\INST, ct(PE-L1-2005) se bdec(4) bracket label excel keep(lerner_1 $BANK) addstat("Wooldridge (1995) overidentification: Chi2", OIscore, ///
"Wooldridge (1995) overidentification: p-value", OIpval, "Wooldridge (1995) exogeneity test: score", EDGSc, "Wooldridge (1995) exogeneity test: p-value", EDGScpval, ///
"Robust exogeneity test: F statistic", EDGF, "Robust exogeneity test: p-value", EDGFpval) append

ivregress 2sls ce (lerner_1= BRI usa ETH_HHI Merger) $BANK DYEAR* DSTATE* if year>1996 & year<2006, robust
estat overid
scalar OIscore=r(score)
scalar OIpval=r(p_score)
estat endogenous
scalar EDGFpval=r(p_regF)
scalar EDGF=r(regF)	
scalar EDGScpval=r(p_r_score)
scalar EDGSc=r(r_score)
estat firststage
matrix def First=r(singleresults)
matrix First_CE_L1_2005=First'
outreg2 using $pathout\INST, ct(CE-L1-2005) se bdec(4) bracket label excel keep(lerner_1 $BANK) addstat("Wooldridge (1995) overidentification: Chi2", OIscore, ///
"Wooldridge (1995) overidentification: p-value", OIpval, "Wooldridge (1995) exogeneity test: score", EDGSc, "Wooldridge (1995) exogeneity test: p-value", EDGScpval, ///
"Robust exogeneity test: F statistic", EDGF, "Robust exogeneity test: p-value", EDGFpval) addn(State adn year-specific effects included, but not reported) append

matrix FIRST=First_PE_L5_All,First_CE_L5_All
matrix FIRST=FIRST,First_PE_L1_All
matrix FIRST=FIRST,First_CE_L1_All
matrix FIRST=FIRST,First_PE_L5_1997
matrix FIRST=FIRST,First_CE_L5_1997
matrix FIRST=FIRST,First_PE_L1_1997
matrix FIRST=FIRST,First_CE_L1_1997
matrix FIRST=FIRST,First_PE_L5_2005
matrix FIRST=FIRST,First_CE_L5_2005
matrix FIRST=FIRST,First_PE_L1_2005
matrix FIRST=FIRST,First_CE_L1_2005
matrix list FIRST

*************************************************
* Outsheeting for robustness checks in SFA 		*
* These checks are variations of the "1_SFA.lim"*
* file as reported in Table 8 in the paper		*
*************************************************
outsheet year entity W1 W2 W3 Y1 Y2 Z OPEX REV PBT TA PBTneg NPDPBT TBM TOPHUN $BANK DSTATE* using $pathdata\robcheck.csv, c replace 
***************************************
* D-in-d approach for Table 9 results *
***************************************
xtreg pe INTRAL5 INTERL5 LAGlerner5 INTRA INTER DYEAR1-DYEAR31, fe rob
outreg2 using $pathout\DiD-FE, ct(FE L5 PE Full) keep(INTRAL5 INTERL5 LAGlerner5 INTRA INTER) se bdec(4) bracket e(all) excel replace
xtreg ce INTRAL5 INTERL5 LAGlerner5 INTRA INTER DYEAR1-DYEAR31, fe rob
outreg2 using $pathout\DiD-FE, ct(FE L5 CE Full) keep(INTRAL5 INTERL5 LAGlerner5 INTRA INTER) se bdec(4) bracket e(all) excel append
xtreg pe INTRAL1 INTERL1 LAGlerner1 INTRA INTER DYEAR1-DYEAR31, fe rob
outreg2 using $pathout\DiD-FE, ct(FE L1 PE Full) keep(INTRAL1 INTERL1 LAGlerner1 INTRA INTER) se bdec(4) bracket e(all) excel append
xtreg ce INTRAL1 INTERL1 LAGlerner1 INTRA INTER DYEAR1-DYEAR31, fe rob
outreg2 using $pathout\DiD-FE, ct(FE L1 CE Full) keep(INTRAL1 INTERL1 LAGlerner1 INTRA INTER) se bdec(4) bracket e(all) excel appendxtreg pe INTRAL5 INTERL5 LAGlerner5 INTRA INTER DYEAR1-DYEAR31 if year<1997, fe rob
outreg2 using $pathout\DiD-FE, ct(FE L5 PE 1997) keep(INTRAL5 INTERL5 LAGlerner5 INTRA INTER) se bdec(4) bracket e(all) excel append
xtreg ce INTRAL5 INTERL5 LAGlerner5 INTRA INTER DYEAR1-DYEAR31 if year<1997, fe rob
outreg2 using $pathout\DiD-FE, ct(FE L5 CE 1997) keep(INTRAL5 INTERL5 LAGlerner5 INTRA INTER) se bdec(4) bracket e(all) excel append
xtreg pe INTRAL1 INTERL1 LAGlerner1 INTRA INTER DYEAR1-DYEAR31 if year<1997, fe rob
outreg2 using $pathout\DiD-FE, ct(FE L1 PE 1997) keep(INTRAL1 INTERL1 LAGlerner1 INTRA INTER) se bdec(4) bracket e(all) excel append
xtreg ce INTRAL1 INTERL1 LAGlerner1 INTRA INTER DYEAR1-DYEAR31 if year<1997, fe rob
outreg2 using $pathout\DiD-FE, ct(FE L1 CE 1997) keep(INTRAL1 INTERL1 LAGlerner1 INTRA INTER) se bdec(4) bracket e(all) excel append
xtreg pe bri1L5 bri2L5 bri3L5 bri4L5 LAGlerner5 bri1-bri4 DYEAR21-DYEAR28 if year>1996 & year<2006, fe rob
outreg2 using $pathout\DiD-FE, ct(FE L5 PE 2005) drop(DYEAR21-DYEAR28) se bdec(4) bracket e(all) excel append
xtreg ce bri1L5 bri2L5 bri3L5 bri4L5 LAGlerner5 bri1-bri4 DYEAR21-DYEAR28 if year>1996 & year<2006, fe rob
outreg2 using $pathout\DiD-FE, ct(FE L5 CE 2005) drop(DYEAR21-DYEAR28) se bdec(4) bracket e(all) excel append
xtreg pe bri1L1 bri2L1 bri3L1 bri4L1 LAGlerner1 bri1-bri4 DYEAR21-DYEAR28 if year>1996 & year<2006, fe rob
outreg2 using $pathout\DiD-FE, ct(FE L1 PE 2005) drop(DYEAR21-DYEAR28) se bdec(4) bracket e(all) excel append
xtreg ce bri1L1 bri2L1 bri3L1 bri4L1 LAGlerner1 bri1-bri4 DYEAR21-DYEAR28 if year>1996 & year<2006, fe rob
outreg2 using $pathout\DiD-FE, ct(FE L1 CE 2005) drop(DYEAR21-DYEAR28) se bdec(4) bracket e(all) excel append

*********************************************
* Conditional marginal effects based on DiD *
* Figures 2,3, and 4 in the paper			*
*********************************************
local MFXBRI="bri1 bri2 bri3 bri4"

local TIME="2008 1996"
local EFF="PE CE"
local MFX="INTRA INTER"
foreach t of local TIME{
foreach y of local EFF{
foreach x of local MFX{
	qui sum `x'
	local Mean_`x'=r(mean)
	qui sum lerner_5
	gen CE=ce
	gen PE=pe
	gen L5=.
	gen mean=.
	gen low=.
	gen hi=.
	qui xtreg `y' INTRAL5 INTERL5 LAGlerner5 INTRA INTER DYEAR1-DYEAR31 if year<=`t', fe rob

	forvalues i = 1 (1) 100{
   		quietly nlcom _b[`x'] + `i' / 100 * _b[`x'L5]
   		matrix coef = r(b) // canot convert a r(matrix) to a local
   		matrix var  = r(V)
   		replace L5 = `i' / 100 if _n == `i'
   		replace mean = coef[1,1] if _n == `i'
   		replace low  = coef[1,1] - 1.96 * var[1,1] ^ (1 / 2) if _n == `i'
   		replace hi   = coef[1,1] + 1.96 * var[1,1] ^ (1 / 2) if _n == `i'
   		matrix drop coef var
	}


twoway (line mean L5, sort lcolor(black)) (line low L5, sort lcolor(black) lpattern(dash)) (line hi L5, sort lcolor(black) lpattern(dash)), xtitle(Adjusted Lerner) ///
scheme(s2mono) subtitle(`y') legend(off) yline(0, lcolor(black)) xlabel(, grid)
graph save Graph "$pathout/MFX_L5_`x'_`y'_`t'.gph", replace

drop mean low hi L5 PE CE
}
}
}

graph combine "$pathout/MFX_L5_INTER_PE_1996.gph" "$pathout/MFX_L5_INTER_CE_1996.gph", ///
title(Interstate deregulation) ycommon xcommon saving($pathout/MFX_INTER_1996.gph, replace)
graph combine "$pathout/MFX_L5_INTRA_PE_1996.gph" "$pathout/MFX_L5_INTRA_CE_1996.gph", ///
title(Intrastate deregulation) ycommon xcommon saving($pathout/MFX_INTRA_1996.gph, replace)
graph combine "$pathout/MFX_INTER_1996.gph" "$pathout/MFX_INTRA_1996.gph", ///
title(Conditional marginal effects of deregulation on efficiency after:) subtitle(D-i-D estimates 1976-1996) c(1) ycommon xcommon saving($pathout/MFX_1996.gph, replace) 


local EFF="PE CE"
local MFXBRI="bri1 bri2 bri3 bri4"
foreach y of local EFF{
foreach x of local MFXBRI{
	qui sum `x'
	local Mean_`x'=r(mean)
	qui sum lerner_5
	gen CE=ce
	gen PE=pe
	gen L5=.
	gen mean=.
	gen low=.
	gen hi=.
	qui xtreg `y' bri1L5 bri2L5 bri3L5 bri4L5 LAGlerner5 bri1-bri4 DYEAR21-DYEAR28 if year>1996 & year<2006, fe rob
	forvalues i = 1 (1) 100{
   		quietly nlcom _b[`x'] + `i' / 100 * _b[`x'L5]
   		matrix coef = r(b) // canot convert a r(matrix) to a local
   		matrix var  = r(V)
   		replace L5 = `i' / 100 if _n == `i'
   		replace mean = coef[1,1] if _n == `i'
   		replace low  = coef[1,1] - 1.96 * var[1,1] ^ (1 / 2) if _n == `i'
   		replace hi   = coef[1,1] + 1.96 * var[1,1] ^ (1 / 2) if _n == `i'
   		matrix drop coef var
	}
twoway (line mean L5, sort lcolor(black)) (line low L5, sort lcolor(black) lpattern(dash)) (line hi L5, sort lcolor(black) lpattern(dash)), xtitle(Adjusted Lerner) ///
scheme(s2mono) subtitle(`x') legend(off) yline(0, lcolor(black)) xlabel(, grid)
graph save Graph "$pathout/MFX_L5_`x'_`y'.gph", replace

drop mean low hi L5 PE CE
}
}

graph combine "$pathout/MFX_L5_bri1_PE.gph" "$pathout/MFX_L5_bri2_PE.gph" "$pathout/MFX_L5_bri3_PE.gph" "$pathout/MFX_L5_bri4_PE.gph", ///
title(Profit efficiency) ycommon xcommon r(2) saving($pathout/MFX_BRI_PE.gph, replace)
graph combine "$pathout/MFX_L5_bri1_CE.gph" "$pathout/MFX_L5_bri2_CE.gph" "$pathout/MFX_L5_bri3_CE.gph" "$pathout/MFX_L5_bri4_CE.gph", ///
title(Cost efficiency) ycommon xcommon r(2) saving($pathout/MFX_BRI_CE.gph, replace)

****************************************
* Table 5: Differences in Lerner indices
****************************************

sum lerner_1 lerner_5
spearman lerner_1 lerner_5, stats(rho obs p) pw
signrank lerner_1=lerner_5
ttest lerner_1=lerner_5

table year, c(m lerner_1 m lerner_5 m ce m pe n lerner_1) row col

matrix Results=J(1,3,0)
matrix colnames Results=N Rho p
	forval Z=1976(1)2007{
		spearman lerner_1 lerner_5 if year==`Z'
		scalar N=r(N) 
		scalar Rho=r(rho)
		scalar p=r(p) 
		matrix M_`Z'=(N,Rho,p)
		matrix rownames M_`Z'=Year_`Z'
		matrix colnames M_`Z'=N Rho p
		matrix Results = Results\M_`Z'
		matrix drop M_`Z'
		scalar drop _all
		serset clear
}
matrix list Results
matrix drop Results


