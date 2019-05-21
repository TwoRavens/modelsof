/*
Eitan Hersh and Clayton Nall
October 2014
Replication Code for "The Primacy of Race in the Geography of Income-Based Voting," 
American Journal of Political Science
*/

**************
**************
***FIGURE 1***
**************
**************


clear
insheet using "main_catalist_file.csv", clear


sort stdist


gen tot020 = (ry020+dy020+oy020)
gen tot2040 = (ry2040+dy2040+oy2040)
gen tot4060 = (ry4060+dy4060+oy4060)
gen tot6080 = (ry6080+dy6080+oy6080)
gen tot80100 = (ry80100+dy80100+oy80100)
gen tot100120 = (ry100120+dy100120+oy120140)
gen tot120140 = (ry120140+dy120140+oy120140)
gen tot140160 =(ry140160+dy140160+oy140160)
gen tot160180 =(ry160180+dy160180+oy160180)
gen tot180200 =(ry180200+dy180200+oy180200)


gen totalincomeinSHD = (tot020*10)+(tot2040*30)+(tot4060*50)+(tot6080*70)+(tot80100*90)+(tot100120*110)+(tot120140*130)+(tot140160*150)+(tot160180*170)+(tot180200*190)

gen totalpeopleinSHD = tot020+tot2040+tot4060+tot6080+tot80100+tot100120+tot120140+tot140160+tot160180+tot180200

gen ave_inc = totalincomeinSHD/totalpeopleinSHD

gen pct_R_total = (ry020+ry2040 +ry4060 + ry6080+ ry80100 + ry100120 + ry120140 + ry140160 + ry160180 + ry180200)/ (ry020+ry2040 +ry4060 + ry6080+ ry80100 + ry100120 + ry120140 + ry140160 + ry160180 + ry180200 + dy020+dy2040 +dy4060 + dy6080+ dy80100 + dy100120 + dy120140 + dy140160 + dy160180 + dy180200)

keep stdist stabbr st_inc_q state_income district ave_inc pct_R_total

*Group States based on income level
gen group1 =1 if stabb == "KY" | stabb == "LA" | stabb == "ME" | stabb == "NM" | stabb == "OK" | stabb == "SD" | stabb == "WV" | stabb == "WY" 
gen group2 =1 if stabb == "IA" | stabb == "NC" | stabb == "FL" | stabb == "NE" | stabb == "OR" | stabb == "PA" | stabb == "RI"
gen group3 = 1 if stabb == "KS" | stabb == "AZ" | stabb == "DE" | stabb == "NV" | stabb == "NY" | stabb == "UT" | stabb == "NH"
gen group4 = 1 if stabb == "AK" | stabb == "CA" | stabb == "CO" | stabb == "CT" | stabb == "MA" | stabb == "MD" | stabb == "NJ"

replace ave_inc = ln(ave_inc)

*Regression Fit Lines
areg pct_R ave_inc if group1 == 1, a(stabb)
predict yhat_group1
areg pct_R ave_inc if group2 == 1, a(stabb)
predict yhat_group2
areg pct_R ave_inc if group3 == 1, a(stabb)
predict yhat_group3
areg pct_R ave_inc if group4 == 1, a(stabb)
predict yhat_group4

replace yhat_group1 = yhat_group1*100
replace yhat_group2 = yhat_group2*100
replace yhat_group3 = yhat_group3*100
replace yhat_group4 = yhat_group4*100

replace pct_R = pct_R*100

cd derivative

twoway (lowess pct_R ave_inc if stabb == "KY", lwidth(thin) lcolor(gs9)) ///
(lowess pct_R ave_inc if stabb == "LA", lwidth(thick)  lcolor(gs8)) ///
(lowess pct_R ave_inc if stabb == "ME", lwidth(thin) lcolor(gs9))  ///
(lowess pct_R ave_inc if stabb == "NM", lwidth(thin) lcolor(gs9))  ///
(lowess pct_R ave_inc if stabb == "OK", lwidth(thin) lcolor(gs9)) ///
(lowess pct_R ave_inc if stabb == "SD", lwidth(thin) lcolor(gs9))  ///
(lowess pct_R ave_inc if stabb == "WV", lwidth(thin) lcolor(gs9))  ///
(lowess pct_R ave_inc if stabb == "WY", lwidth(thin) lcolor(gs9))  ///
(lfit yhat_group1 ave_inc, lwidth(medthick) lc(black) lpattern(dash)), ///
 xtitle("") ylabel(0(20)100) ///
    text(15 3.5 "Louisiana", color(gs9)) ///
 xlabel(2.5 "$12" 3 "$20" 3.5 "$33" 4 "$55" 4.5 "$90" 5 "$150", valuelabel)  ytitle("") xscale(noextend) yscale(noextend) ///
subtitle(Poorest States) plotregion(style(none)) ///
legend(off) 
graph save withinst1.gph, replace

 

