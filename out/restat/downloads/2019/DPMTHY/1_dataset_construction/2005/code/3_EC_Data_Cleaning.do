
** Data Cleaning: 2005 EC **


cd "$dir/1_dataset_construction/2005/output"

use "$dir/1_dataset_construction/2005/output/all_india.dta", clear


* generate hired_total
* MG: total_workers is never generated in the previous scripts.
*   1_ec05_to_stata.R actually incorrectly refers to total_working from EC_dataset_construction.do as nonhired_total.
*	I can fix this but I'd feel more comfortable using EC_dataset_construction since we can readily test it.
gen hired_total = total_workers - nonhired_total


* ============================================================================
* LABEL ASSIGNMENT: The following code labels some variables and values
* ============================================================================

label variable schedule_num "rural/urban schedule" 
label define schedule_numl 53 "rural" 54 "urban" 
label values schedule_num schedule_numl 

label variable major_activity   "NIC_code_2004"

label variable sector "rural/urban sector" 
label define sectorl 1 "rural" 2 "urban" 
label values sector sectorl 

label variable status_code "premises status code" 
label define premisesl 1 "without premises" 2 "with premises" 
label values status_code premisesl 

label variable activity "major or subsidiary activity code" 
label define activityl 1 "major activity" 2 "subsidiary activity" 
label values activity activityl 

label variable agri "agricultural status" 
label define agril 1 "agri" 2 "nonagri" 
label values agri agril 

label variable perennial "perennial status" 
label define perenniall 1 "perennial" 2 "nonperennial" 
label values perennial perenniall 

label variable ownership "ownership status" 
label define ownershipl 1 "Govt & PSU private enterprise" 2 "Non profit Insts" 3 "Unincorporated proprietary" 4 "Unincorporated partnership" 5 "Corporate non financial" 6 "Corporate  financial" 7 "Co-operative" 
label values ownership ownershipl 

label variable social_group "social group of owner" 
label define social_groupl 1 "Female ST" 2 "Female SC" 3 "Female OBC" 4 "Female Other" 5 "Male ST" 6 "Male SC" 7 "Male OBC" 8 "Male Other" 9 "(ii) Other than private"
label values social_group social_groupl

label variable power_used "power code" 
label define powerl 1 "Without Power" 2 "Electricity" 3 "Coal/soft coke" 4 "petrol/diesel/kerosene" 5 "LPG/Natural Gas" 6 "Firewood" 7 "Animal Power" 8 "Non-conventional Energy" 9 "Others"
label values power_used powerl 

label variable reg_code1 "registration code 1" 
label variable reg_code2 "registration code 2" 
label define regcodel 0 "Not Registered" 1 "Factory Act 1948" 2 "State Directorate of Industries" 3 "KVIC/KVIV" 4 "Powerloom/Handloom/handicraft" 5 "textile Comm/Jute Commis/Coir board/silk board" 6 "Central Excise/Sales Tax Act" 7 "Shop & Estab Act" 8 "Co-operative Society/Labour Act" 9 "Registered with other Agencies"
label values reg_code1 regcodel
label values reg_code2 regcodel

label variable finance_source "source of finance" 
label define finance_sourcel 0 "No Finance/self finance" 1 "Assistance from Govt sources" 2 "Borrowing from financial Institn" 3 "Borrowing from Non Institn/Money Lenders" 9 "Others like NGO Voluntary Orgn"
label values finance_source finance_sourcel

label variable has_address "whether has address slip" 
label define yesno 1 "yes" 2 "no" 
label values has_address yesno 

