*** Replication code for Hainmueller, Hall, and Snyder
*** Note that this file produces only a portion of the analyses in the paper
*** The remaing portion are produced in the accompanying R file

*** set working directory here
cd "~/Dropbox/RDD_Extrapolate"

*** set names of variables to use for CIA
local controlset1 = "lag lag2 lag_norm_vote lag_norm_vote2 midterm"
local controlset = "`controlset1'"
local controlset2 = "lag lag2 midterm lag_norm_vote"
local controlset3 = "lag lag_norm_vote"
local controlset0 = ""


*** load main dataset
use statewide_analysis, clear


***** make data table for appendix
preserve
gen tmp = 1
keep if lag != . & lag_norm_vote != . & dv != . & rv != .
egen min_year = min(year), by(state)
egen max_year = max(year), by(state)
collapse (sum) tmp (first) min_year max_year, by(state office)
replace office = subinstr(office, " ", "_", 3)
reshape wide tmp, i(state) j(office) string

foreach v in tmpATTY_GENL tmpAUDITOR tmpG tmpLT_GOV tmpS tmpSEC_STATE tmpTREASURER {
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
	noisily display "\caption{\textbf{Observations in Data Set, by State and Office.} Each cell provides " ///
	"the total number of data points in the dataset used for analysis, subset to observations with no missing values for Control Set 3.\label{tab:data}}"
	noisily display "\begin{tabular}{cccccccccc}"
	noisily display "\toprule \toprule"
	noisily display "State & \# Att Genl & \# Auditor & \# Gov & \# LT Gov & \# Senate" ///
	" & \# Sec State & \# Treasurer & Min Year & Max Year \\"

	forvalues j=1/`N' {
		noisily display state[`j'] " & " %3.0f tmpATTY_GENL[`j'] " & " %3.0f tmpAUDITOR[`j'] ///
		" & " %3.0f tmpG[`j'] " & " %3.0f tmpLT_GOV[`j'] " & " %3.0f tmpS[`j'] ///
		" & " %3.0f tmpSEC_STATE[`j'] " & " %3.0f tmpTREASURER[`j'] " & " ///
		%4.0f min_year[`j'] " & " %4.0f max_year[`j'] " \\ "
	}

	noisily display "\bottomrule"
	noisily display "\end{tabular}"
	noisily display "\end{table}"
	
	log close
}

restore

*** Test for CIA on each side of discontinuity

	cap log close
	set linesize 255
	log using "CIAtest", replace text
	eststo clear
forvalues j=0/3 {
     
	di "Window: 5 D=0" 
	eststo: reg dv rv `controlset`j'' if treat == 0 & rv > -5, r
	local bal1_`j' = _b[rv]
	local bal1se_`j' = _se[rv]
	local n10_`j' = e(N)
	
	di "Window: 5 D=1"
	eststo: reg dv rv `controlset`j'' if treat == 1 & rv < 5, r
	local bal2_`j' = _b[rv]
	local bal2se_`j' = _se[rv]
	local n11_`j' = e(N)
	
	di "Window: 10 D=0"
	eststo: reg dv rv `controlset`j'' if treat == 0 & rv > -10, r
	local bal3_`j' = _b[rv]
	local bal3se_`j' = _se[rv]
	local n20_`j' = e(N)
	
	di "Window: 10 D=1"
	eststo: reg dv rv `controlset`j'' if treat == 1 & rv < 10, r
	local bal4_`j' = _b[rv]
	local bal4se_`j' = _se[rv]
	local n21_`j' = e(N)
	
	di "Window: 15 D=0"
	eststo: reg dv rv `controlset`j'' if treat == 0 & rv > -15, r
	local bal5_`j' = _b[rv]
	local bal5se_`j' = _se[rv]
	local n30_`j' = e(N)
	
	di "Window: 15 D=1"
	eststo: reg dv rv `controlset`j'' if treat == 1 & rv < 15, r
	local bal6_`j' = _b[rv]
	local bal6se_`j' = _se[rv]
	local n31_`j' = e(N)
	
	di "Window: 20 D=0"
	eststo: reg dv rv `controlset`j'' if treat == 0 & rv > -20, r
	local bal7_`j' = _b[rv]
	local bal7se_`j' = _se[rv]
	local n40_`j' = e(N)
	
	di "Window: 20 D=1"
	eststo: reg dv rv `controlset`j'' if treat == 1 & rv < 20, r
	local bal8_`j' = _b[rv]
	local bal8se_`j' = _se[rv]
	local n41_`j' = e(N)
	
	di "Window: 25 D=0"
	eststo: reg dv rv `controlset`j'' if treat == 0 & rv > -25, r
	local bal9_`j' = _b[rv]
	local bal9se_`j' = _se[rv]
	local n50_`j' = e(N)
	
	di "Window: 25 D=1"
	eststo: reg dv rv `controlset`j'' if treat == 1 & rv < 25, r
	local bal10_`j' = _b[rv]
	local bal10se_`j' = _se[rv]
	local n51_`j' = e(N)
	
	di "Window: 30 D=0"
	eststo: reg dv rv `controlset`j'' if treat == 0 & rv > -30, r
	local bal11_`j' = _b[rv]
	local bal11se_`j' = _se[rv]
	local n60_`j' = e(N)
	
	di "Window: 30 D=1"
	eststo: reg dv rv `controlset`j'' if treat == 1 & rv < 30, r
	local bal12_`j' = _b[rv]
	local bal12se_`j' = _se[rv]
	local n61_`j' = e(N)

	di "Window: 35 D=0"
	eststo: reg dv rv `controlset`j'' if treat == 0 & rv > -35, r
	local bal13_`j' = _b[rv]
	local bal13se_`j' = _se[rv]
	local n70_`j' = e(N)
	
	di "Window: 35 D=1"
	eststo: reg dv rv `controlset`j'' if treat == 1 & rv < 35, r
	local bal14_`j' = _b[rv]
	local bal14se_`j' = _se[rv]
	local n71_`j' = e(N)
	
	di "Window: 40 D=0"
	eststo: reg dv rv `controlset`j'' if treat == 0 & rv > -40, r
	local bal15_`j' = _b[rv]
	local bal15se_`j' = _se[rv]
	local n80_`j' = e(N)
	
	di "Window: 40 D=1"
	eststo: reg dv rv `controlset`j'' if treat == 1 & rv < 40, r
	local bal16_`j' = _b[rv]
	local bal16se_`j' = _se[rv]
	local n81_`j' = e(N)
}

*** make CIA table

