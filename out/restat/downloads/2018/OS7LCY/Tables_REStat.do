clear all
set more off
cap log close

set mem 10000m
set matsize 11000
set maxvar 32767

*NOTE: Table 1b, Table 7a (columns 1, 2, 3, 4, and 6), and Table 7b (columns 1, 2, 3, 4, and 6) showing results for the second generation (children of the generation affected in utero) are presented below all results/descriptive statistics for the first generation

*Data for first generation
use "/home/aline/Radioactive downfall/data/data_REStat_Gen1", clear
*Table 1a: Summary statistics
*men 20km sample
preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/

sum fhs mhs unemp yob cs_bc34 csluft_bc34_norain normal_iq hgt eduy hs_completed pearn35 if female==0
*For Table 1b
sum normal_iq if female==0 & soninsample==1
restore
*all men
sum fhs mhs unemp yob cs_bc34 csluft_bc34_norain normal_iq hgt eduy hs_completed pearn35 if female==0

*women 20km sample
preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/

sum fhs mhs unemp yob cs_bc34 csluft_bc34_norain normal_iq hgt eduy hs_completed pearn35 if female==1
restore
*all women
sum fhs mhs unemp yob cs_bc34 csluft_bc34_norain normal_iq hgt eduy hs_completed pearn35 if female==1

*Table 2
preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/
*keep men
keep if female==0

eststo clear
local tabname ""Table 2""
local mtitle1 ""Baseline (in situ)""
local mtitle2 ""Time Trends (in situ)""
local mtitle3 ""Fully Saturated (in situ)""
local mtitle4 ""Sibling FE (in situ)""
local mtitle5 ""Baseline (air)""
local mtitle6 ""Time Trends (air)""
local mtitle7 ""Fully Saturated (air)""
local mtitle8 ""Sibling FE (air)""