* states
label define statel 1 "Jammu & Kashmir" 2 "Himachal Pradesh" 3 "Punjab" 4 "Chandigarh" 5 "Uttaranchal" 6 "Haryana" 7 "Delhi" 8 "Rajasthan" 9 "Uttar Pradesh" 10 "Bihar" 11 "Sikkim" ///
			12 "Arunachal Pradesh" 13 "Nagaland" 14 "Manipur" 15 "Mizoram" 16 "Tripura" 17 "Meghalaya" 18 "Assam" 19 "West Bengal" 20 "Jharkhand" 21 "Orissa" 22 "Chhattisgarh" ///
			23 "Madhya Pradesh" 24 "Gujarat" 25 "Daman & Diu" 26 "Dadra & Nagar Haveli" 27 "Maharashtra" 28 "Andhra Pradesh" 29 "Karnataka" 30 "Goa" 31 "Lakshadweep" ///
			32 "Kerala" 33 "Tamil Nadu" 34 "Pondicherry" 35 "Andaman & Nicobar Islands"
label values state statel

* NIC 2004 sections (2-digit NIC codes) and divisions
rename major_activity nic
gen nic_string = string(nic)
gen nic2 = substr(nic_string, 1, 1) if nic < 1000
replace nic2 = substr(nic_string, 1, 2) if missing(nic2)
destring nic2, replace

gen nic_sec = 1 if nic2 <= 2
replace nic_sec = 2 if nic2 == 5
replace nic_sec = 3 if nic2 >= 10 & nic2 <= 14
replace nic_sec = 4 if nic2 >= 15 & nic2 <= 37
replace nic_sec = 5 if nic2 >= 40 & nic2 <= 41
replace nic_sec = 6 if nic2 == 45
replace nic_sec = 7 if nic2 >= 50 & nic2 <= 52
replace nic_sec = 8 if nic2 == 55
replace nic_sec = 9 if nic2 >= 60 & nic2 <= 64
replace nic_sec = 10 if nic2 >= 65 & nic2 <= 67
replace nic_sec = 11 if nic2 >= 70 & nic2 <= 74
replace nic_sec = 12 if nic2 == 75
replace nic_sec = 13 if nic2 == 80
replace nic_sec = 14 if nic2 == 85
replace nic_sec = 15 if nic2 >= 90 & nic2 <= 93
replace nic_sec = 16 if nic2 >= 95 & nic2 <= 97
replace nic_sec = 17 if nic2 == 99

label define nic_sec_l 1 "SECTION A: AGRICULTURE, HUNTING AND FORESTRY" 2 "SECTION B : FISHING" 3 "SECTION C : MINING AND QUARRYING" 4 "SECTION D: MANUFACTURING" ///
				5 "SECTION E : ELECTRICITY, GAS AND WATER SUPPLY" 6 "SECTION F: CONSTRUCTION" ///
				7 "SECTION G : WHOLESALE AND RETAIL TRADE; REPAIR OF MOTOR VEHICLES, MOTORCYCLES AND PERSONAL AND HOUSEHOLD GOODS" ///
				8 "SECTION H : HOTELS AND RESTAURANTS" 9 "SECTION I : TRANSPORT , STORAG AND COMMUNICATIONS" 10 "SECTION J : FINANCIAL INTERMEDIATION" ///
				11 "SECTION K : REAL ESTATE, RENTING AND BUSINESS ACTIVITIES" 12 "SECTION L : PUBLIC ADMINISTRATION AND DEFENCE; COMPULSORY SOCIAL SECURITY" ///
				13 "SECTION M : EDUCATION" 14 "SECTION N : HEALTH AND SOCIAL WORK" 15 "SECTION O : OTHER COMMUNITY, SOCIAL AND PERSONAL SERVICE ACTIVITIES" ///
				16 "SECTION P : UNDIFFERENTIATED PRODUCTION ACTIVITIES OF PRIVATE HOUSEHOLDS AND ACTIVITIES OF PRIVATE HOUSEHOLDS AS EMPLOYERS" ///
				17 "SECTION Q : EXTRA TERRITORIAL ORGANIZATIONS AND BODIES"
				
label values nic_sec nic_sec_l


