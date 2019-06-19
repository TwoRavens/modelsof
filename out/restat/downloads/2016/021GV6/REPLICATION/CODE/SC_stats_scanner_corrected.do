*SCRIPT FOR SCRAPED DATA PAPER 
*Generates Table 2, with the data description

**SETUP******************
*use this database

global database usa_scanner_corrected
global sales full

use ${dir_rawdata}\\usa_scanner.dta, clear

*Delete data errors
drop if price<0
drop if date>18487

replace fullprice=. if miss==1

gen stringprice=string(price)
split stringprice, parse(.) 

gen secondigit=substr(stringprice2,2,1)

gen imputed=1 if secondigit!="5" &  secondigit!="9" & secondigit!=""

replace fullprice=. if imputed==1


tsset id date
*replace weeklyprice with previous (but not on initial and last spells)
tsspell fullprice, spell(spellprice) seq(seqprice) end(endprice)
bysort id: egen maxspellprice=max(spellprice)
by id: replace fullprice=l.fullprice if miss==1&  fullprice==. & spellprice!=maxspellprice & seqprice <=20
gen initialspell=1 if spellprice==1
gen lastspell=1 if spellprice==maxspellprice
drop spellprice seqprice endprice maxspellprice
*drop price



*select main price series (including SALES use "fullprice" or NOSALES use "nsfullprice")
gen mprice=${sales}price

*sets no stopping and graph styles
set more off
set scheme s2mono

* *generate week, month and quarter indicators that distinguish the year (for most graphs)
* gen weekyear=wofd(date)
* gen monthyear=mofd(date)
* gen quarteryear=qofd(date)
* gen dow=dow(date)

*DATES
sum date, format
local mindate=r(min)
display %td `mindate'
local maxdate=r(max)
display %td `maxdate'
local days=r(max)-r(min)
display `days'

*This shows number of unique products and categories
unique id
local unique_id=r(sum)
display `unique_id'
local unique_obs=r(N)
display `unique_obs'
count if price!=. & initialspell!=1 & lastspell!=1
local unique_obs_nonmiss=r(N)
display `unique_obs_nonmiss'


*unique values of other variables
foreach var in category cat_url {
unique 	`var'
local unique_`var'=r(sum)
}

