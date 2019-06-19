/************************************************************
                        MANOJ MOHANAN
* Causal Effects of Health Shocks on Consumption and Debt:  *
*  Quasi-Experimental Evidence from Bus Accident Injuries   *

*   Review of Economics and Statistics 2013 95:2, 673-681   *
                   
*************************************************************
NOTES:
	THIS PROGRAM LABELS VARIABLES USED IN ANALYSES
	AND ALSO RECODES VARIABLES FOR ANALYSIS.
************************************************************/


use echos.dta, clear

** CREATING STRING VARIABLE FOR SERIAL NUMBER
tostring serno, generate(s_serno) format(%5.0f)
count if length(s_s) ==5
replace s_serno = "0" + s_serno if length(s_serno) == 4
replace s_serno = "00" + s_serno if length(s_serno) == 3
replace s_se = "05754" if s_ser == "05755"
count if length(s_s) ==5

** MERGING COMPENSATION AMOUNTS AND DATE
sort serno
merge serno using compensation.dta
drop _m


****************
*LABEL DEFINITIONS
*****************/
label define sex 1 "1:Male" 2 "2:Female"
label define role 1  "1:Sole Earning Member" 2 "2:One among earning members" 3 "3:Non-earning(Depndt)"
label define exposed 1 "1:Exposed" 2 "2:Unexposed"
label define urbrur 1 "1:Rural" 2 "2:Urban"
label define relig 1 "1:Hindu" 2 "2:Muslim" 3"3:Christian" 4"4:Sikh" 5"5:Jain" 6"6:Buddhist" 7"7:Others"
label define scst 1 "1:Sch.Caste" 2 "2:Sch.Tribe" 8 "8:N/A"
label define relan 1"1:Head" 2"2:Spouse" 3"3:Parent" 4"4:Son/Dter" 5"5:Son/Dterinlaw" 6"6:Grandchild" 7"7:Broth/Sis" 8"8:Parentinlaw" 9"9:Broth/Sisinlaw" 10"10:Othrelatives" 11"11:Notrelated"
label define educ 1"1:Illiterate" 2"2:Can read/write but no school" 3"3:Primary educ(1-4th)" 4"4:Middle School(5-7th)" 5"5:High School(8-10th)" 6"6:PUC" 7"7:Did not finish college" 8"8:College & above" 98"98:Not applicable [age<6]"
label define occu 1"1:Prof/TechWorker" 2"2:Admin/Exec/Mgmt worker"  3"3:Clerical/Staff" 4"4:merchant/big" 5"5:merchant/small" 6"6:salesman/shopasst"  7"7:moneylender" 8"8:restaurantowner" 9"9:cook/waiter/barattendee" 10"10:maids/housekeeping" 11"11:launderer" 12"12:fire/police/watchman" 13"13:farmer" 14"14:dairy/poultry" 15"15:laboreragri" 16"16:fisherman/hunter/logger" 17"17:productionworker"  18"18:transport(operator/driver)" 19"19:laborernonagri" 20"20:otherworker" 21"21:retired" 22"22:housewife" 23"23:student" 24"24:beggar" 98"98:notapplicable" 99"99:no response"
label define yn 1"1:Yes" 2 "2:No"
label define sold 1"1:Sold" 2"2:Pledged" 3"3:No" 8"8:NA"
label define reastart 1"1:FinSchool" 2"2:Cdntfindjobearlier" 3"3:Othearnmembunable" 4"4:Other"
label define reastop 1"1:Jobended" 2"2:Toosick" 3"3:Noneed" 4"4:Takngcare" 5"5:Other"
label define house 1"1:kacha" 2"2:semipucca" 3"3:pucca"
label define own 1"1:own" 2"2:notown"
label define watersrc 1"1:pvttap" 2"2:pubtap" 3"3:PvtHP/borewl" 4"4:PubHP/borewl" 5"5:PvtCovwell" 6"6:PvtOpwell" 7"7:PubCovwell" 8"8:PubOpwell" 9"9:Sp/Pnd/Lk" 10"10:Riv/Strm" 11"11:Canal" 12"12:Tanker/Truck" 13"13:Others"
label define toilet 1"1:OwnFlush" 2"2:SharedFlush" 3"3:Publicflush" 4"4:OwnPit/lat" 5"5:SharedPit/lat" 6"6:PublicPit/lat" 7"7:Nofac/bush"
label define fuel 1"1:Gas" 2"2:Kerosene" 3"3:GobarGas" 4"4:Wood" 5"5:Other"
label define light 1"1:Elec" 2"2:Kerosene" 3"3:Other"
label define ratcol 1"1:yellow" 2"2:red" 3"3:white" 4"4:NA"
label define income 1"1:Agric(own)" 2"2:Agric(Wage)" 3"3:Wage labor (non-farm)"  4"4:Cattle/Poultry raising" 5"5:Small trader" 6"6:Self Empl incl hhold indstry" 7"7:Money lender" 8"8:Salaried" 9"9:Rental land/prop" 10"10:Pension" 11"11:Support from other/aid" 12"12:Others" 13"13:Refused to answer"
label define serious 1"1:Notserious" 2"2:QuiteSerious" 3"3:VerySerious" 4"4:Notsure/DK"
label define fac1 1 "1:NoRx" 2 "2:Home" 3 "3:TradDr" 4 "4:QuackDr" 5 "5:DrPvt" 6 "6:DrPub" 7 "7:Subctr" 8 "8:PHU" 9 "9:PHC" 10 "10:HospGovt" 11 "11:HospPvt" 12 "12:CharInst" 13 "13:NrsngHm" 14 "14:DrgStr" 15 "15:Other" 99 "99:DK/CantSay"
label define rsnotrt 1"1:Notime" 2"2:No Money" 3"3:NoFacclose" 4"4:NotSers" 5"5:NoEscort" 6"6:NoFaith"
label define fac2 1 "1:SubCtr" 2 "2:PHU" 3 "3:PHC" 4 "4:HospGovt" 5 "5:HospPvt" 6 "6:CharInst" 7 "7:NrsngHm" 8 "8:Other" 99 "9:DK/CantSay"
label define frequent 1"1:Frequently" 2"2:Occassionally" 3"3:Never"
label define definite 1"1:Definitely" 2"2:Probably" 3"3:Unsure" 4"4:Prob_Not" 5"5:Defin_Not"
label define agree 1"1:AgreeStrongly" 2"2:AgreeSomewhat" 3"3:Neither" 4"4:DisagreeSomewhat" 5"5:DisagreeStrongly"
label define extent 1"1:VeryGreatExtent" 2"2:GreatExtent" 3"3:Neither" 4"4:SmallExtent" 5"5:VerySmallExtent"
label define likely 1"1:VeryLikely" 2"2:SomewhatLikely" 3"3:SomewhatUnlikely" 4"4:VeryUnlikely" 5"5:Can'ttell"
label define good 1"1:VeryGood" 2"2:Good" 3"3:Moderate" 4"4:Bad" 5"5:VeryBad"
label define mildmodsev 1"1:None" 2"2:Mild/Mod" 3"3:Severe/Extreme"
label define often 0"0:Noneoftime" 1"1:Littleoftime" 2"2:Someoftime" 3"3:Mostoftime" 4"4:Alloftime"
label define spirituality 1"1:Haven't at all" 2"2:Sometimes/once in a while" 3"3:Often/most of the time" 4"4:All the time"
label define noyes 0"0:No" 1"1:Yes" 


********************
* Variable Definitions
********************

label var sex "Sex of Bus Passenger"
label val sex sex

label var age "Age of Bus Passenger"

label var role "Role of Bus Passenger"
label val role role

label var exp "Exposed"
label val exp exposed

label var noinacc "No. of members in accident"
label var times "No of times UNEXPOSED traveled"
label var dist "District"
label var taluk "Taluk"
label var vill "Village"

label var urbrur "Urban or Rural Residence"
label val urbrur urbrur

label var relig "Religion that household belongs to"
label val relig relig

label var scst "Schd. Caste/Tribe"
label val scst scst

* Loops for questions 1.20-1.31 for up to 9 members

foreach x of varlist relan_* {
label var `x' "Relation to Bus Passenger"
label val `x' relan
}

foreach x of varlist sex_* {
label var `x' "Sex of household member "
label val `x' sex
}

