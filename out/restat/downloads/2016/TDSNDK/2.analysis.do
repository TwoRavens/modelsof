*sale price died to delisting
insheet using compweekspl.txt,clear
rename v1 weeknum
rename v2 listindexspl
rename v3 delistspl
save compweekspl,replace

*sale price at closing
insheet using compweeksp.txt,clear
rename v1 weeknum
rename v2 listindexsp
rename v3 delistsp
replace weeknum=weeknum
save compweeksp,replace

*sale price at closing, only homes that link to mls
insheet using compweekspm.txt,clear
rename v1 weeknum
rename v2 listindexspm
rename v3 delistspm
replace weeknum=weeknum
save compweekspm,replace


merge 1:1 weeknum using compweekspl
drop _merge
merge 1:1 weeknum using compweeksp
drop _merge

*2 week change in variables of interest
local x=2

gen numdatel2=weeknum
format numdatel2 %d
*bring the date to a friday to undo bringing date to a sunday
gen numdatel=weeknum+5

gen m=month(numdatel)
gen y=year(numdatel)
gen d=day(numdatel)
gen w=week(numdatel)

*merge on s&p500 stock prices
sort numdatel
rename numdatel numdatel_r
gen rate=0
gen crate=0
forvalues q=0/7{
gen numdatel=numdatel_r+`q'
sort numdatel
merge numdatel using stockprices,nokeep
drop _merge
replace rate=rate+close if close!=.
replace crate=crate+1 if close!=.
drop close numdatel
}
gen sprice=rate/crate
drop crate rate
rename numdatel_r numdatel

*merge on 10 year treasury rates
sort numdatel
rename numdatel numdatel_r
gen rate=0
gen crate=0
forvalues q=0/7{
gen numdatel=numdatel_r+`q'
sort numdatel
merge numdatel using treasury,nokeep
drop _merge
replace rate=rate+treasury if treasury!=.
replace crate=crate+1 if treasury!=.
drop treasury numdatel
}
gen treasrate=rate/crate
drop crate rate


