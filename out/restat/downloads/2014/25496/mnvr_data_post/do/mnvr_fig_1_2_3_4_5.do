clear
cd ..\dta

use mnvr_reshaped_variables_country_industry_means,clear

keep if country=="AUT"|country=="DNK"|country=="ESP"|country=="FIN"|country=="FRA"|country=="GER"|country=="ITA"|country=="JPN"|country=="NLD"|country=="UK"|country=="USA"
* We drop fuel-related industries because 1980 was close to the peak of an oil boom
drop if ind=="23"|ind=="E"|ind=="C"
drop diff24* 

*generating weights(share of 1980 employment) for full sample
egen wt1_80 = sum(emp) if year==1980, by(country)
gen wt2_80 = emp/wt1_80
egen wt80 = mean(wt2_80), by(country ind)

* generating weights(share of 1980 employment) for  traded Industries
egen wtt1_80 = sum(emp) if year==1980 & import_world!=., by(country)
gen wtt2_80 = emp/wtt1_80
egen wtt80 = mean(wtt2_80), by(country ind)

* generating nonOECD imports and exports
foreach var of newlist import export{
gen `var'_nonoecd= `var'_chn+ `var'_rest
}
* normalising by value added for regressions
foreach var of newlist va{
gen ln_`var'=ln(`var'_USD)
gen tcapit_over_`var'=tcapit_USD/`var'_USD
gen tcapnit_over_`var'=tcapnit_USD/`var'_USD
}
foreach var of varlist  import_oecd export_oecd import_world export_world import_nonoecd export_nonoecd {
replace `var'=. if `var'==0
gen `var'_over_va = `var'/(va_USD*1000000)
}
gen trade_world_over_va=import_world_over_va+export_world_over_va

sort country ind year
*generating 1980 values and 1980-2004 differences for variables of interest

foreach var of varlist  labhs labms labls ln_va tcapit_over_va tcapnit_over_va  trade_world_over_va {
gen diff24_`var' = `var'-`var'[_n-8] if country==country[_n-8] & ind==ind[_n-8] & int((year-1980)/24)==((year-1980)/24)
gen lag24_`var' =`var'[_n-8] if country==country[_n-8] & ind==ind[_n-8] & int((year-1980)/24)==((year-1980)/24)
}
replace country="Austria" if country=="AUT"
replace country="Denmark" if country=="DNK"
replace country="Spain" if country=="ESP"
replace country="Finland" if country=="FIN"
replace country="France" if country=="FRA"
replace country="Germany" if country=="GER"
replace country="Italy" if country=="ITA"
replace country="Japan" if country=="JPN"
replace country="Netherlands" if country=="NLD"



*for figure 1
collapse(mean) diff24_labhs diff24_labms diff24_labls diff24_tcapit_over_va if year==2004 [aw=wt80], by(country)
save mnvr_fig1,replace

twoway scatter diff24_labhs diff24_tcapit_over_va, mlabcolor(black) mlabsize(5) mlabel (country) xtitle("Change ICT/VA") ytitle("Change High-Skilled Wagebill Share")title("Figure 1A:High-Skilled Wage Bill Share") ylabel(-5 0 5 10 15 20) xlabel(0.005 0.01 0.015 0.02 0.025 0.03 0.035) legend(off) scheme(s1color) || lfit diff24_labhs diff24_tcapit_over_va 
cd ..\results
graph save mnvr_fig1a,replace

cd ..\dta
use mnvr_fig1,clear
twoway scatter diff24_labms diff24_tcapit_over_va, mlabcolor(black) mlabsize(5)  mlabel (country) xtitle("Change ICT/VA") ytitle("Change Medium-Skilled Wagebill Share")title("Figure 1B:Medium-Skilled Wage Bill Share") xlabel(0.005 0.01 0.015 0.02 0.025 0.03 0.035)legend(off) scheme(s1color) || lfit diff24_labms diff24_tcapit_over_va 
cd ..\results
graph save mnvr_fig1b,replace

cd ..\dta
use mnvr_fig1,clear

