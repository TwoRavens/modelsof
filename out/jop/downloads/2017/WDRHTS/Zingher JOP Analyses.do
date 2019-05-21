**********************************************************
*
*		MERGING IN DW-NOMINATE COMMON SPACE SCORES
*
**********************************************************


* Gathering NOMINATE data and calculating the mean and 
clear all
cd  "~/Dropbox/Partisan Change/Analysis Files"
use "DW-NOMINATE Scores House and Senate.dta"

keep if cong >= 87

keep cong state cd statenm party dwnom1 dwnom2
drop if state == 99
sort cong 

* Congress means and variances
by cong: egen dwnom1_cmean = mean(dwnom1)
by cong: egen dwnom2_cmean = mean(dwnom2)
by cong: egen dwnom1_cvar = sd(dwnom1)
by cong: egen dwnom2_cvar = sd(dwnom2)


label var dwnom1_cmean "Congress Mean (First Dimension)"
label var dwnom2_cmean "Congress Mean (Second Dimension)"
label var dwnom1_cvar "Congress Variance (First Dimension)"
label var dwnom2_cvar "Congress Variance (Second Dimension)"


* Party means and variances
by cong: egen dwnom1_dmean = mean(dwnom1) if party == 100
by cong: egen dwnom1_rmean = mean(dwnom1) if party == 200

by cong: egen dwnom2_dmean = mean(dwnom2) if party == 100
by cong: egen dwnom2_rmean = mean(dwnom2) if party == 200

by cong: egen dwnom1_dvar = sd(dwnom1) if party == 100
by cong: egen dwnom1_rvar = sd(dwnom1) if party == 200

by cong: egen dwnom2_dvar = sd(dwnom2) if party == 100
by cong: egen dwnom2_rvar = sd(dwnom2) if party == 200

replace dwnom1_dvar = dwnom1_dvar^2
replace dwnom1_rvar = dwnom1_rvar^2
replace dwnom2_dvar = dwnom2_dvar^2
replace dwnom2_rvar = dwnom2_rvar^2

label var dwnom1_dmean "Democratic Mean (First Dimension)"
label var dwnom1_rmean "Republican Mean (First Dimension)"
label var dwnom2_dmean "Democratic Mean (Second Dimension)"
label var dwnom2_rmean "Republican Mean (Second Dimension)"
label var dwnom1_dvar "Democratic Variance (First Dimension)"
label var dwnom1_rvar "Republican Variance (First Dimension)"
label var dwnom2_dvar "Democratic Variance (Second Dimension)"
label var dwnom2_rvar "Republican Variance (Second Dimension)"

collapse (mean) dwnom1_cmean dwnom2_cmean dwnom1_cvar dwnom2_cvar dwnom1_dmean dwnom1_rmean dwnom2_dmean dwnom2_rmean dwnom1_dvar dwnom1_rvar dwnom2_dvar dwnom2_rvar , by(cong)

tsset cong
gen year = 1962 if cong == 87
replace year = l.year+2 if year == . 

label var year "Last Year of Congress"

sort year

tempfile clear
tempfile NOMINATE_CS

save `NOMINATE_CS'

clear


* Merging in DW-NOMINATE data with the individual-level data

use "ANES_POST_FACTOR_COMBINED.dta"
sort year
merge m:1 year using `NOMINATE_CS', gen(nominate_merge) update replace

save `NOMINATE_CS', replace

keep if nominate_merge == 2
keep year dwnom1_cmean dwnom2_cmean dwnom1_cvar dwnom2_cvar dwnom1_dmean dwnom1_rmean dwnom2_dmean dwnom2_rmean dwnom1_dvar dwnom1_rvar dwnom2_dvar dwnom2_rvar 

tsset year

foreach var of varlist dwnom1_cmean-dwnom2_rvar {
rename `var' `var'_lag
}

replace year = year + 2
drop if year > 2012
sort year

