*****************************************************************************
*** Deter_data.do
***
*****************************************************************************


****************************************************************************************************************************************
****************************************************************************************************************************************
*******************************															 	********************************************
*******************************	     			LEVEL OF UNIT SALES 						********************************************
*******************************															 	********************************************
*******************************															 	********************************************
****************************************************************************************************************************************
****************************************************************************************************************************************

*** Requires data files deter2001-deter2005, located in folder Original_data ***

clear
capture log close
set more off

forvalues i=1/5 {
		 use Original_data\deter200`i', clear
		 ** From Do file Number 2 titled "Store Yearly Analysis"				    
		 gen str18 upc = string(sy,"%02.0f") + "-" + string(ge,"%02.0f") + "-" + string(vend,"%05.0f") + "-" + string(item,"%05.0f")
		 sort upc
		 gen double COLUPC=((system*100 + gener)* 100000 +vendor)*100000 + item
		 format COLUPC %30.0g
		 save Data\deter200`i'_Regression_stores_dups, replace 
		 do prod_laundet
		 merge upc using Data\deter200`i'_Regression_stores_dups, uniqmaster sort
		 drop _merge 

		gen price = dollars/units
		replace price=round(price,.01)
		gen pperoz = price/size

		sort iri week prodcode size
		label variable dollars "total dollar sales"
		label variable units "total unit sales"
		label variable iri_key "masked store number"
		label variable vendor "parent company/manufacturer's code"
		drop if price == .
		drop if iri==.
		drop if size==.
		drop if brand=="" 
		replace size=round(size,1)

		drop upc product1 system gener vendor item 
		compress

		gen double uniquepackid=iri_key * 10000000 + prodcode * 1000 + size
		format uniquepackid %30.0g
		* isid uniquepackid week
		replace uniquepackid=round(uniquepackid, 0.01)
		sort uniquepackid week
		egen orderofdups=seq(), by(uniquepackid week)
		gen double uniqueseq=uniquepackid*10+orderofdups
		format uniqueseq %30.0g
		sort uniqueseq week
		isid uniqueseq week

		sort iri_key prodcode week size
		duplicates tag uniquepackid week, gen (numobs) /* same results if we add package. Some mild differences if we add feature and display */
		label var numobs "Surplus of entries by uniquepackid-week"
		tab numobs
		sort uniquepackid week


		***  Get All the upcs for the duplicated entries (to be used in the consumer survey analysis). uniquepackid is a large  *** 
		***  number and cannot be easily multiplied. So, we just add the trend at the end. By declaring orderofdups to be the time ***
		****  variable we can get the upc of the duplicated entries as follows: ****

		egen first_week=min(week)
		gen trend=week-first_week +1
		* egen trend1=group(week)
		gen double PackWeek=uniquepackid*100+trend
		drop trend
		format PackWeek %30.0g
		xtset PackWeek orderofdups


**************************************************************************************************
********************										 *************************************
********************		 Duplicated Entries Analysis	 ***********************************
********************										 *************************************
**************************************************************************************************


		sort uniquepackid week orderofdups
		xtset PackWeek orderofdups

		egen ratio_pperoz1= max(pperoz) if numobs==1 , by (uniquepackid week)
		replace ratio_pperoz1=pperoz/ratio_pperoz1 if numobs==1 
		egen min_ratio_pperoz1= min(ratio_pperoz1) if numobs==1 , by (uniquepackid week)
		drop if min_ratio_pperoz1<0.95
		drop ratio_pperoz min_ratio_pperoz1
		
		egen ratio_pperoz2= max(pperoz) if numobs==2 , by (uniquepackid week)
		replace ratio_pperoz2=pperoz/ratio_pperoz2 if numobs==2 
		egen min_ratio_pperoz2= min(ratio_pperoz2) if numobs==2 , by (uniquepackid week)
		drop if min_ratio_pperoz2<0.95
		drop ratio_pperoz min_ratio_pperoz2
		
		egen ratio_pperoz3= max(pperoz) if numobs==3 , by (uniquepackid week)
		replace ratio_pperoz3=pperoz/ratio_pperoz3 if numobs==3 
		egen min_ratio_pperoz3= min(ratio_pperoz3) if numobs==3 , by (uniquepackid week)
		drop if min_ratio_pperoz3<0.95
		drop ratio_pperoz min_ratio_pperoz3
		
		egen ratio_pperoz4= max(pperoz) if numobs==4 , by (uniquepackid week)
		replace ratio_pperoz4=pperoz/ratio_pperoz4 if numobs==4 
		egen min_ratio_pperoz4= min(ratio_pperoz4) if numobs==4 , by (uniquepackid week)
		drop if min_ratio_pperoz4<0.95
		drop ratio_pperoz min_ratio_pperoz4


**************************************************************************************************
*****************************              Feature analysis 			**************************
**************************************************************************************************

		encode feature, g(numfeature)
		label define numfeature 1 "large ad" 2 "ad plus retailer coupon or rebate" 3 "medium sized ad" 4 "small ad" 5 "None", modify


**************************************************************************************************
********************										 *************************************
********************		DEAL WITH DUPLICATED ENTRIES	  ************************************
********************										 *************************************
**************************************************************************************************

		sort uniquepackid week
		egen totsales=total(units), by (uniquepackid week)

********************										 *************************************
********************	 Generate WEIGHTED AVERAGE PRICE 	 *************************************
********************										 *************************************
		gen propsales=units/totsales
		gen prop_pperoz=pperoz*propsales
		egen weightpperoz=total(prop_pperoz), by (uniquepackid week)
		label variable weightpperoz "weighted average price per oz"
		gen weightprice=weightpperoz*size
		label var weightprice "weighted average price per unit"
		*codebook weightprice weightpperoz

*** KEEP ONLY NON-DUPLICATED DATA
		drop if orderofdups>1
		egen sizeid = seq(), by(iri_key prodcode week)
		isid uniquepackid week /* clear */
		xtset uniquepackid week
		sort uniquepackid week
		replace weightprice=round(weightprice,.01)
		save Data\deter200`i'_Regression_stores_nodups, replace
		capture drop gener 
		capture drop item 
		capture drop display 
		capture drop system 
		capture drop vendor 
		compress 
		sort iri_key prodcode COLUPC week 
		save Data\200`i'PackLev_Regression_Stores,replace


		egen NumSizes=count(size), by (iri week prodcode)
		label var NumSizes "Number of sizes of a product in a given store-week"

		save Data\200`i'PackLev_Regression_Stores, replace
}
*

