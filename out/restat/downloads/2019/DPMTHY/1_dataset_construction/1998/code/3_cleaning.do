** Data Cleaning: EC98 **


cd "$dir/1_dataset_construction/1998/output"

use "all_india.dta", clear


// Assign labels:

* ------------------------------
* states
* ------------------------------

label define statel 2 "Andhra Pradesh" 3 "Arunachal Pradesh" 4 "Assam" 5 "Bihar" 6 "Goa" 7 "Gujarat" 8 "Haryana" 9 "Himachal Pradesh" ///
			10 "Jammu & Kashmir" 11 "Karnataka" 12 "Kerala" 13 "Madhya Pradesh" 14 "Maharashtra" 15 "Manipur" ///
			16 "Meghalaya" 17 "Mizoram" 18 "Nagaland" 19 "Orissa" 20 "Punjab" 21 "Rajasthan" 22 "Sikkim" ///
			23 "Tamil Nadu" 24 "Tripura" 25 "Uttar Pradesh" 26 "West Bengal" 27 "Andaman & Nicobar Islands" ///
			28 "Handigarh" 29 "Dadara & Nagar Haveli" 30 "Daman & Diu" 31 "Delhi" 32 "Lakshadweep" 33 "Pondicherry" ///
			34 "Jharkhand" 35 "Chhattisgarh" 36 "Uttaranchal"

label values state statel


* ----------------------------------
* industries
* ----------------------------------

* the nic variable exists because the raw nic variable contained strings and R converted it to a factor.
* nic now contains the factor index
drop nic


* NIC 1987 sections (2-digit NIC codes) and divisions

gen nic_sec = 0 if char_nic <1000
replace nic_sec = 1 if char_nic >= 1000 & char_nic < 2000
replace nic_sec = 2 if char_nic >= 2000 & char_nic < 4000
replace nic_sec = 4 if char_nic >= 4000 & char_nic < 5000
replace nic_sec = 5 if char_nic >= 5000 & char_nic < 6000
replace nic_sec = 6 if char_nic >= 6000 & char_nic < 7000
replace nic_sec = 7 if char_nic >= 7000 & char_nic < 8000
replace nic_sec = 8 if char_nic >= 8000 & char_nic < 9000
replace nic_sec = 9 if char_nic >= 9000 & char_nic < 10000

label define nic_sec_l 0 "SECTION 0: AGRICULTURE, HUNTING, FORESTRY AND FISHING" 1 "SECTION 1 : MINING AND QUARRYING" 2 "SECTION 2&3 : MANUFACTURING" ///
				4 "SECTION 4 : ELECTRICITY, GAS AND WATER" 5 "SECTION 5: CONSTRUCTION" ///
				6 "SECTION 6 : WHOLESALE TRADE AND RETAIL TRADES AND RESTAURANTS AND HOTELS" ///
				7 "SECTION 7 : TRANSPORT, STORAGE AND COMMUNICATION" 8 "SECTION 8 : FINANCING, OMSIRAMCE, REA; ESTATE AMD BUSINESS SERVICES" ///
				9 "SECTION 9 : COMMUNITY, SOCIAL AND PERSONAL SERVICES"
				
label values nic_sec nic_sec_l

