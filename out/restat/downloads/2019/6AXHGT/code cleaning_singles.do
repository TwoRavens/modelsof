
drop _all
set maxvar 32000
use 2013raw

** ER53410 = whether wife in FU 
** 1 = Head is male and wife/"wife" in FU
** 2 = Head is male but no wife/"wife" in FU (ER54305 = 5)
** 3 = Head is female 
gen couple = 1 if ER53410 == 1
replace couple = 0 if couple == .
drop if couple == 1

gen singlemale = 1 if ER53410 == 2
replace singlemale = 0 if singlemale == .

gen singlefemale = 1 if ER53410 == 3
replace singlefemale = 0 if singlefemale == .

** Wage rate for year 2012 **
** wagem and wagef represents hourly wagerate of previous year in dollars and cents**
gen wagem = ER58118 if ER58118 != 999 & singlemale == 1
gen wagef = ER58118 if ER58118 != 999 & singlefemale == 1

** Average working hours per week **
** 998 is Dont Know **
** 999 is Not Applicable **
** 0 is did not work for money ** 
gen workhm = ER53156 if ER53156 != 998 & ER53156 != 999 & singlemale == 1
gen workhf = ER53156 if ER53156 != 998 & ER53156 != 999 & singlefemale == 1

** Time spent for housework per week **
** 998 = DK ** 
gen hworkm =  ER53676 if ER53676 != 998 & ER53676 != 999 & singlemale == 1
gen hworkf =  ER53676 if ER53676 != 998 & ER53676 != 999 & singlefemale == 1

gen leisurem = 112 - workhm - hworkm if singlemale == 1
gen leisuref = 112 - workhf - hworkf if singlefemale == 1 

gen agem = ER53017 if ER53017 != 999 &  singlemale == 1
gen agef = ER53017 if ER53017 != 999 &  singlefemale == 1

gen kids = ER53020 
gen members = ER53016 
gen nonmembers = ER53022 
gen havekids = 1 if kids != 0
replace havekids = 0 if kids == 0

** Drop if missing wage information **
drop if (wagem == 0 | wagem ==. ) & singlemale == 1 
drop if (wagef == 0 | wagef ==. ) & singlefemale == 1 
drop if (workhm == 0 | workhm ==.) & singlemale == 1 
drop if (workhf == 0 | workhf ==.) & singlefemale == 1
drop if (leisurem == . | leisurem < 0) & singlemale == 1
drop if (leisuref == . | leisuref < 0) & singlefemale == 1
drop if (hworkm == . | hworkm < 0) &  singlemale == 1 
drop if (hworkf == . | hworkf < 0) &  singlefemale == 1
drop if nonmembers != 0
drop if members > kids + 1 

** Annual expenditure **
gen food = FOOD13 
gen housing = HOUS13 
gen transport = TRAN13 
gen education = ED13
gen childcare = CHILD13
gen healthcare = HEALTH13
gen clothing = CLOTH13
gen recreation = TRIPS13 + OTHREC13
gen totalc =  food + housing+ transport+ education+ childcare +healthcare+ clothing +recreation

** Weekly Expenditure **
gen q = totalc/52 
gen nonlabor = q - wagem*workhm if singlemale == 1
replace nonlabor = q - wagef*workhf if singlefemale == 1

gen     gradem = 1 if ER57684 == 1 & singlemale == 1 
replace gradem = 0 if ER57684 == 5 & singlemale == 1 
gen     gradef = 1 if ER57684 == 1 & singlefemale == 1 
replace gradef = 0 if ER57684 == 5 & singlefemale == 1 
gen region = ER58215
gen metro = 1 if inlist(ER58216, 1,2,3,4)
replace metro = 0 if inlist(ER58216, 5,6,7,8,9)
gen ruralcode = ER58217
gen homeowner = 1 if ER53029 == 1
replace homeowner = 0 if ER53029 == 5 | ER53029 == 8

drop if gradem == . & singlemale == 1
drop if gradef == . & singlefemale == 1
drop if region > 4

gen bs_food      = food      /total 
gen bs_housing   = housing   /total 
gen bs_transport = transport /total 
gen bs_education = education /total 
gen bs_childcare = childcare /total 
gen bs_healthcare= healthcare/total
gen bs_clothing  = clothing  /total
gen bs_recreation= recreation/total

drop if workhm < 10 & singlemale == 1
drop if workhf < 10 & singlefemale == 1
sum wagem, de
gen trim1 = wagem if wagem > r(p1) & wagem < r(p99)
sum wagef, de
gen trim2 = wagef if wagef > r(p1) & wagef < r(p99)
drop if (trim1 == .  & singlemale == 1) |(trim2 ==. & singlefemale == 1)