quietly {
	cap log close
	set linesize 255
	log using "balance.tex", replace text
	noisily dis "\begin{table}[h!]"
	noisily dis "\centering"
	noisily dis "\caption{{\bf Conditional Independence Tests. \label{tab:cia}}  Presents CIA tests from equation \ref{eq:test} to the left of the discontinuity (D=0) and to the right (D=1)."  "
	noisily dis "The CIA appears to be satisfied at windows as large as size 10, and partially satisfied at 15.}"
	noisily dis "\begin{tabular}{ccccccccc}"
	noisily dis "\toprule \toprule"
	noisily dis "& \multicolumn{2}{c}{\bf Control Set 1:} & & \multicolumn{2}{c}{\bf Control Set 2:} & & \multicolumn{2}{c}{\bf Control Set 3:} \\"
	noisily dis "& \multicolumn{2}{c}{$\mathit{Dem \ Share}_{t-1}$} & & \multicolumn{2}{c}{$\mathit{Dem \ Share}_{t-1}$} & & \multicolumn{2}{c}{$\mathit{Dem \ Share}_{t-1}$} \\"
	noisily dis "& \multicolumn{2}{c}{$\mathit{Dem \ Share}_{t-2}$} & & \multicolumn{2}{c}{$\mathit{Dem \ Share}_{t-2}$} & & \multicolumn{2}{c}{$\mathit{Normal \ Vote}_{t-1}$} \\"
	noisily dis "& \multicolumn{2}{c}{$\mathit{Normal \ Vote}_{t-1}$} & & \multicolumn{2}{c}{$\mathit{Normal \ Vote}_{t-1}$} & &  & \\"
	noisily dis "& \multicolumn{2}{c}{$\mathit{Normal \ Vote}_{t-2}$} & & \multicolumn{2}{c}{$\mathit{Midterm \ Slump}_{t}$} & &  & \\"
	noisily dis "& \multicolumn{2}{c}{$\mathit{Midterm \ Slump}_t$} & & & & &  & \\[2mm]"
	noisily dis "Window  & D=0 & D=1 & & D=0 & D=1 & & D=0 & D=1 \\"
	noisily dis "\midrule "
	noisily dis "\bf 5 & " %5.2f `bal1_1' " & " %5.2f `bal2_1' "& & " %5.2f `bal1_2' " & " %5.2f `bal2_2' " & & " %5.2f `bal1_3' " & " %5.2f `bal2_3' " \\ "
	noisily dis " & (" %3.2f `bal1se_1' ") & (" %3.2f `bal2se_1' ") & & (" %3.2f `bal1se_2' ") & (" %3.2f `bal2se_2' ") & & (" %3.2f `bal1se_3' ") & (" %3.2f `bal2se_3' ") \\"
	noisily dis " & \emph{N="%3.0f `n10_1' "} & \emph{N="%3.0f `n11_1' "} & & \emph{N="%3.0f `n10_2' "}  & \emph{N="%3.0f `n11_2' "} & & \emph{N="%3.0f `n10_3' "} & \emph{N="%3.0f `n11_3' "} \\[2mm]"
	noisily dis "\bf 10 & " %5.2f `bal3_1' " & " %5.2f `bal4_1' "& & " %5.2f `bal3_2' " & " %5.2f `bal4_2' "& & " %5.2f `bal3_3' " & " %5.2f `bal4_3' " \\ "
	noisily dis " & (" %3.2f `bal3se_1' ") & (" %3.2f `bal4se_1' ") & & (" %3.2f `bal3se_2' ") & (" %3.2f `bal4se_2' ") & & (" %3.2f `bal3se_3' ") & (" %3.2f `bal4se_3' ") \\"
	noisily dis " & \emph{N="%3.0f `n20_1' "} & \emph{N=" %3.0f `n21_1' "} & & \emph{N="%3.0f `n20_2' "} & \emph{N="%3.0f `n21_2' "} & & \emph{N="%3.0f `n20_3' "} & \emph{N="%3.0f `n21_3' "} \\[2mm]"
	noisily dis "\midrule\\"
	noisily dis "\bf 15 & " %5.2f `bal5_1' " & " %5.2f `bal6_1' "& & " %5.2f `bal5_2' " & " %5.2f `bal6_2' "& & " %5.2f `bal5_3' " & " %5.2f `bal6_3' " \\ "
	noisily dis " & (" %3.2f `bal5se_1' ") & (" %3.2f `bal6se_1' ") & & (" %3.2f `bal5se_2' ") & (" %3.2f `bal6se_2' ") & & (" %3.2f `bal5se_3' ") & (" %3.2f `bal6se_3' ") \\"
	noisily dis " & \emph{N="%4.0f `n30_1' "} & \emph{N=" %4.0f `n31_1' "} & & \emph{N="%4.0f `n30_2' "} & \emph{N="%4.0f `n31_2' "} & & \emph{N="%4.0f `n30_3' "} & \emph{N="%4.0f `n31_3' "} \\[4mm]"
	noisily dis "\midrule\\"
	noisily dis "20 & " %5.2f `bal7_1' " & " %5.2f `bal8_1' "& & " %5.2f `bal7_2' " & " %5.2f `bal8_2' "& & " %5.2f `bal7_3' " & " %5.2f `bal8_3' " \\ "
	noisily dis " & (" %3.2f `bal7se_1' ") & (" %3.2f `bal8se_1' ") & & (" %3.2f `bal7se_2' ") & (" %3.2f `bal8se_2' ") & & (" %3.2f `bal7se_3' ") & (" %3.2f `bal8se_3' ") \\"
	noisily dis " & \emph{N="%4.0f `n40_1' "} & \emph{N=" %4.0f `n41_1' "} & & \emph{N="%4.0f `n40_2' "} & \emph{N="%4.0f `n41_2' "} & & \emph{N="%4.0f `n40_3' "} & \emph{N="%4.0f `n41_3' "} \\[2mm]"

	noisily dis "25 & " %5.2f `bal9_1' " & " %5.2f `bal10_1' "& & " %5.2f `bal9_2' " & " %5.2f `bal10_2' "& & " %5.2f `bal9_3' " & " %5.2f `bal10_3' " \\ "
	noisily dis " & (" %3.2f `bal9se_1' ") & (" %3.2f `bal10se_1' ") & & (" %3.2f `bal9se_2' ") & (" %3.2f `bal10se_2' ") & & (" %3.2f `bal9se_3' ") & (" %3.2f `bal10se_3' ") \\"
	noisily dis " & \emph{N="%4.0f `n50_1' "} & \emph{N=" %4.0f `n51_1' "} & & \emph{N="%4.0f `n50_2' "} & \emph{N="%4.0f `n51_2' "} & & \emph{N="%4.0f `n50_3' "} & \emph{N="%4.0f `n51_3' "} \\[2mm]"

	noisily dis "30 & " %5.2f `bal11_1' " & " %5.2f `bal12_1' "& & " %5.2f `bal11_2' " & " %5.2f `bal12_2' "& & " %5.2f `bal11_3' " & " %5.2f `bal12_3' " \\ "
	noisily dis " & (" %3.2f `bal11se_1' ") & (" %3.2f `bal12se_1' ") & & (" %3.2f `bal11se_2' ") & (" %3.2f `bal12se_2' ") & & (" %3.2f `bal11se_3' ") & (" %3.2f `bal12se_3' ") \\"
	noisily dis " & \emph{N="%4.0f `n60_1' "} & \emph{N=" %4.0f `n61_1' "} & & \emph{N="%4.0f `n60_2' "} & \emph{N="%4.0f `n61_2' "} & & \emph{N="%4.0f `n60_3' "} & \emph{N="%4.0f `n61_3' "} \\[2mm]"

	noisily dis "35 & " %5.2f `bal13_1' " & " %5.2f `bal14_1' "& & " %5.2f `bal13_2' " & " %5.2f `bal14_2' "& & " %5.2f `bal13_3' " & " %5.2f `bal14_3' " \\ "
	noisily dis " & (" %3.2f `bal13se_1' ") & (" %3.2f `bal14se_1' ") & & (" %3.2f `bal13se_2' ") & (" %3.2f `bal14se_2' ") & & (" %3.2f `bal13se_3' ") & (" %3.2f `bal14se_3' ") \\"
	noisily dis " & \emph{N="%4.0f `n70_1' "} & \emph{N=" %4.0f `n71_1' "} & & \emph{N="%4.0f `n70_2' "} & \emph{N="%4.0f `n71_2' "} & & \emph{N="%4.0f `n70_3' "} & \emph{N="%4.0f `n71_3' "} \\[2mm]"

	noisily dis "40 & " %5.2f `bal15_1' " & " %5.2f `bal16_1' "& & " %5.2f `bal15_2' " & " %5.2f `bal16_2' "& & " %5.2f `bal15_3' " & " %5.2f `bal16_3' " \\ "
	noisily dis " & (" %3.2f `bal15se_1' ") & (" %3.2f `bal16se_1' ") & & (" %3.2f `bal15se_2' ") & (" %3.2f `bal16se_2' ") & & (" %3.2f `bal15se_3' ") & (" %3.2f `bal16se_3' ") \\"
	noisily dis " & \emph{N="%4.0f `n80_1' "} & \emph{N=" %4.0f `n81_1' "} & & \emph{N="%4.0f `n80_2' "} & \emph{N="%4.0f `n81_2' "} & & \emph{N="%4.0f `n80_3' "} & \emph{N="%4.0f `n81_3' "} \\"

	noisily dis "\bottomrule"
	noisily dis "\multicolumn{9}{p{0.8\textwidth}}{\footnotesize Robust standard errors in parentheses.  $ V_{i,t}$ and $ Y_{i,t+1}$ measured in percentage points. }"
	noisily dis "\end{tabular}"
	noisily dis "\end{table}"

	log close
}

** CIA Table for appendix for case without covars

