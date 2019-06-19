
/*
This dofile replicates Tables 2 and 3 in text and Table A7, A8 and A9 in the
appendix of the paper:
What Hinders Investment in the Aftermath of Financial Crises? Insolvent 
Firms or Illiquid Banks?
*/		

use merged_clean_data_dec2015.dta,clear

xtset id year
//////////////////////////////////////////////////////////////////////
///******* Generate the main variables used in the estimation
///////////////////////////////////////////////////////////////////////
**************************************
/*Debt and Dollar-Debt variables*/
**************************************
** LAG values
local varlist DD shDD shDshD DA lonDD lonDlonD
foreach var of local varlist{
bys id: gen lag`var'=L.`var'
}

** Dummy equal one if the firm holds any dollar debt/asset in the PREVIOUS year
local varlist DD shDD shDshD DA 
foreach var of local varlist{
gen `var'dum=0
replace `var'dum=1 if lag`var'>0 & lag`var'~=.
replace `var'dum=. if lag`var'==.
}


**************************************
/*        Foreign Ownership         */
**************************************
** Dummy more than 50% owned based on CURRENT VALUES
gen dumfor50t=0
replace dumfor50t=1 if forult>50
replace dumfor50t=. if forult==.

** Dummy more than 50% owned based on LAGGED VALUES
sort id year
by id:gen lagforult=L.forult

foreach i in 50 10 60 90 {
gen dumfor`i'=0
replace dumfor`i'=1 if lagforult>`i'
replace dumfor`i'=. if lagforult==.
}

*Continuous
gen forult1=forult+1
gen ln_forult=ln(forult1)

*Dummy up to 50 and then continous
gen lforultdum50=ln_forult*dumfor50

sort id year
by id:gen ln_lagforult=L.ln_forult
by id:gen ln_lagforultdum50=L.lforultdum50

**************************************
/*        Exports                    */
**************************************
*continous measure of exports
gen XshD=exports/shortliab
gen XD=exports/totliab

sum XshD XD,detail

* LAG values
sort id year
local varlist shX XshD XD
foreach var of  local varlist{
by id:gen lag`var'=L.`var'
}

*dummy exporter based on CURRENT values
gen exportert=0
replace exportert=. if shX==.
replace exportert=1 if shX>0 & shX~=.

*dummy exporter based on LAGGED values
gen exporter=0
replace exporter=. if lagshX==.
replace exporter=1 if lagshX>0 & lagshX~=.

*dummy for high exporters (75 percentile of shX distribution) 
sum shX,detail
*Dummy based on CURRENT VALUES
gen exp10t=0
replace exp10t=. if shX==.
replace exp10t=1 if shX>0.1 & shX~=.

*Dummy based on LAGGED VALUES
gen exp10=0
replace exp10=. if lagshX==.
replace exp10=1 if lagshX>0.1 & lagshX~=.

**************************************
/*        Bank data                 */
**************************************
*generate lag values
sort id year
local varlist ltbankdebttotliab stbankdebttotliab cashstitotalassets bankdebt
foreach var of local varlist{
by id:gen lag`var'=L.`var'
}

**************************************
/*     Leverage Variables           */
**************************************
* Total liabilities to total assets
sort id year
by id:gen lagTOTdebt=L.defltotliabforc
gen ln_lagTOTdebt=ln(lagTOTdebt)

gen leverage=lagTOTdebt/lagdefltotasstforc
gen llev=ln(leverage)

sum leverage,detail

gen lev=totliab/totasst
by id:gen laglev=L.lev

* short-term liabilities to short-term total assets
gen shortlev=shortliab/shortasst
sum shortlev,detail

gen lshortlev=ln(shortlev)
sort id year
by id:gen laglshortlev=L.lshortlev
by id:gen lagshortlev=L.shortlev

* Log assets
gen ln_ass=ln(defltotasstforc)
by id:gen lag_ln_ass=L.ln_ass

* Other forms of external finance
sort id year
by id:gen lagbond=L.ext_bond_issuance 
by id:gen lagloan=L.ext_loan_issuance
by id:gen lagequity=L.ext_equity_issuance

**************************************
/*    Investment                   */
**************************************
*** MEASURES OF INVESTMENT:
* inv_lagass
* gK
* capex
*based on capex_ppenetlag
sort id year
*by id:gen lagdeflppe_netforc=L.deflppe_netforc

gen capex_ppe1=deflcapexforc/lagdeflppe_netforc

sum capex_ppe1,detail

