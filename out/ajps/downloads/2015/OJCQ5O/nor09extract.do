****************************************************************************
**		File name: 	nor09extract
**		Author:		Omer Yair 
**		Date: 		Final version: June 5 2015
**		Purpose: 	Prepare the data file for section 4 (Figure A3)
**		Input:		Election2009.dta
**		Ouput: 		policy.dta.dta	                                                                 
*****************************************************************************

use "Election2009", clear
capture log using "norway09.log", replace

*** Keep variables needed for analysis

keep v227 v134 v037 v039 v093 v095 v096 v186 v187 v214 v033 v041 v092 v189 v208 v213 v311
save "policy.dta", replace

log close
