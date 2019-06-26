/* ARCANGELO DIMICO: 15/05/2010*/
/* COMPARISON BETWEEN CIVIL WAR DATA*/

use "G:\Cruzer (I)\comparison 1\bleaney_dimico_jpr.dta

/* INCIDENCE OF CIVIL WAR*/
sum incidence inci atwarns war collier08
sum incidence inci atwarns war collier08 if incidence!=. & inci!=. & atwarns!=. & war!=. & collier08!=.




gen t2=t^2
gen cold=1 if year<1991
replace cold=0 if cold==.
gen logt=t
gen coldt=(1-cold)*t


gen mtnest1=mtnest/100
replace ssafrica=1 if ccode>400 & ccode<600


so ccode year
by ccode: gen incidencel=incidence[_n-1]
by ccode: gen incidencel2=incidence[_n-2]

by ccode: gen incil=inci[_n-1]
by ccode: gen incil2=inci[_n-2]

by ccode: gen atwarll=atwarns[_n-1]
by ccode: gen atwarl2=atwarns[_n-2]
by ccode: gen atwarl3=atwarl2*(1-atwarll)

by ccode: gen warl=war[_n-1]
by ccode: gen warl2=war[_n-2]



by ccode: gen collier08l=collier08[_n-1]
by ccode: gen collierl2=collier08[_n-2]


/*---------------------ONSETS--------------------------------------------------*/

probit incidence lnrgdpch1l lnpopl  mtnest1 ethfrac anocracyl onshore cold logt  coldt incidencel2 if incidencel==0, robust
outreg2 using onset, tstat tdec(2) replace 
probit inci lnrgdpch1l lnpopl  mtnest1  ethfrac anocracyl onshore cold logt coldt incil2 if incil==0, robust
outreg2 using onset, tstat tdec(2) append
probit atwarns lnrgdpch1l lnpopl  mtnest1 onshore ethfrac anocracyl logt cold coldt atwarl2 if atwarll==0, robust
outreg2 using onset, tstat tdec(2) append
probit war lnrgdpch1l lnpopl  mtnest1 onshore ethfrac anocracyl logt cold coldt warl2 if warl==0, robust
outreg2 using onset, tstat tdec(2) append
probit collier08 lnrgdpch1l lnpopl  mtnest1 onshore ethfrac  anocracyl logt cold coldt collierl2 if collier08l==0, robust
outreg2 using onset, tstat tdec(2) append


/*---------------------DURATION--------------------------------------------------*/
probit incidence lnrgdpch1l lnpopl  mtnest1  ethfrac anocracyl onshore cold  logt coldt incidencel2 if incidencel==1, robust
outreg2 using duration, tstat tdec(2) replace 
probit inci lnrgdpch1l lnpopl  mtnest1 ethfrac anocracyl onshore cold logt coldt incil2 if incil==1, robust
outreg2 using duration, tstat tdec(2) append
probit atwarns lnrgdpch1l lnpopl  mtnest1 onshore ethfrac anocracyl  logt cold coldt atwarl2 if atwarll==1, robust
outreg2 using duration, tstat tdec(2) append
probit war lnrgdpch1l lnpopl  mtnest1 onshore ethfrac anocracyl  logt cold coldt warl2 if warl==1, robust
outreg2 using duration, tstat tdec(2) append
probit collier08 lnrgdpch1l lnpopl  mtnest1 onshore ethfrac  anocracyl  logt cold coldt collierl2 if collier08l==1, robust
outreg2 using duration, tstat tdec(2) append




/*---------------------INCIDENCE------------------*/


reg incidence lnrgdpch1l lnpopl  mtnest1  ethfrac anocracyl onshore cold logt  coldt incidencel incidencel2,  robust
outreg2 using lpml, tstat tdec(2) replace

reg inci lnrgdpch1l lnpopl  mtnest1  ethfrac anocracyl onshore  cold logt coldt incil incil2, robust
outreg2 using lpml, tstat tdec(2) append

reg atwarns lnrgdpch1l lnpopl  mtnest1 onshore ethfrac anocracyl logt cold coldt atwarll atwarl2, robust
outreg2 using lpml, tstat tdec(2) append

reg war lnrgdpch1l lnpopl  mtnest1 onshore ethfrac anocracyl logt cold coldt warl warl2, robust
outreg2 using lpml, tstat tdec(2) append

reg collier08 lnrgdpch1l lnpopl  mtnest1 onshore ethfrac anocracyl logt cold coldt collier08l collierl2, robust
outreg2 using lpml, tstat tdec(2) append



/*--------------------STRUCTURAL BREAK---------------------------------------*/