foreach x of varlist age_* {
label var `x' "Age of household member "
}
destring age_4, replace


foreach x of varlist educ_* {
label var `x' "Education of household member"
label val `x' educ
}

replace occu_1 = "21" if occu_1 == "21(PENSIONER)"
destring occu*, replace
foreach x of varlist occu_* {
label var `x' "Occupation of household member"
label val `x' occu
}

foreach x of varlist startwork_* {
label var `x' "Any member start working"
label val `x' yn
}

foreach x of varlist reastart_* {
label var `x' "Reason to start work"
label val `x' reastart
}

foreach x of varlist stopwk_* {
label var `x' "Any member stop work"
label val `x' yn
}

replace reastop_2 = "1" if reastop_2 == "1(retred)"
destring reastop_2, replace
foreach x of varlist reastop_* {
label var `x' "Reason to stop work"
label val `x' reastop
}

label var house "Type of house"
label val house house

*There were two with own == 3
* House_own is more reliable - consistent with house values
replace own = 1 if house_own == 1 & own == 2
replace own = 1 if house_own == 1 & own == 3
replace own = 2 if house_own == 2 & own == 1
replace own = 2 if house_own == 2 & own == 3

label var own "Ownership of house"
label val own own

label var landwt "Wet land area"
label var landdry "Dry Land Area"
label var landnc "Noncultivable land area"

label var drink "Drinking Water Source"
label val drink watersrc

label var bath "Bathing Water Source"
label val bath watersrc

label var toil "Type of Toilet"
label val toil toilet

label var fueltype "Type of Fuel"
label val fueltype fuel

label var light "Source of light"
label val light light

label var ration "Do you have ration card?
label val ration yn

label var ratcol "Color of Ration Card"
label val ratcol ratcol

replace other_own = "1" if other_own == "1 (TEMPO)" | other_own == "AUTO" | other_own == "CD PLAYER" | other_own == "LIC BOND" | other_own == "Wooden cupboard"
destring other_own, replace
foreach x of varlist *_own {
label var `x' "Does the household own"
label val `x' yn
}


replace cycle_val = "1000" if cycle_val == "10009fRREGVEN BY Govt)"
destring cycle_val, replace
foreach x of varlist *_val {
label var `x' "What is the value of"
}

foreach x of varlist *_purch {
label var `x' "In last yr did hhld purchase"
label val `x' yn
}

foreach x of varlist *_pay {
label var `x' "How much paid for purchase"
}

* There was one household (serno = 1915, num = 206), that had
* both sold and pledged (40K & 50K resp) - Borrowed was for health and house repairs
* As a middle ground, I have set it to "pledged 50K"

replace jwlry_recv = "50000" if jwlry_sell == "1 & 2"
replace jwlry_sell = "2" if jwlry_sell == "1 & 2"
destring jwlry_sell, replace
foreach x of varlist *_sell {
label var `x' "In last yr did hhld sell"
label val `x' sold
}



destring jwlry_recv, replace
foreach x of varlist *_recv {
label var `x' "How much was rcvd for selling"
}

** Many of the reasons for selling listed as "other" were investments such as livestock, cultivation, constructiond 
** Accidents will be counted as health reasons
** School expenses and house expenses are recoded as "other"
label var rssell "reason for selling/pledging"
replace rssell = "H" if rssell == "H(HOUSE EXPENSES)"
replace rssell = "A" if rssell == "H( TO BUY LIVESTOCK)"
replace rssell = "A" if rssell == "H (to buy live stock)"
replace rssell = "B" if rssell == "H (HOUSE EXPNESS AND TO DIG BOREWELL)"
replace rssell = "BG" if rssell == "GH(CULTIVATION)"
replace rssell = "AF" if rssell == "FH(Construction of House)"
replace rssell = "FH" if rssell == "FH( HOUSE EXPENSES)"
replace rssell = "FGH" if rssell == "FGH(HOUSE EXPENSES)"
replace rssell = "BGF" if rssell == "FGH(CULTIVATION)"
replace rssell = "F" if rssell == "H(ACCIDENT)"
replace rssell = "H" if rssell == "H(SCHOOL FEE)"
replace rssell = "Z" if rssell == "2"
replace rssell = "Z" if rssell == "z"


label var debt "Hhld have any debt?"
replace debt = "1" if debt == "EFG1" | debt == "H(ACCIDENT)"
destring debt, replace
label val debt yn

* variable debt had two entry errors - [confirmed with total debt != 0]
label var totdebt "Total debt in hhld"

label var borrow "Hhld borrowed last year?"
replace borrow = 2 if borrow == 8
label val borrow yn

label var amtborr "Amount borrowed last year"

label var interest "Interest rate borrowed"
replace interest = "0" if interest == "TO REPAY BYWORKING"
destring interest, replace

/**************************************************
***************************************************
label var whyborr "Why was the money borrowed?"
*** THIS ONE IS A NIGHTMARE ****
* WILL THINK ABOUT THESE SOME MORE *

label var borrfrom "Borrowed from whom"

***************************************************
***************************************************/

* Changing Main Source of Income to numeric
* Stata doesnt allow strings to be labeled
replace mnsrcinc = "1" if mnsrcinc == "A"
replace mnsrcinc = "2" if mnsrcinc == "B"
replace mnsrcinc = "3" if mnsrcinc == "C"
replace mnsrcinc = "4" if mnsrcinc == "D"
replace mnsrcinc = "5" if mnsrcinc == "E"
replace mnsrcinc = "6" if mnsrcinc == "F"
replace mnsrcinc = "7" if mnsrcinc == "G"
replace mnsrcinc = "8" if mnsrcinc == "H"
replace mnsrcinc = "9" if mnsrcinc == "I"
replace mnsrcinc = "10" if mnsrcinc == "J"
replace mnsrcinc = "11" if mnsrcinc == "K"
replace mnsrcinc = "12" if mnsrcinc == "L"
replace mnsrcinc = "13" if mnsrcinc == "M"
tab mnsrcinc, miss
destring mnsrcinc, replace
label var mnsrcinc "Main source of income"
label val mnsrcinc income

label var incmain "avg income_main src"
label var incsec "avg income_sec. src"

label var saving "Contr $ to any saving?"
label val saving yn

foreach x of varlist hi_* {
label var `x' "Have health insurance"
label val `x' yn
}

label var ins_lic "Have life insurance"
label val ins_lic yn

foreach x of varlist yr_* {
label var `x' "How long have you had this insurance"
}

***
* THE YR_* NEEDS TO BE CODED INTO NUMERIC
*************************************

label var useins "Used insurance benefits last year"
replace useins = 2 if useins == 3
label val useins yn

label var spend30 "Expend in 30 days"

foreach x of varlist food rent fuel water elec phone cable recrn educ_yr hlth_yr fest_yr other_mth other_yr {
label var `x' "How much did hhld spend on"
}



**********************
**  EXPOSED CASES   **
**********************

label var injury "Nature of injury of exposed"
** Need to code this into serious and not serious

** Correcting data entry error
replace serious_exp = 1 if serious_exp == 10
label var serious_exp "How serious was injury"
label val serious_exp serious

*** There is a data entry error here, needs correction (serno 3714)
* replace fac_exp = __ if fac_exp == 0
label var fac_exp "Facility used for treatment of injury"
label val fac_exp fac1

*** There is a data entry error here, needs correction (serno 7311, 6016, 8216, 8316 and 8516, 5514 and 5714)
* replace rsnotrt_exp = __ if rsnotrt_exp == 0
* replace rsnotrt_exp = __ if rsnotrt_exp == 10
label var rsnotrt_exp "reason for no treat"
label val rsnotrt_exp rsnotrt

label var daysaffind_exp "Days affected-accdtinjury-Ind"
label var daysafffam_exp "Days affected-accdtinjury-Fam"

label var hospfee_exp "Hospital Fees-accdtinjury"
label var consfee_exp "Consultation Fees-accdtinjury"
label var surg_exp "SurgCharges-accdtinjury"

destring invst_exp, replace
label var invst_exp "InvestCharges-accdtinjury"
label var med_exp "MedicineCost-accdtinjury"
label var tothosp_exp "Total Hospital-accdtinjury"
* potential data entry error in one observation for total hosp costs serno 9912

label var travpat_exp "TravelCosts patient-accdtinjury"
label var travesc_exp "TravelCosts escort-accdtinjury"

label var lstwgpat_exp "lostwages patient-accdtinjury"
label var lstwgesc_exp "lostwages escort-accdtinjury"

label var speed_exp "Speedmoney-accdtinjury"
label var other_exp "Otherexps-accdtinjury"

label var totadd_exp "Total Additional Expenses"

label var payown_exp "paid own money -accdtinjury"
label val payown_exp yn

