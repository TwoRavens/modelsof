
clear

use "/Users/claytoa/Dropbox/Gender_Budget_SubstRepr/JoP/Resubmission/Submitted/Resubmission 2/Final version/ClaytonZetterbergTab1.dta"

gen t=year
gen t2=t^2

//drop pre-existing quotas 

drop if preexisting_quota==1

xi i.country i.year i.country*t i.country*t2

gen lnODA = ln(ODA)
gen lnOil = ln(oil)
gen lnTrade = ln(Trade)
gen lnFDI = ln(FDI)


sort country year
by country: gen demlag = dem[_n-1] if year==year[_n-1]+1
by country: gen dem_cumlag = dem_cum[_n-1] if year==year[_n-1]+1
by country: gen autoclag = autoc[_n-1] if year==year[_n-1]+1
by country: gen leftlag = left[_n-1] if year==year[_n-1]+1
by country: gen left_cumlag = left_cum[_n-1] if year==year[_n-1]+1
by country: gen lnODAlag = lnODA[_n-1] if year==year[_n-1]+1
by country: gen lnOillag = lnOil[_n-1] if year==year[_n-1]+1
by country: gen lnTradelag = lnTrade[_n-1] if year==year[_n-1]+1
by country: gen lnFDIlag = lnFDI[_n-1] if year==year[_n-1]+1
by country: gen increaselag = initial_increase[_n-1] if year==year[_n-1]+1
by country: gen enforced_quotalag = enforced_quota[_n-1] if year==year[_n-1]+1
by country: gen adopt_quotalag = adopt_quota[_n-1] if year==year[_n-1]+1


		   
//Table 1 main specifications DV: % of total spending from WDI indicators 
//Model 1 (quota adoption)
reg percenthealth adopt_quotalag  demlag dem_cumlag autoclag leftlag left_cumlag lnODAlag lnOillag lnTradelag lnFDIlag _Iyear* _Icountry* t t2, cluster(country)

//Model 2 (quota implementation)
reg percenthealth enforced_quotalag  demlag dem_cumlag autoclag leftlag left_cumlag lnODAlag lnOillag lnTradelag lnFDIlag  _Iyear* _Icountry* t t2, cluster(country)

//Model 3 (quota shock) 
reg percenthealth increaselag demlag dem_cumlag autoclag leftlag left_cumlag lnODAlag lnOillag lnTradelag lnFDIlag _Iyear* _Icountry* t t2, cluster(country)

//Model 4 (quota adoption among high quota shock countries) 
reg percenthealth ever_high_adopt_treat demlag dem_cumlag autoclag leftlag left_cumlag lnODAlag lnOillag lnTradelag lnFDIlag _Iyear* _Icountry* t t2, cluster(country)

//Model 5 (quota adoption among low quota shock countries)
reg percenthealth ever_low_adopt_treat demlag dem_cumlag autoclag leftlag left_cumlag lnODAlag lnOillag lnTradelag lnFDIlag  _Iyear* _Icountry* t t2, cluster(country)


//Table 2: SUR with clarify package


clear

use "/Users/claytoa/Dropbox/Gender_Budget_SubstRepr/JoP/Resubmission/Submitted/Resubmission 2/Final version/ClaytonZetterbergTab2.dta"

set matsize 11000 

gen t=year
gen t2=t^2

//drop pre-existing quotas 

drop if preexisting_quota==1

xi i.country i.year i.country*t i.country*t2

gen lnODA = ln(ODA)
gen lnOil = ln(oil)
gen lnTrade = ln(Trade)
gen lnFDI = ln(FDI)


sort country year
by country: gen demlag = dem[_n-1] if year==year[_n-1]+1
by country: gen dem_cumlag = dem_cum[_n-1] if year==year[_n-1]+1
by country: gen autoclag = autoc[_n-1] if year==year[_n-1]+1
by country: gen leftlag = left[_n-1] if year==year[_n-1]+1
by country: gen left_cumlag = left_cum[_n-1] if year==year[_n-1]+1
by country: gen lnODAlag = lnODA[_n-1] if year==year[_n-1]+1
by country: gen lnOillag = lnOil[_n-1] if year==year[_n-1]+1
by country: gen lnTradelag = lnTrade[_n-1] if year==year[_n-1]+1
by country: gen lnFDIlag = lnFDI[_n-1] if year==year[_n-1]+1
by country: gen increaselag = initial_increase[_n-1] if year==year[_n-1]+1
by country: gen enforced_quotalag = enforced_quota[_n-1] if year==year[_n-1]+1
by country: gen adopt_quotalag = adopt_quota[_n-1] if year==year[_n-1]+1


gen EduPercent2 = EduPercent * 100
gen MilPercent2 = MilPercent * 100
gen HealthPercent2 = HealthPercent * 100
gen other2 = other * 100


set matsize 11000 


tlogit EduPercent2 y1 MilPercent2 y2  other2 y3, base(HealthPercent2) percent


estsimp sureg (y1 increaselag demlag dem_cumlag autoclag leftlag left_cumlag lnODAlag lnOillag lnTradelag lnFDIlag UNPeace BattleDeath  _Iyear* _Icountry* t t2) (y2 increaselag demlag dem_cumlag autoclag leftlag left_cumlag lnODAlag lnOillag lnTradelag lnFDIlag UNPeace BattleDeath  _Iyear* _Icountry* t t2) (y3 increaselag demlag dem_cumlag autoclag leftlag left_cumlag lnODAlag lnOillag lnTradelag lnFDIlag UNPeace BattleDeath _Iyear* _Icountry* t t2)

outtex, detail level 

