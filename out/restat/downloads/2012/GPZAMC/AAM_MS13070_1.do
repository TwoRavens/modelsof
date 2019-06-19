/*CHANGES IN CONSUMPTION AT RETIREMENT: EVIDENCE FROM PANEL DATA*/
/*Emma Aguila, Orazio Attanasio, and Costas Meghir*/

/*use file AAM_MS13070.dta and run Table 1 code and Table 3 (Web appendix) code*/


/*******************************************************************************************/
/*Table 1.- Impact on Consumption around retirement including singles and couple households*/
/*******************************************************************************************/


sort newid intno

tab fam_size
drop age2
gen age2=age^2


gen couple=0
replace couple=1 if  sex2==2
label define couple 1 "couple" 0  "single"
label values couple couple

drop if age<50 | age >74

tab intno
sort newid intno
keep if newid==newid[_n+1] | newid==newid[_n-1]
tab intno

codebook d11 d00 d10 d01

gen intd=1*(intno==5)


gen intd00=intd*d00
gen intd01=intd*d01
gen intd10=intd*d10
gen intd11=intd*d11

codebook ldnondur ldfoodtot ldfoodins lnfoodndd

set matsize 600
codebook d11 d00 d10 d01

xi: regress ldnondur i.year*i.qintrvmo  fam_size perslt18 age age2 couple intd d00 d01 d10 intd00 intd01  intd10, cluster(newid)
xi: regress ldfoodtot i.year*i.qintrvmo  fam_size perslt18 age age2 couple intd d00 d01 d10 intd00 intd01  intd10, cluster(newid)
xi: regress ldfoodins i.year*i.qintrvmo  fam_size perslt18 age age2 couple intd d00 d01 d10 intd00 intd01  intd10, cluster(newid)
xi: regress lnfoodndd i.year*i.qintrvmo  fam_size perslt18 age age2 couple intd d00 d01 d10 intd00 intd01  intd10, cluster(newid)


/*********************************************************************************************************/
/*Table 3. (Web Appendix)- Impact on Consumption around retirement including single and couple households*/
/*********************************************************************************************************/

xi: regress ldnondur i.year*i.qintrvmo  fam_size perslt18 age age2 couple intd d00 d01 d10 intd00 intd01  intd10 if (year>=1980 & year<=1989), cluster(newid)
xi: regress ldnondur i.year*i.qintrvmo  fam_size perslt18 age age2 couple intd d00 d01 d10 intd00 intd01  intd10 if (year>=1990 & year<=2001), cluster(newid)


xi: regress ldfoodtot i.year*i.qintrvmo  fam_size perslt18 age age2 couple intd d00 d01 d10 intd00 intd01  intd10 if (year>=1980 & year<=1989), cluster(newid)
xi: regress ldfoodtot i.year*i.qintrvmo  fam_size perslt18 age age2 couple intd d00 d01 d10 intd00 intd01  intd10 if (year>=1990 & year<=2001), cluster(newid)


xi: regress ldfoodins i.year*i.qintrvmo  fam_size perslt18 age age2 couple intd d00 d01 d10 intd00 intd01  intd10 if (year>=1980 & year<=1989), cluster(newid)
xi: regress ldfoodins i.year*i.qintrvmo  fam_size perslt18 age age2 couple intd d00 d01 d10 intd00 intd01  intd10 if (year>=1990 & year<=2001), cluster(newid)

xi: regress lnfoodndd i.year*i.qintrvmo  fam_size perslt18 age age2 couple intd d00 d01 d10 intd00 intd01  intd10 if (year>=1980 & year<=1989), cluster(newid)
xi: regress lnfoodndd i.year*i.qintrvmo  fam_size perslt18 age age2 couple intd d00 d01 d10 intd00 intd01  intd10 if (year>=1990 & year<=2001), cluster(newid)


/********************/


/*use file  AAM_MS13070.dta and run Table 2 code and Table 3 (Web appendix) code*/


