/*
Eitan Hersh and Clayton Nall
October 2014
Replication Code for "The Primacy of Race in the Geography of Income-Based Voting," 
American Journal of Political Science

APPENDIX MATERIALS

*/


****************
***FIG A.1:
****************

u cces_fields_appendix_replication.dta, clear

gen weight = V201
tab votersta [aw=weight], mis
drop if votersta == "unregistered"
drop if votersta == ""
drop if CC332 == 2
gen valid_voter = 1 if e2008g != ""
replace valid_voter =0 if e2008g == ""

gen partyreg = 1 if state == "AK"
replace partyreg = 1 if state == 	"CT"
replace partyreg = 1 if state == 	"DC"
replace partyreg = 1 if state == 	"DE"
replace partyreg = 1 if state == 	"FL"
replace partyreg = 1 if state == 	"KS"
replace partyreg = 1 if state == 	"KY"
replace partyreg = 1 if state == 	"LA"
replace partyreg = 1 if state == 	"NE"
replace partyreg = 1 if state == 	"OK"
replace partyreg = 1 if state == 	"SD"
replace partyreg = 1 if state == 	"UT"
replace partyreg = 1 if state == 	"WY"
replace partyreg = 1 if state == 	"AZ"
replace partyreg = 1 if state == 	"CA"
replace partyreg = 1 if state == 	"CO"
replace partyreg = 1 if state == 	"IA"
replace partyreg = 1 if state == 	"MA"
replace partyreg = 1 if state == 	"MD"
replace partyreg = 1 if state == 	"ME"
replace partyreg = 1 if state == 	"NC"
replace partyreg = 1 if state == 	"NH"
replace partyreg = 1 if state == 	"NJ"
replace partyreg = 1 if state == 	"NM"
replace partyreg = 1 if state == 	"NV"
replace partyreg = 1 if state == 	"NY"
replace partyreg = 1 if state == 	"OR"
replace partyreg = 1 if state == 	"PA"
replace partyreg = 1 if state == 	"RI"
replace partyreg = 1 if state == 	"WV"

keep if partyreg == 1

gen R_aff = 1 if partyaff == "REP"
replace R_aff = 0 if partyaff == "DEM"

gen R_pid = 1 if CC307 == 2
replace R_pid = 0 if CC307 == 1

gen R_pres = 1 if CC327 == 1
replace R_pres =0 if CC327 == 2

gen R_SHvote = 1 if CC414_1 == 2
replace R_SHvote = 0 if CC414_1 == 1


tab R_aff R_pid [aw=weight], row col
tab R_aff R_pres [aw=weight], row col
tab R_aff R_SHvote  [aw=weight], row col

tetrachoric R_aff R_pid 
*.99
tetrachoric R_aff R_pres
*.93
tetrachoric R_aff R_SH if state != "DC"
*.96

bysort state: egen st_R_aff = mean(R_aff)
bysort state: egen st_R_pid = mean(R_pid)
bysort state: egen st_R_pres = mean(R_pres) 
bysort state: egen st_R_SHvote = mean(R_SHvote) 

sort state
keep if state!= state[_n-1] | _n == 1

cor st_R_aff st_R_pid
*.94
cor st_R_aff st_R_pres
*.84
cor st_R_aff st_R_SH if state != "DC"
*.85

cd derivative


twoway (scatter st_R_pid st_R_aff, msymbol(none) mlabel(state)), ///
ytitle("GOP Two-Party PID")  xtitle("GOP Two-Party Reg.") ///
text(.65 .2 "State-Level Corr: 0.94") ///
title(Party Registration vs. Party ID) legend(off) scheme(s1mono) plotregion(style(none))
graph save PID2.gph, replace

twoway (scatter st_R_pres st_R_aff, msymbol(none) mlabel(state)), ///
ytitle("McCain Pres. Vote Share")  xtitle("GOP Two-Party Reg.") ///
 text(.65 .2 "State-Level Corr: 0.84") ///
title(Party Registration vs. Presidential Vote) legend(off) scheme(s1mono) plotregion(style(none))
graph save Pres2.gph, replace

twoway (scatter st_R_SH st_R_aff if state != "DC", msymbol(none) mlabel(state)), ///
ytitle("GOP State House Dist. Vote Share")  xtitle("GOP Two-Party Reg.") ///
 text(.65 .2 "State-Level Corr: 0.85") xlabel(0(.2).8) ylabel(0(.2).8)  ///
title(Party Registration vs. State House District Vote) legend(off) scheme(s1mono) plotregion(style(none))
graph save SHDvote2.gph, replace


clear
set obs 3
gen cors = 1 if _n ==1
replace cors = 2 if _n ==2
replace cors = 3 if _n == 3

label define cors 1 "Party ID" 2 "Pres. Vote" 3 "S.H. Dist. Vote"
label values cors cors


