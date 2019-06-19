clear
clear mata
clear matrix
cap log close
set more 1
set matsize 11000
set maxvar 11000
clear




* 	THIS FILE ESTIMATES THE SPECIFICATIONS REPORTED IN THE PAPER, USING AS INPUTS 2 DIFFERENT
*   ANALYTICAL DATASETS: (1) ANALYSIS_APPLICATION.DTA AND (2) ANALYSIS_PATENTED.  THE FIRST
*   DATASET IS FOR USE WITH THOSE SPECIFICATIONS THAT ARE BASED ON A SAMPLE OF INDIVIDUAL APPLICATIONS.
*   THE SECOND DATASET IS FOR USE WITH THOSE SPECIFICATIONS THAT ARE BASED ON A SAMPLE OF INDIVIDUAL 
*   ISSUED PATENTS.



* TOGGLE THIS.  =1 FOR ANALYTICAL_APPLICATION.  = 2 FOR ANALYTICAL_ISSUED.   
local sample = 1




log using regress.log, replace


local GSlist2 = "GSdum2 GSdum3 GSdum4 GSdum5_1 GSdum5_2 GSdum6_alt"
local GSlist2_foa = "GSdum_foa2 GSdum_foa3 GSdum_foa4 GSdum_foa5_1 GSdum_foa5_2 GSdum_foa6_alt"

local firstlist = "first_year2dum3 first_year2dum4 first_year2dum5 first_year2dum6 first_year2dum7 first_year2dum8 first_year2dum9 first_year2dum10"
local firstlist2 = "first_year2dum11 first_year2dum12 first_year2dum13 first_year2dum14 first_year2dum15 first_year2dum16 first_year2dum17 first_year2dum18"
local firstlist3 = "first_year2dum19 first_year2dum20 first_year2dum21"




if `sample' == 1 {


use analytical_application
*insheet using analytical_application.txt



rename gsdum2  GSdum2
rename gsdum3 GSdum3
rename gsdum4 GSdum4
rename gsdum5_1 GSdum5_1
rename gsdum5_2 GSdum5_2
rename gsdum6_alt GSdum6_alt

rename gsdum_foa2 GSdum_foa2
rename gsdum_foa3 GSdum_foa3
rename gsdum_foa4 GSdum_foa4
rename gsdum_foa5_1 GSdum_foa5_1
rename gsdum_foa5_2 GSdum_foa5_2 
rename gsdum_foa6_alt GSdum_foa6_alt



* FIGURE 1  + Column 1 of Table 3
areg grant `GSlist2' yeardum* if first_year2 != 1992, vce(cluster exam) absorb(exam)
parmest,format(estimate min95 max95 %8.2f p %8.1e) saving (figures/figure_1, replace)


* column 2 of Table 3
areg grant `GSlist2'  total_filings yeardum* classdum* if first_year2 != 1992, vce(cluster exam) absorb(exam)


* FIGURE 2 + column 3 of Table 3
areg grant `GSlist2' exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 yeardum* if first_year2 != 1992, vce(cluster exam) absorb(exam)
parmest,format(estimate min95 max95 %8.2f p %8.1e) saving (figures/figure_2, replace)


* Table 3, Column 4
areg grant size foreign_p duration duration_sq `GSlist2' yeardum* cy_* if first_year2 != 1992, vce(cluster exam) absorb(exam)


* Table 3, Column 5 and 6
areg grant `GSlist2' yeardum* if first_year2 != 1992 & balance == 1, vce(cluster exam) absorb(exam)
areg grant GSdum4 GSdum5_1 GSdum5_2 GSdum6_alt yeardum* if first_year2 != 1992 & balance2 == 1 & grade_alt >= 11 & grade_alt <= 14 & grade_alt != ., vce(cluster exam) absorb(exam)


* Table 4, Columns 1 and 2
areg ratio_obv `GSlist2' yeardum* if first_year2 != 1992, absorb(exam) vce(cluster exam)
areg ratio_obv `GSlist2' exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 yeardum* if first_year2 != 1992, absorb(exam) vce(cluster exam)



* Appendix  Litigation Table--Table A3

