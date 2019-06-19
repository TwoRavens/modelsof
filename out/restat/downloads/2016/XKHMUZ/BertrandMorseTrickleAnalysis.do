********************************
* BERTRAND AND MORSE, REVEIW OF ECONOMICS & STATISTICS 
*"TRICKLE-DOWN CONSUMPTION"
*TABLES 1, 2, 5, 6, 7, APPENDIX TABLES 2,3,4,5,8,11
********************************

*
clear
set more off

use  BertrandMorseTrickleCEXData,
macro define controls "age_ref agesq i.sex_ref dracenew* i.educ1  num_child_i* num_adult_i*  "

*******************************************************************
*TABLE 1
*******************************************************************

xi:areg lntotexp lnma3_p80 $controls i.year i.state [aw=weight] if  ave_inc<p80,a(inc_bucket) cluster(state)
outreg lnma3_p80 using T1.txt,  bdec(3) se br replace

xi:areg lntotexp lnma3_p90 $controls i.year i.state [aw=weight] if  ave_inc<p80,a(inc_bucket) cluster(state)
outreg lnma3_p90 using T1.txt,  bdec(3) se br append

xi:areg lntotexp lnma3_p80 $controls i.year i.state*year [aw=weight] if ave_inc<p80,a(inc_bucket) cluster(state)
outreg lnma3_p80  using T1.txt,  bdec(3) se br append

xi:areg lntotexp lnma3_p80 $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80,a(inc_bucket) cluster(state)
outreg lnma3_p80  unemployed using T1.txt,  bdec(3) se br append

xi:areg lntotexp lnma3_p80 unemployed $controls  i.state*year  $controls i.year  [aw=weight] if  ave_inc<p60 ,a(inc_bucket) cluster(state)
outreg lnma3_p80  unemployed using T1.txt,  bdec(3) se br append ctitle("<P60")

xi:areg lntotexp lnma3_p80 lnma3_p50 lnma3_p20 unemployed $controls i.year i.state*year  [aw=weight] if ave_inc<p80,a(inc_bucket) cluster(state)
outreg lnma3_p80 lnma3_p50 lnma3_p20 unemployed using T1.txt,  bdec(3) se br append

xi:areg lntotexp lnma3_p80_samplep0p40 lnma3_p80_samplep40p80 lnma3_p50_samplep0p40 lnma3_p50_samplep40p80  lnma3_p20_samplep0p40 lnma3_p20_samplep40p80  $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80 ,a(inc_bucket) cluster(state)
outreg lnma3_p80_samplep0p40 lnma3_p80_samplep40p80 lnma3_p50_samplep0p40 lnma3_p50_samplep40p80  lnma3_p20_samplep0p40 lnma3_p20_samplep40p80 unemployed  using T1.txt, bd(3) se br append

xi:areg lntotexp lnma3_p50 lnma3_p20 unemployed $controls i.year i.state*year [aw=weight] if ave_inc>=p80,a(inc_bucket) cluster(state)
outreg  lnma3_p50 lnma3_p20 unemployed using T1.txt,  bdec(3) se br append

***********************************************
*INTERNET APPENDIX TABLE A5:
***********************************************

xi:areg rat_totexp lnma3_p80 $controls i.year i.state [aw=weight] if  ave_inc<p80,a(inc_bucket) cluster(state)
outreg lnma3_p80 using A5.txt,  bdec(3) se br replace

xi:areg rat_totexp lnma3_p90 $controls i.year i.state [aw=weight] if  ave_inc<p80,a(inc_bucket) cluster(state)
outreg lnma3_p90 using A5.txt,  bdec(3) se br append

xi:areg rat_totexp lnma3_p80 $controls i.year i.state*year [aw=weight] if ave_inc<p80,a(inc_bucket) cluster(state)
outreg lnma3_p80  using A5.txt,  bdec(3) se br append

xi:areg rat_totexp lnma3_p80 $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80,a(inc_bucket) cluster(state)
outreg lnma3_p80  unemployed using A5.txt,  bdec(3) se br append

xi:areg rat_totexp lnma3_p80 unemployed $controls  i.state*year  $controls i.year  [aw=weight] if  ave_inc<p60 ,a(inc_bucket) cluster(state)
outreg lnma3_p80  unemployed using A5.txt,  bdec(3) se br append ctitle("<P60")

xi:areg rat_totexp lnma3_p80 lnma3_p50 lnma3_p20 unemployed $controls i.year i.state*year  [aw=weight] if ave_inc<p80,a(inc_bucket) cluster(state)
outreg lnma3_p80 lnma3_p50 lnma3_p20 unemployed using A5.txt,  bdec(3) se br append