twoway scatter diff24_labls diff24_tcapit_over_va, mlabcolor(black) mlabsize(5)  mlabel (country) xtitle("Change ICT/VA") ytitle("Change Low-Skilled Wagebill Share")title("Figure 1C:Low-Skilled Wage Bill Share") xlabel(0.005 0.01 0.015 0.02 0.025 0.03 0.035)legend(off) scheme(s1color) || lfit diff24_labls diff24_tcapit_over_va 
cd ..\results
graph save mnvr_fig1c,replace

* for figure 2
cd ..\dta
foreach num of numlist 80 86 92 98{
use mnvr_fully_disaggregated_tables_dataset,clear
collapse(mean) diff6`num'_labhs diff6`num'_labms diff6`num'_labls if year==19`num'+6 [aw=wt`num'], by(country year)
save mnvr_fig2_6yrdiff`num',replace
}
append using mnvr_fig2_6yrdiff92
append using mnvr_fig2_6yrdiff86
append using mnvr_fig2_6yrdiff80
sort country year
foreach var of newlist labhs labms labls{
gen diff6_`var'=.
foreach num of numlist 80 86 92 98{
replace diff6_`var'=diff6`num'_`var' if year==19`num'+6
}
egen mdiff6_`var'=mean(diff6_`var'), by(year)
replace mdiff6_`var'=mdiff6_`var'/6
}
ren  mdiff6_labhs High
ren  mdiff6_labms Medium
ren mdiff6_labls Low
twoway (connected High year if country=="USA", sort msymbol(lgx)) (connected Medium year if country=="USA", msymbol(circle) lpattern(dash)) (connected Low year if country=="USA", msymbol(square) lpattern(longdash)), ytitle("Average Annualised Six-Year Difference" "in Wagebill Share") xtitle(End Year of Six Year Interval) xlabel (1986 1992 1998 2004) title("Figure 2A: 11 Country Average") scheme(s1color) 
cd ..\results
graph save mnvr_fig2a,replace

cd ..\dta
foreach num of numlist 80 86 92 98{
use mnvr_fully_disaggregated_tables_dataset,clear
collapse(mean) diff6`num'_labhs diff6`num'_labms diff6`num'_labls if year==19`num'+6& country=="USA" [aw=wt`num'], by(year)
save mnvr_fig2_6yrdiff`num',replace
}
append using mnvr_fig2_6yrdiff92
append using mnvr_fig2_6yrdiff86
append using mnvr_fig2_6yrdiff80
sort year
foreach var of newlist labhs labms labls{
gen diff6_`var'=.
foreach num of numlist 80 86 92 98{
replace diff6_`var'=diff6`num'_`var' if year==19`num'+6
}
egen mdiff6_`var'=mean(diff6_`var'), by(year)
replace mdiff6_`var'=mdiff6_`var'/6
}
ren  mdiff6_labhs High
ren  mdiff6_labms Medium
ren mdiff6_labls Low
twoway (connected High year, sort msymbol(lgx)) (connected Medium year, msymbol(circle) lpattern(dash)) (connected Low year, msymbol(square) lpattern(longdash)), ytitle("Average Annualised Six-Year Difference" "in Wagebill Share") xtitle(End Year of Six Year Interval) xlabel (1986 1992 1998 2004) title("Figure 2B: USA Average") scheme(s1color)
cd ..\results
graph save mnvr_fig2b,replace

* For Table 2 and Figures 3, 4 and 5
cd ..\dta
use mnvr_reshaped_variables_country_industry_means,clear

keep if country=="AUT"|country=="DNK"|country=="ESP"|country=="FIN"|country=="FRA"|country=="GER"|country=="ITA"|country=="JPN"|country=="NLD"|country=="UK"|country=="USA"
drop if ind=="23"|ind=="E"|ind=="C"
drop diff24* 
sort ind
merge ind using codedes
*generating weights(share of 1980 employment) for full sample
egen wt1_80 = sum(emp) if year==1980, by(country)
gen wt2_80 = emp/wt1_80
egen wt80 = mean(wt2_80), by(country ind)

* generating weights(share of 1980 employment) for  traded Industries
egen wtt1_80 = sum(emp) if year==1980 & import_world!=., by(country)
gen wtt2_80 = emp/wtt1_80
egen wtt80 = mean(wtt2_80), by(country ind)

