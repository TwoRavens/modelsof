
insheet using input/ssamatab1.txt, tab  clear  // from BLS

split v1, p("	")

drop if v12==""
drop v13 v15 v17-v134

rename v11 LAUS_code 
rename v12 state_fips_code
rename v14 msa 
rename v16 msa_name
replace msa = trim(msa) 
drop if trim(state_fips_code)=="72"

g year = word(v1, -6)
g month = word(v1, -5)
g lf_msa = word(v1, -4)
g e_msa = word(v1, -3)
g u_msa = word(v1, -2)
g ur_msa = word(v1, -1)

drop v1 

replace lf_msa = subinstr(lf_msa,",","",.)
replace e_msa = subinstr(e_msa,",","",.)
replace u_msa = subinstr(u_msa,",","",.)

destring year month lf_msa e_msa u_msa ur_msa, replace

g datem = ym(year, month)

keep msa datem ur_msa msa_name 

/*NECTA associations
Leominster-Fitchburg-Garnder, Portsmouth Maine , Rochester-Dover, Danbury, New Bedford, Waterbury
*/
replace msa = "35300" if msa=="75700"
replace msa = "12620" if msa=="70750"
replace msa = "14460" if msa=="71650" // this is the whole "Boston-Cambridge-Quincy, MA-NH Met NECTA  "
replace msa = "14860" if msa=="71950" 
replace msa = "15540" if msa=="72400" 
replace msa = "25540" if msa=="73450"
replace msa = "30340" if msa=="74650" 
replace msa = "31700" if msa=="74950"
replace msa = "35980" if msa=="76450"
replace msa = "38340" if msa=="76600" 
replace msa = "38860" if msa=="76750" 
replace msa = "39300" if msa=="77200" 
replace msa = "44140" if msa=="78100" 
replace msa = "49340" if msa=="79600" 
replace msa = "12700" if msa=="70900" 

save unemp_SA.tmp, replace 

import excel using input/CBSA-EST2009-01.xls, cellrange(A4:O977) first clear

rename A msa 
rename B md 

drop if msa==""
g date1 = ym(2000,1) 
g date2 = ym(2014,12) 
drop July* C Census Est
reshape long date, i(msa md) j(datem) 
format date %tm 
drop datem 
rename date datem 

replace md = "NONE" if md==""
egen id = group(msa md) 

xtset id datem, delta(1 month)
tsfill
carryforward msa md, replace
replace md="" if md=="NONE"
drop id

/*MSA code cleaning*/
replace msa="35840" if msa=="14600"|msa=="42260" 
replace msa="18880" if msa=="23020"
replace msa="44600" if msa=="48260"
replace msa="42044" if msa=="11244"
replace msa="14460" if msa=="40484"

merge m:1 msa datem using unemp_SA.tmp
sort msa datem

replace msa=md if md!=""  
drop md
destring msa, replace 
drop if inlist(msa, 16980, 19100, 19820, 31100, 33100, 35620, 37980, 41860, 42660, 47900) /* drops overarching MSA data for those with MDs */
drop if msa==40484 // Rockingham issue

drop if _m==1 /*removes micropolitan statistical areas*/
tab msa if _m==2
drop if _m==2 /* not matching the following 6 NECTA's: Leominster-Fitchburg-Garnder, Portsmouth Maine , Rochester-Dover, Danbury, New Bedford, Waterbury*/ 
drop _m msa_name 
save unemp_SA.dta, replace 
