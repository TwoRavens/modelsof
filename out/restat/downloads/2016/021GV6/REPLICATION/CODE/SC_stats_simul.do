*SCRIPT FOR SCRAPED DATA PAPER 
*Generates Table 2, with the data description

**SETUP******************
*use this database
use ${dir_rawdata}\\${database}.dta, clear

*Delete data errors
drop if price<0
drop if date>18487

*select main price series (including SALES use "fullprice" or NOSALES use "nsfullprice")
gen mprice=${sales}price

*sets no stopping and graph styles
set more off

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
local periods=r(max)-r(min)
display `periods'

*This shows number of unique products and categories
unique id
local unique_id=r(sum)
display `unique_id'
local unique_obs=r(N)
display `unique_obs'
*count if price!=. & initialspell!=1 & lastspell!=1
count if price!=. 
local unique_obs_nonmiss=r(N)
display `unique_obs_nonmiss'


*unique values of other variables
foreach var in category cat_url {
unique 	`var'
local unique_`var'=r(sum)
}

* *Number of missing observations (price), not included initial and last spells
*count if miss==1 & initialspell!=1 & lastspell!=1
count if miss==1 
local share_obs_missing=((r(N)/`unique_obs'))*100
display `share_obs_missing'




*Express in monthly duration (default is daily data)
local share_obs_w_sales=9999
local share_prod_w_sales=9999

capture noisily {
*Observations with sales
count if ${type}sale!=0 & ${type}sale!=. 
local share_obs_w_sales=((r(N)/`unique_obs'))*100
display `share_obs_w_sales'

* Share  ids with some kind of oferta
unique id if ${type}sale!=0 & ${type}sale!=.
local share_prod_w_sales=(r(sum)/`unique_id')*100
display `share_prod_w_sales'
}


*Number of products per category
* capture drop tag
* egen tag=tag(id)
* label values category bppcat
* tabulate category if tag==1
* qui log off

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

**table 4

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

* **histograms by year
gen year=year(date)
histogram gr_mprice if gr_mprice>=-50 & gr_mprice<=50, width(0.1)   percent kdensity scale(1)   subtitle(, nobox ) ytitle(% of changes) xtitle(Size of price change (%))   by(year, rows(1) title(Distribution of Price Changes by Year) legend(off) )
graph export ${dir_graphs}\distributionchanges_50_year_${sales}_${database}.png, replace



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

*

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


*Now  keep 1 obs per category
capture drop tag
egen tag=tag(category)
keep if tag==1
drop tag
keep category mean_abs_gr_mprice mean_inc_gr_mprice mean_dec_gr_mprice kurt_gr_mprice 
order category mean_abs_gr_mprice mean_inc_gr_mprice mean_dec_gr_mprice kurt_gr_mprice 



*Mean size of Increases
sum mean_inc_gr_mprice, detail
local mean_size_inc=r(mean)
display `mean_size_inc'

*Mean Size of Decreases
sum mean_dec_gr_mprice, detail
local mean_size_dec=r(mean)
display `mean_size_dec'

*Mean Size of Absolute Changes
sum mean_abs_gr_mprice, detail
local mean_abs_gr_mprice=r(mean)
display `mean_abs_gr_mprice'
local median_abs_gr_mprice=r(p50)
display `median_abs_gr_mprice'

*Mean Kurtosis
sum kurt_gr_mprice, detail
local mean_kurt=r(mean)
display `mean_kurt'

*Fillers for old variables
local mean_mu=.
display `mean_mu'
local mean_s=.
display `mean_s'

**************
ren category pscode3
gen pscode=int(pscode3/100)
destring pscode, replace force
replace pscode= pscode * 100


preserve
*save median - Level 1 
gen median_mean_abs_gr_mprice=.
levelsof pscode, clean
global listpscode `r(levels)'
foreach ps in $listpscode {
display "`ps'"
summarize mean_abs_gr_mprice if pscode==`ps', detail
replace median_mean_abs_gr_mprice=`r(p50)' if pscode==`ps'
}


*keep 1 obs per l1
keep pscode median_mean_abs_gr_mprice
capture drop tag
egen tag=tag(pscode)
keep if tag==1
drop tag
gen source="${database}"
save "${dir_results}\sectorl1_size_${sales}_${database}.dta", replace
restore


***weighted median version. 

*Blank locals in case there is no pscode data
local wmedian_mean_freq 9999
local implied_duration_wmedian 9999
local implied_dur_months_wmedia 9999

*Merge with L3 weights
gen country = strupper("${database}")
replace country="USA" if regexm(country,"USA*")==1
ren pscode3 PSCODE3
merge 1:1 country PSCODE3 using "${dir_rawdata}\coicop_weights_L3_long.dta", keepusing(weight rweight)
keep if _merge == 3
drop _merge


*Weighted median - Level 0
gen fweight=round(weight,1)
drop if fweight==.

summarize mean_abs_gr_mprice [fweight=fweight], detail
local wmedian_mean_abs_gr_mprice=r(p50)
display `wmedian_mean_abs_gr_mprice'

if _N>0 {
*save Weighted median - Level 1 
gen wmedian_mean_abs_gr_mprice=.
levelsof pscode, clean
global listpscode `r(levels)'
foreach ps in $listpscode {
display "`ps'"
summarize mean_abs_gr_mprice [fweight=fweight] if pscode==`ps', detail
replace wmedian_mean_abs_gr_mprice=`r(p50)' if pscode==`ps'
}

*keep 1 obs per l1
keep pscode wmedian_mean_abs_gr_mprice
capture drop tag
egen tag=tag(pscode)
keep if tag==1
drop tag
gen source="${database}"
save "${dir_results}\sectorl1_wsize_${sales}_${database}.dta", replace

}
 

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

capture gen category=bppcat
*B) A la BK-NS
*1)frequency by id: mean of binary indicator of price change (equal to #price changes/all observed prices)
*2)frequency by Category (~ELI). So I calculated the frequency per id, not I calculate the median per category (mean as alternative). 
*3)frequency overall: calculate the weighted (or unweighted for me) median/mean over all categories. 

****1)BY ID
*frequency per id: estimate ratios
by id: egen freq_full_id=mean(c_mprice)

