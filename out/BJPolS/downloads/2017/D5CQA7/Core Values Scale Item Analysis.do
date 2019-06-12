****************
*1988-2012 American National Studies (ANES)*
**Note: The data examined here are from the ANES Cumulative File, which, as*
*of 09/14, has been updated to include data collected during and after the*
*2012 presidential election*

*This Stata do-file, along with the accompanying R script, is used to*
*assess the over time reliability of our core values scale, as well as conduct*
*an item analysis of the egalitarianism and moral traditionalism*
*indicators that comprise the core values scale*

*The analysis conducted in this Stata do-file and the accompanying R script*
*contained in this Dataverse Dataset produces Figures SI1-SI2 in the* 
*Supporting Information (SI) for the BJPS article titled "Values and Political* 
*Predispositions in the Age of Polarization: Examining the Relationship* 
*between Partisanship and Ideology in the U.S., 1988-2012"*

*Note: The dataset used to conduct this item analysis is simply a subset of* 
*the variables that are created in the primary Stata do-file for this article*
*The primary Stata do-file appears in this Dataverse Dataset, and it is*
*titled "Values, Ideology and Partisanship (Replication Code, 09-27-17).do"*

*The data necessary needed to reproduce the following analysis in the immediate*
*Stata do-file is located in this Dataverse Dataset, and it is a Stata dataset* 
*titled "Core Values Scale Item Analysis Data.dta"*
 
*This paper is co-authored with Steven M. Smallpage and Adam M. Enders*
*My name is Robert N. Lupton
*Adam Enders conducted the analysis appearing in this Stata do-file and the*
*accompanying R script

*Wed. 27 September 2017*
****************

** The following code is used to create
** the dataset used to conduct the 
** item analysis included in the
** supplemental appendix of the paper.
**
** Note that the data is constructed such 
** that these analyses are conducted on only
** the observations included in the regression.
**
** The analysis is conducted in R. The R script
** for these analyses is titled "item-analysis.R".
****

* Open raw ANES '48-'12 Cumulative file:

use "/Users/adamenders/Dropbox/Data/ANES/anes48-12cum/ANEScum48-12.dta"

* Create Time and Value variables:

gen Time = .
replace Time = 0 if VCF0004 == 1988
replace Time = 1 if VCF0004 == 1992
replace Time = 2 if VCF0004 == 1996
replace Time = 3 if VCF0004 == 2000
replace Time = 4 if VCF0004 == 2004
replace Time = 5 if VCF0004 == 2008
replace Time = 6 if VCF0004 == 2012

gen Equalopp = VCF9013
replace Equalopp = . if VCF9013 == 8 
replace Equalopp = . if VCF9013 == 9
replace Equalopp = 0 if VCF9013 == 1
replace Equalopp = 1 if VCF9013 == 2
replace Equalopp = 2 if VCF9013 == 3
replace Equalopp = 3 if VCF9013 == 4
replace Equalopp = 4 if VCF9013 == 5

gen Equalrights = VCF9014
replace Equalrights = . if VCF9014 == 8
replace Equalrights = . if VCF9014 == 9
replace Equalrights = 0 if VCF9014 == 5
replace Equalrights = 1 if VCF9014 == 4
replace Equalrights = 2 if VCF9014 == 3
replace Equalrights = 3 if VCF9014 == 2
replace Equalrights = 4 if VCF9014 == 1

gen Equalchance = VCF9015
replace Equalchance = . if VCF9015 == 8
replace Equalchance = . if VCF9015 == 9
replace Equalchance = 0 if VCF9015 == 1
replace Equalchance = 1 if VCF9015 == 2
replace Equalchance = 2 if VCF9015 == 3
replace Equalchance = 3 if VCF9015 == 4
replace Equalchance = 4 if VCF9015 == 5

gen Lessequal = VCF9017
replace Lessequal = . if VCF9017 == 8
replace Lessequal = . if VCF9017 == 9
replace Lessequal = 0 if VCF9017 == 5
replace Lessequal = 1 if VCF9017 == 4
replace Lessequal = 2 if VCF9017 == 3
replace Lessequal = 3 if VCF9017 == 2
replace Lessequal = 4 if VCF9017 == 1

gen Unequal = VCF9016
replace Unequal = . if VCF9016 == 8
replace Unequal = . if VCF9016 == 9
replace Unequal = 0 if VCF9016 == 5 
replace Unequal = 1 if VCF9016 == 4 
replace Unequal = 2 if VCF9016 == 3 
replace Unequal = 3 if VCF9016 == 2 
replace Unequal = 4 if VCF9016 == 1 

gen Fewer = VCF9018
replace Fewer = . if VCF9018 == 8
replace Fewer = . if VCF9018 == 9
replace Fewer = 0 if VCF9018 == 1
replace Fewer = 1 if VCF9018 == 2
replace Fewer = 2 if VCF9018 == 3
replace Fewer = 3 if VCF9018 == 4
replace Fewer = 4 if VCF9018 == 5

gen Changing = VCF0852
replace Changing = . if VCF0852 == 8
replace Changing = . if VCF0852 == 9
replace Changing = 0 if VCF0852 == 1
replace Changing = 1 if VCF0852 == 2
replace Changing = 2 if VCF0852 == 3
replace Changing = 3 if VCF0852 == 4
replace Changing = 4 if VCF0852 == 5
 
gen Lifestyles = VCF0851
replace Lifestyles = . if VCF0851 == 8
replace Lifestyles = . if VCF0851 == 9
replace Lifestyles = 0 if VCF0851 == 5
replace Lifestyles = 1 if VCF0851 == 4
replace Lifestyles = 2 if VCF0851 == 3
replace Lifestyles = 3 if VCF0851 == 2
replace Lifestyles = 4 if VCF0851 == 1

gen Standards = VCF0854
replace Standards = . if VCF0854 == 8
replace Standards = . if VCF0854 == 9
replace Standards = 0 if VCF0854 == 1
replace Standards = 1 if VCF0854 == 2
replace Standards = 2 if VCF0854 == 3
replace Standards = 3 if VCF0854 == 4
replace Standards = 4 if VCF0854 == 5

gen Family = VCF0853
replace Family = . if VCF0853 == 8
replace Family = . if VCF0853 == 9
replace Family = 0 if VCF0853 == 5
replace Family = 1 if VCF0853 == 4
replace Family = 2 if VCF0853 == 3
replace Family = 3 if VCF0853 == 2
replace Family = 4 if VCF0853 == 1

****
** Remove observations that are missing data on 
** any of the variables, and drop all irrelevant
** data.
****

foreach var of varlist Time Equalopp-Family{ 
	drop if `var' == . 
	} 

keep Time Equalopp-Family
	
saveold "/Users/adamenders/Dropbox/Values/item-analysis.dta", replace version(12)	
