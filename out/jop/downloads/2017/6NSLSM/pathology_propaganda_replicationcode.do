******************************************************************************
**       Replication code for "The Pathology of Hard Propganda"            **
**       Journal of Politics                                                **
**       Haifeng Huang                                                      **
******************************************************************************


*** Dataset: pathology_propaganda_stata15data.dta ***
*** The dataset is saved in Stata 15 format ***


/*Variables:
china = satisfaction with China's overall situation
government = assessment of government responsiveness
anticorruption = support for the anti-corruption campaign
abroad = interest in moving abroad 
propaganda = attitudes toward government propaganda
protest = willingness to participate in protest

china_rescale = the variable china rescaled to vary from 0 to 1; china_rescale = (china-1)/4
government_rescale = the variable government rescaled to vary from 0 to 1; china_rescale = (government-1)/3
anticorruption_rescale = the variable anticorruption rescaled to vary from 0 to 1; china_rescale = (anticorruption-1)/6
abroad_rescale = the variable abroad rescaled to vary from 0 to 1; abroad_rescale = (abroad-1)/3
propaganda_rescale = the variable propaganda rescaled to vary from 0 to 1; propaganda_rescale = (propaganda-1)/4
protest_rescale = the variable protest rescaled to vary from 0 to 1; protest_rescale = (protest-1)/3

abroad_rescale_reverse =1 - abroad_rescale

aggregate_attitude = china_rescale + government_rescale + anticorruption_rescale + abroad_rescale_reverse + propaganda_rescale 

education = education level
income = family’s overall economic situation
age = age group (20-24, 25-29, 30-35, etc.)
female = gender (female=1)
ccpmember = membership in the Chinese Communist Party
pinterest = political interest
pride = national pride
stronggov = belief that China needs a strong government
life = life satisfaction
*/



************ Table 1 ************

clear
use pathology_propaganda_stata15data.dta


*** Inspection - Control ***

ttest china_rescale if group==0 | group==1, by(group) unequal 
ttest government_rescale if group==0 | group==1, by(group) unequal 
ttest anticorruption_rescale if group==0 | group==1, by(group) unequal 
ttest abroad_rescale if group==0 | group==1, by(group) unequal 
ttest propaganda_rescale if group==0 | group==1, by(group) unequal 
ttest aggregate_attitude if group==0 | group==1, by(group) unequal 
ttest protest_rescale if group==0 | group==1, by(group) unequal 


*** RZQ - Control ***

ttest china_rescale if group==0 | group==2, by(group) unequal 
ttest government_rescale if group==0 | group==2, by(group) unequal 
ttest anticorruption_rescale if group==0 | group==2, by(group) unequal 
ttest abroad_rescale if group==0 | group==2, by(group) unequal 
ttest propaganda_rescale if group==0 | group==2, by(group) unequal 
ttest aggregate_attitude if group==0 | group==2, by(group) unequal 
ttest protest_rescale if group==0 | group==2, by(group) unequal 


*** Gala - Control ***

ttest china_rescale if group==0 | group==3, by(group) unequal 
ttest government_rescale if group==0 | group==3, by(group) unequal 
ttest anticorruption_rescale if group==0 | group==3, by(group) unequal 
ttest abroad_rescale if group==0 | group==3, by(group) unequal 
ttest propaganda_rescale if group==0 | group==3, by(group) unequal 
ttest aggregate_attitude if group==0 | group==3, by(group) unequal 
ttest protest_rescale if group==0 | group==3, by(group) unequal 
 

*** Treated - Control ***

ttest china_rescale, by(treated) unequal 
ttest government_rescale, by(treated) unequal 
ttest anticorruption_rescale, by(treated) unequal
ttest abroad_rescale, by(treated) unequal 
ttest propaganda_rescale, by(treated) unequal 
ttest aggregate_attitude, by(treated) unequal
ttest protest_rescale, by(treated) unequal 
 
clear



************ Appendix.4 Balance Table ************

clear
use pathology_propaganda_stata15data.dta

oneway education group, t
oneway income group, t
oneway age group, t 
oneway female group, t
oneway ccpmember group, t
oneway pinterest group, t 
oneway pride group, t
oneway stronggov group, t
oneway life group, t

clear

 

************ Appendix.5 Group mean graphs ************

*** China Overall ***

clear
use pathology_propaganda_stata15data.dta

