* Infixing Dictionary of Occupational Titles 1991 data
clear matrix
clear
set mem 700m
cd Z:\Guy\hdrive\Clerks\DOT1991

* Infiling occupations descriptions shifted by 100 bytes in case in the main ones some words get cut off
infix str document_number 1-7 str244 shift_definition_text15 9-152 str244 shift_definition_text16 153-396 str244 shift_definition_text17 397-640 str244 shift_definition_text18 641-884 str244 shift_definition_text19 885-1128 str244 shift_definition_text20 1129-1372 str244 shift_definition_text21 1373-1616 using 06100-0012-Data.txt, clear
sort document_number
save dot1991, replace

infix str document_number 1-7 str244 shift_definition_text8 9-152 str244 shift_definition_text9 153-396 str244 shift_definition_text10 397-640 str244 shift_definition_text11 641-884 str244 shift_definition_text12 885-1128 str244 shift_definition_text13 1129-1372 str244 shift_definition_text14 1373-1616 using 06100-0011-Data.txt, clear
sort document_number
merge document_number using dot1991
drop _m
sort document_number
save dot1991, replace

infix str document_number 1-7 str shift_definition_text1 244-387 str244 shift_definition_text2 388-631 str244 shift_definition_text3 632-875 str244 shift_definition_text4 876-1119 str244 shift_definition_text5 1120-1363 str244 shift_definition_text6 1364-1607 str244 shift_definition_text7 1608-1851 using 06100-0013-Data.txt, clear
sort document_number
merge document_number using dot1991
drop if _m==2
drop _m
sort document_number
save dot1991, replace


* Infiling main DOT occupations descriptions and variables

infix str document_number 1-7 str244 definition_text15 9-252 str244 definition_text16 253-496 str244 definition_text17 497-740 str244 definition_text18 741-984 str244 definition_text19 985-1228 str244 definition_text20 1229-1472 str244 definition_text21 1473-1716 using 06100-0012-Data.txt, clear
sort document_number
merge document_number using dot1991
drop _m
sort document_number
save dot1991, replace

infix str document_number 1-7 str244 definition_text8 9-252 str244 definition_text9 253-496 str244 definition_text10 497-740 str244 definition_text11 741-984 str244 definition_text12 985-1228 str244 definition_text13 1229-1472 str244 definition_text14 1473-1716 using 06100-0011-Data.txt, clear
sort document_number
merge document_number using dot1991
drop _m
sort document_number
save dot1991, replace

infix str document_number 1-7 str dot_code 8-16 definition_type 17 date_of_update 18-19 str data 20-21 str people 22-23 str things 24-25 reasoning 26 math 27 language 28 spec_voc_prep 29 general_learning 30 verbal 31 numerical 32 spacial 33 form_perception 34 clerical_perception 35 motor_coordination 36 finger_dexterity 37 manual_dexterity 38 eye_hand_coordination 39 color_discrimination 40 work_field1 41-43 work_field2 44-46 work_field3 47-49 mpsms_field1 50-52 mpsms_field2 53-55 mpsms_field3 56-58 str temperaments 59-67 geo_code 68-73 soc_code 74-77 str dot_title 112-179 str designation1 180-195 str designation2 196-211 str designation3 212-227 str designation4 228-243 str244 definition_text1 244-487 str244 definition_text2 488-731 str244 definition_text3 732-975 str244 definition_text4 976-1219 str244 definition_text5 1220-1463 str244 definition_text6 1464-1707 str244 definition_text7 1708-1951 using 06100-0013-Data.txt, clear
sort document_number
merge document_number using dot1991
drop if _m==2
drop _m
sort document_number
save dot1991, replace
use dot1991, clear