nbreg asserted2 GSdum2 GSdum3 GSdum4 GSdum5_1 GSdum5_2 GSdum6_alt yeardum* if first_year2 != 1992, vce(cluster exam) exposure(expose) irr
nbreg asserted2 GSdum2 GSdum3 GSdum4 GSdum5_1 GSdum5_2 GSdum6_alt yeardum* exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 if first_year2 != 1992, vce(cluster exam) exposure(expose) irr
nbreg asserted2 GSdum2 GSdum3 GSdum4 GSdum5_1 GSdum5_2 GSdum6_alt yeardum* exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 first_year2dum* if first_year2 != 1992, vce(cluster exam) exposure(expose) irr
nbreg asserted2 GSdum2 GSdum3 GSdum4 GSdum5_1 GSdum5_2 GSdum6_alt yeardum* exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 first_year2dum* max_exp_2 max_exp_3 max_exp_4 max_exp_5 max_exp_6  if first_year2 != 1992, vce(cluster exam) exposure(expose) irr
nbreg asserted2 GSdum2 GSdum3 GSdum4 GSdum5_1 GSdum5_2 GSdum6_alt yeardum* exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 first_year2dum* max_exp_2 max_exp_3 max_exp_4 max_exp_5 max_exp_6  if first_year2 != 1992 & grant == 1, vce(cluster exam) exposure(expose) irr

nbreg asserted2 size duration* foreign_p GSdum2 GSdum3 GSdum4 GSdum5_1 GSdum5_2 GSdum6_alt yeardum* subcatdum* if first_year2 != 1992, vce(cluster exam) exposure(expose) irr
nbreg asserted2 size duration* foreign_p GSdum2 GSdum3 GSdum4 GSdum5_1 GSdum5_2 GSdum6_alt yeardum* subcatdum* exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 if first_year2 != 1992, vce(cluster exam) exposure(expose) irr
nbreg asserted2 size duration* foreign_p GSdum2 GSdum3 GSdum4 GSdum5_1 GSdum5_2 GSdum6_alt yeardum* subcatdum* exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 first_year2dum* if first_year2 != 1992, vce(cluster exam) exposure(expose) irr
nbreg asserted2 size duration* foreign_p GSdum2 GSdum3 GSdum4 GSdum5_1 GSdum5_2 GSdum6_alt yeardum* subcatdum* exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 first_year2dum* max_exp_2 max_exp_3 max_exp_4 max_exp_5 max_exp_6  if first_year2 != 1992, vce(cluster exam) exposure(expose) irr
nbreg asserted2 size duration* foreign_p GSdum2 GSdum3 GSdum4 GSdum5_1 GSdum5_2 GSdum6_alt yeardum* subcatdum* exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 first_year2dum* max_exp_2 max_exp_3 max_exp_4 max_exp_5 max_exp_6  if first_year2 != 1992 & grant == 1, vce(cluster exam) exposure(expose) irr

nbreg asserted2 GSdum2 GSdum3 GSdum4 GSdum5_1 GSdum5_2 GSdum6_alt yeardum* if first_year2 != 1992 & grant == 1, vce(cluster exam) exposure(expose) irr



* Table A5 in Appendix
reg grant exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 yeardum* if first_year2 != 1992, cluster(exam)
reg grant exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 max_exp_2 max_exp_3 max_exp_4 max_exp_5 max_exp_6 yeardum* if first_year2 != 1992, cluster(exam)
reg grant exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 max_exp_2 max_exp_3 max_exp_4 max_exp_5 max_exp_6 yeardum* first_year2dum* if first_year2 != 1992, cluster(exam)
reg grant GSdum2 GSdum3 GSdum4 GSdum5_1 GSdum5_2 GSdum6_alt exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 max_exp_2 max_exp_3 max_exp_4 max_exp_5 max_exp_6 yeardum* first_year2dum* if first_year2 != 1992, cluster(exam)
areg grant GSdum2 GSdum3 GSdum4 GSdum5_1 GSdum5_2 GSdum6_alt exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 yeardum* if first_year2 != 1992, vce(cluster exam) absorb(exam)



* cohort effects figure in appendix
reg grant GSdum2 GSdum3 GSdum4 GSdum5_1 GSdum5_2 GSdum6_alt exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 max_exp_2 max_exp_3 max_exp_4 max_exp_5 max_exp_6 yeardum* `firstlist' `firstlist2' `firstlist3' if first_year2 != 1992 & first_year2 <= 2012 & first_year2 != ., cluster(exam)
parmest,format(estimate min95 max95 %8.2f p %8.1e) saving (figures/figure_A1, replace)


