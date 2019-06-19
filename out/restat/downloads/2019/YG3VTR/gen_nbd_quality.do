/*******************************************************************************

	THIS FILE GENERATES A MEASURE OF NEIGHBORHOOD QUALITY SIMILAR TO THE ONE USED IN 
	"Evidence of Neighborhood Effects from Moving to Opportunity: 
		LATEs of Neighborhood Quality"
	by Dionissi Aliprantis and Francisca G.-C. Richter
	SEE THE INCLUDED readme.txt FILE FOR AN EXPLANATION OF THIS FILE 

*******************************************************************************/

clear
set more off
use "$datapath\raw_NHGIS\ACS_2012_2016\ACS_2012_2016_raw.dta"

rename af35e003 families_w_kids
gen share_single_headed=(af35e005+af35e006+af35e007)/families_w_kids

rename af4oe001 total_pop_ed
gen total_pop_HS=af4oe017+af4oe018+af4oe019+af4oe020+af4oe021+af4oe022+af4oe023+af4oe024+af4oe025
gen total_pop_BA=af4oe022+af4oe023+af4oe024+af4oe025

gen HS=total_pop_HS/total_pop_ed
gen BA=total_pop_BA/total_pop_ed

gen poverty=(af43e002+af43e003)/af43e001

gen unemp=af67e005/af67e002
gen EPR=af67e004/af67e001
    
gsort + HS
gen CDF_HS=sum(total_pop)
sum CDF_HS, detail
replace CDF_HS=CDF_HS/r(max)

gsort + BA
gen CDF_BA=sum(total_pop)
sum CDF_BA, detail
replace CDF_BA=CDF_BA/r(max)

gsort - poverty
gen CDF_poverty=sum(total_pop)
sum CDF_poverty, detail
replace CDF_poverty=CDF_poverty/r(max)

gsort - share_single_headed
gen CDF_single=sum(total_pop)
sum CDF_single, detail
replace CDF_single=CDF_single/r(max)

*OJO - IN OUR MTO APPLICATION WE USE THE FEMALE UNEMPLOYMENT RATE
gsort - unemp
gen CDF_unemp=sum(total_pop)
sum CDF_unemp, detail
replace CDF_unemp=CDF_unemp/r(max)

*OJO - IN OUR MTO APPLICATION WE USE MALE EPR
gsort + EPR
gen CDF_EPR=sum(total_pop)
sum CDF_EPR, detail
replace CDF_EPR=CDF_EPR/r(max)

pca CDF_poverty CDF_EPR CDF_unemp CDF_HS CDF_BA CDF_single 
predict qual, score

screeplot

gsort + qual
gen CDF_qual=sum(total_pop)
sum CDF_qual, detail
replace CDF_qual=CDF_qual/r(max)

gen quality=100*CDF_qual

hist quality [w=total_pop]

foreach var in poverty EPR unemp HS BA share_single_headed {
corr `var' quality
}