gen nic2 = 0 if char_nic<100
replace nic2=1 if char_nic<200 & char_nic>=100
replace nic2=2 if char_nic<300 & char_nic>=200
replace nic2=3 if char_nic<400 & char_nic>=300
replace nic2=4 if char_nic<500 & char_nic>=400
replace nic2=5 if char_nic<600 & char_nic>=500
replace nic2=6 if char_nic<1000 & char_nic>=600
replace nic2=10 if char_nic<1100 & char_nic>=1000
replace nic2=11 if char_nic<1200 & char_nic>=1100
replace nic2=12 if char_nic<1300 & char_nic>=1200
replace nic2=13 if char_nic<1400 & char_nic>=1300
replace nic2=14 if char_nic<1500 & char_nic>=1400
replace nic2=15 if char_nic<1900 & char_nic>=1500
replace nic2=19 if char_nic<2000 & char_nic>=1900
replace nic2=20 if char_nic<2200 & char_nic>=2000
replace nic2=22 if char_nic<2300 & char_nic>=2200
replace nic2=23 if char_nic<2400 & char_nic>=2300
replace nic2=24 if char_nic<2500 & char_nic>=2400
replace nic2=25 if char_nic<2600 & char_nic>=2500
replace nic2=26 if char_nic<2700 & char_nic>=2600
replace nic2=27 if char_nic<2800 & char_nic>=2700
replace nic2=28 if char_nic<2900 & char_nic>=2800
replace nic2=29 if char_nic<3000 & char_nic>=2900
replace nic2=30 if char_nic<3100 & char_nic>=3000
replace nic2=31 if char_nic<3200 & char_nic>=3100
replace nic2=32 if char_nic<3300 & char_nic>=3200
replace nic2=33 if char_nic<3400 & char_nic>=3300
replace nic2=34 if char_nic<3500 & char_nic>=3400
replace nic2=35 if char_nic<3700 & char_nic>=3500
replace nic2=37 if char_nic<3800 & char_nic>=3700
replace nic2=38 if char_nic<3900 & char_nic>=3800
replace nic2=39 if char_nic<4000 & char_nic>=3900
replace nic2=40 if char_nic<4100 & char_nic>=4000
replace nic2=41 if char_nic<4200 & char_nic>=4100
replace nic2=42 if char_nic<4300 & char_nic>=4200
replace nic2=43 if char_nic<4400 & char_nic>=4300
replace nic2=50 if char_nic<5100 & char_nic>=5000
replace nic2=51 if char_nic<6000 & char_nic>=5100
replace nic2=60 if char_nic<6100 & char_nic>=6000
replace nic2=61 if char_nic<6200 & char_nic>=6100
replace nic2=62 if char_nic<6300 & char_nic>=6200
replace nic2=63 if char_nic<6400 & char_nic>=6300
replace nic2=64 if char_nic<6500 & char_nic>=6400
replace nic2=65 if char_nic<6600 & char_nic>=6500
replace nic2=66 if char_nic<6700 & char_nic>=6600
replace nic2=67 if char_nic<6800 & char_nic>=6700
replace nic2=68 if char_nic<6900 & char_nic>=6800
replace nic2=69 if char_nic<7000 & char_nic>=6900
replace nic2=70 if char_nic<7100 & char_nic>=7000
replace nic2=71 if char_nic<7200 & char_nic>=7100
replace nic2=72 if char_nic<7300 & char_nic>=7200
replace nic2=73 if char_nic<7400 & char_nic>=7300
replace nic2=74 if char_nic<7500 & char_nic>=7400
replace nic2=75 if char_nic<8000 & char_nic>=7500
replace nic2=80 if char_nic<8100 & char_nic>=8000
replace nic2=81 if char_nic<8200 & char_nic>=8100
replace nic2=82 if char_nic<8300 & char_nic>=8200
replace nic2=83 if char_nic<8400 & char_nic>=8300
replace nic2=84 if char_nic<8500 & char_nic>=8400
replace nic2=85 if char_nic<8900 & char_nic>=8500
replace nic2=89 if char_nic<9000 & char_nic>=8900
replace nic2=90 if char_nic<9100 & char_nic>=9000
replace nic2=91 if char_nic<9200 & char_nic>=9100
replace nic2=92 if char_nic<9300 & char_nic>=9200
replace nic2=93 if char_nic<9400 & char_nic>=9300
replace nic2=94 if char_nic<9500 & char_nic>=9400
replace nic2=95 if char_nic<9600 & char_nic>=9500
replace nic2=96 if char_nic<9700 & char_nic>=9600
replace nic2=97 if char_nic<9800 & char_nic>=9700
replace nic2=98 if char_nic<9900 & char_nic>=9800
replace nic2=99 if char_nic<10000 & char_nic>=9900

