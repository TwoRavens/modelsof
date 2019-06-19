*use "IGG.dta", clear
xtset ctrycd

***Table 1 ***

*** Column 1a ***
xtreg outlays loutlays yp ideologymvma trade oil_ex oil_im ygap prop1564 prop65 if ygap<=5 & ygap>=-5 , fe vce(robust)

*** Column 1b ***
test ideologymvma
nlcom _b[ideologymvma]/(1-_b[loutlays])
nlcom _b[yp]/(1-_b[loutlays])

*** Column 2a ***
xtreg outlays loutlays yp ideologymv trade oil_ex oil_im ygap  prop1564 prop65 if ygap<=5 & ygap>=-5 & ideologymvma~=.  , fe robust 
 
*** Column 2b ***
test ideologymv 
nlcom _b[yp]/(1-_b[loutlays])
nlcom _b[ideologymv]/(1-_b[loutlays])


*** Table 2 ***

replace turnout=turnout*100
gen ypturnout=yp*turnout

*** Column 1a ***
xtreg outlays turnout yp ypturnout trade oil_ex oil_im ygap if ygap<=5 & ygap>=-5 & ideologymvma~=. & loutlays~=. , fe r

*** Column 1b ***
xtreg outlays turnout yp ypturnout ideologymvma interactmvma trade oil_ex oil_im ygap if ygap<=5 & ygap>=-5 & loutlays~=. , fe r

*** Column 2a ***
xtreg outlays loutlays yp ideologymvma interactmvma trade oil_ex oil_im ygap if ygap<=5 & ygap>=-5 , fe r

*** Column 2b ***
test ideologymvma interactmvma
nlcom _b[ideologymvma]/(1-_b[loutlays])
nlcom _b[yp]/(1-_b[loutlays])
nlcom _b[interactmvma]/(1-_b[loutlays])

*** Column 3a ***
xtreg outlays loutlays yp ideologymvma interactmvma trade oil_ex oil_im ygap y60-y98 if ygap<=5 & ygap>=-5 , fe r

*** Column 3b ***
test ideologymvma interactmvma
nlcom _b[ideologymvma]/(1-_b[loutlays])
nlcom _b[yp]/(1-_b[loutlays])
nlcom _b[interactmvma]/(1-_b[loutlays])


*** Table 3 ***

*** Column 1 ***
xtreg outlays loutlays yp ideologymvma interactmvma trade oil_ex oil_im ygap y61-y97 if ygap<=5 & ygap>=-5 & maj==0, fe r

*** Column 2 ***
xtreg outlays loutlays yp ideologymvma interactmvma trade oil_ex oil_im ygap y61-y97 if ygap<=5 & ygap>=-5 & maj==1, fe r

*** N.B Versions of STATA pre-11 give slightly different Std Errors for Columns 3 & 4 ***

*** Column 3 ***
xtreg outlays loutlays yp maj trade oil_ex oil_im ygap y61-y97 if ygap<=5 & ygap>=-5 & ideologymvma~=. , r

*** Column 4 ***
xtreg outlays loutlays yp ideologymvma interactmvma maj trade oil_ex oil_im ygap y61-y97 if ygap<=5 & ygap>=-5 , r


*** Table 4 ***

quietly foreach s of varlist incomeequal selfpospolit {
	forvalues i = 1960(1)1998 {
	bys country (year): replace `s'=`s'[_N-3] if year==`i' & year~=1995
	bys country (year): replace `s'=`s'[_N-3] if year==`i' & year~=1995
}
by year ctrycd, sort: gen `s'interact=yp*`s' 
}

gen ideopre60s = -mrgpre1960/100
gen interactideopre1960 = yp*ideopre60s
gen ideoall = -averiteleft/100
gen interactideoall=ideoall*yp

*** Column 1 ***
xtreg outlays loutlays trade oil_ex oil_im ygap yp selfpospolitinteract y60-y98 if ideologymvma~=. & ygap<=5 & ygap>=-5 , fe vce(robust)

*** Column 2 ***
xtreg outlays loutlays trade oil_ex oil_im ygap yp incomeequalinteract y60-y98 if ideologymvma~=. & ygap<=5 & ygap>=-5 , fe vce(robust)

*** Column 3 ***
xtreg outlays loutlays trade oil_ex oil_im ygap yp interactideoall y60-y98 if ideologymvma~=. & ygap<=5 & ygap>=-5 , fe vce(robust)

*** Column 4 ***
xtreg outlays loutlays trade oil_ex oil_im ygap yp   interactideopre1960 y60-y98 if ideologymvma~=. & ygap<=5 & ygap>=-5 , fe vce(robust)


