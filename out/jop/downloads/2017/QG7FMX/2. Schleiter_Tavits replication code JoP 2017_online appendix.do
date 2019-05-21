************************************************************************************
**Replication Code: Schleiter & Tavits, "Voter Reactions to Incumbent Opportunism"**
************************************************************************************

*******************
**Online Appendix**
*******************


********************************
***OA.3: Randomization checks***
********************************
	
	**********************************************************************************************************************************************
	**Table OA 3.1.1: Randomization check Studies 1 and 2, logistic regression of treatment assignment on observable demographic characteristics**
	**********************************************************************************************************************************************

		**Study 1 (Feb 2015)**
				use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 1_Feb 2015.dta", clear
				cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

			*Table OA 3.1.1 Study 1*
				lab var gender "Gender"
				lab var age "Age"
				lab var education_age "Education (years)"
				lab var education_level "Education (level)"
				lab var soc_grade "Social grade group"
				lab var income_h "Income (household)"
				lab var income_pers "Income (personal)"
				logit treat_early gender age education_age education_level soc_grade income_pers income_h
				test gender age education_age education_level soc_grade income_personal income_household
							outreg2 using tableSI3_1.1.rtf, replace ///
							label se bdec(3) tdec(3) ctitle("Study 1") ///
							addtext("Wald Test chi-squ.(7df) 10.83 (p-value = .146)") ///
							title ("Table SI 3.1: Randomization checks studies 1 and 2, logistic regression of treatment assignment on observable demographic characteristics") ///
							nonotes addn("Note: Table entries are regression coefficients with standard errors in parentheses. ***p<0.01, **p<0.05, *p<0.1")

		**Study 2 (Nov 2015)**
				use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 2_Nov 2015.dta", clear	
				cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

			*Table OA 3.1.1 Study 2*
				lab var gender "Gender"
				lab var age "Age"
				lab var education_age "Education (years)"
				lab var education_level "Education (level)"
				lab var socialgrade "Social grade group"
				lab var gross_house "Income (household)"
				lab var gross_pers "Income (personal)"
				logit treat gender age education_age education_level socialgrade gross_house gross_pers
				test gender age education_age education_level socialgrade gross_house gross_pers
							outreg2 using tableSI3_1.1.rtf, replace ///
							label se bdec(3) tdec(3) ctitle("Study 2") ///
							addtext("Wald Test chi-squ. 7df 1.77 (p-value = 0.972)") ///
							title ("Table SI 3.1: Randomization checks studies 1 and 2, logistic regression of treatment assignment on observable demographic characteristics") ///
							nonotes addn("Note: Table entries are regression coefficients with standard errors in parentheses. ***p<0.01, **p<0.05, *p<0.1")

	*********************************************************************************************************************************************************
	**Table OA.3.1.2: Randomization check Studies 3 & 4, multinomial regression of experimental group assignement on observable demographic characteristics**
	*********************************************************************************************************************************************************

							
		**Study 3 - varying partisanship (February 2017)**
				use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 3_Feb 2017_Partisanship.dta", clear
				cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

			*Table OA.3.1.2: Study 3*
				lab var gender "Gender"
				lab var age "Age"
				lab var education_age "Education (years)"
				lab var education_level "Education (level)"
				lab var social_grade "Social grade group"
				lab var household "Income (household)
				lab var personal_i "Income (personal)"
				qui mlogit split gender age education_age education_level social_grade household personal_i, base(4)
				test gender age education_age education_level social_grade household_income personal_income 
							outreg2 using tableSI3_2.rtf, replace ///
							label se bdec(3) tdec(3) cttop("Study 3") ctitle(Control 1; Treatment 1; Control 2) ///
							addtext("Wald Test chi-squ. 21df 22.73 (p-value = 0.359)") ///
							nonotes addn("Note: The reference category is treatment group 2. Table entries are regression coefficients with standard errors in parentheses. ***p<0.01, **p<0.05, *p<0.1")

		*Study 4 - varying economic conditions (March 2017)*
				use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 4_Mar 2017_Economy.dta", clear
				cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

			*Table OA.3.1.2: Study 4*
				lab var gender "Gender"
				lab var age "Age"
				lab var education_age "Education (years)"
				lab var education_level "Education (level)"
				lab var socialgrade "Social grade group"
				lab var household_income "Income (household)"
				lab var household_personal "Income (personal)"

				qui mlogit split gender age education_age education_level socialgrade household_income household_personal, base(4)
				test gender age education_age education_level socialgrade household_income household_personal
							outreg2 using tableSI3_2.rtf, append ///
							label se bdec(3) tdec(3)  cttop("Study 4") ctitle(Control 1; Treatment 1; Control 2) ///
							addtext("Wald Test chi-squ. 21df 19.78 (p-value = 0.535)") ///
							title ("Table OA.3.1.2: Randomization checks studies 3 and 4, multinomial logistic regression of experimental group assignment on observable demographic characteristics") ///
							nonotes addn("Note: The reference category is treatment group 2. Table entries are regression coefficients with standard errors in parentheses. ***p<0.01, **p<0.05, *p<0.1")