collapse (mean) mchina=china (sd) sdchina=china (count) nchina=china, by(group)
generate hichina = mchina+invttail(nchina, 0.025)*sdchina/sqrt(nchina)
generate lochina = mchina-invttail(nchina, 0.025)*sdchina/sqrt(nchina)
twoway (bar mchina group, barwidth(.4)) (rcap hichina lochina group, blwid(medthick) blcolor(navy) msize(large)), xlabel(0 "Control" 1 "Inspection" 2 "RZQ" 3 "Gala", noticks) ylabel(2.5(0.5)4)

*** Government Responsiveness ***

clear
use pathology_propaganda_stata15data.dta

collapse (mean) mgovernment=government (sd) sdgovernment=government (count) ngovernment=government, by(group)
generate higovernment = mgovernment+invttail(ngovernment, 0.025)*sdgovernment/sqrt(ngovernment)
generate logovernment = mgovernment-invttail(ngovernment, 0.025)*sdgovernment/sqrt(ngovernment)
twoway (bar mgovernment group, barwidth(.4)) (rcap higovernment logovernment group, blwid(medthick) blcolor(navy) msize(large)), xlabel(0 "Control" 1 "Inspection" 2 "RZQ" 3 "Gala", noticks) ylabel(2(0.5)3.5)

*** Anti-Corruption ***
clear
use pathology_propaganda_stata15data.dta

collapse (mean) manticorruption=anticorruption (sd) sdanticorruption=anticorruption (count) nanticorruption=anticorruption, by(group)
generate hianticorruption = manticorruption+invttail(nanticorruption, 0.025)*sdanticorruption/sqrt(nanticorruption)
generate loanticorruption = manticorruption-invttail(nanticorruption, 0.025)*sdanticorruption/sqrt(nanticorruption)
twoway (bar manticorruption group, barwidth(.4)) (rcap hianticorruption loanticorruption group, blwid(medthick) blcolor(navy) msize(large)), xlabel(0 "Control" 1 "Inspection" 2 "RZQ" 3 "Gala", noticks) ylabel(5.5(0.5)7)

*** Move Abroad ***
clear
use pathology_propaganda_stata15data.dta

collapse (mean) mabroad=abroad (sd) sdabroad=abroad (count) nabroad=abroad, by(group)
generate hiabroad = mabroad+invttail(nabroad, 0.025)*sdabroad/sqrt(nabroad)
generate loabroad = mabroad-invttail(nabroad, 0.025)*sdabroad/sqrt(nabroad)
twoway (bar mabroad group, barwidth(.4)) (rcap hiabroad loabroad group, blwid(medthick) blcolor(navy) msize(large)), xlabel(0 "Control" 1 "Inspection" 2 "RZQ" 3 "Gala", noticks) ylabel(1.5(0.5)2.5)

*** Propaganda ***
clear
use pathology_propaganda_stata15data.dta

collapse (mean) mpropaganda=propaganda (sd) sdpropaganda=propaganda (count) npropaganda=propaganda, by(group)
generate hipropaganda = mpropaganda+invttail(npropaganda, 0.025)*sdpropaganda/sqrt(npropaganda)
generate lopropaganda = mpropaganda-invttail(npropaganda, 0.025)*sdpropaganda/sqrt(npropaganda)
twoway (bar mpropaganda group, barwidth(.4)) (rcap hipropaganda lopropaganda group, blwid(medthick) blcolor(navy) msize(large)), xlabel(0 "Control" 1 "Inspection" 2 "RZQ" 3 "Gala", noticks) ylabel(2.5(0.5)4)

*** Protest ***
clear
use pathology_propaganda_stata15data.dta

collapse (mean) mprotest=protest (sd) sdprotest=protest (count) nprotest=protest, by(group)
generate hiprotest = mprotest+invttail(nprotest, 0.025)*sdprotest/sqrt(nprotest)
generate loprotest = mprotest-invttail(nprotest, 0.025)*sdprotest/sqrt(nprotest)
twoway (bar mprotest group, barwidth(.4)) (rcap hiprotest loprotest group, blwid(medthick) blcolor(navy) msize(large)), xlabel(0 "Control" 1 "Inspection" 2 "RZQ" 3 "Gala", noticks) ylabel(1.5(0.5)2.5)

clear



