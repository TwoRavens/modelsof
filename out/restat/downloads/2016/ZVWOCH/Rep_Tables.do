
********************************************************************************
* This file replicates results int Tables 1-3 in the main text of Dao, Furceri, Loungani (2016)
* Contact: Mai Dao, mdao@imf.org, August 2016
********************************************************************************
cd //"directory where you put your files"//
use statedat.dta, clear
xtset id year

*take deviation from yearly average to create the variable rimix_i,t as in the paper
egen imix_avg=mean(imix2_i), by(year)
gen rimix=imix2_i-imix_avg

*********TABLE 1**********************
**le equation**********

****OLS first****
xtreg le l.le l2.le l.lp l2.lp relempgr l.relempgr l2.relempgr, fe r
****2SLS*****
xi: ivreg2 le l.le l2.le l.lp l2.lp (relempgr=rimix) l.relempgr l2.relempgr i.id, first r endog(relempgr)

**lp equation****

****OLS first****
xtreg lp l.le l2.le l.lp l2.lp relempgr l.relempgr l2.relempgr, fe r
****2SLS*****
xi: ivreg2 lp l.le l2.le l.lp l2.lp (relempgr=rimix) l.relempgr l2.relempgr i.id, first r endog(relempgr)

******TABLE 2*****************************

****************************TEST FOR OVERID OF THE RFIV model***********************************************************************************************************************************************************
xi: qui sureg (relempgr le lp=imix2_i l.imix2_i l2.imix2_i l.relempgr l2.relempgr l.le l2.le  l.lp l2.lp i.id, r) (dtdmigrate_new l.dtdmigrate_new imix2_i l.imix2_i l2.imix2_i i.year i.id, r) if year>=1990 & year<=2011
*for t=1:
test [relempgr]imix2_i-[le]imix2_i-[lp]imix2_i=[dtdmigrate_new]imix2_i

 
*for t=2:
testnl [relempgr]imix2_i +[relempgr]l.imix2_i + [relempgr]l.relempgr*[relempgr]imix2_i+[relempgr]l.le*[le]imix2_i + [relempgr]l.lp*[lp]imix2_i ///
       - ([le]l.imix2_i+[le]l.relempgr*[relempgr]imix2_i+[le]l.le*[le]imix2_i+[le]l.lp*[lp]imix2_i) ///
	   - ([lp]l.imix2_i+[lp]l.relempgr*[relempgr]imix2_i+[lp]l.le*[le]imix2_i+[lp]l.lp*[lp]imix2_i) ///
	   = [dtdmigrate_new]imix2_i*(1+[dtdmigrate_new]l.dtdmigrate_new) + [dtdmigrate_new]l.imix2_i
	   
*for t=3:
testnl [relempgr]imix2_i +[relempgr]l.imix2_i + [relempgr]l.relempgr*[relempgr]imix2_i+[relempgr]l.le*[le]imix2_i + [relempgr]l.lp*[lp]imix2_i ///
		+ [relempgr]l2.imix2_i+[relempgr]l.relempgr*([relempgr]l.imix2_i + [relempgr]l.relempgr*[relempgr]imix2_i+[relempgr]l.le*[le]imix2_i + [relempgr]l.lp*[lp]imix2_i)+[relempgr]l2.relempgr*[relempgr]imix2_i ///
		+[relempgr]l.le*([le]l.imix2_i+[le]l.relempgr*[relempgr]imix2_i+[le]l.le*[le]imix2_i+[le]l.lp*[lp]imix2_i) +[relempgr]l2.le*[le]imix2_i ///
		+[relempgr]l.lp*([lp]l.imix2_i+[lp]l.relempgr*[relempgr]imix2_i+[lp]l.le*[le]imix2_i+[lp]l.lp*[lp]imix2_i)+[relempgr]l2.lp*[lp]imix2_i ///
		- ([le]l2.imix2_i+[le]l.relempgr*([relempgr]l.imix2_i + [relempgr]l.relempgr*[relempgr]imix2_i+[relempgr]l.le*[le]imix2_i + ///
		[relempgr]l.lp*[lp]imix2_i)+[le]l.relempgr*([relempgr]imix2_i)+[le]l.le*([le]l.imix2_i+[le]l.relempgr*[relempgr]imix2_i+[le]l.le*[le]imix2_i+[le]l.lp*[lp]imix2_i)+[le]l2.le*[le]imix2_i ///
		+[le]l.lp*([lp]l.imix2_i+[lp]l.relempgr*[relempgr]imix2_i+[lp]l.le*[le]imix2_i+[lp]l.lp*[lp]imix2_i)+[le]l2.lp*[lp]imix2_i ) ///
		- ( [lp]l2.imix2_i+[lp]l.relempgr*([relempgr]l.imix2_i+[relempgr]l.relempgr*[relempgr]imix2_i+[relempgr]l.le*[le]imix2_i+[relempgr]l.lp*[lp]imix2_i) ///
		+[lp]l2.relempgr*[relempgr]imix2_i+[lp]l.le*([le]l.imix2_i+[le]l.relempgr*[relempgr]imix2_i+[le]l.le*[le]imix2_i+[le]l.lp*[lp]imix2_i)+[lp]l2.le*[le]imix2_i ///
		+[lp]l.lp*([lp]l.imix2_i+[lp]l.relempgr*[relempgr]imix2_i+[lp]l.le*[le]imix2_i+[lp]l.lp*[lp]imix2_i)+[lp]l2.lp*[lp]imix2_i) ///
		= (1+[dtdmigrate_new]l.dtdmigrate_new+[dtdmigrate_new]l.dtdmigrate_new^2)*[dtdmigrate_new]imix2_i + (1+[dtdmigrate_new]l.dtdmigrate_new)*[dtdmigrate_new]l.imix2_i + [dtdmigrate_new]l2.imix2_i
		