xi:areg rat_totexp lnma3_p80_samplep0p40 lnma3_p80_samplep40p80 lnma3_p50_samplep0p40 lnma3_p50_samplep40p80  lnma3_p20_samplep0p40 lnma3_p20_samplep40p80  $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80 ,a(inc_bucket) cluster(state)
outreg lnma3_p80_samplep0p40 lnma3_p80_samplep40p80 lnma3_p50_samplep0p40 lnma3_p50_samplep40p80  lnma3_p20_samplep0p40 lnma3_p20_samplep40p80 unemployed using A5.txt, bd(3) se br append

xi:areg rat_totexp lnma3_p50 lnma3_p20 unemployed $controls i.year i.state*year [aw=weight] if ave_inc>=p80,a(inc_bucket) cluster(state)
outreg  lnma3_p50 lnma3_p20 unemployed using A5.txt,  bdec(3) se br append


*************************************
* TABLE 2: IV REGRESSIONS 
*************************************
*Panel A INCOME MA3 Instrument

*80
*first stage outputting
xi:reg lnma3_totexp_80100  lnma3_p80  lnma3_p95  unemployed $controls  i.inc_bucket i.state*year  if ave_in<p80 [aweight = weight],cluster(state)
test lnma3_p80 lnma3_p95
outreg lnma3_p80 lnma3_p95 unemployed using T2.txt, bdec(3) se br replace 
*log consumption
xi:ivregress liml lntotexp (lnma3_totexp_80100 = lnma3_p80 lnma3_p95  )  $controls i.year i.inc_bucket i.state*year unemployed   if   ave_in<p80 [aweight = weight], first cluster(state)
outreg lnma3_totexp_80100 unemployed  using T2.txt, bdec(3) se br append
*ratio of consumption to income
xi:ivregress liml rat_totexp (lnma3_totexp_80100 = lnma3_p80  lnma3_p95 )  $controls i.year i.inc_bucket i.state*year unemployed  if   ave_in<p80  [aweight = weight], first cluster(state)
outreg lnma3_totexp_80100 unemployed  using T2.txt, bdec(3) se br append


*90
*first stage outputting
xi:reg lnma3_totexp_90100   lnma3_p95  unemployed $controls i.year i.inc_bucket i.state*year  if ave_in<p80 [aweight = weight],cluster(state)
test  lnma3_p95
outreg unemployed  lnma3_p95 using T2.txt, bdec(3) se br append
*log consumption
xi:ivregress liml lntotexp (lnma3_totexp_90100 =  lnma3_p95  )  $controls i.year i.inc_bucket i.state*year unemployed  if   ave_in<p80 [aweight = weight], first cluster(state)
outreg lnma3_totexp_90100 unemployed  using T2.txt,bdec(3) se br append 
*ratio of consumption to income
xi:ivregress liml rat_totexp (lnma3_totexp_90100 =  lnma3_p95 )  $controls i.year i.inc_bucket i.state*year unemployed  if   ave_in<p80 [aweight = weight], first cluster(state)
outreg lnma3_totexp_90100 unemployed   using T2.txt,bdec(3) se br append  


*********SHOW OLS BOTTOM OF TABLE

xi:areg lntotexp lnma3_totexp_80100 $controls i.year i.state*year unemployed [aw=weight] if  ave_inc<p80,a(inc_bucket) cluster(state)
outreg lnma3_totexp_80100 unemployed using T2.txt,  bdec(3) se br append

xi:areg rat_totexp lnma3_totexp_80100 $controls i.year i.state*year unemployed [aw=weight] if  ave_inc<p80,a(inc_bucket) cluster(state)
outreg lnma3_totexp_80100 unemployed  using T2.txt,  bdec(3) se br append

xi:areg lntotexp lnma3_totexp_90100 $controls i.year i.state*year unemployed [aw=weight] if  ave_inc<p80,a(inc_bucket) cluster(state)
outreg lnma3_totexp_90100 unemployed using T2.txt,  bdec(3) se br append


xi:areg rat_totexp lnma3_totexp_90100 $controls i.year i.state*year unemployed [aw=weight] if  ave_inc<p80,a(inc_bucket) cluster(state)
outreg lnma3_totexp_90100 unemployed using T2.txt,  bdec(3) se br append


********************************
*TABLE 5: HOME EQUITY CHANNEL
********************************

gen saiz_nationalhousecpi=saiz_elasticity*national_house_cpi
gen own=housing<4
replace own=. if housingtype==.
gen pre95lnma3_p80=(year<=1995)*lnma3_p80
gen pre95lnma3_p90=(year<=1995)*lnma3_p90


