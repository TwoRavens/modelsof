******************************************************************
**** Replication for "Systemic Effects of Campaign Spending"  ****
**** Andrew B. Hall										      ****
**** 5/15/2015												  ****
******************************************************************

*** code uses 5 datasets
*** (1) reduced_form_data: main reduced-form results for paper
*** (2) iv_data: main IV results for paper
*** (3)-(5): pres_ban, house_ban, and sen_ban: 
***          contain presidential, house, and senate election for placebo tests
*******************************************************************************

** Analysis starts here
use reduced_form_data, clear

gen ban_both = ban_union * ban_corp
replace dem_frac = 100 * dem_frac
egen tmp = group(state lower)

** Table 1 regressions

xi: areg dem_frac ban_corp i.year, a(tmp) cluster(tmp)
local treat1 = _b[ban_corp]
local se1 = _se[ban_corp]
local n1 = e(N)

xi: areg dem_frac ban_corp ban_union ban_spend* i.year, a(tmp) cluster(tmp)
local treat2 = _b[ban_corp]
local se2 = _se[ban_corp]
local n2 = e(N)
local union2 = _b[ban_union]
local unionse2 = _se[ban_union]
local spend_union2 = _b[ban_spend_union]
local spend_unionse2 = _se[ban_spend_union]
local spend_corp2 = _b[ban_spend_corp]
local spend_corpse2 = _se[ban_spend_corp]

gen dem_maj = dem_frac > 50
replace dem_maj = . if dem_frac == .

xi: areg dem_maj ban_corp i.year, a(tmp) cluster(state)
local treat3 = _b[ban_corp]
local se3 = _se[ban_corp]
local n3 = e(N)


xi: areg dem_maj ban_corp ban_union ban_spend* i.year, a(tmp) cluster(tmp)
local treat4 = _b[ban_corp]
local se4 = _se[ban_corp]
local n4 = e(N)
local union4 = _b[ban_union]
local unionse4 = _se[ban_union]
local spend_union4 = _b[ban_spend_union]
local spend_unionse4 = _se[ban_spend_union]
local spend_corp4 = _b[ban_spend_corp]
local spend_corpse4 = _se[ban_spend_corp]


*** Produce LaTeX table

quietly {
	capture log close
	set linesize 255
	log using table1.tex, text replace
	noisily display ""
	noisily display "\begin{table}[t] \caption{{\bf Corporate Contribution Bans and Democratic Seat Share, U.S. State Legislatures, 1950--2012}."
	noisily display "Corporate contribution bans are shown to cause a large increase in Democratic electoral fortunes. \label{tab:main}}"
	noisily display "\vspace{-4mm}"
	noisily display "\begin{center}"
	noisily display "\footnotesize"
	noisily display "\begin{tabular}{lcccc}"
	noisily display "\toprule\toprule"
	noisily display " & \multicolumn{2}{c}{\bf Dem Seat \%} & \multicolumn{2}{c}{\bf Dem Majority} \\"
	noisily display " \midrule "
	noisily display " Corporate Contribution Ban & " %4.2f `treat1' " & " %4.2f `treat2' " & " %4.2f `treat3' " & " %4.2f `treat4' "  \\ "
	noisily display " & (" %4.2f `se1' ") & (" %4.2f `se2' ") & (" %4.2f `se3' ") & (" %4.2f `se4' ")  \\[2mm]"
	noisily display " Union Contribution Ban & & " %4.2f `union2' " & & " %4.2f `union4' " \\"
	noisily display " &  & (" %4.2f `unionse2' ") & & (" %4.2f `unionse4' ") \\"
	noisily display " Corporate Spending Ban & & " %4.2f `spend_corp2' " & & " %4.2f `spend_corp4' " \\"
	noisily display " & & (" %4.2f `spend_corpse2' ") & & (" %4.2f `spend_corpse4' ") \\"
	noisily display " Union Spending Ban & & " %4.2f `spend_union2' " & & " %4.2f `spend_union4' " \\"
	noisily display "  & & (" %4.2f `spend_unionse2' ") & & (" %4.2f `spend_unionse4' ") \\[2mm]"
	noisily display " N & " %6.0fc `n1' " & " %6.0fc `n2' " & " %6.0fc `n3' " & " %6.0fc `n4' "  \\[1mm] "
	noisily display " Year Fixed Effects & Yes & Yes & Yes & Yes \\"
	noisily display " State-Chamber Fixed Effects & Yes & Yes & Yes & Yes \\"
	noisily display " \bottomrule \bottomrule "
	noisily display "\multicolumn{5}{p{0.6\textwidth}}{Robust standard errors clustered by state-chamber in parentheses.} \\"
	noisily display "\end{tabular}"
	noisily display "\end{center}"
	noisily display "\end{table}"
	log close

}


**** appendix table with state linear time trends


use reduced_form_data, clear

gen ban_both = ban_union * ban_corp

replace dem_frac = 100 * dem_frac

egen tmp = group(state lower)

tabulate state, generate(state_dummy)

forvalues j=1/50 {
	gen state_trend`j' = year*state_dummy`j'
}


