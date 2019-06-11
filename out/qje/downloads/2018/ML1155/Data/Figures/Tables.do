**************************************
*Replication files for "The Mission"
*Felipe Valencia Caicedo (2018)
*TABLES
**************************************

*Set directory


*Table I

*Literacy
*use Literacy Argentina Brazil Paraguay.dta
tabstat  literacy illiteracy, by (distmiss50) stat (n mea med sd min max) col(stat)

*Median Years of Schooling
*use Median Years of Schooling Brazil.dta
tabstat edumedyr, by (distmiss50) stat (n mea sd min max) col(stat)

*Income
*use Income Brazil Paraguay.dta
tabstat  lnincome, by (distmiss50) stat (n mea med sd min max) col(stat)

*Poverty
*use Poverty Argentina Paraguay.dta 
tabstat pnbiper , by (mission) stat (n mea sd min max) col(stat)

*Mission / Geographic Controls
*use Literacy Argentina Brazil Paraguay.dta
tabstat distmiss lati longi area tempe alti preci rugg slope river coast landlocked if lati!=., by (distmiss50) stat (n mea med sd min max) col(stat)


*Table II
*Literacy
*use Literacy Argentina Brazil Paraguay.dta

*Full
qui: reg illiteracy distmiss lati longi corr ita mis mis1, r
qui: outreg2 using TableII, append keep(distmiss)
qui: reg illiteracy distmiss lati longi area tempe alti preci rugg river coast corr ita mis mis1, r
qui: outreg2 using TableII, append keep(distmiss)

*Brazil
qui: reg illiteracy distmiss lati longi meso if country=="BRA", r
qui: outreg2 using TableII, append keep(distmiss)
qui: reg illiteracy distmiss lati longi area tempe alti preci rugg river coast meso if country=="BRA", r
qui: outreg2 using TableII, append keep(distmiss)

*Argentina
qui: reg illiteracy distmiss lati longi corr if country=="Argentina", r
qui: outreg2 using TableII, append keep(distmiss)
qui: reg illiteracy distmiss lati longi area tempe alti preci rugg river coast corr if country=="Argentina", r
qui: outreg2 using TableII, append keep(distmiss)

*Paraguay
qui: reg illiteracy distmiss ita if country=="Paraguay", r
qui: outreg2 using TableII, append keep(distmiss)
qui: reg illiteracy distmiss area tempe alti preci rugg river coast ita if country=="Paraguay", r
outreg2 using TableII, append keep(distmiss)
*Conley errors calculated using Conley Standard Errors.do
*Within R-squared calculated manually


*Table III

*Median Years of Schooling
*use Median Years of Schooling Brazil.dta
reg edumedyr distmiss meso lat1 long1 if rain!=., 
outreg2 using TableIII, append keep(distmiss)
reg edumedyr  distmiss lat1 long1 area river slope rugg alt tempe rain coast meso, r
outreg2 using TableIII, append keep(distmiss)

*Ln Income
*use Income Brazil Paraguay.dta
qui: reg lnincome distmiss lati longi  par,  r 
qui: outreg2 using TableIII, append keep(distmiss)
qui: reg lnincome distmiss lati longi area river slope rugg alti tempe preci landlocked coast par,  r 
qui: outreg2 using TableIII, append keep(distmiss)

*Poverty
*use Poverty Argentina Paraguay.dta 
qui: reg pnbiper distmiss lati lon par, r
qui: outreg2 using TableIII, append keep(distmiss)
qui: reg pnbiper distmiss  coast river alti tempe area preci lati lon par, r
outreg2 using TableIII, append keep(distmiss)
*Conley errors calculated using Conley Standard Errors.do
*Within R-squared calculated manually


*Table IV
*Literacy
*use Placebo Literacy Income.dta