* *Number of missing observations (price), not included initial and last spells
count if miss==1 & initialspell!=1 & lastspell!=1
local share_obs_missing=((r(N)/`unique_obs'))*100
display `share_obs_missing'


*Observations with sales
count if fulloferta!=0 & fulloferta!=. 
local share_obs_w_sales=((r(N)/`unique_obs'))*100
display `share_obs_w_sales'

* Share  ids with some kind of oferta
unique id if fulloferta!=0 & fulloferta!=.
local share_prod_w_sales=(r(sum)/`unique_id')*100
display `share_prod_w_sales'



**************PRICE CALCULATIONS
tsset id date

*Calculate change in price, both with and without sales, as well as growth rates. Note that I do not use log because % of price changes are big here
gen d_mprice=d.mprice
gen gr_mprice=100*(d_mprice/l.mprice)
format gr_mprice %9.2f
drop d_mprice 

******************
*See outliers 
count if gr_mprice!=.
count if gr_mprice>100 & gr_mprice!=.
count if gr_mprice>200 & gr_mprice!=.
count if gr_mprice>500 & gr_mprice!=.
count if gr_mprice>1000 & gr_mprice!=.
count if gr_mprice>1500 & gr_mprice!=.
count if gr_mprice<-90 & gr_mprice!=.

*remove them
replace gr_mprice=. if gr_mprice>120 & gr_mprice!=.
replace gr_mprice=. if gr_mprice<-70 & gr_mprice!=.
*********************

*Binary indicator of change in prices
gen c_mprice=0 if gr_mprice==0
replace c_mprice=1 if gr_mprice!=0 & gr_mprice!=.

*Binary indicator of increase in prices
gen inc_mprice=c_mprice
replace inc_mprice=0 if gr_mprice<0

*Binary indicator of decrease in prices
gen dec_mprice=c_mprice
replace dec_mprice=0 if gr_mprice>0 & gr_mprice!=.

*Binary indicator if there a price change could have been recorded for that id that day (to later know how many ids were included that day, week, etc, taking into account only those cases where there was also a price for the previous day). 
gen c_pricefound=1 if gr_mprice!=.

save "${dir_temp}\temp_${sales}_${database}.dta", replace

*********************


*median and mean "life" of good (date last price- date first price)
use "${dir_temp}\temp_${sales}_${database}.dta", replace
by id: egen firstdate=min(date) if miss!=1
by id: egen lastdate=max(date) if miss!=1
by id: gen life=(lastdate-firstdate) if miss!=1
collapse life, by(id)
*median and mean "life" of good (date last price- date first price)
sum life, detail
local median_life=r(p50)
display `median_life'
local mean_life=r(mean)
display `mean_life'


*number of price changes
use "${dir_temp}\temp_${sales}_${database}.dta", clear
*Number of price changes in whole sample
count if c_mprice==1
local price_changes=r(N)
display `price_changes'
*Number of price changes not asssociated with any sale (there is no sale indicator in a -1/+1 day window)
*count if c_mprice==1 & (l.fulloferta==0 |  l.fulloferta==.) & (fulloferta==0 |  fulloferta==.) & (f.fulloferta==0 |  f.fulloferta==.)


*number and % of goods with different price changes
use "${dir_temp}\temp_${sales}_${database}.dta", clear
by id: egen countchanges=sum(c_mprice) 
by id: egen firstdate=min(date) if miss!=1
by id: egen lastdate=max(date) if miss!=1
by id: gen life=(lastdate-firstdate) if miss!=1

collapse countchanges life, by (id)
count if life>30
local temp_all=r(N)
count if life>30 & countchanges==0
local share_nochange=(r(N)/`temp_all')*100
display `share_nochange'

sum countchanges, detail
local median_changes_pg=r(p50)
display `median_changes_pg'





*overall percent of price increases, decreases 
use "${dir_temp}\temp_${sales}_${database}.dta", clear
egen countchanges=sum(c_mprice) 
egen countchanges_inc=sum(inc_mprice) 
egen countchanges_dec=sum(dec_mprice) 

collapse countchanges  countchanges_inc countchanges_dec 
gen perc_inc=(countchanges_inc/countchanges)*100
gen perc_dec=(countchanges_dec/countchanges)*100

*PERCENT OF PRICE CHANGES THAT ARE PRICE INCREASES, DECREASES 
sum perc_inc
local perc_inc=r(mean)
display `perc_inc'
sum perc_dec 
local perc_dec=r(mean)
display `perc_dec'

* tabstat perc_inc perc_dec, statistics(mean) columns(statistics)
* qui log off


************************************************************************************************

* DISTRIBUTION OF AMOUNT % of price change (% of price) over all the sample [given that there is a price change]
use "${dir_temp}\temp_${sales}_${database}.dta", clear
*first drop those obs with no price changes
drop if c_mprice!=1

histogram gr_mprice, percent width(1)  kdensity scale(1)  ytitle(% of changes) xtitle(Size of price change (%)) title(Distribution of Price Changes)
graph export ${dir_graphs}\distributionchanges_${sales}_${database}.png, replace

histogram gr_mprice, percent width(0.1)   kdensity scale(1)  ytitle(% of changes) xtitle(Size of price change (%)) title(Distribution of Price Changes)
graph export ${dir_graphs}\distributionchanges2_${sales}_${database}.png, replace

*use this in tables
histogram gr_mprice if gr_mprice>=-50 & gr_mprice<=50, width(0.1)   percent kdensity scale(1) ytitle(% of changes) xtitle(Size of price change (%)) xlabel(#10) title(Distribution of Price Changes)
graph export ${dir_graphs}\distributionchanges3_${sales}_${database}.png, replace
kdensity gr_mprice if gr_mprice>=-50 & gr_mprice<=50, bwidth(1) normal recast(line) generate(x d)  

preserve
keep x d
drop if x==.
gen id="main"
save ${dir_results}\kernel_main_${sales}_${database}.dta, replace
restore
drop x d

histogram gr_mprice if gr_mprice>=-100 & gr_mprice<=100,width(0.1)   percent kdensity scale(1) ytitle(% of changes) xtitle(Size of price change (%)) xlabel(#10) title(Distribution of Price Changes)
graph export ${dir_graphs}\distributionchanges_100_${sales}_${database}.png, replace

*Roughly 3 years. Using 10/7 as cutoff. Use command display date("10-07-2009", "MDY") to find number.
gen period="Period 1" if date<17812
replace period="Period 2" if date>=17812 & date<18177
replace period="Period 3" if date>=18177
histogram gr_mprice if gr_mprice>=-50 & gr_mprice<=50, width(0.1) percent by(period, rows(1)) subtitle(, nobox )  ytitle(% of changes) xtitle(Size of price change (%)) 
graph export ${dir_graphs}\distributionchanges3_periods_${sales}_${database}.png, replace

twoway kdensity gr_mprice if gr_mprice>=-50 & gr_mprice<=50  & period=="Period 1" || kdensity gr_mprice if gr_mprice>=-50 & gr_mprice<=50  & period=="Period 2" || kdensity gr_mprice if gr_mprice>=-50 & gr_mprice<=50  & period=="Period 3"
graph export ${dir_graphs}\distributionchanges3_periods_kernels_${sales}_${database}.png, replace


* *IN ABSOLUTE VALUE (SEE KK)
gen abs_gr_mprice=abs(gr_mprice) 
sum abs_gr_mprice if c_mprice==1, detail


*FRACTION OF CHANGES BELOW X% absolute value THRESHOLDS
*first count all price changes
count if c_mprice==1
local total=r(N)
*now count those within 1% threshold
foreach th in 1 2 3 4 5 10 {
count if c_mprice==1 & abs_gr_mprice>0 & abs_gr_mprice<=`th'
display "threshold <|`th'%| = " (r(N)/`total')*100 
local share_under_`th'= (r(N)/`total')*100 
display `share_under_`th''
}




*SIZE OF CHANGES --MEAN WITHIN CATEGORIES FIRST, THEN MEAN/MEDIAN ACROSS CATEGORIES 

****THIS PART MAKES MEAN WITHIN CATEGORIES FIRST, THEN MEDIAN ACROSS CATEGORIES
gen inc_gr_mprice=gr_mprice if c_mprice==1 & gr_mprice>0
gen dec_gr_mprice=gr_mprice if c_mprice==1 & gr_mprice<0
bysort category: egen mean_gr_mprice=mean(gr_mprice)
bysort category: egen mean_abs_gr_mprice=mean(abs_gr_mprice) 
bysort category: egen mean_inc_gr_mprice=mean(inc_gr_mprice)
bysort category: egen mean_dec_gr_mprice=mean(dec_gr_mprice)
bysort category: egen kurt_gr_mprice=kurt(gr_mprice)
*for stats on ALP
bysort category: egen sd_abs_gr_mprice=sd(abs_gr_mprice)
bysort category: egen mode_abs_gr_mprice=mode(abs_gr_mprice) 
gen mu=mode_abs_gr_mprice/mean_abs_gr_mprice
gen s=sd_abs_gr_mprice/mean_abs_gr_mprice

collapse  mean_gr_mprice mean_abs_gr_mprice mean_inc_gr_mprice mean_dec_gr_mprice kurt_gr_mprice sd_abs_gr_mprice mode_abs_gr_mprice mu s, by(category)

*Mean size of Increases
sum mean_inc_gr_mprice
local mean_size_inc=r(mean)
display `mean_size_inc'

*Mean Size of Decreases
sum mean_dec_gr_mprice
local mean_size_dec=r(mean)
display `mean_size_dec'

*Mean Size of Absolute Changes
sum mean_abs_gr_mprice
local mean_abs_gr_mprice=r(mean)
display `mean_abs_gr_mprice'


*Mean Kurtosis
sum kurt_gr_mprice
local mean_kurt=r(mean)
display `mean_kurt'

*Fillers for old variables
local mean_mu=.
display `mean_mu'
local mean_s=.
display `mean_s'


****************

use "${dir_temp}\temp_${sales}_${database}.dta", clear

*Standarized Price Changes
* ** STANDARIZED PRICE CHANGES
keep if c_mprice==1

bysort category: egen meandp=mean(gr_mprice)
bysort category: egen sddp=sd(gr_mprice)
gen sdp=(gr_mprice-meandp)/sddp

keep if gr_mprice>=-50 & gr_mprice<=50


*stats for ALP
*Histogram
histogram sdp if gr_mprice>=-50 & gr_mprice<=50, width(0.1)  percent kdensity scale(1) ytitle(% of changes) xtitle(Size of price change (%)) xlabel(#10) title(Distribution of Standarized Price Changes)
graph export ${dir_graphs}\distributionchanges3_standard_${sales}_${database}.png, replace
*Absolute value
gen abs_sdp=abs(sdp)


sum sdp, detail
local sdp_kurt = string(r(kurtosis),"%9.2f")
display "sdp_kurt:" `sdp_kurt'

*stats
*egen kurt_abs_sdp=kurt(abs_sdp)
egen mean_abs_sdp=mean(abs_sdp)
egen sd_abs_sdp=sd(abs_sdp)
egen mode_abs_sdp=mode(abs_sdp)
gen mu_abs_sdp=mode_abs_sdp/mean_abs_sdp
gen s_abs_sdp=sd_abs_sdp/mean_abs_sdp

*store local macros
foreach var in mean_abs_sdp sd_abs_sdp mode_abs_sdp mu_abs_sdp s_abs_sdp  {
capture sum `var'
local `var' = r(mean)
display "`var' :" ``var''
}


use "${dir_temp}\temp_${sales}_${database}.dta", clear

********SIMPLE FREQUENCY ANALYSIS
sort id date



use "${dir_temp}\temp_${sales}_${database}.dta", clear


*B) A la BK-NS
*1)frequency by id: mean of binary indicator of price change (equal to #price changes/all observed prices)
*2)frequency by Category (~ELI). So I calculated the frequency per id, not I calculate the median per category (mean as alternative). 
*3)frequency overall: calculate the weighted (or unweighted for me) median/mean over all categories. 

****1)BY ID
*frequency per id: estimate ratios
by id: egen freq_full_id=mean(c_mprice)

**NOW WE CAN COLLAPSE BY ID 
**this is a much easier database to manipulate. From now on, I can use tabstat to compute means, medians, etc. 
*Note that I calculate "mean", but within each id all these variables are the same, so no real effect there, just using collapse command
collapse (mean) category bppcat  freq_full_id, by(id)
label values category bppcat

**2) BY CATEGORY (~ELI). 
*start with category
bysort category: egen mean_freq_full_cat=mean(freq_full_id)
bysort category: egen median_freq_full_cat=median(freq_full_id)

*implied duration by category
gen i_mean_dur_full_cat=-1/ln(1-mean_freq_full_cat)
gen i_median_dur_full_cat=-1/ln(1-median_freq_full_cat)

*Now collapse to category level
collapse  mean_freq_full_cat  i_mean_dur_full_cat median_freq_full_cat i_median_dur_full_cat , by(category)

*show results
*BK-NS methodology. Frequency and duration by category, using either mean by cat (like BK_NS) or median by cat first. 

*table with frequency values
label values category bppcat
tabstat mean_freq_full_cat  i_mean_dur_full_cat median_freq_full_cat  i_median_dur_full_cat , statistics( mean ) by(category) columns(variables) labelwidth(30)  

histogram mean_freq_full_cat, bin(100) frequency xlabel(, labels valuelabel ticks)
graph export ${dir_graphs}\histogramfrequencies_${sales}_${database}.png, replace



**3) MEDIAN across all categories (note that the first two are using means in step 2, while the other uses median in step 2, when collapsing it by category)
*BK-NS methodology. Median across all categories (unweighted and including uncategorized), and also MEAN. 
tabstat mean_freq_full_cat  i_mean_dur_full_cat median_freq_full_cat  i_median_dur_full_cat, statistics(mean p50 ) columns(variables)