tempfile NOMINATE_CS_LAG
save `NOMINATE_CS_LAG', replace

clear

use `NOMINATE_CS'
merge m:1 year using `NOMINATE_CS_LAG', nogen update replace

gen dwnom1_difference = dwnom1_rmean-dwnom1_dmean 

gen state = ""
replace state ="Alabama" if  VCF0901==41
replace state ="Alaska" if VCF0901==81
replace state ="Arizona" if VCF0901==61
replace state ="Arkansas" if VCF0901==41
replace state ="California" if VCF0901==71
replace state ="Colorado" if VCF0901==62
replace state ="Connecticut" if VCF0901==01
replace state ="Delaware" if VCF0901==11
replace state ="Florida" if VCF0901==43
replace state ="Georgia" if VCF0901==44
replace state ="Hawaii" if VCF0901==82
replace state ="Idaho" if VCF0901==63
replace state ="Illinois" if VCF0901==21
replace state ="Indiana" if VCF0901==22
replace state ="Iowa" if VCF0901==31
replace state ="Kansas" if VCF0901==32
replace state ="Kentucky" if VCF0901==51
replace state ="Louisiana" if VCF0901==45
replace state ="Maine" if VCF0901==02
replace state ="Maryland" if VCF0901==52
replace state ="Massachusetts" if VCF0901==03
replace state ="Michigan" if VCF0901==23
replace state ="Minnesota" if VCF0901==33
replace state ="Mississippi" if VCF0901==46
replace state ="Missouri" if VCF0901==34
replace state ="Montana" if VCF0901==64
replace state ="Nebraska" if VCF0901==35
replace state ="Nevada" if VCF0901==65
replace state ="New Hampshire" if VCF0901==04
replace state ="New Jersey" if VCF0901==12
replace state ="New Mexico" if VCF0901==66
replace state ="New York" if VCF0901==13
replace state ="North Carolina" if VCF0901==47
replace state ="North Dakota" if VCF0901==36
replace state ="Ohio" if  VCF0901==24
replace state ="Oklahoma" if  VCF0901==53
replace state ="Oregon" if  VCF0901==72
replace state ="Pennsylvania" if  VCF0901==14
replace state ="Rhode Island" if  VCF0901==05
replace state ="South Carolina" if VCF0901==48
replace state ="Tennessee" if VCF0901==54
replace state ="Texas" if VCF0901==49
replace state ="Utah" if VCF0901==67
replace state ="Vermont" if VCF0901==06
replace state ="Virginia" if VCF0901==40
replace state ="Washington" if VCF0901==73
replace state ="West Virginia" if VCF0901==56
replace state ="Wisconsin" if VCF0901==25
replace state ="Wyoming" if VCF0901==68
replace state ="District of Columbia" if VCF0901==55

drop if VCF0006==.
drop if year==.


/// Generating Variables Necessary for Sorting/Demographic Change Analysis

/// Dealing with non-responses
replace PID_7 =. if PID_7==0
replace age=. if age==0
replace Income=. if Income==0

rename VCF0130 weekly_church1

///Whites
gen white = 0
replace white= 1 if  race_3cat==1
replace white= 1 if year==2012 & dem_raceeth_x==1
///African Americans
gen Black =0 
replace Black=1 if race_6cat==2
replace Black=1 if race_3cat==2
replace Black=1 if dem_raceeth_x==2 & year==2012
///Latinos
gen Latino =0 
replace Latino=1 if race_6cat==5
replace Latino=1 if dem_raceeth_x==3 & year==2012
/// Gender
gen female = 0
replace female=1 if gender==2
/// South
gen South = 0
replace South = 1 if Census_region == 3
/// White-Southerner
gen white_southerner = 0
replace white_southerner = 1 if Census_region == 3 & race_3cat==1
replace white_southerner = 1 if Census_region == 3 & dem_raceeth_x==1 & year==2012
/// College Graduate
gen collegegrad =0 
replace collegegrad = 1 if education_6cat==6
///Union Member
gen unionmember=0
replace unionmember =1 if Union==1
/// Jew
gen Jew = 0
replace Jew =1 if religion==3
/// White Catholic
gen Catholic =0
replace Catholic =1 if religion==2 & white==1 
/// Weekly Church Attendee
gen weeklychurch=0
replace weeklychurch=1 if weekly_church==1 | weekly_church==2
/// Non-Religious
gen nonreligious=0
replace nonreligious=1 if religion==4


gen policy_mood = . 
replace policy_mood = 63.64 if year==1972
replace policy_mood = 63.64 if year==1972
replace policy_mood = 55.6 if year==1976
replace policy_mood = 50.1 if year==1980
replace policy_mood = 58.34 if year==1983
replace policy_mood = 58.90 if year==1984
replace policy_mood = 60.28 if year==1986
replace policy_mood = 62.9 if year==1987
replace policy_mood = 64.77 if year==1988
replace policy_mood = 66.05 if year==1989
replace policy_mood = 64.58 if year==1990
replace policy_mood = 65.49 if year==1991
replace policy_mood = 65.42 if year==1992
replace policy_mood = 62.48 if year==1993
replace policy_mood = 58.24 if year==1994
replace policy_mood = 56.74 if year==1996
replace policy_mood = 59.16 if year==1998
replace policy_mood = 60.58 if year==2000
replace policy_mood = 66.7 if year==2002
replace policy_mood = 64.7 if year==2004
replace policy_mood = 66.4 if year==2006
replace policy_mood = 66.6 if year==2008
replace policy_mood = 65.23 if year==2009
replace policy_mood = 61.48 if year==2010
replace policy_mood = 62.3 if year==2011
replace policy_mood = 61.25 if year==2012
replace policy_mood = 60.4 if year==2013
replace policy_mood = 59.1 if year==2014

rename VCF0206 FT_Blacks
rename VCF0217 FT_Latinos
rename VCF0207 FT_Whites

/// Implicit Racism--generating the implicit racism scale
recode VCF9040 (1=5) (2=4) (4=2) (5=1)
recode VCF9041 (1=5) (2=4) (4=2) (5=1)

polychoric VCF9042 VCF9041 VCF9040 VCF9039, pw
display r(sum_w)
matrix polyImplicit = r(R)
factormat polyImplicit, n(7032) factors(1)  ml
predict FIMP

zscore VCF9042 VCF9041 VCF9040 VCF9039

gen I1= VCF9042*.2672
gen I2= VCF9041*.3004
gen I3= VCF9040*.3363
gen I4= VCF9039*.2265

egen I1_max1=  max(I1)   
egen I2_max2=  max(I2)    
egen I3_max3=  max(I3)
egen I4_max4=  max(I4)

gen I1_MI = 1 if I1~=.
gen I2_MI = 1 if I2~=.
gen I3_MI = 1 if I3~=.
gen I4_MI = 1 if I4~=.

gen I1_Ind_MAX = I1_max1* I1_MI
gen I2_Ind_MAX = I2_max2* I2_MI
gen I3_Ind_MAX = I3_max3* I3_MI
gen I4_Ind_MAX = I4_max4* I4_MI

egen IMP_Ind_Max = rowtotal(I1_Ind_MAX-I4_Ind_MAX)
egen MaxIMP = max(IMP_Ind_Max)
gen Pct_MaxIMP = IMP_Ind_Max/MaxIMP

egen IMP_Score = rowtotal(I1-I4)
replace IMP_Score=. if Pct_MaxIMP<.4
replace IMP_Score= IMP_Score/Pct_MaxIMP if IMP_Score~=.

/// Gap in Candidate Perceptions Towards Aiding Blacks
replace  VCF9092 = . if  VCF9092==8 |  VCF9092==9 | VCF9092==0
replace  VCF0518 = . if  VCF0518==8 |  VCF0518==9 | VCF0518==0
gen PartyFavBlack = VCF9092-VCF9084
/// Mean white attitudes
sort year
by year: egen W_ATP_PG= mean(PartyFavBlack) if white==1
by year: egen NW_ATP_PG= mean(PartyFavBlack) if white==0
label variable W_ATP_PG "White"
label variable NW_ATP_PG "Non-White"
twoway scatter W_ATP_PG year if year>=1972, mcolor(red) || scatter NW_ATP_PG year if year>=1972, xlabel(1972(4)2012) mcolor(blue) legend(cols(2)) xtitle(Year) ytitle(Mean Gap Between Perceived Party Positions) title(Aid to Blacks)
graph export "Aid to Blacks.pdf", replace

/// Group Size, AA
gen AA_GS = .
replace AA_GS = .11 if year==1972
replace AA_GS = .11 if year==1976
replace AA_GS = .12 if year==1980
replace AA_GS = .12 if year==1984
replace AA_GS = .12 if year==1988
replace AA_GS = .12 if year==1992
replace AA_GS = .12 if year==1996
replace AA_GS = .13 if year==2000
replace AA_GS = .13 if year==2004
replace AA_GS = .13 if year==2008
replace AA_GS = .13 if year==2012
/// Group Size, Latino
gen LAT_GS = .
replace LAT_GS = .05 if year==1972
replace LAT_GS = .06 if year==1976
replace LAT_GS = .06 if year==1980
replace LAT_GS = .07 if year==1984
replace LAT_GS = .08 if year==1988
replace LAT_GS = .09 if year==1992
replace LAT_GS = .11 if year==1996
replace LAT_GS = .13 if year==2000
replace LAT_GS = .14 if year==2004
replace LAT_GS = .16 if year==2008
replace LAT_GS = .18 if year==2012

/// Group Size, WHITE
gen WHITE_GS = .
replace WHITE_GS = .83 if year==1972
replace WHITE_GS = .81 if year==1976
replace WHITE_GS = .80 if year==1980
replace WHITE_GS = .78 if year==1984
replace WHITE_GS = .77 if year==1988
replace WHITE_GS = .76 if year==1992
replace WHITE_GS = .73 if year==1996
replace WHITE_GS = .70 if year==2000
replace WHITE_GS = .67 if year==2004
replace WHITE_GS = .64 if year==2008
replace WHITE_GS = .63 if year==2012

gen total_AA = Total_Pop*AA_GS
gen total_AA_REG = total_AA*Black_Reg

gen total_LAT = Total_Pop*LAT_GS
gen total_LAT_REG = total_LAT*Hisp_Reg

gen Minority_Prop = (total_AA_REG+total_LAT_REG)/Total_Reg
replace Minority_Prop = Minority_Prop * 100

/// Generating Median Positions

local a = 1972
gen wtmedian=.
while `a' <=2012{
summarize F1_Adj [w=vcf0009z] if year==`a', detail
replace wtmedian = r(p50) if year==`a'
local a = `a' + 4
}
 
 
local a = 1972
gen wwtmedian=.
while `a' <=2012{
summarize F1_Adj [w=vcf0009z] if year==`a' & white==1, detail
replace wwtmedian = r(p50) if year==`a'
local a = `a' + 4
}
 
local a = 1972
gen wtmedian2=.
while `a' <=2012{
summarize F2_Adj [w=vcf0009z] if year==`a', detail
replace wtmedian2 = r(p50) if year==`a'
local a = `a' + 4
}
 
 
local a = 1972
gen wwtmedian2=.
while `a' <=2012{
summarize F2_Adj [w=vcf0009z] if year==`a' & white==1, detail
replace wwtmedian2 = r(p50) if year==`a'
local a = `a' + 4
}
 
  
/// White Median relative to the overall median
gen whitedist = wwtmedian-wtmedian
gen whitedist2 = wwtmedian2-wtmedian2

/// Distance From Median
gen Med_Dist = wtmedian-(-F1_Adj)
gen Med_Dist_F2 = wtmedian2-(-F2_Adj)


gen inter1 = dwnom1_difference*Med_Dist
gen inter2 = dwnom1_difference*Med_Dist_F2
gen inter3 = IMP_Score*dwnom1_difference
recode PID_7 (1=7) (2=6) (3=5) (5=3) (6=2) (7=1)
recode Pres_Vote (3 = .) (2 = 0) 

label define RepDem 0 Republican 1 Democrat
label values Pres_Vote RepDem

bysort year: egen Mean_Dem_Support = mean(Pres_Vote)

/// Self placement--Data Cleaning
replace DemC_LibCon = . if DemC_LibCon==0 |  DemC_LibCon==8 | DemC_LibCon==9 
replace RepC_LibCon = . if RepC_LibCon==0 |  RepC_LibCon==8 |  RepC_LibCon==9 
/// Whites Only
by year: egen Mean_White_RPres_Pl = wtmean(RepC_LibCon) if white==1, weight(vcf0010z) 
by year: egen Mean_White_DPres_Pl = wtmean(DemC_LibCon) if white==1, weight(vcf0010z) 
by year: egen Mean_White_Pl = wtmean(Lib_Con_Scale) if white==1, weight(vcf0010z) 
by year: gen White_Rep_Dist = abs(Mean_White_RPres_Pl-Mean_White_Pl)
by year: gen White_Dem_Dist = abs(Mean_White_DPres_Pl-Mean_White_Pl)
/// Non-Whites Only
by year: egen Mean_NWhite_RPres_Pl = wtmean(RepC_LibCon) if white==0, weight(vcf0010z) 
by year: egen Mean_NWhite_DPres_Pl = wtmean(DemC_LibCon) if white==0, weight(vcf0010z) 
by year: egen Mean_NWhite_Pl = wtmean(Lib_Con_Scale) if white==0, weight(vcf0010z) 
by year: gen NWhite_Rep_Dist = abs(Mean_NWhite_RPres_Pl-Mean_NWhite_Pl)
by year: gen NWhite_Dem_Dist = abs(Mean_NWhite_DPres_Pl-Mean_NWhite_Pl)
/// Full Sample
by year: egen Mean_RPres_Pl = wtmean(RepC_LibCon), weight(vcf0010z)
by year: egen Mean_DPres_Pl = wtmean(DemC_LibCon), weight(vcf0010z)
by year: egen Mean_Pl = wtmean(Lib_Con_Scale), weight(vcf0010z)
by year: gen Mean_Dem_Dist = abs(Mean_DPres_Pl-Mean_Pl)
by year: gen Mean_Rep_Dist = abs(Mean_RPres_Pl-Mean_Pl)

/// Individual Party Distances--Full Sample
gen Dem_Dist = abs(Lib_Con_Scale-DemC_LibCon)
gen Rep_Dist = abs(Lib_Con_Scale-RepC_LibCon)
gen Party_Dis = Dem_Dist-Rep_Dist
/// Mean Party Distances--Full Sample
by year: egen Ave_Dem_Dist = wtmean(Dem_Dist), weight(vcf0010z) 
by year: egen Ave_Rep_Dist = wtmean(Rep_Dist), weight(vcf0010z) 

by year: gen Ave_Rep_AdvW = White_Dem_Dist-White_Rep_Dist 
/// Table 1
by year: tab PID_7 if white==1  [aweight= vcf0010z]
by year: tab PID_7 if white==1 & white_southerner==0  [aweight= vcf0010z]
by year: tab PID_7 if white==1 & white_southerner==1  [aweight= vcf0010z]



save "Zingher JOP 2017.dta", replace

xtset year

/// Base Equation--Vote Choice--Table 2 Main Text Models 1-2

probit Pres_Vote Med_Dist Med_Dist_F2 white_southerner female Income age weeklychurch Catholic Jew unionmember education_6cat dwnom1_difference inter1 inter2 policy_mood Mean_Dem_Support if year>=1971 & white==1 [pweight= vcf0010z]  , robust
outreg2 using table1, auto(2) alpha(.05) dec(2) symbol(*) e(r2_p)  replace
probit Pres_Vote Med_Dist Med_Dist_F2 white_southerner female Income age weeklychurch Catholic Jew unionmember education_6cat dwnom1_difference inter1 inter2 policy_mood Mean_Dem_Support Party_Dis if year>=1971 & white==1 [pweight= vcf0010z]  , robust
estimates save Vote_Choice, replace
outreg2 using table1, auto(2) alpha(.05) dec(2) symbol(*)  e(r2_p) append
prgen Party_Dis, gen(Predicted_Prob_VC) from(-6) to(6) gap(1) rest(mean) ci
twoway connected Predip1 Predix, xlabel(-6(2)6) ytitle(Probability of Voting for Democrat) xtitle(Perceived Party Distance)
/// Base Equation--Partisanship--Table 2 Main Text Modesl 3-4

regress PID_7 Med_Dist Med_Dist_F2 white_southerner female Income age weeklychurch Catholic Jew unionmember education_6cat dwnom1_difference inter1 inter2 policy_mood Mean_Dem_Support if year>=1971 & white==1 [pweight= vcf0010z], robust
outreg2 using table2, auto(2) alpha(.05) dec(2) symbol(*) replace
regress PID_7 Med_Dist Med_Dist_F2 white_southerner female Income age weeklychurch Catholic Jew unionmember education_6cat dwnom1_difference inter1 inter2 policy_mood Mean_Dem_Support  Party_Dis   if year>=1971 & white==1 [pweight= vcf0010z], robust
estimates save Partisanship, replace
outreg2 using table2, auto(2) alpha(.05) dec(2) symbol(*) append

/// Appendix Table 4 --Implicit Racism and Immigration Attitudes
probit Pres_Vote Med_Dist Med_Dist_F2 white_southerner female Income age weeklychurch Catholic Jew unionmember education_6cat  dwnom1_difference inter1 inter2  policy_mood Mean_Dem_Support Party_Dis IMP_Score if year>=1971 & white==1 [pweight= vcf0010z] , robust
outreg2 using Appendix4, auto(2) alpha(.05) dec(2) symbol(*)  e(r2_p) replace
probit Pres_Vote Med_Dist Med_Dist_F2 white_southerner female Income age weeklychurch Catholic Jew unionmember education_6cat  dwnom1_difference inter1 inter2  policy_mood Mean_Dem_Support Party_Dis IMP_Score inter3 if year>=1971 & white==1 [pweight= vcf0010z] , robust
outreg2 using Appendix4, auto(2) alpha(.05) dec(2) symbol(*)  e(r2_p) append
probit Pres_Vote Med_Dist Med_Dist_F2 white_southerner female Income age weeklychurch Catholic Jew unionmember education_6cat dwnom1_difference inter1 inter2 policy_mood  Mean_Dem_Support Party_Dis Immigrants_Scale if year>=1971 & white==1 [pweight= vcf0010z] , robust
outreg2 using Appendix4, auto(2) alpha(.05) dec(2) symbol(*)  e(r2_p) append
regress PID_7 Med_Dist Med_Dist_F2 white_southerner female Income age weeklychurch Catholic Jew unionmember education_6cat  dwnom1_difference inter1 inter2 policy_mood Mean_Dem_Support Party_Dis  IMP_Score  if year>=1971 & white==1 [pweight= vcf0010z], robust
outreg2 using Appendix4, auto(2) alpha(.05) dec(2) symbol(*) append
regress PID_7 Med_Dist Med_Dist_F2 white_southerner female Income age weeklychurch Catholic Jew unionmember education_6cat  dwnom1_difference inter1 inter2 policy_mood Mean_Dem_Support Party_Dis  IMP_Score inter3  if year>=1971 & white==1 [pweight= vcf0010z], robust
outreg2 using Appendix4, auto(2) alpha(.05) dec(2) symbol(*) append
regress PID_7 Med_Dist Med_Dist_F2 white_southerner female Income age weeklychurch Catholic Jew unionmember education_6cat  dwnom1_difference inter1 inter2 policy_mood Mean_Dem_Support Party_Dis  Immigrants_Scale if year>=1971 & white==1 [pweight= vcf0010z], robust
outreg2 using Appendix4, auto(2) alpha(.05) dec(2) symbol(*) append

/// Appendix Tables 7-8 South and Non-South 
probit Pres_Vote Med_Dist Med_Dist_F2 female Income age  weeklychurch Catholic Jew unionmember education_6cat dwnom1_difference inter1 inter2 policy_mood Mean_Dem_Support if year>=1971 & white_southerner==1 [pweight= vcf0010z]  , robust
outreg2 using SouthVC, auto(2) alpha(.05) dec(2) symbol(*) e(r2_p)  replace
probit Pres_Vote Med_Dist Med_Dist_F2 female Income age  weeklychurch Catholic Jew unionmember education_6cat dwnom1_difference inter1 inter2 policy_mood Mean_Dem_Support Party_Dis if year>=1971 & white_southerner==1 [pweight= vcf0010z]  , robust
outreg2 using SouthVC, auto(2) alpha(.05) dec(2) symbol(*) e(r2_p)  append
probit Pres_Vote Med_Dist Med_Dist_F2  female Income age  weeklychurch Catholic Jew unionmember education_6cat dwnom1_difference inter1 inter2 policy_mood Mean_Dem_Support if year>=1971 & white_southerner==0 & white==1 [pweight= vcf0010z]  , robust
outreg2 using SouthVC, auto(2) alpha(.05) dec(2) symbol(*) e(r2_p)  append
probit Pres_Vote Med_Dist Med_Dist_F2  female Income age  weeklychurch Catholic Jew unionmember education_6cat dwnom1_difference inter1 inter2 policy_mood Mean_Dem_Support Party_Dis if year>=1971 & white_southerner==0 & white==1 [pweight= vcf0010z]  , robust
outreg2 using SouthVC, auto(2) alpha(.05) dec(2) symbol(*) e(r2_p)  append
regress PID_7 Med_Dist Med_Dist_F2  female Income age weeklychurch Catholic Jew unionmember education_6cat dwnom1_difference inter1 inter2 policy_mood Mean_Dem_Support if year>=1971 & white_southerner==1 [pweight= vcf0010z], robust
outreg2 using South, auto(2) alpha(.05) dec(2) symbol(*) replace
regress PID_7 Med_Dist Med_Dist_F2  female Income age weeklychurch Catholic Jew unionmember education_6cat dwnom1_difference inter1 inter2 policy_mood Mean_Dem_Support Party_Dis if year>=1971 & white_southerner==1 [pweight= vcf0010z], robust
outreg2 using South, auto(2) alpha(.05) dec(2) symbol(*) append
regress PID_7 Med_Dist Med_Dist_F2  female Income age weeklychurch Catholic Jew unionmember education_6cat dwnom1_difference inter1 inter2 policy_mood Mean_Dem_Support if year>=1971 & white_southerner==0 & white==1 [pweight= vcf0010z], robust
outreg2 using South, auto(2) alpha(.05) dec(2) symbol(*) append
regress PID_7 Med_Dist Med_Dist_F2  female Income age weeklychurch Catholic Jew unionmember education_6cat dwnom1_difference inter1 inter2 policy_mood Mean_Dem_Support Party_Dis if year>=1971 & white_southerner==0 & white==1 [pweight= vcf0010z], robust
outreg2 using South, auto(2) alpha(.05) dec(2) symbol(*) append

/// Appendix Table 10--Orientations and Party Distances
regress Party_Dis Med_Dist Med_Dist_F2 [pweight= vcf0010z] if year==1972
outreg2 using Appendix5, auto(2) alpha(.05) dec(2) symbol(*) replace 
foreach year of varlist year{
local year = 1976
while `year' <= 2012{
regress Party_Dis Med_Dist Med_Dist_F2 [pweight= vcf0010z] if year==`year' 
outreg2 using Appendix5, auto(2) alpha(.05) dec(2) symbol(*) append
local year = `year' + 4
}
}

