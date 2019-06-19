// cex_sample.do -- build the CE sample 
// 
// Uses the 'merged_file' and 'prices' datasets from 
// Aguiar and Hurst (2009). Should be the same as the
// NBER CE extract available for 1980 to 2003 
// http://www.markaguiar.com/aguiarhurst/lifecycle/datapage.html
//
version 10

clear 
set mem 500m
set more off

capture log close
log using cex_sample.txt, text replace

use merged_file 
// http://www.markaguiar.com/aguiarhurst/lifecycle/datapage.html

/*********************
 *SAMPLE RESTRICTIONS
 ********************/

//only keep heads and married spouses
keep if relation > 0 & relation < 3

//generate some person level flags
gen byte wifebus_i = emptype == 3 & sex == 2 & marital == 1
//now merge as family level flags
egen wifebus = max(wifebus_i), by(year newid) 

//males, head or husband, aged 25 to 55 inclusive
keep if sex == 1
keep if age >= 25 & age <= 55

//must have worked full time for most of the year
keep if hrswkd >= 30
keep if wkswkd >= 40

//in non-farm paid or self employment
keep if emptype < 4
keep if farm == 0

//keep only full income reports
keep if fullyr == 1 & repstat == 1

//drop people with negative or zero labor + business income
gen negwagebus = (wages+bus) <= 0
//keep if wages + bus > 0

//drop people with negative of zero total income
gen negtotinc = (wages + bus + pension + socsec + ssi + unemp + workcomp ///
    + welfare + scholar + foodstmp + rents + div + interest <= 0)
//keep if wages + bus + pension + socsec + ssi + unemp + workcomp ///
//    + welfare + scholar + foodstmp + rents + div + interest > 0

//using the spouse info, exclude if conditional on being married
//the wife reports being self employed and the husband reports being employed
gen wifebus2 = wifebus & emptype < 3
sum wifebus2
drop if wifebus > 0 & emptype < 3

//don't use the Aguiar and Hurst restrictions
////must have expenditures in Aguiar and Hurst major non-durables
////food
//drop if foodhome + foodout + foodwork == 0
////housing services
//drop if  renthome + homeval2 == 0
////utilities
//drop if elect + gas + water + homefuel + telephon == 0
////clothing and personal care
//drop if  clothes + toiletry + hlthbeau + jewelry + tailors == 0
////nondurable transportation
//drop if  carservs + gasoline + tolls + autoins + masstran + othtrans == 0
////non durable entertainment
//drop if othrec == 0
//

//verify one observation per family
duplicates tag year newid , gen(dup)
assert dup == 0
drop dup

// sample count before non-negative income restriction
gen byte entre = emptype == 3
tab entre

tabstat negwagebus [aw=adjwt], by(entre)
tabstat negtotinc [aw=adjwt], by(entre)


// sample count after non-negative income restriction
drop if negwagebus | negtotinc
cap drop entre
gen byte entre = emptype == 3  
tab entre


/*********************
 *ADDITIONAL VARIABLES
 ********************/

//age group dummies
gen age3034 = (age >= 30 & age < 34)
gen age3539 = (age >= 35 & age < 40)
gen age4044 = (age >= 40 & age < 45)
gen age4549 = (age >= 45 & age < 49)
gen age5055 = (age >= 50 & age <= 55)
gen older = age4044 + age4549 + age5055

//other labor
gen hours = wkswkd * hrswkd

//other demographics
gen black = (race == 2)
gen married = (marital == 1)

//family size dummies
gen hhsize = round(famsize)
replace hhsize = 11 if famsize >= 10.5
tab hhsize, gen(hhsize_cat)
drop hhsize_cat1

//year dummies
tab year, gen(year_cat)
drop year_cat1

//education dummies
//recode the education variable so no diploma >= 1996 is considered hs dropout
//before 1996 variable measured grades completed
//after 1996 variable measured grades attended, with categories for completed
//this is slightly different than Aguiar and Hurst (2009) that treat
//12 years w/ or w/o diploma as HS grad
gen ed_cat1 = educatio < 12 | (educatio == 38 & year >= 1996) //
gen ed_cat2 = (educatio == 12 & year < 1996) | (educatio == 39 & year >= 1996)
gen ed_cat3 = (educatio >= 21 & educatio < 24 & year < 1996) | ///
    (educatio >= 40 & educatio < 43 & year >= 1996)
