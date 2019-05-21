************************************************************************************
**Replication Code: Schleiter & Tavits, "Voter Reactions to Incumbent Opportunism"**
************************************************************************************

**************
**Main Paper**
**************

**********************************************************************************
*Figure 1: Effect of opportunistic election timing on vote intention, Studies 1-3*
**********************************************************************************

	***************************
	**Panel 1: Vote intention**
	***************************
	
	**Study 1 (Feb 2015)**
		use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 1_Feb 2015.dta", clear
		cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"
				graph set window fontface "Times New Roman"
				label define treat_early_l 0 "Con." 1 "Treat.", modify
				label values treat_early treat_early_l 
				
				anova vote treat_early if vote!=6
				margins treat_early
				marginsplot, xdimension(treat_early) xlabel(, nogrid) xti("") yti("Vote intention" "(less likely - more likely)") ///
				title("(1a) Study 1" " ") recast(scatter) scale(1.2) ///
				xscale(range(-0.3 1.3)) yscale(range(3.4 4)) scheme(s1mono) name(f1s1, replace)

	**Study 2 (Nov 2015)**
		use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 2_Nov 2015.dta", clear	
		cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"
				label define treat_l 0 "Con." 1 "Treat.", modify
				label values treat treat_l 
				
				anova vote treat if vote!=6
				margins treat
				marginsplot, xdimension(treat) xlabel(, nogrid) xti("") yti("Vote intention" "(less likely - more likely)") ///
				title("(1b) Study 2" " ") recast(scatter) scale(1.2) ///
				xscale(range(-0.3 1.3)) yscale(range(3.4 4)) scheme(s1mono) name(f1s2, replace)
				
	**Study 3 - varying partisanship (February 2017)**
		use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 3_Feb 2017_Partisanship.dta", clear
		cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"
				label define treat_label 0 "Con." 1 "Treat.", modify
				label values treat treat_label
				
				anova vote treat if vote!=6
				margins treat
				marginsplot, xdimension(treat) xlabel(, nogrid) xti("") yti("Vote intention" "(less likely - more likely)") ///
				title("(1c) Study 3"  " ") recast(scatter) scale(1.2) ///
				xscale(range(-0.3 1.3)) yscale(range(3.4 4)) scheme(s1mono) name(f3, replace)
		
			graph combine f1s1 f1s2 f3, ycommon row(1) iscale(.7) title("(1) Vote Intention" " ") name(f4_1, replace)

	************************************************
	**Panel 2: Vote intention varying partisanship**
	************************************************

		**Study 3 - varying partisanship (February 2017)**
			use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 3_Feb 2017_Partisanship.dta", clear
			cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

			**Preferred party in government**
					label define treat_1_label 0 "Control" 1 "Treatment", modify
					label values treat_1 treat_1_label
					
					anova vote treat_1 if vote!=6 & (treat_1 | control_1)
					margins treat_1
					marginsplot, xdimension(treat_1) xlabel(, nogrid) xti("") yti("Vote intention" "(less likely - more likely)") ///
					title("(2a) Preferred Party" "in Government") recast(scatter) scale(1.2) ///
					xscale(range(-0.3 1.3)) scheme(s1mono) name(f1s1, replace)

			**Preferred party not in government**
					label define treat_2_label 0 "Control" 1 "Treatment", modify
					label values treat_2 treat_2_label
					
					anova vote treat_2 if vote!=6 & (treat_2 | control_2)
					margins treat_2
					marginsplot, xdimension(treat_2) xlabel(, nogrid) xti("") yti("Vote intention" "(less likely - more likely)") ///
					title("(2b) Preferred Party" "not in Government") recast(scatter) scale(1.2) ///
					xscale(range(-0.3 1.3)) scheme(s1mono) name(f1s2, replace)
					
			graph combine f1s1 f1s2, ycommon row(1) iscale(.7) title("(2) Vote Intention" "Varying Partisanship (Study 3)" ) name(f4_2, replace)	
			graph combine f4_1 f4_2, row(1) iscale(.7)

			
			******************************************
			**Wilcoxon rank-sum (Mann-Whitney) tests**
			******************************************
			**Study 1 (Feb 2015)**
				use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 1_Feb 2015.dta", clear
				cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"
						ranksum vote if vote!=6, by(treat_early)

			**Study 2 (Nov 2015)**
				use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 2_Nov 2015.dta", clear	
				cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"
						ranksum vote if vote!=6, by(treat)

			**Study 3 - varying partisanship (February 2017)**
				use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 3_Feb 2017_Partisanship.dta", clear
				cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"
						ranksum vote if vote!=6, by(treat)


