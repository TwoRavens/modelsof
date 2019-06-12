********************************************************************************

********************************************************************************
**THIS DO-FILE PREPARES THE FIRM PANEL DATASET FOR THE FIGURES SHOWN IN THE PAPER 
**Small Firm Death in Developing Countries
**November 20, 2017
**David McKenzie (dmckenzie@worldbank.org) and Anna Luisa Paffhausen (apaffhausen@worldbank.org)
**The analysis was performed with Stata, version 14.2

*Notes:
*1) You can run this before running FiguresAndTables.do but there is no need to do so, as the folder “Do-files and readme/Preparation of Data for Figures/ Data for figures” already contains the necessary files.
*2) Before running this do-file, change the directory to the folder “Do-files and readme” on your computer.

********************************************************************************

********************************************************************************
clear all
*TO DO: change directory 
/*EXAMPLE:
cd  "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Do-files and readme"
*/
set more off

********************************************************************************
**For figures 1 and 2

********************************************************************************
*Death rates over 3 months
********************************************************************************
*SLMS - BL=2005

use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_3mths==0 & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=`r(N)'
count if survival_3mths==1 & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=help1, `r(N)'
count if survival_3mths==. & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="SLMS" & survey=="BL-2005" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)'
su Grate if surveyname=="SLMS" & survey=="BL-2005" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="3 months"

g country="Sri Lanka"

g surveyname="SLMS"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g years=0.25

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_3mths.dta", replace	

********************************************************************************
*Death rates over 4 months
********************************************************************************
*SLK Female Business Training - BL=2009 
*Ghana FLYP - BL=2008 

*SLK Female Business Training
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_4mths==0 & surveyname=="SLKFEMBUSTRAINING" & survey=="BL-2009" & control==1
mat help1=`r(N)'
count if survival_4mths==1 & surveyname=="SLKFEMBUSTRAINING" & survey=="BL-2009" & control==1
mat help1=help1, `r(N)'
count if survival_4mths==. & surveyname=="SLKFEMBUSTRAINING" & survey=="BL-2009" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="SLKFEMBUSTRAINING" & survey=="BL-2009" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="SLKFEMBUSTRAINING" & survey=="BL-2009" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="4 months"

g country="Sri Lanka"

g surveyname="SLKFEMBUSTRAINING"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_4mths_SLKFEMBUSTRAINING_BL-2009.dta", replace


*Ghana FLYP
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_4mths==0 & surveyname=="GHANAFLYP" & survey=="BL-2008" & control==1
mat help1=`r(N)'
count if survival_4mths==1 & surveyname=="GHANAFLYP" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
count if survival_4mths==. & surveyname=="GHANAFLYP" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="GHANAFLYP" & survey=="BL-2008" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="GHANAFLYP" & survey=="BL-2008" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="4 months"

g country="Ghana"

g surveyname="GHANAFLYP"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_4mths_GHANAFLYP_BL-2008.dta", replace

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

*Append and calculate average death rates over 1/3 years
use "Preparation of Data for Figures/Data for figures/Comb_uncond_4mths_SLKFEMBUSTRAINING_BL-2009.dta", clear
append using "Preparation of Data for Figures/Data for figures/Comb_uncond_4mths_GHANAFLYP_BL-2008.dta"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g years=1/3

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_4mths.dta", replace	

********************************************************************************
*Death rates over 6 months
********************************************************************************
*Nigeria - BL=2010,2012
*SLMS - BL=2005
*Egypt - BL=2012

foreach x in BL-2010 R-2012{
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_6mths==0 & country=="Nigeria" & survey=="`x'"
mat help1=`r(N)'
count if survival_6mths==1 & country=="Nigeria" & survey=="`x'"
mat help1=help1, `r(N)'
count if survival_6mths==. & country=="Nigeria" & survey=="`x'"
mat help1=help1, `r(N)'
su pcGDP if country=="Nigeria" & survey=="`x'"
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if country=="Nigeria" & survey=="`x'"
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="6 months"

g country="Nigeria"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_6mths_NG_`x'.dta", replace
}

*SLMS
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_6mths==0 & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=`r(N)'
count if survival_6mths==1 & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=help1, `r(N)'
count if survival_6mths==. & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="SLMS" & survey=="BL-2005" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="SLMS" & survey=="BL-2005" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="6 months"

g country="Sri Lanka"

g surveyname="SLMS"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

save "Preparation of Data for Figures/Data for figures/Comb_uncond_6mths_SLMS_BL-2005.dta", replace

*Egypt
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_6mths==0 & surveyname=="EGYPTMACROINS" & survey=="BL-2012" & control==1
mat help1=`r(N)'
count if survival_6mths==1 & surveyname=="EGYPTMACROINS" & survey=="BL-2012" & control==1
mat help1=help1, `r(N)'
count if survival_6mths==. & surveyname=="EGYPTMACROINS" & survey=="BL-2012" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="EGYPTMACROINS" & survey=="BL-2012" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="EGYPTMACROINS" & survey=="BL-2012" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="6 months"

g country="Egypt"

g surveyname="EGYPTMACROINS"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

save "Preparation of Data for Figures/Data for figures/Comb_uncond_6mths_EGYPTMACROINS_BL-2012.dta", replace

*Append and calculate average death rates over 0.5 years
use "Preparation of Data for Figures/Data for figures/Comb_uncond_6mths_NG_BL-2010.dta", clear
append using "Preparation of Data for Figures/Data for figures/Comb_uncond_6mths_NG_R-2012.dta"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate GDPpc GDPgrowthrate (first) period country 

append	using "Preparation of Data for Figures/Data for figures/Comb_uncond_6mths_SLMS_BL-2005.dta" ///
		"Preparation of Data for Figures/Data for figures/Comb_uncond_6mths_EGYPTMACROINS_BL-2012.dta"

g years=0.5

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_0p5yrs.dta", replace	

********************************************************************************
*Death rates over 7 months
********************************************************************************
*Ghana FLYP - BL=2008 

use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_7mths==0 & surveyname=="GHANAFLYP" & survey=="BL-2008" & control==1
mat help1=`r(N)'
count if survival_7mths==1 & surveyname=="GHANAFLYP" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
count if survival_7mths==. & surveyname=="GHANAFLYP" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="GHANAFLYP" & survey=="BL-2008" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="GHANAFLYP" & survey=="BL-2008" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="7 months"

g country="Ghana"

g surveyname="GHANAFLYP"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g years=7/12

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_7mths.dta", replace	

********************************************************************************
*Death rates over 9 months
********************************************************************************
*SLMS - BL=2005

use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_9mths==0 & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=`r(N)'
count if survival_9mths==1 & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=help1, `r(N)'
count if survival_9mths==. & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="SLMS" & survey=="BL-2005" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="SLMS" & survey=="BL-2005" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="9 months"

g country="Sri Lanka"

g surveyname="SLMS"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g years=0.75

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_9mths.dta", replace

********************************************************************************
*Death rates over 10 months
********************************************************************************
*Ghana FLYP - BL=2008 
*Togo BL=2013 

*Ghana FLYP
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_10mths==0 & surveyname=="GHANAFLYP" & survey=="BL-2008" & control==1
mat help1=`r(N)'
count if survival_10mths==1 & surveyname=="GHANAFLYP" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
count if survival_10mths==. & surveyname=="GHANAFLYP" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="GHANAFLYP" & survey=="BL-2008" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="GHANAFLYP" & survey=="BL-2008" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="10 months"

g country="Ghana"

g surveyname="GHANAFLYP"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_10mths_GHANAFLYP_BL-2008.dta", replace

*Togo INF
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_10mths==0 & surveyname=="TOGOINF" & survey=="BL-2013" & control==1
mat help1=`r(N)'
count if survival_10mths==1 & surveyname=="TOGOINF" & survey=="BL-2013" & control==1
mat help1=help1, `r(N)'
count if survival_10mths==. & surveyname=="TOGOINF" & survey=="BL-2013" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="TOGOINF" & survey=="BL-2013" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="TOGOINF" & survey=="BL-2013" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="10 months"

g country="Togo"

g surveyname="TOGOINF"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_10mths_TOGOINF_BL-2013.dta", replace


*Append and calculate average death rates over 1/3 years
use "Preparation of Data for Figures/Data for figures/Comb_uncond_10mths_GHANAFLYP_BL-2008.dta", clear
append using "Preparation of Data for Figures/Data for figures/Comb_uncond_10mths_TOGOINF_BL-2013.dta"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g years=10/12

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_10mths.dta", replace	

********************************************************************************
*Death rates over 11 months
********************************************************************************
*Nigeria YOUWin - BL=2012
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_11mths==0 & surveyname=="NGYOUWIN" & survey=="BL-2012" & control==1
mat help1=`r(N)'
count if survival_11mths==1 & surveyname=="NGYOUWIN" & survey=="BL-2012" & control==1
mat help1=help1, `r(N)'
count if survival_11mths==. & surveyname=="NGYOUWIN" & survey=="BL-2012" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="NGYOUWIN" & survey=="BL-2012" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="NGYOUWIN" & survey=="BL-2012" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="11 months"

g country="Nigeria"

g surveyname="NGYOUWIN"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g years=11/12

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_11mths.dta", replace	

********************************************************************************
*Death rates over 1 year
********************************************************************************
*Thailand - BL=1997-2013
*Kenya GETAHEAD - BL=2013
*Sri Lanka SLLSE - BL=2008
*SLK Female Business Training - BL=2009 
*SLMS - BL=2005
*MALAWIFORM - BL=2012

foreach x in BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 R-2007 R-2008 R-2009 R-2010 R-2011 R-2012 R-2013{
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_1yr==0 & country=="Thailand" & survey=="`x'"
mat help1=`r(N)'
count if survival_1yr==1 & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
count if survival_1yr==. & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
su pcGDP if country=="Thailand" & survey=="`x'"
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if country=="Thailand" & survey=="`x'"
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="1 year"

g country="Thailand"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_`x'.dta", replace
}

*Kenya GETAHEAD - BL=2013
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_1yr==0 & surveyname=="KENYAGETAHEAD" & survey=="BL-2013" & control==1
mat help1=`r(N)'
count if survival_1yr==1 & surveyname=="KENYAGETAHEAD" & survey=="BL-2013" & control==1
mat help1=help1, `r(N)'
count if survival_1yr==. & surveyname=="KENYAGETAHEAD" & survey=="BL-2013" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="KENYAGETAHEAD" & survey=="BL-2013" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="KENYAGETAHEAD" & survey=="BL-2013" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="1 year"

g country="Kenya"

g surveyname="KENYAGETAHEAD"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

save "Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_KENYAGETAHEAD_BL-2013.dta", replace

*Sri Lanka SLLSE - BL=2008
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_1yr==0 & surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat help1=`r(N)'
count if survival_1yr==1 & surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
count if survival_1yr==. & surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="1 year"

g country="Sri Lanka"

g surveyname="SLLSE"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

save "Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_SLLSE_BL-2008.dta", replace

*SLK Female Business Training - BL=2009 
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_1yr==0 & surveyname=="SLKFEMBUSTRAINING" & survey=="BL-2009" & control==1
mat help1=`r(N)'
count if survival_1yr==1 & surveyname=="SLKFEMBUSTRAINING" & survey=="BL-2009" & control==1
mat help1=help1, `r(N)'
count if survival_1yr==. & surveyname=="SLKFEMBUSTRAINING" & survey=="BL-2009" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="SLKFEMBUSTRAINING" & survey=="BL-2009" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="SLKFEMBUSTRAINING" & survey=="BL-2009" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="1 year"

g country="Sri Lanka"

g surveyname="SLKFEMBUSTRAINING"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

save "Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_SLKFEMBUSTRAINING_BL-2009.dta", replace

*SLMS - BL=2005 
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_1yr==0 & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=`r(N)'
count if survival_1yr==1 & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=help1, `r(N)'
count if survival_1yr==. & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="SLMS" & survey=="BL-2005" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)'
su Grate if surveyname=="SLMS" & survey=="BL-2005" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="1 year"

g country="Sri Lanka"

g surveyname="SLMS"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

save "Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_SLMS_BL-2005.dta", replace

*MALAWIFORM - BL=2012
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_1yr==0 & surveyname=="MALAWIFORM" & survey=="BL-2012" & control==1
mat help1=`r(N)'
count if survival_1yr==1 & surveyname=="MALAWIFORM" & survey=="BL-2012" & control==1
mat help1=help1, `r(N)'
count if survival_1yr==. & surveyname=="MALAWIFORM" & survey=="BL-2012" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="MALAWIFORM" & survey=="BL-2012" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="MALAWIFORM" & survey=="BL-2012" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="1 year"

g country="Malawi"

g surveyname="MALAWIFORM"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

save "Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_MALAWIFORM_BL-2012.dta", replace

*Append and calculate average death rates over 1 year
use "Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_BL-1997.dta", clear
append using	"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-1998.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-1999.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-2000.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-2001.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-2002.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-2003.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-2004.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-2005.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-2006.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-2007.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-2008.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-2009.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-2010.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-2011.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-2012.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-2013.dta" 


g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate GDPpc GDPgrowthrate (first) period country

append using	"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_KENYAGETAHEAD_BL-2013.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_SLLSE_BL-2008.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_SLKFEMBUSTRAINING_BL-2009.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_SLMS_BL-2005.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_MALAWIFORM_BL-2012.dta"

g years=1

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_1yr.dta", replace	

********************************************************************************
*Death rates over 1 year and 1 month
********************************************************************************
*Ghana FLYP - BL=2008 
*BENINFORM - BL=2014

*Ghana FLYP
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_1p083yrs==0 & surveyname=="GHANAFLYP" & survey=="BL-2008" & control==1
mat help1=`r(N)'
count if survival_1p083yrs==1 & surveyname=="GHANAFLYP" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
count if survival_1p083yrs==. & surveyname=="GHANAFLYP" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="GHANAFLYP" & survey=="BL-2008" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)'
su Grate if surveyname=="GHANAFLYP" & survey=="BL-2008" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="1 year and 1 month"

g country="Ghana"

g surveyname="GHANAFLYP"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_13mths_GHANAFLYP_BL-2008.dta", replace

*BENINFORM
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_1p083yrs==0 & surveyname=="BENINFORM" & survey=="BL-2014" & control==1
mat help1=`r(N)'
count if survival_1p083yrs==1 & surveyname=="BENINFORM" & survey=="BL-2014" & control==1
mat help1=help1, `r(N)'
count if survival_1p083yrs==. & surveyname=="BENINFORM" & survey=="BL-2014" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="BENINFORM" & survey=="BL-2014" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="BENINFORM" & survey=="BL-2014" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="1 year and 1 month"

g country="Benin"

g surveyname="BENINFORM"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_13mths_BENINFORM_BL-2014.dta", replace


*Append and calculate average death rates over 1/3 years
use "Preparation of Data for Figures/Data for figures/Comb_uncond_13mths_GHANAFLYP_BL-2008.dta", clear
append using "Preparation of Data for Figures/Data for figures/Comb_uncond_13mths_BENINFORM_BL-2014.dta"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g years=13/12

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_13mths.dta", replace	

********************************************************************************
*Death rates over 1 year and 2 months
********************************************************************************
*Togo INF - BL=2008 

use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_1p167yrs==0 & surveyname=="TOGOINF" & survey=="BL-2013" & control==1
mat help1=`r(N)'
count if survival_1p167yrs==1 & surveyname=="TOGOINF" & survey=="BL-2013" & control==1
mat help1=help1, `r(N)'
count if survival_1p167yrs==. & surveyname=="TOGOINF" & survey=="BL-2013" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="TOGOINF" & survey=="BL-2013" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="TOGOINF" & survey=="BL-2013" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="1 year and 2 months"

g country="Togo"

g surveyname="TOGOINF"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g years=14/12

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_14mths.dta", replace

********************************************************************************
*Death rates over 1.25 years
********************************************************************************
*SLMS - BL=2005

use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_1p25yrs==0 & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=`r(N)'
count if survival_1p25yrs==1 & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=help1, `r(N)'
count if survival_1p25yrs==. & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="SLMS" & survey=="BL-2005" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="SLMS" & survey=="BL-2005" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="1 year and 3 months"

g country="Sri Lanka"

g surveyname="SLMS"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g years=1.25

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_1p25yrs.dta", replace	

********************************************************************************
*Death rates over 1 year and 4 months
********************************************************************************
*Ghana FLYP - BL=2008 

use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_1p33yrs==0 & surveyname=="GHANAFLYP" & survey=="BL-2008" & control==1
mat help1=`r(N)'
count if survival_1p33yrs==1 & surveyname=="GHANAFLYP" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
count if survival_1p33yrs==. & surveyname=="GHANAFLYP" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="GHANAFLYP" & survey=="BL-2008" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)'
su Grate if surveyname=="GHANAFLYP" & survey=="BL-2008" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="1 year and 4 months"

g country="Ghana"

g surveyname="GHANAFLYP"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g years=16/12

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_16mths.dta", replace

********************************************************************************
*Death rates over 1.5 years
********************************************************************************
*Nigeria - BL=2011
*Uganda - BL=2009
*SLLSE - BL=2008
*SLMS - BL=2005

*Nigeria
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_18mths==0 & country=="Nigeria" & survey=="R-2011"
mat help1=`r(N)'
count if survival_18mths==1 & country=="Nigeria" & survey=="R-2011"
mat help1=help1, `r(N)'
count if survival_18mths==. & country=="Nigeria" & survey=="R-2011"
mat help1=help1, `r(N)'
su pcGDP if country=="Nigeria" & survey=="R-2011"
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if country=="Nigeria" & survey=="R-2011"
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="1 year and 6 months"

g country="Nigeria"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

save "Preparation of Data for Figures/Data for figures/Comb_uncond_18mths_NG_R-2011.dta", replace


*Uganda
/*Since we do not observe enterprises from one round to another, we cannot compute
 attrition bounds in the way we computed them for IFLS and MXFLS.
 
 In order to compute attrition bounds, I need to make two assumptions:
 (1) All enterprises that attrited or have missing values, started a firm, and
 (2) these firms either survived or died.
 */
 
*Somehow survival has been coded zero if hhbus==0, so I need to only use obs with either hhbus=1 or hhbus=. for attrition in the later case
 
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear

count if survival_18mths==0 & country=="Uganda" & survey=="BL-2009" & hhbus==1 & control==1
mat help1=`r(N)'
count if survival_18mths==1 & country=="Uganda" & survey=="BL-2009" & hhbus==1 & control==1
mat help1=help1, `r(N)'
count if survival_18mths==. & country=="Uganda" & survey=="BL-2009" & hhbus==. & control==1
mat help1=help1, `r(N)'
su pcGDP if country=="Uganda" & survey=="BL-2009" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if country=="Uganda" & survey=="BL-2009" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="1 year and 6 months"

g country="Uganda"
g surveyname="UGWINGS"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

save "Preparation of Data for Figures/Data for figures/Comb_uncond_18mths_UG_BL-2009.dta", replace


*Sri Lanka SLLSE - BL=2008
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_18mths==0 & surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat help1=`r(N)'
count if survival_18mths==1 & surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
count if survival_18mths==. & surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="1 year and 6 months"

g country="Sri Lanka"

g surveyname="SLLSE"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

save "Preparation of Data for Figures/Data for figures/Comb_uncond_18mths_SLLSE_BL-2008.dta", replace

*Sri Lanka SLMS - BL=2005
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_18mths==0 & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=`r(N)'
count if survival_18mths==1 & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=help1, `r(N)'
count if survival_18mths==. & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="SLMS" & survey=="BL-2005" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="SLMS" & survey=="BL-2005" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="1 year and 6 months"

g country="Sri Lanka"

g surveyname="SLMS"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

save "Preparation of Data for Figures/Data for figures/Comb_uncond_18mths_SLMS_BL-2005.dta", replace

*Append and calculate average death rates over 1.5 years
use "Preparation of Data for Figures/Data for figures/Comb_uncond_18mths_UG_BL-2009.dta"

append using "Preparation of Data for Figures/Data for figures/Comb_uncond_18mths_NG_R-2011.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_18mths_SLLSE_BL-2008.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_18mths_SLMS_BL-2005.dta"

g years=1.5

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_1p5yrs.dta", replace	

********************************************************************************
*Death rates over 1 year and 8 months
********************************************************************************
*SLKINFORMALITY - BL=2008

use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_1yr8mths==0 & surveyname=="SLKINFORMALITY" & survey=="BL-2008" & control==1
mat help1=`r(N)'
count if survival_1yr8mths==1 & surveyname=="SLKINFORMALITY" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
count if survival_1yr8mths==. & surveyname=="SLKINFORMALITY" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="SLKINFORMALITY" & survey=="BL-2008" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="SLKINFORMALITY" & survey=="BL-2008" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="1 year and 8 months"

g country="Sri Lanka"

g surveyname="SLKINFORMALITY"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g years=20/12

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_20mths.dta", replace	

********************************************************************************
*Death rates over 1.75 years
********************************************************************************
*SLK Female Business Training - BL=2009 
*SLMS - BL=2005

*SLK Female Business Training
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_1p75yrs==0 & surveyname=="SLKFEMBUSTRAINING" & survey=="BL-2009" & control==1
mat help1=`r(N)'
count if survival_1p75yrs==1 & surveyname=="SLKFEMBUSTRAINING" & survey=="BL-2009" & control==1
mat help1=help1, `r(N)'
count if survival_1p75yrs==. & surveyname=="SLKFEMBUSTRAINING" & survey=="BL-2009" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="SLKFEMBUSTRAINING" & survey=="BL-2009" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="SLKFEMBUSTRAINING" & survey=="BL-2009" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="1 year and 9 months"