gen vals = .99 if _n == 1
replace vals = .93 if _n==2 
replace vals = .96 if _n==3

twoway (scatter vals cors, mcolor(black) msize(large)), ///
ytitle("Corr(Party Reg., Survey Measures)") ylabel(.5(.1)1)  xtitle(Survey Measures of Partisanship,  margin(medium))  xlabel(.5(1)3.5, nolabels noticks) ///
title(Individual-Level Correlations) legend(off) scheme(s1mono) plotregion(style(none)) ///
text(.51 1.1 "Party ID") text(.51 2.1 "Pres. Vote") text(.51 3.1 "SH Dist. Vote")
graph save indiv.gph, replace


graph combine indiv.gph PID2.gph Pres2.gph SHDvote2.gph, cols(2) rows(2) iscale(.65) scheme(s1mono)



****************
***FIG A-2
****************
cd ..

u figure_a2_data_bystate.dta, clear

cor st_reg_r st_pres_r
cor st_reg_r st_norm_r

cd derivative
twoway (scatter st_reg_r st_pres_r, msymbol(none) mlabel(state)), ///
text(.65 .2 "State Level Corr: 0.79") ///
title(Party Registration vs. Presidential Vote Returns) subtitle(by State) legend(off) scheme(s1mono) plotregion(style(none)) ///
ytitle("GOP Two-Party Reg.") xtitle("GOP Two-Party Precinct Returns")
graph save precinc_state.gph, replace

twoway (scatter st_reg_r st_norm_r, msymbol(none) mlabel(state)), ///
text(.65 .2 "State Level Corr: 0.71") ///
title(Party Registration vs. the Normal Vote) subtitle(by State) legend(off) scheme(s1mono) plotregion(style(none)) ///
ytitle("GOP Two-Party Reg.") xtitle("GOP Normal Vote Based on Precinct Returns") xlabel(0(.2).8)
graph save precinc_state_norm.gph, replace
 
 cd ..
u figure_a2_data_byshd.dta, clear


cor shd_reg shd_pres
cor shd_reg shd_norm 

cd derivative
twoway(scatter shd_reg shd_pres, msymbol(none) mlabel(state)), ///
text(.85 .2 "District-Level Corr: 0.75") ///
title(Party Registration vs. Presidential Vote Returns) subtitle(by State House District) ///
legend(off) scheme(s1mono) plotregion(style(none)) ///
ytitle("GOP Two-Party Reg.") xtitle("GOP Two-Party Precinct Returns")  xlabel(0(.2)1)
graph save shd_prec_reg.gph, replace

twoway(scatter shd_reg shd_norm, msymbol(none) mlabel(state)), ///
text(.85 .2 "District-Level Corr: 0.77") ///
title(Party Registration vs. the Normal Vote) subtitle(by State House District) ///
legend(off) scheme(s1mono) plotregion(style(none)) ///
ytitle("GOP Two-Party Reg.") xtitle("GOP Normal Vote Based on Precinct Returns") xlabel(0(.2)1)
graph save shd_prec_reg_norm.gph, replace


graph combine precinc_state.gph precinc_state_norm.gph shd_prec_reg.gph shd_prec_reg_norm.gph, cols(2) rows(2) iscale(.65) scheme(s1mono)



****************
***FIG A-3
****************
cd ..

clear
insheet using "../main_catalist_file.csv", clear
sort stdist

gen tot_R = ry020+ry2040+ry4060+ry6080+ry80100+ry100120+ry120140+ry140160+ry160180+ry180200
gen tot_D = dy020+dy2040+dy4060+dy6080+dy80100+dy100120+dy120140+dy140160+dy160180+dy180200
gen pct_R = tot_R/(tot_R+tot_D)


gen pct_R10 = 1 if pct_R < .1
replace pct_R10 = 2 if pct_R < .2 & pct_R >= .1
replace pct_R10 = 3 if pct_R < .3 & pct_R >= .2
replace pct_R10 = 4 if pct_R < .4 & pct_R >= .3
replace pct_R10 = 5 if pct_R < .5 & pct_R >= .4
replace pct_R10 = 6 if pct_R < .6 & pct_R >= .5
replace pct_R10 = 7 if pct_R < .7 & pct_R >= .6
replace pct_R10 = 8 if pct_R < .8 & pct_R >= .7
replace pct_R10 = 9 if pct_R < .9 & pct_R >= .8
replace pct_R10 = 10 if pct_R < 1 & pct_R >= .9


*for compatibility with Butler data
gen dist_md = district if stabb == "MD"
destring dist_md, gen(dist_num_md) ignore("A", "B", "C")
tostring dist_num_md, replace 
gen stdist_md = stabb+dist_num_md
replace stdist = stdist_md if stabb == "MD"


keep stdist pct_R10

sort stdist

merge m:1 stdist using butler_district_reps.dta

*There are 2 dists from Butler file that don't merge to our file, and several that don't match the other way
*But most of those (49/69) are from NE where there are non-partisan reps.