gen ed_cat4 = (educatio >=24 & educatio < 31 & year < 1996) | ///
    (educatio == 43 & year >= 1996)
gen ed_cat5 = (educatio >= 31 & educatio < . & year < 1996) | ///
    (educatio >= 44 & educatio <. & year >= 1996)
assert ed_cat1 + ed_cat2 + ed_cat3 + ed_cat4 + ed_cat5
drop ed_cat1


/******************************
 *INCOME / EXPENDITURE MEASURES
 *****************************/
//generate the expenditure/income measures using 
//Aguiar and Hurst (2009) categories

//non durables
gen foodin_nom=foodhome
gen foodaway_nom = foodout+foodwork
gen food_nom = foodin_nom + foodaway_nom  
gen clothes_pcare_nom = clothes + toiletry + hlthbeau + jewelry + tailors
gen utility_nom = elect	+ gas + water + homefuel + telephon
gen transport_nom = carservs + gasoline + tolls	+ autoins + masstran + othtrans
gen alc_tob_nom = tobacco + alcohol+niteclub
gen other_nd_nom = airfare + gambling + charity 
gen domestic_svcs_nom=servants
gen ent_nom=othrec
gen rent_nom = renthome + (homeval2) * 12
gen nondurable_nom = food_nom + alc_tob_nom + clothes_pcare_nom ///
    + other_nd_nom + utility_nom+domestic_svcs_nom + transport_nom + ent_nom
gen nondurable_housing_nom=nondurable_nom+ rent_nom
gen nondurable_core_nom = other_nd_nom +utility_nom+domestic_svcs_nom ///
    + ent_nom + rent_nom
gen work_related_nom = clothes_pcare_nom + transport_nom+foodaway_nom 
gen nondurable_housing_adj_nom = nondurable_housing_nom - alc_tob_nom

//other categories
gen extra_nom  = busiserv  + lifeins+ books + pubs+rentothr + housuppl
gen interest_and_taxes_nom=intauto+intoth+ohtax+ohint
gen durables_hhmaint_nom=furnish +autos+parts+recsport+ohmaint
gen education_nom = highedu + lowedu + othedu
gen health_nom = drugs + orthopd + doctors + hospital + nurshome + helthins
gen total_nominal_expenditures = nondurable_housing_nom + durables_hhmaint_nom ///
     + health_nom + education_nom + extra_nom

//expenditure shares
gen food_share = food_nom / total_nominal_expenditures
gen foodin_share = foodin_nom / total_nominal_expenditures
gen foodaway_share = foodaway_nom / total_nominal_expenditures
gen transport_share = transport_nom / total_nominal_expenditures
gen ent_share = ent_nom / total_nominal_expenditures
gen clothes_pcare_share = clothes_pcare_nom / total_nominal_expenditures
gen nondurable_share = nondurable_nom / total_nominal_expenditures
gen health_share = health_nom / total_nominal_expenditures
gen education_share = education_nom / total_nominal_expenditures

/***************************************
 *DEFLATED INCOME / EXPENDITURE MEASURES
 **************************************/

//use Aguiar and Hurst (2009) prices to deflate
sort date
merge date using prices, nokeep
tab _merge
drop _merge

//generate real expenditure (2000 dollars) using  product deflators
foreach var of varlist foodhome foodout foodwork renthome homeval2 ///
    clothes tailors jewelry toiletry hlthbeau elect gas water homefuel ///
    telephon autoins masstran othtrans gasoline tolls carservs tobacco ///
    alcohol niteclub busiserv lifeins books pubs rentothr housuppl ///
    servants airfare othrec gambling charity {
    gen `var'_real=`var'/`var'_price*100
}

//other variables (income / taxes) deflate by overall cpi
foreach var of varlist wages wage bus farm rents div interest pension	///
    socsec ssi unemp workcomp welfare scholar foodstmp gvpremia rrpremia ///
    sspremia fedtax statax pproptax othtax nontax insrefnd intauto intoth ///
    rentnpay homevalu ohint ohtax ohmaint ohprinc ohlump ohsold ohbuy ///
    ohmort1	ohmort2	ohtrans housadd	checkng	dcheckng saving	dsaving	securi ///
    dsecuri	carloan	tradein	carsold carprinc investb pnpremia sepremia ///
    deltaiou owe1 owe1q1 owe5 owe5q1 give receive give2	lumpsums othernet ///
    fedtax statax pproptax othtax nontax ohtax {
    cap drop `var'_real
    gen `var'_real=`var'/all_price*100
}