eststo est1: xi: reg normal_iq cs_bb12 cs_bb11 cs_bb10 cs_bb9 cs_bb8 cs_bb7 cs_bb6 cs_bb5 cs_bb4 cs_bb3 cs_bb2 cs_bb1 cs_0 cs_ab1 cs_ab2 cs_ab3 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est2: xi: reg normal_iq cs_bb12 cs_bb11 cs_bb10 cs_bb9 cs_bb8 cs_bb7 cs_bb6 cs_bb5 cs_bb4 cs_bb3 cs_bb2 cs_bb1 cs_0 cs_ab1 cs_ab2 cs_ab3 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun i.mummun*t, cluster(mummun)
eststo est3: xi: reg normal_iq cs_bb12 cs_bb11 cs_bb10 cs_bb9 cs_bb8 cs_bb7 cs_bb6 cs_bb5 cs_bb4 cs_bb3 cs_bb2 cs_bb1 cs_0 cs_ab1 cs_ab2 cs_ab3 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun i.yob*i.mummun i.mob*i.mummun, cluster(mummun)
*xtset: mothers giving birth in same municipality
g mpid_muni=mpid*10000+mummun
sort mpid_muni yob
xtset mpid_muni
sort mummun
eststo est4: xi: xtreg normal_iq cs_bb12 cs_bb11 cs_bb10 cs_bb9 cs_bb8 cs_bb7 cs_bb6 cs_bb5 cs_bb4 cs_bb3 cs_bb2 cs_bb1 cs_0 cs_ab1 cs_ab2 cs_ab3 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, vce(cluster mummun)
#delimit ; 
	esttab est1 est2 est3 est4   
	using table2-1, replace 
	cells(b(star fmt (%12.3f))   se (fmt (%12.3f))  ) 
	title(`tabname')
	starlevel(* 0.10 ** 0.05 *** 0.01)
	label
	keep(cs_bb12 cs_bb11 cs_bb10 cs_bb9 cs_bb8 cs_bb7 cs_bb6 cs_bb5 cs_bb4 cs_bb3 cs_bb2 cs_bb1 cs_0 cs_ab1 cs_ab2 cs_ab3)
	compress
	booktabs
	style(tab) 
	
	;
#delimit cr

eststo est5: xi: reg normal_iq csluft_norain_bb12 csluft_norain_bb11 csluft_norain_bb10 csluft_norain_bb9 csluft_norain_bb8 csluft_norain_bb7 csluft_norain_bb6 csluft_norain_bb5 csluft_norain_bb4 csluft_norain_bb3 csluft_norain_bb2 csluft_norain_bb1 csluft_norain_0 csluft_norain_ab1 csluft_norain_ab2 csluft_norain_ab3 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est6: xi: reg normal_iq csluft_norain_bb12 csluft_norain_bb11 csluft_norain_bb10 csluft_norain_bb9 csluft_norain_bb8 csluft_norain_bb7 csluft_norain_bb6 csluft_norain_bb5 csluft_norain_bb4 csluft_norain_bb3 csluft_norain_bb2 csluft_norain_bb1 csluft_norain_0 csluft_norain_ab1 csluft_norain_ab2 csluft_norain_ab3 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun i.mummun*t, cluster(mummun)
eststo est7: xi: reg normal_iq csluft_norain_bb12 csluft_norain_bb11 csluft_norain_bb10 csluft_norain_bb9 csluft_norain_bb8 csluft_norain_bb7 csluft_norain_bb6 csluft_norain_bb5 csluft_norain_bb4 csluft_norain_bb3 csluft_norain_bb2 csluft_norain_bb1 csluft_norain_0 csluft_norain_ab1 csluft_norain_ab2 csluft_norain_ab3 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun i.yob*i.mummun i.mob*i.mummun, cluster(mummun)
eststo est8: xi: xtreg normal_iq csluft_norain_bb12 csluft_norain_bb11 csluft_norain_bb10 csluft_norain_bb9 csluft_norain_bb8 csluft_norain_bb7 csluft_norain_bb6 csluft_norain_bb5 csluft_norain_bb4 csluft_norain_bb3 csluft_norain_bb2 csluft_norain_bb1 csluft_norain_0 csluft_norain_ab1 csluft_norain_ab2 csluft_norain_ab3 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, vce(cluster mummun)
#delimit ; 
	esttab est5 est6 est7 est8  
	using table2-2, replace 
	cells(b(star fmt (%12.3f))   se (fmt (%12.3f))  ) 
	title(`tabname')
	starlevel(* 0.10 ** 0.05 *** 0.01)
	label
	keep(csluft_norain_bb12 csluft_norain_bb11 csluft_norain_bb10 csluft_norain_bb9 csluft_norain_bb8 csluft_norain_bb7 csluft_norain_bb6 csluft_norain_bb5 csluft_norain_bb4 csluft_norain_bb3 csluft_norain_bb2 csluft_norain_bb1 csluft_norain_0 csluft_norain_ab1 csluft_norain_ab2 csluft_norain_ab3)
	compress
	booktabs
	style(tab) 
	
	;
#delimit cr
restore
*Note: multiple hypothesis tests are in the end of the do-file

*Table 3a
preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/
*keep men
keep if female==0

eststo clear
local tabname ""Table 3a""
local mtitle1 ""IQ""
local mtitle2 ""Height""
local mtitle3 ""Years of education""
local mtitle4 ""High School""
local mtitle5 ""Log earnings""
local mtitle6 ""Years of education""
local mtitle7 ""High School""
local mtitle8 ""Log earnings""

eststo est1: xi: reg normal_iq cs_bb12 cs_bb11 cs_bb10 cs_bb9 cs_bb8 cs_bb7 cs_bb6 cs_bb5 cs_bb4 cs_bb3 cs_bb2 cs_bb1 cs_0 cs_ab1 cs_ab2 cs_ab3 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est2: xi: reg hgt cs_bb12 cs_bb11 cs_bb10 cs_bb9 cs_bb8 cs_bb7 cs_bb6 cs_bb5 cs_bb4 cs_bb3 cs_bb2 cs_bb1 cs_0 cs_ab1 cs_ab2 cs_ab3 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est3: xi: reg eduy cs_bb12 cs_bb11 cs_bb10 cs_bb9 cs_bb8 cs_bb7 cs_bb6 cs_bb5 cs_bb4 cs_bb3 cs_bb2 cs_bb1 cs_0 cs_ab1 cs_ab2 cs_ab3 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est4: xi: reg hs_completed cs_bb12 cs_bb11 cs_bb10 cs_bb9 cs_bb8 cs_bb7 cs_bb6 cs_bb5 cs_bb4 cs_bb3 cs_bb2 cs_bb1 cs_0 cs_ab1 cs_ab2 cs_ab3 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est5: xi: reg lnpearn35 cs_bb12 cs_bb11 cs_bb10 cs_bb9 cs_bb8 cs_bb7 cs_bb6 cs_bb5 cs_bb4 cs_bb3 cs_bb2 cs_bb1 cs_0 cs_ab1 cs_ab2 cs_ab3 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
restore

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/
*keep women
keep if female==1

eststo est6: xi: reg eduy cs_bb12 cs_bb11 cs_bb10 cs_bb9 cs_bb8 cs_bb7 cs_bb6 cs_bb5 cs_bb4 cs_bb3 cs_bb2 cs_bb1 cs_0 cs_ab1 cs_ab2 cs_ab3 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est7: xi: reg hs_completed cs_bb12 cs_bb11 cs_bb10 cs_bb9 cs_bb8 cs_bb7 cs_bb6 cs_bb5 cs_bb4 cs_bb3 cs_bb2 cs_bb1 cs_0 cs_ab1 cs_ab2 cs_ab3 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est8: xi: reg lnpearn35 cs_bb12 cs_bb11 cs_bb10 cs_bb9 cs_bb8 cs_bb7 cs_bb6 cs_bb5 cs_bb4 cs_bb3 cs_bb2 cs_bb1 cs_0 cs_ab1 cs_ab2 cs_ab3 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
#delimit ; 
	esttab est1 est2 est3 est4 est5 est6 est7 est8 
	using table3a, replace 
	cells(b(star fmt (%12.3f))   se (fmt (%12.3f))  ) 
	title(`tabname')
	starlevel(* 0.10 ** 0.05 *** 0.01)
	label
	keep(cs_bb12 cs_bb11 cs_bb10 cs_bb9 cs_bb8 cs_bb7 cs_bb6 cs_bb5 cs_bb4 cs_bb3 cs_bb2 cs_bb1 cs_0 cs_ab1 cs_ab2 cs_ab3)
	compress
	booktabs
	style(tab) 
	
	;
#delimit cr
restore

*Table 3b
preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/
*keep men
keep if female==0

eststo clear
local tabname ""Table 3b""
local mtitle1 ""IQ""
local mtitle2 ""Height""
local mtitle3 ""Years of education""
local mtitle4 ""High School""
local mtitle5 ""Log earnings""
local mtitle6 ""Years of education""
local mtitle7 ""High School""
local mtitle8 ""Log earnings""

eststo est1: xi: reg normal_iq csluft_norain_bb12 csluft_norain_bb11 csluft_norain_bb10 csluft_norain_bb9 csluft_norain_bb8 csluft_norain_bb7 csluft_norain_bb6 csluft_norain_bb5 csluft_norain_bb4 csluft_norain_bb3 csluft_norain_bb2 csluft_norain_bb1 csluft_norain_0 csluft_norain_ab1 csluft_norain_ab2 csluft_norain_ab3 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est2: xi: reg hgt csluft_norain_bb12 csluft_norain_bb11 csluft_norain_bb10 csluft_norain_bb9 csluft_norain_bb8 csluft_norain_bb7 csluft_norain_bb6 csluft_norain_bb5 csluft_norain_bb4 csluft_norain_bb3 csluft_norain_bb2 csluft_norain_bb1 csluft_norain_0 csluft_norain_ab1 csluft_norain_ab2 csluft_norain_ab3 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est3: xi: reg eduy csluft_norain_bb12 csluft_norain_bb11 csluft_norain_bb10 csluft_norain_bb9 csluft_norain_bb8 csluft_norain_bb7 csluft_norain_bb6 csluft_norain_bb5 csluft_norain_bb4 csluft_norain_bb3 csluft_norain_bb2 csluft_norain_bb1 csluft_norain_0 csluft_norain_ab1 csluft_norain_ab2 csluft_norain_ab3 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est4: xi: reg hs_completed csluft_norain_bb12 csluft_norain_bb11 csluft_norain_bb10 csluft_norain_bb9 csluft_norain_bb8 csluft_norain_bb7 csluft_norain_bb6 csluft_norain_bb5 csluft_norain_bb4 csluft_norain_bb3 csluft_norain_bb2 csluft_norain_bb1 csluft_norain_0 csluft_norain_ab1 csluft_norain_ab2 csluft_norain_ab3 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est5: xi: reg lnpearn35 csluft_norain_bb12 csluft_norain_bb11 csluft_norain_bb10 csluft_norain_bb9 csluft_norain_bb8 csluft_norain_bb7 csluft_norain_bb6 csluft_norain_bb5 csluft_norain_bb4 csluft_norain_bb3 csluft_norain_bb2 csluft_norain_bb1 csluft_norain_0 csluft_norain_ab1 csluft_norain_ab2 csluft_norain_ab3 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
restore

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/
*keep women
keep if female==1

eststo est6: xi: reg eduy csluft_norain_bb12 csluft_norain_bb11 csluft_norain_bb10 csluft_norain_bb9 csluft_norain_bb8 csluft_norain_bb7 csluft_norain_bb6 csluft_norain_bb5 csluft_norain_bb4 csluft_norain_bb3 csluft_norain_bb2 csluft_norain_bb1 csluft_norain_0 csluft_norain_ab1 csluft_norain_ab2 csluft_norain_ab3 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est7: xi: reg hs_completed csluft_norain_bb12 csluft_norain_bb11 csluft_norain_bb10 csluft_norain_bb9 csluft_norain_bb8 csluft_norain_bb7 csluft_norain_bb6 csluft_norain_bb5 csluft_norain_bb4 csluft_norain_bb3 csluft_norain_bb2 csluft_norain_bb1 csluft_norain_0 csluft_norain_ab1 csluft_norain_ab2 csluft_norain_ab3 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est8: xi: reg lnpearn35 csluft_norain_bb12 csluft_norain_bb11 csluft_norain_bb10 csluft_norain_bb9 csluft_norain_bb8 csluft_norain_bb7 csluft_norain_bb6 csluft_norain_bb5 csluft_norain_bb4 csluft_norain_bb3 csluft_norain_bb2 csluft_norain_bb1 csluft_norain_0 csluft_norain_ab1 csluft_norain_ab2 csluft_norain_ab3 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
#delimit ; 
	esttab est1 est2 est3 est4 est5 est6 est7 est8 
	using table3b, replace 
	cells(b(star fmt (%12.3f))   se (fmt (%12.3f))  ) 
	title(`tabname')
	starlevel(* 0.10 ** 0.05 *** 0.01)
	label
	keep(csluft_norain_bb12 csluft_norain_bb11 csluft_norain_bb10 csluft_norain_bb9 csluft_norain_bb8 csluft_norain_bb7 csluft_norain_bb6 csluft_norain_bb5 csluft_norain_bb4 csluft_norain_bb3 csluft_norain_bb2 csluft_norain_bb1 csluft_norain_0 csluft_norain_ab1 csluft_norain_ab2 csluft_norain_ab3)
	compress
	booktabs
	style(tab) 
	
	;
#delimit cr
restore


*Table 4
egen ground1=pctile(cs_bc34), p(20)
egen ground2=pctile(cs_bc34), p(40)
egen ground3=pctile(cs_bc34), p(60)
egen ground4=pctile(cs_bc34), p(80)

g cs_q1=cs_bc34<=ground1
g cs_q2=cs_bc34>ground1 & cs_bc34<=ground2
g cs_q3=cs_bc34>ground2 & cs_bc34<=ground3
g cs_q4=cs_bc34>ground3 & cs_bc34<=ground4
g cs_q5=cs_bc34>ground4

egen air1=pctile(csluft_bc34_norain), p(20)
egen air2=pctile(csluft_bc34_norain), p(40)
egen air3=pctile(csluft_bc34_norain), p(60)
egen air4=pctile(csluft_bc34_norain), p(80)

g csluft_q1=csluft_bc34_norain<=air1
g csluft_q2=csluft_bc34_norain>air1 & csluft_bc34_norain<=air2
g csluft_q3=csluft_bc34_norain>air2 & csluft_bc34_norain<=air3
g csluft_q4=csluft_bc34_norain>air3 & csluft_bc34_norain<=air4
g csluft_q5=csluft_bc34_norain>air4

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/
*keep men
keep if female==0

eststo clear
local tabname ""Table 4""
local mtitle1 ""IQ""
local mtitle2 ""Height""
local mtitle3 ""Years of education""
local mtitle4 ""High School""
local mtitle5 ""Log earnings""
local mtitle6 ""Years of education""
local mtitle7 ""High School""
local mtitle8 ""Log earnings""

eststo est1: xi: reg normal_iq cs_q2 cs_q3 cs_q4 cs_q5 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est2: xi: reg hgt cs_q2 cs_q3 cs_q4 cs_q5 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est3: xi: reg eduy cs_q2 cs_q3 cs_q4 cs_q5 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est4: xi: reg hs_completed cs_q2 cs_q3 cs_q4 cs_q5 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est5: xi: reg lnpearn35 cs_q2 cs_q3 cs_q4 cs_q5 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
restore

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/
*keep women
keep if female==1

eststo est6: xi: reg eduy cs_q2 cs_q3 cs_q4 cs_q5 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est7: xi: reg hs_completed cs_q2 cs_q3 cs_q4 cs_q5 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est8: xi: reg lnpearn35 cs_q2 cs_q3 cs_q4 cs_q5 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
#delimit ; 
	esttab est1 est2 est3 est4 est5 est6 est7 est8
	using table4-1, replace 
	cells(b(star fmt (%12.3f))   se (fmt (%12.3f))  ) 
	title(`tabname')
	starlevel(* 0.10 ** 0.05 *** 0.01)
	label
	keep(cs_q2 cs_q3 cs_q4 cs_q5)
	compress
	booktabs
	style(tab) 
	
	;
#delimit cr
restore

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/
*keep men
keep if female==0

eststo clear
local tabname ""Table 4""
local mtitle1 ""IQ""
local mtitle2 ""Height""
local mtitle3 ""Years of education""
local mtitle4 ""High School""
local mtitle5 ""Log earnings""
local mtitle6 ""Years of education""
local mtitle7 ""High School""
local mtitle8 ""Log earnings""

eststo est1: xi: reg normal_iq csluft_q2 csluft_q3 csluft_q4 csluft_q5 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est2: xi: reg hgt csluft_q2 csluft_q3 csluft_q4 csluft_q5 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est3: xi: reg eduy csluft_q2 csluft_q3 csluft_q4 csluft_q5 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est4: xi: reg hs_completed csluft_q2 csluft_q3 csluft_q4 csluft_q5 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est5: xi: reg lnpearn35 csluft_q2 csluft_q3 csluft_q4 csluft_q5 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
restore

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/
*keep women
keep if female==1

eststo est6: xi: reg eduy csluft_q2 csluft_q3 csluft_q4 csluft_q5 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est7: xi: reg hs_completed csluft_q2 csluft_q3 csluft_q4 csluft_q5 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est8: xi: reg lnpearn35 csluft_q2 csluft_q3 csluft_q4 csluft_q5 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
#delimit ; 
	esttab est1 est2 est3 est4 est5 est6 est7 est8
	using table4-2, replace 
	cells(b(star fmt (%12.3f))   se (fmt (%12.3f))  ) 
	title(`tabname')
	starlevel(* 0.10 ** 0.05 *** 0.01)
	label
	keep(csluft_q2 csluft_q3 csluft_q4 csluft_q5)
	compress
	booktabs
	style(tab) 
	
	;
#delimit cr
restore


*Table 5
*summer (during months 3 or 4 post-conception)
g summer=0
replace summer=1 if mob>=1 & mob<=3
replace summer=1 if mob>=9 & mob<=12

g summer_ground=summer*cs_bc34
g summer_air=summer*csluft_bc34_norain

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/
*keep men
keep if female==0

eststo clear
local tabname ""Table 5""
local mtitle1 ""IQ""
local mtitle2 ""Height""
local mtitle3 ""Years of education""
local mtitle4 ""High School""
local mtitle5 ""Log earnings""
local mtitle6 ""Years of education""
local mtitle7 ""High School""
local mtitle8 ""Log earnings""

eststo est1: xi: reg normal_iq cs_bc34 summer summer_ground b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est2: xi: reg hgt cs_bc34 summer summer_ground b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est3: xi: reg eduy cs_bc34 summer summer_ground b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est4: xi: reg hs_completed cs_bc34 summer summer_ground b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est5: xi: reg lnpearn35 cs_bc34 summer summer_ground b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
restore

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/
*keep women
keep if female==1

eststo est6: xi: reg eduy cs_bc34 summer summer_ground b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est7: xi: reg hs_completed cs_bc34 summer summer_ground b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est8: xi: reg lnpearn35 cs_bc34 summer summer_ground b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
#delimit ; 
	esttab est1 est2 est3 est4 est5 est6 est7 est8
	using table5-1, replace 
	cells(b(star fmt (%12.3f))   se (fmt (%12.3f))  ) 
	title(`tabname')
	starlevel(* 0.10 ** 0.05 *** 0.01)
	label
	keep(cs_bc34 summer summer_ground)
	compress
	booktabs
	style(tab) 
	
	;
#delimit cr
restore


preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/
*keep men
keep if female==0


eststo clear
local tabname ""Table 5""
local mtitle1 ""IQ""
local mtitle2 ""Height""
local mtitle3 ""Years of education""
local mtitle4 ""High School""
local mtitle5 ""Log earnings""
local mtitle6 ""Years of education""
local mtitle7 ""High School""
local mtitle8 ""Log earnings""

eststo est1: xi: reg normal_iq csluft_bc34_norain summer summer_air b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est2: xi: reg hgt csluft_bc34_norain summer summer_air b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est3: xi: reg eduy csluft_bc34_norain summer summer_air b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est4: xi: reg hs_completed csluft_bc34_norain summer summer_air b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est5: xi: reg lnpearn35 csluft_bc34_norain summer summer_air b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
restore

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/
*keep women
keep if female==1

eststo est6: xi: reg eduy csluft_bc34_norain summer summer_air b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est7: xi: reg hs_completed csluft_bc34_norain summer summer_air b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est8: xi: reg lnpearn35 csluft_bc34_norain summer summer_air b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
#delimit ; 
	esttab est1 est2 est3 est4 est5 est6 est7 est8
	using table5-2, replace 
	cells(b(star fmt (%12.3f))   se (fmt (%12.3f))  ) 
	title(`tabname')
	starlevel(* 0.10 ** 0.05 *** 0.01)
	label
	keep(csluft_bc34_norain summer summer_air)
	compress
	booktabs
	style(tab) 
	;
#delimit cr
restore


*Table 6
g mhs_ground=mhs*cs_bc34
g mhs_air=mhs*csluft_bc34_norain

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/
*keep men
keep if female==0


eststo clear
local tabname ""Table 6""
local mtitle1 ""IQ""
local mtitle2 ""Height""
local mtitle3 ""Years of education""
local mtitle4 ""High School""
local mtitle5 ""Log earnings""
local mtitle6 ""Years of education""
local mtitle7 ""High School""
local mtitle8 ""Log earnings""

eststo est1: xi: reg normal_iq cs_bc34 mhs_ground b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est2: xi: reg hgt cs_bc34 mhs_ground b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est3: xi: reg eduy cs_bc34 mhs_ground b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est4: xi: reg hs_completed cs_bc34 mhs_ground b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est5: xi: reg lnpearn35 cs_bc34 mhs_ground b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
restore

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/
*keep women
keep if female==1

eststo est6: xi: reg eduy cs_bc34 mhs_ground b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est7: xi: reg hs_completed cs_bc34 mhs_ground b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est8: xi: reg lnpearn35 cs_bc34 mhs_ground b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
#delimit ; 
	esttab est1 est2 est3 est4 est5 est6 est7 est8
	using table6-1, replace 
	cells(b(star fmt (%12.3f))   se (fmt (%12.3f))  ) 
	title(`tabname')
	starlevel(* 0.10 ** 0.05 *** 0.01)
	label
	keep(cs_bc34 mhs mhs_ground)
	compress
	booktabs
	style(tab) 
	;
#delimit cr
restore


preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/
*keep men
keep if female==0

eststo clear
local tabname ""Table 6""
local mtitle1 ""IQ""
local mtitle2 ""Height""
local mtitle3 ""Years of education""
local mtitle4 ""High School""
local mtitle5 ""Log earnings""
local mtitle6 ""Years of education""
local mtitle7 ""High School""
local mtitle8 ""Log earnings""

eststo est1: xi: reg normal_iq csluft_bc34_norain mhs_air b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est2: xi: reg hgt csluft_bc34_norain mhs_air b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est3: xi: reg eduy csluft_bc34_norain mhs_air b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est4: xi: reg hs_completed csluft_bc34_norain mhs_air b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est5: xi: reg lnpearn35 csluft_bc34_norain mhs_air b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
restore

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/
*keep women
keep if female==1

eststo est6: xi: reg eduy csluft_bc34_norain mhs_air b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est7: xi: reg hs_completed csluft_bc34_norain mhs_air b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
eststo est8: xi: reg lnpearn35 csluft_bc34_norain mhs_air b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
#delimit ; 
	esttab est1 est2 est3 est4 est5 est6 est7 est8
	using table6-2, replace 
	cells(b(star fmt (%12.3f))   se (fmt (%12.3f))  ) 
	title(`tabname')
	starlevel(* 0.10 ** 0.05 *** 0.01)
	label
	keep(csluft_bc34_norain mhs mhs_air)
	compress
	booktabs
	style(tab) 
	;
#delimit cr
restore

*Table 7a Column 3
preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/
*keep men
keep if female==0
keep if soninsample==1

eststo clear
local tabname ""Table 7a""
local mtitle1 ""IQ""

eststo est1: xi: reg normal_iq cs_bb12 cs_bb11 cs_bb10 cs_bb9 cs_bb8 cs_bb7 cs_bb6 cs_bb5 cs_bb4 cs_bb3 cs_bb2 cs_bb1 cs_0 cs_ab1 cs_ab2 cs_ab3 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
#delimit ; 
	esttab est1 
	using table7a-C3, replace 
	cells(b(star fmt (%12.3f))   se (fmt (%12.3f))  ) 
	title(`tabname')
	starlevel(* 0.10 ** 0.05 *** 0.01)
	label
	keep(cs_bb12 cs_bb11 cs_bb10 cs_bb9 cs_bb8 cs_bb7 cs_bb6 cs_bb5 cs_bb4 cs_bb3 cs_bb2 cs_bb1 cs_0 cs_ab1 cs_ab2 cs_ab3)
	compress
	booktabs
	style(tab) 
	
	;
#delimit cr

*Table 7b Column 3
eststo clear
local tabname ""Table 7b""
local mtitle1 ""IQ""

eststo est1: xi: reg normal_iq csluft_norain_bb12 csluft_norain_bb11 csluft_norain_bb10 csluft_norain_bb9 csluft_norain_bb8 csluft_norain_bb7 csluft_norain_bb6 csluft_norain_bb5 csluft_norain_bb4 csluft_norain_bb3 csluft_norain_bb2 csluft_norain_bb1 csluft_norain_0 csluft_norain_ab1 csluft_norain_ab2 csluft_norain_ab3 b_order2 b_order3 b_order4 b_order5 i.yob*i.mob unemp fhs mhs i.mummun, cluster(mummun)
#delimit ; 
	esttab est1 
	using table7b-C3, replace 
	cells(b(star fmt (%12.3f))   se (fmt (%12.3f))  ) 
	title(`tabname')
	starlevel(* 0.10 ** 0.05 *** 0.01)
	label
	keep(csluft_norain_bb12 csluft_norain_bb11 csluft_norain_bb10 csluft_norain_bb9 csluft_norain_bb8 csluft_norain_bb7 csluft_norain_bb6 csluft_norain_bb5 csluft_norain_bb4 csluft_norain_bb3 csluft_norain_bb2 csluft_norain_bb1 csluft_norain_0 csluft_norain_ab1 csluft_norain_ab2 csluft_norain_ab3)
	compress
	booktabs
	style(tab) 
	
	;
#delimit cr
restore


************** 2. generation data 

*Data for first generation
use "/home/aline/Radioactive downfall/data/data_REStat_Gen2", clear
*Table 1b: Summary statistics

*keep male offspring only
keep if sex==1

preserve
*keep municipalities of birth of father within a 20km range
keep if f_close==1
*keep birth cohort of father in main sample
keep if f_period==1
keep if yob<1993
sum ff_hs fm_hs f_unemp f_yob yob famsize f_ground_b7 f_air_b7 iq_norm if iq_norm!=. & f_ground_b7!=.
restore

preserve
*keep municipalities of birth of father within a 20km range
keep if m_close==1
*keep birth cohort of father in main sample
keep if m_period==1
keep if yob<1993
sum mf_hs mm_hs m_unemp m_yob yob famsize m_ground_b7 m_air_b7 iq_norm if iq_norm!=. & m_ground_b7!=.
restore

*Table 7a
preserve
*keep municipalities of birth of father within a 20km range
keep if f_close==1
*keep birth cohort of father in main sample
keep if f_period==1

eststo clear
local tabname ""Table 7a Columns 1 2 4 5 6""
local mtitle1 ""IQ""
local mtitle2 ""IQ with controls""
eststo est1: xi: reg iq_norm f_ground_b12 f_ground_b11 f_ground_b10 f_ground_b9 f_ground_b8 f_ground_b7 f_ground_b6 f_ground_b5 f_ground_b4 f_ground_b3 f_ground_b2 f_ground_b1 f_ground_b0 f_ground_a1 f_ground_a2 f_ground_a3 i.f_yob*i.f_mob i.f_muni ff_hs mf_hs f_border1 f_border2 f_border3 f_border4 f_border5 f_unemp if sex==1 [pweight=n], cluster(f_muni)
eststo est2: xi: reg iq_norm f_ground_b12 f_ground_b11 f_ground_b10 f_ground_b9 f_ground_b8 f_ground_b7 f_ground_b6 f_ground_b5 f_ground_b4 f_ground_b3 f_ground_b2 f_ground_b1 f_ground_b0 f_ground_a1 f_ground_a2 f_ground_a3 i.f_yob*i.f_mob i.f_muni ff_hs mf_hs f_border1 f_border2 f_border3 f_border4 f_border5 f_unemp border1 border2 border3 border4 border5 famsize1 famsize2 famsize3 famsize4 famsize5 f_iq f_edu i.yob i.mob if sex==1 [pweight=n], cluster(f_muni)
restore

preserve
*keep municipalities of birth of mother within a 20km range
keep if m_close==1
*keep birth cohort of mother in main sample
keep if m_period==1

local mtitle4 ""IQ""
local mtitle5 ""IQ with controls""
eststo est4: xi: reg iq_norm m_ground_b12 m_ground_b11 m_ground_b10 m_ground_b9 m_ground_b8 m_ground_b7 m_ground_b6 m_ground_b5 m_ground_b4 m_ground_b3 m_ground_b2 m_ground_b1 m_ground_b0 m_ground_a1 m_ground_a2 m_ground_a3 i.m_yob*i.m_mob i.m_muni fm_hs mm_hs m_border1 m_border2 m_border3 m_border4 m_border5 m_unemp if sex==1 [pweight=n], cluster(m_muni)
eststo est5: xi: reg iq_norm m_ground_b12 m_ground_b11 m_ground_b10 m_ground_b9 m_ground_b8 m_ground_b7 m_ground_b6 m_ground_b5 m_ground_b4 m_ground_b3 m_ground_b2 m_ground_b1 m_ground_b0 m_ground_a1 m_ground_a2 m_ground_a3 i.m_yob*i.m_mob i.m_muni fm_hs mm_hs m_border1 m_border2 m_border3 m_border4 m_border5 m_unemp border1 border2 border3 border4 border5 famsize1 famsize2 famsize3 famsize4 famsize5 m_edu i.yob i.mob if sex==1 [pweight=n], cluster(m_muni)
restore

preserve
*keep municipalities of birth of both parents within a 20km range
keep if m_close==1 & f_close==1
*keep birth cohort of both parents in main sample
keep if m_period==1 & f_period==1

local mtitle6 ""IQ""
eststo est6: xi: reg iq_norm f_ground_b12 f_ground_b11 f_ground_b10 f_ground_b9 f_ground_b8 f_ground_b7 f_ground_b6 f_ground_b5 f_ground_b4 f_ground_b3 f_ground_b2 f_ground_b1 f_ground_b0 f_ground_a1 f_ground_a2 f_ground_a3 i.f_yob*i.f_mob i.f_muni ff_hs mf_hs f_border1 f_border2 f_border3 f_border4 f_border5 f_unemp m_ground_b12 m_ground_b11 m_ground_b10 m_ground_b9 m_ground_b8 m_ground_b7 m_ground_b6 m_ground_b5 m_ground_b4 m_ground_b3 m_ground_b2 m_ground_b1 m_ground_b0 m_ground_a1 m_ground_a2 m_ground_a3 i.m_yob*i.m_mob i.m_muni fm_hs mm_hs m_border1 m_border2 m_border3 m_border4 m_border5 m_unemp if sex==1 [pweight=n], cluster(m_muni)
restore

#delimit ; 
	esttab est1 est2 est4 est5 est6   
	using table7a, replace 
	cells(b(star fmt (%12.3f))   se (fmt (%12.3f))  ) 
	title(`tabname')
	starlevel(* 0.10 ** 0.05 *** 0.01)
	label
	keep(f_ground_b12 f_ground_b11 f_ground_b10 f_ground_b9 f_ground_b8 f_ground_b7 f_ground_b6 f_ground_b5 f_ground_b4 f_ground_b3 f_ground_b2 f_ground_b1 f_ground_b0 f_ground_a1 f_ground_a2 f_ground_a3 m_ground_b12 m_ground_b11 m_ground_b10 m_ground_b9 m_ground_b8 m_ground_b7 m_ground_b6 m_ground_b5 m_ground_b4 m_ground_b3 m_ground_b2 m_ground_b1 m_ground_b0 m_ground_a1 m_ground_a2 m_ground_a3)
	compress
	booktabs
	style(tab) 
	;
#delimit cr

*Table 7b
preserve
*keep municipalities of birth of father within a 20km range
keep if f_close==1
*keep birth cohort of father in main sample
keep if f_period==1

eststo clear
local tabname ""Table 7b Columns 1 2 4 5 6""
local mtitle1 ""IQ""
local mtitle2 ""IQ with controls""
eststo est1: xi: reg iq_norm f_air_b12 f_air_b11 f_air_b10 f_air_b9 f_air_b8 f_air_b7 f_air_b6 f_air_b5 f_air_b4 f_air_b3 f_air_b2 f_air_b1 f_air_b0 f_air_a1 f_air_a2 f_air_a3 i.f_yob*i.f_mob i.f_muni ff_hs mf_hs f_border1 f_border2 f_border3 f_border4 f_border5 f_unemp if sex==1 [pweight=n], cluster(f_muni)
eststo est2: xi: reg iq_norm f_air_b12 f_air_b11 f_air_b10 f_air_b9 f_air_b8 f_air_b7 f_air_b6 f_air_b5 f_air_b4 f_air_b3 f_air_b2 f_air_b1 f_air_b0 f_air_a1 f_air_a2 f_air_a3 i.f_yob*i.f_mob i.f_muni ff_hs mf_hs f_border1 f_border2 f_border3 f_border4 f_border5 f_unemp border1 border2 border3 border4 border5 famsize1 famsize2 famsize3 famsize4 famsize5 f_iq f_edu i.yob if sex==1 [pweight=n], cluster(f_muni)
restore

preserve
*keep municipalities of birth of mother within a 20km range
keep if m_close==1
*keep birth cohort of mother in main sample
keep if m_period==1

local mtitle4 ""IQ""
local mtitle5 ""IQ with controls""
eststo est4: xi: reg iq_norm m_air_b12 m_air_b11 m_air_b10 m_air_b9 m_air_b8 m_air_b7 m_air_b6 m_air_b5 m_air_b4 m_air_b3 m_air_b2 m_air_b1 m_air_b0 m_air_a1 m_air_a2 m_air_a3 i.m_yob*i.m_mob i.m_muni fm_hs mm_hs m_border1 m_border2 m_border3 m_border4 m_border5 m_unemp if sex==1 [pweight=n], cluster(m_muni)
eststo est5: xi: reg iq_norm m_air_b12 m_air_b11 m_air_b10 m_air_b9 m_air_b8 m_air_b7 m_air_b6 m_air_b5 m_air_b4 m_air_b3 m_air_b2 m_air_b1 m_air_b0 m_air_a1 m_air_a2 m_air_a3 i.m_yob*i.m_mob i.m_muni fm_hs mm_hs m_border1 m_border2 m_border3 m_border4 m_border5 m_unemp border1 border2 border3 border4 border5 famsize1 famsize2 famsize3 famsize4 famsize5 m_edu i.yob if sex==1 [pweight=n], cluster(m_muni)
restore

preserve
*keep municipalities of birth of both parents within a 20km range
keep if m_close==1 & f_close==1
*keep birth cohort of both parents in main sample
keep if m_period==1 & f_period==1

local mtitle6 ""IQ""
eststo est6: xi: reg iq_norm f_air_b12 f_air_b11 f_air_b10 f_air_b9 f_air_b8 f_air_b7 f_air_b6 f_air_b5 f_air_b4 f_air_b3 f_air_b2 f_air_b1 f_air_b0 f_air_a1 f_air_a2 f_air_a3 i.f_yob*i.f_mob i.f_muni ff_hs mf_hs f_border1 f_border2 f_border3 f_border4 f_border5 f_unemp m_air_b12 m_air_b11 m_air_b10 m_air_b9 m_air_b8 m_air_b7 m_air_b6 m_air_b5 m_air_b4 m_air_b3 m_air_b2 m_air_b1 m_air_b0 m_air_a1 m_air_a2 m_air_a3 i.m_yob*i.m_mob i.m_muni fm_hs mm_hs m_border1 m_border2 m_border3 m_border4 m_border5 m_unemp if sex==1 [pweight=n], cluster(m_muni)
restore

#delimit ; 
	esttab est1 est2 est4 est5 est6   
	using table7b, replace 
	cells(b(star fmt (%12.3f))   se (fmt (%12.3f))  ) 
	title(`tabname')
	starlevel(* 0.10 ** 0.05 *** 0.01)
	label
	keep(f_air_b12 f_air_b11 f_air_b10 f_air_b9 f_air_b8 f_air_b7 f_air_b6 f_air_b5 f_air_b4 f_air_b3 f_air_b2 f_air_b1 f_air_b0 f_air_a1 f_air_a2 f_air_a3 m_air_b12 m_air_b11 m_air_b10 m_air_b9 m_air_b8 m_air_b7 m_air_b6 m_air_b5 m_air_b4 m_air_b3 m_air_b2 m_air_b1 m_air_b0 m_air_a1 m_air_a2 m_air_a3)
	compress
	booktabs
	style(tab) 
	;
#delimit cr

********************Multiple hypothesis testing


*programme to do Romano-Wolf method for multiple hypothesis testing within one regression
*no monte carlo -- just generate data once

*Table 2
*Column 1
clear
set more off
cap log close
use  "/home/aline/Radioactive downfall/data/data_REStat_Gen1", clear

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/

*keep men
keep if female==0

rename cs_bb12 w16
rename cs_bb11 w15
rename cs_bb10 w14
rename cs_bb9 w13
rename cs_bb8 w12
rename cs_bb7 w11
rename cs_bb6 w10
rename cs_bb5 w9
rename cs_bb4 w8
rename cs_bb3 w7
rename cs_bb2 w6
rename cs_bb1 w5
rename cs_0 w4
rename cs_ab3 w1
rename cs_ab2 w2
rename cs_ab1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe normal_iq w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster mummun) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(mummun) idcluster(newgroup) : reghdfe normal_iq w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************
*Column 2
clear
set more off
cap log close
use  "/home/aline/Radioactive downfall/data/data_REStat_Gen1", clear

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/

*keep men
keep if female==0

rename cs_bb12 w16
rename cs_bb11 w15
rename cs_bb10 w14
rename cs_bb9 w13
rename cs_bb8 w12
rename cs_bb7 w11
rename cs_bb6 w10
rename cs_bb5 w9
rename cs_bb4 w8
rename cs_bb3 w7
rename cs_bb2 w6
rename cs_bb1 w5
rename cs_0 w4
rename cs_ab3 w1
rename cs_ab2 w2
rename cs_ab1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe normal_iq w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob i.mummun*t, absorb(mummun) vce(cluster mummun) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(mummun) idcluster(newgroup) : reghdfe normal_iq w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob i.mummun*t, absorb(mummun) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************
*Column 3
clear
set more off
cap log close
use  "/home/aline/Radioactive downfall/data/data_REStat_Gen1", clear

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/

*keep men
keep if female==0

rename cs_bb12 w16
rename cs_bb11 w15
rename cs_bb10 w14
rename cs_bb9 w13
rename cs_bb8 w12
rename cs_bb7 w11
rename cs_bb6 w10
rename cs_bb5 w9
rename cs_bb4 w8
rename cs_bb3 w7
rename cs_bb2 w6
rename cs_bb1 w5
rename cs_0 w4
rename cs_ab3 w1
rename cs_ab2 w2
rename cs_ab1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe normal_iq w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob i.yob*i.mummun i.mob*i.mummun, absorb(mummun) vce(cluster mummun) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(mummun) idcluster(newgroup) : reghdfe normal_iq w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob i.yob*i.mummun i.mob*i.mummun, absorb(mummun) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace


********************************************************************************
*Column 4
clear
set more off
cap log close
use  "/home/aline/Radioactive downfall/data/data_REStat_Gen1", clear

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/

*keep men
keep if female==0

*xtset: mothers giving birth in same municipality
g mpid_muni=mpid*10000+mummun
sort mpid_muni yob
xtset mpid_muni

rename cs_bb12 w16
rename cs_bb11 w15
rename cs_bb10 w14
rename cs_bb9 w13
rename cs_bb8 w12
rename cs_bb7 w11
rename cs_bb6 w10
rename cs_bb5 w9
rename cs_bb4 w8
rename cs_bb3 w7
rename cs_bb2 w6
rename cs_bb1 w5
rename cs_0 w4
rename cs_ab3 w1
rename cs_ab2 w2
rename cs_ab1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe normal_iq w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob i.mummun, absorb(mpid_muni) vce(cluster mummun) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(mummun) idcluster(newgroup) : reghdfe normal_iq w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob i.mummun, absorb(mpid_muni) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************

*Column 5
clear
set more off
cap log close
use  "/home/aline/Radioactive downfall/data/data_REStat_Gen1", clear

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/

*keep men
keep if female==0

rename csluft_norain_bb12 w16
rename csluft_norain_bb11 w15
rename csluft_norain_bb10 w14
rename csluft_norain_bb9 w13
rename csluft_norain_bb8 w12
rename csluft_norain_bb7 w11
rename csluft_norain_bb6 w10
rename csluft_norain_bb5 w9
rename csluft_norain_bb4 w8
rename csluft_norain_bb3 w7
rename csluft_norain_bb2 w6
rename csluft_norain_bb1 w5
rename csluft_norain_0 w4
rename csluft_norain_ab3 w1
rename csluft_norain_ab2 w2
rename csluft_norain_ab1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe normal_iq w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster mummun) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(mummun) idcluster(newgroup) : reghdfe normal_iq w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************
*Column 6
clear
set more off
cap log close
use  "/home/aline/Radioactive downfall/data/data_REStat_Gen1", clear

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/

*keep men
keep if female==0

rename csluft_norain_bb12 w16
rename csluft_norain_bb11 w15
rename csluft_norain_bb10 w14
rename csluft_norain_bb9 w13
rename csluft_norain_bb8 w12
rename csluft_norain_bb7 w11
rename csluft_norain_bb6 w10
rename csluft_norain_bb5 w9
rename csluft_norain_bb4 w8
rename csluft_norain_bb3 w7
rename csluft_norain_bb2 w6
rename csluft_norain_bb1 w5
rename csluft_norain_0 w4
rename csluft_norain_ab3 w1
rename csluft_norain_ab2 w2
rename csluft_norain_ab1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe normal_iq w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob i.mummun*t, absorb(mummun) vce(cluster mummun) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(mummun) idcluster(newgroup) : reghdfe normal_iq w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob i.mummun*t, absorb(mummun) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************
*Column 7
clear
set more off
cap log close
use  "/home/aline/Radioactive downfall/data/data_REStat_Gen1", clear

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/

*keep men
keep if female==0

rename csluft_norain_bb12 w16
rename csluft_norain_bb11 w15
rename csluft_norain_bb10 w14
rename csluft_norain_bb9 w13
rename csluft_norain_bb8 w12
rename csluft_norain_bb7 w11
rename csluft_norain_bb6 w10
rename csluft_norain_bb5 w9
rename csluft_norain_bb4 w8
rename csluft_norain_bb3 w7
rename csluft_norain_bb2 w6
rename csluft_norain_bb1 w5
rename csluft_norain_0 w4
rename csluft_norain_ab3 w1
rename csluft_norain_ab2 w2
rename csluft_norain_ab1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe normal_iq w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob i.yob*i.mummun i.mob*i.mummun, absorb(mummun) vce(cluster mummun) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(mummun) idcluster(newgroup) : reghdfe normal_iq w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob i.yob*i.mummun i.mob*i.mummun, absorb(mummun) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace


********************************************************************************
*Column 8
clear
set more off
cap log close
use  "/home/aline/Radioactive downfall/data/data_REStat_Gen1", clear

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/

*keep men
keep if female==0

*xtset: mothers giving birth in same municipality
g mpid_muni=mpid*10000+mummun
sort mpid_muni yob
xtset mpid_muni

rename csluft_norain_bb12 w16
rename csluft_norain_bb11 w15
rename csluft_norain_bb10 w14
rename csluft_norain_bb9 w13
rename csluft_norain_bb8 w12
rename csluft_norain_bb7 w11
rename csluft_norain_bb6 w10
rename csluft_norain_bb5 w9
rename csluft_norain_bb4 w8
rename csluft_norain_bb3 w7
rename csluft_norain_bb2 w6
rename csluft_norain_bb1 w5
rename csluft_norain_0 w4
rename csluft_norain_ab3 w1
rename csluft_norain_ab2 w2
rename csluft_norain_ab1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe normal_iq w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob i.mummun, absorb(mpid_muni) vce(cluster mummun) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(mummun) idcluster(newgroup) : reghdfe normal_iq w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob i.mummun, absorb(mpid_muni) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace
********************************************************************************

*Table 3a
*Column 1
clear
set more off
cap log close
use  "/home/aline/Radioactive downfall/data/data_REStat_Gen1", clear

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/

*keep men
keep if female==0

rename cs_bb12 w16
rename cs_bb11 w15
rename cs_bb10 w14
rename cs_bb9 w13
rename cs_bb8 w12
rename cs_bb7 w11
rename cs_bb6 w10
rename cs_bb5 w9
rename cs_bb4 w8
rename cs_bb3 w7
rename cs_bb2 w6
rename cs_bb1 w5
rename cs_0 w4
rename cs_ab3 w1
rename cs_ab2 w2
rename cs_ab1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe normal_iq w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster mummun) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(mummun) idcluster(newgroup) : reghdfe eduy w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************

*Column 2
clear
set more off
cap log close
use  "/home/aline/Radioactive downfall/data/data_REStat_Gen1", clear

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/

*keep men
keep if female==0

rename cs_bb12 w16
rename cs_bb11 w15
rename cs_bb10 w14
rename cs_bb9 w13
rename cs_bb8 w12
rename cs_bb7 w11
rename cs_bb6 w10
rename cs_bb5 w9
rename cs_bb4 w8
rename cs_bb3 w7R
rename cs_bb2 w6
rename cs_bb1 w5
rename cs_0 w4
rename cs_ab3 w1
rename cs_ab2 w2
rename cs_ab1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe hgt w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster mummun) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(mummun) idcluster(newgroup) : reghdfe hgt w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************

*Column 3
clear
set more off
cap log close
use  "/home/aline/Radioactive downfall/data/data_REStat_Gen1", clear

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/

*keep men
keep if female==0

rename cs_bb12 w16
rename cs_bb11 w15
rename cs_bb10 w14
rename cs_bb9 w13
rename cs_bb8 w12
rename cs_bb7 w11
rename cs_bb6 w10
rename cs_bb5 w9
rename cs_bb4 w8
rename cs_bb3 w7R
rename cs_bb2 w6
rename cs_bb1 w5
rename cs_0 w4
rename cs_ab3 w1
rename cs_ab2 w2
rename cs_ab1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe eduy w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster mummun) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(mummun) idcluster(newgroup) : reghdfe eduy w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************
*Column 4
clear
set more off
cap log close
use  "/home/aline/Radioactive downfall/data/data_REStat_Gen1", clear

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/

*keep men
keep if female==0

rename cs_bb12 w16
rename cs_bb11 w15
rename cs_bb10 w14
rename cs_bb9 w13
rename cs_bb8 w12
rename cs_bb7 w11
rename cs_bb6 w10
rename cs_bb5 w9
rename cs_bb4 w8
rename cs_bb3 w7R
rename cs_bb2 w6
rename cs_bb1 w5
rename cs_0 w4
rename cs_ab3 w1
rename cs_ab2 w2
rename cs_ab1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe hs_completed w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster mummun) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(mummun) idcluster(newgroup) : reghdfe hs_completed w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************

*Column 5
clear
set more off
cap log close
use  "/home/aline/Radioactive downfall/data/data_REStat_Gen1", clear

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/

*keep men
keep if female==0

rename cs_bb12 w16
rename cs_bb11 w15
rename cs_bb10 w14
rename cs_bb9 w13
rename cs_bb8 w12
rename cs_bb7 w11
rename cs_bb6 w10
rename cs_bb5 w9
rename cs_bb4 w8
rename cs_bb3 w7R
rename cs_bb2 w6
rename cs_bb1 w5
rename cs_0 w4
rename cs_ab3 w1
rename cs_ab2 w2
rename cs_ab1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe lnpearn35 w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster mummun) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(mummun) idcluster(newgroup) : reghdfe lnpearn35 w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************

