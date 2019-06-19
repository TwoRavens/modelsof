clear all
set more off
* This do file loads Pews survey data and generate summary statistics reported in Table 1 of the article
* "Statistical discrimination or prejudice? A large sample field experiment"

* Use Pews Spring Tracking Survey 2009
use "april_2009_economy.dta", clear
	* Can also run:
	* insheet using "april_2009_economy.csv", comma clear
	
	
* Generate new variables to prepare for Table 1
gen craigslist = (activ82==1 | activ82==2)
gen white = 1 if (race==1 & hisp==2)
gen black = 1 if (race==2 & hisp==2)
replace white = 0 if black==1
replace black = 0 if white==1
gen adage = age if (age~=98 & age~=99)
gen male = (sex==1)
gen college = (receduc==3 | receduc==4)
gen lowinc = (inc>=1 & inc<=5)
gen renter = (ownrent==2)
gen single = (mar==6 | mar==7)
gen fulltime = (empl==1)

***** Table 1 ******
* Full sample
table white [pw=weight], c(n black mean adage mean male mean college mean lowinc)
table white [pw=weight], c(mean renter mean single mean fulltime mean i_user mean craigslist)

* Craigslist users
table white if craigslist [pw=weight], c(n black mean adage mean male mean college mean lowinc)
table white if craigslist [pw=weight], c(mean renter mean single mean fulltime)

* Non-craigslist users
table white if ~craigslist [pw=weight], c(n black mean adage mean male mean college mean lowinc)
table white if ~craigslist [pw=weight], c(mean renter mean single mean fulltime)

* Internet users
table white if i_user [pw=weight], c(n black mean adage mean male mean college mean lowinc)
table white if i_user [pw=weight], c(mean renter mean single mean fulltime mean craigslist)

* Non-internet users
table white if ~i_user [pw=weight], c(n black mean adage mean male mean college mean lowinc)
table white if ~i_user [pw=weight], c(mean renter mean single mean fulltime)

