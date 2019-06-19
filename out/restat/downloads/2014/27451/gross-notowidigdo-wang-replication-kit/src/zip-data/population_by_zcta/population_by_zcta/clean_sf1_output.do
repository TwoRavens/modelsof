#delim cr
set more off
*version 10
pause on
graph set ps logo off

*capture log close
*set linesize 80
*set logtype text
*log using XXX.log , replace

/* --------------------------------------

AUTHOR: Tal Gross

PURPOSE:  Just clean the basic census sf1 output.

DATE CREATED: Mon Mar 15 13:25:36 EDT 2010

NOTES:

CHANGELOG:

--------------------------------------- */

clear
estimates clear
set mem 50m
describe, short


************************************************************
**  Bring in Output                                       **
************************************************************

insheet using census_sf1_output.csv , comma names
d, f

************************************************************
**  Clean up Vars                                         **
************************************************************

label var zcta5   "Geographic Identifiers 2000  ZIP Code Tabulation Area (5 digit)"
label var p012001 "P Tables 2000 P012 SEX BY AGE [49] P012001   Total"
label var p012002 "P Tables 2000 P012 SEX BY AGE [49] P012002         Male"
label var p012003 "P Tables 2000 P012 SEX BY AGE [49] P012003 Male,  Under 5 years"
label var p012004 "P Tables 2000 P012 SEX BY AGE [49] P012004 Male,  5 to 9 years"
label var p012005 "P Tables 2000 P012 SEX BY AGE [49] P012005 Male,  10 to 14 years"
label var p012006 "P Tables 2000 P012 SEX BY AGE [49] P012006 Male,  15 to 17 years"
label var p012007 "P Tables 2000 P012 SEX BY AGE [49] P012007 Male,  18 and 19 years"
label var p012008 "P Tables 2000 P012 SEX BY AGE [49] P012008 Male,  20 years"
label var p012009 "P Tables 2000 P012 SEX BY AGE [49] P012009 Male,  21 years"
label var p012010 "P Tables 2000 P012 SEX BY AGE [49] P012010 Male,  22 to 24 years"
label var p012011 "P Tables 2000 P012 SEX BY AGE [49] P012011 Male,  25 to 29 years"
label var p012012 "P Tables 2000 P012 SEX BY AGE [49] P012012 Male,  30 to 34 years"
label var p012013 "P Tables 2000 P012 SEX BY AGE [49] P012013 Male,  35 to 39 years"
label var p012014 "P Tables 2000 P012 SEX BY AGE [49] P012014 Male,  40 to 44 years"
label var p012015 "P Tables 2000 P012 SEX BY AGE [49] P012015 Male,  45 to 49 years"
label var p012016 "P Tables 2000 P012 SEX BY AGE [49] P012016 Male,  50 to 54 years"
label var p012017 "P Tables 2000 P012 SEX BY AGE [49] P012017 Male,  55 to 59 years"
label var p012018 "P Tables 2000 P012 SEX BY AGE [49] P012018 Male,  60 and 61 years"
label var p012019 "P Tables 2000 P012 SEX BY AGE [49] P012019 Male,  62 to 64 years"
label var p012020 "P Tables 2000 P012 SEX BY AGE [49] P012020 Male,  65 and 66 years"
label var p012021 "P Tables 2000 P012 SEX BY AGE [49] P012021 Male,  67 to 69 years"
label var p012022 "P Tables 2000 P012 SEX BY AGE [49] P012022 Male,  70 to 74 years"
label var p012023 "P Tables 2000 P012 SEX BY AGE [49] P012023 Male,  75 to 79 years"
label var p012024 "P Tables 2000 P012 SEX BY AGE [49] P012024 Male,  80 to 84 years"
label var p012025 "P Tables 2000 P012 SEX BY AGE [49] P012025 Male,  85 years and over"
label var p012026 "P Tables 2000 P012 SEX BY AGE [49] P012026         Female"
label var p012027 "P Tables 2000 P012 SEX BY AGE [49] P012027 Female,  Under 5 years"
label var p012028 "P Tables 2000 P012 SEX BY AGE [49] P012028 Female,  5 to 9 years"
label var p012029 "P Tables 2000 P012 SEX BY AGE [49] P012029 Female,  10 to 14 years"
label var p012030 "P Tables 2000 P012 SEX BY AGE [49] P012030 Female,  15 to 17 years"
label var p012031 "P Tables 2000 P012 SEX BY AGE [49] P012031 Female,  18 and 19 years"
label var p012032 "P Tables 2000 P012 SEX BY AGE [49] P012032 Female,  20 years"
label var p012033 "P Tables 2000 P012 SEX BY AGE [49] P012033 Female,  21 years"
label var p012034 "P Tables 2000 P012 SEX BY AGE [49] P012034 Female,  22 to 24 years"
label var p012035 "P Tables 2000 P012 SEX BY AGE [49] P012035 Female,  25 to 29 years"
label var p012036 "P Tables 2000 P012 SEX BY AGE [49] P012036 Female,  30 to 34 years"
label var p012037 "P Tables 2000 P012 SEX BY AGE [49] P012037 Female,  35 to 39 years"
label var p012038 "P Tables 2000 P012 SEX BY AGE [49] P012038 Female,  40 to 44 years"
label var p012039 "P Tables 2000 P012 SEX BY AGE [49] P012039 Female,  45 to 49 years"
label var p012040 "P Tables 2000 P012 SEX BY AGE [49] P012040 Female,  50 to 54 years"
label var p012041 "P Tables 2000 P012 SEX BY AGE [49] P012041 Female,  55 to 59 years"
label var p012042 "P Tables 2000 P012 SEX BY AGE [49] P012042 Female,  60 and 61 years"
label var p012043 "P Tables 2000 P012 SEX BY AGE [49] P012043 Female,  62 to 64 years"
label var p012044 "P Tables 2000 P012 SEX BY AGE [49] P012044 Female,  65 and 66 years"
label var p012045 "P Tables 2000 P012 SEX BY AGE [49] P012045 Female,  67 to 69 years"
label var p012046 "P Tables 2000 P012 SEX BY AGE [49] P012046 Female,  70 to 74 years"
label var p012047 "P Tables 2000 P012 SEX BY AGE [49] P012047 Female,  75 to 79 years"
label var p012048 "P Tables 2000 P012 SEX BY AGE [49] P012048 Female,  80 to 84 years"
label var p012049 "P Tables 2000 P012 SEX BY AGE [49] P012049 Female,  85 years and over"
label var p015001 "P Tables 2000 P015 HOUSEHOLDS [1] P015001   Total"


************************************************************
**  Create Share Under Age 18                             **
************************************************************

egen pop_leq_19 = rowtotal(p012027 p012028 p012029 p012030 p012031 p012003 p012004 p012005 p012006 p012007)
sum pop_leq_19

gen share_pop_leq_19 = pop_leq_19 / (p012026 + p012002) 
sum share_pop_leq_19

************************************************************
**  Save & Close                                          **
************************************************************

compress
label data "Population by Zip Code from the 2000 Census SF1 Files"
save zipcode-population-2000-sf1.dta , replace

*log close
exit