label define nic2_l 1 "AGRICULTURE , HUNTING AND RELATED SERVICE ACTIVITIES" ///
			2 "FORESTRY, LOGGING AND RELATED SERVICE ACTIVITIES" ///
			5 "FISHING, OPERATION OF FISH HATCHERIES AND FISH FARMS; SERVICE ACTIVITIES INCIDENTAL TO FISHING" ///
			10 "MINING OF COAL AND LIGNITE; EXTRACTION OF PEAT" ///
			11 "EXTRACTION OF CRUDE PETROLEUM AND NATURAL GAS; SERVICE ACTIVITIES INCIDENTAL TO OIL AND GAS EXTRACTION EXCLUDING SURVEYING" ///
			12 "MINING OF URANIUM AND THORIUM ORES" ///
			13 "MINING OF METAL ORES" ///
			14 "OTHER MINING AND QUARRYING" ///
			15 "MANUFACTURE OF FOOD PRODUCTS AND BEVERAGES" ///
			16 "MANUFACTURE OF TOBACCO PRODUCTS" ///
			17 "MANUFACTURE OF TEXTILES" ///
			18 "MANUFACTURE OF WEARING APPAREL; DRESSING AND DYEING OF FUR" ///
			19 "TANNING AND DRESSING OF LEATHER; MANUFACTURE OF LUGGAGE, HANDBAGS SADDLERY, HARNESS AND FOOTWEAR" ///
			20 "MANUFACTURE OF WOOD AND OF PRODUCTS OF WOOD AND CORK,EXCEPT FURNITURE;MANUFACTURE OF ARTICLES OF STRAW AND PLATING MATERIALS" ///
			21 "MANUFACTURE OF PAPER AND PAPER PRODUCTS" ///
			22 "PUBLISHING, PRINTING AND REPRODUCTION OF RECORDED MEDIA" ///
			23 "MANUFACTURE OF COKE, REFINED PETROLEUM PRODUCTS AND NUCLEAR FUEL" ///
			24 "MANUFACTURE OF CHEMICALS AND CHEMICAL PRODUCTS" ///
			25 "MANUFACTURE OF RUBBER AND PLASTIC PRODUCTS" ///
			26 "MANUFACTURE OF OTHER NON-METALLIC MINERAL PRODUCTS" ///
			27 "MANUFACTURE OF BASIC METALS" ///
			28 "MANUFACTURE OF FABRICATED METAL PRODUCTS, EXCEPT MACHINERY AND EQUIPMENTS" ///
			29 "MANUFACTURE OF MACHINERY AND EQUIPMENT N.E.C." ///
			30 "MANUFACTURE OF OFFICE, ACCOUNTING AND COMPUTING MACHINERY" ///
			31 "MANUFACTURE OF ELECTRICAL MACHINERY AND APPARATUS N.E.C." ///
			32 "MANUFACTURE OF RADIO, TELEVISION AND COMMUNICATION EQUIPMENT AND APPARATUS" ///
			33 "MANUFACTURE OF MEDICAL, PRECISION AND OPTICAL INSTRUMENTS, WATCHES AND CLOCKS" ///
			34 "MANUFACTURE OF MOTOR VEHICLES, TRAILERS AND SEMI-TRAILERS" ///
			35 "MANUFACTURE OF OTHER TRANSPORT EQUIPMENT" ///
			36 "MANUFACTURE OF FURNITURE; MANUFACTURING N.E.C." ///
			37 "RECYCLING" ///
			40 "ELECTRICITY, GAS, STEAM AND HOT WATER SUPPLY" ///
			41 "COLLECTION, PURIFICATION AND DISTRIBUTION OF WATER" ///
			45 "CONSTRUCTION" ///
			50 "SALE , MAINTENANCE AND REPAIR OF MOTOR VEHICLES AND MOTORCYCLES; RETAIL SALE OF AUTOMOTIVE FUEL" ///
			51 "WHOLESALE TRADE AND COMMISSION TRADE, EXCEPT OF MOTOR VEHICLES AND MOTORCYCLES" ///
			52 "RETAIL TRADE, EXCEPT OF MOTOR VEHICLES AND MOTORCYCLES; REPAIR OF PERSONAL AND HOUSEHOLD GOODS" ///
			55 "HOTELS AND RESTAURANTS" ///
			60 "LAND TRANSPORT; TRANSPORT VIA PIPELINES" ///
			61 "WATER TRANSPORT" ///
			62 "AIR TRANSPORT" ///
			63 "SUPPORTING AND AUXILLIARY TRANSPORT ACTIVITIES; ACTIVITIES OF TRAVEL AGENCIES" ///
			64 "POST AND TELECOMMUNICATIONS" ///
			65 "FINANCIAL INTERMEDIATION, EXCEPT INSURANCE AND PENSION FUNDING" ///
			66 "INSURANCE AND PENSION FUNDING, EXCEPT COMPULSORY SOCIAL SECURITY" ///
			67 "ACTIVITIES AUXILIARY TO FINANCIAL INTERMEDIATION" ///
			70 "REAL ESTATE ACTIVITIES" ///
			71 "RENTING OF MACHINERY AND EQUIPMENT WITHOUT OPERATOR AND OF PERSONAL AND HOUSEHOLD GOODS" ///
			72 "COMPUTER AND RELATED ACTIVITIES" ///
			73 "RESEARCH AND DEVELOPMENT" ///
			74 "OTHER BUSINESS ACTIVITIES" ///
			75 "PUBLIC ADMINISTRATION AND DEFENCE; COMPULSORY SOCIAL SECURITY" ///
			80 "EDUCATION" ///
			85 "HEALTH AND SOCIAL WORK" ///
			90 "SEWAGE AND REFUSE DISPOSAL, SANITATION AND SIMILAR ACTIVITIES" ///
			91 "ACTIVITIES OF MEMBERSHIP ORGANISATIONS N.E.C." ///
			92 "RECREATIONAL, CULTURAL AND SPORTING ACTIVITIES" ///
			93 "OTHER SERVICE ACTIVITIES" ///
			95 "ACTIVITIES OF PRIVATE HOUSEHOLDS AS EMPLOYERS OF DOMESTIC STAFF" ///
			96 "UNDIFFERENCIATED GOODS-PRODUCING ACTIVITIES OF PRIVATE HOUSEHOLDS FOR OWN USE" ///
			97 "UNDIFFERENCIATED SERVICE-PRODUCING ACTIVITIES OF PRIVATE HOUSEHOLDS FOR OWN USE" ///
			99 "EXTRA TERRITORIAL ORGANIZATIONS AND BODIES" 
