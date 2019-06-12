* Matthew Hoddie and Jason Smith *
* "Forms of Civil War Violence and Their Consequences for Future Public Health" *
* You will need change the path directory to where you saved the data file *


clear
set mem 50m
set more off
use "F:\ISQ data\ISQ_final.dta", clear


** summary statistics for TABLE 1 **

drop if log_vanhanen == .

sum deathspercapbst deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen if ct == 1

*****************************************************************************************************
*****************************************************************************************************

** These are the equations for the ISQ submission **
** TABLE 2 **

* All causes men under 4 using best *

regress dalyp0 deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 1

* All causes women under 4

regress dalyp0  deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 25

* All causes men 5 to 14

regress dalyp5_14 deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 1


* All causes women 5 to 14

regress dalyp5_14 deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 25


* All causes men 15 to 44

regress dalyp15_44 deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 1


* All causes women 15 to 44

regress dalyp15_44 deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 25


* All causes men 44 to 59

regress dalyp45_59 deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 1


* All causes women 44 to 59 

regress dalyp45_59 deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 25


* All causes men 60 plus

regress dalyp60plus deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 1
 

* All causes women 60 plus

regress dalyp60plus deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 25

*****************************************************************************************************
*****************************************************************************************************

**These are the estimates for State Failure Project (SFP)**
**TABLE 4**


* All causes men under 4 *

regress dalyp0 deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 1

* All causes women under 4

regress dalyp0  deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 25

* All causes men 5 to 14

regress dalyp5_14 deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 1


* All causes women 5 to 14

regress dalyp5_14 deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 25


* All causes men 15 to 44

regress dalyp15_44 deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 1


* All causes women 15 to 44

regress dalyp15_44 deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 25


* All causes men 44 to 59

regress dalyp45_59 deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 1


* All causes women 44 to 59 

regress dalyp45_59 deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 25


* All causes men 60 plus

regress dalyp60plus deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 1
 

* All causes women 60 plus

regress dalyp60plus deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 25

**********************************************************************************************************
**********************************************************************************************************

** Analyses using dummy GHR variable (civil_warghr) **
** TABLE 5 **

* All causes men under 4 using best *

regress dalyp0 deathspercapbst civil_warghr contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 1

* All causes women under 4

regress dalyp0  deathspercapbst civil_warghr contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 25

* All causes men 5 to 14

regress dalyp5_14 deathspercapbst civil_warghr contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 1


* All causes women 5 to 14

regress dalyp5_14 deathspercapbst civil_warghr contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 25


* All causes men 15 to 44

regress dalyp15_44 deathspercapbst civil_warghr contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 1


* All causes women 15 to 44

regress dalyp15_44 deathspercapbst civil_warghr contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 25


* All causes men 44 to 59

regress dalyp45_59 deathspercapbst civil_warghr contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 1


* All causes women 44 to 59 

regress dalyp45_59 deathspercapbst civil_warghr contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 25


* All causes men 60 plus

regress dalyp60plus deathspercapbst civil_warghr contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 1
 

* All causes women 60 plus

regress dalyp60plus deathspercapbst civil_warghr contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 25

***********************************************************************************************
***********************************************************************************************


**These are the estimates for SFP using a dummy variable for civil war (civil_warghr) **
** TABLE 6 **

* All causes men under 4 *

regress dalyp0 deathmagmax totalmagmax civil_warghr contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 1

* All causes women under 4

regress dalyp0  deathmagmax totalmagmax civil_warghr contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 25

* All causes men 5 to 14

regress dalyp5_14 deathmagmax totalmagmax civil_warghr contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 1


* All causes women 5 to 14

regress dalyp5_14 deathmagmax totalmagmax civil_warghr contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 25


* All causes men 15 to 44

regress dalyp15_44 deathmagmax totalmagmax civil_warghr contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 1


* All causes women 15 to 44

regress dalyp15_44 deathmagmax totalmagmax civil_warghr contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 25


* All causes men 44 to 59

regress dalyp45_59 deathmagmax totalmagmax civil_warghr contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 1


* All causes women 44 to 59 

regress dalyp45_59 deathmagmax totalmagmax civil_warghr contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 25


* All causes men 60 plus

regress dalyp60plus deathmagmax totalmagmax civil_warghr contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 1
 

* All causes women 60 plus

regress dalyp60plus deathmagmax totalmagmax civil_warghr contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 25


*****************************************************************************************************************
*****************************************************************************************************************

** Robustness checks using logged variables for deaths per capita **
** These are the estimates using logged variable per capita (logdeathbestpc) **
** TABLE A1 **

* All causes men under 4 *

regress dalyp0 logdeathbestpc contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 1

* All causes women under 4

regress dalyp0 logdeathbestpc contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 25

* All causes men 5 to 14

regress dalyp5_14 logdeathbestpc contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 1


* All causes women 5 to 14

regress dalyp5_14 logdeathbestpc contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 25


* All causes men 15 to 44

regress dalyp15_44 logdeathbestpc contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 1


* All causes women 15 to 44

regress dalyp15_44 logdeathbestpc contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 25