gen gdpwar=incidencel*lnrgdpch1l
gen popwar=incidencel*lnpopl
gen montwar=incidencel*mtnest1
gen oilwar=incidencel*onshore
gen fracwar=incidencel*ethfrac
gen anowar=incidencel*anocracyl
gen coldwar=cold*incidencel
gen twar=logt*incidencel





probit incidence lnrgdpch1l lnpopl  mtnest1  ethfrac anocracyl onshore cold coldt logt  incidencel incidencel2 twar gdpwar popwar montwar  fracwar anowar oilwar , robust
outreg2 using probit, tstat tdec(2) replace


probit incidence lnrgdpch1l lnpopl  mtnest1  ethfrac anocracyl onshore cold coldt logt  incidencel incidencel2 twar popwar anowar , robust
outreg2 using mount, tstat tdec(2) replace

reg incidence lnrgdpch1l lnpopl  mtnest1  ethfrac anocracyl onshore cold coldt logt  incidencel incidencel2 twar gdpwar popwar montwar  fracwar anowar oilwar , robust
outreg2 using lpm, tstat tdec(2) replace

reg incidence lnrgdpch1l lnpopl  mtnest1  ethfrac anocracyl onshore cold coldt logt  incidencel incidencel2 twar, robust
outreg2 using lpm1, tstat tdec(2) replace




drop  gdpwar popwar montwar oilwar fracwar  anowar coldwar twar 

gen gdpwar=incil*lnrgdpch1l
gen popwar=incil*lnpopl
gen montwar=incil*mtnest1
gen oilwar=incil*onshore
gen fracwar=incil*ethfrac
gen anowar=incil*anocracyl
gen coldwar=incil*cold
gen twar= logt*incil



probit inci lnrgdpch1l lnpopl  mtnest1  ethfrac anocracyl onshore cold coldt logt  incil incil2 twar gdpwar popwar montwar  fracwar anowar oilwar , robust
outreg2 using probit, tstat tdec(2) append


probit inci lnrgdpch1l lnpopl  mtnest1  ethfrac anocracyl onshore cold coldt logt  incil incil2 twar fracwar anowar, robust
outreg2 using mount, tstat tdec(2) append

reg inci lnrgdpch1l lnpopl  mtnest1  ethfrac anocracyl onshore cold coldt logt  incil incil2 twar gdpwar popwar montwar  fracwar anowar oilwar , robust
outreg2 using lpm, tstat tdec(2) append

reg inci lnrgdpch1l lnpopl  mtnest1  ethfrac anocracyl onshore cold coldt logt  incil incil2 twar anowar, robust
outreg2 using lpm1, tstat tdec(2) append



drop  gdpwar popwar montwar oilwar fracwar anowar   coldwar twar
gen gdpwar=atwarll*lnrgdpch1l
gen popwar=atwarll*lnpopl
gen montwar=atwarll*mtnest1
gen oilwar=atwarll*onshore
gen fracwar=atwarll*ethfrac
gen anowar=atwarll*anocracyl
gen coldwar=atwarll*cold
gen twar=logt*atwarll

probit atwarns lnrgdpch1l lnpopl  mtnest1  ethfrac anocracyl onshore cold coldt logt  atwarll atwarl2 twar gdpwar popwar montwar  fracwar anowar oilwar , robust

outreg2 using probit, tstat tdec(2) append

probit atwarns lnrgdpch1l lnpopl  mtnest1  ethfrac anocracyl onshore cold coldt logt  atwarll atwarl2 twar anowar , robust

outreg2 using mount, tstat tdec(2) append


reg atwarns lnrgdpch1l lnpopl  mtnest1  ethfrac anocracyl onshore cold coldt logt  atwarll atwarl2 twar gdpwar popwar montwar  fracwar anowar oilwar , robust
outreg2 using lpm, tstat tdec(2) append

reg atwarns lnrgdpch1l lnpopl  mtnest1  ethfrac anocracyl onshore cold coldt logt  atwarll atwarl2 twar oilwar , robust
outreg2 using lpm1, tstat tdec(2) append





drop  gdpwar popwar montwar oilwar fracwar anowar coldwar twar 
gen gdpwar=warl*lnrgdpch1l
gen popwar=warl*lnpopl
gen montwar=warl*mtnest1
gen oilwar=warl*onshore
gen fracwar=warl*ethfrac
gen anowar=warl*anocracyl
gen coldwar=warl*cold
gen twar=logt*warl



probit war lnrgdpch1l lnpopl  mtnest1  ethfrac anocracyl onshore cold coldt logt  warl warl2 twar gdpwar popwar montwar  fracwar anowar oilwar , robust
outreg2 using probit, tstat tdec(2) append


probit war lnrgdpch1l lnpopl  mtnest1  ethfrac anocracyl onshore cold coldt logt  warl warl2 oilwar , robust
outreg2 using mount, tstat tdec(2) append

