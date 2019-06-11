// Sponsor bias data analysis
// last revision: 4 July 2019 by Emily
// requires _sutex_ and _estout_ from ssc

// load data
	clear
	use sponsordata2.dta
	
// cleanup duplicate responses
	duplicates tag newid, gen(DUPLICATE)
	sort DUPLICATE newid startdate
	tab DUPLICATE finished
//           |       Finished
// DUPLICATE |         0          1 |     Total
//-----------+----------------------+----------
//         0 |        14        828 |       842 
//         1 |        29         25 |        54 
//         2 |         9          3 |        12 
//-----------+----------------------+----------
//     Total |        52        856 |       908

	drop if DUPLICATE != 0
	drop DUPLICATE
	

// do recoding
	do analysis_coding.do
	
// Main Results (Table 1)

// Command to write results to disk
capture program drop doftest
program define doftest
	quietly reg `1' i.condition1 i.stratum1
	local local_dvlab : variable label `e(depvar)'
	quietly test 2.condition1 3.condition1 4.condition1 5.condition1
	file write ftests "`local_dvlab'" " & $ F(" %1.0f (`r(df)') "," %1.0f (`r(df_r)') ")=" %5.2f (`r(F)') ", p\leq" %4.2f (`r(p)') " $\\"
	file write ftests _n(1)
end

// open ftest results
file open ftests using "tables/ftests.tex", write text replace
file write ftests "\begin{table}[ht]" _n(1) "\begin{center}" _n(1) "\caption{Summary of Effects}" _n(1) "\begin{tabular}{@{}ll@{}}\hline" _n(1)
file write ftests "\textbf{Measure} & \textbf{Test for Group Differences} \\ \hline" _n(1)

// F-tests
doftest votedsum
doftest sdsum
doftest polinterest
doftest onleft_sum
doftest appelcount
doftest appelwrong
doftest timing_appel
doftest check5_5
doftest know_pol
doftest know_pol_dk
doftest know_gen
doftest know_gen_dk
doftest cheat_pol
doftest cheat_gen
doftest email
doftest survey
doftest pay2
doftest eval_univ
doftest eval_market

// close ftest results
file write ftests "\hline" _n(1) "\end{tabular}" _n(1) "\label{tabsum}" _n(1) "\end{center}" _n(1) "{\footnotesize Cell entries are F-tests for joint hypothesis of differences across experimental conditions from an OLS regression controlling for respondent experience on MTurk. Full results are included in Appendix \ref{app:results}.}" _n(1) "\end{table}" _n(1)
file close ftests


// Descriptives for Appendix

	* demographic measures
	sutex age2 sex race education2 partyid2 ideology ///
		, labels minmax digits(1) title(Summary Statistics: Demographics) ///
		file(tables/descstats.tex) replace
		
	* outcome measures
	sutex votedsum sdsum polinterest list1 list2 listAB ///
		onleft_sum appelcount appelwrong timing_appel ///
		know_pol know_pol_dk know_gen know_gen_dk ///
		cheat_pol cheat_gen email survey pay2 eval_univ eval_market ///
		, labels minmax digits(1) title(Summary Statistics: Outcome Measures) ///
		file(tables/summarystats.tex) replace


// FULL RESULTS

// Social Desirability: past voting
	*tab condition1, summarize(votedsum)
	*anova votedsum condition1
	*graph dot (mean) votedsum, over(condition1)
	
	*reg votedsum i.condition1
	quietly reg votedsum i.condition1 i.stratum1
	eststo voted
	
// Social Desirability: Good behaviors

	*reg sdsum i.condition1
	quietly reg sdsum i.condition1 i.stratum1
	eststo behaviors
	
// political interest

	*tab condition1, summarize(polinterest)
	*reg polinterest i.condition1
	quietly reg polinterest i.condition1 i.stratum1
	eststo interest

// Output for "Socially Desirable Responding" measures

	esttab using "tables/tabsdr.tex", replace ///
		nobaselevels label ///
		b(%9.2f) se(%9.2f) stats (N rmse) ///
		title (Socially Desirable Responding) ///
		mtitles ("Past Voting" "Good Behavior" "Political Interest")
	
	eststo clear

// List experiment
	
	reg list1 temp##i.condition1 i.stratum1
	eststo listexp1
	
	drop temp
	gen temp = listcondition2
	label values temp listtemplabel
	
	reg list2 temp##i.condition1 i.stratum1
	eststo listexp2
	
	reg listAB i.condition1 i.stratum1
	eststo listexp3
	
	esttab using "tables/tablist.tex", replace ///
		nobaselevels label ///
		b(%9.2f) se(%9.2f) stats (N rmse) ///
		title (List Experiment) ///
		mtitles ("List Experiment 1" "List Experiment 2" "Within-Subjects")
	
	drop temp
	label drop listtemplabel
	eststo clear
	
	

// Good subjects

	/*for this use the onleft variables--the sum of those will be the number of
	times that they chose they leftmost option*/

	*reg onleft_sum i.gstreatment##i.condition1
	reg onleft_sum i.gstreatment##i.condition1 i.stratum1
	eststo gs
	
	esttab using "tables/tabgs.tex", replace ///
		nobaselevels label ///
		b(%9.2f) se(%9.2f) stats (N rmse) ///
		title (Good Subjects Behavior) ///
		mtitles ("Good Subjects")
	
	eststo clear
	
	
// Information recall from vignette

	*reg appelcount i.condition1
	reg appelcount i.condition1 i.stratum1
	eststo recall1
	
	//without some very high outliers
	*reg appelcount i.condition1 if appelcount<1000
	reg appelcount i.condition1 i.stratum1 if appelcount<1000
	eststo recall2
	
	// incorrect answers
	*reg appelwrong i.condition1
	reg appelwrong i.condition1 i.stratum1
	eststo recallwrong
	
	// Timing
	*reg timing_appel i.condition1 i.stratum1 if timing_appel<500
	reg timing_appel i.condition1 i.stratum1
	eststo reading

	esttab using "tables/tabrecall.tex", replace ///
		nobaselevels label ///
		b(%9.2f) se(%9.2f) stats (N rmse) ///
		title (Attention Measures) ///
		mtitles ("Recall (characters)" "Recall (characters)" "Incorrect Responses" "Reading Time") ///
		addnotes("Column 2 excludes extreme outliers ($>$1000) characters")
	
	eststo clear
	
// attention check item (variable is `check5_5'; correct answer "None of the above")
	
	// basically everyone passed, so not interesting to analyze
	*tab check5_5
	*logit check5_5 i.condition1
	*logit check5_5 i.condition1 i.stratum1


// Political knowledge

	// Number of correct answers
	*reg know_pol i.condition1
	reg know_pol i.condition1 i.stratum1
	eststo knowpol
	
	// Number of DKs
	*reg know_pol_dk i.condition1
	reg know_pol_dk i.condition1 i.stratum1
	eststo knowpoldk
	
// General scientific knowledge

	// Number of correct answers
	*reg know_gen i.condition1
	reg know_gen i.condition1 i.stratum1
	eststo knowgen
	
	// Number of DKs
	*reg know_gen_dk i.condition1
	reg know_gen_dk i.condition1 i.stratum1
	eststo knowscidk

	esttab using "tables/tabknow.tex", replace ///
		nobaselevels label ///
		b(%9.2f) se(%9.2f) stats (N rmse) ///
		title (Political and Science Knowledge) ///
		mtitles ("Political Knowledge" "DKs (Political)" "Science Knowledge" "DKs (Science)")
		
	eststo clear
	
	
	
// Self-reported cheating

	// on political knowledge
	*quietly logit cheat_pol i.condition1
	*margins, dydx(*)
	quietly logit cheat_pol i.condition1 i.stratum1
	margins, dydx(*)
	eststo cheatpol
	
	// on general scientific knowledge
	*quietly logit cheat_gen i.condition1
	*margins, dydx(*)
	quietly logit cheat_gen i.condition1 i.stratum1
	margins, dydx(*)
	eststo cheatsci
	
	esttab using "tables/tabcheat.tex", replace ///
		nobaselevels label ///
		b(%9.2f) se(%9.2f) stats (N rmse) ///
		title (Self-Reported Cheating Political and Science Knowledge) ///
		mtitles ("Political Knowledge" "Science Knowledge") ///
		addnotes("Cell entries are average marginal effects calculated from logistic regression estimates")
		
	eststo clear
	
	
//Evaluation of the survey

	*tab condition1, summarize(email)
	*reg email i.condition1
	logit email i.condition1 i.stratum1
	margins, dydx(*)
	eststo email

	*tab condition1, summarize(survey)
	*reg survey i.condition1
	reg survey i.condition1 i.stratum1
	eststo survey

	*tab condition1, summarize(pay2)
	*reg pay2 i.condition1
	reg pay2 i.condition1 i.stratum1
	eststo pay2

// Evaluation of relevant institutions

	*reg eval_univ i.condition1
	reg eval_univ i.condition1 i.stratum1
	eststo univ
	
	*reg eval_market i.condition1
	reg eval_market i.condition1 i.stratum1
	eststo market
	
	esttab using "tables/tabeval.tex", replace ///
		nobaselevels label ///
		b(%9.2f) se(%9.2f) stats (N rmse) ///
		title (Respondents' Evaluation of Survey) ///
		mtitles ("Receive email" "Survey Rating" "Compensation" "Universities" "Marketing Firms") ///
		addnotes("Cell entries in Column 1 are average marginal effects calculated from logistic regression estimates")
	
	eststo clear

// END