//create expenditure sub-categories
gen foodin = foodhome_real /*23*/
gen foodaway =  foodout_real + foodwork_real  /*24,25*/
gen food = foodin + foodaway 
gen rent = renthome_real + (homeval2_real) * 12 /*34,75*/
gen clothes_pcare = clothes_real + toiletry_real + hlthbeau_real ///
     + jewelry_real + tailors_real /*29...33*/
gen utility = elect_real	+ gas_real + water_real + homefuel_real ///
     + telephon_real /*38...42*/
gen transport = carservs_real + gasoline_real + tolls_real + autoins_real ///
     + masstran_real + othtrans_real /*54...59*/
gen alc_tob = tobacco_real + alcohol_real+niteclub_real /*26,27,28*/
gen domestic_svcs=servants_real /*43*/
gen ent=othrec_real /*64*/
gen other_nd = airfare_real + gambling_real + charity_real /*  60, 65, 69*/

gen nondurable = foodin + foodaway + alc_tob + clothes_pcare+ other_nd ///
     + utility + domestic_svcs + transport + ent
gen nondurable_housing = nondurable + rent
gen nondurable_core = other_nd + utility + domestic_svcs + ent + rent
gen work_related = clothes_pcare + transport + foodaway
gen nondurable_housing_adj = nondurable_housing - alc_tob
gen nondurable_core_food = nondurable_core + foodin

//define our income measures
gen laborbus = wages_real + bus_real
gen transfers = pension_real + socsec_real + ssi_real + unemp_real ///
     + workcomp_real + welfare_real + scholar_real + foodstmp_real
gen asset = rents_real + div_real + interest_real

gen taxtot = fedtax_real + statax_real + pproptax_real + othtax_real + nontax_real + ohtax_real

//generate the log income/expenditure measures we want
gen loglaborbus = log(laborbus)
gen loglaborbusasset = log(laborbus + asset)
gen logtotalinc = log(laborbus + transfers + asset)
gen loglaborbusextax = log(laborbus - taxtot)
gen logtotalincextax = log(laborbus + transfers + asset - taxtot)
gen logfood = log(food)
gen lognondur = log(nondurable)
gen logtotal = log(total_nominal_expenditures/all_price*100)
gen logent = log(ent)
gen logutil = log(utility) 
gen logcloth = log(clothes_pcare)
gen logtrans = log(transport)


//generate percentiles of the conditional income distribution
//we may use these to trim the sample
egen p1 = pctile(loglaborbus), p(1) by (entre)
egen p2 = pctile(loglaborbus), p(2) by (entre)
egen p5 = pctile(loglaborbus), p(5) by (entre)
egen p95 = pctile(loglaborbus), p(95) by (entre)
egen p98 = pctile(loglaborbus), p(98) by (entre)
egen p99 = pctile(loglaborbus), p(99) by (entre)

gen trim1 = loglaborbus > p1 & loglaborbus < p99
gen trim2 = loglaborbus > p2 & loglaborbus < p98
gen trim5 = loglaborbus > p5 & loglaborbus < p95


/******************************
 *ADD ANNUAL AGGREGATE TAX DATA
 *****************************/

//lagged tax years
replace year = year - 1

//top marginal tax rates from taxpolicycenter.org/taxfacts
gen top_taxrate_lag = 0
replace top_taxrate_lag = 70 if year <= 1980
replace top_taxrate_lag = 70 if year == 1981
replace top_taxrate_lag = 50 if year >= 1982 & year <= 1986
replace top_taxrate_lag = 38.5 if year == 1987
replace top_taxrate_lag = 28 if year == 1988 | year == 1989
replace top_taxrate_lag = 31 if year >= 1990 & year <= 1992
replace top_taxrate_lag = 39.6 if year >= 1993 & year <= 2000
replace top_taxrate_lag = 38.6 if year == 2001 | year == 2002
replace top_taxrate_lag = 35 if year >= 2003