g country="Sri Lanka"

g surveyname="SLKFEMBUSTRAINING"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

save "Preparation of Data for Figures/Data for figures/Comb_uncond_1p75yrs_SLKFEMBUSTRAINING_BL-2009.dta", replace

*SLMS - BL=2005 
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_1p75yrs==0 & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=`r(N)'
count if survival_1p75yrs==1 & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=help1, `r(N)'
count if survival_1p75yrs==. & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="SLMS" & survey=="BL-2005" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="SLMS" & survey=="BL-2005" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="1 year and 9 months"

g country="Sri Lanka"

g surveyname="SLMS"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

save "Preparation of Data for Figures/Data for figures/Comb_uncond_1p75yrs_SLMS_BL-2005.dta", replace

append using "Preparation of Data for Figures/Data for figures/Comb_uncond_1p75yrs_SLKFEMBUSTRAINING_BL-2009.dta"

g years=1.75

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_1p75yrs.dta", replace

********************************************************************************
*Death rates over 1 year and 10 months
********************************************************************************
*MALAWIFORM - BL=2012
*Togo Inf -  BL=2013 
*Nigeria YOUWIND - BL=2012

*MALAWIFORM
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_1p833yrs==0 & surveyname=="MALAWIFORM" & survey=="BL-2012" & control==1
mat help1=`r(N)'
count if survival_1p833yrs==1 & surveyname=="MALAWIFORM" & survey=="BL-2012" & control==1
mat help1=help1, `r(N)'
count if survival_1p833yrs==. & surveyname=="MALAWIFORM" & survey=="BL-2012" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="MALAWIFORM" & survey=="BL-2012" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="MALAWIFORM" & survey=="BL-2012" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="1 year and 10 months"

g country="Malawi"

g surveyname="MALAWIFORM"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_22mths_MALAWIFORM_BL-2012.dta", replace

*Togo INF
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_1p833yrs==0 & surveyname=="TOGOINF" & survey=="BL-2013" & control==1
mat help1=`r(N)'
count if survival_1p833yrs==1 & surveyname=="TOGOINF" & survey=="BL-2013" & control==1
mat help1=help1, `r(N)'
count if survival_1p833yrs==. & surveyname=="TOGOINF" & survey=="BL-2013" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="TOGOINF" & survey=="BL-2013" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="TOGOINF" & survey=="BL-2013" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="1 year and 10 months"

g country="Togo"

g surveyname="TOGOINF"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_22mths_TOGOINF_BL-2013.dta", replace

*Nigeria YOUWIN
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_1p833yrs==0 & surveyname=="NGYOUWIN" & survey=="BL-2012" & control==1
mat help1=`r(N)'
count if survival_1p833yrs==1 & surveyname=="NGYOUWIN" & survey=="BL-2012" & control==1
mat help1=help1, `r(N)'
count if survival_1p833yrs==. & surveyname=="NGYOUWIN" & survey=="BL-2012" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="NGYOUWIN" & survey=="BL-2012" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="NGYOUWIN" & survey=="BL-2012" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="1 year and 10 months"

g country="Nigeria"

g surveyname="NGYOUWIN"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_22mths_NGYOUWIN_BL-2012.dta", replace

append using	"Preparation of Data for Figures/Data for figures/Comb_uncond_22mths_MALAWIFORM_BL-2012.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_22mths_TOGOINF_BL-2013.dta"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g years=22/12

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_22mths.dta", replace

********************************************************************************
*Death rates over 2 years
********************************************************************************
*Thailand - BL=1997-2012
*Nigeria - BL=2010, 2011
*SLLSE - BL=2008
*SLMS - BL=2005

*Thailand
foreach x in BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 R-2007 R-2008 R-2009 R-2010 R-2011 R-2012 {
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_2yrs==0 & country=="Thailand" & survey=="`x'"
mat help1=`r(N)'
count if survival_2yrs==1 & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
count if survival_2yrs==. & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
su pcGDP if country=="Thailand" & survey=="`x'"
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)'
su Grate if country=="Thailand" & survey=="`x'"
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="2 years"

g country="Thailand"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_`x'.dta", replace
}

*Nigeria
foreach x in BL-2010 R-2011 {
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_2yrs==0 & country=="Nigeria" & survey=="`x'"
mat help1=`r(N)'
count if survival_2yrs==1 & country=="Nigeria" & survey=="`x'"
mat help1=help1, `r(N)'
count if survival_2yrs==. & country=="Nigeria" & survey=="`x'"
mat help1=help1, `r(N)'
su pcGDP if country=="Nigeria" & survey=="`x'"
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if country=="Nigeria" & survey=="`x'"
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="2 years"

g country="Nigeria"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_NG_`x'.dta", replace
}

*Sri Lanka SLLSE - BL=2008
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_2yrs==0 & surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat help1=`r(N)'
count if survival_2yrs==1 & surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
count if survival_2yrs==. & surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="2 years"

g country="Sri Lanka"

g surveyname="SLLSE"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

save "Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_SLLSE_BL-2008.dta", replace

*SLMS
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_2yrs==0 & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=`r(N)'
count if survival_2yrs==1 & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=help1, `r(N)'
count if survival_2yrs==. & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="SLMS" & survey=="BL-2005" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="SLMS" & survey=="BL-2005" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="2 years"

g country="Sri Lanka"

g surveyname="SLMS"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

save "Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_SLMS_BL-2005.dta", replace

*Append and calculate average death rates over 2 years
use "Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_BL-1997.dta", clear
append using	"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-1998.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-1999.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-2000.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-2001.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-2002.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-2003.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-2004.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-2005.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-2006.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-2007.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-2008.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-2009.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-2010.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-2011.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-2012.dta"


g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate GDPpc GDPgrowthrate (first) period country

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_2yrs_THL.dta", replace	

use "Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_NG_BL-2010.dta", clear
append using	"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_NG_R-2011.dta" 

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate GDPpc GDPgrowthrate (first) period country

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_2yrs_NG.dta", replace	

append using	"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_2yrs_THL.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_SLLSE_BL-2008.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_SLMS_BL-2005.dta"

g years=2

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_2yrs.dta", replace	

********************************************************************************
*Death rates over 2 years and 2 months
********************************************************************************
*BENINFORM - BL=2014

use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_2p167yrs==0 & surveyname=="BENINFORM" & survey=="BL-2014" & control==1
mat help1=`r(N)'
count if survival_2p167yrs==1 & surveyname=="BENINFORM" & survey=="BL-2014" & control==1
mat help1=help1, `r(N)'
count if survival_2p167yrs==. & surveyname=="BENINFORM" & survey=="BL-2014" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="BENINFORM" & survey=="BL-2014" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)'
su Grate if surveyname=="BENINFORM" & survey=="BL-2014" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="2 years and 2 months"

g country="Benin"

g surveyname="BENINFORM"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g years=26/12

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_26mths.dta", replace

********************************************************************************
*Death rates over 2.25 years
********************************************************************************
*SLKINFORMALITY - BL=2008

use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_2p25yrs==0 & surveyname=="SLKINFORMALITY" & survey=="BL-2008" & control==1
mat help1=`r(N)'
count if survival_2p25yrs==1 & surveyname=="SLKINFORMALITY" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
count if survival_2p25yrs==. & surveyname=="SLKINFORMALITY" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="SLKINFORMALITY" & survey=="BL-2008" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="SLKINFORMALITY" & survey=="BL-2008" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="2 years and 4 months"

g country="Sri Lanka"

g surveyname="SLKINFORMALITY"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g years=2.25

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_2p25yrs.dta", replace	

********************************************************************************
*Death rates over 2.5 years
********************************************************************************
*Nigeria - BL=2010
*Kenya GETAHEAD - BL=2013
*Sri Lanka SLLSE - BL=2008
*SLMS - BL=2005

*Nigeria
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_30mths==0 & country=="Nigeria" & survey=="BL-2010"
mat help1=`r(N)'
count if survival_30mths==1 & country=="Nigeria" & survey=="BL-2010"
mat help1=help1, `r(N)'
count if survival_30mths==. & country=="Nigeria" & survey=="BL-2010"
mat help1=help1, `r(N)'
su pcGDP if country=="Nigeria" & survey=="BL-2010"
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if country=="Nigeria" & survey=="BL-2010"
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="2 years and 6 months"

g country="Nigeria"

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_2p5yrs_NG_BL-2010.dta", replace

*Kenya GETAHEAD - BL=2013
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_30mths==0 & surveyname=="KENYAGETAHEAD" & survey=="BL-2013" & control==1
mat help1=`r(N)'
count if survival_30mths==1 & surveyname=="KENYAGETAHEAD" & survey=="BL-2013" & control==1
mat help1=help1, `r(N)'
count if survival_30mths==. & surveyname=="KENYAGETAHEAD" & survey=="BL-2013" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="KENYAGETAHEAD" & survey=="BL-2013" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="KENYAGETAHEAD" & survey=="BL-2013" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="2 years and 6 months"

g country="Kenya"

g surveyname="KENYAGETAHEAD"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_2p5yrs_KENYAGETAHEAD_BL-2013.dta", replace

*Sri Lanka SLLSE - BL=2008
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_30mths==0 & surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat help1=`r(N)'
count if survival_30mths==1 & surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
count if survival_30mths==. & surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="2 years and 6 months"

g country="Sri Lanka"

g surveyname="SLLSE"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_2p5yrs_SLLSE_BL-2008.dta", replace

*SLMS
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_30mths==0 & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=`r(N)'
count if survival_30mths==1 & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=help1, `r(N)'
count if survival_30mths==. & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="SLMS" & survey=="BL-2005" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)'
su Grate if surveyname=="SLMS" & survey=="BL-2005" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="2 years and 6 months"

g country="Sri Lanka"

g surveyname="SLMS"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_2p5yrs_SLMS_BL-2005.dta", replace

append using	"Preparation of Data for Figures/Data for figures/Comb_uncond_2p5yrs_SLLSE_BL-2008.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_2p5yrs_KENYAGETAHEAD_BL-2013.dta" ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_2p5yrs_NG_BL-2010.dta"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g years=2.5

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_2p5yrs.dta", replace

********************************************************************************
*Death rates over 2 years and 10 months
********************************************************************************
*Togo INF - BL=2008 

use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_2p833yrs==0 & surveyname=="TOGOINF" & survey=="BL-2013" & control==1
mat help1=`r(N)'
count if survival_2p833yrs==1 & surveyname=="TOGOINF" & survey=="BL-2013" & control==1
mat help1=help1, `r(N)'
count if survival_2p833yrs==. & surveyname=="TOGOINF" & survey=="BL-2013" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="TOGOINF" & survey=="BL-2013" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="TOGOINF" & survey=="BL-2013" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="2 years and 10 months"

g country="Togo"

g surveyname="TOGOINF"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g years=34/12

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_34mths.dta", replace

********************************************************************************
*Death rates over 2 years and 11 months
********************************************************************************
*MALAWIFORM - BL=2012

use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_2p9167yrs==0 & surveyname=="MALAWIFORM" & survey=="BL-2012" & control==1
mat help1=`r(N)'
count if survival_2p9167yrs==1 & surveyname=="MALAWIFORM" & survey=="BL-2012" & control==1
mat help1=help1, `r(N)'
count if survival_2p9167yrs==. & surveyname=="MALAWIFORM" & survey=="BL-2012" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="MALAWIFORM" & survey=="BL-2012" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)'
su Grate if surveyname=="MALAWIFORM" & survey=="BL-2012" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="2 years and 11 months"

g country="Malawi"

g surveyname="MALAWIFORM"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g years=35/12

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_35mths.dta", replace

********************************************************************************
*Death rates over 3 years
********************************************************************************
*Thailand - BL=1997-2011
*Mexico - BL=2002
*Sri Lanka SLLSE - BL=2008
*SLMS - BL=2005
*SKLINFORMALITY - BL=2008

*Thailand
foreach x in BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 R-2007 R-2008 R-2009 R-2010 R-2011 {
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_3yrs==0 & country=="Thailand" & survey=="`x'"
mat help1=`r(N)'
count if survival_3yrs==1 & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
count if survival_3yrs==. & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
su pcGDP if country=="Thailand" & survey=="`x'"
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if country=="Thailand" & survey=="`x'"
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="3 years"

g country="Thailand"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_`x'.dta", replace
}

*Mexico
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_3yrs==0 & country=="Mexico" & survey=="BL-2002"
mat help1=`r(N)'
count if survival_3yrs==1 & country=="Mexico" & survey=="BL-2002"
mat help1=help1, `r(N)'
count if survival_3yrs==. & country=="Mexico" & survey=="BL-2002"
mat help1=help1, `r(N)'
su pcGDP if country=="Mexico" & survey=="BL-2002"
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if country=="Mexico" & survey=="BL-2002"
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="3 years"

g country="Mexico"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

save "Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_MX_BL-2002.dta", replace

*Sri Lanka SLLSE
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_3yrs==0 & surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat help1=`r(N)'
count if survival_3yrs==1 & surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
count if survival_3yrs==. & surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="3 years"

g country="Sri Lanka"

g surveyname="SLLSE"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

save "Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_SLLSE_BL-2008.dta", replace

*SLKINFORMALITY
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_3yrs==0 & surveyname=="SLKINFORMALITY" & survey=="BL-2008" & control==1
mat help1=`r(N)'
count if survival_3yrs==1 & surveyname=="SLKINFORMALITY" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
count if survival_3yrs==. & surveyname=="SLKINFORMALITY" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="SLKINFORMALITY" & survey=="BL-2008" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="SLKINFORMALITY" & survey=="BL-2008" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="3 years"

g country="Sri Lanka"

g surveyname="SLKINFORMALITY"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)


save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_3yrs_SLKINFORMALITY_BL-2008.dta", replace	

*SLMS - BL=2005 
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_3yrs==0 & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=`r(N)'
count if survival_3yrs==1 & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=help1, `r(N)'
count if survival_3yrs==. & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=help1, `r(N)'
su pcGDP if surveyname=="SLMS" & survey=="BL-2005" & control==1
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3], `r(mean)' 
su Grate if surveyname=="SLMS" & survey=="BL-2005" & control==1
mat deathrates=deathrates, `r(mean)' 
mat colnames deathrates=died survived missing GDPpc GDPgrowthrate

svmat deathrates, names(col)

keep died-GDPgrowthrate
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="3 years"

g country="Sri Lanka"

g surveyname="SLMS"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

save "Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_SLMS_BL-2005.dta", replace

*Append and calculate average death rates over 3 years
use "Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_BL-1997.dta", clear
append using	"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_R-1998.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_R-1999.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_R-2000.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_R-2001.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_R-2002.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_R-2003.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_R-2004.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_R-2005.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_R-2006.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_R-2007.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_R-2008.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_R-2009.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_R-2010.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_R-2011.dta" 


g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate GDPpc GDPgrowthrate (first) period country

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_3yrs_THL.dta", replace	

append using	"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_MX_BL-2002.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_SLLSE_BL-2008.dta" ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_3yrs_SLKINFORMALITY_BL-2008.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_SLMS_BL-2005.dta"

g years=3

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_3yrs.dta", replace	

********************************************************************************
*Death rates over 3.5 years
********************************************************************************
*MALAWIFORM - BL=2012
*Sri Lanka SLLSE - BL=2008

*MALAWIFORM - BL=2012
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_3p5yrs==0 & surveyname=="MALAWIFORM" & survey=="BL-2012" & control==1
mat help1=`r(N)'
count if survival_3p5yrs==1 & surveyname=="MALAWIFORM" & survey=="BL-2012" & control==1
mat help1=help1, `r(N)'
count if survival_3p5yrs==. & surveyname=="MALAWIFORM" & survey=="BL-2012" & control==1
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="3 years and 6 months"

g country="Malawi"

g surveyname="MALAWIFORM"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_3p5yrs_MALAWIFORM_BL-2012.dta", replace

*Sri Lanka SLLSE
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_3p5yrs==0 & surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat help1=`r(N)'
count if survival_3p5yrs==1 & surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
count if survival_3p5yrs==. & surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="3 years and 6 months"

g country="Sri Lanka"

g surveyname="SLLSE"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_3p5yrs_SLLSE_BL-2008.dta", replace

append using "Preparation of Data for Figures/Data for figures/Comb_uncond_3p5yrs_MALAWIFORM_BL-2012.dta"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g years=3.5

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_3p5yrs.dta", replace

********************************************************************************
*Death rates over 3 years and 8 months
********************************************************************************
*Nigeria YOUWin - BL=2012
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_3p667yrs==0 & surveyname=="NGYOUWIN" & survey=="BL-2012" & control==1
mat help1=`r(N)'
count if survival_3p667yrs==1 & surveyname=="NGYOUWIN" & survey=="BL-2012" & control==1
mat help1=help1, `r(N)'
count if survival_3p667yrs==. & surveyname=="NGYOUWIN" & survey=="BL-2012" & control==1
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="44 months"

g country="Nigeria"

g surveyname="NGYOUWIN"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g years=44/12

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_44mths.dta", replace	

********************************************************************************
*Death rates over 4 years
********************************************************************************
*Thailand - BL=1997-2010
*Sri Lanka SLLSE - BL=2008

*Thailand
foreach x in BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 R-2007 R-2008 R-2009 R-2010{
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_4yrs==0 & country=="Thailand" & survey=="`x'"
mat help1=`r(N)'
count if survival_4yrs==1 & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
count if survival_4yrs==. & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="4 years"

g country="Thailand"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_`x'.dta", replace
}

*Sri Lanka SLLSE
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_4yrs==0 & surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat help1=`r(N)'
count if survival_4yrs==1 & surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
count if survival_4yrs==. & surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="4 years"

g country="Sri Lanka"

g surveyname="SLLSE"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

save "Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_SLLSE_BL-2008.dta", replace


*Append and calculate average death rates over 4 years
use "Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_BL-1997.dta", clear
append using	"Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_R-1998.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_R-1999.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_R-2000.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_R-2001.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_R-2002.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_R-2003.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_R-2004.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_R-2005.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_R-2006.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_R-2007.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_R-2008.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_R-2009.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_R-2010.dta"


g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate (first) period country

append using "Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_SLLSE_BL-2008.dta"

g years=4

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_4yrs.dta", replace	

********************************************************************************
*Death rates over 4.5 years
********************************************************************************
*Mexico - BL=2005
*Sri Lanka SLLSE - BL=2008

use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_4p5yrs==0 & country=="Mexico" & survey=="R-2005"
mat help1=`r(N)'
count if survival_4p5yrs==1 & country=="Mexico" & survey=="R-2005"
mat help1=help1, `r(N)'
count if survival_4p5yrs==. & country=="Mexico" & survey=="R-2005"
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="4 years and 6 months"

g country="Mexico"

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_4p5yrs_MX_BL-2005.dta", replace

*Sri Lanka SLLSE
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_4p5yrs==0 & surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat help1=`r(N)'
count if survival_4p5yrs==1 & surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
count if survival_4p5yrs==. & surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="4 years and 6 months"

g country="Sri Lanka"

g surveyname="SLLSE"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_4p5yrs_SLLSE_BL-2008.dta", replace

append using "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_4p5yrs_MX_BL-2005.dta"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g years=4.5

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_4p5yrs.dta", replace

********************************************************************************
*Death rates over 5 years
********************************************************************************
*Thailand - BL=1997-2009

*Thailand
foreach x in BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 R-2007 R-2008 R-2009{
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_5yrs==0 & country=="Thailand" & survey=="`x'"
mat help1=`r(N)'
count if survival_5yrs==1 & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
count if survival_5yrs==. & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="5 years"

g country="Thailand"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_5yrs_THL_`x'.dta", replace
}

*Append and calculate average death rates over 5 years
use "Preparation of Data for Figures/Data for figures/Comb_uncond_5yrs_THL_BL-1997.dta", clear
append using	"Preparation of Data for Figures/Data for figures/Comb_uncond_5yrs_THL_R-1998.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_5yrs_THL_R-1999.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_5yrs_THL_R-2000.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_5yrs_THL_R-2001.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_5yrs_THL_R-2002.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_5yrs_THL_R-2003.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_5yrs_THL_R-2004.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_5yrs_THL_R-2005.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_5yrs_THL_R-2006.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_5yrs_THL_R-2007.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_5yrs_THL_R-2008.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_5yrs_THL_R-2009.dta" 


g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate (first) period country

g years=5

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_5yrs.dta", replace	

********************************************************************************
*Death rates over 5 years and 2 months
********************************************************************************
*SLMS - BL=2005 

use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_5p17yrs==0 & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=`r(N)'
count if survival_5p17yrs==1 & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=help1, `r(N)'
count if survival_5p17yrs==. & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="5 years and 2 months"

g country="Sri Lanka"

g surveyname="SLMS"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g years=62/12

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_62mths.dta", replace	

********************************************************************************
*Death rates over 5.5 years
********************************************************************************
*Sri Lanka SLLSE - BL=2008

