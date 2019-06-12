use "C:\Users\Owner\Dropbox\Diversity\GHZ_Replication_Data.dta", clear



**** TABLE 2

*** MODEL 1: OLS/NW
estimates clear
xi: newey  Polity4_imp_F Religious_fractionaliz_Alesina  elf Muslim GDPpc_ln_07_imp  Urban_Pop_WDI_07_imp  pop_ln Polity4_imp_geo Latitude_ln Landlock Island Land_Area_WDI_07_epo_ln Protestant  English_legal_origin European_language   Oil_production_MH_pc Africa LatinAm WestEurope Asia MiddleEast i.Year, force lag(1)
estimates store model1

esttab * using full_model.rtf, replace brackets star(* 0.10 ** 0.05 *** 0.01) b(3) se drop(_IYear* o.*) nogaps compress

predict Polity4_imp_Fp if e(sample) 
corr Polity4_imp_F Polity4_imp_Fp if e(sample) 
di r(rho)^2

margins, at(Religious_fractionaliz_Alesina = (0(0.1)1) )atmeans
margins, at(elf = (0(0.1)1) )atmeans

	
*** MODEL 2: NET IMMIGRANTS PER CAPITA & CIVIL WAR YEARS
xi: newey  Polity4_imp_F elf NetImmigrantsPC CuWars Muslim GDPpc_ln_07_imp  Religious_fractionaliz_Alesina Urban_Pop_WDI_07_imp  pop_ln Polity4_imp_geo Latitude_ln Landlock Island Land_Area_WDI_07_epo_ln Protestant  English_legal_origin European_language   Oil_production_MH_pc Africa LatinAm WestEurope Asia MiddleEast i.Year, lag(1) force
drop Polity4_imp_Fp 
predict Polity4_imp_Fp if e(sample) 
corr Polity4_imp_F Polity4_imp_Fp if e(sample) 
di r(rho)^2


*** MODEL 3: MINIMAL MODEL
xi: newey  Polity4_imp_F elf Religious_fractionaliz_Alesina   Latitude_ln  Island Muslim Protestant Polity4_imp_geo, lag(1) force
drop Polity4_imp_Fp 
predict Polity4_imp_Fp if e(sample) 
corr Polity4_imp_F Polity4_imp_Fp if e(sample) 
di r(rho)^2


*** MODEL 4: NON-OECD
xi: newey  Polity4_imp_F elf Muslim GDPpc_ln_07_imp  Religious_fractionaliz_Alesina Urban_Pop_WDI_07_imp  pop_ln Polity4_imp_geo Latitude_ln Landlock Island Land_Area_WDI_07_epo_ln Protestant  English_legal_origin European_language   Oil_production_MH_pc Africa LatinAm WestEurope Asia MiddleEast i.Year if OECD == 0, lag(1) force
drop Polity4_imp_Fp 
predict Polity4_imp_Fp if e(sample) 
corr Polity4_imp_F Polity4_imp_Fp if e(sample) 
di r(rho)^2


*** MODELS 5 AND 6 -- SEE BELOW

*** MODEL 7: RANDOM EFFECTS
estimates clear

xi: xtreg Polity4_imp_F elf Muslim GDPpc_ln_07_imp  Religious_fractionaliz_Alesina Urban_Pop_WDI_07_imp  pop_ln Polity4_imp_geo Latitude_ln Landlock Island Land_Area_WDI_07_epo_ln Protestant  English_legal_origin European_language   Oil_production_MH_pc Africa LatinAm WestEurope Asia MiddleEast i.Year, re
estimates store model1
drop Polity4_imp_Fp 
predict Polity4_imp_Fp if e(sample) 
corr Polity4_imp_F Polity4_imp_Fp if e(sample) 
di r(rho)^2



*** MODEL 8: LAGGED Y
xi: newey  Polity4_imp_F L1.Polity4_imp_F elf Muslim GDPpc_ln_07_imp  Religious_fractionaliz_Alesina Urban_Pop_WDI_07_imp  pop_ln Polity4_imp_geo Latitude_ln Landlock Island Land_Area_WDI_07_epo_ln Protestant  English_legal_origin European_language   Oil_production_MH_pc Africa LatinAm WestEurope Asia MiddleEast i.Year, lag(1) force
drop Polity4_imp_Fp 
predict Polity4_imp_Fp if e(sample) 
corr Polity4_imp_F Polity4_imp_Fp if e(sample) 
di r(rho)^2


