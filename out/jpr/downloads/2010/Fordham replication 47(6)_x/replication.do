* This file will replicate the analysis used in Benjamin O. Fordham,
* 'Trade and Asymmetric Alliances,' in the Journal of Peace Research
* The user should first create a 'C:\replication\' directory and place 
* the replication dataset in it. Each variable is labeled. Information
* on data sources can be found in the text of the article.

clear
set more off
set mem 1000m

* This section will replicate the formation models in Table III
* First, the models of alliance formation
use "C:\replication\replication.dta", clear
drop if year < 1885
gen lnpop_1=ln(tpop_1)
gen lnpop_2=ln(tpop_2)
gen lncap_1=ln(cap_1)
gen lncap_2=ln(cap_2)
gen lndistance=ln(distance+1)
replace majpow1=1 if ccode1==220
replace majpow1=1 if ccode1==255 & year < 1946
replace majpow1=1 if ccode1==365
replace majpow1=0 if ccode1==255& year> 1945
replace majpow1=0 if ccode1==740& year> 1945
recode ccode2 255=260 if year>1989
drop if ccode2==260&year==1990
by dyadid: drop if atopdef[_n-1]==1
gen lsinteract=lsthreat_1*lntradel_ro
keep if majpow1==1&majpow2~=1
btscs atopdef year dyadid, g(noallyrs) nspline(3) failure
probit atopdef lntradel_ro lnpop_1 lnpop_2 cap_1 cap_2 s_un_glo lsthreat_1 lsthreat_2 lndistance similarity polity2lo noallyrs _prefail _spline1 _spline2 _spline3 if ww1~=1 & ww2~=1, nolog robust
probit atopdef lntradel_ro lsinteract lnpop_1 lnpop_2 cap_1 cap_2 s_un_glo lsthreat_1 lsthreat_2 lndistance similarity polity2lo noallyrs _prefail _spline1 _spline2 _spline3 if ww1~=1 & ww2~=1, nolog robust
test lntradel_ro lsinteract lsthreat_1

* Robustness checks on alliance formation for Table V
* 1. Original results from model above
* 2. Excluding all control variables
probit atopdef lntradel_ro noallyrs _prefail _spline1 _spline2 _spline3 if ww1~=1 & ww2~=1, nolog robust 

* 3. Fixed effect dummy for each major power
sort ccode1
xi: probit atopdef i.ccode1 lntradel_ro lnpop_1 lnpop_2 cap_1 cap_2 s_un_glo lsthreat_1 lsthreat_2 lndistance similarity polity2lo noallyrs _prefail _spline1 _spline2 _spline3  if ww1~=1 & ww2~=1, nolog robust

* 4. Data through 1938
probit atopdef lntradel_ro lnpop_1 lnpop_2 cap_1 cap_2 s_un_glo lsthreat_1 lsthreat_2 lndistance similarity polity2lo noallyrs _prefail _spline1 _spline2 _spline3 if year<1939, nolog robust

* 5. Data after 1950 
probit atopdef lntradel_ro lnpop_1 lnpop_2 cap_1 cap_2 s_un_glo lsthreat_1 lsthreat_2 lndistance similarity polity2lo noallyrs _prefail _spline1 _spline2 _spline3 if year>=1950, nolog robust

* 6. Minor-minor dyads less than 500 km apart
use "C:\replication\replication.dta", clear
drop if year < 1885
gen lnpop_1=ln(tpop_1)
gen lnpop_2=ln(tpop_2)
gen lncap_1=ln(cap_1)
gen lncap_2=ln(cap_2)
gen lndistance=ln(distance+1)
replace majpow1=1 if ccode1==220
replace majpow1=1 if ccode1==255 & year < 1946
replace majpow1=1 if ccode1==365
replace majpow1=0 if ccode1==255& year> 1945
replace majpow1=0 if ccode1==740& year> 1945
recode ccode2 255=260 if year>1989
drop if ccode2==260&year==1990
by dyadid: drop if atopdef[_n-1]==1
gen lsinteract=lsthreat_1*lntradel_ro
keep if majpow1==0 & majpow2==0 & distance<=500
btscs atopdef year dyadid, g(noallyrs) nspline(3) failure
probit atopdef lntradel_ro lnpop_1 lnpop_2 cap_1 cap_2 s_un_glo lsthreat_1 lsthreat_2 lndistance similarity polity2lo noallyrs _prefail _spline1 _spline2 _spline3 if ww1~=1 & ww2~=1, nolog robust

