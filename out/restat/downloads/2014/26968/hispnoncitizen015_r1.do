/*the code in this file produces the main estimates for the outcome variable proportion hispanic non-citizen among the population over 15 years of age.  The code and output from this program produce elements in Table 2*/
clear all
/*change path in the following line to directory where data is stored*/
cd "D:\state immigration laws\RESTATREVISION\program files for RESTAT readme"
use populationtotals.dta

*dropping states with legislation targeting employment of undocumented immigrants*/

drop if statefip==28
drop if statefip==44
drop if statefip==45
drop if statefip==49

sort statefip year

** Declare panel dataset

tsset statefip year



** Initial synthetic cohort analysis for Arizona.
#delimit;
synth hispnoncitizeno15 hispnoncitizeno15(1998) hispnoncitizeno15(1999) hispnoncitizeno15(2000) hispnoncitizeno15(2001) hispnoncitizeno15(2002) hispnoncitizeno15(2003) hispnoncitizeno15(2004) hispnoncitizeno15(2005) hispnoncitizeno15(2006)
ind1(1998(1)2000) ind2(1998(1)2000) ind3(1998(1)2000) ind4(1998(1)2000) ind5(1998(1)2000) ind6(1998(1)2000) ind8(1998(1)2000) ind9(1998(1)2000) educ1(1998(1)2000) educ2(1998(1)2000) educ3(1998(1)2000) rate(1998(1)2000)
ind1(2001(1)2003) ind2(2001(1)2003) ind3(2001(1)2003) ind4(2001(1)2003) ind5(2001(1)2003) ind6(2001(1)2003) ind8(2001(1)2003) ind9(2001(1)2003) educ1(2001(1)2003) educ2(2001(1)2003) educ3(2001(1)2003) rate(2001(1)2003)
ind1(2004(1)2006) ind2(2004(1)2006) ind3(2004(1)2006) ind4(2004(1)2006) ind5(2004(1)2006) ind6(2004(1)2006) ind8(2004(1)2006) ind9(2004(1)2006) educ1(2004(1)2006) educ2(2004(1)2006) educ3(2004(1)2006) rate(2004(1)2006), 
trunit(4) counit(1 2 5 6 8 9 10 11 12 13 15 16 17 18 19 20 21 22 23 24 25 26 27 29 30 31 32 33 34 35 36 37 38 39 40 41 42 46 47 48 50 51 53 54 55 56)
trperiod(2007) fig;
#delimit cr

**the following code creates a variable with title "dif_TU" which contains the difference in the outcome variable for arizona minus synthetic arizona for each year from 1998 through 2009
mat diffs = e(Y_treated) - e(Y_synthetic)
mat treated =e(Y_treated)
mat colnames treated = treated
mat synthcontrol=e(Y_synthetic)
mat colnames synthcontrol = synthetic
mat colnames diffs = dif_TU
svmat diffs, names(col)
svmat treated, names(col)
svmat synthcontrol, names(col)
list treated synthetic in 1/12