label define nic2_l 0 "AGRICULTURAL PRODUCTION" ///
			1 "PLANTATIONS" ///
			2 "RAISING OF LIVESROCK" ///
			3 "AGRICULTURAL SERVICES" ///
			4 "HUNTING, TRAPPING AND GAME PROPAGATION" ///
			5 "FORESTRY AND LOGGING" ///
			6 "FISHING(INCLUDING COLLECTION OF SEA PRODUCTS)" ///
			10 "MINING OF COAL AND LIGNITE; EXTRACTION OF PEAT" ///
			11 "EXTRACTION OF CRUDE PETROLEUM, PRODUCTION OF NATURAL GAS" ///
			12 "MINING OF IRON ORES" ///
			13 "MINING OF METAL ORES OTHER THAN IRON ORE" ///
			14 "MINGING OF URANIUM AND THORIUM ORES" ///
			15 "MINGING OF NON-METALLIC MINERALS N. E. C." ///
			19 "MINGING SEIVICES N. E. C." ///
			20 "MANUFACTURE OF FOOD PRODUCTS" ///
			22 "MANUFACTURE OF BEVERAGES, TOBACOO AND RELATED PRODUCTS" ///
			23 "MANUFACTURE OF COTTON TEXTILES" ///
			24 "MANUFACTURE OF WOOL SILK AND MAN-MADE FIBRE TEXTILES" ///
			25 "MANUFACTURE OF JATE AND OTHER VEGETABLE FIBRE TEXTILES (EXCEPE COTTON)" ///
			26 "MANUFACTURE OF TEXTILE PRODUCTS (INCLUDING WEARING APPAREL)" ///
			27 "MANUFACTURE OF WOOD AND WOOD PRODUCTS; FURNITURE AND FIXTURES" ///
			28 "MANUFACTURE OF PAPER AND PAPER PRODUCTS AND PRINTING PUBLISHING & ALLIED INDUSTRIES" ///
			29 "MANUFACTURE OF LEATHER AND PRODUCTS OF LEATHER, FUR & SUBSTITUTES OF LEATHER" ///
			30 "MANUFACTURE OF BASIC CHEMICALS AND CHEMICAL PRODUCTS (EXCEPT PRODUCTS OF PETROLEUM AND COAL)" ///
			31 "MANUFACTURE OF RUBBER, PLASTIC, PETROLEUM AND COAL PRODUCTS; PROCESSING OF NUCLEAR FUELS" ///
			32 "MANUFACTURE OF NON-METALLIC MINERAL PRODUCTS" ///
			33 "BASIC METAL AND ALLOYS INDUSTRIES" ///
			34 "MANUFACTURE OF METAL PRODUCTS AND PARTS, EXCEPT MACHINERY AND EQUIPMENT" ///
			35 "MANUFACTURE OF MACHINERY AND EQUIPMENT OTHER THAN TRANSPORT EQUIPMENT" ///
			37 "MANUFACTURE OF TRANSPORT EQUIPMENT AND PARTS" ///
			38 "OTHER MANUFACTURING INDUSTRIES" ///
			39 "REPAIR OF CAPITAL GOODS" ///
			40 "ELECTRICITY GENERATION, TRANSMISSION AND DISTRIBUTION" ///
			41 "GAS AND STEAM GENERATION AND DISTRIBUTION THROUGH PIPES" ///
			42 "WATER WORKS AND SUPPLY" ///
			43 "NON-CONVENTIONAL ENERGY GENERATION AND DISTRIBUTION" ///
			50 "CONSTRUCTION" ///
			51 "ACTIVITIES ALLIED TO CONSTRUCTION" ///
			60 "WHOLESALE TRADE IN AGRICULTURAL RAW MATERIALS LIVE ANIMALS, FOOD, BEVERAGES, INTOXICANTS AND TEXTILES" ///
			61 "WHOLESALE TRADE IN WOOD, PAPER, SKIN, LEATHER AND FUR, FUEL, PETROLEUM, CHEMICALS, PERFUMERY CERAMICS, GLASS AND ORES, AND METALS" ///
			62 "WHOLESALE TRADE IN ALL TYPES OF MACHINERY & EQUIPMENT INCLUDING TRANSPORT EQUIPMENT" ///
			63 "WHOLESALE TRADE N. E. C." ///
			64 "COMMISSION AGENTS" ///
			65 "RETAIL TRADE IN FOOD AND FOOD ARTICLES, BEVERAGES TOBACCO AND INTOXICANTS" ///
			66 "RETAIL TRADE IN TEXTILES" ///
			67 "RETAIL TRADE IN FUELS AND OTHER HOUSEHOLD UTILITIES AND DURABLES" ///
			68 "RETAIL TRADE N. E. C." ///
			69 "RESTAURANTS AND HOTELS" ///
			70 "LAND TRANSPORT" ///
			71 "WATER TRANSPORT" ///
			72 "AIR TRANSPORT" ///
			73 "SERVICES INCIDENTAL TO TRANSPORT N. E. C." ///
			74 "STORAGE AND WAREHOUSING SERVICES" ///
			75 "COMMUNICATION SERVICES" ///
			80 "BANKING ACTIVITIES, INCLUDING FINANCIAL SERVICES" ///
			81 "PROVIDENT AND INSURANCE SERVICES" ///
			82 "REAL ESTATE ACTIVITIES" ///
			83 "LEGAL SERVICES" ///
			84 "OPERATION OF LOTTERIES" ///
			85 "RENTING AND LEASING (FINANCIAL LEASING IS CLASSIFIED IN FINANCIAL ACTIVITIES) N. E. C." ///
			89 "BUSINESS SERVICES N. E. C." ///
			90 "PUBLIC ADMINISTRATION AND DEFENCE SERVICES" ///
			91 "SANITATY SERVICES" ///
			92 "EDUCATION, SCIENIFIC AND RESEARCH SERVICES" ///
			93 "HEALTH AND MEDICAL SERVICES" ///
			94 "COMMUNITY SERVICES" ///
			95 "RECREATIONAL AND CULTURAL SERVICES" ///
			96 "PERSONAL SERVICES" ///
			97 "REPAIR SERVICES" ///
			98 "INTERNATIONAL AND OTHER EXTRA TERRITORIAL BODIES" ///
			99 "SERVICES N. E. C."
						