egen whitemean = wtmean(Med_Dist) if white==1, weight(vcf0010x)
egen whitemean2 = wtmean(Med_Dist_F2) if white==1, weight(vcf0010x)
egen whitemeanPP = wtmean(Party_Dis) if white==1, weight(vcf0010x)
///


/// Simulations testing how changes in polarization, perceptions of party positions, and distribution of orientations 
/// affect estimated levels of white Republican Vote choice and Partisanship    
/// The Effect of Polarization Holding White Orientations and perceived distances at their global means

clear

matrix C = (1, .124, .494 \ .124, 1, .308 \ .494, .308, 1)
corr2data Med_Dist Med_Dist_F2 Party_Dis, n(10000) means(.19 -.02 .44) sds(.96 1.02 2.44) corr(C)

gen white_southerner=0
gen female = 1
gen Income = 3
gen Latino = 0
gen Black=0
gen age = 46
gen weeklychurch=0
gen Catholic = 0
gen Jew=0
gen unionmember=0
gen education_6cat=4.23
gen dwnom1_difference= .569
gen inter1 = Med_Dist*dwnom1_difference
gen inter2 = Med_Dist_F2*dwnom1_difference
gen policy_mood = 57
gen Mean_Dem_Support=.537

local a = .569
local b = 1 