*Sri Lanka SLLSE
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_5p5yrs==0 & surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat help1=`r(N)'
count if survival_5p5yrs==1 & surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
count if survival_5p5yrs==. & surveyname=="SLLSE" & survey=="BL-2008" & control==1
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="5 years and 6 months"

g country="Sri Lanka"

g surveyname="SLLSE"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g years=5.5

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_5p5yrs.dta", replace

********************************************************************************
*Death rates over 5 years and 8 months
********************************************************************************
*SLMS - BL=2005

use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_5p67yrs==0 & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=`r(N)'
count if survival_5p67yrs==1 & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=help1, `r(N)'
count if survival_5p67yrs==. & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="5 years and 8 months"

g country="Sri Lanka"

g surveyname="SLMS"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g years=68/12

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_68mths.dta", replace

********************************************************************************
*Death rates over 5.75 years
********************************************************************************
*Sri Lanka SLLSE - BL=2008

*SLK Female Business Training
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_5p75yrs==0 & surveyname=="SLKFEMBUSTRAINING" & survey=="BL-2009" & control==1
mat help1=`r(N)'
count if survival_5p75yrs==1 & surveyname=="SLKFEMBUSTRAINING" & survey=="BL-2009" & control==1
mat help1=help1, `r(N)'
count if survival_5p75yrs==. & surveyname=="SLKFEMBUSTRAINING" & survey=="BL-2009" & control==1
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="5 years and 9 months"

g country="Sri Lanka"

g surveyname="SLKFEMBUSTRAINING"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g years=5.75

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_5p75yrs.dta", replace

********************************************************************************
*Death rates over 6 years
********************************************************************************
*Thailand - BL=1997-2008

*Thailand
foreach x in BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 R-2007 R-2008 {
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_6yrs==0 & country=="Thailand" & survey=="`x'"
mat help1=`r(N)'
count if survival_6yrs==1 & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
count if survival_6yrs==. & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="6 years"

g country="Thailand"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_6yrs_THL_`x'.dta", replace
}

*Append and calculate average death rates over 6 years
use "Preparation of Data for Figures/Data for figures/Comb_uncond_6yrs_THL_BL-1997.dta", clear
append using	"Preparation of Data for Figures/Data for figures/Comb_uncond_6yrs_THL_R-1998.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_6yrs_THL_R-1999.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_6yrs_THL_R-2000.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_6yrs_THL_R-2001.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_6yrs_THL_R-2002.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_6yrs_THL_R-2003.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_6yrs_THL_R-2004.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_6yrs_THL_R-2005.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_6yrs_THL_R-2006.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_6yrs_THL_R-2007.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_6yrs_THL_R-2008.dta" 


g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate (first) period country

g years=6

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_6yrs.dta", replace	


********************************************************************************
*Death rates over 7 years
********************************************************************************
*Thailand - BL=1997-2007
*Indonesia - BL=2007

*Thailand
foreach x in BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 R-2007{
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_7yrs==0 & country=="Thailand" & survey=="`x'"
mat help1=`r(N)'
count if survival_7yrs==1 & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
count if survival_7yrs==. & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="7 years"

g country="Thailand"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_7yrs_THL_`x'.dta", replace
}

*Indonesia
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_7yrs==0 & country=="Indonesia" & survey=="R-2007"
mat help1=`r(N)'
count if survival_7yrs==1 & country=="Indonesia" & survey=="R-2007"
mat help1=help1, `r(N)'
count if survival_7yrs==. & country=="Indonesia" & survey=="R-2007"
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="7 years"

g country="Indonesia"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

save "Preparation of Data for Figures/Data for figures/Comb_uncond_7yrs_IDN.dta", replace

*Append and calculate average death rates over 7 years
use "Preparation of Data for Figures/Data for figures/Comb_uncond_7yrs_THL_BL-1997.dta", clear
append using	"Preparation of Data for Figures/Data for figures/Comb_uncond_7yrs_THL_R-1998.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_7yrs_THL_R-1999.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_7yrs_THL_R-2000.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_7yrs_THL_R-2001.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_7yrs_THL_R-2002.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_7yrs_THL_R-2003.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_7yrs_THL_R-2004.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_7yrs_THL_R-2005.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_7yrs_THL_R-2006.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_7yrs_THL_R-2007.dta" 


g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate (first) period country

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_7yrs_THL.dta", replace	

append using "Preparation of Data for Figures/Data for figures/Comb_uncond_7yrs_IDN.dta"

g years=7

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_7yrs.dta", replace	

********************************************************************************
*Death rates over 7.5 years
********************************************************************************
*Indonesia - BL=2000
*Mexico - BL=2002

*Indonesia
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_7p5yrs==0 & country=="Indonesia" & survey=="BL-2000"
mat help1=`r(N)'
count if survival_7p5yrs==1 & country=="Indonesia" & survey=="BL-2000"
mat help1=help1, `r(N)'
count if survival_7p5yrs==. & country=="Indonesia" & survey=="BL-2000"
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="7 years and 6 months"

g country="Indonesia"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

save "Preparation of Data for Figures/Data for figures/Comb_uncond_7p5yrs_IDN.dta", replace

*Mexico
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_7p5yrs==0 & country=="Mexico" & survey=="BL-2002"
mat help1=`r(N)'
count if survival_7p5yrs==1 & country=="Mexico" & survey=="BL-2002"
mat help1=help1, `r(N)'
count if survival_7p5yrs==. & country=="Mexico" & survey=="BL-2002"
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="7 years and 6 months"

g country="Mexico"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

save "Preparation of Data for Figures/Data for figures/Comb_uncond_7p5yrs_MX.dta", replace

append using "Preparation of Data for Figures/Data for figures/Comb_uncond_7p5yrs_IDN.dta"

g years=7.5

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_7p5yrs.dta", replace	

********************************************************************************
*Death rates over 8 years
********************************************************************************
*Thailand - BL=1997-2006

foreach x in BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 {
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_8yrs==0 & country=="Thailand" & survey=="`x'"
mat help1=`r(N)'
count if survival_8yrs==1 & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
count if survival_8yrs==. & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="8 years"

g country="Thailand"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_8yrs_THL_`x'.dta", replace
}

*Append and calculate average death rates over 8 years
use "Preparation of Data for Figures/Data for figures/Comb_uncond_8yrs_THL_BL-1997.dta", clear
append using	"Preparation of Data for Figures/Data for figures/Comb_uncond_8yrs_THL_R-1998.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_8yrs_THL_R-1999.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_8yrs_THL_R-2000.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_8yrs_THL_R-2001.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_8yrs_THL_R-2002.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_8yrs_THL_R-2003.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_8yrs_THL_R-2004.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_8yrs_THL_R-2005.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_8yrs_THL_R-2006.dta"


g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate (first) period country

g years=8

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_8yrs.dta", replace	

********************************************************************************
*Death rates over 9 years
********************************************************************************
*Thailand - BL=1997-2005

foreach x in BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 {
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_9yrs==0 & country=="Thailand" & survey=="`x'"
mat help1=`r(N)'
count if survival_9yrs==1 & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
count if survival_9yrs==. & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="9 years"

g country="Thailand"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_9yrs_THL_`x'.dta", replace
}

*Append and calculate average death rates over 9 years
use "Preparation of Data for Figures/Data for figures/Comb_uncond_9yrs_THL_BL-1997.dta", clear
append using	"Preparation of Data for Figures/Data for figures/Comb_uncond_9yrs_THL_R-1998.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_9yrs_THL_R-1999.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_9yrs_THL_R-2000.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_9yrs_THL_R-2001.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_9yrs_THL_R-2002.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_9yrs_THL_R-2003.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_9yrs_THL_R-2004.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_9yrs_THL_R-2005.dta"


g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate (first) period country

g years=9

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_9yrs.dta", replace	

********************************************************************************
*Death rates over 10 years
********************************************************************************
*Thailand - BL=1997-2004

foreach x in BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 {
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_10yrs==0 & country=="Thailand" & survey=="`x'"
mat help1=`r(N)'
count if survival_10yrs==1 & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
count if survival_10yrs==. & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="10 years"

g country="Thailand"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_10yrs_THL_`x'.dta", replace
}

*Append and calculate average death rates over 10 years
use "Preparation of Data for Figures/Data for figures/Comb_uncond_10yrs_THL_BL-1997.dta", clear
append using	"Preparation of Data for Figures/Data for figures/Comb_uncond_10yrs_THL_R-1998.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_10yrs_THL_R-1999.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_10yrs_THL_R-2000.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_10yrs_THL_R-2001.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_10yrs_THL_R-2002.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_10yrs_THL_R-2003.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_10yrs_THL_R-2004.dta"


g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate (first) period country

g years=10

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_10yrs.dta", replace	

********************************************************************************
*Death rates over 10 years and 5 months
********************************************************************************
*SLMS - BL=2005

use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_10p416yrs==0 & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=`r(N)'
count if survival_10p416yrs==1 & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=help1, `r(N)'
count if survival_10p416yrs==. & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="10 years and 5 months"

g country="Sri Lanka"

g surveyname="SLMS"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g years=125/12

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_125mths.dta", replace	

********************************************************************************
*Death rates over 10 years and 11 months
********************************************************************************
*SLMS - BL=2005

use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_10p916yrs==0 & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=`r(N)'
count if survival_10p916yrs==1 & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=help1, `r(N)'
count if survival_10p916yrs==. & surveyname=="SLMS" & survey=="BL-2005" & control==1
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="10 years and 11 months"

g country="Sri Lanka"

g surveyname="SLMS"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g years=131/12

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_131mths.dta", replace	

********************************************************************************
*Death rates over 11 years
********************************************************************************
*Thailand - BL=1997-2003

foreach x in BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 {
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_11yrs==0 & country=="Thailand" & survey=="`x'"
mat help1=`r(N)'
count if survival_11yrs==1 & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
count if survival_11yrs==. & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="11 years"

g country="Thailand"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_11yrs_THL_`x'.dta", replace
}

*Append and calculate average death rates over 11 years
use "Preparation of Data for Figures/Data for figures/Comb_uncond_11yrs_THL_BL-1997.dta", clear
append using	"Preparation of Data for Figures/Data for figures/Comb_uncond_11yrs_THL_R-1998.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_11yrs_THL_R-1999.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_11yrs_THL_R-2000.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_11yrs_THL_R-2001.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_11yrs_THL_R-2002.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_11yrs_THL_R-2003.dta" 


g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate (first) period country

g years=11

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_11yrs.dta", replace	

********************************************************************************
*Death rates over 12 years
********************************************************************************
*Thailand - BL=1997-2002

foreach x in BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 {
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_12yrs==0 & country=="Thailand" & survey=="`x'"
mat help1=`r(N)'
count if survival_12yrs==1 & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
count if survival_12yrs==. & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="12 years"

g country="Thailand"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_12yrs_THL_`x'.dta", replace
}


*Append and calculate average death rates over 12 years
use "Preparation of Data for Figures/Data for figures/Comb_uncond_12yrs_THL_BL-1997.dta", clear
append using	"Preparation of Data for Figures/Data for figures/Comb_uncond_12yrs_THL_R-1998.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_12yrs_THL_R-1999.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_12yrs_THL_R-2000.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_12yrs_THL_R-2001.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_12yrs_THL_R-2002.dta" 


g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate (first) period country

g years=12

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_12yrs.dta", replace	

********************************************************************************
*Death rates over 13 years
********************************************************************************
*Thailand - BL=1997-2001

foreach x in BL-1997 R-1998 R-1999 R-2000 R-2001 {
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_13yrs==0 & country=="Thailand" & survey=="`x'"
mat help1=`r(N)'
count if survival_13yrs==1 & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
count if survival_13yrs==. & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="13 years"

g country="Thailand"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_13yrs_THL_`x'.dta", replace
}


*Append and calculate average death rates over 13 years
use "Preparation of Data for Figures/Data for figures/Comb_uncond_13yrs_THL_BL-1997.dta", clear
append using	"Preparation of Data for Figures/Data for figures/Comb_uncond_13yrs_THL_R-1998.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_13yrs_THL_R-1999.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_13yrs_THL_R-2000.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_13yrs_THL_R-2001.dta" 


g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate (first) period country

g years=13

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_13yrs.dta", replace	

********************************************************************************
*Death rates over 14 years
********************************************************************************
*Thailand - BL=1997-2000

foreach x in BL-1997 R-1998 R-1999 R-2000 {
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_14yrs==0 & country=="Thailand" & survey=="`x'"
mat help1=`r(N)'
count if survival_14yrs==1 & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
count if survival_14yrs==. & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="14 years"

g country="Thailand"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_14yrs_THL_`x'.dta", replace
}

*Append and calculate average death rates over 14 years
use "Preparation of Data for Figures/Data for figures/Comb_uncond_14yrs_THL_BL-1997.dta", clear
append using	"Preparation of Data for Figures/Data for figures/Comb_uncond_14yrs_THL_R-1998.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_14yrs_THL_R-1999.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_14yrs_THL_R-2000.dta" 


g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate (first) period country

g years=14

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_14yrs.dta", replace	

********************************************************************************
*Death rates over 14.5 years
********************************************************************************
*Indonesia - BL=2000

use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_14p5yrs==0 & country=="Indonesia" & survey=="BL-2000"
mat help1=`r(N)'
count if survival_14p5yrs==1 & country=="Indonesia" & survey=="BL-2000"
mat help1=help1, `r(N)'
count if survival_14p5yrs==. & country=="Indonesia" & survey=="BL-2000"
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="14 years and 6 months"

g country="Indonesia"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g years=14.5

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_14p5yrs.dta", replace


********************************************************************************
*Death rates over 15 years
********************************************************************************
*Thailand - BL=1997-1999

foreach x in BL-1997 R-1998 R-1999 {
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_15yrs==0 & country=="Thailand" & survey=="`x'"
mat help1=`r(N)'
count if survival_15yrs==1 & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
count if survival_15yrs==. & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="15 years"

g country="Thailand"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_15yrs_THL_`x'.dta", replace
}


*Append and calculate average death rates over 15 years
use "Preparation of Data for Figures/Data for figures/Comb_uncond_15yrs_THL_BL-1997.dta", clear
append using	"Preparation of Data for Figures/Data for figures/Comb_uncond_15yrs_THL_R-1998.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_uncond_15yrs_THL_R-1999.dta" 


g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate (first) period country

g years=15

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_15yrs.dta", replace	

********************************************************************************
*Death rates over 16 years
********************************************************************************
*Thailand - BL=1997, 1998

foreach x in BL-1997 R-1998 {
use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_16yrs==0 & country=="Thailand" & survey=="`x'"
mat help1=`r(N)'
count if survival_16yrs==1 & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
count if survival_16yrs==. & country=="Thailand" & survey=="`x'"
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="16 years"

g country="Thailand"

save "Preparation of Data for Figures/Data for figures/Comb_uncond_16yrs_THL_`x'.dta", replace
}

*Append and calculate average death rates over 16 years
use "Preparation of Data for Figures/Data for figures/Comb_uncond_16yrs_THL_BL-1997.dta", clear
append using	"Preparation of Data for Figures/Data for figures/Comb_uncond_16yrs_THL_R-1998.dta" 

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate (first) period country

g years=16

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_16yrs.dta", replace	

********************************************************************************
*Death rates over 17 years
********************************************************************************
*Thailand - BL=1997

use "Construction of Dataset/Data for combination/CombinedMaster.dta", clear
count if survival_17yrs==0 & country=="Thailand" & survey=="BL-1997"
mat help1=`r(N)'
count if survival_17yrs==1 & country=="Thailand" & survey=="BL-1997"
mat help1=help1, `r(N)'
count if survival_17yrs==. & country=="Thailand" & survey=="BL-1997"
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="17 years"

g country="Thailand"

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g years=17

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_17yrs.dta", replace


********************************************************************************
*Death rates for rounded horizons:
/*We want to measure death rates over horizons in 0.25 steps from 0-2 years,
	in 0.5 year steps from 2-6 years and in 1 year steps for 6 years and more*/
********************************************************************************
 
use 			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_3mths.dta", clear
append using 	"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_4mths.dta" 
replace period="3 months"
replace years=0.25
save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_3mths_RH.dta", replace

use				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_0p5yrs.dta", clear 	/*6mths*/
append using 	"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_7mths.dta"
replace period="6 months"
replace years=0.5
save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_6mths_RH.dta", replace

use				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_9mths.dta", clear
append using	"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_10mths.dta"
replace period="9 months"
replace years=0.75
save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_9mths_RH.dta", replace

use				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_11mths.dta", clear
append using	"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_1yr.dta" ///		/*12mths*/
				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_13mths.dta" 
replace period="1 year"
replace years=1
save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_1yr_RH.dta", replace

use				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_14mths.dta", clear
append using	"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_1p25yrs.dta" ///	/*15mths*/
				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_16mths.dta"
replace period="1 year and 3 months"
replace years=1.25
save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_1p25yrs_RH.dta", replace		
	
use				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_1p5yrs.dta", clear	/*18mths*/
save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_1p5yrs_RH.dta", replace		

use				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_20mths.dta", clear
append using	"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_1p75yrs.dta" ///	/*21mths*/
				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_22mths.dta"
replace period="1 year and 9 months"
replace years=1.75
save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_1p75yrs_RH.dta", replace	
				
use				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_2yrs.dta", clear		/*24mths*/
append using	"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_26mths.dta"
replace period="2 years"
replace years=2
save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_2yrs_RH.dta", replace	
				
use				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_2p25yrs.dta", clear 	/*27mths*/
append using	"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_2p5yrs.dta"			/*30mths*/
replace period="2 years and 6 months"
replace years=2.5
save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_2p5yrs_RH.dta", replace	

use				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_34mths.dta", clear 
append using	"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_35mths.dta" ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_3yrs.dta" 			/*36mths*/
replace period="3 years"
replace years=3
save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_3yrs_RH.dta", replace					
				
use				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_3p5yrs.dta", clear /*42mths*/
append using	"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_44mths.dta"
replace period="3 years and six months"
replace years=3.5
save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_3p5yrs_RH.dta", replace					
				
use				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_4yrs.dta", clear	/*48mths*/
save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_4yrs_RH.dta", replace					

use				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_4p5yrs.dta", clear	/*54mths*/
save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_4p5yrs_RH.dta", replace					

use				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_5yrs.dta", clear	/*60mths*/
append using	"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_62mths.dta"
replace period="5 years"
replace years=5
save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_5yrs_RH.dta", replace

use				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_5p5yrs.dta", clear	/*66mths*/
append using	"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_68mths.dta"
replace period="5 years and 6 months"
replace years=5.5
save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_5p5yrs_RH.dta", replace

use				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_5p75yrs.dta", clear	/*69mths*/
append using	"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_6yrs.dta"
replace period="6 years"
replace years=6
save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_6yrs_RH.dta", replace
		
use				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_7yrs.dta", clear
save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_7yrs_RH.dta", replace

use				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_7p5yrs.dta", clear
append using	"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_8yrs.dta"
replace period="8 years"
replace years=8
save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_8yrs_RH.dta", replace

use				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_9yrs.dta", clear
save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_9yrs_RH.dta", replace

use				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_10yrs.dta", clear	/*120mths*/
append using	"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_125mths.dta"
replace period="10 years"
replace years=10
save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_10yrs_RH.dta", replace

use				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_131mths.dta", clear
append using	"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_11yrs.dta"			/*132mths*/
replace period="11 years"
replace years=11
save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_11yrs_RH.dta", replace

use				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_12yrs.dta", clear
save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_12yrs_RH.dta", replace

use				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_13yrs.dta", clear
save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_13yrs_RH.dta", replace

use				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_14yrs.dta", clear
save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_14yrs_RH.dta", replace

use				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_14p5yrs.dta", clear
append using	"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_15yrs.dta"
replace period="15 years"
replace years=15
save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_15yrs_RH.dta", replace

use				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_16yrs.dta", clear
save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_16yrs_RH.dta", replace

use				"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_17yrs.dta", clear
save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_17yrs_RH.dta", replace

********************************************************************************

use "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_3mths_RH.dta", replace
foreach x in 	6mths 9mths 1yr 1p25yrs 1p5yrs 1p75yrs 2yrs ///
				2p5yrs 3yrs 3p5yrs 4yrs 4p5yrs 5yrs 5p5yrs 6yrs ///
				7yrs 8yrs 9yrs 10yrs 11yrs 12yrs 13yrs 14yrs 15yrs 16yrs 17yrs{
				
append using	"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_`x'_RH.dta"
}
				
sort years country

g countrylabel="ID" if country=="Indonesia"
replace countrylabel="MX" if country=="Mexico"
replace countrylabel="NG" if country=="Nigeria"
replace countrylabel="TH" if country=="Thailand"
replace countrylabel="UG" if country=="Uganda"
replace countrylabel="BJ" if country=="Benin"
replace countrylabel="EG" if country=="Egypt"
replace countrylabel="GH" if country=="Ghana"
replace countrylabel="KE" if country=="Kenya"
replace countrylabel="MW" if country=="Malawi"
replace countrylabel="LK" if country=="Sri Lanka"
replace countrylabel="TG" if country=="Togo"

*Source: https://www.iso.org/obp/ui/#search

replace countrylabel="LK (SLKFEMBUSTRAINING)" if country=="Sri Lanka" & surveyname=="SLKFEMBUSTRAINING"
replace countrylabel="LK (SLMS)" if country=="Sri Lanka" & surveyname=="SLMS"
replace countrylabel="LK (SLLSE)" if country=="Sri Lanka" & surveyname=="SLLSE"
replace countrylabel="LK (SLKINFORMALITY)" if country=="Sri Lanka" & surveyname=="SLKINFORMALITY"

replace countrylabel="NG (YOUWIN)" if country=="Nigeria" & surveyname=="NGYOUWIN"
replace countrylabel="NG (LSMS-ISA)" if country=="Nigeria" & surveyname=="" 


replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"

save "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_RH.dta", replace		