qui: reg illiteracy distpar distfran lati longi area alti tempe  preci river rugg coast landlocked ita mis1 corr mis, r
qui: outreg2 using TableIV, append keep(distpar distgua distita distmiss)
qui: reg illiteracy distgua distfran lati longi area alti tempe  preci river rugg coast landlocked ita mis1 corr mis, r
qui: outreg2 using TableIV, append keep(distpar distgua distita distmiss)
qui: reg illiteracy distita distfran lati longi area alti tempe  preci river rugg coast landlocked ita mis1 corr mis, r
qui: outreg2 using TableIV, append keep(distpar distgua distita distmiss)
qui: reg illiteracy distpar distgua distita  lati longi par arg, r
qui: outreg2 using TableIV, append keep(distpar distgua distita distmiss)
qui: reg illiteracy distpar distgua distita distfran lati longi area alti tempe  preci river rugg coast landlocked ita mis1 corr mis, r
qui: outreg2 using TableIV, append keep(distpar distgua distita distmiss)
qui: reg illiteracy distpar distgua distita distmiss  lati longi mis1 mis corr ita, r
qui: outreg2 using TableIV, append keep(distpar distgua distita distmiss)
qui: reg illiteracy distpar distgua distita distfran distmiss lati longi area alti tempe  preci river rugg coast landlocked ita mis1 corr mis, r
outreg2 using TableIV, append keep(distpar distgua distita distmiss)
*Conley errors calculated using Conley Standard Errors.do
*Within R-squared calculated manually


*Table V
*Median Years of Schooling
*use Median Years of Schooling Brazil.dta
qui: reg edumedyr distita distpar distgua distfran long1 area temp alt rain tordist1 rugg river coast meso, r
qui: outreg2 using TableV, append keep(distpar distgua distita distmiss)
qui: reg edumedyr distita distpar distgua distfran distmiss long1 area temp alt rain tordist1 rugg river coast meso, r
qui: outreg2 using TableV, append keep(distpar distgua distita distmiss)

*Ln Income
*use Placebo Literacy Income.dta
qui: reg lnincome distita distpar distgua distfran lati longi area alt temp preci river rugg coast slope par, r
qui: outreg2 using TableV, append keep(distpar distgua distita distmiss)
qui: reg lnincome distita distpar distgua distmiss distfran lati longi area alt temp preci river rugg coast slope par, r
qui: outreg2 using TableV, append keep(distpar distgua distita distmiss)

*Poverty
*use Poverty Argentina Paraguay.dta 
qui: reg pnbiper distpar distgua distita distfran coast river alti tempe area preci rugg distord1 longi par, r
qui: outreg2 using TableV, append keep(distpar distgua distita distmiss)
qui: reg pnbiper distpar distgua distita distfran distmiss coast river alti tempe area preci rugg distord1 longi par, r
outreg2 using TableV, append keep(distpar distgua distita distmiss)
*Conley errors calculated using Conley Standard Errors.do
*Within R-squared calculated manually


*Table VI
*Literacy
*use Literacy Argentina Brazil Paraguay.dta

qui: reg illiteracy distfran lati longi arg par, r
qui: outreg2 using TableVI, append keep(distmiss distfran)
qui: reg illiteracy distfran lati longi area river slope rugg alti tempe preci landlocked coast par arg, r
qui: outreg2 using TableVI, append keep(distmiss distfran)
qui: reg illiteracy distfran distmiss lati longi arg par, r
qui: outreg2 using TableVI, append keep(distmiss distfran)
qui: reg illiteracy distfran distmiss lati longi area river slope rugg alti tempe preci landlocked coast par arg, r
qui: outreg2 using TableVI, append keep(distmiss distfran)
qui: reg illiteracy  distfran distmiss lati longi area tempe alti preci rugg river  slope landlocked coast meso if country=="BRA", r
qui: outreg2 using TableVI, append keep(distmiss distfran)
qui: reg illiteracy distmiss distfran lati longi area tempe alti preci rugg river slope coast corr if country=="Argentina", r
qui: outreg2 using TableVI, append keep(distmiss distfran)
qui: reg illiteracy  distfran distmiss  area river slope rugg alti tempe preci coast ita if country=="Paraguay", r
outreg2 using TableVI, append keep(distmiss distfran) 	
*Conley errors calculated using Conley Standard Errors.do
*Within R-squared calculated manually


