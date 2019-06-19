*****************************************************************************
*** Diap_reg.do
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

*** Requires data files Diap2001-Diap2005, located in folder Original_data ***

clear
capture log close
set more off

forvalues i=1/5 {
			clear
			use Original_data\diapers200`i'.dta
			gen str18 upc = string(sy,"%02.0f") + "-" + string(ge,"%02.0f") + "-" + string(vend,"%05.0f") + "-" + string(item,"%05.0f")
			sort upc
			gen double COLUPC=((sy*100 + ge)* 100000 +vend)*100000 + item
			format COLUPC %30.0g
			save Databases\diapers200`i'_Regression_stores_dups, replace
			do prod_diapers
			merge upc using Databases\diapers200`i'_Regression_stores_dups, uniqmaster sort
			drop _merge

			gen price = dollars/units
			replace price=round(price,.01)
			gen pperdiaper = price/count

			sort iri week prodcode count
			label variable dollars "total dollar sales"
			label variable units "unit sales"
			label variable iri_key "masked store number"
			label variable vend "parent company/manufacturer's code"
			drop if price == .
			drop if iri==.
			drop if count==.
			drop if brand==""

			drop upc product1 sy ge vend item 
			compress
			
			gen double uniquepackid=((iri_key * 1000) + prodcode) * 100 + count
			format uniquepackid %30.0g
			*isid uniquepackid week

			replace uniquepackid=round(uniquepackid, 0.01)

			sort uniquepackid week
			egen orderofdups=seq(), by(uniquepackid week)
			gen double uniqueseq=uniquepackid*10+orderofdups
			format uniqueseq %30.0g
			sort uniqueseq week
			isid uniqueseq week

			sort iri_key prodcode week count
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

			egen ratio_pperdiaper1= max(pperdiaper) if numobs==1 , by (uniquepackid week)
			replace ratio_pperdiaper1=pperdiaper/ratio_pperdiaper1 if numobs==1
			egen min_ratio_pperdiaper1= min(ratio_pperdiaper1) if numobs==1 , by (uniquepackid week)
			drop if min_ratio_pperdiaper1<0.95
			drop ratio_pperdiaper1 min_ratio_pperdiaper1

			egen ratio_pperdiaper2= max(pperdiaper) if numobs==2 , by (uniquepackid week)
			replace ratio_pperdiaper2=pperdiaper/ratio_pperdiaper2 if numobs==2
			egen min_ratio_pperdiaper2= min(ratio_pperdiaper2) if numobs==2 , by (uniquepackid week)
			drop if min_ratio_pperdiaper2<0.95
			drop ratio_pperdiaper2 min_ratio_pperdiaper2
			
			egen ratio_pperdiaper3= max(pperdiaper) if numobs==3 , by (uniquepackid week)
			replace ratio_pperdiaper3=pperdiaper/ratio_pperdiaper3 if numobs==3
			egen min_ratio_pperdiaper3= min(ratio_pperdiaper3) if numobs==3 , by (uniquepackid week)
			drop if min_ratio_pperdiaper3<0.95
			drop ratio_pperdiaper3 min_ratio_pperdiaper3

			egen ratio_pperdiaper4= max(pperdiaper) if numobs==4 , by (uniquepackid week)
			replace ratio_pperdiaper4=pperdiaper/ratio_pperdiaper4 if numobs==4
			egen min_ratio_pperdiaper4= min(ratio_pperdiaper4) if numobs==4 , by (uniquepackid week)
			drop if min_ratio_pperdiaper4<0.95
			drop ratio_pperdiaper4 min_ratio_pperdiaper4

			
			
			rename f feature
			rename d display



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
			gen prop_pperdiaper=pperdiaper*propsales
			egen weightpperdiaper=total(prop_pperdiaper), by (uniquepackid week)
			label variable weightpperdiaper "weighted average price per diaper"
			gen weightprice=weightpperdiaper*count
			label var weightprice "weighted average price per unit"

*** KEEP ONLY NON-DUPLICATED DATA
			drop if orderofdups>1
			egen sizeid = seq(), by(iri_key prodcode week)
			isid uniquepackid week /* clear */
			xtset uniquepackid week
			sort uniquepackid week
			replace weightprice=round(weightprice,.01)
			save Databases\diapers200`i'_Regression_stores_nodups, replace

			capture drop ge 
			capture drop item 
			capture drop sy 
			capture drop vend 
			compress 
			sort iri_key prodcode COLUPC week 
			save Databases\200`i'PackLev_Regression_Stores,replace



			egen NumSizes=count(count), by (iri week prodcode)
			label var NumSizes "Number of sizes of a product in a given store-week"
			*keep if NumSizes>1

			save Databases\200`i'PackLev_Regression_Stores, replace
}
*

