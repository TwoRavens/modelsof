**************************************************
** Archigos Leader exits & GWF regime failure **
**************************************************
use archigos_original, clear
keep if exit==1 | exit==3 | exit==4  						/* exclude natural deaths */
gen year = year(eoutdate)   								/* identifying failure years */
bysort ccode year: egen exitsum = count(year)   			/* identifying multiple-failure years */
keep ida ccode year exitsum leader  
rename ccode cowcode 
egen tag = tag(cow year)  
keep if tag==1
keep if year>1945
gen leaderexit=1
tab  exitsum leaderexit
drop tag  
sort cow year
merge cow year using GWFglobal
keep if year<2005
tab _merge
browse ida year if _merge==1  								/* small population countries not included in GWF */
drop if _merge==1
drop _merge
drop if gwf_fail==.
recode leaderexit exitsum (.=0) (.=0)


*Autocracy transition*
gen gwf_AA = gwf_fail==1 & gwf_next~="democracy" & gwf_next~="provisional"  & gwf_non~="democracy" & gwf_non~="provisional"
*Transition to Democracy*
gen gwf_AD = gwf_fail==1 & (gwf_next=="democracy" | gwf_next=="provisional")
*Democratic Failure*
gen gwf_DA = gwf_fail==1 & (gwf_next~="democracy" & gwf_next~="provisional")  & (gwf_non=="democracy" | gwf_non=="provisional")

tab gwf_fail gwf_AA
tab gwf_fail gwf_AD
tab gwf_fail gwf_DA


tab exitsum gwf_AA if gwf_regimetype~="NA" 
tab exitsum gwf_AD if gwf_regimetype~="NA"
tab exitsum gwf_DA if (gwf_non=="democracy" | gwf_non=="provisional")

** Fix (4) inauguration date differences **
		*Panama 1990; Chile 1990; Uruguay 1985; South Korea 1988 
gen gwffail = gwf_fail
recode gwffail (0=1) if ((cowc==95 & year==1990) | (cowc==155 & year==1990) | (cowc==165 & year==1985) | (cowc==732 & year==1988)  )
recode gwf_AD (0=1) if  ((cowc==95 & year==1990) | (cowc==155 & year==1990) | (cowc==165 & year==1985) | (cowc==732 & year==1988)  )
recode gwf_AD (1=0) if  ((cowc==95 & year==1989) | (cowc==155 & year==1989) | (cowc==165 & year==1984) | (cowc==732 & year==1987)  )

**leader failure years when NO regime collapse**
tab leaderexit if gwffail==0 & gwf_regimetype~="NA"   & leaderexit>=1
tab leaderexit if gwffail==0 & (gwf_non=="democracy" | gwf_non=="provisional")  & leaderexit>=1

**leader failure years when YES regime collapse**
tab leaderexit if gwffail==1 & gwf_AA==1 & gwf_regimetype~="NA" & leaderexit>=1
tab leaderexit if gwffail==1 & gwf_AD==1 & gwf_regimetype~="NA" & leaderexit>=1
tab leaderexit if gwffail==1 & gwf_DA==1 & (gwf_non=="democracy" | gwf_non=="provisional") & leaderexit>=1


gen graphgwfarchigos = .
replace graphgwfarchigos = 610 in 1    /* Democracy survives */
replace graphgwfarchigos = . in 2    
replace graphgwfarchigos = 53 in 3     /* Democracy-Autocracy */
replace graphgwfarchigos = . in 4    
replace graphgwfarchigos = 84 in 5     /* Autocracy-Democracy */
replace graphgwfarchigos = . in 6  
replace graphgwfarchigos = 109 in 7    /* Autocracy-Autocracy */
replace graphgwfarchigos = . in 8  
replace graphgwfarchigos = 212 in 9    /* Autocracy survives */

gen index  = _n in 1/9
label define allfails  1 "Democracy survives" 2 " "  3 "Democracy-Autocracy"  4 " " 5 "Autocracy-Democracy" /*
*/ 6 " " 7 "Autocracy-Autocracy" 8 " "  9 "Autocracy survives"   
label values index  allfails 

twoway (bar graphgwfarchigos index, scheme(lean2)  ylabel(0(200)600,glcolor(gs14))   /*
*/ xlabel(1(1)9, valuelabel labsize(small) labcolor(black) labgap(tiny) noticks) xsize(10) ysize(5) )/*
*/ (scatter graphgwfarchigos index, ms(none) mla(graphgwfarchigos) mlabpos(6) graphregion(color(white)) /*
*/ xtitle("Type of event",height(8)) ytitle("Number of country-years")  xscale(range (0 10))  /*
*/ legend(pos(12) col(1) ring(1) label(1 "Archigos Leader Failure") label(2 "") bmargin(0) order(2 1)) )
*graph export "C:\Users\jwright\Documents\My Dropbox\Research\Autocratic Instability\ArchigosGWF.pdf", as(pdf) replace