*Table VII

*Median Years of Schooling
*use Median Years of Schooling Brazil.dta
qui: reg edumedyr  distfran lat1 long1 area river slope rugg alt tempe rain coast meso, r
qui: outreg2 using TableVII, append keep(distmiss distfran)
qui: reg edumedyr  distfran distmiss lat1 long1 area river slope rugg alt tempe rain coast meso, r
qui: outreg2 using TableVII, append keep(distmiss distfran)

*Ln Income
*use Income Brazil Paraguay.dta
qui: reg lnincome distfran lati longi area river slope rugg alti tempe preci landlocked coast par,  r 
qui: outreg2 using TableVII, append keep(distmiss distfran)
qui: reg lnincome distfran distmiss lati longi area river slope rugg alti tempe preci landlocked coast par, r
qui: outreg2 using TableVII, append keep(distmiss distfran)

*Poverty
*use Poverty Argentina Paraguay.dta 
qui: reg pnbiper distfran coast river alti tempe area preci rugg lati longi ita mis corr, r
qui: outreg2 using TableVII, append keep(distmiss distfran)
qui: reg pnbiper  distfran distmiss coast river alti tempe area preci rugg lati longi ita mis corr, r
outreg2 using TableVII, append keep(distmiss distfran)
*Conley errors calculated using Conley Standard Errors.do
*Within R-squared calculated manually


*Table VIII

*Panel A
*Argentina 
*use Argentina 1895.dta
qui: reg  argiliteracy distmiss distfran lati alti tempe area river, r
qui: outreg2 using TableVIIIA, append keep(distmiss)
qui: reg  argmailiteracy distmiss distfran lati alti tempe area river, r
qui: outreg2 using TableVIIIA, append keep(distmiss)
qui: reg  argfeiliteracy distmiss distfran lati alti tempe area river, r 
qui: outreg2 using TableVIIIA, append keep(distmiss)
qui: reg  foriliteracy distmiss distfran lati alti tempe area river, r 
qui: outreg2 using TableVIIIA, append keep(distmiss)

*Bootstrapped Standard Errors
*reg  argiliteracy distmiss distfran lati alti tempe area river, vce(boot, r(100))
*reg  argmailiteracy distmiss distfran lati alti tempe area river, vce(boot)
*reg  argfeiliteracy distmiss distfran lati alti tempe area river, vce(boot)
*reg  foriliteracy distmiss distfran lati alti tempe area river, vce(boot)

*use IPUMS Argentina.dta
qui: probit illiterate distmiss distfran lati longi area coast river slope rugg alti tempe preci corr if  year==1970, r cl (muni)
qui: outreg2 using TableVIIIA, append keep(distmiss)
qui: probit illiterate distmiss distfran lati longi area coast river slope rugg alti tempe preci corr if  year==1980, r cl (muni)
qui: outreg2 using TableVIIIA, append keep(distmiss)
qui: probit illiterate distmiss distfran lati longi area coast river slope rugg alti tempe preci corr if  year==1991, r cl (muni)
outreg2 using TableVIIIA, append keep(distmiss)
*R-squared from the regression output
*Within R-squared calculated manually

*Panel B
*Brazil
*use Brazil 1920.dta
qui: reg  illit1920 distmiss distfran lat1 alt temp rain area long1, r 
qui: outreg2 using TableVIIIB, append keep(distmiss)
qui: reg  braillit distmiss distfran lat1 alt temp rain area long1, r
qui: outreg2 using TableVIIIB, append keep(distmiss)
qui: reg  forillit distmiss distfran lat1 alt temp rain area long1, r 
outreg2 using TableVIIIB, append keep(distmiss)

*Bootstrapped Standard Errors
*reg  illit1920 distmiss distfran lat1 alt temp rain area long1, vce(boot)
*reg  braillit distmiss distfran lat1 alt temp rain area long1, vce(boot)
*reg  forillit distmiss distfran lat1 alt temp rain area long1, vce(boot)