set more 1
foreach verb of newlist Synthesize Coordinate Analyze Compile Compute Copy Compare Mentor Negotiate Instruct Supervise Divert Persuade Speak Serve Help Set Precision Operate Drive Manipulate Tend Feed Handle {
 gen `verb'=0
 local lower = strlower("`verb'")
 foreach num of numlist 1(1)21 {
  gen definition_text`num'`verb' = subinstr(definition_text`num',"`verb'","",1)
  gen definition_text`num'`verb'l = subinstr(definition_text`num',"`lower'","",1)
  replace `verb'=1 if definition_text`num'`verb'!=definition_text`num'
  replace `verb'=1 if definition_text`num'`verb'l!=definition_text`num'
  drop definition_text`num'`verb' definition_text`num'`verb'l
  gen s_definition_text`num'`verb' = subinstr(shift_definition_text`num',"`verb'","",1)
  gen s_definition_text`num'`verb'l = subinstr(shift_definition_text`num',"`lower'","",1)
  replace `verb'=1 if s_definition_text`num'`verb'!=shift_definition_text`num'
  replace `verb'=1 if s_definition_text`num'`verb'l!=shift_definition_text`num'
  drop s_definition_text`num'`verb' s_definition_text`num'`verb'l
 }
}

set more 1
foreach verb of newlist Typewriter Photocopy Filing Telephone {
 gen `verb'=0
 local lower = strlower("`verb'")
 foreach num of numlist 1(1)21 {
  gen definition_text`num'`verb' = subinstr(definition_text`num',"`verb'","",1)
  gen definition_text`num'`verb'l = subinstr(definition_text`num',"`lower'","",1)
  replace `verb'=1 if definition_text`num'`verb'!=definition_text`num'
  replace `verb'=1 if definition_text`num'`verb'l!=definition_text`num'
  drop definition_text`num'`verb' definition_text`num'`verb'l
  gen s_definition_text`num'`verb' = subinstr(shift_definition_text`num',"`verb'","",1)
  gen s_definition_text`num'`verb'l = subinstr(shift_definition_text`num',"`lower'","",1)
  replace `verb'=1 if s_definition_text`num'`verb'!=shift_definition_text`num'
  replace `verb'=1 if s_definition_text`num'`verb'l!=shift_definition_text`num'
  drop s_definition_text`num'`verb' s_definition_text`num'`verb'l
 }
}

save dot1991, replace



use dot1991, clear
gen occ2dig = substr( dot_code,1,2)
destring occ2dig, replace
gen str occ19501digit="Professional, Technical" if occ2dig>=0 & occ2dig<=17
replace occ19501digit="Managers, Officials, and Proprietors" if occ2dig==18
replace occ19501digit="Clerical and Kindred" if occ2dig>=20 & occ2dig<=24
replace occ19501digit="Sales workers" if occ2dig>=25 & occ2dig<=29
replace occ19501digit="Craftsmen, Operatives, and Laborers" if occ2dig>=50 & occ2dig<=93
replace occ19501digit="Service Workers" if (occ2dig>=30 & occ2dig<=38) | (occ2dig>=95 & occ2dig<=97)
replace occ19501digit="Farmers and Farm Laborers" if occ2dig>=40 & occ2dig<=46
drop if occ19501digit==""
collapse (count) obs=definition_type (sum) Synthesize-Telephone, by( occ19501digit)


foreach var of varlist Synthesize Coordinate Analyze Compile Compute Copy Compare Mentor Negotiate Instruct Supervise Divert Persuade Speak Serve Help Set Precision Operate Drive Manipulate Tend Feed Handle Typewriter Photocopy Filing Telephone  {
 replace `var'=`var'/ obs
}
foreach var of varlist Synthesize Coordinate Analyze Compile Compute Copy Compare Mentor Negotiate Instruct Supervise Divert Persuade Speak Serve Help Set Precision Operate Drive Manipulate Tend Feed Handle Typewriter Photocopy Filing Telephone  {
 egen a_`var'=mean(`var')
}
foreach var of varlist Synthesize Coordinate Analyze Compile Compute Copy Compare Mentor Negotiate Instruct Supervise Divert Persuade Speak Serve Help Set Precision Operate Drive Manipulate Tend Feed Handle Typewriter Photocopy Filing Telephone  {
gen n_`var'=`var'/a_`var'
}

keep occ19501digit n_*
xpose, varname clear
rename  v1 Clerical_and_Kindred
rename  v2 Craftsmen_and_Operatives
rename  v3 Farmers_and_Farm_Laborers
rename  v4 Managers_Officials_Proprietors
rename  v5 Professional_Technical
rename  v6 Sales_workers
rename  v7 Service_workers
rename _varname function
drop if _n==1
order function Clerical_and_Kindred Managers_Officials_Proprietors Professional_Technical Sales_workers Service_workers Craftsmen_and_Operatives Farmers_and_Farm_Laborers
drop if function=="n_Mentor"

