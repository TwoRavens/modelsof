* Date: July 19, 2012
* Apply to: mck_1.dta
* Description: This set of commands merges margin, district partisanship,
* committee membership, political experience, district population data, bill
* introductions and defines treatment variables and covariates

clear

set more off


* Use McKibben dataset

use "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\McKibben\mck_1.dta", clear


* Merge electoral margin

sort icpsr_cong

merge 1:1 icpsr_cong using "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\MacKenzie\margin_1.dta", update

tab _merge
drop if _merge==2
drop _merge


* Merge committee membership

sort icpsr_cong

merge 1:1 icpsr_cong using "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\Committees\com_38_79.dta", update

tab _merge
drop if _merge==2
drop _merge


* Change committee measures to zero for non-listed MCs

replace com_any = 0 if com_any==.
replace chr_any = 0 if chr_any==.
replace com_no = 0 if com_no==.
replace chr_no = 0 if chr_no==.

replace com_pens = 0 if com_pens==.
replace com_pinv = 0 if com_pinv==.

replace com_pcom = 0 if com_pcom==.
replace com_pcom = 1 if com_pcom > 1

replace com_clms = 0 if com_clms==.
replace com_maff = 0 if com_maff==.
replace com_naff = 0 if com_naff==.
replace com_baff = 0 if com_baff==.
replace com_cmrc = 0 if com_cmrc==.
replace com_iaff = 0 if com_iaff==.
replace com_bild = 0 if com_bild==.
replace com_land = 0 if com_land==.
replace com_judi = 0 if com_judi==.
replace com_fish = 0 if com_fish==.
replace com_rhar = 0 if com_rhar==.
replace com_iimp = 0 if com_iimp==.
replace com_agri = 0 if com_agri==.
replace com_bank = 0 if com_bank==.
replace com_educ = 0 if com_educ==.
replace com_faff = 0 if com_faff==.
replace com_imig = 0 if com_imig==.
replace com_labo = 0 if com_labo==.
replace com_ways = 0 if com_ways==.
replace com_edla = 0 if com_edla==.

replace chr_pens = 0 if chr_pens==.
replace chr_pinv = 0 if chr_pinv==.

replace chr_pcom = 0 if chr_pcom==.
replace chr_pcom = 1 if chr_pcom > 1

replace chr_clms = 0 if chr_clms==.
replace chr_maff = 0 if chr_maff==.
replace chr_naff = 0 if chr_naff==.
replace chr_baff = 0 if chr_baff==.
replace chr_cmrc = 0 if chr_cmrc==.
replace chr_iaff = 0 if chr_iaff==.
replace chr_bild = 0 if chr_bild==.
replace chr_land = 0 if chr_land==.
replace chr_judi = 0 if chr_judi==.
replace chr_fish = 0 if chr_fish==.
replace chr_rhar = 0 if chr_rhar==.
replace chr_iimp = 0 if chr_iimp==.
replace chr_agri = 0 if chr_agri==.
replace chr_bank = 0 if chr_bank==.
replace chr_educ = 0 if chr_educ==.
replace chr_faff = 0 if chr_faff==.
replace chr_imig = 0 if chr_imig==.
replace chr_labo = 0 if chr_labo==.
replace chr_ways = 0 if chr_ways==.
replace chr_edla = 0 if chr_edla==.


* Merge partisan advantage

sort stateyear

merge m:1 stateyear using "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\Gubernatorial Returns\cqgov_1.dta", update

tab _merge
drop if _merge==2
drop _merge


* Merge district veteran population

sort stateyear

merge m:1 stateyear using "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\Veterans\vets_1.dta", update

tab _merge
drop if _merge==2
drop _merge


* Merge farm value per capita

sort stateyear

merge m:1 stateyear using "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\Farm Value\farm_value_1.dta", update

tab _merge
drop if _merge==2
drop _merge


* Merge district population

gen double sdc_id = (state * 10000) + (district * 100) + congress

sort sdc_id

merge m:1 sdc_id using "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\District Population\dis_pop_1_mrg.dta", update

tab _merge
drop if _merge==2
rename _merge pop_1_mrg


* Fix missing observations

* 1872-1880

* At large districts

replace population = 125015 if state==11 & congress==47 & district==98
replace population = 122993 if state==35 & congress==47 & district==98
replace population = 39864 if state==62 & congress==47 & district==98
replace population = 42491 if state==65 & congress==47 & district==98
replace population = 90923 if state==72 & congress==47 & district==98

* Other districts

replace population = 148372 if state==13 & congress==47 & district==9
replace population = 122947 if state==23 & congress==47 & district==7
replace population = 115809 if state==32 & congress==47 & district==1
replace population = 143603 if state==32 & congress==47 & district==2
replace population = 53423 if state==32 & congress==47 & district==3
replace population = 117063 if state==34 & congress==47 & district==2


* 1882-1890

* At large districts

replace population = 146608 if state==11 & congress>=47 & congress<=51 & district==98
replace population = 4282891 if state==14 & congress>=47 & congress<=51 & district==98
replace population = . if state==36 & congress>=47 & congress<=51 & district==98
replace population = 135177 if state==37 & congress>=47 & congress<=51 & district==97
replace population = 135177 if state==37 & congress>=47 & congress<=51 & district==98
replace population = 194327 if state==62 & congress>=47 & congress<=51 & district==98
replace population = 32610 if state==63 & congress>=47 & congress<=51 & district==98
replace population = 39159 if state==64 & congress>=47 & congress<=51 & district==98
replace population = 62266 if state==65 & congress>=47 & congress<=51 & district==98
replace population = 20789 if state==68 & congress>=47 & congress<=51 & district==98
replace population = 174768 if state==72 & congress>=47 & congress<=51 & district==98
replace population = 75116 if state==73 & congress>=47 & congress<=51 & district==98

replace population = 648936 if state==2 & congress==48 & district > 90
replace population = 5082877 if state==13 & congress==48 & district==98
replace population = 994270 if state==32 & congress==48 & district > 90
replace population = 1522627 if state==40 & congress==48 & district==98
replace population = 802525 if state==42 & congress==48 & district==98
replace population = 1542176 if state==44 & congress==48 & district==98
replace population = 1399750 if state==47 & congress==48 & district==98
replace population = 865694 if state==71 & congress==48 & district > 90

replace population = 146608 if state==11 & congress==52 & district==98
replace population = 135177 if state==37 & congress==52 & district > 90
replace population = 194327 if state==62 & congress==52 & district==98
replace population = 32610 if state==63 & congress==52 & district==98
replace population = 39159 if state==64 & congress==52 & district==98
replace population = 62266 if state==65 & congress==52 & district==98
replace population = 20789 if state==68 & congress==52 & district==98
replace population = 174768 if state==72 & congress==52 & district==98
replace population = 75116 if state==73 & congress==52 & district==98

* Use 1892 total to estimate ND district 98
replace population = 182719 if state==36 & congress>=51 & congress<=52 & district==98