*Column 6
clear
set more off
cap log close
use  "/home/aline/Radioactive downfall/data/data_REStat_Gen1", clear

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/

*keep men
keep if female==1

rename cs_bb12 w16
rename cs_bb11 w15
rename cs_bb10 w14
rename cs_bb9 w13
rename cs_bb8 w12
rename cs_bb7 w11
rename cs_bb6 w10
rename cs_bb5 w9
rename cs_bb4 w8
rename cs_bb3 w7R
rename cs_bb2 w6
rename cs_bb1 w5
rename cs_0 w4
rename cs_ab3 w1
rename cs_ab2 w2
rename cs_ab1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe eduy w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster mummun) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(mummun) idcluster(newgroup) : reghdfe eduy w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************
*Column 7
clear
set more off
cap log close
use  "/home/aline/Radioactive downfall/data/data_REStat_Gen1", clear

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/

*keep men
keep if female==1

rename cs_bb12 w16
rename cs_bb11 w15
rename cs_bb10 w14
rename cs_bb9 w13
rename cs_bb8 w12
rename cs_bb7 w11
rename cs_bb6 w10
rename cs_bb5 w9
rename cs_bb4 w8
rename cs_bb3 w7R
rename cs_bb2 w6
rename cs_bb1 w5
rename cs_0 w4
rename cs_ab3 w1
rename cs_ab2 w2
rename cs_ab1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe hs_completed w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster mummun) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(mummun) idcluster(newgroup) : reghdfe hs_completed w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************