* restricted duration window approach in appendix
areg grant  `GSlist2' yeardum* if first_year2 != 1992 & duration <= (3*356) & year >= 2004, vce(cluster exam) absorb(exam)
parmest,format(estimate min95 max95 %8.2f p %8.1e) saving (figures/figure_A3, replace)

* RCE figure for appendix
areg grant rce `GSlist2' yeardum* if first_year2 != 1992, vce(cluster exam) absorb(exam)
parmest,format(estimate min95 max95 %8.2f p %8.1e) saving (figures/figure_A4, replace)




* rejection figures in appendix

* Figure A10-A12
areg novelty `GSlist2' yeardum* if first_year2 != 1992, vce(cluster exam) absorb(exam)
areg wd `GSlist2' yeardum* if first_year2 != 1992, vce(cluster exam) absorb(exam)
areg psm `GSlist2' yeardum* if first_year2 != 1992, vce(cluster exam) absorb(exam)
areg obv `GSlist2' yeardum* if first_year2 != 1992, vce(cluster exam) absorb(exam)

areg novelty `GSlist2' size duration* foreign_p cy_* yeardum* if first_year2 != 1992, vce(cluster exam) absorb(exam)
areg wd `GSlist2' size duration* foreign_p cy_* yeardum* if first_year2 != 1992, vce(cluster exam) absorb(exam)
areg psm `GSlist2' size duration* foreign_p cy_* yeardum* if first_year2 != 1992, vce(cluster exam) absorb(exam)
areg obv `GSlist2' size duration* foreign_p cy_* yeardum* if first_year2 != 1992, vce(cluster exam) absorb(exam)



* hours interpretation, for table in appendix
areg grant hours yeardum* if first_year2 != 1992, vce(cluster exam) absorb(exam)
areg grant hours classdum* yeardum* if first_year2 != 1992, vce(cluster exam) absorb(exam)
areg grant hours size rce duration* foreign_p classdum* yeardum* if first_year2 != 1992, vce(cluster exam) absorb(exam)
areg grant hours size  rce duration* foreign_p yeardum* cy_* if first_year2 != 1992, vce(cluster exam) absorb(exam)


* appendix -- focus on those with original examiners throughout
areg grant `GSlist2' yeardum* if first_year2 != 1992 & flag_redocket == 0, vce(cluster exam) absorb(exam)
parmest,format(estimate min95 max95 %8.2f p %8.1e) saving (figures/figure_redocket, replace)


* appendix -- use time of FOA as relevant time
areg grant `GSlist2_foa' foa_yeardum* if first_year2 != 1992 & flag_redocket == 0, absorb(exam) vce(cluster exam)
parmest,format(estimate min95 max95 %8.2f p %8.1e) saving (figures/figure_foa, replace)


* appendix.  falsification exercises

areg size foreign_p `GSlist2' exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 yeardum* if first_year2 != 1992, vce(cluster exam) absorb(exam)
areg foreign_p size `GSlist2' exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 yeardum* if first_year2 != 1992, vce(cluster exam) absorb(exam)

areg size foreign_p duration* rce `GSlist2' exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 yeardum* cy_* if first_year2 != 1992, vce(cluster exam) absorb(exam)
areg foreign_p size duration* rce `GSlist2' exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 yeardum* cy_* if first_year2 != 1992, vce(cluster exam) absorb(exam)