replace population = 146608 if state==11 & congress==50 & district==1
replace population = 194327 if state==62 & congress==50 & district==1
replace population = 62266 if state==65 & congress==50 & district==1
replace population = 174768 if state==72 & congress==50 & district==1

* Other districts

replace population = 148780 if state==3 & congress==48 & district==12
replace population = 157832 if state==13 & congress==49 & district==8
replace population = 154890 if state==13 & congress==50 & district==19
replace population = 146891 if state==13 & congress==50 & district==23
replace population = 143718 if state==13 & congress==50 & district==25
replace population = 125242 if state==13 & congress==51 & district==6
replace population = 152100 if state==13 & congress==52 & district==22
replace population = 223838 if state==13 & congress==53 & district==15
replace population = 156537 if state==13 & congress==54 & district==10
replace population = 179308 if state==13 & congress==56 & district==34
replace population = 170495 if state==13 & congress==57 & district==24
replace population = 166273 if state==14 & congress==49 & district==19
replace population = 167713 if state==24 & congress==48 & district==17
replace population = 157854 if state==25 & congress==50 & district==8
replace population = 143085 if state==34 & congress==51 & district==4
replace population = 154221 if state==47 & congress==48 & district==1
replace population = 165346 if state==42 & congress==51 & district==2
replace population = 185999 if state==42 & congress==49 & district==3
replace population = 128495 if state==45 & congress==49 & district==2
replace population = 164587 if state==45 & congress==50 & district==6
replace population = 165534 if state==45 & congress==61 & district==2
replace population = 128073 if state==48 & congress==48 & district==7
replace population = 144733 if state==56 & congress==48 & district==3


* 1892-1900

* At large districts

replace population = 168493 if state==11 & congress>=53 & congress<=57 & district==98
replace population = 5258014 if state==14 & congress>=53 & congress<=57 & district==96
replace population = 5258014 if state==14 & congress>=53 & congress<=57 & district==97
replace population = 5258014 if state==14 & congress>=53 & congress<=57 & district==98
replace population = 3826351 if state==21 & congress>=53 & congress<=57 & district==97
replace population = 3826351 if state==21 & congress>=53 & congress<=57 & district==98
replace population = 1427096 if state==32 & congress>=53 & congress<=57 & district==98
replace population = 182719 if state==36 & congress>=53 & congress<=57 & district==98
replace population = 328808 if state==37 & congress>=53 & congress<=57 & district==97
replace population = 328808 if state==37 & congress>=53 & congress<=57 & district==98
replace population = 762794 if state==56 & congress>=53 & congress<=57 & district==98
replace population = 84385 if state==63 & congress>=53 & congress<=57 & district==98
replace population = 132159 if state==64 & congress>=53 & congress<=57 & district==98
replace population = 45761 if state==65 & congress>=53 & congress<=57 & district==98
replace population = 207905 if state==67 & congress>=53 & congress<=57 & district==98
replace population = 60705 if state==68 & congress>=53 & congress<=57 & district==98
replace population = 349390 if state==73 & congress>=53 & congress<=57 & district==97
replace population = 349390 if state==73 & congress>=53 & congress<=57 & district==98

replace population = 168493 if state==11 & congress==55 & district==98
replace population = 168493 if state==11 & congress==56 & district==97

* Other districts

replace population = 169553 if state==2 & congress==56 & district==2
replace population = 183070 if state==2 & congress==57 & district==4
replace population = 174866 if state==3 & congress==53 & district==7

replace population = 146227 if state==14 & congress==54 & district==15
replace population = 109677 if state==14 & congress==55 & district==25
replace population = 162222 if state==21 & congress==54 & district==10
replace population = 164866 if state==21 & congress==54 & district==18
replace population = 173921 if state==24 & congress==53 & district==10
replace population = 181975 if state==25 & congress==53 & district==4
replace population = 181975 if state==32 & congress==53 & district==12
replace population = 173717 if state==34 & congress==55 & district==1

replace population = 158246 if state==52 & congress==53 & district==1
replace population = 158246 if state==52 & congress==56 & district==1


* 1902-1910

* At large districts

replace population = 908420 if state==1 & congress>=58 & congress<=62 & district==98
replace population = 184735 if state==11 & congress>=58 & congress<=62 & district==98
replace population = 1470495 if state==32 & congress>=58 & congress<=62 & district==98
replace population = 319146 if state==36 & congress>=58 & congress<=62 & district==97
replace population = 319146 if state==36 & congress>=58 & congress<=62 & district==98
replace population = 401570 if state==37 & congress>=58 & congress<=62 & district==97
replace population = 401570 if state==37 & congress>=58 & congress<=62 & district==98
replace population = 539700 if state==62 & congress>=58 & congress<=62 & district==98
replace population = 161772 if state==63 & congress>=58 & congress<=62 & district==98
replace population = 243329 if state==64 & congress>=58 & congress<=62 & district==98
replace population = 42335 if state==65 & congress>=58 & congress<=62 & district==98
replace population = 276749 if state==67 & congress>=58 & congress<=62 & district==98
replace population = 92531 if state==68 & congress>=58 & congress<=62 & district==98
replace population = 518103 if state==73 & congress>=58 & congress<=62 & district==96
replace population = 518103 if state==73 & congress>=58 & congress<=62 & district==97
replace population = 518103 if state==73 & congress>=58 & congress<=62 & district==98

replace population = 5608591 if state==37 & congress==60 & district==96

* Use 1912 total to estimate NM district 98
replace population = 327301 if state==66 & congress==62 & district > 90

* Use 1912 total to estimate AZ district 98
replace population = 204354 if state==61 & congress==62 & district==98

* Other districts

replace population = 177020 if state==14 & congress==58 & district==4
replace population = 195609 if state==14 & congress==60 & district==2
replace population = 195609 if state==14 & congress==62 & district==2
replace population = 203710 if state==23 & congress==60 & district==5
replace population = 255510 if state==24 & congress==61 & district==21
replace population = 259516 if state==32 & congress==58 & district==7
replace population = 215747 if state==32 & congress==60 & district==1
replace population = 234268 if state==32 & congress==62 & district==2
replace population = 154198 if state==40 & congress==60 & district==8
replace population = 202736 if state==49 & congress==58 & district==8
replace population = 192929 if state==72 & congress==58 & district==1


sort sdc_id

merge m:1 sdc_id using "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\District Population\dis_pop_2_mrg.dta", update

tab _merge
drop if _merge==2
rename _merge pop_2_mrg


* Fix missing observations

* 1912-1920

* At large districts