*Column 8
clear
set more off
cap log close
use  "/home/aline/Radioactive downfall/data/data_REStat_Gen1", clear

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/

*keep men
keep if female==1

rename cs_bb12 w16
rename cs_bb11 w15
rename cs_bb10 w14
rename cs_bb9 w13
rename cs_bb8 w12
rename cs_bb7 w11
rename cs_bb6 w10
rename cs_bb5 w9
rename cs_bb4 w8
rename cs_bb3 w7R
rename cs_bb2 w6
rename cs_bb1 w5
rename cs_0 w4
rename cs_ab3 w1
rename cs_ab2 w2
rename cs_ab1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe lnpearn35 w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster mummun) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(mummun) idcluster(newgroup) : reghdfe lnpearn35 w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************

*Table 3b
*Column 1
clear
set more off
cap log close
use  "/home/aline/Radioactive downfall/data/data_REStat_Gen1", clear

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/

*keep men
keep if female==0

rename csluft_norain_bb12 w16
rename csluft_norain_bb11 w15
rename csluft_norain_bb10 w14
rename csluft_norain_bb9 w13
rename csluft_norain_bb8 w12
rename csluft_norain_bb7 w11
rename csluft_norain_bb6 w10
rename csluft_norain_bb5 w9
rename csluft_norain_bb4 w8
rename csluft_norain_bb3 w7
rename csluft_norain_bb2 w6
rename csluft_norain_bb1 w5
rename csluft_norain_0 w4
rename csluft_norain_ab3 w1
rename csluft_norain_ab2 w2
rename csluft_norain_ab1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe normal_iq w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster mummun) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(mummun) idcluster(newgroup) : reghdfe eduy w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************

