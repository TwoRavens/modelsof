/*************************************************************
This do file uses the Business Structure Database (BSD) accessible to authorised users via the UK Data Service Secure Lab.
Using this data, the do file constructs measures of entry and exit rates as well as size of entrants and of existing firms.

This file focuses on manufacturing industries.
Industries are analysed at the 3-digit level (SIC1992 or SIC2003 3-digit code).

**************************************************************/
clear all
set mem 2g
set matsize 11000
set maxvar 32000
set more off

global home "Y:\53523_Sorting"
global working "$home\Working"
global BSD_data "$working\BSD_Coaggl"
global logs "$working\Logs\Coaggl"
global temp "$working\Coaggl"
global geodata "$working\Data\GeoData"
global output "$working\Data\Coaggl\big_small"

*-----------------------------------------------------------
*Data cleaning part: All plants

local i=1997
while `i'<=2009 {

	use "$BSD_data\idbr_intx4_`i'.dta", clear


	disp"*******************************"
	disp"*******************************"
	disp"*******This is year `i'*******"
	disp"*******************************"
	disp"*******************************"
	count
	disp"keeping plants with no anomalous IDs over time"
	tab hrt_id,m
	keep if hrt_id==1
	disp"keeping if adj emp is positive & not missing"
	keep if lu_empli>0 & lu_empli<.
	disp"keeping if sic3d is not missing"
	keep if sic3d>0 & sic3d<.
	disp"keeping if postcode is not missing"
	keep if postcode!="."

	keep if dlink_ref<.

	duplicates tag dlink_ref if dlink_ref!=., gen(xx)
	disp"tab duplicates"
	tab xx

	egen nplant = count(dlink_ref) if dlink_ref!=., by(entref)
	gen multi=1 if nplant>1 & nplant<.
	replace multi=0 if multi!=1 
	disp"num of multiples by entref"
	tab multi, m
	gen single=1==nplant
	disp"num of sigle firms"
	disp "This year is `i'"
	tab single, m
	*keep if single==1 /*if this commant is activated the calculations only include single plants (as in one robustness check)/*
	compress
	drop  xx merge1 
	capture drop _merge
	compress
	save "$temp\panel_`i'_all", replace
	
local i = `i'+1
}

local i=1997
while `i'<=2009 {
use "$temp\panel_`i'_all", clear
keep dlink_ref year entref
save  "$temp\panel_`i'_all_small", replace
local i = `i'+1
}

use "$temp\panel_1997_all_small", clear
local i=1998
while `i'<=2009 {
append using "$temp\panel_`i'_all_small"
local i = `i'+1
}

compress
sort dlink_ref year 
save "$temp\panel_all_adjacent_years.dta", replace


****************************
*This code opens the panel, keeps only useful variables and performs checks for the presence of plants in non-consecutive years 
*(not shown; not found given correction keep if hrt_id==1 above)
local i=1997
while `i'<=2009 {
use "$temp\panel_`i'_all", clear
count
sort dlink_ref year
merge dlink_ref year using "$temp\panel_all_adjacent_years.dta", nokeep
tab _merge
keep if _merge==3
drop _merge 
keep dlink_ref year sic3d postcode lu_empli entref birth
local z "year sic3d postcode lu_empli entref"
foreach j of local z {
rename `j' `j'_`i'
}
sort dlink_ref
save  "$temp\panel_`i'_all_clean_xtr", replace
local i = `i'+1
}


*******************************
*This loop starts merging adjacent years of the panel (two at the time) and calculates:
*Plant creation, Plant destruction, net Plant creation; employment growth

cap log close
log using $logs\coaggl_entry_exit_emp.log, replace

local i=1997
while `i'<=2008 {
local j = `i'+1
use "$temp\panel_`i'_all_clean_xtr", clear
sort dlink_ref 
merge 1:1 dlink_ref using "$temp\panel_`j'_all_clean_xtr" 
tab _merge


	disp"*****************************************"
	disp"*****************************************"
	disp"*******These are years `i' and `j' ******"
	disp"*****************************************"
	disp"*****************************************"

******************
*This displays continuing companies with changing sector. We replace with most recent
count if  _merge==3 &  sic3d_`i'!= sic3d_`j'
replace sic3d_`i'=sic3d_`j' if  _merge==3 &  sic3d_`i'!= sic3d_`j'

******************
*This displays continuing companies with changing postcodes. We replace with most recent
count if  _merge==3 &   postcode_`i'!=  postcode_`j'
replace  postcode_`i'=postcode_`j' if  _merge==3 &  postcode_`i'!=postcode_`j'

*---- Focus on Manufacturing, Construction and Services
count
keep if (sic3d_`i'>=151 & sic3d_`i'<=372) | (sic3d_`j'>=151 & sic3d_`j'<=372) 

*---- Drop tobacco and aggregates some sectors; see manuscript for details
drop if sic3d_`i'==160 | sic3d_`j'==160
recode sic3d_`i' 183 181 = 182
recode sic3d_`j' 183 181 = 182
recode sic3d_`i' 231 232 233 = 232
recode sic3d_`j' 231 232 233 = 232
recode sic3d_`i' 247 246 = 246
recode sic3d_`j' 247 246 = 246
recode sic3d_`i' 154 = 158
recode sic3d_`j' 154 = 158
recode sic3d_`i' 265 = 266
recode sic3d_`j' 265 = 266
recode sic3d_`i' 223 = 222
recode sic3d_`j' 223 = 222

*---- rename merge_plants
rename _merge merge_plants
label define lbl_plants	1"exit" 2"entry" 3"continuous"
label values merge_plants lbl_plants

**************************************************************
sort postcode_`i'
rename postcode_`i' postcode
replace postcode=subinstr(postcode," ","",.)
merge m:1 postcode using "$geodata\ttwa_pcode_mapping.dta", keep(match master)
tab _merge
drop if _merge==2
rename postcode postcode_`i'
rename ttwa ttwa_new_`i'
drop _merge
count if merge_plants==1 & ttwa_new_`i'==.
count if merge_plants==3 & ttwa_new_`i'==.
count if merge_plants==2 & ttwa_new_`i'==.

sort postcode_`j'
rename postcode_`j' postcode
replace postcode=subinstr(postcode," ","",.)

/*Merges information to map postcode to TTWAs - this kind of mapping can be easily found on-line using the Postcode Survey Directory which gets updated every years */
merge m:1 postcode using "$geodata\ttwa_pcode_mapping.dta", keep(match master)
tab _merge
drop if _merge==2
rename postcode postcode_`j'
rename ttwa ttwa_new_`j'
drop _merge
count if merge_plants==1 & ttwa_new_`j'==.
count if merge_plants==3 & ttwa_new_`j'==.
count if merge_plants==2 & ttwa_new_`j'==.

************************
rename ttwa_new_`i' TTWA
sort TTWA
merge m:1 TTWA using "$geodata\ruralgroup_urban_ttwa_updated.dta"