*************************************
***OA3.2: Covariate Balance Checks***
*************************************

	**********************************************************
	**Table OA 3.2.1: Covariate balance checks studies 1 & 2**
	**********************************************************

		**Study 1 (Feb 2015)**
				use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 1_Feb 2015.dta", clear
				cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

				label define treatment_l 1 "Control" 2 "Treatment 1" 3 "Treatment 2", modify
				label values treatment treatment_l 
				lab var gender "Gender"
				lab var age "Age"
				lab var education_age "Education (years)"
				lab var education_level "Education (level)"
				lab var soc_grade "Social grade group"
				lab var income_h "Income (household)"
				lab var income_pers "Income (personal)"
				matrix drop T
						mat T = J(2,6,.)
						ttest gender, by (treat_early) welch
						mat T[2,1] = r(mu_1)
						mat T[2,2] = r(sd_1)
						mat T[2,3] = r(mu_2)
						mat T[2,4] = r(sd_2)
						mat T[2,5] = r(mu_1) - r(mu_2)
						mat T[2,6] = r(p)								
						mat rownames T = gender
						
						frmttable using tableSI3_3.rtf, statmat(T) varlabels replace ///
						title("Table SI 3.3: Covariate balance checks, studies 1 and 2") ///
						rtitles("Study 1" \ "Gender") ///
						ctitle("", Mean (Control), Standard Deviation (Control), Mean (Treatment), Standard Deviation (Treatment), Difference-of-Means, p-value) sdec(2,2,2,2,2,3)
			
					quietly foreach x of varlist age education_age education_level soc_grade income_pers income_h {
						mat T = J(1,6,.)
						ttest `x', by (treat_early) welch
						mat T[1,1] = r(mu_1)
						mat T[1,2] = r(sd_1)
						mat T[1,3] = r(mu_2)
						mat T[1,4] = r(sd_2)
						mat T[1,5] = r(mu_1) - r(mu_2)
						mat T[1,6] = r(p)								
						mat rownames T = `x' 
						
						frmttable using tableSI3_3.rtf, statmat(T) varlabels append ///
						title("Table OA.3.2.1: Covariate balance checks, Studies 1 and 2") ///
						ctitle("", Mean (Control), Standard Deviation (Control), Mean (Treatment), Standard Deviation (Treatment), Difference-of-Means, p-value) sdec(2,2,2,2,2,3)
					}		

		**Study 2 (Nov 2015)**
				use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 2_Nov 2015.dta", clear	
				cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"
				lab var gender "Gender"
				lab var age "Age"
				lab var education_age "Education (years)"
				lab var education_level "Education (level)"
				lab var socialgrade "Social grade group"
				lab var gross_house "Income (household)"
				lab var gross_pers "Income (personal)"

				matrix drop T
						mat T = J(2,6,.)
						ttest gender, by (treat) welch
						mat T[2,1] = r(mu_1)
						mat T[2,2] = r(sd_1)
						mat T[2,3] = r(mu_2)
						mat T[2,4] = r(sd_2)
						mat T[2,5] = r(mu_1) - r(mu_2)
						mat T[2,6] = r(p)								
						mat rownames T = gender
						
						frmttable using tableSI3_3.rtf, statmat(T) varlabels append ///
						title("Table OA.3.2.1: Covariate balance checks, Studies 1 and 2") ///
						rtitles("Study 2" \ "Gender") ///
						ctitle("", Mean (Control), Standard Deviation (Control), Mean (Treatment), Standard Deviation (Treatment), Difference-of-Means, p-value) sdec(2,2,2,2,2,3)
					
					quietly foreach x of varlist age education_age education_level socialgrade gross_pers gross_house {
						mat T = J(1,6,.)
						ttest `x', by (treat) welch
						mat T[1,1] = r(mu_1)
						mat T[1,2] = r(sd_1)
						mat T[1,3] = r(mu_2)
						mat T[1,4] = r(sd_2)
						mat T[1,5] = r(mu_1) - r(mu_2)
						mat T[1,6] = r(p)								
						mat rownames T = `x' 
						
						frmttable using tableSI3_3.rtf, statmat(T) varlabels append ///
						title("Table OA.3.2.1: Covariate balance checks, Studies 1 and 2") ///
						ctitle("", Mean (Control), Standard Deviation (Control), Mean (Treatment), Standard Deviation (Treatment), Difference-of-Means, p-value) sdec(2,2,2,2,2,3)
					}		

	***********************************************************
	**Table OA.3.2.2: Covariate balance checks, Studies 3 & 4**
	***********************************************************
					
			
		**Study 3 - varying partisanship (12 February 2017)**
				use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 3_Feb 2017_Partisanship.dta", clear
				cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

				lab var gender "Gender"
				lab var age "Age"
				lab var education_age "Education (years)"
				lab var education_level "Education (level)"
				lab var social_grade "Social grade group"
				lab var household "Income (household)"
				lab var personal_i "Income (personal)"

				*control group 1 & treatment group 1*
					matrix drop T
						mat T = J(2,6,.)
						ttest gender if treat_1==1 | control_1==1, by (treat_1) welch
						mat T[2,1] = r(mu_1)
						mat T[2,2] = r(sd_1)
						mat T[2,3] = r(mu_2)
						mat T[2,4] = r(sd_2)
						mat T[2,5] = r(mu_1) - r(mu_2)
						mat T[2,6] = r(p)								
						mat rownames T = gender
						
						frmttable using tableSI3_4.rtf, statmat(T) varlabels replace ///
						title("Table SI 3.4: Covariate balance checks, studies 3 and 4") ///
						rtitles("Study 3 (control 1 & treatment 1)" \ "Gender") ///
						ctitle("", Mean (Control), Standard Deviation (Control), Mean (Treatment), Standard Deviation (Treatment), Difference-of-Means, p-value) sdec(2,2,2,2,2,3)

					qui foreach x of varlist age education_age education_level social_grade personal_income household_income{
						mat T = J(1,6,.)
						ttest `x' if treat_1 | control_1, by (treat_1) welch
						mat T[1,1] = r(mu_1)
						mat T[1,2] = r(sd_1)
						mat T[1,3] = r(mu_2)
						mat T[1,4] = r(sd_2)
						mat T[1,5] = r(mu_1) - r(mu_2)
						mat T[1,6] = r(p)								
						mat rownames T = `x' 
						
						frmttable using tableSI3_4.rtf, statmat(T) varlabels append ///
						title("Table SI 3.4: Covariate balance checks, studies 3 and 4") ///
						ctitle("", Mean (Control), Standard Deviation (Control), Mean (Treatment), Standard Deviation (Treatment), Difference-of-Means, p-value) sdec(2,2,2,2,2,3)
						
					}		
					
			*control group 2 & treatment group 2*
					matrix drop T
						mat T = J(2,6,.)
						ttest gender if treat_2==1 | control_2==1, by (treat_2) welch
						mat T[2,1] = r(mu_1)
						mat T[2,2] = r(sd_1)
						mat T[2,3] = r(mu_2)
						mat T[2,4] = r(sd_2)
						mat T[2,5] = r(mu_1) - r(mu_2)
						mat T[2,6] = r(p)								
						mat rownames T = gender
						
						frmttable using tableSI3_4.rtf, statmat(T) varlabels append ///
						rtitles("Study 3 (control 2 & treatment 2)" \ "Gender") ///
						ctitle("", Mean (Control), Standard Deviation (Control), Mean (Treatment), Standard Deviation (Treatment), Difference-of-Means, p-value) sdec(2,2,2,2,2,3)

					foreach x of varlist age education_age education_level social_grade personal_income household_income {
						mat T = J(1,6,.)
						ttest `x' if treat_2 | control_2, by (treat_2) welch
						mat T[1,1] = r(mu_1)
						mat T[1,2] = r(sd_1)
						mat T[1,3] = r(mu_2)
						mat T[1,4] = r(sd_2)
						mat T[1,5] = r(mu_1) - r(mu_2)
						mat T[1,6] = r(p)								
						mat rownames T = `x' 
						
						frmttable using tableSI3_4.rtf, statmat(T) varlabels append ///
						ctitle("", Mean (Control), Standard Deviation (Control), Mean (Treatment), Standard Deviation (Treatment), Difference-of-Means, p-value) sdec(2,2,2,2,2,3)
					}
					
		*Study 4 - varying economic conditions (March 2017)*
				use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 4_Mar 2017_Economy.dta", clear
				cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

				lab var gender "Gender"
				lab var age "Age"
				lab var education_age "Education (years)"
				lab var education_level "Education (level)"
				lab var socialgrade "Social grade group"
				lab var household_income "Income (household)"
				lab var household_personal "Income (personal)"
							
			*control group 1 & treatment group 1*
					matrix drop T
						mat T = J(2,6,.)
						ttest gender if treat_1==1 | control_2==1, by (treat_1) welch
						mat T[2,1] = r(mu_1)
						mat T[2,2] = r(sd_1)
						mat T[2,3] = r(mu_2)
						mat T[2,4] = r(sd_2)
						mat T[2,5] = r(mu_1) - r(mu_2)
						mat T[2,6] = r(p)								
						
						frmttable using tableSI3_4.rtf, statmat(T) varlabels append ///
						rtitles("Study 4 (control 1 & treatment 1)" \ "Gender") ///
						ctitle("", Mean (Control), Standard Deviation (Control), Mean (Treatment), Standard Deviation (Treatment), Difference-of-Means, p-value) sdec(2,2,2,2,2,3)

					foreach x of varlist age education_age education_level socialgrade household_personal household_income{
						mat T = J(1,6,.)
						ttest `x' if treat_1 | control_1, by (treat_1) welch
						mat T[1,1] = r(mu_1)
						mat T[1,2] = r(sd_1)
						mat T[1,3] = r(mu_2)
						mat T[1,4] = r(sd_2)
						mat T[1,5] = r(mu_1) - r(mu_2)
						mat T[1,6] = r(p)								
						mat rownames T = `x' 
						
						frmttable using tableSI3_4.rtf, statmat(T) varlabels append ///
						ctitle("", Mean (Control), Standard Deviation (Control), Mean (Treatment), Standard Deviation (Treatment), Difference-of-Means, p-value) sdec(2,2,2,2,2,3)
					}		

			*control group 2 & treatment group 2*
					matrix drop T
						mat T = J(2,6,.)
						ttest gender if treat_2 | control_2, by (treat_2) welch
						mat T[2,1] = r(mu_1)
						mat T[2,2] = r(sd_1)
						mat T[2,3] = r(mu_2)
						mat T[2,4] = r(sd_2)
						mat T[2,5] = r(mu_1) - r(mu_2)
						mat T[2,6] = r(p)								
						
						frmttable using tableSI3_4.rtf, statmat(T) varlabels append ///
						rtitles("Study 4 (control 2 & treatment 2)" \ "Gender") ///
						ctitle("", Mean (Control), Standard Deviation (Control), Mean (Treatment), Standard Deviation (Treatment), Difference-of-Means, p-value) sdec(2,2,2,2,2,3)


					foreach x of varlist age education_age education_level socialgrade household_personal household_income {
						mat T = J(1,6,.)
						ttest `x' if treat_2 | control_2, by (treat_2) welch
						mat T[1,1] = r(mu_1)
						mat T[1,2] = r(sd_1)
						mat T[1,3] = r(mu_2)
						mat T[1,4] = r(sd_2)
						mat T[1,5] = r(mu_1) - r(mu_2)
						mat T[1,6] = r(p)								
						mat rownames T = `x' 
						
						frmttable using tableSI3_4.rtf, statmat(T) varlabels append ///
						ctitle("", Mean (Control), Standard Deviation (Control), Mean (Treatment), Standard Deviation (Treatment), Difference-of-Means, p-value) sdec(2,2,2,2,2,3)
						}		
					
						