quietly {
	cap log close
	set linesize 255
	log using "balanceNoControls.tex", replace text
	noisily dis "\begin{table}[h!]"
	noisily dis "\centering"
	noisily dis "\caption{{\bf Conditional Independence Tests. \label{tab:ciaNoCovars}}  Presents CIA tests from equation \ref{eq:test} without any covariates to the left of the discontinuity (D=0) and to the right (D=1)."  "
	noisily dis "The CIA appears to be questionable at windows as small as size 10, and fails at 15.}"
	noisily dis "\begin{tabular}{ccc}"
	noisily dis "\toprule \toprule"
	noisily dis "& \multicolumn{2}{c}{\bf No Controls:}  \\"
	noisily dis "Window  & D=0 & D=1  \\"
	noisily dis "\midrule "
	noisily dis "\bf 5 & " %5.2f `bal1_0' " & " %5.2f `bal2_0' " \\ "
	noisily dis " & (" %3.2f `bal1se_0' ") & (" %3.2f `bal2se_0' ") \\"
	noisily dis " & \emph{N="%3.0f `n10_0' "} & \emph{N="%3.0f `n11_0' "}  \\[2mm]"
		noisily dis "\midrule\\"
	noisily dis "\bf 10 & " %5.2f `bal3_0' " & " %5.2f `bal4_0' " \\ "
	noisily dis " & (" %3.2f `bal3se_0' ") & (" %3.2f `bal4se_0' ")  \\"
	noisily dis " & \emph{N="%3.0f `n20_0' "} & \emph{N=" %3.0f `n21_0' "}  \\[2mm]"
	noisily dis "\midrule\\"
	noisily dis "\bf 15 & " %5.2f `bal5_0' " & " %5.2f `bal6_0' " \\ "
	noisily dis " & (" %3.2f `bal5se_0' ") & (" %3.2f `bal6se_0' ")  \\"
	noisily dis " & \emph{N="%4.0f `n30_0' "} & \emph{N=" %4.0f `n31_0' "}  \\[4mm]"
	noisily dis "\midrule\\"
	noisily dis "20 & " %5.2f `bal7_0' " & " %5.2f `bal8_0' " \\ "
	noisily dis " & (" %3.2f `bal7se_0' ") & (" %3.2f `bal8se_0' ")  \\"
	noisily dis " & \emph{N="%4.0f `n40_0' "} & \emph{N=" %4.0f `n41_0' "}  \\[2mm]"

	noisily dis "25 & " %5.2f `bal9_0' " & " %5.2f `bal10_0' " \\ "
	noisily dis " & (" %3.2f `bal9se_0' ") & (" %3.2f `bal10se_0' ") \\"
	noisily dis " & \emph{N="%4.0f `n50_0' "} & \emph{N=" %4.0f `n51_0' "} \\[2mm]"

	noisily dis "30 & " %5.2f `bal11_0' " & " %5.2f `bal12_0' " \\ "
	noisily dis " & (" %3.2f `bal11se_0' ") & (" %3.2f `bal12se_0' ") \\"
	noisily dis " & \emph{N="%4.0f `n60_0' "} & \emph{N=" %4.0f `n61_0' "}  \\[2mm]"

	noisily dis "35 & " %5.2f `bal13_0' " & " %5.2f `bal14_0' " \\ "
	noisily dis " & (" %3.2f `bal13se_0' ") & (" %3.2f `bal14se_0' ")  \\"
	noisily dis " & \emph{N="%4.0f `n70_0' "} & \emph{N=" %4.0f `n71_0' "}  \\[2mm]"

	noisily dis "40 & " %5.2f `bal15_0' " & " %5.2f `bal16_0' " \\ "
	noisily dis " & (" %3.2f `bal15se_0' ") & (" %3.2f `bal16se_0' ")  \\"
	noisily dis " & \emph{N="%4.0f `n80_0' "} & \emph{N=" %4.0f `n81_0' "}  \\"

	noisily dis "\bottomrule"
	noisily dis "\multicolumn{3}{p{0.4\textwidth}}{\footnotesize Robust standard errors in parentheses.  $ V_{i,t}$ and $ Y_{i,t+1}$ measured in percentage points. }"
	noisily dis "\end{tabular}"
	noisily dis "\end{table}"

	log close
}



* run CIA tests for republicans

*** make republican rv and republican treat
reg dv treat rv rv_treat if abs(rv) < 2 & lag!=. & lag_norm_vote!=.

drop lag* 
replace treat = 1-treat
replace rv = -1*rv
replace rv_treat = rv * treat

*** create lags
sort state office year
by state office: gen lag = rv[_n-1]
by state office: gen lag2 = rv[_n-2]
by state office: gen lag3 = rv[_n-3]
by state office: gen lag4 = rv[_n-4]

gen lag_sq = lag^2

sort state year
drop norm_vote 
by state year: egen norm_vote = mean(pct_R)
sort state office year
by state office: gen lag_norm_vote = norm_vote[_n-1]
by state office: gen lag_norm_vote2 = norm_vote[_n-2]

drop dv dv_win
gen dv     = 100*((next_pct_R) / (next_pct_D + next_pct_R))
gen dv_win = next_win_R
reg dv treat rv rv_treat if abs(rv) < 2 & lag!=. & lag_norm_vote!=.



*** Test for CIA on each side of discontinuity for Republicans

	cap log close
	set linesize 255
	log using "CIAtest", replace text
	eststo clear
forvalues j=0/3 {
     
	di "Window: 5 D=0" 
	eststo: reg dv rv `controlset`j'' if treat == 0 & rv > -5, r
	local bal1_`j' = _b[rv]
	local bal1se_`j' = _se[rv]
	local n10_`j' = e(N)
	
	di "Window: 5 D=1"
	eststo: reg dv rv `controlset`j'' if treat == 1 & rv < 5, r
	local bal2_`j' = _b[rv]
	local bal2se_`j' = _se[rv]
	local n11_`j' = e(N)
	
	di "Window: 10 D=0"
	eststo: reg dv rv `controlset`j'' if treat == 0 & rv > -10, r
	local bal3_`j' = _b[rv]
	local bal3se_`j' = _se[rv]
	local n20_`j' = e(N)
	
	di "Window: 10 D=1"
	eststo: reg dv rv `controlset`j'' if treat == 1 & rv < 10, r
	local bal4_`j' = _b[rv]
	local bal4se_`j' = _se[rv]
	local n21_`j' = e(N)
	
	di "Window: 15 D=0"
	eststo: reg dv rv `controlset`j'' if treat == 0 & rv > -15, r
	local bal5_`j' = _b[rv]
	local bal5se_`j' = _se[rv]
	local n30_`j' = e(N)
	
	di "Window: 15 D=1"
	eststo: reg dv rv `controlset`j'' if treat == 1 & rv < 15, r
	local bal6_`j' = _b[rv]
	local bal6se_`j' = _se[rv]
	local n31_`j' = e(N)
	
	di "Window: 20 D=0"
	eststo: reg dv rv `controlset`j'' if treat == 0 & rv > -20, r
	local bal7_`j' = _b[rv]
	local bal7se_`j' = _se[rv]
	local n40_`j' = e(N)
	
	di "Window: 20 D=1"
	eststo: reg dv rv `controlset`j'' if treat == 1 & rv < 20, r
	local bal8_`j' = _b[rv]
	local bal8se_`j' = _se[rv]
	local n41_`j' = e(N)
	
	di "Window: 25 D=0"
	eststo: reg dv rv `controlset`j'' if treat == 0 & rv > -25, r
	local bal9_`j' = _b[rv]
	local bal9se_`j' = _se[rv]
	local n50_`j' = e(N)
	
	di "Window: 25 D=1"
	eststo: reg dv rv `controlset`j'' if treat == 1 & rv < 25, r
	local bal10_`j' = _b[rv]
	local bal10se_`j' = _se[rv]
	local n51_`j' = e(N)
	
	di "Window: 30 D=0"
	eststo: reg dv rv `controlset`j'' if treat == 0 & rv > -30, r
	local bal11_`j' = _b[rv]
	local bal11se_`j' = _se[rv]
	local n60_`j' = e(N)
	
	di "Window: 30 D=1"
	eststo: reg dv rv `controlset`j'' if treat == 1 & rv < 30, r
	local bal12_`j' = _b[rv]
	local bal12se_`j' = _se[rv]
	local n61_`j' = e(N)

	di "Window: 35 D=0"
	eststo: reg dv rv `controlset`j'' if treat == 0 & rv > -35, r
	local bal13_`j' = _b[rv]
	local bal13se_`j' = _se[rv]
	local n70_`j' = e(N)
	
	di "Window: 35 D=1"
	eststo: reg dv rv `controlset`j'' if treat == 1 & rv < 35, r
	local bal14_`j' = _b[rv]
	local bal14se_`j' = _se[rv]
	local n71_`j' = e(N)
	
	di "Window: 40 D=0"
	eststo: reg dv rv `controlset`j'' if treat == 0 & rv > -40, r
	local bal15_`j' = _b[rv]
	local bal15se_`j' = _se[rv]
	local n80_`j' = e(N)
	
	di "Window: 40 D=1"
	eststo: reg dv rv `controlset`j'' if treat == 1 & rv < 40, r
	local bal16_`j' = _b[rv]
	local bal16se_`j' = _se[rv]
	local n81_`j' = e(N)
}


