
clear all
set mem 300m
set more off
 

/****************************************************************
* 	This file replicates the results in
*   Fair Trade and Free Entree: Can a Disequilibrium Market Serve as a Development Tool?
*   by Alain de Janvry, Craig McIntosh, and Elisabeth Sadoulet
*   Review of Economics and Statistics
*****************************************************************/

* There are two input files:
*   - sale.dta  that provides information at the sale level
*   - deliverysalematch.dta that provides information at the delivery-sale pair level

/*USER DIRECTORY HERE:*/
cd "/Users/sadoulet/Documents/A-Papers/Fair Trade/Paper/Final REStat Sept 2014/Replication files/"

******************************************************
**********   Table 1 and A2 - Annual ft premium  *****
******************************************************
use  deliverysalematch, replace
forvalues y=1997/2009 { 
gen shipft`y'=ft*(shipmentyear==`y')
}
egen ftmean=mean(ft), by(ingresoid)

************ from split deliveries ************
preserve
keep if ftmean>0 & ftmean<1
sort ingresoid shiptime
by ingresoid: gen match=1 if shiptime==shiptime[_n-1]
by ingresoid: replace match=1 if shiptime==shiptime[_n+1]
tab match, missing

qui xi: xtreg finalprice shipft1997-shipft2009 i.shiptime, i(ingresoid) fe robust
  outreg2 shipft1997-shipft2009 using "TableA2",se bracket 2aster dec(2)  title("FT premium") ctitle("split deliveries, with shiptime") replace
qui xi: xtreg finalprice shipft1997-shipft2009 if match==1, i(ingresoid) fe robust
  outreg2 shipft1* shipft2* using "Table1",se bracket 2aster dec(2) title("FT premium") ctitle("split deliveries, same shiptime") replace
restore

************ from all delivery-sales matched **********
************ with quality and coop fixed effects ******

qui xi:xtreg finalprice  shipft1997-shipft2009 cal_* i.shiptime, i(coop_id) fe robust
outreg2 shipft1* shipft2* using "Table1", se bracket 2aster  dec(2) ctitle("p coopfe cal* no dup") append

