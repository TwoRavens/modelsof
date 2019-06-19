capture log close
clear all
set mem 450m

global dir C:/Dropbox/AResearch/GGreen
cd /
cd $dir

log using Logs/descriptives.txt, text replace

** SUMMARY STATISTICS
use Data/gg, clear
sum effectiveyearbuilt elec gas baths beds stories squarefeet year month centralair shingled CDD HDD  

** CALCULATE THE AVERAGE MARGINAL PRICE
** Current price data is available from MLGW's website.
gen mprice = .
replace mprice = .026 if elec < 250
replace mprice = .066 if elec >=251 & elec < 750
replace mprice = .098 if elec >= 750
sum mprice

** CREATE A DATASET OF ONE OBSERVATION PER HOUSE
use Data/gg.dta, replace
keep if year==2006
collapse (mean) elec gas baths beds stories squarefeet centralair shingled, by(home_id x2001 effectiveyearbuilt)
save Data/houses, replace

** UNIQUE HOUSES IN EACH CODE REGIME
use Data/houses, clear
codebook home_id if x2001==0
codebook home_id if x2001==1

** COMPARE PRE AND POST ELECTRIC AND GAS USAGE ACROSS ALL OBSERVATIONS
ttest elec, by(x2001)
ttest gas, by(x2001)

** TEST FOR DIFFERENCES IN VARIABLES
ttest elec, by(x2001code)
gen elecX = r(t)
ttest gas, by(x2001code)
gen gasX = r(t)
ttest squarefeet, by(x2001code)
gen squarefeetX = r(t)
ttest baths, by(x2001code)
gen bathsX = r(t)
ttest beds, by(x2001code)
gen bedsX = r(t)
ttest stories, by(x2001code)
gen storiesX = r(t)
ttest centralair, by(x2001code)
gen centralairX = r(t)
ttest shingled, by(x2001code)
gen shingledX = r(t)
** SAVE TSTAT COLUMN FOR COMPARISON TABLE
keep if _n==1
keep elecX gasX squarefeetX bathsX bedsX storiesX centralairX shingledX
order elecX gasX squarefeetX bathsX bedsX storiesX centralairX shingledX
xpose, clear
rename v1 tstat
format tstat %9.3fc 
tostring tstat, replace usedisplayformat force
save Data/tstat, replace

*****************************************************************
** CREATE TABLES

*****************************************************************
** Table 1: SUMMARY STATISTICS
** LOAD DATA
use Data/gg, clear

** PREPARE VARIABLES FOR COLLAPSE
foreach var1 in mean sd min max  {
foreach var2 in effectiveyearbuilt elec gas baths beds stories squarefeet year month ///
centralair shingled CDD HDD  ///
{
gen `var2'`var1' = `var2'
}
}
gen obs = 1

** COLLAPSE THE DATA
collapse (mean) elecmean gasmean effectiveyearbuiltmean squarefeetmean  bathsmean bedsmean storiesmean ///
centralairmean shingledmean yearmean monthmean CDDmean HDDmean ///
 (sd) elecsd gassd effectiveyearbuiltsd squarefeetsd bathssd bedssd storiessd ///
centralairsd shingledsd yearsd monthsd CDDsd HDDsd ///
 (min) elecmin gasmin effectiveyearbuiltmin squarefeetmin bathsmin bedsmin storiesmin ///
centralairmin shingledmin yearmin monthmin CDDmin HDDmin ///
 (max) elecmax gasmax effectiveyearbuiltmax squarefeetmax  bathsmax bedsmax storiesmax ///
centralairmax shingledmax yearmax monthmax CDDmax HDDmax

** RE-ORDER
order elecmean gasmean effectiveyearbuiltmean squarefeetmean  bathsmean bedsmean storiesmean ///
centralairmean shingledmean yearmean monthmean CDDmean HDDmean ///
 elecsd gassd effectiveyearbuiltsd squarefeetsd bathssd bedssd storiessd ///
centralairsd shingledsd yearsd monthsd CDDsd HDDsd ///
 elecmin gasmin effectiveyearbuiltmin squarefeetmin bathsmin bedsmin storiesmin ///
centralairmin shingledmin yearmin monthmin CDDmin HDDmin ///
 elecmax gasmax effectiveyearbuiltmax squarefeetmax  bathsmax bedsmax storiesmax ///
centralairmax shingledmax yearmax monthmax CDDmax HDDmax

** TRANSPOSE
xpose, clear

** CUT UP SINGLE VAR INTO 4 13-PIECE CHUNKS
save Data/funk1a, replace
use Data/funk1a, clear
keep if _n >= 14 & _n < 27
rename v1 sd
save Data/funk2a, replace
use Data/funk1a, clear
keep if _n >= 27 & _n < 40
rename v1 min
save Data/funk3a, replace
use Data/funk1a, clear
keep if _n >= 40 & _n < 53
rename v1 max
save Data/funk4a, replace