replace population = 7665111 if state==14 & congress>=63 & congress<=67 & district==95
replace population = 7665111 if state==14 & congress>=63 & congress<=67 & district==96
replace population = 7665111 if state==14 & congress>=63 & congress<=67 & district==97
replace population = 7665111 if state==14 & congress>=63 & congress<=67 & district==98
replace population = 5638591 if state==14 & congress>=63 & congress<=67 & district==96
replace population = 5638591 if state==14 & congress>=63 & congress<=67 & district==97
replace population = 5638591 if state==14 & congress>=63 & congress<=67 & district==98
replace population = 4767121 if state==24 & congress>=63 & congress<=67 & district==98
replace population = 2075708 if state==33 & congress>=63 & congress<=67 & district==98
replace population = 2138093 if state==41 & congress>=63 & congress<=67 & district==98
replace population = 752619 if state==43 & congress>=63 & congress<=67 & district==98
replace population = 3896542 if state==49 & congress>=63 & congress<=67 & district==97
replace population = 3896542 if state==49 & congress>=63 & congress<=67 & district==98
replace population = 1657155 if state==53 & congress>=63 & congress<=67 & district==96
replace population = 1657155 if state==53 & congress>=63 & congress<=67 & district==97
replace population = 1657155 if state==53 & congress>=63 & congress<=67 & district==98
replace population = 1221119 if state==56 & congress>=63 & congress<=67 & district==98
replace population = 799024 if state==62 & congress>=63 & congress<=67 & district==97
replace population = 799024 if state==62 & congress>=63 & congress<=67 & district==98
replace population = 325594 if state==63 & congress>=63 & congress<=67 & district==97
replace population = 376053 if state==64 & congress>=63 & congress<=67 & district==97
replace population = 373351 if state==67 & congress>=63 & congress<=67 & district==97
replace population = 1141990 if state==73 & congress>=63 & congress<=67 & district==97
replace population = 1141990 if state==73 & congress>=63 & congress<=67 & district==98

replace population = 202322 if state==11 & congress==65 & district==1
replace population = 908420 if state==21 & congress>=63 & congress<=67 & district > 90

* Estimate based on 12 MI districts with valid population
* Look up population of MI district 13
replace population = 3013015 if state==23 & congress==63 & district==98

replace population = 204354 if state==61 & congress==65 & district==1

* Other districts

replace population = 182647 if state==5 & congress>=63 & congress<=67 & district==3

replace population = 207465 if state==13 & congress>=63 & congress<=67 & district==2
replace population = 209578 if state==13 & congress>=63 & congress<=67 & district==4
replace population = 209700 if state==13 & congress>=63 & congress<=67 & district==5
replace population = 204498 if state==13 & congress>=63 & congress<=67 & district==6
replace population = 204731 if state==13 & congress>=63 & congress<=67 & district==7
replace population = 207175 if state==13 & congress>=63 & congress<=67 & district==9

replace population = 207175 if state==13 & congress>=63 & congress<=67 & district==34
replace population = 229547 if state==13 & congress>=63 & congress<=67 & district==35
replace population = 215185 if state==13 & congress>=63 & congress<=67 & district==36
replace population = 211299 if state==13 & congress>=63 & congress<=67 & district==37
replace population = 220355 if state==13 & congress>=63 & congress<=67 & district==38
replace population = 202389 if state==13 & congress>=63 & congress<=67 & district==39
replace population = 209587 if state==13 & congress>=63 & congress<=67 & district==40
replace population = 207335 if state==13 & congress>=63 & congress<=67 & district==41
replace population = 204099 if state==13 & congress>=63 & congress<=67 & district==42
replace population = 212457 if state==13 & congress>=63 & congress<=67 & district==43

replace population = 201054 if state==33 & congress>=64 & congress<=67 & district==1
replace population = 200501 if state==33 & congress>=64 & congress<=67 & district==2
replace population = 208040 if state==33 & congress>=64 & congress<=67 & district==3
replace population = 223675 if state==33 & congress>=64 & congress<=67 & district==4
*replace population = . if state==33 & congress>=64 & congress<=67 & district==5
replace population = 191616 if state==33 & congress>=64 & congress<=67 & district==6
replace population = 197322 if state==33 & congress>=64 & congress<=67 & district==7
replace population = 213819 if state==33 & congress>=64 & congress<=67 & district==8
replace population = 206430 if state==33 & congress>=64 & congress<=67 & district==9
replace population = 220773 if state==33 & congress>=64 & congress<=67 & district==10

replace population = 211856 if state==41 & congress>=65 & congress<=67 & district==1
replace population = 289770 if state==41 & congress>=65 & congress<=67 & district==2
replace population = 249042 if state==41 & congress>=65 & congress<=67 & district==3
replace population = 193958 if state==41 & congress>=65 & congress<=67 & district==4
replace population = 235615 if state==41 & congress>=65 & congress<=67 & district==5
replace population = 180871 if state==41 & congress>=65 & congress<=67 & district==6
replace population = 186641 if state==41 & congress>=65 & congress<=67 & district==7
replace population = 218342 if state==41 & congress>=65 & congress<=67 & district==8
replace population = 226476 if state==41 & congress>=65 & congress<=67 & district==9
replace population = 145522 if state==41 & congress>=65 & congress<=67 & district==10

replace population = 168001 if state==43 & congress>=64 & congress<=67 & district==1
replace population = 197086 if state==43 & congress>=64 & congress<=67 & district==2
replace population = 190960 if state==43 & congress>=64 & congress<=67 & district==3
replace population = 196574 if state==43 & congress>=64 & congress<=67 & district==4

replace population = 194726 if state==56 & congress>=65 & congress<=67 & district==1
replace population = 211690 if state==56 & congress>=65 & congress<=67 & district==2
replace population = 197110 if state==56 & congress>=65 & congress<=67 & district==3
replace population = 202123 if state==56 & congress>=65 & congress<=67 & district==4
replace population = 206573 if state==56 & congress>=65 & congress<=67 & district==5
replace population = 208897 if state==56 & congress>=65 & congress<=67 & district==6

replace population = 234422 if state==24 & congress>=64 & congress<=67 & district==1
replace population = 234254 if state==24 & congress>=64 & congress<=67 & district==2
replace population = 257868 if state==24 & congress>=64 & congress<=67 & district==3
replace population = 228005 if state==24 & congress>=64 & congress<=67 & district==4
replace population = 180550 if state==24 & congress>=64 & congress<=67 & district==5
replace population = 172035 if state==24 & congress>=64 & congress<=67 & district==6
replace population = 264297 if state==24 & congress>=64 & congress<=67 & district==7
replace population = 173849 if state==24 & congress>=64 & congress<=67 & district==8
replace population = 215088 if state==24 & congress>=64 & congress<=67 & district==9
replace population = 182512 if state==24 & congress>=64 & congress<=67 & district==10
replace population = 164474 if state==24 & congress>=64 & congress<=67 & district==11
replace population = 221567 if state==24 & congress>=64 & congress<=67 & district==12
replace population = 196455 if state==24 & congress>=64 & congress<=67 & district==13
replace population = 238195 if state==24 & congress>=64 & congress<=67 & district==14
replace population = 204568 if state==24 & congress>=64 & congress<=67 & district==15
replace population = 235984 if state==24 & congress>=64 & congress<=67 & district==16
replace population = 213716 if state==24 & congress>=64 & congress<=67 & district==17
replace population = 253735 if state==24 & congress>=64 & congress<=67 & district==18
replace population = 228464 if state==24 & congress>=64 & congress<=67 & district==19
replace population = 224357 if state==24 & congress>=64 & congress<=67 & district==20
replace population = . if state==24 & congress>=64 & congress<=67 & district==21
replace population = . if state==24 & congress>=64 & congress<=67 & district==22

