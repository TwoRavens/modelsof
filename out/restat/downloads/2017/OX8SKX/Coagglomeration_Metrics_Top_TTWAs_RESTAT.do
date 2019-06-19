/*************************************************************
This do file uses the Business Structure Database (BSD), which is accessible to authorised users via the UK Data Service Secure Lab
Using this data, the do file constructs the Ellison-Glaeser-Kerr (2010) Gamma indices for studying the coagglomeration of industries.

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
global output "$working\Data\Coaggl"

*-----------------------------------------------------------
*Data cleaning part: All plants

cap log close

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
	disp"keeping if emp is positive & not missing"
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
local z "year sic3d postcode lu_empli "
foreach j of local z {
rename `j' `j'_`i'
}
sort dlink_ref
save  "$temp\panel_`i'_all_clean_xtr", replace
local i = `i'+1
}

*--------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------
/*Coagglomeration part*/

capture log close
log using $logs\coaggl_all_plants_manuf_ttwa.log, replace

local m=1997
while `m'<=2008 {



disp "****************************"
disp "****************************"
disp "****This is for year `m'****"
disp "****************************"
disp "****************************"

use "$temp\panel_`m'_all_clean_xtr", clear
/*Introducing the TTWA coding*/
sort postcode_`m'
rename postcode_`m' postcode
replace postcode=subinstr(postcode," ","",.)

/*Merges information to map postcode to TTWAs - this kind of mapping can be easily found on-line using the Postcode Survey Directory which gets updated every years */
merge m:1 postcode using "$geodata\ttwa_pcode_mapping.dta", keep(match master)
tab _merge
drop if _merge==2
drop if _merge==1
drop _merge

************************
rename ttwa TTWA
sort TTWA
merge m:1 TTWA using "$geodata\ruralgroup_urban_ttwa_updated.dta"

*Use the classification provided by Gibbons, Overman, Resende, SERC DP 65, 2011 to create "grouped" TTWA and rural/urban divide
tab _merge
drop if _merge==2
drop if _merge==1 
drop _merge

gen new_area_name=ttwa_name if  area_name=="Urban"
replace new_area_name=area_name if  area_name!="Urban"

gen urban=1 if  area_name=="Urban" 
replace urban=0 if  area_code!=. &  area_name!="Urban"
tab urban, m

count
rename TTWA TTWA_old
gen TTWA=area_code

drop ttwa_name area_name area_code new_area_name TTWA_old

*********************************

#delimit ;
label define ttwa_code_new
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
label values TTWA ttwa_code_new

/*Adjusting for problematic postcodes - see Web Appendix of the Manuscript for details*/
sort postcode sic3d_`m'
by postcode sic3d_`m': egen c_pc_sc=count(dlink_ref)
egen pc95=pctile(c_pc_sc), p(95)
drop if c_pc_sc>pc95

sort sic3d_`m'
by sic3d_`m': egen pe99=pctile(lu_empli_`m'), p(99)
drop if lu_empli_`m'>pe99


drop pe99 pc95 c_pc_sc
 
sort postcode sic3d_`m' entref
by postcode sic3d_`m' entref: egen c_pc_sc=count(dlink_ref)
sum c_pc_sc, det
drop if c_pc_sc>2

rename  year_`m' year 
rename  sic3d_`m'  sic3d
rename  lu_empli_`m' empl

*****************************************
**********Manufacturing only*************
*****************************************
count
keep if sic3d>=151 & sic3d<=372
count

*---- Drop tobacco and aggregates some sectors; see manuscript for details
drop if sic3d==160
recode sic3d 183 181 = 182
recode sic3d 231 232 233 = 232
recode sic3d 247 246 = 246
recode sic3d 154 = 158
recode sic3d 265 = 266
recode sic3d 223 = 222

egen ind = group(sic3d)
disp"sum ind for year `m"
sum ind
gen min=r(min)
gen max=r(max)
save "$temp\all_dataset.dta", replace

***********************************************
/*Coagglomeration coding -- number of plants */
***********************************************

*IMPORTANT: IN ORDER TO OBTAIN COAGGLOMERATION METRICS THAT EXCLUDE LONDON, PRINTING AND PUBLISHING, CONSIDER BOTH URBAN AND RURAL AREAS
*THE CODE THAT FOLLOWS NEEDS TO BE ADAPTED (E.G. DROP LONDON WHICH IS TTWA==135; OR KEEP IF URBAN==1|URBAN==0) AND THE FINAL FILE SAVED WITH A DIFFERENT NAME

use "$temp\all_dataset.dta", clear
sort TTWA sic3d 
by TTWA sic3d: egen nplants_sic_ttwa=count(dlink_ref)
sort sic3d
by sic3d: egen nplants_sic_uk=count(dlink_ref)
sort TTWA
by TTWA: egen nplants_ttwa=count(dlink_ref)
egen nplants_uk=count(dlink_ref)
sum  nplants_sic_ttwa nplants_sic_uk nplants_ttwa nplants_uk