//li geng's coding treats 1987/1988 differently
gen top_taxrate_g_lag = 0
replace top_taxrate_g_lag  = 70 if year <= 1980
replace top_taxrate_g_lag = 50 if year >= 1982 & year <= 1986
replace top_taxrate_g_lag = 38.5 if year == 1987
replace top_taxrate_g_lag = 33 if year >= 1988 & year <= 1990
replace top_taxrate_g_lag = 31 if year == 1991 | year == 1992
replace top_taxrate_g_lag = 39.6 if year >= 1993 & year <= 2000
replace top_taxrate_g_lag = 39.1 if year == 2001
replace top_taxrate_g_lag = 38.6 if year== 2002
replace top_taxrate_g_lag = 35 if year >= 2003

//average marginal rates taken from the NBER tax data
gen avgmar_taxrate_lag = 0
replace avgmar_taxrate_lag = 28.4 if year == 1979
replace avgmar_taxrate_lag = 30.1 if year == 1980
replace avgmar_taxrate_lag = 31.2 if year == 1981
replace avgmar_taxrate_lag = 29.2 if year == 1982
replace avgmar_taxrate_lag = 27.4 if year == 1983
replace avgmar_taxrate_lag = 27.2 if year == 1984
replace avgmar_taxrate_lag = 27.4 if year == 1985
replace avgmar_taxrate_lag = 28 if year == 1986
replace avgmar_taxrate_lag = 24.2 if year == 1987
replace avgmar_taxrate_lag = 22.7 if year == 1988
replace avgmar_taxrate_lag = 22.8 if year == 1989
replace avgmar_taxrate_lag = 22.7 if year == 1990
replace avgmar_taxrate_lag = 22.7 if year == 1991
replace avgmar_taxrate_lag = 22.7 if year == 1992
replace avgmar_taxrate_lag = 23.7 if year == 1993
replace avgmar_taxrate_lag = 24.2 if year == 1994
replace avgmar_taxrate_lag = 24.6 if year == 1995
replace avgmar_taxrate_lag = 24.7 if year == 1996
replace avgmar_taxrate_lag = 24.7 if year == 1997
replace avgmar_taxrate_lag = 24.8 if year == 1998
replace avgmar_taxrate_lag = 25.2 if year == 1999
replace avgmar_taxrate_lag = 25.5 if year == 2000
replace avgmar_taxrate_lag = 24.8 if year == 2001
replace avgmar_taxrate_lag = 24.2 if year == 2002
replace avgmar_taxrate_lag = 22 if year == 2003

//average tax rates from NBER tax data
gen avg_taxrate_lag = 0
replace avg_taxrate_lag = 14.9 if year == 1979
replace avg_taxrate_lag = 15.8 if year == 1980
replace avg_taxrate_lag = 16.3 if year == 1981
replace avg_taxrate_lag = 15.2 if year == 1982
replace avg_taxrate_lag = 14.4 if year == 1983
replace avg_taxrate_lag = 14.4 if year == 1984
replace avg_taxrate_lag = 14.5 if year == 1985
replace avg_taxrate_lag = 15.1 if year == 1986
replace avg_taxrate_lag = 13.5 if year == 1987
replace avg_taxrate_lag = 13.5 if year == 1988
replace avg_taxrate_lag = 13.4 if year == 1989
replace avg_taxrate_lag = 13.2 if year == 1990
replace avg_taxrate_lag = 13 if year == 1991
replace avg_taxrate_lag = 13.2 if year == 1992
replace avg_taxrate_lag = 13.7 if year == 1993
replace avg_taxrate_lag = 13.6 if year == 1994
replace avg_taxrate_lag = 13.9 if year == 1995
replace avg_taxrate_lag = 14.2 if year == 1996
replace avg_taxrate_lag = 14.3 if year == 1997
replace avg_taxrate_lag = 14.3 if year == 1998
replace avg_taxrate_lag = 14.8 if year == 1999
replace avg_taxrate_lag = 15.2 if year == 2000
replace avg_taxrate_lag = 13.6 if year == 2001
replace avg_taxrate_lag = 12.8 if year == 2002
replace avg_taxrate_lag = 11.4 if year == 2003

replace year = year + 1

//generate non lagged counterparts where tax_year = year
gen top_taxrate = 0
replace top_taxrate = 70 if year <= 1980
replace top_taxrate = 70 if year == 1981
replace top_taxrate = 50 if year >= 1982 & year <= 1986
replace top_taxrate = 38.5 if year == 1987
replace top_taxrate = 28 if year == 1988 | year == 1989
replace top_taxrate = 31 if year >= 1990 & year <= 1992
replace top_taxrate = 39.6 if year >= 1993 & year <= 2000
replace top_taxrate = 38.6 if year == 2001 | year == 2002
replace top_taxrate = 35 if year >= 2003