*******************************
**OA.3.3: Manipulation checks**
*******************************

	***********************************************************
	**Table OA.3.3.1: Manipulation checks, Studies 2, 3 and 4**
	***********************************************************
	
		**Study 2 (Nov 2015)**
				use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 2_Nov 2015.dta", clear	
				cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"


			*Study 2: Manipulation check*
				lab var mc_elect "Election timing"
				lab var mc_unemp "Unemployment"
				lab var mc_econ "Growth"

				matrix drop T
						mat T = J(2,6,.)
						ttest mc_elect, by (treat) welch
						mat T[2,1] = r(N_1)
						mat T[2,2] = r(mu_1)
						mat T[2,3] = r(N_2)
						mat T[2,4] = r(mu_2)
						mat T[2,5] = r(mu_1) - r(mu_2)
						mat T[2,6] = r(p)								
						mat rownames T = mc_elect
						
						frmttable using tableSI3_5.rtf, statmat(T) varlabels replace ///
						title("Table OA.3.3.1: Manipulation checks, Studies 2, 3 and 4") ///
						rtitles("Study 2" \ "Election timing") ///
						ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-Means, p-value) sdec(2,2,2,2,2,3)


					foreach x of varlist mc_econ mc_unemp	{
					quietly ttest `x', by (treat) welch
					mat T = J(1,6,.)
						mat T[1,1] = r(N_1)
						mat T[1,2] = r(mu_1)
						mat T[1,3] = r(N_2)
						mat T[1,4] = r(mu_2)
						mat T[1,5] = r(mu_1) - r(mu_2)
						mat T[1,6] = r(p)

						mat rownames T = `x' 
						
						frmttable using tableSI3_5.rtf, statmat(T) varlabels append ///
						title("Table OA.3.3.1: Manipulation checks, Studies 2, 3 and 4") ///
						ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-Means, p-value) sdec(2,2,2,2,2,3)
				}
		
		**Study 3 - varying partisanship (February 2017)**
				use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 3_Feb 2017_Partisanship.dta", clear
				cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

				lab var att_re "Election timing"
				lab var att_ypty "Preferred party"
				lab var att_econ "Growth"

				*************************************
				*control group 1 & treatment group 1*
				*************************************	
					matrix drop T
					quietly ttest att_re if control_1 | treat_1, by (treat_1) welch
					mat T = J(3,6,.)
						mat T[3,1] = r(N_1)
						mat T[3,2] = r(mu_1)
						mat T[3,3] = r(N_2)
						mat T[3,4] = r(mu_2)
						mat T[3,5] = r(mu_1) - r(mu_2)
						mat T[3,6] = r(p)

						mat rownames T = att_re
						
						frmttable using tableSI3_5.doc, statmat(T) varlabels append ///
						rtitles("Study 3" \ "Control 1 & Treatment 1" \ "Election timing") ///
						ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)

					foreach x of varlist att_ypty att_econ	{
					quietly ttest `x' if control_1 | treat_1, by (treat_1) welch
					mat T = J(1,6,.)
						mat T[1,1] = r(N_1)
						mat T[1,2] = r(mu_1)
						mat T[1,3] = r(N_2)
						mat T[1,4] = r(mu_2)
						mat T[1,5] = r(mu_1) - r(mu_2)
						mat T[1,6] = r(p)

						mat rownames T = `x' 
						
						frmttable using tableSI3_5.doc, statmat(T) varlabels append ///
						ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)
				}
				
				*************************************
				*control group 2 & treatment group 2*
				*************************************	
					matrix drop T
					quietly ttest att_re if control_2 | treat_2, by (treat_2) welch
					mat T = J(2,6,.)
						mat T[2,1] = r(N_1)
						mat T[2,2] = r(mu_1)
						mat T[2,3] = r(N_2)
						mat T[2,4] = r(mu_2)
						mat T[2,5] = r(mu_1) - r(mu_2)
						mat T[2,6] = r(p)

						mat rownames T = att_re
						
						frmttable using tableSI3_5.doc, statmat(T) varlabels append ///
						rtitles("Control 2 & Treatment 2" \ "Election timing") ///
						ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)

					foreach x of varlist att_ypty att_econ	{
					quietly ttest `x' if control_2 | treat_2, by (treat_2) welch
					mat T = J(1,6,.)
						mat T[1,1] = r(N_1)
						mat T[1,2] = r(mu_1)
						mat T[1,3] = r(N_2)
						mat T[1,4] = r(mu_2)
						mat T[1,5] = r(mu_1) - r(mu_2)
						mat T[1,6] = r(p)

						mat rownames T = `x' 
						
						frmttable using tableSI3_5.doc, statmat(T) varlabels append ///
						ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)
				}		

		*Study 4 - varying economic conditions (15 March 2017)*
				use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 4_Mar 2017_Economy.dta", clear
				cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

				lab var att_re "Election timing"
				lab var att_unemp "Unemployment"
				lab var att_econ "Growth"

				*******************************************************
				*Stong Economy condition - control 1 and treatment 1**
				*******************************************************	
					matrix drop T
					quietly ttest att_re if control_1 | treat_1, by (treat_1) welch
					mat T = J(3,6,.)
						mat T[3,1] = r(N_1)
						mat T[3,2] = r(mu_1)
						mat T[3,3] = r(N_2)
						mat T[3,4] = r(mu_2)
						mat T[3,5] = r(mu_1) - r(mu_2)
						mat T[3,6] = r(p)

						mat rownames T = att_re
						
						frmttable using tableSI3_5.doc, statmat(T) varlabels append ///
						rtitles("Study 4" \ "Control 1 & Treatment 1" \ "Election timing") ///
						ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)

					foreach x of varlist att_unemp att_econ	{
					quietly ttest `x' if control_1 | treat_1, by (treat_1) welch
					mat T = J(1,6,.)
						mat T[1,1] = r(N_1)
						mat T[1,2] = r(mu_1)
						mat T[1,3] = r(N_2)
						mat T[1,4] = r(mu_2)
						mat T[1,5] = r(mu_1) - r(mu_2)
						mat T[1,6] = r(p)

						mat rownames T = `x' 
						
						frmttable using tableSI3_5.doc, statmat(T) varlabels append ///
						ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)
				}
				
				*****************************************************
				*Mixed Economy condition - control 2 and treatment 2*
				*****************************************************	
					matrix drop T
					quietly ttest att_re if control_2 | treat_2, by (treat_2) welch
					mat T = J(2,6,.)
						mat T[2,1] = r(N_1)
						mat T[2,2] = r(mu_1)
						mat T[2,3] = r(N_2)
						mat T[2,4] = r(mu_2)
						mat T[2,5] = r(mu_1) - r(mu_2)
						mat T[2,6] = r(p)

						mat rownames T = att_re
						
						frmttable using tableSI3_5.doc, statmat(T) varlabels append ///
						rtitles("Control 2 & Treatment 2" \ "Election timing") ///
						ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)


					foreach x of varlist att_unemp att_econ	{
					quietly ttest `x' if control_2 | treat_2, by (treat_2) welch
					mat T = J(1,6,.)
						mat T[1,1] = r(N_1)
						mat T[1,2] = r(mu_1)
						mat T[1,3] = r(N_2)
						mat T[1,4] = r(mu_2)
						mat T[1,5] = r(mu_1) - r(mu_2)
						mat T[1,6] = r(p)

						mat rownames T = `x' 
						
						frmttable using tableSI3_5.doc, statmat(T) varlabels append ///
						ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)
				}
	******************************************************************
	**Table OA.3.3.2: Additional manipulation checks, Studies 3 and 4**
	******************************************************************

			**Study 3 - varying partisanship (February 2017)**
				use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 3_Feb 2017_Partisanship.dta", clear
				cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

					matrix drop T
					mat T = J(3,6,.)
					ttest manip if treat_1 | control_1, by (treat_1) unequal welch
						mat T[3,1] = r(N_1)
						mat T[3,2] = r(mu_1)
						mat T[3,3] = r(N_2)
						mat T[3,4] = r(mu_2)
						mat T[3,5] = r(mu_1) - r(mu_2)
						mat T[3,6] = r(p)

						mat rownames T = vote 
						
						frmttable using table3_6.doc, statmat(T) varlabels replace ///
						rtitle("Study 3" \ "Control 1 & Treatment 1" \ "Election called for political benefit") ///
						title("Table OA.3.3.2: Additional manipulation checks, Studies 3 and 4") ///
						ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)

					matrix drop T
					mat T = J(2,6,.)
					ttest manip if treat_2 | control_2, by (treat_2) unequal welch
						mat T[2,1] = r(N_1)
						mat T[2,2] = r(mu_1)
						mat T[2,3] = r(N_2)
						mat T[2,4] = r(mu_2)
						mat T[2,5] = r(mu_1) - r(mu_2)
						mat T[2,6] = r(p)

						mat rownames T = vote 
						
						frmttable using table3_6.doc, statmat(T) varlabels append ///
						rtitle("Control 2 & Treatment 2" \ "Election called for political benefit") ///
						ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)

			*Study 4 - varying economic conditions (March 2017)*
				use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 4_Mar 2017_Economy.dta", clear
				cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

					matrix drop T
					mat T = J(3,6,.)
					ttest manip if treat_1 | control_1, by (treat_1) unequal welch
						mat T[3,1] = r(N_1)
						mat T[3,2] = r(mu_1)
						mat T[3,3] = r(N_2)
						mat T[3,4] = r(mu_2)
						mat T[3,5] = r(mu_1) - r(mu_2)
						mat T[3,6] = r(p)

						mat rownames T = vote 
						
						frmttable using table3_6.doc, statmat(T) varlabels append ///
						rtitle("Study 4" \ "Control 1 & Treatment 1" \ "Election called for political benefit") ///
						ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)

					matrix drop T
					mat T = J(2,6,.)
					ttest manip if treat_2 | control_2, by (treat_2) unequal welch
						mat T[2,1] = r(N_1)
						mat T[2,2] = r(mu_1)
						mat T[2,3] = r(N_2)
						mat T[2,4] = r(mu_2)
						mat T[2,5] = r(mu_1) - r(mu_2)
						mat T[2,6] = r(p)

						mat rownames T = vote 
						
						frmttable using table3_6.doc, statmat(T) varlabels append ///
						rtitle("Control 2 & Treatment 2" \ "Election called for political benefit") ///
						ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)

				