gen s_sic_ttwa=nplants_sic_ttwa/nplants_sic_uk 
gen x_ttwa=nplants_ttwa/nplants_uk 
gen x2_ttwa=(x_ttwa)^2

/*for each pair we can report 1 ttwa with the largest share of that pair's activity*/
gen p_sic_ttwa = (nplants_sic_ttwa/nplants_sic_uk)

collapse (mean) s_sic_ttwa p_sic_ttwa x_ttwa x2_ttwa urban min max year sic3d, by(ind TTWA)
reshape wide s_sic_ttwa p_sic_ttwa sic3d, i(TTWA) j(ind)
order  TTWA x_ttwa x2_ttwa year urban
compress

sort urban
by urban: egen a=sum(x2_ttwa)
replace x2_ttwa=a
drop a 

	local i=min
	while `i'<=max {
		replace s_sic_ttwa`i'=0 if s_sic_ttwa`i'==.
		replace p_sic_ttwa`i'=0 if p_sic_ttwa`i'==.
		egen a=max(sic3d`i')
		replace sic3d`i'=a if sic3d`i'==.
		drop a
	local i = `i'+1
	}

	keep if urban==1

	local i=min
		while `i'<=max-1 {
			local j=`i'+1 
			while `j'<=max {
			gen s_ttwa`i'`j'=(s_sic_ttwa`i'-x_ttwa)*(s_sic_ttwa`j'-x_ttwa)
			egen a=sum(s_ttwa`i'`j')
			replace s_ttwa`i'`j'=a
			drop a
			gen gamma`i'`j'=s_ttwa`i'`j'/(1-x2_ttwa)
			drop s_ttwa`i'`j' 
			gen p_ttwa`i'`j' = (p_sic_ttwa`i' + p_sic_ttwa`j')
			egen sec`i'`j'=concat(sic3d`i' sic3d`j'), punct("_")
			
		    replace p_ttwa`i'`j'=. if p_ttwa`i'`j'==0
			replace p_ttwa`i'`j'=. if (p_sic_ttwa`i'==0 | p_sic_ttwa`j'==0)
			gsort sec`i'`j' -p_ttwa`i'`j'
			by sec`i'`j': gen p_max`i'`j' = p_ttwa`i'`j'[1]
			by sec`i'`j': gen p_2nd`i'`j' = p_ttwa`i'`j'[2]
			by sec`i'`j': gen p_3rd`i'`j' = p_ttwa`i'`j'[3]
			
			bysort sec`i'`j': gen ttwa1_`i'`j' = TTWA if (p_ttwa`i'`j' == p_max`i'`j')
			bysort sec`i'`j': egen t_max`i'`j' = max(ttwa1_`i'`j')
			
			bysort sec`i'`j': gen ttwa2_`i'`j' = TTWA if (p_ttwa`i'`j' == p_2nd`i'`j') & TTWA!= t_max`i'`j'
			bysort sec`i'`j': egen t_2nd`i'`j' = max(ttwa2_`i'`j')
			
			bysort sec`i'`j': gen ttwa3_`i'`j' = TTWA if (p_ttwa`i'`j' == p_3rd`i'`j') & TTWA!= t_max`i'`j' & TTWA!= t_2nd`i'`j'
			bysort sec`i'`j': egen t_3rd`i'`j' = max(ttwa3_`i'`j')
			
			drop ttwa1_`i'`j' ttwa2_`i'`j' ttwa3_`i'`j' p_ttwa`i'`j' p_max`i'`j' p_2nd`i'`j' p_3rd`i'`j'
			local j = `j'+1
			}
		drop s_sic_ttwa`i' p_sic_ttwa`i' sic3d`i'
	local i = `i'+1
	}	
bysort urban: gen n=_n
sum n
keep if n==1

drop TTWA n x2_ttwa x_ttwa s_sic_ttwa* p_sic_ttwa* sic3d* min max
reshape long gamma sec t_max t_2nd t_3rd, i(urban) j(sic)

keep year gamma sec t_max t_2nd t_3rd
label values t_max ttwa_code_new
label values t_2nd ttwa_code_new
label values t_3rd ttwa_code_new
sort sec

*THIS FILE CONTAINS MEASURES OF COAGGLOMERATION AS WELL AS THE THREE TOP TTWAS WHERE THE SECTOR PAIRS ARE MOST CO-LOCATED
save "$temp\gamma_all_plants_manuf_ttwa_max_`m'.dta", replace


**************************************************
/*Coagglomeration coding -- number of employees */
**************************************************

use "$temp\all_dataset.dta", clear
sort TTWA sic3d 
by TTWA sic3d: egen nempl_sic_ttwa=sum(empl) if empl<.
sort sic3d
by sic3d: egen nempl_sic_uk=sum(empl) if empl<.
sort TTWA
by TTWA: egen nempl_ttwa=sum(empl) if empl<.
egen nempl_uk=sum(empl) if empl<.
sum  nempl_sic_ttwa nempl_sic_uk nempl_ttwa nempl_uk

gen s_sic_ttwa=nempl_sic_ttwa/nempl_sic_uk 
gen x_ttwa=nempl_ttwa/nempl_uk 
gen x2_ttwa=(x_ttwa)^2