gen top_taxrate_g = 0
replace top_taxrate_g = 70 if year <= 1980
replace top_taxrate_g = 50 if year >= 1982 & year <= 1986
replace top_taxrate_g = 38.5 if year == 1987
replace top_taxrate_g = 33 if year >= 1988 & year <= 1990
replace top_taxrate_g = 31 if year == 1991 | year == 1992
replace top_taxrate_g = 39.6 if year >= 1993 & year <= 2000
replace top_taxrate_g = 39.1 if year == 2001
replace top_taxrate_g = 38.6 if year== 2002
replace top_taxrate_g = 35 if year >= 2003

gen avgmar_taxrate = 0
replace avgmar_taxrate = 30.1 if year == 1980
replace avgmar_taxrate = 31.2 if year == 1981
replace avgmar_taxrate = 29.2 if year == 1982
replace avgmar_taxrate = 27.4 if year == 1983
replace avgmar_taxrate = 27.2 if year == 1984
replace avgmar_taxrate = 27.4 if year == 1985
replace avgmar_taxrate = 28.0 if year == 1986
replace avgmar_taxrate = 24.2 if year == 1987
replace avgmar_taxrate = 22.7 if year == 1988
replace avgmar_taxrate = 22.8 if year == 1989
replace avgmar_taxrate = 22.7 if year == 1990
replace avgmar_taxrate = 22.7 if year == 1991
replace avgmar_taxrate = 22.7 if year == 1992
replace avgmar_taxrate = 23.7 if year == 1993
replace avgmar_taxrate = 24.2 if year == 1994
replace avgmar_taxrate = 24.6 if year == 1995
replace avgmar_taxrate = 24.7 if year == 1996
replace avgmar_taxrate = 24.7 if year == 1997
replace avgmar_taxrate = 24.8 if year == 1998
replace avgmar_taxrate = 25.2 if year == 1999
replace avgmar_taxrate = 25.5 if year == 2000
replace avgmar_taxrate = 24.8 if year == 2001
replace avgmar_taxrate = 24.2 if year == 2002
replace avgmar_taxrate = 22.0 if year == 2003

gen avg_taxrate = 0
replace avg_taxrate = 15.8 if year == 1980
replace avg_taxrate = 16.3 if year == 1981
replace avg_taxrate = 15.2 if year == 1982
replace avg_taxrate = 14.4 if year == 1983
replace avg_taxrate = 14.4 if year == 1984
replace avg_taxrate = 14.5 if year == 1985
replace avg_taxrate = 15.1 if year == 1986
replace avg_taxrate = 13.5 if year == 1987
replace avg_taxrate = 13.5 if year == 1988
replace avg_taxrate = 13.4 if year == 1989
replace avg_taxrate = 13.2 if year == 1990
replace avg_taxrate = 13 if year == 1991
replace avg_taxrate = 13.2 if year == 1992
replace avg_taxrate = 13.7 if year == 1993
replace avg_taxrate = 13.6 if year == 1994
replace avg_taxrate = 13.9 if year == 1995
replace avg_taxrate = 14.2 if year == 1996
replace avg_taxrate = 14.3 if year == 1997
replace avg_taxrate = 14.3 if year == 1998
replace avg_taxrate = 14.8 if year == 1999
replace avg_taxrate = 15.2 if year == 2000
replace avg_taxrate = 13.6 if year == 2001
replace avg_taxrate = 12.8 if year == 2002
replace avg_taxrate = 11.4 if year == 2003