keep wagem wagef workhm workhf agem agef kids hworkf hworkm leisurem leisuref q nonlabor gradem gradef region singlemale singlefemale /*
*/ couple members nonmembers havekids metro homeowner food housing transport education childcare healthcare clothing recreation totalc /*
*/ ruralcode bs_food bs_housing bs_transport bs_education bs_childcare bs_healthcare bs_clothing bs_recreation metro familyid13 

order wagem wagef workhm workhf agem agef kids hworkf hworkm leisurem leisuref q nonlabor gradem gradef region singlemale singlefemale /*
*/ couple members nonmembers havekids metro homeowner food housing transport education childcare healthcare clothing recreation totalc /*
*/ ruralcode bs_food bs_housing bs_transport bs_education bs_childcare bs_healthcare bs_clothing bs_recreation familyid13
sort familyid 

*=============================================================== 
* Table 36 summary statistics of single males and single females
*===============================================================
sum wagem workhm hworkm leisurem agem kids q if singlemale == 1
sum wagef workhf hworkf leisuref agef kids q if singlefemale == 1

*================================================================
* creating duplicates so that each sinlge is in 4 marriage market
*================================================================
* create 160 duplicate of each singles for each marriage market. 
* Then create an indicator variable (ind) taking value 1 if that single is present in that particular marriage market.
* Otherwise this value is 0. 
* Once this is done, drop all observations with indicator = 0. 
* Now we have data for singles where a copy of singles is present if that single if present in particular marriage market 

gen agecategory = 1 if agem <= 30 & singlemale == 1
replace agecategory = 2 if 31 <= agem  & agem <= 40 & singlemale == 1
replace agecategory = 3 if 41 <= agem  & agem <= 50 & singlemale == 1
replace agecategory = 4 if 51 <= agem  & agem <= 60 & singlemale == 1
replace agecategory = 5 if 61 <= agem  & singlemale == 1
replace agecategory = 1 if agef <= 30 & singlefemale == 1
replace agecategory = 2 if 31 <= agef  & agef <= 40 & singlefemale == 1
replace agecategory = 3 if 41 <= agef  & agef <= 50 & singlefemale == 1
replace agecategory = 4 if 51 <= agef  & agef <= 60 & singlefemale == 1
replace agecategory = 5 if 61 <= agef  & singlefemale == 1

gen grade = 0
replace grade = 1 if gradem == 1 & singlemale == 1
replace grade = 1 if gradef == 1 & singlefemale == 1