label values nic2 nic2_l


rename major_activity major_activity_98
label variable major_activity_98   "NOT AN NIC CODE - UNKNOWN"

label variable sector "rural/urban status" 
label define sectorl 1 "rural" 2 "urban" 
label values sector sectorl 

label variable status_code "premises_status" 
label define premisesl 1 "without premises" 2 "with premises" 
label values status_code premisesl 

label define agril 1 "agri" 2 "nonagri" //I think
label values agri agril 

label define perenniall 1 "perennial" 2 "nonperennial" 
label values perennial perenniall 

label define ownershipl 1 "Private Non-Profit Institutions" 2 "Private Others" 3 "Co-operatives" 4 "Governments" 
label values ownership ownershipl 

label define social_groupl 1 "ST Female" 2 "ST Male" 3 "SC Female" 4 "SC Male" 5 "OBC Female" 6 "OBC Male" 7 "Other Female" 8 "Other Male" 9 "(ii) Other than private"
label values social_group social_groupl


* power status
label define powerl 0 "Without Power" 1 "Electricity" 2 "Coal/soft coke" 3 "Petrol/diesel" 4 "LPG/Natural Gas" 5 "Firewood" 6 "Kerosene" 7 "Animal Power" 8 "Non-conventional Energy" 9 "Others"
label values power_used powerl 

* registration code
label define regcodel 0 "Not registered or recognized with any of the above" 1 "Factories Act 1948" 2 "State Directorate of Industries" 3 "KVIC/KVIV" 4 "Development Commissioner Powerlooms/Handlooms" ///
			5 "Commissioner Handicrafts" 6 "Textile Commissioner" 7 "Jute Commissioner" 8 "Coir Board" 9 "Central Silk Board"
label values reg_code1 regcodel
label values reg_code2 regcodel

label define finance_sourcel 1 "Assistance under IRDP" 2 "Assistance under other poverty alleviation programmes TRYSEM/DWCRA/Tool Kits" 3 "Borrowing from institutions" 4 "Borrowing from non-institutions" 5 "Self-financing" 6 "Others"
label values finance_source finance_sourcel

* factories act variable
gen factories_act = reg_code1==1 | reg_code2==1


/* There are 2 reg code variables. We treat reg_code1 as the primary code. */
count if reg_code1==reg_code2 //2397341
count if reg_code1!=reg_code2 // 927803 
count if reg_code1!=reg_code2 & reg_code1==0 // 343869 - for these units, reg_code1 was coded 0 while code2 was not.

gen regcode=reg_code1 //generating a new variable, "regcode", which takes the value of reg_code1, or reg_code2 if reg_code1 is 0
replace regcode=reg_code2 if reg_code1!=reg_code2 & reg_code1==0 
label values regcode regcodel

* drop observations missing number of workers (should be just 1):
drop if missing(total_workers)


save ec_98_all_india_cleaned.dta, replace