** Table 2, main results

xi: areg dem_frac ban_corp i.year year state_trend*, a(tmp) cluster(state)
local treat1 = _b[ban_corp]
local se1 = _se[ban_corp]
local n1 = e(N)

xi: areg dem_frac ban_corp ban_union ban_spend* year state_trend* i.year, a(tmp) cluster(state)
local treat2 = _b[ban_corp]
local se2 = _se[ban_corp]
local n2 = e(N)
local union2 = _b[ban_union]
local unionse2 = _se[ban_union]
local spend_union2 = _b[ban_spend_union]
local spend_unionse2 = _se[ban_spend_union]
local spend_corp2 = _b[ban_spend_corp]
local spend_corpse2 = _se[ban_spend_corp]

gen dem_maj = dem_frac > 50
replace dem_maj = . if dem_frac == .

xi: areg dem_maj ban_corp i.year year state_trend*, a(tmp) cluster(state)
local treat3 = _b[ban_corp]
local se3 = _se[ban_corp]
local n3 = e(N)


xi: areg dem_maj ban_corp ban_union ban_spend* i.year year state_trend*, a(tmp) cluster(state)
local treat4 = _b[ban_corp]
local se4 = _se[ban_corp]
local n4 = e(N)
local union4 = _b[ban_union]
local unionse4 = _se[ban_union]
local spend_union4 = _b[ban_spend_union]
local spend_unionse4 = _se[ban_spend_union]
local spend_corp4 = _b[ban_spend_corp]
local spend_corpse4 = _se[ban_spend_corp]


quietly {
	capture log close
	set linesize 255
	log using table_trends.tex, text replace
	noisily display ""
	noisily display "\begin{table}[h] \caption{{\bf Corporate Contribution Bans and Democratic Seat Share, U.S. State Legislatures, 1950--2012}."
	noisily display "Corporate contribution bans are shown to cause a large increase in Democratic electoral fortunes. \label{tab:trends}}"
	noisily display "\vspace{-4mm}"
	noisily display "\begin{center}"
	noisily display "\footnotesize"
	noisily display "\begin{tabular}{lcccc}"
	noisily display "\toprule\toprule"
	noisily display " & \multicolumn{2}{c}{\bf Dem Seat \%} & \multicolumn{2}{c}{\bf Dem Majority} \\"
	noisily display " \midrule "
	noisily display " Corporate Contribution Ban & " %4.2f `treat1' " & " %4.2f `treat2' " & " %4.2f `treat3' " & " %4.2f `treat4' "  \\ "
	noisily display " & (" %4.2f `se1' ") & (" %4.2f `se2' ") & (" %4.2f `se3' ") & (" %4.2f `se4' ")  \\[2mm]"
	noisily display " Union Contribution Ban & & " %4.2f `union2' " & & " %4.2f `union4' " \\"
	noisily display " &  & (" %4.2f `unionse2' ") & & (" %4.2f `unionse4' ") \\"
	noisily display " Corporate Spending Ban & & " %4.2f `spend_corp2' " & & " %4.2f `spend_corp4' " \\"
	noisily display " & & (" %4.2f `spend_corpse2' ") & & (" %4.2f `spend_corpse4' ") \\"
	noisily display " Union Spending Ban & & " %4.2f `spend_union2' " & & " %4.2f `spend_union4' " \\"
	noisily display "  & & (" %4.2f `spend_unionse2' ") & & (" %4.2f `spend_unionse4' ") \\[2mm]"
	noisily display " N & " %6.0fc `n1' " & " %6.0fc `n2' " & " %6.0fc `n3' " & " %6.0fc `n4' "  \\[1mm] "
	noisily display " Year Fixed Effects & Yes & Yes & Yes & Yes \\"
	noisily display " State-Chamber Fixed Effects & Yes & Yes & Yes & Yes \\"
	noisily display " State Linear Time Trends & Yes & Yes & Yes & Yes \\"
	noisily display " \bottomrule \bottomrule "
	noisily display "\multicolumn{5}{p{0.6\textwidth}}{Robust standard errors clustered by state in parentheses.} \\"
	noisily display "\end{tabular}"
	noisily display "\end{center}"
	noisily display "\end{table}"
	log close

}


*** data table for appendix
use iv_data, clear
gen tmp = 1

keep if dem_frac != . & dem_year_share != .
egen min_year = min(year), by(state)
egen max_year = max(year), by(state)
collapse (sum) tmp (first) min_year max_year, by(state lower)
reshape wide tmp, i(state) j(lower)

foreach v in tmp0 tmp1  {
	replace `v' = 0 if `v' == .
}