*** MODEL 9: FIXED EFFECTS 
set matsize 800
 xi: newey Polity4_imp_F elf relfrac_cow GDPpc_ln_07_imp Urban_Pop_WDI_07_imp Polity4_imp_geo Oil_production_MH_pc i.Year i.Banks, lag(1) force noomitted
estimates store model1
drop Polity4_imp_Fp 
predict Polity4_imp_Fp if e(sample) 
corr Polity4_imp_F Polity4_imp_Fp if e(sample) 
di r(rho)^2


	
******* TABLE 3: ALTERNATIVE DEMOCRACY MEASURES	
	

*** MODEL 1: VANHANEN COMPETITION
xi: newey   Competition_Vanhanen_100_F elf Muslim GDPpc_ln_07_imp  Religious_fractionaliz_Alesina Urban_Pop_WDI_07_imp  pop_ln Polity4_imp_geo Latitude_ln Landlock Island Land_Area_WDI_07_epo_ln Protestant  English_legal_origin European_language   Oil_production_MH_pc Africa LatinAm WestEurope Asia MiddleEast i.Year, lag(1) force
predict Competition_Vanhanen_100_Fp if e(sample) 
corr Competition_Vanhanen_100_F Competition_Vanhanen_100_Fp if e(sample) 
di r(rho)^2




*** MODEL 2: COPPEDGE CONTESTATION
xi: newey   Contestation_F elf Muslim GDPpc_ln_07_imp  Religious_fractionaliz_Alesina Urban_Pop_WDI_07_imp  pop_ln Polity4_imp_geo Latitude_ln Landlock Island Land_Area_WDI_07_epo_ln Protestant  English_legal_origin European_language   Oil_production_MH_pc Africa LatinAm WestEurope Asia MiddleEast i.Year, lag(1) force
drop Contestation_Fp
predict Contestation_Fp if e(sample) 
corr Contestation_F Contestation_Fp if e(sample) 
di r(rho)^2



*** MODEL 3: FH POLITICAL RIGHTS
xi: newey   Pol_rights_FH_neg_F elf Muslim GDPpc_ln_07_imp  Religious_fractionaliz_Alesina Urban_Pop_WDI_07_imp  pop_ln Polity4_imp_geo Latitude_ln Landlock Island Land_Area_WDI_07_epo_ln Protestant  English_legal_origin European_language   Oil_production_MH_pc Africa LatinAm WestEurope Asia MiddleEast i.Year, lag(1) force
drop Pol_rights_FH_neg_Fp
predict Pol_rights_FH_neg_Fp if e(sample)
corr Pol_rights_FH_neg_F Pol_rights_FH_neg_Fp if e(sample) 
di r(rho)^2


*** MODEL 4: FH CIVIL LIBERTIES
xi: newey   FH_Civil_Liberties_F elf Muslim GDPpc_ln_07_imp  Religious_fractionaliz_Alesina Urban_Pop_WDI_07_imp  pop_ln Polity4_imp_geo Latitude_ln Landlock Island Land_Area_WDI_07_epo_ln Protestant  English_legal_origin European_language   Oil_production_MH_pc Africa LatinAm WestEurope Asia MiddleEast i.Year, lag(1) force
drop FH_Civil_Liberties_Fp
predict FH_Civil_Liberties_Fp if e(sample) 
corr FH_Civil_Liberties_F FH_Civil_Liberties_Fp if e(sample) 
di r(rho)^2




*** MODEL 5: UDS MEASURE
xi: newey  UDS_100 elf Muslim GDPpc_ln_07_imp  Religious_fractionaliz_Alesina Urban_Pop_WDI_07_imp  pop_ln Polity4_imp_geo Latitude_ln Landlock Island Land_Area_WDI_07_epo_ln Protestant  English_legal_origin European_language   Oil_production_MH_pc Africa LatinAm WestEurope Asia MiddleEast i.Year, lag(1) force
drop UDS_100p
predict UDS_100p if e(sample) 
corr UDS_100 UDS_100p if e(sample) 
di r(rho)^2






*************** TABLE 4 -- ALTERNATIVE DIVERSITY MEASURES

