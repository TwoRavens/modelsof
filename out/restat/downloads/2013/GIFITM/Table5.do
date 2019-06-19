set more off
set mat 800
clear
capture log close
log using anMaritalFertileRevised.log, replace
use MaritalFertileData
*
* Regression runs for Fertility paper
*
* define variable lists
local yr "y1r2-y1r19 y3r2-y3r19 y4r2-y4r19"
local inst "cpcoalL1 cpcoalL2"
* drop state totals
drop if sttot==1
drop if year < 1971
egen tcat = group(cat t)
egen ttreat = group(treat t)
egen yrcat = group(cat year)
egen yrtreat = group(year treat)
*
* birth rate
*
reg crmbirth cearnL `yr' [aw=Pop], robust noconst
reg crmbirth cearnL `yr' [aw=Pop], noconst cluster(fips) 
ivreg crmbirth `yr' (cearnL = `inst') [aw=Pop], noconst cluster(fips) 
* 
* births
*
reg cmbirth cearnL `yr' [aw=Pop], noconst cluster(fips)
ivreg cmbirth `yr' (cearnL = `inst') [aw=Pop], noconst cluster(fips) 
*
* EJ sample
*  
* birth rate
*
reg crmbirth cearnL `yr' [aw=Pop] if treat > -1, noconst cluster(fips) 
ivreg crmbirth `yr' (cearnL = `inst')[aw=Pop] if treat>-1, noconst cluster(fips)
*
* births
*
reg cmbirth cearnL `yr' [aw=Pop] if treat > -1, noconst cluster(fips)          
ivreg cmbirth `yr' (cearnL = `inst')[aw=Pop] if treat>-1, noconst cluster(fips)
*
* Higher oder births
*
* birth rates
*
reg crmhorder cearnL `yr' [aw=Pop], noconst cluster(fips)
ivreg crmhorder `yr' (cearnL = `inst') [aw=Pop], noconst cluster(fips)
*
* (higher order) births
*
reg cmhorder cearnL `yr' [aw=Pop], noconst cluster(fips)                      
ivreg cmhorder `yr' (cearnL = `inst') [aw=Pop], noconst cluster(fips)         
*
* EJ sample
*
* birth rates
*         
reg crmhorder cearnL `yr' [aw=Pop] if treat > -1, noconst cluster(fips)
ivreg crmhorder `yr' (cearnL = `inst') [aw=Pop] if treat > -1, noconst cluster(fips)
*                                                                                      
* birth                                                                           
*                                                                                      
reg cmhorder cearnL `yr' [aw=Pop] if treat > -1, noconst cluster(fips)                
ivreg cmhorder `yr' (cearnL = `inst') [aw=Pop] if treat > -1, noconst cluster(fips)   



*
* First stage
*
reg cearnL `inst' `yr' [aw=Pop],  noconst hascon
testparm `inst'
reg cearnL `inst' `yr' [aw=Pop] if treat>-1, noconst hascon
testparm `inst'

log close
* end
