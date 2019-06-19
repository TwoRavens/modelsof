
********************************************************************************************************************************************************************
**************** Constructing Dataset From Original Fixed-length Data ****************************** 
********************************************************************************************************************************************************************
***** Working Directory: "/Volumes/LACIE/JFIES_ORG_2013" 
***** Data Directory: "`Working Directory'/ORG_JFIES_Purpose" & "`Working Directory'/ORG_JFIES_Goods" 
***** Dictionaries: "`Working Directory'/Dictionary"
***** Constructed Data are save in "`Working Directory'/VAT_Japan" 
				
cd "/Volumes/LACIE/JFIES_ORG_2013"
clear
set more off

********************************************************************************************************************************************************************
********************************************************************************************************************************************************************
***** Constructing Baseline Dataset
********************************************************************************************************************************************************************
********************************************************************************************************************************************************************
gen temp=1
compress
saveold "./VAT_Japan/JFIES_Purpose_VAT.dta", replace
clear

forvalues YYYY=1992/2002 {
	local YY=`YYYY'-1900-(100*(`YYYY'>=2000))
	forvalues MM=1/12{
		clear
		if `YYYY'>=1990&`YYYY'<=1992{
			qui: infile using "./Dictionary/JFIES_Purpose_1990-1992.dct", using(./ORG_JFIES_Purpose/W2_`YYYY'_RCD_Y-`YY'MM_A.txt)
			drop if month!=`MM'
		}
		if `MM'<10 {
			local YYMM="`YY'0`MM'"
		}
		if `MM'>=10  {
			local YYMM="`YY'`MM'"
		}
		if (`YYYY'==1993) {
			qui: infile using "./Dictionary/JFIES_Purpose_1993.dct", using(./ORG_JFIES_Purpose/W2_`YYYY'_RCD_Y-`YYMM'_A.txt)
		}
		if `YYYY'==1994 {
			qui: infile using "./Dictionary/JFIES_Purpose_1994.dct", using(./ORG_JFIES_Purpose/W2_`YYYY'_RCD_Y-`YYMM'_A.txt)
		}
		if (`YYYY'>=1995&`YYYY'<=1998)|(`YYYY'==1999&`MM'<=6) {
			qui: infile using "./Dictionary/JFIES_Purpose_1995-1999_Jun.dct", using(./ORG_JFIES_Purpose/W2_`YYYY'_RCD_Y-`YYMM'_A.txt)
		}
		if (`YYYY'==1999&`MM'>=7) {
			qui: infile using "./Dictionary/JFIES_Purpose_1999_Jul.dct", using(./ORG_JFIES_Purpose/W2_`YYYY'_RCD_Y-`YYMM'_A.txt)
		}
		if (`YYYY'>=2000&`YYYY'<=2001) {
			qui: infile using "./Dictionary/JFIES_Purpose_2000-2001.dct", using(./ORG_JFIES_Purpose/W2_`YYYY'_RCD_ZY-0`YYMM'_A.txt)
		}
		if (`YYYY'>=2002&`YYYY'<=2004){
			qui: infile using "./Dictionary/JFIES_Purpose_2002-2004.dct", using(./ORG_JFIES_Purpose/W2_`YYYY'_RCD_ZY-0`YYMM'_A.txt)
		}
		
		qui: compress

		**************************************************************
		cap drop number_member_18
		cap drop number_member_65
		gen number_member_18=age<18
		gen number_member_65=age>=65&age!=.
		gen wife_work=.
		gen number_member_15=age<15
		gen number_member_6=age<6
		gen number_member_3=age<3
		
		forvalues NM=2/18{
				replace number_member_15=number_member_15+1 if hm_`NM'_age<15
				replace number_member_6=number_member_6+1 if hm_`NM'_age<6
				replace number_member_3=number_member_3+1 if hm_`NM'_age<3
				replace wife_work= hm_`NM'_workornot if (hm_`NM'_relation==2|hm_`NM'_relation==3)
				replace number_member_18=number_member_18+1 if hm_`NM'_age<18
				replace number_member_65=number_member_65+1 if hm_`NM'_age>=65&hm_`NM'_age!=.
		}
		move number_member_3 number_worker
		move number_member_6 number_worker
		move number_member_18 number_worker
		move number_member_65 number_worker
		
		
		global id "year month city_code unit_code household_code serial_number inflation_factor"
		global hh_chara "house_ownership house_size yearly_income number_member number_worker household_type sex age job wife_work number_member_3 number_member_6  number_member_15 number_member_18 number_member_65"
		global income "total_income periodical_income temporary_income bonus wife_income other_member_income bussiness_income asset_income social_security others_income"
		global cons "income_tax other_tax social_security_premium other_non_cons_exp"
		keep $id $hh_chara $income $cons
		
		append using "./VAT_Japan/JFIES_Purpose_VAT.dta"
		cap: drop temp
		compress
		saveold "./VAT_Japan/JFIES_Purpose_VAT.dta", replace
	}
}

********************************************************************************************************************************************************************
********************************************************************************************************************************************************************
***** Constructing Dataset for More Detailed Expenditure Categories 
********************************************************************************************************************************************************************
********************************************************************************************************************************************************************
clear
gen temp=1
compress
saveold "./VAT_Japan/JFIES_Goods_VAT.dta", replace
forvalues YYYY=1992/2002 {
	local YY=`YYYY'-1900-(100*(`YYYY'>=2000))
	forvalues MM=1/12{
		clear
		if `MM'<10 {
			local YYMM="`YY'0`MM'"
		}
		if `MM'>=10  {
			local YYMM="`YY'`MM'"
		}
		if `YYYY'>=1990&`YYYY'<=1992 {
			qui: infile using "./Dictionary/JFIES_Goods_1990-1992.dct", using(./ORG_JFIES_Goods/W2_`YYYY'_RCD_H-`YYMM'_A.txt)
		}
		if `YYYY'>=1993&`YYYY'<=1994 {
			qui: infile using "./Dictionary/JFIES_Goods_1993-1994.dct", using(./ORG_JFIES_Goods/W2_`YYYY'_RCD_H-`YYMM'_A.txt)
		}
		if (`YYYY'>=1995&`YYYY'<=1998)|(`YYYY'==1999&`MM'<=6) {
			qui: infile using "./Dictionary/JFIES_Goods_1995-1999_Jun.dct", using(./ORG_JFIES_Goods/W2_`YYYY'_RCD_H-`YYMM'_A.txt)
		}
		if (`YYYY'==1999&`MM'>=7) {
			qui: infile using "./Dictionary/JFIES_Goods_1999_Jul.dct", using(./ORG_JFIES_Goods/W2_`YYYY'_RCD_H-`YYMM'_A.txt)
		}
		if (`YYYY'>=2000&`YYYY'<=2001) {
			qui: infile using "./Dictionary/JFIES_Goods_2000-2001.dct", using(./ORG_JFIES_Goods/W2_`YYYY'_RCD_ZH-0`YYMM'_A.txt)
		}
		if (`YYYY'>=2002&`YYYY'<=2004){
			qui: infile using "./Dictionary/JFIES_Goods_2002-2004.dct", using(./ORG_JFIES_Goods/W2_`YYYY'_RCD_ZH-0`YYMM'_A.txt)
		}
		
		qui: compress
	
		**********************************************
		qui: do "./VAT_Japan/Sub_VAT_Commodity_Def.do"
		**********************************************
		
		rename all_goods_x texp
		rename all_goods_f texp_f
		
		global id "year month city_code unit_code household_code serial_number"
		global david " household_appliances consumer_electronics furniture clothing_and_footwear automobiles domestic_goods rail_pass beverages personal_care_toiletries tobacco food_within seasonings ndns1 ndns2 ndns3a ndns3b ndns3c"
		keep $id texp durable storable ndns notax $david

		append using "./VAT_Japan/JFIES_Goods_VAT.dta"
		cap: drop temp
		compress
		saveold "./VAT_Japan/JFIES_Goods_VAT.dta", replace
	}
}

********************************************************************************************************************************************************************
********************************************************************************************************************************************************************
******* Making Dataset for Regressions 
********************************************************************************************************************************************************************
********************************************************************************************************************************************************************

clear

use "./VAT_Japan/JFIES_Purpose_VAT.dta", clear
gen period=(year-1960)*12+month-1

sort year month
merge year month using "./VAT_Japan/cpi_vat.dta", uniqus
drop _merge
drop if city_code==.

merge year month city_code unit_code household_code serial_number using "./VAT_Japan/JFIES_Goods_VAT.dta", sort
drop _merge

**********************************************
do "./VAT_Japan/Sub_Make_ID.do"
**********************************************

tsset id period


**********************************************************************************
*** Adjusting for Changing Category Coding  ****
**********************************************************************************
egen maxy=max(yearly_income*(n_interview==6)), by(id)
replace yearly_income=maxy
drop maxy
replace inflation_factor=inflation_factor*10 if year<=1992
gen nuclear=(household_type==1|household_type==2|household_type==91|household_type==92)
replace job=10 if job==0
replace house_own=1 if house_own<4&year==2002
replace house_own=house_own==1
compress

**********************************************************************************
*****  Define Variables  **********************************
**********************************************************************************
rename texp m_tot_exp
rename durable m_d_gs
rename storable m_snd_gs
rename ndns m_nd_gs
rename notax m_exempt_gs
gen m_tot_exp_all=m_tot_exp
replace m_tot_exp=m_tot_exp-m_exempt_gs

gen m_d_gs_def = m_d_gs/(10*cpi_d)
gen m_snd_gs_def = m_snd_gs/(10*cpi_snd) 
gen m_nd_gs_def = m_nd_gs/(10*cpi_nd)
gen m_exempt_gs_def = m_exempt_gs/(10*cpi)
gen m_tot_exp_def = m_tot_exp/(10*cpi)
gen m_tot_exp_all_def = m_tot_exp_all/(10*cpi)

replace yearly_income=10*yearly_income/cpi

global demo_var "number_member number_worker number_member_18 number_member_65"
global cons_var "m_tot_exp_def m_d_gs_def m_snd_gs_def m_nd_gs_def m_exempt_gs_def"
global monthd "d_month_1-d_month_9 d_month_11 d_month_12"

/*
**********************************************************************************
** Generate differenced expenditures, as well as log differenced expenditures
**********************************************************************************
*/

foreach var of global demo_var {
  gen d_`var' = D.`var'
}  
foreach var of global cons_var {
  gen d_`var' = D.`var'
  gen log_`var' = ln(`var')
  gen d_log_`var' = D.log_`var'
}  

/*
**********************************************************************************
** Generate month dummies and differenced month dummies
**********************************************************************************
*/
forvalues num=1/12 {
  gen month_`num' = (month == `num')
  gen d_month_`num' = D.month_`num'
  drop month_`num'
}

forvalues num=1/6 {
  gen interview_`num' = (n_interview == `num')
  gen d_interview_`num' = D.interview_`num'
}
cap drop interview_1 interview_2