*Median across categories of the mean within categories
sum mean_freq_full_cat, detail
local median_mean_freq=r(p50)
display `median_mean_freq'

local implied_duration=-1/ln(1-`median_mean_freq')
display `implied_duration'

local implied_duration_months=`implied_duration'/30
display `implied_duration_months'


*Implied duration (days)

***************************INCREASES AND DECREASES ONLY*****************************************

***********************************************************************
*INCREASES ONLY ----A la BK-NS
use "${dir_temp}\temp_${sales}_${database}.dta", clear

*1)frequency by id: mean of binary indicator of price change (equal to #price changes/all observed prices)
*2)frequency by Category (~ELI). So I calculated the frequency per id, not I calculate the median per category (mean as alternative). 
*3)frequency overall: calculate the weighted (or unweighted for me) median/mean over all categories. 

****1)BY ID
*frequency per id: estimate ratios
by id: egen freq_full_id=mean(inc_mprice)

**NOW WE CAN COLLAPSE BY ID 
**this is a much easier database to manipulate. From now on, I can use tabstat to compute means, medians, etc. 
*Note that I calculate "mean", but within each id all these variables are the same, so no real effect there, just using collapse command
collapse (mean) category bppcat  freq_full_id, by(id)
label values category bppcat

**2) BY CATEGORY (~ELI). 
*start with category
bysort category: egen mean_freq_full_cat=mean(freq_full_id)
bysort category: egen median_freq_full_cat=median(freq_full_id)

*implied duration by category
gen i_mean_dur_full_cat=-1/ln(1-mean_freq_full_cat)
gen i_median_dur_full_cat=-1/ln(1-median_freq_full_cat)

*Now collapse to category level
collapse  mean_freq_full_cat  i_mean_dur_full_cat median_freq_full_cat i_median_dur_full_cat , by(category)

*show results

*BK-NS methodology. Frequency and duration by category, using either mean by cat (like BK_NS) or median by cat first. 

*table with frequency values
label values category bppcat
tabstat mean_freq_full_cat  i_mean_dur_full_cat median_freq_full_cat  i_median_dur_full_cat , statistics( mean ) by(category) columns(variables) labelwidth(30)  


**3) MEDIAN across all categories (note that the first two are using means in step 2, while the other uses median in step 2, when collapsing it by category)
*BK-NS methodology. Median across all categories (unweighted and including uncategorized), and also MEAN. 
tabstat mean_freq_full_cat  i_mean_dur_full_cat median_freq_full_cat  i_median_dur_full_cat, statistics(mean p50 ) columns(variables)

***********************************************************************
*Median across categories of the mean within categories
sum mean_freq_full_cat, detail
local median_mean_freq_inc=r(p50)
display `median_mean_freq_inc'