**NOW keep 1 obs per id 
capture drop tag
egen tag=tag(id)
keep if tag==1
drop tag
keep id cat_url category bppcat freq_full_id

**2) BY CATEGORY (~ELI). 
*start with category
bysort category: egen mean_freq_full_cat=mean(freq_full_id)
bysort category: egen median_freq_full_cat=median(freq_full_id)

*implied duration by category
gen i_mean_dur_full_cat=-1/ln(1-mean_freq_full_cat)
gen i_median_dur_full_cat=-1/ln(1-median_freq_full_cat)

*Now  keep 1 obs per category
capture drop tag
egen tag=tag(category)
keep if tag==1
drop tag
keep category mean_freq_full_cat median_freq_full_cat i_mean_dur_full_cat i_median_dur_full_cat 
order category mean_freq_full_cat median_freq_full_cat i_mean_dur_full_cat i_median_dur_full_cat 
*show results


**3) MEDIAN across all categories (note that the first two are using means in step 2, while the other uses median in step 2, when collapsing it by category)
*BK-NS methodology. Median across all categories (unweighted and including uncategorized), and also MEAN. 
tabstat mean_freq_full_cat  i_mean_dur_full_cat median_freq_full_cat  i_median_dur_full_cat, statistics(mean p50 ) columns(variables)

*Median across categories of the mean within categories
sum mean_freq_full_cat, detail
local median_mean_freq=r(p50)
display `median_mean_freq'

local implied_duration=-1/ln(1-`median_mean_freq')
display `implied_duration'


*Express in monthly duration (default is daily data)
local implied_duration_months=`implied_duration'/30 
if regexm("${database}","weekly.*")==1 {
display "this is weekly data"
local implied_duration_months=`implied_duration'/4
}
if regexm("${database}","cpi.*")==1 {
display "this is monthly data"
local implied_duration_months=`implied_duration'
}
display `implied_duration_months'

ren category pscode3
gen pscode=int(pscode3/100)
destring pscode, replace force
replace pscode= pscode * 100


preserve


*save median - Level 1 
gen median_mean_freq_l1=.
levelsof pscode, clean
global listpscode `r(levels)'
foreach ps in $listpscode {
display "`ps'"
summarize mean_freq_full_cat if pscode==`ps', detail
replace median_mean_freq_l1=`r(p50)' if pscode==`ps'
}
gen implied_duration_median=-1/ln(1-median_mean_freq_l1)
gen implied_duration_median_month=implied_duration_median/30

if regexm("${database}","weekly.*")==1 {
display "this is weekly data"
replace implied_duration_median_month=implied_duration_median_month/4
}
if regexm("${database}","cpi.*")==1 {
display "this is monthly data"
replace implied_duration_median_month=implied_duration_median_month*30
}


*keep 1 obs per l1
keep pscode median_mean_freq_l1 implied_duration_median  implied_duration_median_month
capture drop tag
egen tag=tag(pscode)
keep if tag==1
drop tag
gen source="${database}"
save "${dir_results}\sectorl1_frequeny_${sales}_${database}.dta", replace

restore


***weighted median version. 

*Blank locals in case there is no pscode data
local wmedian_mean_freq 9999
local implied_duration_wmedian 9999
local implied_dur_months_wmedia 9999

*Merge with L3 weights
gen country = strupper("${database}")
replace country="USA" if regexm(country,"USA*")==1
ren pscode3 PSCODE3
merge 1:1 country PSCODE3 using "${dir_rawdata}\coicop_weights_L3_long.dta", keepusing(weight rweight)
keep if _merge == 3
drop _merge