*use IPUMS Brazil.dta
qui: reg yrschool distmiss distfran pa lat1 long1 area coast river slope rugg alti tempe preci meso if yrschool<90 & year==1980, r cl(muni)
qui: outreg2 using TableVIIIB, append keep(distmiss)
qui: reg yrschool distmiss distfran pa lat1 long1 area coast river slope rugg alti tempe preci meso if yrschool<90 & year==1991, r cl(muni)
outreg2 using TableVIIIB, append keep(distmiss)
*R-squared from the regression output
*Within R-squared calculated manually

*Panel C
*Paraguay
* use Paraguay 1950.dta
qui:reg  illitper1950 distmiss distfran ita area  coast river slope rugg alti preci lati tempe, r
qui:outreg2 using TableVIIIC, append keep(distmiss)
*Within R-squared calculated manually

*Bootstrapped Standard Errors
*reg  illitper1950 distmiss distfran ita area  coast river slope rugg alti preci lati tempe, vce(jack)

* use IPUMS Paraguay.dta
qui:probit illiterate distmiss distfran lati longi coast river slope rugg alti tempe preci if year==1962, r
qui:outreg2 using TableVIIIC, append keep(distmiss)
qui:probit illiterate distmiss distfran lati longi coast river slope rugg alti tempe preci if year==1982, r
outreg2 using TableVIIIC, append keep(distmiss)
*R-squared from the regression output


*Table IX

*Panel A
*Brazil
*use Structural Transformation Brazil.dta
qui: reg agroper distmiss lat1 long1 meso, r
qui: outreg2 using TableIXA, append keep(distmiss)
qui: reg induper distmiss lat1 long1 meso, r
qui: outreg2 using TableIXA, append keep(distmiss)
qui: reg commper distmiss lat1 long1 meso, r
qui: outreg2 using TableIXA, append keep(distmiss)
*Conley errors calculated using Conley Standard Errors.do
*Within R-squared calculated manually

*Argentina
* use Structural Transformation Argentina.dta
qui: probit agriculture distmiss lati longi corr if indgen!=0, r cl(geolev2)
qui: outreg2 using TableIXA, append keep(distmiss)
qui: probit manufacturing distmiss lati longi corr if indgen!=0, r cl(geolev2)
qui: outreg2 using TableIXA, append keep(distmiss)
qui: probit commerce distmiss lati longi corr if indgen!=0, r cl(geolev2)
qui: outreg2 using TableIXA, append keep(distmiss)
*R-squared from the regression output
*Within R-squared calculated manually

*Paraguay
*use Structural Transformation Paraguay.dta
qui: probit agro distmiss  itapua, r cl(district)
qui: outreg2 using TableIXA, append keep(distmiss)
qui: probit manu distmiss  itapua, r cl(district)
qui: outreg2 using TableIXA, append keep(distmiss)
qui: probit comm distmiss  itapua, r cl(district)
outreg2 using TableIXA, append keep(distmiss)
*R-squared from the regression output
*Within R-squared calculated manually

*Panel B
*Brazil
*use Brazil Structural Transformation.dta.dta
qui: reg agroper distmiss distfran lat1 long1 area temp alt rain rugg river coast slope meso, r
qui: outreg2 using TableIXB, append keep(distmiss)
qui: reg induper distmiss distfran lat1 long1 area temp alt rain rugg river coast slope meso, r
qui: outreg2 using TableIXB, append keep(distmiss)
qui: reg commper distmiss distfran lat1 long1 area temp alt rain rugg river coast slope meso, r
qui: outreg2 using TableIXB, append keep(distmiss)
*Conley errors calculated using Conley Standard Errors.do
*Within R-squared calculated manually