*****************************************
***OA.4: Results of Additional analyses**
*****************************************

				
	*********************************************************************************************
	*Table OA.4.1.1: The effect of opportunistic election timing on vote intention (Studies 1-3)*
	*********************************************************************************************

		**Study 1 (Feb 2015)**
			use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 1_Feb 2015.dta", clear
			cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

				mat T = J(1,6,.)
				ttest vote if vote!=6, by(treat_early) unequal welch
					mat T[1,1] = r(N_1)
					mat T[1,2] = r(mu_1)
					mat T[1,3] = r(N_2)
					mat T[1,4] = r(mu_2)
					mat T[1,5] = r(mu_2) - r(mu_1)
					mat T[1,6] = r(p)

					mat rownames T = vote_experiment1 
					
					frmttable using tableSI4_1.doc, statmat(T) varlabels replace ///
					rtitle("Vote intention (Study 1)") ///
					title(Table OA.4.1.1: The effect of opportunistic election timing on vote intention (Studies 1-3)) ///
					ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3) ///
					posttext(Note: Response scale: 5 = Much more likely, 4 = A little more likely, 3 = Neither more nor less likely, 2 = A little less likely, 1 = Much less likely.) 

		**Study 2 (Nov 2015)**
			use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 2_Nov 2015.dta", clear	
			cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

				matrix drop T
				mat T = J(1,6,.)
				ttest vote if vote!=6, by (treat) unequal welch
					mat T[1,1] = r(N_1)
					mat T[1,2] = r(mu_1)
					mat T[1,3] = r(N_2)
					mat T[1,4] = r(mu_2)
					mat T[1,5] = r(mu_2) - r(mu_1)
					mat T[1,6] = r(p)

					mat rownames T = vote_experiment2 
					
					frmttable using tableSI4_1.doc, statmat(T) varlabels append ///
					rtitle("Vote intention (Study 2)") ///
					ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)

		**Study 3 - varying partisanship (February 2017)**
			use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 3_Feb 2017_Partisanship.dta", clear
			cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

					label define treat_label 0 "Control" 1 "Treatment", modify
					label values treat treat_label

				matrix drop T
				mat T = J(1,6,.)
				ttest vote if vote!=6, by (treat) unequal welch
					mat T[1,1] = r(N_1)
					mat T[1,2] = r(mu_1)
					mat T[1,3] = r(N_2)
					mat T[1,4] = r(mu_2)
					mat T[1,5] = r(mu_2) - r(mu_1)
					mat T[1,6] = r(p)

					mat rownames T = vote_experiment2 
					
					frmttable using tableSI4_1.doc, statmat(T) varlabels append ///
					rtitle("Vote intention (Study 3)") ///
					ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)


	***********************************************************************************************************
	**Table OA.4.1.2: The effect of opportunistic election timing on vote intention by partisanship (Study 3)**
	***********************************************************************************************************
	
		**Study 3 - varying partisanship**
			use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 3_Feb 2017_Partisanship.dta", clear
			cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

			*Party you support governs*
				matrix drop T
				mat T = J(2,6,.)
				ttest vote if (treat_1 | control_1) & vote!=6, by (treat_1) unequal welch
					mat T[2,1] = r(N_1)
					mat T[2,2] = r(mu_1)
					mat T[2,3] = r(N_2)
					mat T[2,4] = r(mu_2)
					mat T[2,5] = r(mu_2) - r(mu_1)
					mat T[2,6] = r(p)

					mat rownames T = vote 
					
					frmttable using tableSI4_2.doc, statmat(T) varlabels replace ///
					rtitle("Party you support governs" \ "Vote intention") ///
					title("Table OA.4.1.2: The effect of opportunistic election timing on vote intention by partisanship (Study 3)") ///
					ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3) ///
					posttext(Note: Response scale: 5 = Much more likely, 4 = A little more likely, 3 = Neither more nor less likely, 2 = A little less likely, 1 = Much less likely.) 

				*Party you support does not govern*
				matrix drop T
				mat T = J(2,6,.)
				ttest vote if (treat_2 | control_2) & vote!=6, by (treat_2) unequal welch
					mat T[2,1] = r(N_1)
					mat T[2,2] = r(mu_1)
					mat T[2,3] = r(N_2)
					mat T[2,4] = r(mu_2)
					mat T[2,5] = r(mu_2) - r(mu_1)
					mat T[2,6] = r(p)

					mat rownames T = vote 
					
					frmttable using tableSI4_2.doc, statmat(T) varlabels append ///
					rtitle("Party you support does not govern" \ "Vote intention") ///
					title("Table SI 4.2: Treatment effect on vote intention by partisanship") ///
					ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)
			
		
	**************************************************************************************************************************
	**Figure OA.4.1.1: The effect of opportunistic election timing on vote intention, varying economic performance (Study 4)**
	**************************************************************************************************************************

		*Study 4 - varying economic conditions (March 2017)*
			use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 4_Mar 2017_Economy.dta", clear
			cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

			**(Strong economy condition)**
		
					label define treat_1_label 0 "Control Group" 1 "Treatment Group", modify
					label values treat_1 treat_1_label
					
					anova vote treat_1 if vote!=6 & (treat_1 | control_1)
					margins treat_1
					marginsplot, xdimension(treat_1) xlabel(, nogrid) xti("") yti("Vote intention" "(less likely - more likely)") ///
					title((1) Strong Economy) recast(scatter) scale(1.2) ///
					xscale(range(-0.3 1.3)) scheme(s1mono) name(f1s1, replace)

			**(Mixed economy condition)**

					label define treat_2_label 0 "Control Group" 1 "Treatment Group", modify
					label values treat_2 treat_2_label
					
					anova vote treat_2 if vote!=6 & (treat_2 | control_2)
					margins treat_2
					marginsplot, xdimension(treat_2) xlabel(, nogrid) xti("") yti("Vote intention" "(less likely - more likely)") ///
					title((2) Mixed Economy) recast(scatter) scale(1.2) ///
					xscale(range(-0.3 1.3)) scheme(s1mono) name(f1s2, replace)
					
			graph combine f1s1 f1s2, ycommon

				******************************************
				**Wilcoxon rank-sum (Mann-Whitney) tests**
				******************************************
							ranksum vote if vote!=6 & (treat_1 | control_1), by(treat_1)
							ranksum vote if vote!=6 & (treat_2 | control_2), by(treat_2)

			
	*****************************************************************************************************************
	**Table OA.4.1.3: The effect of opportunistic election timing on vote intention by economic condition (Study 4)**
	*****************************************************************************************************************
		
		*Study 4 - varying economic conditions (March 2017)*
			use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 4_Mar 2017_Economy.dta", clear
			cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

				matrix drop T
				mat T = J(2,6,.)
				ttest vote if treat_1 | control_1, by (treat_1) unequal welch
					mat T[2,1] = r(N_1)
					mat T[2,2] = r(mu_1)
					mat T[2,3] = r(N_2)
					mat T[2,4] = r(mu_2)
					mat T[2,5] = r(mu_2) - r(mu_1)
					mat T[2,6] = r(p)

					mat rownames T = vote 
					
					frmttable using tableSI4_3.doc, statmat(T) varlabels replace ///
					rtitle("Strong economy" \ "Vote intention") ///
					title("Table OA.4.1.3: The effect of opportunistic election timing on vote intention by economic condition (Study 4)") ///
					ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)

				matrix drop T
				mat T = J(2,6,.)
				ttest vote if treat_2 | control_2, by (treat_2) unequal welch
					mat T[2,1] = r(N_1)
					mat T[2,2] = r(mu_1)
					mat T[2,3] = r(N_2)
					mat T[2,4] = r(mu_2)
					mat T[2,5] = r(mu_2) - r(mu_1)
					mat T[2,6] = r(p)

					mat rownames T = vote 
					
					frmttable using tableSI4_3.doc, statmat(T) varlabels append ///
					rtitle("Mixed economy" \ "Vote intention") ///
					title("Table OA.4.1.3: The effect of opportunistic election timing on vote intention by economic condition (Study 4)") ///
					ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)

					