label var borremp_exp "Borrwd from employer-accdtinjury"
label val borremp_exp yn

label var empint_exp "Monthly IntRate employer-accdtinjury"

label var borrml_exp "Borrwd frm MoneyLender-accdtinjury"
label val borrml_exp yn

label var intml_exp "Monthly IntRate MoneyLender-accdtinjury"

label var borrff_exp "Borrwd from friendsfamily-accdtinjury"
replace borrff_exp = "1" if borrff_exp == "1 (STREE SHAKTI)"
destring borrff_exp, replace
label val borrff_exp yn

label var intff_exp "Monthly IntRate friendsfamily-accdtinjury"

label var suppff_exp "Support from friendsfamily-accdtinjury"
replace suppff_exp = 2 if suppff_exp == 8
label val suppff_exp yn

label var sldjwlry_exp "Sold jwlry-accdtinjury"
label val sldjwlry_exp yn

label var sldprop_exp "Sold property-accdtinjury"
label val sldprop_exp yn

label var sldlfstk_exp "Sold livestock-accdtinjury"
label val sldlfstk_exp yn

label var insur_exp "Insurance-accdtinjury"
label val insur_exp yn

label var ksrtc_exp "KSRTCcompensation"
label val ksrtc_exp yn

label var nopay_exp "Didnot pay"
label val nopay_exp yn


*********************************
**      MINOR ILLNESSES        **
*********************************

* There were 16 MinIll cases with data entry error - entered as missing.
* 4 non-cases entered as 0 and several others entered as .
replace anymill = 1 if anymill == . & illness != ""
replace anymill = 2 if anymill == . & mem!= "a"
replace anymill = 2 if anymill == 0 & mem== "a"
label var anymill "Any episodes of Minor Illnesses"
label val anymill yn

* There is an error in this variable - there are 118 total episodes
* The sum of this variable gives 89+16+6+8 = 119.
label var episodes_mill "Number of Minor Illness episodes"

label var illness "Minor Illness"
** Need to code this into serious and not serious

label var serious_mill "How serious was illness"
label val serious_mill serious

** This has an error - needs to be corrected - serno 7111, 7131 are coded 44
label var fac_mill "Facility used for treatment of illness"
label val fac_mill fac1

*** This needed correction - all got treatment (!!)
replace rsnotrt_mill = . if rsnotrt_mill == 0 | rsnotrt_mill == 8
label var rsnotrt_mill "Reason for No Treatment"
label val rsnotrt_mill rsnotrt

label var daysaffind_mill "Days affected-minill-Ind"
label var daysafffam_mill "Days affected-minill-Fam"

label var hospfee_mill "Hospital Fees-min.Illness"
label var consfee_mill "Consultation Fees-min.Illness"

label var invst_mill "InvestCharges-min.Illness"
label var med_mill "MedicineCost-min.Illness"


label var travpat_mill "TravelCosts patient-min.Illness"
label var travesc_mill "TravelCosts escort-min.Illness"

label var lstwgpat_mill "lostwages patient-min.Illness"
label var lstwgesc_mill "lostwages escort-min.Illness"

label var speed_mill "Speedmoney-min.Illness"
label var other_mill "Otherexps-min.Illness"

* This one needs some SERIOUS EDITING - there are ppl claiming more in lost wages than their total wages
rename totadd_mill total_mill
label var total_mill "Total Expenses on Min Illness"

label var payown_mill "paid own money-min.Illness"
label val payown_mill yn

label var borremp_mill "Borrwd from employer-min.Illness"
label val borremp_mill yn

label var empint_mill "Monthly IntRate employer-min.Illness"

label var borrml_mill "Borrwd frm MoneyLender-min.Illness"
label val borrml_mill yn

label var intml_mill "Monthly IntRate MoneyLender-min.Illness"

label var borrff_mill "Borrwd from friendsfamily-min.Illness"
label val borrff_mill yn

label var intff_mill "Monthly IntRate friendsfamily-min.Illness"

label var suppff_mill "Support from friendsfamily-min.Illness"
label val suppff_mill yn

label var sldjwlry_mill "Sold jwlry-min.Illness"
label val sldjwlry_mill yn

label var sldprop_mill "Sold property-min.Illness"
label val sldprop_mill yn

label var sldlfstk_mill "Sold livestock-min.Illness"
label val sldlfstk_mill yn

label var insur_mill "Insurance-min.Illness"
label val insur_mill yn

label var nopay_mill "Didnot pay"
label val nopay_mill yn

label var notapp_mill "NA-Minill"

**********************
** HOSPITALIZATION  **
**********************

* Couple of anyhosps labeled as 0 - could be changed to 2 (no) or missing.
replace anyhosp = 2 if anyhosp == 0 &  episodes_hosp ==.
label var anyhosp "Any episodes of Hospitalization"
label val anyhosp yn

label var episodes_hosp "Number of Hospitalization episodes"

replace hospill = "45 & 46" if hospill =="457 46"
label var hospill "Illness for Hospitalization"

label var serious_hosp "How serious was hospillness"
label val serious_hosp serious

* There is a data entry error here - ser no 7011 is entered as "12", which is not a valid code
label var fac_hosp "Facility used for treatment of hospillness"
label val fac_hosp fac2

* There is a data entry error - tentatively changing it - needs to be verified.
replace daysaffind_hosp = "10" if daysaffind_hosp == "10  2"
destring daysaffind_hosp, replace
label var daysaffind_hosp "Days affected-hosptn-Ind"

label var daysafffam_hosp "Days affected-hosptn-Fam"

label var hospfee_hosp "Hospital Fees-hosptn"
label var consfee_hosp "Consultation Fees-hosptn"
label var surg_hosp "SurgeryFees-hosptn"

label var invst_hosp "InvestCharges-hosptn"
label var med_hosp "MedicineCost-hosptn"

label var tothosp_hosp "Total HOSP Expenses on Hospitalization"

label var travpat_hosp "TravelCosts patient-hosptn"
* Potential error on serno 6815, this is a huge outlier in travpat_hosp
label var travesc_hosp "TravelCosts escort-hosptn"

label var lstwgpat_hosp "lostwages patient-hosptn"
label var lstwgesc_hosp "lostwages escort-hosptn"

label var speed_hosp "Speedmoney-hosptn"
label var other_hosp "Otherexps-hosptn"

label var totadd_hosp "Total Additional Expenses on Hospitalization"

** Ser numbers 8616 and 4754 do not have any information on paying for treatment - needs to be verified.
** Several of the 2:NO were entered as 8 or even 5 (!!)
label var payown_hosp "paid own money-hosptn"
label val payown_hosp yn

replace borremp_hosp = 2 if borremp_hosp == 8
label var borremp_hosp "Borrwd from employer-hosptn"
label val borremp_hosp yn

label var empint_hosp "Monthly IntRate employer-hosptn"

replace borrml_hosp = 2 if borrml_hosp == 8
label var borrml_hosp "Borrwd frm MoneyLender-hosptn"
label val borrml_hosp yn

label var intml_hosp "Monthly IntRate MoneyLender-hosptn"

replace borrff_hosp = 2 if borrff_hosp == 5 |borrff_hosp == 8
label var borrff_hosp "Borrwd from friendsfamily-hosptn"
label val borrff_hosp yn

label var intff_hosp "Monthly IntRate friendsfamily-hosptn"

label var suppff_hosp "Support from friendsfamily-hosptn"
label val suppff_hosp yn

label var sldjwlry_hosp "Sold jwlry-hosptn"
label val sldjwlry_hosp yn

label var sldprop_hosp "Sold property-hosptn"
label val sldprop_hosp yn

label var sldlfstk_hosp "Sold livestock-hosptn"
label val sldlfstk_hosp yn

label var insur_hosp "Insurance-hosptn"
label val insur_hosp yn

label var nopay_hosp "Didnot pay"
label val nopay_hosp yn


**********************************
**** CHRONIC CONDITIONS
*********************************

label var anychrn "Any episodes of Chr Illness"
label val anychrn yn

label var episodes_chr "Number of Chron Illness Episodes"

label var diab "Member has diabetes"
label var htdis "Member has Heart Disease"
label var  hibp "Member has High BP"
label var  hichol "Member has HighCholesterol"
label var  tb "Member has TB"
label var  chrasth "Member has Chron Asthma"
label var  arthrts "Member has Arthritis"
label var  cataract "Member has Cataract"
label var  other_chr "Member has Other Chr Illness"
* Need to recode other_chr

label var  trtchr "Member takes treatment for illness"
label var  chrcost "Average monthly cost of treatment"
label var  rsnotrt_chr "reason for no treatment"
* Need to recode rsnotrt_chr