twoway(lowess pct_R ave_inc if stabb == "FL", lwidth(thin) lcolor(gs9)) ///
(lowess pct_R ave_inc if stabb == "IA", lwidth(thin)  lcolor(gs9)) ///
(lowess pct_R ave_inc if stabb == "NC", lwidth(thin) lcolor(gs9))  ///
(lowess pct_R ave_inc if stabb == "NE", lwidth(thin) lcolor(gs9))  ///
(lowess pct_R ave_inc if stabb == "OR", lwidth(thick)  lcolor(gs8)) ///
(lowess pct_R ave_inc if stabb == "PA", lwidth(thin) lcolor(gs9))  ///
(lowess pct_R ave_inc if stabb == "RI", lwidth(thin) lcolor(gs9))  ///
(lfit yhat_group2 ave_inc, lwidth(medthick) lc(black) lpattern(dash)), ///
  xtitle("") ylabel(0(20)100) ///
      text(44 4.6 "Oregon", color(gs9)) ///
 xlabel(2.5 "$12" 3 "$20" 3.5 "$33" 4 "$55" 4.5 "$90" 5 "$150", valuelabel)  ytitle("") xscale(noextend) yscale(noextend) ///
subtitle(Middle-Poor States) plotregion(style(none)) ///
legend(off)
graph save withinst2.gph, replace

 
 
twoway (lowess pct_R ave_inc if stabb == "AZ", lwidth(thin) lcolor(gs9)) ///
(lowess pct_R ave_inc if stabb == "DE", lwidth(thin)  lcolor(gs9)) ///
(lowess pct_R ave_inc if stabb == "KS", lwidth(thin) lcolor(gs9))  ///
(lowess pct_R ave_inc if stabb == "NH", lwidth(thin) lcolor(gs9))  ///
(lowess pct_R ave_inc if stabb == "NV", lwidth(thin) lcolor(gs9)) ///
(lowess pct_R ave_inc if stabb == "NY", lwidth(thin) lcolor(gs9))  ///
(lowess pct_R ave_inc if stabb == "UT", lwidth(thick)  lcolor(gs8))  ///
(lfit yhat_group3 ave_inc, lwidth(medthick) lc(black) lpattern(dash)), ///
  xtitle("")  ylabel(0(20)100) ///
    text(80 3.5 "Utah", color(gs9)) ///
 xlabel(2.5 "$12" 3 "$20" 3.5 "$33" 4 "$55" 4.5 "$90" 5 "$150", valuelabel)  ytitle("") xscale(noextend) yscale(noextend) ///
 subtitle(Middle-Rich States) plotregion(style(none)) ///
legend(off) 
graph save withinst3.gph, replace


twoway(lowess pct_R ave_inc if stabb == "AK", lwidth(thin) lcolor(gs9)) ///
(lowess pct_R ave_inc if stabb == "CA", lwidth(thin)  lcolor(gs9)) ///
(lowess pct_R ave_inc if stabb == "CT", lwidth(thin) lcolor(gs9))  ///
(lowess pct_R ave_inc if stabb == "CO", lwidth(thin) lcolor(gs9))  ///
(lowess pct_R ave_inc if stabb == "MA", lwidth(thin) lcolor(gs9)) ///
(lowess pct_R ave_inc if stabb == "MD", lwidth(thin) lcolor(gs9))  ///
(lowess pct_R ave_inc if stabb == "NJ", lwidth(thick)  lcolor(gs8))  ///
(lfit yhat_group4 ave_inc, lwidth(medthick) lc(black) lpattern(dash)), ///
  xtitle("") ylabel(0(20)100) ///
  text(64 4.8 "New Jersey", color(gs9)) ///
 xlabel(2.5 "$12" 3 "$20" 3.5 "$33" 4 "$55" 4.5 "$90" 5 "$150", valuelabel)  ytitle("") xscale(noextend) yscale(noextend) ///
 subtitle(Richest States) plotregion(style(none)) ///
legend(off)
graph save withinst4.gph, replace
 



graph combine  withinst1.gph  withinst2.gph   withinst3.gph   withinst4.gph, ///
cols(2) rows(2) xsize(6) ysize(5) title("District Income by Partisanship, Group By State Income", size(medsmall)) ///
l1title(Percent Republican of Two-Party Reg., size(small)) b1title("Median District Income in Thousands, Logged Scale", size(small)) 
graph save shd_income.gph, replace


**************
**************
***FIGURE 2***
**************
**************

cd ..

clear
insheet using "main_catalist_file.csv", clear


sort stdist

gen tot020 = (ry020+dy020+oy020)
gen tot2040 = (ry2040+dy2040+oy2040)
gen tot4060 = (ry4060+dy4060+oy4060)
gen tot6080 = (ry6080+dy6080+oy6080)
gen tot80100 = (ry80100+dy80100+oy80100)
gen tot100120 = (ry100120+dy100120+oy120140)
gen tot120140 = (ry120140+dy120140+oy120140)
gen tot140160 =(ry140160+dy140160+oy140160)
gen tot160180 =(ry160180+dy160180+oy160180)
gen tot180200 =(ry180200+dy180200+oy180200)


gen totalincomeinSHD = (tot020*10)+(tot2040*30)+(tot4060*50)+(tot6080*70)+(tot80100*90)+(tot100120*110)+(tot120140*130)+(tot140160*150)+(tot160180*170)+(tot180200*190)

gen totalpeopleinSHD = tot020+tot2040+tot4060+tot6080+tot80100+tot100120+tot120140+tot140160+tot160180+tot180200

gen ave_inc = totalincomeinSHD/totalpeopleinSHD

gen pct_R_total = (ry020+ry2040 +ry4060 + ry6080+ ry80100 + ry100120 + ry120140 + ry140160 + ry160180 + ry180200)/ (ry020+ry2040 +ry4060 + ry6080+ ry80100 + ry100120 + ry120140 + ry140160 + ry160180 + ry180200 + dy020+dy2040 +dy4060 + dy6080+ dy80100 + dy100120 + dy120140 + dy140160 + dy160180 + dy180200)