forvalues i=1/5 {
		use Data\200`i'PackLev_Regression_Stores, clear
		drop package brand DetFabSoft packagecode sdpackagecode* feature pricered COLUPC orderofdups uniqueseq numobs first_week numfeature sizeid weightprice
		compress
		save Data\200`i'PackLev_Regression_Stores-Compressed, replace
}
*

******************************************************************************************************************************
******************************************************************************************************************************
******************************************************************************************************************************
clear

use Data\2001PackLev_Regression_Stores-Compressed, clear
append using Data\2002PackLev_Regression_Stores-Compressed
append using Data\2003PackLev_Regression_Stores-Compressed
append using Data\2004PackLev_Regression_Stores-Compressed
append using Data\2005PackLev_Regression_Stores-Compressed

compress

drop PackWeek propsales prop_pperoz NumSizes



******************************************************************************************************************************
******************************************************************************************************************************

****************************************			Report 						**********************************************

******************************************************************************************************************************
******************************************************************************************************************************


sort uniquepackid week
xtset uniquepackid week

*gen double PackID=1000*prodcode+size
*label var PackID "product_code +size"
*format PackID %12.0g
*isid iri PackID week 

gen double ProdChainID=iri*10000+prodcode
label var ProdChainID "iri+prodcode_code"
format ProdChainID %200.0f
isid ProdChainID size week
capture gen double uniquepackid=iri_key * 10000000 + prodcode * 1000 + size
format uniquepackid %30.0g
isid uniquepackid week
label var uniquepackid "iri+product code+ size"