replace population = 180053 if state==53 & congress>=64 & congress<=67 & district==1
replace population = 188098 if state==53 & congress>=64 & congress<=67 & district==2
replace population = 231634 if state==53 & congress>=64 & congress<=67 & district==3
replace population = 225478 if state==53 & congress>=64 & congress<=67 & district==4
replace population = 214498 if state==53 & congress>=64 & congress<=67 & district==5
replace population = 207451 if state==53 & congress>=64 & congress<=67 & district==6
replace population = 208022 if state==53 & congress>=64 & congress<=67 & district==7
replace population = 201921 if state==53 & congress>=64 & congress<=67 & district==8

replace population = 213381 if state==62 & congress>=64 & congress<=67 & district==1
replace population = 222730 if state==62 & congress>=64 & congress<=67 & district==2
replace population = 228444 if state==62 & congress>=64 & congress<=67 & district==3
replace population = 134469 if state==62 & congress>=64 & congress<=67 & district==4

replace population = 185868 if state==67 & congress>=64 & congress<=67 & district==1
replace population = 187483 if state==67 & congress>=64 & congress<=67 & district==2

replace population = 254841 if state==73 & congress>=64 & congress<=67 & district==1
replace population = 208804 if state==73 & congress>=64 & congress<=67 & district==2
replace population = 268646 if state==73 & congress>=64 & congress<=67 & district==3
replace population = 185441 if state==73 & congress>=64 & congress<=67 & district==4
replace population = 224258 if state==73 & congress>=64 & congress<=67 & district==5


* 1922-1930

* At large districts

replace population = 223003 if state==11 & congress>=69 & congress<=71 & district==98
replace population = 6485280 if state==21 & congress>=69 & congress<=71 & district==97
replace population = 6485280 if state==21 & congress>=69 & congress<=71 & district==98
replace population = 334162 if state==61 & congress>=69 & congress<=71 & district==98
replace population = 77407 if state==65 & congress>=69 & congress<=71 & district==98
replace population = 360350 if state==66 & congress>=69 & congress<=71 & district==98
replace population = 194402 if state==68 & congress>=69 & congress<=71 & district==98

replace population = 223003 if state==11 & congress==68 & district==98
replace population = 6485280 if state==21 & congress==68 & district > 90
replace population = 334162 if state==61 & congress==68 & district==98
replace population = 77407 if state==65 & congress==68 & district==98
replace population = 360350 if state==66 & congress==68 & district==98
replace population = 194402 if state==68 & congress==68 & district==98

* Other districts

replace population = 252062 if state==13 & congress>=68 & congress<=72 & district==10
replace population = 217371 if state==13 & congress>=68 & congress<=72 & district==11
replace population = . if state==13 & congress>=68 & congress<=72 & district==12
replace population = 163292 if state==13 & congress>=68 & congress<=72 & district==13
replace population = 179572 if state==13 & congress>=68 & congress<=72 & district==14
replace population = 191645 if state==13 & congress>=68 & congress<=72 & district==15
replace population = 200072 if state==13 & congress>=68 & congress<=72 & district==16
replace population = 217882 if state==13 & congress>=68 & congress<=72 & district==17
replace population = 203677 if state==13 & congress>=68 & congress<=72 & district==18
replace population = 258139 if state==13 & congress>=68 & congress<=72 & district==19
replace population = 195814 if state==13 & congress>=68 & congress<=72 & district==20
replace population = 317803 if state==13 & congress>=68 & congress<=72 & district==21
replace population = 232926 if state==13 & congress>=68 & congress<=72 & district==22
replace population = 391050 if state==13 & congress>=68 & congress<=72 & district==23
replace population = 355754 if state==13 & congress>=68 & congress<=72 & district==24
replace population = 232515 if state==13 & congress>=68 & congress<=72 & district==25
replace population = 222393 if state==13 & congress>=68 & congress<=72 & district==26
replace population = 194171 if state==13 & congress>=68 & congress<=72 & district==27
replace population = 228556 if state==13 & congress>=68 & congress<=72 & district==28
replace population = 207269 if state==13 & congress>=68 & congress<=72 & district==29
replace population = 216188 if state==13 & congress>=68 & congress<=72 & district==30
replace population = 207431 if state==13 & congress>=68 & congress<=72 & district==31
replace population = 216534 if state==13 & congress>=68 & congress<=72 & district==32
replace population = 247795 if state==13 & congress>=68 & congress<=72 & district==33

replace population = 257324 if state==14 & congress>=68 & congress<=72 & district==33
replace population = 215794 if state==14 & congress>=68 & congress<=72 & district==34
replace population = 236161 if state==14 & congress>=68 & congress<=72 & district==35
replace population = 238449 if state==14 & congress>=68 & congress<=72 & district==36


replace population = 163292 if state==13 & congress>=69 & congress<=71 & district==34
replace population = 165123 if state==13 & congress>=69 & congress<=71 & district==35
replace population = 179572 if state==13 & congress>=69 & congress<=71 & district==36


* District Population
* Identifies district ranking in the upper quartile of population by congress
* Districts with missing totals coded as zero

egen b_pop_up25 = pctile(population), by(congress) p(75)

gen b_pop_top = 0
replace b_pop_top = 1 if population > b_pop_up25 & population!=.

drop pop_1_mrg pop_2_mrg population b_pop_up25


* Merge political experience

sort icpsrno

merge m:1 icpsrno using "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\MacKenzie\mackenz_1.dta", update

tab _merge
drop if _merge==2
drop _merge


* Years of previous service
* Identifies members who are above the median in years of public service

gen yr_hse_hi = 0
replace yr_hse_hi = 1 if yr_hse > 5

gen yr_hse_terms = yr_hse_hi * hse_terms


* Reform institutions
* Identifies members who begin service in states with ballot and primary laws

* State adoption of direct primary

gen primary = 0

* Connecticut
replace primary = 1 if state==1 & yearofelect>=955

* Maine
replace primary = 1 if state==2 & yearofelect>=912

* Massachusetts
replace primary = 1 if state==3 & yearofelect>=912

* New Hampshire
replace primary = 1 if state==4 & yearofelect>=910

* Rhode Island
replace primary = 1 if state==5 & yearofelect>=947

* Vermont
replace primary = 1 if state==6 & yearofelect>=916

* Delaware
replace primary = 1 if state==11 & yearofelect>=904

* New Jersey
replace primary = 1 if state==12 & yearofelect>=912

* New York
replace primary = 1 if state==13 & yearofelect>=914

* Pennsylvania
replace primary = 1 if state==14 & yearofelect>=906

* Illinois
replace primary = 1 if state==21 & yearofelect>=906

* Indiana
replace primary = 1 if state==22 & yearofelect>=916