bysort pct_R10: ci dist_r if dist_r != . & pct_R10 !=.
*These results are loaded into a .csv file used to generate graph below.

insheet using appendix_figa3_means_cis.csv, clear

label define butler 1 "<10% R>" 5 "40-50% R" 10 ">90% R" 11 "<$30K" 15 "$4.5K-$5K" 20 ">$70K"
label values value butler

twoway (rcap lb ub value, lcolor(gs9) lwidth(medthick)) ///
(scatter mean value, mcolor(black) msize(medlarge) msymbol(none) mlabel(n) mlabsize(large) ///
 mlabcolor(black) mlabposition(0)), ytitle(Pr(Representative is Republican)) ///
 ylabel(0(.25)1) xtitle(Percentage Republican of D and R Registrants in District) ///
 xlabel(1 "<10% R" 5 "40-50% R" 10 ">90% R", valuelabel) legend(off) plotregion(style(none))


 ****************
***FIG A.4
****************

/*Because of identifiability issues, we are not publicly releasing the CCES file linked to Census Block-Group
Level characteristics. Figure A-4 shows the comparison between self-reported income and block-group income. Code is as follows:


u cces_fields_appendix_replication.dta, clear


gen weight = V201
keep if votersta == "active" | votersta == "inactive" | votersta == "dropped"
ren V246 familyincome
drop if fam == 15
drop  if famil == . 

gen grmed = 1 if median < 20000
replace grmed = 2 if median >=20000 & median <40000
replace grmed = 3 if median >=40000 & median <60000
replace grmed = 4 if median >=60000 & median <80000
replace grmed = 5 if median >=80000 & median <100000
replace grmed = 6 if median >=100000 & median <120000
replace grmed = 7 if median >=120000 & median <140000
replace grmed = 8 if median >=140000 & median <160000
replace grmed = 9 if median >=160000 & median <180000
replace grmed = 10 if median>=180000 & median <200000

replace grmed = 6 if grmed > 6 & grmed !=.


bysort grmed: ci fam [aw=weight]
bysort grmed: sum fam [aw=weight], detail
*copy to .csv file

insheet using appendix_fig_a4.csv, clear


gen census = _n

 twoway (rspike iqr_l iqr_h census, lcolor(gs14) lwidth(thick)) ///
(rcap lb ub census, lcolor(black) lwidth(medthick)) ///
(scatter mean census, mcolor(black) msize(medlarge)  mlabsize(large) ///
 mlabcolor(black) mlabposition(0)), ytitle("Average Reported Family Income (in thousands)") ///
 ylabel(2 "$10-$15" 3 "$15-$20" 4 "$20-$25" 5 "$25-$30" 6 "$30-$40" 7 "$40-$50" 8 "$50-$60" 9 "$60-$70" 10 "$70-$80" 11 "$80-$100" 12 "$100-$120" 13 "$120-$150" 14 "$150 +", angle(horizontal)) xtitle("Census Block Group Median Household Income (in $20K groupings)") ///
 xlabel(1 "$0-$20" 2 "$20-$40" 3 "$40-$60" 4 "$60-$80" 5 "$80-$100" 6 "$100 +", valuelabel)  plotregion(style(none))   ///
 legend(on nobox  col(3) order(3 "Mean" 2 "95% CI" 1 "IQR"  ) ///
region(margin(medium)) lcolor(white) bmargin(zero))

*/

****************
***FIG A.5: Replication of Figure 3 with Non-White (Rather than Black) Racial Categories
****************

clear
insheet using "../main_catalist_file.csv", clear
sort stdist


gen white3 = 1 if sh_white < .5
replace white3 = 2 if sh_white >=.5 & sh_white <.9
replace white3 = 3 if sh_white >=.9 & sh_white !=.


gen state_white3 = stabb+string(white3)
collapse (sum) dy020-dy160180, by(state_white3)

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

gen state = substr(state_white,1,2)
gen white = substr(state_white,3,2)
destring white, replace