************ Appendix.6 Regression Analysis ************ 
****** Installation of SPost13 (http://www.indiana.edu/~jslsoc/spost13.htm) is needed to replicate this section ******

clear
use pathology_propaganda_stata15data.dta

*** Table S3 ***

ologit china inspectiongroup rzqgroup galagroup education income age female ccpmember
listcoef, std help

ologit government inspectiongroup rzqgroup galagroup education income age female ccpmember 
listcoef, std help

ologit anticorruption inspectiongroup rzqgroup galagroup education income age female ccpmember 
listcoef, std help

ologit abroad inspectiongroup rzqgroup galagroup education income age female ccpmember 
listcoef, std help

ologit propaganda inspectiongroup rzqgroup galagroup education income age female ccpmember
listcoef, std help

reg aggregate_attitude inspectiongroup rzqgroup galagroup education income age female ccpmember  
listcoef, std help

ologit protest inspectiongroup rzqgroup galagroup education income age female ccpmember 
listcoef, std help

*** Table S4 ***

ologit china inspectiongroup rzqgroup galagroup education income age female ccpmember pinterest pride stronggov life
listcoef, std help

ologit government inspectiongroup rzqgroup galagroup education income age female ccpmember pinterest pride stronggov life 
listcoef, std help

ologit anticorruption inspectiongroup rzqgroup galagroup education income age female ccpmember pinterest pride stronggov life
listcoef, std help

ologit abroad inspectiongroup rzqgroup galagroup education income age female ccpmember pinterest pride stronggov life  
listcoef, std help

ologit propaganda inspectiongroup rzqgroup galagroup education income age female ccpmember pinterest pride stronggov life  
listcoef, std help

reg aggregate_attitude inspectiongroup rzqgroup galagroup education income age female ccpmember pinterest pride stronggov life 
listcoef, std help

ologit protest inspectiongroup rzqgroup galagroup education income age female ccpmember pinterest pride stronggov life 
listcoef, std help


clear



************ Appendix.7 Sub-Group Analysis *********************

*** High Education ***

clear
use pathology_propaganda_stata15data.dta

keep if education >4

ttest china if group==0 | group==1, by(group) unequal   /* Inspection - Control */
ttest government if group==0 | group==1, by(group) unequal 
ttest anticorruption if group==0 | group==1, by(group) unequal 
ttest abroad if group==0 | group==1, by(group) unequal 
ttest propaganda if group==0 | group==1, by(group) unequal 
ttest aggregate_attitude if group==0 | group==1, by(group) unequal 
ttest protest if group==0 | group==1, by(group) unequal 

ttest china if group==0 | group==2, by(group) unequal   /* RZQ - Control */
ttest government if group==0 | group==2, by(group) unequal 
ttest anticorruption if group==0 | group==2, by(group) unequal 
ttest abroad if group==0 | group==2, by(group) unequal 
ttest propaganda if group==0 | group==2, by(group) unequal 
ttest aggregate_attitude if group==0 | group==2, by(group) unequal 
ttest protest if group==0 | group==2, by(group) unequal 

ttest china if group==0 | group==3, by(group) unequal   /* Gala - Control */
ttest government if group==0 | group==3, by(group) unequal 
ttest anticorruption if group==0 | group==3, by(group) unequal
ttest abroad if group==0 | group==3, by(group) unequal 
ttest propaganda if group==0 | group==3, by(group) unequal
ttest aggregate_attitude if group==0 | group==3, by(group) unequal 
ttest protest if group==0 | group==3, by(group) unequal 

clear


*** Low Education ***

clear
use pathology_propaganda_stata15data.dta

drop if education >4

ttest china if group==0 | group==1, by(group) unequal   /* Inspection - Control */
ttest government if group==0 | group==1, by(group) unequal 
ttest anticorruption if group==0 | group==1, by(group) unequal 
ttest abroad if group==0 | group==1, by(group) unequal 
ttest propaganda if group==0 | group==1, by(group) unequal 
ttest aggregate_attitude if group==0 | group==1, by(group) unequal
ttest protest if group==0 | group==1, by(group) unequal 

ttest china if group==0 | group==2, by(group) unequal   /* RZQ - Control */
ttest government if group==0 | group==2, by(group) unequal 
ttest anticorruption if group==0 | group==2, by(group) unequal 
ttest abroad if group==0 | group==2, by(group) unequal 
ttest propaganda if group==0 | group==2, by(group) unequal 
ttest aggregate_attitude if group==0 | group==2, by(group) unequal 
ttest protest if group==0 | group==2, by(group) unequal 

ttest china if group==0 | group==3, by(group) unequal   /* Gala - Control */
ttest government if group==0 | group==3, by(group) unequal 
ttest anticorruption if group==0 | group==3, by(group) unequal
ttest abroad if group==0 | group==3, by(group) unequal 
ttest propaganda if group==0 | group==3, by(group) unequal
ttest aggregate_attitude if group==0 | group==3, by(group) unequal 
ttest protest if group==0 | group==3, by(group) unequal 

clear


*** High Political Interest ***

clear
use pathology_propaganda_stata15data.dta

keep if pinterest >2

ttest china if group==0 | group==1, by(group) unequal   /* Inspection - Control */
ttest government if group==0 | group==1, by(group) unequal 
ttest anticorruption if group==0 | group==1, by(group) unequal 
ttest abroad if group==0 | group==1, by(group) unequal 
ttest propaganda if group==0 | group==1, by(group) unequal 
ttest aggregate_attitude if group==0 | group==1, by(group) unequal 
ttest protest if group==0 | group==1, by(group) unequal 

ttest china if group==0 | group==2, by(group) unequal   /* RZQ - Control */
ttest government if group==0 | group==2, by(group) unequal 
ttest anticorruption if group==0 | group==2, by(group) unequal 
ttest abroad if group==0 | group==2, by(group) unequal 
ttest propaganda if group==0 | group==2, by(group) unequal 
ttest aggregate_attitude if group==0 | group==2, by(group) unequal
ttest protest if group==0 | group==2, by(group) unequal 

ttest china if group==0 | group==3, by(group) unequal   /* Gala - Control */
ttest government if group==0 | group==3, by(group) unequal 
ttest anticorruption if group==0 | group==3, by(group) unequal
ttest abroad if group==0 | group==3, by(group) unequal 
ttest propaganda if group==0 | group==3, by(group) unequal
ttest aggregate_attitude if group==0 | group==3, by(group) unequal
ttest protest if group==0 | group==3, by(group) unequal 

clear


*** Low Political Interest ***

clear
use pathology_propaganda_stata15data.dta

drop if pinterest >2

ttest china if group==0 | group==1, by(group) unequal   /* Inspection - Control */
ttest government if group==0 | group==1, by(group) unequal 
ttest anticorruption if group==0 | group==1, by(group) unequal 
ttest abroad if group==0 | group==1, by(group) unequal 
ttest propaganda if group==0 | group==1, by(group) unequal 
ttest aggregate_attitude if group==0 | group==1, by(group) unequal
ttest protest if group==0 | group==1, by(group) unequal 

ttest china if group==0 | group==2, by(group) unequal   /* RZQ - Control */
ttest government if group==0 | group==2, by(group) unequal 
ttest anticorruption if group==0 | group==2, by(group) unequal 
ttest abroad if group==0 | group==2, by(group) unequal 
ttest propaganda if group==0 | group==2, by(group) unequal 
ttest aggregate_attitude if group==0 | group==2, by(group) unequal 
ttest protest if group==0 | group==2, by(group) unequal 

ttest china if group==0 | group==3, by(group) unequal   /* Gala - Control */
ttest government if group==0 | group==3, by(group) unequal 
ttest anticorruption if group==0 | group==3, by(group) unequal
ttest abroad if group==0 | group==3, by(group) unequal 
ttest propaganda if group==0 | group==3, by(group) unequal
ttest aggregate_attitude if group==0 | group==3, by(group) unequal
ttest protest if group==0 | group==3, by(group) unequal 

clear


*** High National Pride ***

clear
use pathology_propaganda_stata15data.dta

keep if pride >3

ttest china if group==0 | group==1, by(group) unequal   /* Inspection - Control */
ttest government if group==0 | group==1, by(group) unequal 
ttest anticorruption if group==0 | group==1, by(group) unequal 
ttest abroad if group==0 | group==1, by(group) unequal 
ttest propaganda if group==0 | group==1, by(group) unequal 
ttest aggregate_attitude if group==0 | group==1, by(group) unequal 
ttest protest if group==0 | group==1, by(group) unequal 

ttest china if group==0 | group==2, by(group) unequal   /* RZQ - Control */
ttest government if group==0 | group==2, by(group) unequal 
ttest anticorruption if group==0 | group==2, by(group) unequal 
ttest abroad if group==0 | group==2, by(group) unequal 
ttest propaganda if group==0 | group==2, by(group) unequal 
ttest aggregate_attitude if group==0 | group==2, by(group) unequal 
ttest protest if group==0 | group==2, by(group) unequal 

ttest china if group==0 | group==3, by(group) unequal   /* Gala - Control */
ttest government if group==0 | group==3, by(group) unequal 
ttest anticorruption if group==0 | group==3, by(group) unequal
ttest abroad if group==0 | group==3, by(group) unequal 
ttest propaganda if group==0 | group==3, by(group) unequal
ttest aggregate_attitude if group==0 | group==3, by(group) unequal 
ttest protest if group==0 | group==3, by(group) unequal 

clear


*** Low National Pride ***

clear
use pathology_propaganda_stata15data.dta

drop if pride >3

ttest china if group==0 | group==1, by(group) unequal   /* Inspection - Control */
ttest government if group==0 | group==1, by(group) unequal 
ttest anticorruption if group==0 | group==1, by(group) unequal 
ttest abroad if group==0 | group==1, by(group) unequal 
ttest propaganda if group==0 | group==1, by(group) unequal 
ttest aggregate_attitude if group==0 | group==1, by(group) unequal
ttest protest if group==0 | group==1, by(group) unequal 

ttest china if group==0 | group==2, by(group) unequal   /* RZQ - Control */
ttest government if group==0 | group==2, by(group) unequal 
ttest anticorruption if group==0 | group==2, by(group) unequal 
ttest abroad if group==0 | group==2, by(group) unequal 
ttest propaganda if group==0 | group==2, by(group) unequal 
ttest aggregate_attitude if group==0 | group==2, by(group) unequal 
ttest protest if group==0 | group==2, by(group) unequal 

ttest china if group==0 | group==3, by(group) unequal   /* Gala - Control */
ttest government if group==0 | group==3, by(group) unequal 
ttest anticorruption if group==0 | group==3, by(group) unequal
ttest abroad if group==0 | group==3, by(group) unequal 
ttest propaganda if group==0 | group==3, by(group) unequal
ttest aggregate_attitude if group==0 | group==3, by(group) unequal 
ttest protest if group==0 | group==3, by(group) unequal 

clear


*** High Belief in Strong Government ***

clear
use pathology_propaganda_stata15data.dta

keep if stronggov >3

ttest china if group==0 | group==1, by(group) unequal   /* Inspection - Control */
ttest government if group==0 | group==1, by(group) unequal 
ttest anticorruption if group==0 | group==1, by(group) unequal 
ttest abroad if group==0 | group==1, by(group) unequal 
ttest propaganda if group==0 | group==1, by(group) unequal 
ttest aggregate_attitude if group==0 | group==1, by(group) unequal 
ttest protest if group==0 | group==1, by(group) unequal 

ttest china if group==0 | group==2, by(group) unequal   /* RZQ - Control */
ttest government if group==0 | group==2, by(group) unequal 
ttest anticorruption if group==0 | group==2, by(group) unequal 
ttest abroad if group==0 | group==2, by(group) unequal 
ttest propaganda if group==0 | group==2, by(group) unequal 
ttest aggregate_attitude if group==0 | group==2, by(group) unequal 
ttest protest if group==0 | group==2, by(group) unequal 

ttest china if group==0 | group==3, by(group) unequal   /* Gala - Control */
ttest government if group==0 | group==3, by(group) unequal 
ttest anticorruption if group==0 | group==3, by(group) unequal
ttest abroad if group==0 | group==3, by(group) unequal 
ttest propaganda if group==0 | group==3, by(group) unequal
ttest aggregate_attitude if group==0 | group==3, by(group) unequal
ttest protest if group==0 | group==3, by(group) unequal 

clear


*** Low Belief in Strong Government ***

clear
use pathology_propaganda_stata15data.dta

drop if stronggov >3

ttest china if group==0 | group==1, by(group) unequal   /* Inspection - Control */
ttest government if group==0 | group==1, by(group) unequal 
ttest anticorruption if group==0 | group==1, by(group) unequal 
ttest abroad if group==0 | group==1, by(group) unequal 
ttest propaganda if group==0 | group==1, by(group) unequal 
ttest aggregate_attitude if group==0 | group==1, by(group) unequal 
ttest protest if group==0 | group==1, by(group) unequal 

ttest china if group==0 | group==2, by(group) unequal   /* RZQ - Control */
ttest government if group==0 | group==2, by(group) unequal 
ttest anticorruption if group==0 | group==2, by(group) unequal 
ttest abroad if group==0 | group==2, by(group) unequal 
ttest propaganda if group==0 | group==2, by(group) unequal 
ttest aggregate_attitude if group==0 | group==2, by(group) unequal
ttest protest if group==0 | group==2, by(group) unequal 

ttest china if group==0 | group==3, by(group) unequal   /* Gala - Control */
ttest government if group==0 | group==3, by(group) unequal 
ttest anticorruption if group==0 | group==3, by(group) unequal
ttest abroad if group==0 | group==3, by(group) unequal 
ttest propaganda if group==0 | group==3, by(group) unequal
ttest aggregate_attitude if group==0 | group==3, by(group) unequal
ttest protest if group==0 | group==3, by(group) unequal 

clear



exit