tempvar temph templ 
_pctile capex_ppe1, percentiles(1 99)
scalar `templ'=r(r1)
scalar `temph'=r(r2)
replace capex_ppe1=`templ' if capex_ppe1<`templ' & capex_ppe1!=. /*459*/
replace capex_ppe1=`temph' if capex_ppe1>`temph' & capex_ppe1!=. /*459*/

sum capex_ppe1,detail


*gen lcapex_ppe1=ln(capex_ppe1)

** dividing by total assets
sort id year
*by id:gen lagdefltotasstforc=L.defltotasstforc
gen capex_asst=deflcapexforc/lagdefltotasstforc

sum capex_asst,detail

tempvar temph templ 
_pctile capex_asst, percentiles(1 99)
scalar `templ'=r(r1)
scalar `temph'=r(r2)
replace capex_asst=`templ' if capex_asst<`templ' & capex_asst!=. /*459*/
replace capex_asst=`temph' if capex_asst>`temph' & capex_asst!=. /*459*/

sum capex_asst,detail


*gen lcapex_asst=ln(capex_asst)


sum inv_lagass gK capex_asst ,detail


**************************************
/*     Defining the Crisis Episodes   */
**************************************
/***Banking crisis**/
gen BC=0
replace BC=1 if (country==1 & year==2001) | (country==1 & year ==1995) | (country==5 & year==1994) | (country==2 & year==1995) | (country==4 & year==1998) | (country==6 & year==1999)

/**Banking crisis without currency crisis**/
gen BCnoC=0
replace BCnoC=1 if (country==1 & year ==1995) | (country==2 & year==1995) | (country==4 & year==1998) | (country==6 & year==1999)

/**Banking crisis Colombia and Peru**/
gen BCPC=0
replace BCPC=1 if  (country==4 & year==1998) | (country==6 & year==1999)

/*POST*/
gen post=0
replace post=1 if (country==1 & (year==2002 | year==2003)) | (country==2 & (year==1999 | year==2000)) | (country==5 & (year==1995| year==1996))

/*POSTBR: Both Twin and Currency Crises*/
gen postBR=0
replace postBR=1 if (country==1 & (year==2002 | year==2003)) | (country==2 & (year==1999 | year==2000)) | (country==2 & (year==2002 | year==2003))| (country==5 & (year==1995| year==1996))

gen posttot=0
replace posttot=1 if (country==1 & (year==2002 | year==2003)) | (country==2 & (year==1999 | year==2000)) | (country==2 & (year==2002 | year==2003))| (country==5 & (year==1994| year==1995))


/*POST only Argentina and Mexico: Twin Crises*/
gen postAM=0
replace postAM=1 if (country==1 & (year==2002 | year==2003)) | (country==5 & (year==1995| year==1996))

/*POST only Argentina and Mexico: Twin Crises*/
gen postAM2=0
replace postAM2=1 if (country==1 & (year==2002 | year==2003)) | (country==5 & (year==1994| year==1995))


/*POSTBR2: Currency Crises*/
gen postBR2=0
replace postBR2=1 if (country==2 & (year==1999 | year==2000)) | (country==2 & (year==2002 | year==2003))

gen postBR98=0
replace postBR98=1 if country==2 & (year==1999 | year==2000)

gen postBR02=0
replace postBR02=1 if country==2 & (year==2002 | year==2003)


**************************************
/*    POST Variables                */
**************************************
*foreign and exports based on CURRENT values
local varlist "ln_forult lforultdum50 dumfor50t shX exportert exp10t "
foreach var of local varlist{
gen `var'pBR=`var'*postBR
gen `var'pBR2=`var'*postBR2
gen `var'pAM=`var'*postAM
gen `var'pBR98=`var'*postBR98
gen `var'pBR02=`var'*postBR02
gen `var'gq=`var'*gq
gen `var'pAM2=`var'*postAM2
gen `var'ptot=`var'*posttot
}


*foreign and exports based on LAGGED values
local varlist "ln_lagforult ln_lagforultdum50 dumfor50 dumfor10 dumfor60 dumfor90 lagshX exporter exp10 "
foreach var of local varlist{
gen `var'pBR=`var'*postBR
gen `var'pBR2=`var'*postBR2
gen `var'pAM=`var'*postAM
gen `var'pBR98=`var'*postBR98
gen `var'pBR02=`var'*postBR02
gen `var'gq=`var'*gq
gen `var'pAM2=`var'*postAM2
gen `var'ptot=`var'*posttot
}

