*program define tcredit
*args class minobs iniyear endyear digit hqual

/*-------------------------------------------------------------------------------------------------------------*/
/*This program takes data on trade credit from dependence dataset and creates a set of typical measure
  by industry, both at the SIC and ISIC codes. Use: 3 digits SIC and ISIC
  First version: March 17, 2003
  This version: March 17, 2003.
  Author: Claudio Raddatz
  MODIFIED OCTOBER 2008 TO COMPUTE RATIO OF PAYABLES TO COST OF GOODS SOLD AND MATERIALS TO COST OF GOODS SOLD
  MODIFIED OCTOBER 30 2008 TO COMPUTE RATIO OF NET TRADE CREDIT TO THE COST OF GOODS SOLD*/
/*-------------------------------------------------------------------------------------------------------------*/

/*-------------------------------------------------------------------------------------------------------------*/
/*FIRST PART SELECT THE FILE AND SAMPLE, INITIALIZES SOME VARIABLES AND ASSIGN ISIC CODES*/
set mem 30m
local digit   = 3    /*This one defines the level of aggregation that the program uses*/
local iniyear = 1980
local endyear = 1999 /*The previous two define the period over which I use the data to build the measures*/
local hqual   = 1    /*This one defines the quality of the data: 1 is only high quality data (good match permnos)*/
local minobs  = 0    /*Defines the minimum number of observations (firms) to accept a sector (this can be controlled later)*/
local id permno      /*Defining which variable is the identifier*/
local defage ipo     /*Defining which variable determines firm age*/
local class "isic"

/*select the file to use*/

use dependence.dta

tsset permno year

/*SELECTING SAMPLE*/

   keep if year>=`iniyear' & year<=`endyear'
   keep if hqual<=`hqual'


/*Eliminating those observations with no format for cash flow statement*/
/*the reason is that a firm might be taken off the sample because of no matching counters for this reason*/

drop if fcode==. | fcode==4 | fcode==5 | fcode==6


/* Define sic or isic codes */

    if "`class'" == "isic" {
      sort sic
      merge sic using "sicisic.dta", nok
      if `digit'==3 {
      gen isic3 = int(isic/10)
      drop isic
      rename isic3 isic
      }
      drop _merge
      }
    else if "`class'" == "sic3" {
      gen sic3 = int(sic/10) if sic>=1000
      replace sic3 = sic if sic<1000
    }
    else if "`class'" == "codesic" {
      gen sic3 = int(sic/10) if sic>=1000
      replace sic3 = sic if sic<1000

      /*Assign codesics merging the database*/

      sort sic3
      merge sic3 using "sic3_normal_codesic", nok
      drop _merge
      gen sic2 = int(sic3/10) if sic3>=100
      replace sic2 = sic3 if sic3<100
      sort sic2
      merge sic2 using "sic2_normal_codesic", update nok /*Replacing only the missing*/
      drop _merge sic2

    }
    else if "`class'" == "indgtap" {
      sort sic
      merge sic using "sicisic.dta", nok
      gen isic3 = int(isic/10)
      drop isic
      rename isic3 isic
      drop _merge
      /*Assign codesics merging the database*/

      sort isic
      merge isic using "isic_gtap.dta", nok
      drop _merge
    }



/*
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
 Define  main variables
 By now I don't have the data on current liabilities (compustat #5) and total liabilities (compustat #181)
 Momentaneously I will do the following:
 - Instead of current liabilities I will use account payables (compustat #70) plus debt in current liabilities
   (compustat #34)
 - Instead of total liabilities I will use my measure of current liabilities plus long term debt (compustat #9)
 - In each case these are the main components of liabilities, so the approximation should be fine. If something
   interesting appears I should gather the data.
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
*/

/*Creating intermediate variables*/


qui gen culiab = acpay + cudebt
qui gen tliab  = culiab + ltdebt


/*Relative importance of trade credit as a source of funds
1. As a fraction of current liabilities
2. As a fraction of total liabilities
3. As a fraction of total assets
4. As a fraction of total sales
*/

tsset

    qui gen matcost = cost-wages
    qui gen payculi = acpay/culiab
    qui gen paytlia = acpay/tliab
    qui gen paytass = acpay/totass
    qui gen paysale = acpay/sales
    qui gen netpay  = (acpay - acrec)
    qui gen payturn = (cost/(0.5*(acpay + l.acpay)))
    qui gen recturn = (sales/(0.5*(acrec + l.acrec)))
    qui gen paymatc = (matcost/(0.5*(acpay + l.acpay)))
    qui gen netpayt = (cost/(0.5*(netpay + l.netpay)))
    qui gen stdbtpay = stdbt/acpay
    qui gen mcost2cgs= matcost/cost

/*Relative importance of trade credit as a use of funds
1. As a fraction of current assets
2. As a fraction of total assets
3. As a fraction of total sales
*/

    qui gen reccuas = acrec/cuass
    qui gen rectass = acrec/totass
    qui gen recsale = acrec/sales


/*-------------------------------------------------------------------------------------------------------------*/


/*Dropping those with funny values*/

    qui replace payculi  =. if payculi  >1 | payculi  <0
    qui replace paytlia  =. if paytlia  >1 | paytlia  <0
    qui replace paytass  =. if paytass  >1 | paytass  <0
    *qui replace paysale  =. if paysale  >1 | paysale  <0

    qui replace reccuas  =. if reccuas  >1 | reccuas  <0
    qui replace rectass  =. if rectass  >1 | rectass  <0
    *qui replace recsale  =. if recsale  >1 | recsale  <0


pause /*This pause can be used to save the new database with the relevant measures year by year.*/

display "HERE"