*Use the classification provided by Gibbons, Overman, Resende, SERC DP 65, 2011 to create "grouped" TTWA and rural/urban divide
tab _merge
tab _merge merge_plants
drop if _merge==2
drop _merge
count if TTWA!=.
tab merge_plants if TTWA==.

gen new_area_name=ttwa_name if  area_name=="Urban"
replace new_area_name=area_name if  area_name!="Urban"

gen urban=1 if  area_name=="Urban"
replace urban=0 if  area_code!=. &  area_name!="Urban"
tab urban merge_plants, m

count
rename TTWA TTWA_old
gen TTWA=area_code

rename TTWA ttwa_`i' 
rename urban urban_`i' 
drop ttwa_name area_name area_code new_area_name TTWA_old

********************************
rename ttwa_new_`j' TTWA
sort TTWA
merge m:1 TTWA using "$geodata\ruralgroup_urban_ttwa_updated.dta"

*Use the classification provided by Gibbons, Overman, Resende, SERC DP 65, 2011 to create "grouped" TTWA and rural/urban divide
tab _merge
tab _merge merge_plants
drop if _merge==2
drop _merge
count if TTWA!=.

gen new_area_name=ttwa_name if  area_name=="Urban"
replace new_area_name=area_name if  area_name!="Urban"

gen urban=1 if  area_name=="Urban"
replace urban=0 if  area_code!=. &  area_name!="Urban"
tab urban merge_plants, m

count
rename TTWA TTWA_old
gen TTWA=area_code

rename TTWA ttwa_`j' 
rename urban urban_`j' 
drop ttwa_name area_name area_code new_area_name TTWA_old

*********************************
*Create unique TTWA (from TTWA of two years)
gen TTWA=ttwa_`i' if merge_plants==1
replace TTWA=ttwa_`j' if merge_plants==3
replace TTWA=ttwa_`j' if merge_plants==2

gen year=`j'

gen urban=urban_`i' if merge_plants==1
replace urban=urban_`j' if merge_plants==3
replace urban=urban_`j' if merge_plants==2

