
/*===========================================================================
* Sample selection for the analysis reported in the main text of 
* "Marital matching, economies of scale and intrahousehold allocations"
* by Laurens Cherchye, Bram De Rock, Khushboo Surana and Frederic Vermeulen
=============================================================================*/


drop _all
set maxvar 32000
use 2013raw

** Wage rate for year 2012 
** wagem(male)and wagef (female) represents hourly wagerate of previous year in dollars and cents

gen wagem = ER58118 if ER58118 != 999
gen wagef = ER58119 if ER58119 != 999

label variable wagem "Wage rate of husband"
label variable wagef "Wage rate of wife"

** Average working hours per week 
** 998 is Dont Know 
** 999 is Not Applicable 
** 0 is did not work for money  
gen workhm = ER53156 if ER53156 != 998 & ER53156 != 999
gen workhf = ER53419 if ER53419 != 998 & ER53419 != 999 

label variable workhm "Hours worked in labor market by husband"
label variable workhf "Hours worked in labor market by wife"

gen agem = ER53017 if ER53017 != 999
gen agef = ER53019 if ER53019 != 999
gen kids = ER53020 
gen members = ER53016 
gen nonmembers = ER53022 
gen homeowner = 1 if ER53029 == 1
replace homeowner = 0 if ER53029 == 5 | ER53029 == 8
gen metro = 1 if inlist(ER58216, 1,2,3,4)
replace metro = 0 if inlist(ER58216, 5,6,7,8,9)

label variable agem "Age husband"
label variable agef "Age wife"
label variable kids "Number of children"
label variable homeowner "Home owner"
label variable members "Number of household members"
label variable nonmembers "Number of non-household members"
label variable metro "Living in metro"

** Marital Status 
** ER53023 is marital status of head 
** 1 = Married 
** 2 = Never Married 
** 3 = Widowed 
** 4 = Divorced
** 5 = Seperated 
** 8 = Dont Know 
** 9 = Refused 
gen married = 1 if ER53023 == 1 & agef != 0
replace married = 0 if married == . 

gen cohabitating = 1 if ER53023 != 1 & agef != 0
replace cohabitating = 0 if cohabitating == . 

label variable married "Married"
label variable cohabitating "Cohabitating"


** Drop if missing labor supply information or
** members other than couples or children are present 
drop if workhm == 0 | workhf == 0 | workhm ==. | workhf == . 
drop if nonmembers != 0
drop if members > kids + 2

** Time spent for housework per week 
** 998 = Dont know ** 
gen hworkf = ER53674 if ER53674 != 998 & ER53674 != 999
gen hworkm = ER53676 if ER53676 != 998 & ER53676 != 999
gen leisurem = 112 - workhm - hworkm
gen leisuref = 112 - workhf - hworkf

label variable hworkf "Hours worked in household by wife"
label variable hworkm "Hours worked in household by husband"
label variable leisuref "Leisure hours by wife"
label variable leisurem "Leisure hours by husband"

** Drop if missing information of time use 
drop if leisurem == . | leisurem < 0 
drop if leisuref == . | leisuref < 0 
drop if hworkf == . | hworkf < 0 
drop if hworkm == . | hworkm < 0 

** Annual expenditure 
gen food = FOOD13 
gen housing = HOUS13 
gen transport = TRAN13 
gen education = ED13
gen childcare = CHILD13
gen healthcare = HEALTH13
gen clothing = CLOTH13
gen recreation = TRIPS13 + OTHREC13
gen totalc =  food + housing+ transport+ education+ childcare +healthcare+ clothing +recreation

label variable food "Annual food expenditure"
label variable housing "Annual housing expenditure"
label variable transport "Annual tranport expenditure"
label variable education "Annual education expenditure"
label variable childcare "Annual childcare expenditure"
label variable healthcare "Annual healthcare expenditure"
label variable clothing "Annual clothing expenditure"
label variable recreation "Annual recreation expenditure"
label variable totalc  "Annual total expenditure"

** Weekly Expenditure 
gen q = totalc/52 
gen nonlabor = q - wagem*workhm - wagef*workhf 
label variable q "Weekly Hicksian consumption"
label variable nonlabor "Nonlabor income of household"