*Argentina
* use Structural Transformation Argentina.dta
qui: probit agriculture distmiss distfran lati longi area tempe preci coast river slope alti rugg corr if indgen!=0, r cl(geolev2)
qui: outreg2 using TableIXB, append keep(distmiss)
qui: probit manufacturing distmiss distfran lati longi area tempe preci coast river slope alti rugg corr if indgen!=0, r cl(geolev2)
qui: outreg2 using TableIXB, append keep(distmiss)
qui: probit commerce distmiss distfran lati longi area tempe preci coast river slope alti rugg corr if indgen!=0, r cl(geolev2)
qui: outreg2 using TableIXB, append keep(distmiss)
*R-squared from the regression output
*Within R-squared calculated manually

*Paraguay
*use Structural Transformation Paraguay.dta
qui: probit agro distmiss distfran itapua area coast river slope rugg alti tempe preci, r cl(district)
qui: outreg2 using TableIXB, append keep(distmiss)
qui: probit manu distmiss distfran itapua area coast river slope rugg alti tempe preci, r cl(district)
qui: outreg2 using TableIXB, append keep(distmiss)
qui: probit comm distmiss distfran itapua area coast river slope rugg alti tempe preci, r cl(district)
outreg2 using TableIXB, append keep(distmiss)
*R-squared from the regression output
*Within R-squared calculated manually


*Table X
*use Industries Brazil.dta

qui: probit foundries distmiss distfran lat1 long1 pa area temp rain coast river slope alti rugg meso if occ!=9999 & year==2010, r
qui: outreg2 using TableX, append keep(distmiss)
qui: probit tobacco distmiss distfran pa lat1 long1 area temp rain coast river slope alti rugg meso if occ!=9999 & year==2010, r
qui: outreg2 using TableX, append keep(distmiss)
*Might not converge: reg tobacco distmiss distfran2 temp rain coast area river slope alti rugg meso if occ!=9999 & year==2010, r
*qui: outreg2 using TableX, append keep(distmiss)
qui: probit nfmetals distmiss  distfran lat1 long1 pa area temp rain coast river slope alti rugg meso if occ!=9999 & year==2010, r
qui: outreg2 using TableX, append keep(distmiss)
qui: probit metalp  distmiss distfran lat1 long1 pa area temp rain coast river slope alti rugg meso if occ!=9999 & year==2010, r
qui: outreg2 using TableX, append keep(distmiss)
qui: probit plastic  distmiss distfran lat1 long1 area temp rain coast river slope alti rugg meso if occ!=9999 & year==2010, r
qui: outreg2 using TableX, append keep(distmiss)
qui: probit beverages distmiss distfran lat1 long1 pa area temp rain coast river slope alti rugg meso if occ!=9999 & year==2010, r
qui: outreg2 using TableX, append keep(distmiss)
qui: probit transport distmiss distfran lat1 long1 pa area temp rain coast river slope alti rugg meso if occ!=9999 & year==2010, r
qui: outreg2 using TableX, append keep(distmiss)
qui: probit machinee distmiss distfran lat1 long1 pa area temp rain coast river slope alti rugg meso if occ!=9999 & year==2010, r
qui: outreg2 using TableX, append keep(distmiss)
qui: probit chemicals distmiss distfran lat1 long1 pa area temp rain coast river slope alti rugg meso if occ!=9999 & year==2010, r
qui: outreg2 using TableX, append keep(distmiss)
qui: probit chemicalo  distmiss distfran lat1 long1 pa area temp rain coast river slope alti rugg meso if occ!=9999 & year==2010, r
outreg2 using TableX, append keep(distmiss)
*R-squared from the regression output
*Within R-squared calculated manually


*Table XI
*use Soy Brazil.dta
*Data is from Bustos, Caprettini and Ponticelli (2016)
*Available at: https://www.aeaweb.org/articles?id=10.1257/aer.20131061