* Michigan
replace primary = 1 if state==23 & yearofelect>=906

* Ohio
replace primary = 1 if state==24 & yearofelect>=908

* Wisconsin
replace primary = 1 if state==25 & yearofelect>=904

* Iowa
replace primary = 1 if state==31 & yearofelect>=908

* Kansas
replace primary = 1 if state==32 & yearofelect>=908

* Minnesota
replace primary = 1 if state==33 & yearofelect>=902

* Missouri
replace primary = 1 if state==34 & yearofelect>=908

* Nebraska
replace primary = 1 if state==35 & yearofelect>=908

* North Dakota
replace primary = 1 if state==36 & yearofelect>=908

* South Dakota
replace primary = 1 if state==37 & yearofelect>=906

* Virginia
replace primary = 1 if state==40 & yearofelect>=912

* Alabama
replace primary = 1 if state==41 & yearofelect>=904

* Arkansas
replace primary = 1 if state==42 & yearofelect>=910

* Florida
replace primary = 1 if state==43 & yearofelect>=902

* Georgia
replace primary = 1 if state==44 & yearofelect>=918

* Louisiana
replace primary = 1 if state==45 & yearofelect>=906

* Mississippi
replace primary = 1 if state==46 & yearofelect>=902

* North Carolina
replace primary = 1 if state==47 & yearofelect>=916

* South Carolina
replace primary = 1 if state==48 & yearofelect>=916

* Texas
replace primary = 1 if state==49 & yearofelect>=906

* Kentucky
replace primary = 1 if state==51 & yearofelect>=912

* Maryland
replace primary = 1 if state==52 & yearofelect>=910

* Oklahoma
replace primary = 1 if state==53 & yearofelect>=908

* Tennessee
replace primary = 1 if state==54 & yearofelect>=910

* West Virginia
replace primary = 1 if state==56 & yearofelect>=916

* Arizona
replace primary = 1 if state==61 & yearofelect>=910

* Colorado
replace primary = 1 if state==62 & yearofelect>=910

* Idaho
replace primary = 1 if state==63 & yearofelect>=910

* Montana
replace primary = 1 if state==64 & yearofelect>=906

* Nevada
replace primary = 1 if state==65 & yearofelect>=910

* New Mexico
replace primary = 1 if state==66 & yearofelect>=936

* Utah
replace primary = 1 if state==67 & yearofelect>=938

* Wyoming
replace primary = 1 if state==68 & yearofelect>=912

* California
replace primary = 1 if state==71 & yearofelect>=910

* Oregon
replace primary = 1 if state==72 & yearofelect>=902

* Washington
replace primary = 1 if state==73 & yearofelect>=908


* Ballot

gen lb = 0
gen ab = 0
gen pc = 0
gen ob = 0
gen pb = 0


* Kentucky
* Local, office bloc, 1888

replace lb = 1 if state==51 & yearofelect>= 888 & yearofelect<= 891
replace ob = 1 if state==51 & yearofelect>= 888 & yearofelect<= 891

* State, party column, box, 1892

replace ab = 1 if state==51 & yearofelect>= 892
replace pc = 1 if state==51 & yearofelect>= 892
replace pb = 1 if state==51 & yearofelect>= 892


* Massachusetts
* State, office bloc 1888

replace ab = 1 if state==3 & yearofelect>= 888
replace ob = 1 if state==3 & yearofelect>= 888


* Indiana
* State, party column, box, 1889

replace ab = 1 if state==22 & yearofelect>= 889
replace pc = 1 if state==22 & yearofelect>= 889
replace pb = 1 if state==22 & yearofelect>= 889


* Missouri
* Local, party column, 1889

replace lb = 1 if state==34 & yearofelect>= 889 & yearofelect<= 890
replace pc = 1 if state==34 & yearofelect>= 889

* State, party column, box, 1891

replace ab = 1 if state==34 & yearofelect>= 891
replace pb = 1 if state==34 & yearofelect>= 891

* Ballot repealed in 1897 (leave ab, pc, pb unchanged)
* State printed official ballots, provided for secrecy
* Separate ballots for each party made ticket splitting difficult

* State, party column, box, 1921


* Montana
* State, office bloc, box, 1889

replace ab = 1 if state==64 & yearofelect>= 889
replace ob = 1 if state==64 & yearofelect>= 889 & yearofelect<= 894
replace pb = 1 if state==64 & yearofelect>= 889 & yearofelect<= 894

* State, party column, box, 1895

 replace pc = 1 if state==64 & yearofelect>= 895 & yearofelect<= 900
 replace pb = 1 if state==64 & yearofelect>= 895 & yearofelect<= 900

* State, party column, 1901

 replace pc = 1 if state==64 & yearofelect>= 901 & yearofelect<= 938

* State, office bloc, 1939

replace ob = 1 if state==64 & yearofelect>= 939


* Rhode Island
* State, office bloc, 1889

replace ab = 1 if state==5 & yearofelect>= 889
replace ob = 1 if state==5 & yearofelect>= 889 & yearofelect<= 904

* State, party column, box, 1905

replace pc = 1 if state==5 & yearofelect>= 905
replace pb = 1 if state==5 & yearofelect>= 905


* Wisconsin
* State, office bloc, 1889

replace ab = 1 if state==25 & yearofelect>= 889
replace ob = 1 if state==25 & yearofelect>= 889 & yearofelect<= 890

* Local, party column, box, 1891

replace pc = 1 if state==25 & yearofelect>= 891
replace pb = 1 if state==25 & yearofelect>= 891


* Minnesota
* Local, office bloc, box, 1889

replace lb = 1 if state==33 & yearofelect>= 889 & yearofelect<= 890
replace ob = 1 if state==33 & yearofelect>= 889 & yearofelect<= 890
replace pb = 1 if state==33 & yearofelect>= 889 & yearofelect<= 890

* State, office bloc, 1891

replace ab = 1 if state==33 & yearofelect>= 891
replace ob = 1 if state==33 & yearofelect>= 891


* Tennessee
* Local, office bloc, 1889

replace lb = 1 if state==54 & yearofelect>= 889 & yearofelect<= 921
replace ob = 1 if state==54 & yearofelect>= 889 & yearofelect<= 921

* State, office bloc, 1922
* Confirm date of statewide application

replace ab = 1 if state==54 & yearofelect>= 922
replace ob = 1 if state==54 & yearofelect>= 922


* Connecticut
* State, party column, box, 1909

replace ab = 1 if state==1 & yearofelect>= 909
replace pc = 1 if state==1 & yearofelect>= 909
replace pb = 1 if state==1 & yearofelect>= 909


* Oklahoma
* State, party column, box, 1890

replace ab = 1 if state==53 & yearofelect>= 890
replace pc = 1 if state==53 & yearofelect>= 890 & yearofelect<= 896
replace pb = 1 if state==53 & yearofelect>= 890 & yearofelect<= 896

* State, office bloc, 1897

replace ob = 1 if state==53 & yearofelect>= 897 & yearofelect<= 898