/*******************************************************************************/
/*Table 2.- Impact on Consumption around retirement including couple households*/
/*******************************************************************************/

/*use file  final AAM.dta*/

sort newid intno

tab fam_size
drop age2
gen age2=age^2


gen couple=0
replace couple=1 if  sex2==2
label define couple 1 "couple" 0  "single"
label values couple couple

drop if age<50 | age >74

tab intno
sort newid intno
keep if newid==newid[_n+1] | newid==newid[_n-1]
tab intno

keep if couple==1

gen agew2=agew^2

tab intno
sort newid intno
drop n N
by newid: gen n=_n
by newid: gen N=_N
tab n
tab N
drop if N<2
tab intno

gen difaw=age-agew

/*wife leisure annual hours=(5000-no of work hours)*/
gen wleisure=5000-whourpyw
gen lleisf=ln(wleisure)
replace lleisf=0 if lleisf<0 | lleisf==.

sort newid intno
keep if newid==newid[_n+1] | newid==newid[_n-1]
tab intno

codebook d11 d00 d10 d01

gen intd=1*(intno==5)


gen intd00=intd*d00
gen intd01=intd*d01
gen intd10=intd*d10
gen intd11=intd*d11

codebook ldnondur ldfoodtot ldfoodins lnfoodndd


codebook difaw

xi: regress ldnondur i.year*i.qintrvmo  fam_size perslt18 age age2 difaw lleisf intd d00 d01 d10 intd00 intd01  intd10, cluster(newid)
xi: regress ldfoodtot i.year*i.qintrvmo  fam_size perslt18 age age2 difaw lleisf intd d00 d01 d10 intd00 intd01  intd10, cluster(newid)
xi: regress ldfoodins i.year*i.qintrvmo  fam_size perslt18 age age2 difaw lleisf intd d00 d01 d10 intd00 intd01  intd10, cluster(newid)
xi: regress lnfoodndd i.year*i.qintrvmo  fam_size perslt18 age age2 difaw lleisf intd d00 d01 d10 intd00 intd01  intd10, cluster(newid)


/***********************************************************************************************/
/*Table 3. (Web Appendix)- Impact on Consumption around retirement including couple households*/
/**********************************************************************************************/


xi: regress ldnondur i.year*i.qintrvmo  fam_size perslt18 age age2 difaw lleisf intd d00 d01 d10 intd00 intd01  intd10 if (year>=1980 & year<=1989), cluster(newid)
xi: regress ldnondur i.year*i.qintrvmo  fam_size perslt18 age age2 difaw lleisf intd d00 d01 d10 intd00 intd01  intd10 if (year>=1990 & year<=2001), cluster(newid)

xi: regress ldfoodtot i.year*i.qintrvmo  fam_size perslt18 age age2 difaw lleisf intd d00 d01 d10 intd00 intd01  intd10 if (year>=1980 & year<=1989), cluster(newid)
xi: regress ldfoodtot i.year*i.qintrvmo  fam_size perslt18 age age2 difaw lleisf intd d00 d01 d10 intd00 intd01  intd10 if (year>=1990 & year<=2001), cluster(newid)

xi: regress ldfoodins i.year*i.qintrvmo  fam_size perslt18 age age2 difaw lleisf intd d00 d01 d10 intd00 intd01  intd10 if (year>=1980 & year<=1989), cluster(newid)
xi: regress ldfoodins i.year*i.qintrvmo  fam_size perslt18 age age2 difaw lleisf intd d00 d01 d10 intd00 intd01  intd10 if (year>=1990 & year<=2001), cluster(newid)

xi: regress lnfoodndd i.year*i.qintrvmo  fam_size perslt18 age age2 difaw lleisf intd d00 d01 d10 intd00 intd01  intd10 if (year>=1980 & year<=1989), cluster(newid)
xi: regress lnfoodndd i.year*i.qintrvmo  fam_size perslt18 age age2 difaw lleisf intd d00 d01 d10 intd00 intd01  intd10 if (year>=1990 & year<=2001), cluster(newid)


/**************/

