* This Stata Do File generates all the results in Bell, Fasani and Machin "Crime and Immigration: Evidence from Large Immigrant Waves"
* The associated data set is crime_immig.dta

use "crime_immig.dta", clear

sort la_code year
egen panel_id = group(la_code)
sort panel_id year
tsset panel_id year

* generate cumulative WRS data

replace wrs=0 if wrs==. 
gen wrscum=0 
replace wrscum=wrs if year==2004
by panel_id: replace wrscum=wrscum[_n-1]+wrs if year>2004

egen pfid = group(pfa_name)

* generate regression variables

gen adult_pop = totalpop-pop014
gen asylum_pop = ((dispsMF+subsMF)/adult_pop)
gen asylum_dispersal_pop = (dispsMF/adult_pop)
gen asylum_pop_males = ((dispsM+subsM)/adult_pop)
gen asylum_pop_females = asylum_pop-asylum_pop_males
gen asylum_disp_males = (dispsM/adult_pop)
gen asylum_disp_females = ((dispsMF-dispsM)/adult_pop)
gen a8_pop = (wrscum/adult_pop)
gen young_share = (pop1524/adult_pop)
gen benefit_claimants = benclaim/adult_pop
gen lnpop = ln(adult_pop)
gen a8_iv = SP_A8/adult_pop

gen viol_crime_rate = viol/adult_pop
gen prop_crime = burg+rob+tomv+tfmv
gen prop_crime_rate = prop_crime/adult_pop
gen total_crime_rate = (viol+prop_crime)/adult_pop

sort panel_id year
by panel_id: egen avg_adult_pop = mean(adult_pop)
gen trend = year-2001

drop if year<2002

* Table 2: Panel Regressions for Immigrant Waves

regress D.(viol_crime_rate asylum_pop a8_pop) i.year [aw=adult_pop], vce(cluster panel_id)
test D.asylum_pop=D.a8_pop
regress D.(viol_crime_rate asylum_pop a8_pop lnpop benefit_claimants young_share) i.year [aw=adult_pop], vce(cluster panel_id)
test D.asylum_pop=D.a8_pop
areg D.(viol_crime_rate asylum_pop a8_pop lnpop benefit_claimants young_share) i.year [aw=adult_pop], absorb(pfa_name) vce(cluster panel_id)
test D.asylum_pop=D.a8_pop
regress D.(prop_crime_rate asylum_pop a8_pop) i.year [aw=adult_pop], vce(cluster panel_id)
test D.asylum_pop=D.a8_pop
regress D.(prop_crime_rate asylum_pop a8_pop lnpop benefit_claimants young_share) i.year [aw=adult_pop], vce(cluster panel_id)
test D.asylum_pop=D.a8_pop
areg D.(prop_crime_rate asylum_pop a8_pop lnpop benefit_claimants young_share) i.year [aw=adult_pop], absorb(pfa_name) vce(cluster panel_id)
test D.asylum_pop=D.a8_pop

* Table A1: Fixed-Effect Panel Regressions for Immigrant Waves

xtreg viol_crime_rate asylum_pop a8_pop i.year [aw=avg_adult_pop], fe vce(cluster panel_id)
test asylum_pop=a8_pop
xtreg viol_crime_rate asylum_pop a8_pop lnpop benefit_claimants young_share i.year [aw=avg_adult_pop], fe vce(cluster panel_id)
test asylum_pop=a8_pop
xtreg viol_crime_rate asylum_pop a8_pop lnpop benefit_claimants young_share i.year i.pfid#c.trend [aw=avg_adult_pop], fe vce(cluster panel_id)
test asylum_pop=a8_pop
xtreg prop_crime_rate asylum_pop a8_pop i.year [aw=avg_adult_pop], fe vce(cluster panel_id)
test asylum_pop=a8_pop
xtreg prop_crime_rate asylum_pop a8_pop lnpop benefit_claimants young_share i.year [aw=avg_adult_pop], fe vce(cluster panel_id)
test asylum_pop=a8_pop
xtreg prop_crime_rate asylum_pop a8_pop lnpop benefit_claimants young_share i.year i.pfid#c.trend [aw=avg_adult_pop], fe vce(cluster panel_id)
test asylum_pop=a8_pop

* Table 4: IV Panel Regressions for Immigrant Waves (and Table A2: IV First Stage Regressions)