sort uniquepackid week
*egen WeeksAvail=count(week), by(uniquepackid)
compress
*egen PackSeq=seq(), by(uniquepackid)
*xtset uniquepackid PackSeq
*gen WeekDiff=week-L.week

******************************************************************************************************************************
save Data\2001-2005PackLev_Regression_Stores-Compressed, replace

forvalues i=1/5 {
	erase Data\200`i'PackLev_Regression_Stores-Compressed.dta
	erase Data\200`i'PackLev_Regression_Stores.dta
	erase Data\deter200`i'_Regression_stores_dups.dta
	erase Data\deter200`i'_Regression_stores_nodups.dta
	}
	
******************************************************************************************************************************

set more off
******************************************************************************************************************************
use Data\2001-2005PackLev_Regression_Stores-Compressed, clear
******************************************************************************************************************************

keep iri_key
duplicates drop iri_key, force
sort iri_key
gen iri_short=_n


merge 1:m iri_key using Data\2001-2005PackLev_Regression_Stores-Compressed

drop _merge
drop dollars price


egen ProdTotSales=total(totsales), by (ProdChainID )
gen ProdMeanWeekSales=ProdTotSales/260
egen prodseq=seq(), by(ProdChainID )

count
sum ProdTotSales ProdMeanWeekSales if prodseq ==1, d
sum ProdTotSales ProdMeanWeekSales if prodseq ==1 & ProdMeanWeekSales>=10, d

keep if ProdMeanWeekSales>=10

egen NumWeeksAvail=count(week), by(uniquepackid)
egen MinNumWeeksAvail=min(NumWeeksAvail), by(ProdChainID)

*keep if MinNumWeeksAvail >=100

drop ProdMeanWeekSales ProdTotSales prodseq NumWeeksAvail MinNumWeeksAvail

compress

xtset uniquepackid week
tsfill

replace iri_key=L.iri_key if totsales==.
replace iri_short=L.iri_short if totsales==.
replace size=L.size if totsales==.
replace ProdChainID=L.ProdChainID if totsales==.
replace prodcode=L.prodcode if totsales==.

******************************************************************************************************************************
save Data\2001-2005PackLev_Regression_Stores-Compressed-2, replace
******************************************************************************************************************************

capture drop NumSizes
egen NumSizes=count(size), by (iri_key week prodcode)
label var NumSizes "Number of sizes of a product in a given store-week"

capture drop InvSizeRank
egen InvSizeRank=rank(size), by (iri_key week prodcode) track

sort uniquepackid week
xtset uniquepackid week


****** Missing weeks and Weeks with 0 sales ******
gen MissingWeek=(L2.totsales==. & L1.totsales==.  & totsales==.)
replace MissingWeek=1 if (F2.totsales==. & F1.totsales==.  & totsales==.)
replace MissingWeek=1 if L.MissingWeek ==1 & F.MissingWeek ==1 & totsales==. & L.totsales==. & F.totsales
label variable MissingWeek "Missing Week"
label define MissingWeek 0 "No" 1 "Yes"
label values MissingWeek MissingWeek

replace totsales=0 if totsales==. & MissingWeek==0
gen ZeroSalesWeek=totsales==0
label variable ZeroSalesWeek "0 unit sales"
label define ZeroSalesWeek 0 "No" 1 "Yes"
label values ZeroSalesWeek ZeroSalesWeek



** Filling price per oz
* 1 week with 0 sales *
replace weightpperoz=L.weightpperoz if L.weightpperoz ==F.weightpperoz & weightpperoz ==. & totsales==0

* 2 weeks with 0 sales *

replace weightpperoz=L.weightpperoz if L.weightpperoz ==F2.weightpperoz & weightpperoz ==. & F.totsales ==0 & totsales==0
replace weightpperoz=F.weightpperoz if L2.weightpperoz ==F.weightpperoz & weightpperoz ==. & L.totsales ==0 & totsales==0
************************************************************************************

