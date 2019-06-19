
clear all
set mem 3g
set matsize 11000
set maxvar 32767 
set more off 
capture log close

/*************************************************************************************
Using the LFS data 1995-1999, this do file constructs:
the labour pooling measure according to Ellison-Glaeser-Kerr, 2010
see manuscript for details and references

*************************************************************************************/

global home "Y:\53523_Sorting"
global working "$home\Working"
global LFS "$home\Syntax\LFS_construct\LFS_1664"
global LFS_original "$home\Original_data\6727_LFS\stata\stata9"
global LFS_added "$working\Data\LFS\added_files"
global logs "$working\Logs\Coaggl"
global temp "$working\Coaggl"
global geodata "$working\Data\GeoData"
global output "$working\Data\Coaggl"


**********************************************************
*Check missings variable of interest

local i=95
while `i'<=99 {

local j=1
while `j'<=4 {

*Uses standard do files that in-sheet and keep variables from LFS files (various quarters and years)
*Available for authorised users via the UK Data Service Secure Lab

quietly do $LFS\code`i'q`j'.do

disp "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
disp "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
display "This year is `i' & quarter is `j'"
disp "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
disp "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"

disp"keep employed, unemployed and inactive" 
keep if lfstat!=.
tab lfstat, m

disp"REFWKM"
tab refwkm, m

disp"URES"
tab ures, m
tab ures refwkm, m

disp"soc90"
tab soc90, m
tab soc90 refwkm, m
tab soc90 refwkm

disp"skill"
tab skill, m
tab skill refwkm, m
tab skill refwkm

disp"skgav"
tab skgav, m
tab skgav refwkm , m
tab skgav refwkm

disp"lfstat for those who skill is missing"
tab lfstat if skill==.

disp"full-time/part-time if l1==1"
tab ftptm if l1==1,m

display "*********************************"
display "Start cleaning data"
display "*********************************"

/*drop Northern Ireland and ures==.*/
disp"drop NI"
drop if ures==20
disp"drop if ures is missing"
drop if ures==.
rename ures region

rename self semp
rename soc1 soc_1d
rename soc90 soc_3d

display "**************************************************"
display " Further cleaning of variables"
display "**************************************************"

format remserno %16.0f 

tab skill, m
tab skgav, m
disp"replace nkid=0 if nkid==."
replace nkid=0 if nkid==.

disp"drop if working for the armed forces"
drop if armed==1 

disp"keep if SOC is not missing & lfstat==1 (only employed)"
keep if soc_3d<. & l1==1
disp"keep employees"
keep if semp==0

disp"drop if ward98=-9"
drop if ward98=="-9" 
disp"count if ward98=."
count if ward98==""
disp"count if ward98=-5"
count if ward98=="-5"

sort remserno quota persno hhold 
duplicates tag remserno quota persno hhold , gen(t)
tab t, m

rename weight1 weight
rename ward98 ward982

#delimit ;
keep remserno quota persno hhold year qr refwkm thisw qr
	sex age status skill skgav hoh nkid hhsize white
	student lfstat l1 l2 l3 ftptm pubw allemp soc_1d soc_3d inds92m indd92m
	indm92m rethed secj weight region ward982;
#delimi cr;


compress
disp "---------------------------------------"
save $temp\pnl`i'q`j'.dta, replace
disp "---------------------------------------"

local j=`j'+1
}
local i=`i'+1
display "*********************************"
}

/*appending the dataset*/
use $temp\pnl95q1.dta, clear
append using $temp\pnl95q2
append using $temp\pnl95q3
append using $temp\pnl95q4

local i=96
while `i'<=99 {
local j=1 
while `j'<=4 {
append using $temp\pnl`i'q`j'.dta
local j=`j'+1
}
local i=`i'+1
}
compress
save $temp\panel_allqr_untidy.dta, replace
sum
save, replace

*---------------*
clear all
set mem 3g
set matsize 11000
set maxvar 32767
set more off 
*---------------*

/***Using the untidy dataset***/

use "$temp\panel_allqr_untidy.dta", clear

/*adding sic92 3digit*/

*This is a standard do file that maps four digit sectors into three digit sectors
*A number of sectors have been aggregated; see manuscript for details 

do "Y:\53523_Sorting\Syntax\LFS_construct\sic92_4to3.do"
rename ind3 sic92_3d
drop ind4
rename inds92m sic92_1d

#delimit;
order remserno quota persno hhold year qr refwkm thisw qr
	sex age student rethed lfstat l* ftptm pubw allemp 
	soc_1d soc_3d sic92_1d sic92_3d region ward982;
	
#delimit cr;
duplicates tag remserno quota persno year qr, gen(t)
tab t
drop t
egen id=group(remserno quota persno year qr)
codebook id
order id

replace ward982=trim(ward982)
gen l=length(ward982) 
tab l
gen s4=ward982 if l==4
gen s6=ward982 if l==6
replace s4=trim(s4)
replace s6=trim(s6)
gen s1=0
gen s1s=string(s1)
gen s2s=string(s1)
drop s1
gen wardnew=s1s+s2s+s4 if l==4
replace wardnew=s6 if l==6
replace wardnew="-5" if l==2
rename wardnew ward98
sort ward98
compress
merge m:1 ward98 using "$geodata\ttwa_ward_mapping.dta" 

