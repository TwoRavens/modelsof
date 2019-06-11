use "C:\Users\mjoshi2\Desktop\Working Projects\Internal Interactions RR\Joshi-Mason_Civil War Settlements, Size of Governing Coalition and Durability of Peace"
set more off 
//W " Winning Coalition size"//
gen W=0 
replace W=W+1 if (xrcomp>=2)
replace W=W+1 if (xropen>2)
replace W=W+1 if parcomp==5 
gen W_extend = W

//Governmental Incompatibility//
gen gov_incomp = 1 if incompatibility ==0
replace gov_incomp = 0 if gov_incomp==.

//Ethnic Conflicts with governmental incompatibility//
gen ethnic_gov_incomp = ethnic*gov_incomp

replace  eco_power = 0 if  eco_power==.

//Cold War =1 if year>1989//

gen coldwar = 1 if year>1989

replace coldwar = 0 if coldwar==.

//Generate log of battle death//
gen ln_battledeath = ln(battledeath)

//Generate ethnic conflict that secured territorial autonomy//
gen ethnic_autonomy = ethnic*cult_geo_auto

//Generate log of GDP Lag (lagged by one year)//
gen ln_gdplag = ln(gdplag)

//Generate log of population//
gen ln_pop = ln(pop)

//Replicating Table 1
//At Year 1
sum W if nego_s==1 & case_firstyear==1
sum W if rebel_v==1 & case_firstyear==1
sum W if gov_v==1 & case_firstyear==1
sum W if  case_firstyear==1

//at Year 5
sum W if at_5==5
sum W if at_5==5 & nego_s==1
sum W if at_5==5 & rebel_v==1
sum W if at_5==5 & gov_v==1

//Table 2 
//Model 1
ologit W wardur   join_govpolpact  eco_power army_united geo_autonomy  ln_gdplag  pastdemoc pko coldwar nego_settl gov_v  ln_battledeath factnum oil if  case_firstyear!=.,r
//Model2
ologit W wardur   join_govpolpact  eco_power army_united geo_autonomy ethnic  gov_incomp  pastdemoc  nego_settl gov_v  ln_battledeath factnum oil if  case_firstyear!=.,r
//Model 3
ologit W wardur   join_govpolpact  eco_power army_united geo_autonomy  ln_pop  pastdemoc  ethnic coldwar nego_settl gov_v  ln_battledeath factnum oil if  case_firstyear!=.,r

//Setting St for Table 4
stset year, id(peaceid) failure(peacefailure) origin(time year)


//Testing Model Specifications for Table 4
//Weibull  Models
streg W wardur   ln_gdplag   ln_pop pastdemoc pko coldwar nego_settl gov_v  ln_battledeath, d(w) cluster(ccode) time
estat ic
streg W wardur gov_incom ethnic oil  pko coldwar nego_settl gov_v  ln_battledeath, d(w) cluster(ccode) time
estat ic
streg W wardur oil  pko coldwar nego_settl gov_v  ln_battledeath, d(w) cluster(ccode) time
estat ic
streg W wardur oil  pko coldwar nego_settl gov_v  ln_battledeath factnum, d(w) cluster(ccode) time
estat ic

//Testing Model Specifications
//Log Normal Models
streg W wardur   ln_gdplag   ln_pop pastdemoc pko coldwar nego_settl gov_v  ln_battledeath, d(ln) cluster(ccode) time
estat ic
streg W wardur gov_incom ethnic oil  pko coldwar nego_settl gov_v  ln_battledeath, d(ln) cluster(ccode) time
estat ic
streg W wardur oil  pko coldwar nego_settl gov_v  ln_battledeath, d(ln) cluster(ccode) time
estat ic
streg W wardur oil  pko coldwar nego_settl gov_v  ln_battledeath factnum, d(ln) cluster(ccode) time
estat ic


//Testing Model Specifications
//Exponential Models
streg W wardur   ln_gdplag   ln_pop pastdemoc pko coldwar nego_settl gov_v  ln_battledeath, d(e) cluster(ccode) time
estat ic
streg W wardur gov_incom ethnic oil  pko coldwar nego_settl gov_v  ln_battledeath, d(e) cluster(ccode) time
estat ic
streg W wardur oil  pko coldwar nego_settl gov_v  ln_battledeath, d(e) cluster(ccode) time
estat ic
streg W wardur oil  pko coldwar nego_settl gov_v  ln_battledeath factnum, d(e) cluster(ccode) time
estat ic


//Testing Model Specifications
//Cox
stcox W wardur   ln_gdplag   ln_pop pastdemoc pko coldwar nego_settl gov_v  ln_battledeath, cluster(ccode) 
estat ic
stcox W wardur gov_incom ethnic oil  pko coldwar nego_settl gov_v  ln_battledeath, cluster(ccode) 
estat ic
stcox W wardur oil  pko coldwar nego_settl gov_v  ln_battledeath, cluster(ccode) 
estat ic
stcox W wardur oil  pko coldwar nego_settl gov_v  ln_battledeath factnum, cluster(ccode) 
estat ic

//Replicate Table 4
stset year, id(peaceid) failure(peacefailure) origin(time year)
//Model 1
streg W wardur   ln_gdplag   ln_pop pastdemoc pko coldwar nego_settl gov_v  ln_battledeath, d(ln) cluster(ccode) time
//Model 2
streg W wardur gov_incom ethnic oil  pko coldwar nego_settl gov_v  ln_battledeath, d(ln) cluster(ccode) time
//Model 3
streg W wardur oil  pko coldwar nego_settl gov_v  ln_battledeath, d(ln) cluster(ccode) time
//Model 4
streg W wardur oil  pko coldwar nego_settl gov_v  ln_battledeath factnum, d(ln) cluster(ccode) time

//replicate Table 3
//The following command will drop all observation beyond 5 years of post-civil war period
drop if drop==1
xtset year ccode
//Model 1
xtreg W wardur   join_govpolpact  eco_power army_united geo_autonomy  ln_gdplag  pastdemoc pko nego_settl gov_v  ln_battledeath factnum oil,  nonest cluster(ccode) fe
//Model 2
xtreg W wardur   join_govpolpact  eco_power army_united geo_autonomy ethnic  gov_incomp  pastdemoc  nego_settl gov_v  ln_battledeath factnum oil,  nonest cluster(ccode) fe
//Model 3
xtreg W wardur   join_govpolpact  eco_power army_united geo_autonomy  ln_pop  pastdemoc  ethnic nego_settl gov_v  ln_battledeath factnum oil,  nonest cluster(ccode) fe