*** Redefining pack prom
capture drop ppoz1* ppoz2* ppoz3*  ppoz_rmed PackProm

gen ppoz1l=l.weightpperoz if weightpperoz!=.
gen ppoz2l=l2.weightpperoz if weightpperoz!=.
gen ppoz3l=l3.weightpperoz if weightpperoz!=.
gen ppoz1f=f.weightpperoz if weightpperoz!=.
gen ppoz2f=f2.weightpperoz if weightpperoz!=.
gen ppoz3f=f3.weightpperoz if weightpperoz!=.

egen ppoz_rmed=rowmedian(ppoz1l ppoz2l ppoz3l weightpperoz ppoz1f ppoz2f ppoz3f) if ppoz3l !=. & ppoz2l !=. & ppoz1l !=. & weightpperoz !=. & ppoz1f !=. & ppoz2f !=. & ppoz3f !=.
gen PackProm=weightpperoz<0.95*ppoz_rmed & weightpperoz!=. & ppoz_rmed !=.
label var PackProm "1 if the pack is promoted"
replace PackProm=. if ppoz_rmed==. 

capture drop WeeksAvail
egen WeeksAvail=count(week), by(uniquepackid)
label var WeeksAvail "Number of weeks the pack was available"

*********
keep if NumSizes==2

*********

******************************************************************************************************************************
save Data\2001-2005PackLev_Regression_Stores-Compressed-3, replace
******************************************************************************************************************************
log using Log_Files_and_Graphs\2001-2005PackLevReport_Detergents, replace
******************************************************************************************************************************
set more off
use Data\2001-2005PackLev_Regression_Stores-Compressed-3, clear
******************************************************************************************************************************
sort uniquepackid week
xtset uniquepackid week
egen ConcWeeks=seq() if NumSizes==2 & (NumSizes==F.NumSizes | NumSizes==L.NumSizes), by (iri_key prodcode size)
egen MinConcWeeks=min(ConcWeeks), by (iri_key week prodcode)
replace ConcWeeks=MinConcWeeks if ConcWeeks>MinConcWeeks
label var ConcWeeks "Number of consecutive weeks the combination was available"

/*
egen ConcWeeks3=seq() if NumSizes==3 & (NumSizes==F.NumSizes | NumSizes==L.NumSizes), by (iri_key prodcode size)
egen MinConcWeeks3=min(ConcWeeks3), by (iri_key week prodcode)
replace ConcWeeks3=MinConcWeeks3 if ConcWeeks>MinConcWeeks
label var ConcWeeks3 "Number of consecutive weeks the combination was available"
*/



gen double WeekProdID=ProdChainID*10000+week
label var WeekProdID "iri+product code+ week"
format WeekProdID %30.0g

sort WeekProdID InvSizeRank
xtset WeekProdID InvSizeRank

gen Fsize=F.size
gen Lsize=L.size
gen double SizeProdID= ((iri_short*1000+prodcode)*1000+size)*1000+Fsize if Fsize!=.
replace SizeProdID= ((iri_short*1000+prodcode)*1000+Lsize)*1000+size if Lsize!=.
format SizeProdID %50.0g

egen MaxConcWeeks=max(ConcWeeks), by (SizeProdID)
replace ConcWeeks=MaxConcWeeks
drop MaxConcWeeks Fsize Lsize SizeProdID

************

**** Small pack promoted ***
gen SmallProm=(L1.PackProm ==1)
label variable SmallProm "Smaller Pack Promoted"
label define SmallProm 0 "No" 1 "Yes"
label values SmallProm SmallProm

gen SmallProm2=SmallProm
replace SmallProm2=. if L.PackProm==.

*** Large Pack Promoted ***
gen LargeProm2=(PackProm==1 & InvSizeRank==2)
replace LargeProm2=. if InvSizeRank==1

label var SmallProm2 "Small Pack Promoted"
label var LargeProm2 "Large Pack Promoted"