*Rescale all diversity measures from (in principle) 0-1;
replace Ethnolinguistic_fract_imp = 0 if Ethnolinguistic_fract_imp<0
replace Ethnolinguistic_homog_Vanhanen = Ethnolinguistic_homog_Vanhanen/100
replace lnnmbrlang_percntry = lnnmbrlang_percntry/6.136
replace Ethnic_homogeneity_Vanhanen = Ethnic_homogeneity_Vanhanen / 100

*1. Benchmark Ethnoling fract (EPR) - elf
xi: newey  Polity4_imp_F elf GDPpc_ln_07_imp Urban_Pop_WDI_07_imp Polity4_imp_geo pop_ln  Oil_production_MH_pc  English_legal_origin  European_language Religious_fract_Alesina Muslim Protestant Land_Area_WDI_07_epo_ln Landlock Latitude_ln Island Africa Asia LatinAm MiddleEast WestEurope i.Year,  force lag(1)


*2. Ethnoling fract (Easterly/Levine) - Ethnolinguistic_fract_imp
xi: newey Polity4_imp_F Ethnolinguistic_fract_imp GDPpc_ln_07_imp Urban_Pop_WDI_07_imp Polity4_imp_geo pop_ln  Oil_production_MH_pc  English_legal_origin  European_language Religious_fract_Alesina Muslim Protestant Land_Area_WDI_07_epo_ln Landlock Latitude_ln Island Africa Asia LatinAm MiddleEast WestEurope i.Year,  lag(1) force


*3. Ethnoling homog (Vanhanen) - Ethnolinguistic_homog_Vanhanen
xi: newey Polity4_imp_F Ethnolinguistic_homog_Vanhanen GDPpc_ln_07_imp Urban_Pop_WDI_07_imp Polity4_imp_geo pop_ln  Oil_production_MH_pc English_legal_origin  European_language Religious_fract_Alesina Muslim Protestant Land_Area_WDI_07_epo_ln Landlock Latitude_ln Island Africa Asia LatinAm MiddleEast WestEurope i.Year,  lag(1) force


*4. Ethnoling fract (Fearon) - elf_Fearon2
xi: newey Polity4_imp_F elf_Fearon2 GDPpc_ln_07_imp Urban_Pop_WDI_07_imp Polity4_imp_geo pop_ln  Oil_production_MH_pc English_legal_origin  European_language Religious_fract_Alesina Muslim Protestant Land_Area_WDI_07_epo_ln Landlock Latitude_ln Island Africa Asia LatinAm MiddleEast WestEurope i.Year,  lag(1) force


*5. Largest group (Fearon) - plural_Fearon2
xi: newey Polity4_imp_F plural_Fearon2 GDPpc_ln_07_imp Urban_Pop_WDI_07_imp Polity4_imp_geo pop_ln  Oil_production_MH_pc English_legal_origin  European_language Religious_fract_Alesina Muslim Protestant Land_Area_WDI_07_epo_ln Landlock Latitude_ln Island Africa Asia LatinAm MiddleEast WestEurope i.Year,  lag(1) force


*6. Cultural fract (Fearon) - cdiv_Fearon2
xi: newey Polity4_imp_F cdiv_Fearon2 GDPpc_ln_07_imp Urban_Pop_WDI_07_imp Polity4_imp_geo pop_ln  Oil_production_MH_pc English_legal_origin  European_language Religious_fract_Alesina Muslim Protestant Land_Area_WDI_07_epo_ln Landlock Latitude_ln Island Africa Asia LatinAm MiddleEast WestEurope i.Year,  lag(1) force


*7. Ethnic homog (Vanhanen) - Ethnic_homogeneity_Vanhanen
xi: newey Polity4_imp_F Ethnic_homogeneity_Vanhanen GDPpc_ln_07_imp Urban_Pop_WDI_07_imp Polity4_imp_geo pop_ln  Oil_production_MH_pc English_legal_origin  European_language Religious_fract_Alesina Muslim Protestant Land_Area_WDI_07_epo_ln Landlock Latitude_ln Island Africa Asia LatinAm MiddleEast WestEurope i.Year,  lag(1) force