*FOLLOW METHODOLOGY IN DETTLING AND KEARNEY, as well as Gleaser, and Chetty and Szeidl

*nominal median house price by state and year
gen house_value=median_housevalue_2000*(1+state_index)
replace house_value=house_value/100000
*real median house price by state (99 $)
replace house_value=house_value*def99



*Panel A
xi:areg lntotexp  lnma3_p80   $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80 & own==1,a(inc_bucket) cluster(state)
outreg lnma3_p80 using T5.txt,  bdec(6) se br replace
xi:areg lntotexp  lnma3_p80   $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80 & own==0,a(inc_bucket) cluster(state)
outreg lnma3_p80   using T5.txt,  bdec(6) se br append
xi:areg lntotexp lnma3_p80 pre95lnma3_p80  $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80 & own==1,a(inc_bucket) cluster(state)
outreg lnma3_p80 pre95lnma3_p80  using T5.txt,  bdec(6) se br append
xi:ivregress liml lntotexp lnma3_p80   (house_value  =  saiz_nationalhousecpi )  $controls i.year i.inc_bucket i.state*year unemployed  if  ave_in<p80 [aweight = weight], first cluster(state)
outreg lnma3_p80  house_value   using T5.txt,  bdec(6) se br append ctitle("iv")
xi:ivregress liml lntotexp lnma3_p80  (house_value  =  saiz_nationalhousecpi)  $controls i.year i.inc_bucket i.state*year unemployed  if  ave_in<p80 & own==1 [aweight = weight], first cluster(state)
outreg lnma3_p80  house_value   using T5.txt,  bdec(6) se br append ctitle("iv")


*Panel B
xi:areg lntotexp  lnma3_p90   $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80 & own==1,a(inc_bucket) cluster(state)
outreg lnma3_p90   using T5.txt,  bdec(6) se br append
xi:areg lntotexp  lnma3_p90   $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80 & own==0,a(inc_bucket) cluster(state)
outreg lnma3_p90   lnma3_p90 using T5.txt,  bdec(6) se br append
xi:areg lntotexp lnma3_p90 pre95lnma3_p90  $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80 & own==1,a(inc_bucket) cluster(state)
outreg lnma3_p90  pre95lnma3_p90   using T5.txt,  bdec(6) se br append
xi:ivregress liml lntotexp lnma3_p90 (house_value  =  saiz_nationalhousecpi)  $controls i.year i.inc_bucket i.state*year unemployed  if  ave_in<p80 [aweight = weight], first cluster(state)
outreg lnma3_p90 house_value  using T5.txt,  bdec(6) se br append ctitle("iv")
xi:ivregress liml lntotexp lnma3_p90  (house_value  =  saiz_nationalhousecpi )  $controls i.year i.inc_bucket i.state*year unemployed  if  ave_in<p80 & own==1 [aweight = weight], first cluster(state)
outreg lnma3_p90  house_value   using T5.txt,  bdec(6) se br append ctitle("iv")


********************************************
*TABLE 6: Local Price Effects 
*************************************************************
gen logcpi=log(indexcpi_all)
egen tagsty=tag(state year)

*local CPIs
foreach v in food apparel hous  trans medical{
gen lnnewcpi_`v'=ln(newcpi_`v')
}

tab state,gen(dstate)
forval num=1/24{
gen dstate`num'year=dstate`num'*year
}

xi:reg  logcpi lnma3_p80 lnma3_p50 lnma3_p20 i.state i.year unemployed if tagsty==1
outreg lnma3_p80 lnma3_p50 lnma3_p20 unemployed using t6.TXT,  bdec(3) se br replace
xi:reg  logcpi lnma3_p90 lnma3_p50 lnma3_p20 i.state  unemployed i.year  if tagsty==1
outreg lnma3_p90 lnma3_p50 lnma3_p20 unemployed using t6.TXT,  bdec(3) se br append 

xi:areg lntotexp lnma3_p80  logcpi  $controls i.year  unemployed i.state*year [aw=weight] if  ave_inc<p80 , a(inc_bucket) cluster(state)
outreg lnma3_p80   logcpi unemployed  using t6.TXT, bdec(3) se br append ctitle("cpi all")  
xi:areg lntotexp lnma3_p90  logcpi $controls i.year  unemployed  i.state*year [aw=weight] if  ave_inc<p80 , a(inc_bucket) cluster(state)
outreg lnma3_p90  logcpi unemployed using t6.TXT, bdec(3) se br append ctitle("cpi all")  