* 7. COW defense pacts instead of ATOP
use "C:\replication\replication.dta", clear
drop if year < 1885
gen lnpop_1=ln(tpop_1)
gen lnpop_2=ln(tpop_2)
gen lncap_1=ln(cap_1)
gen lncap_2=ln(cap_2)
gen lndistance=ln(distance+1)
replace majpow1=1 if ccode1==220
replace majpow1=1 if ccode1==255 & year < 1946
replace majpow1=1 if ccode1==365
replace majpow1=0 if ccode1==255& year> 1945
replace majpow1=0 if ccode1==740& year> 1945
recode ccode2 255=260 if year>1989
drop if ccode2==260&year==1990
by dyadid: drop if cowdef[_n-1]==1
keep if majpow1==1&majpow2~=1
btscs cowdef year dyadid, g(noallyrs) nspline(3) failure
probit cowdef lntradel_ro lnpop_1 lnpop_2 cap_1 cap_2 s_un_glo lsthreat_1 lsthreat_2 lndistance similarity polity2lo noallyrs _prefail _spline1 _spline2 _spline3 if ww1~=1 & ww2~=1, nolog robust

* 8. Model using Barbieri, Keshk, and Pollins trade data
use "C:\replication\replication.dta", clear
drop if year < 1870
replace majpow1=1 if ccode1==220
replace majpow1=1 if ccode1==255 & year < 1946
replace majpow1=1 if ccode1==365
replace majpow1=0 if ccode1==255& year> 1945
replace majpow1=0 if ccode1==740& year> 1945
gen lnpop_1=ln(tpop_1)
gen lnpop_2=ln(tpop_2)
gen lncap_1=ln(cap_1)
gen lncap_2=ln(cap_2)
gen lndistance=ln(distance+1)
keep if majpow1==1&majpow2~=1
recode ccode2 255=260 if year>1989
drop if ccode2==260&year==1990
by dyadid: drop if atopdef[_n-1]==1
btscs atopdef year dyadid, g(noallyrs) nspline(3) failure
probit atopdef lntradel_bkp lnpop_1 lnpop_2 cap_1 cap_2 s_un_glo lsthreat_1 lsthreat_2 lndistance similarity polity2lo noallyrs _prefail _spline1 _spline2 _spline3 if ww1~=1 & ww2~=1, nolog robust

* 9. Bilateral alliances only
use "C:\replication\replication.dta", clear
drop if year < 1885
gen lnpop_1=ln(tpop_1)
gen lnpop_2=ln(tpop_2)
gen lncap_1=ln(cap_1)
gen lncap_2=ln(cap_2)
gen lndistance=ln(distance+1)
replace majpow1=1 if ccode1==220
replace majpow1=1 if ccode1==255 & year < 1946
replace majpow1=1 if ccode1==365
replace majpow1=0 if ccode1==255& year> 1945
replace majpow1=0 if ccode1==740& year> 1945
recode ccode2 255=260 if year>1989
drop if ccode2==260&year==1990
sort dyadid year
by dyadid: drop if bilat[_n-1]==1
gen lsinteract=lsthreat_1*lntradel_ro
keep if majpow1==1&majpow2~=1
btscs bilat year dyadid, g(noallyrs) nspline(3) failure
probit bilat lntradel_ro lnpop_1 lnpop_2 cap_1 cap_2 s_un_glo lsthreat_1 lsthreat_2 lndistance similarity polity2lo noallyrs _prefail _spline1 _spline2 _spline3 if ww1~=1 & ww2~=1, nolog robust