*8. Ethnic fract (Alesina) - Ethnic_fractionaliz_Alesina
xi: newey Polity4_imp_F Ethnic_fractionaliz_Alesina GDPpc_ln_07_imp Urban_Pop_WDI_07_imp Polity4_imp_geo pop_ln  Oil_production_MH_pc English_legal_origin  European_language Religious_fract_Alesina Muslim Protestant Land_Area_WDI_07_epo_ln Landlock Latitude_ln Island Africa Asia LatinAm MiddleEast WestEurope i.Year,  lag(1) force


*9. Ethnic fract (Fearon) - ef_Fearon2
xi: newey Polity4_imp_F ef_Fearon2 GDPpc_ln_07_imp Urban_Pop_WDI_07_imp Polity4_imp_geo pop_ln  Oil_production_MH_pc English_legal_origin  European_language Religious_fract_Alesina Muslim Protestant Land_Area_WDI_07_epo_ln Landlock Latitude_ln Island Africa Asia LatinAm MiddleEast WestEurope i.Year,  lag(1) force


*10. Ethnic fract (R-Querol) - ETHFRAC2_Reynal_Querol
xi: newey Polity4_imp_F ETHFRAC2_Reynal_Querol GDPpc_ln_07_imp Urban_Pop_WDI_07_imp Polity4_imp_geo pop_ln  Oil_production_MH_pc English_legal_origin  European_language Religious_fract_Alesina Muslim Protestant Land_Area_WDI_07_epo_ln Landlock Latitude_ln Island Africa Asia LatinAm MiddleEast WestEurope i.Year,  lag(1) force


*11. Ethnic polar (R-Querol) - ETHPOL2_Reynal_Querol
xi: newey Polity4_imp_F ETHPOL2_Reynal_Querol GDPpc_ln_07_imp Urban_Pop_WDI_07_imp Polity4_imp_geo pop_ln  Oil_production_MH_pc English_legal_origin  European_language Religious_fract_Alesina Muslim Protestant Land_Area_WDI_07_epo_ln Landlock Latitude_ln Island Africa Asia LatinAm MiddleEast WestEurope i.Year,  lag(1) force


*12. Ling fract (Alesina) - Linguistic_fractionaliz_Alesina
xi: newey Polity4_imp_F Linguistic_fractionaliz_Alesina GDPpc_ln_07_imp Urban_Pop_WDI_07_imp Polity4_imp_geo pop_ln  Oil_production_MH_pc English_legal_origin  European_language Religious_fract_Alesina Muslim Protestant  Land_Area_WDI_07_epo_ln Landlock Latitude_ln Island Africa Asia LatinAm MiddleEast WestEurope i.Year,  lag(1) force


*13. Ling hetero 1 (Gunnemark) - Linguistic_heterogen1_Gunnemark
xi: newey Polity4_imp_F Linguistic_heterogen1_Gunnemark GDPpc_ln_07_imp Urban_Pop_WDI_07_imp Polity4_imp_geo pop_ln  Oil_production_MH_pc English_legal_origin  European_language Religious_fract_Alesina Muslim Protestant Land_Area_WDI_07_epo_ln Landlock Latitude_ln Island Africa Asia LatinAm MiddleEast WestEurope i.Year,  lag(1) force


*14. Languages (Michalopoulos) - lnnmbrlang_percntry
xi: newey Polity4_imp_F lnnmbrlang_percntry GDPpc_ln_07_imp Urban_Pop_WDI_07_imp Polity4_imp_geo pop_ln  Oil_production_MH_pc English_legal_origin  European_language Religious_fract_Alesina Muslim Protestant Land_Area_WDI_07_epo_ln Landlock Latitude_ln Island Africa Asia LatinAm MiddleEast WestEurope  i.Year,  lag(1) force


*15. Desmetet al (forthcoming) - elf2
xi: newey Polity4_imp_F elf1 GDPpc_ln_07_imp Urban_Pop_WDI_07_imp Polity4_imp_geo pop_ln  Oil_production_MH_pc English_legal_origin  European_language Religious_fract_Alesina Muslim Protestant Land_Area_WDI_07_epo_ln Landlock Latitude_ln Island Africa Asia LatinAm MiddleEast WestEurope i.Year,  lag(1) force


*16. Desmetet al (forthcoming) - pol2
xi: newey Polity4_imp_F elf2 GDPpc_ln_07_imp Urban_Pop_WDI_07_imp Polity4_imp_geo pop_ln  Oil_production_MH_pc English_legal_origin  European_language Religious_fract_Alesina Muslim Protestant Land_Area_WDI_07_epo_ln Landlock Latitude_ln Island Africa Asia LatinAm MiddleEast WestEurope i.Year,  lag(1) force