*Column 2
clear
set more off
cap log close
use  "/home/aline/Radioactive downfall/data/data_REStat_Gen1", clear

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/

*keep men
keep if female==0

rename csluft_norain_bb12 w16
rename csluft_norain_bb11 w15
rename csluft_norain_bb10 w14
rename csluft_norain_bb9 w13
rename csluft_norain_bb8 w12
rename csluft_norain_bb7 w11
rename csluft_norain_bb6 w10
rename csluft_norain_bb5 w9
rename csluft_norain_bb4 w8
rename csluft_norain_bb3 w7R
rename csluft_norain_bb2 w6
rename csluft_norain_bb1 w5
rename csluft_norain_0 w4
rename csluft_norain_ab3 w1
rename csluft_norain_ab2 w2
rename csluft_norain_ab1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe hgt w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster mummun) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(mummun) idcluster(newgroup) : reghdfe hgt w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************

*Column 3
clear
set more off
cap log close
use  "/home/aline/Radioactive downfall/data/data_REStat_Gen1", clear

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/

*keep men
keep if female==0

rename csluft_norain_bb12 w16
rename csluft_norain_bb11 w15
rename csluft_norain_bb10 w14
rename csluft_norain_bb9 w13
rename csluft_norain_bb8 w12
rename csluft_norain_bb7 w11
rename csluft_norain_bb6 w10
rename csluft_norain_bb5 w9
rename csluft_norain_bb4 w8
rename csluft_norain_bb3 w7R
rename csluft_norain_bb2 w6
rename csluft_norain_bb1 w5
rename csluft_norain_0 w4
rename csluft_norain_ab3 w1
rename csluft_norain_ab2 w2
rename csluft_norain_ab1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe eduy w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster mummun) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(mummun) idcluster(newgroup) : reghdfe eduy w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************
*Column 4
clear
set more off
cap log close
use  "/home/aline/Radioactive downfall/data/data_REStat_Gen1", clear

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/