*the following code estimaes the synthetic treatment effect for each state in the donor pool to generate the distribution of placebo estimate for the permutation test of the LAWA effect
local wonka "1 2 5 6 8 9 10 11 12 13 15 16 17 18 19 20 21 22 23 24 25 26 27 29 30 31 32 33 34 35 36 37 38 39 40 41 42 46 47 48 50 51 53 54 55 56"

	set more off
	foreach val of local wonka {
		display as text "`val'"
		quietly: synth hispnoncitizeno15 hispnoncitizeno15(1998) hispnoncitizeno15(1999) hispnoncitizeno15(2000) hispnoncitizeno15(2001) hispnoncitizeno15(2002) hispnoncitizeno15(2003) hispnoncitizeno15(2004) hispnoncitizeno15(2005) hispnoncitizeno15(2006) ind1(1998(1)2000) ind2(1998(1)2000) ind3(1998(1)2000) ind4(1998(1)2000) ind5(1998(1)2000) ind6(1998(1)2000) ind8(1998(1)2000) ind9(1998(1)2000) educ1(1998(1)2000) educ2(1998(1)2000) educ3(1998(1)2000) rate(1998(1)2000) ind1(2001(1)2003) ind2(2001(1)2003) ind3(2001(1)2003) ind4(2001(1)2003) ind5(2001(1)2003) ind6(2001(1)2003) ind8(2001(1)2003) ind9(2001(1)2003) educ1(2001(1)2003) educ2(2001(1)2003) educ3(2001(1)2003) rate(2001(1)2003) ind1(2004(1)2006) ind2(2004(1)2006) ind3(2004(1)2006) ind4(2004(1)2006) ind5(2004(1)2006) ind6(2004(1)2006) ind8(2004(1)2006) ind9(2004(1)2006) educ1(2004(1)2006) educ2(2004(1)2006) educ3(2004(1)2006) rate(2004(1)2006), trunit(`val') trperiod(2007)		
        * Calculations for the plotting the gap
			mat diffs = e(Y_treated) - e(Y_synthetic)
			mat colnames diffs = dif_`val'
			svmat diffs, names(col)
			}

*the following statement prodocues a figure showing the treated minus synth differences for Arizona (in heavy line) and all other states in the donor pool
twoway line dif_1 year, lcolor(black) xline(2007)|| line dif_2 year, lcolor(black) || line dif_5 year, lcolor(black) || line dif_6 year, lcolor(black) || line dif_8 year, lcolor(black) || line dif_9 year, lcolor(black) || line dif_10 year, lcolor(black) || line dif_11 year, lcolor(black)|| line dif_12 year, lcolor(black) || line dif_13 year, lcolor(black) || line dif_15 year, lcolor(black)|| line dif_16 year, lcolor(black) || line dif_17 year, lcolor(black) || line dif_18 year, lcolor(black) || line dif_19 year, lcolor(black) || line dif_20 year, lcolor(black) || line dif_21 year, lcolor(black) || line dif_22 year, lcolor(black) || line dif_23 year, lcolor(black) || line dif_24 year, lcolor(black) || line dif_25 year, lcolor(black) || line dif_26 year, lcolor(black) || line dif_27 year, lcolor(black) || line dif_29 year, lcolor(black) || line dif_30 year, lcolor(black) || line dif_31 year, lcolor(black) || line dif_32 year, lcolor(black) || line dif_33 year, lcolor(black) || line dif_34 year, lcolor(black) || line dif_35 year, lcolor(black) || line dif_36 year, lcolor(black) || line dif_37 year, lcolor(black) || line dif_38 year, lcolor(black) || line dif_39 year, lcolor(black) || line dif_40 year, lcolor(black) || line dif_41 year, lcolor(black) || line dif_42 year, lcolor(black) || line dif_46 year, lcolor(black) || line dif_47 year, lcolor(black) || line dif_48 year, lcolor(black) || line dif_50 year, lcolor(black) ||  line dif_51 year, lcolor(black) ||  line dif_53 year, lcolor(black) || line dif_54 year, lcolor(black) || line dif_55 year, lcolor(black) ||  line dif_56 year, lcolor(black) || line dif_TU year, lcolor(red)lwidth(vthick) || ,legend(off) ytitle("Difference treatment minuse synthetic control") xtitle(year) yline(0, lstyle(foreground) lpattern(dash)) xline(13)





** the code that follows uses the vectors of treated minus control difference to generate the key statistics for the difference-in-differnece estimates and the permutation test 

*restric the data set to obervations contaning the difference vectors
keep if dif_1< .


/*creat2 12 by 47 matrix of differences vectors for each state, take the transpose, and create variables with each observation a state and generating variables year1 through year12 
corresponding to 1998 through 2009 treated minus synthetic comparison differences.  Note, Arizona is last observation in data set (row 47)*/
mkmat dif_1 dif_2 dif_5 dif_6 dif_8 dif_9 dif_10 dif_11 dif_12 dif_13 dif_15 dif_16 dif_17 dif_18 dif_19 dif_20 dif_21 dif_22 dif_23 dif_24 dif_25 dif_26 dif_27 dif_29 dif_30 dif_31 dif_32 dif_33 dif_34 dif_35 dif_36 dif_37 dif_38 dif_39 dif_40 dif_41 dif_42 dif_46 dif_47 dif_48 dif_50 dif_51 dif_53 dif_54 dif_55 dif_56 dif_TU, matrix(diffs) rownames(year)
mat diffs2=diffs'
svmat diffs2, names(year)


*following code generates mean squared error for pre-intervention period 1998 througb 2006
gen pre=(year1*year1+year2*year2+year3*year3+year4*year4+year5*year5+year6*year6+year7*year7+year8*year8+year9*year9)/9

*following code generates mean square error for post-intervention treatment period 2007 through 2010
gen post=(year10*year10+year11*year11+year12*year12)/3
*following code generates mean pre-intervention difference between treated and synth for the pre-period 1998-2006
gen premean=(year1+year2+year3+year4+year5+year6+year7+year8+year9)/9

*following code generates mean difference between treated and synth for the pre-period 2005-2006
gen premean3=(year8+year9)/2
*following code generates mean post-intervention difference between treated and synth for the post-period 2007-2009
gen postmean=(year10+year11+year12)/3

*the following code generates mean post-intervention difference between treated and synth for the post-period 2008-2009
gen postmean2=(year11+year12)/2

*the following generates diff-in-diff estimate using pre-preiod 1998-2006 and post-period 2007-2009
gen diffmean=postmean-premean
*the following generates diff-in-diff estimate using pre-period 1998-2006 and post-period 2008-2009
gen diffmean2=postmean2-premean
*the following generates diff-in-diff estimate using pre-period 2005-2006 and post-period 2008-2009 
gen diffmean3=postmean2-premean3
*the following generates diff-in-diff estimate using the pre-period 2005-2006 and post-period 2007-2009
gen diffmean4=postmean-premean3

/*the code that follows generates the otuput needed to perform the permutation inference tests.  We first list the various pre and post means
for Arizona (observatin 47).  We then sort each diff-in-diff estimaate and print the distribution.  Arizona's relative distribution is noteed in the 
secon-to-last columns of table 2 and 3, followed by the implied p-value*/

list premean premean3 postmean postmean2 diffmean diffmean2 diffmean3 diffmean4 in 47


sort diffmean
list diffmean
sort diffmean2
list diffmean2
sort diffmean3
list diffmean3
sort diffmean4
list diffmean4
 