* generating weights(share of 1980 employment) for  nontraded Industries
egen wtnott1_80 = sum(emp) if year==1980 & import_world==., by(country)
gen wtnott2_80 = emp/wtnott1_80
egen wtnott80 = mean(wtnott2_80), by(country ind)

* generating average weight (share of 1980 employment) across countries
egen mwt80=mean(wt80), by(ind)
* generating average weight (share of 1980 employment) across countries for traded Industries
egen mwtt80=mean(wtt80), by(ind)
* generating average weight (share of 1980 employment) across countries for nontraded Industries
egen mwtnott80=mean(wtnott80), by(ind)

* generating nonOECD imports and exports
foreach var of newlist import export{
gen `var'_nonoecd= `var'_chn+ `var'_rest
}
* normalising by value added for regressions
foreach var of newlist va{
gen ln_`var'=ln(`var'_USD)
gen tcapit_over_`var'=tcapit_USD/`var'_USD
gen tcapnit_over_`var'=tcapnit_USD/`var'_USD
}
foreach var of varlist  import_oecd export_oecd import_world export_world import_nonoecd export_nonoecd {
replace `var'=. if `var'==0
gen `var'_over_va = `var'/(va_USD*1000000)
}
gen trade_world_over_va=import_world_over_va+export_world_over_va

sort country ind year
*generating 1980 values and 1980-2004 differences for variables of interest

foreach var of varlist  labhs labms labls ln_va tcapit_over_va tcapnit_over_va  trade_world_over_va {
gen diff24_`var' = `var'-`var'[_n-8] if country==country[_n-8] & ind==ind[_n-8] & int((year-1980)/24)==((year-1980)/24)
gen lag24_`var' =`var'[_n-8] if country==country[_n-8] & ind==ind[_n-8] & int((year-1980)/24)==((year-1980)/24)
}
* Here we sort industries so that all traded Industries appear first.

gen key=.
replace key=4 if codedes=="Wood and products of wood and cork"
replace key=6 if codedes=="Chemicals and chemical products"
replace key=7 if codedes=="Rubber and plastics products"
replace key=8 if codedes=="Other non-metallic mineral products"
replace key=10 if codedes=="Machinery, not elsewhere classified"
replace key=14 if codedes=="Sale, maintenance and repair of motor vehicles and motorcycles; retail sale of fuel"
replace key=15 if codedes=="Wholesale trade and commission trade, except of motor vehicles and motorcycles"
replace key=16 if codedes=="Retail trade, except of motor vehicles and motorcycles; repair of household goods"
replace key=18 if codedes=="Post and telecommunications"
replace key=19 if codedes=="Real estate activities"
replace key=2 if codedes=="Food products, beverages and tobacco"
replace key=3 if codedes=="Textiles, textile products, leather and footwear"
replace key=5 if codedes=="Pulp, paper, paper products, printing and publishing"
replace key=9 if codedes=="Basic metals and fabricated metal products"
replace key=11 if codedes=="Electrical and optical equipment"
replace key=12 if codedes=="Transport equipment"
replace key=13 if codedes=="Manufacturing not elsewhere classified; recycling"
replace key=17 if codedes=="Transport and storage"
replace key=20 if codedes=="Renting of machinery and equipment and other business activities"
replace key=1 if codedes=="Agriculture, hunting, forestry and fishing"
replace key=21 if codedes=="Construction"
replace key=22 if codedes=="Hotels and restaurants"
replace key=23 if codedes=="Financial intermediation"
replace key=24 if codedes=="Public admin and defence; compulsory social security"
replace key=25 if codedes=="Education"
replace key=26 if codedes=="Health and social work"
replace key=27 if codedes=="Other community, social and personal services"