** Categorical variable based on number of children
gen kidcategory = 1 if kids == 0 
replace kidcategory = 2 if kids == 1 
replace kidcategory = 3 if kids == 2 
replace kidcategory = 4 if kids >= 3 
label variable kidcategory "Category number of children"
label define kidc  1 "No child" 2 "One child" 3 "Two children" 4 "More than two children"
label values kidcategory kidc

** Categorical variable based on age of husband
gen agecategory = 1 if agem <= 30
replace agecategory = 2 if 31 <= agem  & agem <= 40
replace agecategory = 3 if 41 <= agem  & agem <= 50
replace agecategory = 4 if 51 <= agem  & agem <= 60
replace agecategory = 5 if 61 <= agem  
label variable agecategory "Category age of husband"
label define agec  1 "<= 30" 2 "31-40" 3 "41-50" 4 "51-60" 5 ">= 61"
label values agecategory agec

** Categorical variable based on presence of college degree of husband and wife
gen gradehusband = 1 if ER57684 == 1
replace gradehusband = 0 if ER57684 == 5
gen gradewife = 1 if ER57574 == 1
replace gradewife = 0 if ER57574 == 5
label variable gradehusband "Husband has college degree"
label variable gradewife "Wife has college degree"
label define gradec 1 "Has degree" 0 "No degree"
label values gradehusband gradec
label values gradewife gradec

** Categorical variable based region of residence
gen region = ER58215
label variable region "Region of residence"
label define regionc 1 "Northeast" 2 "North Central" 3 "South" 4 "West"
label values region regionc

** Drop if missing information of husband's college degree or 
** if region of residence is outside Northeast, North Central, South or West
drop if gradehusband == . 
drop if region > 4

** Budget share: fraction of individual consumption category that form the Hicksian consumption
gen bs_food      = food      /total 
gen bs_housing   = housing   /total 
gen bs_transport = transport /total 
gen bs_education = education /total 
gen bs_childcare = childcare /total 
gen bs_healthcare= healthcare/total
gen bs_clothing  = clothing  /total
gen bs_recreation= recreation/total

label variable bs_food "Budget share food"
label variable bs_housing "Budget share housing"
label variable bs_transport "Budget share transport"
label variable bs_education "Budget share education"
label variable bs_childcare "Budget share childcare"
label variable bs_healthcare "Budget share healthcare"
label variable bs_clothing "Budget share clothing"
label variable bs_recreation "Budget share recreation"