* All causes men 44 to 59

regress dalyp45_59 logdeathbestpc contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 1


* All causes women 44 to 59 

regress dalyp45_59 logdeathbestpc contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 25


* All causes men 60 plus

regress dalyp60plus logdeathbestpc contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 1
 

* All causes women 60 plus

regress dalyp60plus logdeathbestpc contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen /*
*/ if ct == 25


*****************************************************************************************************************
*****************************************************************************************************************

** Regressions using GDP per capita (gdppercap) **
** TABLE A2 ** 

* All causes men under 4 using best *

regress dalyp0 deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen gdppercap /*
*/ if ct == 1

* All causes women under 4

regress dalyp0  deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen gdppercap /*
*/ if ct == 25

* All causes men 5 to 14

regress dalyp5_14 deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen gdppercap /*
*/ if ct == 1


* All causes women 5 to 14

regress dalyp5_14 deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen gdppercap /*
*/ if ct == 25


* All causes men 15 to 44

regress dalyp15_44 deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen gdppercap /*
*/ if ct == 1


* All causes women 15 to 44

regress dalyp15_44 deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen gdppercap /*
*/ if ct == 25


* All causes men 44 to 59

regress dalyp45_59 deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen gdppercap /*
*/ if ct == 1


* All causes women 44 to 59 

regress dalyp45_59 deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen gdppercap /*
*/ if ct == 25


* All causes men 60 plus

regress dalyp60plus deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen gdppercap /*
*/ if ct == 1
 

* All causes women 60 plus

regress dalyp60plus deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen gdppercap /*
*/ if ct == 25



***************************************************************************************************
***************************************************************************************************
** TABLE A3 **

* All causes men under 4 using SFP *

regress dalyp0 deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen gdppercap /*
*/ if ct == 1

* All causes women under 4

regress dalyp0  deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen gdppercap/*
*/ if ct == 25

* All causes men 5 to 14

regress dalyp5_14 deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen gdppercap /*
*/ if ct == 1


* All causes women 5 to 14

regress dalyp5_14 deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen gdppercap /*
*/ if ct == 25


* All causes men 15 to 44

regress dalyp15_44 deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen gdppercap /*
*/ if ct == 1


* All causes women 15 to 44

regress dalyp15_44 deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen gdppercap /*
*/ if ct == 25


* All causes men 44 to 59

regress dalyp45_59 deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen gdppercap /*
*/ if ct == 1


* All causes women 44 to 59 

regress dalyp45_59 deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen gdppercap /*
*/ if ct == 25


* All causes men 60 plus

regress dalyp60plus deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen gdppercap /*
*/ if ct == 1
 

* All causes women 60 plus

regress dalyp60plus deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen gdppercap /*
*/ if ct == 25



****************************************************************************************************************
****************************************************************************************************************

** Revised equations controling for duration of conflict **
** TABLE A4 **


* All causes men under 4 using best *

regress dalyp0 deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen duration /*
*/ if ct == 1

* All causes women under 4

regress dalyp0  deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen duration /*
*/ if ct == 25

* All causes men 5 to 14

regress dalyp5_14 deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen duration /*
*/ if ct == 1


* All causes women 5 to 14

regress dalyp5_14 deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen duration /*
*/ if ct == 25


* All causes men 15 to 44

regress dalyp15_44 deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen duration /*
*/ if ct == 1


* All causes women 15 to 44

regress dalyp15_44 deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen duration /*
*/ if ct == 25


* All causes men 44 to 59

regress dalyp45_59 deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen duration /*
*/ if ct == 1


* All causes women 44 to 59 

regress dalyp45_59 deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen duration /*
*/ if ct == 25


* All causes men 60 plus

regress dalyp60plus deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen duration /*
*/ if ct == 1
 

* All causes women 60 plus

regress dalyp60plus deathspercapbst contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen duration /*
*/ if ct == 25


****************************************************************************************************************
****************************************************************************************************************

**These are the estimates for State Failure Project (SFP)**
** TABLE A5 **

* All causes men under 4 *

regress dalyp0 deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen duration /*
*/ if ct == 1

* All causes women under 4

regress dalyp0  deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen duration /*
*/ if ct == 25

* All causes men 5 to 14

regress dalyp5_14 deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen duration /*
*/ if ct == 1


* All causes women 5 to 14

regress dalyp5_14 deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen duration /*
*/ if ct == 25


* All causes men 15 to 44

regress dalyp15_44 deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen duration /*
*/ if ct == 1


* All causes women 15 to 44

regress dalyp15_44 deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen duration /*
*/ if ct == 25


* All causes men 44 to 59

regress dalyp45_59 deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen duration /*
*/ if ct == 1


* All causes women 44 to 59 

regress dalyp45_59 deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen duration /*
*/ if ct == 25


* All causes men 60 plus

regress dalyp60plus deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen duration /*
*/ if ct == 1
 

* All causes women 60 plus

regress dalyp60plus deathmagmax totalmagmax contig_civil_war _k_total_log log_educational_attainment /*
*/growth_urban_pop_un gini tropical polity log_vanhanen duration /*
*/ if ct == 25