foreach x in "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_11yrs_RH.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_12yrs_RH.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_13yrs_RH.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_14yrs_RH.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_15yrs_RH.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_16yrs_RH.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_17yrs_RH.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_3p5yrs_RH.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_3yrs_RH.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_4p5yrs_RH.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_4yrs_RH.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_5p5yrs_RH.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_5yrs_RH.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_6yrs_RH.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_7yrs_RH.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_8yrs_RH.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_9yrs_RH.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_10yrs_RH.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_1p5yrs_RH.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_1p25yrs_RH.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_1p75yrs_RH.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_1yr_RH.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_2p5yrs_RH.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_2yrs_RH.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_9mths_RH.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_3mths_RH.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_6mths_RH.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_17yrs.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_16yrs.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_16yrs_THL_R-1998.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_16yrs_THL_BL-1997.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_15yrs.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_15yrs_THL_R-1999.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_15yrs_THL_R-1998.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_15yrs_THL_BL-1997.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_14p5yrs.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_14yrs.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_14yrs_THL_R-2000.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_14yrs_THL_R-1999.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_14yrs_THL_R-1998.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_14yrs_THL_BL-1997.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_13yrs.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_13yrs_THL_R-2001.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_13yrs_THL_R-2000.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_13yrs_THL_R-1999.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_13yrs_THL_R-1998.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_13yrs_THL_BL-1997.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_12yrs.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_12yrs_THL_R-2002.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_12yrs_THL_R-2001.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_12yrs_THL_R-2000.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_12yrs_THL_R-1999.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_12yrs_THL_R-1998.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_12yrs_THL_BL-1997.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_11yrs.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_11yrs_THL_R-2003.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_11yrs_THL_R-2002.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_11yrs_THL_R-2001.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_11yrs_THL_R-2000.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_11yrs_THL_R-1999.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_11yrs_THL_R-1998.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_11yrs_THL_BL-1997.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_131mths.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_125mths.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_10yrs.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_10yrs_THL_R-2004.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_10yrs_THL_R-2003.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_10yrs_THL_R-2002.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_10yrs_THL_R-2001.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_10yrs_THL_R-2000.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_10yrs_THL_R-1999.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_10yrs_THL_R-1998.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_10yrs_THL_BL-1997.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_9yrs.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_9yrs_THL_R-2005.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_9yrs_THL_R-2004.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_9yrs_THL_R-2003.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_9yrs_THL_R-2002.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_9yrs_THL_R-2001.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_9yrs_THL_R-2000.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_9yrs_THL_R-1999.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_9yrs_THL_R-1998.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_9yrs_THL_BL-1997.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_8yrs.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_8yrs_THL_R-2006.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_8yrs_THL_R-2005.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_8yrs_THL_R-2003.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_8yrs_THL_R-2004.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_8yrs_THL_R-2002.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_8yrs_THL_R-2001.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_8yrs_THL_R-2000.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_8yrs_THL_R-1999.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_8yrs_THL_R-1998.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_8yrs_THL_BL-1997.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_7p5yrs.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_7p5yrs_MX.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_7p5yrs_IDN.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_7yrs_THL.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_7yrs.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_7yrs_IDN.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_7yrs_THL_R-2007.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_7yrs_THL_R-2005.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_7yrs_THL_R-2006.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_7yrs_THL_R-2004.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_7yrs_THL_R-2003.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_7yrs_THL_R-2002.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_7yrs_THL_R-2001.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_7yrs_THL_R-2000.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_7yrs_THL_R-1999.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_7yrs_THL_R-1998.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_7yrs_THL_BL-1997.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_6yrs.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_6yrs_THL_R-2007.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_6yrs_THL_R-2008.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_6yrs_THL_R-2006.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_6yrs_THL_R-2004.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_6yrs_THL_R-2005.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_6yrs_THL_R-2002.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_6yrs_THL_R-2003.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_6yrs_THL_R-2001.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_6yrs_THL_R-2000.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_6yrs_THL_R-1998.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_6yrs_THL_R-1999.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_6yrs_THL_BL-1997.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_5p75yrs.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_68mths.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_5p5yrs.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_62mths.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_5yrs.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_5yrs_THL_R-2008.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_5yrs_THL_R-2009.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_5yrs_THL_R-2006.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_5yrs_THL_R-2007.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_5yrs_THL_R-2005.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_5yrs_THL_R-2003.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_5yrs_THL_R-2004.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_5yrs_THL_R-2002.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_5yrs_THL_R-2000.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_5yrs_THL_R-2001.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_5yrs_THL_R-1999.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_5yrs_THL_R-1998.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_5yrs_THL_BL-1997.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_4p5yrs.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_4p5yrs_SLLSE_BL-2008.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_4p5yrs_MX_BL-2005.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_4yrs.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_SLLSE_BL-2008.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_R-2009.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_R-2010.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_R-2007.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_R-2008.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_R-2006.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_R-2004.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_R-2005.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_R-2002.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_R-2003.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_R-2000.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_R-2001.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_R-1999.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_R-1998.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_4yrs_THL_BL-1997.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_44mths.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_3p5yrs.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_3p5yrs_SLLSE_BL-2008.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_3p5yrs_MALAWIFORM_BL-2012.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_3yrs.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_3yrs_THL.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_SLMS_BL-2005.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_3yrs_SLKINFORMALITY_BL-2008.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_SLLSE_BL-2008.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_MX_BL-2002.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_R-2010.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_R-2011.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_R-2009.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_R-2007.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_R-2008.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_R-2006.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_R-2004.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_R-2005.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_R-2003.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_R-2002.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_R-2000.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_R-2001.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_R-1999.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_R-1998.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_3yrs_THL_BL-1997.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_35mths.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_34mths.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_2p5yrs_SLMS_BL-2005.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_2p5yrs.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_2p5yrs_SLLSE_BL-2008.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_2p5yrs_KENYAGETAHEAD_BL-2013.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_2p5yrs_NG_BL-2010.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_2p25yrs.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_26mths.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_2yrs.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_2yrs_NG.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_2yrs_THL.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_SLMS_BL-2005.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_SLLSE_BL-2008.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_NG_R-2011.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_NG_BL-2010.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-2012.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-2011.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-2010.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-2008.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-2009.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-2007.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-2005.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-2006.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-2004.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-2003.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-2001.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-2002.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-2000.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-1999.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_R-1998.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_2yrs_THL_BL-1997.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_22mths_NGYOUWIN_BL-2012.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_22mths.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_22mths_TOGOINF_BL-2013.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_22mths_MALAWIFORM_BL-2012.dta." ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_1p75yrs_SLMS_BL-2005.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_1p75yrs.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_1p75yrs_SLKFEMBUSTRAINING_BL-2009.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_20mths.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_1p5yrs.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_18mths_SLMS_BL-2005.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_18mths_SLLSE_BL-2008.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_18mths_UG_BL-2009.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_18mths_NG_R-2011.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_16mths.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_1p25yrs.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_14mths.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_13mths.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_13mths_BENINFORM_BL-2014.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_13mths_GHANAFLYP_BL-2008.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_1yr.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_MALAWIFORM_BL-2012.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_SLMS_BL-2005.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_SLKFEMBUSTRAINING_BL-2009.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_SLLSE_BL-2008.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_KENYAGETAHEAD_BL-2013.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-2013.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-2012.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-2011.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-2010.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-2009.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-2008.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-2007.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-2006.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-2005.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-2004.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-2003.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-2002.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-2001.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-2000.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-1999.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_R-1998.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_1yr_THL_BL-1997.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_11mths.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_10mths.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_10mths_TOGOINF_BL-2013.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_10mths_GHANAFLYP_BL-2008.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_9mths.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_7mths.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_0p5yrs.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_6mths_EGYPTMACROINS_BL-2012.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_6mths_SLMS_BL-2005.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_6mths_NG_R-2012.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_6mths_NG_BL-2010.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_4mths.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_4mths_GHANAFLYP_BL-2008.dta" ///
			"Preparation of Data for Figures/Data for figures/Comb_uncond_4mths_SLKFEMBUSTRAINING_BL-2009.dta" ///
			"Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_3mths.dta" {
erase "`x'"
}			

********************************************************************************
**For figure 3 (a) - Standardized death rates by firm age

foreach p in 3mths 6mths 9mths 1yr 1p25yrs 18mths 1p75yrs 2yrs 30mths 3yrs{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 


drop if surveyname=="TTHAI" | surveyname=="NGLSMS-ISA"

levelsof surveyname if survival_`p'!=., local(svyname) 

foreach x of local svyname{ 

forvalues y=1/7{
																		 
use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

count if survival_`p'==0 & surveyname=="`x'" & agegroup==`y'
mat help1=`r(N)'
count if survival_`p'==1 & surveyname=="`x'" & agegroup==`y'
mat help1=help1, `r(N)'
count if survival_`p'==. & surveyname=="`x'" & agegroup==`y'
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g period="`p'"

g surveyname="`x'"

g agegroup=`y'

save "Preparation of Data for Figures/Data for figures/Comb_cond_fa_`p'_`x'`y'.dta", replace
}


use "Preparation of Data for Figures/Data for figures/Comb_cond_fa_`p'_`x'1.dta", clear

forvalues y=2/7{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_fa_`p'_`x'`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_fa_`p'_`x'`y'.dta"
}

save "Preparation of Data for Figures/Data for figures/Comb_cond_fa_`p'_`x'_firmage.dta", replace 
erase "Preparation of Data for Figures/Data for figures/Comb_cond_fa_`p'_`x'1.dta"

}
}

*Redo it for Nigeria LSMS-ISA and TTHAI to have averages over all rounds with the same horizon
*Thailand
local list1 BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 R-2007 R-2008 R-2009 R-2010 R-2011 R-2012 R-2013
local list2 BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 R-2007 R-2008 R-2009 R-2010 R-2011 R-2012
local list3 BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 R-2007 R-2008 R-2009 R-2010 R-2011

local p1 1yr
local p2 2yrs
local p3 3yrs

local j=1

forvalues i=1/3{

foreach x of local list`i'{

forvalues y=1/7{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

count if survival_`p`i''==0 & country=="Thailand" & survey=="`x'" & agegroup==`y'
mat help1=`r(N)'
count if survival_`p`i''==1 & country=="Thailand" & survey=="`x'" & agegroup==`y'
mat help1=help1, `r(N)'
count if survival_`p`i''==. & country=="Thailand" & survey=="`x'" & agegroup==`y'
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="`p`i''"

g country="Thailand"

g surveyname="TTHAI"

g agegroup=`y'

local help="`x'"
save "Preparation of Data for Figures/Data for figures/Comb_cond_fa_`p`i''_THL_`help'`y'.dta", replace
}
}

use "Preparation of Data for Figures/Data for figures/Comb_cond_fa_`p`i''_THL_BL-19971.dta", clear

forvalues y=2/7{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_fa_`p`i''_THL_BL-1997`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_fa_`p`i''_THL_BL-1997`y'.dta"
}

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fa_`p`i''_THAI.dta", replace 

local end=2014-`j'
forvalues d = 1998/`end'{
forvalues y=1/7{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_fa_`p`i''_THL_R-`d'`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_fa_`p`i''_THL_R-`d'`y'.dta"
}
}

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate (first) period country surveyname, by(agegroup)

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fa_`p`i''_THAI_firmage.dta", replace 
erase "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fa_`p`i''_THAI.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_fa_`p`i''_THL_BL-19971.dta"

local j=`j'+1
}


*Nigeria

local list1 BL-2010 R-2012
local list2 BL-2010 R-2011

local p1 6mths
local p2 2yrs

local j=1

forvalues i=1/2{

foreach x of local list`i'{

forvalues y=1/7{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

count if survival_`p`i''==0 & surveyname=="NGLSMS-ISA" & survey=="`x'" & agegroup==`y'
mat help1=`r(N)'
count if survival_`p`i''==1 & surveyname=="NGLSMS-ISA" & survey=="`x'" & agegroup==`y'
mat help1=help1, `r(N)'
count if survival_`p`i''==. & surveyname=="NGLSMS-ISA" & survey=="`x'" & agegroup==`y'
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="`p`i''"

g country="Nigeria"

g surveyname="NGLSMS-ISA"

g agegroup=`y'

local help="`x'"
save "Preparation of Data for Figures/Data for figures/Comb_cond_fa_`p`i''_NGLSMSISA_`help'`y'.dta", replace
}
}

use "Preparation of Data for Figures/Data for figures/Comb_cond_fa_`p`i''_NGLSMSISA_BL-20101.dta", clear

forvalues y=2/7{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_fa_`p`i''_NGLSMSISA_BL-2010`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_fa_`p`i''_NGLSMSISA_BL-2010`y'.dta"
}

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fa_`p`i''_NGLSMSISA.dta", replace 

local d=2013-`j'
forvalues y=1/7{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_fa_`p`i''_NGLSMSISA_R-`d'`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_fa_`p`i''_NGLSMSISA_R-`d'`y'.dta"
}


g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate (first) period country surveyname, by(agegroup)

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fa_`p`i''_NGLSMSISA_firmage.dta", replace 
erase "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fa_`p`i''_NGLSMSISA.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_fa_`p`i''_NGLSMSISA_BL-20101.dta"

local j=`j'+1
}


local x1 BL-2010 
local x2 R-2011

local p1 30mths
local p2 18mths


forvalues i=1/2{

forvalues y=1/7{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

count if survival_`p`i''==0 & surveyname=="NGLSMS-ISA" & survey=="`x`i''" & agegroup==`y'
mat help1=`r(N)'
count if survival_`p`i''==1 & surveyname=="NGLSMS-ISA" & survey=="`x`i''" & agegroup==`y'
mat help1=help1, `r(N)'
count if survival_`p`i''==. & surveyname=="NGLSMS-ISA" & survey=="`x`i''" & agegroup==`y'
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g period="`p`i''"

g surveyname="NGLSMS-ISA"

g agegroup=`y'

save "Preparation of Data for Figures/Data for figures/Comb_cond_fa_`p`i''_`x`i''`y'.dta", replace
}


use "Preparation of Data for Figures/Data for figures/Comb_cond_fa_`p`i''_`x`i''1.dta", clear

forvalues y=2/7{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_fa_`p`i''_`x`i''`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_fa_`p`i''_`x`i''`y'.dta"
}

save "Preparation of Data for Figures/Data for figures/Comb_cond_fa_`p`i''_`x`i''_firmage.dta", replace 
erase "Preparation of Data for Figures/Data for figures/Comb_cond_fa_`p`i''_`x`i''1.dta"

}

use				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_18mths_R-2011_firmage.dta", clear 
append using	"Preparation of Data for Figures/Data for figures/Comb_cond_fa_30mths_BL-2010_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fa_2yrs_NGLSMSISA_firmage.dta"		///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fa_6mths_NGLSMSISA_firmage.dta"		///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fa_3yrs_THAI_firmage.dta"			///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fa_2yrs_THAI_firmage.dta"			///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fa_1yr_THAI_firmage.dta"				///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_3yrs_TOGOINF_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_3yrs_SLMS_firmage.dta"						///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_3yrs_SLLSE_firmage.dta"						///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_3yrs_SLKINFORMALITY_firmage.dta"			///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_3yrs_MXFLS_firmage.dta"						///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_3yrs_MALAWIFORM_firmage.dta"				///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_30mths_SLMS_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_30mths_SLLSE_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_30mths_SLKINFORMALITY_firmage.dta"			///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_30mths_KENYAGETAHEAD_firmage.dta"			///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_2yrs_SLMS_firmage.dta"						///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_2yrs_SLLSE_firmage.dta"						///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_2yrs_BENINFORM_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1p75yrs_TOGOINF_firmage.dta"				///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1p75yrs_SLMS_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1p75yrs_SLKINFORMALITY_firmage.dta"			///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1p75yrs_SLKFEMBUSTRAINING_firmage.dta"		///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1p75yrs_NGYOUWIN_firmage.dta"				///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1p75yrs_MALAWIFORM_firmage.dta"				///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_18mths_UGWINGS_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_18mths_SLMS_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_18mths_SLLSE_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1p25yrs_TOGOINF_firmage.dta"				///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1p25yrs_SLMS_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1p25yrs_GHANAFLYP_firmage.dta"				///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1yr_SLMS_firmage.dta"						///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1yr_SLLSE_firmage.dta"						///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1yr_SLKFEMBUSTRAINING_firmage.dta"			///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1yr_NGYOUWIN_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1yr_MALAWIFORM_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1yr_KENYAGETAHEAD_firmage.dta"				///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1yr_GHANAFLYP_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1yr_BENINFORM_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_9mths_TOGOINF_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_9mths_SLMS_firmage.dta"						///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_9mths_GHANAFLYP_firmage.dta"				///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_6mths_SLMS_firmage.dta" 					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_6mths_SLLSE_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_6mths_GHANAFLYP_firmage.dta"				///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_6mths_EGYPTMACROINS_firmage.dta"			///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_3mths_SLMS_firmage.dta"						///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_3mths_SLKFEMBUSTRAINING_firmage.dta"		///	
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_3mths_GHANAFLYP_firmage.dta"					

g years=0.25 if period=="3mths"
replace years=0.5 if period=="6mths"
replace years=0.75 if period=="9mths"
replace years=1 if period=="1yr"
replace years=1.25 if period=="1p25yrs"
replace years=1.5 if period=="18mths"
replace years=1.75 if period=="1p75yrs"
replace years=2 if period=="2yrs"
replace years=2.5 if period=="30mths"
replace years=3 if period=="3yrs"


label define agegroup       1     "under 2 years" ///
							2     "2 to 5 years" ///
							3     "5 to 10 years" ///
							4  	  "10 to 15 years" ///
							5     "15 to 20 years" ///
							6     "20 to 30 years" ///
							7     "30 years and older"

label values agegroup agegroup

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fa_ALL_firmage.dta", replace

foreach x in	"Preparation of Data for Figures/Data for figures/Comb_cond_fa_18mths_R-2011_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_30mths_BL-2010_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fa_2yrs_NGLSMSISA_firmage.dta"		///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fa_6mths_NGLSMSISA_firmage.dta"		///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fa_3yrs_THAI_firmage.dta"			///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fa_2yrs_THAI_firmage.dta"			///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fa_1yr_THAI_firmage.dta"				///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_3yrs_TOGOINF_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_3yrs_SLMS_firmage.dta"						///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_3yrs_SLLSE_firmage.dta"						///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_3yrs_SLKINFORMALITY_firmage.dta"			///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_3yrs_MXFLS_firmage.dta"						///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_3yrs_MALAWIFORM_firmage.dta"				///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_30mths_SLMS_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_30mths_SLLSE_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_30mths_SLKINFORMALITY_firmage.dta"			///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_30mths_KENYAGETAHEAD_firmage.dta"			///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_2yrs_SLMS_firmage.dta"						///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_2yrs_SLLSE_firmage.dta"						///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_2yrs_BENINFORM_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1p75yrs_TOGOINF_firmage.dta"				///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1p75yrs_SLMS_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1p75yrs_SLKINFORMALITY_firmage.dta"			///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1p75yrs_SLKFEMBUSTRAINING_firmage.dta"		///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1p75yrs_NGYOUWIN_firmage.dta"				///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1p75yrs_MALAWIFORM_firmage.dta"				///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_18mths_UGWINGS_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_18mths_SLMS_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_18mths_SLLSE_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1p25yrs_TOGOINF_firmage.dta"				///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1p25yrs_SLMS_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1p25yrs_GHANAFLYP_firmage.dta"				///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1yr_SLMS_firmage.dta"						///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1yr_SLLSE_firmage.dta"						///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1yr_SLKFEMBUSTRAINING_firmage.dta"			///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1yr_NGYOUWIN_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1yr_MALAWIFORM_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1yr_KENYAGETAHEAD_firmage.dta"				///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1yr_GHANAFLYP_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_1yr_BENINFORM_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_9mths_TOGOINF_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_9mths_SLMS_firmage.dta"						///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_9mths_GHANAFLYP_firmage.dta"				///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_6mths_SLMS_firmage.dta" 					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_6mths_SLLSE_firmage.dta"					///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_6mths_GHANAFLYP_firmage.dta"				///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_6mths_EGYPTMACROINS_firmage.dta"			///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_3mths_SLMS_firmage.dta"						///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_3mths_SLKFEMBUSTRAINING_firmage.dta"		///	
				"Preparation of Data for Figures/Data for figures/Comb_cond_fa_3mths_GHANAFLYP_firmage.dta"	{
erase "`x'"
}


********************************************************************************
**For figure 3 (b) - Death rates by firm size

foreach p in 3mths 6mths 9mths 1yr 1p25yrs 18mths 1p75yrs 2yrs 30mths 3yrs{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 


drop if surveyname=="TTHAI" | surveyname=="NGLSMS-ISA"

levelsof surveyname if survival_`p'!=., local(svyname) 

foreach x of local svyname{ 

forvalues y=0/10{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

count if survival_`p'==0 & surveyname=="`x'" & employees==`y'
mat help1=`r(N)'
count if survival_`p'==1 & surveyname=="`x'" & employees==`y'
mat help1=help1, `r(N)'
count if survival_`p'==. & surveyname=="`x'" & employees==`y'
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g period="`p'"

g surveyname="`x'"

g employees=`y'

save "Preparation of Data for Figures/Data for figures/Comb_cond_fs_`p'_`x'`y'.dta", replace
}


use "Preparation of Data for Figures/Data for figures/Comb_cond_fs_`p'_`x'0.dta", clear

forvalues y=1/10{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_fs_`p'_`x'`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_fs_`p'_`x'`y'.dta"
}

save "Preparation of Data for Figures/Data for figures/Comb_cond_fs_`p'_`x'_firmsize.dta", replace 
erase "Preparation of Data for Figures/Data for figures/Comb_cond_fs_`p'_`x'0.dta"

}
}	

*Redo it for Nigeria LSMS-ISA and TTHAI to have averages over all rounds with the same horizon
*Thailand
local list1 BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 R-2007 R-2008 R-2009 R-2010 R-2011 R-2012 R-2013
local list2 BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 R-2007 R-2008 R-2009 R-2010 R-2011 R-2012
local list3 BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 R-2007 R-2008 R-2009 R-2010 R-2011