* State, party column, box, 1899

replace pc = 1 if state==53 & yearofelect>= 899 & yearofelect<= 908
replace pb = 1 if state==53 & yearofelect>= 899 & yearofelect<= 908

* State, office bloc, 1909

replace ob = 1 if state==53 & yearofelect== 909

* State, party column, box, 1910

replace pc = 1 if state==53 & yearofelect>= 910
replace pb = 1 if state==53 & yearofelect>= 910


* Maryland
* Local, party column, box, 1890

replace lb = 1 if state==52 & yearofelect>= 890 & yearofelect<= 891
replace pc = 1 if state==52 & yearofelect>= 890 & yearofelect<= 892
replace pb = 1 if state==52 & yearofelect>= 890 & yearofelect<= 892

* State, party column, box, 1892

replace ab = 1 if state==52 & yearofelect>= 892
replace pc = 1 if state==52 & yearofelect>= 892 & yearofelect<= 900
replace pb = 1 if state==52 & yearofelect>= 892 & yearofelect<= 900

* State, office bloc, 1901

replace ob = 1 if state==52 & yearofelect>= 901


* Washington
* State, office bloc, box, 1890

replace ab = 1 if state==73 & yearofelect>= 890
replace ob = 1 if state==73 & yearofelect== 890
replace pb = 1 if state==73 & yearofelect== 890

* State, party column, box, 1891

replace pc = 1 if state==73 & yearofelect>= 891 & yearofelect<= 894
replace pb = 1 if state==73 & yearofelect>= 891 & yearofelect<= 894

* State, office bloc, box, 1895

replace ob = 1 if state==73 & yearofelect>= 895 & yearofelect<= 900
replace pb = 1 if state==73 & yearofelect>= 895 & yearofelect<= 900

* State, party column, box, 1901

replace pc = 1 if state==73 & yearofelect>= 901
replace pb = 1 if state==73 & yearofelect>= 901


* Mississippi
* State, office bloc, 1890

replace ab = 1 if state==46 & yearofelect>= 890
replace ob = 1 if state==46 & yearofelect>= 890


* Vermont
* State, office bloc, 1890

replace ab = 1 if state==6 & yearofelect>= 890
replace ob = 1 if state==6 & yearofelect>= 890 & yearofelect<= 891

* State, party column, box, 1892

replace pc = 1 if state==6 & yearofelect>= 892
replace pb = 1 if state==6 & yearofelect>= 892


* Wyoming
* State, office bloc, 1890

replace ab = 1 if state==68 & yearofelect>= 890
replace ob = 1 if state==68 & yearofelect>= 890 & yearofelect<= 896

* State, party column, box, 1897

replace pc = 1 if state==68 & yearofelect>= 897 & yearofelect<= 910
replace pb = 1 if state==68 & yearofelect>= 897 & yearofelect<= 910

* State, party column, 1911
* Confirm date of application

replace pc = 1 if state==68 & yearofelect>= 911


* New Jersey
* State, office bloc, 1911

replace ab = 1 if state==12 & yearofelect>= 911
replace ob = 1 if state==12 & yearofelect>= 911 & yearofelect<= 929

* State, party column, 1930
* Confirm date of application

replace pc = 1 if state==12 & yearofelect>= 930


* New York
* State, party column, box, 1895

replace ab = 1 if state==13 & yearofelect>= 895
replace pc = 1 if state==13 & yearofelect>= 895 & yearofelect<= 912
replace pb = 1 if state==13 & yearofelect>= 895 & yearofelect<= 912

* State, office bloc, box, 1895

replace ob = 1 if state==13 & yearofelect>= 913


* Colorado
* State, party column, box, 1891

replace ab = 1 if state==62 & yearofelect>= 891
replace pc = 1 if state==62 & yearofelect>= 891 & yearofelect<= 893
replace pb = 1 if state==62 & yearofelect>= 891 & yearofelect<= 893

* State, office bloc, box, 1894

replace ob = 1 if state==62 & yearofelect>= 894 & yearofelect<= 913
replace pb = 1 if state==62 & yearofelect>= 894 & yearofelect<= 913

* State, office bloc, 1914
* Confirm date of application

replace ob = 1 if state==62 & yearofelect>= 914


* Delaware
* State, party column, box, 1891

replace ab = 1 if state==11 & yearofelect>= 891
replace pc = 1 if state==11 & yearofelect>= 891
replace pb = 1 if state==11 & yearofelect>= 891


* Illinois
* State, party column, box, 1891

replace ab = 1 if state==21 & yearofelect>= 891
replace pc = 1 if state==21 & yearofelect>= 891
replace pb = 1 if state==21 & yearofelect>= 891


* Maine
* State, party column, box, 1891

replace ab = 1 if state==2 & yearofelect>= 891
replace pc = 1 if state==2 & yearofelect>= 891
replace pb = 1 if state==2 & yearofelect>= 891


* Michigan
* State, party column, box, 1891

replace ab = 1 if state==23 & yearofelect>= 891
replace pc = 1 if state==23 & yearofelect>= 891
replace pb = 1 if state==23 & yearofelect>= 891


* Ohio
* State, party column, box, 1891

replace ab = 1 if state==24 & yearofelect>= 891
replace pc = 1 if state==24 & yearofelect>= 891
replace pb = 1 if state==24 & yearofelect>= 891


* Pennsylvania
* State, party column, box, 1891

replace ab = 1 if state==14 & yearofelect>= 891
replace pc = 1 if state==14 & yearofelect>= 891 & yearofelect<= 902
replace pb = 1 if state==14 & yearofelect>= 891 & yearofelect<= 902

* State, office bloc, box, 1903

replace ob = 1 if state==14 & yearofelect>= 903
replace pb = 1 if state==14 & yearofelect>= 903


* West Virginia
* State, party column, box, 1891

replace ab = 1 if state==56 & yearofelect>= 891
replace pc = 1 if state==56 & yearofelect>= 891
replace pb = 1 if state==56 & yearofelect>= 891


* Idaho
* State, party column, 1891

replace ab = 1 if state==63 & yearofelect>= 891
replace pc = 1 if state==63 & yearofelect>= 891 & yearofelect<= 902

* State, party column, box, 1903

replace pc = 1 if state==63 & yearofelect>= 903 & yearofelect<= 917
replace pb = 1 if state==63 & yearofelect>= 903 & yearofelect<= 917

* State, party column, 1918

replace pc = 1 if state==63 & yearofelect>= 918 & yearofelect<= 919

* State, party column, box, 1920

replace pc = 1 if state==63 & yearofelect>= 920
replace pb = 1 if state==63 & yearofelect>= 920


* California
* State, office bloc, box, 1891

replace ab = 1 if state==71 & yearofelect>= 891
replace ob = 1 if state==71 & yearofelect>= 891 & yearofelect<= 892
replace pb = 1 if state==71 & yearofelect>= 891 & yearofelect<= 892

* State, office bloc, 1893

replace ob = 1 if state==71 & yearofelect>= 893 & yearofelect<= 898