*** make CIA table for Republicans

quietly {
	cap log close
	set linesize 255
	log using "balanceReps.tex", replace text
	noisily dis "\begin{table}[h!]"
	noisily dis "\centering"
	noisily dis "\caption{{\bf Conditional Independence Tests for Republicans. \label{tab:ciaReps}}  Presents CIA tests from equation \ref{eq:test} to the left of the discontinuity (D=0) and to the right (D=1)."  "
	noisily dis "The CIA appears to be satisfied at windows as large as size 10, and partially satisfied at 15.}"
	noisily dis "\begin{tabular}{ccccccccc}"
	noisily dis "\toprule \toprule"
	noisily dis "& \multicolumn{2}{c}{\bf Control Set 1:} & & \multicolumn{2}{c}{\bf Control Set 2:} & & \multicolumn{2}{c}{\bf Control Set 3:} \\"
	noisily dis "& \multicolumn{2}{c}{$\mathit{Rep \ Share}_{t-1}$} & & \multicolumn{2}{c}{$\mathit{Rep \ Share}_{t-1}$} & & \multicolumn{2}{c}{$\mathit{Rep \ Share}_{t-1}$} \\"
	noisily dis "& \multicolumn{2}{c}{$\mathit{Rep \ Share}_{t-2}$} & & \multicolumn{2}{c}{$\mathit{Rep \ Share}_{t-2}$} & & \multicolumn{2}{c}{$\mathit{Normal \ Vote}_{t-1}$} \\"
	noisily dis "& \multicolumn{2}{c}{$\mathit{Normal \ Vote}_{t-1}$} & & \multicolumn{2}{c}{$\mathit{Normal \ Vote}_{t-1}$} & &  & \\"
	noisily dis "& \multicolumn{2}{c}{$\mathit{Normal \ Vote}_{t-2}$} & & \multicolumn{2}{c}{$\mathit{Midterm \ Slump}_{t}$} & &  & \\"
	noisily dis "& \multicolumn{2}{c}{$\mathit{Midterm \ Slump}_t$} & & & & &  & \\[2mm]"
	noisily dis "Window  & D=0 & D=1 & & D=0 & D=1 & & D=0 & D=1 \\"
	noisily dis "\midrule "
	noisily dis "\bf 5 & " %5.2f `bal1_1' " & " %5.2f `bal2_1' "& & " %5.2f `bal1_2' " & " %5.2f `bal2_2' " & & " %5.2f `bal1_3' " & " %5.2f `bal2_3' " \\ "
	noisily dis " & (" %3.2f `bal1se_1' ") & (" %3.2f `bal2se_1' ") & & (" %3.2f `bal1se_2' ") & (" %3.2f `bal2se_2' ") & & (" %3.2f `bal1se_3' ") & (" %3.2f `bal2se_3' ") \\"
	noisily dis " & \emph{N="%3.0f `n10_1' "} & \emph{N="%3.0f `n11_1' "} & & \emph{N="%3.0f `n10_2' "}  & \emph{N="%3.0f `n11_2' "} & & \emph{N="%3.0f `n10_3' "} & \emph{N="%3.0f `n11_3' "} \\[2mm]"
	noisily dis "\bf 10 & " %5.2f `bal3_1' " & " %5.2f `bal4_1' "& & " %5.2f `bal3_2' " & " %5.2f `bal4_2' "& & " %5.2f `bal3_3' " & " %5.2f `bal4_3' " \\ "
	noisily dis " & (" %3.2f `bal3se_1' ") & (" %3.2f `bal4se_1' ") & & (" %3.2f `bal3se_2' ") & (" %3.2f `bal4se_2' ") & & (" %3.2f `bal3se_3' ") & (" %3.2f `bal4se_3' ") \\"
	noisily dis " & \emph{N="%3.0f `n20_1' "} & \emph{N=" %3.0f `n21_1' "} & & \emph{N="%3.0f `n20_2' "} & \emph{N="%3.0f `n21_2' "} & & \emph{N="%3.0f `n20_3' "} & \emph{N="%3.0f `n21_3' "} \\[2mm]"
	noisily dis "\midrule\\"
	noisily dis "\bf 15 & " %5.2f `bal5_1' " & " %5.2f `bal6_1' "& & " %5.2f `bal5_2' " & " %5.2f `bal6_2' "& & " %5.2f `bal5_3' " & " %5.2f `bal6_3' " \\ "
	noisily dis " & (" %3.2f `bal5se_1' ") & (" %3.2f `bal6se_1' ") & & (" %3.2f `bal5se_2' ") & (" %3.2f `bal6se_2' ") & & (" %3.2f `bal5se_3' ") & (" %3.2f `bal6se_3' ") \\"
	noisily dis " & \emph{N="%4.0f `n30_1' "} & \emph{N=" %4.0f `n31_1' "} & & \emph{N="%4.0f `n30_2' "} & \emph{N="%4.0f `n31_2' "} & & \emph{N="%4.0f `n30_3' "} & \emph{N="%4.0f `n31_3' "} \\[4mm]"
	noisily dis "\midrule\\"
	noisily dis "20 & " %5.2f `bal7_1' " & " %5.2f `bal8_1' "& & " %5.2f `bal7_2' " & " %5.2f `bal8_2' "& & " %5.2f `bal7_3' " & " %5.2f `bal8_3' " \\ "
	noisily dis " & (" %3.2f `bal7se_1' ") & (" %3.2f `bal8se_1' ") & & (" %3.2f `bal7se_2' ") & (" %3.2f `bal8se_2' ") & & (" %3.2f `bal7se_3' ") & (" %3.2f `bal8se_3' ") \\"
	noisily dis " & \emph{N="%4.0f `n40_1' "} & \emph{N=" %4.0f `n41_1' "} & & \emph{N="%4.0f `n40_2' "} & \emph{N="%4.0f `n41_2' "} & & \emph{N="%4.0f `n40_3' "} & \emph{N="%4.0f `n41_3' "} \\[2mm]"

	noisily dis "25 & " %5.2f `bal9_1' " & " %5.2f `bal10_1' "& & " %5.2f `bal9_2' " & " %5.2f `bal10_2' "& & " %5.2f `bal9_3' " & " %5.2f `bal10_3' " \\ "
	noisily dis " & (" %3.2f `bal9se_1' ") & (" %3.2f `bal10se_1' ") & & (" %3.2f `bal9se_2' ") & (" %3.2f `bal10se_2' ") & & (" %3.2f `bal9se_3' ") & (" %3.2f `bal10se_3' ") \\"
	noisily dis " & \emph{N="%4.0f `n50_1' "} & \emph{N=" %4.0f `n51_1' "} & & \emph{N="%4.0f `n50_2' "} & \emph{N="%4.0f `n51_2' "} & & \emph{N="%4.0f `n50_3' "} & \emph{N="%4.0f `n51_3' "} \\[2mm]"

	noisily dis "30 & " %5.2f `bal11_1' " & " %5.2f `bal12_1' "& & " %5.2f `bal11_2' " & " %5.2f `bal12_2' "& & " %5.2f `bal11_3' " & " %5.2f `bal12_3' " \\ "
	noisily dis " & (" %3.2f `bal11se_1' ") & (" %3.2f `bal12se_1' ") & & (" %3.2f `bal11se_2' ") & (" %3.2f `bal12se_2' ") & & (" %3.2f `bal11se_3' ") & (" %3.2f `bal12se_3' ") \\"
	noisily dis " & \emph{N="%4.0f `n60_1' "} & \emph{N=" %4.0f `n61_1' "} & & \emph{N="%4.0f `n60_2' "} & \emph{N="%4.0f `n61_2' "} & & \emph{N="%4.0f `n60_3' "} & \emph{N="%4.0f `n61_3' "} \\[2mm]"

	noisily dis "35 & " %5.2f `bal13_1' " & " %5.2f `bal14_1' "& & " %5.2f `bal13_2' " & " %5.2f `bal14_2' "& & " %5.2f `bal13_3' " & " %5.2f `bal14_3' " \\ "
	noisily dis " & (" %3.2f `bal13se_1' ") & (" %3.2f `bal14se_1' ") & & (" %3.2f `bal13se_2' ") & (" %3.2f `bal14se_2' ") & & (" %3.2f `bal13se_3' ") & (" %3.2f `bal14se_3' ") \\"
	noisily dis " & \emph{N="%4.0f `n70_1' "} & \emph{N=" %4.0f `n71_1' "} & & \emph{N="%4.0f `n70_2' "} & \emph{N="%4.0f `n71_2' "} & & \emph{N="%4.0f `n70_3' "} & \emph{N="%4.0f `n71_3' "} \\[2mm]"

	noisily dis "40 & " %5.2f `bal15_1' " & " %5.2f `bal16_1' "& & " %5.2f `bal15_2' " & " %5.2f `bal16_2' "& & " %5.2f `bal15_3' " & " %5.2f `bal16_3' " \\ "
	noisily dis " & (" %3.2f `bal15se_1' ") & (" %3.2f `bal16se_1' ") & & (" %3.2f `bal15se_2' ") & (" %3.2f `bal16se_2' ") & & (" %3.2f `bal15se_3' ") & (" %3.2f `bal16se_3' ") \\"
	noisily dis " & \emph{N="%4.0f `n80_1' "} & \emph{N=" %4.0f `n81_1' "} & & \emph{N="%4.0f `n80_2' "} & \emph{N="%4.0f `n81_2' "} & & \emph{N="%4.0f `n80_3' "} & \emph{N="%4.0f `n81_3' "} \\"

	noisily dis "\bottomrule"
	noisily dis "\multicolumn{9}{p{0.8\textwidth}}{\footnotesize Robust standard errors in parentheses.  $ V_{i,t}$ and $ Y_{i,t+1}$ measured in percentage points. }"
	noisily dis "\end{tabular}"
	noisily dis "\end{table}"

	log close
}
saveold statewide_analysis_Rep, replace