xi:areg lntotexp lnma3_p80  lnnewcpi_*  $controls i.year  unemployed i.state*year [aw=weight] if  ave_inc<p80 , a(inc_bucket) cluster(state)
outreg lnma3_p80   lnnewcpi_food lnnewcpi_apparel lnnewcpi_hous lnnewcpi_trans lnnewcpi_medical unemployed  using t6.TXT, bdec(3) se br append ctitle("cpi all")  
xi:areg lntotexp lnma3_p90  lnnewcpi_* $controls i.year  unemployed  i.state*year [aw=weight] if  ave_inc<p80 , a(inc_bucket) cluster(state)
outreg lnma3_p90  lnnewcpi_food lnnewcpi_apparel lnnewcpi_hous lnnewcpi_trans lnnewcpi_medical unemployed using t6.TXT, bdec(3) se br append ctitle("cpi all")  

*80p iv
xi:ivregress liml lntotexp   logcpi (lnma3_totexp_80100 = lnma3_p80 lnma3_p95  )  $controls i.year i.inc_bucket dstate*year unemployed   if   ave_in<p80 [aweight = weight], first cluster(state)
outreg lnma3_totexp_80100   logcpi unemployed using t6.TXT, bdec(3) se br append
*90 p IV
xi:ivregress liml lntotexp   logcpi (lnma3_totexp_90100 =  lnma3_p95  )  $controls i.year i.inc_bucket dstate*year unemployed  if   ave_in<p80 [aweight = weight], first cluster(state)
outreg lnma3_totexp_90100   logcpi unemployed using t6.TXT,bdec(3) se br append 

*80p iv
xi:ivregress liml lntotexp   lnnewcpi_food lnnewcpi_apparel lnnewcpi_hous lnnewcpi_trans lnnewcpi_medical (lnma3_totexp_80100 = lnma3_p80 lnma3_p95  )  $controls i.year i.inc_bucket dstate*year unemployed   if   ave_in<p80 [aweight = weight], first cluster(state)
outreg lnma3_totexp_80100  lnnewcpi_food lnnewcpi_apparel lnnewcpi_hous lnnewcpi_trans lnnewcpi_medical  unemployed using t6.TXT, bdec(3) se br append
*90 p IV
xi:ivregress liml lntotexp  lnnewcpi_food lnnewcpi_apparel lnnewcpi_hous lnnewcpi_trans lnnewcpi_medical (lnma3_totexp_90100 =  lnma3_p95  )  $controls i.year i.inc_bucket dstate*year unemployed  if   ave_in<p80 [aweight = weight], first cluster(state)
outreg lnma3_totexp_90100  lnnewcpi_food lnnewcpi_apparel lnnewcpi_hous lnnewcpi_trans lnnewcpi_medical  unemployed using t6.TXT,bdec(3) se br append 


*************************************
*INTERNET APPENDIX TABLE A2
************************************
*PANEL A:

sum ave_inc99 age_ref male_ref white_ref collegeormore num_adult num_child lntotexp lnma3_totexp_80100 lnma3_totexp_90100 lnma3_p80 lnma3_p90 lnma3_p95 lnma3_p50 lnma3_p20 if ave_inc<p80 [aw=weight]


*PANEL B:

gen yeargroup=.

replace yeargroup=1 if year>=1980 & year<=1984
replace yeargroup=2 if year>=1985 & year<=1989
replace yeargroup=3 if year>=1990 & year<=1994
replace yeargroup=4 if year>=1995 & year<=1999
replace yeargroup=5 if year>=2000 & year<=2004
replace yeargroup=6 if year>=2005 & year<=2007

tabstat lnma3_totexp_4060 lnma3_totexp_80100 lnma3_totexp_90100 lnma3_p80 lnma3_p90 lnma3_p95 lnma3_p50 lnma3_p20 if  ave_inc<p80 [aw=weight], col(var) by(yeargroup)

sum lnma3_totexp_80100 lnma3_totexp_90100 lnma3_p80 lnma3_p90 lnma3_p95 lnma3_p50 lnma3_p20 if yeargroup==1 & ave_inc<p80 [aw=weight]
sum lnma3_totexp_80100 lnma3_totexp_90100 lnma3_p80 lnma3_p90 lnma3_p95 lnma3_p50 lnma3_p20 if yeargroup==2 & ave_inc<p80 [aw=weight]
sum lnma3_totexp_80100 lnma3_totexp_90100 lnma3_p80 lnma3_p90 lnma3_p95 lnma3_p50 lnma3_p20 if yeargroup==3 & ave_inc<p80 [aw=weight]
sum lnma3_totexp_80100 lnma3_totexp_90100 lnma3_p80 lnma3_p90 lnma3_p95 lnma3_p50 lnma3_p20 if yeargroup==4 & ave_inc<p80 [aw=weight]
sum lnma3_totexp_80100 lnma3_totexp_90100 lnma3_p80 lnma3_p90 lnma3_p95 lnma3_p50 lnma3_p20 if yeargroup==5 & ave_inc<p80 [aw=weight]
sum lnma3_totexp_80100 lnma3_totexp_90100 lnma3_p80 lnma3_p90 lnma3_p95 lnma3_p50 lnma3_p20 if yeargroup==6 & ave_inc<p80 [aw=weight]