*************************TEST FOR OVERID OF THE OLS model*********************************************************************************************************************************************************

xi: qui sureg (relempgr l.relempgr l2.relempgr l.le l2.le  l.lp l2.lp i.id, cl(id)) (le lp=relempgr l.relempgr l2.relempgr l.le l2.le  l.lp l2.lp i.id, r cl(id)) /// 
(dtdmigrate_new l.dtdmigrate_new relempgr l.relempgr l2.relempgr l.le l2.le l.lp l2.lp i.year i.id, r cl(id)) if year>1990 

*for t=1:
test 1-[le]relempgr-[lp]relempgr=[dtdmigrate_new]relempgr

*for t=2:
testnl 1 + [relempgr]l.relempgr+[relempgr]l.le*[le]relempgr + [relempgr]l.lp*[lp]relempgr ///
       - ([le]relempgr*([relempgr]l.relempgr+[relempgr]l.le*[le]relempgr + [relempgr]l.lp*[lp]relempgr)+[le]l.relempgr+[le]l.le*[le]relempgr+[le]l.lp*[lp]relempgr) ///
	   - ([lp]relempgr*([relempgr]l.relempgr+[relempgr]l.le*[le]relempgr + [relempgr]l.lp*[lp]relempgr)+[lp]l.relempgr+[lp]l.le*[le]relempgr+[lp]l.lp*[lp]relempgr) ///
	   = [dtdmigrate_new]relempgr*(1+[dtdmigrate_new]l.dtdmigrate_new) + [dtdmigrate_new]l.relempgr  +[dtdmigrate_new]relempgr*([relempgr]l.relempgr+[relempgr]l.le*[le]relempgr + [relempgr]l.lp*[lp]relempgr) ///
	   + [dtdmigrate_new]l.le*([le]relempgr) + [dtdmigrate_new]l.lp*[lp]relempgr //add this if have le and lp on RHS of m
	   
	
	   