cd derivative
save white3states.dta, replace
gen inc_cat = 1
append using white3states.dta
recode inc_cat .=2
append using white3states.dta
recode inc_cat .=3
append using white3states.dta
recode inc_cat .=4
append using white3states.dta
recode inc_cat .=5
append using white3states.dta
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
twoway (lowess pct_R inc_cat if state == "AK" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "AZ" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "CA" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "CO" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NM" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NV" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "OR" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
, ///
legend(off) plotregion(style(none)) yscale(noextend) xscale(noextend) ///
ylabel(0 10 30 50 70 90) ytitle(" ")  ///
xlabel(1(1)6, valuelabel ticks labsize(small)) xtitle("") ///
 subtitle(" ")
graph save west3.gph, replace


twoway (lowess pct_R inc_cat if state == "AK" & white == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "AZ" & white == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "CA" & whit == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "CO" & white == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NM" & white == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NV" & white == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "OR" & white == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
, ///
legend(off) plotregion(style(none)) yscale(noextend) xscale(noextend) ///
ylabel(0 10 30 50 70 90) ytitle(" ")  ///
xlabel(1(1)6, valuelabel ticks labsize(small)) xtitle("") ///
subtitle(WEST)
graph save west2.gph, replace

twoway (lowess pct_R inc_cat if state == "AK" & white == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "AZ" & white == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "CA" & white == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "CO" & white == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NM" & white == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NV" & white == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "OR" & white == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
, ///
legend(off) plotregion(style(none)) yscale(noextend) xscale(noextend) ///
ylabel(0 10 30 50 70 90) ytitle(" ")  ///
xlabel(1(1)6, valuelabel ticks labsize(small)) xtitle("") ///
 subtitle(" ")
graph save west1.gph, replace

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
 graph save west_white_leg.gph, replace

 
 

*MIDWEST
twoway (lowess pct_R inc_cat if state == "IA" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NE" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "SD" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "UT" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "WY" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "KS" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
, ///
legend(off) plotregion(style(none)) yscale(noextend) xscale(noextend) ///
ylabel(0 10 30 50 70 90) ytitle(" ")  ///
xlabel(1(1)6, valuelabel ticks labsize(small)) xtitle("") ///
 subtitle(" ")
graph save mid3.gph, replace


twoway (lowess pct_R inc_cat if state == "IA" & white == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NE" & white == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "SD" & whit == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "UT" & white == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "WY" & white == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "KS" & white == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
, ///
legend(off) plotregion(style(none)) yscale(noextend) xscale(noextend) ///
ylabel(0 10 30 50 70 90) ytitle(" ")  ///
xlabel(1(1)6, valuelabel ticks labsize(small)) xtitle("") ///
subtitle(MIDWEST)
graph save mid2.gph, replace

twoway (lowess pct_R inc_cat if state == "IA" & white == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NE" & white == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "SD" & white == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "UT" & white == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "WY" & white == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "KS" & white == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
, ///
legend(off) plotregion(style(none)) yscale(noextend) xscale(noextend) ///
ylabel(0 10 30 50 70 90) ytitle(" ")  ///
xlabel(1(1)6, valuelabel ticks labsize(small)) xtitle("") ///
 subtitle(" ")
graph save mid1.gph, replace

twoway (scatter pct_R inc_cat, msymbol(none)), plotregion(style(none)) ///
yscale(off) ylabel(none)  xscale(off) xlabel(7(1)7, labsize(small) valuelabel ticks) ///
fxsize(5) ///
 text(80 7 "IA", color(gs4)) ///
 text(72 7 "NE", color(gs4)) ///
 text(64 7 "SD", color(gs4)) ///
 text(56 7 "UT", color(gs4)) ///
 text(48 7 "WY", color(gs4)) ///
 text(40 7 "KS", color(gs4)) 
 graph save midwest_white_leg.gph, replace

 
 

*NORTH
twoway (lowess pct_R inc_cat if state == "CT" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "DE" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "MA" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "MD" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "ME" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NH" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NJ" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NY" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "PA" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "RI" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
, ///
legend(off) plotregion(style(none)) yscale(noextend)  ///
ylabel(0 10 30 50 70 90) ytitle(" ") xscale(noextend)  ///
xlabel(1(1)6, valuelabel ticks labsize(small)) xtitle("") /// 
title("90%+ White Dists.") ///
 subtitle(" ")
 graph save north3.gph, replace




twoway (lowess pct_R inc_cat if state == "CT" & white == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "DE" & white == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "MA" & white == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "MD" & white == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "ME" & white == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NH" & white == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NJ" & white == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NY" & white == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "PA" & white == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "RI" & white == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
, ///
legend(off) plotregion(style(none)) yscale(noextend) xscale(noextend) ///
ylabel(0 10 30 50 70 90) ytitle(" ")  ///
xlabel(1(1)6, valuelabel ticks labsize(small)) xtitle("") ///
title("50-90%+ White Dists.") subtitle(NORTH)
graph save north2.gph, replace

twoway (lowess pct_R inc_cat if state == "CT" & white == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "DE" & white == 1,lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "MA" & white == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "MD" & white == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "ME" & white == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NH" & white == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NJ" & white == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NY" & white == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "PA" & white == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "RI" & white == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
, ///
legend(off) plotregion(style(none)) yscale(noextend) xscale(noextend) ///
ylabel(0 10 30 50 70 90) ytitle(" ")  ///
xlabel(1(1)6, valuelabel ticks labsize(small)) xtitle("") ///
title("<50% White Dists.") /// 
 subtitle(" ")
graph save north1.gph, replace

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
 graph save north_white_leg.gph, replace

 
 

*South

twoway (lowess pct_R inc_cat if state == "FL" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "KY" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "LA" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NC" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "OK" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "WV" & white == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
, ///
legend(off) plotregion(style(none)) yscale(noextend) xscale(noextend) ///
ylabel(0 10 30 50 70 90) ytitle(" ")  ///
xlabel(1(1)6, valuelabel ticks labsize(small)) xtitle("") ///
 subtitle(" ")
graph save south3.gph, replace


twoway (lowess pct_R inc_cat if state == "FL" & white == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "KY" & white == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "LA" & whit == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NC" & white == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "OK" & white == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "WV" & white == 2, lc(gs4) lpattern(solid) lwidth(thin)) ///
, ///
legend(off) plotregion(style(none)) yscale(noextend) xscale(noextend) ///
ylabel(0 10 30 50 70 90) ytitle(" ")  ///
xlabel(1(1)6, valuelabel ticks labsize(small)) xtitle("") ///
 subtitle(SOUTH)
graph save south2.gph, replace

twoway (lowess pct_R inc_cat if state == "FL" & white == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "KY" & white == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "LA" & white == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NC" & white == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "OK" & white == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "WV" & white == 1, lc(gs4) lpattern(solid) lwidth(thin)) ///
, ///
legend(off) plotregion(style(none)) yscale(noextend) xscale(noextend) ///
ylabel(0 10 30 50 70 90) ytitle(" ")  ///
xlabel(1(1)6, valuelabel ticks labsize(small)) xtitle("") ///
 subtitle(" ")
graph save south1.gph, replace

gen y_var = .8 if state == "FL" 
replace y_var = .72 if state == "KY" 
replace y_var = .64 if state == "LA" 
replace y_var = .56 if state == "NC" 
replace y_var = .48 if state == "OK" 
replace y_var = .40 if state == "WV" 
gen x_var = 1 if inc_cat == 1
replace x_var = 2 if inc_cat == 2


twoway (scatter pct_R inc_cat, msymbol(none)), ///
yscale(off) ylabel(none)  xscale(off) xlabel(7(1)7, labsize(small) valuelabel ticks)  ///
  plotregion(style(none)) fxsize(5) ///
 text(80 7 "FL", color(gs4)) ///
 text(72 7 "KY", color(gs4)) ///
 text(64 7 "LA", color(gs4)) ///
 text(56 7 "NC", color(gs4)) ///
 text(48 7 "OK", color(gs4)) ///
 text(40 7 "WV", color(gs4)) legend(off)
 graph save south_white_leg.gph, replace

 



graph combine  north3.gph north2.gph north1.gph north_white_leg.gph south3.gph south2.gph south1.gph south_white_leg.gph ///
 mid3.gph mid2.gph mid1.gph midwest_white_leg.gph west3.gph west2.gph west1.gph west_white_leg.gph, rows(4) xsize(6) ysize(8)  ///
 l1title(Percent Republican, size(medsmall)) b1title("Census Block Group Income, in $10K", size(medsmall)) 
 
 
 
****************
***FIG A.6	: Replication of Figure 3 only in Non-Black Block Groups
****************

insheet using "../Non_Black_BGs_Only.csv", clear
 
 
 gen black3 = 1 if sh_black >= .10
replace black3 = 2 if sh_black >=.05 & sh_black <.10
replace black3 = 3 if sh_black <.05 & sh_black !=.


gen state_black3 = stabb+string(black3)
drop stabb
collapse (sum) dy020-dy160180, by(state_black3)

drop ounk
drop oy020-oy180200 


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

egen partisan_voters = rowtotal(obs020-obs100pl)

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

save blacknb3states.dta, replace
gen inc_cat = 1
append using blacknb3states.dta
recode inc_cat .=2
append using blacknb3states.dta
recode inc_cat .=3
append using blacknb3states.dta
recode inc_cat .=4
append using blacknb3states.dta
recode inc_cat .=5
append using blacknb3states.dta
recode inc_cat .=6



gen pct_R = pctR020 if inc_cat ==1
replace pct_R = pctR2040 if inc_cat == 2
replace pct_R = pctR4060 if inc_cat == 3
replace pct_R = pctR6080 if inc_cat == 4
replace pct_R = pctR80100 if inc_cat == 5
replace pct_R = pctR100plus if inc_cat == 6

drop pctR*

sort inc_cat


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
(lowess pct_R inc_cat if state == "MD" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "ME" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NH" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NJ" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "NY" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
(lowess pct_R inc_cat if state == "PA" & black == 3, lc(gs4) lpattern(solid) lwidth(thin)) ///
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
 
 
 
 ****************
***FIG A.7: Replication of Figure 4 Among Those Registered Prior to 2008
****************



/*
See comments on Catalist's 1% sample in main replication do-file.

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


*Replicated without new registrants
gen reg_date = date(id_regdate, "YM#")
gen regdate_year = year(reg_date)
drop if regdate_year > 2007

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

 
**The above regression slope coefficients are saved in appendix_figure_4_regressions_old_registrants.csv
*/

insheet using "../appendix_figure_4_regressions_old_registrants.csv", clear

replace coef = coef*100
replace lb = lb*100
replace ub = ub*100

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

 
 ****************
***FIG A.8: 
****************

cd ..
clear
insheet using "../main_catalist_file.csv", clear
sort stdist


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

drop st_inc_q
gen st_inc_q =1 if stab == "KY" | stab == "LA" | stab == "OK" | stab == "SD" | stab == "WV" | stab == "ME" | stab == "NM" | stab == "WY"
replace st_inc_q = 4 if stab == "AK" | stab == "CA" | stab == "CO" | stab == "CT" | stab == "MA" | stab == "MD" | stab == "NJ"

drop if st_inc_q == .

bysort st_inc_q: egen st_pctR020a = total(ry020)
bysort st_inc_q: egen st_pctR020b = total(obs020)
bysort st_inc_q: gen st_pctR020 = st_pctR020a/st_pctR020b

bysort st_inc_q: egen st_pctR2040a = total(ry2040)
bysort st_inc_q: egen st_pctR2040b = total(obs2040)
bysort st_inc_q: gen st_pctR2040 = st_pctR2040a/st_pctR2040b

bysort st_inc_q: egen st_pctR4060a = total(ry4060)
bysort st_inc_q: egen st_pctR4060b = total(obs4060)
bysort st_inc_q: gen st_pctR4060 = st_pctR4060a/st_pctR4060b

bysort st_inc_q: egen st_pctR6080a = total(ry6080)
bysort st_inc_q: egen st_pctR6080b = total(obs6080)
bysort st_inc_q: gen st_pctR6080 = st_pctR6080a/st_pctR6080b

bysort st_inc_q: egen st_pctR80100a = total(ry80100)
bysort st_inc_q: egen st_pctR80100b = total(obs80100)
bysort st_inc_q: gen st_pctR80100 = st_pctR80100a/st_pctR80100b

bysort st_inc_q: egen st_pctR100pla = total(ry100pl)
bysort st_inc_q: egen st_pctR100plb = total(obs100pl)
bysort st_inc_q: gen st_pctR100pl = st_pctR100pla/st_pctR100plb

sort st_inc_q


keep st_inc_q st_pctR020 st_pctR2040 st_pctR4060 st_pctR6080 st_pctR80100 st_pctR100pl st_pctR020b st_pctR2040b st_pctR4060b st_pctR6080b st_pctR80100b st_pctR100plb 
order st_inc_q st_pctR020 st_pctR2040 st_pctR4060 st_pctR6080 st_pctR80100 st_pctR100pl st_pctR020b st_pctR2040b st_pctR4060b st_pctR6080b st_pctR80100b st_pctR100plb 

keep if st_inc_q != st_inc_q[_n-1] | _n ==1
xpose, clear
drop if _n ==1
gen bg_inc = _n
replace bg_inc =. if _n >6
ren (v1 v2) (SHinc1 SHinc2)
label var SHinc1 "Poorest states"
label var SHinc2 "Richest states"


replace bg_inc =5.9 if _n ==7
replace SHinc1 =. if _n==7
replace SHinc2 =. if _n==7



gen poormax = SHinc1 if bg_inc == 6
gen poormin = SHinc1 if bg_inc == 1
egen poormin2 = max(poormin)
egen poormax2 = max(poormax)
drop poormin poormax
ren (poormin2 poormax2) (poormin poormax)
replace poormin =. if _n != 6
replace poormax = . if _n !=6

gen richmax = SHinc2 if bg_inc == 6
gen richmin = SHinc2 if bg_inc == 1
egen richmin2 = max(richmin)
egen richmax2 = max(richmax)
drop richmin richmax
ren (richmin2 richmax2) (richmin richmax)
replace richmin =. if _n != 7
replace richmax = . if _n !=7

cd derivative 

twoway(line SHinc1 bg_inc if bg_inc !=.,  xlabel(, nolabels tlcolor(white)) lwidth(thick) lcolor(purple) lpattern(dash)) ///
(rcap poormax poormin bg_inc, lcolor(gs10) lwidth(medthick) lpattern(dash)) ///
(rcap richmax richmin bg_inc, lcolor(gs10) lwidth(medthick)) ///
(line SHinc2 bg_inc if bg_inc !=.,  xlabel(, nolabels tlcolor(white)) lwidth(thick) lcolor(red)), ///
 fysize(50) fxsize(50) ytitle("Proportion Republican") ylabel(0(.1).6) xtitle("$0-20K         Med. Income (Block Group)         $100K+") ///
title(States) legend(on nobox  order(1 "Poorest States" 4 "Richest States" 2 "36 Pt. Diff." 3 "29 Pt. Diff.") ///
region(margin(medium)) lcolor(white) bmargin(zero)) scheme(s1mono) plotregion(style(none))
graph save state2.gph, replace


*SH DISTS
clear
insheet using "../../main_catalist_file.csv", clear
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


xtile sh_inc_q = ave_inc, nq(4)


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


bysort sh_inc_q: egen st_pctR020a = total(ry020)
bysort sh_inc_q: egen st_pctR020b = total(obs020)
bysort sh_inc_q: gen st_pctR020 = st_pctR020a/st_pctR020b

bysort sh_inc_q: egen st_pctR2040a = total(ry2040)
bysort sh_inc_q: egen st_pctR2040b = total(obs2040)
bysort sh_inc_q: gen st_pctR2040 = st_pctR2040a/st_pctR2040b

bysort sh_inc_q: egen st_pctR4060a = total(ry4060)
bysort sh_inc_q: egen st_pctR4060b = total(obs4060)
bysort sh_inc_q: gen st_pctR4060 = st_pctR4060a/st_pctR4060b

bysort sh_inc_q: egen st_pctR6080a = total(ry6080)
bysort sh_inc_q: egen st_pctR6080b = total(obs6080)
bysort sh_inc_q: gen st_pctR6080 = st_pctR6080a/st_pctR6080b

bysort sh_inc_q: egen st_pctR80100a = total(ry80100)
bysort sh_inc_q: egen st_pctR80100b = total(obs80100)
bysort sh_inc_q: gen st_pctR80100 = st_pctR80100a/st_pctR80100b

bysort sh_inc_q: egen st_pctR100pla = total(ry100pl)
bysort sh_inc_q: egen st_pctR100plb = total(obs100pl)
bysort sh_inc_q: gen st_pctR100pl = st_pctR100pla/st_pctR100plb

sort sh_inc_q


keep sh_inc_q st_pctR020 st_pctR2040 st_pctR4060 st_pctR6080 st_pctR80100 st_pctR100pl st_pctR020b st_pctR2040b st_pctR4060b st_pctR6080b st_pctR80100b st_pctR100plb 
order sh_inc_q st_pctR020 st_pctR2040 st_pctR4060 st_pctR6080 st_pctR80100 st_pctR100pl st_pctR020b st_pctR2040b st_pctR4060b st_pctR6080b st_pctR80100b st_pctR100plb 

keep if sh_inc_q != sh_inc_q[_n-1] | _n ==1
xpose, clear
drop if _n ==1
gen bg_inc = _n
replace bg_inc =. if _n >6
ren (v1 v2 v3 v4) (SHinc1 SHinc2 SHinc3 SHinc4)
label var SHinc1 "Poorest Districts"
label var SHinc4 "Richest Districts"

replace bg_inc =5.9 if _n ==7
replace SHinc1 =. if _n==7
replace SHinc2 =. if _n==7
replace SHinc3 =. if _n==7
replace SHinc4 =. if _n==7



gen poormax = SHinc1 if bg_inc == 6
gen poormin = SHinc1 if bg_inc == 1
egen poormin2 = max(poormin)
egen poormax2 = max(poormax)
drop poormin poormax
ren (poormin2 poormax2) (poormin poormax)
replace poormin =. if _n != 6
replace poormax = . if _n !=6

gen richmax = SHinc4 if bg_inc == 6
gen richmin = SHinc4 if bg_inc == 1
egen richmin2 = max(richmin)
egen richmax2 = max(richmax)
drop richmin richmax
ren (richmin2 richmax2) (richmin richmax)
replace richmin =. if _n != 7
replace richmax = . if _n !=7


twoway(line SHinc1 bg_inc if bg_inc !=.,  xlabel(, nolabels tlcolor(white)) lwidth(thick) lcolor(purple) lpattern(dash)) ///
(rcap poormax poormin bg_inc, lcolor(gs10) lwidth(medthick) lpattern(dash)) ///
(rcap richmax richmin bg_inc, lcolor(gs10) lwidth(medthick)) ///
(line SHinc4 bg_inc if bg_inc !=.,  xlabel(, nolabels tlcolor(white)) lwidth(thick) lcolor(red)), ///
fysize(50) fxsize(50) ytitle("Proportion Republican") ylabel(0(.1).6) xtitle("$0-20K         Med. Income (Block Group)         $100K+") ///
title(State House Districts) legend(on nobox order(1 "Poorest Dists." 4 "Richest Dists." 2 "18 Pt. Diff." 3 "24 Pt. Diff.")   ///
region(margin(medium)) lcolor(white) bmargin(zero)) scheme(s1mono) plotregion(style(none))
graph save SHD2.gph, replace

graph combine state2.gph SHD2.gph, cols(2) rows(1) iscale(.55) scheme(s1mono)




 ****************
***FIG A.9  
****************

/*
As before, we are not releasing block-group level data associated with CCES respondents in the public data release, due to
identifiability concerns. 

u cces_fields_appendix_replication.dta, clear


gen weight = V201
keep if votersta == "active" | votersta == "inactive" | votersta == "dropped"
ren V246 familyincome
drop if fam == 15
drop  if famil == . 



gen midofinc = 5000 if fam == 1
replace midofinc = 12500 if fam == 2
replace midofinc = 17500 if fam == 3
replace midofinc = 22500 if fam == 4
replace midofinc = 27500 if fam == 5
replace midofinc = 35000 if fam == 6
replace midofinc = 45000 if fam == 7
replace midofinc = 55000 if fam == 8
replace midofinc = 65000 if fam == 9
replace midofinc = 75000 if fam == 10
replace midofinc = 90000 if fam == 11
replace midofinc = 110000 if fam == 12
replace midofinc = 135000 if fam == 13
replace midofinc = 175000 if fam == 14


gen partyreg = 1 if state == "AK"
replace partyreg = 1 if state == 	"CT"
replace partyreg = 1 if state == 	"DC"
replace partyreg = 1 if state == 	"DE"
replace partyreg = 1 if state == 	"FL"
replace partyreg = 1 if state == 	"KS"
replace partyreg = 1 if state == 	"KY"
replace partyreg = 1 if state == 	"LA"
replace partyreg = 1 if state == 	"NE"
replace partyreg = 1 if state == 	"OK"
replace partyreg = 1 if state == 	"SD"
replace partyreg = 1 if state == 	"UT"
replace partyreg = 1 if state == 	"WY"
replace partyreg = 1 if state == 	"AZ"
replace partyreg = 1 if state == 	"CA"
replace partyreg = 1 if state == 	"CO"
replace partyreg = 1 if state == 	"IA"
replace partyreg = 1 if state == 	"MA"
replace partyreg = 1 if state == 	"MD"
replace partyreg = 1 if state == 	"ME"
replace partyreg = 1 if state == 	"NC"
replace partyreg = 1 if state == 	"NH"
replace partyreg = 1 if state == 	"NJ"
replace partyreg = 1 if state == 	"NM"
replace partyreg = 1 if state == 	"NV"
replace partyreg = 1 if state == 	"NY"
replace partyreg = 1 if state == 	"OR"
replace partyreg = 1 if state == 	"PA"
replace partyreg = 1 if state == 	"RI"
replace partyreg = 1 if state == 	"WV"

keep if partyreg == 1


ren V211 race_rep 
ren CC307 pid3
gen st_stdist = state+statehouse
bysort st_stdist: egen shd_inc = mean(median)
bysort state: egen st_inc = mean(medianhh) 

xtile st_inc_q = st_inc, nq(4)
xtile shd_inc_q = shd_inc, nq(4)
gen R = 1 if pid3 == 2
replace R = 0 if pid3 ==1

tab midofinc R if st_inc_q ==4 [aw=weight], row nof 
tab midofinc R if st_inc_q ==1 [aw=weight], row nof
tab midofinc R if shd_inc_q ==4 [aw=weight], row  nof
tab midofinc R if shd_inc_q ==1 [aw=weight], row  nof

*copied to .csv file
*/
cd .. 
insheet using appendix_fig_a9.csv, clear

cd derivative 

twoway(lowess ps inc,  xlabel(, nolabels tlcolor(white)) lwidth(thick) lcolor(purple) lpattern(dash)) ///
(lowess rs inc,  xlabel(, nolabels tlcolor(white)) lwidth(thick) lcolor(red)), ///
 fysize(50) fxsize(50) ytitle("Pct. Republican") ylabel(0(10)60) xtitle("$5K                   Self-Reported Income                 $170.5K") ///
title(States) legend(on nobox  order(1 "Poorest States" 2 "Richest States") ///
region(margin(medium)) lcolor(white) bmargin(zero)) scheme(s1mono) plotregion(style(none))
graph save ccesstate2.gph, replace

twoway(lowess pd inc,  xlabel(, nolabels tlcolor(white)) lwidth(thick) lcolor(purple) lpattern(dash)) ///
(lowess rd inc,  xlabel(, nolabels tlcolor(white)) lwidth(thick) lcolor(red)), ///
 fysize(50) fxsize(50) ytitle("Pct. Republican") ylabel(0(10)60) xtitle("$5K                     Self-Reported Income                  $170.5K") ///
title(State House Districts) legend(on nobox  order(1 "Poorest Dists." 2 "Richest Dists.") ///
region(margin(medium)) lcolor(white) bmargin(zero)) scheme(s1mono) plotregion(style(none))
graph save ccesdist2.gph, replace

graph combine ccesstate2.gph ccesdist2.gph, cols(2) rows(1) iscale(.55) scheme(s1mono)