local implied_duration_inc=-1/ln(1-`median_mean_freq_inc')
display `implied_duration_inc'

local implied_duration_months_inc=`implied_duration_inc'/30
display `implied_duration_months_inc'


***********************************************************************
*DECREASES ONLY ----A la BK-NS
use "${dir_temp}\temp_${sales}_${database}.dta", clear

*1)frequency by id: mean of binary indicator of price change (equal to #price changes/all observed prices)
*2)frequency by Category (~ELI). So I calculated the frequency per id, not I calculate the median per category (mean as alternative). 
*3)frequency overall: calculate the weighted (or unweighted for me) median/mean over all categories. 

****1)BY ID
*frequency per id: estimate ratios
by id: egen freq_full_id=mean(dec_mprice)

**NOW WE CAN COLLAPSE BY ID 
**this is a much easier database to manipulate. From now on, I can use tabstat to compute means, medians, etc. 
*Note that I calculate "mean", but within each id all these variables are the same, so no real effect there, just using collapse command
collapse (mean) category bppcat  freq_full_id, by(id)
label values category bppcat

**2) BY CATEGORY (~ELI). 
*start with category
bysort category: egen mean_freq_full_cat=mean(freq_full_id)
bysort category: egen median_freq_full_cat=median(freq_full_id)