*keep men
keep if female==0

rename csluft_norain_bb12 w16
rename csluft_norain_bb11 w15
rename csluft_norain_bb10 w14
rename csluft_norain_bb9 w13
rename csluft_norain_bb8 w12
rename csluft_norain_bb7 w11
rename csluft_norain_bb6 w10
rename csluft_norain_bb5 w9
rename csluft_norain_bb4 w8
rename csluft_norain_bb3 w7R
rename csluft_norain_bb2 w6
rename csluft_norain_bb1 w5
rename csluft_norain_0 w4
rename csluft_norain_ab3 w1
rename csluft_norain_ab2 w2
rename csluft_norain_ab1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe hs_completed w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster mummun) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(mummun) idcluster(newgroup) : reghdfe hs_completed w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************

*Column 5
clear
set more off
cap log close
use  "/home/aline/Radioactive downfall/data/data_REStat_Gen1", clear

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/

*keep men
keep if female==0

rename csluft_norain_bb12 w16
rename csluft_norain_bb11 w15
rename csluft_norain_bb10 w14
rename csluft_norain_bb9 w13
rename csluft_norain_bb8 w12
rename csluft_norain_bb7 w11
rename csluft_norain_bb6 w10
rename csluft_norain_bb5 w9
rename csluft_norain_bb4 w8
rename csluft_norain_bb3 w7R
rename csluft_norain_bb2 w6
rename csluft_norain_bb1 w5
rename csluft_norain_0 w4
rename csluft_norain_ab3 w1
rename csluft_norain_ab2 w2
rename csluft_norain_ab1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe lnpearn35 w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster mummun) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(mummun) idcluster(newgroup) : reghdfe lnpearn35 w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************

*Column 6
clear
set more off
cap log close
use  "/home/aline/Radioactive downfall/data/data_REStat_Gen1", clear

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/

*keep men
keep if female==1

rename csluft_norain_bb12 w16
rename csluft_norain_bb11 w15
rename csluft_norain_bb10 w14
rename csluft_norain_bb9 w13
rename csluft_norain_bb8 w12
rename csluft_norain_bb7 w11
rename csluft_norain_bb6 w10
rename csluft_norain_bb5 w9
rename csluft_norain_bb4 w8
rename csluft_norain_bb3 w7R
rename csluft_norain_bb2 w6
rename csluft_norain_bb1 w5
rename csluft_norain_0 w4
rename csluft_norain_ab3 w1
rename csluft_norain_ab2 w2
rename csluft_norain_ab1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe eduy w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster mummun) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(mummun) idcluster(newgroup) : reghdfe eduy w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************
*Column 7
clear
set more off
cap log close
use  "/home/aline/Radioactive downfall/data/data_REStat_Gen1", clear

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/

*keep men
keep if female==1

rename csluft_norain_bb12 w16
rename csluft_norain_bb11 w15
rename csluft_norain_bb10 w14
rename csluft_norain_bb9 w13
rename csluft_norain_bb8 w12
rename csluft_norain_bb7 w11
rename csluft_norain_bb6 w10
rename csluft_norain_bb5 w9
rename csluft_norain_bb4 w8
rename csluft_norain_bb3 w7R
rename csluft_norain_bb2 w6
rename csluft_norain_bb1 w5
rename csluft_norain_0 w4
rename csluft_norain_ab3 w1
rename csluft_norain_ab2 w2
rename csluft_norain_ab1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe hs_completed w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster mummun) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(mummun) idcluster(newgroup) : reghdfe hs_completed w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************

*Column 8
clear
set more off
cap log close
use  "/home/aline/Radioactive downfall/data/data_REStat_Gen1", clear

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/

*keep men
keep if female==1

rename csluft_norain_bb12 w16
rename csluft_norain_bb11 w15
rename csluft_norain_bb10 w14
rename csluft_norain_bb9 w13
rename csluft_norain_bb8 w12
rename csluft_norain_bb7 w11
rename csluft_norain_bb6 w10
rename csluft_norain_bb5 w9
rename csluft_norain_bb4 w8
rename csluft_norain_bb3 w7R
rename csluft_norain_bb2 w6
rename csluft_norain_bb1 w5
rename csluft_norain_0 w4
rename csluft_norain_ab3 w1
rename csluft_norain_ab2 w2
rename csluft_norain_ab1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe lnpearn35 w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster mummun) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(mummun) idcluster(newgroup) : reghdfe lnpearn35 w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************

*Table 7a 
*Column 3
clear
set more off
cap log close
use  "/home/aline/Radioactive downfall/data/data_REStat_Gen1", clear

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/

*keep men
keep if female==0
keep if soninsample==1

rename cs_bb12 w16
rename cs_bb11 w15
rename cs_bb10 w14
rename cs_bb9 w13
rename cs_bb8 w12
rename cs_bb7 w11
rename cs_bb6 w10
rename cs_bb5 w9
rename cs_bb4 w8
rename cs_bb3 w7
rename cs_bb2 w6
rename cs_bb1 w5
rename cs_0 w4
rename cs_ab3 w1
rename cs_ab2 w2
rename cs_ab1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe normal_iq w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster mummun) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(mummun) idcluster(newgroup) : reghdfe normal_iq w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************

*Table 7b
*Column 3
clear
set more off
cap log close
use  "/home/aline/Radioactive downfall/data/data_REStat_Gen1", clear

preserve
*keep municipalities within a 20km range
keep if mummun==122 /*Trødstad*/| mummun== 217 /*Oppegård*/| mummun== 219 /*Bærum*/| mummun==221 /*Aurskog-Høgland*/| mummun== 226 /*Sørum*/| mummun== 227 /*Fet*/| mummun== 213 /*Ski*/| mummun== 229 /*Enebakk*/| mummun== 230 /*Lørenskog*/| mummun== 231 /*Nittedal*/| ///
mummun== 234 /*Gjerdrum*/| mummun== 235 /*Ullensaker*/| mummun== 236 /*Nes*/| mummun== 237 /*Eidsvoll*/| mummun== 238 /*Nennestad*/| mummun== 301 /*Oslo*/| mummun== 436 /*Tolga*/| mummun== 441 /*Os*/| mummun==437 /*Tynset*/ | ///
mummun== 1001 /*Kristiansand*/| mummun== 1014 /*Vennesla*/| mummun== 1018 /*Søgne*/| mummun== 1016 /*Sogndalen*/| mummun== 926 /*Lillesand*/| mummun== 928 /*Birkenes*/| mummun== 1102 /*Sandnes*/| ///
mummun== 1103 /*Stavenger*/| mummun== 1120 /*Klepp*/| mummun== 1121 /*Time*/| mummun== 1122 /*Gjesdal*/| mummun== 1124 /*Sola*/| mummun== 1127 /*Randaberg*/| mummun==1119 /*Hå*/| mummun==1130 /*Strand*/| mummun==1142 /*Rennesøy*/| mummun== 1201 /*Bergen*/| mummun== 1223 /*Tysnes*/| mummun== 1238 /*Kvam*/| ///
mummun== 1241 /*Fusa*/| mummun==1242 /*Samnanger*/| mummun== 1243 /*Os*/| mummun== 1245 /*Sund*/| mummun== 1246 /*Fjell*/| mummun== 1247 /*Askøy*/| mummun== 1253 /*Osterøy*/| mummun== 1256 /*Meland*/| mummun== 1263 /*Lindås*/| ///
mummun== 1233 /*Ulvik*/| mummun== 1234 /*Granvin*/| mummun== 1235 /*Voss*/| mummun== 1232/*Eidfjord*/| mummun== 1504 /*Ålesund*/| ///
mummun== 1529 /*Skodje*/| mummun== 1531 /*Sula*/| mummun== 1532 /*Giske*/| mummun==1534 /*Haram*/| mummun== 1601 /*Trondheim*/| mummun== 1657 /*Skaun*/| mummun== 1663 /*Malvik*/| mummun== 1662 /*Klæbu*/| mummun== 1664 /*Selbu*/| mummun== 1653 /*Melhus*/| ///
mummun== 1714 /*Stjørdal*/| mummun== 1804 /*Bodø*/| mummun== 1848 /*Steigen*/| mummun== 1839 /*Beiarn*/| mummun== 1841 /*Fauske*/| mummun== 1902 /*Tromsø*/| mummun== 1933 /*Balsfjord*/| mummun== 1936 /*Lyngen*/ | mummun== 1939 /*Storfjord*/ | ///
mummun== 1924 /*Målselv*/ | mummun== 1922 /*Bardu*/ | mummun== 2003 /*Vadsø*/