label define indl	4	 "Wood and products of wood and cork", add
label define indl	6	 "Chemicals and chemical products", add
label define indl	7	 "Rubber and plastics products", add
label define indl	8	 "Other non-metallic mineral products", add
label define indl	10	 "Machinery, not elsewhere classified", add
label define indl	14	 "Sale, maintenance and repair of motor vehicles and motorcycles; retail sale of fuel", add
label define indl	15	 "Wholesale trade and commission trade, except of motor vehicles and motorcycles", add
label define indl	16	 "Retail trade, except of motor vehicles and motorcycles; repair of household goods", add
label define indl	18	 "Post and telecommunications", add
label define indl	19	 "Real estate activities", add
label define indl	2	 "Food products, beverages and tobacco", add
label define indl	3	 "Textiles, textile products, leather and footwear", add
label define indl	5	 "Pulp, paper, paper products, printing and publishing", add
label define indl	9	 "Basic metals and fabricated metal products", add
label define indl	11	 "Electrical and optical equipment", add
label define indl	12	 "Transport equipment", add
label define indl	13	 "Manufacturing not elsewhere classified; recycling", add
label define indl	17	 "Transport and storage", add
label define indl	20	 "Renting of machinery and equipment and other business activities", add
label define indl	1	 "Agriculture, hunting, forestry and fishing", add
label define indl	21	 "Construction", add
label define indl	22	 "Hotels and restaurants", add
label define indl	23	 "Financial intermediation", add
label define indl	24	 "Public admin and defence; compulsory social security", add
label define indl	25	 "Education", add
label define indl	26	 "Health and social work", add
label define indl	27	 "Other community, social and personal services", add



lab values key indl

* for table 2 (1980-2004 differences):
table key , contents(mean lag24_labhs mean lag24_labms mean lag24_labls )
table key , contents(mean lag24_ln_va mean lag24_tcapit_over_va mean lag24_tcapnit_over_va )
table key , contents(mean lag24_trade_world_over_va )

table key , contents(mean diff24_labhs mean diff24_labms mean diff24_labls )
table key , contents(mean diff24_ln_va mean diff24_tcapit_over_va mean diff24_tcapnit_over_va)
table key , contents(mean diff24_trade_world_over_va mean wt80 mean wtt80)

collapse(mean)diff24_labhs diff24_labms diff24_labls diff24_tcapit_over_va wt80 wtt80 wtnott80 if year==2004 , by(key)
gen ind=""
replace ind="Wood and products of wood and cork" if key==4
replace ind="Chemicals and chemical products" if key==6
replace ind="Rubber and plastics products" if key==7
replace ind="Other non-metallic mineral products" if key==8
replace ind="Machinery, not elsewhere classified" if key==10
replace ind="Sale, maintenance and repair of motor vehicles and motorcycles; retail sale of fuel" if key==14
replace ind="Wholesale trade and commission trade, except of motor vehicles and motorcycles" if key==15
replace ind="Retail trade, except of motor vehicles and motorcycles; repair of household goods" if key==16
replace ind="Post and telecommunications" if key==18
replace ind="Real estate activities" if key==19
replace ind="Food products, beverages and tobacco" if key==2
replace ind="Textiles, textile products, leather and footwear" if key==3
replace ind="Pulp, paper, paper products, printing and publishing" if key==5
replace ind="Basic metals and fabricated metal products" if key==9
replace ind="Electrical and optical equipment" if key==11
replace ind="Transport equipment" if key==12
replace ind="Manufacturing not elsewhere classified; recycling" if key==13
replace ind="Transport and storage" if key==17
replace ind="Renting of machinery and equipment and other business activities" if key==20
replace ind="Agriculture, hunting, forestry and fishing" if key==1
replace ind="Construction" if key==21
replace ind="Hotels and restaurants" if key==22
replace ind="Financial intermediation" if key==23
replace ind="Public admin and defence; compulsory social security" if key==24
replace ind="Education" if key==25
replace ind="Health and social work" if key==26
replace ind="Other community, social and personal services" if key==27

gen gapcheck=strpos(ind," ")
gen subind=substr(ind,1,gapcheck-1)
replace subind=ind if gapcheck==0
replace subind="Minerals" if key==8
replace subind="Community" if key==27
replace subind="Metals" if subind=="Basic"
replace subind="Sale_motor" if subind=="Sale,"
replace subind="Real estate" if subind=="Real"
replace subind="Paper" if subind=="Pulp,"
replace subind="Agri" if subind=="Agriculture,"
replace subind="Edu" if subind=="Education"
gen commacheck=strpos(subind,",")
gen sub2ind=substr(subind,1,commacheck-1)
replace subind=sub2ind if commacheck~=0
drop sub2ind commacheck
drop ind