label var group "Number of groups that household is member of"
label var samerel_1 "Are members of group 1 of same religion?"
label val samerel_1 yn

label var samecas_1 "Are members of group 1 of same caste?"
label val samecas_1 yn

label var samegen_1 "Are members of group 1 of same gender?"
label val samegen_1 yn

label var samelan_1 "Are members of group 1 of same language?"
label val samelan_1 

label var samerel_2 "Are members of group 2 of same religion?"
label val samerel_2 yn

label var samecas_2 "Are members of group 2 of same caste?"
label val samecas_2 yn

label var samegen_2 "Are members of group 2 of same gender?"
label val samegen_2 yn

label var samelan_2 "Are members of group 2 of same language?"
label val samelan_2 yn

label var sameocc_1 "Do members of group 1 have same occupation?"
label val sameocc_1 yn
 
label var sameedu_1 "Do members of group 1 have same education?" 
label val sameedu_1 yn

label var sameocc_2 "Do members of group 2 have same occupation?"
label val sameocc_2 yn

label var sameedu_2 "Do members of group 2 have same education?" 
label val sameedu_2 yn

rename intractwithin_1 interactwithin_1
label var interactwithin_1 "Group 1 members interact within vill/nbrhood"
label val interactwithin_1 frequent

label var interactout_1 "Group 1 members interact outside vill/nbrhood"
label val interactout_1 frequent

label var interactwithin_2 "Group 2 members interact within vill/nbrhood"
label val interactwithin_2 frequent

label var interactout_2 "Group 2 members interact outside vill/nbrhood"
label val interactout_2 frequent

label var canbrw "Can borrow small amount of $"
label val canbrw definite

label var cantrust "Most ppl can be trusted"
label var willhelp "Most ppl in voll/nbrhd willing to help"
label val willhelp agree

label var alert "One has to be alert"
label val alert agree

label var trustpri "Trust Panchayati Raj Off"
label val trustpri extent

label var trustloc "Trust Local Off"
label val trustloc extent

label var trustcen "Trust Central Off"
label val trustcen extent

label var contrtime "Contr time to Comm Proj"
label var contrmon "Contr money to Comm Proj"
label var partcomm "Participate in Comm Activity
label val partcomm yn

label var commactivity "Type of Community Activity"
label var timesact "Times partcpted in comm activ"
label var cooperate "People will cooperate to solve comm problem"
label val cooperate likely


****************
** DISABILITY **
****************

label var anydisab "Any Disability"
label var disability "What Disability"
label var selfrh "Self Rated overall health in 30 days"
label val selfrh good

label var diffstand "Difficulty in Standing"
label val diffstand mildmodsev

label var diffresp "Difficulty in taking care of hhld respon"
label val diffresp mildmodsev

label var difflearn "Difficulty in learning new tasks"
label val difflearn mildmodsev

label var diffcomm "Difficulty in joining community activities"
label val diffcomm mildmodsev

label var diffconc "Difficulty in concentrating on task for 10 mins"
label val diffconc mildmodsev

label var diffwalk "Difficulty in walking 1km"
label val diffwalk mildmodsev

label var diffwash "Difficulty in washing whole body"
label val diffwash mildmodsev

label var diffdress "Difficulty in getting dressed"
label val diffdress mildmodsev

label var diffdeal "Difficulty in dealing with ppl u dont know"
label val diffdeal mildmodsev

label var diffriend "Difficulty in maintaining a friendship"
label val diffriend mildmodsev

label var diffwork "Difficulty in day to day work"
label val diffwork mildmodsev

label var emoteff "Emotionally affected by health problems"
label val emoteff mildmodsev

label var interfere "Difficulties interfere in life?"
label val interfere mildmodsev

label var dayswdiff "No. of days with difficulty"
label var daysunable "No. Days totally unable to usual activities/work"
label var dayscutback "No. days cut back usual activities/work"

*******************
** MENTAL HEALTH **
*******************
replace d1_ = d1_-1
label var d1_tired "Past 4 weeks, Tired for no good reason"
label val d1_tired often

replace d2_ = d2_-1
label var d2_nervous "Past 4 weeks, nervous"
label val d2_nervous often

replace d3_ = d3_-1
label var d3_nocalm "Past 4 weeks, so nervous you could not calm down"
label val d3_nocalm often

replace d4_ = d4_-1
label var d4_hopeless "Past 4 weeks, hopeless"
label val d4_hopeless often

replace d5_ = d5_-1
label var d5_restless "Past 4 weeks, restless or fidgety"
label val d5_restless often

replace d6_ = d6_-1
label var d6_nosleep "Past 4 weeks, so restless you could not sit still or sleep"
label val d6_nosleep often

replace d7_ = d7_-1
label var d7_depressed "Past 4 weeks, depressed"
label val d7_depressed often

replace d8_ = d8_-1
label var d8_effort "Past 4 weeks, that every thing was an effort"
label val d8_effort often

replace d9_ = d9_-1
label var d9_sad "Past 4 weeks, so sad that nothing could cheer you up"
label val d9_sad often

replace d10_ = d10_-1
label var d10_worthless "Past 4 weeks, worthless"
label val d10_worthless often


*****************
** RELIGIOSITY **
*****************
label var relig_1 "I try to see how God might be trying to strengthen me in this situation"
label val relig_1 spirituality
label var relig_2 "I seek God’s love and care"
label val relig_2 spirituality
label var relig_3 "I stick to the teachings and practices of my religion (e.g., doing my duty)"
label val relig_3 spirituality
label var relig_4 "I try to put my plans into action together with God"
label val relig_4 spirituality
label var relig_5 "I do what I can and put the rest in God’s hands"
label val relig_5 spirituality
label var relig_6 "I look for a stronger connection with a higher power"
label val relig_6 spirituality
label var relig_7 "I pray to discover my purpose in living"
label val relig_7 spirituality
label var relig_8 "I offer spiritual support to family/friends"
label val relig_8 spirituality
label var relig_9 "I believe that I am being punished for bad actions that I or my ancestors did in the past"
label val relig_9 spirituality
label var relig_10 "I express anger that God didn’t answer my prayers"
label val relig_10 spirituality

label var relig_11 "I feel punished by God for my lack of devotion"
replace relig_11 = "." if relig_11 == ""
destring relig_11, replace
label val relig_11 spirituality

label var relig_12 "I look for love and concern from friends in the church/temple/mosque"
label val relig_12 spirituality
label var relig_13 "I ask for forgiveness for my sins"
label val relig_13 spirituality
label var relig_14 "I pray and perform religious rituals to get my mind off my problems"
label val relig_14 spirituality
label var relig_15 "I plead with God to make things turn out okay"
label val relig_15 spirituality

********************************************************
********************************************************
*********************************************************
*
*		RECODES AND CHANGES TO VARIABLES 
*
*********************************************************
********************************************************
********************************************************


set more off

*There were 4 unexposed recorded as missing
* Replacing the exp for the unexposed(substr!=1) first observation in the household (mem=a)
tab exp, miss
list serno if substr(s_serno,4,1) != "1" & mem == "a" & exp == .
replace exp = 2 if exp == . &  substr(s_serno,4,1) != "1" & mem == "a" & exp == .

* No. of times travelled is only for unexposed.
replace times = . if exp == 1

*** Generating ID variables for cluster 
***************************************
gen id = substr(s_ser,1,3)

gen invest = substr(s_ser,5,5)
destring invest, replace
label var invest "investigator"

***************************************
** Going through each variable and 
** EDITING FOR LOGICAL INCONSISTENCIES AND ERRORS
** Also includes errors verified from CFPD emails
** The order of variables is same as in the 
** d command
**************************************

replace noinacc = 8 if noinacc == 25
replace noinacc = . if noinacc == 8

replace relan_1 =. if relan_1 == 1 & exp ==.
replace educ_1 = 1 if educ_1 ==0

replace startwork_1 = . if relan_1 == . &  startwork_1!=.
replace reastart_1 = . if relan_1 == . &  reastart_1!=.
replace stopwk_1 = 2 if stopwk_1 == 8 & relan_1 != .
replace stopwk_1 = . if relan_1 == . &  stopwk_1 !=.
replace reastop_1 = . if relan_1 == . &  reastop_1!=.
replace startwork_2 = 2 if relan_2 != . &  startwork_2==8
replace stopwk_2 = 2 if relan_2 != . &  stopwk_2 == 8

