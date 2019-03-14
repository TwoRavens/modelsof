** this script replicates the analysis in Tables 1 and 2 **
** of "Cabinet Durability and Fiscal Discipline" **
** by David Fortunato and Matt W. Loftis **

** //\\//\\ depending on your machine, this will take about an hour all told //\\//\\**


** first, execute utility file for posterior draws **
** then read in the data and perform the panel setting **
	cd "~/Dropbox/Sovereign bond rates/data/replication"
	do "simutils.do"
	use "replication.dta", clear
	xtset couno year, yearly

** this estimates the models using an arbitrary draw of the independent variable **
** (duration discount is the length of time the cabinet has already served) **
** and do not forget to trim expectations to the ciep (maxDuration)**
	gen expectedDuration  = iteration_305 + durationDiscount
	replace expectedDuration = maxDuration if expectedDuration  > maxDuration

** pooled then FE **
** spending **
	xtpcse outlays l.numpar_year l.enp_year l.caretakertime l.gdppercap l.unemp_rate l.dep_ratio l.openc l.outlays l.maasera l.budgetconstraint l.budgetconstraint_inter expectedDuration lr gdppercap unemp_rate dep_ratio openc, pairwise
	xtpcse outlays l.numpar_year l.enp_year l.caretakertime l.gdppercap l.unemp_rate l.dep_ratio l.openc l.outlays l.maasera l.budgetconstraint l.budgetconstraint_inter expectedDuration lr gdppercap unemp_rate dep_ratio openc  i.couno, pairwise

** deficits **
	xtpcse deficit l.numpar_year l.enp_year l.caretakertime l.gdppercap l.unemp_rate l.dep_ratio l.openc l.deficit l.maasera l.budgetconstraint l.budgetconstraint_inter expectedDuration lr gdppercap unemp_rate dep_ratio openc, pairwise
	xtpcse deficit l.numpar_year l.enp_year l.caretakertime l.gdppercap l.unemp_rate l.dep_ratio l.openc l.deficit l.maasera l.budgetconstraint l.budgetconstraint_inter expectedDuration lr gdppercap unemp_rate dep_ratio openc  i.couno, pairwise
	
** And now bootstrap these, writing the posterior draws to a new file **
	gen r2spend = 0
	gen r2spendFix = 0
	gen r2def = 0
	gen r2defFix = 0
	set seed 0624
	set more off
	forvalues x = 1/1000{

		drop expectedDuration*
		gen expectedDuration  = iteration_`x' + durationDiscount
		replace expectedDuration = maxDuration if expectedDuration  > maxDuration
	** this draws new estimates of cabinet ideology to model the measure uncertainty **
		gen lrNew = rnormal(lr, lrSe)
		xtpcse outlays l.numpar_year l.enp_year l.caretakertime l.gdppercap l.unemp_rate l.dep_ratio l.openc l.outlays l.maasera l.budgetconstraint l.budgetconstraint_inter expectedDuration lrNew  gdppercap unemp_rate dep_ratio openc, pairwise

		replace r2spend = r2spend + e(r2)

		tempname b V sig dfsig
		matrix `b' = e(b)                            /* 1 x k vector         */
		matrix `V' = e(V)                            /* k x k variance matrix*/
		local N = `e(N)'                             /* save # observations  */

		capture drop bbt*
		_simp, b(`b') v(`V') s(100) g(bbt) 
	
		preserve
		
			keep bbt*
			drop if bbt1 == .
			if `x' == 1{

				save "spendingPosteriors.dta", replace

			}
			else {
			
				append using "spendingPosteriors.dta"
				saveold "spendingPosteriors.dta", version(12) replace
			}

		restore

		xtpcse outlays l.numpar_year l.enp_year l.caretakertime l.gdppercap l.unemp_rate l.dep_ratio l.openc l.outlays l.maasera l.budgetconstraint l.budgetconstraint_inter expectedDuration lrNew  gdppercap unemp_rate dep_ratio openc i.couno, pairwise
		replace r2spendFix = r2spendFix + e(r2)

		tempname b V sig dfsig
		matrix `b' = e(b)                            /* 1 x k vector         */
		matrix `V' = e(V)                            /* k x k variance matrix*/
		local N = `e(N)'                             /* save # observations  */

		capture drop bbt*
		_simp, b(`b') v(`V') s(100) g(bbt) 
	
		preserve
		
			keep bbt*
			drop if bbt1 == .
			if `x' == 1{

				save "spendingPosteriorsFix.dta", replace

			}
			else {
			
				append using "spendingPosteriorsFix.dta"
				saveold "spendingPosteriorsFix.dta", version(12) replace
			}

		restore


		xtpcse deficit l.numpar_year l.enp_year l.caretakertime l.gdppercap l.unemp_rate l.dep_ratio l.openc l.deficit l.maasera l.budgetconstraint l.budgetconstraint_inter  expectedDuration lrNew  gdppercap unemp_rate dep_ratio openc, pairwise
		replace r2def = r2def + e(r2)

		tempname b V sig dfsig
		matrix `b' = e(b)                            /* 1 x k vector         */
		matrix `V' = e(V)                            /* k x k variance matrix*/
		local N = `e(N)'                             /* save # observations  */

		capture drop bbt*
		_simp, b(`b') v(`V') s(100) g(bbt) 
	
		preserve
		
			keep bbt*
			drop if bbt1 == .
			if `x' == 1{

				save "deficitPosteriors.dta", replace

			}
			else {
			
				append using "deficitPosteriors.dta"
				saveold "deficitPosteriors.dta", version(12)replace
			}

		restore

		xtpcse deficit l.numpar_year l.enp_year l.caretakertime l.gdppercap l.unemp_rate l.dep_ratio l.openc l.deficit l.maasera l.budgetconstraint l.budgetconstraint_inter expectedDuration lrNew  gdppercap unemp_rate dep_ratio openc i.couno, pairwise
		replace r2defFix = r2defFix + e(r2)

		tempname b V sig dfsig
		matrix `b' = e(b)                            /* 1 x k vector         */
		matrix `V' = e(V)                            /* k x k variance matrix*/
		local N = `e(N)'                             /* save # observations  */

		capture drop bbt*
		_simp, b(`b') v(`V') s(100) g(bbt) 
	
		preserve
		
			keep bbt*
			drop if bbt1 == .
			if `x' == 1{

				save "deficitPosteriorsFix.dta", replace

			}
			else {
			
				append using "deficitPosteriorsFix.dta"
				saveold "deficitPosteriorsFix.dta", version(12) replace
			}

	restore
		
	drop lrNew
	
	}

	sum r2spend
	sum r2spendFix
	sum r2def
	sum r2defFix
