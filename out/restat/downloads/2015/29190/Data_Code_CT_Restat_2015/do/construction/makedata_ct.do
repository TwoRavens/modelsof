

********************************************
*MAKEDATA
********************************************

*raw comtrade data
use $Data/sitc1_raw, clear

*GDP data
merge m:1 country year using $Data/GDP_curr_usd_1962

gen share=value/value_gdp
replace share=1 if share>1 & share!=. //Qatar 1972

keep year good code country sitc1 value value_gdp share 

capture bysort code year: egen ranking=rank(share), field

*polity data
merge m:1 code year using $Data/polity_62_09  

sort country
replace _m=3 if code==177 & year>=1962 & year<=1970    //UAE (missing polity data; othw unbalanced panel)
drop if _m==1
drop _m

sort code year ranking

*Identify principal commodity
bysort code: egen princ_comm= mode(good) if ranking==1, max
bysort code: egen aux = mean(princ_comm)
drop princ_comm
rename aux princ_comm

sort country year
by country: gen n=_n

*************

*Years principal commodity ranked 1st
bysort code:egen countshare_m= count(share) if princ_comm==good & ranking==1
bysort code: egen aux = mean(countshare_m)
drop countshare_m
rename aux countshare_m

by code:egen totcount=count(ranking) if ranking==1
gen prop=countshare_m/totcount
label var prop "Proportion of years in which the principal commodity is ranked first"

sort code year
by code year:gen good_pr=good if ranking==1
by code year:egen aux=mean(good_pr)
drop good_pr
rename aux good_pr

*Country-years where principal commodity is not reported
by code year:gen a=1 if good==princ_comm
by code year:egen aux_a=mean(a)
drop a 
rename aux_a a
replace a=0 if a==. & good!=.
by code year:gen ny=_n


*One observation per country-year
gen diff=princ_comm-good
sort year country
by year country:egen countgood=count(good)
sort country year
keep if diff==0 |countgood==0|a==0 & ny==1
drop ny a
sort code year
drop n
sort country
by country:gen n=_n

*Count observations for share
bysort code:egen countshare= count(share)
bysort code:egen r=rank(share) if share!=.