local N = _N

quietly {
	cap log close
	set linesize 255
	log using "data.tex", replace text
	noisily display "\renewcommand{\tabcolsep}{.1cm}"
	noisily display "\begin{table}[ht]"
	noisily display "\centering"
	noisily display "\footnotesize"
	noisily display "\caption{\textbf{Observations in Merged Dataset with Contributions, by State and Chamber.} Each cell provides " ///
	"the total number of data points in the dataset used for analysis.\label{tab:data}}"
	noisily display "\begin{tabular}{cccccccccc}"
	noisily display "\toprule \toprule"
	noisily display "State & \# Upper House & \# Lower House " ///
	"  & Min Year & Max Year \\"
	noisily display "\midrule"

	forvalues j=1/`N' {
		noisily display state[`j'] " & " %3.0f tmp0[`j'] " & " %3.0f tmp1[`j'] ///
		" & " %4.0f min_year[`j'] " & " %4.0f max_year[`j'] " \\ "
	}

	noisily display "\bottomrule"
	noisily display "\end{tabular}"
	noisily display "\end{table}"
	
	log close
}




** Table 3, placebos
use pres_ban, clear

drop if state == "NE" | state == "DC"
drop if year <= 1950

gen union_ban = 0
replace union_ban = 1 if state == "AK" & year >=1996
replace union_ban = 1 if state == "AZ" & year >=1979
replace union_ban = 1 if state == "CO" & year >= 2003
replace union_ban = 1 if state == "MI" & year >= 1976
replace union_ban = 1 if state == "NH" & year >= 1979
replace union_ban = 1 if state == "NC" & year >= 1973
replace union_ban = 1 if state == "ND" & year >= 1995
replace union_ban = 1 if state == "OH" & year >= 2005
replace union_ban = 1 if state == "OK" & year >= 2007
replace union_ban = 1 if state == "PA" & year >= 1980
replace union_ban = 1 if state == "RI" & year >= 1988
replace union_ban = 1 if state == "SD" & year >= 2007
replace union_ban = 1 if state == "TX" & year >= 1987
replace union_ban = 1 if state == "WI" & year >= 1973
replace union_ban = 1 if state == "WY" & year >= 1977
rename union_ban ban_union

gen ban_both = ban_union*ban_corp

xi: reg usp_ ban_corp ban_union ban_both i.year i.state, cluster(state)
local treat1 = _b[ban_corp]
local se1 = _se[ban_corp]
local n1 = e(N)


use sen_ban, clear
drop if state == "NE" | state == "DC"
drop if year <= 1950
gen union_ban = 0
replace union_ban = 1 if state == "AK" & year >=1996
replace union_ban = 1 if state == "AZ" & year >=1979
replace union_ban = 1 if state == "CO" & year >= 2003
replace union_ban = 1 if state == "MI" & year >= 1976
replace union_ban = 1 if state == "NH" & year >= 1979
replace union_ban = 1 if state == "NC" & year >= 1973
replace union_ban = 1 if state == "ND" & year >= 1995
replace union_ban = 1 if state == "OH" & year >= 2005
replace union_ban = 1 if state == "OK" & year >= 2007
replace union_ban = 1 if state == "PA" & year >= 1980
replace union_ban = 1 if state == "RI" & year >= 1988
replace union_ban = 1 if state == "SD" & year >= 2007
replace union_ban = 1 if state == "TX" & year >= 1987
replace union_ban = 1 if state == "WI" & year >= 1973
replace union_ban = 1 if state == "WY" & year >= 1977
rename union_ban ban_union

gen ban_both = ban_union*ban_corp
xi: reg vote_share ban_corp ban_union ban_both i.state i.year if party=="D" & year > 1949, cluster(state)
local treat2 = _b[ban_corp]
local se2 = _se[ban_corp]
local n2 = e(N)