*Ward to TTWA mapping can be accessed by authorised users via the UK Data Service Secure Lab
tab _merge
drop if _merge==2
	
rename _merge merge1

sort ward98
merge ward98 using "$geodata\ttwa_ward_stat05_mapping.dta"

*Further corrections to wards/TTWAs; ward to TTWA mapping can be accessed by authorised users via the UK Data Service Secure Lab
tab _merge
drop if _merge==2

count if year==98
count if year==99
sum ttwa if year==98
sum ttwa if year==99
replace ttwa=ttwa_cen if year==98 & ward98!="-5" & ttwa==. & _merge==3
replace ttwa=ttwa_cen if year==99 & ward98!="-5" & ttwa==. & _merge==3

tab year qr if ward98==""
tab year qr if ward98=="-5"
tab year qr if ward98=="-9"
tab year refwkm if ward98=="-5"
tab year thiswv if ward98=="-5"
tab year qr if ttwa!=.

drop _merge merge1

drop if ttwa==.
drop  l s4 s6 s1s s2s flag mode_ttwa ttwa_cen

**************************************************
*Use the classification provided by Gibbons, Overman, Resende, SERC DP 65, 2011 to create "grouped" TTWA and rural/urban divide
rename ttwa TTWA
sort TTWA
merge m:m TTWA using "$geodata\ruralgroup_urban_ttwa_updated.dta"
tab _merge
drop if _merge==2
drop _merge
count if TTWA!=.

**************************
*codebook ttwa_2001 area_code
drop allemp weight thiswv refwkm secj rethed student hhold hoh age l1 l2 l3 ward982 ward98
gen new_area_name=ttwa_name if  area_name=="Urban"

replace new_area_name=area_name if  area_name!="Urban"
gen urban=1 if  area_name=="Urban"
replace urban=0 if  area_code!=. &  area_name!="Urban"
tab urban, m
count

***************************
drop TTWA
gen TTWA= area_code
codebook TTWA
sort TTWA
rename  ttwa_name TTWA_name

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
tab TTWA, m
tab TTWA, nol

drop  area_name area_code new_area_name TTWA_name
order id remserno quota persno year qr TTWA urban sic92_3d sic92_1d soc_3d soc_1d

******************************** 
compress
save "$temp\panel_allqr_clean.dta", replace
********************************

use "$temp\panel_allqr_clean.dta", clear

*----focus on manufacturing
keep if sic92_3d>=151 & sic92_3d<=372
sum id soc_3d sic92_3d
keep if urban==1

rename soc_3d soc3d
rename sic92_3d sic3d

*---- Drop tobacco and aggregates some sectors; see manuscript for details
drop if sic3d==160
recode sic3d 183 182 181 = 182
recode sic3d 231 232 233 = 232
recode sic3d 247 246 = 246
recode sic3d 154 = 158
recode sic3d 265 = 266
recode sic3d 223 = 222

egen ind = group(sic3d)
sum ind
gen min_i=r(min)
gen max_i=r(max)

egen occ = group(soc3d)
sum occ
gen min_o=r(min)
gen max_o=r(max)

*----computing a measure of labour pooling
sort ind occ
by ind occ: egen nempl_soc_sic=count(id)
sort ind
by ind: egen nempl_sic=count(id)
gen s_oi = (nempl_soc_sic/nempl_sic)
sum  nempl_soc_sic nempl_sic s_oi


collapse (mean) s_oi nempl_soc_sic nempl_sic min_i max_i min_o max_o sic3d, by(ind occ)
reshape wide s_oi nempl_soc_sic nempl_sic sic3d, i(occ) j(ind)
compress

	local i=min_i
	while `i'<=max_i {
		replace s_oi`i'=0 if s_oi`i'==.
		replace nempl_sic`i'=0 if nempl_sic`i'==.
		replace nempl_soc_sic`i'=0 if nempl_soc_sic`i'==.
		egen a=max(sic3d`i')
		replace sic3d`i'=a if sic3d`i'==.
		drop a
	local i = `i'+1
	}
	
	
	local i=min_i
		while `i'<=max_i-1 {
			local j=`i'+1 
			while `j'<=max_i {
			gen lab`i'`j'=abs(s_oi`i'-s_oi`j')
			egen double slab`i'`j' = sum(lab`i'`j')
			pwcorr s_oi`i' s_oi`j'
			matrix accum R`i'`j' = s_oi`i' s_oi`j', nocons dev
			matrix R`i'`j' = corr(R`i'`j')
			gen c`i'`j'=el(R`i'`j',2,1)
			egen sec`i'`j'=concat(sic3d`i' sic3d`j'), punct("_")
			local j = `j'+1
			}
	drop s_oi`i' nempl_soc_sic`i' nempl_sic`i' sic3d`i'
	local i = `i'+1
	}	

drop s_oi* lab* nempl_soc_sic* nempl_sic* sic3d* min* max*

gen n=_n
sum n
keep if n==1
drop n

reshape long sec slab c, i(occ) j(sic)
drop occ
order sec c slab

gen l_sim = 1/(0.5*slab)

sort sec
save "$output\lab_pool9599.dta", replace