/*for each pair we can report 1 ttwa with the largest share of that pair's activity*/
gen p_sic_ttwa = (nempl_sic_ttwa/nempl_sic_uk)

collapse (mean) s_sic_ttwa p_sic_ttwa x_ttwa x2_ttwa urban min max year sic3d, by(ind TTWA)
reshape wide s_sic_ttwa p_sic_ttwa sic3d, i(TTWA) j(ind)
order  TTWA x_ttwa x2_ttwa year urban
compress

sort urban
by urban: egen a=sum(x2_ttwa)
replace x2_ttwa=a
drop a 

	local i=min
	while `i'<=max {
		replace s_sic_ttwa`i'=0 if s_sic_ttwa`i'==.
		replace p_sic_ttwa`i'=0 if p_sic_ttwa`i'==.
		egen a=max(sic3d`i')
		replace sic3d`i'=a if sic3d`i'==.
		drop a
	local i = `i'+1
	}

	keep if urban==1

	local i=min
		while `i'<=max-1 {
			local j=`i'+1 
			while `j'<=max {
			gen s_ttwa`i'`j'=(s_sic_ttwa`i'-x_ttwa)*(s_sic_ttwa`j'-x_ttwa)
			egen a=sum(s_ttwa`i'`j')
			replace s_ttwa`i'`j'=a
			drop a
			gen e_gamma`i'`j'=s_ttwa`i'`j'/(1-x2_ttwa)
			drop s_ttwa`i'`j' 
			gen p_ttwa`i'`j' = (p_sic_ttwa`i' + p_sic_ttwa`j')
			egen sec`i'`j'=concat(sic3d`i' sic3d`j'), punct("_")
			
		    replace p_ttwa`i'`j'=. if p_ttwa`i'`j'==0
			replace p_ttwa`i'`j'=. if (p_sic_ttwa`i'==0 | p_sic_ttwa`j'==0)
			gsort sec`i'`j' -p_ttwa`i'`j'
			by sec`i'`j': gen p_max`i'`j' = p_ttwa`i'`j'[1]
			by sec`i'`j': gen p_2nd`i'`j' = p_ttwa`i'`j'[2]
			by sec`i'`j': gen p_3rd`i'`j' = p_ttwa`i'`j'[3]
			
			bysort sec`i'`j': gen ttwa1_`i'`j' = TTWA if (p_ttwa`i'`j' == p_max`i'`j')
			bysort sec`i'`j': egen t_max`i'`j' = max(ttwa1_`i'`j')
			
			bysort sec`i'`j': gen ttwa2_`i'`j' = TTWA if (p_ttwa`i'`j' == p_2nd`i'`j') & TTWA!= t_max`i'`j'
			bysort sec`i'`j': egen t_2nd`i'`j' = max(ttwa2_`i'`j')
			
			bysort sec`i'`j': gen ttwa3_`i'`j' = TTWA if (p_ttwa`i'`j' == p_3rd`i'`j') & TTWA!= t_max`i'`j' & TTWA!= t_2nd`i'`j'
			bysort sec`i'`j': egen t_3rd`i'`j' = max(ttwa3_`i'`j')
			
			drop ttwa1_`i'`j' ttwa2_`i'`j' ttwa3_`i'`j' p_ttwa`i'`j' p_max`i'`j' p_2nd`i'`j' p_3rd`i'`j'
			local j = `j'+1
			}
		drop s_sic_ttwa`i' p_sic_ttwa`i' sic3d`i'
	local i = `i'+1
	}	

bysort urban: gen n=_n
sum n
keep if n==1

drop TTWA n x2_ttwa x_ttwa s_sic_ttwa* p_sic_ttwa* sic3d* min max
reshape long e_gamma sec t_max t_2nd t_3rd, i(urban) j(sic)

keep year e_gamma sec t_max t_2nd t_3rd
rename t_max e_t_max
rename t_2nd e_t_2nd
rename t_3rd e_t_3rd
label values e_t_max ttwa_code_new
label values e_t_2nd ttwa_code_new
label values e_t_3rd ttwa_code_new
sort sec
save "$temp\e_gamma_all_plants_manuf_ttwa_max_`m'.dta", replace

sort sec
merge 1:1 sec using "$temp\gamma_all_plants_manuf_ttwa_max_`m'.dta"
tab _merge
drop _merge
label var e_gamma"EGK empl coaggl"
label var gamma"EGK num of firms coaggl"
save "$temp\EG_all_plants_manuf_ttwa_max_`m'.dta", replace

local m =`m'+1
}

*AFTER REPEATING FOR ALL YEARS BETWEEN 1997 AND 2008, DATA ARE APPENDED
use "$temp\EG_all_plants_manuf_ttwa_max_1997.dta", clear
local m=1998
while `m'<=2008 {
append using "$temp\EG_all_plants_manuf_ttwa_max_`m'.dta"
local m = `m'+1
}

sort year sec
save "$output\EG_all_plants_manuf_ttwa_max_1997-2008.dta", replace

log close

