****************************************************************************************************************
**																											  **
** This do file is part of the replication material for the following article: 								  **
** "On the Limits on Officials’ Ability to Change Citizens’ Priorities: A Field Experiment in Local Politics" **
** 		Authors: Daniel M. Butler and Hans Hassell															  **
** 		Journal: American Political Science Review															  **
**																											  **
** This file replicates the following things from the article: 												  **
**		Table 8																								  **
**		Table SI.4																							  **
**																											  **
****************************************************************************************************************

********************
** Get MTurk Data **
********************

clear
** Change directory to where the datasets are stored
	* cd "~/Dropbox/Butler-Hassell/Priorities Project/Archive/"
	cd "~/Dropbox/Coauthors/Butler-Hassell/Priorities Project/Archive/"
	* cd "C:\Users\Hans\Dropbox\Butler-Hassell\Priorities Project\Archive"
	use "Mturk.dta"

*********************
** Prep MTurk Data **
*********************
	
* Generate the Treatment Variable
	gen tr_cityofficial= cityororg=="city council member"

* Generate the DV
	** Will the government take action? Higher values of created var ("govtaction") means more likely to take action 
		egen temp1 = rowtotal(q227 q232 q237 q242), missing
			gen govtaction=6-temp1

			
*****************************
** Table 8: MTurk Analysis **
*****************************
	ologit govtaction tr_cityofficial

	
********************************************************
** Table SI.4: Descriptive Statistics of MTurk Sample **
********************************************************
	sum gender
		replace birthyr=birthyr +1913
	gen age=2017-birthyr
	sum age
	gen somecollege= educ>2
		replace somecollege=. if educ==.
	sum somecollege
	gen white= race==1
		replace white=. if race==.
	gen black= race==2
		replace black=. if race==.
	gen asian= race==4
		replace asian=. if race==.
	gen latino= race==6
		replace latino=. if race==.
	sum white
	sum black
	sum asian
	sum latino
	tab pid