tempname Whitemean_Sim
postfile `Whitemean_Sim'  dwnom1_difference  Mean_RV Mean_PID using "Whitemean", replace
 

while `a' <= .88{
replace dwnom1_difference= `a'
replace inter1 = Med_Dist*dwnom1_difference
replace inter2 = Med_Dist_F2*dwnom1_difference

estimates use Vote_Choice
predict VC_1972_`b', pr
egen Mean_RV_`b' = mean(VC_1972_`b')

estimates use Partisanship
predict PID_`b'
egen Mean_PID_`b' = mean(PID_`b')

post `Whitemean_Sim' (dwnom1_difference)  (Mean_RV_`b') (Mean_PID_`b')

local a = `a' + .01
local b = `b' + 1 
}
postclose `Whitemean_Sim'

/// 2012 Econ, Mean Social


clear
matrix C = (1, .124, .494 \ .124, 1, .308 \ .494, .308, 1)
corr2data Med_Dist Med_Dist_F2 Party_Dis, n(10000) means(.3 -.02 .44) sds(.96 1.02 2.44) corr(C)

gen white_southerner=0
gen female = 1
gen Income = 3
gen Latino = 0
gen Black=0
gen age = 46
gen weeklychurch=0
gen Catholic = 0
gen Jew=0
gen unionmember=0
gen education_6cat=4.23
gen dwnom1_difference= .569
gen inter1 = Med_Dist*dwnom1_difference
gen inter2 = Med_Dist_F2*dwnom1_difference
gen policy_mood = 57
gen Mean_Dem_Support=.537

local a = .569
local b = 1 

tempname White_Max_Sim
postfile `White_Max_Sim'  dwnom1_difference  Mean_RV Mean_PID Mean_MD_`b'  using "White_Max_Sim", replace
 