replace landnc = 0 if landnc == . & landwt !=.
replace house_own = 2 if  house_own == . & exp == 2
replace house_own = 1 if house_own == 2 & house_val != 8
*The above one assumes that the houseval was entered more reliably

replace house_own = . if exp == .
replace land_own = 2 if land_own == . & exp == 1
replace land_own = 2 if land_own == . & exp == 2
replace land_own = . if land_own == 2 & exp == .
replace phone_own = 1 if phone_own == 2 & phone_val !=8
replace jwlry_pay = 8 if jwlry_pay == . & jwlry_purch == 2
replace slvr_val = 8 if slvr_val == 0 &  slvr_own == 2
replace brcprpots_val = 8 if brcprpots_val == . & brcprpots_own == 2

* Changing debt AND borrow from 1-2 to 0-1 variable.
replace debt = 0 if debt ==2
label val debt noyes

replace borrow = 0 if borrow ==2
label val borrow noyes

replace amtborr = 20000 if amtborr == 2000000
** Tentatively changed this to a reasonable no.. NEED TO CONFIRM

replace age_1 = 39 if serno == 2013
replace age_1 = 55 if serno == 1855 

replace age_4 = "0.3" if serno == 1416
destring age_4, replace

/******************************

replace incsec = 0 if incsec == . & exp != .

*******************************/

replace noofaccident = 2 if noofaccident == 0 & serno == 1015
replace fac_exp = 10 if fac_exp == 0
replace fac_exp = 10 if fac_exp == 8 & serno == 5714
replace rsnotrt_exp = 8 if rsnotrt_exp == 0
replace rsnotrt_exp = 8 if rsnotrt_exp == 10
replace tothosp_exp = 1500 if  tothosp_exp==1450 & serno == 9912
replace speed_exp = 0 if  speed_exp == 20 
replace totadd_exp = 7380 if  totadd_exp == 10480 & serno == 6511
replace fac_mill = 9 if fac_mill ==44

replace payown_mill = 2 if serno == 1456
replace borremp_mill = 2 if serno == 1456
replace empint_mill = 8 if serno == 1456
replace borrml_mill = 1 if serno == 1456
replace intml_mill = 2 if serno == 1456
replace borrff_mill = 1 if serno == 1456
replace intff_mill = 2 if serno == 1456
replace suppff_mill = 2 if serno == 1456
replace sldjwlry_mill = 2 if serno == 1456
replace sldprop_mill = 2 if serno == 1456
replace sldlfstk_mill = 2 if serno == 1456
replace insur_mill = 2 if serno == 1456
replace nopay_mill = 2 if serno == 1456

replace payown_mill = 2 if serno == 8346
replace borremp_mill = 2 if serno == 8346
replace empint_mill = 8 if serno == 8346
replace borrml_mill = 1 if serno == 8346
replace intml_mill = 2 if serno == 8346
replace borrff_mill = 1 if serno == 8346
replace intff_mill = 2 if serno == 8346
replace suppff_mill = 2 if serno == 8346
replace sldjwlry_mill = 2 if serno == 8346
replace sldprop_mill = 2 if serno == 8346
replace sldlfstk_mill = 2 if serno == 8346
replace insur_mill = 2 if serno == 8346
replace nopay_mill = 2 if serno == 8346

*household 1515 had 4 member records.
replace payown_mill = 1 if serno == 1515 & illness != ""
replace borremp_mill = 2 if serno == 1515 & illness != ""
replace empint_mill = 8 if serno == 1515 & illness != ""
replace borrml_mill = 2 if serno == 1515 & illness != ""
replace intml_mill = 8 if serno == 1515 & illness != ""
replace borrff_mill = 2 if serno == 1515 & illness != ""
replace intff_mill = 8 if serno == 1515 & illness != ""
replace suppff_mill = 2 if serno == 1515 & illness != ""
replace sldjwlry_mill = 2 if serno == 1515 & illness != ""
replace sldprop_mill = 2 if serno == 1515 & illness != ""
replace sldlfstk_mill = 2 if serno == 1515 & illness != ""
replace insur_mill = 2 if serno == 1515 & illness != ""
replace nopay_mill = 2 if serno == 1515 & illness != ""

replace fac_hosp = 6 if fac_hosp == 12
replace  travpat_hosp = 750 if serno == 6815 &  travpat_hosp == 7850

replace payown_hosp = 1 if serno == 8616
replace borremp_hosp = 2 if serno == 8616
replace empint_hosp = 8 if serno == 8616
replace borrml_hosp = 2 if serno == 8616
replace intml_hosp = 8 if serno == 8616
replace borrff_hosp = 2 if serno == 8616
replace intff_hosp = 8 if serno == 8616
replace suppff_hosp = 2 if serno == 8616
replace sldjwlry_hosp = 2 if serno == 8616
replace sldprop_hosp = 2 if serno == 8616
replace sldlfstk_hosp = 2 if serno == 8616
replace insur_hosp = 1 if serno == 8616
replace nopay_hosp = 2 if serno == 8616

replace payown_hosp = 2 if serno == 4754
replace borremp_hosp = 2 if serno == 4754
replace empint_hosp = 8 if serno == 4754
replace borrml_hosp = 2 if serno == 4754
replace intml_hosp = 8 if serno == 4754
replace borrff_hosp = 2 if serno == 4754
replace intff_hosp = 8 if serno == 4754
replace suppff_hosp = 2 if serno == 4754
replace sldjwlry_hosp = 1 if serno == 4754
replace sldprop_hosp = 2 if serno == 4754
replace sldlfstk_hosp = 2 if serno == 4754
replace insur_hosp = 2 if serno == 4754
replace nopay_hosp = 2 if serno == 4754


************************************
* NEW VARIABLES
**********************************

* Variable for Transitory Shock
gen trans = .
replace trans = 0 if exp == 2
replace trans = 1 if exp == 1
label var trans "Transitory Shock"
label define trans 1"1:Exposed" 0"0:Unexposed"
label val trans trans

************************************
** CHANGING TOTDEBT & AMTBORR 8s to 0s.
*************************************

count if totdebt == 8 & exp == 1
count if totdebt == 8 & exp == 2
count if amtborr == 8 & exp == 1
count if amtborr == 8 & exp == 2

replace totdebt = 0 if totdebt == 8
replace totdebt = 0 if totdebt == . & trans !=.

replace amtborr = 0 if amtborr == 8
replace amtborr = 0 if amtborr == . & trans !=.

gen age2 = age_1*age_1
gen age3 = age_1*age2

*************************
* SCHOOL AGED CHILDREM
********************
gen schkid1 = .
gen schkid2 = .
gen schkid3 = .
gen schkid4 = .
gen schkid5 = .
gen schkid6 = .
gen schkid7 = .
gen schkid8 = .
gen schkid9 = .

foreach num of numlist 1 2 3 4 5 6 7 8 9 {
replace schkid`num' = 0
replace schkid`num' = 1 if age_`num' > 4 & age_`num' < 23
replace schkid`num' = 0 if schkid`num' == .
}

gen schoolkids = schkid1 + schkid2 + schkid3 + schkid4 + schkid5 + schkid6 + schkid7 + schkid8 + schkid9
label var schoolkids "School Aged Children in Household"
drop schkid*




* Low Caste Variable
gen caste = .
replace caste = 1 if scst == 1
replace caste = 1 if scst == 2
replace caste = 0 if scst == 8
label var caste "low caste"
label val caste noyes

* Total land holding
gen totland = landwt+landdry + landnc
label var totland "Total Land"

* REASONS TO SELL/PLEDGE IS MULTIPLE CHOICES - COMPLICATED.
* HEALTH REASON TO SELL
gen rssell_h = .
label var rssell_h "health reason to sell/pledge"
replace rssell_h = 1 if substr(rssell,1,1) == "F"
replace rssell_h = 1 if substr(rssell,2,1) == "F"
replace rssell_h = 1 if substr(rssell,3,1) == "F"
replace rssell_h = 3 if rssell == "Z"
replace rssell_h = 2 if rssell_h == .
label define rssell_h 1"1:health reason to sell" 2"2:non-health reason to sell" 3"3:didnot sell"
label val rssell_h rssell_h

* FESTIVAL REASON TO SELL
gen rssell_f = .
label var rssell_f "festival reason to sell/pledge"
replace rssell_f = 1 if substr(rssell,1,1) == "G"
replace rssell_f = 1 if substr(rssell,2,1) == "G"
replace rssell_f = 1 if substr(rssell,3,1) == "G"
replace rssell_f = 3 if rssell == "Z"
replace rssell_f = 2 if rssell_f == .
label define rssell_f 1"1:festival reason to sell" 2"2:other reasons to sell" 3"3:didnot sell"
label val rssell_f rssell_f

