
*************************************************************************
*** simulation for non-resource FDI
*************************************************************************
preserve
global lhs="lnfdinores"
global clus =""
global ldv= "llnfdinores"

global rhs1 ="ln_poptot  lnhumanav   ln_dist  llngdppc lngdp_smp  rernlgdp govshare l1lnresenval "
qui reg $lhs $ldv $rhs1, robust
keep if e(sample)
sort year idcode
qui do "$path\weight matrix calculation rowst.do"
subsave dij* using "$path\w.dta", replace
spatwmat using "$path\w.dta", name(w)
matrix eigenvalues re im = w
matrix e = re'	
spatreg2 $lhs $ldv $rhs1 $extra, robust  w(w) e(e) model(lag) vce($clus)


drop if longitude==.
replace year =1 

keep idcode country year longitude latitude lnfdinores
duplicates drop idcode, force
qui do "$path\weight matrix calculation rowst.do"
subsave dij* using "$path\w.dta", replace
spatwmat using "$path\w.dta", name(w)



*****
*** calculate long run effects: 
*****
sort year idcode 
gen fdinores=exp(lnfdinores)
mkmat fdinores, mat(fdi)
mata
	fdi=st_matrix("fdi")
	W=st_matrix("w")
	A=qrinv(I(rows(W)) -.1498836*W )
	L= -.0214188* A * qrinv( I(rows(W)) -.8312982*A )
	st_matrix("L", L)
	
	Lmin=rowmin(L)
	Ltot=colsum(L:*fdi:*100)
	Ltot=Ltot'
	st_matrix("Lmin", Lmin)
	st_matrix("Ltot", Ltot)
	st_matrix("A", A)
end

svmat Lmin
svmat Ltot
egen fditot=total(fdinores)
gen x= Lmin* fdinores*100
gen row=Ltot-x
gen rowshare=  row/(fditot- fdinores)
gen totshare=Ltot/fditot
replace Lmin=Lmin*100
hilo rowshare totshare Lmin  country fdinores, show(5)




******************************************
** simulation
******************************************
mat a = inv(I(rowsof(w))-.1498836*w)

** Australia: 
gen shocka = 0
replace shocka = 17.722044 if country =="Australia"
mkmat shocka, mat(sa)
mat xa = a* -.0214188*sa

mat ya1 = a*.8312982*(xa)
svmat ya1
renvars ya1, postdrop(1)

local i =2
while `i'<=50 {
local j = `i'-1
mat ya`i' = a*.8312982*ya`j'
svmat ya`i', names(ya`i')
renvars ya`i', postdrop(1)
local i=`i'+1
}


** Norway:

gen shockb = 0
replace shockb = 17.722044 if country =="Norway"
mkmat shockb, mat(sb)
mat xb = a* -.0214188*sb


mat yb1 = a*.8312982*(xb)
svmat yb1
renvars yb1, postdrop(1)

local i =2
while `i'<=50 {
local j = `i'-1
mat yb`i' = a*.8312982*yb`j'
svmat yb`i', names(yb`i')
renvars yb`i', postdrop(1)
local i=`i'+1
}

drop longitude latitude shock* dij*



reshape long ya yb, i(idcode) j(years)
tsset idcode years
label var years "Years after 1 sd increase in natural resource rents"

label var ya "with spillovers"
label var yb "with spillovers"


*** without spatial effects:
sort country years
gen y2=.
label var y2 "without spillovers"

replace y2 = .8312982*(-.0214188*17.722044) if years==1

local i =2
while `i'<=50 {
replace y2 = .8312982*y2[_n-1] if years==`i'
local i = `i'+1
}

*** effects on rest of the world
sort years idcode
by years: egen yarow=total(ya) if country!="Australia"
label var yarow "Rest of the World"
by years: egen ybrow=total(yb) if country!="Norway"
label var ybrow "Rest of the World"

twoway (line ya years if country == "Australia", lcolor(black) lpattern(solid) lwidth(medthick)) (line y2 years if country == "Australia", lcolor(black) lpattern(dash) lwidth(medthick)) (line yarow years if country=="Norway", lcolor(black) lpattern(dot) lwidth(medthick)), name(aus, replace)  legend(rows(1)) nodraw title("Australia") ylabel(,grid)
twoway (line yb years if country == "Norway", lcolor(black) lpattern(solid) lwidth(medthick)) (line y2 years if country == "Norway", lcolor(black) lpattern(dash) lwidth(medthick)) (line ybrow years if country=="Australia", lcolor(black) lpattern(dot) lwidth(medthick)), name(bel, replace)  legend(rows(1)) nodraw title("Norway") ylabel(,grid)
grc1leg aus bel, ycommon rows(1) title("Effect on ln Non-Resource FDI") legend(aus)
graph save "$path\figure2" , asis replace 



*** add the effect of a shock to resource fdi
sort country years
gen yr=.
label var yr "resource FDI"

replace yr = 0.8520112*(0.0307566*17.722044) if years==1

local i =2
qui while `i'<=50 {
replace yr = 0.8520112*yr[_n-1] if years==`i'
local i = `i'+1
}
gen yrnor =yr
replace yrnor=0 if country!="Norway"
gen yraus =yr
replace yraus=0 if country!="Australia"

local i =1
qui while `i' <=50 {
egen temp = min(yarow) if years==`i'
replace yarow=temp if yarow==. & years==`i'
drop temp
local i = `i'+1
}

local i =1
qui while `i' <=50 {
egen temp = min(ybrow) if years==`i'
replace ybrow=temp if ybrow==. & years==`i'
drop temp
local i = `i'+1
}

gen ytotalaus = ya+yarow 
label var ytotalaus "non-resource FDI"
gen ytotalnor = yb+ybrow 
label var ytotalnor "non-resource FDI"

gen ysumaus = ytotalaus+yraus
label var ysumaus "Total FDI"
gen ysumnor = ytotalnor+yrnor
label var ysumnor "Total FDI"

twoway (line ysumaus years if country=="Australia", lcolor(black) lpattern(solid) lwidth(medthick)) (line ytotalaus years if country == "Australia", lcolor(black) lpattern(dash) lwidth(medthick)) (line yr years if country=="Australia", lcolor(black) lpattern(dot) lwidth(medthick)) , name(aus2, replace)  legend(rows(1)) nodraw title("Australia") ylabel(,grid)
twoway (line ysumnor years if country == "Norway", lcolor(black) lpattern(solid) lwidth(medthick)) (line ytotalnor years if country == "Norway", lcolor(black) lpattern(dash) lwidth(medthick)) (line yr years if country == "Norway", lcolor(black) lpattern(dot) lwidth(medthick)) , name(nor2, replace)  legend(rows(1)) nodraw title("Norway") ylabel(,grid)
grc1leg aus2 nor2, ycommon rows(1) title("Effect on World FDI") legend(aus2)
graph save "$path\figure3" , asis replace 

restore








