
******************************************************************************
******************************************************************************

** National Elections and the Dynamics of International Negotiations - 2016 **

******************************************************************************
******************************************************************************


clear 
use "The Timeline of Elections - A Comparative Perspective.dta" 
save "polldata.dta", replace

*************************
**1. Clean poll dataset**
*************************

order countryid ipoll_, after(polldate)
drop election-_50_ipoll
drop if polldate<date("01-01-1976","DMY") | polldate>date("30-06-2009","DMY")

**1.1 Keep only EU countries**

/* Countries kept:
Austria, Bulgaria, Croatia, Cyprus, Czech Republic, Finland, France, Germany, Greece, Ireland, Italy, Malta, Netherlands, Poland, Portugal
Romania, Slovakia, Slovenia, Sweden, United Kingdom, Belgium, Denmark, Hungary
*/

keep if countryid==3|countryid==5|countryid==10|countryid==11|countryid==13|countryid==14|countryid==15|countryid==16 ///
|countryid==18|countryid==19|countryid==21|countryid==23|countryid==28|countryid==29|countryid==30|countryid==32|countryid==33|countryid==35 ///
|countryid==36|countryid==39|countryid==42|countryid==43|countryid==45

**1.2 Keep only top two parties based on poll results for each poll day for each country**

gsort polldate countryid -ipoll_
bysort polldate countryid: gen seq=_n
order seq, after(ipoll_)
keep if (seq==1|seq==2)

**1.3 Calculate difference in vote intention between top two parties for each poll day for each country**

gen diff=.
order diff, after(seq)
bysort polldate countryid: replace diff=ipoll_[_n]-ipoll_[_n+1]

**1.4 Calculate difference in vote intention for each poll day per country**

sort countryid polldate

levelsof countryid, local(levels)
foreach x of local levels {
	gen diff_`x' = .
	replace diff_`x' = diff if countryid==`x'
}
//

sort polldate countryid

levelsof countryid, local(levels)
foreach x of local levels {
	bys polldate: egen adiff_`x'=sum(diff_`x')
}
//

drop diff_3-diff_45

**1.5 Calculate average difference in vote intention for each poll day across countries**

bysort polldate: egen avdiff=mean(diff)

**1.5 Calculate index of closeness for each poll day across countries**

levelsof countryid, local(levels)
foreach x of local levels {
	gen closel_`x'=1-(adiff_`x'/100)
}
//

gen closel=1-(avdiff/100)
drop adiff_3-avdiff

**1.5 Keep one observation by poll date**

bysort polldate: keep if _n==1
drop countryid-diff
rename polldate date

**1.5 Recode missing values as zeroes**

replace closel_3=. if closel_3==1

foreach x of varlist closel_3-closel {
	replace `x'=. if `x'==1
}
//

rename closel_3 closeau
rename closel_5 closebu
rename closel_10 closecy
rename closel_11 closecz
rename closel_13 closefn
rename closel_14 closefr
rename closel_15 closede
rename closel_16 closegr
rename closel_18 closeie
rename closel_19 closeit
rename closel_21 closema
rename closel_23 closend
rename closel_28 closepl
rename closel_29 closept
rename closel_30 closero
rename closel_32 closesk
rename closel_33 closesv
rename closel_35 closesp
rename closel_36 closesw
rename closel_39 closeuk
rename closel_42 closebe
rename closel_43 closedk
rename closel_45 closehu

save "polldata.dta", replace

***************************************************
**2. Prepare EULO dataset for continuous variable**
***************************************************

use "eup-10-0520-File005.dta"
save "EULO_NATEL_cont.dta", replace
use "EULO_NATEL_cont.dta"

drop ec9 ec10 ec12 ec15 ec25 ec27 postsea postteu postams postnice qmvbeforesea qmvpostsea qmvpostteu qmvpostams qmvpostnice

drop if adt_bcommission_1<date("01-07-1976","DMY")
sort adt_bcommission_1

**2.1 Identify Data as Survival Data**
stset dexit, failure(event) id(case_id) enter(adt_bcommission_1)

stsplit day, every(1)
sort dexit
gen date=dexit
save "EULO_NATEL_cont.dta", replace

**2.2 Merge with poll dataset**

merge m:1 date using "polldata.dta"
sort date
drop _merge
drop if case_id==.

save "EULO_NATEL_cont.dta", replace
erase "polldata.dta"

***********************************
**Generate year and month dummies**
***********************************

**Rescale backlog variable**
generate backlog100=backlog/100