reg war lnrgdpch1l lnpopl  mtnest1  ethfrac anocracyl onshore cold coldt logt  warl warl2 twar gdpwar popwar montwar  fracwar anowar oilwar , robust
outreg2 using lpm, tstat tdec(2) append

reg war lnrgdpch1l lnpopl  mtnest1  ethfrac anocracyl onshore cold coldt logt  warl warl2 twar oilwar , robust
outreg2 using lpm1, tstat tdec(2) append



drop  gdpwar popwar montwar oilwar fracwar  anowar  coldwar twar
gen gdpwar=collier08l*lnrgdpch1l
gen popwar=collier08l*lnpopl
gen montwar=collier08l*mtnest1
gen oilwar=collier08l*onshore
gen fracwar=collier08l*ethfrac
gen anowar=collier08l*anocracyl
gen coldwar=collier08l*cold
gen twar= collier08l*logt


probit collier08 lnrgdpch1l lnpopl  mtnest1  ethfrac anocracyl onshore cold coldt logt  collier08l collierl2 twar gdpwar popwar montwar  fracwar anowar oilwar , robust
outreg2 using probit, tstat tdec(2) append

probit collier08 lnrgdpch1l lnpopl  mtnest1  ethfrac anocracyl onshore cold coldt logt  collier08l collierl2 twar gdpwar anowar , robust
outreg2 using mount, tstat tdec(2) append

reg collier08 lnrgdpch1l lnpopl  mtnest1  ethfrac anocracyl onshore cold coldt logt  collier08l collierl2 twar gdpwar popwar montwar  fracwar anowar oilwar , robust
outreg2 using lpm, tstat tdec(2) append

reg collier08 lnrgdpch1l lnpopl  mtnest1  ethfrac anocracyl onshore cold coldt logt  collier08l collierl2 twar, robust
outreg2 using lpm1, tstat tdec(2) append





/*----------------------CORRELATION TESTS-------------------------------------*/

/*----GEN PEACE ONSETS--------*/
so ccode year
by ccode: gen pitfp=1 if incidence==0 & incidencel==1
replace pitfp=0 if pitfp==. & incidence==1 

by ccode: gen priop=1 if inci==0 & incil==1
replace priop=0 if priop==. & inci==1

by ccode: gen sambp=1 if atwarns==0 & atwarll==1
replace sambp=0 if sambp==. & atwarns==1

by ccode: gen fearonp=1 if war==0 & warl==1
replace fearonp=0 if fearonp==. & war==1

by ccode: gen chp=1 if collier08==0 & collier08l==1
replace chp=0 if chp==. & collier08==1

pwcorr pitfp priop sambp fearonp chp

/*----GEN  ONSET---*/
so ccode year
by ccode: gen ponset=1 if incidence==1 & incidencel==0
replace ponset=0 if ponset==. & incidence!=.
replace ponset=. if n==1

by ccode: gen prio=1 if inci==1 & incil==0
replace prio=0 if prio==. & inci!=.
replace prio=. if n==1

by ccode: gen samb=1 if atwarns==1 & atwarll==0
replace samb=0 if samb==. & atwarns!=.
replace samb=. if n==1

by ccode: gen fearon=1 if war==1 & warl==0
replace fearon=0 if fearon==. & war!=.
replace fearon=. if n==1

by ccode: gen ch=1 if collier08==1 & collier08l==0
replace ch=0 if ch==. & collier08!=.
replace ch=. if n==1

corr ponset prio samb fearon ch


tab ponset if ssafrica==1
tab ponset if ssafrica!=1
tab prio if ssafrica==1
tab prio if ssafrica!=1
tab samb if ssafrica==1
tab samb if ssafrica!=1
tab fearon if ssafrica==1
tab fearon if ssafrica!=1
tab ch if ssafrica==1
tab ch if ssafrica!=1
/*-------------------TREND----------------*/
replace ponset=1 if n==1 & incidence==1
replace ponset=0 if n==1 & incidence==0

so year ccode
by year: egen trend=sum(incidence)
by year: egen strend=sum(incidence) if ssafrica==1
by year: egen sumdur=sum(incidence) if incidence==1 & pitfonset!=1
by year: egen sumons=sum(ponset)
by year: egen ssumons=sum(ponset) if ssafrica==1
by year: egen nstrend=sum(incidence) if ssafrica!=1
by year: egen nsumons=sum(ponset) if ssafrica!=1



plot trend year
by year: egen trend1=sum(inci)
by year: egen sumdur1=sum(inci) if inci==1 & onset2!=1
by year: egen sumons1=sum(prio)
plot trend1 year
by year: egen trend2=sum(atwarns)
by year: egen sumons2=sum(samb)
by year: egen sumdur2=sum(atwarns) if atwarns==1 & warstnsa!=1