label values nic2 nic2_l


* ==============================================
* CONSISTENCY CHECKS:
* ==============================================

/* The following code checks the data for inconsistencies, and labels them as errors. 
In particular, an "error" variable is created with value 1 for these observations. */

gen error = 0

tab schedule_num, m 
/* 61% of obs rural (schedule_num = 53) and 39% urban (54) */
tab sector
replace error=1 if sector==5
/* ditto: 61% of obs rural (sector = 1) and 39% urban (2) */
tab sector schedule_num, 
/* These variables should line up. However, there appears to be a small discrepancy (800 firms). These are labeled as errors: */
replace error = sector==1 & schedule_num==54 


tab status_code
replace error=1 if status_code==0 // miscode labeled as error
replace status_code=. if status_code==0

tab agri
tab error if agri==0 // already labeled as errors
tab power_used // same errors
tab perennial // ditto
tab ownership // ditto
tab total_workers if agri ==0 // already labeled as errors


** NOTE: Since the same observations appear to be missing values for most variables,
** and are not coded as having any workers, they are dropped from the dataset:
drop if total_workers ==0



/* There are 2 reg code variables. We treat reg_code1 as the primary code. */
count if reg_code1==reg_code2 //39362240
count if reg_code1!=reg_code2 // 2765027 
count if reg_code1!=reg_code2 & reg_code1==0 // 1626352

* Firms should only have 2 different values if they are registered under 2 laws/acts *

gen regcode=reg_code1 //generating a new variable, "regcode", which takes the value of reg_code1, or reg_code2 if reg_code1 is 0
replace regcode=reg_code2 if reg_code1!=reg_code2 & reg_code1==0 
label values regcode regcodel

gen unreg = reg_code1==0 & reg_code2 ==0


save "$dir/1_dataset_construction/2005/output/ec_05_all_india_cleaned.dta", replace