use house_ban, clear
drop if state == "NE" | state == "DC"
drop if year <= 1950
gen union_ban = 0
replace union_ban = 1 if state == "AK" & year >=1996
replace union_ban = 1 if state == "AZ" & year >=1979
replace union_ban = 1 if state == "CO" & year >= 2003
replace union_ban = 1 if state == "MI" & year >= 1976
replace union_ban = 1 if state == "NH" & year >= 1979
replace union_ban = 1 if state == "NC" & year >= 1973
replace union_ban = 1 if state == "ND" & year >= 1995
replace union_ban = 1 if state == "OH" & year >= 2005
replace union_ban = 1 if state == "OK" & year >= 2007
replace union_ban = 1 if state == "PA" & year >= 1980
replace union_ban = 1 if state == "RI" & year >= 1988
replace union_ban = 1 if state == "SD" & year >= 2007
replace union_ban = 1 if state == "TX" & year >= 1987
replace union_ban = 1 if state == "WI" & year >= 1973
replace union_ban = 1 if state == "WY" & year >= 1977
rename union_ban ban_union

gen ban_both = ban_union*ban_corp
xi: reg vote_share ban_corp ban_union ban_both i.state i.year if party=="D" & year > 1949, cluster(state)
local treat3 = _b[ban_corp]
local se3 = _se[ban_corp]
local n3 = e(N)


quietly {
	capture log close
	set linesize 255
	log using placebo.tex, text replace
	noisily display ""
	noisily display "\begin{table}[t] \caption{{\bf Placebo Tests.} Corporate contribution bans, which only affect state legislatures, "
	noisily display "do not have similar electoral effects on national political outcomes. \label{tab:placebo}}"
	noisily display "\vspace{-4mm}"
	noisily display "\begin{center}"
	noisily display "\footnotesize"
	noisily display "\begin{tabular}{lccc}"
	noisily display "\toprule\toprule"
	noisily display " & \multicolumn{3}{c}{Dem Vote Share, 1950--2010} \\[1mm]"
	noisily display " & \bf President & \bf Senate & \bf House \\"
	noisily display " \midrule "
	noisily display " Corporate Contribution Ban & " %4.2f `treat1' " & " %4.2f `treat2' " & " %4.2f `treat3' "  \\ "
	noisily display " & (" %4.2f `se1' ") & (" %4.2f `se2' ") & (" %4.2f `se3' ") \\[2mm]"
	noisily display " N & " %6.0fc `n1' " & " %6.0fc `n2' " & " %6.0fc `n3' "  \\[1mm] "
	noisily display " Year Fixed Effects & Yes & Yes & Yes \\"
	noisily display " State Fixed Effects & Yes & Yes & Yes \\"
	noisily display " \bottomrule \bottomrule "
	noisily display "\multicolumn{4}{p{0.5\textwidth}}{Robust standard errors clustered by state in parentheses.} \\"
	noisily display "\end{tabular}"
	noisily display "\end{center}"
	noisily display "\end{table}"
	log close

}

** Table 4, first stage

use iv_data, clear

replace dem_frac = 100*dem_frac
replace dem_year_share = 100 * dem_year_share

**** reduced form on this data and specification

xi: areg dem_frac ban_corp ban_union ban_both i.year if dem_year_share != ., a(state_chamber_id) cluster(state_chamber_id)
local treat1 = _b[ban_corp]
local se1 = _se[ban_corp]
local n1 = e(N)
local union1 = _b[ban_union]
local unionse1 = _se[ban_union]
local both1 = _b[ban_both]
local bothse1 = _se[ban_both]

xi: areg dem_frac ban_corp ban_union ban_both i.year if lower == 1 & dem_year_share != ., a(state) cluster(state_chamber_id)
local treat2 = _b[ban_corp]
local se2 = _se[ban_corp]
local n2 = e(N)
local union2 = _b[ban_union]
local unionse2 = _se[ban_union]
local both2 = _b[ban_both]
local bothse2 = _se[ban_both]

xi: areg dem_frac ban_corp ban_union ban_both i.year if lower == 0 & dem_year_share != ., a(state) cluster(state_chamber_id)
local treat3 = _b[ban_corp]
local se3 = _se[ban_corp]
local n3 = e(N)
local union3 = _b[ban_union]
local unionse3 = _se[ban_union]
local both3 = _b[ban_both]
local bothse3 = _se[ban_both]

xi: areg dem_year_share ban_corp ban_union ban_both i.year if dem_frac != ., a(state_chamber_id) cluster(state_chamber_id)
local treat4 = _b[ban_corp]
local se4 = _se[ban_corp]
local n4 = e(N)
local union4 = _b[ban_union]
local unionse4 = _se[ban_union]
local both4 = _b[ban_both]
local bothse4 = _se[ban_both]

testparm ban_corp ban_union ban_both

local f4 = r(F)
local p4 = r(p)

xi: areg dem_year_share ban_corp ban_union ban_both i.year if dem_frac != . & lower == 1, a(state) cluster(state_chamber_id)
local treat5 = _b[ban_corp]
local se5 = _se[ban_corp]
local n5 = e(N)
local union5 = _b[ban_union]
local unionse5 = _se[ban_union]
local both5 = _b[ban_both]
local bothse5 = _se[ban_both]