*merge on surprise index
rename numdatel_r numdatel
sort numdatel
rename numdatel numdatel_r
gen rate=0
gen crate=0
forvalues q=0/7{
gen numdatel=numdatel_r+`q'
merge 1:1 numdatel using surprise_index
drop if _merge==2
drop _merge
replace rate=rate+surprise if surprise!=.
replace crate=crate+1 if surprise!=.
drop surprise* numdatel
}
gen surpriseindex=rate/crate
drop crate rate



sort numdatel
gen chngcontract=(listindexspl)-(listindexspl[_n-`x'])
gen chngsaleprice=(listindexsp)-(listindexsp[_n-`x'])
gen chngsalepricem=(listindexspm)-(listindexspm[_n-`x'])
gen chngstock=ln(sprice)-ln(sprice[_n-`x'])
gen chngsurprise=surprise-surprise[_n-`x']
gen chngrate=ln(treasrate)-ln(treasrate[_n-`x'])

*choose a csample period for which listings and sales data overlap
gen common2=(y>=2008&y<=2012)
replace common2=0 if weeknum>=19266
replace common2=0 if y==2008 & m<2


format numdatel %dmY

*create figure 3
line listindexsp listindexspm numdatel if common==1, lcolor(gs10 black )  legend(order(1 "All Transactions" 2 "Transactions Linked to MLS"  )) ytitle("Log Price Level") xtitle("") saving(linktomls.gph,replace)
graph export linktomls.ps,replace logo(off)
!ps2pdf linktomls.ps linktomls.pdf

*create figure 4
line listindexspl listindexsp  numdatel if common2==1, lcolor(gs10 black )  legend(order(1 "Contract-Dated Index" 2 "Closing-Dated Index"  )) ytitle("Log Price Level") xtitle("") saving(indexcomparison.gph,replace) ylabel(.4 (.2) 1.2)
graph export indexcomparison.ps,replace logo(off)
!ps2pdf indexcomparison.ps indexcomparison.pdf

egen tid=group(numdatel)
tsset tid

*create table 2
gen contract=listindexspl
gen saleprice=listindexsp
newey saleprice L.saleprice L2.saleprice L.contract  L2.contract if common2==1,lag(5) 
outreg2 using lead, excel alpha(.01,.05,.1) symbol(***,**,*) r bdec(4)  drop(_I*) replace
newey contract L.contract L2.contract L.saleprice if common2==1, lag(5) 
outreg2 using lead, excel alpha(.01,.05,.1) symbol(***,**,*) r bdec(4)  drop(_I*) append


local y=6
local z=2*`x'
local zz=3*`x'

**************************
**uncomment to produce table 3
***************************
*keep if common2==1
*collapse (p10) chngcontractp10=chngcontract  chngsalepricep10=chngsaleprice  chngstockp10=chngstock  surprisep10=surprise  chngratep10=chngrate (p25) chngcontractp25=chngcontract  chngsalepricep25=chngsaleprice  chngstockp25=chngstock  surprisep25=surprise  chngratep25=chngrate (p50) chngcontractp50=chngcontract  chngsalepricep50=chngsaleprice  chngstockp50=chngstock  surprisep50=surprise  chngratep50=chngrate (p75)  chngcontractp75=chngcontract  chngsalepricep75=chngsaleprice  chngstockp75=chngstock  surprisep75=surprise  chngratep75=chngrate (p90) chngcontractp90=chngcontract  chngsalepricep90=chngsaleprice  chngstockp90=chngstock  surprisep90=surprise  chngratep90=chngrate,by(common2)
*reshape long chngcontractp chngsalepricep chngstockp surprisep chngratep, i(common2) j(pctile)
*drop common2
*outsheet using summstats_new.xls

**first show correlation between surprise and stocks


**********************
*stock prices, table 4
**********************
*week dummies
xi i.w
sureg(chngcontract  L.chngstock  L`x'.chngcontract L`z'.chngcontract L`zz'.chngcontract _I*) (chngsaleprice  L.chngstock  L`x'.chngsaleprice L`z'.chngsaleprice L`zz'.chngsaleprice _I* ) if common2==1
outreg2 using stocks`x'_`y', excel alpha(.01,.05,.1) symbol(***,**,*) r bdec(4) sortvar(L.chngstock L5.chngstock) drop(_I*) replace
sureg(chngcontract  L.chngstock  L`x'.chngcontract L`z'.chngcontract L`zz'.chngcontract _I*) (chngsaleprice  L5.chngstock  L`x'.chngsaleprice L`z'.chngsaleprice L`zz'.chngsaleprice _I* ) if common2==1
outreg2 using stocks`x'_`y', excel alpha(.01,.05,.1) symbol(***,**,*) r bdec(4) sortvar(L.chngstock L5.chngstock)  drop(_I*)  append
test _b[chngsaleprice:L5.chngstock]-_b[chngcontract:L.chngstock]=0
*full sample
areg chngsaleprice  L.chngstock  L`x'.chngsaleprice L`z'.chngsaleprice L`zz'.chngsaleprice ,a(w) r
outreg2 using stocks`x'_`y', excel alpha(.01,.05,.1) symbol(***,**,*) r bdec(4) sortvar(L.chngstock L5.chngstock)  drop(_I*)  append
*full sample
areg chngsaleprice  L5.chngstock  L`x'.chngsaleprice L`z'.chngsaleprice L`zz'.chngsaleprice ,a(w) r
outreg2 using stocks`x'_`y', excel alpha(.01,.05,.1) symbol(***,**,*) r bdec(4) sortvar(L.chngstock L5.chngstock)  drop(_I*)  append

************************
*surprise, table 5
*************************
replace surprise=surprise/1000
sum surprise if common2==1
reg chngstock surprise if common2==1
outreg2 using surprise`x'_`y', excel alpha(.01,.05,.1) symbol(***,**,*) r bdec(4) sortvar(L.surprise L5.surprise L.chngstock L5.chngstock) drop(_I*) replace
sureg(chngcontract  L.surprise  L`x'.chngcontract L`z'.chngcontract L`zz'.chngcontract _I*) (chngsaleprice  L.surprise  L`x'.chngsaleprice L`z'.chngsaleprice L`zz'.chngsaleprice _I* ) if common2==1
outreg2 using surprise`x'_`y', excel alpha(.01,.05,.1) symbol(***,**,*) r bdec(4) sortvar(L.surprise L5.surprise L.chngstock L5.chngstock) drop(_I*) append
sureg(chngcontract  L.surprise  L`x'.chngcontract L`z'.chngcontract L`zz'.chngcontract _I*) (chngsaleprice  L5.surprise  L`x'.chngsaleprice L`z'.chngsaleprice L`zz'.chngsaleprice _I* ) if common2==1
outreg2 using surprise`x'_`y', excel alpha(.01,.05,.1) symbol(***,**,*) r bdec(4) sortvar(L.surprise L5.surprise L.chngstock L5.chngstock)  drop(_I*) append
test _b[chngsaleprice:L5.surprise]-_b[chngcontract:L.surprise]=0
*full sample
areg chngsaleprice  L.surprise  L`x'.chngsaleprice L`z'.chngsaleprice L`zz'.chngsaleprice ,a(w)
outreg2 using surprise`x'_`y', excel alpha(.01,.05,.1) symbol(***,**,*) r bdec(4) sortvar(L.surprise L5.surprise L.chngstock L5.chngstock)  drop(_I*) append
*full sample
areg chngsaleprice  L5.surprise  L`x'.chngsaleprice L`z'.chngsaleprice L`zz'.chngsaleprice ,a(w)
outreg2 using surprise`x'_`y', excel alpha(.01,.05,.1) symbol(***,**,*) r bdec(4) sortvar (L.surprise L5.surprise L.chngstock L5.chngstock)  drop(_I*) append
**now with stock prices too
sureg(chngcontract  L.surprise L.chngstock L`x'.chngcontract L`z'.chngcontract L`zz'.chngcontract _I*) (chngsaleprice  L5.surprise L5.chngstock L`x'.chngsaleprice L`z'.chngsaleprice L`zz'.chngsaleprice _I* ) if common2==1
outreg2 using surprise`x'_`y', excel alpha(.01,.05,.1) symbol(***,**,*) r bdec(4) sortvar(L.surprise L5.surprise L.chngstock L5.chngstock)  drop(_I*) append

************************
*treasury rate, table 6
*************************
sureg(chngcontract  L.chngrate  L`x'.chngcontract L`z'.chngcontract L`zz'.chngcontract _I*) (chngsaleprice  L.chngrate  L`x'.chngsaleprice L`z'.chngsaleprice L`zz'.chngsaleprice _I* ) if common2==1
outreg2 using chngrate`x'_`y', excel alpha(.01,.05,.1) symbol(***,**,*) r bdec(4) sortvar(L.chngrate L5.chngrate L.chngstock L.surprise) drop(_I*) replace
sureg(chngcontract  L.chngrate  L`x'.chngcontract L`z'.chngcontract L`zz'.chngcontract _I*) (chngsaleprice  L5.chngrate  L`x'.chngsaleprice L`z'.chngsaleprice L`zz'.chngsaleprice _I* ) if common2==1
outreg2 using chngrate`x'_`y', excel alpha(.01,.05,.1) symbol(***,**,*) r bdec(4) sortvar(L.chngrate L5.chngrate L.chngstock L.surprise)  drop(_I*) append
test _b[chngsaleprice:L5.chngrate]-_b[chngcontract:L.chngrate]=0
*full sample
areg chngsaleprice  L.chngrate  L`x'.chngsaleprice L`z'.chngsaleprice L`zz'.chngsaleprice ,a(w)
outreg2 using chngrate`x'_`y', excel alpha(.01,.05,.1) symbol(***,**,*) r bdec(4) sortvar(L.chngrate L5.chngrate L.chngstock L.surprise)  drop(_I*) append
*full sample
areg chngsaleprice  L5.chngrate  L`x'.chngsaleprice L`z'.chngsaleprice L`zz'.chngsaleprice ,a(w)
outreg2 using chngrate`x'_`y', excel alpha(.01,.05,.1) symbol(***,**,*) r bdec(4) sortvar(L.chngrate L5.chngrate L.chngstock L.surprise)  drop(_I*) append
**now with stock prices too
sureg(chngcontract  L.surprise L.chngstock L.chngrate L`x'.chngcontract L`z'.chngcontract L`zz'.chngcontract _I*) (chngsaleprice  L5.surprise L5.chngstock L5.chngrate L`x'.chngsaleprice L`z'.chngsaleprice L`zz'.chngsaleprice _I* ) if common2==1
outreg2 using chngrate`x'_`y', excel alpha(.01,.05,.1) symbol(***,**,*) r bdec(4) sortvar(L.chngrate L5.chngrate L.chngstock L.surprise)  drop(_I*) append


****************************
*impulse responses, figures 5-6
******************************
do irfs.do
drop coeff seup selow spcoeff spseup spselow spfull* chngsalepricefull index
do irf_surprises.do

******************************
**persistence, figure 7
******************************************
replace listindexsp=. if common2!=1
replace listindexspl=. if common2!=1

drop chng*
forvalues x=1/16{
gen chngsaleprice`x'=(listindexsp)-(listindexsp[_n-`x'])
gen chngcontract`x'=(listindexspl)-(listindexspl[_n-`x'])
}
drop coeff
gen coeff_delist=.
gen coeff=.
gen id=.
forvalues j=1/16{
local k=`j'+1
areg chngcontract`j'   L`k'.chngcontract`j' if common2==1 , a(w) r
replace coeff_delist=_b[L`k'.chngcontract] in `j'
areg chngsaleprice`j'   L`k'.chngsaleprice`j' if common2==1 , a(w) r
replace coeff=_b[L`k'.chngsaleprice] in `j'
replace id=`j' in `j'
}

graph bar coeff coeff_delist ,over(id) legend(label(1 "Closing-dated index") label (2 "Contract-dated index")) saving(persistence.gph,replace)
graph export persistence.ps,replace logo(off)
!ps2pdf persistence.ps persistence.pdf

*****************************
**seasonality, figure 8
*********************************
drop _I*
xi i.m,noomit
reg listindexspl _I* if common2==1,nocons
gen seasspl=.
forvalues j=1/12{
replace seasspl=_b[_Im_`j'] in `j'
}
reg listindexsp _I* if common2==1,nocons
gen seassp=.
forvalues j=1/12{
replace seassp=_b[_Im_`j'] in `j'
}

egen temp1=mean(seasspl)
replace seasspl=seasspl-temp1
drop temp1
egen temp1=mean(seassp)
replace seassp=seassp-temp1

drop index
gen index=_n
line seassp seasspl index in 1/12,xtitle("Calendar Month") xlabel(1 (1) 12) saving(seasonal2.gph,replace) legend(label(1 "Closing-dated index") label (2 "Contract-dated index")) lpattern(l - )
graph export seasonal.ps,replace logo(off)
!ps2pdf seasonal.ps seasonal.pdf


