****************************************************************************************************************
**																											  **
** This do file is part of the replication material for the following article: 								  **
** "On the Limits on Officials’ Ability to Change Citizens’ Priorities: A Field Experiment in Local Politics" **
** 		Authors: Daniel M. Butler and Hans Hassell															  **
** 		Journal: American Political Science Review															  **
**																											  **
** This file replicates the following things from the article: 												  **
**		Figure 1																							  **
**		Table 3																								  **
**		Table 4																								  **																							  **																						 
**		Table 5																								  **
**																											  **
****************************************************************************************************************

** Change directory to where the datasets are stored
	* cd "~/Dropbox/Butler-Hassell/Priorities Project/Archive/"
	cd "~/Dropbox/Coauthors/Butler-Hassell/Priorities Project/Archive/"
	* cd "C:\Users\Hans\Dropbox\Butler-Hassell\Priorities Project\Archive"
	
** Call up the dataset
	use "Leadership-AnalysisData.dta", clear

	
*******************************
** Figure 1: Research Design **
*******************************		
		gen num_movable=totallow
			replace num_movable=totalmed if num_movable==0		
		** Step 3
		tab num_movable
		** Step 4
		tab trletter 
		** Steps 6-7
		tab trletter if mchimp_open==1 & survey_pre!=1
		** Step 8
		tab num_movable if mchimp_open==1 & survey_pre!=1

******************************
** Table 3, Col. 1: Balance **
******************************		
	probit trletter female age educ polit_int localfocus if in_postsample==1
					
**************************************
** Table 4, Cols. 1 and 2: Atrition **
**************************************
	probit in_postsample trletter   
	probit in_postsample female age educ polit_int localfocus  if trletter!=.
		
*********************************************
** Table 5, Col. 1: Descriptive Statistics **
*********************************************	
	summ female if in_postsample==1
	tab age if in_postsample==1
	tab educ if in_postsample==1
	tab localfocus if in_postsample==1
	tab polit_int if in_postsample==1
				

*********************************************
*********************************************
** Create dataset for Issue Level Analyses **
*********************************************
*********************************************

	** Expand dataset to 1 observation per issue 
	forvalues var=1/7{
		rename issue`var'_post issuepost`var'
		}
	gen voterid=_n
	
	reshape long issuepost medpriority lowpriority issue salience , i(voterid) j(issueid)

	** Only keep the observations that were eligible for treatment
	keep if lowpriority==1 | medpriority==1 & lowprioritysample==0
	
	** Generate an issue specific treatment variable
	gen tr_issueletter=0
		replace tr_issueletter=1 if trletter==1 & issueid==trissue	
		
	** Create Strata based on randomization scheme (this is the number of issues on which they were eligbile for treatment)
		gen strata=totallow
			replace strata=totalmed if strata==0

	** New variable for whether in post-sample
		drop in_postsample
	xi: oprobit issuepost tr_issueletter lowprioritysample i.strata  if mchimp_open==1 & survey_pre!=1, cl(voterid)
		gen in_postsample=1 if e(sample)==1
		replace in_postsample=0 if in_postsample==.
		
******************************
** Table 3, Col. 2: Balance **
******************************			
	probit tr_issueletter female age educ  polit_int localfocus if in_postsample==1

**************************************
** Table 4, Cols. 3 and 4: Atrition **
**************************************		
	probit  in_postsample trletter  
	probit  in_postsample female age educ polit_int localfocus

*********************************************
** Table 5, Col. 2: Descriptive Statistics **
*********************************************	
	xi: oprobit issuepost tr_issueletter lowprioritysample i.strata  if mchimp_open==1 & survey_pre!=1, cl(voterid)
		gen in_sample=1 if e(sample)==1

	tab female if in_sample==1
	tab age if in_sample==1
	tab educ if in_sample==1
	tab localfocus if in_sample==1
	tab polit_int if in_sample==1		
			