local p1 1yr
local p2 2yrs
local p3 3yrs

local j=1

forvalues i=1/3{

foreach x of local list`i'{

forvalues y=0/10{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

count if survival_`p`i''==0 & country=="Thailand" & survey=="`x'" & employees==`y'
mat help1=`r(N)'
count if survival_`p`i''==1 & country=="Thailand" & survey=="`x'" & employees==`y'
mat help1=help1, `r(N)'
count if survival_`p`i''==. & country=="Thailand" & survey=="`x'" & employees==`y'
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="`p`i''"

g country="Thailand"

g surveyname="TTHAI"

g employees=`y'

local help="`x'"
save "Preparation of Data for Figures/Data for figures/Comb_cond_fs_`p`i''_THL_`help'`y'.dta", replace
}
}

use "Preparation of Data for Figures/Data for figures/Comb_cond_fs_`p`i''_THL_BL-19970.dta", clear

forvalues y=1/10{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_fs_`p`i''_THL_BL-1997`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_fs_`p`i''_THL_BL-1997`y'.dta"
}

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fs_`p`i''_THAI.dta", replace 

local end=2014-`j'
forvalues d = 1998/`end'{
forvalues y=0/10{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_fs_`p`i''_THL_R-`d'`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_fs_`p`i''_THL_R-`d'`y'.dta"
}
}

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate (first) period country surveyname, by(employees)

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fs_`p`i''_THAI_firmsize.dta", replace 
erase "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fs_`p`i''_THAI.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_fs_`p`i''_THL_BL-19970.dta"

local j=`j'+1
}


*Nigeria

local list1 BL-2010 R-2012
local list2 BL-2010 R-2011

local p1 6mths
local p2 2yrs

local j=1

forvalues i=1/2{

foreach x of local list`i'{

forvalues y=0/10{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

count if survival_`p`i''==0 & surveyname=="NGLSMS-ISA" & survey=="`x'" & employees==`y'
mat help1=`r(N)'
count if survival_`p`i''==1 & surveyname=="NGLSMS-ISA" & survey=="`x'" & employees==`y'
mat help1=help1, `r(N)'
count if survival_`p`i''==. & surveyname=="NGLSMS-ISA" & survey=="`x'" & employees==`y'
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="`p`i''"

g country="Nigeria"

g surveyname="NGLSMS-ISA"

g employees=`y'

local help="`x'"
save "Preparation of Data for Figures/Data for figures/Comb_cond_fs_`p`i''_NGLSMSISA_`help'`y'.dta", replace
}
}

use "Preparation of Data for Figures/Data for figures/Comb_cond_fs_`p`i''_NGLSMSISA_BL-20100.dta", clear

forvalues y=1/10{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_fs_`p`i''_NGLSMSISA_BL-2010`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_fs_`p`i''_NGLSMSISA_BL-2010`y'.dta"
}

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fs_`p`i''_NGLSMSISA.dta", replace 

local d=2013-`j'
forvalues y=0/10{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_fs_`p`i''_NGLSMSISA_R-`d'`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_fs_`p`i''_NGLSMSISA_R-`d'`y'.dta"
}


g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate (first) period country surveyname, by(employees)

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fs_`p`i''_NGLSMSISA_firmsize.dta", replace 
erase "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fs_`p`i''_NGLSMSISA.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_fs_`p`i''_NGLSMSISA_BL-20100.dta"

local j=`j'+1
}

local x1 BL-2010 
local x2 R-2011

local p1 30mths
local p2 18mths


forvalues i=1/2{

forvalues y=0/10{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

count if survival_`p`i''==0 & surveyname=="NGLSMS-ISA" & survey=="`x`i''" & employees==`y'
mat help1=`r(N)'
count if survival_`p`i''==1 & surveyname=="NGLSMS-ISA" & survey=="`x`i''" & employees==`y'
mat help1=help1, `r(N)'
count if survival_`p`i''==. & surveyname=="NGLSMS-ISA" & survey=="`x`i''" & employees==`y'
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g period="`p`i''"

g surveyname="NGLSMS-ISA"

g employees=`y'

save "Preparation of Data for Figures/Data for figures/Comb_cond_fs_`p`i''_`x`i''`y'.dta", replace
}


use "Preparation of Data for Figures/Data for figures/Comb_cond_fs_`p`i''_`x`i''0.dta", clear

forvalues y=1/10{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_fs_`p`i''_`x`i''`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_fs_`p`i''_`x`i''`y'.dta"
}

save "Preparation of Data for Figures/Data for figures/Comb_cond_fs_`p`i''_`x`i''_firmsize.dta", replace 
erase "Preparation of Data for Figures/Data for figures/Comb_cond_fs_`p`i''_`x`i''0.dta"

}

use				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fs_2yrs_NGLSMSISA_firmsize.dta", clear
append using	"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fs_6mths_NGLSMSISA_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fs_3yrs_THAI_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fs_2yrs_THAI_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fs_1yr_THAI_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_3yrs_TOGOINF_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_3yrs_SLMS_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_3yrs_SLLSE_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_3yrs_SLKINFORMALITY_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_3yrs_MXFLS_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_3yrs_MALAWIFORM_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_30mths_SLMS_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_30mths_SLLSE_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_30mths_SLKINFORMALITY_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_30mths_KENYAGETAHEAD_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_2yrs_SLMS_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_2yrs_SLLSE_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_2yrs_BENINFORM_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1p75yrs_TOGOINF_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1p75yrs_SLMS_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1p75yrs_SLKINFORMALITY_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1p75yrs_SLKFEMBUSTRAINING_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1p75yrs_NGYOUWIN_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1p75yrs_MALAWIFORM_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_18mths_UGWINGS_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_18mths_SLMS_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_18mths_SLLSE_firmsize.dta" ///  
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1p25yrs_TOGOINF_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1p25yrs_SLMS_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1p25yrs_GHANAFLYP_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1yr_SLMS_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1yr_SLLSE_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1yr_SLKFEMBUSTRAINING_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1yr_NGYOUWIN_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1yr_MALAWIFORM_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1yr_KENYAGETAHEAD_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1yr_GHANAFLYP_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1yr_BENINFORM_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_9mths_TOGOINF_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_9mths_SLMS_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_9mths_GHANAFLYP_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_6mths_SLMS_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_6mths_SLLSE_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_6mths_GHANAFLYP_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_6mths_EGYPTMACROINS_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_3mths_SLMS_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_3mths_SLKFEMBUSTRAINING_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_3mths_GHANAFLYP_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_18mths_R-2011_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_30mths_BL-2010_firmsize.dta"


g years=0.25 if period=="3mths"
replace years=0.5 if period=="6mths"
replace years=0.75 if period=="9mths"
replace years=1 if period=="1yr"
replace years=1.25 if period=="1p25yrs"
replace years=1.5 if period=="18mths"
replace years=1.75 if period=="1p75yrs"
replace years=2 if period=="2yrs"
replace years=2.5 if period=="30mths"
replace years=3 if period=="3yrs"


save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fs_ALL_firmsize.dta", replace

foreach x in	"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fs_2yrs_NGLSMSISA_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fs_6mths_NGLSMSISA_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fs_3yrs_THAI_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fs_2yrs_THAI_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_fs_1yr_THAI_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_3yrs_TOGOINF_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_3yrs_SLMS_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_3yrs_SLLSE_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_3yrs_SLKINFORMALITY_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_3yrs_MXFLS_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_3yrs_MALAWIFORM_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_30mths_SLMS_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_30mths_SLLSE_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_30mths_SLKINFORMALITY_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_30mths_KENYAGETAHEAD_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_2yrs_SLMS_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_2yrs_SLLSE_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_2yrs_BENINFORM_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1p75yrs_TOGOINF_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1p75yrs_SLMS_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1p75yrs_SLKINFORMALITY_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1p75yrs_SLKFEMBUSTRAINING_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1p75yrs_NGYOUWIN_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1p75yrs_MALAWIFORM_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_18mths_UGWINGS_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_18mths_SLMS_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_18mths_SLLSE_firmsize.dta" ///  
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1p25yrs_TOGOINF_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1p25yrs_SLMS_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1p25yrs_GHANAFLYP_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1yr_SLMS_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1yr_SLLSE_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1yr_SLKFEMBUSTRAINING_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1yr_NGYOUWIN_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1yr_MALAWIFORM_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1yr_KENYAGETAHEAD_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1yr_GHANAFLYP_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_1yr_BENINFORM_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_9mths_TOGOINF_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_9mths_SLMS_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_9mths_GHANAFLYP_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_6mths_SLMS_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_6mths_SLLSE_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_6mths_GHANAFLYP_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_6mths_EGYPTMACROINS_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_3mths_SLMS_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_3mths_SLKFEMBUSTRAINING_firmsize.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_3mths_GHANAFLYP_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_18mths_R-2011_firmsize.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_fs_30mths_BL-2010_firmsize.dta"{
erase "`x'"
}


********************************************************************************
**For figure 3 (c) - Standardized death rates by daily profits

foreach p in 3mths 6mths 9mths 1yr 1p25yrs 18mths 1p75yrs 2yrs 30mths 3yrs{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 


drop if surveyname=="TTHAI" | surveyname=="NGLSMS-ISA"

levelsof surveyname if survival_`p'!=., local(svyname) 

foreach x of local svyname{ 

forvalues y=1/10{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

count if survival_`p'==0 & surveyname=="`x'" & subsgroup==`y'
mat help1=`r(N)'
count if survival_`p'==1 & surveyname=="`x'" & subsgroup==`y'
mat help1=help1, `r(N)'
count if survival_`p'==. & surveyname=="`x'" & subsgroup==`y'
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g period="`p'"

g surveyname="`x'"

g subsgroup=`y'

save "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p'_`x'`y'.dta", replace
}


use "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p'_`x'1.dta", clear

forvalues y=2/10{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p'_`x'`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p'_`x'`y'.dta"
}

save "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p'_`x'_subs.dta", replace 
erase "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p'_`x'1.dta"

}
}

*Redo it for Nigeria LSMS-ISA and TTHAI to have averages over all rounds with the same horizon
*Thailand
local list1 BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 R-2007 R-2008 R-2009 R-2010 R-2011 R-2012 R-2013
local list2 BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 R-2007 R-2008 R-2009 R-2010 R-2011 R-2012
local list3 BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 R-2007 R-2008 R-2009 R-2010 R-2011

local p1 1yr
local p2 2yrs
local p3 3yrs

local j=1

forvalues i=1/3{

foreach x of local list`i'{

forvalues y=1/10{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

count if survival_`p`i''==0 & country=="Thailand" & survey=="`x'" & subsgroup==`y'
mat help1=`r(N)'
count if survival_`p`i''==1 & country=="Thailand" & survey=="`x'" & subsgroup==`y'
mat help1=help1, `r(N)'
count if survival_`p`i''==. & country=="Thailand" & survey=="`x'" & subsgroup==`y'
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="`p`i''"

g country="Thailand"

g surveyname="TTHAI"

g subsgroup=`y'

local help="`x'"
save "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_THL_`help'`y'.dta", replace
}
}

use "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_THL_BL-19971.dta", clear

forvalues y=2/10{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_THL_BL-1997`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_THL_BL-1997`y'.dta"
}

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_`p`i''_THAI.dta", replace 

local end=2014-`j'
forvalues d = 1998/`end'{
forvalues y=1/10{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_THL_R-`d'`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_THL_R-`d'`y'.dta"
}
}

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate (first) period country surveyname, by(subsgroup)

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_`p`i''_THAI_subs.dta", replace 
erase "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_`p`i''_THAI.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_THL_BL-19971.dta"

local j=`j'+1
}


*Nigeria

local list1 BL-2010 R-2012
local list2 BL-2010 R-2011

local p1 6mths
local p2 2yrs

local j=1

forvalues i=1/2{

foreach x of local list`i'{

forvalues y=1/10{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

count if survival_`p`i''==0 & surveyname=="NGLSMS-ISA" & survey=="`x'" & subsgroup==`y'
mat help1=`r(N)'
count if survival_`p`i''==1 & surveyname=="NGLSMS-ISA" & survey=="`x'" & subsgroup==`y'
mat help1=help1, `r(N)'
count if survival_`p`i''==. & surveyname=="NGLSMS-ISA" & survey=="`x'" & subsgroup==`y'
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="`p`i''"

g country="Nigeria"

g surveyname="NGLSMS-ISA"

g subsgroup=`y'

local help="`x'"
save "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_NGLSMSISA_`help'`y'.dta", replace
}
}

use "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_NGLSMSISA_BL-20101.dta", clear

forvalues y=2/10{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_NGLSMSISA_BL-2010`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_NGLSMSISA_BL-2010`y'.dta"
}

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_`p`i''_NGLSMSISA.dta", replace 

local d=2013-`j'
forvalues y=1/10{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_NGLSMSISA_R-`d'`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_NGLSMSISA_R-`d'`y'.dta"
}


g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate (first) period country surveyname, by(subsgroup)

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_`p`i''_NGLSMSISA_subs.dta", replace 
erase "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_`p`i''_NGLSMSISA.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_NGLSMSISA_BL-20101.dta"

local j=`j'+1
}


local x1 BL-2010 
local x2 R-2011

local p1 30mths
local p2 18mths


forvalues i=1/2{

forvalues y=1/10{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

count if survival_`p`i''==0 & surveyname=="NGLSMS-ISA" & survey=="`x`i''" & subsgroup==`y'
mat help1=`r(N)'
count if survival_`p`i''==1 & surveyname=="NGLSMS-ISA" & survey=="`x`i''" & subsgroup==`y'
mat help1=help1, `r(N)'
count if survival_`p`i''==. & surveyname=="NGLSMS-ISA" & survey=="`x`i''" & subsgroup==`y'
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g period="`p`i''"

g surveyname="NGLSMS-ISA"

g subsgroup=`y'

save "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_`x`i''`y'.dta", replace
}


use "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_`x`i''1.dta", clear

forvalues y=2/10{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_`x`i''`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_`x`i''`y'.dta"
}

save "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_`x`i''_subs.dta", replace 
erase "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_`x`i''1.dta"

}

use "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_2yrs_NGLSMSISA_subs.dta", clear
append using	"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_6mths_NGLSMSISA_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_3yrs_THAI_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_2yrs_THAI_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_1yr_THAI_subs.dta"	///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3yrs_TOGOINF_subs.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3yrs_SLMS_subs.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3yrs_SLLSE_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3yrs_SLKINFORMALITY_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3yrs_MXFLS_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3yrs_MALAWIFORM_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_30mths_SLMS_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_30mths_SLLSE_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_30mths_SLKINFORMALITY_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_30mths_KENYAGETAHEAD_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_2yrs_SLMS_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_2yrs_SLLSE_subs.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_2yrs_BENINFORM_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p75yrs_TOGOINF_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p75yrs_SLMS_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p75yrs_SLKINFORMALITY_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p75yrs_SLKFEMBUSTRAINING_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p75yrs_NGYOUWIN_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p75yrs_MALAWIFORM_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_18mths_SLMS_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_18mths_SLLSE_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p25yrs_TOGOINF_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p25yrs_SLMS_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p25yrs_GHANAFLYP_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_SLMS_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_SLLSE_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_SLKFEMBUSTRAINING_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_NGYOUWIN_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_MALAWIFORM_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_KENYAGETAHEAD_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_GHANAFLYP_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_BENINFORM_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_9mths_TOGOINF_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_9mths_SLMS_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_9mths_GHANAFLYP_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_6mths_SLMS_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_6mths_SLLSE_subs.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_6mths_GHANAFLYP_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_6mths_EGYPTMACROINS_subs.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3mths_SLMS_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3mths_SLKFEMBUSTRAINING_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3mths_GHANAFLYP_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_18mths_R-2011_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_30mths_BL-2010_subs.dta"

g years=0.25 if period=="3mths"
replace years=0.5 if period=="6mths"
replace years=0.75 if period=="9mths"
replace years=1 if period=="1yr"
replace years=1.25 if period=="1p25yrs"
replace years=1.5 if period=="18mths"
replace years=1.75 if period=="1p75yrs"
replace years=2 if period=="2yrs"
replace years=2.5 if period=="30mths"
replace years=3 if period=="3yrs"


label define subsgroup 	1 "less than US$1 per day" ///
						2 "US$1-US$2 per day" ///
						3 "US$2-US$3 per day" ///
						4 "US$3-US$4 per day" ///
						5 "US$4-US$5 per day" ///
						6 "US$5-US$6 per day" ///
						7 "US$6-US$7 per day" ///
						8 "US$7-US$8 per day" ///
						9 "US$8-US$9 per day" ///
						10 "US$9-US$10 per day" 

label values subsgroup subsgroup	


save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_ALL_subs.dta", replace

foreach x in	"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_2yrs_NGLSMSISA_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_6mths_NGLSMSISA_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_3yrs_THAI_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_2yrs_THAI_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_1yr_THAI_subs.dta"	///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3yrs_TOGOINF_subs.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3yrs_SLMS_subs.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3yrs_SLLSE_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3yrs_SLKINFORMALITY_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3yrs_MXFLS_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3yrs_MALAWIFORM_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_30mths_SLMS_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_30mths_SLLSE_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_30mths_SLKINFORMALITY_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_30mths_KENYAGETAHEAD_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_2yrs_SLMS_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_2yrs_SLLSE_subs.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_2yrs_BENINFORM_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p75yrs_TOGOINF_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p75yrs_SLMS_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p75yrs_SLKINFORMALITY_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p75yrs_SLKFEMBUSTRAINING_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p75yrs_NGYOUWIN_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p75yrs_MALAWIFORM_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_18mths_SLMS_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_18mths_SLLSE_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_18mths_UGWINGS_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p25yrs_TOGOINF_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p25yrs_SLMS_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p25yrs_GHANAFLYP_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_SLMS_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_SLLSE_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_SLKFEMBUSTRAINING_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_NGYOUWIN_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_MALAWIFORM_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_KENYAGETAHEAD_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_GHANAFLYP_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_BENINFORM_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_9mths_TOGOINF_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_9mths_SLMS_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_9mths_GHANAFLYP_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_6mths_SLMS_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_6mths_SLLSE_subs.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_6mths_GHANAFLYP_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_6mths_EGYPTMACROINS_subs.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3mths_SLMS_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3mths_SLKFEMBUSTRAINING_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3mths_GHANAFLYP_subs.dta"	///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_18mths_R-2011_subs.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_30mths_BL-2010_subs.dta"{
erase "`x'"
}


********************************************************************************
**For figure 3 (d) - Death rates by firm sector

foreach p in 3mths 6mths 9mths 1yr 1p25yrs 18mths 1p75yrs 2yrs 30mths 3yrs{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 


drop if surveyname=="TTHAI" | surveyname=="NGLSMS-ISA"

levelsof surveyname if survival_`p'!=., local(svyname) 

foreach x of local svyname{ 

forvalues y=1/4{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

count if survival_`p'==0 & surveyname=="`x'" & sector1234==`y'
mat help1=`r(N)'
count if survival_`p'==1 & surveyname=="`x'" & sector1234==`y'
mat help1=help1, `r(N)'
count if survival_`p'==. & surveyname=="`x'" & sector1234==`y'
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g period="`p'"

g surveyname="`x'"

g sector=`y'

save "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p'_`x'`y'.dta", replace
}


use "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p'_`x'1.dta", clear

forvalues y=2/4{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p'_`x'`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p'_`x'`y'.dta"
}

save "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p'_`x'_sector.dta", replace 
erase "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p'_`x'1.dta"

}
}	


*Redo it for Nigeria LSMS-ISA and TTHAI to have averages over all rounds with the same horizon
*Thailand
local list1 BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 R-2007 R-2008 R-2009 R-2010 R-2011 R-2012 R-2013
local list2 BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 R-2007 R-2008 R-2009 R-2010 R-2011 R-2012
local list3 BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 R-2007 R-2008 R-2009 R-2010 R-2011

local p1 1yr
local p2 2yrs
local p3 3yrs

local j=1

forvalues i=1/3{

foreach x of local list`i'{

forvalues y=1/4{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

count if survival_`p`i''==0 & country=="Thailand" & survey=="`x'" & sector1234==`y'
mat help1=`r(N)'
count if survival_`p`i''==1 & country=="Thailand" & survey=="`x'" & sector1234==`y'
mat help1=help1, `r(N)'
count if survival_`p`i''==. & country=="Thailand" & survey=="`x'" & sector1234==`y'
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="`p`i''"

g country="Thailand"

g surveyname="TTHAI"

g sector=`y'

local help="`x'"
save "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_THL_`help'`y'.dta", replace
}
}

use "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_THL_BL-19971.dta", clear

forvalues y=2/4{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_THL_BL-1997`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_THL_BL-1997`y'.dta"
}

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_`p`i''_THAI.dta", replace 

local end=2014-`j'
forvalues d = 1998/`end'{
forvalues y=1/4{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_THL_R-`d'`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_THL_R-`d'`y'.dta"
}
}

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate (first) period country surveyname, by(sector)

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_`p`i''_THAI_sector.dta", replace 
erase "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_`p`i''_THAI.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_THL_BL-19971.dta"

local j=`j'+1
}


*Nigeria

local list1 BL-2010 R-2012
local list2 BL-2010 R-2011

local p1 6mths
local p2 2yrs

local j=1

forvalues i=1/2{

foreach x of local list`i'{