#delimit ;
label define ttwa_code
11	"Barnsley"  16	"Bedford"  20	"Birmingham"  22	"Blackburn"  23	"Blackpool"  24	"Bolton"  26	"Bournemouth"  27	"Bradford"
33	"Brighton"  34	"Bristol"  36	"Burnley"  40	"Calderdale"  41	"Cambridge"  44	"Cardiff"  48	"Chelmsford"
49	"Cheltenham"  54	"Colchester"  56	"Coventry"  59	"Crawley"  62	"Darlington"  63	"Derby"  66	"Doncaster"
70	"Dudley "  82	"Exeter"  90	"Gloucester"  94	"Grimsby"  95	"Guildford"  98	"Hartlepool" 
99	"Hastings"  107	"Huddersfield"  108	"Hull"  112	"Ipswich"  126	"Leeds"  127	"Leicester"   129	"Liverpool" 
139	"Luton"  141	"N Kent"  143	"Manchester"  144	"Mansfield"  148	"Middlesbrough"  150	"Milton Key."
157	"Newcastle"  158	"Newport"  163	"Northampton"  164	"Norwich"  165	"Nottingham"  171	"Oxford"
177	"Peterborough"  180	"Plymouth"  181	"Poole"  183	"Portsmouth"  184	"Preston"  186	"Reading"  189	"Rochdale"
195	"Sheffield"  201	"Southampton"  202	"Southend"  206	"Stevenage"  208	"Stoke-on-Trent"  211	"Sunderland" 
212	"Swansea"  213	"Swindon"  215	"Telford"  219 "Torbay"  222	"Tunbridge Wells"  225	"Wakefield"  226	"Walsall"
227	"Warrington"  233	"Wirral"  235	"Wolverhampton"  236	"Worcester"  239	"Worthing"
241	"Slough"  243	"York"  1015	"Carlisle"  1016	"Scot. Borders"  1017	"Ashington" 
1018	"Mid NE" 1019	"N Cumbria"  1020	"S Cumbria"  1021	"Kendal"  1022	"Lancaster"
1023	"NE Yorkshire"  1024	"Harrogate"  1025	"NW Yorkshire"  1026	"Scarborough" 
1027	"Chester"  1028	"Northwich"  1029	"Wrexham"  1030	"Shrewsbury"  1031	"Mid-Wales Bord."
1032	"Hereford"  1033	"South-Wales Bord."  1034	"Bridgend"  1035	"South-Mid Wales"  1036	"SW Wales"
1037	"Mid Wales"  1039	"NW Wales"  1040	"North Wales"  1041	"Stafford"  1042	"Burton"  1043	"W Peak Distr."
1044	"Chesterfield"   1045	"Worksop & Retford"  1046	"Scunthorpe"  1047 "E. Lincolnshire"   1048	"W Lincolnshire"  1049	"Norfolk"
1050	"N Norfolk"  1051	"Huntingdon"  1052	"Kettering"  1053	"Warwick"  1054	"Rugby"
1055	"Banbury"   1056	"W East Anglia"  1057	"East Anglia Coast" 
1058	"Harlow"  1059	"Chichester"  1060	"Eastbourne"  1061	"W Kent" 
1062	"Canterbury"  1063	"E Kent"  1064	"I. of Wight"  1065	"Basingstoke"  1066	"Newbury"
1067	"Andover"  1068	"Salisbury"  1069	"Trowbridge"  1070	"Bath"  1071	"E Somerset"
1072	"Yeovil"  1073	"Devon Coast"  1074	"S Devon"  1075	"Taunton"  1076	"N Devon"  1077	"NW Devon" 
1078	"W Cornwall"  1079	"E Cornwall"  
1 "Aberdeen" 73 "Dundee" 79 "Edinburgh" 89 "Glasgow" 123 "Lanarkshire" 1001 "N Scotland" 1002 "Moray Firth" 1003 "W Highlands"	
1004 "Inverness" 1005 "Stirling&All." 1006 "E Highlands"	1007 "Perth&Blairg." 1008 "N of Forth"
1009 "Dunfermline" 1010 "Falkirk"	1011 "Livingston&Bathg." 1012 "Greenock,Arran&Irv." 1013 "Ayr&Kilmarnock" 1014 "N Solway"
135  "London" ;

#delimit cr;
label values TTWA ttwa_code


/*Adjusting for problematic postcodes - see Web Appendix of the Manuscript for details*/
sort postcode_`i' sic3d_`i' entref_`i'
by postcode_`i' sic3d_`i' entref_`i': egen c_pc_sc_`i'=count(dlink_ref) if merge_plants==1 | merge_plants==3

sort postcode_`j' sic3d_`j' entref_`j'
by postcode_`j' sic3d_`j' entref_`j': egen c_pc_sc_`j'=count(dlink_ref) if merge_plants==2 | merge_plants==3

