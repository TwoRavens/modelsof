clear all
program drop _all
macro   drop _all
matrix  drop _all
set more off
*set matsize 5000
set matsize 800
log using table4.log, replace
************************
* prepare full dataset *
************************
use model-level, clear

keep if year>=1982 & year <=2007

drop realprice2
drop if Tsales==. 	    /* 697 obs. in US in 1994-1997; none in EU countries */

gen aftermerge1 = (firm=="DAIMLER" & year>=1998)

*********************
recode country 1/5=1
*********************

rename Tsales sales
egen Tsales=sum(sales) , by(country year firm make model)
egen Mprice=mean(price), by(country year firm make model)
bysort country year firm make model (price): drop if _n>1
drop sales price 
rename Tsales sales
rename Mprice price
egen   Tsales=sum(sales), by(year)
 gen    share=sales/Tsales
 gen      lns= ln(sales/Tsales)

replace hpwt=hpwt*100
for var hpwt size mpd : egen TX =  sum(X), by(year)
for var hpwt size mpd : egen CX =count(X), by(year)
for var hpwt size mpd : egen TFX=  sum(X), by(year firm)
for var hpwt size mpd : egen CFX=count(X), by(year firm)
for var hpwt size mpd : gen   IX=(TX-TFX)/(CX-CFX)

egen market=group(year country) 
summ market
local MAXmarket=_result(6)

sort country year firm model
tempfile temp markupfile
save `temp', replace

keep year
drop if year>0
save `markupfile', replace

forvalues yy = 1/`MAXmarket' {

	use `temp', clear
	quietly keep if market==`yy'
	di `yy'  "  country = " country[1] "  year = " year[1]
	quietly {
	sort firm model
	gen order=_n
	summ order
	local MAXorder=_result(6)
	for num 1/`MAXorder':     gen  share_X=share              if order==X
	for num 1/`MAXorder':    egen Mshare_X=mean(share_X)
	for num 1/`MAXorder': replace  share_X=0                  if order~=X
	for num 1/`MAXorder':     gen  delta_X=share_X - share*Mshare_X
	for num 1/`MAXorder': replace  delta_X=0                  if firm~=firm[X]
	mkmat delta_1-delta_`MAXorder', matrix(DELTA)
	mkmat share,                    matrix(Mshare)
*	matrix DinvS=inv(diag(Mshare)-Mshare*Mshare')*Mshare   /* works for monopoly */
	matrix DinvS=inv(DELTA)*Mshare
	svmat  DinvS, names(markup)
	matrix drop DELTA DinvS Mshare
	keep country year firm model markup
	append using `markupfile'
	save `markupfile', replace
	}
	}