**** descriptive analysis with money data

use state_cand_totals, clear

drop contributorname amount indiv

rename amount0 amount_group
rename amount1 amount_indiv

collapse (sum) amount*, by(state year office dem)

reshape wide amount*, i(state year office) j(dem)

replace amount_group0 = 0 if amount_group0 == .
replace amount_group1 = 0 if amount_group1 == .
replace amount_indiv0 = 0 if amount_indiv0 == .
replace amount_indiv1 = 0 if amount_indiv1 == .

gen race_total = amount_group0 + amount_indiv0 + amount_group1 + amount_indiv1

gen dem_money_share = (amount_group1 + amount_indiv1)/race_total

gen dem_total = log(amount_group1 + amount_indiv1)

sort state office year
by state office: gen dv_money = dem_money_share[_n+1]
by state office: gen lag_money_share2 = dem_money_share[_n-1]
rename dem_money_share lag_money_share

keep state office year dv* lag_money* amount_group1 amount_indiv1 dem_total

keep if dv_money != .

sort state office year

save state_money_merge, replace

use tmp_senate_1980_2012, clear

collapse (sum) totrec, by(state partycd year)
keep if partycd != 3


gen dem_money = totrec if partycd == 1
egen tot_money = sum(totrec), by(state year)
gen dem_money_share = dem_money / tot_money

collapse (max) dem_money_share, by(state year)
replace dem_money_share = 0 if dem_money_share == .
sort state year
by state: gen dv_money = dem_money_share[_n+1]
by state: gen lag_money_share2 = dem_money_share[_n-1]
rename dem_money_share lag_money_share
keep state year dv_money lag_money*

gen office = "S"
sort state office year

save senate_money_merge, replace

use statewide_analysis, clear
sort state office year

merge 1:1 state office year using state_money_merge
drop if _merge == 2
drop _merge

sort state office year
merge 1:1 state office year using senate_money_merge, update

drop if _merge == 2
drop _merge

drop dv
rename dv_money dv

replace dv = 100*dv

keep if dv != .
keep if rv > 0 & rv <= 15
keep rv dv office dem_total

binscatter dem_total rv, savedata("money_for_r") replace

*** scare-off analysis

use statewide_analysis, clear

gen qual_diff = next_qual_D - next_qual_R

saveold for_scareoff_estimates, replace

preserve
keep if rv > 0 & rv <= 15
binscatter qual_diff rv, savedata("qual_for_r") replace
restore

local controlset1 = "lag lag2 lag_norm_vote lag_norm_vote2 midterm"
local controlset = "`controlset1'"
local controlset2 = "lag lag2 midterm lag_norm_vote"
local controlset3 = "lag lag_norm_vote"
local controlset0 = ""


**** CIA TESTS WITH CAND QUAL

drop dv
rename qual_diff dv

replace dv = 100*dv