gen D_asylum_pop=D.asylum_pop
gen D_asylum_dispersal_pop=D.asylum_dispersal_pop

ivregress 2sls D.(viol_crime_rate lnpop benefit_claimants young_share) i.year (D_asylum_pop=D_asylum_dispersal_pop) [aw=adult_pop], vce(cluster panel_id) first
estat firststage
ivregress 2sls D.(prop_crime_rate lnpop benefit_claimants young_share) i.year (D_asylum_pop=D_asylum_dispersal_pop) [aw=adult_pop], vce(cluster panel_id) 
ivregress 2sls D.(prop_crime_rate lnpop benefit_claimants young_share) i.year i.pfid (D_asylum_pop=D_asylum_dispersal_pop) [aw=adult_pop], vce(cluster panel_id) first
estat firststage

gen D_a8_pop=D.a8_pop

ivregress 2sls D.(viol_crime_rate lnpop benefit_claimants young_share) i.year (D_a8_pop=a8_iv) [aw=adult_pop] if year>2004, vce(cluster panel_id) first
estat firststage
ivregress 2sls D.(prop_crime_rate lnpop benefit_claimants young_share) i.year (D_a8_pop=a8_iv) [aw=adult_pop] if year>2004, vce(cluster panel_id) 
ivregress 2sls D.(prop_crime_rate lnpop benefit_claimants young_share) i.year i.pfid (D_a8_pop=a8_iv) [aw=adult_pop] if year>2004, vce(cluster panel_id) first
estat firststage

* Table 5: OLS and IV Panel Regressions for Male and Female Asylum Wave (and Table A2: IV First Stage Regressions)

areg D.(viol_crime_rate asylum_pop_females lnpop benefit_claimants young_share) i.year [aw=adult_pop], absorb(pfa_name) vce(cluster panel_id)
areg D.(viol_crime_rate asylum_pop_males lnpop benefit_claimants young_share) i.year [aw=adult_pop], absorb(pfa_name) vce(cluster panel_id)
areg D.(prop_crime_rate asylum_pop_females lnpop benefit_claimants young_share) i.year [aw=adult_pop], absorb(pfa_name) vce(cluster panel_id)
areg D.(prop_crime_rate asylum_pop_males lnpop benefit_claimants young_share) i.year [aw=adult_pop], absorb(pfa_name) vce(cluster panel_id)

gen D_asylum_pop_females = D.asylum_pop_females
gen D_asylum_disp_females = D.asylum_disp_females
gen D_asylum_pop_males = D.asylum_pop_males
gen D_asylum_disp_males = D.asylum_disp_males

ivregress 2sls D.(viol_crime_rate lnpop benefit_claimants young_share) i.year i.pfid (D_asylum_pop_females=D_asylum_disp_females) [aw=adult_pop], vce(cluster panel_id) first
estat firststage
ivregress 2sls D.(viol_crime_rate lnpop benefit_claimants young_share) i.year i.pfid (D_asylum_pop_males=D_asylum_disp_males) [aw=adult_pop], vce(cluster panel_id) first
estat firststage
ivregress 2sls D.(prop_crime_rate lnpop benefit_claimants young_share) i.year i.pfid (D_asylum_pop_females=D_asylum_disp_females) [aw=adult_pop], vce(cluster panel_id)
ivregress 2sls D.(prop_crime_rate lnpop benefit_claimants young_share) i.year i.pfid (D_asylum_pop_males=D_asylum_disp_males) [aw=adult_pop], vce(cluster panel_id)


clear

* Data for Table 6 comes from Freedom of Information Requests to Individual Police Forces in England and Wales.
* The data file is police_arrests.dta

use "police_arrests.dta", clear

gen a8_pop_wrs= wrscum/adultpop
gen a8_arrest_share = a8_arrests/total_arrests if total_arrests>0 & a8_arrests>0
gen a8_property_share = (a8_arrests-a8_violent)/(total_arrests-total_violent) if a8_violent>0 & total_violent>0 & a8_arrests>0 & total_arrests>0

regress a8_arrest_share a8_pop_wrs, vce(cluster pfa_code)
regress a8_property_share a8_pop_wrs , vce(cluster pfa_code)
regress a8_arrest_share a8_pop_wrs if quality==1, vce(cluster pfa_code)
regress a8_property_share a8_pop_wrs if quality==1, vce(cluster pfa_code)