drop if (merge_plants==1 & c_pc_sc_`i'>2) | (merge_plants==3 & c_pc_sc_`i'>2)
drop if (merge_plants==2 & c_pc_sc_`j'>2) | (merge_plants==3 & c_pc_sc_`j'>2)

drop c_pc_sc_`i' c_pc_sc_`j'

/*Adjusting for problematic postcodes - see Web Appendix of the Manuscript for details*/
sort postcode_`i' sic3d_`i'
by postcode_`i' sic3d_`i': egen c_pc_sc_`i'=count(dlink_ref) if merge_plants==1 | merge_plants==3

sort postcode_`j' sic3d_`j'
by postcode_`j' sic3d_`j': egen c_pc_sc_`j'=count(dlink_ref) if merge_plants==2 | merge_plants==3

egen pc95_`i'=pctile(c_pc_sc_`i') if (merge_plants==1 | merge_plants==3) , p(95)
egen pc95_`j'=pctile(c_pc_sc_`j') if (merge_plants==2 | merge_plants==3) , p(95)
drop if (merge_plants==1 & c_pc_sc_`i'>pc95_`i') | (merge_plants==3 & c_pc_sc_`i'>pc95_`i')
drop if (merge_plants==2 & c_pc_sc_`j'>pc95_`j') | (merge_plants==3 & c_pc_sc_`j'>pc95_`j')
drop c_pc_sc_`i' c_pc_sc_`j' pc95_`i' pc95_`j'


/* Adjustment for employment outliers - see Web Appendix of the Manuscript for details*/
sort sic3d_`i'
by sic3d_`i': egen pe99_`i'=pctile(lu_empli_`i') if (merge_plants==1 | merge_plants==3), p(99)
drop if (merge_plants==1 & lu_empli_`i'>pe99_`i') | (merge_plants==3 & lu_empli_`i'>pe99_`i')

sort sic3d_`j'
by sic3d_`j': egen pe99_`j'=pctile(lu_empli_`j') if (merge_plants==2 | merge_plants==3) , p(99)
drop if (merge_plants==2 & lu_empli_`j'>pe99_`j') | (merge_plants==3 & lu_empli_`j'>pe99_`j')

drop pe99_`i' pe99_`j' 

*---- keeping urban only
keep if urban==1

*---- computing entry and exit rates
bysort sic3d_`j': egen nplants_`j'=count(dlink_ref) if sic3d_`j'!=.
bysort sic3d_`i': egen nplants_`i'=count(dlink_ref) if sic3d_`i'!=.
egen nplants_av=rowmean(nplants_`i' nplants_`j') if merge_plants==3

drop nplants_`j' nplants_`i'

sort sic3d_`i'
gen a=0
replace a=1 if merge_plants==1
by sic3d_`i': egen exit=sum(a) if sic3d_`i'!=.
drop a

sort sic3d_`j'
gen a=0
replace a=1 if merge_plants==2
by sic3d_`j': egen entry=sum(a) if sic3d_`j'!=.
drop a
sum entry exit
gen net=entry-exit
sum net

gen entry_sh=entry/nplants_av
gen exit_sh=exit/nplants_av
gen net_sh=net/nplants_av
sum *_sh

*---- computing average employment for entrants, exitors and continuing firms
egen exit_emp = mean(lu_empli_`i') if merge_plants==1 & lu_empli_`i'<., by(sic3d_`i')
egen entry_emp = mean(lu_empli_`j') if merge_plants==2 & lu_empli_`j'<., by(sic3d_`j')
egen cont_emp = mean(lu_empli_`j') if merge_plants==3 & lu_empli_`j'<., by(sic3d_`j')
egen avg_emp = mean(lu_empli_`j') if merge_plants==3 & lu_empli_`j'<. | merge_plants==2 & lu_empli_`j'<., by(sic3d_`j')

foreach y in lu_empli sic3d {
*---- Create unique values (from values of two years)
gen `y'=`y'_`i' if merge_plants==1
replace `y'=`y'_`j' if merge_plants==3
replace `y'=`y'_`j' if merge_plants==2
}

keep entry_sh exit_sh net_sh entry_emp exit_emp cont_emp avg_emp dlink_ref sic3d year
quietly compress
collapse (mean) entry_sh exit_sh net_sh entry_emp exit_emp cont_emp avg_emp year, by(sic3d)
save "$temp\BSD_entry_exit_emp_`j'.dta", replace

local i = `i'+1
}

use "$temp\BSD_entry_exit_emp_1998.dta", clear
local m=1999
while `m'<=2008 {
append using "$temp\BSD_entry_exit_emp_`m'.dta"
local m = `m'+1
}

sort year sic3d
save "$output\BSD_entry_exit_emp.dta", replace

log close