/*NOTE THAT I'M NOT GENERATING THE STOCK VALUE OF THE VARIABLES, WHICH I HAVE PREVIOUSLY NOT USED ANYWAY*/


/*-------------------------------------------------------------------------------------------------------------*/
/* summarize at firm-isic level: robust statistic median*/
/*-------------------------------------------------------------------------------------------------------------*/


collapse (median) payculi paytlia paytass paysale payturn reccuas rectass recsale recturn stdbtpay matcost paymat mcost2cgs netpayt, by(`id' `class')

*save firms_T, replace

/*-------------------------------------------------------------------------------------------------------------*/
/*-------------------------------------------------------------------------------------------------------------*/

/*  Drop the ratios if you have less than `minobs' firms per industry       */

/*generating the counters*/
/*Names for counters are n plus the first 5 letters of the variable name*/

/*Inventories*/

display "`class'"

    qui egen npayculi = count(payculi), by(`class')
    qui egen npaytlia = count(paytlia), by(`class')
    qui egen npaytass = count(paytass), by(`class')
    qui egen npaysale = count(paysale), by(`class')
    qui egen nreccuas = count(reccuas), by(`class')
    qui egen nrectass = count(rectass), by(`class')
    qui egen nrecsale = count(recsale), by(`class')
    qui egen nrecturn = count(recturn), by(`class')
    qui egen npayturn = count(payturn), by(`class')
    qui egen nstdbtpay = count(stdbtpay), by(`class')
    qui egen npaymatc  = count(paymat), by(`class')
    qui egen nmatcost  = count(matcost), by(`class')
    qui egen nmcost2cgs= count(mcost2cgs), by(`class')
    qui egen nnetpayt = count(netpayt), by(`class')


/*-------------------------------------------------------------------------------------------------------------*/

/*Start with the replacing*/

/*Inventories*/

qui replace payculi = . if npayculi < `minobs'
qui replace paytlia = . if npaytlia < `minobs'
qui replace paytass = . if npaytass < `minobs'
qui replace paysale = . if npaysale < `minobs'
qui replace reccuas = . if nreccuas < `minobs'
qui replace rectass = . if nrectass < `minobs'
qui replace recsale = . if nrecsale < `minobs'
qui replace recturn = . if nrecturn < `minobs'
qui replace payturn = . if npayturn < `minobs'
qui replace stdbtpay = . if nstdbtpay < `minobs'
qui replace paymatc = . if npaymat < `minobs'
qui replace matcost = . if nmatcost < `minobs'
qui replace mcost2cgs = . if nmcost2cgs < `minobs'
qui replace netpayt = . if nnetpayt < `minobs'

/*-------------------------------------------------------------------------------------------------------------*/
/*-------------------------------------------------------------------------------------------------------------*/
/*-------------------------------------------------------------------------------------------------------------*/
/*START COLLAPSING THE DATA*/
/*-------------------------------------------------------------------------------------------------------------*/
/*-------------------------------------------------------------------------------------------------------------*/
/*-------------------------------------------------------------------------------------------------------------*/

egen RECTURN = median(recturn)
egen PAYTURN = median(payturn)
egen STDBTPAY = median(stdbtpay)
egen MATCOST = median(matcost)
egen PAYMATC = median(paymatc)
egen MCOST2CGS = median(mcost2cgs)
egen NETPAYT = median(netpayt)

collapse (median) payculi paytlia paytass paysale reccuas rectass recsale recturn payturn stdbtpay paymat mcost2cgs netpayt /*
*/       	RECTURN PAYTURN STDBTPAY PAYMAT MCOST2CGS/*
*/           (sd) sdpaycul = payculi sdpaytli = paytlia sdpayta = paytass/*
*/                sdpaysal = paysale sdreccua = reccuas sdrecta = rectass sdrecsa = recsale/*
*/          (iqr) iqpaycul = payculi iqpaytli = paytlia iqpayta = paytass/*
*/                iqpaysal = paysale iqreccua = reccuas iqrecta = rectass iqrecsa = recsale/*
*/         (mean) npayculi npaytlia npaytass npaysale nreccuas nrectass nrecsale nrecturn npayturn nstdbtpay npaymat nmcost2cgs nnetpayt/*
*/                , by(`class')


if "`class'" ~= "codesic" {
   drop if `class'==.

   if "`class'" == "sic3" {
      drop if `class' < 200 | `class'>399
   }
}
else {
   drop if `class' == ""
   drop  if substr(codesic,2,1)~="2" & substr(codesic,2,1)~="3"
}


local year1=mod(`iniyear',100)
local year2=mod(`endyear',100)

if "`class'" == "isic" {

    if `digit'==3 {
      save "tcred_isic`digit'_`year1'`year2'`hqual'_net.dta", replace
    }
    else if `digit'==4 {  /*When using 4 digits the 3 digit codes are extracted from the 3 digit database*/
      save "tcred_isic`digit'_`year1'`year2'`hqual'_T.dta", replace
      preserve
      use "tcred_isic3_`year1'`year2'`hqual'_T.dta"
      qui replace isic = isic*10
      sort isic
      save paso, replace
      restore
      sort isic
      merge isic using paso, update replace
      save "tcred_isic`digit'_`year1'`year2'`hqual'_T.dta", replace
    }
}
else if "`class'" == "sic" {
      save "tcred_sic`digit'_`year1'`year2'`hqual'_T.dta", replace
}
else if "`class'" == "codesic" {
      save "tcred_codesic_`year1'`year2'`hqual'_T.dta", replace
}
else if "`class'" == "indgtap" {
      save "tcred_indgtap_`year1'`year2'`hqual'_T.dta", replace
}

program drop _all
drop _all

*end