forvalues y=1/4{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

count if survival_`p`i''==0 & surveyname=="NGLSMS-ISA" & survey=="`x'" & sector1234==`y'
mat help1=`r(N)'
count if survival_`p`i''==1 & surveyname=="NGLSMS-ISA" & survey=="`x'" & sector1234==`y'
mat help1=help1, `r(N)'
count if survival_`p`i''==. & surveyname=="NGLSMS-ISA" & survey=="`x'" & sector1234==`y'
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="`p`i''"

g country="Nigeria"

g surveyname="NGLSMS-ISA"

g sector=`y'

local help="`x'"
save "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_NGLSMSISA_`help'`y'.dta", replace
}
}

use "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_NGLSMSISA_BL-20101.dta", clear

forvalues y=2/4{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_NGLSMSISA_BL-2010`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_NGLSMSISA_BL-2010`y'.dta"
}

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_`p`i''_NGLSMSISA.dta", replace 

local d=2013-`j'
forvalues y=1/4{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_NGLSMSISA_R-`d'`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_NGLSMSISA_R-`d'`y'.dta"
}


g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate (first) period country surveyname, by(sector)

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_`p`i''_NGLSMSISA_sector.dta", replace 
erase "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_`p`i''_NGLSMSISA.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_NGLSMSISA_BL-20101.dta"

local j=`j'+1
}

local x1 BL-2010 
local x2 R-2011

local p1 30mths
local p2 18mths


forvalues i=1/2{

forvalues y=1/4{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

count if survival_`p`i''==0 & surveyname=="NGLSMS-ISA" & survey=="`x`i''" & sector1234==`y'
mat help1=`r(N)'
count if survival_`p`i''==1 & surveyname=="NGLSMS-ISA" & survey=="`x`i''" & sector1234==`y'
mat help1=help1, `r(N)'
count if survival_`p`i''==. & surveyname=="NGLSMS-ISA" & survey=="`x`i''" & sector1234==`y'
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g period="`p`i''"

g surveyname="NGLSMS-ISA"

g sector=`y'

save "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_`x`i''`y'.dta", replace
}


use "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_`x`i''1.dta", clear

forvalues y=2/4{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_`x`i''`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_`x`i''`y'.dta"
}

save "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_`x`i''_sector.dta", replace 
erase "Preparation of Data for Figures/Data for figures/Comb_cond_s_`p`i''_`x`i''1.dta"

}

use				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_2yrs_NGLSMSISA_sector.dta", clear
append using	"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_6mths_NGLSMSISA_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_3yrs_THAI_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_2yrs_THAI_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_1yr_THAI_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3yrs_TOGOINF_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3yrs_SLMS_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3yrs_SLLSE_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3yrs_SLKINFORMALITY_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3yrs_MXFLS_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3yrs_MALAWIFORM_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_30mths_SLMS_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_30mths_SLLSE_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_30mths_SLKINFORMALITY_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_30mths_KENYAGETAHEAD_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_2yrs_SLMS_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_2yrs_SLLSE_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_2yrs_BENINFORM_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p75yrs_TOGOINF_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p75yrs_SLMS_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p75yrs_SLKINFORMALITY_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p75yrs_SLKFEMBUSTRAINING_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p75yrs_NGYOUWIN_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p75yrs_MALAWIFORM_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_18mths_UGWINGS_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_18mths_SLMS_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_18mths_SLLSE_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p25yrs_TOGOINF_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p25yrs_SLMS_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p25yrs_GHANAFLYP_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_SLMS_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_SLLSE_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_SLKFEMBUSTRAINING_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_NGYOUWIN_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_MALAWIFORM_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_KENYAGETAHEAD_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_GHANAFLYP_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_BENINFORM_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_9mths_TOGOINF_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_9mths_SLMS_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_9mths_GHANAFLYP_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_6mths_SLMS_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_6mths_SLLSE_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_6mths_GHANAFLYP_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_6mths_EGYPTMACROINS_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3mths_SLMS_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3mths_SLKFEMBUSTRAINING_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3mths_GHANAFLYP_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_18mths_R-2011_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_30mths_BL-2010_sector.dta"
				

g years=0.25 if period=="3mths"
replace years=0.5 if period=="6mths"
replace years=0.75 if period=="9mths"
replace years=1 if period=="1yr"
replace years=1.25 if period=="1p25yrs"
replace years=1.5 if period=="18mths"
replace years=1.75 if period=="1p75yrs"
replace years=2 if period=="2yrs"
replace years=2.5 if period=="30mths"
replace years=3 if period=="3yrs"

label define sector 1 retail ///
					2 manufacturing ///
					3 services ///
					4 other
					
label values sector sector					
					

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_ALL_sector.dta", replace

foreach x in	"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_2yrs_NGLSMSISA_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_6mths_NGLSMSISA_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_3yrs_THAI_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_2yrs_THAI_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_s_1yr_THAI_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3yrs_TOGOINF_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3yrs_SLMS_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3yrs_SLLSE_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3yrs_SLKINFORMALITY_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3yrs_MXFLS_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3yrs_MALAWIFORM_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_30mths_SLMS_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_30mths_SLLSE_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_30mths_SLKINFORMALITY_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_30mths_KENYAGETAHEAD_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_2yrs_SLMS_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_2yrs_SLLSE_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_2yrs_BENINFORM_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p75yrs_TOGOINF_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p75yrs_SLMS_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p75yrs_SLKINFORMALITY_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p75yrs_SLKFEMBUSTRAINING_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p75yrs_NGYOUWIN_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p75yrs_MALAWIFORM_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_18mths_UGWINGS_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_18mths_SLMS_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_18mths_SLLSE_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p25yrs_TOGOINF_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p25yrs_SLMS_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1p25yrs_GHANAFLYP_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_SLMS_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_SLLSE_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_SLKFEMBUSTRAINING_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_NGYOUWIN_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_MALAWIFORM_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_KENYAGETAHEAD_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_GHANAFLYP_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_1yr_BENINFORM_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_9mths_TOGOINF_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_9mths_SLMS_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_9mths_GHANAFLYP_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_6mths_SLMS_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_6mths_SLLSE_sector.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_6mths_GHANAFLYP_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_6mths_EGYPTMACROINS_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3mths_SLMS_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3mths_SLKFEMBUSTRAINING_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_3mths_GHANAFLYP_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_18mths_R-2011_sector.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_s_30mths_BL-2010_sector.dta"{
erase "`x'"
}					


********************************************************************************
**For figure 4 (a) - Standardized death rates by age of owner
	
foreach p in 3mths 6mths 9mths 1yr 1p25yrs 18mths 1p75yrs 2yrs 30mths 3yrs{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 


drop if surveyname=="TTHAI" | surveyname=="NGLSMS-ISA"

levelsof surveyname if survival_`p'!=., local(svyname) 

foreach x of local svyname{ 

forvalues y=1/9{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

count if survival_`p'==0 & surveyname=="`x'" & owneragegroup==`y'
mat help1=`r(N)'
count if survival_`p'==1 & surveyname=="`x'" & owneragegroup==`y'
mat help1=help1, `r(N)'
count if survival_`p'==. & surveyname=="`x'" & owneragegroup==`y'
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g period="`p'"

g surveyname="`x'"

g owneragegroup=`y'

save  "Preparation of Data for Figures/Data for figures/Comb_cond_oa_`p'_`x'`y'.dta", replace
}


use "Preparation of Data for Figures/Data for figures/Comb_cond_oa_`p'_`x'1.dta", clear

forvalues y=2/9{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_oa_`p'_`x'`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_oa_`p'_`x'`y'.dta"
}

save "Preparation of Data for Figures/Data for figures/Comb_cond_oa_`p'_`x'_ownerage", replace 
erase "Preparation of Data for Figures/Data for figures/Comb_cond_oa_`p'_`x'1.dta"

}
}	

*Redo it for Nigeria LSMS-ISA and TTHAI to have averages over all rounds with the same horizon
*Thailand
local list1 BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 R-2007 R-2008 R-2009 R-2010 R-2011 R-2012 R-2013
local list2 BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 R-2007 R-2008 R-2009 R-2010 R-2011 R-2012
local list3 BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 R-2007 R-2008 R-2009 R-2010 R-2011

local p1 1yr
local p2 2yrs
local p3 3yrs

local j=1

forvalues i=1/3{

foreach x of local list`i'{

forvalues y=1/9{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

count if survival_`p`i''==0 & country=="Thailand" & survey=="`x'" & owneragegroup==`y'
mat help1=`r(N)'
count if survival_`p`i''==1 & country=="Thailand" & survey=="`x'" & owneragegroup==`y'
mat help1=help1, `r(N)'
count if survival_`p`i''==. & country=="Thailand" & survey=="`x'" & owneragegroup==`y'
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="`p`i''"

g country="Thailand"

g surveyname="TTHAI"

g owneragegroup=`y'

local help="`x'"
save "Preparation of Data for Figures/Data for figures/Comb_cond_oa_`p`i''_THL_`help'`y'.dta", replace
}
}

use "Preparation of Data for Figures/Data for figures/Comb_cond_oa_`p`i''_THL_BL-19971", clear

forvalues y=2/9{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_oa_`p`i''_THL_BL-1997`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_oa_`p`i''_THL_BL-1997`y'.dta"
}

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_oa_`p`i''_THAI.dta", replace 

local end=2014-`j'
forvalues d = 1998/`end'{
forvalues y=1/9{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_oa_`p`i''_THL_R-`d'`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_oa_`p`i''_THL_R-`d'`y'.dta"
}
}

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate (first) period country surveyname, by(owneragegroup)

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_oa_`p`i''_THAI_ownerage.dta", replace 
erase "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_oa_`p`i''_THAI.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_oa_`p`i''_THL_BL-19971.dta"

local j=`j'+1
}


*Nigeria

local list1 BL-2010 R-2012
local list2 BL-2010 R-2011

local p1 6mths
local p2 2yrs

local j=1

forvalues i=1/2{

foreach x of local list`i'{

forvalues y=1/9{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

count if survival_`p`i''==0 & surveyname=="NGLSMS-ISA" & survey=="`x'" & owneragegroup==`y'
mat help1=`r(N)'
count if survival_`p`i''==1 & surveyname=="NGLSMS-ISA" & survey=="`x'" & owneragegroup==`y'
mat help1=help1, `r(N)'
count if survival_`p`i''==. & surveyname=="NGLSMS-ISA" & survey=="`x'" & owneragegroup==`y'
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="`p`i''"

g country="Nigeria"

g surveyname="NGLSMS-ISA"

g owneragegroup=`y'

local help="`x'"
save "Preparation of Data for Figures/Data for figures/Comb_cond_oa_`p`i''_NGLSMSISA_`help'`y'.dta", replace
}
}

use "Preparation of Data for Figures/Data for figures/Comb_cond_oa_`p`i''_NGLSMSISA_BL-20101.dta", clear

forvalues y=2/9{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_oa_`p`i''_NGLSMSISA_BL-2010`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_oa_`p`i''_NGLSMSISA_BL-2010`y'.dta"
}

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_oa_`p`i''_NGLSMSISA.dta", replace 

local d=2013-`j'
forvalues y=1/9{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_oa_`p`i''_NGLSMSISA_R-`d'`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_oa_`p`i''_NGLSMSISA_R-`d'`y'.dta"
}


g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate (first) period country surveyname, by(owneragegroup)

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_oa_`p`i''_NGLSMSISA_ownerage.dta", replace 
erase "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_oa_`p`i''_NGLSMSISA.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_oa_`p`i''_NGLSMSISA_BL-20101.dta"

local j=`j'+1
}

local x1 BL-2010 
local x2 R-2011

local p1 30mths
local p2 18mths


forvalues i=1/2{

forvalues y=1/9{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

count if survival_`p`i''==0 & surveyname=="NGLSMS-ISA" & survey=="`x`i''" & owneragegroup==`y'
mat help1=`r(N)'
count if survival_`p`i''==1 & surveyname=="NGLSMS-ISA" & survey=="`x`i''" & owneragegroup==`y'
mat help1=help1, `r(N)'
count if survival_`p`i''==. & surveyname=="NGLSMS-ISA" & survey=="`x`i''" & owneragegroup==`y'
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g period="`p`i''"

g surveyname="NGLSMS-ISA"

g owneragegroup=`y'

save "Preparation of Data for Figures/Data for figures/Comb_cond_oa_`p`i''_`x`i''`y'.dta", replace
}


use "Preparation of Data for Figures/Data for figures/Comb_cond_oa_`p`i''_`x`i''1.dta", clear

forvalues y=2/9{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_oa_`p`i''_`x`i''`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_oa_`p`i''_`x`i''`y'.dta"
}

save "Preparation of Data for Figures/Data for figures/Comb_cond_oa_`p`i''_`x`i''_ownerage.dta", replace 
erase "Preparation of Data for Figures/Data for figures/Comb_cond_oa_`p`i''_`x`i''1.dta"

}

use				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_3yrs_TOGOINF_ownerage.dta", clear
append using	"Preparation of Data for Figures/Data for figures/Comb_cond_oa_3yrs_SLMS_ownerage.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_3yrs_SLLSE_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_3yrs_SLKINFORMALITY_ownerage.dta"   ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_3yrs_MXFLS_ownerage.dta"   ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_3yrs_MALAWIFORM_ownerage.dta"   ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_30mths_SLMS_ownerage.dta"   ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_30mths_SLLSE_ownerage.dta"   ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_30mths_SLKINFORMALITY_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_30mths_KENYAGETAHEAD_ownerage.dta"   ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_2yrs_SLMS_ownerage.dta"   ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_2yrs_SLLSE_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_2yrs_BENINFORM_ownerage.dta"   ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1p75yrs_TOGOINF_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1p75yrs_SLMS_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1p75yrs_SLKINFORMALITY_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1p75yrs_SLKFEMBUSTRAINING_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1p75yrs_NGYOUWIN_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1p75yrs_MALAWIFORM_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_18mths_UGWINGS_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_18mths_SLMS_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_18mths_SLLSE_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1p25yrs_TOGOINF_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1p25yrs_SLMS_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1p25yrs_GHANAFLYP_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1yr_SLMS_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1yr_SLLSE_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1yr_SLKFEMBUSTRAINING_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1yr_NGYOUWIN_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1yr_MALAWIFORM_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1yr_KENYAGETAHEAD_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1yr_GHANAFLYP_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1yr_BENINFORM_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_9mths_TOGOINF_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_9mths_SLMS_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_9mths_GHANAFLYP_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_6mths_SLMS_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_6mths_SLLSE_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_6mths_GHANAFLYP_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_6mths_EGYPTMACROINS_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_3mths_SLMS_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_3mths_SLKFEMBUSTRAINING_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_3mths_GHANAFLYP_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_oa_2yrs_NGLSMSISA_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_oa_6mths_NGLSMSISA_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_oa_3yrs_THAI_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_oa_2yrs_THAI_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_oa_1yr_THAI_ownerage.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_18mths_R-2011_ownerage.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_30mths_BL-2010_ownerage.dta" ///
				

g years=0.25 if period=="3mths"
replace years=0.5 if period=="6mths"
replace years=0.75 if period=="9mths"
replace years=1 if period=="1yr"
replace years=1.25 if period=="1p25yrs"
replace years=1.5 if period=="18mths"
replace years=1.75 if period=="1p75yrs"
replace years=2 if period=="2yrs"
replace years=2.5 if period=="30mths"
replace years=3 if period=="3yrs"


label define owneragegroup  1     "15 to 20 years" ///
							2     "20 to 25 years" ///
							3     "25 to 30 years" ///
							4  	  "30 to 35 years" ///
							5     "35 to 40 years" ///
							6     "40 to 45 years" ///
							7     "45 to 50 years" ///
							8	  "50 to 60 years" ///	
							9	  "60 years and older"	


label values owneragegroup owneragegroup


save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_oa_ALL_ownerage", replace

foreach x in	"Preparation of Data for Figures/Data for figures/Comb_cond_oa_3yrs_TOGOINF_ownerage.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_3yrs_SLMS_ownerage.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_3yrs_SLLSE_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_3yrs_SLKINFORMALITY_ownerage.dta"   ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_3yrs_MXFLS_ownerage.dta"   ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_3yrs_MALAWIFORM_ownerage.dta"   ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_30mths_SLMS_ownerage.dta"   ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_30mths_SLLSE_ownerage.dta"   ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_30mths_SLKINFORMALITY_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_30mths_KENYAGETAHEAD_ownerage.dta"   ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_2yrs_SLMS_ownerage.dta"   ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_2yrs_SLLSE_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_2yrs_BENINFORM_ownerage.dta"   ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1p75yrs_TOGOINF_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1p75yrs_SLMS_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1p75yrs_SLKINFORMALITY_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1p75yrs_SLKFEMBUSTRAINING_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1p75yrs_NGYOUWIN_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1p75yrs_MALAWIFORM_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_18mths_UGWINGS_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_18mths_SLMS_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_18mths_SLLSE_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1p25yrs_TOGOINF_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1p25yrs_SLMS_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1p25yrs_GHANAFLYP_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1yr_SLMS_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1yr_SLLSE_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1yr_SLKFEMBUSTRAINING_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1yr_NGYOUWIN_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1yr_MALAWIFORM_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1yr_KENYAGETAHEAD_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1yr_GHANAFLYP_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_1yr_BENINFORM_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_9mths_TOGOINF_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_9mths_SLMS_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_9mths_GHANAFLYP_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_6mths_SLMS_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_6mths_SLLSE_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_6mths_GHANAFLYP_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_6mths_EGYPTMACROINS_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_3mths_SLMS_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_3mths_SLKFEMBUSTRAINING_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_3mths_GHANAFLYP_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_oa_2yrs_NGLSMSISA_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_oa_6mths_NGLSMSISA_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_oa_3yrs_THAI_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_oa_2yrs_THAI_ownerage.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_oa_1yr_THAI_ownerage.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_18mths_R-2011_ownerage.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_oa_30mths_BL-2010_ownerage.dta"{
erase "`x'"
}


********************************************************************************
**For figure 4 (b) - Death rates by gender of owner

foreach p in 3mths 6mths 9mths 1yr 1p25yrs 18mths 1p75yrs 2yrs 30mths 3yrs{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 


drop if surveyname=="TTHAI" | surveyname=="NGLSMS-ISA"

levelsof surveyname if survival_`p'!=., local(svyname) 

foreach x of local svyname{ 

forvalues y=0/2{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

count if survival_`p'==0 & surveyname=="`x'" & mfj==`y'
mat help1=`r(N)'
count if survival_`p'==1 & surveyname=="`x'" & mfj==`y'
mat help1=help1, `r(N)'
count if survival_`p'==. & surveyname=="`x'" & mfj==`y'
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g period="`p'"

g surveyname="`x'"

g mfj=`y'

save "Preparation of Data for Figures/Data for figures/Comb_cond_gj_`p'_`x'`y'.dta", replace
}


use "Preparation of Data for Figures/Data for figures/Comb_cond_gj_`p'_`x'0.dta", clear

forvalues y=1/2{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_gj_`p'_`x'`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_gj_`p'_`x'`y'.dta"
}

save "Preparation of Data for Figures/Data for figures/Comb_cond_gj_`p'_`x'_mfj.dta", replace 
erase "Preparation of Data for Figures/Data for figures/Comb_cond_gj_`p'_`x'0.dta"

}
}	


*Redo it for Nigeria LSMS-ISA and TTHAI to have averages over all rounds with the same horizon
*Thailand
local list1 BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 R-2007 R-2008 R-2009 R-2010 R-2011 R-2012 R-2013
local list2 BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 R-2007 R-2008 R-2009 R-2010 R-2011 R-2012
local list3 BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 R-2007 R-2008 R-2009 R-2010 R-2011

local p1 1yr
local p2 2yrs
local p3 3yrs

local j=1

forvalues i=1/3{

foreach x of local list`i'{

forvalues y=0/2{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

count if survival_`p`i''==0 & country=="Thailand" & survey=="`x'" & mfj==`y'
mat help1=`r(N)'
count if survival_`p`i''==1 & country=="Thailand" & survey=="`x'" & mfj==`y'
mat help1=help1, `r(N)'
count if survival_`p`i''==. & country=="Thailand" & survey=="`x'" & mfj==`y'
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="`p`i''"

g country="Thailand"

g surveyname="TTHAI"

g mfj=`y'

local help="`x'"
save "Preparation of Data for Figures/Data for figures/Comb_cond_gj_`p`i''_THL_`help'`y'.dta", replace
}
}

use "Preparation of Data for Figures/Data for figures/Comb_cond_gj_`p`i''_THL_BL-19970.dta", clear

forvalues y=1/2{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_gj_`p`i''_THL_BL-1997`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_gj_`p`i''_THL_BL-1997`y'.dta"
}

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_gj_`p`i''_THAI.dta", replace 

local end=2014-`j'
forvalues d = 1998/`end'{
forvalues y=0/2{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_gj_`p`i''_THL_R-`d'`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_gj_`p`i''_THL_R-`d'`y'.dta"
}
}

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate (first) period country surveyname, by(mfj)

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_gj_`p`i''_THAI_mfj.dta", replace 
erase "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_gj_`p`i''_THAI.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_gj_`p`i''_THL_BL-19970.dta"

local j=`j'+1
}


*Nigeria

local list1 BL-2010 R-2012
local list2 BL-2010 R-2011

local p1 6mths
local p2 2yrs

local j=1

forvalues i=1/2{

foreach x of local list`i'{