** ID for marriage markets based on age category, region of residence, college degree of 
** husband and number of children in the household
gen id = 0
replace id = 1   if agecategory == 1 & region == 1 & gradehusband == 0 & kidcategory == 1 
replace id = 2   if agecategory == 1 & region == 1 & gradehusband == 0 & kidcategory == 2
replace id = 3   if agecategory == 1 & region == 1 & gradehusband == 0 & kidcategory == 3
replace id = 4   if agecategory == 1 & region == 1 & gradehusband == 0 & kidcategory == 4
replace id = 5   if agecategory == 1 & region == 1 & gradehusband == 1 & kidcategory == 1 
replace id = 6   if agecategory == 1 & region == 1 & gradehusband == 1 & kidcategory == 2
replace id = 7   if agecategory == 1 & region == 1 & gradehusband == 1 & kidcategory == 3
replace id = 8   if agecategory == 1 & region == 1 & gradehusband == 1 & kidcategory == 4
replace id = 9   if agecategory == 1 & region == 2 & gradehusband == 0 & kidcategory == 1 
replace id = 10  if agecategory == 1 & region == 2 & gradehusband == 0 & kidcategory == 2
replace id = 11  if agecategory == 1 & region == 2 & gradehusband == 0 & kidcategory == 3
replace id = 12  if agecategory == 1 & region == 2 & gradehusband == 0 & kidcategory == 4
replace id = 13  if agecategory == 1 & region == 2 & gradehusband == 1 & kidcategory == 1 
replace id = 14  if agecategory == 1 & region == 2 & gradehusband == 1 & kidcategory == 2
replace id = 15  if agecategory == 1 & region == 2 & gradehusband == 1 & kidcategory == 3
replace id = 16  if agecategory == 1 & region == 2 & gradehusband == 1 & kidcategory == 4
replace id = 17  if agecategory == 1 & region == 3 & gradehusband == 0 & kidcategory == 1 
replace id = 18  if agecategory == 1 & region == 3 & gradehusband == 0 & kidcategory == 2
replace id = 19  if agecategory == 1 & region == 3 & gradehusband == 0 & kidcategory == 3
replace id = 20  if agecategory == 1 & region == 3 & gradehusband == 0 & kidcategory == 4
replace id = 21  if agecategory == 1 & region == 3 & gradehusband == 1 & kidcategory == 1 
replace id = 22  if agecategory == 1 & region == 3 & gradehusband == 1 & kidcategory == 2
replace id = 23  if agecategory == 1 & region == 3 & gradehusband == 1 & kidcategory == 3
replace id = 24  if agecategory == 1 & region == 3 & gradehusband == 1 & kidcategory == 4
replace id = 25  if agecategory == 1 & region == 4 & gradehusband == 0 & kidcategory == 1 
replace id = 26  if agecategory == 1 & region == 4 & gradehusband == 0 & kidcategory == 2
replace id = 27  if agecategory == 1 & region == 4 & gradehusband == 0 & kidcategory == 3
replace id = 28  if agecategory == 1 & region == 4 & gradehusband == 0 & kidcategory == 4
replace id = 29  if agecategory == 1 & region == 4 & gradehusband == 1 & kidcategory == 1 
replace id = 30  if agecategory == 1 & region == 4 & gradehusband == 1 & kidcategory == 2
replace id = 31  if agecategory == 1 & region == 4 & gradehusband == 1 & kidcategory == 3
replace id = 32  if agecategory == 1 & region == 4 & gradehusband == 1 & kidcategory == 4
replace id = 33  if agecategory == 2 & region == 1 & gradehusband == 0 & kidcategory == 1 
replace id = 34  if agecategory == 2 & region == 1 & gradehusband == 0 & kidcategory == 2
replace id = 35  if agecategory == 2 & region == 1 & gradehusband == 0 & kidcategory == 3
replace id = 36  if agecategory == 2 & region == 1 & gradehusband == 0 & kidcategory == 4
replace id = 37  if agecategory == 2 & region == 1 & gradehusband == 1 & kidcategory == 1 
replace id = 38  if agecategory == 2 & region == 1 & gradehusband == 1 & kidcategory == 2
replace id = 39  if agecategory == 2 & region == 1 & gradehusband == 1 & kidcategory == 3
replace id = 40  if agecategory == 2 & region == 1 & gradehusband == 1 & kidcategory == 4
replace id = 41  if agecategory == 2 & region == 2 & gradehusband == 0 & kidcategory == 1 
replace id = 42  if agecategory == 2 & region == 2 & gradehusband == 0 & kidcategory == 2
replace id = 43  if agecategory == 2 & region == 2 & gradehusband == 0 & kidcategory == 3
replace id = 44  if agecategory == 2 & region == 2 & gradehusband == 0 & kidcategory == 4
replace id = 45  if agecategory == 2 & region == 2 & gradehusband == 1 & kidcategory == 1 
replace id = 46  if agecategory == 2 & region == 2 & gradehusband == 1 & kidcategory == 2
replace id = 47  if agecategory == 2 & region == 2 & gradehusband == 1 & kidcategory == 3
replace id = 48  if agecategory == 2 & region == 2 & gradehusband == 1 & kidcategory == 4
replace id = 49  if agecategory == 2 & region == 3 & gradehusband == 0 & kidcategory == 1 
replace id = 50  if agecategory == 2 & region == 3 & gradehusband == 0 & kidcategory == 2
replace id = 51  if agecategory == 2 & region == 3 & gradehusband == 0 & kidcategory == 3
replace id = 52  if agecategory == 2 & region == 3 & gradehusband == 0 & kidcategory == 4
replace id = 53  if agecategory == 2 & region == 3 & gradehusband == 1 & kidcategory == 1 
replace id = 54  if agecategory == 2 & region == 3 & gradehusband == 1 & kidcategory == 2
replace id = 55  if agecategory == 2 & region == 3 & gradehusband == 1 & kidcategory == 3
replace id = 56  if agecategory == 2 & region == 3 & gradehusband == 1 & kidcategory == 4
replace id = 57  if agecategory == 2 & region == 4 & gradehusband == 0 & kidcategory == 1 
replace id = 58  if agecategory == 2 & region == 4 & gradehusband == 0 & kidcategory == 2
replace id = 59  if agecategory == 2 & region == 4 & gradehusband == 0 & kidcategory == 3
replace id = 60  if agecategory == 2 & region == 4 & gradehusband == 0 & kidcategory == 4
replace id = 61  if agecategory == 2 & region == 4 & gradehusband == 1 & kidcategory == 1 
replace id = 62  if agecategory == 2 & region == 4 & gradehusband == 1 & kidcategory == 2
replace id = 63  if agecategory == 2 & region == 4 & gradehusband == 1 & kidcategory == 3
replace id = 64  if agecategory == 2 & region == 4 & gradehusband == 1 & kidcategory == 4
replace id = 65  if agecategory == 3 & region == 1 & gradehusband == 0 & kidcategory == 1 
replace id = 66  if agecategory == 3 & region == 1 & gradehusband == 0 & kidcategory == 2
replace id = 67  if agecategory == 3 & region == 1 & gradehusband == 0 & kidcategory == 3
replace id = 68  if agecategory == 3 & region == 1 & gradehusband == 0 & kidcategory == 4
replace id = 69  if agecategory == 3 & region == 1 & gradehusband == 1 & kidcategory == 1 
replace id = 70  if agecategory == 3 & region == 1 & gradehusband == 1 & kidcategory == 2
replace id = 71  if agecategory == 3 & region == 1 & gradehusband == 1 & kidcategory == 3
replace id = 72  if agecategory == 3 & region == 1 & gradehusband == 1 & kidcategory == 4
replace id = 73  if agecategory == 3 & region == 2 & gradehusband == 0 & kidcategory == 1 
replace id = 74  if agecategory == 3 & region == 2 & gradehusband == 0 & kidcategory == 2
replace id = 75  if agecategory == 3 & region == 2 & gradehusband == 0 & kidcategory == 3
replace id = 76  if agecategory == 3 & region == 2 & gradehusband == 0 & kidcategory == 4
replace id = 77  if agecategory == 3 & region == 2 & gradehusband == 1 & kidcategory == 1 
replace id = 78  if agecategory == 3 & region == 2 & gradehusband == 1 & kidcategory == 2
replace id = 79  if agecategory == 3 & region == 2 & gradehusband == 1 & kidcategory == 3
replace id = 80  if agecategory == 3 & region == 2 & gradehusband == 1 & kidcategory == 4
replace id = 81  if agecategory == 3 & region == 3 & gradehusband == 0 & kidcategory == 1 
replace id = 82  if agecategory == 3 & region == 3 & gradehusband == 0 & kidcategory == 2
replace id = 83  if agecategory == 3 & region == 3 & gradehusband == 0 & kidcategory == 3
replace id = 84  if agecategory == 3 & region == 3 & gradehusband == 0 & kidcategory == 4
replace id = 85  if agecategory == 3 & region == 3 & gradehusband == 1 & kidcategory == 1 
replace id = 86  if agecategory == 3 & region == 3 & gradehusband == 1 & kidcategory == 2
replace id = 87  if agecategory == 3 & region == 3 & gradehusband == 1 & kidcategory == 3
replace id = 88  if agecategory == 3 & region == 3 & gradehusband == 1 & kidcategory == 4
replace id = 89  if agecategory == 3 & region == 4 & gradehusband == 0 & kidcategory == 1 
replace id = 90  if agecategory == 3 & region == 4 & gradehusband == 0 & kidcategory == 2
replace id = 91  if agecategory == 3 & region == 4 & gradehusband == 0 & kidcategory == 3
replace id = 92  if agecategory == 3 & region == 4 & gradehusband == 0 & kidcategory == 4
replace id = 93  if agecategory == 3 & region == 4 & gradehusband == 1 & kidcategory == 1 
replace id = 94  if agecategory == 3 & region == 4 & gradehusband == 1 & kidcategory == 2
replace id = 95  if agecategory == 3 & region == 4 & gradehusband == 1 & kidcategory == 3
replace id = 96  if agecategory == 3 & region == 4 & gradehusband == 1 & kidcategory == 4
replace id = 97  if agecategory == 4 & region == 1 & gradehusband == 0 & kidcategory == 1 
replace id = 98  if agecategory == 4 & region == 1 & gradehusband == 0 & kidcategory == 2
replace id = 99  if agecategory == 4 & region == 1 & gradehusband == 0 & kidcategory == 3
replace id = 100 if agecategory == 4 & region == 1 & gradehusband == 0 & kidcategory == 4
replace id = 101 if agecategory == 4 & region == 1 & gradehusband == 1 & kidcategory == 1 
replace id = 102 if agecategory == 4 & region == 1 & gradehusband == 1 & kidcategory == 2
replace id = 103 if agecategory == 4 & region == 1 & gradehusband == 1 & kidcategory == 3
replace id = 104 if agecategory == 4 & region == 1 & gradehusband == 1 & kidcategory == 4
replace id = 105 if agecategory == 4 & region == 2 & gradehusband == 0 & kidcategory == 1 
replace id = 106 if agecategory == 4 & region == 2 & gradehusband == 0 & kidcategory == 2
replace id = 107 if agecategory == 4 & region == 2 & gradehusband == 0 & kidcategory == 3
replace id = 108 if agecategory == 4 & region == 2 & gradehusband == 0 & kidcategory == 4
replace id = 109 if agecategory == 4 & region == 2 & gradehusband == 1 & kidcategory == 1 
replace id = 110 if agecategory == 4 & region == 2 & gradehusband == 1 & kidcategory == 2
replace id = 111 if agecategory == 4 & region == 2 & gradehusband == 1 & kidcategory == 3
replace id = 112 if agecategory == 4 & region == 2 & gradehusband == 1 & kidcategory == 4
replace id = 113 if agecategory == 4 & region == 3 & gradehusband == 0 & kidcategory == 1 
replace id = 114 if agecategory == 4 & region == 3 & gradehusband == 0 & kidcategory == 2
replace id = 115 if agecategory == 4 & region == 3 & gradehusband == 0 & kidcategory == 3
replace id = 116  if agecategory == 4 & region == 3 & gradehusband == 0 & kidcategory == 4
replace id = 117  if agecategory == 4 & region == 3 & gradehusband == 1 & kidcategory == 1 
replace id = 118  if agecategory == 4 & region == 3 & gradehusband == 1 & kidcategory == 2
replace id = 119  if agecategory == 4 & region == 3 & gradehusband == 1 & kidcategory == 3
replace id = 120  if agecategory == 4 & region == 3 & gradehusband == 1 & kidcategory == 4
replace id = 121  if agecategory == 4 & region == 4 & gradehusband == 0 & kidcategory == 1 
replace id = 122  if agecategory == 4 & region == 4 & gradehusband == 0 & kidcategory == 2
replace id = 123  if agecategory == 4 & region == 4 & gradehusband == 0 & kidcategory == 3
replace id = 124  if agecategory == 4 & region == 4 & gradehusband == 0 & kidcategory == 4
replace id = 125  if agecategory == 4 & region == 4 & gradehusband == 1 & kidcategory == 1 
replace id = 126  if agecategory == 4 & region == 4 & gradehusband == 1 & kidcategory == 2
replace id = 127  if agecategory == 4 & region == 4 & gradehusband == 1 & kidcategory == 3
replace id = 128  if agecategory == 4 & region == 4 & gradehusband == 1 & kidcategory == 4
replace id = 129  if agecategory == 5 & region == 1 & gradehusband == 0 & kidcategory == 1 
replace id = 130  if agecategory == 5 & region == 1 & gradehusband == 0 & kidcategory == 2
replace id = 131  if agecategory == 5 & region == 1 & gradehusband == 0 & kidcategory == 3
replace id = 132  if agecategory == 5 & region == 1 & gradehusband == 0 & kidcategory == 4
replace id = 133  if agecategory == 5 & region == 1 & gradehusband == 1 & kidcategory == 1 
replace id = 134  if agecategory == 5 & region == 1 & gradehusband == 1 & kidcategory == 2
replace id = 135  if agecategory == 5 & region == 1 & gradehusband == 1 & kidcategory == 3
replace id = 136  if agecategory == 5 & region == 1 & gradehusband == 1 & kidcategory == 4
replace id = 137  if agecategory == 5 & region == 2 & gradehusband == 0 & kidcategory == 1 
replace id = 138  if agecategory == 5 & region == 2 & gradehusband == 0 & kidcategory == 2
replace id = 139  if agecategory == 5 & region == 2 & gradehusband == 0 & kidcategory == 3
replace id = 140  if agecategory == 5 & region == 2 & gradehusband == 0 & kidcategory == 4
replace id = 141  if agecategory == 5 & region == 2 & gradehusband == 1 & kidcategory == 1 
replace id = 142  if agecategory == 5 & region == 2 & gradehusband == 1 & kidcategory == 2
replace id = 143  if agecategory == 5 & region == 2 & gradehusband == 1 & kidcategory == 3
replace id = 144  if agecategory == 5 & region == 2 & gradehusband == 1 & kidcategory == 4
replace id = 145  if agecategory == 5 & region == 3 & gradehusband == 0 & kidcategory == 1 
replace id = 146  if agecategory == 5 & region == 3 & gradehusband == 0 & kidcategory == 2
replace id = 147  if agecategory == 5 & region == 3 & gradehusband == 0 & kidcategory == 3
replace id = 148  if agecategory == 5 & region == 3 & gradehusband == 0 & kidcategory == 4
replace id = 149  if agecategory == 5 & region == 3 & gradehusband == 1 & kidcategory == 1 
replace id = 150  if agecategory == 5 & region == 3 & gradehusband == 1 & kidcategory == 2
replace id = 151  if agecategory == 5 & region == 3 & gradehusband == 1 & kidcategory == 3
replace id = 152  if agecategory == 5 & region == 3 & gradehusband == 1 & kidcategory == 4
replace id = 153  if agecategory == 5 & region == 4 & gradehusband == 0 & kidcategory == 1 
replace id = 154  if agecategory == 5 & region == 4 & gradehusband == 0 & kidcategory == 2
replace id = 155  if agecategory == 5 & region == 4 & gradehusband == 0 & kidcategory == 3
replace id = 156  if agecategory == 5 & region == 4 & gradehusband == 0 & kidcategory == 4
replace id = 157  if agecategory == 5 & region == 4 & gradehusband == 1 & kidcategory == 1 
replace id = 158  if agecategory == 5 & region == 4 & gradehusband == 1 & kidcategory == 2
replace id = 159  if agecategory == 5 & region == 4 & gradehusband == 1 & kidcategory == 3
replace id = 160  if agecategory == 5 & region == 4 & gradehusband == 1 & kidcategory == 4
label variable id "Marriage market id"

