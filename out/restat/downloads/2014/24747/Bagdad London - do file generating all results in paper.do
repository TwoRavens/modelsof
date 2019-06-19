cap log c
clear
set more 1
set memory 500m
set matsize 2000

log using "C:\NEG\Data\EuropeanUrbanisation\RESULT B-L RR2.log",replace t


/*open dataset*/
/*total dataset that we have*/
*use "C:\NEG\Data\EuropeanUrbanisation\r&r restat - final.dta", clear
/*data set containing variable we actually use to get the results in the paper*/
use "C:\NEG\Data\EuropeanUrbanisation\restat - final.dta", clear

/*make graphs and calculate urbanization rate by country*/
sort country year

/*calculate urbanization rate by country*/
by country year: egen urbanization_country = sum(citypop_le10)
replace urbanization_country = urbanization_country/total_pop_ons
tab country year if year<1200, sum(urbanization_country)
tab country year if year>=1200, sum(urbanization_country)
drop urbanization_country


/*calculate urbanization rate for middle_east and Europe (based on geographic division*/
/*introduce a help-variable to calculate them directly from city data*/
gen help = 1
by country year: egen nrcities = sum(help)
replace help = total_pop_ons/nrcities

sort me_na year
by me_na year: egen totalpop_mena = sum(help)
by me_na year: egen urbpop_mena = sum(citypop_le10)
gen urbanization_mena = urbpop_mena/totalpop*100
replace urbpop_mena = urbpop_mena/1000