* Models of alliance collapse for Table III
use "C:\replication\replication.dta", clear
drop if year < 1885
drop if year > 2000
replace majpow1=1 if ccode1==220
replace majpow1=1 if ccode1==255 & year < 1946
replace majpow1=1 if ccode1==365
replace majpow1=0 if ccode1==255& year> 1945
replace majpow1=0 if ccode1==740& year> 1945
gen atopend=1 if atopdef==0
replace atopend=0 if atopdef==1
sort dyadid year
gen lnpop_1=ln(tpop_1)
gen lnpop_2=ln(tpop_2)
gen lncap_1=ln(cap_1)
gen lncap_2=ln(cap_2)
gen lndistance=ln(distance+1)
sort dyadid year
keep if majpow1==1&majpow2~=1
recode ccode2 255=260 if year>1989
drop if ccode2==260&year==1990
sort dyadid year
by dyadid: drop if atopend[_n-1]==1
by dyadid: drop if atopend==1&atopend[_n-1]==.
gen lsinteract=lsthreat_1*lntradel_ro
btscs atopend year dyadid, g(noallyrs) nspline(3) failure
probit atopend lntradel_ro lnpop_1 lnpop_2 cap_1 cap_2 s_un_glo lsthreat_1 lsthreat_2 lndistance similarity polity2lo noallyrs _prefail _spline1 _spline2 _spline3 if ww1~=1 & ww2~=1, nolog robust
probit atopend lntradel_ro lsinteract lnpop_1 lnpop_2 cap_1 cap_2 s_un_glo lsthreat_1 lsthreat_2 lndistance similarity polity2lo noallyrs _prefail _spline1 _spline2 _spline3 if ww1~=1 & ww2~=1, nolog robust
test lntradel_ro lsinteract lsthreat_1

* Robustness checks on alliance formation for Table V
* 1. Original results from model above
* 2. Excluding all control variables
probit atopend lntradel_ro noallyrs _prefail _spline1 _spline2 _spline3 if ww1~=1 & ww2~=1, nolog robust

* 3. Fixed effect dummy for each major power
sort ccode1
xi: probit atopend i.ccode1 lntradel_ro lnpop_1 lnpop_2 cap_1 cap_2 s_un_glo lsthreat_1 lsthreat_2 lndistance similarity polity2lo noallyrs _prefail _spline1 _spline2 _spline3 if ww1~=1 & ww2~=1, nolog robust

* 4. Data through 1938
probit atopend lntradel_ro lnpop_1 lnpop_2 cap_1 cap_2 s_un_glo lsthreat_1 lsthreat_2 lndistance similarity polity2lo noallyrs _prefail _spline1 _spline2 _spline3 if year < 1939, nolog robust

* 5. Data after 1950 
probit atopend lntradel_ro lnpop_1 lnpop_2 cap_1 cap_2 s_un_glo lsthreat_1 lsthreat_2 lndistance similarity polity2lo noallyrs _prefail _spline1 _spline2 _spline3 if year >=1950, nolog robust

* 6. Minor-minor dyads less than 500 km apart
use "C:\replication\replication.dta", clear
drop if year < 1885
drop if year > 2000
replace majpow1=1 if ccode1==220
replace majpow1=1 if ccode1==255 & year < 1946
replace majpow1=1 if ccode1==365
replace majpow1=0 if ccode1==255& year> 1945
replace majpow1=0 if ccode1==740& year> 1945
gen atopend=1 if atopdef==0
replace atopend=0 if atopdef==1
sort dyadid year
gen lnpop_1=ln(tpop_1)
gen lnpop_2=ln(tpop_2)
gen lncap_1=ln(cap_1)
gen lncap_2=ln(cap_2)
gen lndistance=ln(distance+1)
keep if majpow1==0 & majpow2==0 & distance<=500
recode ccode2 255=260 if year>1989
drop if ccode2==260&year==1990
sort dyadid year
by dyadid: drop if atopend[_n-1]==1
by dyadid: drop if atopend==1&atopend[_n-1]==.
gen lsinteract=lsthreat_1*lntradel_ro
btscs atopend year dyadid, g(noallyrs) nspline(3) failure
probit atopend lntradel_ro lnpop_1 lnpop_2 cap_1 cap_2 s_un_glo lsthreat_1 lsthreat_2 lndistance similarity polity2lo noallyrs _prefail _spline1 _spline2 _spline3 if ww1~=1 & ww2~=1, nolog robust