*bank variables
local varlist "lagltbankdebttotliab lagstbankdebttotliab lagcashstitotalassets"
foreach var of local varlist{
gen `var'pBR=`var'*postBR
gen `var'pBR2=`var'*postBR2
gen `var'pAM=`var'*postAM
gen `var'pBR98=`var'*postBR98
gen `var'pBR02=`var'*postBR02
gen `var'gq=`var'*gq
gen `var'pAM2=`var'*postAM2
gen `var'ptot=`var'*posttot
}

*dollar debt variables
local varlist "lagshDshD"
foreach var of local varlist{
gen `var'pBR=`var'*postBR
gen `var'pBR2=`var'*postBR2
gen `var'pAM=`var'*postAM
gen `var'pBR98=`var'*postBR98
gen `var'pBR02=`var'*postBR02
gen `var'gq=`var'*gq
gen `var'pAM2=`var'*postAM2
gen `var'ptot=`var'*posttot
}


**************************************
/*  PREDETERMINED Variables         */
**************************************
/*Predetermined three years before the crisis*/
*Agentina start crisis (banking): 2001
*Mexico start crisis (banking): 1994
*Brazil start crisis (currency): 1999
*Colombia start crisis (banking): 1998

*predetermined exporter
gen preexportercountry=0
replace preexportercountry=1 if shX>0 & shX~=. & country==1 & ( year==1998 | year==1999 | year==2000)
replace preexportercountry=1 if shX>0 & shX~=. & country==2 & ( year==1996 | year==1997 | year==1998)
replace preexportercountry=1 if shX>0 & shX~=. & country==3  
replace preexportercountry=1 if shX>0 & shX~=. & country==4 & (year==1995 | year==1996 | year==1997 )
replace preexportercountry=1 if shX>0 & shX~=. & country==5 & (year==1991 | year==1992 | year==1993)
replace preexportercountry=1 if shX>0 & shX~=. & country==6

replace preexportercountry=. if shX==. & country==1 & ( year==1998 | year==1999 | year==2000)
replace preexportercountry=. if shX==. & country==2 & ( year==1996 | year==1997 | year==1998)
replace preexportercountry=. if shX==. & country==3  
replace preexportercountry=. if shX==. & country==4 & (year==1995 | year==1996 | year==1997 )
replace preexportercountry=. if shX==. & country==5 & (year==1991 | year==1992 | year==1993)
replace preexportercountry=. if shX==. & country==6

sort id year
by id:egen predexp=max(preexportercountry)

gen predexppostBR=predexp*postBR
gen predexppostBR2=predexp*postBR2
gen predexppostAM=predexp*postAM
gen predexppostBR98=predexp*postBR98
gen predexppostBR02=predexp*postBR02
gen predexppostAM2=predexp*postAM2
gen predexpposttot=predexp*posttot

*predetermined high exporter
* more than 1 percent of export revenue
gen preexporter10country=0
replace preexporter10country=1 if shX>0.01 & shX~=. & country==1 & ( year==1998 | year==1999 | year==2000)
replace preexporter10country=1 if shX>0.01 & shX~=. & country==2 & ( year==1996 | year==1997 | year==1998)
replace preexporter10country=1 if shX>0.01 & shX~=. & country==3  
replace preexporter10country=1 if shX>0.01 & shX~=. & country==4 & (year==1995 | year==1996 | year==1997 )
replace preexporter10country=1 if shX>0.01 & shX~=. & country==5 & (year==1991 | year==1992 | year==1993)
replace preexporter10country=1 if shX>0.01 & shX~=. & country==6

replace preexporter10country=. if shX==. & country==1 & ( year==1998 | year==1999 | year==2000)
replace preexporter10country=. if shX==. & country==2 & ( year==1996 | year==1997 | year==1998)
replace preexporter10country=. if shX==. & country==3  
replace preexporter10country=. if shX==. & country==4 & (year==1995 | year==1996 | year==1997 )
replace preexporter10country=. if shX==. & country==5 & (year==1991 | year==1992 | year==1993)
replace preexporter10country=. if shX==. & country==6


sort id year
by id:egen predexp10=max(preexporter10country)

gen predexp10postBR=predexp10*postBR
gen predexp10postBR2=predexp10*postBR2
gen predexp10postAM=predexp10*postAM
gen predexp10postAM2=predexp10*postAM2
gen predexp10posttot=predexp10*posttot