qui: reg soy_TA distmiss distfran time latitude longitude micro dA_soy, r
qui: outreg2 using TableXI, append keep(distmiss)
qui: reg dgsoy_TA distmiss distfran dA_soy latitude longitude micro, r
qui: outreg2 using TableXI, append keep(distmiss)
qui: reg dnsoy_TA distmiss distfran dA_soy latitude longitude micro, r
qui: outreg2 using TableXI, append keep(distmiss)
qui: reg log_PQ_LA  distmiss distfran dA_soy latitude longitude micro, r
qui: outreg2 using TableXI, append keep(distmiss)
qui: reg La_L distmiss distfran time latitude longitude micro, r
qui: outreg2 using TableXI, append keep(distmiss)
qui: reg Lm_L distmiss distfran time latitude longitude micro, r
qui: outreg2 using TableXI, append keep(distmiss)
qui: reg Ls_L distmiss distfran time latitude longitude micro, r
outreg2 using TableXI, append keep(distmiss)
*Conley errors calculated using Conley Standard Errors.do
*Within R-squared calculated manually


*Table XII

*Panel A
*use Literacy Argentina Brazil Paraguay.dta
qui: reg popd distmiss distfran area river slope rugg alti tempe preci landlocked coast arg par lati longi, r
qui: outreg2 using TableXIIA, append keep(distmiss)
*Conley errors calculated using Conley Standard Errors.do
*Within R-squared calculated manually

*use Pre-Colonial Population Density.dta
*Data is from Maloney and Valencia Caicedo (2016)
*Available at: https://onlinelibrary.wiley.com/doi/full/10.1111/ecoj.12276
qui: iis countrynum
qui: xtreg popd mission temp_avg rainfall alti landlocked altisq tempsq rainsq , r fe
qui: outreg2 using TableXIIA, append keep(mission)
popd mission temp_avg rainfall alti landlocked altisq tempsq rainsq
*reg popd mission temp_avg rainfall alti landlocked altisq tempsq rainsq arg bra, cl (country)
*Within R-squared calculated manually

*use Literacy Argentina Brazil Paraguay.dta
qui: reg roads distmiss distfran lati longi area tempe alti preci rugg slope river coast corr ita mis mis1, r
qui: outreg2 using TableXIIA, append keep(distmiss)
qui: reg rail distmiss distfran lati longi area tempe alti preci rugg slope river coast corr ita mis mis1, r
outreg2 using TableXIIA, append keep(distmiss)
*Conley errors calculated using Conley Standard Errors.do
*Within R-squared calculated manually

*Panel B
*use Median Years of Schooling Brazil.dta
qui: reg ifdmhea100 distmiss distfran area river slope rugg alti tempe preci landlocked meso coast lat lon, r
qui: outreg2 using TableXIIB, append keep(distmiss)
*Conley errors calculated using Conley Standard Errors.do
*Within R-squared calculated manually

*use Brazil Culture.dta
qui: reg turismo distmiss distfran  alt area temp rain meso lat1 long1, r
qui: outreg2 using TableXIIB, append keep(distmiss)
*Alternatively: probit turismo distmiss distfran  alt area temp rain meso lat1 long1
*Conley errors calculated using Conley Standard Errors.do
*Within R-squared calculated manually

*Paraguay
*use Culture Paraguay.dta
qui: reg museum distmiss distfran itapua area coast river slope rugg alti tempe preci, r cl(district)
qui: outreg2 using TableXIIB, append keep(distmiss)
*Alternatively: probit museum distmiss distfran itapua area coast river slope rugg alti tempe preci, r cl(district)
qui: reg visited distmiss distfran itapua area coast river slope rugg alti tempe preci lati longi, r
qui: outreg2 using TableXIIB, append keep(distmiss)
*Alternatively: probit visited distmiss distfran itapua area coast river slope rugg alti tempe preci lati longi, cl(district)
*Conley standard errors calculated using Conley Standard Errors.do
*Within R-squared calculated manually

*Brazil
*use Median Years of Schooling Brazil.dta
reg edumedyr  distmiss area river slope rugg alti tempe preci landlocked coast meso if residente==1, r
outreg2 using TableXIIB, append keep(distmiss)
reg edumedyr  distmiss area river slope rugg alti tempe preci landlocked coast meso if residente!=1, r
outreg2 using TableXIIB, append keep(distmiss)
*Conley  standard errors calculated using Conley Standard Errors.do
*Within R-squared calculated manually

*The paper omits the constants in the regression throughout for presentation purposes
