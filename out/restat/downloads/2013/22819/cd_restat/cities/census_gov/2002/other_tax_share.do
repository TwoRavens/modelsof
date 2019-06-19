clear
set mem 1300m


use "C:\Users\HW462587\Documents\Leah\Data\rough1906_2005extract_wcensus"
sort state fips year_aux
tempfile algo
save `algo', replace

cd "C:\Users\HW462587\Documents\Leah\Data\census_gov\2002"




use "C:\Users\HW462587\Documents\Leah\Data\census_gov\2002\10298252\ICPSR_04426\DS0001\pkg04426-0001\Part1\02finindfinal"
drop year
gen year_aux=1999

rename fipstate state
rename fipspla fips
destring state fips, replace
sort state fips year_aux
merge state fips year_aux using  `algo'

tab _merge
keep if _merge==3
drop _merge




label var v_t01 "Property Taxes                         "
label var v_t09 "General Sales and Gross Receipts Taxes "
label var v_t10 "Alcoholic Beverages 		      "
label var v_t11 "Amusements			      "
label var v_t12 "Insurance Premiums 		      "
label var v_t13 "Motor Fuels 			      "
label var v_t14 "Pari-mutuels 			      "
label var v_t15 "Public Utilities 		      "
label var v_t16 "Tobacco Products 		      "
label var v_t19 "Other				      "
label var v_t20 "Alcoholic Beverages 		      "
label var v_t21 "Amusements 			      "
label var v_t22 "Corporations in General 	      "
label var v_t23 "Hunting and Fishing 		      "
label var v_t24 "Motor Vehicles 		      "
label var v_t25 "Motor Vehicle Operators	      "
label var v_t27 "Public Utilities 		      "
label var v_t28 "Occupation and Business, NEC 	      "
label var v_t29 "Other				      "
label var v_t40 "Individual Income 		      "
label var v_t41 "Corporation Net Income 	      "
label var v_t50 "Death and Gift			      "
label var v_t51 "Documentary & Stock Transfer 	      "
label var v_t53 "Severance 			      "
label var v_t99 "Taxes, NEC			      "

egen aux=rsum(v_t*)

matrix totals=J(40,40,.)

global variables v_t01	v_t09	v_t10	v_t11	v_t12	v_t13	v_t14	v_t15	v_t16	v_t19	v_t20	v_t21	v_t22	v_t23	v_t24	v_t25	v_t27	v_t28	v_t29	v_t40	v_t41	v_t50	v_t51	v_t53	v_t99


local counter= 1
foreach var in $variables   {

sum `var'
d `var'
matrix totals[`counter',1]=r(sum)
local counter=`counter'+1
}