* State, party column, 1899

replace pc = 1 if state==71 & yearofelect>= 899 & yearofelect<= 902

* State, party column, box, 1903

replace pc = 1 if state==71 & yearofelect>= 903 & yearofelect<= 910
replace pb = 1 if state==71 & yearofelect>= 903 & yearofelect<= 910

* State, office bloc, 1911

replace ob = 1 if state==71 & yearofelect>= 911


* North Dakota
* State, office bloc, box, 1891

replace ab = 1 if state==36 & yearofelect>= 891
replace ob = 1 if state==36 & yearofelect>= 891 & yearofelect<= 892
replace pb = 1 if state==36 & yearofelect>= 891 & yearofelect<= 892

* State, party column, 1893

replace pc = 1 if state==36 & yearofelect>= 893 & yearofelect<= 896

* State, party column, box, 1897

replace pc = 1 if state==36 & yearofelect>= 897
replace pb = 1 if state==36 & yearofelect>= 897

* State, party column, 1926
* Confirm date of application

replace pc = 1 if state==36 & yearofelect>= 926


* Arizona
* State, office bloc, 1891

replace ab = 1 if state==61 & yearofelect>= 891
replace ob = 1 if state==61 & yearofelect>= 891 & yearofelect<= 894

* State, party column, party box, 1895

replace pc = 1 if state==61 & yearofelect>= 895
replace pb = 1 if state==61 & yearofelect>= 895


* Arkansas
* State, office bloc, 1891

replace ab = 1 if state==42 & yearofelect>= 891
replace ob = 1 if state==42 & yearofelect>= 891


* Nebraska
* State, office bloc, 1891

replace ab = 1 if state==35 & yearofelect>= 891
replace ob = 1 if state==35 & yearofelect>= 891 & yearofelect<= 896

* State, party column, party box, 1897

replace pc = 1 if state==35 & yearofelect>= 897 & yearofelect<= 898
replace pb = 1 if state==35 & yearofelect>= 897 & yearofelect<= 898

* State, office bloc, 1899

replace ob = 1 if state==35 & yearofelect>= 899 & yearofelect<= 900

* State, office bloc, box, 1901

replace ob = 1 if state==35 & yearofelect>= 901 & yearofelect<= 932
replace pb = 1 if state==35 & yearofelect>= 901 & yearofelect<= 932

* State, office bloc, 1933
* Confirm date of application

replace ob = 1 if state==35 & yearofelect>= 933


* Nevada
* State, office bloc, 1891

replace ab = 1 if state==65 & yearofelect>= 891
replace ob = 1 if state==65 & yearofelect>= 891


* New Hampshire
* State, office bloc, 1891

replace ab = 1 if state==4 & yearofelect>= 891
replace ob = 1 if state==4 & yearofelect>= 891 & yearofelect<= 896

* State, party column, box, 1897

replace pc = 1 if state==4 & yearofelect>= 897
replace pb = 1 if state==4 & yearofelect>= 897


* Oregon
* State, office bloc, 1891

replace ab = 1 if state==72 & yearofelect>= 891
replace ob = 1 if state==72 & yearofelect>= 891


* South Dakota
* State, office bloc, 1891

replace ab = 1 if state==37 & yearofelect>= 891
replace ob = 1 if state==37 & yearofelect>= 891 & yearofelect<= 892

* State, party column, box, 1893

replace pc = 1 if state==37 & yearofelect>= 893
replace pb = 1 if state==37 & yearofelect>= 893


* Iowa
* State, party column, box, 1892

replace ab = 1 if state==31 & yearofelect>= 892
replace pc = 1 if state==31 & yearofelect>= 892 & yearofelect<= 905
replace pb = 1 if state==31 & yearofelect>= 892 & yearofelect<= 905

* State, party column, 1906

replace pc = 1 if state==31 & yearofelect>= 906 & yearofelect<= 919

* State, party column, box, 1920

replace pc = 1 if state==31 & yearofelect>= 920
replace pb = 1 if state==31 & yearofelect>= 920


* Texas
* Local, party column, box, 1892

replace lb = 1 if state==49 & yearofelect>= 892 & yearofelect<= 902
replace pc = 1 if state==49 & yearofelect>= 892 & yearofelect<= 902
replace pb = 1 if state==49 & yearofelect>= 892 & yearofelect<= 902

* Repeal local, party column, box, 1903
* State printed official ballots
* Separate ballots for each party made ticket splitting difficult
* State, party column, box, 1905

replace ab = 1 if state==49 & yearofelect>= 905
replace pc = 1 if state==49 & yearofelect>= 905
replace pb = 1 if state==49 & yearofelect>= 905


* Kansas
* State, party column, 1893

replace ab = 1 if state==32 & yearofelect>= 893
replace pc = 1 if state==32 & yearofelect>= 893 & yearofelect<=900

* State, party column, box, 1901

replace pc = 1 if state==32 & yearofelect>= 901 & yearofelect<=912
replace pb = 1 if state==32 & yearofelect>= 901 & yearofelect<=912

* State, office bloc, 1913

replace ob = 1 if state==32 & yearofelect>= 913


* Alabama
* State, office bloc, 1893

replace ab = 1 if state==41 & yearofelect>= 893
replace ob = 1 if state==41 & yearofelect>= 893 & yearofelect<= 902

* State, party column, box, 1903

replace pc = 1 if state==41 & yearofelect>= 903
replace pb = 1 if state==41 & yearofelect>= 903


* Virginia
* State, office bloc, 1894

replace ab = 1 if state==40 & yearofelect>= 894
replace ob = 1 if state==40 & yearofelect>= 894


* Florida
* State, office bloc, 1895

replace ab = 1 if state==43 & yearofelect>= 895
replace ob = 1 if state==43 & yearofelect>= 895


* Utah
* State, office bloc, box, 1896

replace ab = 1 if state==67 & yearofelect>= 896
replace ob = 1 if state==67 & yearofelect== 896
replace pb = 1 if state==67 & yearofelect== 896

* State, party column, box, 1897

replace pc = 1 if state==67 & yearofelect>= 897
replace pb = 1 if state==67 & yearofelect>= 897


* Louisiana
* State, office bloc, 1896

replace ab = 1 if state==45 & yearofelect>= 896
replace ob = 1 if state==45 & yearofelect>= 896 & yearofelect<= 897

* State, party column, box, 1898

replace pc = 1 if state==45 & yearofelect>= 898
replace pb = 1 if state==45 & yearofelect>= 898


* New Mexico
* No statewide aussie ballot until 1928; code as 1905
* State printed official ballots, provided for secrecy
* Separate ballots for each party made ticket splitting difficult
* State, party column, box, 1905

replace ab = 1 if state==66 & yearofelect>= 905
replace pc = 1 if state==66 & yearofelect>= 905
replace pb = 1 if state==66 & yearofelect>= 905

* State, party column, party box, 1928


* North Carolina
* Local, party column, box, 1909

