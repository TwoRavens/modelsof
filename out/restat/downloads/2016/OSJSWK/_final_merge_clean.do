


use Final_Dataset_1992_2007_dec2015.dta,clear

/////////////////////////////////////////////////////////////
*** 1. Deflate and transform the VARIABLES
/////////////////////////////////////////////////////////////
/*Deflate to local currency of year 2000 and then convert to dollars using
the end of the period exchange rate*/
gen ER2000=ER if year==2000
bys country:egen ER2000max=max(ER2000)
drop ER2000 
rename ER2000max ER2000



local varlist totasst totdolliab totdolasst totliab shortliab longliab shortdolliab longdolliab shortasst longasst longdolasst shortdolasst exports sales capex ppe_net
foreach var of local varlist {
gen defl`var'forc=((`var'/CPI)*100)*(1/ER2000)
}


///////////////////////////////////////////////////////////////
////// 2. CLEANING STEPS          /////////////////////////////
///////////////////////////////////////////////////////////////
******************************************
/**    2a. Basic reporting mistakes **/
******************************************
** Sales and Assets
drop if (deflsalesforc==0 ) 
drop if (defltotasstforc==0 ) 

** Share of dollar liabilities
gen DD=defltotdolliabforc/defltotliabforc
drop if DD>1 & DD!=. 

** Share of dollar assets
gen DA=defltotdolasstforc/defltotasstforc
drop if DA>1 & DA!=. 

** Share of short dollar liabilities over total debt
drop if deflshortdolliabforc<0 & deflshortdolliabforc!=. 

gen shDD=deflshortdolliabforc/defltotliabforc
drop if shDD>1 & shDD!=. 

** Share of short dollar liabilities over short debt
gen shDshD=deflshortdolliabforc/deflshortliabforc
drop if shDshD>1 & shDshD!=. 

** Long-term dollar debt over total dollar debt
gen lonDD=longdolliab/totliab
drop if lonDD<0 & lonDD~=. 
drop if lonDD>1 & lonDD~=. 

** Long term dollar liability over long term liability
gen lonDlonD=longdolliab/longliab
drop if lonDlonD>1 & lonDlonD~=. 

** Bank data
*  negative value of stbankdebttotliab
drop if stbankdebttotliab<0 & stbankdebttotliab!=.
*  negative cash
drop  if cashstitotalassets<0 & cashstitotalassets!=.
*  cash to asset ratio  
drop  if cashstitotalassets>1 & cashstitotalassets~=.
*  total bank debt: long plus short
gen bankdebt=ltbankdebttotliab+stbankdebttotliab
drop if bankdebt>1 & bankdebt!=. 

** Share of exports
gen shx=deflexportsforc/deflsalesforc
sum shx,detail
drop if shx>1 & shx!=.  
rename shx shX

** Sector classification
drop if isic_1==. | isic_1==0 

**************************************
/**    2b. Basic Ratios **/
**************************************
** Ratio of sales to assets
gen salesasset=deflsalesforc/defltotasstforc

bys country year:egen SAp99=pctile(salesasset),p(99)
bys country year:egen SAp1=pctile(salesasset),p(1)
drop if salesasset>SAp99 & salesasset!=. 
drop if salesasset<SAp1 & salesasset!=. 
drop SAp99 SAp1 salesasset

** Ratio of liabilities to total assets
gen debtasset=defltotliabforc/defltotasstforc
drop if debtasset>1 & debtasset!=.

bys country year:egen DAp99=pctile(debtasset),p(99)
bys country year:egen DAp1=pctile(debtasset),p(1)
drop if debtasset>DAp99 & debtasset!=. 
drop if debtasset<DAp1 & debtasset!=. 
drop debtasset DAp99 DAp1


*Compute the z-score for assets
xtset id year

gen ln_totasst=ln(defltotasstforc) 
bys id:gen lagdefltotasst=L.defltotasstforc
gen ln_lagtotasst=ln(lagdefltotasst)
gen gtotasst=ln_totasst-ln_lagtotasst

bys country year:egen zmeanass=mean(gtotasst)
bys country year:egen zsdass=sd(gtotasst)

gen zass=(gtotasst-zmeanass)/zsdass
gen zabsass=abs(zass)
drop if zabsass>5 & zabsass~=.
drop zabsass