* TOTAL INCOME FROM BOTH PRI AND SEC INCOME
gen totinc = incmain + incsec
replace totinc = incmain if totinc == . & incmain != .
label var totinc "Total avg hhld income"

* GENERATING A NEW VARIABLE FOR CALCULATED MONTHLY EXPENDITURES
* Note that yearly expenditures are divided by 12

replace rent = 0 if rent ==. & trans != .
replace water = 0 if water == . & trans !=.
replace phone = 0 if phone ==. & trans !=.
replace cable = 0 if cable ==. & trans !=.
replace educ_yr = 0 if educ_yr ==. & trans !=.

gen spendcalc =  food + rent + fuel + water + elec + phone + cable + recrn + (educ_yr/12) + (hlth_yr/12) + (fest_yr/12) + other_mth + (other_yr/12)
label var spendcalc "Monthly Expenditures Calc"

gen spendnh =  food + rent + fuel + water + elec + phone + cable + recrn + (educ_yr/12) + (fest_yr/12) + other_mth + (other_yr/12)
label var spendnh "Monthly Exp Non-Health"

gen spendmth = food + rent + fuel + water + elec + phone + cable + recrn
label var spendmth "Monthly only"

gen spendhouse = rent + fuel + water + elec + phone + cable + other_mth
label var spendhouse "Housing"

gen spendrec = recrn
label var spendrec "recreation"

gen spendfest12 = fest_yr + other_yr
gen spendfest = (fest_yr/12) + (other_yr/12)
label var spendfest "festivals and weddings"

gen spendedu = educ_yr
gen spendhlth = hlth_yr
gen spendfood = food

* MODIFYING COMPENSATION VARIABLE
replace compensation = 0 if compensation == . & trans!=.
tab compensation trans

*CREATING NEW VAR for TOTAL EXPENDITURES ON ACCIDENT EPISODE
gen totexp_exp =  tothosp_exp + totadd_exp
label var totexp_exp "Total Expenses on Accident Injury"
replace totexp_exp = 0 if totexp_exp == . & trans == 0

gen temp = totexp_exp
replace temp = 0 if totexp_exp == .
gen tothealth = spendhlth + temp
drop temp

* CREATING RATIO OF TOTEXP TO INCOME
bysort serno: egen totexphh = sum(totexp_exp)
gen ratio = totexp_exp / totinc if totexphh ! = .

*CREATNG NEW VAR FOR EXPENDITURE LEVEL FOR ACCIDENT EPISODE
gen explevel = .
replace explevel = 1 if totexp_exp >100
replace explevel = 2 if totexp_exp >2500
replace explevel = 3 if totexp_exp >5000
replace explevel = 4 if totexp_exp >10000
replace explevel = 5 if totexp_exp >25000
replace explevel = 6 if totexp_exp >75000
replace explevel = 0 if totexp_exp == .
label var explevel "Exp on accdt episode"

*Generating new variable for whether any major asset was purchased in last year
gen purch = .
label var purch "was any asset purchased in last year"
replace purch = 1 if house_purch == 1| land_purch  == 1|phone_purch == 1|sewmch_purch == 1|fan_purch == 1|radio_purch == 1|tv_purch == 1|fridge_purch == 1|cycle_purch == 1|scter_purch == 1| car_purch == 1|bllkcrt_purch == 1|lvstk_purch == 1|trctr_purch == 1|wtrpmp_purch == 1|fmeqpt_purch == 1|jwlry_purch == 1|slvr_purch == 1|brcprpots_purch == 1|other_purch == 1
replace purch = 0 if purch == . & trans !=.
label val purch noyes

* New variable for any assets pledged
gen pledge = .
label var pledge "pledged ANY asset last year"
foreach x of varlist *_sell {
replace pledge = 1 if `x' == 2
replace pledge = 0 if pledge == . & trans != .
label val pledge noyes
}

*This var is to facilitate next step .. amtpled
gen pled2 = 0
foreach x of varlist *_sell {
replace pled2 = 1 + pled2 if `x' == 2
}

gen amtpled = .
label var amtpled "Amt pledged from asset_recv"
foreach x of varlist *_recv {
replace amtpled = `x' if (pled2 ==1 & `x' != 8 & `x' != 0)
}
replace amtpled = 2000 if serno == 8146
** The above correction is because they had pled2=2, but the value for the first asset (fmeqpt) was missing
** Have written to CFPD to check... might need to revise this one.

* New variable to include households who reported pledging, but not borrowing.
gen newborr = .
label var newborr "Borrow: including pledge"
replace newborr = 1 if borrow == 1 
replace newborr = 0 if borrow == 0 & trans !=.
replace newborr = 1 if borrow == 0 & pledge == 1
label val newborr noyes

* New var for amount borr based on newborr
gen amtborpled = amtborr
replace amtborpled = amtpled if borrow == 0 & pledge == 1
replace amtborpled = . if amtborpled == 8
label var amtborpled "Amount borrowed or pledged"

* Annualized interest rates
gen annint = .
label var annint "annualized interest rates"
replace annint = 0 if interest == 0
replace annint = 9.38 if interest == 0.75
replace annint = 11.62 if interest == 0.92
replace annint = 12.68 if interest == 1
replace annint = 26.82 if interest == 2 
replace annint = 42.58 if interest == 3
replace annint = 60.1 if interest == 4
replace annint = 79.59 if interest == 5
replace annint = 101.22 if interest == 6

* REASONS TO BORROW IS MULTIPLE CHOICES - COMPLICATED.
* HEALTH REASON TO BORROW; Not including maternity
gen whyborr_h = .
label var whyborr_h "health reason to borrow"
replace whyborr_h = 1 if substr(whyborr,1,1) == "F" 
replace whyborr_h = 1 if substr(whyborr,2,1) == "F" 
replace whyborr_h = 1 if substr(whyborr,3,1) == "F"
replace whyborr_h = 0 if whyborr_h == . & whyborr ! = "8" & whyborr ! = "" 
label define whyborr_h 1"1:health borr" 0"0:non-health borr"
label val whyborr_h whyborr_h


* FESTIVAL REASON TO BORROW
gen whyborr_f = .
label var whyborr_f "festival reason to borrow"
replace whyborr_f = 1 if substr(whyborr,1,1) == "G"
replace whyborr_f = 1 if substr(whyborr,2,1) == "G"
replace whyborr_f = 1 if substr(whyborr,3,1) == "G"
replace whyborr_f = 0 if whyborr_f == . & whyborr ! = "8" & whyborr ! = "" 
label define whyborr_f 1"1:fest borr" 0"0:non-fest borr"
label val whyborr_f whyborr_f

* INVESTMENT REASON TO BORROW
gen whyborr_i = .
label var whyborr_i "borrowed for asset/invest"
replace whyborr_i = 1 if substr(whyborr,1,1) == "B" | substr(whyborr,1,1) == "A"
replace whyborr_i = 1 if substr(whyborr,2,1) == "B" | substr(whyborr,2,1) == "A"
replace whyborr_i = 1 if substr(whyborr,3,1) == "B" | substr(whyborr,3,1) == "A"
replace whyborr_i = 0 if whyborr_i == . & whyborr ! = "8" & whyborr ! = "" 
label define whyborr_i 1"1:invest borr" 0"0:non-invest borr"
label val whyborr_i whyborr_i



*****************************
*** CREATING ASSET INDEX
*****************************

gen asset_h = 0
replace asset_h = 4 if house == 3
replace asset_h = 2 if house == 2
replace asset_h = 0 if house == 1
tab asset_h house

gen asset_o = 0
replace asset_o = 2 if own == 1
replace asset_o = 0 if own == 2
tab asset_o own

gen asset_w = 0
replace asset_w = 4 if drink == 1
replace asset_w = 2 if drink == 2
replace asset_w = 4 if drink == 3
replace asset_w = 2 if drink == 4
replace asset_w = 0 if drink == 5
replace asset_w = 0 if drink == 6
replace asset_w = 0 if drink == 7
replace asset_w = 0 if drink == 8
tab asset_w drink

gen asset_t = 0
replace asset_t = 4 if toil == 1
replace asset_t = 2 if toil == 2
replace asset_t = 2 if toil == 3
replace asset_t = 2 if toil == 4
replace asset_t = 2 if toil == 5
replace asset_t = 2 if toil == 6
replace asset_t = 0 if toil == 7
tab asset_t toil