*for t=3:
testnl 1 + [relempgr]l.relempgr+[relempgr]l.le*[le]relempgr + [relempgr]l.lp*[lp]relempgr ///
         + [relempgr]l.relempgr*([relempgr]l.relempgr+[relempgr]l.le*[le]relempgr + [relempgr]l.lp*[lp]relempgr) + [relempgr]l2.relempgr ///
		 + [relempgr]l.le*([le]l.relempgr+[le]l.le*[le]relempgr+[le]l.lp*[lp]relempgr) + [relempgr]l2.le*[le]relempgr ///
		 + [relempgr]l.lp*([lp]l.relempgr+[lp]l.le*[le]relempgr+[lp]l.lp*[lp]relempgr) + [relempgr]l2.lp*[lp]relempgr ///
		 - ([le]relempgr*([relempgr]l.relempgr*([relempgr]l.relempgr+[relempgr]l.le*[le]relempgr + [relempgr]l.lp*[lp]relempgr) + [relempgr]l2.relempgr ///
		 + [relempgr]l.le*([le]l.relempgr+[le]l.le*[le]relempgr+[le]l.lp*[lp]relempgr) + [relempgr]l2.le*[le]relempgr ///
		 + [relempgr]l.lp*([lp]l.relempgr+[lp]l.le*[le]relempgr+[lp]l.lp*[lp]relempgr) + [relempgr]l2.lp*[lp]relempgr) ///
		 + [le]l.relempgr*([relempgr]l.relempgr+[relempgr]l.le*[le]relempgr + [relempgr]l.lp*[lp]relempgr)+[le]l2.relempgr ///
		 + [le]l.le*([le]relempgr*([relempgr]l.relempgr+[relempgr]l.le*[le]relempgr + [relempgr]l.lp*[lp]relempgr)+[le]l.relempgr+[le]l.le*[le]relempgr+[le]l.lp*[lp]relempgr) ///
		 + [le]l.lp*([lp]relempgr*([relempgr]l.relempgr+[relempgr]l.le*[le]relempgr + [relempgr]l.lp*[lp]relempgr)+[lp]l.relempgr+[lp]l.le*[le]relempgr+[lp]l.lp*[lp]relempgr) ///
		 + [le]l2.le*[le]relempgr + [le]l2.lp*[lp]relempgr) ///
		 - ([lp]relempgr*([relempgr]l.relempgr*([relempgr]l.relempgr+[relempgr]l.le*[le]relempgr + [relempgr]l.lp*[lp]relempgr) + [relempgr]l2.relempgr ///
		 + [relempgr]l.le*([le]l.relempgr+[le]l.le*[le]relempgr+[le]l.lp*[lp]relempgr) + [relempgr]l2.le*[le]relempgr ///
		 + [relempgr]l.lp*([lp]l.relempgr+[lp]l.le*[le]relempgr+[lp]l.lp*[lp]relempgr) + [relempgr]l2.lp*[lp]relempgr) ///
		 + [lp]l.relempgr*([relempgr]l.relempgr+[relempgr]l.le*[le]relempgr + [relempgr]l.lp*[lp]relempgr) +[lp]l2.relempgr ///
		 + [lp]l.le*([le]relempgr*([relempgr]l.relempgr+[relempgr]l.le*[le]relempgr + [relempgr]l.lp*[lp]relempgr)+[le]l.relempgr+[le]l.le*[le]relempgr+[le]l.lp*[lp]relempgr) ///
		 + [lp]l.lp*([lp]relempgr*([relempgr]l.relempgr+[relempgr]l.le*[le]relempgr + [relempgr]l.lp*[lp]relempgr)+[lp]l.relempgr+[lp]l.le*[le]relempgr+[lp]l.lp*[lp]relempgr) ///
		 + [lp]l2.le*[le]relempgr + [lp]l2.lp*[lp]relempgr) ///
		 = (1+[dtdmigrate_new]l.dtdmigrate_new+[dtdmigrate_new]l.dtdmigrate_new^2)*[dtdmigrate_new]relempgr ///
		 + ([dtdmigrate_new]relempgr+[dtdmigrate_new]l.dtdmigrate_new*[dtdmigrate_new]relempgr+[dtdmigrate_new]l.relempgr)*([relempgr]l.relempgr+[relempgr]l.le*[le]relempgr + [relempgr]l.lp*[lp]relempgr) ///
		 + [dtdmigrate_new]relempgr*([relempgr]l.relempgr*([relempgr]l.relempgr+[relempgr]l.le*[le]relempgr + [relempgr]l.lp*[lp]relempgr) + [relempgr]l2.relempgr ///
		 + [relempgr]l.le*([le]l.relempgr+[le]l.le*[le]relempgr+[le]l.lp*[lp]relempgr) + [relempgr]l2.le*[le]relempgr ///
		 + [relempgr]l.lp*([lp]l.relempgr+[lp]l.le*[le]relempgr+[lp]l.lp*[lp]relempgr) + [relempgr]l2.lp*[lp]relempgr) ///
		 + (1+[dtdmigrate_new]l.dtdmigrate_new)*[dtdmigrate_new]l.relempgr + [dtdmigrate_new]l2.relempgr /// until here only if no le lp on RHS of m
		 +([dtdmigrate_new]l.dtdmigrate_new*[dtdmigrate_new]l.le+[dtdmigrate_new]l.le+[dtdmigrate_new]l2.le)*[le]relempgr + ([dtdmigrate_new]l.dtdmigrate_new*[dtdmigrate_new]l.lp+[dtdmigrate_new]l.lp+[dtdmigrate_new]l2.lp)*[lp]relempgr ///
		 + [dtdmigrate_new]l.le*[le]l.relempgr + [dtdmigrate_new]l.lp*[lp]l.relempgr
     
*********TABLE 3************************
use statedat.dta, clear
set matsize 1000
xtset id year

egen imix_avg=mean(imix2_i), by(year)
gen imix_rel=imix2_i-imix_avg

gen rec=(d2>0 & d2!= .)
replace rec=1 if year==2007
gen exp=(rec==0)

*column 1:
xi: xtreg dtdmigrate_new l.dtdmigrate_new imix_rel l.imix_rel i.year [weight=avgpop] , fe cl(id)