*** Basic Structure ***
count
codebook prodcode week uniquepackid iri_key 
egen prodseq=seq(), by(iri_key ProdChainID)
egen prodseqWeek=seq(), by(iri_key ProdChainID week)
egen NumProducts=count(ProdChainID) if prodseq==1, by(iri_key)
egen NumWeekProducts=count(ProdChainID) if prodseqWeek==1, by(iri_key week)

sum NumProducts NumWeekProducts 

drop prodseq prodseqWeek NumProducts NumWeekProducts

*****************************************************
****** 0 Sales Weeks and Small Pack Promotion  ******
*****************************************************
tab ZeroSalesWeek SmallProm, col
tab ZeroSalesWeek SmallProm2, col

*****************************************************
****** Missing Weeks and Small Pack Promotion ******
*****************************************************
tab MissingWeek SmallProm, col
tab MissingWeek SmallProm2, col


*****************************************************


**** Both Packs being promoted
gen OtherPackProm=L.PackProm if InvSizeRank==2
replace OtherPackProm=F.PackProm if InvSizeRank==1
label var OtherPackProm "1 if the other pack is promoted"
gen MultPromotions=PackProm*OtherPackProm
label var MultPromotions "1 if both packs are promoted"


*******************************************************
****** Other Pack Promotions and Pack Promotion  ******
*******************************************************
tab PackProm
tab PackProm if InvSizeRank==1
tab MultPromotions
tab PackProm OtherPackProm, row
tab PackProm SmallProm if InvSizeRank==2, row
tab SmallProm2 LargeProm2 if InvSizeRank==2, cell row
**********************************************************


/*
forvalues i=1 {
		gen QuantDiscInvRank_`i' = (L`i'. weightpperoz - weightpperoz)  / L`i'.weightpperoz 
		gen QuantPrem_`i'=(QuantDiscInvRank_`i'<0 & QuantDiscInvRank_`i' !=.)
		gen sizeratio`i'=size/l`i'.size 	if QuantPrem_`i'==1
		replace sizeratio`i'=round(sizeratio`i',.1)

}
*/

****************************************************
******   Quant Premium and Surcharge **************
****************************************************
**** 	Vars: QuantPrem only large pack takes value 1
****          QuantSurcharge both packs take value 1
****************************************************
gen QuantDiscInvRank = (L. weightpperoz - weightpperoz) 
gen QuantPrem=(QuantDiscInvRank<0 & QuantDiscInvRank !=.)
label var QuantPrem "1 if QS with a smaller pack"
gen sizeratio=size/l.size 	if QuantPrem==1
replace sizeratio=round(sizeratio,.1)

gen QuantSurcharge=(QuantPrem==1)
replace QuantSurcharge=F.QuantSurcharge if F.QuantSurcharge==1
label define QuantSurcharge 0 "NO QS" 1 "QS between the packs"
label values QuantSurcharge QuantSurcharge
				
gen SmallerMultipQSurc=inlist(sizeratio, 1, 1.5, 2, 2.5, 3, 4,5,6,7,8,9,10,11,12,13,14,15,16,17,18)
replace SmallerMultipQSurc=. if (QuantPrem==0 )

label define SmallerMultipQSurc 0 "QS with not smaller Mult" 1 "QS with smaller Mult"
label values SmallerMultipQSurc SmallerMultipQSurc


************************************************************************

**** Defintion of Periods *****
sort WeekProdID InvSizeRank
xtset WeekProdID InvSizeRank

gen RegularPeriod=(PackProm!=1 & OtherPackProm!=1)
gen QSPeriod=(QuantPrem*SmallProm==1)
replace QSPeriod=F.QSPeriod if F.QSPeriod==1


sort uniquepackid week
xtset uniquepackid week

*****************************************
****** Small Pack Promotion and QS ******
*****************************************
tab QuantSurcharge
tab SmallProm QuantSurcharge, row
tab SmallProm QuantPrem, row

**** using these two ****
tab SmallProm2 QuantSurcharge, row
tab SmallProm2 QuantPrem, row