testparm ban_corp ban_union ban_both

local f5 = r(F)
local p5 = r(p)

xi: areg dem_year_share ban_corp ban_union ban_both i.year if dem_frac != . & lower == 0, a(state) cluster(state_chamber_id)
local treat6 = _b[ban_corp]
local se6 = _se[ban_corp]
local n6 = e(N)
local union6 = _b[ban_union]
local unionse6 = _se[ban_union]
local both6 = _b[ban_both]
local bothse6 = _se[ban_both]

testparm ban_corp ban_union ban_both

local f6 = r(F)
local p6 = r(p)

quietly {
	set linesize 255
	cap log close
	log using "first_stage.tex", text replace
	noisily display "\begin{table}[t]"
	noisily display "\centering"
	noisily display "\caption{{\bf Reduced Form and First Stage Effects of Corporate Contribution Bans, 1990--2012.}"
	noisily display "Corporate bans are seen to cause an increase in the Democratic share of the legislature and the Democratic share of all campaign contributions."
	noisily display "These effects are both much larger in state upper houses. \label{tab:trunc}}"
	noisily display "\begin{tabular}{lcccccc}"
	noisily display "\toprule \toprule"
	noisily display " & \multicolumn{3}{c}{\bf Dem Seat \%} & \multicolumn{3}{c}{\bf Dem Money \%} \\[1mm]"
	noisily display " & All & Lower House & Upper House & All & Lower House & Upper House \\"
	noisily display " \midrule"
	noisily display " Corporate Contribution & " %4.2f `treat1' " & " %4.2f `treat2' " & " %4.2f `treat3' " & " %4.2f `treat4' " & " %4.2f `treat5' " & " %4.2f `treat6' "\\"
	noisily display " Ban & (" %4.2f `se1' ") & (" %4.2f `se2' ") & (" %4.2f `se3' ") & (" %4.2f `se4' ") & (" %4.2f `se5' ") & (" %4.2f `se6' ") \\[2mm]"
	noisily display " First-Stage F-test & & & & " %4.2f `f4' " & " %4.2f `f5' " & " %4.2f `f6' " \\"
	noisily display "N & " %4.0f `n1' " & " %4.0f `n2' " & " %4.0f `n3' " & " %4.0f `n4' " & " %4.0f `n5' " & " %4.0f `n6' "\\"
	noisily display "Year Fixed Effects & Yes & Yes & Yes & Yes & Yes & Yes \\"
	noisily display "State-Chamber Fixed Effects & Yes & Yes & Yes & Yes & Yes & Yes \\"
	noisily display "\bottomrule \bottomrule\\[-4mm]"
	noisily display "\multicolumn{7}{p{.95\textwidth}}{All regressions include controls as in equation \ref{eq:money}.  Robust standard errors clustered by state-chamber in parentheses.} \\"
	noisily display "\end{tabular}"
	noisily display "\end{table}"
	log off

}


quietly {
	set linesize 255
	cap log close
	log using "first_stage_appendix.tex", text replace
	noisily display "\begin{table}[t]"
	noisily display "\centering"
	noisily display "\caption{{\bf Reduced Form and First Stage Effects of Corporate Contribution Bans, 1990--2012.}"
	noisily display "Corporate bans are seen to cause an increase in the Democratic share of the legislature and the Democratic share of all campaign contributions."
	noisily display "These effects are both much larger in state upper houses. \label{tab:trunc_appendix}}"
	noisily display "\begin{tabular}{lcccccc}"
	noisily display "\toprule \toprule"
	noisily display " & \multicolumn{3}{c}{\bf Dem Seat \%} & \multicolumn{3}{c}{\bf Dem Money \%} \\[1mm]"
	noisily display " & All & Lower House & Upper House & All & Lower House & Upper House \\"
	noisily display " \midrule"
	noisily display " Corporate Contribution & " %4.2f `treat1' " & " %4.2f `treat2' " & " %4.2f `treat3' " & " %4.2f `treat4' " & " %4.2f `treat5' " & " %4.2f `treat6' "\\"
	noisily display " Ban & (" %4.2f `se1' ") & (" %4.2f `se2' ") & (" %4.2f `se3' ") & (" %4.2f `se4' ") & (" %4.2f `se5' ") & (" %4.2f `se6' ") \\[2mm]"
	noisily display " Union Contribution & " %4.2f `union1' " & " %4.2f `union2' " & " %4.2f `union3' " & " %4.2f `union4' " & " %4.2f `union5' " & " %4.2f `union6' "\\"
	noisily display " Ban & (" %4.2f `unionse1' ") & (" %4.2f `unionse2' ") & (" %4.2f `unionse3' ") & (" %4.2f `unionse4' ") & (" %4.2f `unionse5' ") & (" %4.2f `unionse6' ") \\[2mm]"
	noisily display " Corporate Ban $\times$ Union Ban & " %4.2f `both1' " & " %4.2f `both2' " & " %4.2f `both3' " & " %4.2f `both4' " & " %4.2f `both5' " & " %4.2f `both6' "\\"
	noisily display "  & (" %4.2f `bothse1' ") & (" %4.2f `bothse2' ") & (" %4.2f `bothse3' ") & (" %4.2f `bothse4' ") & (" %4.2f `bothse5' ") & (" %4.2f `bothse6' ") \\[2mm]"
	noisily display "N & " %4.0f `n1' " & " %4.0f `n2' " & " %4.0f `n3' " & " %4.0f `n4' " & " %4.0f `n5' " & " %4.0f `n6' "\\"
	noisily display "Year Fixed Effects & Yes & Yes & Yes & Yes & Yes & Yes \\"
	noisily display "State-Chamber Fixed Effects & Yes & Yes & Yes & Yes & Yes & Yes \\"
	noisily display "\bottomrule \bottomrule\\[-4mm]"
	noisily display "\multicolumn{7}{p{.95\textwidth}}{All regressions include controls as in equation \ref{eq:money}.  Robust standard errors clustered by state-chamber in parentheses.} \\"
	noisily display "\end{tabular}"
	noisily display "\end{table}"
	log off

}