** MERGE CHUNKS
use Data/funk1a, clear
drop if _n > 13
merge using Data/funk2a
drop _m
merge using Data/funk3a
drop _m
merge using Data/funk4a
drop _m
gen name = ""

erase Data/funk1a.dta
erase Data/funk2a.dta
erase Data/funk3a.dta
erase Data/funk4a.dta

** GENERTE VAR NAMES
replace name = "Electricity (kWh)" if _n==1
replace name = "Natural gas (therms)" if _n==2
replace name = "Effective year built (EYB)" if _n==3
replace name = "Square feet" if _n==4
replace name = "Bathrooms" if _n==5
replace name = "Bedrooms" if _n==6
replace name = "Stories" if _n==7
replace name = "Central air-conditioning" if _n==8
replace name = "Shingled roof" if _n==9
replace name = "Billing year" if _n==10
replace name = "Billing month" if _n==11
replace name = "Average cooling degree days (ACDD)" if _n==12
replace name = "Average heating degree days (AHDD)" if _n==13

** RE-FORMAT
foreach var in v1 sd min max {
format `var' %9.3fc 
tostring `var', replace usedisplayformat force
replace `var' = subinstr(`var', ".000", "", .)
}

** EXPORT
listtex name v1 sd min max using PaperGG/Tab/sumstats.tex, rstyle(tabular) ///
head("\begin{tabular}{lrrrr}" ///
\hline\hline ///
\multicolumn{1}{l}{\textbf{Variable}} & \textbf{Mean} & \textbf{St. Dev.} & \textbf{Min.} & \textbf{Max.}\\ \hline) ///
foot("\hline\end{tabular}") replace

*****************************************************************
** TABLE 2: COMPARING HOUSES 
** LOAD THE DATA
use Data/houses, clear

** PREPARE VARIABLES FOR COLLAPSE
foreach var1 in mean sd min max  {
foreach var2 in elec gas baths beds stories squarefeet ///
centralair shingled ///
{
gen `var2'`var1' = `var2'
}
}

** MAKE THE COLLAPSE
collapse (mean) elecmean gasmean squarefeetmean bathsmean bedsmean storiesmean centralairmean shingledmean ///
 (sd) elecsd gassd squarefeetsd bathssd bedssd storiessd centralairsd shingledsd ///
 (min) elecmin gasmin squarefeetmin bathsmin bedsmin storiesmin centralairmin shingledmin ///
 (max) elecmax gasmax squarefeetmax bathsmax bedsmax storiesmax centralairmax shingledmax ///
, by(x2001code)

** RE-ORDER THE VARS
order elecmean gasmean squarefeetmean bathsmean bedsmean storiesmean centralairmean shingledmean ///
  elecsd gassd squarefeetsd bathssd bedssd storiessd centralairsd shingledsd ///
  elecmin gasmin squarefeetmin bathsmin bedsmin storiesmin centralairmin shingledmin ///
  elecmax gasmax squarefeetmax  bedsmax storiesmax centralairmax shingledmax ///

** TRANSPOSE INTO A SINGLE VAR
xpose, clear

** LIMIT TO STATS OF INTEREST (MEAN, SD)
keep if _n < 17

** GENERATE VARIABLE NAMES
gen name = ""
replace name = "Electricity (kWh)" if _n==1
replace name = "Natural gas (therms)" if _n==2
replace name = "Square feet" if _n==3
replace name = "Bathrooms" if _n==4
replace name = "Bedrooms" if _n==5
replace name = "Stories" if _n==6
replace name = "Central air-conditioning" if _n==7
replace name = "Shingled roof" if _n==8
order name v1 v2

** ADD T-STAT COLUMN
merge using Data/tstat

** MOVE STANDARD DEVIATION OBS. IN BETWEEN MEAN OBS.
gen sort = _n
replace sort = _n-8 + .1 if _n > 8
sort sort

** GEN DIFFERENCE BETWEEN THE TWO GROUPS VARIABLE
gen diff = v2 - v1
foreach var in diff v1 v2 {
format `var' %9.3fc 
tostring `var', replace usedisplayformat force
}
replace diff = "" if name==""

** EXPORT
listtex name v1 v2 diff tstat using PaperGG/Tab/comparisonstats.tex, rstyle(tabular) ///
head("\begin{tabular}{lcccc}" ///
\hline\hline Variable & \multicolumn{1}{c}{\textbf{Before code change}} ///
& \multicolumn{1}{c}{\textbf{After code change}} & Diff. & \textit{t}-stat. \\ \hline) ///
foot("\hline\end{tabular}") replace

log close