*17. First components (PCF) - eth_PCA

xi: newey Polity4_imp_F eth_PCA GDPpc_ln_07_imp Urban_Pop_WDI_07_imp Polity4_imp_geo pop_ln  Oil_production_MH_pc English_legal_origin  European_language Religious_fract_Alesina Muslim Protestant Land_Area_WDI_07_epo_ln Landlock Latitude_ln Island Africa Asia LatinAm MiddleEast WestEurope i.Year,  lag(1) force
xi: newey Polity4_imp_F rel_PCA elf GDPpc_ln_07_imp Urban_Pop_WDI_07_imp Polity4_imp_geo pop_ln  Oil_production_MH_pc English_legal_origin  European_language Muslim Protestant Land_Area_WDI_07_epo_ln Landlock Latitude_ln Island Africa Asia LatinAm MiddleEast WestEurope i.Year,  lag(1) force

*18. R-Q relfrac - RELFRAC2_Reynal_Querol
xi: newey  Polity4_imp_F RELFRAC2_Reynal_Querol elf Muslim GDPpc_ln_07_imp  Urban_Pop_WDI_07_imp  pop_ln Polity4_imp_geo Latitude_ln Landlock Island Land_Area_WDI_07_epo_ln Protestant  English_legal_origin European_language   Oil_production_MH_pc Africa LatinAm WestEurope Asia MiddleEast i.Year, lag(1) force


*19. R-Q relpol - RELPOL2_Reynal_Querol 
xi: newey  Polity4_imp_F RELPOL2_Reynal_Querol  elf Muslim GDPpc_ln_07_imp  Urban_Pop_WDI_07_imp  pop_ln Polity4_imp_geo Latitude_ln Landlock Island Land_Area_WDI_07_epo_ln Protestant  English_legal_origin European_language   Oil_production_MH_pc Africa LatinAm WestEurope Asia MiddleEast i.Year, lag(1) force

*20 COW relfrac - relfrac_cow
xi: newey  Polity4_imp_F relfrac_cow elf Muslim GDPpc_ln_07_imp  Urban_Pop_WDI_07_imp  pop_ln Polity4_imp_geo Latitude_ln Landlock Island Land_Area_WDI_07_epo_ln Protestant  English_legal_origin European_language   Oil_production_MH_pc Africa LatinAm WestEurope Asia MiddleEast i.Year, lag(1) force

*21 PACL relfrac - relfrac_pacl
xi: newey  Polity4_imp_F relfrac_pacl elf Muslim GDPpc_ln_07_imp  Urban_Pop_WDI_07_imp  pop_ln Polity4_imp_geo Latitude_ln Landlock Island Land_Area_WDI_07_epo_ln Protestant  English_legal_origin European_language   Oil_production_MH_pc Africa LatinAm WestEurope Asia MiddleEast i.Year, lag(1) force


**** TABLE 2, MODEL 5: MULTIPLE IMPUTATION

keep if Sovereignty == 1 & Year > 1945
mi set mlong
mi register imputed elf
mi register imputed Muslim Protestant  European_language Latitude_ln Land_Area_WDI_07_epo_ln Religious_fract_Alesina GDPpc_ln_07_imp Urban_Pop_WDI_07_imp Polity4_imp_geo pop_ln  Oil_production_MH_pc 
mi register regular Polity4_imp_F Banks Year Landlock Island AfricaSS Asia LatinAm MiddleEast WestEurope English_legal_origin
mi xtset Banks Year
mi stset, clear
tabulate(Banks), generate(Banks_)

*mi impute mvn elf GDPpc_ln_07_imp Urban_Pop_WDI_07_imp Polity4_imp_geo pop_ln  Oil_production_MH_pc English_legal_origin  European_language Religious_fract_Alesina Muslim Protestant Land_Area_WDI_07_epo_ln Landlock Latitude_ln Island AfricaSS Asia LatinAm MiddleEast WestEurope, add(3)
*mi estimate: reg Polity4_imp_F elf GDPpc_ln_07_imp Urban_Pop_WDI_07_imp Polity4_imp_geo pop_ln  Oil_production_MH_pc  English_legal_origin  European_language Religious_fract_Alesina Muslim Protestant Land_Area_WDI_07_epo_ln Landlock Latitude_ln Island AfricaSS Asia LatinAm MiddleEast WestEurope i.Year