** Table 5, 2sls results

xi: ivregress 2sls dem_frac (dem_year_share = ban_corp ban_union ban_both) i.year i.state_chamber_id, cluster(state_chamber_id)
local money1 = _b[dem_year_share]
local semoney1 = _se[dem_year_share]
local moneyn1 = e(N)

xi: ivregress 2sls dem_frac (dem_year_share = ban_corp ban_union ban_both) i.year i.state_chamber_id if lower == 0, cluster(state_chamber_id)
local money2 = _b[dem_year_share]
local semoney2 = _se[dem_year_share]
local moneyn2 = e(N)

quietly {
	set linesize 255
	cap log close
	log using "iv.tex", text replace
	noisily display "\begin{table}[t]"
	noisily display "\centering"
	noisily display "\caption{{\bf 2SLS Estimates For Systemic Effects of Campaign Spending.}\label{tab:iv}}"
	noisily display "\begin{tabular}{lcc}"
	noisily display "\toprule \toprule"
	noisily display " & \multicolumn{2}{c}{\bf Dem Seat Share} \\"
	noisily display " & All & Upper House \\"
	noisily display " \midrule"
	noisily display " Dem Money Share & " %4.2f `money1' " & " %4.2f `money2'  "\\"
	noisily display " & (" %4.2f `semoney1' ") & (" %4.2f `semoney2' ")  \\[2mm]"
	noisily display "N & " %4.0f `moneyn1' " & " %4.0f `moneyn2' "\\"
	noisily display "Year Fixed Effects & Yes & Yes \\"
	noisily display "State-Chamber Fixed Effects & Yes & Yes  \\"
	noisily display "\bottomrule \bottomrule\\[-4mm]"
	noisily display "\multicolumn{3}{p{.55\textwidth}}{Regression specifications as in equation \ref{eq:2sls}.  Robust standard errors clustered by state-chamber in parentheses.  Lower House omitted due to lack of first stage effect.} \\"
	noisily display "\end{tabular}"
	noisily display "\end{table}"
	log off

}

*** Figure 1
*** preps data and saves; figure is produced in R
*** see separate R code for figure itself

use reduced_form_data, clear

keep if year >= 1970
drop if mod(year, 2) != 0

*** fix missing RI observation
replace dem_frac = .78 if year == 1982 & state == "RI" & lower == 0

egen tmp = group(state)
bys tmp: egen control_tmp = mean(ban_corp)
gen control = control_tmp == 0
gen treated = control_tmp > 0

*** drop states that are always treated
drop if control_tmp == 1
drop control_tmp

*** drop states that "switch off" treatment
sort tmp year
by tmp: gen test = 1 if ban_corp[_n] == 0 & ban_corp[_n-1] == 1
by tmp: egen test2 = max(test)
drop if test2 == 1
drop test test2

*** control mean by year
bys year: egen control_mean_tmp = mean(dem_frac) if control == 1
bys year: egen control_mean = max(control_mean_tmp)
drop control_mean_tmp
sort tmp year
by tmp: gen treat_year_tmp = year if ban_corp[_n] == 1 & ban_corp[_n-1] == 0
by tmp: egen treat_year = max(treat_year_tmp)
drop treat_year_tmp
gen t = year-treat_year
gen dem_frac_treat = dem_frac if treated == 1
collapse (mean) dem_frac_treat control_mean, by(t)
keep if abs(t) < 11