while `a' <= .88{
replace dwnom1_difference= `a'
replace inter1 = Med_Dist*dwnom1_difference
replace inter2 = Med_Dist_F2*dwnom1_difference

estimates use Vote_Choice
predict VC_1972_`b', pr
egen Mean_RV_`b' = mean(VC_1972_`b')

estimates use Partisanship
predict PID_`b'
egen Mean_PID_`b' = mean(PID_`b')
egen Mean_MD_`b' = mean(Med_Dist)

post `White_Max_Sim' (dwnom1_difference)  (Mean_RV_`b') (Mean_PID_`b') (Mean_MD_`b')

local a = `a' + .01
local b = `b' + 1 
}
postclose `White_Max_Sim'

/// 2012 Social, Mean Econ

clear



clear
matrix C = (1, .124, .494 \ .124, 1, .308 \ .494, .308, 1)
corr2data Med_Dist Med_Dist_F2 Party_Dis, n(10000) means(.19 -.158 .41) sds(.96 1.02 2.44) corr(C)

gen white_southerner=0
gen female = 1
gen Income = 3
gen Latino = 0
gen Black=0
gen age = 46
gen weeklychurch=0
gen Catholic = 0
gen Jew=0
gen unionmember=0
gen education_6cat=4.23
gen dwnom1_difference= .569
gen inter1 = Med_Dist*dwnom1_difference
gen inter2 = Med_Dist_F2*dwnom1_difference
gen policy_mood = 57
gen Mean_Dem_Support=.537

local a = .569
local b = 1 

tempname White_Max_SocSim
postfile `White_Max_SocSim'  dwnom1_difference  Mean_RV Mean_PID using "White_Max_SocSim", replace
 