gen asset_f = 0
replace asset_f = 2 if fueltype == 1
replace asset_f = 1 if fueltype == 2
replace asset_f = 2 if fueltype == 3
replace asset_f = 0 if fueltype == 4
tab asset_f fueltype

gen asset_l = 0
replace asset_l = 2 if light == 1
replace asset_l = 1 if light == 2
replace asset_l = 0 if light == 4
tab asset_l light

gen asset_aglan = 0
replace asset_aglan = 4 if land_own == 1

gen asset_car = 0
replace asset_car = 4 if car_own == 1

gen asset_sctr = 0
replace asset_sctr = 3 if scter_own == 1

gen asset_tv = 0
replace asset_tv = 3 if tv_own == 1

gen asset_frig = 0
replace asset_frig = 3 if fridge_own == 1

gen asset_radio = 0
replace asset_radio = 2 if radio_own == 1

gen asset_sew = 0
replace asset_sew = 2 if sewmch_own == 1

gen asset_cyc = 0
replace asset_cyc = 2 if cycle_own == 1

gen asset_fan = 0
replace asset_fan = 1 if fan_own ==1    

gen assetscore =  asset_h+ asset_o+ asset_w+ asset_t+ asset_f+ asset_l+ asset_aglan+ asset_car+ asset_sctr+ asset_tv+ asset_frig+ asset_radio+ asset_sew+ asset_cyc+ asset_fan
replace assetscore = . if assetscore == 0

gen assetindex = .
replace assetindex = 1 if assetscore < 9
replace assetindex = 2 if assetscore >= 9 & assetscore < 17
replace assetindex = 3 if assetscore >= 17 & assetscore < 24
replace assetindex = 4 if assetscore >= 23
label define assetindex 1"1:Poor" 2"2:LowerMiddle" 3"3:UpperMiddle" 4"4:Upper"
label val assetindex assetindex

* Setting reference group (richest)
char assetindex[omit] 4


*************************
** CREATING OCCUPATION VARiable dummy
*************************

gen occup =.
replace occup = 1 if (occu_1 ==1|occu_1 ==2|occu_1 ==4|occu_1 ==8)
replace occup = 2 if (occu_1 ==3|occu_1 ==5|occu_1 ==12|occu_1 == 13|occu_1 == 14)
replace occup = 3 if (occu_1 ==6|occu_1 ==9|occu_1 ==11| occu_1 ==15| occu_1 ==16|occu_1 ==17|occu_1 ==18|occu_1 ==19)
replace occup = 4 if (occu_1 >=20)



******************************
** CREATING NUMBER OF MEMBERS
******************************

gen mem = 0
replace mem = 1 if relan_1 != .
replace mem = 2 if relan_2 != .
replace mem = 3 if relan_3 != .
replace mem = 4 if relan_4 != .
replace mem = 5 if relan_5 != .
replace mem = 6 if relan_6 != .
replace mem = 7 if relan_7 != .
replace mem = 8 if relan_8 != .
replace mem = 9 if relan_9 != .
label var mem "Number of members in household"


*************************
* ILLITERATE
**************************

** illit was created from educ_1 where illit was educ <=2 (illit & can read, but no school)
gen illit = 0
replace illit =1 if educ_1 <= 2
label var illit "Illiterate"
label val illit noyes

*********************************
**injury and severity variables**

gen headinj =.
replace headinj = 1 if  (serno ==7311 |serno == 9412 |serno ==  2113  |serno == 9512  |serno == 715  |serno == 2313  |serno == 2913  |serno == 6511  |serno == 2713  |serno == 9612  |serno == 8116  |serno == 6016  |serno == 7611  |serno == 8216  |serno == 9112  |serno == 3216  |serno == 8416  |serno == 8516  |serno == 916  |serno == 1715  |serno == 38616  |serno == 9912  |serno == 8316  |serno == 7111  |serno == 3814  |serno == 1515  |serno == 10012  |serno == 6611  |serno == 5816  |serno == 415) & trans ==1
replace headinj = 0 if headinj ==. & trans == 1
replace headinj = 0 if trans == 0
label var headinj "head injury"
label val headinj noyes

*******************************
***HOSPITALIZATION, MINOR ILLNESS & CHRONIC
******************************

replace anyhosp = 2 if anyhosp ==. & exp ==1
replace anyhosp = 2 if anyhosp ==. & exp ==2

replace anymill = 2 if anyhosp ==. & exp ==1
replace anymill = 2 if anyhosp ==. & exp ==2

replace anychrn = 2 if anyhosp ==. & exp ==1
replace anychrn = 2 if anyhosp ==. & exp ==2



**************************
*** DISABILITY INDEX
*************************

gen disabscore =  diffstand+ diffresp+ difflearn+ diffcomm+ diffconc+ diffwalk+ diffwash+ diffdress+ diffdeal+ diffriend+ diffwork+ emoteff
**
* 0 for no diasb at all
* 1 if one or two minor, or one severe
* 2 for everthing else

gen das = .
replace das = 1 if disabscore == 12
replace das = 2 if disabscore == 13|disabscore == 14
replace das = 3 if disabscore > 14 & disabscore != .
label var das "Disability Index"
label define das 1"1:NoDisab" 2"2:OneSerious/TwoMinor" 3"3:SevereDisab"
label val das das
tab das, miss

gen phydisscore = diffstand + diffresp + diffwalk + diffwash + diffdress + diffwork
gen das_phy = .
replace das_phy = 1 if phydisscore == 6
replace das_phy = 2 if phydisscore == 7|phydisscore == 8
replace das_phy = 3 if phydisscore > 8 & phydisscore != .
label var das_phy "Physical Disability Index"
label define das_phy 1"1:NoPhyDisab" 2"2:OneSerPhyDis/TwoMinorPhyDis" 3"3:SeverePhyDisab"
label val das_phy das_phy
tab das_phy, miss

* farm/poultry; laborer; salaried; merchant; retd-hswfe-stud
gen newoccup = .
replace newoccup = 1 if occu_1 ==13 |occu_1 ==14 |occu_1 ==16
replace newoccup = 2 if occu_1 ==11 |occu_1 ==15 |occu_1 ==17 |occu_1 ==18 |occu_1 ==19|occu_1 ==20
replace newoccup = 3 if occu_1 == 1 |occu_1 == 2 |occu_1 == 3 |occu_1 == 6 |occu_1 ==9 |occu_1 ==12 
replace newoccup = 4 if occu_1 == 4 |occu_1 == 5 |occu_1 == 8
replace newoccup = 5 if occu_1 > 20

label define newocc 1"farm-poultry" 2"laborer" 3"salaried" 4"merchant" 5"Rtd-Hw-Std"
label val newoccup newocc

* noschool, pri-mid, high, puc, +
gen school = .
replace school = 1 if educ_1 < 3
replace school = 2 if educ_1 == 3 | educ_1 == 4
replace school = 3 if educ_1 == 5 
replace school = 4 if educ_1 == 6
replace school = 5 if educ_1 > 6  & educ_1 != .

label define school 1"noschool" 2"prim-mid" 3"middle" 4"highschool" 5"College+"
label val school school

gen edlevel =.
replace edlevel = 1 if educ_yr == 0
replace edlevel = 2 if educ_yr > 0 & educ_yr <=100
replace edlevel = 3 if educ_yr >100 & educ_yr <= 500
replace edlevel = 4 if educ_yr >500 & educ_yr <= 1000
replace edlevel = 5 if educ_yr >1000 & educ_yr <= 5000
replace edlevel = 6 if educ_yr >5000 & educ_yr <= 10000
replace edlevel = 7 if educ_yr >10000


**************
** LOG VARIABLES

gen lnspendnh = log(spendnh)
gen lnspendmth = log(spendmth)
gen lnspendcalc = log(spendcal)
gen lntotinc = log(totinc)
gen lnhouse = log(spendhouse)
gen lnfood = log(spendfood)
gen lnhlth = log(spendhlth)
gen lnhlth1 = log(spendhlth+1)
gen lntoth = log(tothealth)
gen lntoth1 = log(tothealth+1)
gen lnrec = log(spendrec)
gen lneduc1 = log(spendedu +1)
gen lneduc = log(educ_yr)
gen lnfest = log(spendfest)

*Adding 1 for log total expenses*
gen texp = totexp_exp
replace texp = 0 if texp == . & trans != .
replace texp = texp + 1 if trans ! = .
bysort trans: sum texp
gen lntotexp = log(texp)