tab SmallProm2 QuantPrem if L.QSPeriod==0 & MultPromotions==0, row
tab SmallProm2 QuantPrem if L.SmallProm2==0 & PackProm==0, row
******************************





egen MedianWeekSales=median(totsales), by(uniquepackid)
gen HMedWeekSales=MedianWeekSales>=20
label define HMedWeekSales 0 "Median Sales <20" 1 "Median Sales >=20"
label values HMedWeekSales HMedWeekSales



****** Extra tables ******
**************************
tab QuantSurcharge SmallProm if HMedWeekSales==1 , col
* New QS*
tab QuantSurcharge SmallProm if HMedWeekSales==1 & L.QuantSurcharge==0 , col




************************************************************************
*****			Sales Ratio								  			****
************************************************************************

* Defintion of Periods *
sort WeekProdID InvSizeRank
xtset WeekProdID InvSizeRank

drop RegularPeriod QSPeriod
gen RegularPeriod=(PackProm!=1 & OtherPackProm!=1)
gen QSPeriod=(QuantPrem*SmallProm==1)
replace QSPeriod=F.QSPeriod if F.QSPeriod==1

************************************************************************************************
sort uniquepackid week
xtset uniquepackid week
** Sales Ratio relative to previous week **
gen QSurcSales=totsales/L.totsales if (QuantPrem==1) 

*** Relative to regular median sales ***
egen RegMedianWeekSales=median(totsales) if RegularPeriod==1, by(uniquepackid)
egen RegMedianWeekSales1=max(RegMedianWeekSales), by (uniquepackid)
drop RegMedianWeekSales
rename RegMedianWeekSales1 RegMedianWeekSales
******************************************
gen QSurcSales_Median=totsales/RegMedianWeekSales if QSPeriod==1 & InvSizeRank==2
************************************************************************************************


*********************************************************
sort uniquepackid week
xtset uniquepackid week

*********************************************************
******** Medians of Sales ratios ***********************
*********************************************************
gen HMed10WeekSales=MedianWeekSales>=10
label define HMed10WeekSales 0 "Median Sales < 10" 1 "Median Sales >= 10"
label values HMed10WeekSales HMed10WeekSales

*** All QS Periods ****
table HMed10WeekSales if QSPeriod==1, c(n QSurcSales  p50 QSurcSales n QSurcSales_Median p50 QSurcSales_Median) row

***** New QS Periods and Solo promotions (Included in the report) **** 
table HMed10WeekSales if QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0, c(n QSurcSales  p50 QSurcSales n QSurcSales_Median p50 QSurcSales_Median) row

*********************************************************

tab ZeroSalesWeek HMed10WeekSales if QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0 & QSurcSales!=.
tab ZeroSalesWeek HMed10WeekSales if QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0 & QSurcSales_Median!=.


*********************************************************

egen SeqUniquepackid=seq(), by(uniquepackid)


***  Distribution parameters of key variables ***
sum totsales, d

sum RegMedianWeekSales if QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0 & QSurcSales_Median!=.,d
sum RegMedianWeekSales if QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0 & SeqUniquepackid==1 & QSurcSales_Median!=., d

sum L.totsales if QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0 & QSurcSales!=.,d
sum L.totsales if QSPeriod ==1 & L.QSPeriod ==0 & SeqUniquepackid==1  & QSurcSales!=.,d
capture drop Ltotsales
gen Ltotsales=L.totsales if QSPeriod ==1 & L.QSPeriod ==0




*** Distribution of unit sales of those packs that recorded at least 1 zero sales week ***
egen MinSales=min(totsales) if totsales!=., by(uniquepackid) 
sum totsales, d
egen Zero_MedianWeekSales=median(totsales) if MinSales ==0, by(uniquepackid)
sum Zero_MedianWeekSales,d


*******************************************
*** Depth of discount during promotions ***
*******************************************
sort uniquepackid week
xtset uniquepackid week