reg dv treat `controlset3' if rv > -15 & rv < 15, r
reg dv treat rv rv_treat if abs(rv) < 5, r

forvalues j=1/3 {

	reg dv rv `controlset`j'' if treat == 0 & rv > -5, r
	local bal1_`j' = _b[rv]
	local bal1se_`j' = _se[rv]
	local n10_`j' = e(N)
	
	reg dv rv `controlset`j'' if treat == 1 & rv < 5, r
	local bal2_`j' = _b[rv]
	local bal2se_`j' = _se[rv]
	local n11_`j' = e(N)
	
	
	reg dv rv `controlset`j'' if treat == 0 & rv > -10, r
	local bal3_`j' = _b[rv]
	local bal3se_`j' = _se[rv]
	local n20_`j' = e(N)
	
	
	reg dv rv `controlset`j'' if treat == 1 & rv < 10, r
	local bal4_`j' = _b[rv]
	local bal4se_`j' = _se[rv]
	local n21_`j' = e(N)
	
	reg dv rv `controlset`j'' if treat == 0 & rv > -15, r
	local bal5_`j' = _b[rv]
	local bal5se_`j' = _se[rv]
	local n30_`j' = e(N)
	
	
	reg dv rv `controlset`j'' if treat == 1 & rv < 15, r
	local bal6_`j' = _b[rv]
	local bal6se_`j' = _se[rv]
	local n31_`j' = e(N)
	
	
	reg dv rv `controlset`j'' if treat == 0 & rv > -20, r
	local bal7_`j' = _b[rv]
	local bal7se_`j' = _se[rv]
	local n40_`j' = e(N)
	
	
	reg dv rv `controlset`j'' if treat == 1 & rv < 20, r
	local bal8_`j' = _b[rv]
	local bal8se_`j' = _se[rv]
	local n41_`j' = e(N)
	
	reg dv rv `controlset`j'' if treat == 0 & rv > -25, r
	local bal9_`j' = _b[rv]
	local bal9se_`j' = _se[rv]
	local n50_`j' = e(N)
	
	
	reg dv rv `controlset`j'' if treat == 1 & rv < 25, r
	local bal10_`j' = _b[rv]
	local bal10se_`j' = _se[rv]
	local n51_`j' = e(N)
	
	reg dv rv `controlset`j'' if treat == 0 & rv > -30, r
	local bal11_`j' = _b[rv]
	local bal11se_`j' = _se[rv]
	local n60_`j' = e(N)
	
	
	reg dv rv `controlset`j'' if treat == 1 & rv < 30, r
	local bal12_`j' = _b[rv]
	local bal12se_`j' = _se[rv]
	local n61_`j' = e(N)

	reg dv rv `controlset`j'' if treat == 0 & rv > -35, r
	local bal13_`j' = _b[rv]
	local bal13se_`j' = _se[rv]
	local n70_`j' = e(N)
	
	
	reg dv rv `controlset`j'' if treat == 1 & rv < 35, r
	local bal14_`j' = _b[rv]
	local bal14se_`j' = _se[rv]
	local n71_`j' = e(N)
	
	reg dv rv `controlset`j'' if treat == 0 & rv > -40, r
	local bal15_`j' = _b[rv]
	local bal15se_`j' = _se[rv]
	local n80_`j' = e(N)
	
	
	reg dv rv `controlset`j'' if treat == 1 & rv < 40, r
	local bal16_`j' = _b[rv]
	local bal16se_`j' = _se[rv]
	local n81_`j' = e(N)
}



quietly {
	cap log close
	set linesize 255
	log using "balance_qual.tex", replace text
	noisily dis "\begin{table}[h!]"
	noisily dis "\centering"
	noisily dis "\caption{{\bf Conditional Independence Tests When Outcome Variable is Net Candidate Quality Differential. \label{tab:cia_qual}}  Presents CIA tests from equation \ref{eq:test} to the left of the discontinuity (D=0) and to the right (D=1).}"
	noisily dis "\begin{tabular}{ccccccccc}"
	noisily dis "\toprule \toprule"
	noisily dis "& \multicolumn{2}{c}{\bf Control Set 1:} & & \multicolumn{2}{c}{\bf Control Set 2:} & & \multicolumn{2}{c}{\bf Control Set 3:} \\"
	noisily dis "& \multicolumn{2}{c}{$\mathit{Dem \ Share}_{t-1}$} & & \multicolumn{2}{c}{$\mathit{Dem \ Share}_{t-1}$} & & \multicolumn{2}{c}{$\mathit{Dem \ Share}_{t-1}$} \\"
	noisily dis "& \multicolumn{2}{c}{$\mathit{Dem \ Share}_{t-2}$} & & \multicolumn{2}{c}{$\mathit{Dem \ Share}_{t-2}$} & & \multicolumn{2}{c}{$\mathit{Normal \ Vote}_{t-1}$} \\"
	noisily dis "& \multicolumn{2}{c}{$\mathit{Normal \ Vote}_{t-1}$} & & \multicolumn{2}{c}{$\mathit{Normal \ Vote}_{t-1}$} & &  & \\"
	noisily dis "& \multicolumn{2}{c}{$\mathit{Normal \ Vote}_{t-2}$} & & \multicolumn{2}{c}{$\mathit{Midterm \ Slump}_{t}$} & &  & \\"
	noisily dis "& \multicolumn{2}{c}{$\mathit{Midterm \ Slump}_t$} & & & & &  & \\[2mm]"
	noisily dis "Window  & D=0 & D=1 & & D=0 & D=1 & & D=0 & D=1 \\"
	noisily dis "\midrule "
	noisily dis "\bf 5 & " %5.2f `bal1_1' " & " %5.2f `bal2_1' "& & " %5.2f `bal1_2' " & " %5.2f `bal2_2' " & & " %5.2f `bal1_3' " & " %5.2f `bal2_3' " \\ "
	noisily dis " & (" %3.2f `bal1se_1' ") & (" %3.2f `bal2se_1' ") & & (" %3.2f `bal1se_2' ") & (" %3.2f `bal2se_2' ") & & (" %3.2f `bal1se_3' ") & (" %3.2f `bal2se_3' ") \\"
	noisily dis " & \emph{N="%3.0f `n10_1' "} & \emph{N="%3.0f `n11_1' "} & & \emph{N="%3.0f `n10_2' "}  & \emph{N="%3.0f `n11_2' "} & & \emph{N="%3.0f `n10_3' "} & \emph{N="%3.0f `n11_3' "} \\[2mm]"
	noisily dis "\bf 10 & " %5.2f `bal3_1' " & " %5.2f `bal4_1' "& & " %5.2f `bal3_2' " & " %5.2f `bal4_2' "& & " %5.2f `bal3_3' " & " %5.2f `bal4_3' " \\ "
	noisily dis " & (" %3.2f `bal3se_1' ") & (" %3.2f `bal4se_1' ") & & (" %3.2f `bal3se_2' ") & (" %3.2f `bal4se_2' ") & & (" %3.2f `bal3se_3' ") & (" %3.2f `bal4se_3' ") \\"
	noisily dis " & \emph{N="%3.0f `n20_1' "} & \emph{N=" %3.0f `n21_1' "} & & \emph{N="%3.0f `n20_2' "} & \emph{N="%3.0f `n21_2' "} & & \emph{N="%3.0f `n20_3' "} & \emph{N="%3.0f `n21_3' "} \\[2mm]"
	noisily dis "\midrule\\"
	noisily dis "\bf 15 & " %5.2f `bal5_1' " & " %5.2f `bal6_1' "& & " %5.2f `bal5_2' " & " %5.2f `bal6_2' "& & " %5.2f `bal5_3' " & " %5.2f `bal6_3' " \\ "
	noisily dis " & (" %3.2f `bal5se_1' ") & (" %3.2f `bal6se_1' ") & & (" %3.2f `bal5se_2' ") & (" %3.2f `bal6se_2' ") & & (" %3.2f `bal5se_3' ") & (" %3.2f `bal6se_3' ") \\"
	noisily dis " & \emph{N="%4.0f `n30_1' "} & \emph{N=" %4.0f `n31_1' "} & & \emph{N="%4.0f `n30_2' "} & \emph{N="%4.0f `n31_2' "} & & \emph{N="%4.0f `n30_3' "} & \emph{N="%4.0f `n31_3' "} \\[4mm]"
	noisily dis "\midrule\\"
	noisily dis "20 & " %5.2f `bal7_1' " & " %5.2f `bal8_1' "& & " %5.2f `bal7_2' " & " %5.2f `bal8_2' "& & " %5.2f `bal7_3' " & " %5.2f `bal8_3' " \\ "
	noisily dis " & (" %3.2f `bal7se_1' ") & (" %3.2f `bal8se_1' ") & & (" %3.2f `bal7se_2' ") & (" %3.2f `bal8se_2' ") & & (" %3.2f `bal7se_3' ") & (" %3.2f `bal8se_3' ") \\"
	noisily dis " & \emph{N="%4.0f `n40_1' "} & \emph{N=" %4.0f `n41_1' "} & & \emph{N="%4.0f `n40_2' "} & \emph{N="%4.0f `n41_2' "} & & \emph{N="%4.0f `n40_3' "} & \emph{N="%4.0f `n41_3' "} \\[2mm]"

	noisily dis "25 & " %5.2f `bal9_1' " & " %5.2f `bal10_1' "& & " %5.2f `bal9_2' " & " %5.2f `bal10_2' "& & " %5.2f `bal9_3' " & " %5.2f `bal10_3' " \\ "
	noisily dis " & (" %3.2f `bal9se_1' ") & (" %3.2f `bal10se_1' ") & & (" %3.2f `bal9se_2' ") & (" %3.2f `bal10se_2' ") & & (" %3.2f `bal9se_3' ") & (" %3.2f `bal10se_3' ") \\"
	noisily dis " & \emph{N="%4.0f `n50_1' "} & \emph{N=" %4.0f `n51_1' "} & & \emph{N="%4.0f `n50_2' "} & \emph{N="%4.0f `n51_2' "} & & \emph{N="%4.0f `n50_3' "} & \emph{N="%4.0f `n51_3' "} \\[2mm]"

	noisily dis "30 & " %5.2f `bal11_1' " & " %5.2f `bal12_1' "& & " %5.2f `bal11_2' " & " %5.2f `bal12_2' "& & " %5.2f `bal11_3' " & " %5.2f `bal12_3' " \\ "
	noisily dis " & (" %3.2f `bal11se_1' ") & (" %3.2f `bal12se_1' ") & & (" %3.2f `bal11se_2' ") & (" %3.2f `bal12se_2' ") & & (" %3.2f `bal11se_3' ") & (" %3.2f `bal12se_3' ") \\"
	noisily dis " & \emph{N="%4.0f `n60_1' "} & \emph{N=" %4.0f `n61_1' "} & & \emph{N="%4.0f `n60_2' "} & \emph{N="%4.0f `n61_2' "} & & \emph{N="%4.0f `n60_3' "} & \emph{N="%4.0f `n61_3' "} \\[2mm]"

	noisily dis "35 & " %5.2f `bal13_1' " & " %5.2f `bal14_1' "& & " %5.2f `bal13_2' " & " %5.2f `bal14_2' "& & " %5.2f `bal13_3' " & " %5.2f `bal14_3' " \\ "
	noisily dis " & (" %3.2f `bal13se_1' ") & (" %3.2f `bal14se_1' ") & & (" %3.2f `bal13se_2' ") & (" %3.2f `bal14se_2' ") & & (" %3.2f `bal13se_3' ") & (" %3.2f `bal14se_3' ") \\"
	noisily dis " & \emph{N="%4.0f `n70_1' "} & \emph{N=" %4.0f `n71_1' "} & & \emph{N="%4.0f `n70_2' "} & \emph{N="%4.0f `n71_2' "} & & \emph{N="%4.0f `n70_3' "} & \emph{N="%4.0f `n71_3' "} \\[2mm]"

	noisily dis "40 & " %5.2f `bal15_1' " & " %5.2f `bal16_1' "& & " %5.2f `bal15_2' " & " %5.2f `bal16_2' "& & " %5.2f `bal15_3' " & " %5.2f `bal16_3' " \\ "
	noisily dis " & (" %3.2f `bal15se_1' ") & (" %3.2f `bal16se_1' ") & & (" %3.2f `bal15se_2' ") & (" %3.2f `bal16se_2' ") & & (" %3.2f `bal15se_3' ") & (" %3.2f `bal16se_3' ") \\"
	noisily dis " & \emph{N="%4.0f `n80_1' "} & \emph{N=" %4.0f `n81_1' "} & & \emph{N="%4.0f `n80_2' "} & \emph{N="%4.0f `n81_2' "} & & \emph{N="%4.0f `n80_3' "} & \emph{N="%4.0f `n81_3' "} \\"

	noisily dis "\bottomrule"
	noisily dis "\multicolumn{9}{p{0.75\textwidth}}{\footnotesize Robust standard errors in parentheses.  $ V_{i,t}$ and $ Y_{i,t+1}$ measured in percentage points. }"
	noisily dis "\end{tabular}"
	noisily dis "\end{table}"

	log close
}



*** US HOUSE ANALYSIS FOR APPENDIX

cd "~/Dropbox/RDD_Extrapolate"

use tmp_rdd_us_house_postwar, clear

gen south = state=="AL"|state=="AR"|state=="FL"|state=="GA"|state=="LA"|state=="MS"|state=="NC"|state=="SC"|state=="TN"|state=="TX"|state=="VA"

drop if mod(year,2) == 1

gen     midterm =  0 if mod(year,4) == 0
replace midterm =  1 if year == 1946 | year == 1950 | year == 1962 | year == 1966 | year == 1978 | year == 1994 | year == 1998 | year == 2010 
replace midterm = -1 if year == 1954 | year == 1958 | year == 1970 | year == 1974 | year == 1982 | year == 1986 | year == 1990 | year == 2002 | year == 2006

gen     coattail =  0 if mod(year,4) == 2
replace coattail = -1 if year == 1952 | year == 1956 | year == 1968 | year == 1972 | year == 1980 | year == 1984 | year == 1988 | year == 2000 | year == 2004
replace coattail =  1 if year == 1948 | year == 1960 | year == 1964 | year == 1976 | year == 1992 | year == 1996 | year == 2008 | year == 2012

gen dist_id = state + " " + string(dist) + " " + string(redist1) + " " + string(redist2)

sort dist_id year
by dist_id: gen lag2_rv = rv[_n-2]
by dist_id: gen midterm_next  = midterm[_n+1]
by dist_id: gen coattail_next = coattail[_n+1]

gen treat = rv > 0 if rv != .
gen dv   = 100 * next_pct_D/(next_pct_D + next_pct_R) - 50
gen dv_w = next_w_D - next_w_R

gen year_south = year * south

replace inc_D = 1 if inc_D == 2
replace inc_R = 1 if inc_R == 2
gen inc = inc_D - inc_R

local controlset1 = "lag_rv lag2_rv midterm_next coattail_next"
local controlset2 = "lag_rv lag2_rv midterm_next"
local controlset3 = "lag_rv lag2_rv"

*** CIA tests


forvalues j=1/3 {

	reg dv rv `controlset`j'' if treat == 0 & rv > -5, r
	local bal1_`j' = _b[rv]
	local bal1se_`j' = _se[rv]
	local n10_`j' = e(N)
	
	reg dv rv `controlset`j'' if treat == 1 & rv < 5, r
	local bal2_`j' = _b[rv]
	local bal2se_`j' = _se[rv]
	local n11_`j' = e(N)
	
	
	reg dv rv `controlset`j'' if treat == 0 & rv > -10, r
	local bal3_`j' = _b[rv]
	local bal3se_`j' = _se[rv]
	local n20_`j' = e(N)
	
	
	reg dv rv `controlset`j'' if treat == 1 & rv < 10, r
	local bal4_`j' = _b[rv]
	local bal4se_`j' = _se[rv]
	local n21_`j' = e(N)
	
	reg dv rv `controlset`j'' if treat == 0 & rv > -15, r
	local bal5_`j' = _b[rv]
	local bal5se_`j' = _se[rv]
	local n30_`j' = e(N)
	
	
	reg dv rv `controlset`j'' if treat == 1 & rv < 15, r
	local bal6_`j' = _b[rv]
	local bal6se_`j' = _se[rv]
	local n31_`j' = e(N)
	
	
	reg dv rv `controlset`j'' if treat == 0 & rv > -20, r
	local bal7_`j' = _b[rv]
	local bal7se_`j' = _se[rv]
	local n40_`j' = e(N)
	
	
	reg dv rv `controlset`j'' if treat == 1 & rv < 20, r
	local bal8_`j' = _b[rv]
	local bal8se_`j' = _se[rv]
	local n41_`j' = e(N)
	
	reg dv rv `controlset`j'' if treat == 0 & rv > -25, r
	local bal9_`j' = _b[rv]
	local bal9se_`j' = _se[rv]
	local n50_`j' = e(N)
	
	
	reg dv rv `controlset`j'' if treat == 1 & rv < 25, r
	local bal10_`j' = _b[rv]
	local bal10se_`j' = _se[rv]
	local n51_`j' = e(N)
	
	reg dv rv `controlset`j'' if treat == 0 & rv > -30, r
	local bal11_`j' = _b[rv]
	local bal11se_`j' = _se[rv]
	local n60_`j' = e(N)
	
	
	reg dv rv `controlset`j'' if treat == 1 & rv < 30, r
	local bal12_`j' = _b[rv]
	local bal12se_`j' = _se[rv]
	local n61_`j' = e(N)

	reg dv rv `controlset`j'' if treat == 0 & rv > -35, r
	local bal13_`j' = _b[rv]
	local bal13se_`j' = _se[rv]
	local n70_`j' = e(N)
	
	
	reg dv rv `controlset`j'' if treat == 1 & rv < 35, r
	local bal14_`j' = _b[rv]
	local bal14se_`j' = _se[rv]
	local n71_`j' = e(N)
	
	reg dv rv `controlset`j'' if treat == 0 & rv > -40, r
	local bal15_`j' = _b[rv]
	local bal15se_`j' = _se[rv]
	local n80_`j' = e(N)
	
	
	reg dv rv `controlset`j'' if treat == 1 & rv < 40, r
	local bal16_`j' = _b[rv]
	local bal16se_`j' = _se[rv]
	local n81_`j' = e(N)
}



quietly {
	cap log close
	set linesize 255
	log using "balance_house.tex", replace text
	noisily dis "\begin{table}[h!]"
	noisily dis "\centering"
	noisily dis "\caption{{\bf Conditional Independence Tests, U.S. House 1948--2012. \label{tab:cia_house}}  Presents CIA tests from equation \ref{eq:test} to the left of the discontinuity (D=0) and to the right (D=1)."  "
	noisily dis "The CIA appears to fail in the U.S. House.}"
	noisily dis "\begin{tabular}{ccccccccc}"
	noisily dis "\toprule \toprule"
	
	noisily dis "& \multicolumn{2}{c}{\bf Control Set 1:} & & \multicolumn{2}{c}{\bf Control Set 2:} & & \multicolumn{2}{c}{\bf Control Set 3:} \\"
	
	noisily dis "& \multicolumn{2}{c}{$\mathit{Dem \ Share}_{t-1}$} & & \multicolumn{2}{c}{$\mathit{Dem \ Share}_{t-1}$} & & \multicolumn{2}{c}{$\mathit{Dem \ Share}_{t-1}$} \\"
	
	noisily dis "& \multicolumn{2}{c}{$\mathit{Dem \ Share}_{t-2}$} & & \multicolumn{2}{c}{$\mathit{Dem \ Share}_{t-2}$} & & \multicolumn{2}{c}{$\mathit{Dem \ Share}_{t-2}$} \\"
	
	noisily dis "& \multicolumn{2}{c}{$\mathit{Midterm \, Slump}_{t}$} & & \multicolumn{2}{c}{$\mathit{Midterm \, Slump}_{t}$} & &  & \\"
	
	noisily dis "& \multicolumn{2}{c}{$\mathit{Coattail}_{t}$} & & & &  & \\[2mm]"
		
	noisily dis "Window  & D=0 & D=1 & & D=0 & D=1 & & D=0 & D=1 \\"
	noisily dis "\midrule "
	noisily dis "\bf 5 & " %5.2f `bal1_1' " & " %5.2f `bal2_1' "& & " %5.2f `bal1_2' " & " %5.2f `bal2_2' " & & " %5.2f `bal1_3' " & " %5.2f `bal2_3' " \\ "
	noisily dis " & (" %3.2f `bal1se_1' ") & (" %3.2f `bal2se_1' ") & & (" %3.2f `bal1se_2' ") & (" %3.2f `bal2se_2' ") & & (" %3.2f `bal1se_3' ") & (" %3.2f `bal2se_3' ") \\"
	noisily dis " & \emph{N="%3.0f `n10_1' "} & \emph{N="%3.0f `n11_1' "} & & \emph{N="%3.0f `n10_2' "}  & \emph{N="%3.0f `n11_2' "} & & \emph{N="%3.0f `n10_3' "} & \emph{N="%3.0f `n11_3' "} \\[2mm]"
	noisily dis "\bf 10 & " %5.2f `bal3_1' " & " %5.2f `bal4_1' "& & " %5.2f `bal3_2' " & " %5.2f `bal4_2' "& & " %5.2f `bal3_3' " & " %5.2f `bal4_3' " \\ "
	noisily dis " & (" %3.2f `bal3se_1' ") & (" %3.2f `bal4se_1' ") & & (" %3.2f `bal3se_2' ") & (" %3.2f `bal4se_2' ") & & (" %3.2f `bal3se_3' ") & (" %3.2f `bal4se_3' ") \\"
	noisily dis " & \emph{N="%3.0f `n20_1' "} & \emph{N=" %3.0f `n21_1' "} & & \emph{N="%3.0f `n20_2' "} & \emph{N="%3.0f `n21_2' "} & & \emph{N="%3.0f `n20_3' "} & \emph{N="%3.0f `n21_3' "} \\[2mm]"
	noisily dis "\midrule\\"
	noisily dis "\bf 15 & " %5.2f `bal5_1' " & " %5.2f `bal6_1' "& & " %5.2f `bal5_2' " & " %5.2f `bal6_2' "& & " %5.2f `bal5_3' " & " %5.2f `bal6_3' " \\ "
	noisily dis " & (" %3.2f `bal5se_1' ") & (" %3.2f `bal6se_1' ") & & (" %3.2f `bal5se_2' ") & (" %3.2f `bal6se_2' ") & & (" %3.2f `bal5se_3' ") & (" %3.2f `bal6se_3' ") \\"
	noisily dis " & \emph{N="%4.0f `n30_1' "} & \emph{N=" %4.0f `n31_1' "} & & \emph{N="%4.0f `n30_2' "} & \emph{N="%4.0f `n31_2' "} & & \emph{N="%4.0f `n30_3' "} & \emph{N="%4.0f `n31_3' "} \\[4mm]"
	noisily dis "\midrule\\"
	noisily dis "20 & " %5.2f `bal7_1' " & " %5.2f `bal8_1' "& & " %5.2f `bal7_2' " & " %5.2f `bal8_2' "& & " %5.2f `bal7_3' " & " %5.2f `bal8_3' " \\ "
	noisily dis " & (" %3.2f `bal7se_1' ") & (" %3.2f `bal8se_1' ") & & (" %3.2f `bal7se_2' ") & (" %3.2f `bal8se_2' ") & & (" %3.2f `bal7se_3' ") & (" %3.2f `bal8se_3' ") \\"
	noisily dis " & \emph{N="%4.0f `n40_1' "} & \emph{N=" %4.0f `n41_1' "} & & \emph{N="%4.0f `n40_2' "} & \emph{N="%4.0f `n41_2' "} & & \emph{N="%4.0f `n40_3' "} & \emph{N="%4.0f `n41_3' "} \\[2mm]"

	noisily dis "25 & " %5.2f `bal9_1' " & " %5.2f `bal10_1' "& & " %5.2f `bal9_2' " & " %5.2f `bal10_2' "& & " %5.2f `bal9_3' " & " %5.2f `bal10_3' " \\ "
	noisily dis " & (" %3.2f `bal9se_1' ") & (" %3.2f `bal10se_1' ") & & (" %3.2f `bal9se_2' ") & (" %3.2f `bal10se_2' ") & & (" %3.2f `bal9se_3' ") & (" %3.2f `bal10se_3' ") \\"
	noisily dis " & \emph{N="%4.0f `n50_1' "} & \emph{N=" %4.0f `n51_1' "} & & \emph{N="%4.0f `n50_2' "} & \emph{N="%4.0f `n51_2' "} & & \emph{N="%4.0f `n50_3' "} & \emph{N="%4.0f `n51_3' "} \\[2mm]"

	noisily dis "30 & " %5.2f `bal11_1' " & " %5.2f `bal12_1' "& & " %5.2f `bal11_2' " & " %5.2f `bal12_2' "& & " %5.2f `bal11_3' " & " %5.2f `bal12_3' " \\ "
	noisily dis " & (" %3.2f `bal11se_1' ") & (" %3.2f `bal12se_1' ") & & (" %3.2f `bal11se_2' ") & (" %3.2f `bal12se_2' ") & & (" %3.2f `bal11se_3' ") & (" %3.2f `bal12se_3' ") \\"
	noisily dis " & \emph{N="%4.0f `n60_1' "} & \emph{N=" %4.0f `n61_1' "} & & \emph{N="%4.0f `n60_2' "} & \emph{N="%4.0f `n61_2' "} & & \emph{N="%4.0f `n60_3' "} & \emph{N="%4.0f `n61_3' "} \\[2mm]"

	noisily dis "35 & " %5.2f `bal13_1' " & " %5.2f `bal14_1' "& & " %5.2f `bal13_2' " & " %5.2f `bal14_2' "& & " %5.2f `bal13_3' " & " %5.2f `bal14_3' " \\ "
	noisily dis " & (" %3.2f `bal13se_1' ") & (" %3.2f `bal14se_1' ") & & (" %3.2f `bal13se_2' ") & (" %3.2f `bal14se_2' ") & & (" %3.2f `bal13se_3' ") & (" %3.2f `bal14se_3' ") \\"
	noisily dis " & \emph{N="%4.0f `n70_1' "} & \emph{N=" %4.0f `n71_1' "} & & \emph{N="%4.0f `n70_2' "} & \emph{N="%4.0f `n71_2' "} & & \emph{N="%4.0f `n70_3' "} & \emph{N="%4.0f `n71_3' "} \\[2mm]"

	noisily dis "40 & " %5.2f `bal15_1' " & " %5.2f `bal16_1' "& & " %5.2f `bal15_2' " & " %5.2f `bal16_2' "& & " %5.2f `bal15_3' " & " %5.2f `bal16_3' " \\ "
	noisily dis " & (" %3.2f `bal15se_1' ") & (" %3.2f `bal16se_1' ") & & (" %3.2f `bal15se_2' ") & (" %3.2f `bal16se_2' ") & & (" %3.2f `bal15se_3' ") & (" %3.2f `bal16se_3' ") \\"
	noisily dis " & \emph{N="%4.0f `n80_1' "} & \emph{N=" %4.0f `n81_1' "} & & \emph{N="%4.0f `n80_2' "} & \emph{N="%4.0f `n81_2' "} & & \emph{N="%4.0f `n80_3' "} & \emph{N="%4.0f `n81_3' "} \\"

	noisily dis "\bottomrule"
	noisily dis "\multicolumn{9}{p{0.8\textwidth}}{\footnotesize Robust standard errors in parentheses.  $ V_{i,t}$ and $ Y_{i,t+1}$ measured in percentage points. }"
	noisily dis "\end{tabular}"
	noisily dis "\end{table}"

	log close
}