******************************************************
*INTERNET APPENDIX TABLE A3: DECADES + MOBILITY+ INEQUALITY
******************************************************

gen gap8020=lnma3_p80-lnma3_p20
foreach v in "80" "90" {
gen lnma3_p`v'_d1980s=lnma3_p`v'*(year<=1990)
gen lnma3_p`v'_d1990s=lnma3_p`v'*(year<2000 & year>1990)
gen lnma3_p`v'_d2000s=lnma3_p`v'*(year>=2000)

}
*time split
xi:areg lntotexp  lnma3_p80_d1980s lnma3_p80_d1990s lnma3_p80_d2000s unemployed $controls i.year i.state [aw=weight] if  ave_inc<p80,a(inc_bucket) cluster(state)
outreg   lnma3_p80_d1980s lnma3_p80_d1990s lnma3_p80_d2000s unemployed using A3.txt, bdec(3) se br replace

xi:areg lntotexp lnma3_p80 fin  $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80,a(inc_bucket) cluster(state)
outreg lnma3_p80 fin using A3.txt,  bdec(3) se br append ctitle("fraction in finance")
xi:areg lntotexp lnma3_p80 ind_1*  $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80,a(inc_bucket) cluster(state)
outreg lnma3_p80 ind_1dig_1-ind_1dig_10 using A3.txt,  bdec(3) se br append ctitle("fracion in each 1 digit industry")
xi:areg lntotexp lnma3_p80 migrant outmigrant  $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80,a(inc_bucket) cluster(state)
outreg lnma3_p80 migrant outmigrant using A3.txt,  bdec(3) se br append ctitle("share in migrant  and outmigrant")
xi:areg lntotexp lnma3_p80 gini  $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80,a(inc_bucket) cluster(state)
outreg lnma3_p80 gini using A3.txt,  bdec(3) se br append ctitle("gini")
xi:areg lntotexp lnma3_p80 gap8020  $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80,a(inc_bucket) cluster(state)
outreg lnma3_p80 gap8020 using A3.txt,  bdec(3) se br append ctitle("80-20 gap")


********************
*INTERNET APPENDIX TABLE A4: GEOGRAPHY SUBSETS
**********************************

table statename, c(m state)
*the census list of states growing faster than national growth 1990-2000 are NV, AZ, CO, UT, ID, GA 
gen fastfastgrowstates=inlist(state,32,4,8,49,16,13)

*the census list of states very slow growth states 1990-2000 are WV,ME, ND,
gen slowslowgrowstates=inlist(state,39,42,9)

*belts
gen region="eastern seabord"
replace region="central sun belt" if inlist(state,4,22,48,5,40,47,32)
gen sunbelt=region=="central sun belt" | inlist(state,12,13,6)
replace region="pacific" if inlist(state,6,41,53,15,2)
replace region="mountain" if inlist(state,8,49,16)
replace region="corn belt" if inlist(state,18,19,17,31,20,29,27,21)
replace region="rust belt" if inlist(state,42,39,26,55,17,18)