saveold diff_graph_for_r, replace

**** Analysis on statewide races for appendix Table A4

use tmp_rdd_us_statewide.dta, clear

*** drop senate elections
drop if office == "S"

gen ban = 0
replace ban = 1 if state == "AL" & year <= 1981
replace ban = 1 if state == "AK" & year >= 1996
replace ban = 1 if state == "AZ"
replace ban = 1 if state == "CO" & year <= 1963
replace ban = 1 if state == "CO" & year >= 2002
replace ban = 1 if state == "CT"
replace ban = 1 if state == "FL" & year <= 1967
replace ban = 1 if state == "GA" & year <= 1968
replace ban = 1 if state == "HI" & year <= 1973
replace ban = 1 if state == "IN" & year <= 1976
replace ban = 1 if state == "IA"
replace ban = 1 if state == "KY"
replace ban = 1 if state == "LA" & year <= 1975
replace ban = 1 if state == "MD" & year <= 1968
replace ban = 1 if state == "MA"
replace ban = 1 if state == "MI"
replace ban = 1 if state == "MN"
replace ban = 1 if state == "MS" & year <= 1978
replace ban = 1 if state == "MO" & year <= 1978
replace ban = 1 if state == "MT"
replace ban = 1 if state == "NE" & year <= 1976
replace ban = 1 if state == "NH" & year <= 2000
replace ban = 1 if state == "NY" & year <= 1974
replace ban = 1 if state == "NC"
replace ban = 1 if state == "ND" | state == "OH" | state =="OK" | state =="PA"
replace ban = 1 if state == "OR" & year <= 1983
replace ban = 1 if state == "RI" & year >= 1992
replace ban = 1 if state == "SD" | state == "TN" | state == "TX" | state == "WV" | state == "WI" | state =="WY"
replace ban = 1 if state == "UT" & year <= 1971

rename ban ban_corp


gen union_ban = 0
replace union_ban = 1 if state == "AK" & year >=1996
replace union_ban = 1 if state == "AZ" & year >=1979
replace union_ban = 1 if state == "CO" & year >= 2003
replace union_ban = 1 if state == "MI" & year >= 1976
replace union_ban = 1 if state == "NH" & year >= 1979
replace union_ban = 1 if state == "NC" & year >= 1973
replace union_ban = 1 if state == "ND" & year >= 1995
replace union_ban = 1 if state == "OH" & year >= 2005
replace union_ban = 1 if state == "OK" & year >= 2007
replace union_ban = 1 if state == "PA" & year >= 1980
replace union_ban = 1 if state == "RI" & year >= 1988
replace union_ban = 1 if state == "SD" & year >= 2007
replace union_ban = 1 if state == "TX" & year >= 1987
replace union_ban = 1 if state == "WI" & year >= 1973
replace union_ban = 1 if state == "WY" & year >= 1977
rename union_ban ban_union

gen b = 0
replace b =1 if state == "AK" & year >= 1996
replace b=1 if state == "AZ" & year >= 1978
replace b=1 if state == "CO" & year >= 2002
replace b=1 if state == "CT" & year >= 2000
replace b=1 if state == "IA" & year >= 2003
replace b=1 if state == "KY" & year >= 1974
replace b=1 if state == "MA" & year >= 1975
replace b=1 if state == "MI" & year >= 1976
replace b=1 if state == "MN" & year >= 1988
replace b=1 if state == "MT" & year >= 1912
replace b=1 if state == "NC" & year >= 1973
replace b=1 if state == "ND" & year >= 1981
replace b=1 if state == "OH" & year >= 1995
replace b=1 if state == "OK" & year >= 1994
replace b=1 if state == "PA" & year >= 1937
replace b=1 if state == "RI" & year >= 1998
replace b=1 if state == "SD" & year >= 2007
replace b=1 if state == "TN" & year >= 1972
replace b=1 if state == "TX" & year >= 1987
replace b=1 if state == "WV" & year >= 1908
replace b=1 if state == "WY" & year >= 1977
rename b ban_spend_corp