*** All Packs ****
gen PercDiscount=(weightpperoz-L.weightpperoz)/L.weightpperoz if PackProm==1
gen PercDiscount_ppoz_rmed=(weightpperoz-ppoz_rmed)/ppoz_rmed if PackProm==1

sum PercDiscount*, d

*** All Packs- First week of promotion ***
gen PercDiscount_1st=(weightpperoz-L.weightpperoz)/L.weightpperoz if PackProm==1 & L.PackProm==0
gen PercDiscount_1st_ppoz_rmed=(weightpperoz-ppoz_rmed)/ppoz_rmed if PackProm==1 & L.PackProm==0
sum PercDiscount_1st*, d


*** Small Packs in the QS Periods identified above ***
sort WeekProdID InvSizeRank
xtset WeekProdID InvSizeRank

gen FQSurcSales=F.QSurcSales
gen FQSurcSales_Median=F.QSurcSales_Median

sort uniquepackid week
xtset uniquepackid week

gen PercSmallDiscQS_RW=(weightpperoz-L.weightpperoz)/L.weightpperoz if FQSurcSales!=. & QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0 & InvSizeRank==1
gen PercSmallDiscQS_RM=(weightpperoz-L.weightpperoz)/L.weightpperoz if FQSurcSales_Median!=. & QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0 & InvSizeRank==1
gen PercSmallDiscQS_RW_ppoz_rmed=(weightpperoz-L.ppoz_rmed)/L.ppoz_rmed if FQSurcSales!=. & QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0 & InvSizeRank==1
gen PercSmallDiscQS_RM_ppoz_rmed=(weightpperoz-L.ppoz_rmed)/L.ppoz_rmed if FQSurcSales_Median!=. & QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0 & InvSizeRank==1

sum PercSmallDiscQS_R*, d

*************************
*** Price Ratio in QS ***
*************************
sort WeekProdID InvSizeRank
xtset WeekProdID InvSizeRank
gen PercDiffQS = (L.weightpperoz/weightpperoz) if QuantDiscInvRank <0 & QuantDiscInvRank!=.

sort uniquepackid week
xtset uniquepackid week
sum PercDiffQS, d
sum PercDiffQS if QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0 & QSurcSales!=.,d
sum PercDiffQS if QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0 & QSurcSales_Median!=.,d

******************************************************************************************************************************
save Data\2001-2005PackLev_NonLinear-Regressions, replace
******************************************************************************************************************************

log close

set more off

use Data\2001-2005PackLev_NonLinear-Regressions, clear

sum QSurcSales QSurcSales_Median if QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0

histogram QSurcSales if QSurcSales<=40 & QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0, bin (50) kdensity
graph save Graph Log_Files_and_Graphs\RW_Distr_tr40, replace

histogram QSurcSales_Median if QSurcSales_Median <=200 & QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0, w(1) kdensity
graph save Graph Log_Files_and_Graphs\RM_Distr_tr200, replace

histogram totsales if totsales<=200,  w(1) kdensity
graph save  Log_Files_and_Graphs\UnitSales_Distribution_tr_200, replace
count if totsales<=200 & SeqUniquepackid==1
count if totsales>200 & SeqUniquepackid==1

egen Seq2Uniquepackid =seq() if QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0  & QSurcSales_Median!=., by(uniquepackid)
histogram RegMedianWeekSales if QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0  & QSurcSales_Median!=. & Seq2Uniquepackid==1, w(1) kdensity
graph save Graph Log_Files_and_Graphs\RegMedianWeekSales_Distribution, replace
drop Seq2Uniquepackid

histogram Ltotsales if Ltotsales<=200 & QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0  & QSurcSales!=., w(1) kdensity
graph save Graph Log_Files_and_Graphs\LSales_Distribution_tr_200, replace

histogram Zero_MedianWeekSales if Zero_MedianWeekSales<=200 & SeqUniquepackid==1, w(1) kdensity
graph save Graph Log_Files_and_Graphs\Zero_MedianSales_Distribution_tr_200,replace