plot trend2 year
by year: egen trend3=sum(war)
by year: egen sumons3=sum(fearon)
by year: egen sumdur3=sum(war) if war==1 & onset!=1

plot trend3 year
by year: egen trend4=sum(collier08)
plot trend4 year

by year: egen strend1=sum(collier08) if ssafrica==1
by year: egen ssumons1=sum(ch) if ssafrica==1
by year: egen nstrend1=sum(collier08) if ssafrica!=1
by year: egen nsumons1=sum(ch) if ssafrica!=1



/*-------------------------USING BTSCS-----------------------------------------*/
btscs incidence year ccode, g(btscs1) nspline(6)
rename _spline1 spi1
rename _spline2 spi2
rename _spline3 spi3
rename _spline4 spi4
rename _spline5 spi5
rename _spline6 spi6
probit incidence lnrgdpch1l lnpopl  mtnest1 onshore ethfrac anocracyl diamond  logt cold coldt incidencel btscs1 spi1 spi2 spi3 spi4 spi5 spi6,  robust
outreg2 using spline, tstat tdec(2) replace

probit incidence lnrgdpch1l lnpopl  mtnest1 onshore ethfrac anocracyl diamond  logt cold coldt incidencel incidencel2 btscs1 spi1 spi2 spi3 spi4 spi5 spi6,  robust
outreg2 using spline1, tstat tdec(2) replace


btscs inci year ccode, g(btscs2) nspline(6)
rename _spline1 spr1
rename _spline2 spr2
rename _spline3 spr3
rename _spline4 spr4
rename _spline5 spr5
rename _spline6 spr6
probit inci lnrgdpch1l lnpopl  mtnest1 onshore ethfrac anocracyl diamond logt cold coldt incil btscs2 spr1 spr2 spr3 spr4 spr5 spr6,  robust
outreg2 using spline, tstat tdec(2) append

probit inci lnrgdpch1l lnpopl  mtnest1 onshore ethfrac anocracyl diamond logt cold coldt incil incil2 btscs2 spr1 spr2 spr3 spr4 spr5 spr6,  robust
outreg2 using spline1, tstat tdec(2) append


btscs atwarns year ccode, g(btscs3) nspline(6)
rename _spline1 sba1
rename _spline2 sba2
rename _spline3 sba3
rename _spline4 sba4
rename _spline5 sba5
rename _spline6 sba6
probit atwarns lnrgdpch1l lnpopl  mtnest1 onshore ethfrac anocracyl diamond logt cold coldt atwarll btscs3 sba1 sba2 sba3 sba4 sba5 sba6,  robust
outreg2 using spline, tstat tdec(2) append

probit atwarns lnrgdpch1l lnpopl  mtnest1 onshore ethfrac anocracyl diamond logt cold coldt atwarll atwarl2 btscs3 sba1 sba2 sba3 sba4 sba5 sba6,  robust
outreg2 using spline1, tstat tdec(2) append


btscs war year ccode, g(btscs4) nspline(6)
rename _spline1 sfe1
rename _spline2 sfe2
rename _spline3 sfe3
rename _spline4 sfe4
rename _spline5 sfe5
rename _spline6 sfe6
probit war lnrgdpch1l lnpopl  mtnest1 onshore ethfrac anocracyl diamond logt cold coldt warl btscs4 sfe1 sfe2 sfe3 sfe4 sfe5 sfe6,  robust
outreg2 using spline, tstat tdec(2) append

probit war lnrgdpch1l lnpopl  mtnest1 onshore ethfrac anocracyl diamond logt cold coldt warl warl2 btscs4 sfe1 sfe2 sfe3 sfe4 sfe5 sfe6,  robust
outreg2 using spline1, tstat tdec(2) append


btscs collier08 year ccode, g(btscs5) nspline(6)
rename _spline1 sco1
rename _spline2 sco2
rename _spline3 sco3
rename _spline4 sco4
rename _spline5 sco5
rename _spline6 sco6
probit collier08 lnrgdpch1l lnpopl  mtnest1 onshore ethfrac anocracyl diamond logt cold coldt collier08l btscs5 sco1 sco2 sco3 sco4 sco5 sco6,  robust
outreg2 using spline, tstat tdec(2) append


probit collier08 lnrgdpch1l lnpopl  mtnest1 onshore ethfrac anocracyl diamond logt cold coldt collier08l collierl2 btscs5 sco1 sco2 sco3 sco4 sco5 sco6,  robust
outreg2 using spline1, tstat tdec(2) append

pwcorr btscs1 btscs2 btscs3 btscs4 btscs5 logt coldt




