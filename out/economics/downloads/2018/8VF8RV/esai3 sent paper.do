
*=============================================================*
*        The Influence of Corruption on the Inequality        *
*=============================================================*
* p_democ: Institutionalized Democracy

clear all
capture log close
set more off
log using /Users/inayatinurainidwiputri/Documents/stata/disertasi/Esai3/log/esai3.log, text replace
use "/Users/inayatinurainidwiputri/Documents/stata/disertasi/Esai3/data/asiagini.dta", clear
xtset no year
xtsum gini corr
plot corr gini

*====================================*
*================   OLS   ===========*
****  MODEL 1  ****
reg gini corr unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade
predict resid1, r
vif
hettest
summarize resid1
ksmirnov  resid1 = normal(( resid1-r(mean))/r(sd))

****  MODEL 2  ****
reg gini corr unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade capgrow
predict resid2, r
vif
hettest
summarize resid2
ksmirnov  resid2 = normal(( resid2-r(mean))/r(sd))

****  MODEL 3  ****
reg gini corr unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade capgrow gdpcapgrow
predict resid3, r
vif
hettest
summarize resid3
ksmirnov  resid3 = normal(( resid3-r(mean))/r(sd))

***** MODEL 4  *****
reg gini corr unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade capgrow gdpcapcorr
predict resid4, r 
vif
hettest
summarize resid4
ksmirnov  resid4 = normal(( resid4-r(mean))/r(sd))

* 56 data, corr negatif sig
***** MODEL 5  *****
reg gini corr unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade expense gdpcapcorr 
predict resid5, r
vif
hettest
summarize resid5
ksmirnov  resid5 = normal(( resid5-r(mean))/r(sd))

***** MODEL 6  *****
reg gini corr unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade expense capgrow
predict resid6, r
vif
hettest
summarize resid6
ksmirnov  resid6 = normal(( resid6-r(mean))/r(sd))

*=========================================*
*============= TOBIT =====================*
tobit gini corr unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade, ll
tobit gini corr unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade capgrow, ll
tobit gini corr unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade capgrow gdpcapgrow, ll
tobit gini corr unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade capgrow gdpcapcorr, ll
tobit gini corr unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade expense gdpcapcorr, ll
tobit gini corr unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade expense capgrow, ll

*====================================*
*================   IV    ===========*
*** GINI: VARIABEL DEPENDEN
ivregress 2sls gini unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov (corr = al_ethnic al_language al_religion), first
estat endog
estat firststage
estat overid
ivregress 2sls gini unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade (corr = al_ethnic al_language al_religion), first
estat endog
estat firststage
estat overid
ivregress 2sls gini unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade capgrow (corr = al_ethnic al_language al_religion), first
estat endog
estat firststage
estat overid
ivregress 2sls gini unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade capgrow gdpcapgrow (corr = al_ethnic al_language al_religion), first
estat endog
estat firststage
estat overid
ivregress 2sls gini unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade gdpcapgrow  (corr = al_ethnic al_language al_religion), first
estat endog
estat firststage
estat overid
ivregress 2sls gini unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade expense capgrow (corr = al_ethnic al_language al_religion), first
estat endog
estat firststage
estat overid

*============================================================*
**       The Influence of Inequality on the Corruption      **
*============================================================*
clear all
capture log close
set more off
log using /Users/inayatinurainidwiputri/Documents/stata/disertasi/Esai3/log/dep_corr.log, text replace
use "/Users/inayatinurainidwiputri/Documents/stata/disertasi/Esai3/data/asiagini.dta", clear
xtset no year

*====================================*
*================   OLS   ===========*
*         MODEL 7         
reg corr gini unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade, ro
predict resid7, r
vif
summarize resid7
ksmirnov  resid7 = normal(( resid7-r(mean))/r(sd))
*        MODEL 8  
reg corr gini unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade capgrow, ro
predict resid8, r
vif
summarize resid8
ksmirnov  resid8 = normal(( resid8-r(mean))/r(sd))
*        MODEL 9  
reg corr gini unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade capgrow gdpcapgrow, ro
predict resid9, r
vif
summarize resid9
ksmirnov  resid9 = normal(( resid9-r(mean))/r(sd))
*        MODEL 10  
reg corr gini unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade gdpcapgrow, ro
predict resid10, r 
vif
summarize resid10
ksmirnov  resid10 = normal(( resid10-r(mean))/r(sd))
*        MODEL 11  
reg corr gini unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade expense, ro 
predict resid11, r
vif
summarize resid11
ksmirnov  resid11 = normal(( resid11-r(mean))/r(sd))
*        MODEL 12  
reg corr gini unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade expense capgrow, ro
predict resid12, r
vif
summarize resid12
ksmirnov  resid12 = normal(( resid12-r(mean))/r(sd))

*=========================================*
*============= TOBIT =====================*
tobit corr gini unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade, ll
tobit corr gini unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade capgrow, ll
tobit corr gini unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade capgrow gdpcapgrow, ll
tobit corr gini unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade gdpcapgrow, ll
tobit corr gini unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade expense, ll
tobit corr gini unemptot ln_gdpcapcons educprim educsec taxrev healthtot cap popgrow fdi p_democ gov trade expense capgrow, ll