forvalues num =1992/2002 {
  gen year_`num' = 0.01*(year == `num')
}

**********************************************************************************
**** Define Period Dummies ******************
**********************************************************************************

replace year_1996=0 if (month==10|month==11|month==12)

gen y1996_m10=0.01*(period==m(1996m10))
gen y1996_m11=0.01*(period==m(1996m11))
gen y1996_m12=0.01*(period==m(1996m12))
gen y1997_m1=0.01*(period==m(1997m1))
gen y1997_m2=0.01*(period==m(1997m2))
gen y1997_m3=0.01*(period==m(1997m3))
gen y1997_m4=0.01*(period==m(1997m4))
gen y1997_m5=0.01*(period==m(1997m5))
gen y1997_m6=0.01*(period==m(1997m6))
gen y1997_m7=0.01*(period==m(1997m7))
gen y1997_m8=0.01*(period==m(1997m8))
gen y1997_m9=0.01*(period==m(1997m9))
gen y1997_m10=0.01*(period==m(1997m10))
gen y1997_m11=0.01*(period==m(1997m11))
gen y1997_m12=0.01*(period==m(1997m12))

gen d_y1996_m10=D.y1996_m10
gen d_y1996_m11=D.y1996_m11
gen d_y1996_m12=D.y1996_m12
gen d_y1997_m1=D.y1997_m1
gen d_y1997_m2=D.y1997_m2
gen d_y1997_m3=D.y1997_m3
gen d_y1997_m4=D.y1997_m4
gen d_y1997_m5=D.y1997_m5
gen d_y1997_m6=D.y1997_m6
gen d_y1997_m7=D.y1997_m7
gen d_y1997_m8=D.y1997_m8
gen d_y1997_m9=D.y1997_m9
gen d_y1997_m10=D.y1997_m10
gen d_y1997_m11=D.y1997_m11
gen d_y1997_m12=D.y1997_m12

gen d_gs_def=m_d_gs_def>0
gen w_d_gs=m_d_gs/m_tot_exp
gen w_snd_gs=m_snd_gs/m_tot_exp
gen w_nd_gs=m_nd_gs/m_tot_exp


********************************************************************************************************************************
saveold "./VAT_Japan/JFIES_VAT.dta", replace
********************************************************************************************************************************