save mnvr_fig3_4_5,replace
* for figure 3
twoway scatter diff24_labhs diff24_tcapit_over_va if wt80!=. [aw=wt80], mlabsize(3) mlabcolor(black) msymbol(i) mlabel(subind) mlabpos(6) xtitle("Change ICT/VA") ytitle("Change High-Skilled Wagebill Share")title("Figure 3A:Growth of High-Skilled Share" "Whole Economy and Nontraded Industries") ylabel(0 5 10 15 20 25 30 35)  scheme(s1color) ||lfit diff24_labhs diff24_tcapit_over_va [aw=wt80] ||lfit diff24_labhs diff24_tcapit_over_va [aw=wtnott80], lpattern(dash) legend(off)
cd ..\results
graph save mnvr_fig3a,replace
cd ..\dta
use mnvr_fig3_4_5,clear

twoway scatter diff24_labhs diff24_tcapit_over_va if wtt80!=. [aw=wtt80],mlabsize(3) mlabcolor(black) msymbol(i) mlabel(subind) mlabpos(6)xtitle("Change ICT/VA") ytitle("Change High-Skilled Wagebill Share")title("Figure 3B: Growth of High-Skilled Share" "Traded Industries Only")legend(off) ylabel(0 5 10 15 20) scheme(s1color) ||lfit diff24_labhs diff24_tcapit_over_va [aw=wtt80]
cd ..\results
graph save mnvr_fig3b,replace
* for figure 4
cd ..\dta
use mnvr_fig3_4_5,clear
twoway scatter diff24_labms diff24_tcapit_over_va if wt80!=. [aw=wt80], mlabsize(3) mlabcolor(black) msymbol(i) mlabel(subind) mlabpos(6) xtitle("Change ICT/VA") ytitle("Change Medium-Skilled Wagebill Share")title("Figure 4A:Growth of Medium-Skilled Share" "Whole Economy and Nontraded Industries") ylabel(-10 -5 0 5 10 15 20 25) scheme(s1color) ||lfit diff24_labms diff24_tcapit_over_va [aw=wt80] ||lfit diff24_labms diff24_tcapit_over_va [aw=wtnott80], lpattern(dash) legend(off)
cd ..\results
graph save mnvr_fig4a,replace
cd ..\dta
use mnvr_fig3_4_5,clear
twoway scatter diff24_labms diff24_tcapit_over_va if wtt80!=. [aw=wtt80],mlabsize(3) mlabcolor(black) msymbol(i) mlabel (subind) mlabpos(6) xtitle("Change ICT/VA") ytitle("Change Medium-Skilled Wagebill Share")title("Figure 4B:Growth of Medium-Skilled Share" "Traded Industries Only")legend(off) ylabel(5 10 15 20 25) scheme(s1color) ||lfit diff24_labms diff24_tcapit_over_va [aw=wtt80]
cd ..\results
graph save mnvr_fig4b,replace
* for figure 5
cd ..\dta
use mnvr_fig3_4_5,clear
twoway scatter diff24_labls diff24_tcapit_over_va if wt80!=. [aw=wt80], mlabsize(3) mlabcolor(black) msymbol(i) mlabel(subind) mlabpos(6) xtitle("Change ICT/VA") ytitle("Change Low-Skilled Wagebill Share")title("Figure 5A:Growth of Low-Skilled Share" "Whole Economy and Nontraded Industries") ylabel(-35 -30 -25 -20 -15 -10 -5 0) scheme(s1color) ||lfit diff24_labls diff24_tcapit_over_va [aw=wt80] ||lfit diff24_labls diff24_tcapit_over_va [aw=wtnott80], lpattern(dash) legend(off)
cd ..\results
graph save mnvr_fig5a,replace
cd ..\dta
use mnvr_fig3_4_5,clear
twoway scatter diff24_labls diff24_tcapit_over_va if wtt80!=. [aw=wtt80],mlabsize(4) mlabcolor(black) msymbol(i) mlabel (subind) mlabpos(6) xtitle("Change ICT/VA") ytitle("Change Low-Skilled Wagebill Share")title("Figure 5B: Growth of Low-Skilled Share" "Traded Industries Only")legend(off) ylabel(-30 -25 -20 -15 -10) scheme(s1color) ||lfit diff24_labls diff24_tcapit_over_va [aw=wtt80]
cd ..\results
graph save mnvr_fig5b,replace

cd ..\dta