keep stdist stabbr st_inc_q state_income district ave_inc pct_R_total



*Group by state pct black
gen group1 =1 if stabb == "LA" | stabb == "MD" | stabb == "NC" | stabb == "DE" | stabb == "NY" | stabb == "FL" | stabb == "NJ" | stabb == "PA" 
gen group2 =1 if stabb == "CT" | stabb == "OK" | stabb == "KY" | stabb == "NV" | stabb == "CA" | stabb == "KS" | stabb == "MA"
gen group3 = 1 if stabb == "RI" | stabb == "NE" | stabb == "CO" | stabb == "AK" | stabb == "WV" | stabb == "AZ" | stabb == "IA"
gen group4 = 1 if stabb == "NM" | stabb == "OR" | stabb == "NH" | stabb == "UT" | stabb == "WY" | stabb == "SD" | stabb == "ME"

replace ave_inc = ln(ave_inc)


*
areg pct_R ave_inc if group1 == 1, a(stabb)
predict yhat_group1
areg pct_R ave_inc if group2 == 1, a(stabb)
predict yhat_group2
areg pct_R ave_inc if group3 == 1, a(stabb)
predict yhat_group3
areg pct_R ave_inc if group4 == 1, a(stabb)
predict yhat_group4


*Regression Fit Lines
replace yhat_group1 = yhat_group1*100
replace yhat_group2 = yhat_group2*100
replace yhat_group3 = yhat_group3*100
replace yhat_group4 = yhat_group4*100

replace pct_R = pct_R*100

cd derivative 


twoway (lowess pct_R ave_inc if stabb == "LA" , lwidth(thick)  lcolor(gs8)) ///
(lowess pct_R ave_inc if stabb == "MD", lwidth(thin)  lcolor(gs9)) ///
(lowess pct_R ave_inc if stabb == "NC", lwidth(thin) lcolor(gs9))  ///
(lowess pct_R ave_inc if stabb == "DE", lwidth(thin) lcolor(gs9))  ///
(lowess pct_R ave_inc if stabb == "NY", lwidth(thin) lcolor(gs9)) ///
(lowess pct_R ave_inc if stabb == "FL", lwidth(thin) lcolor(gs9))  ///
(lowess pct_R ave_inc if stabb == "NJ", lwidth(thick)  lcolor(gs8))  ///
(lowess pct_R ave_inc if stabb == "PA", lwidth(thin) lcolor(gs9))  ///
(lfit yhat_group1 ave_inc, lwidth(medthick) lc(black) lpattern(dash)), ///
 xtitle("") ylabel(0(20)100) ///
    text(0 3.4 "New Jersey", color(gs9)) ///
	text(69 4.45 "Louisiana", color(gs9)) ///
 xlabel(2.5 "$12" 3 "$20" 3.5 "$33" 4 "$55" 4.5 "$90" 5 "$150", valuelabel)  ytitle("") xscale(noextend) yscale(noextend) ///
subtitle("Highest Pct. Black States") plotregion(style(none)) ///
legend(off) 
graph save bwithinst1.gph, replace

 

twoway(lowess pct_R ave_inc if stabb == "CT", lwidth(thin) lcolor(gs9)) ///
(lowess pct_R ave_inc if stabb == "OK", lwidth(thin)  lcolor(gs9)) ///
(lowess pct_R ave_inc if stabb == "KY", lwidth(thin) lcolor(gs9))  ///
(lowess pct_R ave_inc if stabb == "NV", lwidth(thin) lcolor(gs9))  ///
(lowess pct_R ave_inc if stabb == "CA", lwidth(thin) lcolor(gs9)) ///
(lowess pct_R ave_inc if stabb == "KS", lwidth(thin) lcolor(gs9))  ///
(lowess pct_R ave_inc if stabb == "MA", lwidth(thin) lcolor(gs9))  ///
(lfit yhat_group2 ave_inc, lwidth(medthick) lc(black) lpattern(dash)), ///
  xtitle("") ylabel(0(20)100) ///
 xlabel(2.5 "$12" 3 "$20" 3.5 "$33" 4 "$55" 4.5 "$90" 5 "$150", valuelabel)  ytitle("") xscale(noextend) yscale(noextend) ///
subtitle("Second Highest Pct. Black States") plotregion(style(none)) ///
legend(off)
graph save bwithinst2.gph, replace

 
 
twoway (lowess pct_R ave_inc if stabb == "RI", lwidth(thin) lcolor(gs9)) ///
(lowess pct_R ave_inc if stabb == "NE", lwidth(thin)  lcolor(gs9)) ///
(lowess pct_R ave_inc if stabb == "CO", lwidth(thin) lcolor(gs9))  ///
(lowess pct_R ave_inc if stabb == "AK", lwidth(thin) lcolor(gs9))  ///
(lowess pct_R ave_inc if stabb == "WV", lwidth(thin) lcolor(gs9)) ///
(lowess pct_R ave_inc if stabb == "AZ", lwidth(thin) lcolor(gs9))  ///
(lowess pct_R ave_inc if stabb == "IA", lwidth(thin) lcolor(gs9))  ///
(lfit yhat_group3 ave_inc, lwidth(medthick) lc(black) lpattern(dash)), ///
  xtitle("")  ylabel(0(20)100) ///
 xlabel(2.5 "$12" 3 "$20" 3.5 "$33" 4 "$55" 4.5 "$90" 5 "$150", valuelabel)  ytitle("") xscale(noextend) yscale(noextend) ///
 subtitle("Second Lowest Pct. Black States") plotregion(style(none)) ///