preserve
gen ftprem_coopFE=.
forvalues x=1997/2009 {
replace ftprem_coopFE=_b[shipft`x'] if shipmentyear==`x'
}
collapse ftprem_coopFE, by(shipmentyear)
sort shipmentyear
save "ftpremiumcoopFE", replace 
restore

qui xi:xtreg finalprice  shipft1997-shipft2009 cal_* i.shiptime if  (ftmean==0 | ftmean==1), i(coop_id) fe robust
outreg2 shipft1* shipft2* using "TableA2", se bracket 2aster  dec(2) ctitle("same+no-mixed") append
gen differential=finalprice-nyprice

* creation of a quality index
qui tab coop_id, gen(icoop)
qui reg differential cal* icoop* if ft==0, nocons
predict qualindexfe
label variable qualindexfe "Quality index with coop fe"
qui xi:xtreg finalprice  shipft1997-shipft2009 qualindexfe  i.shiptime, i(coop_id) fe robust
outreg2 shipft1* shipft2* using "TableA2", se bracket 2aster  dec(2) ctitle("p-coopfe-qualindex") append

qui xi:xtreg differential  shipft1997-shipft2009 cal* , i(coop_id) fe robust
outreg2 shipft1* shipft2* using "TableA2", se bracket 2aster  dec(2) ctitle("differential") append


************  from sales data, with quality ******************
use sale, replace
forvalues y=1997/2009 {
gen shipft`y'=ft*(shipmentyear==`y')
}
qui xi:reg finalprice cal*  shipft* i.shiptime, robust
outreg2 shipft1* shipft2* using "Table1", se dec(2) 2aster bracket ctitle("sales cal*") append
qui xi:reg finalprice shipft* i.shiptime, robust
outreg2 shipft1* shipft2* using "Table1", se dec(2) 2aster  bracket ctitle("sales no cal") append

gen differential=finalprice-nyprice
qui xi:reg differential cal*  shipft* i.shiptime, robust
outreg2 shipft1* shipft2* using "TableA2", se dec(2) 2aster bracket ctitle("salesdifferential") append



*************************************************************
********** Table 2 - Fair Trade rule and FT share  **********
*************************************************************
use sale, replace
forvalues y=1997/2009 {
gen shipft`y'=ft*(shipmentyear==`y')
}

gen binding=nyprice<ftfloorp
gen nyp_binding=nyprice*binding
gen nyp_notbinding=nyprice*(1-binding)
gen dp=(ftfloorp-nyprice)
gen dpftbind=binding*dp*ft
gen dpftnotbind=dp*ft*(1-binding)
gen socialftbind=ftsocial*ft*binding
gen socialftnotbind=ftsocial*ft*(1-binding)


gen ftfloorsocial=ftfloorp+ftsocial
gen nypsocial=nyprice+ftsocial
gen violate=0
replace violate=1 if finalprice<ftfloorsocial & binding==1
replace violate=1 if finalprice<nypsocial & binding==0
tab violate binding if ft==1, col
gen violatenosocial=0
replace violatenosocial =1 if finalprice<ftfloorp & binding==1
replace violatenosocial =1 if finalprice<nyprice & binding==0
tab violatenosocial binding if ft==1, col

reg finalprice socialftbind socialftnotbind dpftbind dpftnotbind nyprice, robust
test (socialftbind=1) (socialftnotbind=1) (dpftbind=1) (dpftnotbind=0)
test socialftbind=1 
test socialftnotbind=1 
test dpftbind=1
test nyprice=1
outreg2 socialftbind  dpftbind socialftnotbind dpftnotbind nyprice using "Table2", se bracket 2aster dec(2) replace


gen dpbind=dp*binding
gen dpnotbind=dp*(1-binding)
gen ft100=ft*100
reg ft100 dpbind dpnotbind, robust
outreg2 dpbind dpnotbind using "Table2", se bracket 2aster dec(2) append



******************************************************
****** Table A1  - Descriptive statistics  ***
******************************************************

use "sale.dta", replace
gen nsale=1
gen pminflo=max(nyprice, ftfloorp)+ftsocial
gen premiumflo=pminflo-nyprice

gen bagsFT=bagssale if ft==1 
gen bagsnonFT=bagssale if ft==0 
gen FTvalue=bagsFT*finalprice
gen nypbags=nyprice*bagssale
gen premiumflobags=premiumflo*bagsFT
collapse (sum) nsale bagssale bagsFT bagsnonFT  FTvalue nypbags premiumflobags, by(shipmentyear)
gen nypav=nypbags/bagssale
gen ftpriceav= FTvalue/bagsFT
gen premiumflo=premiumflobags/bagsFT
drop FTvalue nypbags premiumflobags
list,  sep(0)
sort shipmentyear
save "TableA1Col1_5", replace 
preserve
keep shipmentyear premiumflo
sort shipmentyear
save "flopremium", replace 
restore
merge 1:1 shipmentyear using flopremium
drop _m
merge 1:1 shipmentyear using ftpremiumcoopFE
drop _m
gen ftshare=100*bagsFT/bagssale
gen effective=ftprem_coopFE*ftshare/100
gen ftpremsh=100*ftprem_coopFE/ftpriceav
list shipmentyear bagssale ftshare nypav ftpriceav premiumflo ftprem_coopFE effective ftpremsh, sep(0)



***************************************************
*********************** price graphs **********
***************************************************


***** Raw price graph  *****************************

use "sale.dta", replace
gen ftsales=bags*finalprice if ft==1 
gen nftsales=bags*finalprice if ft==0 
gen ftbags=bags if ft==1  & finalprice~=.
gen nftbags=bags if ft==0  & finalprice~=.

* monthly average ftfloor, social and nyprice are not weighted by quantity
collapse (mean) ftfloorp ftsocial nyprice (sum) ftsales nftsales ftbags nftbags , by(shipmentmonth shipmentyear shiptime)
foreach X in ft nft {
 gen `X'meanp=`X'sales/`X'bags
  }

gen ftshare= ftbags/(ftbags+nftbags)
gen ftminp=max(ftfloorp+ftsocial, nyprice+ftsocial)
label variable ftmeanp "Average FT price"
label variable nftmeanp "Average non FT price"
label variable ftminp "FT minimum price"
label variable nyprice "NYC price"

sort shiptime
label variable shiptime " "

* periods of binding floor price
gen ac1=250 if shiptime>1998.49 & shiptime< 2005.084
gen ac2=250 if shiptime>2005.49 & shiptime< 2006.76
gen ac3=250 if shiptime>2007.166 & shiptime< 2007.51
gen ac4=250 if shiptime>2008.74 & shiptime< 2008.92
label var ac1 "FT price binding"
twoway area ac1 shiptime,  bcolor(gs10) || area ac2 shiptime,  bcolor(gs10) ||area ac3 shiptime, bcolor(gs10) ||area ac4 shiptime, bcolor(gs10) || ///
line ftmeanp nftmeanp ftminp nyprice shiptime, ytitle("Price (US cents/lb)")  lpattern(solid dash  dash_dot shortdash) ///
 xmtick(##11) xlabel(1997(1)2009, grid)  scheme(s2mono) graphr(m(r+10)) legend(order(5 6 7 8 1)) saving("prices", replace)


***  Graph of FT premium and share  *****************************

use "sale.dta", replace
gen ftbags=bagssale if ft==1 
gen nftbags= bagssale if ft==0
collapse (sum) bagsyear=bags ftbagsyear=ftbags, by(shipmentyear)
gen ftshareyear=ftbags/bags
sort shipmentyear
save "ftshare", replace
merge 1:1 shipmentyear using "ftpremiumcoopFE"
drop _m
merge 1:1 shipmentyear using "flopremium"
drop _m
rename shipmentyear shiptime
append using "sale"

rename ftprem_coopFE ftpremium
gen effective=ftpremium*ftshareyear
gen netpremium=effective
replace netpremium=effective -3 if shiptime>=2004
label variable premiumflo "FLO formula"
label variable ftpremium "Nominal premium"
label variable nyprice "NYC price"
label variable effective "Effective (per certified lb)"
label variable netpremium "Net of certification cost"
label variable ftshareyear "Fair Trade share (right scale)"

* periods of binding floor price
gen ac1=80 if shiptime>1998.49 & shiptime< 2005.084
gen ac2=80 if shiptime>2005.49 & shiptime< 2006.76
gen ac3=80 if shiptime>2007.166 & shiptime< 2007.51
gen ac4=80 if shiptime>2008.74 & shiptime< 2008.92
gen zero=0 if shiptime<2009.1

lab var ac1 "FT price binding" 
gen time=shiptime
label variable time " "
sort time

twoway area ac1 time, base(-10) bcolor(gs10) || area ac2 time, base(-10) bcolor(gs10) ||area ac3 time,base(-10) bcolor(gs10) ||area ac4 time,base(-10) bcolor(gs10) || ///
line ftpremium effective netpremium zero time, yaxis(1) ytitle("Fair Trade premium (US cents/lb)", axis(1)) ylabel(-10(10)80) lpattern(solid dash shortdash solid) lwidth(medium medium medium vthin)|| ///
line ftshareyear time, yaxis(2)  ytitle("Share of FT in total sales (%)", axis(2))  lpattern(shortdash) lwidth(medium) ///
xmtick(##11) xlabel(1997(1)2009, grid)  legend(order(5 6 7 9 1))  scheme(s2mono) saving("premium", replace)


***************************************************
***********************   welfare        **********
***************************************************

* computing alternative price scenarios
use "sale.dta", replace
sort shipmentyear
merge m:1 shipmentyear using "ftpremiumcoopFE"
rename ftprem_coopFE ftpremium
drop _m
*simpler FLO formula
gen pminflo=max(nyprice, ftfloorp)+ftsocial

gen pwoFT=finalprice-ft*ftpremium
gen pFLOrule=max(pwoFT, pminflo)

sum nyprice pwoFT pFLO finalprice  [w=bagssale], sep(0)

foreach x in nyprice pwoFT pFLO finalprice {
 gen bags`x'=bagssale*`x'
  }

collapse (sum) bags*, by(shipmentyear)
 foreach x in pwoFT pFLO finalprice nyprice {
 gen `x'_avw=bags`x'/bagssale
  }
 list shipmentyear nyprice pwoFT pFLO finalprice, sep(0)
 