*implied duration by category
gen i_mean_dur_full_cat=-1/ln(1-mean_freq_full_cat)
gen i_median_dur_full_cat=-1/ln(1-median_freq_full_cat)

*Now collapse to category level
collapse  mean_freq_full_cat  i_mean_dur_full_cat median_freq_full_cat i_median_dur_full_cat , by(category)

*show results
*BK-NS methodology. Frequency and duration by category, using either mean by cat (like BK_NS) or median by cat first. 

*table with frequency values
label values category bppcat
tabstat mean_freq_full_cat  i_mean_dur_full_cat median_freq_full_cat  i_median_dur_full_cat , statistics( mean ) by(category) columns(variables) labelwidth(30)  

**3) MEDIAN across all categories (note that the first two are using means in step 2, while the other uses median in step 2, when collapsing it by category)
*BK-NS methodology. Median across all categories (unweighted and including uncategorized), and also MEAN. 
tabstat mean_freq_full_cat  i_mean_dur_full_cat median_freq_full_cat  i_median_dur_full_cat, statistics(mean p50 ) columns(variables)

***********************************************************************
*Median across categories of the mean within categories
sum mean_freq_full_cat, detail
local median_mean_freq_dec=r(p50)
display `median_mean_freq_dec'

local implied_duration_dec=-1/ln(1-`median_mean_freq_dec')
display `implied_duration_dec'

local implied_duration_months_dec=`implied_duration_dec'/30
display `implied_duration_months_dec'


***********************************************************************
*Now ratio of freq+/freq-
local mean_freq_ratio=`median_mean_freq_inc'/`median_mean_freq_dec'
display `mean_freq_ratio'


************INFLATION

use "${dir_temp}\temp_${sales}_${database}.dta", clear
*log name
*cd "/var/grads/acavallo/prices/"

*price relative
tsset id date
gen relative=mprice/l.mprice

*get geometric mean by category and date
egen gmean=gmean(relative), by(category date)

*get arithmentic mean by category and date
egen mean=mean(relative), by(category date)

egen gmeanall=gmean(relative), by(date)

*collapse to get one obs per category/date
*collapse gmean mean gmeanall, by(category date)
keep gmean mean gmeanall category date
egen tag=tag(category date)
keep if tag==1
drop tag


*Now generate index per day, multiplying the relatives
tsset category date
egen daymax=max(date)
format daymax %td
egen daymin=min(date)
format daymin %td

*
gen index=100 if date==daymin
replace index=l.index if index==. & gmean==.
replace index=gmean*l.index if index==. & gmean!=.

* xtline index , overlay legend(off) scheme(s2color) scale(1) title(All Goods)
* graph export ${dir_graphs}\categoryindex_${sales}_${database}.png, replace


********************************
* ***********this part deals with the comparison with official statistics

*An average ALL indexes to compare with official stats
bysort date: egen index_sup=mean(index)
label var index_sup "Scraped Supermarket Index"

*An average food index to compare with official ayb stats
gen index_food=index if (category<=183  | category==901 | category==911 | category==921 | category==931)
bysort date: egen index_ayb=mean(index_food)
label var index_ayb "Scraped Food Index"


*collapse them
drop tag
egen tag=tag(date)
keep if tag==1
drop tag

*Now use gmeanall to get the other version of the aggregate index (without category weights)
tsset date
gen index_sup2=100 if date==daymin
replace index_sup2=l.index_sup2 if index_sup2==. & gmeanall==.
replace index_sup2=gmeanall*l.index_sup2 if index_sup2==. & gmeanall!=.


label var index_ayb "Scraped Food Index"
label var index_sup "Scraped Supermarket Index"
label var index_sup2 "Scraped Supermarket Index v2"

* *this one includes the official  indices
* sort date
* merge date using all_official_allcountries_monthly_2.dta, keep(${database}*)
* drop _merge
* drop if date==.

* label var ${database}_ab "Official Food Price Index"
* label var ${database}_ipc "Official CPI"

* *SUMMARIZE TO SEE LAST VALUE
sum  if date==daymax 


****Now use Scraped annual and monthly inflation and compare to official data 

*sup v1
sort date
tsset date
tssmooth ma index_sup_ma=index_sup, window(29 1)
format index_sup_ma  %9.1f
*annual
gen index_sup_annual=100*(index_sup_ma-index_sup_ma[_n-365])/index_sup_ma[_n-365]
format  index_sup_annual  %9.1f
*monthly
gen  index_sup_monthly=100*(index_sup_ma-index_sup_ma[_n-30])/index_sup_ma[_n-30]
format index_sup_monthly  %9.1f


sum index_sup_annual
local mean_annual_inflation=r(mean) 
display `mean_annual_inflation'