******************************************************
**OA.4.2: What produces the negative voter reaction?**
******************************************************					
					
	******************************************************************************************************************************
	**Table OA.4.2.1: The effect of opportunistic election timing on competence evaluations and anticipated economic performance**
	******************************************************************************************************************************

		**Study 2 (Nov 2015)**
			use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 2_Nov 2015.dta", clear	
			cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"
				
				matrix drop T
				mat T = J(2,6,.)
				ttest eval_comp if eval_comp!=6, by (treat) unequal welch
					mat T[2,1] = r(N_1)
					mat T[2,2] = r(mu_1)
					mat T[2,3] = r(N_2)
					mat T[2,4] = r(mu_2)
					mat T[2,5] = r(mu_2) - r(mu_1)
					mat T[2,6] = r(p)

					mat rownames T = eval_comp 
					
					frmttable using tableSI4_4.doc, statmat(T) varlabels replace ///
					rtitle("Competence evaluations" \ "Study 2") ///
					title("Table OA.4.2.1: The effect of opportunistic election timing on competence evaluations and anticipated economic performance") ///
					ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)

		**Study 3 - varying partisanship (12 February 2017)**
			use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 3_Feb 2017_Partisanship.dta", clear
			cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

					label define treat_label 0 "Control" 1 "Treatment", modify
					label values treat treat_label

				matrix drop T
				mat T = J(1,6,.)
				ttest comp if comp!=6, by (treat) unequal welch
					mat T[1,1] = r(N_1)
					mat T[1,2] = r(mu_1)
					mat T[1,3] = r(N_2)
					mat T[1,4] = r(mu_2)
					mat T[1,5] = r(mu_2) - r(mu_1)
					mat T[1,6] = r(p)

					mat rownames T = comp 
					
					frmttable using tableSI4_4.doc, statmat(T) varlabels append ///
					rtitle("Study 3") ///
					ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)

		**Study 2 (Nov 2015)**
			use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 2_Nov 2015.dta", clear	
			cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"
				
				mat T = J(2,6,.)
				ttest econ_exp if econ_exp!=6, by (treat) unequal welch
					mat T[2,1] = r(N_1)
					mat T[2,2] = r(mu_1)
					mat T[2,3] = r(N_2)
					mat T[2,4] = r(mu_2)
					mat T[2,5] = r(mu_2) - r(mu_1)
					mat T[2,6] = r(p)

					mat rownames T = econ_exp 
					
					frmttable using tableSI4_4.doc, statmat(T) varlabels append ///
					rtitle("Anticipated economic performance" \ "Study 2") ///
					ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)

		**Study 3 - varying partisanship**
			use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 3_Feb 2017_Partisanship.dta", clear
			cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

					label define treat_label 0 "Control" 1 "Treatment", modify
					label values treat treat_label

				matrix drop T
				mat T = J(1,6,.)
				ttest eexp if eexp!=6, by (treat) unequal welch
					mat T[1,1] = r(N_1)
					mat T[1,2] = r(mu_1)
					mat T[1,3] = r(N_2)
					mat T[1,4] = r(mu_2)
					mat T[1,5] = r(mu_2) - r(mu_1)
					mat T[1,6] = r(p)

					mat rownames T = eexp 
					
					frmttable using tableSI4_4.doc, statmat(T) varlabels append ///
					rtitle("Study 3") ///
					ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)


	**************************************************************************************************************************************************************
	**Table OA.4.2.2: The effect of opportunistic election timing on competence evaluations and anticipated economic performance, varying partisanship (Study 3)**
	**************************************************************************************************************************************************************

		**Study 3 - varying partisanship (February 2017)**
			use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 3_Feb 2017_Partisanship.dta", clear
			cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

			*Party you support governs*
				matrix drop T
				mat T = J(2,6,.)
				ttest comp if (treat_1 | control_1) & comp!=6, by (treat_1) unequal welch
					mat T[2,1] = r(N_1)
					mat T[2,2] = r(mu_1)
					mat T[2,3] = r(N_2)
					mat T[2,4] = r(mu_2)
					mat T[2,5] = r(mu_2) - r(mu_1)
					mat T[2,6] = r(p)

					mat rownames T = vote 
					
					frmttable using tableSI4_5.doc, statmat(T) varlabels replace ///
					rtitle("Party you support governs" \ "Competence evaluation") ///
					title("Table OA.4.2.2: The effect of opportunistic election timing on competence evaluations and anticipated economic performance, varying partisanship (Study 3)") ///
					ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)

				matrix drop T
				mat T = J(1,6,.)
				ttest eexp if (treat_1 | control_1) & eexp!=6, by (treat_1) unequal welch
					mat T[1,1] = r(N_1)
					mat T[1,2] = r(mu_1)
					mat T[1,3] = r(N_2)
					mat T[1,4] = r(mu_2)
					mat T[1,5] = r(mu_2) - r(mu_1)
					mat T[1,6] = r(p)

					mat rownames T = vote 
					
					frmttable using tableSI4_5.doc, statmat(T) varlabels append ///
					rtitle("Anticipated economic performance") ///
					ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)
					
				*Party you support does not govern*
				matrix drop T
				mat T = J(2,6,.)
				ttest comp if (treat_2 | control_2) & comp!=6, by (treat_2) unequal welch
					mat T[2,1] = r(N_1)
					mat T[2,2] = r(mu_1)
					mat T[2,3] = r(N_2)
					mat T[2,4] = r(mu_2)
					mat T[2,5] = r(mu_2) - r(mu_1)
					mat T[2,6] = r(p)

					mat rownames T = vote 
					
					frmttable using tableSI4_5.doc, statmat(T) varlabels append ///
					rtitle("Party you support does not govern" \ "Competence evaluation") ///
					ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)

				matrix drop T
				mat T = J(1,6,.)
				ttest eexp if (treat_2 | control_2) & eexp!=6, by (treat_2) unequal welch
					mat T[1,1] = r(N_1)
					mat T[1,2] = r(mu_1)
					mat T[1,3] = r(N_2)
					mat T[1,4] = r(mu_2)
					mat T[1,5] = r(mu_2) - r(mu_1)
					mat T[1,6] = r(p)

					frmttable using tableSI4_5.doc, statmat(T) varlabels append ///
					rtitle("Anticipated economic performance") ///
					ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)

				******************************************
				**Wilcoxon rank-sum (Mann-Whitney) tests**
				******************************************
							ranksum eexp if eexp!=6 & (treat_1 | control_1), by(treat_1)
							ranksum eexp if eexp!=6 & (treat_2 | control_2), by(treat_2)
							ranksum comp if comp!=6 & (treat_1 | control_1), by(treat_1)
							ranksum comp if comp!=6 & (treat_2 | control_2), by(treat_2)

	*******************************************************************************************************************************
	**Table OA.4.2.3: The effect of opportunistic election timing on procedural fairness concerns (Study 3)**
	*******************************************************************************************************************************

		**Study 3 - varying partisanship (February 2017)**
			use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 3_Feb 2017_Partisanship.dta", clear
			cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

			*Fairness to voters*
				matrix drop T
				mat T = J(2,6,.)
				ttest fairv if fairv!=6, by (treat) unequal welch
					mat T[2,1] = r(N_1)
					mat T[2,2] = r(mu_1)
					mat T[2,3] = r(N_2)
					mat T[2,4] = r(mu_2)
					mat T[2,5] = r(mu_2) - r(mu_1)
					mat T[2,6] = r(p)

					mat rownames T = vote 
					
					frmttable using tableSI4_6.doc, statmat(T) varlabels replace ///
					rtitle("Fairness to voters") ///
					title("Table OA.4.2.3: The effect of opportunistic election timing on procedural fairness concerns (Study 3)") ///
					ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)

			*Fairness to other parties*		
				matrix drop T
				mat T = J(1,6,.)
				ttest fairp if fairp!=6, by (treat) unequal welch
					mat T[1,1] = r(N_1)
					mat T[1,2] = r(mu_1)
					mat T[1,3] = r(N_2)
					mat T[1,4] = r(mu_2)
					mat T[1,5] = r(mu_2) - r(mu_1)
					mat T[1,6] = r(p)

					mat rownames T = vote 
					
					frmttable using tableSI4_6.doc, statmat(T) varlabels append ///
					rtitle("Fairness to other parties") ///
					ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)
					

	*******************************************************************************************************************************
	**Table OA.4.2.4: The effect of opportunistic election timing on procedural fairness concerns, varying partisanship (Study 3)**
	*******************************************************************************************************************************

		**Study 3 - varying partisanship (February 2017)**
			use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 3_Feb 2017_Partisanship.dta", clear
			cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

			*Party you support governs*
				matrix drop T
				mat T = J(2,6,.)
				ttest fairv if (treat_1 | control_1) & fairv!=6, by (treat_1) unequal welch
					mat T[2,1] = r(N_1)
					mat T[2,2] = r(mu_1)
					mat T[2,3] = r(N_2)
					mat T[2,4] = r(mu_2)
					mat T[2,5] = r(mu_2) - r(mu_1)
					mat T[2,6] = r(p)

					mat rownames T = vote 
					
					frmttable using tableSI4_7.doc, statmat(T) varlabels replace ///
					rtitle("Party you support governs" \ "Fairness to voters") ///
					title("Table OA.4.2.4: The effect of opportunistic election timing on procedural fairness concerns, varying partisanship (Study 3)") ///
					ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)

				matrix drop T
				mat T = J(1,6,.)
				ttest fairp if (treat_1 | control_1) & fairp!=6, by (treat_1) unequal welch
					mat T[1,1] = r(N_1)
					mat T[1,2] = r(mu_1)
					mat T[1,3] = r(N_2)
					mat T[1,4] = r(mu_2)
					mat T[1,5] = r(mu_2) - r(mu_1)
					mat T[1,6] = r(p)

					mat rownames T = vote 
					
					frmttable using tableSI4_7.doc, statmat(T) varlabels append ///
					rtitle("Fairness to other parties") ///
					ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)
					
				*Party you support does not govern*
				matrix drop T
				mat T = J(2,6,.)
				ttest fairv if (treat_2 | control_2) & fairv!=6, by (treat_2) unequal welch
					mat T[2,1] = r(N_1)
					mat T[2,2] = r(mu_1)
					mat T[2,3] = r(N_2)
					mat T[2,4] = r(mu_2)
					mat T[2,5] = r(mu_2) - r(mu_1)
					mat T[2,6] = r(p)

					mat rownames T = vote 
					
					frmttable using tableSI4_7.doc, statmat(T) varlabels append ///
					rtitle("Party you support does not govern" \ "Fairness to voters") ///
					ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)

				matrix drop T
				mat T = J(1,6,.)
				ttest fairp if (treat_2 | control_2) & fairp!=6, by (treat_2) unequal welch
					mat T[1,1] = r(N_1)
					mat T[1,2] = r(mu_1)
					mat T[1,3] = r(N_2)
					mat T[1,4] = r(mu_2)
					mat T[1,5] = r(mu_2) - r(mu_1)
					mat T[1,6] = r(p)

					frmttable using tableSI4_7.doc, statmat(T) varlabels append ///
					rtitle("Fairness to other parties") ///
					ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)

				******************************************
				**Wilcoxon rank-sum (Mann-Whitney) tests**
				******************************************
							ranksum fairv if fairv!=6 & (treat_1 | control_1), by(treat_1)
							ranksum fairp if fairp!=6 & (treat_1 | control_1), by(treat_1)
							ranksum fairv if fairv!=6 & (treat_2 | control_2), by(treat_2)
							ranksum fairp if fairp!=6 & (treat_2 | control_2), by(treat_2)
							
				