xi:areg lntotexp lnma3_p80 $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80 & state~=6,a(inc_bucket) cluster(state)
outreg lnma3_p80 using A4.txt,  bdec(3) se br replace ctitle("exl CA")
xi:areg lntotexp lnma3_p80 $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80 & state~=36,a(inc_bucket) cluster(state)
outreg lnma3_p80 using A4.txt,  bdec(3) se br append ctitle("exl NY")
xi:areg lntotexp lnma3_p80 $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80 & state~=36 & state~=6,a(inc_bucket) cluster(state)
outreg lnma3_p80 using A4.txt,  bdec(3) se br append ctitle("exl NY and CA")
xi:areg lntotexp lnma3_p80 $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80 & fastfastgrowstates==0,a(inc_bucket) cluster(state)
outreg lnma3_p80 using A4.txt,  bdec(3) se br append ctitle("excl fast trend")
xi:areg lntotexp lnma3_p80 $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80 & slowslowgrowstates==0,a(inc_bucket) cluster(state)
outreg lnma3_p80 using A4.txt,  bdec(3) se br append ctitle("excl slow trend")
xi:areg lntotexp lnma3_p80 $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80 & region!="rust belt",a(inc_bucket) cluster(state) 
outreg lnma3_p80 using A4.txt,  bdec(3) se br append ctitle("no rust belt trend")
xi:areg lntotexp lnma3_p80 $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80 & sunbelt==0,a(inc_bucket) cluster(state) 
outreg lnma3_p80 using A4.txt,  bdec(3) se br append ctitle("no fullsun belt trend")
xi:areg lntotexp lnma3_p80 $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80 & (region!="pacific" & region!="eastern seabord"),a(inc_bucket) cluster(state) 
outreg lnma3_p80 using A4.txt,  bdec(3) se br append ctitle("no coasts trend")
xi:areg lntotexp lnma3_p80 $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80 & ( region!="eastern seabord"),a(inc_bucket) cluster(state) 
outreg lnma3_p80 using A4.txt,  bdec(3) se br append ctitle("no east coast trend")
xi:areg lntotexp lnma3_p80 $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80 & ( region!="pacific"),a(inc_bucket) cluster(state) 
outreg lnma3_p80 using A4.txt,  bdec(3) se br append ctitle("no west coast trend")

*high polarization states (from Lindley and Machin)
*18 high polarization, Arkansas, California, Colorado, Connecticut, Delaware, Illinois, Indiana, Maryland, Massachusetts, Michigan, New Hampshire, New Jersey, New York, North Carolina, Oregon, 
*Rhode Island, South Carolina, Virginia
*NOTE: Rhode Island and New Hampshire not in the CEX
gen highpolarizationstates=inlist(state, 5,6,8,9,10,17,18,24,25,26,34,36,37,41, 45,51)
xi:areg lntotexp lnma3_p80 $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80 & (highpolarization==0),a(inc_bucket) cluster(state) 
outreg lnma3_p80 using A4.txt,  bdec(3) se br append ctitle("no high polarization")

*********************
*INTERNET APPENDIX TABLE A8: ALTERNATIVE DEFINITIONS OF SHELTER
******************

gen lnnewtotexp=lntotexp
replace lnnewtotexp=ln(totexp+last_renteqhome99*12-expense_cat28) if own==1
gen ratnewtotexp=rat_totexp
replace ratnewtotexp=(totexp+last_renteqhome99*12-expense_cat28)/ave_inc if own==1
gen rat_expwoshelter=expense_woshelter/ave_inc

xi:areg lnnewtotexp lnma3_p80 unemployed $controls i.year i.state*year  [aw=weight] if ave_inc<p80,a(inc_bucket) cluster(state)
outreg lnma3_p80 unemployed using A8.txt,  bdec(3) se br replace

xi:areg lnnewtotexp lnma3_p80 lnma3_p50 lnma3_p20 unemployed $controls i.year i.state*year  [aw=weight] if ave_inc<p80,a(inc_bucket) cluster(state)
outreg lnma3_p80 lnma3_p50 lnma3_p20 unemployed using A8.txt,  bdec(3) se br append

xi:areg lnexp_wo_shelt lnma3_p80  unemployed $controls i.year i.state*year  [aw=weight] if ave_inc<p80,a(inc_bucket) cluster(state)
outreg lnma3_p80  unemployed using A8.txt,  bdec(3) se br append

xi:areg lnexp_wo_shelt lnma3_p80 lnma3_p50 lnma3_p20 unemployed $controls i.year i.state*year  [aw=weight] if ave_inc<p80,a(inc_bucket) cluster(state)
outreg lnma3_p80 lnma3_p50 lnma3_p20 unemployed using A8.txt,  bdec(3) se br append

xi:areg ratnewtotexp lnma3_p80 unemployed $controls i.year i.state*year  [aw=weight] if ave_inc<p80,a(inc_bucket) cluster(state)
outreg lnma3_p80 unemployed using A8.txt,  bdec(3) se br append

xi:areg ratnewtotexp lnma3_p80 lnma3_p50 lnma3_p20 unemployed $controls i.year i.state*year  [aw=weight] if ave_inc<p80,a(inc_bucket) cluster(state)
outreg lnma3_p80 lnma3_p50 lnma3_p20 unemployed using A8.txt,  bdec(3) se br append

xi:areg rat_expwoshelt lnma3_p80  unemployed $controls i.year i.state*year  [aw=weight] if ave_inc<p80,a(inc_bucket) cluster(state)
outreg lnma3_p80  unemployed using A8.txt,  bdec(3) se br append