**********************PUT THIS AT THE END
*STORE RESULTS 
clear
clear matrix
matrix X = [`mindate', `maxdate', `days', `unique_id', `unique_obs',`unique_obs_nonmiss', `unique_category', `unique_cat_url', `share_obs_missing', `share_obs_w_sales', `share_prod_w_sales', `median_life', `mean_life', `price_changes', `share_nochange', `median_changes_pg', `perc_inc',`perc_dec' , `mean_size_inc' , `mean_size_dec' , `mean_abs_gr_mprice', `share_under_1', `share_under_2', `share_under_3', `share_under_4', `share_under_5', `share_under_10', `median_mean_freq',`implied_duration' , `implied_duration_months', `median_mean_freq_inc',`implied_duration_inc' , `implied_duration_months_inc' ,  `median_mean_freq_dec',`implied_duration_dec' , `implied_duration_months_dec', `mean_freq_ratio', `sdp_kurt', `mean_kurt', `mean_annual_inflation' , `mean_mu', `mean_s' , `mean_abs_sdp' , `sd_abs_sdp' , `mode_abs_sdp', `mu_abs_sdp' , `s_abs_sdp' ]
matrix colnames X = mindate  maxdate  days  unique_id  unique_obs unique_obs_nonmiss  unique_category  unique_cat_url  share_obs_missing  share_obs_w_sales  share_prod_w_sales  median_life  mean_life  price_changes  share_nochange  median_changes_pg  perc_inc perc_dec mean_size_inc mean_size_dec  mean_abs_gr_mprice share_under_1    share_under_2    share_under_3    share_under_4    share_under_5    share_under_10   median_mean_freq   implied_duration     implied_duration_months median_mean_freq_inc implied_duration_inc  implied_duration_months_inc   median_mean_freq_dec implied_duration_dec mean_freq_ratio implied_duration_months_dec sdp_kurt  mean_kurt mean_annual_inflation mean_mu mean_s mean_abs_sdp sd_abs_sdp mode_abs_sdp mu_abs_sdp s_abs_sdp

svmat X, names(col)

ren * c_*

gen i=1

reshape long c_, i(i) j(name) string
drop i

ren c_ ${database}

*Save 
save ${dir_tables}\table_${sales}_${database}.dta, replace

*******************************************************