*keep men
keep if female==0
keep if soninsample==1

rename csluft_norain_bb12 w16
rename csluft_norain_bb11 w15
rename csluft_norain_bb10 w14
rename csluft_norain_bb9 w13
rename csluft_norain_bb8 w12
rename csluft_norain_bb7 w11
rename csluft_norain_bb6 w10
rename csluft_norain_bb5 w9
rename csluft_norain_bb4 w8
rename csluft_norain_bb3 w7
rename csluft_norain_bb2 w6
rename csluft_norain_bb1 w5
rename csluft_norain_0 w4
rename csluft_norain_ab3 w1
rename csluft_norain_ab2 w2
rename csluft_norain_ab1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe normal_iq w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster mummun) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(mummun) idcluster(newgroup) : reghdfe normal_iq w1-w`j' b_order2 b_order3 b_order4 b_order5 unemp fhs mhs i.yob*i.mob, absorb(mummun) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

**********************************************************************************

*Table 7a 
*Column 1
clear
set more off
cap log close
use "/home/aline/Radioactive downfall/data/data_REStat_Gen2", clear

preserve
*keep male offspring only
keep if sex==1
*keep municipalities of birth of father within a 20km range
keep if f_close==1
*keep birth cohort of father in main sample
keep if f_period==1
keep if yob<1993

rename f_ground_b12 w16
rename f_ground_b11 w15
rename f_ground_b10 w14
rename f_ground_b9 w13
rename f_ground_b8 w12
rename f_ground_b7 w11
rename f_ground_b6 w10
rename f_ground_b5 w9
rename f_ground_b4 w8
rename f_ground_b3 w7
rename f_ground_b2 w6
rename f_ground_b1 w5
rename f_ground_b0 w4
rename f_ground_a3 w1
rename f_ground_a2 w2
rename f_ground_a1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe iq_norm w1-w`j' i.f_yob*i.f_mob i.f_muni ff_hs mf_hs f_border1 f_border2 f_border3 f_border4 f_border5 f_unemp [pweight=n], absorb(f_muni) vce(cluster f_muni) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(f_muni) idcluster(newgroup) : reghdfe iq_norm w1-w`j' i.f_yob*i.f_mob i.f_muni ff_hs mf_hs f_border1 f_border2 f_border3 f_border4 f_border5 f_unemp, absorb(f_muni) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************

*Table 7a 
*Column 2
clear
set more off
cap log close
use "/home/aline/Radioactive downfall/data/data_REStat_Gen2", clear

preserve
*keep male offspring only
keep if sex==1
*keep municipalities of birth of father within a 20km range
keep if f_close==1
*keep birth cohort of father in main sample
keep if f_period==1
keep if yob<1993

rename f_ground_b12 w16
rename f_ground_b11 w15
rename f_ground_b10 w14
rename f_ground_b9 w13
rename f_ground_b8 w12
rename f_ground_b7 w11
rename f_ground_b6 w10
rename f_ground_b5 w9
rename f_ground_b4 w8
rename f_ground_b3 w7
rename f_ground_b2 w6
rename f_ground_b1 w5
rename f_ground_b0 w4
rename f_ground_a3 w1
rename f_ground_a2 w2
rename f_ground_a1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe iq_norm w1-w`j' i.f_yob*i.f_mob i.f_muni ff_hs mf_hs f_border1 f_border2 f_border3 f_border4 f_border5 f_unemp border1 border2 border3 border4 border5 famsize1 famsize2 famsize3 famsize4 famsize5 f_iq f_edu i.yob i.mob [pweight=n], absorb(f_muni) vce(cluster f_muni) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(f_muni) idcluster(newgroup) : reghdfe iq_norm w1-w`j' i.f_yob*i.f_mob i.f_muni ff_hs mf_hs f_border1 f_border2 f_border3 f_border4 f_border5 f_unemp border1 border2 border3 border4 border5 famsize1 famsize2 famsize3 famsize4 famsize5 f_iq f_edu i.yob i.mob, absorb(f_muni) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************

*Table 7a 
*Column 4
clear
set more off
cap log close
use "/home/aline/Radioactive downfall/data/data_REStat_Gen2", clear

preserve
*keep male offspring only
keep if sex==1
*keep municipalities of birth of father within a 20km range
keep if m_close==1
*keep birth cohort of father in main sample
keep if m_period==1
keep if yob<1993

rename m_ground_b12 w16
rename m_ground_b11 w15
rename m_ground_b10 w14
rename m_ground_b9 w13
rename m_ground_b8 w12
rename m_ground_b7 w11
rename m_ground_b6 w10
rename m_ground_b5 w9
rename m_ground_b4 w8
rename m_ground_b3 w7
rename m_ground_b2 w6
rename m_ground_b1 w5
rename m_ground_b0 w4
rename m_ground_a3 w1
rename m_ground_a2 w2
rename m_ground_a1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe iq_norm w1-w`j' i.m_yob*i.m_mob i.m_muni mf_hs mm_hs m_border1 m_border2 m_border3 m_border4 m_border5 m_unemp [pweight=n], absorb(m_muni) vce(cluster m_muni) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(m_muni) idcluster(newgroup) : reghdfe iq_norm w1-w`j' i.m_yob*i.m_mob i.m_muni mf_hs mm_hs m_border1 m_border2 m_border3 m_border4 m_border5 m_unemp, absorb(m_muni) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************

*Table 7a 
*Column 5
clear
set more off
cap log close
use "/home/aline/Radioactive downfall/data/data_REStat_Gen2", clear

preserve
*keep male offspring only
keep if sex==1
*keep municipalities of birth of father within a 20km range
keep if m_close==1
*keep birth cohort of father in main sample
keep if m_period==1
keep if yob<1993

rename m_ground_b12 w16
rename m_ground_b11 w15
rename m_ground_b10 w14
rename m_ground_b9 w13
rename m_ground_b8 w12
rename m_ground_b7 w11
rename m_ground_b6 w10
rename m_ground_b5 w9
rename m_ground_b4 w8
rename m_ground_b3 w7
rename m_ground_b2 w6
rename m_ground_b1 w5
rename m_ground_b0 w4
rename m_ground_a3 w1
rename m_ground_a2 w2
rename m_ground_a1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe iq_norm w1-w`j' i.m_yob*i.m_mob i.m_muni ff_hs mf_hs m_border1 m_border2 m_border3 m_border4 m_border5 m_unemp border1 border2 border3 border4 border5 famsize1 famsize2 famsize3 famsize4 famsize5 m_iq m_edu i.yob i.mob [pweight=n], absorb(m_muni) vce(cluster m_muni) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(m_muni) idcluster(newgroup) : reghdfe iq_norm w1-w`j' i.m_yob*i.m_mob i.m_muni ff_hs mf_hs m_border1 m_border2 m_border3 m_border4 m_border5 m_unemp border1 border2 border3 border4 border5 famsize1 famsize2 famsize3 famsize4 famsize5 m_iq m_edu i.yob i.mob, absorb(m_muni) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************

*Table 7a 
*Column 6
clear
set more off
cap log close
use "/home/aline/Radioactive downfall/data/data_REStat_Gen2", clear

preserve
*keep male offspring only
keep if sex==1
*keep municipalities of birth of both parents within a 20km range
keep if m_close==1 & f_close==1
*keep birth cohort of both parents in main sample
keep if m_period==1 & f_period==1
keep if yob<1993

rename f_ground_b12 w16
rename f_ground_b11 w15
rename f_ground_b10 w14
rename f_ground_b9 w13
rename f_ground_b8 w12
rename f_ground_b7 w11
rename f_ground_b6 w10
rename f_ground_b5 w9
rename f_ground_b4 w8
rename f_ground_b3 w7
rename f_ground_b2 w6
rename f_ground_b1 w5
rename f_ground_b0 w4
rename f_ground_a3 w1
rename f_ground_a2 w2
rename f_ground_a1 w3
rename m_ground_b12 w32
rename m_ground_b11 w31
rename m_ground_b10 w30
rename m_ground_b9 w29
rename m_ground_b8 w28
rename m_ground_b7 w27
rename m_ground_b6 w26
rename m_ground_b5 w25
rename m_ground_b4 w24
rename m_ground_b3 w23
rename m_ground_b2 w22
rename m_ground_b1 w21
rename m_ground_b0 w20
rename m_ground_a3 w17
rename m_ground_a2 w18
rename m_ground_a1 w19
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16 w17 w18 w19 w20 w21 w22 w23 w24 w25 w26 w27 w28 w29 w30 w31 w32

set seed 111 
*significance level
global alpha = 0.1
local j = 32

*1 OLS 
xi: reghdfe iq_norm w1-w`j' i.f_yob*i.f_mob ff_hs fm_hs f_border1 f_border2 f_border3 f_border4 f_border5 f_unemp i.m_yob*i.m_mob mf_hs mm_hs m_border1 m_border2 m_border3 m_border4 m_border5 m_unemp [pweight=n], absorb(f_muni m_muni) vce(cluster f_muni) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16] b_bs17=_b[w17] b_bs18=_b[w18] b_bs19=_b[w19] b_bs20=_b[w20] b_bs21=_b[w21] b_bs22=_b[w22] b_bs23=_b[w23] b_bs24=_b[w24] b_bs25=_b[w25] b_bs26=_b[w26] b_bs27=_b[w27] b_bs28=_b[w28] b_bs29=_b[w29] b_bs30=_b[w30] b_bs31=_b[w31] b_bs32=_b[w32], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(f_muni) idcluster(newgroup) : reghdfe iq_norm w1-w`j' i.f_yob*i.f_mob ff_hs fm_hs f_border1 f_border2 f_border3 f_border4 f_border5 f_unemp i.m_yob*i.m_mob mf_hs mm_hs m_border1 m_border2 m_border3 m_border4 m_border5 m_unemp, absorb(f_muni) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)32 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16', `t17', `t18', `t19', `t20', `t21', `t22', `t23', `t24', `t25', `t26', `t27', `t28', `t29', `t30', `t31', `t32')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace



*Table 7a 
*Column 1
clear
set more off
cap log close
use "/home/aline/Radioactive downfall/data/data_REStat_Gen2", clear

preserve
*keep male offspring only
keep if sex==1
*keep municipalities of birth of father within a 20km range
keep if f_close==1
*keep birth cohort of father in main sample
keep if f_period==1
keep if yob<1993

rename f_air_b12 w16
rename f_air_b11 w15
rename f_air_b10 w14
rename f_air_b9 w13
rename f_air_b8 w12
rename f_air_b7 w11
rename f_air_b6 w10
rename f_air_b5 w9
rename f_air_b4 w8
rename f_air_b3 w7
rename f_air_b2 w6
rename f_air_b1 w5
rename f_air_b0 w4
rename f_air_a3 w1
rename f_air_a2 w2
rename f_air_a1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe iq_norm w1-w`j' i.f_yob*i.f_mob i.f_muni ff_hs mf_hs f_border1 f_border2 f_border3 f_border4 f_border5 f_unemp [pweight=n], absorb(f_muni) vce(cluster f_muni) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(f_muni) idcluster(newgroup) : reghdfe iq_norm w1-w`j' i.f_yob*i.f_mob i.f_muni ff_hs mf_hs f_border1 f_border2 f_border3 f_border4 f_border5 f_unemp, absorb(f_muni) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************