*** Equation 15 ***

*Get time varying income slope coefs and regress on ideology
***********************************************************************************************************
cap drop beta
cap drop eta
cap drop slopey*
cap drop bcoef
cap drop countrynum
gen bcoef=.
encode country, gen(countrynum)
cap drop ypccdummy*
forv u=1/18 {
	gen ypccdummy`u'=yp*(countrynum==`u')
	}
cap drop essypm
cap drop tempessypm
gen essypm=.
sort country (year)
cap drop bcoef20
gen bcoef20=.
cap forv k = 1960(1)1978 {
	quietly xtreg outlays ypccdummy1-ypccdummy18 loutlays trade toil ygap if polity_gt<=3.6661  & ygap<=5 & ygap>=-5 & year>=`k' & year<=(`k'+20), fe vce(robust) 
	mat medbeta`k'=e(b)
	 forv z=1/18 {
		replace bcoef20=_b[ypccdummy`z'] if year==`k'+10 & countrynum==`z' 
		egen tempessypm=mean(yp) if year>=`k' & year<=(`k'+20) & countrynum==`z'
		replace essypm=tempessypm if year==(`k'+10) & countrynum==`z'
		cap drop tempessypm
	}
	
}

regr bcoef20 ideologymvma essypm, robust


*** Figures 1,2 and 6 ***




gen betarw=0.3
gen betalw=0.6
gen mu=2000
gen m=2
gen delta=3
gen ybar=_n*100 if _n<501
gen rybar=(m-1)/(2*delta)
gen ry=0.18
cap drop tmlw
cap drop tmrw
gen tmlw=(((4*betalw*delta)+((m-1)*((betalw*m)+2+betalw)))/((1+betalw)*((4*delta)-((m-1)^2))))-(((1+(betalw*m))*mu)/((1+betalw)*ybar))

gen tmrw=(((4*betarw*delta)+((m-1)*((betarw*m)+2+betalw)))/((1+betarw)*((4*delta)-((m-1)^2))))-(((1+(betarw*m))*mu)/((1+betarw)*ybar))

twoway (line tmlw ybar if tmlw>0.18) (line tmrw ybar if tmrw>0.18) (line ry ybar, lwidth(thin) lpattern(solid) connect(direct)) , ytitle(Size of the State (t)) yscale(range(0 0.6)) ylabel(0(0.1)0.6) xtitle(Mean Income per Capita) legend(order(1 "Archetypal left-wing" 2 "Archetypal right-wing" 3 "r(y)")) scheme(s1color)


***Figure 2***


xtline outlays, overlay plot1opts(lcolor(pink)) plot2opts(lcolor(stone)) i(country) t(year) ytitle(%) ytitle(, margin(medlarge)) ylabel(0(10)80) ttitle(Year) tscale(range(1960 1998)) title(Total Government Outlays as a share of GDP in OECD countries, size(medium) justification(center)) legend(order(1 "Australia" 2 "Austria" 3 "Belgium" 4 "Canada" 5 "Denmark" 6 "Finland" 7 "France" 8 "Germany" 9 "Iceland" 10 "Ireland" 11 "Italy"  12 "Netherlands" 13  "Norway" 14 "Sweden"  15 "Switzerland"  16 "UK" 17 "USA") cols(1) all size(small) region(margin(2 7 2 2) lcolor(none)) position(3)) scheme(s1color)


*** Figure 6 ***

*Marginal Distribution plot code based on that accompanying Brambor et al (2006)
xtreg outlays ideologymvma  yp interactmvma loutlays  trade oil_ex oil_im ygap if ygap<=5 & ygap>=-5 , vce(robust) fe 
  
cap drop MV
generate MV=(_n-1)/1
replace  MV=. if _n>24
matrix b=e(b) 
matrix V=e(V)
scalar b1=b[1,1] 
scalar b2=b[1,2]
scalar b3=b[1,3]
scalar varb1=V[1,1] 
scalar varb2=V[2,2] 
scalar varb3=V[3,3]
scalar covb1b3=V[1,3] 
scalar covb2b3=V[2,3]
cap drop conb conse a upper lower
gen conb=b1+b3*MV if _n<23 &_n>3.5
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<23 & _n>3.5
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a
twoway (line conb MV) (line upper MV, lpattern(dash)) (line lower MV, lpattern(dash)) if ygap<=5 & ygap>=-5, ytitle(Marginal Effect of Ideology on Government Spending) xtitle(Income Per Capita ({c S|}US thousand)) legend(order(1 "Marginal Effect" 2 "95% Confidence Interval"))

cap log close