mi impute chained (regress) elf    Muslim Protestant  European_language Latitude_ln  Land_Area_WDI_07_epo_ln Religious_fract_Alesina GDPpc_ln_07_imp Urban_Pop_WDI_07_imp Polity4_imp_geo pop_ln  Oil_production_MH_pc = Polity4_imp_F Landlock Island AfricaSS Asia LatinAm MiddleEast WestEurope English_legal_origin _IYear*, force add(5) rseed(123)
mi estimate: reg Polity4_imp_F elf GDPpc_ln_07_imp Urban_Pop_WDI_07_imp Polity4_imp_geo pop_ln  Oil_production_MH_pc  English_legal_origin  European_language Religious_fract_Alesina Muslim Protestant Land_Area_WDI_07_epo_ln Landlock Latitude_ln Island AfricaSS Asia LatinAm MiddleEast WestEurope i.Year
mibeta Polity4_imp_F elf GDPpc_ln_07_imp Urban_Pop_WDI_07_imp Polity4_imp_geo pop_ln  Oil_production_MH_pc  English_legal_origin  European_language Religious_fract_Alesina Muslim Protestant Land_Area_WDI_07_epo_ln Landlock Latitude_ln Island AfricaSS Asia LatinAm MiddleEast WestEurope i.Year




 
 
***** TABLE 5 -- IV ANALYSIS
estimates clear
keep Banks Year Polity4_imp_F GDPpc_ln_07_imp Urban_Pop_WDI_07_imp Polity4_imp_geo pop_ln English_legal_origin  European_language Religious_fract_Alesina Muslim Protestant Oil_production_MH_pc Land_Area_WDI_07_epo_ln Landlock Latitude_ln Island Africa Asia LatinAm MiddleEast WestEurope elf  avgclip sd_suitclip agritran emeanclip erange_geconclip migdistclip Years_Early_1648_ln tempavclip
qui tabulate Year, generate(_IYear)
ivregress 2sls Polity4_imp_F GDPpc_ln_07_imp Urban_Pop_WDI_07_imp Polity4_imp_geo pop_ln English_legal_origin  European_language Religious_fract_Alesina Muslim Protestant Oil_production_MH_pc Land_Area_WDI_07_epo_ln Landlock Latitude_ln Island Africa Asia LatinAm MiddleEast WestEurope i.Year (elf =  avgclip sd_suitclip agritran emeanclip erange_geconclip migdistclip Years_Early_1648_ln tempavclip) , small first noomitted

 
 **** TABLE A2 -- DESCRIPTIVE STATS
 sum cdiv_Fearon2 Ethnic_fractionaliz_Alesina ef_Fearon2 ETHFRAC2_Reynal_Querol Ethnic_homogeneity_Vanhanen ETHPOL2_Reynal_Querol elf_Fearon2 Ethnolinguistic_fract_imp elf ethnoling_PCA1 Ethnolinguistic_homog_Vanhanen  plural_Fearon2 Linguistic_fractionaliz_Alesina Linguistic_heterogen1_Gunnemark lnnmbrlang_percntry elf1 elf2 CuWars NetImmigrantsPC FH_Civil_Liberties_F UDS_100
 
 
 **** TABLE A3 -- CORRELATION MATRIX
 estimates clear
 corr elf Ethnolinguistic_fract_imp cdiv_Fearon2 Ethnolinguistic_homog_Vanhanen elf_Fearon2 Ethnic_homogeneity_Vanhanen Ethnic_fractionaliz_Alesina ef_Fearon2 ETHFRAC2_Reynal_Querol ETHPOL2_Reynal_Querol  plural_Fearon2 Linguistic_fractionaliz_Alesina Linguistic_heterogen1_Gunnemark lnnmbrlang_percntry elf1 elf2 Religious_fractionaliz_Alesina relfrac_cow relfrac_pacl RELFRAC2_Reynal_Querol RELPOL2_Reynal_Querol

 **** TABLE A4: FACTOR ANALYSIS