****************************************************************
**OA.4.3: Extension of the test of fairness concerns (Study 2)**
****************************************************************

	***********************************************************************************************************
	**Figure OA.4.3.1: The effect of opportunistic election timing on perceived procedural fairness (Study 2)**
	***********************************************************************************************************

		**Study 2 (Nov 2015)**
			use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 2_Nov 2015.dta", clear	
			cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"
				graph set window fontface "Times New Roman"
		
				**Voters**
					label define treat_l 0 "Control Group" 1 "Treatment Group", modify
					label values treat treat_l 
					
					anova fairv treat if fairv!=6
					margins treat
					marginsplot, xdimension(treat) xlabel(, nogrid) xti("") yti("Fairness to voters" "(unfair - fair)") ///
					title(Fairness to voters) recast(scatter) scale(1.2) ///
					yscale(range(2.4 2.6)) xscale(range(-0.3 1.3)) scheme(s1mono) name(f2_1, replace)
					
					/*yscale(range(1 5))
					title(Study 1) subtitle(Economy) scale(1.2) ///
					yscale(range(1 5))  xtick(none) xlabel(none) xti(" ") scheme(sol) name(f4ecs1, replace)
					*/
					
				**Parties**
					anova fairp treat if fairp!=6
					margins treat
					marginsplot, xdimension(treat) xlabel(, nogrid) xti("") yti("Fairness to other parties" "(unfair - fair)") ///
					title(Fairness to other parties) recast(scatter) scale(1.2) ///
					yscale(range(2.4 2.6)) xscale(range(-0.3 1.3)) scheme(s1mono) name(f2_2, replace)

				graph combine f2_1 f2_2, ycommon 

			******************************************
			**Wilcoxon rank-sum (Mann-Whitney) tests**
			******************************************
						ranksum fairv if fairv!=6, by(treat)
						ranksum fairp if fairp!=6, by(treat)
				