while `a' <= .88{
replace dwnom1_difference= `a'
replace inter1 = Med_Dist*dwnom1_difference
replace inter2 = Med_Dist_F2*dwnom1_difference

estimates use Vote_Choice
predict VC_1972_`b', pr
egen Mean_RV_`b' = mean(VC_1972_`b')

estimates use Partisanship
predict PID_`b'
egen Mean_PID_`b' = mean(PID_`b')

post `White_Max_SocSim' (dwnom1_difference)  (Mean_RV_`b') (Mean_PID_`b')

local a = `a' + .01
local b = `b' + 1 
}
postclose `White_Max_SocSim'

/// Orientations Shift 

clear



clear
matrix C = (1, .124, .494 \ .124, 1, .308 \ .494, .308, 1)
corr2data Med_Dist Med_Dist_F2 Party_Dis, n(10000) means(.14 -.004 .41) sds(.96 1.02 2.44) corr(C)
gen white_southerner=0
gen female = 1
gen Income = 3
gen Latino = 0
gen Black=0
gen age = 46
gen weeklychurch=0
gen Catholic = 0
gen Jew=0
gen unionmember=0
gen education_6cat=4.23
gen dwnom1_difference= .569
gen inter1 = Med_Dist*dwnom1_difference
gen inter2 = Med_Dist_F2*dwnom1_difference
gen policy_mood = 57
gen Mean_Dem_Support=.537


local a = .569
local b = 1 
local c = .005
local d = -.00465
tempname White_MaxMin
postfile `White_MaxMin'  dwnom1_difference  Mean_RV Mean_PID Mean_MD_`b' Mean_MD_F2_`b' using "White_MaxMin", replace
 

while `a' <= .88{
replace dwnom1_difference= `a'
replace Med_Dist = Med_Dist+`c'
replace Med_Dist_F2 = Med_Dist_F2+`d'
replace inter1 = Med_Dist*dwnom1_difference
replace inter2 = Med_Dist_F2*dwnom1_difference

estimates use Vote_Choice
predict VC_1972_`b', pr
egen Mean_RV_`b' = mean(VC_1972_`b')

estimates use Partisanship
predict PID_`b'
egen Mean_PID_`b' = mean(PID_`b')
egen Mean_MD_`b' = mean(Med_Dist)
egen Mean_MD_F2_`b' = mean(Med_Dist_F2)

post `White_MaxMin' (dwnom1_difference)  (Mean_RV_`b') (Mean_PID_`b') (Mean_MD_`b') (Mean_MD_F2_`b')

local a = `a' + .01
local b = `b' + 1 
}
postclose `White_MaxMin'

/// Party Distances only

clear

matrix C = (1, .124, .494 \ .124, 1, .308 \ .494, .308, 1)
corr2data Med_Dist Med_Dist_F2 Party_Dis, n(10000) means(.19 -.02 .2) sds(.96 1.02 2.44) corr(C)

gen white_southerner=0
gen female = 1
gen Income = 3
gen Latino = 0
gen Black=0
gen age = 46
gen weeklychurch=0
gen Catholic = 0
gen Jew=0
gen unionmember=0
gen education_6cat=4.23
gen dwnom1_difference= .744
gen inter1 = Med_Dist*dwnom1_difference
gen inter2 = Med_Dist_F2*dwnom1_difference
gen policy_mood = 57
gen Mean_Dem_Support=.537

local a = .569
local b = 1 
local c = .2

tempname WhitemeanPartyDis
postfile `WhitemeanPartyDis'  dwnom1_difference  Mean_RV Mean_PID Party_Dis using "WhitemeanPartyDis", replace
 

while `a' <= .88{
replace Party_Dis = `c'

estimates use Vote_Choice
predict VC_1972_`b', pr
egen Mean_RV_`b' = mean(VC_1972_`b')

estimates use Partisanship
predict PID_`b'
egen Mean_PID_`b' = mean(PID_`b')

post `WhitemeanPartyDis' (dwnom1_difference)  (Mean_RV_`b') (Mean_PID_`b') (Party_Dis)

local a = `a' + .01
local b = `b' + 1 
local c = `c' + .01575
}
postclose `WhitemeanPartyDis'


/// Estimating the Total Shift

clear
matrix C = (1, .124, .494 \ .124, 1, .308 \ .494, .308, 1)
corr2data Med_Dist Med_Dist_F2 Party_Dis, n(10000) means(.14 -.004 .2) sds(.96 1.02 2.44) corr(C)
gen white_southerner=0
gen female = 1
gen Income = 3
gen Latino = 0
gen Black=0
gen age = 46
gen weeklychurch=0
gen Catholic = 0
gen Jew=0
gen unionmember=0
gen education_6cat=4.23
gen dwnom1_difference= .569
gen inter1 = Med_Dist*dwnom1_difference
gen inter2 = Med_Dist_F2*dwnom1_difference
gen policy_mood = 57
gen Mean_Dem_Support=.537

local a = .569
local b = 1 
local c = 0
local f = 0

tempname White_Total
postfile `White_Total'  dwnom1_difference Mean_E Mean_S Mean_RV RV_UB RV_LB Mean_PID PID_UB PID_LB Party_Dis using "White_Total", replace
 

while `a' <= .88{



estimates use Vote_Choice
predict VC_total_`b', pr
predict VC_total_SE_`b', stdp
egen Mean_RV_`b' = mean(VC_total_`b')
gen Mean_RV_UB_`b' = Mean_RV_`b'+(VC_total_SE_`b'*1.96)
gen Mean_RV_LB_`b' = Mean_RV_`b'-(VC_total_SE_`b'*1.96)
egen Mean_E_`b' = mean(Med_Dist) 

estimates use Partisanship
predict PID_`b'
predict PID_total_SE_`b', stdp
egen Mean_PID_`b' = mean(PID_`b')
gen Mean_PID_UB_`b' = Mean_PID_`b'+(PID_total_SE_`b'*1.96)
gen Mean_PID_LB_`b' = Mean_PID_`b'-(PID_total_SE_`b'*1.96)
egen Mean_S_`b' = mean(Med_Dist_F2) 
egen Mean_PD_`b' = mean(Party_Dis)