*column 2/Chow test****
*need to do the steps below to have the right RHS variable in each regime
xi: qui xtreg dtdmigrate_new i.year if year>=2007 & year<=2009 [weight=avgpop], cluster(id) fe
predict migrate_til_a if e(sample), e
gen imix_l=l.imix_rel
xi: qui xtreg imix_l  i.year if year>=2007 & year<=2009 & dtdmigrate_new!=. [weight=avgpop], cluster(id) fe //to match the exact sample of the migrate_til variable
predict imix_til_a if e(sample), e
xi: qui xtreg dtdmigrate_new i.year if (year<2007 | year>2009) [weight=avgpop], cluster(id) fe
predict migrate_til_b if e(sample), e
xi: qui xtreg imix_l i.year if (year<2007 | year>2009) & dtdmigrate_new!=. [weight=avgpop], cluster(id) fe //to match the exact sample of the migrate_til variable
predict imix_til_b if e(sample), e

gen migrate_til=migrate_til_a if year>=2007 & year<=2009
replace migrate_til=migrate_til_b if (year<2007 | year>2009)
gen imix_til=imix_til_a if year>=2007 & year<=2009
replace imix_til=imix_til_b if (year<2007 | year>2009)
gen imix_til_rec=imix_til*rec
gen imix_til_exp=imix_til*exp
reg migrate_til l.migrate_til imix_til_exp imix_til_rec [aweight=avgpop], cl(id) nocons
test imix_til_exp=imix_til_rec

*column 3/without LDV****
capture drop imix_til*
capture drop migrate_til*
capture drop imix_l

xi: qui xtreg dtdmigrate_new i.year if year>=2007 & year<=2009 [weight=avgpop], cluster(id) fe
predict migrate_til1 if e(sample), e
gen imix_l=l.imix_rel
xi: qui xtreg imix_l i.year if year>=2007 & year<=2009 & dtdmigrate_new!=. [weight=avgpop], cluster(id) fe //to match the exact sample of the migrate_til variable
predict imix_til1 if e(sample), e
xi: qui xtreg dtdmigrate_new i.year if (year<2007 | year>2009) [weight=avgpop], cluster(id) fe
predict migrate_til2 if e(sample), e
xi: qui xtreg imix_l i.year if (year<2007 | year>2009) & dtdmigrate_new!=. [weight=avgpop], cluster(id) fe //to match the exact sample of the migrate_til variable
predict imix_til2 if e(sample), e

gen migrate_til=migrate_til1 if year>=2007 & year<=2009
replace migrate_til=migrate_til2 if (year<2007 | year>2009)
gen imix_til=imix_til1 if year>=2007 & year<=2009
replace imix_til=imix_til2 if (year<2007 | year>2009)
gen imix_til_rec=imix_til*rec
gen imix_til_exp=imix_til*exp
reg migrate_til imix_til_exp imix_til_rec rec [aweight=avgpop], cl(id) nocons
test imix_til_exp=imix_til_rec

*column 4/using MSA data:

use msa, clear
egen imix_avg=mean(imix), by(year)
gen imix_rel=imix-imix_avg

xi: xtreg migrate  l.imix_rel i.year [weight=pop_2005], cluster(area_id) fe
*Column 5/using MSA data but excluding 2006***
 xi: xtreg migrate  l.imix_rel i.year  [weight=pop_2005] if year!=2006 , cluster(area_id) fe
*Column 6/business cycle interactions:

gen imix_l=l.imix_rel
xi: qui reg migrate i.area_id i.year [weight=pop_2005] if  year>=2007 & year<=2009, cluster(area_id) //fe
predict migrate_til1 if e(sample), r
xi: qui reg imix_l i.area_id i.year [weight=pop_2005] if  year>=2007 & year<=2009 & migrate!=., cluster(area_id)  //to match the exact sample of the migrate_til variable
predict imix_til1 if e(sample), r
drop if year==2006	 
xi: qui reg migrate i.area_id i.year [weight=pop_2005] if (year<2007 | year>2009), cluster(area_id) //fe
predict migrate_til2 if e(sample), r 
xi: qui reg imix_l i.area_id i.year [weight=pop_2005] if (year<2007 | year>2009) & migrate!=., cluster(area_id)  //to match the exact sample of the migrate_til variable
predict imix_til2 if e(sample), r

gen gr=(year>=2007 & year<=2009)
gen ngr=(year<2007 | year>2009)
gen migrate_til=migrate_til1 if year>=2007 & year<=2009
replace migrate_til=migrate_til2 if (year<2007 | year>2009)
gen imix_til=imix_til1 if year>=2007 & year<=2009
replace imix_til=imix_til2 if (year<2007 | year>2009)
gen imix_til_gr=imix_til*gr
gen imix_til_ngr=imix_til*ngr


reg migrate_til imix_til_ngr imix_til_gr gr [weight=pop_2005], nocons cl(area_id)
test imix_til_ngr=imix_til_gr
   
 
