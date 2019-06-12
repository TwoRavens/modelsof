capture program drop test_ezop
program define test_ezop, eclass
		version 12
		syntax [, qmin(real 10) qmax(real 90) groups(real 2) myfile(string asis) median atmedian qte]

		capture log close

		do ezOP_07.do

		if "`qte'" != "" {
			local method "QTE comparison"
		}
		else {
			local method "Distribution comaparison"
		}
		//	Obtain quantiles (q=19) for the QTE as averages of bootstrapped QTE.
		//	Obtain COVARIANCES between quantiles (q=19) for the QTE estimated by the covariance between bspped QTE

		local groups = `groups'
		local groups2 = `groups' - 1

		if "`median'" == "" & "`atmedian'" == "" {
			local where "MEAN"
		}
		else if "`median'" != "" & "`atmedian'" == "" {
			local where "MEDIAN"
		}
		else if "`median'" == "" & "`atmedian'" != "" {
			local where "ATMEDIAN"
		}
		else if "`median'" != "" & "`atmedian'" != "" {
			di as error "Chose either MEAN of QTE, MEDIAN of QTE or QTE at the MEDIAN."
		}
		
		foreach x of numlist 1(1)`groups' {
			local n`x' = 1
			local n2`x' = 359104/`groups'
		}

		use `myfile', clear
		keep ez_i1_p1t1 ez_i5_p1t1 ez_i9_p1t1 rif_ez_*i1 rif_ez_*i5 rif_ez_*i9 quantile repl
		rename ez_i1_p1t1 ez_i1_p1t1
		rename ez_i5_p1t1 ez_i2_p1t1
		rename ez_i9_p1t1 ez_i3_p1t1
		local names "MEAN MEDIAN ATMEDIAN"
		foreach x of local names {
			rename rif_ez_`x'i1 rif_ez_`x'i1
			rename rif_ez_`x'i5 rif_ez_`x'i2
			rename rif_ez_`x'i9 rif_ez_`x'i3			
		}
		drop if repl==0
		qui sum repl
		local repmax = r(max)
		foreach x of numlist 1(1)`groups' {
			mkmat ez_i`x'_p1t1 if repl==1, mat(Q`x') nomis
			mkmat rif_ez_`where'i`x' if repl==1, mat(QTE`x') nomis
			mat Q0`x' = Q`x' - QTE`x'
			mata : st_matrix("Q0`x'", sort(st_matrix("Q0`x'"), 1))	
			foreach rep of numlist 2(1)`repmax' {
				mkmat ez_i`x'_p1t1 if repl==`rep', mat(Q`x'`rep') nomis
				mkmat rif_ez_`where'i`x' if repl==`rep', mat(QTE`x'`rep') nomis
				mat Q0`x'`rep' = Q`x'`rep' - QTE`x'`rep'
				mata : st_matrix("Q0`x'`rep'", sort(st_matrix("Q0`x'`rep'"), 1))	
				mat Q0`x' = Q0`x', Q0`x'`rep'		
				mat Q`x' = Q`x', Q`x'`rep'
				mat QTE`x' = QTE`x', QTE`x'`rep'
			}
			local matn "Q`x' Q0`x' QTE`x'"
			foreach M of local matn {
				mat `M' = `M''
				mata: m`M' = mean(st_matrix("`M'"))
				mata: cv`M' = `n`x''*variance(st_matrix("`M'"))
				mata: st_matrix("`M'", m`M'')
				mata: st_matrix("S`M'", cv`M'')
			}
		}

		local qmax = `qmax'
		local qmin = `qmin'
		local qrange = `qmax' - `qmin' + 1

		//	Keep only quantiles between 5% and 95% to be sure of skipping tails
		foreach x of numlist 1(1)`groups' {
			local matn "Q`x' Q0`x' QTE`x'"
			foreach M of local matn {
				mat `M'compl = `M'
				mat `M' = J(19,1,.)
				foreach i of numlist 1(1)19 {
					mat `M'[`i',1] = `M'compl[`i'*5,1]
				}
			}
			local matn "SQ`x' SQ0`x' SQTE`x'"
			foreach M of local matn {
				mat `M'compl = `M'
				mat `M' = J(19,19,.)
				foreach i of numlist 1(1)19 {
					foreach j of numlist 1(1)19 {
						mat `M'[`i',`j'] = `M'compl[`i'*5,`j'*5]
					}
				}
			}
		}
		
		/*
		//	Sequential hypothesis testing. To be run in case of need!!!
		//	Note that some of the QTE estimates are not significant.
		//	One possibility is to substitute these values for "0" in the QTE vectors.

		foreach x of numlist 1(1)4 {
			foreach i of numlist 1(1)19 {
				local test = abs(QTE`x'[`i',1]/QTE`x'se[`i',1])
				if `test'<1.96 mat QTE`x'[`i',1]=0
				else continue
			}
		}
		*/

		local qPC = 99
		local q = 19


		//	Run the estimators for ezOP_alpha(), ezOP_beta(), ezOP(). 
		// 	The commands produce a vector of test-statistics and p-values for the nulls:
		//	-	H0: "=" in position [1,1]
		//	-	H0: ">" in position [1,2]
		//	-	H0: "<" in position [1,2]
		//	Depending on the p-value, the values of alpha and beta are set:
		//	-	alpha = +1/-1 iff condition (a) is satisfied, 0 otherwise
		//	-	beta = +1/-1 iff condition (a) is satisfied. 0 otherwise
		//	Finally, the command produces a table to be plotted.


		if "`qte'" != "" {
			mat data = J(1,17,.)
			mat coln data = "Gdomd" "Gdomt" "TdomF0" "TdomF1" "TdomQTE" "PVALdomF0" "PVALdomF1" "PVALdomQTE" "TeqF0" "TeqF1" "TeqQTE" "PVALeqF0" "PVALeqF1" "PVALeqQTE" "comparison" "alpha" "beta"
			foreach i of numlist 1(1)`groups2' {
				local j = `i'+1
				while `j'<=`groups' {
					qui {			
						mata: ezOP_alpha(st_matrix("Q0`i'"), st_matrix("Q0`j'"), st_matrix("SQ0`i'"), st_matrix("SQ0`j'"), `n`i'', `n`j'', `q', "TstatAlpha", "PvalueAlpha")
						if PvalueAlpha[1,1]>=0.01 | PvalueAlpha[1,2]>=0.01 {
							local alpha = 1
						}
						else if PvalueAlpha[1,3]>=0.01 {
							local alpha = -1
						}
						else local alpha = 0
						mata: ezOP_beta(st_matrix("Q`i'"), st_matrix("Q`j'"), st_matrix("SQ`i'"), st_matrix("SQ`j'"), `n`i'', `n`j'', `q', "TstatBeta", "PvalueBeta")
						if PvalueBeta[1,1]>=0.01 | PvalueBeta[1,2]>=0.01 {
							local beta = 1
						}
						else if PvalueBeta[1,3]>=0.01 {
							local beta = -1
						}
						else local beta = 0
						
						local nt = `n`i'' + `n`j''
						if `alpha' == `beta' & `alpha'!=0 {
							if `alpha'==1 {
								mata: ezOP2(st_matrix("QTE`j'"), st_matrix("QTE`i'"), st_matrix("SQTE`j'"), st_matrix("SQTE`i'"), `n`j'', `n`i'', `nt', `q', "TstatEZOP", "PvalueEZOP")
							}
							else {
								mata: ezOP2(st_matrix("QTE`i'"), st_matrix("QTE`j'"), st_matrix("SQTE`i'"), st_matrix("SQTE`j'"), `n`i'', `n`j'', `nt', `q', "TstatEZOP", "PvalueEZOP")
							}				
						}
						else mata: ezop(st_matrix("Q0`i'"), st_matrix("Q0`j'"), st_matrix("Q`i'"), st_matrix("Q`j'"), st_matrix("SQ0`i'"), st_matrix("SQ0`j'"), st_matrix("SQ`i'"), st_matrix("SQ`j'"), `alpha', `beta', `n2`i'', `n2`j'', `q', "TstatEZOP", "PvalueEZOP")			

						mat AB = `alpha' \ `beta' \ .

						mat Tstat = TstatAlpha \ TstatBeta \ TstatEZOP
						mat Pvalue = PvalueAlpha \ PvalueBeta \ PvalueEZOP
						
						mat TAB`i'`j' = Tstat[1..3,1], Pvalue[1..3,1], Tstat[1..3,2], Pvalue[1..3,2], Tstat[1..3,3], Pvalue[1..3,3], AB 
						mat coln TAB`i'`j' = "Test H0: =" "p-value" "Test H0: >" "p-value" "Test H0: <" "p-value" "Which H0?"
						mat rown TAB`i'`j' = "F0 vs G0" "F1 vs G1" "Gap dominance"
						mat TABt = TAB`i'`j''
						mat data1 = `i', `j', TABt[3,1..3], TABt[4,1..3], TABt[1,1..3], TABt[2,1..3], 1, TABt[7,1..2] 
						mat data2 = `j', `i', TABt[5,1..3], TABt[6,1..3], TABt[1,1..3], TABt[2,1..3], 2, TABt[7,1..2]
						mat data = data \ data1 \ data2
					}
					local j = `j'+1
				}
			}
		}
		**********************************************************************************************
		else {
			foreach i of numlist 1(1)`groups2' {
				local j = `i'+1
				while `j'<=`groups' {
					qui {			
						mata: ezOP_alpha(st_matrix("Q0`i'"), st_matrix("Q0`j'"), st_matrix("SQ0`i'"), st_matrix("SQ0`j'"), `n`i'', `n`j'', `q', "TstatAlpha", "PvalueAlpha")
						if PvalueAlpha[1,1]>=0.01 | PvalueAlpha[1,2]>=0.01 {
							local alpha = 1
						}
						else if PvalueAlpha[1,3]>=0.01 {
							local alpha = -1
						}
						else local alpha = 0
						mata: ezOP_beta(st_matrix("Q`i'"), st_matrix("Q`j'"), st_matrix("SQ`i'"), st_matrix("SQ`j'"), `n`i'', `n`j'', `q', "TstatBeta", "PvalueBeta")
						if PvalueBeta[1,1]>=0.01 | PvalueBeta[1,2]>=0.01 {
							local beta = 1
						}
						else if PvalueBeta[1,3]>=0.01 {
							local beta = -1
						}
						else local beta = 0

						mata: ezop(st_matrix("Q0`i'"), st_matrix("Q0`j'"), st_matrix("Q`i'"), st_matrix("Q`j'"), st_matrix("SQ0`i'"), st_matrix("SQ0`j'"), st_matrix("SQ`i'"), st_matrix("SQ`j'"), `alpha', `beta', `n`i'', `n`j'', `q', "TstatEZOP", "PvalueEZOP")			

						mat AB = `alpha' \ `beta' \ .

						mat Tstat = TstatAlpha \ TstatBeta \ TstatEZOP
						mat Pvalue = PvalueAlpha \ PvalueBeta \ PvalueEZOP
						
						mat TAB`i'`j' = Tstat[1..3,1], Pvalue[1..3,1], Tstat[1..3,2], Pvalue[1..3,2], Tstat[1..3,3], Pvalue[1..3,3], AB 
						mat coln TAB`i'`j' = "Test H0: =" "p-value" "Test H0: >" "p-value" "Test H0: <" "p-value" "Which H0?"
						mat rown TAB`i'`j' = "F0 vs G0" "F1 vs G1" "Gap dominance, given a,b"
					}
					local j = `j'+1
				}
			}
		}

		tempfile datause 
		save `datause', replace
		clear
		svmat data, names(col)
		save  data_graph_3groups.dta, replace
		use `datause', clear
		
		local pairs = comb(`groups',2)
		local pairs " "
		local f = 1
		while `f' <=`groups2' {
			local f2 = `f' + 1
			foreach s of numlist `f2'(1)`groups' {
				local pairs "`pairs' `f'`s'"
			}
			local f = `f' + 1
		}
		foreach x of local pairs {
			foreach j of numlist 1(1)6 {
				foreach i of numlist 1(1)3 {
					local out`x'`i'`j' = TAB`x'[`i',`j']
					ereturn scalar out`x'`i'`j' = `out`x'`i'`j''
				}
			}
		}
end