sort  country year firm model
merge country year firm model using `temp'
drop _merge

replace markup=price if markup>price & markup~=.  /* 288 changes */

tabulate year,    gen(yy)
tabulate firm,    gen(ff)
tabulate country, gen(cc)

* normalizing by OTHER good gets rid of year FE
* use: lns - Mlns0 - {ap}* (  price - MMprice0) - $Xb
for var lns price aftermerge1 size hpwt mpd I* yy*:  gen ZX = X if firm=="OTHER"
for var lns price aftermerge1 size hpwt mpd I* yy*: egen MX = mean(ZX), by(country year)
for var lns price aftermerge1 size hpwt mpd I* yy*:  gen DX = X-MX

gen euro=0
gen usa=0
for any BMW DAIMLER FIAT PSA RENAULT VW: replace euro=1 if firm=="X"
for any FORD GM CHRYSLER: replace usa=1 if firm=="X"
gen region=country
replace region=1 if region~=0
egen RsalesE=sum(sales*(euro==1)), by(year)
egen RsalesU=sum(sales*(usa==1)), by(year)
gen log_Rsales=log(RsalesE*(euro==1)+RsalesU*(usa==1)+(RsalesE+RsalesU)/4*(euro==0)*(usa==0))

global DXb "({a0} + {ax1}*Dsize + {ax2}*Dhpwt + {ax3}*Dmpd)"
global  Xb "({a0} + {ax1}* size + {ax2}* hpwt + {ax3}* mpd)"
global yy1 "({y2} *yy2 + {y3} *yy3 + {y4} *yy4 + {y5} *yy5 + {y6} *yy6 + {y7} *yy7 + {y8} *yy8 + {y9} *yy9 + {y10} *yy10 + {y11} *yy11 + {y12} *yy12 + {y13} *yy13 + {y14} *yy14 + {y15} *yy15 + {y16} *yy16 + {y17} *yy17 + {y18} *yy18 + {y19} *yy19 + {y20} *yy20 + {y21} *yy21 + {y22} *yy22)"
global yy2 "({yy2}*yy2 + {yy3}*yy3 + {yy4}*yy4 + {yy5}*yy5 + {yy6}*yy6 + {yy7}*yy7 + {yy8}*yy8 + {yy9}*yy9 + {yy10}*yy10 + {yy11}*yy11 + {yy12}*yy12 + {yy13}*yy13 + {yy14}*yy14 + {yy15}*yy15 + {yy16}*yy16 + {yy17}*yy17 + {yy18}*yy18 + {yy19}*yy19 + {yy20}*yy20 + {yy21}*yy21 + {yy22}*yy22)"
global ff1 "({f2} *ff2 + {f3} *ff3 + {f4} *ff4 + {f5} *ff5 + {f6} *ff6 + {f7} *ff7 + {f8} *ff8 + {f9} *ff9 + {f10} *ff10 + {f11} *ff11 + {f12} *ff12 + {f13} *ff13 + {f14} *ff14 + {f15} *ff15)"
global ff2 "({ff2}*ff2 + {ff3}*ff3 + {ff4}*ff4 + {ff5}*ff5 + {ff6}*ff6 + {ff7}*ff7 + {ff8}*ff8 + {ff9}*ff9 + {ff10}*ff10 + {ff11}*ff11 + {ff12}*ff12 + {ff13}*ff13 + {ff14}*ff14 + {ff15}*ff15)"
global cc1 "()"
global cc2 "({Cc1} *cc1)"

***************
* CONSTANT MC *
***************
xtivreg lns (price = Isize Ihpwt Impd) size hpwt mpd aftermerge1 cc1, i(year) fe
gen xi = lns - _b[price]*price - _b[cc1]*cc1 - _b[aftermerge1]*aftermerge1
gen xi2= xi^2
gen MC = price - markup/(-_b[price])
regress MC xi xi2
sum MC
* a  = -0.302 (0.032)
* c0 = 11.733 (0.221)    --> only FYI
* c1 =  2.226 (0.078)    --> only FYI
* c2 = -0.086 (0.011)    --> only FYI

*************
* LINEAR MC *
*************
* without transformation
* new, added year-dummies
gmm ( lns - {ap}* price -  $Xb - {am}* aftermerge1 - {cc1}*cc1 - $yy1) ( price - {c0} - {c1}*(lns - {ap}*price - {cc1}*cc1  - $yy1 - {am}* aftermerge1) - markup/(-{ap}) )              , instruments(1: size hpwt mpd Isize Ihpwt Impd cc1 aftermerge1 yy2-yy26) instruments(2:  size  hpwt  mpd  Isize  Ihpwt  Impd cc1 aftermerge1 yy2-yy26)  onestep winitial(unadjusted, indep)  from(ap -.1 c1 0)
* a  = -0.453 (0.013)
* c0 = 13.834 (0.490)
* c1 =  2.450 (0.085) 


******************
* LOG-LINEAR MC *
******************
gmm (Dlns - {ap}*Dprice - $DXb - {am}* aftermerge1 - {cc1}*cc1) ( log(price - markup/(-{ap})) - {c0} - {c1}*(lns - {ap}*price - {cc1}*cc1 - {am}* aftermerge1)), instruments(1: Dsize Dhpwt Dmpd DIsize DIhpwt DImpd cc1 aftermerge1)  instruments(2:  size  hpwt  mpd  Isize  Ihpwt  Impd cc1 aftermerge1)   onestep winitial(unadjusted, indep)   from(ap -.1)

* new markup
* a  = -0.222 (0.019)
* c1 =  0.285 (0.037)


*****************
* CONSTANT TERM *
*****************
***** best to calculate the constant term (if it is needed) 
***** separately using firm-level data
*gen xi = lns - `alpha'*price
*gen MC = price - 1/(1-share)/(-`alpha')
*gen constant = MC - `c1'*xi
*regress this on a constant term and desired controls (e.g. aftermerge1 and/or year dummies)

log close