*predetermined foreign10
gen preforcountry10=0
replace preforcountry10=1 if (forult>10 & forult~=.) & country==1 & ( year==1998 | year==1999 | year==2000)
replace preforcountry10=1 if (forult>10 & forult~=.) & country==2 & ( year==1996 | year==1997 | year==1998)
replace preforcountry10=1 if (forult>10 & forult~=.) & country==3  
replace preforcountry10=1 if (forult>10 & forult~=.) & country==4 & (year==1995 | year==1996 | year==1997 )
replace preforcountry10=1 if (forult>10 & forult~=.) & country==5 & (year==1991 | year==1992 | year==1993)
replace preforcountry10=1 if (forult>10 & forult~=.) & country==6

replace preforcountry10=. if forult==.

sort id year
by id:egen predfor10=max(preforcountry10)

gen predfor10postBR=predfor10*postBR
gen predfor10postBR2=predfor10*postBR2
gen predfor10postAM=predfor10*postAM
gen predfor10postBR98=predfor10*postBR98
gen predfor10postBR02=predfor10*postBR02
gen predfor10postAM2=predfor10*postAM2
gen predfor10posttot=predfor10*posttot


*predetermined foreign
gen preforcountry=0
replace preforcountry=1 if (forult>50 & forult~=.) & country==1 & ( year==1998 | year==1999 | year==2000)
replace preforcountry=1 if (forult>50 & forult~=.) & country==2 & ( year==1996 | year==1997 | year==1998)
replace preforcountry=1 if (forult>50 & forult~=.) & country==3  
replace preforcountry=1 if (forult>50 & forult~=.) & country==4 & (year==1995 | year==1996 | year==1997 )
replace preforcountry=1 if (forult>50 & forult~=.) & country==5 & (year==1991 | year==1992 | year==1993)
replace preforcountry=1 if (forult>50 & forult~=.) & country==6

replace preforcountry=. if forult==.

sort id year
by id:egen predfor=max(preforcountry)

gen predforpostBR=predfor*postBR
gen predforpostBR2=predfor*postBR2
gen predforpostAM=predfor*postAM
gen predforpostBR98=predfor*postBR98
gen predforpostBR02=predfor*postBR02
gen predforpostAM2=predfor*postAM2
gen predforposttot=predfor*posttot


*predetermined DD
gen preDDcountry=0
replace preDDcountry=1 if (shDshD>0 & shDshD~=.) & country==1 & ( year==1998 | year==1999 | year==2000)
replace preDDcountry=1 if (shDshD>0 & shDshD~=.) & country==2 & ( year==1996 | year==1997 | year==1998)
replace preDDcountry=1 if (shDshD>0 & shDshD~=.) & country==3  
replace preDDcountry=1 if (shDshD>0 & shDshD~=.) & country==4 & (year==1995 | year==1996 | year==1997 )
replace preDDcountry=1 if (shDshD>0 & shDshD~=.) & country==5 & (year==1991 | year==1992 | year==1993)
replace preDDcountry=1 if (shDshD>0 & shDshD~=.) & country==6

replace preDDcountry=. if shDshD==.

sort id year
by id:egen predDD=max(preDDcountry)

gen predDDpostBR=predDD*postBR
gen predDDpostBR2=predDD*postBR2
gen predDDpostAM=predDD*postAM
gen predDDpostBR98=predDD*postBR98
gen predDDpostBR02=predDD*postBR02
gen predDDpostAM2=predDD*postAM2
gen predDDposttot=predDD*posttot


*predetermined DD
* median in sample of those holding DD 0.32
gen preDD39country=0
replace preDD39country=1 if (shDshD>0.32 & shDshD~=.) & country==1 & ( year==1998 | year==1999 | year==2000)
replace preDD39country=1 if (shDshD>0.32 & shDshD~=.) & country==2 & ( year==1996 | year==1997 | year==1998)
replace preDD39country=1 if (shDshD>0.32 & shDshD~=.) & country==3  
replace preDD39country=1 if (shDshD>0.32 & shDshD~=.) & country==4 & (year==1995 | year==1996 | year==1997 )
replace preDD39country=1 if (shDshD>0.32 & shDshD~=.) & country==5 & (year==1991 | year==1992 | year==1993)
replace preDD39country=1 if (shDshD>0.32 & shDshD~=.) & country==6

replace preDD39country=. if shDshD==.

sort id year
by id:egen predDD39=max(preDD39country)