replace lb = 1 if state==47 & yearofelect>= 909 & yearofelect<= 928
replace pc = 1 if state==47 & yearofelect>= 909 & yearofelect<= 928
replace pb = 1 if state==47 & yearofelect>= 909 & yearofelect<= 928

* State, party column, box, 1929

replace ab = 1 if state==47 & yearofelect>= 929
replace pc = 1 if state==47 & yearofelect>= 929
replace pb = 1 if state==47 & yearofelect>= 929


* Georgia
* State, party column, box, 1922

replace ab = 1 if state==44 & yearofelect>= 922
replace pc = 1 if state==44 & yearofelect>= 922
replace pb = 1 if state==44 & yearofelect>= 922


* South Carolina
* No official ballot during period
* Adopted in 1950 (confirm ob form)

replace ab = 1 if state==48 & yearofelect>= 950
replace ob = 1 if state==48 & yearofelect>= 950 


* Ballot
* Treats local and statewide laws equivalently

gen ballot = ab


* Define treatment indicators

sort icpsrno congress

egen min_ballot = min(ballot), by(icpsrno)
egen max_ballot = max(ballot), by(icpsrno)

egen min_primary = min(primary), by(icpsrno)
egen max_primary = max(primary), by(icpsrno)

gen ref_none = 0
replace ref_none = 1 if ballot==0 & primary==0

gen ref_bal_only = 0
replace ref_bal_only = 1 if ballot==1 & primary==0

gen ref_pri_only = 0
replace ref_pri_only = 1 if ballot==0 & primary==1

gen ref_both = 0
replace ref_both = 1 if ballot==1 & primary==1


* Screen indicators
* NOTE:  To eliminate post-reform member-congress obs. from MCs who began pre-refrom

gen scr_bal_only = 0
replace scr_bal_only = 1 if ref_bal_only==1 & min_ballot==0

gen scr_both = 0
replace scr_both = 1 if ref_both==1 & min_ballot==0
replace scr_both = 1 if ref_both==1 & min_primary==0


* Treatment variables

* Pre-Reform vs. Ballot Only

gen ref_ballot = 0
replace ref_ballot = 1 if ref_bal_only==1
replace ref_ballot = . if ref_pri_only==1
replace ref_ballot = . if ref_both==1


* Pre-Reform vs. Ballot + Primary

gen ref_bal_pri = 0
replace ref_bal_pri = 1 if ref_both==1
replace ref_bal_pri = . if ref_pri_only==1
replace ref_bal_pri = . if ref_bal_only==1


drop lb ab pc ob pb ballot min_ballot primary max_ballot min_primary max_primary ///
     ref_none ref_bal_only ref_pri_only ref_both scr_bal_only scr_both


* Merge bill introductions

sort icpsr_cong

merge 1:1 icpsr_cong using "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\Bill Introductions\bills_1.dta", update

tab _merge
drop if _merge==2
drop _merge


* Merge bill introductions

sort icpsr_cong

merge 1:1 icpsr_cong using "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\Bill Introductions\bills_2.dta", update

tab _merge
drop if _merge==2
drop _merge


* Merge bill introductions

sort icpsr_cong

merge 1:1 icpsr_cong using "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\Bill Introductions\bills_3.dta", update

tab _merge
drop if _merge==2
drop _merge


* Eliminate members with missing values

drop if state==.
drop if margin==.
drop if gdem_p_12_ave==.
drop if age==.
drop if yr_hse==.
drop if hsemaj_r==.


* Eliminate members winning by special election

drop if V43!=0


sort icpsr_cong


save "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\Main\mww_1.dta", replace


* Generate files for matching and Monte Carlo analyses

* Ballot and Non-reform settings, North

use "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\Main\mww_1.dta", clear


* Eliminate extraneous variables

order icpsrno congress invpens private local policy ///
     margin gdem_p_12_ave democrat hsemaj_r ///
	 i_vets_rank2 south ind b_pop_top ///
	 hse_terms com_pcom chr_any ///
	 age hse_terms yr_hse_hi l_fun ///
	 ref_ballot

keep icpsrno congress invpens private local policy ///
     margin gdem_p_12_ave democrat hsemaj_r ///
	 i_vets_rank2 south ind b_pop_top ///
	 hse_terms com_pcom chr_any ///
	 age hse_terms yr_hse_hi l_fun ///
	 ref_ballot


* Eliminate MCs from primary settings, South

drop if ref_ballot==.
drop if south==1


outsheet using "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\MWW Table 1\mww_1_ref_ballot_ns.txt", replace


* Ballot and Non-reform settings, South

use "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\Main\mww_1.dta", clear


* Eliminate extraneous variables

order icpsrno congress invpens private local policy ///
     margin gdem_p_12_ave hsemaj_r ///
	 south b_pop_top ///
	 hse_terms chr_any ///
	 age hse_terms yr_hse_hi l_fun ///
	 ref_ballot

keep icpsrno congress invpens private local policy ///
     margin gdem_p_12_ave hsemaj_r ///
	 south b_pop_top ///
	 hse_terms chr_any ///
	 age hse_terms yr_hse_hi l_fun ///
	 ref_ballot


* Eliminate MCs from primary settings, non-South

drop if ref_ballot==.
drop if south==0


outsheet using "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\MWW Table 1\mww_1_ref_ballot_s.txt", replace


* Primary and Non-reform settings, North

use "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\Main\mww_1.dta", clear


* Eliminate extraneous variables

order icpsrno congress invpens private local policy ///
     margin gdem_p_12_ave democrat hsemaj_r ///
	 i_vets_rank2 south ind b_pop_top ///
	 hse_terms com_pcom chr_any ///
	 age hse_terms yr_hse_hi l_fun ///
	 ref_bal_pri

keep icpsrno congress invpens private local policy ///
     margin gdem_p_12_ave democrat hsemaj_r ///
	 i_vets_rank2 south ind b_pop_top ///
	 hse_terms com_pcom chr_any ///
	 age hse_terms yr_hse_hi l_fun ///
	 ref_bal_pri


* Eliminate MCs from ballot settings, South

drop if ref_bal_pri==.
drop if south==1


outsheet using "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\MWW Table 1\mww_1_ref_bal_pri_ns.txt", replace


* Primary and Non-reform settings, South

use "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\Main\mww_1.dta", clear


* Eliminate extraneous variables

order icpsrno congress invpens private local policy ///
     margin gdem_p_12_ave hsemaj_r ///
	 south b_pop_top ///
	 hse_terms chr_any ///
	 age hse_terms yr_hse_hi l_fun ///
	 ref_bal_pri

keep icpsrno congress invpens private local policy ///
     margin gdem_p_12_ave hsemaj_r ///
	 south b_pop_top ///
	 hse_terms chr_any ///
	 age hse_terms yr_hse_hi l_fun ///
	 ref_bal_pri


* Eliminate MCs from ballot settings, non-South

drop if ref_bal_pri==.
drop if south==0


outsheet using "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\MWW Table 1\mww_1_ref_bal_pri_s.txt", replace

* End