**Generate year dummy variables**
forvalues x = 1999/2009 {
	gen y`x' = 0
	replace y`x' = 1 if adt_bcommission_1 >= d(01.01.`x') & adt_bcommission_1 <= d(31.12.`x')
}
//

**Generate August dummy**

generate Aug2=0
replace Aug2=1 if month(dexit)==8

*****************************
**Generate election dummies**
*****************************


*************
*1. Germany *
*************

generate deprel=0

local z=date("19 Sep 1965", "DMY")
replace deprel=1 if (date<=`z' & date>`z'-60)
local z=date("28 Sep 1969", "DMY")
replace deprel=1 if (date<=`z' & date>`z'-60)
local z=date("19 Nov 1972", "DMY")
replace deprel=1 if (date<=`z' & date>`z'-60)
local z=date("3 Oct 1976", "DMY")
replace deprel=1 if (date<=`z' & date>`z'-60)
local z=date("5 Oct 1980", "DMY")
replace deprel=1 if (date<=`z' & date>`z'-60)
local z=date("6 Mar 1983", "DMY")
replace deprel=1 if (date<=`z' & date>`z'-60)
local z=date("25 Jan 1987", "DMY")
replace deprel=1 if (date<=`z' & date>`z'-60)
local z=date("2 Dec 1990", "DMY")
replace deprel=1 if (date<=`z' & date>`z'-60)
local z=date("16 Oct 1994", "DMY")
replace deprel=1 if (date<=`z' & date>`z'-60)
local z=date("27 Sep 1998", "DMY")
replace deprel=1 if (date<=`z' & date>`z'-60)
local z=date("22 Sep 2002", "DMY")
replace deprel=1 if (date<=`z' & date>`z'-60)
local z=date("18 sept 2005", "DMY")
replace deprel=1 if (date<=`z' & date>`z'-60)
local z=date("27 Sep 2009", "DMY")
replace deprel=1 if (date<=`z' & date>`z'-60)

*************
* 2. France *
*************

*Presidential*

generate frprel=0

local z=date("19 Dec 1965", "DMY")
replace frprel=1 if (date<=`z' & date>`z'-60)
local z=date("15 Jun 1969", "DMY")
replace frprel=1 if (date<=`z' & date>`z'-60)
local z=date("19 May 1974", "DMY")
replace frprel=1 if (date<=`z' & date>`z'-60)
local z=date("10 May 1981", "DMY")
replace frprel=1 if (date<=`z' & date>`z'-60)
local z=date("8 May 1988", "DMY")
replace frprel=1 if (date<=`z' & date>`z'-60)
local z=date("7 May 1995", "DMY")
replace frprel=1 if (date<=`z' & date>`z'-60)
local z=date("5 May 2002", "DMY")
replace frprel=1 if (date<=`z' & date>`z'-60)
local z=date("6 May 2007", "DMY")
replace frprel=1 if (date<=`z' & date>`z'-60)

*********
* 3. UK *
*********

generate ukprel=0

local z=date("28 Feb 1974", "DMY")
replace ukprel=1 if (date<=`z' & date>`z'-60)
local z=date("10 Oct 1974", "DMY")
replace ukprel=1 if (date<=`z' & date>`z'-60)
local z=date("3 May 1979", "DMY")
replace ukprel=1 if (date<=`z' & date>`z'-60)
local z=date("9 Jun 1983", "DMY")
replace ukprel=1 if (date<=`z' & date>`z'-60)
local z=date("11 Jun 1987", "DMY")
replace ukprel=1 if (date<=`z' & date>`z'-60)
local z=date("9 Apr 1992", "DMY")
replace ukprel=1 if (date<=`z' & date>`z'-60)
local z=date("1 May 1997", "DMY")
replace ukprel=1 if (date<=`z' & date>`z'-60)
local z=date("7 Jun 2001", "DMY")
replace ukprel=1 if (date<=`z' & date>`z'-60)
local z=date("5 may 2005", "DMY")
replace ukprel=1 if (date<=`z' & date>`z'-60)


************
* 5. Spain *
************

generate spprel=0

local z=date("22 Jun 1986", "DMY")
replace spprel=1 if (date<=`z' & date>`z'-60)
local z=date("29 Oct 1989", "DMY")
replace spprel=1 if (date<=`z' & date>`z'-60)
//local z=date("06 Jun 1993", "DMY")
local z=date("03 Mar 1996", "DMY")
replace spprel=1 if (date<=`z' & date>`z'-60)
local z=date("12 Mar 2000", "DMY")
replace spprel=1 if (date<=`z' & date>`z'-60)
local z=date("14 Mar 2004", "DMY")
replace spprel=1 if (date<=`z' & date>`z'-60)
local z=date("09 Mar 2008", "DMY")
replace spprel=1 if (date<=`z' & date>`z'-60)


******************
* 6. Netherlands *
******************

generate ndprel=0

local z=date("15 Feb 1967", "DMY")
replace ndprel=1 if (date<=`z' & date>`z'-60)
local z=date("28 Mar 1971", "DMY")
replace ndprel=1 if (date<=`z' & date>`z'-60)
local z=date("29 Nov 1972", "DMY")
replace ndprel=1 if (date<=`z' & date>`z'-60)
local z=date("25 May 1977", "DMY")
replace ndprel=1 if (date<=`z' & date>`z'-60)
local z=date("26 May 1981", "DMY")
replace ndprel=1 if (date<=`z' & date>`z'-60)
local z=date("08 Sep 1982", "DMY")
replace ndprel=1 if (date<=`z' & date>`z'-60)
local z=date("21 May 1986", "DMY")
replace ndprel=1 if (date<=`z' & date>`z'-60)
local z=date("06 Sep 1989", "DMY")
replace ndprel=1 if (date<=`z' & date>`z'-60)
local z=date("03 May 1994", "DMY")
replace ndprel=1 if (date<=`z' & date>`z'-60)
local z=date("06 May 1998", "DMY")
replace ndprel=1 if (date<=`z' & date>`z'-60)
local z=date("15 May 2002", "DMY")
replace ndprel=1 if (date<=`z' & date>`z'-60)
//local z=date("22 Jan 2003", "DMY")
//local z=date("22 Nov 2006", "DMY")

**************
* 7. Belgium *
**************

generate beprel=0

local z=date("10 Jun 2007", "DMY")
replace beprel=1 if (date<=`z' & date>`z'-60)


*************
* 8. Greece *
*************

generate grprel=0

local z=date("16 Sep 2007", "DMY")
replace grprel=1 if (date<=`z' & date>`z'-60)


***************
* 9. Portugal *
***************

generate ptprel=0

local z=date("19 Jul 1987", "DMY")
replace ptprel=1 if (date<=`z' & date>`z'-60)
local z=date("06 Oct 1991", "DMY")
replace ptprel=1 if (date<=`z' & date>`z'-60)
local z=date("01 Oct 1995", "DMY")
replace ptprel=1 if (date<=`z' & date>`z'-60)
local z=date("01 Oct 1999", "DMY")
replace ptprel=1 if (date<=`z' & date>`z'-60)
local z=date("17 Mar 2002", "DMY")
replace ptprel=1 if (date<=`z' & date>`z'-60)
local z=date("20 Feb 2005", "DMY")
replace ptprel=1 if (date<=`z' & date>`z'-60)
local z=date("27 Sep 2009", "DMY")
replace ptprel=1 if (date<=`z' & date>`z'-60)


**************
* 10. Sweden *
**************

generate swprel=0

//local z=date("20 Sep 1998", "DMY")
local z=date("15 Sep 2002", "DMY")
replace swprel=1 if (date<=`z' & date>`z'-60)
local z=date("17 Sep 2006", "DMY")
replace swprel=1 if (date<=`z' & date>`z'-60)


***************
* 11. Austria *
***************

generate auprel=0

//local z=date("17 Dec 1995", "DMY")
//local z=date("03 Oct 1999", "DMY")
//local z=date("24 Nov 2002", "DMY")
local z=date("01 Oct 2006", "DMY")
replace auprel=1 if (date<=`z' & date>`z'-60)
local z=date("28 Sep 2008", "DMY")
replace auprel=1 if (date<=`z' & date>`z'-60)


***************
* 12. Denmark *
***************

generate dkprel=0

local z=date("04 Dec 1973", "DMY")
replace dkprel=1 if (date<=`z' & date>`z'-60)
local z=date("09 Jan 1975", "DMY")
replace dkprel=1 if (date<=`z' & date>`z'-60)
local z=date("15 Feb 1977", "DMY")
replace dkprel=1 if (date<=`z' & date>`z'-60)
local z=date("23 Oct 1979", "DMY")
replace dkprel=1 if (date<=`z' & date>`z'-60)
local z=date("08 Dec 1981", "DMY")
replace dkprel=1 if (date<=`z' & date>`z'-60)
local z=date("10 Jan 1984", "DMY")
replace dkprel=1 if (date<=`z' & date>`z'-60)
local z=date("08 Sep 1987", "DMY")
replace dkprel=1 if (date<=`z' & date>`z'-60)
local z=date("10 May 1988", "DMY")
replace dkprel=1 if (date<=`z' & date>`z'-60)
local z=date("12 Dec 1990", "DMY")
replace dkprel=1 if (date<=`z' & date>`z'-60)

//local z=date("21 Sep 1994", "DMY")
//local z=date("11 Mar 1998", "DMY")
//local z=date("20 Nov 2001", "DMY")
//local z=date("08 Feb 2005", "DMY")
//local z=date("13 Nov 2007", "DMY")

***************
* 14. Ireland *
***************

gen ieprel=0

local z=date("28 Feb 1973", "DMY")
replace ieprel=1 if (date<=`z' & date>`z'-60)
local z=date("16 Jun 1977", "DMY")
replace ieprel=1 if (date<=`z' & date>`z'-60)
local z=date("11 Jun 1981", "DMY")
replace ieprel=1 if (date<=`z' & date>`z'-60)
local z=date("18 Feb 1982", "DMY")
replace ieprel=1 if (date<=`z' & date>`z'-60)
local z=date("24 Nov 1982", "DMY")
replace ieprel=1 if (date<=`z' & date>`z'-60)
local z=date("17 Feb 1987", "DMY")
replace ieprel=1 if (date<=`z' & date>`z'-60)
local z=date("15 Jun 1989", "DMY")
replace ieprel=1 if (date<=`z' & date>`z'-60)
local z=date("25 Nov 1992", "DMY")
replace ieprel=1 if (date<=`z' & date>`z'-60)
local z=date("06 Jun 1997", "DMY")
replace ieprel=1 if (date<=`z' & date>`z'-60)
local z=date("17 May 2002", "DMY")
replace ieprel=1 if (date<=`z' & date>`z'-60)
local z=date("24 May 2007", "DMY")
replace ieprel=1 if (date<=`z' & date>`z'-60)


**************
* 24. Cyprus *
**************

gen cyprel=0

local z=date("17 Feb 2008", "DMY")
replace cyprel=1 if (date<=`z' & date>`z'-60)


***************
* 26. Romania *
***************

gen roprel=0

local z=date("30 Nov 2008", "DMY")
replace roprel=1 if (date<=`z' & date>`z'-60)


****************
* 27. Bulgaria *
****************

gen buprel=0

local z=date("5 Jul 2009", "DMY")
replace buprel=1 if (date<=`z' & date>`z'-60)


**************************************************
**Generate interaction 60 days x closeness index**
**************************************************

gen deprecel=. 
gen frprecel=. 
gen ukprecel=. 
gen spprecel=. 
gen ndprecel=. 
gen beprecel=. 
gen grprecel=. 
gen ptprecel=. 
gen swprecel=. 
gen auprecel=. 
gen dkprecel=. 
gen ieprecel=. 
gen cyprecel=. 
gen roprecel=. 
gen buprecel=.

replace deprecel=deprel*closede if deprel>0
replace	frprecel=frprel*closefr if frprel>0	
replace	ukprecel=ukprel*closeuk if ukprel>0	
replace	spprecel=spprel*closesp if spprel>0
replace	ndprecel=ndprel*closend if ndprel>0
replace	beprecel=beprel*closebe	if beprel>0
replace grprecel=grprel*closegr if grprel>0
replace	ptprecel=ptprel*closept if ptprel>0
replace	swprecel=swprel*closesw if swprel>0
replace auprecel=auprel*closeau	if auprel>0 
replace	dkprecel=dkprel*closedk if dkprel>0
replace	ieprecel=ieprel*closeie if ieprel>0
replace	cyprecel=cyprel*closecy if cyprel>0
replace roprecel=roprel*closero if roprel>0
//replace	buprecel=buprel*closebu	if buprel>0

//No poll data in time period: closecz	closefn	closeit	closema	closepl	closesk	closesv	closehu
drop closecz closefn closeit closema closepl closesk closesv closehu closebu

egen prelclose=rowmean(deprecel frprecel ukprecel spprecel ndprecel beprecel grprecel ptprecel swprecel auprecel dkprecel ieprecel cyprecel ///
roprecel)

replace prelclose=0 if prelclose==.

save "EULO_NATEL_cont.dta", replace


************************************
** Prepare dataset for regression **
************************************

**Reset timing**
stset _t, origin(_t0) failure(_d) id(case_id)
save "EULO_NATEL_cont.dta", replace