gen predDD39postBR=predDD39*postBR
gen predDD39postBR2=predDD39*postBR2
gen predDD39postAM=predDD39*postAM
gen predDD39postBR98=predDD39*postBR98
gen predDD39postBR02=predDD39*postBR02
gen predDD39postAM2=predDD39*postAM2
gen predDD39posttot=predDD39*posttot


**************************************
/*     Sector Variables             */
**************************************
/*Generate Traded- Non-Traded Sector variable*/
gen tradedsec=0
replace tradedsec=1 if isic_2==12 |isic_2==13 |isic_2==21 |isic_2==22 |isic_2==23 | /*
                      */ isic_2==29 | isic_2==30 |isic_2==31 |isic_2==32 | isic_2==33 | /*
					  */ isic_2==34 | isic_2==35 |isic_2==36 |isic_2==37 |isic_2==38 | /*
					  */ isic_2==39 | isic_2==50 
                   

/*Generate sector year fixed effects*/
egen concatisic1year=concat(year isic_1)
egen isic1year=group(concatisic1year)

egen concatisic2year=concat(year isic_2)
egen isic2year=group(concatisic2year)

/*Generate country year fixed effects*/
egen concatcountyear=concat(country year)
egen countyear=group(concatcountyear)


rename isic_1 isic1