*Compute Z-score for sales
sort id year
bys id:gen lagdeflsalesforc=L.deflsalesforc
gen ln_sales=ln(deflsalesforc)
gen ln_lagsales=ln(lagdeflsalesforc)
gen gsales=ln_sales-ln_lagsales

sort country year
by country year:egen zmeansal=mean(gsales)
by country year:egen zsdsal=sd(gsales)

gen zsal=(gsales-zmeansal)/zsdsal
gen zabssal=abs(zsal)
drop if zabssal>5 & zabssal~=.
drop zabssal


**************************************
/**    2c. Investment Variable **/
**************************************
*Capital Stock Growth Rate
sort id year
by id:gen  lagdeflppe_netforc=L.deflppe_netforc
gen gK= (deflppe_netforc-lagdeflppe_netforc)/lagdeflppe_netforc

*Investment over Assets
gen inv= deflppe_netforc-lagdeflppe_netforc
gen invasst=inv/defltotasstforc 
sort id year 
by id:gen laginvasst=L.invasst
gen ginvasst=(invasst-laginvasst)/laginvasst

*Compute the z-score for capital stock growth rate
sort country year
by country year:egen zmean=mean(gK)
by country year:egen zsd=sd(gK)

gen z=(gK-zmean)/zsd
gen zabs=abs(z)
count if zabs>5 & zabs~=. 
drop if zabs>5 & zabs~=.
drop zabs


*Investment over lagged assets
sort id year
by id:gen lagdefltotasstforc=L.defltotasstforc
gen inv_lagass=inv/lagdefltotasstforc

sum inv_lagass,detail



** WINSORIZE VALUE OF MAIN VARIABLES BY COUNTRY
local varlist "gK ginvasst invasst inv_lagass deflsalesforc defltotasstforc"
foreach var of local varlist{
    sort country year
	by country:egen lowerpctilevar=pctile(`var') if `var'!=. ,p(1)
	by country:egen maxpctilevar=pctile(`var') if `var'!=.,p(99) 
	replace `var'=lowerpctilevar if `var'<lowerpctilevar & `var'~=. 
	replace `var'=maxpctilevar if `var'>maxpctilevar & `var'~=.
	drop lowerpctilevar
	drop maxpctilevar
}


* Overall distribution of sales and assets
tempvar temph templ 
_pctile deflsalesforc if deflsalesforc!=., percentiles(1 99)
scalar `templ'=r(r1)
scalar `temph'=r(r2)
replace deflsalesforc=`templ' if deflsalesforc<`templ' & deflsalesforc!=.
replace deflsalesforc=`temph' if deflsalesforc>`temph' & deflsalesforc!=. 

tempvar temph templ 
_pctile defltotasstforc if defltotasstforc!=., percentiles(1 99)
scalar `templ'=r(r1)
scalar `temph'=r(r2)
replace defltotasstforc=`templ' if defltotasstforc<`templ' & defltotasstforc!=. 
replace defltotasstforc=`temph' if defltotasstforc>`temph' & defltotasstforc!=. 


drop lagdeflsalesforc ln_sales ln_lagsales gsales
sort id year
by id:gen lagdeflsalesforc=L.deflsalesforc
gen ln_sales=ln(deflsalesforc)
gen ln_lagsales=ln(lagdeflsalesforc)
gen gsales=ln_sales-ln_lagsales

*Total assets
drop lagdefltotasstforc gtotasst  ln_totasst  ln_lagtotasst
sort id year
by id:gen lagdefltotasstforc=L.defltotasstforc
gen ln_totasst=ln(defltotasstforc)
gen ln_lagtotasst=ln(lagdefltotasstforc)
gen gtotasst=ln_totasst-ln_lagtotasst

* capital expenditure as percentage of ppe_net
gen capex_ppe=deflcapexforc/deflppe_netforc

sum capex_ppe,detail

*winsorize 
local varlist "capex_ppe"
foreach var of local varlist{
sort country year
	by country:	egen lowerpctilevar=pctile(`var') ,p(2.5)
	by country: egen maxpctilevar=pctile(`var') ,p(97.5) 
	replace `var'=lowerpctilevar if `var'<lowerpctilevar & `var'~=. 
	replace `var'=maxpctilevar if `var'>maxpctilevar & `var'~=.
	drop lowerpctilevar
	drop maxpctilevar
}

sum capex_ppe,detail


* Drop some auxiliary variables generated
drop zmeanass zsdass zass zmeansal zsdsal zsal zmean zsd z


save "merged_clean_data_dec2015.dta",replace

  