******************************************************************************
**OA.4.4: How important is election timing relative to economic performance?**
******************************************************************************

	*******************************************************************************************************************
	**Table OA.4.4.1: The effect of economic performance and opportunitic election timing on vote intention (Study 4)**
	*******************************************************************************************************************

	*Study 4 - varying economic conditions (15 March 2017)*
		use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 4_Mar 2017_Economy.dta", clear
		cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

		*****************************************************
		**Effect of economic performance on vote intention***
		*****************************************************
				label define econ_l 0 "Strong Economy" 1 "Mixed Economy", modify
				label values econ econ_l 
				
			matrix drop T
			mat T = J(2,6,.)
			ttest vote if vote!=6, by (econ) unequal welch
				mat T[2,1] = r(N_1)
				mat T[2,2] = r(mu_1)
				mat T[2,3] = r(N_2)
				mat T[2,4] = r(mu_2)
				mat T[2,5] = r(mu_2) - r(mu_1)
				mat T[2,6] = r(p)

				mat rownames T = vote 
				
				frmttable using tableSI4_6.doc, statmat(T) varlabels replace ///
				title("Table OA.4.4.1: The effect of economic performance and opportunitic election timing on vote intention (Study 4)") ///
				rtitle("Varying economic performance (control = strong economy, treatment = mixed economy)" \ "Vote intention") ///
				ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)
				
	
		*********************************************************************
		**Effect of opportunistic election timing on vote intention**
		*********************************************************************
				label define treat_label 0 "Regular Elect." 1 "Opportunistic Elect.", modify
				label values treat treat_label
				
			matrix drop T
			mat T = J(2,6,.)
			ttest vote if vote!=6, by (treat) unequal welch
				mat T[2,1] = r(N_1)
				mat T[2,2] = r(mu_1)
				mat T[2,3] = r(N_2)
				mat T[2,4] = r(mu_2)
				mat T[2,5] = r(mu_2) - r(mu_1)
				mat T[2,6] = r(p)

				mat rownames T = vote 
				
				frmttable using tableSI4_6.doc, statmat(T) varlabels append ///
				rtitle("Varying election timing (control = regular election, treatment = opportunistic election)" \ "Vote intention") ///
				ctitle("", N, Mean (Control), N, Mean (Treatment), Difference-of-means, "(p-value)") sdec(0,2,0,2,2,3)