***********************************************************
** Archigos Irregular transitions vs. GWF regime failure **
***********************************************************
use archigos_original, clear
gen startyr = ""                              				/*generate an empty string variable*/
replace startyr = substr(startdate,-4,4)      				/*capture last 4 characters of string var*/
gen endyr = ""
replace endyr = substr(enddate,-4,4)
destring startyr endyr, replace		      					/*create integer variables from string variables*/
sort ccode eindate
gen IRR = exit==3 & entry[_n+1]==1 & ccode == ccode[_n+1]
tab IRR
keep if endyr>1945 & IRR==1
tab IRR
sum endyr
keep ccode endyr leader idacr IRR  
rename ccode cowcode
rename endyr year
egen IRRsum = sum(IRR), by(cowcode year)
tab IRRsum

sort cowcode year
merge cowcode year using GWFglobal
tab _merge
*browse idacr cowcode year if _merge==1  					/*These are small countries not in GWF, except DRC 1960 which GWF code as not indep until 1961*/
drop if _merge==1
gen gwf_dict = gwf_fail==1 & gwf_next~="democracy" & gwf_next~="provisional"  & gwf_regimetype~="NA" 
tab gwf_dict IRRsum if gwf_regimetype~="NA" , m

**total years and irregular transitions with no GWF autocratic regime failure**
tab gwf_dict IRRsum if gwf_fail==0 & gwf_regimetype~="NA" & gwf_dict==0 &  IRRsum~=.  /* 105 irregular exits is 73 country-years */

browse gwf_case gwf_regime  idacr leader year IRRsum if IRRsum>=1 &  IRRsum~=. & gwf_dict==0 & gwf_regimetype~="NA" & gwf_fail==0    
tab gwf_regime IRRsum if gwf_fail==0 & gwf_regimetype~="NA"    /* 39 of 73 years are military rule; 54 of 105 events are under military rule*/

egen tag = tag(cow year) if gwf_fail~=.
keep if tag==1
tsset cow year
sort cow year
gen nextfail = F.gwf_fail==1
browse gwf_case gwf_regime  idacr leader IRRsum year nextfail if IRRsum>=1 &  IRRsum~=. & gwf_dict==0 & gwf_regimetype~="NA" & gwf_fail==0  
tab nextfail if IRRsum>=1 &  IRRsum~=. & gwf_dict==0 & gwf_regimetype~="NA" & gwf_fail==0 

**total years and irregular transitions with no GWF autocratic regime failure and NO regime failure the next year either**
tab IRRsum if nextfail==0 & gwf_dict==0 & gwf_regimetype~="NA" & gwf_fail==0 

****************************************
** BDM and Smith 2010 AJPS, Model 2.2 **
****************************************

*Replication of Model 2.2
use BdmSmithAJPS, clear
qui streg W S age Wage threat3 Wthreat NTgdp WNTgdp lGDPpcWB WlGDPpcWB  growthWB WgrowthWB , dis(wei) anc(W ) cluster(ccode)
lincom NTgdp
lincom WNTgdp + NTgdp

rename ccode cowcode
sort cowcode year
merge cowcode year using GWFglobal
tab _merge
gen fail1 = _d
rename _d bdm_d
rename _t bdm_t
rename _t0 bdm_t0
stset  bdm_t, fail(fail1) id(ID)
corr bdm* _d _t _t0

*Replication model*
stset  bdm_t, fail(fail1) id(ID)
qui streg W S age Wage threat3 Wthreat NTgdp WNTgdp lGDPpcWB WlGDPpcWB  growthWB WgrowthWB , dis(wei) anc(W ) cluster(ccode)
estimates store r1
lincom NTgdp
lincom WNTgdp + NTgdp


*Failure types*
gen fail2 = fail1==1 & gwf_fail==1 if fail1~=.
gen fail3 = fail1==1 & (gwf_fail==0 | gwf_fail==.) if fail1~=.
*Five leader failures in sample take place the calendar year after the electoral/demonstration event that ends the regime:
	*Panama 1990; Chile 1990; Uruguay 1985; South Korea 1988; Indonesia 1998
recode fail2 (0=1) if fail1==1 & ((cowc==95 & year==1990) | (cowc==155 & year==1990) | (cowc==165 & year==1985) | (cowc==732 & year==1988) | (cowc==850 & year==1998))
recode fail3 (1=0) if (cowc==95 & year==1990) | (cowc==155 & year==1990) | (cowc==165 & year==1985) | (cowc==732 & year==1988) | (cowc==850 & year==1998)  