****************************************************************************************************************************************************
**Figure 2: The effect of opportunistic election timing on competence evalutions and expectations for future economic performance, Studies 2 and 3**
****************************************************************************************************************************************************

	**Study 2 (Nov 2015)**
		use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 2_Nov 2015.dta", clear	
		cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

		**Competence**
				label define treat_l 0 "Control" 1 "Treatment", modify
				label values treat treat_l 

				anova eval_comp treat if eval_comp!=6
				margins treat
				marginsplot, xdimension(treat) xlabel(, nogrid) xti("") yti("Evaluation" "(negative - positive)") ///
				title("(1a) Study 2") recast(scatter) scale(1.2) ///
				xscale(range(-0.3 1.3)) yscale(range(3.4 4)) scheme(s1mono) name(f1, replace)

			**Anticipated economic performance**
				label define treat_l 0 "Control" 1 "Treatment", modify
				label values treat treat_l 
				
				anova econ_exp treat if econ_exp!=6
				margins treat
				marginsplot, xdimension(treat) xlabel(, nogrid) xti("") yti("Performance" "(negative - positive)") ///
				title("(2a) Study 2") recast(scatter) scale(1.2) ///
				xscale(range(-0.3 1.3)) yscale(range(3.4 4)) scheme(s1mono) name(f3, replace)
				

	**Study 3 - (February 2017)**
		use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 3_Feb 2017_Partisanship.dta", clear
		cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

				label define treat_label 0 "Control" 1 "Treatment", modify
				label values treat treat_label

			*Competence*
				anova comp treat if comp!=6
				margins treat
				marginsplot, xdimension(treat) xlabel(, nogrid) xti("") yti("Evaluation" "(negative - positive)") ///
				title("(1b) Study 3") recast(scatter) scale(1.2) ///
				xscale(range(-0.3 1.3)) yscale(range(3.4 4)) scheme(s1mono) name(f2, replace)
				
			*Anticipated economic performance*
				anova eexp treat if eexp!=6
				margins treat
				marginsplot, xdimension(treat) xlabel(, nogrid) xti("") yti("Performance" "(negative - positive)") ///
				title("(2b) Study 3") recast(scatter) scale(1.2) ///
				xscale(range(-0.3 1.3)) yscale(range(3.4 4)) scheme(s1mono) name(f4, replace)
			
			graph combine f1 f2, ycommon row(1) iscale(.7) title("(1) Competence" " ") name(f4_1, replace)
			graph combine f3 f4, ycommon row(1) iscale(.7) title("(2) Anticipated" "Economic Performance") name(f4_2, replace)
			graph combine f4_1 f4_2, row(1) iscale(.7)

			
			******************************************
			**Wilcoxon rank-sum (Mann-Whitney) tests**
			******************************************
			**Study 2 (Nov 2015)**
				use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 2_Nov 2015.dta", clear	
				cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"
						ranksum eval_comp if eval_comp!=6, by(treat)
						ranksum econ_exp if econ_exp!=6, by(treat)

			**Study 3 (February 2017)**
				use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 3_Feb 2017_Partisanship.dta", clear
				cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"
						ranksum comp if comp!=6, by(treat)
						ranksum eexp if eexp!=6, by(treat)

***************************************************************************************************
**Figure 3: The effect of opportunistic election timing on perceived procedural fairness, Study 3**
***************************************************************************************************

		**Study 3 (February 2017)		
		use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 3_Feb 2017_Partisanship.dta", clear
		cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

				label define treat_label 0 "Control Group" 1 "Treatment Group", modify
				label values treat treat_label

			*Fairness to voters*
				anova fairv treat if fairv!=6
				margins treat
				marginsplot, xdimension(treat) xlabel(, nogrid) xti("") yti("Fairness" "(unfair - fair)") ///
				title("(1) Fairness" "to voters") recast(scatter) scale(1.2) ///
				xscale(range(-0.3 1.3)) yscale(range(3 4)) scheme(s1mono) name(f1, replace)
				
			*Fairness to other parties*
				anova fairp treat if fairp!=6
				margins treat
				marginsplot, xdimension(treat) xlabel(, nogrid) xti("") yti("Fairness" "(unfair - fair)")  ///
				title("(2) Fairness" "to other parties") recast(scatter) scale(1.2) ///
				xscale(range(-0.3 1.3)) yscale(range(3 4)) scheme(s1mono) name(f2, replace)
			
			graph combine f1 f2, row(1) ycommon 

			
			******************************************
			**Wilcoxon rank-sum (Mann-Whitney) tests**
			******************************************
			**Study 3 - varying partisanship (February 2017)**
				use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 3_Feb 2017_Partisanship.dta", clear
				cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"
						ranksum fairv if fairv!=6, by(treat)
						ranksum fairp if fairp!=6, by(treat)


				
**************************************************************************************************
**Figure 4: The effect of economic variation and and election timing on vote intention, Study 4**
**************************************************************************************************

		*Study 4 - varying economic conditions (March 2017)*
		use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 4_Mar 2017_Economy.dta", clear
		cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

		**Effects of economic performance on vote intention***
		
				label define econ_l 0 "Strong Economy" 1 "Mixed Economy", modify
				label values econ econ_l 
				
				anova vote econ
				margins econ
				marginsplot, xdimension(econ) xlabel(, nogrid) xti("") yti("Vote intention" "(less likely - more likely)") ///
				title("(1) Varying" "economic performance") recast(scatter) scale(1.2) ///
				xscale(range(-0.3 1.3)) yscale(range(3 3.8)) scheme(s1mono) name(f1, replace) bgcolor(white) graphregion(color(white) lwidth(large))
				
		**Effect of opportunistic election timing on vote intention**

				label define treat_label 0 "Regular Elect." 1 "Opportunistic Elect.", modify
				label values treat treat_label
				
				anova vote treat if vote!=6
				margins treat
				marginsplot, xdimension(treat) xlabel(, nogrid) xti("") yti("Vote intention" "(less likely - more likely)") ///
				title("(2) Varying" "election timing") recast(scatter) scale(1.2) ///
				xscale(range(-0.3 1.3)) yscale(range(3 3.8)) scheme(s1mono) name(f3, replace)

			graph combine f1 f3, ycommon 
			title("Varying economic performance") name(f12, replace)
			graph combine f3 f4, ycommon title("Varying election timing") name(f34, replace)
			graph combine f12 f34, ycommon row(1) iscale(.7)

			******************************************
			**Wilcoxon rank-sum (Mann-Whitney) tests**
			******************************************
						ranksum vote if vote!=6, by(econ)
						ranksum vote if vote!=6, by(treat)
		
						

						
	