* 7. COW defense pacts instead of ATOP
use "C:\replication\replication.dta", clear
drop if year < 1885
replace majpow1=1 if ccode1==220
replace majpow1=1 if ccode1==255 & year < 1946
replace majpow1=1 if ccode1==365
replace majpow1=0 if ccode1==255& year> 1945
replace majpow1=0 if ccode1==740& year> 1945
gen cowend=1 if cowdef==0
replace cowend=0 if cowdef==1
sort dyadid year
gen lnpop_1=ln(tpop_1)
gen lnpop_2=ln(tpop_2)
gen lncap_1=ln(cap_1)
gen lncap_2=ln(cap_2)
gen lndistance=ln(distance+1)
keep if majpow1==1&majpow2~=1
recode ccode2 255=260 if year>1989
drop if ccode2==260&year==1990
sort dyadid year
by dyadid: drop if cowend[_n-1]==1
by dyadid: drop if cowend==1&cowend[_n-1]==.
btscs cowend year dyadid, g(noallyrs) nspline(3) failure
probit cowend lntradel_ro lnpop_1 lnpop_2 lncap_1 lncap_2 s_un_glo lsthreat_1 lsthreat_2 lndistance similarity polity2lo noallyrs _prefail _spline1 _spline2 _spline3 if ww1~=1 & ww2~=1, nolog robust

* 8. Model using Barbieri, Keshk, and Pollins trade data
use "C:\replication\replication.dta", clear
drop if year < 1870
gen atopend=1 if atopdef==0
replace atopend=0 if atopdef==1
replace majpow1=1 if ccode1==220
replace majpow1=1 if ccode1==255 & year < 1946
replace majpow1=1 if ccode1==365
replace majpow1=0 if ccode1==255& year> 1945
replace majpow1=0 if ccode1==740& year> 1945
gen lnpop_1=ln(tpop_1)
gen lnpop_2=ln(tpop_2)
gen lncap_1=ln(cap_1)
gen lncap_2=ln(cap_2)
gen lndistance=ln(distance+1)
keep if majpow1==1&majpow2~=1
recode ccode2 255=260 if year>1989
drop if ccode2==260&year==1990
sort dyadid year
by dyadid: drop if atopend[_n-1]==1
by dyadid: drop if atopend==1&atopend[_n-1]==.
btscs atopend year dyadid, g(noallyrs) nspline(3) failure
probit atopend lntradel_bkp lnpop_1 lnpop_2 cap_1 cap_2 s_un_glo lsthreat_1 lsthreat_2 lndistance similarity polity2lo noallyrs _prefail _spline1 _spline2 _spline3 if ww1~=1 & ww2~=1, nolog robust

* 9. Bilateral alliances only
use "C:\replication\replication.dta", clear
drop if year < 1885
drop if year > 2000
replace majpow1=1 if ccode1==220
replace majpow1=1 if ccode1==255 & year < 1946
replace majpow1=1 if ccode1==365
replace majpow1=0 if ccode1==255& year> 1945
replace majpow1=0 if ccode1==740& year> 1945
gen bilatend=1 if bilat==0
replace bilatend=0 if bilat==1
sort dyadid year
gen lnpop_1=ln(tpop_1)
gen lnpop_2=ln(tpop_2)
gen lncap_1=ln(cap_1)
gen lncap_2=ln(cap_2)
gen lndistance=ln(distance+1)
keep if majpow1==1&majpow2~=1
recode ccode2 255=260 if year>1989
drop if ccode2==260&year==1990
sort dyadid year
by dyadid: drop if bilatend[_n-1]==1
by dyadid: drop if bilatend==1&bilatend[_n-1]==.
gen lsinteract=lsthreat_1*lntradel_ro
btscs bilatend year dyadid, g(noallyrs) nspline(3) failure
probit bilatend lntradel_ro lnpop_1 lnpop_2 cap_1 cap_2 s_un_glo lsthreat_1 lsthreat_2 lndistance similarity polity2lo noallyrs _prefail _spline1 _spline2 _spline3 if ww1~=1 & ww2~=1, nolog robust

* Model results for Table VI
use "C:\replication\replication.dta", clear