expand 160
gen ind = 0
sort familyid
by familyid: gen market = _n
by familyid: replace ind = 1 if  agecategory == 1 & region == 1 & grade == 0 & inlist(market, 1,2,3,4)
by familyid: replace ind = 1 if  agecategory == 1 & region == 1 & grade == 1 & inlist(market, 5,6,7,8)
by familyid: replace ind = 1 if  agecategory == 1 & region == 2 & grade == 0 & inlist(market, 9,10,11,12)
by familyid: replace ind = 1 if  agecategory == 1 & region == 2 & grade == 1 & inlist(market, 13,14,15,16)
by familyid: replace ind = 1 if  agecategory == 1 & region == 3 & grade == 0 & inlist(market, 17,18,19,20)
by familyid: replace ind = 1 if  agecategory == 1 & region == 3 & grade == 1 & inlist(market, 21,22,23,24)
by familyid: replace ind = 1 if  agecategory == 1 & region == 4 & grade == 0 & inlist(market, 25,26,27,28)
by familyid: replace ind = 1 if  agecategory == 1 & region == 4 & grade == 1 & inlist(market, 29,30,31,32)
by familyid: replace ind = 1 if  agecategory == 2 & region == 1 & grade == 0 & inlist(market, 33,34,35,36)
by familyid: replace ind = 1 if  agecategory == 2 & region == 1 & grade == 1 & inlist(market, 37,38,39,40)
by familyid: replace ind = 1 if  agecategory == 2 & region == 2 & grade == 0 & inlist(market, 41,42,43,44)
by familyid: replace ind = 1 if  agecategory == 2 & region == 2 & grade == 1 & inlist(market, 45,46,47,48)
by familyid: replace ind = 1 if  agecategory == 2 & region == 3 & grade == 0 & inlist(market, 49,50,51,52)
by familyid: replace ind = 1 if  agecategory == 2 & region == 3 & grade == 1 & inlist(market, 53,54,55,56)
by familyid: replace ind = 1 if  agecategory == 2 & region == 4 & grade == 0 & inlist(market, 57,58,59,60)
by familyid: replace ind = 1 if  agecategory == 2 & region == 4 & grade == 1 & inlist(market, 61,62,63,64)
by familyid: replace ind = 1 if  agecategory == 3 & region == 1 & grade == 0 & inlist(market, 65,66,67,68)
by familyid: replace ind = 1 if  agecategory == 3 & region == 1 & grade == 1 & inlist(market, 69,70,71,72)
by familyid: replace ind = 1 if  agecategory == 3 & region == 2 & grade == 0 & inlist(market, 73,74,75,76)
by familyid: replace ind = 1 if  agecategory == 3 & region == 2 & grade == 1 & inlist(market, 77,78,79,80)
by familyid: replace ind = 1 if  agecategory == 3 & region == 3 & grade == 0 & inlist(market, 81,82,83,84)
by familyid: replace ind = 1 if  agecategory == 3 & region == 3 & grade == 1 & inlist(market, 85,86,87,88)
by familyid: replace ind = 1 if  agecategory == 3 & region == 4 & grade == 0 & inlist(market, 89,90,91,92)
by familyid: replace ind = 1 if  agecategory == 3 & region == 4 & grade == 1 & inlist(market, 93,94,95,96)
by familyid: replace ind = 1 if  agecategory == 4 & region == 1 & grade == 0 & inlist(market, 97,98,99,100)
by familyid: replace ind = 1 if  agecategory == 4 & region == 1 & grade == 1 & inlist(market, 101,102,103,104)
by familyid: replace ind = 1 if  agecategory == 4 & region == 2 & grade == 0 & inlist(market, 105,106,107,108)
by familyid: replace ind = 1 if  agecategory == 4 & region == 2 & grade == 1 & inlist(market, 109,110,111,112)
by familyid: replace ind = 1 if  agecategory == 4 & region == 3 & grade == 0 & inlist(market, 113,114,115,116)
by familyid: replace ind = 1 if  agecategory == 4 & region == 3 & grade == 1 & inlist(market, 117,118,119,120)
by familyid: replace ind = 1 if  agecategory == 4 & region == 4 & grade == 0 & inlist(market, 121,122,123,124)
by familyid: replace ind = 1 if  agecategory == 4 & region == 4 & grade == 1 & inlist(market, 125,126,127,128)
by familyid: replace ind = 1 if  agecategory == 5 & region == 1 & grade == 0 & inlist(market, 129,130,131,132)
by familyid: replace ind = 1 if  agecategory == 5 & region == 1 & grade == 1 & inlist(market, 133,134,135,136)
by familyid: replace ind = 1 if  agecategory == 5 & region == 2 & grade == 0 & inlist(market, 137,138,139,140)
by familyid: replace ind = 1 if  agecategory == 5 & region == 2 & grade == 1 & inlist(market, 141,142,143,144)
by familyid: replace ind = 1 if  agecategory == 5 & region == 3 & grade == 0 & inlist(market, 145,146,147,148)
by familyid: replace ind = 1 if  agecategory == 5 & region == 3 & grade == 1 & inlist(market, 149,150,151,152)
by familyid: replace ind = 1 if  agecategory == 5 & region == 4 & grade == 0 & inlist(market, 153,154,155,156)
by familyid: replace ind = 1 if  agecategory == 5 & region == 4 & grade == 1 & inlist(market, 157,158,159,160)

drop if ind == 0
rename market id

order wagem wagef workhm workhf agem agef kids hworkf hworkm leisurem leisuref q nonlabor gradem gradef region agecategory singlemale singlefemale id /*
*/ members nonmembers havekids food housing transport education childcare healthcare clothing recreation totalc  /* 
*/ bs_food bs_housing bs_transport bs_education bs_childcare bs_healthcare bs_clothing bs_recreation homeowner metro grade 
sort id familyid
*save psid2013_singleswithduplicates, replace

append using psid_cleaned_onlycouples, generate(couples)
replace singlemale = 0 if singlemale == .
replace singlefemale = 0 if singlefemale == .
replace couple = 1 if couple == .

sort id
by id: egen numcouple = total(couple)
by id: egen numsinglemale = total(singlemale)
by id: egen numsinglefemale = total(singlefemale)
drop if numcouple == 0

sort id singlemale singlefemale couples familyid
order wagem wagef workhm workhf agem agef kids hworkf hworkm leisurem leisuref q nonlabor id gradem gradef region agecategory singlemale singlefemale couple familyid13/*
*/ members nonmembers havekids food housing transport education childcare healthcare clothing recreation totalc /*
*/bs_food bs_housing bs_transport bs_education bs_childcare bs_healthcare bs_clothing bs_recreation homeowner grade couple ruralcode numcouple numsinglemale numsinglefemale
 

save psid_cleaned_withsingles, replace