xi:areg rat_expwoshelt lnma3_p80 lnma3_p50 lnma3_p20 unemployed $controls i.year i.state*year  [aw=weight] if ave_inc<p80,a(inc_bucket) cluster(state)
outreg lnma3_p80 lnma3_p50 lnma3_p20 unemployed using A8.txt,  bdec(3) se br append


**************************************************************
*INTERNET APPENDIX A11 : INCOME SEGREGATION
**************************************************************

keep if ave_inc<p80
egen med_seg_inc=median(cs00_seg_inc)
gen low_seg_inc=cs00_seg_inc<med_seg_inc
 
egen med_seg_inc_pov25=median(cs00_seg_inc_pov25)
gen low_seg_inc_pov25=cs00_seg_inc_pov25<med_seg_inc_pov25
 
egen med_seg_inc_aff75=median(cs00_seg_inc_aff75)
gen low_seg_inc_aff75=cs00_seg_inc_aff75<med_seg_inc_aff75

gen intseg=lnma3_p80*cs00_seg_inc
gen intseg_pov25=lnma3_p80*cs00_seg_inc_pov25
gen intseg_aff75=lnma3_p80*cs00_seg_inc_aff75
gen intlowseg=lnma3_p80*low_seg_inc
gen intlowseg_pov25=lnma3_p80*low_seg_inc_pov25
gen intlowseg_aff75=lnma3_p80*low_seg_inc_aff75


xi:areg lntotexp lnma3_p80  $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80 & low_seg_inc==1,a(inc_bucket) cluster(state)
outreg lnma3_p80  using A11.txt,  bdec(3) se br replace ctitle("income segregation")
xi:areg lntotexp lnma3_p80  $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80 & low_seg_inc==0,a(inc_bucket) cluster(state)
outreg lnma3_p80  using A11.txt,  bdec(3) se br append ctitle("income segregation")

xi:areg lntotexp lnma3_p80  $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80 & low_seg_inc_pov25==1,a(inc_bucket) cluster(state)
outreg lnma3_p80  using A11.txt,  bdec(3) se br append ctitle("income segregation")
xi:areg lntotexp lnma3_p80  $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80 & low_seg_inc_pov25==0,a(inc_bucket) cluster(state)
outreg lnma3_p80  using A11.txt,  bdec(3) se br append ctitle("income segregation")

xi:areg lntotexp lnma3_p80  $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80 & low_seg_inc_aff75==1,a(inc_bucket) cluster(state)
outreg lnma3_p80  using A11.txt,  bdec(3) se br append ctitle("income segregation")
xi:areg lntotexp lnma3_p80  $controls i.year unemployed i.state*year [aw=weight] if ave_inc<p80 & low_seg_inc_aff75==0,a(inc_bucket) cluster(state)
outreg lnma3_p80  using A11.txt,  bdec(3) se br append ctitle("income segregation")

****************************
*TABLE 7 COUNTERFACTUAL  
****************************

*use columns of  TABLE 1 
xi:areg lntotexp lnma3_p80 $controls i.year i.state [aw=weight] if  ave_inc<p80,a(inc_bucket) cluster(state)
gen blnma3_p80_middle=_b[lnma3_p80]

xi:areg lntotexp lnma3_p90 $controls i.year i.state [aw=weight] if  ave_inc<p80,a(inc_bucket) cluster(state)
gen blnma3_p90_middle=_b[lnma3_p90]

gen totexp_middle=totexp
replace totexp_middle=. if ave_inc<p80
gen lntotexp_middle=ln(totexp_middle)
collapse totexp_middle lntotexp_middle blnma3_p80_middle blnma3_p90_middle lnma3_p50 lnma3_p80 lnma3_p90 ma3_p50 ma3_p80 ma3_p90,by(year)

tab year
sort year
*TOTAL GROWTH IN INCOME for median households over different time intervals:
sort year
gen gr50_8208=lnma3_p50[_N]-lnma3_p50[1]
sort year
gen gr50_8290=lnma3_p50[9]-lnma3_p50[1]
sort year
gen gr50_8200=lnma3_p50[19]-lnma3_p50[1]
sort year
gen gr50_8205=lnma3_p50[24]-lnma3_p50[1]


*COUNTERFACTUALS for lnma3_p80 and lnma3_p90 over the same time intervals:

foreach z in 8208 8290 8200 8205{
foreach var in lnma3_p80 lnma3_p90{
sort year
gen counter`var'_`z'=`var'[1]+gr50_`z'
}
}

*COUNTERFACTUAL CONSUMPTION FOR the median households:
foreach z in 8208 8290 8200 8205{
foreach var in p80 p90{
sort year
gen diflntotexp_`z'_`var'=blnma3_`var'_middle*(counterlnma3_`var'_`z'-lnma3_`var')
gen savingdif_`z'_`var'=totexp_middle*diflntotexp_`z'_`var'
}
}