*Weighted median - Level 0
gen fweight=round(weight,1)
drop if fweight==.

summarize mean_freq_full_cat [fweight=fweight], detail
local wmedian_mean_freq=r(p50)
display `wmedian_mean_freq'
local implied_duration_wmedian=-1/ln(1-`wmedian_mean_freq')
display `implied_duration_wmedian'

*Express in monthly duration (default is daily data)
local implied_dur_months_wmedian=`implied_duration_wmedian'/30 
if regexm("${database}","weekly.*")==1 {
display "this is weekly data"
local implied_dur_months_wmedian=`implied_duration_wmedian'/4
}
if regexm("${database}","cpi.*")==1 {
display "this is monthly data"
local implied_dur_months_wmedian=`implied_duration_wmedian'
}
display `implied_dur_months_wmedian'

if _N>0 {
*save Weighted median - Level 1 
gen wmedian_mean_freq_l1=.
levelsof pscode, clean
global listpscode `r(levels)'
foreach ps in $listpscode {
display "`ps'"
summarize mean_freq_full_cat [fweight=fweight] if pscode==`ps', detail
replace wmedian_mean_freq_l1=`r(p50)' if pscode==`ps'
}
gen implied_duration_wmedian=-1/ln(1-wmedian_mean_freq_l1)
gen implied_duration_wmedian_month=implied_duration_wmedian/30

if regexm("${database}","weekly.*")==1 {
display "this is weekly data"
replace implied_duration_wmedian_month=implied_duration_wmedian_month/4
}
if regexm("${database}","cpi.*")==1 {
display "this is monthly data"
replace implied_duration_wmedian_month=implied_duration_wmedian_month*30
}

*keep 1 obs per l1
keep pscode wmedian_mean_freq_l1 implied_duration_wmedian  implied_duration_wmedian_month
capture drop tag
egen tag=tag(pscode)
keep if tag==1
drop tag
gen source="${database}"
save "${dir_results}\sectorl1_wfrequeny_${sales}_${database}.dta", replace

***************************INCREASES AND DECREASES ONLY*****************************************
}

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



*length of missing spells
*********************
use "${dir_temp}\temp_${sales}_${database}.dta", replace
tsspell miss
keep if miss==1
keep if _end==1
sum _seq, detail
local miss_mean=r(mean)
display `miss_mean'
local miss_median=r(p50)
display `miss_median'
 
**********************PUT THIS AT THE END
*STORE RESULTS 
clear
clear matrix
matrix X = [`mindate', `maxdate', `periods', `unique_id', `unique_obs',`unique_obs_nonmiss', `unique_category', `unique_cat_url', `share_obs_missing', `share_obs_w_sales', `share_prod_w_sales', `median_life', `mean_life', `price_changes', `share_nochange', `median_changes_pg', `perc_inc',`perc_dec' , `mean_size_inc' , `mean_size_dec' , `mean_abs_gr_mprice', `share_under_1', `share_under_2', `share_under_3', `share_under_4', `share_under_5', `share_under_10', `median_mean_freq',`implied_duration' , `implied_duration_months', `median_mean_freq_inc',`implied_duration_inc' , `implied_duration_months_inc' ,  `median_mean_freq_dec',`implied_duration_dec' , `implied_duration_months_dec', `mean_freq_ratio', `sdp_kurt', `mean_kurt', `mean_mu', `mean_s' , `mean_abs_sdp' , `sd_abs_sdp' , `mode_abs_sdp', `mu_abs_sdp' , `s_abs_sdp' , `wmedian_mean_freq', `implied_duration_wmedian', `implied_dur_months_wmedian', `miss_mean', `miss_median']
matrix colnames X = mindate  maxdate  periods  unique_id  unique_obs unique_obs_nonmiss  unique_category  unique_cat_url  share_obs_missing  share_obs_w_sales  share_prod_w_sales  median_life  mean_life  price_changes  share_nochange  median_changes_pg  perc_inc perc_dec mean_size_inc mean_size_dec  mean_abs_gr_mprice share_under_1    share_under_2    share_under_3    share_under_4    share_under_5    share_under_10   median_mean_freq   implied_duration     implied_duration_months median_mean_freq_inc implied_duration_inc  implied_duration_months_inc   median_mean_freq_dec implied_duration_dec mean_freq_ratio implied_duration_months_dec sdp_kurt  mean_kurt mean_mu mean_s mean_abs_sdp sd_abs_sdp mode_abs_sdp mu_abs_sdp s_abs_sdp  wmedian_mean_freq implied_duration_wmedian implied_dur_months_wmedian miss_mean miss_median


svmat X, names(col)

ren * c_*

*save wide
save ${dir_tables}\table_${sales}_${database}_wide.dta, replace

gen i=1

reshape long c_, i(i) j(name) string
drop i

ren c_ ${database}

*Save long
save ${dir_tables}\table_${sales}_${database}.dta, replace

*******************************************************