* Data for Tables 8 and 9 come from the British Crime Survey and the National Evaluation of the New Deal for Communities Survey. 
* This data is available upon application to the ESRC Data Archive (http://www.data-archive.ac.uk/). 
* The script below provides stata code for estimating the Table 9 probits with this data.

* Table 9: Victimization Equations, Pr(Crime Victim in Last Year)

* New Deal Evaluation Regressions (Table 9 - Columns 3-6)

use "main_ndc2002.dta"
gen cr4tot = cr4_a+cr4_b+cr4_c+cr4_d+cr4_e+cr4_f+cr4_g
gen cr4sum = 1
replace cr4sum=0 if cr4tot==14
gen year=2002
recode region (1=2) (2=3) (3=4) (4=6) (6=7) (7=8) (8=9) (9=1)
keep hrp_num re1 hd7 waggfull sex_p1 age_p1 wo1p1_a wo1p1_f wo1p1_g fi2 fi3 hd9 compos ved1a cr4sum region tenure vho6 hd1 he3 fi6 vwork1 ndcarea year
append using "main_ndc2004.dta", keep(hrp_num re1 hd7 waggfull sex_p1 age_p1 wo1p1_a wo1p1_f wo1p1_g fi2 fi3 hd9 compos ved1a cr4sum region tenure vho6 hd1 he3 fi6 vwork1 ndcarea)
replace year=2004 if year==.
* keep only HoH respondents
keep if hrp_num==1
* code immig = 0 for british, 1 for non-british asylum, 2 for non-british non-asylum
gen immig=0
replace immig=1 if re1==1
replace immig=2 if re1==2 & hd7>1
rename waggfull weight
gen asylum=0
replace asylum=1 if immig==1
gen nonasylum=0
replace nonasylum=1 if immig==2

gen sex=sex_p1
drop if age_p1<18
drop if age_p1>65
gen employed=0
replace employed=1 if wo1p1_a==1
gen unemp=0
replace unemp=1 if wo1p1_f==1
replace unemp=1 if wo1p1_g==1
gen annwage=.
replace annwage=fi2 if fi3==1
replace annwage=fi2*12 if fi3==12
replace annwage=fi2*13 if fi3==13
replace annwage=fi2*26 if fi3==26
replace annwage=fi2*52 if fi3==52
replace annwage=fi2*365 if fi3==365
gen poor_english=0
replace poor_english=1 if hd9==3 | hd9==4

gen victim=0
replace victim=1 if cr4sum==1
quietly tab ved1a, gen(educ)
gen male=0
replace male=1 if sex_p1==1
quietly tab region, gen(reg)
quietly tab tenure, gen(hhtenure)
quietly tab vho6, gen(timeaddress)
recode hd1 (6/16=6)
quietly tab hd1, gen(hhsize)
gen asian=0
gen black=0
replace asian=1 if hd7==8 | hd7==9 | hd7==10 | hd7==11
replace black=1 if hd7==12 | hd7==13 | hd7==14
quietly tab compos, gen(hhstructure)
gen illness=0
replace illness=1 if he3==1
quietly tab fi6, gen(hhincome)
gen worklesshh=0
replace worklesshh=1 if vwork1==1
gen pfa=ndcarea
recode pfa (11=1) (12=2) (13=3) (14=4) (15=5) (16=6) (17/22=7) (23=8) (24=9) (25=10) (26=11) (27 29=12) (28=13) (30 31=14) (32/35=15) (36/37=16) (38/39=17) (41/50=18)
quietly tab pfa, gen(police)


probit victim asylum nonasylum
probit victim asylum nonasylum educ1-educ5 male age_p1 reg1-reg8 hhtenure1 hhtenure2 timeaddress1-timeaddress5 hhsize1-hhsize4 asian black hhstructure1-hhstructure4 hhincome1-hhincome8 worklesshh unemp employed poor_english
probit victim asylum nonasylum educ1-educ5 male age_p1 reg1-reg8 hhtenure1 hhtenure2 timeaddress1-timeaddress5 hhsize1-hhsize4 asian black hhstructure1-hhstructure4 hhincome1-hhincome8 worklesshh unemp employed poor_english police1-police17