*Generating variable on recent alliance formation before dropping pre-1950 observations
sort dyadid year
by dyadid: gen recentalliance=1 if atopdef==1&atopdef[_n-1]==0
by dyadid: replace recentalliance=1 if atopdef==1&atopdef[_n-1]==.
by dyadid: replace recentalliance=1 if atopdef==1&atopdef[_n-1]==1&atopdef[_n-2]==0
by dyadid: replace recentalliance=1 if atopdef==1&atopdef[_n-1]==1&atopdef[_n-2]==.
by dyadid: replace recentalliance=1 if atopdef==1&atopdef[_n-1]==1&atopdef[_n-2]==1&atopdef[_n-3]==0
by dyadid: replace recentalliance=1 if atopdef==1&atopdef[_n-1]==1&atopdef[_n-2]==1&atopdef[_n-3]==.
by dyadid: replace recentalliance=1 if atopdef==1&atopdef[_n-1]==1&atopdef[_n-2]==1&atopdef[_n-3]==1&atopdef[_n-4]==0
by dyadid: replace recentalliance=1 if atopdef==1&atopdef[_n-1]==1&atopdef[_n-2]==1&atopdef[_n-3]==1&atopdef[_n-4]==.
by dyadid: replace recentalliance=1 if atopdef==1&atopdef[_n-1]==1&atopdef[_n-2]==1&atopdef[_n-3]==1&atopdef[_n-4]==1&atopdef[_n-5]==0
by dyadid: replace recentalliance=1 if atopdef==1&atopdef[_n-1]==1&atopdef[_n-2]==1&atopdef[_n-3]==1&atopdef[_n-4]==1&atopdef[_n-5]==.
recode recentalliance .=0

drop if year < 1950
drop if year > 2000
drop if dyadid==.

* Logged trade is the logged value of trade in thousands of 1996 dollars
* Trade value is adjusted for inflation using the implicit price deflator 
* in the Gleditsch data, which contained both current and real 1996 per 
* capita GDP.
gen rexp12=(exp12*100000)/gdpdef1
gen lnexp12=ln(rexp12+1)
sort dyadid year
by dyadid: gen diffexp12=rexp12-rexp12[_n-1]
by dyadid: gen difflnexp12=lnexp12-lnexp12[_n-1]

* Logged GDP is the log of real GDP in millions of dollars
gen gdp1=(rgdpc1*pop1)/1000
gen gdp2=(rgdpc2*pop2)/1000
gen lngdp1=ln(gdp1)
gen lngdp2=ln(gdp2)
gen lndistance=ln(distance+1)
gen lnpop1=ln(pop1)
gen lnpop2=ln(pop2)

*Generating differenced variables for gravity model
sort dyadid year
by dyadid: gen diffgdp1=gdp1-gdp1[_n-1]
by dyadid: gen diffgdp2=gdp2-gdp2[_n-1]
by dyadid: gen diffpop1=pop1-pop1[_n-1]
by dyadid: gen diffpop2=pop2-pop2[_n-1]
by dyadid: gen difflngdp1=lngdp1-lngdp1[_n-1]
by dyadid: gen difflngdp2=lngdp2-lngdp2[_n-1]
by dyadid: gen difflnpop1=lnpop1-lnpop1[_n-1]
by dyadid: gen difflnpop2=lnpop2-lnpop2[_n-1]
by dyadid: gen lnexp12lag=lnexp12[_n-1]
by dyadid: gen difflnexp12lag=difflnexp12[_n-1]
by dyadid: gen diffatopdef=atopdef-atopdef[_n-1]
gen asymmetric=1 if majpow1==1&majpow2~=1
replace asymmetric=1 if majpow1~=1&majpow2==1
recode asymmetric .=0

xtset dyadid year

* Gravity model of trade for dyads with at least one major power and
* Note that fidings about alliance variable are robust to inclusion
* of fixed effects for each directed dyad, but not to alternative
* specification of the dynamics.
xtregar lnexp12 lngdp1 lngdp2 lnpop1 lnpop2 lndistance atopdef if asymmetric==1

* Differenced gravity model
xtregar difflnexp12 difflngdp1 difflngdp2 difflnpop1 difflnpop2 diffatopdef if asymmetric==1

* Differenced gravity model with non-differenced alliance variable
xtregar difflnexp12 difflngdp1 difflngdp2 difflnpop1 difflnpop2 atopdef if asymmetric==1

* Differenced gravity model with variable indicating alliance formed in last five years
xtregar difflnexp12 difflngdp1 difflngdp2 difflnpop1 difflnpop2 recentalliance if asymmetric==1