local group 86 90
foreach c of local group{
bysort code:egen countshare_`c'=count(share) if year<=19`c'
bysort code:egen aux=mean(countshare_`c')
drop countshare_`c'
rename aux countshare_`c'
}

*Always 1st after 1986
by code: gen c = 1 if ranking!=1 & ranking!=. & year>=1986
by code: egen d=sum(c)
by code: gen e = 1 if countshare_86==0 & d!=0
replace e=0 if e==.

*countries with few observations
xtile dec_countshare=countshare, nq(10)
xtile dec_countshare_m=countshare_m , nq(10)


********

*Natural resource abundance

*Average share
bysort code: egen avshare= mean(share)
bysort code: egen aux= mean(avshare)
drop avshare
rename aux avshare

*Average share (defined only on years with principal commodity ranked 1st)
bysort code:egen avshare_m= mean(share) if princ_comm==good & ranking==1
bysort code: egen aux = mean(avshare_m)
drop avshare_m
rename aux avshare_m

*OPEC countries
gen opec=.
local opec 2 83 95 101 127 138 149 183 84 65 177
foreach c of local opec {
replace opec=1 if code==`c'
}
replace opec=0 if opec==.

*Big producers (from different sources). More than 3% of world production
gen prod=.
local prod 183 84 149 2 83 95 101 34 35 43 92 112 126 141 188 135 31 176 75 87 158 108 23 62 180 3 38 57 74 128 134 25 105 159 42 116 90 9 163 61 167 24 88 177
foreach c of local prod {
qui replace prod=1 if code==`c'
}
replace prod=0 if prod==.

*Alternative producers directly from UN comtrade (threshold at 3%)
gen bigexp_un=.

local un 124 85 94 6 62 130 167 180 79 42 135 74 54 38 25 159 92 189 70 105 163 31 10 61 160 120 150 90 169 116 129/*
*/ 126 9 136 83 2 129 152 24 128 112 95 183 127 84 141 149 178 82 176 89 51 157 134 157 188 34 68 23
foreach c of local un {
qui replace bigexp_un=1 if code==`c'
}

*little quantity of resources
xtile dec_avshare=avshare, nq(10)
xtile dec_avshare_m=avshare_m, nq(10)


*************

*Add commodity price index
merge m:m princ_comm year using  $Data/comm_index_princ
drop if _m==2
drop _m
drop if princ_comm==.
format stub_n %20s

*Declare data to be time-series
egen id=group(code princ_comm)
tsset id year

*Generate average 3-y lagged price growth
sort code year
by code: gen price_g=(price-price[_n-1])/price[_n-1]
by code:gen pr=(price_g[_n-1]+price_g[_n-2]+price_g[_n-3])/3


*Polity2 change
sort code year
by code: gen polity2_l = polity2[_n-1] if year==year[_n-1]+1
bysort code year: egen aux=max(polity2_l)
drop polity2_l
rename aux polity2_l
gen d_pol2= polity2-polity2_l


*Main dependent: modified version of polity2
gen polity2_rob=polity2 
replace polity2_rob=. if polity==-77
sort code year 
by code: gen d_pol2_rob= polity2_rob-polity2_rob[_n-1] if year==year[_n-1]+1

*dummy 
gen dum_d_pol2_rob=1 if d_pol2_rob>0 & d_pol2_rob!=.
replace dum_d_pol2_rob=0 if dum_d_pol2_rob==. & d_pol2_rob<=0 


*components of polity2. Use same definition: interpolate when equal to -88; missing when equal to -66 or -77
sort code year
local group exconst exrec polcomp
foreach c of local group {
gen `c'_old=`c'
replace `c'=. if `c'==-66|`c'==-77|`c'==-88
by code:ipolate `c' year, gen (`c'_ip) 
replace `c'_ip=. if `c'_old==-77|`c'_old==-66
gen aux_`c'_ip=round(`c'_ip)
drop `c'_ip
rename aux_`c'_ip `c'_ip
by code:gen `c'_ip_l=`c'_ip[_n-1]
gen d_`c'=`c'_ip-`c'_ip_l
replace d_`c'=. if d_pol2_rob==.
}


*Lagged (t-4) value of polity and its components
by code: gen pl4 = polity2_rob[_n-4] if year==year[_n-1]+1

local group exrec polcomp exconst
foreach c of local group{
by code: gen `c'_l4 =`c'[_n-4] if year==year[_n-1]+1
}


sort code year 
by code: egen aux_ccode=mode(ccode)
drop ccode
rename aux_ccode ccode


gen polity2_1962=polity2 if year==1962
gen polity2_2009=polity2 if year==2009

*Add labels
label var polity2_rob "Polity Score"
label var d_pol2_rob "Change in Polity2"
label var pr "3Y Avg. Price Growth"
label var princ_comm "Principal Commodity"
label var share "Annual Share Principal Commodity"
label var countshare "Observations for Principal Commodity"
label var countshare_m "Observations for Principal Commodity in which it is ranked 1st"
label var year "Year"

*Order variables
order year code country polity2_rob d_pol2_rob pl4 princ_comm share stub_n price price_g pr countshare countshare_m  dec_countshare avshare dec_avshare mil/*
*/ sp pers prod countshare_86 countshare_90 polity2 d_pol2 dum_d_pol2_rob ccode 


*Drop construction and irrelevant variables 
drop code_n cname_n prior emonth eday eyear eprec interim bmonth bday byear bprec post change durable flag fragment cyear diff d4 sf good polity2_l mil sp pers sitc1/*
*/ scode democ autoc xrreg* xrcomp* xropen* parreg* parcomp* regtrans totcount prop good_pr countgood n r c d dec_countshare_m avshare_m dec_avshare_m *old *ip *ip_l countshare_m term 

save $Output_aux/aux1,replace