factor elf Ethnolinguistic_fract_imp cdiv_Fearon2 Ethnolinguistic_homog_Vanhanen elf_Fearon2 Ethnic_homogeneity_Vanhanen Ethnic_fractionaliz_Alesina ef_Fearon2 ETHFRAC2_Reynal_Querol ETHPOL2_Reynal_Querol  plural_Fearon2 Linguistic_fractionaliz_Alesina Linguistic_heterogen1_Gunnemark lnnmbrlang_percntry elf1 elf2 Religious_fractionaliz_Alesina relfrac_cow relfrac_pacl RELFRAC2_Reynal_Querol RELPOL2_Reynal_Querol, factors(2)
rotate 
**** FIGURES A1 AND A2: HISTOGRAMS
xi: newey Polity4_imp_F elf Muslim GDPpc_ln_07_imp  Religious_fractionaliz_Alesina Urban_Pop_WDI_07_imp  pop_ln Polity4_imp_geo Latitude_ln Landlock Island Land_Area_WDI_07_epo_ln Protestant  English_legal_origin European_language   Oil_production_MH_pc Africa LatinAm WestEurope Asia MiddleEast i.Year, force lag(1)
histogram elf if e(sample) == 1, bin(15) percent
histogram Religious_fractionaliz_Alesina if e(sample) == 1, bin(15) percent


*** TABLE 2, MODEL 6: DECADES ANALYSIS:
keep  if Year == 1950 | Year == 1960 | Year == 1970 | Year == 1980 | Year == 1990 | Year == 2000
egen Decade = group(Year)
xtset Banks Decade
xi: newey  Polity4_imp_F elf Muslim GDPpc_ln_07_imp  Religious_fractionaliz_Alesina Urban_Pop_WDI_07_imp  pop_ln Polity4_imp_geo Latitude_ln Landlock Island Land_Area_WDI_07_epo_ln Protestant  English_legal_origin European_language   Oil_production_MH_pc Africa LatinAm WestEurope Asia MiddleEast i.Decade, lag(1) force


*** TABLE A6:
**** INTERACTING RAS WITH RELFRAC:
xi: xtreg Polity4_imp_F elf Muslim GDPpc_ln_07_imp  c.GRI##c.Religious_fractionaliz_Alesina Urban_Pop_WDI_07_imp  pop_ln Polity4_imp_geo Latitude_ln Landlock Island Land_Area_WDI_07_epo_ln Protestant  English_legal_origin European_language   Oil_production_MH_pc Africa LatinAm WestEurope Asia MiddleEast i.Year, re

***FIGURES A3 AND A4 :MULTIVARIATE SMOOTHING:
mrunning Polity4_imp_F elf Religious_fractionaliz_Alesina   Muslim GDPpc_ln_07_imp  Urban_Pop_WDI_07_imp  pop_ln Polity4_imp_geo Latitude_ln Landlock Island Land_Area_WDI_07_epo_ln Protestant  English_legal_origin European_language   Oil_production_MH_pc Africa LatinAm WestEurope Asia MiddleEast _IYear*, nopts draw(1) adjust(Muslim GDPpc_ln_07_imp  Urban_Pop_WDI_07_imp  pop_ln Polity4_imp_geo Latitude_ln Landlock Island Land_Area_WDI_07_epo_ln Protestant  English_legal_origin European_language   Oil_production_MH_pc Africa LatinAm WestEurope Asia MiddleEast _IYear*) knn(1000)  ci xtitle(Ethnolinguistic Fractionalization) ytitle("Democacy Score [0-100]")

mrunning Polity4_imp_F elf Religious_fractionaliz_Alesina   Muslim GDPpc_ln_07_imp  Urban_Pop_WDI_07_imp  pop_ln Polity4_imp_geo Latitude_ln Landlock Island Land_Area_WDI_07_epo_ln Protestant  English_legal_origin European_language   Oil_production_MH_pc Africa LatinAm WestEurope Asia MiddleEast _IYear*, nopts draw(2) adjust(Muslim GDPpc_ln_07_imp  Urban_Pop_WDI_07_imp  pop_ln Polity4_imp_geo Latitude_ln Landlock Island Land_Area_WDI_07_epo_ln Protestant  English_legal_origin European_language   Oil_production_MH_pc Africa LatinAm WestEurope Asia MiddleEast _IYear*) knn(1000) ci xtitle(Religious Fractionalization) ytitle("Democacy Score [0-100]")