forvalues y=0/2{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

count if survival_`p`i''==0 & surveyname=="NGLSMS-ISA" & survey=="`x'" & mfj==`y'
mat help1=`r(N)'
count if survival_`p`i''==1 & surveyname=="NGLSMS-ISA" & survey=="`x'" & mfj==`y'
mat help1=help1, `r(N)'
count if survival_`p`i''==. & surveyname=="NGLSMS-ISA" & survey=="`x'" & mfj==`y'
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="`p`i''"

g country="Nigeria"

g surveyname="NGLSMS-ISA"

g mfj=`y'

local help="`x'"
save "Preparation of Data for Figures/Data for figures/Comb_cond_gj_`p`i''_NGLSMSISA_`help'`y'.dta", replace
}
}

use "Preparation of Data for Figures/Data for figures/Comb_cond_gj_`p`i''_NGLSMSISA_BL-20100.dta", clear

forvalues y=1/2{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_gj_`p`i''_NGLSMSISA_BL-2010`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_gj_`p`i''_NGLSMSISA_BL-2010`y'.dta"
}

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_gj_`p`i''_NGLSMSISA.dta", replace 

local d=2013-`j'
forvalues y=0/2{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_gj_`p`i''_NGLSMSISA_R-`d'`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_gj_`p`i''_NGLSMSISA_R-`d'`y'.dta"
}


g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate (first) period country surveyname, by(mfj)

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_gj_`p`i''_NGLSMSISA_mfj.dta", replace 
erase "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_gj_`p`i''_NGLSMSISA.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_gj_`p`i''_NGLSMSISA_BL-20100.dta"

local j=`j'+1
}

set more off
local x1 BL-2010 
local x2 R-2011

local p1 30mths
local p2 18mths


forvalues i=1/2{

forvalues y=0/2{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

count if survival_`p`i''==0 & surveyname=="NGLSMS-ISA" & survey=="`x`i''" & mfj==`y'
mat help1=`r(N)'
count if survival_`p`i''==1 & surveyname=="NGLSMS-ISA" & survey=="`x`i''" & mfj==`y'
mat help1=help1, `r(N)'
count if survival_`p`i''==. & surveyname=="NGLSMS-ISA" & survey=="`x`i''" & mfj==`y'
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g period="`p`i''"

g surveyname="NGLSMS-ISA"

g mfj=`y'

save "Preparation of Data for Figures/Data for figures/Comb_cond_gj_`p`i''_`x`i''`y'.dta", replace
}


use "Preparation of Data for Figures/Data for figures/Comb_cond_gj_`p`i''_`x`i''1.dta", clear

forvalues y=1/2{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_gj_`p`i''_`x`i''`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_gj_`p`i''_`x`i''`y'.dta"
}

save "Preparation of Data for Figures/Data for figures/Comb_cond_gj_`p`i''_`x`i''_mfj.dta", replace 
erase "Preparation of Data for Figures/Data for figures/Comb_cond_gj_`p`i''_`x`i''0.dta"

}		
		
use				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_18mths_R-2011_mfj.dta",clear
append using	"Preparation of Data for Figures/Data for figures/Comb_cond_gj_30mths_BL-2010_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_gj_2yrs_NGLSMSISA_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_gj_6mths_NGLSMSISA_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_gj_3yrs_THAI_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_gj_2yrs_THAI_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_gj_1yr_THAI_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_3yrs_TOGOINF_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_3yrs_SLMS_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_3yrs_SLLSE_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_3yrs_SLKINFORMALITY_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_3yrs_MXFLS_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_3yrs_MALAWIFORM_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_30mths_SLMS_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_30mths_SLLSE_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_30mths_SLKINFORMALITY_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_30mths_KENYAGETAHEAD_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_2yrs_SLMS_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_2yrs_SLLSE_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_2yrs_BENINFORM_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1p75yrs_TOGOINF_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1p75yrs_SLMS_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1p75yrs_SLKINFORMALITY_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1p75yrs_SLKFEMBUSTRAINING_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1p75yrs_NGYOUWIN_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1p75yrs_MALAWIFORM_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_18mths_UGWINGS_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_18mths_SLMS_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_18mths_SLLSE_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1p25yrs_TOGOINF_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1p25yrs_SLMS_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1p25yrs_GHANAFLYP_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1yr_SLMS_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1yr_SLLSE_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1yr_SLKFEMBUSTRAINING_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1yr_NGYOUWIN_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1yr_MALAWIFORM_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1yr_KENYAGETAHEAD_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1yr_GHANAFLYP_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1yr_BENINFORM_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_9mths_TOGOINF_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_9mths_SLMS_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_9mths_GHANAFLYP_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_6mths_SLMS_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_6mths_SLLSE_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_6mths_GHANAFLYP_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_6mths_EGYPTMACROINS_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_3mths_SLMS_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_3mths_SLKFEMBUSTRAINING_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_3mths_GHANAFLYP_mfj.dta"


g years=0.25 if period=="3mths"
replace years=0.5 if period=="6mths"
replace years=0.75 if period=="9mths"
replace years=1 if period=="1yr"
replace years=1.25 if period=="1p25yrs"
replace years=1.5 if period=="18mths"
replace years=1.75 if period=="1p75yrs"
replace years=2 if period=="2yrs"
replace years=2.5 if period=="30mths"
replace years=3 if period=="3yrs"

label define mfj	0 "male" ///
					1 "female" ///
					2 "joint business"

label values mfj mfj				

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_gf_ALL_mfj.dta", replace

foreach x in	"Preparation of Data for Figures/Data for figures/Comb_cond_gj_18mths_R-2011_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_30mths_BL-2010_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_gj_2yrs_NGLSMSISA_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_gj_6mths_NGLSMSISA_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_gj_3yrs_THAI_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_gj_2yrs_THAI_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_gj_1yr_THAI_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_3yrs_TOGOINF_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_3yrs_SLMS_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_3yrs_SLLSE_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_3yrs_SLKINFORMALITY_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_3yrs_MXFLS_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_3yrs_MALAWIFORM_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_30mths_SLMS_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_30mths_SLLSE_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_30mths_SLKINFORMALITY_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_30mths_KENYAGETAHEAD_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_2yrs_SLMS_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_2yrs_SLLSE_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_2yrs_BENINFORM_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1p75yrs_TOGOINF_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1p75yrs_SLMS_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1p75yrs_SLKINFORMALITY_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1p75yrs_SLKFEMBUSTRAINING_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1p75yrs_NGYOUWIN_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1p75yrs_MALAWIFORM_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_18mths_UGWINGS_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_18mths_SLMS_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_18mths_SLLSE_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1p25yrs_TOGOINF_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1p25yrs_SLMS_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1p25yrs_GHANAFLYP_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1yr_SLMS_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1yr_SLLSE_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1yr_SLKFEMBUSTRAINING_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1yr_NGYOUWIN_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1yr_MALAWIFORM_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1yr_KENYAGETAHEAD_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1yr_GHANAFLYP_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_1yr_BENINFORM_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_9mths_TOGOINF_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_9mths_SLMS_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_9mths_GHANAFLYP_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_6mths_SLMS_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_6mths_SLLSE_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_6mths_GHANAFLYP_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_6mths_EGYPTMACROINS_mfj.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_3mths_SLMS_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_3mths_SLKFEMBUSTRAINING_mfj.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_gj_3mths_GHANAFLYP_mfj.dta"{
erase "`x'"
}		


********************************************************************************
**For figure 4 (c) - Death rates by education of owner

foreach p in 3mths 6mths 9mths 1yr 1p25yrs 18mths 1p75yrs 2yrs 30mths 3yrs{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 


drop if surveyname=="TTHAI" | surveyname=="NGLSMS-ISA"

levelsof surveyname if survival_`p'!=., local(svyname) 

foreach x of local svyname{ 

forvalues y=0/1{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 


count if survival_`p'==0 & surveyname=="`x'" & ownertertiary==`y'
mat help1=`r(N)'
count if survival_`p'==1 & surveyname=="`x'" & ownertertiary==`y'
mat help1=help1, `r(N)'
count if survival_`p'==. & surveyname=="`x'" & ownertertiary==`y'
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g period="`p'"

g surveyname="`x'"

g ownertertiary=`y'

save "Preparation of Data for Figures/Data for figures/Comb_cond_ed_`p'_`x'`y'.dta", replace
}


use "Preparation of Data for Figures/Data for figures/Comb_cond_ed_`p'_`x'0.dta", clear

append using "Preparation of Data for Figures/Data for figures/Comb_cond_ed_`p'_`x'1.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_ed_`p'_`x'1.dta"


save "Preparation of Data for Figures/Data for figures/Comb_cond_ed_`p'_`x'_edudummy.dta", replace 
erase "Preparation of Data for Figures/Data for figures/Comb_cond_ed_`p'_`x'0.dta"

}
}	

*Redo it for Nigeria LSMS-ISA and TTHAI to have averages over all rounds with the same horizon
*Thailand
local list1 BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 R-2007 R-2008 R-2009 R-2010 R-2011 R-2012 R-2013
local list2 BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 R-2007 R-2008 R-2009 R-2010 R-2011 R-2012
local list3 BL-1997 R-1998 R-1999 R-2000 R-2001 R-2002 R-2003 R-2004 R-2005 R-2006 R-2007 R-2008 R-2009 R-2010 R-2011

local p1 1yr
local p2 2yrs
local p3 3yrs

local j=1

forvalues i=1/3{

foreach x of local list`i'{

forvalues y=0/1{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

count if survival_`p`i''==0 & country=="Thailand" & survey=="`x'" & ownertertiary==`y'
mat help1=`r(N)'
count if survival_`p`i''==1 & country=="Thailand" & survey=="`x'" & ownertertiary==`y'
mat help1=help1, `r(N)'
count if survival_`p`i''==. & country=="Thailand" & survey=="`x'" & ownertertiary==`y'
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="`p`i''"

g country="Thailand"

g surveyname="TTHAI"

g ownertertiary=`y'

local help="`x'"
save "Preparation of Data for Figures/Data for figures/Comb_cond_ed_`p`i''_THL_`help'`y'.dta", replace
}
}

use "Preparation of Data for Figures/Data for figures/Comb_cond_ed_`p`i''_THL_BL-19970", clear

append using "Preparation of Data for Figures/Data for figures/Comb_cond_ed_`p`i''_THL_BL-19971.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_ed_`p`i''_THL_BL-19971.dta"


save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_ed_`p`i''_THAI.dta", replace 

local end=2014-`j'
forvalues d = 1998/`end'{
forvalues y=0/1{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_ed_`p`i''_THL_R-`d'`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_ed_`p`i''_THL_R-`d'`y'.dta"
}
}

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate (first) period country surveyname, by(ownertertiary)

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_ed_`p`i''_THAI_edudummy", replace 
erase "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_ed_`p`i''_THAI.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_ed_`p`i''_THL_BL-19970.dta"

local j=`j'+1
}


*Nigeria

local list1 BL-2010 R-2012
local list2 BL-2010 R-2011

local p1 6mths
local p2 2yrs

local j=1

forvalues i=1/2{

foreach x of local list`i'{

forvalues y=0/1{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

count if survival_`p`i''==0 & surveyname=="NGLSMS-ISA" & survey=="`x'" & ownertertiary==`y'
mat help1=`r(N)'
count if survival_`p`i''==1 & surveyname=="NGLSMS-ISA" & survey=="`x'" & ownertertiary==`y'
mat help1=help1, `r(N)'
count if survival_`p`i''==. & surveyname=="NGLSMS-ISA" & survey=="`x'" & ownertertiary==`y'
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g period="`p`i''"

g country="Nigeria"

g surveyname="NGLSMS-ISA"

g ownertertiary=`y'

local help="`x'"
save "Preparation of Data for Figures/Data for figures/Comb_cond_ed_`p`i''_NGLSMSISA_`help'`y'.dta", replace
}
}

use "Preparation of Data for Figures/Data for figures/Comb_cond_ed_`p`i''_NGLSMSISA_BL-20100", clear

append using "Preparation of Data for Figures/Data for figures/Comb_cond_ed_`p`i''_NGLSMSISA_BL-20101.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_ed_`p`i''_NGLSMSISA_BL-20101.dta"


save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_ed_`p`i''_NGLSMSISA.dta", replace 

local d=2013-`j'
forvalues y=0/1{
append using "Preparation of Data for Figures/Data for figures/Comb_cond_ed_`p`i''_NGLSMSISA_R-`d'`y'.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_ed_`p`i''_NGLSMSISA_R-`d'`y'.dta"
}


g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

collapse (sum) died survived missing b_totalfirmobs totalfirmobs (mean) deathrate lowb_deathrate uppb_deathrate (first) period country surveyname, by(ownertertiary)

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_ed_`p`i''_NGLSMSISA_edudummy", replace 
erase "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_ed_`p`i''_NGLSMSISA.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_ed_`p`i''_NGLSMSISA_BL-20100.dta"

local j=`j'+1
}

set more off
local x1 BL-2010 
local x2 R-2011

local p1 30mths
local p2 18mths


forvalues i=1/2{

forvalues y=0/1{

use CombinedMaster_RH, clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

count if survival_`p`i''==0 & surveyname=="NGLSMS-ISA" & survey=="`x`i''" & ownertertiary==`y'
mat help1=`r(N)'
count if survival_`p`i''==1 & surveyname=="NGLSMS-ISA" & survey=="`x`i''" & ownertertiary==`y'
mat help1=help1, `r(N)'
count if survival_`p`i''==. & surveyname=="NGLSMS-ISA" & survey=="`x`i''" & ownertertiary==`y'
mat help1=help1, `r(N)'
mat deathrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames deathrates=died survived missing

svmat deathrates, names(col)

keep died-missing
keep in 1

g b_totalfirmobs=died + survived + missing

g totalfirmobs=died + survived

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

g period="`p`i''"

g surveyname="NGLSMS-ISA"

g ownertertiary=`y'

save "Preparation of Data for Figures/Data for figures/Comb_cond_ed_`p`i''_`x`i''`y'.dta", replace
}


use "Preparation of Data for Figures/Data for figures/Comb_cond_ed_`p`i''_`x`i''0.dta", clear

append using "Preparation of Data for Figures/Data for figures/Comb_cond_ed_`p`i''_`x`i''1.dta"
erase "Preparation of Data for Figures/Data for figures/Comb_cond_ed_`p`i''_`x`i''1.dta"


save "Preparation of Data for Figures/Data for figures/Comb_cond_ed_`p`i''_`x`i''_edudummy.dta", replace 
erase "Preparation of Data for Figures/Data for figures/Comb_cond_ed_`p`i''_`x`i''0.dta"

}

use				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_ed_2yrs_NGLSMSISA_edudummy.dta",clear
append using	"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_ed_6mths_NGLSMSISA_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_ed_3yrs_THAI_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_ed_2yrs_THAI_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_ed_1yr_THAI_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_3yrs_TOGOINF_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_3yrs_SLMS_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_3yrs_SLLSE_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_3yrs_SLKINFORMALITY_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_3yrs_MXFLS_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_3yrs_MALAWIFORM_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_30mths_SLMS_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_30mths_SLLSE_edudummy.dta"  /// 
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_30mths_SLKINFORMALITY_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_30mths_KENYAGETAHEAD_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_2yrs_SLMS_edudummy.dta"   ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_2yrs_SLLSE_edudummy.dta"   ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_2yrs_BENINFORM_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1p75yrs_TOGOINF_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1p75yrs_SLMS_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1p75yrs_SLKINFORMALITY_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1p75yrs_SLKFEMBUSTRAINING_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1p75yrs_NGYOUWIN_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1p75yrs_MALAWIFORM_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_18mths_UGWINGS_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_18mths_SLMS_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_18mths_SLLSE_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1p25yrs_TOGOINF_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1p25yrs_SLMS_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1p25yrs_GHANAFLYP_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1yr_SLMS_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1yr_SLLSE_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1yr_SLKFEMBUSTRAINING_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1yr_NGYOUWIN_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1yr_MALAWIFORM_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1yr_KENYAGETAHEAD_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1yr_GHANAFLYP_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1yr_BENINFORM_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_9mths_TOGOINF_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_9mths_SLMS_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_9mths_GHANAFLYP_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_6mths_SLMS_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_6mths_SLLSE_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_6mths_GHANAFLYP_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_6mths_EGYPTMACROINS_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_3mths_SLMS_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_3mths_SLKFEMBUSTRAINING_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_3mths_GHANAFLYP_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_18mths_R-2011_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_30mths_BL-2010_edudummy.dta"


g years=0.25 if period=="3mths"
replace years=0.5 if period=="6mths"
replace years=0.75 if period=="9mths"
replace years=1 if period=="1yr"
replace years=1.25 if period=="1p25yrs"
replace years=1.5 if period=="18mths"
replace years=1.75 if period=="1p75yrs"
replace years=2 if period=="2yrs"
replace years=2.5 if period=="30mths"
replace years=3 if period=="3yrs"

label define ownertertiary	0 "no tertiary education" ///
							1 "has tertiary education"

label values ownertertiary ownertertiary						

save "Preparation of Data for Figures/Data for figures/Combdeathrates_cond_ed_ALL_edudummy.dta", replace

foreach x in	"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_ed_2yrs_NGLSMSISA_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_ed_6mths_NGLSMSISA_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_ed_3yrs_THAI_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_ed_2yrs_THAI_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Combdeathrates_cond_ed_1yr_THAI_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_3yrs_TOGOINF_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_3yrs_SLMS_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_3yrs_SLLSE_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_3yrs_SLKINFORMALITY_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_3yrs_MXFLS_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_3yrs_MALAWIFORM_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_30mths_SLMS_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_30mths_SLLSE_edudummy.dta"  /// 
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_30mths_SLKINFORMALITY_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_30mths_KENYAGETAHEAD_edudummy.dta"   ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_2yrs_SLMS_edudummy.dta"   ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_2yrs_SLLSE_edudummy.dta"   ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_2yrs_BENINFORM_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1p75yrs_TOGOINF_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1p75yrs_SLMS_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1p75yrs_SLKINFORMALITY_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1p75yrs_SLKFEMBUSTRAINING_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1p75yrs_NGYOUWIN_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1p75yrs_MALAWIFORM_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_18mths_UGWINGS_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_18mths_SLMS_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_18mths_SLLSE_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1p25yrs_TOGOINF_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1p25yrs_SLMS_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1p25yrs_GHANAFLYP_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1yr_SLMS_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1yr_SLLSE_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1yr_SLKFEMBUSTRAINING_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1yr_NGYOUWIN_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1yr_MALAWIFORM_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1yr_KENYAGETAHEAD_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1yr_GHANAFLYP_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_1yr_BENINFORM_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_9mths_TOGOINF_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_9mths_SLMS_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_9mths_GHANAFLYP_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_6mths_SLMS_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_6mths_SLLSE_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_6mths_GHANAFLYP_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_6mths_EGYPTMACROINS_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_3mths_SLMS_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_3mths_SLKFEMBUSTRAINING_edudummy.dta"  ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_3mths_GHANAFLYP_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_18mths_R-2011_edudummy.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_ed_30mths_BL-2010_edudummy.dta"{
erase "`x'"
}	

********************************************************************************
**For figures 6 and 8

use CombinedMaster_RH, clear
label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity" 11 "catastrophe"

g reasonclosure_4yrs=.
g reasonclosure_4p5yrs=.
							