sum bdm_d _d fail* if e(sample)
tab fail1 fail2 if e(sample)
tab fail1 fail3 if e(sample)

drop _merge
saveold temp_BDM, replace



**DV's for Appendix Table*
sort country year
browse country year if e(sample) & fail2==1
browse country year if e(sample) & fail3==1

*Only regime failures*
stset  bdm_t, fail(fail2) id(ID)
tab _d fail2 if e(sample)
qui streg W S age Wage threat3 Wthreat NTgdp WNTgdp lGDPpcWB WlGDPpcWB  growthWB WgrowthWB , dis(wei) anc(W ) cluster(cowcode)
estimates store r2
lincom NTgdp
lincom WNTgdp  + NTgdp

*Only non-regime failures*
stset  bdm_t, fail(fail3) id(ID)
tab _d fail3 if e(sample)
qui streg W S age Wage threat3 Wthreat NTgdp WNTgdp lGDPpcWB WlGDPpcWB  growthWB WgrowthWB , dis(wei) anc(W ) cluster(cowcode)
estimates store r3
lincom NTgdp
lincom WNTgdp + NTgdp

estout  r1 r2 r3 using Table2.tex, cells(b(star  fmt(%9.3f)) se(par fmt(%9.2f))) stats(ll r2 N) style(tex) replace label starlevels(* 0.10 ** 0.05)


**Multinomial setting**
gen tme = bdm_t+1
gen duration = round(tme,1)
drop tme
sum duration
gen duration2= duration^2
gen duration3 = duration^3
gen fail_all = fail1
/* fail_all==1 is regime collapse failure; fail_all==-1 is no regime collapse failure*/
recode fail_all (1=-1) if fail1==1 & fail3==1  
mlogit fail_all duration* W S age Wage threat3 Wthreat NTgdp WNTgdp lGDPpcWB WlGDPpcWB  growthWB WgrowthWB,  cluster(cowcode)


***Hazards***

	stset  bdm_t, fail(fail1) id(ID)
	qui streg W S age Wage threat3 Wthreat NTgdp WNTgdp lGDPpcWB WlGDPpcWB  growthWB WgrowthWB , dis(wei) cluster(ccode)
	lincom NTgdp
	lincom WNTgdp + NTgdp
	stcurve, hazard at1(NTgdp=3, WNTgdp=0, W=0) at2(NTgdp=13, WNTgdp=0, W=0) /*
	*/  legend(pos(12) col(2) ring(1) label(1 "Non-tax= 3%") label(2 "Non-tax= 13%"))/*
	*/ yscale(range (0 0.1)) xscale(range (0 12)) xlabel(0 (2) 12)  range(0 12) 
	*graph export "C:\Users\jwright\Documents\My Dropbox\Research\Autocratic Instability\BDMSmithRep1.pdf", as(pdf)                            replace

	stset  bdm_t, fail(fail2) id(ID)
	qui streg W S age Wage threat3 Wthreat NTgdp WNTgdp lGDPpcWB WlGDPpcWB  growthWB WgrowthWB , dis(wei) cluster(ccode)
	lincom NTgdp
	lincom WNTgdp + NTgdp
	stcurve, hazard at1(NTgdp=3, WNTgdp=0, W=0) at2(NTgdp=13, WNTgdp=0, W=0) /*
	*/  legend(pos(12) col(2) ring(1) label(1 "Non-tax= 3%") label(2 "Non-tax= 13%"))/*
	*/ yscale(range (0 0.002)) ylabel(0 (0.0005) 0.002) xscale(range (0 12)) xlabel(0 (2) 12)  range(0 12) 
	*graph export "C:\Users\jwright\Documents\My Dropbox\Research\Autocratic Instability\BDMSmithRep2.pdf", as(pdf)                            replace

	stset  bdm_t, fail(fail3) id(ID)
	qui streg W S age Wage threat3 Wthreat NTgdp WNTgdp lGDPpcWB WlGDPpcWB  growthWB WgrowthWB , dis(wei) cluster(ccode)
	lincom NTgdp
	lincom WNTgdp + NTgdp
	stcurve, hazard at1(NTgdp=3, WNTgdp=0, W=0) at2(NTgdp=13, WNTgdp=0, W=0) /*
	*/  legend(pos(12) col(2) ring(1) label(1 "Non-tax= 3%") label(2 "Non-tax= 13%"))/*
	*/ yscale(range (0 0.04)) ylabel(0 (0.005) 0.04) xscale(range (0 12)) xlabel(0 (2) 12)  range(0 12) 
	*graph export "C:\Users\jwright\Documents\My Dropbox\Research\Autocratic Instability\BDMSmithRep3.pdf", as(pdf)                            replace


******The End******