//this is a special computation done by the NBER that computes
//the aggregate tax rates using the same 1995 income distribution 
//in each of the tax years
gen avgmar95_taxrate = 0
replace avgmar95_taxrate = 30.7 if year == 1979
replace avgmar95_taxrate = 31.6 if year == 1980
replace avgmar95_taxrate = 32.6 if year == 1981
replace avgmar95_taxrate = 29.9 if year == 1982
replace avgmar95_taxrate = 28.3 if year == 1983
replace avgmar95_taxrate = 28.7 if year == 1984
replace avgmar95_taxrate = 28.9 if year == 1985
replace avgmar95_taxrate = 28.9 if year == 1986
replace avgmar95_taxrate = 24.6 if year == 1987
replace avgmar95_taxrate = 22.6 if year == 1988
replace avgmar95_taxrate = 22.7 if year == 1989
replace avgmar95_taxrate = 22.7 if year == 1990
replace avgmar95_taxrate = 22.6 if year == 1991
replace avgmar95_taxrate = 22.5 if year == 1992
replace avgmar95_taxrate = 23.7 if year == 1993
replace avgmar95_taxrate = 24.2 if year == 1994
replace avgmar95_taxrate = 24.5 if year == 1995
replace avgmar95_taxrate = 24.8 if year == 1996
replace avgmar95_taxrate = 24.7 if year == 1997
replace avgmar95_taxrate = 24.9 if year == 1998
replace avgmar95_taxrate = 25.3 if year == 1999
replace avgmar95_taxrate = 25.6 if year == 2000
replace avgmar95_taxrate = 24.7 if year == 2001
replace avgmar95_taxrate = 24.3 if year == 2002
replace avgmar95_taxrate = 22 if year == 2003

gen avgmarbr_taxrate = 0
replace avgmarbr_taxrate = 27.35 if year == 1979	
replace avgmarbr_taxrate = 28.68 if year == 1980	
replace avgmarbr_taxrate = 29.39 if year == 1981	
replace avgmarbr_taxrate = 27.56 if year == 1982	
replace avgmarbr_taxrate = 25.68 if year == 1983	
replace avgmarbr_taxrate = 25.47 if year == 1984	
replace avgmarbr_taxrate = 26.07 if year == 1985	
replace avgmarbr_taxrate = 25.77 if year == 1986	
replace avgmarbr_taxrate = 23.53 if year == 1987	
replace avgmarbr_taxrate = 21.62 if year == 1988	
replace avgmarbr_taxrate = 21.69 if year == 1989	
replace avgmarbr_taxrate = 21.62 if year == 1990	
replace avgmarbr_taxrate = 21.74 if year == 1991	
replace avgmarbr_taxrate = 21.51 if year == 1992	
replace avgmarbr_taxrate = 22.45 if year == 1993	
replace avgmarbr_taxrate = 22.94 if year == 1994	
replace avgmarbr_taxrate = 23.24 if year == 1995	
replace avgmarbr_taxrate = 23.46 if year == 1996	
replace avgmarbr_taxrate = 23.7 if year == 1997	
replace avgmarbr_taxrate = 23.94 if year == 1998	
replace avgmarbr_taxrate = 24.33 if year == 1999	
replace avgmarbr_taxrate = 24.69 if year == 2000	
replace avgmarbr_taxrate = 23.83 if year == 2001	
replace avgmarbr_taxrate = 23.14 if year == 2002	
replace avgmarbr_taxrate = 21.16 if year == 2003
	
gen loggdp = 0
replace loggdp = 8.67231482828354 if year == 1980	
replace loggdp = 8.69737913607977 if year == 1981	
replace loggdp = 8.67776322304568 if year == 1982	
replace loggdp = 8.72196093704002 if year == 1983	
replace loggdp = 8.7913491976863 if year == 1984	
replace loggdp = 8.83190173625352 if year == 1985	
replace loggdp = 8.86594684460696 if year == 1986	
replace loggdp = 8.89744988726558 if year == 1987	
replace loggdp = 8.93773080315512 if year == 1988	
replace loggdp = 8.9728316336572 if year == 1989	
replace loggdp = 8.99142536774194 if year == 1990	
replace loggdp = 8.98908254157218 if year == 1991	
replace loggdp = 9.02245536786927 if year == 1992	
replace loggdp = 9.05057060125255 if year == 1993	
replace loggdp = 9.0905089898899 if year == 1994	
replace loggdp = 9.115337145057 if year == 1995	
replace loggdp = 9.15206486383043 if year == 1996	
replace loggdp = 9.19566318713003 if year == 1997	
replace loggdp = 9.23829594798951 if year == 1998	
replace loggdp = 9.28542929141519 if year == 1999	
replace loggdp = 9.32598779550214 if year == 2000	
replace loggdp = 9.33672629643983 if year == 2001	
replace loggdp = 9.35470042248302 if year == 2002	
replace loggdp = 9.379298028312 if year == 2003	
	


	

/*************************
 *FINAL CPS SAMPLE
 ************************/

capture log close

compress
label data "original cex sample without negative income"
save cex_sample, replace