legend(off) 
graph save bwithinst3.gph, replace


twoway(lowess pct_R ave_inc if stabb == "NM", lwidth(thin) lcolor(gs9)) ///
(lowess pct_R ave_inc if stabb == "OR", lwidth(thick)  lcolor(gs8)) ///
(lowess pct_R ave_inc if stabb == "NH", lwidth(thin) lcolor(gs9))  ///
(lowess pct_R ave_inc if stabb == "UT", lwidth(thick)  lcolor(gs8))  ///
(lowess pct_R ave_inc if stabb == "WY", lwidth(thin) lcolor(gs9)) ///
(lowess pct_R ave_inc if stabb == "SD", lwidth(thin) lcolor(gs9))  ///
(lowess pct_R ave_inc if stabb == "ME", lwidth(thin) lcolor(gs9))  ///
(lfit yhat_group4 ave_inc, lwidth(medthick) lc(black) lpattern(dash)), ///
  xtitle("") ylabel(0(20)100) ///
    text(85 4.6 "Utah", color(gs9)) ///
	text(44 4.6 "Oregon", color(gs9)) ///
 xlabel(2.5 "$12" 3 "$20" 3.5 "$33" 4 "$55" 4.5 "$90" 5 "$150", valuelabel)  ytitle("") xscale(noextend) yscale(noextend) ///
 subtitle("Lowest Pct. Black States") plotregion(style(none)) ///
legend(off)
graph save bwithinst4.gph, replace



graph combine  bwithinst1.gph  bwithinst2.gph   bwithinst3.gph   bwithinst4.gph, ///
cols(2) rows(2) xsize(6) ysize(5) title("District Income by Partisanship, Grouped By State Percent Black", size(medsmall)) ///
l1title(Proportion Republican of Two-Party Reg., size(small)) b1title("Median District Income in Thousands, Logged Scale", size(small)) 
graph save shd_race.gph, replace


**************
**************
***FIGURE 3***
**************
**************

cd .. 

insheet using "main_catalist_file.csv", clear

sort stdist

gen black3 = 1 if sh_black >= .10
replace black3 = 2 if sh_black >=.05 & sh_black <.10
replace black3 = 3 if sh_black <.05 & sh_black !=.

gen state_black3 = stabb+string(black3)
collapse (sum) dy020-dy160180, by(state_black3)

drop dunk-oy180200 
drop ounk

gen pctR020 = ry020/(ry020+dy020)
gen pctR2040 = ry2040/(ry2040+dy2040)
gen pctR4060 = ry4060/(ry4060+dy4060)
gen pctR6080 = ry6080/(ry6080+dy6080)
gen pctR80100 = ry80100/(ry80100+dy80100)
gen pctR100plus = (ry100120+ry120140+ry140160+ry160180+ry180200)/(ry100120+ry120140+ry140160+ry160180+ry180200+dy100120+dy120140+dy140160+dy160180+dy180200)
gen ry100plus = ry100120+ry120140+ry140160+ry160180+ry180200


gen obs020 = (ry020+dy020)
gen obs2040 = (ry2040+dy2040)
gen obs4060 = (ry4060+dy4060)
gen obs6080 = (ry6080+dy6080)
gen obs80100 = (ry80100+dy80100)
gen obs100plus = (ry100120+ry120140+ry140160+ry160180+ry180200+dy100120+dy120140+dy140160+dy160180+dy180200)


replace pctR020 = . if obs020 < 30
replace pctR2040 = . if obs2040 < 30
replace pctR4060 = . if obs4060 < 30
replace pctR6080 = . if obs6080 < 30
replace pctR80100 = . if obs80100 < 30
replace pctR100p = . if obs100p < 30

drop obs* dy* ry*

gen state = substr(state_black,1,2)
gen black = substr(state_black,3,2)
destring black, replace

cd derivative 

save black3states.dta, replace
gen inc_cat = 1
append using black3states.dta
recode inc_cat .=2
append using black3states.dta
recode inc_cat .=3
append using black3states.dta
recode inc_cat .=4
append using black3states.dta
recode inc_cat .=5
append using black3states.dta
recode inc_cat .=6



gen pct_R = pctR020 if inc_cat ==1
replace pct_R = pctR2040 if inc_cat == 2
replace pct_R = pctR4060 if inc_cat == 3
replace pct_R = pctR6080 if inc_cat == 4
replace pct_R = pctR80100 if inc_cat == 5
replace pct_R = pctR100plus if inc_cat == 6

drop pctR*

sort inc_cat

label define income62 1 "<2" 2 "2-4" 3 "4-6" 4 "6-8" 5 "8-10" 6 "10+" 7 "Leg."
label values inc_cat income62

replace pct_R = pct_R*100 