gen b = 0
replace b =1 if state == "AK" & year >= 1996
replace b=1 if state == "AZ" & year >= 1978
replace b=1 if state == "CO" & year >= 2002
replace b=1 if state == "MI" & year >= 1976
replace b=1 if state == "NH" & year >= 1979
replace b=1 if state == "NC" & year >= 1973
replace b=1 if state == "ND" & year >= 1981
replace b=1 if state == "OH" & year >= 1995
replace b=1 if state == "OK" & year >= 1994
replace b=1 if state == "PA" & year >= 1937
replace b=1 if state == "RI" & year >= 1998
replace b=1 if state == "SD" & year >= 2007
replace b=1 if state == "TX" & year >= 1987
replace b=1 if state == "WV" & year >= 1908
replace b=1 if state == "WY" & year >= 1977
rename b ban_spend_union


rename rv dem_frac
gen dem_maj = dem_frac > 0

egen tmp = group(state)


xi: areg dem_frac ban_corp i.year, a(tmp) cluster(tmp)
local treat1 = _b[ban_corp]
local se1 = _se[ban_corp]
local n1 = e(N)

xi: areg dem_frac ban_corp ban_union ban_spend* i.year, a(tmp) cluster(tmp)
local treat2 = _b[ban_corp]
local se2 = _se[ban_corp]
local n2 = e(N)
local union2 = _b[ban_union]
local unionse2 = _se[ban_union]
local spend_union2 = _b[ban_spend_union]
local spend_unionse2 = _se[ban_spend_union]
local spend_corp2 = _b[ban_spend_corp]
local spend_corpse2 = _se[ban_spend_corp]


xi: areg dem_maj ban_corp i.year, a(tmp) cluster(state)
local treat3 = _b[ban_corp]
local se3 = _se[ban_corp]
local n3 = e(N)


xi: areg dem_maj ban_corp ban_union ban_spend* i.year, a(tmp) cluster(tmp)
local treat4 = _b[ban_corp]
local se4 = _se[ban_corp]
local n4 = e(N)
local union4 = _b[ban_union]
local unionse4 = _se[ban_union]
local spend_union4 = _b[ban_spend_union]
local spend_unionse4 = _se[ban_spend_union]
local spend_corp4 = _b[ban_spend_corp]
local spend_corpse4 = _se[ban_spend_corp]

*** regression on just gov for note in Appendix
xi: areg dem_frac ban_corp i.year if office == "G", a(tmp) cluster(tmp)


quietly {
	capture log close
	set linesize 255
	log using statewide_appendix.tex, text replace
	noisily display ""
	noisily display "\begin{table}[h] \caption{{\bf Corporate Contribution Bans and Democratic Electoral Fortunes, U.S. Statewide Elections, 1950--2012}."
	noisily display "Corporate contribution bans are shown to cause a large increase in Democratic electoral fortunes. \label{tab:statewide}}"
	noisily display "\vspace{-4mm}"
	noisily display "\begin{center}"
	noisily display "\footnotesize"
	noisily display "\begin{tabular}{lcccc}"
	noisily display "\toprule\toprule"
	noisily display " & \multicolumn{2}{c}{\bf Dem Vote \%} & \multicolumn{2}{c}{\bf Dem Victory} \\"
	noisily display " \midrule "
	noisily display " Corporate Contribution Ban & " %4.2f `treat1' " & " %4.2f `treat2' " & " %4.2f `treat3' " & " %4.2f `treat4' "  \\ "
	noisily display " & (" %4.2f `se1' ") & (" %4.2f `se2' ") & (" %4.2f `se3' ") & (" %4.2f `se4' ")  \\[2mm]"
	noisily display " Union Contribution Ban & & " %4.2f `union2' " & & " %4.2f `union4' " \\"
	noisily display " &  & (" %4.2f `unionse2' ") & & (" %4.2f `unionse4' ") \\"
	noisily display " Corporate Spending Ban & & " %4.2f `spend_corp2' " & & " %4.2f `spend_corp4' " \\"
	noisily display " & & (" %4.2f `spend_corpse2' ") & & (" %4.2f `spend_corpse4' ") \\"
	noisily display " Union Spending Ban & & " %4.2f `spend_union2' " & & " %4.2f `spend_union4' " \\"
	noisily display "  & & (" %4.2f `spend_unionse2' ") & & (" %4.2f `spend_unionse4' ") \\[2mm]"
	noisily display " N & " %6.0fc `n1' " & " %6.0fc `n2' " & " %6.0fc `n3' " & " %6.0fc `n4' "  \\[1mm] "
	noisily display " Year Fixed Effects & Yes & Yes & Yes & Yes \\"
	noisily display " State-Chamber Fixed Effects & Yes & Yes & Yes & Yes \\"
	noisily display " \bottomrule \bottomrule "
	noisily display "\multicolumn{5}{p{0.6\textwidth}}{Robust standard errors clustered by state-chamber in parentheses.} \\"
	noisily display "\end{tabular}"
	noisily display "\end{center}"
	noisily display "\end{table}"
	log close
	
}