post `White_Total' (dwnom1_difference) (Mean_E_`b') (Mean_S_`b') (Mean_RV_`b') (Mean_RV_UB_`b') (Mean_RV_LB_`b')  (Mean_PID_`b') (Mean_PID_UB_`b') (Mean_PID_LB_`b') (Mean_PD_`b')

local a = `a' + .01
local b = `b' + 1 
local c =  + .005 
local d = + .01575
local f =  - .00465 
replace dwnom1_difference= `a'
replace Med_Dist = Med_Dist+`c'
replace Med_Dist_F2 = Med_Dist_F2+`f'
replace inter1 = Med_Dist*dwnom1_difference
replace inter2 = Med_Dist_F2*dwnom1_difference
replace Party_Dis = Party_Dis+`d'
}
postclose `White_Total'

clear

/// Figures--Vote Choice Economic ME

use "Zingher JOP 2017.dta"

	#delimit ; 

probit Pres_Vote c.Med_Dist##c.dwnom1_difference  c.Med_Dist_F2##c.dwnom1_difference white_southerner female Income age weeklychurch Catholic Jew unionmember education_6cat  Party_Dis Mean_Dem_Support if white==1, robust ;
		sum dwnom1_difference if e(sample) ;
		local min = r(min) ;
		local max = r(max) ;
		local name = "Economic" ;
		local interval = ((`max'-`min')/10) ;
		margins, dydx(Med_Dist) at(dwnom1_difference=(`min'(`interval')`max')) predict(pr) vsquish ;

		#delimit ;
		marginsplot, xlabel(`min'(`interval')`max') recastci(rarea) recast(line) 
		ci1opts(color(gs14) fintensity(100) yaxis(2))   
		plot1opts(lwidth(.50) yaxis(2)) 
		xlabel(, format(%9.2fc)) 
		xdimension(dwnom1_difference)
		ylabel(, format(%9.2fc) axis(2))
		ytitle("Marginal Effect", axis(2))
		addplot(kdensity dwnom1_difference if e(sample), xlab(`min'(`interval')`max') xtitle(Polarization) color(gs10) lpattern(dash) yaxis(1) yscale(alt off)
		|| function y = 0.00, range(dwnom1_difference) lwidth(.25) yaxis(2)
		)
		legend(off)
		title("")
		subtitle("Vote Choice - Economic")
        name(Panel_`name', replace) 
		;
		graph save "Vote Choice - Economic", replace;
		;
	
	#delimit cr

/// Figures--Vote Choice Social ME

	#delimit ; 

probit Pres_Vote  c.Med_Dist_F2##c.dwnom1_difference c.Med_Dist##c.dwnom1_difference white_southerner female Income age weeklychurch Catholic Jew unionmember education_6cat  Party_Dis Mean_Dem_Support if white==1, robust ;
		sum dwnom1_difference if e(sample) ;
		local min = r(min) ;
		local max = r(max) ;
		local name = "Social" ;
		local interval = ((`max'-`min')/10) ;
		margins, dydx(Med_Dist_F2) at(dwnom1_difference=(`min'(`interval')`max')) predict(pr) vsquish ;

		#delimit ;
		marginsplot, xlabel(`min'(`interval')`max') recastci(rarea) recast(line) 
		ci1opts(color(gs14) fintensity(100) yaxis(2))   
		plot1opts(lwidth(.50) yaxis(2)) 
		xlabel(, format(%9.2fc)) 
		xdimension(dwnom1_difference)
		ylabel(, format(%9.2fc) axis(2))
		ytitle("Marginal Effect", axis(2))
		addplot(kdensity dwnom1_difference if e(sample), xlab(`min'(`interval')`max') xtitle(Polarization) color(gs10) lpattern(dash) yaxis(1) yscale(alt off)
		|| function y = 0.00, range(dwnom1_difference) lwidth(.25) yaxis(2)
		)
		legend(off)
		title("")
		subtitle("Vote Choice - Social")
        name(Panel_`name', replace)
		;
		graph save "Vote Choice - Social", replace;
		;
	
	#delimit cr

/// Figures--PID Economic


	#delimit ; 

regress PID_7 c.Med_Dist##c.dwnom1_difference  c.Med_Dist_F2##c.dwnom1_difference white_southerner female Income age weeklychurch Catholic Jew unionmember education_6cat  Party_Dis Mean_Dem_Support if white==1, robust ;
		sum dwnom1_difference if e(sample) ;
		local min = r(min) ;
		local max = r(max) ;
		local name = "Economic" ;
		local interval = ((`max'-`min')/10) ;
		margins, dydx(Med_Dist) at(dwnom1_difference=(`min'(`interval')`max')) vsquish ;

		#delimit ;
		marginsplot, xlabel(`min'(`interval')`max') recastci(rarea) recast(line) 
		ci1opts(color(gs14) fintensity(100) yaxis(2))   
		plot1opts(lwidth(.50) yaxis(2)) 
		xlabel(, format(%9.2fc)) 
		xdimension(dwnom1_difference)
		ylabel(, format(%9.2fc) axis(2))
		ytitle("Marginal Effect", axis(2))
		addplot(kdensity dwnom1_difference if e(sample), xlab(`min'(`interval')`max') xtitle(Polarization) color(gs10) lpattern(dash) yaxis(1) yscale(alt off) 
		|| function y = 0.00, range(dwnom1_difference) lwidth(.25) yaxis(2)
		)
		legend(off)
		title("")
		subtitle("PID - Economic")
        name(Panel_`name', replace) 
		;
		graph save "PID - Economic", replace;
		;
		
	#delimit cr

/// Figures PID--Social


	#delimit ; 

regress PID_7  c.Med_Dist_F2##c.dwnom1_difference c.Med_Dist##c.dwnom1_difference  white_southerner female Income age weeklychurch Catholic Jew unionmember education_6cat  Party_Dis Mean_Dem_Support if white==1, robust ;
		sum dwnom1_difference if e(sample) ;
		local min = r(min) ;
		local max = r(max) ;
		local name = "Social" ;
		local interval = ((`max'-`min')/10) ;
		margins, dydx(Med_Dist_F2) at(dwnom1_difference=(`min'(`interval')`max')) vsquish ;

		#delimit ;
		marginsplot, xlabel(`min'(`interval')`max') recastci(rarea) recast(line) 
		ci1opts(color(gs14) fintensity(100) yaxis(2))   
		plot1opts(lwidth(.50) yaxis(2)) 
		xlabel(, format(%9.2fc)) 
		xdimension(dwnom1_difference)
		ylabel(, format(%9.2fc) axis(2))
		ytitle("Marginal Effect", axis(2))
		addplot(kdensity dwnom1_difference if e(sample), xlab(`min'(`interval')`max') xtitle(Polarization) color(gs10) lpattern(dash) yaxis(1) yscale(alt off)
		|| function y = 0.00, range(dwnom1_difference) lwidth(.25) yaxis(2)
		)
		legend(off)
		title("")
		subtitle("PID - Social")
        name(Panel_`name', replace) 
		;
		graph save "PID - Social", replace;
		;

		#delimit cr
		
			#delimit ; 

/// Figures IMP--PID

			
regress PID_7 c.IMP_Score##c.dwnom1_difference c.Med_Dist_F2##c.dwnom1_difference c.Med_Dist##c.dwnom1_difference  white_southerner female Income age weeklychurch Catholic Jew unionmember education_6cat policy_mood Party_Dis Mean_Dem_Support if white==1, robust ;
		sum dwnom1_difference if e(sample) ;
		local min = r(min) ;
		local max = r(max) ;
		local name = "Social" ;
		local interval = ((`max'-`min')/10)  ;
		margins, dydx(IMP_Score) at(dwnom1_difference=(`min'(`interval')`max')) vsquish ;

		#delimit ;
		marginsplot, xlabel(.62(`interval')1.10) recastci(rarea) recast(line) 
		ci1opts(color(gs14) fintensity(100) yaxis(2))   
		plot1opts(lwidth(.50) yaxis(2)) 
		xlabel(, format(%9.2fc)) 
		xdimension(dwnom1_difference)
		ylabel(, format(%9.2fc) axis(2))
		ytitle("Marginal Effect", axis(2))
		addplot(kdensity dwnom1_difference if e(sample), xlab(`min'(`interval')`max') xtitle(Polarization) color(gs10) lpattern(dash) yaxis(1) yscale(alt off)
		|| function y = 0.00, range(.62 1.09) lwidth(.25) yaxis(2)
		)
		legend(off)
		title("")
		subtitle("PID - Implicit Racism")
        name(Panel_`name', replace) 
		;
		graph save "IMP PID", replace;
		;

		#delimit cr
		
/// Figures IMP--Vote Choice

		#delimit ; 
		
probit Pres_Vote c.IMP_Score##c.dwnom1_difference c.Med_Dist_F2##c.dwnom1_difference c.Med_Dist##c.dwnom1_difference  white_southerner female Income age weeklychurch Catholic Jew unionmember education_6cat policy_mood Party_Dis Mean_Dem_Support if white==1 & IMP_Score~=., robust ;
		sum dwnom1_difference if e(sample) ;
		local min = r(min) ;
		local max = r(max) ;
		local interval = ((`max'-`min')/10)  ;
		margins, dydx(IMP_Score) at(dwnom1_difference=(`min'(`interval')`max')) vsquish ;

		#delimit ;
		marginsplot, xlabel(`min'(`interval')`max') recastci(rarea) recast(line) 
		ci1opts(color(gs14) fintensity(100) yaxis(2))   
		plot1opts(lwidth(.50) yaxis(2)) 
		xlabel(, format(%9.2fc)) 
		xdimension(dwnom1_difference)
		ylabel(, format(%9.2fc) axis(2))
		ytitle("Marginal Effect", axis(2))
		addplot(kdensity dwnom1_difference if e(sample), xlab(`min'(`interval')`max') xtitle(Polarization) color(gs10) lpattern(dash) yaxis(1) yscale(alt off)
		|| function y = 0.00, range(.62 1.09) lwidth(.25) yaxis(2)
		)
		legend(off)
		title("")
		subtitle("Vote Choice - Implicit Racism")
		;
		graph save "IMP Vote Choice", replace;
		;

		#delimit cr
		

///Figures

/// Main Text Figure 1
twoway connected dwnom1_rmean year, mstyle(none) lcolor(red)  legend(cols(2) label(1 "Republican") label(2 "Democratic")) xtitle(Year) xlabel(1972(8)2012) ytitle(Mean Scores) title(DW-NOMINATE Party Means) || connected dwnom1_dmean year, mstyle(none) lcolor(blue) lpattern(dash)  
graph save "Party Means", replace
graph export "Party Means.pdf", replace 
twoway connected White_Rep_Dist year, mstyle(none) lcolor(red) || connected White_Dem_Dist year, xtitle(Year) ytitle(Average Distance from Mean) title(White Citizens Only) xlabel(1972(8)2012) mstyle(none) lcolor(blue) lpattern(dash) legend(cols(2) label(1 "Republican") label(2 "Democratic"))
graph save "White Party Distances", replace 
graph export "White Party Distances.pdf", replace 
twoway connected Mean_RPres_Pl year, mstyle(none) lcolor(red) || connected Mean_DPres_Pl year, xtitle(Year) ytitle(Average Placement) title(All Citizens) xlabel(1972(8)2012) ylabel(2.5(1)5.5) mstyle(none) lcolor(blue) lpattern(dash) legend(cols(2) label(1 "Republican") label(2 "Democratic") label(3 "Mean Citizen")) || connected Mean_Pl year, mstyle(none)
graph save "Overall Party Placements", replace 
graph export "Overall Party Placements.pdf", replace 
graph combine "Overall Party Placements" "Non White Proportion" "White Party Distances" "Party Means", xsize(8) ysize(5.5)
graph export "Party Placements Figure 1.pdf", replace
		
/// Main Text Figure 2		
graph combine "Vote Choice - Economic" "Vote Choice - Social" "PID - Economic" "PID - Social", xsize(6.5) 
graph export "Marginal Effects.pdf", replace

/// Main Text Figure 3
twoway scatter whitedist year, xtitle(year) xlabel(1972(8)2012) ylabel(-.2(.1).4) ytitle(Distance from the Overall Median) legend(off) title(Economic) || lfit whitedist year
graph save "White Distance Econ", replace 
twoway scatter whitedist2 year, xtitle(year) xlabel(1972(8)2012) ylabel(-.2(.1).4) ytitle(Distance from the Overall Median) legend(off) title(Social) || lfit whitedist2 year
graph save "White Distance Social", replace 
graph combine "White Distance Econ" "White Distance Social", xsize(6)
graph export "White Distances.pdf", replace 


/// Appendix Figure A3
graph combine "IMP Vote Choice" "IMP PID", xsize(6.5) 
graph export "Marginal Effects IMP.pdf", replace