** Further sample selection
** Keep the housholds where both spouses work atleast 10 hours per week in the labor market
** Drop if wage rate of either spouse is reported 0 
** Trim the top and bottom 1% of wage distribution
drop if workhm < 10 | workhf < 10
drop if wagem == 0 | wagef == 0 
sum wagem, de
gen trim1 = wagem if wagem > r(p1) & wagem < r(p99)
sum wagef, de
gen trim2 = wagef if wagef > r(p1) & wagef < r(p99)
drop if trim2 ==.  | trim1 == .


keep wagem wagef workhm workhf agem agef kids hworkf hworkm leisurem leisuref q nonlabor gradehusband gradewife region kidcategory agecategory id /*
*/ married members nonmembers cohabitating food housing transport education childcare healthcare clothing recreation totalc/*
*/ bs_food bs_housing bs_transport bs_education bs_childcare bs_healthcare bs_clothing bs_recreation homeowner metro familyid13
order wagem wagef workhm workhf agem agef kids hworkf hworkm leisurem leisuref q nonlabor gradehusband gradewife region kidcategory agecategory id
sort id familyid

** Table 1: Sample summary statistics
sum wagem wagef workhm workhf hworkm hworkf leisurem leisuref agem agef kids q
save psid_cleaned_onlycouples, replace