/*FIGURE 3*/
twoway (line urbanization_mena year if me_na==1, ytitle("urbanization rate (%)", axis(1)) xlabel(#11) xtitle("") yaxis(1) color(black) lpattern(-)) (line urbanization_mena year if me_na==0, yaxis(1) color(black) lpattern(-)) (line urbpop_mena year if me_na==1, ytitle("urban population (mln)", axis(2)) yaxis(2) color(black)) (line urbpop_mena year if me_na==0, yaxis(2) color(black)), legend(order(1 "urbanization" 3 "urban population") region(lcolor(white))) graphregion(fcolor(gs16))
graph rename urb_MENA, replace

/*FIGURE A3a*/
hist ecozone if me_na==0& year == 800, discrete frac addlabels graphregion(fcolor(gs16) lcolor(gs16)) legend(off) xlabel(1(1)6) ytitle("") color(gs10) lcolor(black)
graph rename aap1, replace
hist ecozone if me_na==1& year == 800, discrete frac addlabels graphregion(fcolor(gs16) lcolor(gs16)) legend(off) xlabel(1(1)6) color(gs10)  lcolor(black)
graph rename aap2, replace
graph combine aap2 aap1, ycommon xcommon graphregion(fcolor(gs16) lcolor(gs16)) title("agricultural potential")
graph rename ecozones, replace
graph drop aap1 aap2

/*FIGURE A3b*/
twoway (kdensity grond if me_na==0 & year==800, bwidth(0.05) color(black) lpattern(-)) (kdensity grond if  me_na==1 & year==800, bwidth(0.05) color(black)), legend(off) xtitle("P(cultivation)") ytitle("density") graphregion(fcolor(gs16) lcolor(gs16))
graph rename grondvgl, replace

drop help nrcities totalpop_mena urbpop_mena urbanization_mena totalpop urbpop

/*calculate share of muslim cities in each of the two regions*/
sort me_na year
by me_na year: egen pop = sum(citypop_le10)
by me_na year: egen muspop = sum(citypop_le10) if muslim==1
gen aap = (citypop_le10 >=10)
by me_na year: egen musnrcities = sum(aap) if muslim==1
by me_na year: egen nr_cities = sum(aap)

replace muspop = muspop/pop
replace musnrcities = musnrcities/nr_cities

/*FIGURE 2*/
twoway (line muspop year if me_na==1, xlabel(#11) xtitle("") yaxis(1) color(black) lpattern(-)) (line muspop year if me_na==0, yaxis(1) color(black) lpattern(-)) (line musnrcities year if me_na==1, yaxis(1) color(black)) (line musnrcities year if me_na==0, yaxis(1) color(black)), title("% muslim") legend(order(1 "urban population" 3 "number of cities") region(lcolor(white))) graphregion(fcolor(gs16))
graph rename religion_mena, replace
drop pop muspop aap musnrcities nr_cities





/*------------------------------------*/
/* start with the regression analysis */
/*------------------------------------*/

/*transform variables into ln, and create some new variables*/
gen ln_citypop = ln(citypop_le10)
gen ln_citypop_le5 = ln(citypop_le5)

gen ln_elev = ln(elevation_m+5) /*+5 to be able to take logs: lowest elevation is -4, in the Netherlands*/
gen ln_rugg10 = ln(rugg10)

gen ln_dmedina = ln(dmedina+1)
gen ln_dmecca = ln(dmecca+1)
gen ln_drome = ln(drome+1)
gen ln_djerusalem = ln(djerusalem+1)
gen ln_dbyzantium = ln(dbyzantium+1)

gen ln_dmus_near = ln(d_nearest_muslim)
gen ln_dchr_near = ln(d_nearest_christian)

gen ln_fup = ln(fup)
gen ln_musfup = ln(musfup)
gen ln_chrfup = ln(chrfup)

/*distance bands instead of fup*/
gen le10_0_20 = (nrcities_le10_0_20>0)
gen le10_20_50 = (nrcities_le10_20_50>0)
gen le10_50_100 = (nrcities_le10_50_100>0)

gen pople10_0_20 = ln(citypop_le10_0_20+1)
gen pople10_20_50 = ln(citypop_le10_20_50+1)
gen pople10_50_100 = ln(citypop_le10_50_100+1)

gen le10_0_20_mus = (nrcities_le10_0_20_mus>0)
gen le10_20_50_mus = (nrcities_le10_20_50_mus>0)
gen le10_50_100_mus = (nrcities_le10_50_100_mus>0)

gen pople10_0_20_mus = ln(citypop_le10_0_20_mus+1)
gen pople10_20_50_mus = ln(citypop_le10_20_50_mus+1)
gen pople10_50_100_mus = ln(citypop_le10_50_100_mus+1)

gen le10_0_20_chr = (nrcities_le10_0_20_chr>0)
gen le10_20_50_chr = (nrcities_le10_20_50_chr>0)
gen le10_50_100_chr = (nrcities_le10_50_100_chr>0)

gen pople10_0_20_chr = ln(citypop_le10_0_20_chr+1)
gen pople10_20_50_chr = ln(citypop_le10_20_50_chr+1)
gen pople10_50_100_chr = ln(citypop_le10_50_100_chr+1)

gen cities_le10_0_20_chr = ln(nrcities_le10_0_20_chr+1)
gen cities_le10_20_50_chr = ln(nrcities_le10_20_50_chr+1)
gen cities_le10_50_100_chr = ln(nrcities_le10_50_100_chr+1)

gen cities_le10_0_20_mus = ln(nrcities_le10_0_20_mus+1)
gen cities_le10_20_50_mus = ln(nrcities_le10_20_50_mus+1)
gen cities_le10_50_100_mus = ln(nrcities_le10_50_100_mus+1)

gen cities_le10_0_20 = ln(nrcities_le10_0_20+1)
gen cities_le10_20_50 = ln(nrcities_le10_20_50+1)
gen cities_le10_50_100 = ln(nrcities_le10_50_100+1)

/*distance and size nearest city*/
gen ln_dmus_near_le10 = ln(distance_nearest_muslim_le10)
gen ln_dchr_near_le10 = ln(distance_nearest_christian_le101)
gen ln_sizemus_near_le10 = ln(size_nearest_le10_mus)
gen ln_sizechr_near_le10 = ln(size_nearest_le10_chr)

/*generate dummy for muslim holy cities: mecca, medina, damascus, jerusalem*/
replace muslim_holy_city = (muslim_holy_city>0)

/*generate dummy for active parliaments*/
*gen parl_act = (parl_ai>0)

/*generate madrassa dummy from nr. of madrassas variable*/
*gen madrassa01 = (madrassas>0)



/*generate a large-state dummy - see Data appendix for realms classified as large - and see earlier dataset for realm variable*/
/*correction: change Fatimids into Ayyubids in 1200*/
/*
replace realm = 1000 if year==1200 & realm==54

gen D_largestate = 0
replace D_largestate = realm if realm== 106
replace D_largestate = realm if realm== 14
replace D_largestate = realm if realm== 84
replace D_largestate = realm if realm== 73
replace D_largestate = realm if realm== 113
replace D_largestate = realm if realm== 92
replace D_largestate = realm if realm== 89
replace D_largestate = realm if realm== 83
replace D_largestate = realm if realm== 70
replace D_largestate = realm if realm== 69
replace D_largestate = realm if realm== 148
replace D_largestate = realm if realm== 90
replace D_largestate = realm if realm== 111
replace D_largestate = realm if realm== 114
replace D_largestate = realm if realm== 120
replace D_largestate = realm if realm== 77
replace D_largestate = realm if realm== 31
replace D_largestate = realm if realm== 65
replace D_largestate = realm if realm== 233
replace D_largestate = realm if realm== 1000
replace D_largestate = realm if realm== 7
replace D_largestate = realm if realm== 54
replace D_largestate = realm if realm== 8
replace D_largestate = realm if realm== 74
replace D_largestate = realm if realm== 25
replace D_largestate = realm if realm== 1
replace D_largestate = realm if realm== 104
replace D_largestate = realm if realm== 133
replace D_largestate = realm if realm== 125
replace D_largestate = realm if realm== 4
replace D_largestate = realm if realm== 62
replace D_largestate = realm if realm== 28
replace D_largestate = realm if realm== 51
replace D_largestate = realm if realm== 315
replace D_largestate = realm if realm== 45
replace D_largestate = realm if realm== 88
replace D_largestate = realm if realm== 26
replace D_largestate = realm if realm== 132
replace D_largestate = realm if realm== 79
replace D_largestate = realm if realm== 80
replace D_largestate = realm if realm== 78
replace D_largestate = realm  if realm== 23
replace D_largestate = realm  if realm== 22
replace D_largestate = realm  if realm== 67
replace D_largestate = realm  if realm== 95
replace D_largestate = realm  if realm== 156
replace D_largestate = realm  if realm== 86
replace D_largestate = realm  if realm== 58
replace D_largestate = realm  if realm== 231
replace D_largestate = 1 if D_largestate!=0 & D_largestate!=.
*/

/*generate christian_holy_city: rome, santiago, byzantium, jerusalem*/
gen christian_holy_city = (indicator==337 | indicator==613 | indicator==598 | indicator==500)

/*generate interaction commune_final, active parliament dummy, large state dummy & fup (also for christian and muslim variants)*/
gen parl_musfup = parl_act*ln_musfup 
gen com_musfup = commune_final*ln_musfup 
gen largestate_musfup = D_largestate*ln_musfup
gen parl_chrfup = parl_act*ln_chrfup 
gen com_chrfup = commune_final*ln_chrfup 
gen largestate_chrfup = D_largestate*ln_chrfup

/*generate UK-Low countries-dummy, a Central Europe dummy and a Mediterrenean dummy*/
gen UK_Neth_BE = (country=="UK" | country=="Netherlands" | country=="Belgium")
gen Central_Europe = (country=="Czech rep." | country=="Poland" | country=="Slovakia" | country=="Hungary")
gen clubMED = (UK_Neth_BE!=1 & Central_Europe!=1 & country!="Ireland" & country!="Germany" & country!="Denmark" & country!="Zwitserland" & country!="Bulgaria" & country!= "Finland" & country!= "Norway" & country!="Sweden" & country!="Austria" & country!="Rumenia" & arab_peninsula==0 & longitude <= 47.03429 )

/*generate time, country, realm, ecozone etc dummies*/
tab country, gen(cdum)
tab year, gen(tdum)
tab ecozones, gen(ecodum)


/*set panel dimension of the dataset*/
xtset indicator year


/*RESULTS*/

/*----------------------------------------------------------------------------*/
/*-------------------------------- TABLE 1 -----------------------------------*/
/*----------------------------------------------------------------------------*/
/*ALL cities - column 1 Table 1*/
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_musfup ln_chrfup ln_elev ln_rugg10 grond  plundered ln_dmecca ln_drome ln_dbyzantium muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum*,cluster(indicator)
testparm tdum*
testparm cdum*
testparm ecodum*

/*christian cities - column 3 Table 1 - include only ln_drome and ln_dbyzantium*/
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_musfup ln_chrfup ln_elev ln_rugg10 grond  plundered ln_drome ln_dbyzantium muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==0,cluster(indicator)
testparm tdum*
testparm cdum*
testparm ecodum*

/*muslim cities - column 2 Table 1 - include only ln_dmecca*/
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_musfup ln_chrfup ln_elev ln_rugg10 grond  plundered ln_dmecca muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==1,cluster(indicator)
testparm tdum*
testparm cdum*
testparm ecodum*


/*robustness different sample composition*/
/*Europe only - column 5 Table 1*/
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_musfup ln_chrfup ln_elev ln_rugg10 grond  plundered ln_dmecca ln_drome ln_dbyzantium muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if me_na==0,cluster(indicator)
testparm tdum*
testparm cdum*
testparm ecodum*
/*Middle East & North Africa only - column 4 Table 1*/
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_musfup ln_chrfup ln_elev ln_rugg10 grond  plundered ln_dmecca ln_drome ln_dbyzantium muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if me_na==1,cluster(indicator)
testparm tdum*
testparm cdum*
testparm ecodum*


/*focus on muslim and christian cities in ME_NA and in Europe respectively*/
/*chr en mus samples met alleen ln_dmecca of ln_drome respectively*/
/*christian cities in Europe - column 7 Table 1*/
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_musfup ln_chrfup ln_elev ln_rugg10 grond  plundered ln_drome ln_dbyzantium muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==0 & me_na==0,cluster(indicator)
testparm tdum*
testparm cdum*
testparm ecodum*
/*muslim cities in Middle East & North Africa - column 6 Table 1*/
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_musfup ln_chrfup ln_elev ln_rugg10 grond  plundered ln_dmecca muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==1 & me_na==1,cluster(indicator)
testparm tdum*
testparm cdum*
testparm ecodum*


/*RR2 -- explain lack of sea effect in Arab World*/
/*leave out damietta or dummy damietta*/
gen damietta = (city=="Damietta (Doumyat, Dimyat)")
/*regression excluding Damietta - focus on ME_NA, muslim cities in ME_NA or muslim cities*/
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_musfup ln_chrfup ln_elev ln_rugg10 grond  plundered ln_dmecca muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if  muslim==1 & me_na==1 & damietta==0,cluster(indicator)
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_musfup ln_chrfup ln_elev ln_rugg10 grond  plundered ln_dmecca muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if  me_na==1 & damietta==0,cluster(indicator)
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_musfup ln_chrfup ln_elev ln_rugg10 grond  plundered ln_dmecca muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if  muslim==1 & damietta==0,cluster(indicator)



/*---------------------------- Table A4: including Fixed Effects ---------------------------*/
/*column 1 Table A4*/
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_musfup ln_chrfup ln_elev ln_rugg10 grond  plundered ln_dmecca ln_drome ln_dbyzantium muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum*,cluster(indicator) fe
testparm tdum*
/*column 3 Table A4*/
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_musfup ln_chrfup ln_elev ln_rugg10 grond  plundered ln_dmecca ln_drome ln_dbyzantium muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==0,cluster(indicator) fe
testparm tdum*
/*column 2 Table A4*/
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_musfup ln_chrfup ln_elev ln_rugg10 grond  plundered ln_dmecca ln_drome ln_dbyzantium muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==1,cluster(indicator) fe
testparm tdum*

/*focus on mediterrenean*/
/*column 5 Table A4*/
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_musfup ln_chrfup ln_elev ln_rugg10 grond  plundered ln_dmecca ln_drome ln_dbyzantium muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==0 & clubMED==1,cluster(indicator) fe
testparm tdum*
/*column 4 Table A4*/
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_musfup ln_chrfup ln_elev ln_rugg10 grond  plundered ln_dmecca ln_drome ln_dbyzantium muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==1 & clubMED==1,cluster(indicator) fe
testparm tdum*


/*---------------------------------------------------------------------------*/
/*------------------- Focus on city-specific institutions -------------------*/
/*---------------------------------------------------------------------------*/

/*column 2 Table 3*/
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_musfup ln_chrfup ln_elev ln_rugg10 grond plundered ln_dmecca ln_drome ln_dbyzantium muslim*holy* christian*holy* madr*01 D_largestate commune_final parl_act free_prince_dls ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum*  if muslim==0, cluster(indicator) fe
testparm tdum*
/*column 1 Table 3*/
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_musfup ln_chrfup ln_elev ln_rugg10 grond plundered ln_dmecca ln_drome ln_dbyzantium muslim*holy* christian*holy* madr*01 D_largestate commune_final parl_act free_prince_dls ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum*  if muslim==1, cluster(indicator) fe
testparm tdum*


/* column 4 Table 3 */
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_musfup ln_chrfup ln_elev ln_rugg10 grond plundered ln_dmecca ln_drome ln_dbyzantium muslim*holy* christian*holy* madr*01 D_largestate commune_final parl_act free_prince_dls ecodum2 ecodum3 ecodum4 ecodum5 lar*fup com*fup parl*fup cdum* tdum* if muslim==0,cluster(indicator) fe
testparm tdum*
test ln_chrfup+largestate_chrfup=0
test ln_chrfup+parl_chrfup=0
test ln_chrfup+com_chrfup=0

/* Figure A2a - left panel */
gen MV=((_n+2)/10)
replace MV=. if _n>40
/*create plot of marginal effect of going from non-commune to commune depending on CHRFUP*/
matrix b = e(b)
matrix V = e(V)
scalar b1 = b[1,13]
scalar b2 = b[1,25]
scalar b3 = b[1,35]
scalar varb1 = V[13,13]
scalar varb2 = V[25,25]
scalar varb3 = V[35,35]
scalar covarb1b3 = V[13,35]
scalar covarb2b3 = V[25,35]
gen conb = b2+b3*MV if _n<70
gen conse=sqrt(varb2 + varb3*(MV)^2+2*covarb2b3*MV) if _n<70
gen a = 1.96*conse
gen upper = conb+a
gen lower = conb-a
gen aap = 0
twoway (line conb MV, xtitle("ln christian urban potential") color(black)) (line upper MV, color(black) lpattern(-)) (line lower MV, color(black) lpattern(-)) (line aap MV, color(grey)) (kdensity ln_chrfup if ln_chrfup>0.3 & ln_chrfup<=4.3, color(red)), legend(order(1 "marg.eff commune" 3 "5% confidence interval" 5 "density of ln Christian urban potential") region(lcolor(white))) graphregion(fcolor(gs16))
graph rename aap_com, replace

/* Figure A2a - right panel */
/*create plot of marginal effect of going from no active parlm to active parlm depending on CHRFUP*/
matrix b = e(b)
matrix V = e(V)
scalar b1 = b[1,13]
scalar b2 = b[1,26]
scalar b3 = b[1,37]
scalar varb1 = V[13,13]
scalar varb2 = V[26,26]
scalar varb3 = V[37,37]
scalar covarb1b3 = V[13,37]
scalar covarb2b3 = V[26,37]
replace conb = b2+b3*MV if _n<70
replace conse=sqrt(varb2 + varb3*(MV)^2+2*covarb2b3*MV) if _n<70
replace a = 1.96*conse
replace upper = conb+a
replace lower = conb-a
replace aap = 0
twoway (line conb MV, xtitle("ln christian urban potential") color(black)) (line upper MV, color(black) lpattern(-)) (line lower MV, color(black) lpattern(-)) (line aap MV, color(grey)) (kdensity ln_chrfup if ln_chrfup>0.3 & ln_chrfup<=4.3, color(red)), legend(order(1 "marg.eff active parliament" 3 "5% confidence interval" 5 "density of ln Christian urban potential") region(lcolor(white))) graphregion(fcolor(gs16))
graph rename aap_parlm, replace


/* column 3 Table 3 */
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_musfup ln_chrfup ln_elev ln_rugg10 grond plundered ln_dmecca ln_drome ln_dbyzantium muslim*holy* christian*holy* madr*01 D_largestate commune_final parl_act free_prince_dls ecodum2 ecodum3 ecodum4 ecodum5 lar*fup com*fup parl*fup cdum* tdum* if muslim==1,cluster(indicator) fe
testparm tdum*
test ln_musfup+largestate_musfup=0

/* Figure A2b */
/*create plot of marginal effect of going from no largestate to largestate depending on MUSFUP*/
replace MV=((_n-10)/10)
replace MV=. if _n>40
matrix b = e(b)
matrix V = e(V)
scalar b1 = b[1,12]
scalar b2 = b[1,24]
scalar b3 = b[1,32]
scalar varb1 = V[12,12]
scalar varb2 = V[24,24]
scalar varb3 = V[32,32]
scalar covarb1b3 = V[12,32]
scalar covarb2b3 = V[24,32]
replace conb = b2+b3*MV if _n<70
replace conse=sqrt(varb2 + varb3*(MV)^2+2*covarb2b3*MV) if _n<70
replace a = 1.96*conse
replace upper = conb+a
replace lower = conb-a
replace aap = 0
twoway (line conb MV, xtitle("ln muslim urban potential") color(black)) (line upper MV, color(black) lpattern(-)) (line lower MV, color(black) lpattern(-)) (line aap MV, color(grey)) (kdensity ln_musfup if ln_musfup>-0.9 & ln_musfup<=3, color(red)), legend(order(1 "marg.eff large state" 3 "5% confidence interval" 5 "density of ln Muslim urban potential") region(lcolor(white))) graphregion(fcolor(gs16))
graph rename aap_muslarge, replace

/* exclude Andalusia */
/* i.e. country!=Spain & longitude < 38.7375 (northern most tip andalusia)*/
/* and latitude < -2.05 (eastern most tip andalusia ~~*/
/*first city to exclude: north: Hinojosa-del-Duque, east: Vélez-Rubio*/
gen andalusia = (country=="Spain" & longitude < 38.7375 & latitude < -2.05)
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_musfup ln_chrfup ln_elev ln_rugg10 grond plundered ln_dmecca ln_drome ln_dbyzantium muslim*holy* christian*holy* madr*01 D_largestate commune_final parl_act free_prince_dls ecodum2 ecodum3 ecodum4 ecodum5 lar*fup com*fup parl*fup cdum* tdum* if muslim==1 & andalusia!=1,cluster(indicator) fe
testparm tdum*
test ln_musfup+largestate_musfup=0

/* column 5 Table 3 */
/* exclude Emirate of Granada */
/* = Andalusia in 1300 and 1400 dummy */
/* Emirate of Granada (1238 - 1492) dummy, aka Nasrid Kingdom of Granada */
*gen GranadaEmirate = (realm==75)
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_musfup ln_chrfup ln_elev ln_rugg10 grond plundered ln_dmecca ln_drome ln_dbyzantium muslim*holy* christian*holy* madr*01 D_largestate commune_final parl_act free_prince_dls ecodum2 ecodum3 ecodum4 ecodum5 lar*fup com*fup parl*fup cdum* tdum* if muslim==1 & GranadaEmirate!=1,cluster(indicator) fe
testparm tdum*
test ln_musfup+largestate_musfup=0

/* column 6 Table 3 */
/* additional focus on Ottoman Empire */
*gen ottoman = (realm==106)
gen ottoman_musfup = ottoman*ln_musfup
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_musfup ln_chrfup ln_elev ln_rugg10 grond plundered ln_dmecca ln_drome ln_dbyzantium muslim*holy* christian*holy* madr*01 D_largestate commune_final parl_act free_prince_dls ecodum2 ecodum3 ecodum4 ecodum5 lar*fup com*fup parl*fup ottoman* cdum* tdum* if muslim==1,cluster(indicator) fe
testparm tdum*
test ln_musfup+largestate_musfup=0
test ln_musfup+largestate_musfup+ottoman_musfup=0


/*column 7 Table 3 */
/* exclude UK and Low Countries */
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_musfup ln_chrfup ln_elev ln_rugg10 grond plundered ln_dmecca ln_drome ln_dbyzantium muslim*holy* christian*holy* madr*01 D_largestate commune_final parl_act free_prince_dls ecodum2 ecodum3 ecodum4 ecodum5 lar*fup com*fup parl*fup cdum* tdum* if muslim==0 & UK_Neth_BE==0,cluster(indicator) fe
testparm tdum*
test ln_chrfup+largestate_chrfup=0
test ln_chrfup+parl_chrfup=0
test ln_chrfup+com_chrfup=0



/*----------------------------------------------------------------------------*/
/*-------------------------------- STEP 2 ------------------------------------*/
/*----------------------------------------------------------------------------*/

/*generate time-varying variables - ALS ZONDER FE*/
forvalues X = 1/11 {
gen sea_year`X' = sea * tdum`X'
gen grond_year`X' = grond * tdum`X'
gen river_year`X' = river *tdum`X'
gen rom_road_nohub_year`X' = rom_road_nohub * tdum`X'
gen caravan_hub_year`X' = caravan_hub * tdum`X'
gen caravan_nohub_year`X' = caravan_nohub *tdum`X'
gen hub_3rr_year`X' = hub_3rr * tdum`X'
}

forvalues X = 1/11 {
gen capitol_year`X' =  capitol * tdum`X'
gen ln_musfup_year`X' = ln_musfup  * tdum`X'
gen ln_chrfup_year`X' = ln_chrfup  * tdum`X'
}

/*muslim cities*/
/*------------------------ TABLE A7a --------------------*/
xtreg ln_citypop sea river rom_road*year* hub_3rr caravan_nohub caravan_hub*year* bishop archbishop capitol*year* university muslim ln_musfup*year* ln_chrfup*year* ln_elev ln_rugg10 grond  plundered ln_dmecca muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==1,cluster(indicator)
test rom_road_nohub_year1 = rom_road_nohub_year2 = rom_road_nohub_year3 = rom_road_nohub_year4 = rom_road_nohub_year5 = rom_road_nohub_year6 = rom_road_nohub_year7 = rom_road_nohub_year8 = rom_road_nohub_year9 = rom_road_nohub_year10 = rom_road_nohub_year11
test rom_road_nohub_year1 = rom_road_nohub_year2 
test rom_road_nohub_year1 = rom_road_nohub_year3 
test rom_road_nohub_year1 = rom_road_nohub_year4 
test rom_road_nohub_year1 = rom_road_nohub_year5 
test rom_road_nohub_year1 = rom_road_nohub_year6 
test rom_road_nohub_year1 = rom_road_nohub_year7 
test rom_road_nohub_year1 = rom_road_nohub_year8
test rom_road_nohub_year1 = rom_road_nohub_year9 
test rom_road_nohub_year1 = rom_road_nohub_year10 
test rom_road_nohub_year1 = rom_road_nohub_year11

test caravan_hub_year1 = caravan_hub_year2 = caravan_hub_year3 = caravan_hub_year4 = caravan_hub_year5 = caravan_hub_year6 = caravan_hub_year7 = caravan_hub_year8 = caravan_hub_year9 = caravan_hub_year10 = caravan_hub_year11
test caravan_hub_year1 = caravan_hub_year2 
test caravan_hub_year1 = caravan_hub_year3 
test caravan_hub_year1 = caravan_hub_year4 
test caravan_hub_year1 = caravan_hub_year5 
test caravan_hub_year1 = caravan_hub_year6 
test caravan_hub_year1 = caravan_hub_year7 
test caravan_hub_year1 = caravan_hub_year8 
test caravan_hub_year1 = caravan_hub_year9 
test caravan_hub_year1 = caravan_hub_year10 
test caravan_hub_year1 = caravan_hub_year11

test capitol_year1 = capitol_year2 = capitol_year3 = capitol_year4 = capitol_year5 = capitol_year6 = capitol_year7 = capitol_year8 = capitol_year9 = capitol_year10 = capitol_year11
test capitol_year1 = capitol_year2 
test capitol_year1 = capitol_year3 
test capitol_year1 = capitol_year4 
test capitol_year1 = capitol_year5 
test capitol_year1 = capitol_year6 
test capitol_year1 = capitol_year7 
test capitol_year1 = capitol_year8 
test capitol_year1 = capitol_year9 
test capitol_year1 = capitol_year10 
test capitol_year1 = capitol_year11

test ln_musfup_year1 = ln_musfup_year2 = ln_musfup_year3 = ln_musfup_year4 = ln_musfup_year5 = ln_musfup_year6 = ln_musfup_year7 = ln_musfup_year8 = ln_musfup_year9 = ln_musfup_year10 = ln_musfup_year11
test ln_musfup_year1 = ln_musfup_year2 
test ln_musfup_year1 = ln_musfup_year3 
test ln_musfup_year1 = ln_musfup_year4 
test ln_musfup_year1 = ln_musfup_year5 
test ln_musfup_year1 = ln_musfup_year6 
test ln_musfup_year1 = ln_musfup_year7 
test ln_musfup_year1 = ln_musfup_year8 
test ln_musfup_year1 = ln_musfup_year9
test ln_musfup_year1 = ln_musfup_year10 
test ln_musfup_year1 = ln_musfup_year11

test ln_chrfup_year1 = ln_chrfup_year2 = ln_chrfup_year3 = ln_chrfup_year4 = ln_chrfup_year5 = ln_chrfup_year6 = ln_chrfup_year7 = ln_chrfup_year8 = ln_chrfup_year9 = ln_chrfup_year10 = ln_chrfup_year11
test ln_chrfup_year1 = ln_chrfup_year2 
test ln_chrfup_year1 = ln_chrfup_year3 
test ln_chrfup_year1 = ln_chrfup_year4 
test ln_chrfup_year1 = ln_chrfup_year5 
test ln_chrfup_year1 = ln_chrfup_year6 
test ln_chrfup_year1 = ln_chrfup_year7 
test ln_chrfup_year1 = ln_chrfup_year8
test ln_chrfup_year1 = ln_chrfup_year9 
test ln_chrfup_year1 = ln_chrfup_year10 
test ln_chrfup_year1 = ln_chrfup_year11
testparm tdum*
testparm cdum*
testparm ecodum*


/*christian cities*/
/*------------------------ TABLE A7b --------------------*/
xtreg ln_citypop sea_y* river_y* rom_road_nohub hub_3rr caravan_nohub caravan_hub bishop archbishop capitol*year* university muslim ln_musfup*year* ln_chrfup*year* ln_elev ln_rugg10 grond  plundered ln_drome ln_dbyzantium muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==0,cluster(indicator)
test sea_year1 = sea_year2 = sea_year3 = sea_year4 = sea_year5 = sea_year6 = sea_year7 = sea_year8 = sea_year9 = sea_year10 = sea_year11
test sea_year1 = sea_year2 
test sea_year1 = sea_year3 
test sea_year1 = sea_year4 
test sea_year1 = sea_year5 
test sea_year1 = sea_year6 
test sea_year1 = sea_year7 
test sea_year1 = sea_year8
test sea_year1 = sea_year9 
test sea_year1 = sea_year10 
test sea_year1 = sea_year11

test river_year1 = river_year2 = river_year3 = river_year4 = river_year5 = river_year6 = river_year7 = river_year8 = river_year9 = river_year10 = river_year11
test river_year1 = river_year2 
test river_year1 = river_year3 
test river_year1 = river_year4 
test river_year1 = river_year5 
test river_year1 = river_year6 
test river_year1 = river_year7 
test river_year1 = river_year8
test river_year1 = river_year9 
test river_year1 = river_year10 
test river_year1 = river_year11

test capitol_year1 = capitol_year2 = capitol_year3 = capitol_year4 = capitol_year5 = capitol_year6 = capitol_year7 = capitol_year8 = capitol_year9 = capitol_year10 = capitol_year11
test capitol_year1 = capitol_year2 
test capitol_year1 = capitol_year3 
test capitol_year1 = capitol_year4 
test capitol_year1 = capitol_year5 
test capitol_year1 = capitol_year6 
test capitol_year1 = capitol_year7 
test capitol_year1 = capitol_year8 
test capitol_year1 = capitol_year9 
test capitol_year1 = capitol_year10 
test capitol_year1 = capitol_year11

test ln_musfup_year1 = ln_musfup_year2 = ln_musfup_year3 = ln_musfup_year4 = ln_musfup_year5 = ln_musfup_year6 = ln_musfup_year7 = ln_musfup_year8 = ln_musfup_year9 = ln_musfup_year10 = ln_musfup_year11
test ln_musfup_year1 = ln_musfup_year2 
test ln_musfup_year1 = ln_musfup_year3 
test ln_musfup_year1 = ln_musfup_year4 
test ln_musfup_year1 = ln_musfup_year5 
test ln_musfup_year1 = ln_musfup_year6 
test ln_musfup_year1 = ln_musfup_year7 
test ln_musfup_year1 = ln_musfup_year8 
test ln_musfup_year1 = ln_musfup_year9
test ln_musfup_year1 = ln_musfup_year10 
test ln_musfup_year1 = ln_musfup_year11

test ln_chrfup_year1 = ln_chrfup_year2 = ln_chrfup_year3 = ln_chrfup_year4 = ln_chrfup_year5 = ln_chrfup_year6 = ln_chrfup_year7 = ln_chrfup_year8 = ln_chrfup_year9 = ln_chrfup_year10 = ln_chrfup_year11
test ln_chrfup_year1 = ln_chrfup_year2 
test ln_chrfup_year1 = ln_chrfup_year3 
test ln_chrfup_year1 = ln_chrfup_year4 
test ln_chrfup_year1 = ln_chrfup_year5 
test ln_chrfup_year1 = ln_chrfup_year6 
test ln_chrfup_year1 = ln_chrfup_year7 
test ln_chrfup_year1 = ln_chrfup_year8
test ln_chrfup_year1 = ln_chrfup_year9 
test ln_chrfup_year1 = ln_chrfup_year10 
test ln_chrfup_year1 = ln_chrfup_year11
testparm tdum*
testparm cdum*
testparm ecodum*


/*RR2 - met sea over time in muslim sample*/
xtreg ln_citypop sea*year* river rom_road*year* hub_3rr caravan_nohub caravan_hub*year* bishop archbishop capitol*year* university muslim ln_musfup*year* ln_chrfup*year* ln_elev ln_rugg10 grond  plundered ln_dmecca muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==1,cluster(indicator)
test sea_year1 = sea_year2 = sea_year3 = sea_year4 = sea_year5 = sea_year6 = sea_year7 = sea_year8 = sea_year9 = sea_year10 = sea_year11
test sea_year1 = sea_year2 
test sea_year1 = sea_year3 
test sea_year1 = sea_year4 
test sea_year1 = sea_year5 
test sea_year1 = sea_year6 
test sea_year1 = sea_year7 
test sea_year1 = sea_year8
test sea_year1 = sea_year9 
test sea_year1 = sea_year10 
test sea_year1 = sea_year11

test rom_road_nohub_year1 = rom_road_nohub_year2 = rom_road_nohub_year3 = rom_road_nohub_year4 = rom_road_nohub_year5 = rom_road_nohub_year6 = rom_road_nohub_year7 = rom_road_nohub_year8 = rom_road_nohub_year9 = rom_road_nohub_year10 = rom_road_nohub_year11
test rom_road_nohub_year1 = rom_road_nohub_year2 
test rom_road_nohub_year1 = rom_road_nohub_year3 
test rom_road_nohub_year1 = rom_road_nohub_year4 
test rom_road_nohub_year1 = rom_road_nohub_year5 
test rom_road_nohub_year1 = rom_road_nohub_year6 
test rom_road_nohub_year1 = rom_road_nohub_year7 
test rom_road_nohub_year1 = rom_road_nohub_year8
test rom_road_nohub_year1 = rom_road_nohub_year9 
test rom_road_nohub_year1 = rom_road_nohub_year10 
test rom_road_nohub_year1 = rom_road_nohub_year11

test caravan_hub_year1 = caravan_hub_year2 = caravan_hub_year3 = caravan_hub_year4 = caravan_hub_year5 = caravan_hub_year6 = caravan_hub_year7 = caravan_hub_year8 = caravan_hub_year9 = caravan_hub_year10 = caravan_hub_year11
test caravan_hub_year1 = caravan_hub_year2 
test caravan_hub_year1 = caravan_hub_year3 
test caravan_hub_year1 = caravan_hub_year4 
test caravan_hub_year1 = caravan_hub_year5 
test caravan_hub_year1 = caravan_hub_year6 
test caravan_hub_year1 = caravan_hub_year7 
test caravan_hub_year1 = caravan_hub_year8 
test caravan_hub_year1 = caravan_hub_year9 
test caravan_hub_year1 = caravan_hub_year10 
test caravan_hub_year1 = caravan_hub_year11

test capitol_year1 = capitol_year2 = capitol_year3 = capitol_year4 = capitol_year5 = capitol_year6 = capitol_year7 = capitol_year8 = capitol_year9 = capitol_year10 = capitol_year11
test capitol_year1 = capitol_year2 
test capitol_year1 = capitol_year3 
test capitol_year1 = capitol_year4 
test capitol_year1 = capitol_year5 
test capitol_year1 = capitol_year6 
test capitol_year1 = capitol_year7 
test capitol_year1 = capitol_year8 
test capitol_year1 = capitol_year9 
test capitol_year1 = capitol_year10 
test capitol_year1 = capitol_year11

test ln_musfup_year1 = ln_musfup_year2 = ln_musfup_year3 = ln_musfup_year4 = ln_musfup_year5 = ln_musfup_year6 = ln_musfup_year7 = ln_musfup_year8 = ln_musfup_year9 = ln_musfup_year10 = ln_musfup_year11
test ln_musfup_year1 = ln_musfup_year2 
test ln_musfup_year1 = ln_musfup_year3 
test ln_musfup_year1 = ln_musfup_year4 
test ln_musfup_year1 = ln_musfup_year5 
test ln_musfup_year1 = ln_musfup_year6 
test ln_musfup_year1 = ln_musfup_year7 
test ln_musfup_year1 = ln_musfup_year8 
test ln_musfup_year1 = ln_musfup_year9
test ln_musfup_year1 = ln_musfup_year10 
test ln_musfup_year1 = ln_musfup_year11

test ln_chrfup_year1 = ln_chrfup_year2 = ln_chrfup_year3 = ln_chrfup_year4 = ln_chrfup_year5 = ln_chrfup_year6 = ln_chrfup_year7 = ln_chrfup_year8 = ln_chrfup_year9 = ln_chrfup_year10 = ln_chrfup_year11
test ln_chrfup_year1 = ln_chrfup_year2 
test ln_chrfup_year1 = ln_chrfup_year3 
test ln_chrfup_year1 = ln_chrfup_year4 
test ln_chrfup_year1 = ln_chrfup_year5 
test ln_chrfup_year1 = ln_chrfup_year6 
test ln_chrfup_year1 = ln_chrfup_year7 
test ln_chrfup_year1 = ln_chrfup_year8
test ln_chrfup_year1 = ln_chrfup_year9 
test ln_chrfup_year1 = ln_chrfup_year10 
test ln_chrfup_year1 = ln_chrfup_year11

testparm tdum*


/*zonder damietta*/
xtreg ln_citypop sea*year* river rom_road*year* hub_3rr caravan_nohub caravan_hub*year* bishop archbishop capitol*year* university muslim ln_musfup*year* ln_chrfup*year* ln_elev ln_rugg10 grond  plundered ln_dmecca muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==1 & damietta==0,cluster(indicator)
test sea_year1 = sea_year2 = sea_year3 = sea_year4 = sea_year5 = sea_year6 = sea_year7 = sea_year8 = sea_year9 = sea_year10 = sea_year11
test sea_year1 = sea_year2 
test sea_year1 = sea_year3 
test sea_year1 = sea_year4 
test sea_year1 = sea_year5 
test sea_year1 = sea_year6 
test sea_year1 = sea_year7 
test sea_year1 = sea_year8
test sea_year1 = sea_year9 
test sea_year1 = sea_year10 
test sea_year1 = sea_year11

test rom_road_nohub_year1 = rom_road_nohub_year2 = rom_road_nohub_year3 = rom_road_nohub_year4 = rom_road_nohub_year5 = rom_road_nohub_year6 = rom_road_nohub_year7 = rom_road_nohub_year8 = rom_road_nohub_year9 = rom_road_nohub_year10 = rom_road_nohub_year11
test rom_road_nohub_year1 = rom_road_nohub_year2 
test rom_road_nohub_year1 = rom_road_nohub_year3 
test rom_road_nohub_year1 = rom_road_nohub_year4 
test rom_road_nohub_year1 = rom_road_nohub_year5 
test rom_road_nohub_year1 = rom_road_nohub_year6 
test rom_road_nohub_year1 = rom_road_nohub_year7 
test rom_road_nohub_year1 = rom_road_nohub_year8
test rom_road_nohub_year1 = rom_road_nohub_year9 
test rom_road_nohub_year1 = rom_road_nohub_year10 
test rom_road_nohub_year1 = rom_road_nohub_year11

test caravan_hub_year1 = caravan_hub_year2 = caravan_hub_year3 = caravan_hub_year4 = caravan_hub_year5 = caravan_hub_year6 = caravan_hub_year7 = caravan_hub_year8 = caravan_hub_year9 = caravan_hub_year10 = caravan_hub_year11
test caravan_hub_year1 = caravan_hub_year2 
test caravan_hub_year1 = caravan_hub_year3 
test caravan_hub_year1 = caravan_hub_year4 
test caravan_hub_year1 = caravan_hub_year5 
test caravan_hub_year1 = caravan_hub_year6 
test caravan_hub_year1 = caravan_hub_year7 
test caravan_hub_year1 = caravan_hub_year8 
test caravan_hub_year1 = caravan_hub_year9 
test caravan_hub_year1 = caravan_hub_year10 
test caravan_hub_year1 = caravan_hub_year11

test capitol_year1 = capitol_year2 = capitol_year3 = capitol_year4 = capitol_year5 = capitol_year6 = capitol_year7 = capitol_year8 = capitol_year9 = capitol_year10 = capitol_year11
test capitol_year1 = capitol_year2 
test capitol_year1 = capitol_year3 
test capitol_year1 = capitol_year4 
test capitol_year1 = capitol_year5 
test capitol_year1 = capitol_year6 
test capitol_year1 = capitol_year7 
test capitol_year1 = capitol_year8 
test capitol_year1 = capitol_year9 
test capitol_year1 = capitol_year10 
test capitol_year1 = capitol_year11

test ln_musfup_year1 = ln_musfup_year2 = ln_musfup_year3 = ln_musfup_year4 = ln_musfup_year5 = ln_musfup_year6 = ln_musfup_year7 = ln_musfup_year8 = ln_musfup_year9 = ln_musfup_year10 = ln_musfup_year11
test ln_musfup_year1 = ln_musfup_year2 
test ln_musfup_year1 = ln_musfup_year3 
test ln_musfup_year1 = ln_musfup_year4 
test ln_musfup_year1 = ln_musfup_year5 
test ln_musfup_year1 = ln_musfup_year6 
test ln_musfup_year1 = ln_musfup_year7 
test ln_musfup_year1 = ln_musfup_year8 
test ln_musfup_year1 = ln_musfup_year9
test ln_musfup_year1 = ln_musfup_year10 
test ln_musfup_year1 = ln_musfup_year11

test ln_chrfup_year1 = ln_chrfup_year2 = ln_chrfup_year3 = ln_chrfup_year4 = ln_chrfup_year5 = ln_chrfup_year6 = ln_chrfup_year7 = ln_chrfup_year8 = ln_chrfup_year9 = ln_chrfup_year10 = ln_chrfup_year11
test ln_chrfup_year1 = ln_chrfup_year2 
test ln_chrfup_year1 = ln_chrfup_year3 
test ln_chrfup_year1 = ln_chrfup_year4 
test ln_chrfup_year1 = ln_chrfup_year5 
test ln_chrfup_year1 = ln_chrfup_year6 
test ln_chrfup_year1 = ln_chrfup_year7 
test ln_chrfup_year1 = ln_chrfup_year8
test ln_chrfup_year1 = ln_chrfup_year9 
test ln_chrfup_year1 = ln_chrfup_year10 
test ln_chrfup_year1 = ln_chrfup_year11
testparm tdum*


/*----------------------------------------------------------------------------------*/
/*-- including FE - for the time-invariant variable keep 800 as a reference group --*/
/*----------------------------------------------------------------------------------*/
drop *_year*
forvalues X = 2/11 {
gen grond_year`X' = grond * tdum`X'
gen river_year`X' = river *tdum`X'
gen rom_road_nohub_year`X' = rom_road_nohub * tdum`X'
gen caravan_hub_year`X' = caravan_hub * tdum`X'
gen caravan_nohub_year`X' = caravan_nohub *tdum`X'
gen hub_3rr_year`X' = hub_3rr * tdum`X'
}

forvalues X = 1/11 {
gen sea_year`X' = sea * tdum`X'
gen capitol_year`X' =  capitol * tdum`X'
gen ln_musfup_year`X' = ln_musfup  * tdum`X'
gen ln_chrfup_year`X' = ln_chrfup  * tdum`X'
}


/*muslim cities*/
/*------ TABLE 2a versie 1stRR--------*/
xtreg ln_citypop sea river rom_road*year* hub_3rr caravan_nohub caravan_hub*year* bishop archbishop capitol*year* university muslim ln_musfup*year* ln_chrfup*year* ln_elev ln_rugg10 grond  plundered ln_dmecca muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==1,cluster(indicator) fe
testparm rom_road*
testparm caravan_hub*
test capitol_year1 = capitol_year2 = capitol_year3 = capitol_year4 = capitol_year5 = capitol_year6 = capitol_year7 = capitol_year8 = capitol_year9 = capitol_year10 = capitol_year11
test capitol_year1 = capitol_year2 
test capitol_year1 = capitol_year3 
test capitol_year1 = capitol_year4 
test capitol_year1 = capitol_year5 
test capitol_year1 = capitol_year6 
test capitol_year1 = capitol_year7 
test capitol_year1 = capitol_year8 
test capitol_year1 = capitol_year9 
test capitol_year1 = capitol_year10 
test capitol_year1 = capitol_year11

test ln_musfup_year1 = ln_musfup_year2 = ln_musfup_year3 = ln_musfup_year4 = ln_musfup_year5 = ln_musfup_year6 = ln_musfup_year7 = ln_musfup_year8 = ln_musfup_year9 = ln_musfup_year10 = ln_musfup_year11
test ln_musfup_year1 = ln_musfup_year2 
test ln_musfup_year1 = ln_musfup_year3 
test ln_musfup_year1 = ln_musfup_year4 
test ln_musfup_year1 = ln_musfup_year5 
test ln_musfup_year1 = ln_musfup_year6 
test ln_musfup_year1 = ln_musfup_year7 
test ln_musfup_year1 = ln_musfup_year8 
test ln_musfup_year1 = ln_musfup_year9
test ln_musfup_year1 = ln_musfup_year10 
test ln_musfup_year1 = ln_musfup_year11

test ln_chrfup_year1 = ln_chrfup_year2 = ln_chrfup_year3 = ln_chrfup_year4 = ln_chrfup_year5 = ln_chrfup_year6 = ln_chrfup_year7 = ln_chrfup_year8 = ln_chrfup_year9 = ln_chrfup_year10 = ln_chrfup_year11
test ln_chrfup_year1 = ln_chrfup_year2 
test ln_chrfup_year1 = ln_chrfup_year3 
test ln_chrfup_year1 = ln_chrfup_year4 
test ln_chrfup_year1 = ln_chrfup_year5 
test ln_chrfup_year1 = ln_chrfup_year6 
test ln_chrfup_year1 = ln_chrfup_year7 
test ln_chrfup_year1 = ln_chrfup_year8
test ln_chrfup_year1 = ln_chrfup_year9 
test ln_chrfup_year1 = ln_chrfup_year10 
test ln_chrfup_year1 = ln_chrfup_year11
testparm tdum*

/*------- TABLE 2b versie 1stRR ---------*/
xtreg ln_citypop sea_y* river_y* rom_road_nohub hub_3rr caravan_nohub caravan_hub bishop archbishop capitol*year* university muslim ln_musfup*year* ln_chrfup*year* ln_elev ln_rugg10 grond  plundered ln_drome ln_dbyzantium muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==0,cluster(indicator) fe
test sea_year1 = sea_year2 = sea_year3 = sea_year4 = sea_year5 = sea_year6 = sea_year7 = sea_year8 = sea_year9 = sea_year10 = sea_year11
testparm river*

test capitol_year1 = capitol_year2 = capitol_year3 = capitol_year4 = capitol_year5 = capitol_year6 = capitol_year7 = capitol_year8 = capitol_year9 = capitol_year10 = capitol_year11
test capitol_year1 = capitol_year2 
test capitol_year1 = capitol_year3 
test capitol_year1 = capitol_year4 
test capitol_year1 = capitol_year5 
test capitol_year1 = capitol_year6 
test capitol_year1 = capitol_year7 
test capitol_year1 = capitol_year8 
test capitol_year1 = capitol_year9 
test capitol_year1 = capitol_year10 
test capitol_year1 = capitol_year11

test ln_musfup_year1 = ln_musfup_year2 = ln_musfup_year3 = ln_musfup_year4 = ln_musfup_year5 = ln_musfup_year6 = ln_musfup_year7 = ln_musfup_year8 = ln_musfup_year9 = ln_musfup_year10 = ln_musfup_year11
test ln_musfup_year1 = ln_musfup_year2 
test ln_musfup_year1 = ln_musfup_year3 
test ln_musfup_year1 = ln_musfup_year4 
test ln_musfup_year1 = ln_musfup_year5 
test ln_musfup_year1 = ln_musfup_year6 
test ln_musfup_year1 = ln_musfup_year7 
test ln_musfup_year1 = ln_musfup_year8 
test ln_musfup_year1 = ln_musfup_year9
test ln_musfup_year1 = ln_musfup_year10 
test ln_musfup_year1 = ln_musfup_year11

test ln_chrfup_year1 = ln_chrfup_year2 = ln_chrfup_year3 = ln_chrfup_year4 = ln_chrfup_year5 = ln_chrfup_year6 = ln_chrfup_year7 = ln_chrfup_year8 = ln_chrfup_year9 = ln_chrfup_year10 = ln_chrfup_year11
test ln_chrfup_year1 = ln_chrfup_year2 
test ln_chrfup_year1 = ln_chrfup_year3 
test ln_chrfup_year1 = ln_chrfup_year4 
test ln_chrfup_year1 = ln_chrfup_year5 
test ln_chrfup_year1 = ln_chrfup_year6 
test ln_chrfup_year1 = ln_chrfup_year7 
test ln_chrfup_year1 = ln_chrfup_year8
test ln_chrfup_year1 = ln_chrfup_year9 
test ln_chrfup_year1 = ln_chrfup_year10 
test ln_chrfup_year1 = ln_chrfup_year11
testparm tdum*

/*RR2 - sea over time Muslim */
drop sea_year1
*muslim
xtreg ln_citypop sea_y* river rom_road*year* hub_3rr caravan_nohub caravan_hub*year* bishop archbishop capitol*year* university muslim ln_musfup*year* ln_chrfup*year* ln_elev ln_rugg10 grond  plundered ln_dmecca muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==1,cluster(indicator) fe
testparm sea*
testparm rom_road*
testparm caravan_hub*
test capitol_year1 = capitol_year2 = capitol_year3 = capitol_year4 = capitol_year5 = capitol_year6 = capitol_year7 = capitol_year8 = capitol_year9 = capitol_year10 = capitol_year11
test capitol_year1 = capitol_year2 
test capitol_year1 = capitol_year3 
test capitol_year1 = capitol_year4 
test capitol_year1 = capitol_year5 
test capitol_year1 = capitol_year6 
test capitol_year1 = capitol_year7 
test capitol_year1 = capitol_year8 
test capitol_year1 = capitol_year9 
test capitol_year1 = capitol_year10 
test capitol_year1 = capitol_year11

test ln_musfup_year1 = ln_musfup_year2 = ln_musfup_year3 = ln_musfup_year4 = ln_musfup_year5 = ln_musfup_year6 = ln_musfup_year7 = ln_musfup_year8 = ln_musfup_year9 = ln_musfup_year10 = ln_musfup_year11
test ln_musfup_year1 = ln_musfup_year2 
test ln_musfup_year1 = ln_musfup_year3 
test ln_musfup_year1 = ln_musfup_year4 
test ln_musfup_year1 = ln_musfup_year5 
test ln_musfup_year1 = ln_musfup_year6 
test ln_musfup_year1 = ln_musfup_year7 
test ln_musfup_year1 = ln_musfup_year8 
test ln_musfup_year1 = ln_musfup_year9
test ln_musfup_year1 = ln_musfup_year10 
test ln_musfup_year1 = ln_musfup_year11

test ln_chrfup_year1 = ln_chrfup_year2 = ln_chrfup_year3 = ln_chrfup_year4 = ln_chrfup_year5 = ln_chrfup_year6 = ln_chrfup_year7 = ln_chrfup_year8 = ln_chrfup_year9 = ln_chrfup_year10 = ln_chrfup_year11
test ln_chrfup_year1 = ln_chrfup_year2 
test ln_chrfup_year1 = ln_chrfup_year3 
test ln_chrfup_year1 = ln_chrfup_year4 
test ln_chrfup_year1 = ln_chrfup_year5 
test ln_chrfup_year1 = ln_chrfup_year6 
test ln_chrfup_year1 = ln_chrfup_year7 
test ln_chrfup_year1 = ln_chrfup_year8
test ln_chrfup_year1 = ln_chrfup_year9 
test ln_chrfup_year1 = ln_chrfup_year10 
test ln_chrfup_year1 = ln_chrfup_year11
testparm tdum*


*christian
xtreg ln_citypop sea_y* river_y* rom_road_nohub hub_3rr caravan_nohub caravan_hub bishop archbishop capitol*year* university muslim ln_musfup*year* ln_chrfup*year* ln_elev ln_rugg10 grond  plundered ln_drome ln_dbyzantium muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==0,cluster(indicator) fe
testparm sea*
testparm river*
test capitol_year1 = capitol_year2 = capitol_year3 = capitol_year4 = capitol_year5 = capitol_year6 = capitol_year7 = capitol_year8 = capitol_year9 = capitol_year10 = capitol_year11
test capitol_year1 = capitol_year2 
test capitol_year1 = capitol_year3 
test capitol_year1 = capitol_year4 
test capitol_year1 = capitol_year5 
test capitol_year1 = capitol_year6 
test capitol_year1 = capitol_year7 
test capitol_year1 = capitol_year8 
test capitol_year1 = capitol_year9 
test capitol_year1 = capitol_year10 
test capitol_year1 = capitol_year11

test ln_musfup_year1 = ln_musfup_year2 = ln_musfup_year3 = ln_musfup_year4 = ln_musfup_year5 = ln_musfup_year6 = ln_musfup_year7 = ln_musfup_year8 = ln_musfup_year9 = ln_musfup_year10 = ln_musfup_year11
test ln_musfup_year1 = ln_musfup_year2 
test ln_musfup_year1 = ln_musfup_year3 
test ln_musfup_year1 = ln_musfup_year4 
test ln_musfup_year1 = ln_musfup_year5 
test ln_musfup_year1 = ln_musfup_year6 
test ln_musfup_year1 = ln_musfup_year7 
test ln_musfup_year1 = ln_musfup_year8 
test ln_musfup_year1 = ln_musfup_year9
test ln_musfup_year1 = ln_musfup_year10 
test ln_musfup_year1 = ln_musfup_year11

test ln_chrfup_year1 = ln_chrfup_year2 = ln_chrfup_year3 = ln_chrfup_year4 = ln_chrfup_year5 = ln_chrfup_year6 = ln_chrfup_year7 = ln_chrfup_year8 = ln_chrfup_year9 = ln_chrfup_year10 = ln_chrfup_year11
test ln_chrfup_year1 = ln_chrfup_year2 
test ln_chrfup_year1 = ln_chrfup_year3 
test ln_chrfup_year1 = ln_chrfup_year4 
test ln_chrfup_year1 = ln_chrfup_year5 
test ln_chrfup_year1 = ln_chrfup_year6 
test ln_chrfup_year1 = ln_chrfup_year7 
test ln_chrfup_year1 = ln_chrfup_year8
test ln_chrfup_year1 = ln_chrfup_year9 
test ln_chrfup_year1 = ln_chrfup_year10 
test ln_chrfup_year1 = ln_chrfup_year11
testparm tdum*
/*also against 900*/
test ln_chrfup_year2 = ln_chrfup_year3 
test ln_chrfup_year2 = ln_chrfup_year4 
test ln_chrfup_year2 = ln_chrfup_year5 
test ln_chrfup_year2 = ln_chrfup_year6 
test ln_chrfup_year2 = ln_chrfup_year7 
test ln_chrfup_year2 = ln_chrfup_year8
test ln_chrfup_year2 = ln_chrfup_year9 
test ln_chrfup_year2 = ln_chrfup_year10 
test ln_chrfup_year2 = ln_chrfup_year11
/*also against 1000*/
test ln_chrfup_year3 = ln_chrfup_year4 
test ln_chrfup_year3 = ln_chrfup_year5 
test ln_chrfup_year3 = ln_chrfup_year6 
test ln_chrfup_year3 = ln_chrfup_year7 
test ln_chrfup_year3 = ln_chrfup_year8
test ln_chrfup_year3 = ln_chrfup_year9 
test ln_chrfup_year3 = ln_chrfup_year10 
test ln_chrfup_year3 = ln_chrfup_year11



*muslim zonder damietta
xtreg ln_citypop sea_y* river rom_road*year* hub_3rr caravan_nohub caravan_hub*year* bishop archbishop capitol*year* university muslim ln_musfup*year* ln_chrfup*year* ln_elev ln_rugg10 grond  plundered ln_dmecca muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==1 & damietta==0,cluster(indicator) fe
testparm sea*
testparm rom_road*
testparm caravan_hub*
test capitol_year1 = capitol_year2 = capitol_year3 = capitol_year4 = capitol_year5 = capitol_year6 = capitol_year7 = capitol_year8 = capitol_year9 = capitol_year10 = capitol_year11
test capitol_year1 = capitol_year2 
test capitol_year1 = capitol_year3 
test capitol_year1 = capitol_year4 
test capitol_year1 = capitol_year5 
test capitol_year1 = capitol_year6 
test capitol_year1 = capitol_year7 
test capitol_year1 = capitol_year8 
test capitol_year1 = capitol_year9 
test capitol_year1 = capitol_year10 
test capitol_year1 = capitol_year11

test ln_musfup_year1 = ln_musfup_year2 = ln_musfup_year3 = ln_musfup_year4 = ln_musfup_year5 = ln_musfup_year6 = ln_musfup_year7 = ln_musfup_year8 = ln_musfup_year9 = ln_musfup_year10 = ln_musfup_year11
test ln_musfup_year1 = ln_musfup_year2 
test ln_musfup_year1 = ln_musfup_year3 
test ln_musfup_year1 = ln_musfup_year4 
test ln_musfup_year1 = ln_musfup_year5 
test ln_musfup_year1 = ln_musfup_year6 
test ln_musfup_year1 = ln_musfup_year7 
test ln_musfup_year1 = ln_musfup_year8 
test ln_musfup_year1 = ln_musfup_year9
test ln_musfup_year1 = ln_musfup_year10 
test ln_musfup_year1 = ln_musfup_year11

test ln_chrfup_year1 = ln_chrfup_year2 = ln_chrfup_year3 = ln_chrfup_year4 = ln_chrfup_year5 = ln_chrfup_year6 = ln_chrfup_year7 = ln_chrfup_year8 = ln_chrfup_year9 = ln_chrfup_year10 = ln_chrfup_year11
test ln_chrfup_year1 = ln_chrfup_year2 
test ln_chrfup_year1 = ln_chrfup_year3 
test ln_chrfup_year1 = ln_chrfup_year4 
test ln_chrfup_year1 = ln_chrfup_year5 
test ln_chrfup_year1 = ln_chrfup_year6 
test ln_chrfup_year1 = ln_chrfup_year7 
test ln_chrfup_year1 = ln_chrfup_year8
test ln_chrfup_year1 = ln_chrfup_year9 
test ln_chrfup_year1 = ln_chrfup_year10 
test ln_chrfup_year1 = ln_chrfup_year11
testparm tdum*





drop *_year*



/*------------------------------------------------------------------------------*/
/*-------------------------------- TABLE A6 ------------------------------------*/
/*------------------------------------------------------------------------------*/

/*cities as soon as 5000 inhabitants*/
/*column 1 Table A6*/
xtreg ln_citypop_le5 sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_musfup ln_chrfup ln_elev ln_rugg10 grond  plundered ln_dmecca ln_drome ln_dbyzantium muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum*,cluster(indicator)
testparm tdum*
testparm cdum*
testparm ecodum*
/*column 3 Table A6*/
xtreg ln_citypop_le5 sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_musfup ln_chrfup ln_elev ln_rugg10 grond  plundered ln_drome ln_dbyzantium muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==0,cluster(indicator)
testparm tdum*
testparm cdum*
testparm ecodum*
/*column 2 Table A6*/
xtreg ln_citypop_le5 sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_musfup ln_chrfup ln_elev ln_rugg10 grond  plundered ln_dmecca muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==1,cluster(indicator)
testparm tdum*
testparm cdum*
testparm ecodum*



/*-----------------------------------------------------------------*/
/*-------------------------- Table A5 -----------------------------*/
/*robustness for different interaction proxies than Urban Potential*/
/*-----------------------------------------------------------------*/

/*distance + size nearest muslim/christian city*/
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_dmus_near_le10 ln_dchr_near_le10 ln_sizemus_near_le10 ln_sizechr_near_le10 ln_elev ln_rugg10 grond  plundered ln_drome ln_dbyzantium muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==0, cluster(indicator)
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_dmus_near_le10 ln_dchr_near_le10 ln_sizemus_near_le10 ln_sizechr_near_le10 ln_elev ln_rugg10 grond  plundered ln_dmecca muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==1, cluster(indicator)

/*weighted FUP a la De Vries (1980)*/
gen ln_musfup_DV = ln(musfup_devries)
gen ln_chrfup_DV = ln(chrfup_devries)
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_musfup_DV ln_chrfup_DV ln_elev ln_rugg10 grond  plundered ln_drome ln_dbyzantium muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==0,cluster(indicator)
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_musfup_DV ln_chrfup_DV ln_elev ln_rugg10 grond  plundered ln_dmecca muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==1,cluster(indicator)

/*UP not delineated by religion*/
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_fup ln_elev ln_rugg10 grond  plundered ln_drome ln_dbyzantium muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==0,cluster(indicator)
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_fup ln_elev ln_rugg10 grond  plundered ln_dmecca muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==1,cluster(indicator)

/*UP not delineated by religion*/
/*plus: presence of christian or muslim city within distance bands*/
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_fup le10*s le10*r ln_elev ln_rugg10 grond  plundered ln_drome ln_dbyzantium muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==0,cluster(indicator)
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_fup le10*s le10*r ln_elev ln_rugg10 grond  plundered ln_dmecca muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==1,cluster(indicator)

/*UP not delineated by religion*/
/*plus: total urban population (christian or muslim) within distance bands*/
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_fup po*le10*s po*le10*r ln_elev ln_rugg10 grond  plundered ln_drome ln_dbyzantium muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==0,cluster(indicator)
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_fup po*le10*s po*le10*r ln_elev ln_rugg10 grond  plundered ln_dmecca muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==1,cluster(indicator)

/*UP not delineated by religion*/
/*plus: nr. of christian or muslim cities within distance bands*/
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_fup ci*le10*s ci*le10*r ln_elev ln_rugg10 grond  plundered ln_drome ln_dbyzantium muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==0,cluster(indicator)
xtreg ln_citypop sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub  bishop archbishop capitol university muslim ln_fup ci*le10*s ci*le10*r ln_elev ln_rugg10 grond  plundered ln_dmecca  muslim*holy* chr*holy* madr*01 ecodum2 ecodum3 ecodum4 ecodum5 cdum* tdum* if muslim==1,cluster(indicator)








/*------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------------------*/
/*----- descriptives city size t-1 for non-capitols t, capitols t given no capital t-1 -----*/
/*----- similar for communes, (arch)bishops, parliaments, universities, madrassas, etc -----*/
/*----- nrs. mentioned in several footnotes throughout the text ----------------------------*/
/*------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------------------*/

sort indicator year
by indicator: gen L_capitol = capitol[_n-1]
by indicator: gen L_commune_final = commune_final[_n-1]
by indicator: gen L_citypop_le10 = citypop_le10[_n-1] if citypop_le10[_n-1]>=10
by indicator: gen L_university = university[_n-1]
by indicator: gen L_madrassa01 = madrassa01[_n-1]
by indicator: gen L_parl_act = parl_act[_n-1]
by indicator: gen L_bishop = bishop[_n-1]
by indicator: gen L_archbishop = archbishop[_n-1]


/*universities - whole sample*/
tab L_university university if citypop_le10>=10, sum(L_citypop_le10)
reg L_citypop_le10 university if L_university==0 & citypop_le10>=10, cluster(indicator)

/*madrassas - christian and muslim sample separately*/
tab L_madrassa01 madrassa01 if citypop_le10>=10 & muslim==1, sum(L_citypop_le10)
reg L_citypop_le10 madrassa01 if L_madrassa01==0 & citypop_le10>=10 & muslim==1, cluster(indicator)

/*capitol cities - christian and muslim sample separately*/
tab L_capitol capitol if citypop_le10>=10 & muslim==1, sum(L_citypop_le10)
reg L_citypop_le10 capitol if L_capitol==0 & citypop_le10>=10 & muslim==1, cluster(indicator)

tab L_capitol capitol if citypop_le10>=10 & muslim==0, sum(L_citypop_le10)
reg L_citypop_le10 capitol if L_capitol==0 & citypop_le10>=10 & muslim==0, cluster(indicator)

/*bishops - christian and muslim sample separately*/
tab L_bishop bishop if citypop_le10>=10 & muslim==1, sum(L_citypop_le10)
reg L_citypop_le10 bishop if L_bishop==0 & citypop_le10>=10 & muslim==1, cluster(indicator)

tab L_bishop bishop if citypop_le10>=10 & muslim==0, sum(L_citypop_le10)
reg L_citypop_le10 bishop if L_bishop==0 & citypop_le10>=10 & muslim==0, cluster(indicator)

/*archbishops - christian and muslim sample separately*/
tab L_archbishop archbishop if citypop_le10>=10 & muslim==0, sum(L_citypop_le10)
reg L_citypop_le10 archbishop if L_archbishop==0 & citypop_le10>=10 & muslim==0, cluster(indicator)

*--- note: only city gaining archbishop status while muslim is Tyrus (Lebanon) in 1100, Tyrus was conquered by crusader forces in 1124
tab L_archbishop archbishop if citypop_le10>=10 & muslim==1, sum(L_citypop_le10)
reg L_citypop_le10 archbishop if L_archbishop==0 & citypop_le10>=10 & muslim==1, cluster(indicator)


/*parliaments and communes - christian only*/
tab L_parl_act parl_act if citypop_le10>=10 & muslim==1, sum(L_citypop_le10)
reg L_citypop_le10 parl_act if L_parl_act==0 & citypop_le10>=10 & muslim==1, cluster(indicator)

tab L_commune_final commune_final if citypop_le10>=10 & muslim==0, sum(L_citypop_le10)
reg L_citypop_le10 commune_final if L_commune_final==0 & citypop_le10>=10 & muslim==0, cluster(indicator)



/*---------------- TABLE A1: descriptives all cities >= 10000 inhabitants ------------*/
/*all cities*/
sum citypop_le10 sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub bishop archbishop chr*holy* muslim*holy*  capitol university madr*01 plundered ln_musfup ln_chrfup ln_fup muslim dmecca drome dbyzantium elevation_m rugg10 grond  ecozones  d_nearest_muslim d_nearest_christian  distance_nearest_muslim_le10 distance_nearest_christian_le101 commune_final  parl_act D_largestate free_prince_dls me_na if citypop_le10>=10
/*Christian and Muslim cities separately*/
sort muslim
by muslim: sum citypop_le10 sea river rom_road_nohub hub_3rr caravan_nohub caravan_hub bishop archbishop chr*holy* muslim*holy*  capitol university madr*01 plundered ln_musfup ln_chrfup ln_fup muslim dmecca drome dbyzantium elevation_m rugg10 grond  ecozones  d_nearest_muslim d_nearest_christian  distance_nearest_muslim_le10 distance_nearest_christian_le101 commune_final  parl_act D_largestate free_prince_dls me_na if citypop_le10>=10


/*---------------- TABLE A8: geography descriptives Europe and ME & NA ------------*/
sort me_na
by me_na: sum elevation_m rugg10 grond ecozones if year==800

/*---------------- TABLE A9: largest cities by century ----------------*/
/*this actually shows more, i.e. by century all names of cities (including population nrs.) >= 90k inhabitants */
sort year citypop_le10
by year: tab city if citypop_le10>=90, sum(citypop_le10)