foreach p in 3mths 6mths 9mths 1yr 1p25yrs 18mths 1p75yrs 2yrs 30mths 3yrs 3p5yrs 4yrs 4p5yrs 5yrs 5p5yrs 6yrs 8yrs 10yrs 11yrs 15yrs{


replace reasonclosure_`p'=1 if reasonforclosure_`p'==1 & country=="Sri Lanka" & surveyname=="SLLSE" & survey=="BL-2008"
replace reasonclosure_`p'=2 if reasonforclosure_`p'==2 & country=="Sri Lanka" & surveyname=="SLLSE" & survey=="BL-2008"
replace reasonclosure_`p'=4 if reasonforclosure_`p'==3 & country=="Sri Lanka" & surveyname=="SLLSE" & survey=="BL-2008"
replace reasonclosure_`p'=3 if reasonforclosure_`p'==4 & country=="Sri Lanka" & surveyname=="SLLSE" & survey=="BL-2008"
replace reasonclosure_`p'=10 if reasonforclosure_`p'==5 & country=="Sri Lanka" & surveyname=="SLLSE" & survey=="BL-2008"
replace reasonclosure_`p'=9 if reasonforclosure_`p'==6 & country=="Sri Lanka" & surveyname=="SLLSE" & survey=="BL-2008"
replace reasonclosure_`p'=5 if reasonforclosure_`p'==12 & country=="Sri Lanka" & surveyname=="SLLSE" & survey=="BL-2008"

label values reasonclosure_`p' closereason

*Only for closures we count (I checked and results do not change if we look at all closures)
g reasonclosure_blbus_`p'=reasonclosure_`p'*(1-survival_`p')
replace reasonclosure_blbus_`p'=. if reasonclosure_blbus_`p'==0
}

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

*for Uganda, only the study participants who opened a business, have an id, and they are those we want to have in the regression, so I drop the others
drop if country=="Uganda" & firmid=="."

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

forvalues i=2/15{
g reasonclosure_blbus_`i'=.
}


*Generate closed in last horizon (not double counting firms)
egen uniquefirmids=group(firmid)
bysort unique: egen firstapp=min(wave)

keep if firstapp==wave

g e_closed=.


*BENINFORM:
egen help=rowmin(survival_1yr survival_2yrs) 
replace e_closed=1 if surveyname=="BENINFORM" & help==0
replace e_closed=0 if surveyname=="BENINFORM" & help==1
drop help
foreach y in reasonclosure_blbus{
local i=2
foreach x in 1yr 2yrs{
replace `y'_`i'=`y'_`x' if surveyname=="BENINFORM"
local i=`i'+1
}
}

*EYPGTMACROINS:
replace e_closed=1 if surveyname=="EYPGTMACROINS" & survival_6mths==0
replace e_closed=0 if surveyname=="EYPGTMACROINS" & survival_6mths==1

*GHANAFLYP:
egen help=rowmin(survival_3mths survival_6mths survival_9mths survival_1yr survival_1p25yrs) 
replace e_closed=1 if surveyname=="GHANAFLYP" & help==0
replace e_closed=0 if surveyname=="GHANAFLYP" & help==1
drop help

*KENYAGETAHEAD:
egen help=rowmin(survival_1yr survival_30mths) 
replace e_closed=1 if surveyname=="KENYAGETAHEAD" & help==0
replace e_closed=0 if surveyname=="KENYAGETAHEAD" & help==1
drop help
foreach y in reasonclosure_blbus{
local i=2
foreach x in 1yr 30mths{
replace `y'_`i'=`y'_`x' if surveyname=="KENYAGETAHEAD"
local i=`i'+1
}
}

*MALAWIFORM:
egen help=rowmin(survival_1yr survival_1p75yrs survival_3yrs survival_3p5yrs) 
replace e_closed=1 if surveyname=="MALAWIFORM" & help==0
replace e_closed=0 if surveyname=="MALAWIFORM" & help==1
drop help
foreach y in reasonclosure_blbus{
local i=2
foreach x in 1yr 1p75yrs 3yrs 3p5yrs{
replace `y'_`i'=`y'_`x' if surveyname=="MALAWIFORM"
local i=`i'+1
}
}

*NGYOUWIN:
egen help=rowmin(survival_1yr survival_1p75yrs survival_3p5yrs)
replace e_closed=1 if surveyname=="NGYOUWIN" & help==0
replace e_closed=0 if surveyname=="NGYOUWIN" & help==1
drop help
foreach y in reasonclosure_blbus{
local i=2
foreach x in 1yr 1p75yrs 3p5yrs{
replace `y'_`i'=`y'_`x' if surveyname=="NGYOUWIN"
local i=`i'+1
}
}

*SLKFEMBUSTRAINING:
egen help=rowmin(survival_3mths survival_1yr survival_1p75yrs survival_6yrs)
replace e_closed=1 if surveyname=="SLKFEMBUSTRAINING" & help==0
replace e_closed=0 if surveyname=="SLKFEMBUSTRAINING" & help==1
drop help
foreach y in reasonclosure_blbus{
local i=2
foreach x in 3mths 1yr 1p75yrs 6yrs{
replace `y'_`i'=`y'_`x' if surveyname=="SLKFEMBUSTRAINING"
local i=`i'+1
}
}

*SLKINFORMALITY:
egen help=rowmin(survival_1p75yrs survival_30mths survival_3yrs)
replace e_closed=1 if surveyname=="SLKINFORMALITY" & help==0
replace e_closed=0 if surveyname=="SLKINFORMALITY" & help==1
drop help
foreach y in reasonclosure_blbus{
local i=2
foreach x in 1p75yrs 30mths 3yrs{
replace `y'_`i'=`y'_`x' if surveyname=="SLKINFORMALITY"
local i=`i'+1
}
}

*SLLSE:
egen help=rowmin(survival_6mths survival_1yr survival_18mths survival_2yrs survival_30mths survival_3yrs survival_3p5yrs survival_4yrs survival_4p5yrs survival_5p5yrs)
replace e_closed=1 if surveyname=="SLLSE" & help==0
replace e_closed=0 if surveyname=="SLLSE" & help==1
drop help
foreach y in reasonclosure_blbus{
local i=2
foreach x in 6mths 1yr 18mths 2yrs 30mths 3yrs 3p5yrs 4yrs 4p5yrs 5p5yrs{
replace `y'_`i'=`y'_`x' if surveyname=="SLLSE"
local i=`i'+1
}
}

*SLMS
egen help=rowmin(survival_3mths survival_6mths survival_9mths survival_1yr survival_1p25yrs survival_18mths survival_1p75yrs survival_2yrs survival_30mths survival_3yrs survival_5yrs survival_5p5yrs survival_10yrs survival_11yrs)
replace e_closed=1 if surveyname=="SLMS" & help==0
replace e_closed=0 if surveyname=="SLMS" & help==1
drop help
foreach y in reasonclosure_blbus{
local i=2
foreach x in 3mths 6mths 9mths 1yr 1p25yrs 18mths 1p75yrs 2yrs 30mths 3yrs 5yrs 5p5yrs 10yrs 11yrs{
replace `y'_`i'=`y'_`x' if surveyname=="SLMS"
local i=`i'+1
}
}

*TOGOINF
egen help=rowmin(survival_9mths survival_1p25yrs survival_1p75yrs survival_3yrs)
replace e_closed=1 if surveyname=="TOGOINF" & help==0
replace e_closed=0 if surveyname=="TOGOINF" & help==1
drop help
foreach y in reasonclosure_blbus{
local i=2
foreach x in 9mths 1p25yrs 1p75yrs 3yrs{
replace `y'_`i'=`y'_`x' if surveyname=="TOGOINF"
local i=`i'+1
}
}

*UGWINGS
replace e_closed=1 if surveyname=="UGWINGS" & survival_18mths==0
replace e_closed=0 if surveyname=="UGWINGS" & survival_18mths==1

*Household survey: pool them (it is only relevant for NGLSMS and TTHAI)
*IFLS
egen help=rowmin(survival_8yrs survival_15yrs)
replace e_closed=1 if surveyname=="IFLS" & help==0
replace e_closed=0 if surveyname=="IFLS" & help==1
drop help

*MXFLS
egen help=rowmin(survival_3yrs survival_8yrs)
replace e_closed=1 if surveyname=="MXFLS" & help==0
replace e_closed=0 if surveyname=="MXFLS" & help==1
drop help

*NGLSMS-ISA
egen help=rowmin(survival_6mths survival_2yrs survival_30mths)
replace e_closed=1 if surveyname=="NGLSMS-ISA" & help==0 & wave==1
replace e_closed=0 if surveyname=="NGLSMS-ISA" & help==1 & wave==1
drop help

egen help=rowmin(survival_18mths survival_2yrs)
replace e_closed=1 if surveyname=="NGLSMS-ISA" & help==0 & wave==2
replace e_closed=0 if surveyname=="NGLSMS-ISA" & help==1 & wave==2
drop help

egen help=rowmin(survival_6mths)
replace e_closed=1 if surveyname=="NGLSMS-ISA" & help==0 & wave==3
replace e_closed=0 if surveyname=="NGLSMS-ISA" & help==1 & wave==3
drop help

*TTHAI
egen help=rowmin(survival_1yr)
replace e_closed=1 if surveyname=="TTHAI" & help==0 & wave==17
replace e_closed=0 if surveyname=="TTHAI" & help==1 & wave==17
drop help

egen help=rowmin(survival_1yr survival_2yrs)
replace e_closed=1 if surveyname=="TTHAI" & help==0 & wave==16
replace e_closed=0 if surveyname=="TTHAI" & help==1 & wave==16
drop help

egen help=rowmin(survival_1yr survival_2yrs survival_3yrs)
replace e_closed=1 if surveyname=="TTHAI" & help==0 & wave==15
replace e_closed=0 if surveyname=="TTHAI" & help==1 & wave==15
drop help

egen help=rowmin(survival_1yr survival_2yrs survival_3yrs survival_4yrs)
replace e_closed=1 if surveyname=="TTHAI" & help==0 & wave==14
replace e_closed=0 if surveyname=="TTHAI" & help==1 & wave==14
drop help

egen help=rowmin(survival_1yr survival_2yrs survival_3yrs survival_4yrs survival_5yrs)
replace e_closed=1 if surveyname=="TTHAI" & help==0 & wave==13
replace e_closed=0 if surveyname=="TTHAI" & help==1 & wave==13
drop help

egen help=rowmin(survival_1yr survival_2yrs survival_3yrs survival_4yrs survival_5yrs survival_6yrs)
replace e_closed=1 if surveyname=="TTHAI" & help==0 & wave==12
replace e_closed=0 if surveyname=="TTHAI" & help==1 & wave==12
drop help

egen help=rowmin(survival_1yr survival_2yrs survival_3yrs survival_4yrs survival_5yrs survival_6yrs survival_7yrs)
replace e_closed=1 if surveyname=="TTHAI" & help==0 & wave==11
replace e_closed=0 if surveyname=="TTHAI" & help==1 & wave==11
drop help

egen help=rowmin(survival_1yr survival_2yrs survival_3yrs survival_4yrs survival_5yrs survival_6yrs survival_7yrs survival_8yrs)
replace e_closed=1 if surveyname=="TTHAI" & help==0 & wave==10
replace e_closed=0 if surveyname=="TTHAI" & help==1 & wave==10
drop help

egen help=rowmin(survival_1yr survival_2yrs survival_3yrs survival_4yrs survival_5yrs survival_6yrs survival_7yrs survival_8yrs survival_9yrs)
replace e_closed=1 if surveyname=="TTHAI" & help==0 & wave==9
replace e_closed=0 if surveyname=="TTHAI" & help==1 & wave==9
drop help

egen help=rowmin(survival_1yr survival_2yrs survival_3yrs survival_4yrs survival_5yrs survival_6yrs survival_7yrs survival_8yrs survival_9yrs survival_10yrs)
replace e_closed=1 if surveyname=="TTHAI" & help==0 & wave==8
replace e_closed=0 if surveyname=="TTHAI" & help==1 & wave==8
drop help

egen help=rowmin(survival_1yr survival_2yrs survival_3yrs survival_4yrs survival_5yrs survival_6yrs survival_7yrs survival_8yrs survival_9yrs survival_10yrs survival_11yrs)
replace e_closed=1 if surveyname=="TTHAI" & help==0 & wave==7
replace e_closed=0 if surveyname=="TTHAI" & help==1 & wave==7
drop help

egen help=rowmin(survival_1yr survival_2yrs survival_3yrs survival_4yrs survival_5yrs survival_6yrs survival_7yrs survival_8yrs survival_9yrs survival_10yrs survival_11yrs survival_12yrs)
replace e_closed=1 if surveyname=="TTHAI" & help==0 & wave==6
replace e_closed=0 if surveyname=="TTHAI" & help==1 & wave==6
drop help

egen help=rowmin(survival_1yr survival_2yrs survival_3yrs survival_4yrs survival_5yrs survival_6yrs survival_7yrs survival_8yrs survival_9yrs survival_10yrs survival_11yrs survival_12yrs survival_13yrs)
replace e_closed=1 if surveyname=="TTHAI" & help==0 & wave==5
replace e_closed=0 if surveyname=="TTHAI" & help==1 & wave==5
drop help

egen help=rowmin(survival_1yr survival_2yrs survival_3yrs survival_4yrs survival_5yrs survival_6yrs survival_7yrs survival_8yrs survival_9yrs survival_10yrs survival_11yrs survival_12yrs survival_13yrs survival_14yrs)
replace e_closed=1 if surveyname=="TTHAI" & help==0 & wave==4
replace e_closed=0 if surveyname=="TTHAI" & help==1 & wave==4
drop help

egen help=rowmin(survival_1yr survival_2yrs survival_3yrs survival_4yrs survival_5yrs survival_6yrs survival_7yrs survival_8yrs survival_9yrs survival_10yrs survival_11yrs survival_12yrs survival_13yrs survival_14yrs survival_15yrs)
replace e_closed=1 if surveyname=="TTHAI" & help==0 & wave==3
replace e_closed=0 if surveyname=="TTHAI" & help==1 & wave==3
drop help

egen help=rowmin(survival_1yr survival_2yrs survival_3yrs survival_4yrs survival_5yrs survival_6yrs survival_7yrs survival_8yrs survival_9yrs survival_10yrs survival_11yrs survival_12yrs survival_13yrs survival_14yrs survival_15yrs survival_16yrs)
replace e_closed=1 if surveyname=="TTHAI" & help==0 & wave==2
replace e_closed=0 if surveyname=="TTHAI" & help==1 & wave==2
drop help

egen help=rowmin(survival_1yr survival_2yrs survival_3yrs survival_4yrs survival_5yrs survival_6yrs survival_7yrs survival_8yrs survival_9yrs survival_10yrs survival_11yrs survival_12yrs survival_13yrs survival_14yrs survival_15yrs survival_16yrs survival_17yrs)
replace e_closed=1 if surveyname=="TTHAI" & help==0 & wave==1
replace e_closed=0 if surveyname=="TTHAI" & help==1 & wave==1
drop help

*Labor productivity at baseline, based on sales
g lprod2=sales/(employees + 1)
replace lprod2=sales/(totalworkers+1) if surveyname=="BENINFORM" | surveyname=="MALAWIFORM" | surveyname=="TOGOINF"


*remove outliers:
levelsof surveyname , local(svyname) 
foreach x of local svyname{
forvalues i=1/17{
su lprod2 if (surveyname=="`x'" & wave==`i' ), detail
replace lprod2=. if surveyname=="`x'" & wave==`i' & lprod2>r(p99)
}
}

g loglprod2=log(lprod2)

forvalues i=2/15{
g newreasonclosure_blbus_`i'=reasonclosure_blbus_`i' 
}

forvalues i=3/15{
local j=`i'-1
order newreasonclosure_blbus_`i', after(newreasonclosure_blbus_`j')
}

egen total_newreasonclosure_blbus=rowtotal(newreasonclosure_blbus_2-newreasonclosure_blbus_15), m
egen hlpclr=rownonmiss(newreasonclosure_blbus_2-newreasonclosure_blbus_15)
egen hlpclr2=rowmax(newreasonclosure_blbus_2-newreasonclosure_blbus_15)

*Some firms have multiple closure reasons.
*-> I consider firms only first time they die.

g newreasonclosure_blbus=newreasonclosure_blbus_2
forvalues i=3/15{
replace newreasonclosure_blbus=newreasonclosure_blbus_`i' if newreasonclosure_blbus==.
}

egen test=rownonmiss(reasonclosure_blbus_2-reasonclosure_blbus_15)
egen reasonclosuremean=rowmean(reasonclosure_blbus_2-reasonclosure_blbus_15)
egen reasonclosuresd=rowsd(reasonclosure_blbus_2-reasonclosure_blbus_15)
g sdhelp=reasonclosuresd==0 if reasonclosuresd!=.

g reasonclosure_blbus=reasonclosuremean if test==1 | (test>1 & sdhelp==1)
*-> if multiple closures reported, I only consider those that always closed for the same reason -> I disregard 164 firms with multiple closure reasons
label values reasonclosure_blbus closereason

replace surveyname="NGLSMSISA" if surveyname=="NGLSMS-ISA"

save "Preparation of Data for Figures/Data for figures/labprod_ediedsurvived_clr.dta", replace


********************************************************************************
**For figures 7 and 8

use CombinedMaster_RH, clear

label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity" 11 "catastrophe"

g reasonclosure_4yrs=.
g reasonclosure_4p5yrs=.

foreach p in 3mths 6mths 9mths 1yr 1p25yrs 18mths 1p75yrs 2yrs 30mths 3yrs 4yrs 4p5yrs 3p5yrs 5yrs 5p5yrs 6yrs 8yrs 10yrs 11yrs 15yrs{

replace reasonclosure_`p'=1 if reasonforclosure_`p'==1 & country=="Sri Lanka" & surveyname=="SLLSE" & survey=="BL-2008"
replace reasonclosure_`p'=2 if reasonforclosure_`p'==2 & country=="Sri Lanka" & surveyname=="SLLSE" & survey=="BL-2008"
replace reasonclosure_`p'=4 if reasonforclosure_`p'==3 & country=="Sri Lanka" & surveyname=="SLLSE" & survey=="BL-2008"
replace reasonclosure_`p'=3 if reasonforclosure_`p'==4 & country=="Sri Lanka" & surveyname=="SLLSE" & survey=="BL-2008"
replace reasonclosure_`p'=10 if reasonforclosure_`p'==5 & country=="Sri Lanka" & surveyname=="SLLSE" & survey=="BL-2008"
replace reasonclosure_`p'=9 if reasonforclosure_`p'==6 & country=="Sri Lanka" & surveyname=="SLLSE" & survey=="BL-2008"
replace reasonclosure_`p'=5 if reasonforclosure_`p'==12 & country=="Sri Lanka" & surveyname=="SLLSE" & survey=="BL-2008"

label values reasonclosure_`p' closereason

*Only for closures we count (I checked and results do not change if we look at all closures)
g reasonclosure_blbus_`p'=reasonclosure_`p'*(1-survival_`p')
replace reasonclosure_blbus_`p'=. if reasonclosure_blbus_`p'==0


g mainactivityafterblbus_`p'=mainactivity_`p'*(1-survival_`p')
replace mainactivityafterblbus_`p'=. if mainactivityafterblbus_`p'==0
}


*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

*for Uganda, only the study participants who opened a business, have an id, and they are those we want to have in the regression, so I drop the others
drop if country=="Uganda" & firmid=="."

*generate id that is unique (for Thailand and Nigeria) to be able to reshape the data:
g firmidfrs=firmid
replace firmidfrs=firmid+"-"+survey if country=="Thailand" | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012"))


replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda"

foreach p in 3mths 6mths 9mths 1yr 1p25yrs 18mths 1p75yrs 2yrs 30mths 3yrs 3p5yrs 5yrs 5p5yrs 6yrs 8yrs 10yrs 11yrs 15yrs{
levelsof surveyname if laborincome_`p'!=.
}

forvalues i=2/15{
g survival_`i'=.
g laborincome_`i'=.
g reasonclosure_blbus_`i'=.
g mainactivityafterblbus_`i'=.
}

egen laborincomecheck=rowtotal(laborincome*), m
levelsof surveyname if laborincomecheck!=.

*BENINFORM:
foreach y in survival laborincome reasonclosure_blbus mainactivityafterblbus {
local i=2
foreach x in 1yr 2yrs{
replace `y'_`i'=`y'_`x' if surveyname=="BENINFORM"
local i=`i'+1
}
}

*KENYAGETAHEAD
foreach y in survival laborincome reasonclosure_blbus mainactivityafterblbus{
local i=2
foreach x in 1yr 30mths{
replace `y'_`i'=`y'_`x' if surveyname=="KENYAGETAHEAD"
local i=`i'+1
}
}

*MALAWIFORM
foreach y in survival laborincome reasonclosure_blbus mainactivityafterblbus{
local i=2
foreach x in 1yr 1p75yrs 3yrs 3p5yrs{
replace `y'_`i'=`y'_`x' if surveyname=="MALAWIFORM"
local i=`i'+1
}
}

*NGYOUWIN
foreach y in survival laborincome reasonclosure_blbus mainactivityafterblbus{
local i=2
foreach x in 1yr 1p75yrs 3p5yrs{
replace `y'_`i'=`y'_`x' if surveyname=="NGYOUWIN"
local i=`i'+1
}
}

*SLKFEMBUSTRAINING
foreach y in survival laborincome reasonclosure_blbus mainactivityafterblbus{
local i=2
foreach x in 3mths 1yr 1p75yrs 6yrs{
replace `y'_`i'=`y'_`x' if surveyname=="SLKFEMBUSTRAINING"
local i=`i'+1
}
}

*SLLSE
foreach y in survival laborincome reasonclosure_blbus mainactivityafterblbus{
local i=2
foreach x in 6mths 1yr 18mths 2yrs 30mths 3yrs 3p5yrs 4yrs 4p5yrs 5p5yrs{
replace `y'_`i'=`y'_`x' if surveyname=="SLLSE"
local i=`i'+1
}
}

*SLMS
foreach y in survival laborincome reasonclosure_blbus mainactivityafterblbus{
local i=2
foreach x in 3mths 6mths 9mths 1yr 1p25yrs 18mths 1p75yrs 2yrs 30mths 3yrs 5yrs 5p5yrs 10yrs 11yrs{
replace `y'_`i'=`y'_`x' if surveyname=="SLMS"
local i=`i'+1
}
}


*Remove outliers
forvalues i=2/15{
levelsof surveyname if laborincome_`i'!=., local(svyname) 
foreach x of local svyname{
su laborincome_`i' if surveyname=="`x'", detail
replace laborincome_`i'=. if surveyname=="`x'" & laborincome_`i'>r(p99)
}
}


forvalues i=2/15{
rename survival_`i' newsurvival_`i' 
rename reasonclosure_blbus_`i' newreasonclosure_blbus_`i'
rename mainactivityafterblbus_`i' newmainactivityafterblbus_`i'
}

keep if surveyname=="BENINFORM" | surveyname=="KENYAGETAHEAD"| surveyname=="MALAWIFORM"| surveyname=="NGYOUWIN"| surveyname=="SLKFEMBUSTRAINING" | surveyname=="SLLSE" | surveyname=="SLMS"

forvalues i=2/15{
g wavesurvey_`i'=1
}

forvalues i=4/15{
replace  wavesurvey_`i'=0 if surveyname=="BENINFORM" | surveyname=="KENYAGETAHEAD" 
}

forvalues i=6/15{
replace  wavesurvey_`i'=0 if surveyname=="MALAWIFORM" | surveyname=="SLKFEMBUSTRAINING"
}

forvalues i=5/15{
replace  wavesurvey_`i'=0 if surveyname=="NGYOUWIN"
}

forvalues i=12/15{
replace  wavesurvey_`i'=0 if surveyname=="SLLSE"
}


reshape long newsurvival_ newreasonclosure_blbus_ newmainactivityafterblbus_ laborincome_ wavesurvey_, i(firmid) j(newwave)

g loglaborincome=log(laborincome_+1)

save "Preparation of Data for Figures/Data for figures/laborincome_diedsurvivedint_clr.dta", replace