forvalues i=1/5 {
			use Databases\200`i'PackLev_Regression_Stores, clear
			drop brand pricered COLUPC orderofdups uniqueseq numobs first_week numfeature sizeid weightprice
			compress
			save Databases\200`i'PackLev_Regression_Stores-Compressed, replace
}
*

****************************************************************

clear

use 		Databases\2005PackLev_Regression_Stores-Compressed, clear
append using  Databases\2004PackLev_Regression_Stores-Compressed.dta
append using  Databases\2003PackLev_Regression_Stores-Compressed.dta
append using  Databases\2002PackLev_Regression_Stores-Compressed.dta
append using  Databases\2001PackLev_Regression_Stores-Compressed.dta

compress

drop PackWeek propsales prop_pperdiaper NumSizes
****************************************************************************************************************************************************************
****************************************************************************************************************************************************************

****************************************			Report 						********************************************************************************

****************************************************************************************************************************************************************
****************************************************************************************************************************************************************

sort uniquepackid week
xtset uniquepackid week

gen double ProdChainID=iri*1000+prodcode
label var ProdChainID "iri+prodcode_code"
format ProdChainID %200.0f
isid ProdChainID count week
capture gen double uniquepackid=((iri_key * 1000) + prodcode) * 100 + count
format uniquepackid %30.0g
isid uniquepackid week
label var uniquepackid "iri+product code+ count"

sort uniquepackid week

*egen WeeksAvail=count(week), by(uniquepackid)

compress

*egen PackSeq=seq(), by(uniquepackid)
*xtset uniquepackid PackSeq
*gen WeekDiff=week-L.week

save Databases\2001-2005PackLev_Regression_Stores-Compressed, replace

forvalues i=1/5 {
	erase Databases\200`i'PackLev_Regression_Stores-Compressed.dta
	erase Databases\200`i'PackLev_Regression_Stores.dta
	erase Databases\diapers200`i'_Regression_stores_dups.dta
	erase Databases\diapers200`i'_Regression_stores_nodups.dta
	}

*****************************************************************
use Databases\2001-2005PackLev_Regression_Stores-Compressed, clear

keep iri_key
duplicates drop iri_key, force
sort iri_key
gen iri_short=_n


 merge 1:m iri_key using Databases\2001-2005PackLev_Regression_Stores-Compressed
 

drop _merge
drop dollars price


egen ProdTotSales=total(totsales), by (ProdChainID )
gen ProdMeanWeekSales=ProdTotSales/260
egen prodseq=seq(), by(ProdChainID )

count
sum ProdTotSales ProdMeanWeekSales if prodseq ==1, d
sum ProdTotSales ProdMeanWeekSales if prodseq ==1 & ProdMeanWeekSales>=10, d

keep if ProdMeanWeekSales>=10

drop ProdMeanWeekSales ProdTotSales prodseq

compress

xtset uniquepackid week
tsfill

replace iri_key=L.iri_key if totsales==.
replace iri_short=L.iri_short if totsales==.
replace count=L.count if totsales==.
replace ProdChainID=L.ProdChainID if totsales==.
replace prodcode=L.prodcode if totsales==.

save Databases\2001-2005PackLev_Regression_Stores-Compressed-2, replace
******************************************************************************
use Databases\2001-2005PackLev_Regression_Stores-Compressed-2, clear

capture drop NumSizes
egen NumSizes=count(count), by (iri_key week prodcode)
label var NumSizes "Number of sizes of a product in a given store-week"

capture drop InvSizeRank
egen InvSizeRank=rank(count), by (iri_key week prodcode) track

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
replace weightpperdiaper=L.weightpperdiaper if L.weightpperdiaper ==F.weightpperdiaper & weightpperdiaper ==. & totsales==0

* 2 weeks with 0 sales *

replace weightpperdiaper=L.weightpperdiaper if L.weightpperdiaper ==F2.weightpperdiaper & weightpperdiaper ==. & F.totsales ==0 & totsales==0
replace weightpperdiaper=F.weightpperdiaper if L2.weightpperdiaper ==F.weightpperdiaper & weightpperdiaper ==. & L.totsales ==0 & totsales==0
************************************************************************************

