*** SAMPLE SELECTION ***

drop if l_ngdcm >= 318 & l_ngdcm~=.
drop if l_ngdcm == 0
drop if l_ngdcm==.

gen nrv_2006 = nrv if year == 2006
replace nrv_2006 = nrv*1.013623 if year == 2005 
replace nrv_2006 = nrv*1.01798 if year == 2004 
replace nrv_2006 = nrv*1.022006 if year == 2003
replace nrv_2006 = nrv*1.041862 if year == 2002
replace nrv_2006 = nrv*1.064096 if year == 2001
drop if nrv_2006 > 10000

drop if nrv>=10000

drop if bfoland~="SE" & year == 2001
drop if bfland~="SVERIGE" & year >= 2002

gen late_enlist = 1 if bari_2>=94
drop if late_enlist == 1

keep if ((tlont>0|isocbid>0|tarbst>0|tsjpersl>0|tforpl>0|tsal>0) & year >= 2004) | ((tlont>0|isocbid>0|tarbst>0|tsjpersl>0|tforpl>0|pfpatp>0) & year == 2003) | ((tlont>0|isocbid>0|tarbst>0|tsjpersl>0|tforpl>0|pfp>0) & year >= 2001 & year <= 2002)

keep if pg~=. & pf~=. & pg>=1 & pf>=1

gen industry = bkungr/1000
replace industry = floor(industry)
replace industry =. if industry == 0
gen indagri = 1 if industry >= 1 & industry <= 5
replace indagri = 0 if indagri ==. & industry ~=.
drop if indagri == 1

keep if (istud == 0|istud==.)

* Rescaling height
gen l_ngdm = (l_ngdcm/100)

*** OCCUPATION ****
gen ssyk2_b = real(ssyk_b)
drop ssyk_b
rename ssyk2_b ssyk_b

gen ssyk2_f = real(ssyk_f)
drop ssyk_f
rename ssyk2_f ssyk_f

gen ssyk = ssyk_b if ssyk_b~=.
replace ssyk = ssyk_f if ssyk ==.

* Adjusting 3-digit codes
replace ssyk = ssyk*10 if ssyk<999 & ssyk~=110 & ssyk~=603

gen ssykgrupp = floor(ssyk/1000) if year >= 2001
gen ssykgrupp10 = floor(ssyk/100) if year >= 2001
gen ssykgrupp100 = floor(ssyk/10) if year >= 2001

/*Basic manager measure for 2001-2006*/
gen chef = 1 if ssykgrupp == 1 & year >= 2001 & year <= 2006
replace chef = 0 if ssykgrupp~=. & ssykgrupp~=1 & year >= 2001 & year <= 2006

/* Detailed managerial position */
gen ceo = 1 if ssykgrupp100 == 121replace ceo = 0 if ssykgrupp100~=121 & ssykgrupp100~=.