*WEST
twoway (lowess pct_R inc_cat if state == "AK" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "AZ" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "CA" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "CO" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NM" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NV" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "OR" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
, ///
legend(off) plotregion(style(none)) yscale(noextend) xscale(noextend) ///
ylabel(0 10 30 50 70 90) ytitle(" ")  ///
xlabel(1(1)6, valuelabel ticks labsize(small)) xtitle("") ///
 subtitle(" ")
graph save west3b.gph, replace


twoway (lowess pct_R inc_cat if state == "AK" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "AZ" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "CA" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "CO" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NM" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NV" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "OR" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
, ///
legend(off) plotregion(style(none)) yscale(noextend) xscale(noextend) ///
ylabel(0 10 30 50 70 90) ytitle(" ")  ///
xlabel(1(1)6, valuelabel ticks labsize(small)) xtitle("") ///
subtitle(WEST)
graph save west2b.gph, replace

twoway (lowess pct_R inc_cat if state == "AK" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "AZ" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "CA" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "CO" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NM" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NV" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "OR" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
, ///
legend(off) plotregion(style(none)) yscale(noextend) xscale(noextend) ///
ylabel(0 10 30 50 70 90) ytitle(" ")  ///
xlabel(1(1)6, valuelabel ticks labsize(small)) xtitle("") ///
 subtitle(" ")
graph save west1b.gph, replace

twoway (scatter pct_R inc_cat, msymbol(none)), plotregion(style(none)) ///
yscale(off) ylabel(none)  xscale(off) xlabel(7(1)7, labsize(small) valuelabel ticks) ///
fxsize(5) ///
 text(80 7 "AK", color(gs4)) ///
 text(72 7 "AZ", color(gs4)) ///
 text(64 7 "CA", color(gs4)) ///
 text(56 7 "CO", color(gs4)) ///
 text(48 7 "NM", color(gs4)) ///
 text(40 7 "NV", color(gs4)) ///
 text(32 7 "OR", color(gs4)) 
 graph save west_black_leg.gph, replace

 
 

*MIDWEST
twoway (lowess pct_R inc_cat if state == "IA" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NE" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "SD" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "UT" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "WY" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "KS" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
, ///
legend(off) plotregion(style(none)) yscale(noextend) xscale(noextend) ///
ylabel(0 10 30 50 70 90) ytitle(" ")  ///
xlabel(1(1)6, valuelabel ticks labsize(small)) xtitle("") ///
 subtitle(" ")
graph save mid3b.gph, replace


twoway (lowess pct_R inc_cat if state == "IA" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NE" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "SD" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "UT" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "WY" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "KS" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
, ///
legend(off) plotregion(style(none)) yscale(noextend) xscale(noextend) ///
ylabel(0 10 30 50 70 90) ytitle(" ")  ///
xlabel(1(1)6, valuelabel ticks labsize(small)) xtitle("") ///
subtitle(MIDWEST)
graph save mid2b.gph, replace

twoway (lowess pct_R inc_cat if state == "IA" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NE" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "SD" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "UT" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "WY" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "KS" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
, ///
legend(off) plotregion(style(none)) yscale(noextend) xscale(noextend) ///
ylabel(0 10 30 50 70 90) ytitle(" ")  ///
xlabel(1(1)6, valuelabel ticks labsize(small)) xtitle("") ///
 subtitle(" ")
graph save mid1b.gph, replace

twoway (scatter pct_R inc_cat, msymbol(none)), plotregion(style(none)) ///
yscale(off) ylabel(none)  xscale(off) xlabel(7(1)7, labsize(small) valuelabel ticks) ///
fxsize(5) ///
 text(80 7 "IA", color(gs4)) ///
 text(72 7 "NE", color(gs4)) ///
 text(64 7 "SD", color(gs4)) ///
 text(56 7 "UT", color(gs4)) ///
 text(48 7 "WY", color(gs4)) ///
 text(40 7 "KS", color(gs4)) 
 graph save midwest_black_leg.gph, replace

 
 

*NORTH
twoway (lowess pct_R inc_cat if state == "CT" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "DE" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "MA" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "MD" & black == 3, lc(gs4)  lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "ME" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NH" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NJ" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NY" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "PA" & black == 3, lc(gs4) lpattern(solid)  lwidth(thin)) ///
(lowess pct_R inc_cat if state == "RI" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
, ///
legend(off) plotregion(style(none)) yscale(noextend)  ///
ylabel(0 10 30 50 70 90) ytitle(" ") xscale(noextend)  ///
xlabel(1(1)6, valuelabel ticks labsize(small)) xtitle("") /// 
title("<5% Black Dists.") ///
 subtitle(" ")
 graph save north3b.gph, replace




twoway (lowess pct_R inc_cat if state == "CT" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "DE" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "MA" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "MD" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "ME" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NH" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NJ" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NY" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "PA" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "RI" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
, ///
legend(off) plotregion(style(none)) yscale(noextend) xscale(noextend) ///
ylabel(0 10 30 50 70 90) ytitle(" ")  ///
xlabel(1(1)6, valuelabel ticks labsize(small)) xtitle("") ///
title("5-10% Black Dists.") subtitle(NORTH)
graph save north2b.gph, replace

twoway (lowess pct_R inc_cat if state == "CT" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "DE" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "MA" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "MD" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "ME" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NH" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NJ" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NY" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "PA" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "RI" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
, ///
legend(off) plotregion(style(none)) yscale(noextend) xscale(noextend) ///
ylabel(0 10 30 50 70 90) ytitle(" ")  ///
xlabel(1(1)6, valuelabel ticks labsize(small)) xtitle("") ///
title("10%+ Black Dists.") /// 
 subtitle(" ")
graph save north1b.gph, replace

twoway (scatter pct_R inc_cat, msymbol(none)), plotregion(style(none)) ///
yscale(off) ylabel(none)  xscale(off) xlabel(7(1)7, labsize(small) valuelabel ticks) ///
fxsize(5) ///
 text(80 7 "CT", color(gs4)) ///
 text(72 7 "DE", color(gs4)) ///
 text(64 7 "MA", color(gs4)) ///
 text(56 7 "MD", color(gs4)) ///
 text(48 7 "ME", color(gs4)) ///
 text(40 7 "NH", color(gs4)) ///
 text(32 7 "NJ", color(gs4)) ///
 text(24 7 "NY", color(gs4)) ///
 text(16 7 "PA", color(gs4)) ///
 text(08 7 "RI", color(gs4))
 graph save north_black_leg.gph, replace

 
 

*South

twoway (lowess pct_R inc_cat if state == "FL" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "KY" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "LA" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NC" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "OK" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "WV" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
, ///
legend(off) plotregion(style(none)) yscale(noextend) xscale(noextend) ///
ylabel(0 10 30 50 70 90) ytitle(" ")  ///
xlabel(1(1)6, valuelabel ticks labsize(small)) xtitle("") ///
 subtitle(" ")
graph save south3b.gph, replace


twoway (lowess pct_R inc_cat if state == "FL" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "KY" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "LA" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NC" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "OK" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "WV" & black == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
, ///
legend(off) plotregion(style(none)) yscale(noextend) xscale(noextend) ///
ylabel(0 10 30 50 70 90) ytitle(" ")  ///
xlabel(1(1)6, valuelabel ticks labsize(small)) xtitle("") ///
 subtitle(SOUTH)
graph save south2b.gph, replace

twoway (lowess pct_R inc_cat if state == "FL" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "KY" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "LA" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NC" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "OK" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "WV" & black == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
, ///
legend(off) plotregion(style(none)) yscale(noextend) xscale(noextend) ///
ylabel(0 10 30 50 70 90) ytitle(" ")  ///
xlabel(1(1)6, valuelabel ticks labsize(small)) xtitle("") ///
 subtitle(" ")
graph save south1b.gph, replace

twoway (scatter pct_R inc_cat, msymbol(none)), plotregion(style(none)) ///
yscale(off) ylabel(none)  xscale(off) xlabel(7(1)7, labsize(small) valuelabel ticks) ///
fxsize(5) ///
 text(80 7 "FL", color(gs4)) ///
 text(72 7 "KY", color(gs4)) ///
 text(64 7 "LA", color(gs4)) ///
 text(56 7 "NC", color(gs4)) ///
 text(48 7 "OK", color(gs4)) ///
 text(40 7 "WV", color(gs4)) 
 graph save south_black_leg.gph, replace


graph combine  north3b.gph north2b.gph north1b.gph north_black_leg.gph south3b.gph south2b.gph south1b.gph south_black_leg.gph ///
 mid3b.gph mid2b.gph mid1b.gph midwest_black_leg.gph west3b.gph west2b.gph west1b.gph west_black_leg.gph, rows(4) xsize(6) ysize(8)  ///
 l1title(Percent Republican, size(medsmall)) b1title("Census Block Group Income, in $10K", size(medsmall)) 

**************
**************
***FIGURE 4***
**************
**************

/*
Figure 4 is composed from regression coefficient estimates, derived from a 1% sample of individual-level Catalist data. Here, we provide 
the code for producing the regressions from the 1% sample. Then, we create a .csv file with the regression coefficients that
 are plotted in Figure 4. We provide code that generates the plots from the regression coefficients in the .csv. We do not 
 provide the original, individual-level data from the Catalist 1% sample. The file can be produced by the authors, by request,
 for the purpose  of peer review, but not for the purpose of new analysis. For new analysis, scholars should contact Catalist.
Catalist academic subscriptions come with 1% samples. Scholars who have Catalist subscriptions may also request to have older 
versions of the 1% sample (such as ours) shared with them.


use state id_regdate ca_partyaff id_regdate di_statehouse ge_fips ce_medianhhincome ce_pctwhite ce_pctblack ///
 using 1pct_sample.dta, clear
 
 replace ge_fips = "" if ge_fips == "UNKNOWN"
destring ge_fips, gen(fips_nonstr)

gen gop_reg = 1 if ca_partyaff == "REP"
replace gop_reg =0 if ca_partyaff == "DEM"

drop if state == "OH" 
**Ohio is not a party-registration state, even though some voters are listed in the Ohio voter file as registered Republicans
**or Democrats.


drop if di_statehouse == ""
gen st_stleg = state_name + di_statehousedist


gen cbg = ce_medianhhinc/10000

bysort st_stleg: egen sh_medinc = mean(cbg)
bysort st_stleg: egen sh_black = mean(ce_pctblack)

replace fips_nonstr = . if fips_nonstr < 100000000

gen south = 1 if state_name == "FL" | state_name == "KY" | state_name == "LA" | state_name == "NC" | state_name == "OK" | state_name == "WV"
recode south .=0

gen shinc3 = 1 if sh_medinc < 4
replace shinc3 = 2 if sh_medinc >=4 & sh_medinc < 6
replace shinc3 = 3 if sh_medinc >=6 & sh_medinc !=. 

gen shrace3 = 1 if sh_black < .05
replace shrace3 = 2 if sh_black >=.05 & sh_black < .1
replace shrace3 = 3 if sh_black >=.1 & sh_black !=. 


reg gop_reg cbg if shinc3 == 1  & (shrace3 ==1 ) & south == 0 , vce(cluster fips_nonstr) 
reg gop_reg cbg if shinc3 == 2  & (shrace3 ==1) & south == 0 , vce(cluster fips_nonstr) 
reg gop_reg cbg if shinc3 == 3  & (shrace3 ==1)  & south == 0, vce(cluster fips_nonstr) 
reg gop_reg cbg if shinc3 == 1  & (shrace3 >1  ) & south == 0, vce(cluster fips_nonstr) 
reg gop_reg cbg if shinc3 == 2  & (shrace3 >1) & south == 0, vce(cluster fips_nonstr) 
reg gop_reg cbg if shinc3 == 3  & (shrace3 >1) & south == 0, vce(cluster fips_nonstr) 

reg gop_reg cbg if shinc3 == 1  & (shrace3 ==1 ) & south == 1, vce(cluster fips_nonstr) 
reg gop_reg cbg if shinc3 == 2  & (shrace3 ==1) & south == 1, vce(cluster fips_nonstr) 
reg gop_reg cbg if shinc3 == 3  & (shrace3 ==1) & south == 1, vce(cluster fips_nonstr) 
reg gop_reg cbg if shinc3 == 1  & (shrace3 >1  ) & south == 1, vce(cluster fips_nonstr) 
reg gop_reg cbg if shinc3 == 2  & (shrace3 >1) & south == 1 , vce(cluster fips_nonstr) 
reg gop_reg cbg if shinc3 == 3  & (shrace3 >1) & south == 1, vce(cluster fips_nonstr) 

reg gop_reg cbg if shrace3 == 1  & (sh_medinc <5 ) & south == 0 , vce(cluster fips_nonstr) 
reg gop_reg cbg if shrace3 == 2  & (sh_medinc <5) & south == 0 , vce(cluster fips_nonstr) 
reg gop_reg cbg if shrace3 == 3  & (sh_medinc <5)  & south == 0, vce(cluster fips_nonstr) 
reg gop_reg cbg if shrace3 == 1  & (sh_medinc > 5  ) & south == 0, vce(cluster fips_nonstr) 
reg gop_reg cbg if shrace3 == 2  & (sh_medinc > 5 ) & south == 0, vce(cluster fips_nonstr) 
reg gop_reg cbg if shrace3 == 3  & (sh_medinc > 5 ) & south == 0, vce(cluster fips_nonstr) 

reg gop_reg cbg if shrace3 == 1  & (sh_medinc <5) & south == 1, vce(cluster fips_nonstr) 
reg gop_reg cbg if shrace3 == 2  & (sh_medinc <5) & south == 1, vce(cluster fips_nonstr) 
reg gop_reg cbg if shrace3 == 3  & (sh_medinc <5) & south == 1, vce(cluster fips_nonstr) 
reg gop_reg cbg if shrace3 == 1  & (sh_medinc > 5 ) & south == 1, vce(cluster fips_nonstr) 
reg gop_reg cbg if shrace3 == 2  & (sh_medinc > 5 ) & south == 1 , vce(cluster fips_nonstr) 
reg gop_reg cbg if shrace3 == 3  & (sh_medinc > 5 ) & south == 1, vce(cluster fips_nonstr) 

**The above regression slope coefficients are saved in figure_4_regressions.csv
*/

cd .. 
insheet using figure_4_regressions.csv, clear

replace coef = coef*100
replace lb = lb*100
replace ub = ub*100

cd derivative

twoway (rspike lb ub shinc if black ==0 & south ==0 & type ==1, fcolor(gs9) lcolor(gs9)) ///
 (rspike lb ub shinc if black ==1 & south ==0 & type ==1, fcolor(gs1) lcolor(gs1)) ///
 (line coef shinc if black == 0 & south ==0 & type ==1 ,   lpattern(dash) lcolor(gs9)) ///
  (line coef shinc if black == 1 & south ==0 & type ==1 ,   lpattern(dash) lcolor(gs1)), ///
 yscale(noextend) xscale(noextend) plotregion(style(none)) ///
 xlabel(1 "<$40K" 2 "$40-60K" 3 "$60K+", valuelabels) ///
 xtitle(State House Dist. Ave. Income) legend(off)  ///
  ylabel(0(2)8) text(5.5 1.5 "Districts > 5% Black", color(gs1)) text(1.5 1.5 "Districts < 5% Black", color(gs9))  
 graph save table_graph1.gph, replace
	
 twoway  (rspike lb ub shinc if black ==0 & south == 1 & type ==1, fcolor(gs9) lcolor(gs9)) ///
 (rspike lb ub shinc if black ==1 & south == 1 & type ==1, fcolor(gs1) lcolor(gs1)) ///
 (line coef shinc if black == 0 & south == 1 & type ==1,   lpattern(solid) lcolor(gs9)) ///
 (line coef shinc if black == 1 & south == 1 & type ==1,   lpattern(solid) lcolor(gs1)), ///
 yscale(noextend) xscale(noextend) plotregion(style(none)) ///
 xlabel(1 "<$40K" 2 "$40-60K" 3 "$60K+", valuelabels) ///
 xtitle(State House Dist. Ave. Income) legend(off)  ///
 ylabel(0(2)8)  text(6.8 2 "Districts > 5% Black", color(gs1)) text(1 2 "Districts < 5% Black", color(gs9)) 
 graph save table_graph2.gph, replace
 
 
 twoway (rspike lb ub black if shinc ==0 & south ==0 & type ==2, fcolor(gs9) lcolor(gs9)) ///
 (rspike lb ub black  if  shinc ==5 & south ==0 & type ==2, fcolor(gs1) lcolor(gs1)) ///
 (line coef black if shinc == 0 & south ==0 & type ==2 ,   lpattern(dash) lcolor(gs9)) ///
  (line coef black if shinc == 5 & south ==0 & type ==2 ,   lpattern(dash) lcolor(gs1)), ///
 yscale(noextend) xscale(noextend) plotregion(style(none)) ///
 xlabel(1 "<5%" 2 "5-10%" 3 "10%+", valuelabels) ///
 xtitle(State House Dist. Pct. Black) legend(off)   ///
 ylabel(0(2)8) text(1.1 2.5 "Wealthier Districts", color(gs1)) text(4.65 2.5 "Poorer Districts", color(gs9))  
 graph save table_graph3.gph, replace
 
 twoway (rspike lb ub black if shinc ==0 & south ==1 & type ==2, fcolor(gs9) lcolor(gs9)) ///
 (rspike lb ub black  if  shinc ==5 & south ==1 & type ==2, fcolor(gs1) lcolor(gs1)) ///
 (line coef black if shinc == 0 & south ==1 & type ==2 ,   lpattern(dash) lcolor(gs9)) ///
  (line coef black if shinc == 5 & south ==1 & type ==2 ,   lpattern(dash) lcolor(gs1)), ///
 yscale(noextend) xscale(noextend) plotregion(style(none)) ///
 xlabel(1 "<5%" 2 "5-10%" 3 "10%+", valuelabels) ///
 xtitle(State House Dist. Pct. Black) legend(off)   ///
 ylabel(0(2)8) text(2.5 2.5 "Wealthier Districts", color(gs1)) text(7 2.5 "Poorer Districts", color(gs9))  
 graph save table_graph4.gph, replace
  
 
 graph combine table_graph1.gph table_graph2.gph, cols(2) title(By District Income, size(medsmall)) saving(top2.gph, replace)
 graph combine table_graph3.gph table_graph4.gph, cols(2) title(By District Race, size(medsmall)) saving(bottom2.gph, replace)
 
 graph combine top2.gph bottom2.gph, cols(1) xsize(6.5) ysize(6) ///
 l1title("Percentage Pt. Increase in GOP Reg. per $10K in Income", size(medsmall)) ///
 title(NON-SOUTH				SOUTH, size(medsmall))

 
 
 
**************
**************
***FIGURE 6***
**************
**************

cd .. 
 
 insheet using figure_6_map_coeffs.csv, clear
 
 gen south = 1 if state == "FL" | state == "KY" | state== "LA" | state == "NC" | state == "OK" | state == "WV"
recode south .=0
replace south = 1 if state == "TX" | state == "MS" | state == "AR" | state == "AL" | state == "GA" | state == "SC" | state == "VA" | state == "TN"

replace medhh = medhh*100
replace sh_black = sh_black*100

gen shrace5 = 1 if sh_black < 1
replace shrace5 = 2 if sh_black >=1 & sh_black < 5
replace shrace5 = 3 if sh_black >=5 & sh_black < 10
replace shrace5 = 4 if sh_black >=10 & sh_black < 25
replace shrace5 = 5 if sh_black >=25 & sh_black !=. 

 gen lnblack = ln(sh_black)
replace lnblack = -3 if sh_black < .05

cd derivative 
twoway (scatter medhhinc10k lnblack if south == 0, mcolor(gs9) msymbol(circle)) ///
(lowess medhhinc10k lnblack if south == 0, lcolor(black) lwidth(thick)), ///
plotregion(style(none)) yscale(noextend) legend(off) ///
xtitle("") ytitle("") ///
subtitle("Non-South") ylabel(-10(5)20) ///
xlabel(-3 "<.05%" -2.3 "0.1%" -.69 "0.5%" 0 "1%" .92 "2.5%"	1.6 "5%"  2.3 "10%" 3.2 "25%" 3.9 "50%", valuelabel)
graph save nsg5.gph, replace

twoway (scatter medhhinc10k lnblack if south == 1, mcolor(gs9) msymbol(circle)) ///
(lowess medhhinc10k lnblack if south == 1, lcolor(black) lwidth(thick)), ///
plotregion(style(none)) yscale(noextend)  legend(off) ///
xtitle("") ytitle("") ///
subtitle("South") ylabel(-10(5)20) ///
xlabel(-3 "<.05%" -2.3 "0.1%" -.69 "0.5%" 0 "1%" .92 "2.5%"	1.6 "5%"  2.3 "10%" 3.2 "25%" 3.9 "50%", valuelabel)
graph save sg5.gph, replace


graph combine  nsg5.gph sg5.gph, ///
cols(2) rows(1) xsize(6) ysize(3) title("Effect of Income on Precinct Voting by Region and by District Race", size(medsmall)) ///
l1title("Pct. Point Increase in Republican Support Per $10,000 in Income", size(small)) b1title("State House District Percent Black, Logged Scale", size(small)) 



 