*** Defining Pack prom
gen ppdiaper1l=l.weightpperdiaper if weightpperdiaper!=.
gen ppdiaper2l=l2.weightpperdiaper if weightpperdiaper!=.
gen ppdiaper3l=l3.weightpperdiaper if weightpperdiaper!=.
gen ppdiaper1f=f.weightpperdiaper if weightpperdiaper!=.
gen ppdiaper2f=f2.weightpperdiaper if weightpperdiaper!=.
gen ppdiaper3f=f3.weightpperdiaper if weightpperdiaper!=.

egen ppdiaper_rmed=rowmedian(ppdiaper1l ppdiaper2l ppdiaper3l weightpperdiaper ppdiaper1f ppdiaper2f ppdiaper3f) if ppdiaper3l !=. & ppdiaper2l !=. & ppdiaper1l !=. & weightpperdiaper !=. & ppdiaper1f !=. & ppdiaper2f !=. & ppdiaper3f !=.
gen PackProm=weightpperdiaper<0.95*ppdiaper_rmed & weightpperdiaper!=. & ppdiaper_rmed !=.
label var PackProm "1 if the pack is promoted"
replace PackProm=. if ppdiaper_rmed==. 

capture drop WeeksAvail
egen WeeksAvail=count(week), by(uniquepackid)
label var WeeksAvail "Number of weeks the pack was available"

*********
keep if NumSizes==2

*********

save Databases/2001-2005PackLev_Regression_Stores-Compressed-3, replace
******************************************************************************
use Databases/2001-2005PackLev_Regression_Stores-Compressed-3, clear
capture log close

log using Log_Files_and_Graphs\2001-2005PackLevReport_diapers, replace

sort uniquepackid week
xtset uniquepackid week
egen ConcWeeks=seq() if NumSizes==2 & (NumSizes==F.NumSizes | NumSizes==L.NumSizes), by (iri_key prodcode count)
egen MinConcWeeks=min(ConcWeeks), by (iri_key week prodcode)
replace ConcWeeks=MinConcWeeks if ConcWeeks>MinConcWeeks
label var ConcWeeks "Number of consecutive weeks the combination was available"



gen double WeekProdID=ProdChainID*10000+week
label var WeekProdID "iri+product code+ week"
format WeekProdID %30.0g

sort WeekProdID InvSizeRank
xtset WeekProdID InvSizeRank

gen Fcount=F.count
gen Lcount=L.count
gen double SizeProdID= ((iri_short*1000+prodcode)*100+count)*100+Fcount if Fcount!=.
replace SizeProdID= ((iri_short*1000+prodcode)*100+Lcount)*100+count if Lcount!=.
format SizeProdID %50.0g

egen MaxConcWeeks=max(ConcWeeks), by (SizeProdID)
replace ConcWeeks=MaxConcWeeks
drop MaxConcWeeks Fcount Lcount SizeProdID

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


****************************************************
******   Quant Premium and Surcharge **************
****************************************************
**** 	Vars: QuantPrem only large pack takes value 1
****          QuantSurcharge both packs take value 1
****************************************************
gen QuantDiscInvRank = (L.weightpperdiaper - weightpperdiaper) 
gen QuantPrem=(QuantDiscInvRank<0 & QuantDiscInvRank !=.)
label var QuantPrem "1 if QS with a smaller pack"
*gen sizeratio=size/l.size 	if QuantPrem==1
*replace sizeratio=round(sizeratio,.1)

gen QuantSurcharge=(QuantPrem==1)
replace QuantSurcharge=F.QuantSurcharge if F.QuantSurcharge==1
label define QuantSurcharge 0 "NO QS" 1 "QS between the packs"
label values QuantSurcharge QuantSurcharge
		

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


sort uniquepackid week
xtset uniquepackid week
egen MedianWeekSales=median(totsales), by(uniquepackid)


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

sum RegMedianWeekSales if QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0 & QSurcSales_Median!=.,d
sum RegMedianWeekSales if QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0 & SeqUniquepackid==1 & QSurcSales_Median!=., d

sum L.totsales if QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0 & QSurcSales!=.,d
sum L.totsales if QSPeriod ==1 & L.QSPeriod ==0 & SeqUniquepackid==1  & QSurcSales!=.,d
capture drop Ltotsales
gen Ltotsales=L.totsales if QSPeriod ==1 & L.QSPeriod ==0