**************************************
/*    DOUBLE AND TRIPLE INTERACTIONS */
**************************************
set more off
local varlist1 "lagshDshD ln_forult dumfor50t shX exportert exp10t  dumfor50 dumfor10 dumfor60 dumfor90 lagshX exporter exp10 predexp predexp10 predfor predDD39"
local varlist2 "lagshDshD ln_forult lforultdum50 dumfor50t shX exportert exp10t ln_lagforult ln_lagforultdum50 dumfor50 dumfor10 dumfor60 dumfor90 lagshX exporter exp10 predexp predexp10 predfor predDD39"
foreach var1 of local varlist1{
foreach var2 of local varlist2{
gen `var1'`var2'=`var1'*`var2'

gen `var1'`var2'gqav=`var1'`var2'*gqav
gen `var1'`var2'post=`var1'`var2'*post
gen `var1'`var2'pBR=`var1'`var2'*postBR
gen `var1'`var2'pBR2=`var1'`var2'*postBR2
gen `var1'`var2'pAM=`var1'`var2'*postAM
gen `var1'`var2'pBR98=`var1'`var2'*postBR98
gen `var1'`var2'pBR02=`var1'`var2'*postBR02
gen `var1'`var2'gq=`var1'`var2'*gq
}
}


*************************************************************************
*************************************************************************
***** Table 5: Exports and Financial Crises: Blance Sheet Channel   *****
*************************************************************************
*************************************************************************
gen predexp10pAM=predexp10*postAM
gen predexp10pBR2=predexp10*postBR2
gen predexp10pBR=predexp10*postBR
gen predDD39pBR2=predDD39*postBR2
gen predDD39pAM=predDD39*postAM
gen predDD39pBR=predDD39*postBR

gen predforpAM=predfor*postAM
gen predforpBR2=predfor*postBR2


/***********************************************************/
*** TABLE 5: triple interaction
*** sample: Argentina, Mexico and Brazil
*** cluster: firm id
/***********************************************************/
local varlist inv_lagass 
foreach var of local varlist{
* twin
xi:reghdfe  `var' predDD39predforpAM  predDD39pAM  ///
         lagbond lagloan lagequity  laglev    /*
         */ i.predfor*i.year  if  predexp10==1 & (country==1 | country==2 | country==5),absorb(id year countyear isic1year) vce(cluster id#year)
estimates store m1, title(Balance-Country)
test  predDD39pAM predDD39predforpAM
estadd scalar p_test2 = r(p)
* currency
xi:reghdfe  `var' predDD39predforpBR2   predDD39pBR2    ///
		lagbond lagloan lagequity  laglev    /*
         */ i.predfor*i.year  if  predexp10==1 & (country==1 | country==2 | country==5),absorb(id year countyear isic1year) vce(cluster id#year)
estimates store m2, title(Balance-Country)
test  predDD39pBR2 predDD39predforpBR2
estadd scalar p_test2 = r(p)

* controlling for foreign*year
xi:reghdfe  `var' predDD39predforpAM  predDD39pAM  ///
         predDD39predforpBR2   predDD39pBR2    ///
		lagbond lagloan lagequity  laglev   /*
         */ i.predfor*i.year  if  predexp10==1 & (country==1 | country==2 | country==5),absorb(id year countyear isic1year) vce(cluster id#year)
estimates store m3, title(Balance-Country)
test  predDD39predforpAM predDD39predforpBR2
estadd scalar p_test = r(p)
test  predDD39pAM predDD39pBR2 predDD39predforpAM predDD39predforpBR2
estadd scalar p_test2 = r(p)


esttab m1 m2 m3  using Table5.csv, ///
     cell(b(fmt(3) star)  se(par fmt(2))) ///
	 starlevel(* 0.10 ** 0.05 *** 0.001) ///
	 drop(_I* o.*) scalars(N_g p_test p_test2 ) ///
	 title(“The Effect of on Outcome during Crises”) replace 

}

/**************************************************************/
/*    TABLE 6:     ROBUSTNESS ALTERNATIVE CHANNELS            */
/**************************************************************/
* leverage based on bank debt
gen stbd=stbankdebttotliab*totliab
gen stbdstliab=stbd/shortliab
replace stbdstliab=1 if stbdstliab>1 & stbdstliab!=.

sort id year
by id:gen lagstbdstliab=L.stbdstliab
gen lagstbdstliabpAM=lagstbdstliab*postAM
gen lagstbdstliabpBR2=lagstbdstliab*postBR2
gen laglevpAM=laglev*postAM

* dollar assets
* 75 percentile of the distribution of those holding DA
*predetermined DA based on whether the company has dollar assets or not
gen preDAcountry=0
replace preDAcountry=1 if (DA>0.11 & DA~=.) & country==1 & ( year==1998 | year==1999 | year==2000)
replace preDAcountry=1 if (DA>0.11 & DA~=.) & country==2 & ( year==1996 | year==1997 | year==1998)
replace preDAcountry=1 if (DA>0.11 & DA~=.) & country==3  
replace preDAcountry=1 if (DA>0.11 & DA~=.) & country==4 & (year==1995 | year==1996 | year==1997 )
replace preDAcountry=1 if (DA>0.11 & DA~=.) & country==5 & (year==1991 | year==1992 | year==1993)
replace preDAcountry=1 if (DA>0.11 & DA~=.) & country==6

replace preDAcountry=. if DA==.

sort id year
by id:egen predDA=max(preDAcountry)

gen predDApostBR=predDA*postBR
gen predDApostBR2=predDA*postBR2
gen predDApostAM=predDA*postAM
gen predDApostBR98=predDA*postBR98
gen predDApostBR02=predDA*postBR02
gen predDApostAM2=predDA*postAM2
gen predDAposttot=predDA*posttot


gen predDApredforpAM=predDA*predfor*postAM
gen predDApredfor=predDA*predfor
gen predDApAM=predDA*postAM

gen predDApredforpBR2=predDA*predfor*postBR2
gen predDApBR2=predDA*postBR2


*cash
rename cashstitotalassets cashasst
* 75 percentile value
gen precashcountry=0
replace precashcountry=1 if (cashasst>0.1 & cashasst~=.) & country==1 & ( year==1998 | year==1999 | year==2000)
replace precashcountry=1 if (cashasst>0.1 & cashasst~=.) & country==2 & ( year==1996 | year==1997 | year==1998)
replace precashcountry=1 if (cashasst>0.1 & cashasst~=.) & country==3  
replace precashcountry=1 if (cashasst>0.1 & cashasst~=.) & country==4 & (year==1995 | year==1996 | year==1997 )
replace precashcountry=1 if (cashasst>0.1 & cashasst~=.) & country==5 & (year==1991 | year==1992 | year==1993)
replace precashcountry=1 if (cashasst>0.1 & cashasst~=.) & country==6

replace precashcountry=. if cashasst==.

sort id year
by id:egen predcash=max(precashcountry)

gen predcashpostBR=predcash*postBR
gen predcashpostBR2=predcash*postBR2
gen predcashpostAM=predcash*postAM
gen predcashpostBR98=predcash*postBR98
gen predcashpostBR02=predcash*postBR02
gen predcashpostAM2=predcash*postAM2
gen predcashposttot=predcash*posttot


gen predcashpredforpAM=predcash*predfor*postAM
gen predcashpredfor=predcash*predfor
gen predcashpAM=predcash*postAM

gen predcashpredforpBR2=predcash*predfor*postBR2
gen predcashpBR2=predcash*postBR2


* post values of dummy bond
gen lagbondpAM=lagbond*postAM
gen lagloanpAM=lagloan*postAM
gen lagequitypAM=lagequity*postAM


** Robustness
*other measures of leverage:short bank debt to total liabilities
xi:reghdfe  inv_lagass  predDD39predforpAM  predDD39pAM  ///
        lagbond lagloan lagequity  lagstbdstliab lagstbdstliabpAM   /*
         */ i.predfor*i.year  if  predexp10==1 & (country==1 | country==2 | country==5),absorb(id year countyear isic1year) vce(cluster id#year)
estimates store m1, title(Balance-Country)
estadd scalar p_test = r(p)

*Dollar Assets
xi:reghdfe inv_lagass  predDD39predforpAM  predDD39pAM  ///
         predDApredforpAM predDApAM ///
         lagbond lagloan lagequity  laglev     /*
         */ i.predfor*i.year  if  predexp10==1 & ( country==1 | country==2 | country==5),absorb(id year countyear isic1year) vce(cluster id#year)
estimates store m2, title(Balance-Country)
estadd scalar p_test = r(p)

*Cash Assets
xi:reghdfe  inv_lagass predDD39predforpAM  predDD39pAM ///
         predcashpredforpAM  predcashpAM ///
        lagbond lagloan lagequity  laglev      /*
         */ i.predfor*i.year  if  predexp10==1 & (country==1 | country==2 | country==5),absorb(id year countyear isic1year) vce(cluster id#year)
estimates store m3, title(Balance-Country)
estadd scalar p_test = r(p)

*controlling for post values
xi:reghdfe inv_lagass  predDD39predforpAM  predDD39pAM  ///
         lagbond lagloan lagequity lagbondpAM lagloanpAM lagequitypAM laglev laglevpAM  ///
		  i.predfor*i.year  if  predexp10==1 & (country==1 | country==2 | country==5),absorb(id year countyear isic1year) vce(cluster id#year)
estimates store m4, title(Balance-Country)
estadd scalar p_test = r(p)


esttab m1 m2 m3 m4  using Table6.csv, ///
     cell(b(fmt(3) star)  se(par fmt(2))) ///
	 starlevel(* 0.10 ** 0.05 *** 0.001) ///
	 drop(_I* o.*) scalars(N_g p_test p_test2 ) ///
	 title(“The Effect of on Outcome during Crises”) replace 



/**************************************************************/
/*    TABLE 7:     ROBUSTNESS EXPORTS                         */
/**************************************************************/
*** differential product market exposure 
*** generate export shares prior to the crisis
bys id:egen pre_shX=mean(shX) if (country==1 & ( year==1998 | year==1999 | year==2000)) | ///
                                   (country==2 & ( year==1996 | year==1997 | year==1998)) | ///
                                   (country==5 & (year==1991 | year==1992 | year==1993))

bys id:egen maxpre_shX=max(pre_shX)

gen maxpre_shXpredforpAM=maxpre_shX*predfor*postAM
gen maxpre_shXpAM = maxpre_shX*postAM
gen maxpre_shXpredfor=maxpre_shX*predfor


set more off
** sample: high exp and high DD
xi:reghdfe inv_lagass maxpre_shXpredforpAM    ///
          maxpre_shXpAM  ///
		lagbond lagloan lagequity  laglev   /*
         */ i.predfor*i.year  if  predexp10==1 & predDD39==1 & (country==2 | country==1  | country==5),absorb(id year countyear isic1year) vce(cluster id#year)
estimates store m1, title(Balance-Country)
** sample: high exporter sample
xi:reghdfe inv_lagass maxpre_shXpredforpAM  maxpre_shXpredfor  ///
          maxpre_shXpAM ///
		lagbond lagloan lagequity  laglev   /*
         */ i.predfor*i.year  if  predexp10==1 & (country==2  | country==1  | country==5),absorb(id year countyear isic1year) vce(cluster id#year)
estimates store m2, title(Balance-Country)
** sample: high exporter sample controlling for debt
xi:reghdfe inv_lagass maxpre_shXpredforpAM predDD39predforpAM   /// maxpre_shXpredforpAM  maxpre_shXpredfor  ///
          maxpre_shXpAM  predDD39pAM ///
		lagbond lagloan lagequity  laglev   /*
         */ i.predfor*i.year  if  predexp10==1 & (country==2  |country==1  | country==5),absorb(id year countyear isic1year) vce(cluster id#year)
estimates store m3, title(Balance-Country)


esttab m1 m2 m3 using Table7.csv, ///
     cell(b(fmt(3) star)  se(par fmt(2))) ///
	 starlevel(* 0.10 ** 0.05 *** 0.001) ///
	 drop(_I* o.*) scalars(N_g p_test p_test2 ) ///
	 title(“The Effect of on Outcome during Crises”) replace 
		 
	
/**************************************************************/
/*    TABLE 8:     PLACEBO TEST                               */
/**************************************************************/	
gen post_pl94=0
replace post_pl94=1 if year==1994
gen post_pl93=0
replace post_pl93=1 if year==1993
gen post_pl92=0
replace post_pl92=1 if year==1992
gen post_pl91=0
replace post_pl91=1 if year==1991
gen post_pl9293=0
replace post_pl9293=1 if year==1993 | year==1992
gen post_pl9394=0
replace post_pl9394=1 if year==1993 | year==1994
gen post_pl929394=0
replace post_pl929394=1 if year==1992 | year==1993 | year==1994

local varlist post_pl929394 post_pl94 post_pl93 post_pl92 post_pl91 post_pl9293 post_pl9394
foreach var of local varlist{
gen predfor_`var'=predfor*`var'
gen predDD_`var'=predDD39*`var'
gen preDDprefor_`var'=predDD39*predfor*`var'

}


*** Check if we would identify differences if these were the crisis years
* 1994
xi:reghdfe inv_lagass preDDprefor_post_pl94  predDD_post_pl94  ///
         lagbond lagloan lagequity  laglev    /*
         */ i.predfor*i.year  if  predexp10==1 & (country==1 | country==2 | country==5),absorb(id year countyear isic1year) vce(cluster id#year)
estimates store m1, title(Balance-Country)

* 1993
xi:reghdfe inv_lagass  preDDprefor_post_pl93  predDD_post_pl93  ///
         lagbond lagloan lagequity  laglev    /*
         */ i.predfor*i.year  if  predexp10==1 & (country==1 | country==2 | country==5),absorb(id year countyear isic1year) vce(cluster id#year)
estimates store m2, title(Balance-Country)

* 1992 and 1993
xi:reghdfe inv_lagass  preDDprefor_post_pl9293 predDD_post_pl9293  ///
         lagbond lagloan lagequity  laglev    /*
         */ i.predfor*i.year  if  predexp10==1 & (country==1 | country==2 | country==5),absorb(id year countyear isic1year) vce(cluster id#year)
estimates store m3, title(Balance-Country)

* 1992 & 1993 & 1994
xi:reghdfe inv_lagass  preDDprefor_post_pl929394  predDD_post_pl929394  ///
         lagbond lagloan lagequity  laglev    /*
         */ i.predfor*i.year  if  predexp10==1 & (country==1 | country==2 | country==5),absorb(id year countyear isic1year) vce(cluster id#year)
estimates store m4, title(Balance-Country)


esttab m1 m2 m3 m4 using Table8.csv, ///
     cell(b(fmt(3) star)  se(par fmt(2))) ///
	 starlevel(* 0.10 ** 0.05 *** 0.001) ///
	 drop(_I* o.*) scalars(N_g p_test p_test2 ) ///
	 title(“The Effect of on Outcome during Crises”) replace 

	
			
/**************************************************************/
/*    TABLE 9:     DOLLAR DEBT DIFFERENCES                    */
/**************************************************************/	
** differences in dollar debt holdings between foreign and domestic exporters prior to the 
** crisis
* Mexico
xi:reghdfe shDshD dumfor50  ///
         lagbond lagloan lagequity  laglev    /*
         */ i.year  if  predexp10==1 & (country==5) & year<1995,absorb(id year countyear isic1year) vce(cluster id#year)
estimates store m1, title(Balance-Country)
* Brazil
xi:reghdfe shDshD dumfor50 ///
         lagbond lagloan lagequity  laglev    /*
         */ i.year  if  predexp10==1 & (country==2) & year<1999,absorb(id year countyear isic1year) vce(cluster id#year)
estimates store m2, title(Balance-Country)
* Argentina
xi:reghdfe shDshD dumfor50  ///
         lagbond lagloan lagequity  laglev    /*
         */ i.year  if  predexp10==1 & (country==1) & year<2001,absorb(id year countyear isic1year) vce(cluster id#year)
estimates store m3, title(Balance-Country)


esttab m1 m2 m3  using Table9.csv, ///
     cell(b(fmt(3) star)  se(par fmt(2))) ///
	 starlevel(* 0.10 ** 0.05 *** 0.001) ///
	 drop(_I* o.*) scalars(N_g p_test p_test2 ) ///
	 title(“The Effect of on Outcome during Crises”) replace 
	

	