* focus on each technology separately
foreach num of numlist 1/37 {
display `num'
areg grant GSdum2 GSdum3 GSdum4 GSdum5_1 GSdum5_2 GSdum6_alt yeardum* if first_year2 != 1992 & subcatdum`num' == 1, vce(cluster exam) absorb(exam)
parmest,format(estimate min95 max95 %8.2f p %8.1e) saving (figures/figure_tech_`num', replace)
}



* Figure 3
areg grant exp_group2_12 exp_group3_12 exp_group4_12 exp_group5_12 exp_group1_13_alt exp_group2_13_alt exp_group3_13_alt exp_group4_13_alt exp_group5_13_alt exp_group1_13_alt2 exp_group2_13_alt2 exp_group3_13_alt2 exp_group4_13_alt2 exp_group5_13_alt2  exp_group1_14_alt exp_group2_14_alt exp_group3_14_alt exp_group4_14_alt exp_group5_14_alt yeardum* if first_year2 != 1992 & grade != . & grade >= 12, vce(cluster exam) absorb(exam)
parmest,format(estimate min95 max95 %8.2f p %8.1e) saving (figures/figure_3, replace)

* make sure only look at those who start pre 12
areg grant exp_group2_12 exp_group3_12 exp_group4_12 exp_group5_12 exp_group1_13_alt exp_group2_13_alt exp_group3_13_alt exp_group4_13_alt exp_group5_13_alt exp_group1_13_alt2 exp_group2_13_alt2 exp_group3_13_alt2 exp_group4_13_alt2 exp_group5_13_alt2  exp_group1_14_alt exp_group2_14_alt exp_group3_14_alt exp_group4_14_alt exp_group5_14_alt yeardum* if first_year2 != 1992 & grade != . & mingrade < 12 & mingrade != . & grade >= 12, vce(cluster exam) absorb(exam)
parmest,format(estimate min95 max95 %8.2f p %8.1e) saving (figures/figure_A6, replace)

areg grant exp_group2_12 exp_group3_12 exp_group4_12 exp_group5_12 exp_group1_13_alt exp_group2_13_alt exp_group3_13_alt exp_group4_13_alt exp_group5_13_alt exp_group1_13_alt2 exp_group2_13_alt2 exp_group3_13_alt2 exp_group4_13_alt2 exp_group5_13_alt2  exp_group1_14_alt exp_group2_14_alt exp_group3_14_alt exp_group4_14_alt exp_group5_14_alt yeardum* if first_year2 != 1992 & grade != . & mingrade < 12 & mingrade != . & maxgrade == 14 & grade >= 12, vce(cluster exam) absorb(exam)
parmest,format(estimate min95 max95 %8.2f p %8.1e) saving (figures/figure_A6, replace)


* appendix -- include 15, toggle after recreating analytical files with GS-15 included.  see setup.do
*areg grant exp_group2_12 exp_group3_12 exp_group4_12 exp_group5_12 exp_group1_13_alt exp_group2_13_alt exp_group3_13_alt exp_group4_13_alt exp_group5_13_alt exp_group1_13_alt2 exp_group2_13_alt2 exp_group3_13_alt2 exp_group4_13_alt2 exp_group5_13_alt2  exp_group1_14_alt exp_group2_14_alt exp_group3_14_alt exp_group4_14_alt exp_group5_14_alt exp_group1_15 exp_group2_15 exp_group3_15 exp_group4_15 exp_group5_15 yeardum* if first_year2 != 1992 & grade != . & grade >= 12, vce(cluster exam) absorb(exam)
*parmest,format(estimate min95 max95 %8.2f p %8.1e) saving (figure_A5, replace)
*areg grant exp_group2_12 exp_group3_12 exp_group4_12 exp_group5_12 exp_group1_13_alt exp_group2_13_alt exp_group3_13_alt exp_group4_13_alt exp_group5_13_alt exp_group1_13_alt2 exp_group2_13_alt2 exp_group3_13_alt2 exp_group4_13_alt2 exp_group5_13_alt2  exp_group1_14_alt exp_group2_14_alt exp_group3_14_alt exp_group4_14_alt exp_group5_14_alt exp_group1_15 exp_group2_15 exp_group3_15 exp_group4_15 exp_group5_15 yeardum* if grade != . & grade >= 12, vce(cluster exam) absorb(exam)
*parmest,format(estimate min95 max95 %8.2f p %8.1e) saving (figure_A5, replace)
*areg grant exp_group2_12 exp_group3_12 exp_group4_12 exp_group5_12 exp_group1_13_alt exp_group2_13_alt exp_group3_13_alt exp_group4_13_alt exp_group5_13_alt exp_group1_13_alt2 exp_group2_13_alt2 exp_group3_13_alt2 exp_group4_13_alt2 exp_group5_13_alt2  exp_group1_14_alt exp_group2_14_alt exp_group3_14_alt exp_group4_14_alt exp_group5_14_alt exp_group1_15 exp_group2_15 exp_group3_15 exp_group4_15 exp_group5_15 yeardum* if grade != . & mingrade <= 11 & mingrade != . & grade >=12, vce(cluster exam) absorb(exam)
*parmest,format(estimate min95 max95 %8.2f p %8.1e) saving (figure_A5, replace)


* Figure 4 
areg ratio_obv exp_group2_12 exp_group3_12 exp_group4_12 exp_group5_12 exp_group1_13_alt exp_group2_13_alt exp_group3_13_alt exp_group4_13_alt exp_group5_13_alt exp_group1_13_alt2 exp_group2_13_alt2 exp_group3_13_alt2 exp_group4_13_alt2 exp_group5_13_alt2  exp_group1_14_alt exp_group2_14_alt exp_group3_14_alt exp_group4_14_alt exp_group5_14_alt yeardum* if first_year2 != 1992 & grade != . & grade >= 12, vce(cluster exam) absorb(exam)
parmest,format(estimate min95 max95 %8.2f p %8.1e) saving (figures/figure_4, replace)


* Figure 5
areg obv exp_group2_12 exp_group3_12 exp_group4_12 exp_group5_12 exp_group1_13_alt exp_group2_13_alt exp_group3_13_alt exp_group4_13_alt exp_group5_13_alt exp_group1_13_alt2 exp_group2_13_alt2 exp_group3_13_alt2 exp_group4_13_alt2 exp_group5_13_alt2  exp_group1_14_alt exp_group2_14_alt exp_group3_14_alt exp_group4_14_alt exp_group5_14_alt yeardum* if first_year2 != 1992 & grade != . & grade >= 12, vce(cluster exam) absorb(exam)
parmest,format(estimate min95 max95 %8.2f p %8.1e) saving (figures/figure_5, replace)

areg obv exp_group2_12 exp_group3_12 exp_group4_12 exp_group5_12 exp_group1_13_alt exp_group2_13_alt exp_group3_13_alt exp_group4_13_alt exp_group5_13_alt exp_group1_13_alt2 exp_group2_13_alt2 exp_group3_13_alt2 exp_group4_13_alt2 exp_group5_13_alt2  exp_group1_14_alt exp_group2_14_alt exp_group3_14_alt exp_group4_14_alt exp_group5_14_alt yeardum* if first_year2 != 1992 & grade != . & mingrade <= 11 & mingrade != . & grade < 15 & grade >= 12, vce(cluster exam) absorb(exam)
parmest,format(estimate min95 max95 %8.2f p %8.1e) saving (figures/figure_A7, replace)


*areg obv exp_group2_12 exp_group3_12 exp_group4_12 exp_group5_12 exp_group1_13_alt exp_group2_13_alt exp_group3_13_alt exp_group4_13_alt exp_group5_13_alt exp_group1_13_alt2 exp_group2_13_alt2 exp_group3_13_alt2 exp_group4_13_alt2 exp_group5_13_alt2  exp_group1_14_alt exp_group2_14_alt exp_group3_14_alt exp_group4_14_alt exp_group5_14_alt exp_group1_15 exp_group2_15 exp_group3_15 exp_group4_15 exp_group5_15 yeardum* if first_year2 != 1992 & grade != . & grade >= 12, vce(cluster exam) absorb(exam)
*parmest,format(estimate min95 max95 %8.2f p %8.1e) saving (figures/figure_A8, replace)

*areg obv exp_group2_12 exp_group3_12 exp_group4_12 exp_group5_12 exp_group1_13_alt exp_group2_13_alt exp_group3_13_alt exp_group4_13_alt exp_group5_13_alt exp_group1_13_alt2 exp_group2_13_alt2 exp_group3_13_alt2 exp_group4_13_alt2 exp_group5_13_alt2  exp_group1_14_alt exp_group2_14_alt exp_group3_14_alt exp_group4_14_alt exp_group5_14_alt exp_group1_15 exp_group2_15 exp_group3_15 exp_group4_15 exp_group5_15 yeardum* if first_year2 != 1992 & grade != . & mingrade <= 11 & mingrade != . & grade >= 12, vce(cluster exam) absorb(exam)
*parmest,format(estimate min95 max95 %8.2f p %8.1e) saving (figures/figure_A9, replace)


*areg grant exp_group2_12_foa exp_group3_12_foa exp_group4_12_foa exp_group5_12_foa exp_group1_13_1_foa exp_group2_13_1_foa exp_group3_13_1_foa exp_group4_13_1_foa exp_group5_13_1_foa exp_group1_13_2_foa exp_group2_13_2_foa exp_group3_13_2_foa exp_group4_13_2_foa exp_group5_13_2_foa exp_group1_14_foa exp_group2_14_foa exp_group3_14_foa exp_group4_14_foa exp_group5_14_foa foa_yeardum* if first_year2 != 1992 & grade_foa >= 12 & grade_foa != ., absorb(exam) vce(cluster exam)
*areg grant exp_group2_12_foa exp_group3_12_foa exp_group4_12_foa exp_group5_12_foa exp_group1_13_1_foa exp_group2_13_1_foa exp_group3_13_1_foa exp_group4_13_1_foa exp_group5_13_1_foa exp_group1_13_2_foa exp_group2_13_2_foa exp_group3_13_2_foa exp_group4_13_2_foa exp_group5_13_2_foa exp_group1_14_foa exp_group2_14_foa exp_group3_14_foa exp_group4_14_foa exp_group5_14_foa foa_yeardum* if first_year2 != 1992 & flag_redocket == 0 & grade_foa >= 12 & grade_foa != ., absorb(exam) vce(cluster exam)


* appendix balanced analysis, Table A6



 
sort exam year
merge m:1 exam year using temp/leads14
drop _merge

bysort exam: egen yearsat14_base = max(grade_alt_year) if grade_alt == 14
bysort exam: egen yearsat14 = mean(yearsat14_base)


bysort exam: egen yearsat13_2_base = max(grade_alt_year) if grade_alt == 13.2
bysort exam: egen yearsat13_2 = mean(yearsat13_2_base)

bysort exam: egen yearsat13_1_base = max(grade_alt_year) if grade_alt == 13.1
bysort exam: egen yearsat13_1 = mean(yearsat13_1_base)

bysort exam: egen yearsat12_base = max(grade_alt_year) if grade_alt == 12
bysort exam: egen yearsat12 = mean(yearsat12_base)

bysort exam: egen yearsat11_base = max(grade_alt_year) if grade_alt == 11
bysort exam: egen yearsat11 = mean(yearsat11_base)

bysort exam: egen yearsat9_base = max(grade_alt_year) if grade_alt == 9
bysort exam: egen yearsat9 = mean(yearsat9_base)

bysort exam: egen yearsat7_base = max(grade_alt_year) if grade_alt == 7
bysort exam: egen yearsat7 = mean(yearsat7_base)


replace yearsat7 = 0 if yearsat7 == .
replace yearsat9 = 0 if yearsat9 == .
replace yearsat11 = 0 if yearsat11 == .
replace yearsat12 = 0 if yearsat12 == .
replace yearsat13_1 = 0 if yearsat13_1 == .
replace yearsat13_2 = 0 if yearsat13_2 == .


gen yearspriorto14 = yearsat7 + yearsat9 + yearsat11 + yearsat12 + yearsat13_1 + yearsat13_2

areg grant lead4grade14 lead2grade14 grade14 l2grade14 l4grade14 yeardum* if first_year2 != 1992 & maxgrade == 14 & yearsat14 >= 4 & yearsat14 != . & yearspriorto14 >= 4 & yearspriorto14 != ., absorb(exam) vce(cluster exam)
areg grant lead4grade14 lead2grade14 grade14 l2grade14 l4grade14 yeardum* if first_year2 != 1992 & maxgrade == 14 & mingrade < 14 & mingrade != . & yearsat14 >= 4 & yearsat14 != .  & yearspriorto14 >= 4 & yearspriorto14 != ., absorb(exam) vce(cluster exam)
areg grant size duration* foreign_p lead4grade14 lead2grade14 grade14 l2grade14 l4grade14 yeardum* cy_* if first_year2 != 1992 & maxgrade == 14 & mingrade < 14 & mingrade != . & yearsat14 >= 4 & yearsat14 != .  & yearspriorto14 >= 4 & yearspriorto14 != ., absorb(exam) vce(cluster exam)




* the following analysis assessing the underlying granting tendencies of those who are promoted quickly versus those
* promoted more slowly

gen yearsat12to14 = yearsat12 + yearsat13_1 + yearsat13_2

gen bottomgrade = mingrade
gen topgrade = maxgrade

sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 3 & year == 2002 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 4 & year == 2002 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 5 & year == 2002 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 6 & year == 2002 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 7 & year == 2002 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 8 & year == 2002 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 9 & year == 2002 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 10 & year == 2002 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 11 & year == 2002 & first_year2 != 1992

sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 3 & year == 2003 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 4 & year == 2003 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 5 & year == 2003 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 6 & year == 2003 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 7 & year == 2003 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 8 & year == 2003 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 9 & year == 2003 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 10 & year == 2003 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 11 & year == 2003 & first_year2 != 1992

sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 3 & year == 2004 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 4 & year == 2004 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 5 & year == 2004 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 6 & year == 2004 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 7 & year == 2004 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 8 & year == 2004 & first_year2 != 1992

sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 3 & year == 2005 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 4 & year == 2005 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 5 & year == 2005 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 6 & year == 2005 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 7 & year == 2005 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 8 & year == 2005 & first_year2 != 1992

sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 3 & year == 2006 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 4 & year == 2006 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 5 & year == 2006 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 6 & year == 2006 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 7 & year == 2006 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 8 & year == 2006 & first_year2 != 1992

sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 3 & year == 2007 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 4 & year == 2007 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 5 & year == 2007 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 6 & year == 2007 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 7 & year == 2007 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 8 & year == 2007 & first_year2 != 1992

sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 3 & year == 2008 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 4 & year == 2008 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 5 & year == 2008  & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 6 & year == 2008  & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 7 & year == 2008  & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 8 & year == 2008  & first_year2 != 1992

sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 3 & year == 2009  & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 4 & year == 2009  & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 5 & year == 2009  & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 6 & year == 2009  & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 7 & year == 2009  & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 8 & year == 2009  & first_year2 != 1992

sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 3 & year == 2010  & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 4 & year == 2010  & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 5 & year == 2010  & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 6 & year == 2010  & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 7 & year == 2010  & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 8 & year == 2010  & first_year2 != 1992

sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 3 & year == 2011  & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 4 & year == 2011  & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 5 & year == 2011  & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 6 & year == 2011  & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 7 & year == 2011  & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 8 & year == 2011  & first_year2 != 1992

sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 3 & year == 2012 & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 4 & year == 2012  & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 5 & year == 2012  & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 6 & year == 2012  & first_year2 != 1992
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 7 & year == 2012 & first_year2 != 1992 
sum grant if topgrade == 14 & bottomgrade < 12 & bottomgrade != . & yearsat12to14 == 8 & year == 2012 & first_year2 != 1992


drop if yearsat12to14 > 11 & yearsat12to14 != .



gen fast_3 = 0
replace fast_3 = 1 if yearsat12to14 >= 0 & yearsat12to14 <= 3 & yearsat12to14 != .

gen slower_3 = 0
replace slower_3 = 1 if yearsat12to14 >= 4 & yearsat12to14 <= 7 & yearsat12to14 != .

gen slow_3 = 0
replace slow_3 = 1 if yearsat12to14 >= 8 & yearsat12to14 <= 11 & yearsat12to14 != .


* Table A8
regress grant slower_3 slow_3 if first_year2 != 1992 & mingrade < 12 & mingrade != . & maxgrade == 14, cluster(exam)
regress grant slower_3 slow_3 yeardum* if first_year2 != 1992 & mingrade < 12 & mingrade != . & maxgrade == 14, cluster(exam)
regress grant slower_3 slow_3 exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 GSdum2 GSdum3 GSdum4 GSdum5_1 GSdum5_2 GSdum6_alt yeardum* if first_year2 != 1992 & mingrade < 12 & mingrade != . & maxgrade == 14, cluster(exam)
regress grant slower_3 slow_3 exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 GSdum2 GSdum3 GSdum4 GSdum5_1 GSdum5_2 GSdum6_alt yeardum* first_year2dum* max_exp_2 max_exp_3 max_exp_4 max_exp_5 max_exp_6 if first_year2 != 1992 & mingrade < 12 & mingrade != . & maxgrade == 14, cluster(exam)


tab yearsat12to14, gen(yearsat12to14dum)

regress grant yearsat12to14dum2 yearsat12to14dum3 yearsat12to14dum4 yearsat12to14dum5 yearsat12to14dum6 yearsat12to14dum7 yearsat12to14dum8 yearsat12to14dum9 yearsat12to14dum10 yearsat12to14dum11 exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 GSdum2 GSdum3 GSdum4 GSdum5_1 GSdum5_2 GSdum6_alt yeardum* if first_year2 != 1992 & mingrade < 12 & mingrade != . & maxgrade == 14, cluster(exam)
regress grant yearsat12to14dum2 yearsat12to14dum3 yearsat12to14dum4 yearsat12to14dum5 yearsat12to14dum6 yearsat12to14dum7 yearsat12to14dum8 yearsat12to14dum9 yearsat12to14dum10 yearsat12to14dum11 exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 GSdum2 GSdum3 GSdum4 GSdum5_1 GSdum5_2 GSdum6_alt yeardum* first_year2dum* max_exp_2 max_exp_3 max_exp_4 max_exp_5 max_exp_6 if first_year2 != 1992  & mingrade < 12 & mingrade != . & maxgrade == 14, cluster(exam)

}











if `sample' == 2 {

use analytical_patented
*insheet using analytical_patented.txt

rename gsdum2  GSdum2
rename gsdum3 GSdum3
rename gsdum4 GSdum4
rename gsdum5_1 GSdum5_1
rename gsdum5_2 GSdum5_2
rename gsdum6_alt GSdum6_alt


* Table 4, Columns 3 and 4
areg excite_ratio_new GSdum2 GSdum3 GSdum4 GSdum5_1 GSdum5_2 GSdum6_alt yeardum* if first_year2 != 1992, absorb(exam) vce(cluster exam)
areg excite_ratio_new GSdum2 GSdum3 GSdum4 GSdum5_1 GSdum5_2 GSdum6_alt exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 yeardum* if first_year2 != 1992, absorb(exam) vce(cluster exam)


* table 5

areg grant_epo_jpo `GSlist2' exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 yeardum* if first_year2 != 1992 & family == 1, vce(cluster exam) absorb(exam)
areg grant_epo_jpo size foreign_priority duration duration_sq `GSlist2' exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 yeardum* if first_year2 != 1992 & family == 1, vce(cluster exam) absorb(exam)
areg grant_epo_jpo size foreign_priority duration duration_sq `GSlist2' exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 yeardum* cy_* if first_year2 != 1992 & family == 1, vce(cluster exam) absorb(exam)

areg grant_epo `GSlist2' exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 yeardum* if first_year2 != 1992 & family == 1, vce(cluster exam) absorb(exam)
areg grant_epo size foreign_priority duration duration_sq `GSlist2' exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 yeardum* if first_year2 != 1992 & family == 1, vce(cluster exam) absorb(exam)
areg grant_epo size foreign_priority duration duration_sq `GSlist2' exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 yeardum* cy_* if first_year2 != 1992 & family == 1, vce(cluster exam) absorb(exam)

areg grant_jpo `GSlist2' exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 yeardum* if first_year2 != 1992 & family == 1, vce(cluster exam) absorb(exam)
areg grant_jpo size foreign_priority duration duration_sq `GSlist2' exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 yeardum* if first_year2 != 1992 & family == 1, vce(cluster exam) absorb(exam)
areg grant_jpo size foreign_priority duration duration_sq `GSlist2' exp_group2 exp_group3 exp_group4 exp_group5 exp_group6 exp_group7 exp_group8 yeardum* cy_* if first_year2 != 1992 & family == 1, vce(cluster exam) absorb(exam)



* Appendix figure for application cites
areg app_cites `GSlist2' yeardum* if first_year2 != 1992 , vce(cluster exam) absorb(exam)
parmest,format(estimate min95 max95 %8.2f p %8.1e) saving (figures/figure_A13, replace)

areg total_excites `GSlist2' yeardum* if first_year2 != 1992 , vce(cluster exam) absorb(exam)
parmest,format(estimate min95 max95 %8.2f p %8.1e) saving (figures/figure_A14, replace)



}






















