*************************************************************************************************
**OA 4.5: The relative importance of election timing in shaping vote choice, observational data**
************************************************************************************************* 				

	**********************************************************************************************
	**Figure OA.4.5.1: The importance of election timing and economic performance to vote choice**
	**********************************************************************************************

		**Study 1 (Feb 2015)**
			use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 1_Feb 2015.dta", clear
			cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

					gen election_timing = 1
					graph set window fontface "Times New Roman"
					meansdplot imp_et election_timing if imp_et!=6, xti(Election timing) yti("Importance" "(not important - important)") ylabel(, nogrid) ///
					title(Study 1) subtitle(Election timing) scale(1.2) yscale(off) xtick(none) xlabel(none) xti(" ") ///
					yscale(range(1 5)) scheme(sol) name(f4ets1, replace)
					
					meansdplot imp_ec election_timing if imp_ec!=6, xti(Economy) yti("Importance" "(not important - important)") ylabel(, nogrid) ///
					title(Study 1) subtitle(Economy) scale(1.2) ///
					yscale(range(1 5))  xtick(none) xlabel(none) xti(" ") scheme(sol) name(f4ecs1, replace)
					drop election_timing
					
					graph combine f4ecs1 f4ets1, imargin(zero) ycommon

					
		**Study 2 (Nov 2015)**
			use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 2_Nov 2015.dta", clear	
			cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"
					gen election_timing = 1
					meansdplot imp_et election_timing if imp_et!=6, xti(Election timing) yti("Importance" "(not important - important)") ylabel(, nogrid) ///
					title(Study 2) subtitle(Election timing) scale(1.2) yscale(off) xtick(none) xlabel(none) xti(" ") ///
					yscale(range(1 5)) scheme(sol) name(f4ets2, replace)
					
					meansdplot imp_ec election_timing if imp_ec!=6, xti(Economy) yti("Importance" "not important - important") ylabel(, nogrid) ///
					title(Study 2) subtitle(Economy) scale(1.2) xtick(none) xlabel(none) xti(" ") ///
					yscale(range(1 5)) scheme(sol) name(f4ecs2, replace)
					drop election_timing
					
					graph combine f4ecs1 f4ets1 f4ecs2 f4ets2, imargin(zero) ycommon

	*****************************************************************************************************************
	**Table OA.4.5.1: The relative importance of election timing in shaping vote choice (difference-of-means tests)**
	*****************************************************************************************************************
		
		**Study 1 (Feb 2015)**
			use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 1_Feb 2015.dta", clear
			cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

			matrix drop T
			ttest imp_et==imp_ec if imp_et!=6 & imp_ec!=6
				mat T = J(2,5,.)
					mat T[2,1] = r(N_1)
					mat T[2,2] = r(mu_1)
					mat T[2,3] = r(mu_2)
					mat T[2,4] = r(mu_1) - r(mu_2)
					mat T[2,5] = r(p)

					mat rownames T = 1_imp_et=imp_ec 
					
					frmttable using  tableSI3.2.doc, statmat(T) varlabels replace ///
					rtitle ("Study 1" \ "Economy") ///
					title("Table OA.4.5.1: The relative importance of election timing in shaping vote choice (difference-of-means tests)") ///
					ctitle("", N, Mean (Election timing), Mean (Alternative issue), Difference-of-means, "(p-value)") sdec(0,2,2,2,3)
					
			lab var imp_pp "Party Policy"
			lab var imp_pl "Party Leaders"
			lab var imp_he "Healthcare"
			lab var imp_im "Immigration"
			foreach x of varlist imp_pp imp_pl imp_he imp_im	{
				quietly ttest imp_et==`x' if imp_et!=6 & `x'!=6
				mat T = J(1,5,.)
					mat T[1,1] = r(N_1)
					mat T[1,2] = r(mu_1)
					mat T[1,3] = r(mu_2)
					mat T[1,4] = r(mu_1) - r(mu_2)
					mat T[1,5] = r(p)

					mat rownames T = `x' 
					
					frmttable using tableSI3.doc, statmat(T) varlabels append ///
					ctitle("", N, Mean (Election timing), Mean (Alternative issue), Difference-of-means, "(p-value)") sdec(0,2,2,2,3)
			}
		**Study 2 (Nov 2015)**
			use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 2_Nov 2015.dta", clear	
			cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"
		
			foreach x of varlist imp_ec {
				quietly ttest imp_et==`x' if imp_et!=6 & `x'!=6 
				mat T = J(2,5,.)
					mat T[2,1] = r(N_1)
					mat T[2,2] = r(mu_1)
					mat T[2,3] = r(mu_2)
					mat T[2,4] = r(mu_1) - r(mu_2)
					mat T[2,5] = r(p)

					mat rownames T = `x' 
					
					frmttable using tableSI3.doc, statmat(T) varlabels append ///
					rtitle ("Study 2" \ "Economy") ///
					ctitle("", N, Mean (Election timing), Mean (Alternative issue), Difference-of-means, "(p-value)") sdec(0,2,2,2,3)
			}	
				
			lab var imp_pp "Party Policy"
			lab var imp_pl "Party Leaders"
			lab var imp_he "Healthcare"
			lab var imp_im "Immigration"
			foreach x of varlist imp_pp imp_pl imp_he imp_im	{
				quietly ttest imp_et==`x' if imp_et!=6 & `x'!=6 
				mat T = J(1,5,.)
					mat T[1,1] = r(N_1)
					mat T[1,2] = r(mu_1)
					mat T[1,3] = r(mu_2)
					mat T[1,4] = r(mu_1) - r(mu_2)
					mat T[1,5] = r(p)

					mat rownames T = `x' 
					
					frmttable using tableSI3.doc, statmat(T) varlabels append ///
					ctitle("", N, Mean (Election timing), Mean (Alternative issue), Difference-of-means, "(p-value)") sdec(0,2,2,2,3)
			}	
				
				
*******************************************
**OA 5: Corroborating regression analyses**
*******************************************			

	******************************************************************************************************************
	**Table OA.5.1: Study 1, the effect of opportunistic election timing on vote intention (OLS regression analysis)**
	******************************************************************************************************************								
									
	**Study 1**
			use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 1_Feb 2015.dta", clear
			cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

		**OLS**
				lab var treat_early "Opportunistic election timing"
				regress vote treat_early if vote!=6
					outreg2 treat_early using tableSI5.1.rtf, replace ///
					label se bdec(3) tdec(3) ctitle("Vote intention") ///
					title ("Table OA.5.1: Study 1, the effect of opportunistic election timing on vote intention (OLS regression analysis)")

	*******************************************************************************************************************************
	**Table OA.5.2: Study 1, the effect of opportunistic election timing on vote intention (ordinal logistic regression analysis)**
	*******************************************************************************************************************************								
					
		**Study 1, ordinal logistic regression analysis**
				lab var treat_early "Opportunistic election timing"
				foreach x of varlist vote  {
					quietly ologit `x' treat_early if `x'!=6
					outreg2 treat_early using tableSI5.2.rtf, replace ///
					label se bdec(3) tdec(3) ctitle("Vote intention") ///
					title ("Table OA.5.2: Study 1, the effect of opportunistic election timing on vote intention (ordinal logistic regression analysis)")
					}

			
	********************************************************************************************************************
	**Table OA.5.3: Study 2, the effect of opportunistic election timing on various outcomes (OLS regression analysis)**
	********************************************************************************************************************								

	**Study 2 (Nov 2015)**
			use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 2_Nov 2015.dta", clear	
			cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

		**OLS regression**	
				lab var vote "Vote intention"
				lab var treat "Opportunistic election timing"
				lab var eval_comp "Competence evaluation"
				lab var econ_exp "Anticipated economic performance"
				foreach x of varlist vote  {
				regress `x' treat if `x'!=6
						outreg2 treat using tableSI5.3.rtf, replace ///
						label se bdec(3) tdec(3) ctitle("Vote intention") ///
						title ("Table OA.5.3: Study 2, the effect of opportunistic election timing on various outcomes (OLS regression analysis)")
				}
				foreach x of varlist eval_comp econ_exp {
				local lab : var label `x'
				regress `x' treat if `x'!=6
						outreg2 treat using tableSI5.3.rtf, append ///
						label se bdec(3) tdec(3) ctitle(`lab') 
						}

						
	*********************************************************************************************************************************
	**Table OA.5.4: Study 2, the effect of opportunistic election timing on various outcomes (ordinal logistic regression analysis)**
	*********************************************************************************************************************************								

		**Ordinal logistic regression**	
				foreach x of varlist vote {
					local lab : var label `x'
					quietly ologit `x' treat if `x'!=6
					outreg2 treat using tableSI5.4.rtf, replace ///
					label se bdec(3) tdec(3) ctitle(`lab') ///
					title ("Table OA.5.4: Study 2, the effect of opportunistic election timing on various outcomes (ordinal logistic regression analysis)")
					}
				foreach x of varlist eval_comp econ_exp {
					local lab : var label `x'
					quietly ologit `x' treat if `x'!=6
					outreg2 treat using tableSI5.4.rtf, append ///
					label se bdec(3) tdec(3) ctitle(`lab') 
					}		
			

	************************************************************************************************
	**Table OA.5.5: Study 3, the effect of opportunistic election timing on various outcomes (OLS)**
	************************************************************************************************								

	**Study 3 - varying partisanship (February 2017)**
			use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 3_Feb 2017_Partisanship.dta", clear
			cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

				label define treat_label 0 "Control" 1 "Treatment", modify
				label values treat treat_label

				lab var treat "Opportunistic election timing"
				lab var vote "Vote intention"
				lab var fairv "Fairness (voters)"
				lab var fairp "Fairness (parties)"
				lab var comp "Competence evaluation"
				lab var eexp "Anticipated economic performance"

		**OLS regression**	
				foreach x of varlist vote  {
				regress `x' treat if `x'!=6
						outreg2 treat using tableSI5.5.rtf, replace ///
						label se bdec(3) tdec(3) ctitle("Vote intention") ///
						title ("Table OA.5.5: Study 3, the effect of opportunistic election timing on various outcomes (OLS regression analysis)")
				}
				foreach x of varlist comp eexp fairv fairp {
				local lab : var label `x'
				regress `x' treat if `x'!=6
						outreg2 treat using tableSI5.5.rtf, slow(100) append ///
						label se bdec(3) tdec(3) ctitle(`lab')
						}
					

	*********************************************************************************************************************************
	**Table OA.5.6: Study 3, the effect of opportunistic election timing on various outcomes (ordinal logistic regression analysis)**
	*********************************************************************************************************************************								

		**Ordinal logistic regression**	
			**Study 3**
				foreach x of varlist vote  {
				ologit `x' treat if `x'!=6
						outreg2 treat using tableSI5.6.rtf, replace ///
						label se bdec(3) tdec(3) ctitle("Vote intention") ///
						title ("Table OA.5.6: Study 3, the effect of opportunistic election timing on various outcomes (ordinal logistic regression analysis)")
				}
				foreach x of varlist comp eexp fairv fairp {
				local lab : var label `x'
				ologit `x' treat if `x'!=6
						outreg2 treat using tableSI5.6.rtf, slow(100) append ///
						label se bdec(3) tdec(3) ctitle(`lab') 
						}
					

	**********************************************************************************************************************
	**Table OA.5.7: Study 4, the effect of opportunistic election timing and economic conditions on vote intention (OLS)**
	**********************************************************************************************************************								
							
		*Study 4 - varying economic conditions (15 March 2017)*
			use "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Replication Data\Study 4_Mar 2017_Economy.dta", clear
			cd "C:\Users\User\Dropbox\Early Election Calling\Experiment\Resubmission JoP\Analysis"

				label define treat_label 0 "Control" 1 "Treatment", modify
				label values treat treat_label

				lab var econ "Mixed economic performance"
				lab var treat "Opportunistic election timing"
				lab var vote "Vote intention"

		**OLS regression**	
				regress vote treat if vote!=6
						outreg2 treat using tableSI5.7.rtf, replace ///
						se bdec(3) tdec(3) ctitle("Vote intention") ///
						label ///
						title ("Table OA.5.7: Study 4, the effect of opportunistic election timing and economic conditions on vote intention (OLS regression analysis)")
				regress vote econ if vote!=6
						outreg2 treat econ using tableSI5.7.rtf, slow(100) append ///
						label ///
						se bdec(3) tdec(3) ctitle("Vote intention")
						

	**********************************************************************************************************************************************
	**Table OA.5.8: Study 4, the effect of opportunistic election timing and economic conditions on vote intention (ordinal logistic regression)**
	**********************************************************************************************************************************************								
						
			**Study 4**
				ologit vote treat if vote!=6
						outreg2 treat using tableSI5.8.rtf, replace ///
						se bdec(3) tdec(3) ctitle("Vote intention") ///
						addtext(Controls, No) ///
						label ///
						title ("Table OA.5.8: Study 4, the effect of opportunistic election timing and economic conditions on vote intention (ordinal logistic regression analysis)")
				ologit vote econ if vote!=6
						outreg2 treat econ using tableSI5.8.rtf, slow(100) append ///
						se bdec(3) tdec(3) ctitle("Vote intention") ///
						addtext(Controls, No) ///
						label ///
						title ("Table OA.5.8: Study 4, the effect of opportunistic election timing and economic conditions on vote intention (ordinal logistic regression analysis)")
						
