gen unmatched=.
replace unmatched=1 if merge2015==1
replace unmatched=0 if merge2015==3
tab unmatched

tab unmatched dosage if (condition=="" | condition=="control") & survey_sample==0, column

ttest dosage, by(unmatched) unequal
ttest survey_sample, by(unmatched) unequal

ttest inscrits, by(unmatched) unequal
ttest votants, by(unmatched) unequal
ttest voteshare_fcbe, by(unmatched) unequal
ttest area, by(unmatched) unequal
ttest participation, by(unmatched)
ttest margin, by(unmatched) unequal
ttest competitive_margin, by(unmatched) unequal
ttest north_south, by(unmatched) unequal
ttest main_index, by(unmatched) unequal


gen lg_inscrits = log(inscrits)

logit unmatched lg_inscrits voteshare_fcbe area participation competitive_margin main_index north_south
estimates store unconstrained
logit unmatched if lg_inscrits!=. & voteshare_fcbe!=. & area!=. & participation!=. & competitive_margin!=. & main_index!=. & north_south!=.
lrtest unconstrained

matrix define hist=J(6, 5, .)
matrix colnames hist = "Mean Unmatched" "Mean Matched" "Difference" "P-Value"    
matrix rownames hist = "Registered Voters (log)" "Urban" "Turnout" "Competitive (dichotomous)" "Incumbent Performance" "North" 

local i = 0			   
foreach var in lg_inscrits area participation competitive_margin main_index north_south {
	local i = `i' + 1
	qui regress `var' unmatched, cluster(commune)
	local a = _b[_cons] + _b[unmatched]
	display `a'
	matrix hist[`i', 1] = round(`a', .01)
	matrix hist[`i', 2] = round(_b[_cons], .01)
	matrix hist[`i', 3] = round(abs(_b[unmatched]), .01)
	matrix temp = r(table)
	local p = temp[4, 1]
	display `p'
	matrix hist[`i', 4] = round(`p', .01)

}			   

			   
matrix list hist

cap esttab m(hist) using Drafts/Tables/unmatched_balance_admin.tex, replace nomtitle ///
	addnote("P-values generated from tests in which we cluster on commune.")