* Adding 1 for amount borrowed
gen ab1 = amtborr
replace ab1 = 0 if ab1==. & trans !=.
replace ab1 = amtborr + 1  if trans !=.
gen lnamtbor1 = log(ab1)

* Adding 1 for totdebt
gen td1 = totdebt
replace td1 = 0 if td1==. & trans !=.
replace td1 = totdebt + 1  if trans !=.
gen lntotdeb1 = log(td1)

gen pclnspnh = lnspendnh/mem
gen pclnspmt = lnspendmth/mem
gen pclnfood = lnfood/mem



gen farmer = .
replace farmer = 1 if occu_1 == 13 & trans ==1
replace farmer = 1 if occu_1 == 13 & trans ==0
replace farmer = 0 if occu_1 != 13 & trans ==1
replace farmer = 0 if occu_1 != 13 & trans ==0

gen agriwork = .
replace agriwork = 1 if occu_1 == 15 & trans == 1
replace agriwork = 1 if occu_1 == 15 & trans == 0
replace agriwork = 0 if occu_1 != 15 & trans == 1
replace agriwork = 0 if occu_1 != 15 & trans == 0

gen fkid1 = .
gen fkid2 = .
gen fkid3 = .
gen fkid4 = .
gen fkid5 = .
gen fkid6 = .
gen fkid7 = .
gen fkid8 = .
gen fkid9 = .

foreach num of numlist 1 2 3 4 5 6 7 8 9 {
replace fkid`num' = 0 
replace fkid`num' = 1 if sex_`num' == 2 & age_`num' > 4 & age_`num' < 23
replace fkid`num' = 0 if sex_`num' == .
}

gen fkid = fkid1 + fkid2 + fkid3 + fkid4 + fkid5 + fkid6 + fkid7 + fkid8 + fkid9
gen femkidpct = fkid/schoolkids
drop fkid*
label var femkidpct "Pct F schoolkids"


gen nztoth = 1 if totheal > 0 & trans != .
replace nztoth = 0 if totheal == 0 & trans != .
label var nztoth "Non Zero Health Exp"

gen nzed = 1 if educ_yr > 0 & trans !=.
replace nzed = 0 if educ_yr == 0 & trans != .
label var nzed "Nonzero Educ Exp"

gen assetpurch = 0
foreach x of varlist *_purch {
replace assetpurch = 1 if `x' == 1
}
label val assetpurch noyes
gen assetsell = 0
foreach x of varlist *_sell {
replace assetsell = 1 if `x' == 1
}
label val assetsell noyes
gen assetpled = 0
foreach x of varlist *_sell {
replace assetpled = 1 if `x' == 2
}
label val assetpled noyes

gen acc = "dd-mon-yy" if exp!=.
replace acc = "10-Aug-05"  if id == "004"  & exp != .
replace acc = "1-Nov-05"  if id == "007"  & exp != .
replace acc = "8-Oct-05"  if id == "010"  & exp != .
replace acc = "15-Aug-05"  if id == "013"  & exp != .
replace acc = "15-Aug-05"  if id == "014"  & exp != .
replace acc = "15-Aug-05"  if id == "015"  & exp != .
replace acc = "27-Aug-05"  if id == "017"  & exp != .
replace acc = "10-Jul-05"  if id == "018"  & exp != .
replace acc = "8-Jul-05"  if id == "019"  & exp != .
replace acc = "9-Sep-05"  if id == "020"  & exp != .
replace acc = "13-Jul-05"  if id == "021"  & exp != .
replace acc = "29-Oct-05"  if id == "022"  & exp != .
replace acc = "23-Dec-05"  if id == "023"  & exp != .
replace acc = "13-Jul-05"  if id == "024"  & exp != .
replace acc = "13-Jul-05"  if id == "025"  & exp != .
replace acc = "13-Jul-05"  if id == "026"  & exp != .
replace acc = "29-Oct-05"  if id == "027"  & exp != .
replace acc = "23-Dec-05"  if id == "028"  & exp != .
replace acc = "23-Dec-05"  if id == "029"  & exp != .
replace acc = "2-Jul-05"  if id == "032"  & exp != .
replace acc = "5-Oct-05"  if id == "033"  & exp != .
replace acc = "5-Oct-05"  if id == "034"  & exp != .
replace acc = "5-Oct-05"  if id == "035"  & exp != .
replace acc = "5-Oct-05"  if id == "036"  & exp != .
replace acc = "5-Oct-05"  if id == "037"  & exp != .
replace acc = "5-Oct-05"  if id == "038"  & exp != .
replace acc = "5-Oct-05"  if id == "039"  & exp != .
replace acc = "5-Oct-05"  if id == "040"  & exp != .
replace acc = "5-Oct-05"  if id == "041"  & exp != .
replace acc = "5-Oct-05"  if id == "042"  & exp != .
replace acc = "5-Oct-05"  if id == "043"  & exp != .
replace acc = "5-Oct-05"  if id == "044"  & exp != .
replace acc = "5-Oct-05"  if id == "045"  & exp != .
replace acc = "5-Oct-05"  if id == "046"  & exp != .
replace acc = "5-Oct-05"  if id == "047"  & exp != .
replace acc = "5-Oct-05"  if id == "048"  & exp != .
replace acc = "5-Oct-05"  if id == "049"  & exp != .
replace acc = "5-Oct-05"  if id == "050"  & exp != .
replace acc = "5-Oct-05"  if id == "051"  & exp != .
replace acc = "5-Oct-05"  if id == "052"  & exp != .
replace acc = "5-Oct-05"  if id == "053"  & exp != .
replace acc = "5-Oct-05"  if id == "054"  & exp != .
replace acc = "16-Dec-05"  if id == "055"  & exp != .
replace acc = "16-Dec-05"  if id == "056"  & exp != .
replace acc = "16-Dec-05"  if id == "057"  & exp != .
replace acc = "2-Jul-05"  if id == "058"  & exp != .
replace acc = "2-Jul-05"  if id == "060"  & exp != .
replace acc = "1-Jul-05"  if id == "061"  & exp != .
replace acc = "1-Jul-05"  if id == "064"  & exp != .
replace acc = "1-Jul-05"  if id == "065"  & exp != .
replace acc = "1-Jul-05"  if id == "066"  & exp != .
replace acc = "8-Oct-05"  if id == "067"  & exp != .
replace acc = "8-Jul-05"  if id == "068"  & exp != .
replace acc = "1-Jul-05"  if id == "069"  & exp != .
replace acc = "1-Jul-05"  if id == "070"  & exp != .
replace acc = "1-Jul-05"  if id == "071"  & exp != .
replace acc = "21-Oct-05"  if id == "072"  & exp != .
replace acc = "25-Nov-05"  if id == "073"  & exp != .
replace acc = "1-Jul-05"  if id == "074"  & exp != .
replace acc = "21-Oct-05"  if id == "076"  & exp != .
replace acc = "21-Oct-05"  if id == "077"  & exp != .
replace acc = "7-Jul-05"  if id == "079"  & exp != .
replace acc = "21-Oct-05"  if id == "081"  & exp != .
replace acc = "8-Oct-05"  if id == "082"  & exp != .
replace acc = "17-Dec-05"  if id == "083"  & exp != .
replace acc = "17-Dec-05"  if id == "084"  & exp != .
replace acc = "17-Dec-05"  if id == "085"  & exp != .
replace acc = "17-Dec-05"  if id == "086"  & exp != .
replace acc = "18-Jul-05"  if id == "087"  & exp != .
replace acc = "8-Jul-05"  if id == "088"  & exp != .
replace acc = "8-Oct-05"  if id == "089"  & exp != .
replace acc = "27-Nov-05"  if id == "090"  & exp != .
replace acc = "30-Sep-05"  if id == "091"  & exp != .
replace acc = "30-Sep-05"  if id == "092"  & exp != .
replace acc = "21-Oct-05"  if id == "093"  & exp != .
replace acc = "21-Oct-05"  if id == "094"  & exp != .
replace acc = "10-Aug-05"  if id == "095"  & exp != .
replace acc = "10-Jul-05"  if id == "096"  & exp != .
replace acc = "28-Oct-05"  if id == "097"  & exp != .
replace acc = "28-Oct-05"  if id == "098"  & exp != .
replace acc = "28-Oct-05"  if id == "099"  & exp != .
replace acc = "28-Oct-05"  if id == "100"  & exp != .

gen hindu = .
replace hindu = 1 if relig == 1
replace hindu = 0 if relig == 2
replace hindu = 0 if relig == 3

save echos-analysis-RESTAT.dta, replace

