***THIS DO FILE CREATES AGGREGATE EVENT DUMMIES 
***THAT EACH PARENT COMPANY EXPERIENCES IN ITS INVESTED COUNTRY,
***AS WELL AS COMPUTES MARKET RETURNS


** CREATE AGGREGATE EVENT DUMMIES
set more off
use Data_ZAF.dta, clear


capture gen year = year(Date)
drop if year<1995 //years before 1996 are irrelevant for our event study, we use one year early for completeness

local countries "ago ben bfa bdi cmr caf tcd com zar	cog civ gnq eri eth gmb gha gin gnb ken lbr mdg mwi mli mrt moz ner rwa stp sen	sle som sdn tza tgo uga zmb"

keep date Date ticker p_close dividend pd_close pm_close capimpute turnover vwap volume active open inv_nohipc 

sort ticker Date

** COMPUTE RETURNS, DIVIDEND-ADJUSTED RETURNS AND MARKET RETURN 
* CREATE LAGGED STOCK PRICE
gen activeopen=0
/*ON 13 SPECIFIC DAYS FOR TOTAL 436 OBSERVATIONS, COMPANY IS ACTIVE WHILE THE MARKET IS CLOSED*/
/*(i.e., WHEN active==1 and open==0) THUS, TREAT THESE OBSERVATIONS AS INACTIVE*/
replace activeopen=1 if active==1 & open==1

gen h = .
replace h = 1 if activeopen==1 
replace h = sum(h)
gen i = .
replace i = 1 if activeopen==0
egen j = group(h i)
egen k = count(activeopen) if j!=., by (j) 
gen Lk = k[_n-1]+1
replace Lk = 1 if activeopen==1 & Lk==.
by ticker, sort: gen Lp_close = p_close[_n-Lk] if activeopen==1

order ticker date activeopen p_close Lp_close  h i j k Lk

* SIMILARLY FOR A WHOLE MARKET INDEX 
gen hm = .
replace hm = 1 if open==1
replace hm = sum(hm)
gen im = .
replace im = 1 if open==0
egen jm = group(hm im)
egen km = count(open) if jm!=., by (jm) 
gen Lkm = km[_n-1]+1
replace Lkm = 1 if open==1 & Lkm==.
by ticker, sort: gen Lpm_close = pm_close[_n-Lkm] if open==1

* COMPUTE RETURNS, DIVIDEND-ADJUSTED RETURNS, AND MARKET RETURN
by ticker, sort: gen return = (p_close-Lp_close)/Lp_close
by ticker, sort: gen returnd = (pd_close-Lp_close)/Lp_close
by ticker, sort: gen returnm = (pm_close-Lpm_close)/Lpm_close

drop h i j k Lk hm im jm km Lkm

** COMPUTE REUTRN WEIGHTED BY MARKET CAPITALIZATION FOR THE 10 COMPANIES WHICH HAVE NO INVESTMENT IN ANY HIPC COUNTRIES
by Date, sort: egen totcap_nohipc = sum(capimpute) if inv_nohipc==1&capimpute!=.&returnd!=.
by Date: egen capreturn_nohipc = sum(capimpute*returnd) if inv_nohipc==1&capimpute!=.&returnd!=.
by Date: gen returnw_nohipc = capreturn_nohipc/totcap_nohipc

drop totcap capreturn_nohipc

order Date date ticker p_close return pd_close returnd pm_close returnm active open activeopen

sort ticker Date

label var	activeopen	"(=1) implies both the company and the market are active, and (=0) otherwise"
label var	Lp_close	"Lagged closing price"
label var	Lpm_close	"Lagged closing market price"
label var	return	"Return"
label var	returnd	"Dividend-adjusted return"
label var	returnm	"Market return"
label var	returnw_nohipc	"Weighted return of only-non-HIPC-invested companies"

notes: On 13 specific days for total 436 observations, companies are active while the market is closed (i.e., when active==1 and open==0). Thus, treat these observations as inactive

compress

sort ticker Date


drop date

rename Date date

format date %d

rename return R

rename returnm Rm

rename returnw_nohipc R_nohipc

sort ticker date

saveold financial_data_zaf_parents, replace

isid ticker date

*merge ticker date using "M:\mg\craddatz\Shinsuke\HIPC&MDRI\Data Creation\Size&Group.dta", nok
merge ticker date using Size&Group.dta, nok


drop _merge

sort size date

*merge size date using "M:\mg\craddatz\Shinsuke\HIPC&MDRI\Data Creation\return_size_with_index.dta", nok
merge size date using return_size_with_index.dta, nok

sort group date

rename _merge mergewithsize

*merge group date using "M:\mg\craddatz\Shinsuke\HIPC&MDRI\Data Creation\return_group_with_index.dta", nok
merge group date using return_group_with_index.dta, nok

drop _merge

saveold financial_data_zaf_parents.dta, replace