*** Distribution of unit sales of those packs that recorded at least 1 zero sales week ***
egen MinSales=min(totsales) if totsales!=., by(uniquepackid) 
sum totsales if MinSales==0, d
egen Zero_MedianWeekSales=median(totsales) if MinSales ==0, by(uniquepackid)
sum Zero_MedianWeekSales if MinSales==0,d


*******************************************
*** Depth of discount during promotions ***
*******************************************
sort uniquepackid week
xtset uniquepackid week
*** All Packs ****

gen PercDiscount=(weightpperdiaper-L.weightpperdiaper)/L.weightpperdiaper if PackProm==1
gen PercDiscount_ppdiaper_rmed=(weightpperdiaper-ppdiaper_rmed)/ppdiaper_rmed if PackProm==1

sum PercDiscount*, d

*** All Packs- First week of promotion ***
gen PercDiscount_1st=(weightpperdiaper-L.weightpperdiaper)/L.weightpperdiaper if PackProm==1 & L.PackProm==0
gen PercDiscount_1st_pperdiaper_rmed=(weightpperdiaper-ppdiaper_rmed)/ppdiaper_rmed if PackProm==1 & L.PackProm==0
sum PercDiscount_1st*, d

*** Small Packs in the QS Periods identified above ***
sort WeekProdID InvSizeRank
xtset WeekProdID InvSizeRank

gen FQSurcSales=F.QSurcSales
gen FQSurcSales_Median=F.QSurcSales_Median

sort uniquepackid week
xtset uniquepackid week


gen PercSmallDiscQS_RW=(weightpperdiaper-L.weightpperdiaper)/L.weightpperdiaper if FQSurcSales!=. & QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0 & InvSizeRank==1
gen PercSmallDiscQS_RM=(weightpperdiaper-L.weightpperdiaper)/L.weightpperdiaper if FQSurcSales_Median!=. & QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0 & InvSizeRank==1
gen PercSmallDiscQS_RW_ppoz_rmed=(weightpperdiaper-L.ppdiaper_rmed)/L.ppdiaper_rmed if FQSurcSales!=. & QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0 & InvSizeRank==1
gen PercSmallDiscQS_RM_ppoz_rmed=(weightpperdiaper-L.ppdiaper_rmed)/L.ppdiaper_rmed if FQSurcSales_Median!=. & QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0 & InvSizeRank==1

sum PercSmallDiscQS_R*, d

*************************
*** Price Ratio in QS ***
*************************
sort WeekProdID InvSizeRank
xtset WeekProdID InvSizeRank

gen PercDiffQS = (L.weightpperdiaper/weightpperdiaper) if QuantDiscInvRank <0 & QuantDiscInvRank!=.

sort uniquepackid week
xtset uniquepackid week

sum PercDiffQS, d
sum PercDiffQS if QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0 & QSurcSales!=.,d

sum PercDiffQS if QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0 & QSurcSales_Median!=.,d


log close

******************************************************************************************************************************

save Databases\2001-2005PackLev_NonLinearRegressions, replace

******************************************************************************************************************************

set more off

use Databases\2001-2005PackLev_NonLinearRegressions, clear

******************************************************************************************************************************


sum QSurcSales QSurcSales_Median if QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0

histogram QSurcSales if QSurcSales<=40 & QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0, bin (50) kdensity
graph save Graph Log_Files_and_Graphs\RW_Distr_tr40, replace

histogram QSurcSales_Median if QSurcSales_Median <=100 & QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0, bin(50) kdensity
graph save Graph Log_Files_and_Graphs\RM_Distr_tr100, replace

histogram totsales ,  w(1) kdensity
graph save Graph Log_Files_and_Graphs\UnitSales_Distribution, replace
count if totsales<=200 & SeqUniquepackid==1
count if totsales>200 & SeqUniquepackid==1

egen Seq2Uniquepackid =seq() if QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0  & QSurcSales_Median!=., by(uniquepackid)
histogram RegMedianWeekSales if QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0  & QSurcSales_Median!=. & Seq2Uniquepackid==1, w(1) kdensity
graph save Graph RegMedianWeekSales_Distribution, replace
drop Seq2Uniquepackid

histogram Ltotsales if  QSPeriod ==1 & L.QSPeriod==0 & MultPromotions==0  & QSurcSales!=., w(1) kdensity
graph save Graph Log_Files_and_Graphs\LSales_Distribution, replace

histogram Zero_MedianWeekSales if  SeqUniquepackid==1, w(1) kdensity
graph save Graph Log_Files_and_Graphs\Zero_MedianSales_Distribution,replace