*Table 7a 
*Column 2
clear
set more off
cap log close
use "/home/aline/Radioactive downfall/data/data_REStat_Gen2", clear

preserve
*keep male offspring only
keep if sex==1
*keep municipalities of birth of father within a 20km range
keep if f_close==1
*keep birth cohort of father in main sample
keep if f_period==1
keep if yob<1993

rename f_air_b12 w16
rename f_air_b11 w15
rename f_air_b10 w14
rename f_air_b9 w13
rename f_air_b8 w12
rename f_air_b7 w11
rename f_air_b6 w10
rename f_air_b5 w9
rename f_air_b4 w8
rename f_air_b3 w7
rename f_air_b2 w6
rename f_air_b1 w5
rename f_air_b0 w4
rename f_air_a3 w1
rename f_air_a2 w2
rename f_air_a1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe iq_norm w1-w`j' i.f_yob*i.f_mob i.f_muni ff_hs mf_hs f_border1 f_border2 f_border3 f_border4 f_border5 f_unemp border1 border2 border3 border4 border5 famsize1 famsize2 famsize3 famsize4 famsize5 f_iq f_edu i.yob i.mob [pweight=n], absorb(f_muni) vce(cluster f_muni) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(f_muni) idcluster(newgroup) : reghdfe iq_norm w1-w`j' i.f_yob*i.f_mob i.f_muni ff_hs mf_hs f_border1 f_border2 f_border3 f_border4 f_border5 f_unemp border1 border2 border3 border4 border5 famsize1 famsize2 famsize3 famsize4 famsize5 f_iq f_edu i.yob i.mob, absorb(f_muni) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************

*Table 7a 
*Column 4
clear
set more off
cap log close
use "/home/aline/Radioactive downfall/data/data_REStat_Gen2", clear

preserve
*keep male offspring only
keep if sex==1
*keep municipalities of birth of father within a 20km range
keep if m_close==1
*keep birth cohort of father in main sample
keep if m_period==1
keep if yob<1993

rename m_air_b12 w16
rename m_air_b11 w15
rename m_air_b10 w14
rename m_air_b9 w13
rename m_air_b8 w12
rename m_air_b7 w11
rename m_air_b6 w10
rename m_air_b5 w9
rename m_air_b4 w8
rename m_air_b3 w7
rename m_air_b2 w6
rename m_air_b1 w5
rename m_air_b0 w4
rename m_air_a3 w1
rename m_air_a2 w2
rename m_air_a1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe iq_norm w1-w`j' i.m_yob*i.m_mob i.m_muni mf_hs mm_hs m_border1 m_border2 m_border3 m_border4 m_border5 m_unemp [pweight=n], absorb(m_muni) vce(cluster m_muni) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(m_muni) idcluster(newgroup) : reghdfe iq_norm w1-w`j' i.m_yob*i.m_mob i.m_muni mf_hs mm_hs m_border1 m_border2 m_border3 m_border4 m_border5 m_unemp, absorb(m_muni) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************

*Table 7a 
*Column 5
clear
set more off
cap log close
use "/home/aline/Radioactive downfall/data/data_REStat_Gen2", clear

preserve
*keep male offspring only
keep if sex==1
*keep municipalities of birth of father within a 20km range
keep if m_close==1
*keep birth cohort of father in main sample
keep if m_period==1
keep if yob<1993

rename m_air_b12 w16
rename m_air_b11 w15
rename m_air_b10 w14
rename m_air_b9 w13
rename m_air_b8 w12
rename m_air_b7 w11
rename m_air_b6 w10
rename m_air_b5 w9
rename m_air_b4 w8
rename m_air_b3 w7
rename m_air_b2 w6
rename m_air_b1 w5
rename m_air_b0 w4
rename m_air_a3 w1
rename m_air_a2 w2
rename m_air_a1 w3
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16

set seed 111 
*significance level
global alpha = 0.1
local j = 16 

*1 OLS 
xi: reghdfe iq_norm w1-w`j' i.m_yob*i.m_mob i.m_muni ff_hs mf_hs m_border1 m_border2 m_border3 m_border4 m_border5 m_unemp border1 border2 border3 border4 border5 famsize1 famsize2 famsize3 famsize4 famsize5 m_iq m_edu i.yob i.mob [pweight=n], absorb(m_muni) vce(cluster m_muni) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(m_muni) idcluster(newgroup) : reghdfe iq_norm w1-w`j' i.m_yob*i.m_mob i.m_muni ff_hs mf_hs m_border1 m_border2 m_border3 m_border4 m_border5 m_unemp border1 border2 border3 border4 border5 famsize1 famsize2 famsize3 famsize4 famsize5 m_iq m_edu i.yob i.mob, absorb(m_muni) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)16 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

********************************************************************************

*Table 7a 
*Column 6
clear
set more off
cap log close
use "/home/aline/Radioactive downfall/data/data_REStat_Gen2", clear

preserve
*keep male offspring only
keep if sex==1
*keep municipalities of birth of both parents within a 20km range
keep if m_close==1 & f_close==1
*keep birth cohort of both parents in main sample
keep if m_period==1 & f_period==1
keep if yob<1993

rename f_air_b12 w16
rename f_air_b11 w15
rename f_air_b10 w14
rename f_air_b9 w13
rename f_air_b8 w12
rename f_air_b7 w11
rename f_air_b6 w10
rename f_air_b5 w9
rename f_air_b4 w8
rename f_air_b3 w7
rename f_air_b2 w6
rename f_air_b1 w5
rename f_air_b0 w4
rename f_air_a3 w1
rename f_air_a2 w2
rename f_air_a1 w3
rename m_air_b12 w32
rename m_air_b11 w31
rename m_air_b10 w30
rename m_air_b9 w29
rename m_air_b8 w28
rename m_air_b7 w27
rename m_air_b6 w26
rename m_air_b5 w25
rename m_air_b4 w24
rename m_air_b3 w23
rename m_air_b2 w22
rename m_air_b1 w21
rename m_air_b0 w20
rename m_air_a3 w17
rename m_air_a2 w18
rename m_air_a1 w19
order w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16 w17 w18 w19 w20 w21 w22 w23 w24 w25 w26 w27 w28 w29 w30 w31 w32

set seed 111 
*significance level
global alpha = 0.1
local j = 32

*1 OLS 
xi: reghdfe iq_norm w1-w`j' i.f_yob*i.f_mob ff_hs fm_hs f_border1 f_border2 f_border3 f_border4 f_border5 f_unemp i.m_yob*i.m_mob mf_hs mm_hs m_border1 m_border2 m_border3 m_border4 m_border5 m_unemp [pweight=n], absorb(f_muni m_muni) vce(cluster f_muni) 

*store coefficient and absolute value of t statistics 
forvalues i=1(1)`j' {
local b`i' = _b[w`i']
local se`i' = _se[w`i']
local t`i' = abs(_b[w`i']/_se[w`i'])
}

xtset, clear

*bootstrap the coefficients

xi: bootstrap b_bs1=_b[w1] b_bs2=_b[w2] b_bs3=_b[w3] b_bs4=_b[w4] b_bs5=_b[w5] b_bs6=_b[w6] b_bs7=_b[w7] b_bs8=_b[w8] b_bs9=_b[w9] b_bs10=_b[w10] b_bs11=_b[w11] b_bs12=_b[w12] b_bs13=_b[w13] b_bs14=_b[w14] b_bs15=_b[w15] b_bs16=_b[w16] b_bs17=_b[w17] b_bs18=_b[w18] b_bs19=_b[w19] b_bs20=_b[w20] b_bs21=_b[w21] b_bs22=_b[w22] b_bs23=_b[w23] b_bs24=_b[w24] b_bs25=_b[w25] b_bs26=_b[w26] b_bs27=_b[w27] b_bs28=_b[w28] b_bs29=_b[w29] b_bs30=_b[w30] b_bs31=_b[w31] b_bs32=_b[w32], ///
reps(999) seed(111) notable nodots noheader saving(bsout.dta, replace) cluster(f_muni) idcluster(newgroup) : reghdfe iq_norm w1-w`j' i.f_yob*i.f_mob ff_hs fm_hs f_border1 f_border2 f_border3 f_border4 f_border5 f_unemp i.m_yob*i.m_mob mf_hs mm_hs m_border1 m_border2 m_border3 m_border4 m_border5 m_unemp, absorb(f_muni) vce(cluster newgroup)

tempfile junk
save `junk', replace

*method 3: using the standard error from the main regression
use bsout.dta

*create the absolute value of the t-statistics using the standard error from the main regression
forvalues k=1(1)32 {
gen t_bs`k'=abs((b_bs`k'-`b`k'')/`se`k'')
}
su

gen signif = 1
local counter = 0

*implement the Romano-Wolf stepdown process
*we stop once the coefficient with the highest absolute t-value is not significant

while signif == 1 {

local counter = `counter' + 1
display "Pass Number " `counter'

*maximum of real t values
local tmax=max(`t1', `t2', `t3', `t4', `t5', `t6', `t7', `t8', `t9', `t10', `t11', `t12', `t13', `t14', `t15', `t16', `t17', `t18', `t19', `t20', `t21', `t22', `t23', `t24', `t25', `t26', `t27', `t28', `t29', `t30', `t31', `t32')

*maximum value of bootstrapped t stats
egen tmax_bs=rowmax(t_bs1-t_bs`j')

*identifying which variable has the highest t stat
forvalues i=1(1)`j' {
scalar tmax`i'= (`tmax'==`t`i'')
if (`tmax'== `t`i'') {
scalar high_t = `i'
}
}

display "Variable with highest t value is w" high_t

*percentile-t p value
quietly count if `tmax' < tmax_bs
display "p-value = " r(N)/_N
local sig_r = r(N)/_N<$alpha
scalar sig_rw = r(N)/_N<$alpha

forvalues i=1(1)`j' {

*setting true t stats and bootstrapped t stats equal to zero for any variable that has already been found significant
local sig`i'= (`tmax'==`t`i'' & `sig_r' ==1)
qui replace t_bs`i'=0 if `tmax'==`t`i'' & `sig`i''==1
if (`tmax'==`t`i'' & `sig`i''==1) local t`i'=0

}

qui replace signif = 0 if sig_rw == 0
drop tmax_bs
 
}

tempfile junk
save junk, replace