*TABULATION OF COUNTERFACTUALS FOR THE RELEVANT YEARS (90, 00, 05, 08)
foreach var in p80 p90{
table year if year==1990,c(mean diflntotexp_8290_`var' mean savingdif_8290_`var'  mean lnma3_`var' mean counterlnma3_`var'_8290)
table year if year==2000,c(mean diflntotexp_8200_`var' mean savingdif_8200_`var'  mean lnma3_`var' mean counterlnma3_`var'_8200) 
table year if year==2005,c(mean diflntotexp_8205_`var' mean savingdif_8205_`var'  mean lnma3_`var' mean counterlnma3_`var'_8205)
table year if year==2007,c(mean diflntotexp_8208_`var' mean savingdif_8208_`var'  mean lnma3_`var' mean counterlnma3_`var'_8208)
}


*NIPA counterfactuals
*CENSUS DATA on number of households in the US
*from http://censtats.census.gov/cgi-bin/usac/usatable.pl

gen nhh80=80389673
gen nhh90=91947410
gen nhh00=105480101
gen nhh10=116716292

*NIPA numbers for $$ change in personal savings in relevant years:
gen nipa_savings90=276.7
gen nipa_savings00=213.1
gen nipa_savings05=143.2
gen nipa_savings08=592.3
gen nipa_savings04=318.2
gen nipa_savings06=256.6
gen nipa_savings05_alt=1/2*(nipa_savings04+nipa_savings06)

gen nipa_dispinc90=4254
gen nipa_dispinc00=7327.2
gen nipa_dispinc05=9277.3
gen nipa_dispinc08=11024.5
gen nipa_dispinc04=8889.4
gen nipa_dispinc06=9915.7
gen nipa_dispinc05_alt=1/2*(nipa_dispinc04+nipa_dispinc06)

foreach x in 90 00 05 08 05_alt{
gen nipa_sr_`x'=nipa_savings`x'/nipa_dispinc`x'
}

*number of households below the 80th pctile of the numbers above
foreach var in 80 90 00 10{
gen nhh`var'_middle=nhh`var'*(4/5)
}

*now turn the magnitudes above into $$ change in savings for the middle income households for each of the relevant years (90, 00, 05, 08):
*DO THIS IN NOMINAL TERMS - SEE CPI series MULTIPLY BY DEF99

foreach var in p80 p90{
gen dollar_90_`var'=nhh90_middle*savingdif_8290_`var'*.7845138
gen dollar_00_`var'=nhh00_middle*savingdif_8200_`var'*1.033613
gen dollar_05_`var'=(1/2*(nhh00_middle+nhh10_middle))*savingdif_8205_`var'*1.172269
gen dollar_08_`var'=(1/5*(nhh00_middle)+4/5*(nhh10_middle))*savingdif_8208_`var'*1.292335
gen bdollar_90_`var'=dollar_90_`var'/1000000000
gen bdollar_00_`var'=dollar_00_`var'/1000000000
gen bdollar_05_`var'=dollar_05_`var'/1000000000
gen bdollar_08_`var'=dollar_08_`var'/1000000000
}

*COUNTERFACTUAL NIPA SAVINGS and NIPA SAVINGS RATE
foreach var in p80 p90{
foreach x in 90 00 05 08{
gen counternipa_savings`x'_`var'=nipa_savings`x'-(dollar_`x'_`var'/1000000000)
gen counternipa_sr_`x'_`var'=counternipa_savings`x'_`var'/nipa_dispinc`x'
}
}

foreach var in p80 p90{
gen counternipa_savings_05_`var'_alt=nipa_savings05_alt-(dollar_05_`var'/1000000000)
gen counternipa_sr_05_`var'_alt=counternipa_savings_05_`var'_alt/nipa_dispinc05_alt
}


*TABULATION OF RESULTS:

foreach var in p80 p90{
table year if year==1990,c(mean nipa_savings90 mean bdollar_90_`var' mean nipa_sr_90 mean counternipa_sr_90_`var' )
table year if year==2000,c(mean nipa_savings00 mean bdollar_00_`var' mean nipa_sr_00 mean counternipa_sr_00_`var' )
table year if year==2005,c(mean nipa_savings05 mean bdollar_05_`var' mean nipa_sr_05 mean counternipa_sr_05_`var' )
table year if year==2007,c(mean nipa_savings08 mean bdollar_08_`var' mean nipa_sr_08 mean counternipa_sr_08_`var')
}


