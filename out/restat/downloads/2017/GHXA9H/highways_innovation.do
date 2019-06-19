clear all
set more off

****************************************************
* Stata .do file for Highways and Innovation Paper *
****************************************************

insheet using "highways_innovation-msalevel.tab", clear

****************************************************
* Construct some variables
****************************************************

* Gen Large and Small Firms
gen logSmall83=log( labssmall83+1)
gen logLarge83=log( labslarge83+1)
gen dum = labssmall83==0
gen dumL=logLarge83==0

************************
* Set Global Variables
************************

global inventorsMSA "ln_msanuminv83 ln_msanuminv78 ln_msainv73"
global inventors_class "ln_numinv83 ln_numinv78 ln_numinv73"
global population "l_pop50 l_pop40  l_pop30 l_pop20"  
global cen_div "div1 div2 div3 div4 div5 div6 div7 div8"
global geography	 "logpc loghe logco elevat_range_msa ruggedness_msa"
global geography_extDT "pc_aquifer_msa2 elevat_range_msa2 ruggedness_msa2 eleva_rug"
global geographyDT	 "pc_aquifer_msa elevat_range_msa ruggedness_msa heating_dd cooling_dd"
global socioeco "s_somecollege_80 l_mean_income seg1980_ghetto s_poor_80 smanuf77" 


***************************
* TABLE 1 - Summary Stats *
***************************

sum msacites88 msapats88 msacites83 msapats83  msanuminv83  rd_km_ih_83  hwy1947 rail1898 pix_pre1850 if msasample==1
sum cites88 pats88 cites83 pats83 numinv83 if no83inventors==0

***************************************************
* TABLE 2 - OLS	- Aggregate and Disaggregated	  *
***************************************************

eststo clear

qui: eststo: reg ln_msacites88 l_rd_km_ih_83 ln_msacites83 $inventorsMSA $geography if msasample==1,  r
qui: eststo: reg ln_msapats88 l_rd_km_ih_83 ln_msapats83 $inventorsMSA $geography if msasample==1,  r
qui: eststo: reg ln_cites88 l_rd_km_ih_83 ln_cites83 $inventors_class  ln_msanuminv83 $geography i.class  if no83inventors==0,  cluster(msa)
qui: eststo: reg ln_pats88 l_rd_km_ih_83 ln_pats83 $inventors_class  ln_msanuminv83 $geography i.class  if no83inventors==0,  cluster(msa)

esttab, label b(3) se(3) star(* 0.10 ** 0.05 *** 0.01)  keep(l_rd_km_ih_83 ln_msacites83 ln_msapats83 ln_cites83 ln_pats83) title(TABLE 2: OLS REGRESSIONS)

***************************************************
* TABLE 3 - IV	- Aggregate and Disaggregated	  *
***************************************************

eststo clear

qui: eststo: ivreg2 ln_msacites88 (l_rd_km_ih_83 = l_hwy1947 l_rail1898 l_pix_pre1850) ln_msacites83 $inventorsMSA $geography   if msasample==1, first  r
qui: eststo: ivreg2 ln_msapats88 (l_rd_km_ih_83 = l_hwy1947 l_rail1898 l_pix_pre1850) ln_msapats83 $inventorsMSA $geography   if msasample==1, first  r
qui: eststo: xi: ivreg2 ln_cites88 (l_rd_km_ih_83 = l_hwy1947 l_rail1898 l_pix_pre1850) ln_cites83 $inventors_class  ln_msanuminv83 $geography i.class  if no83inventors==0,  cluster(msa)
qui: eststo: xi: ivreg2 ln_pats88 (l_rd_km_ih_83 = l_hwy1947 l_rail1898 l_pix_pre1850) ln_pats83 $inventors_class ln_msanuminv83 $geography i.class  if no83inventors==0,  cluster(msa)

esttab, label b(3) se(3) star(* 0.10 ** 0.05 *** 0.01)  stats(N rkf, labels("Observations" "F-stat") fmt(a3 a3)) keep(l_rd_km_ih_83) title(TABLE 3: IV)



**************************************
* Table 4: Roads cause an increase in local citations and patents net of displacement effects*
**************************************


eststo clear
qui: eststo: ivreg2 ln_msacites88 (l_rd_km_ih_83 spatial_highway83 = l_hwy1947 l_rail1898 l_pix_pre1850 spatial_highway47 spatial_rail spatial_routes)   ln_msacites83 $inventorsMSA $geography   if msasample==1, first  r
qui: eststo: ivreg2 ln_msapats88 (l_rd_km_ih_83 spatial_highway83 = l_hwy1947 l_rail1898 l_pix_pre1850  spatial_highway47 spatial_rail spatial_routes)   ln_msapats83 $inventorsMSA $geography   if msasample==1, first  r
qui: eststo: xi: ivreg2 ln_cites88 (l_rd_km_ih_83 spatial_highway83 = l_hwy1947 l_rail1898 l_pix_pre1850  spatial_highway47 spatial_rail spatial_routes)   ln_cites83 $inventors_class  ln_msanuminv83 $geography i.class  if no83inventors==0,  cluster(msa)
qui: eststo: xi: ivreg2 ln_pats88 (l_rd_km_ih_83 spatial_highway83 = l_hwy1947 l_rail1898 l_pix_pre1850  spatial_highway47 spatial_rail spatial_routes)   ln_pats83 $inventors_class ln_msanuminv83 $geography i.class  if no83inventors==0,  cluster(msa)
esttab, label b(3) se(3) star(* 0.10 ** 0.05 *** 0.01)  stats(N rkf, labels("Observations" "F-stat") fmt(a3 a3)) keep(l_rd_km_ih_83 spatial_highway83 ) title(TABLE 4: IV)




*************************************************
* TABLE 5	- Roads and Knowledge Input		*
*************************************************

*differences in means*

eststo clear

qui eststo: xi: ivreg2 ln_samemsa_dist_88 (l_rd_km_ih_83 = l_hwy1947 l_rail1898 l_pix_pre1850)  ln_samemsa_dist_83 ln_pats83 $inventors_class  ln_msanuminv83 i.class $cen_div $geography if no83inventors==0,  cluster(msa)
qui eststo: xi: ivreg2 ln_samemsa_dist_88 (l_rd_km_ih_83 = l_hwy1947 l_rail1898 l_pix_pre1850)  ln_samemsa_dist_83 ln_pats83 $inventors_class  ln_msanuminv83  $socioeco $cen_div $geographyDT $geography_extDT i.class  if no83inventors==0,  cluster(msa)
qui eststo: xi: ivreg2 ln_samemsa_dist_88 (l_rd_km_ih_83 = l_hwy1947 l_rail1898 l_pix_pre1850)  ln_samemsa_dist_83 ln_pats83 $inventors_class $geography $inventorsMSA  $population i.class  if no83inventors==0,  cluster(msa)
* Non-Mover Sample
qui eststo: xi: ivreg2 ln_nonmove_dist_88 (l_rd_km_ih_83 = l_hwy1947 l_rail1898 l_pix_pre1850)  ln_nonmove_dist_83 ln_pats83 $inventors_class  ln_msanuminv83  $cen_div i.class  if no83inventors==0,  cluster(msa)
qui eststo: xi: ivreg2 ln_nonmove_dist_88 (l_rd_km_ih_83 = l_hwy1947 l_rail1898 l_pix_pre1850)  ln_nonmove_dist_83 ln_pats83 $inventors_class  ln_msanuminv83  $socioeco $cen_div $geographyDT $geography_extDT i.class  if no83inventors==0,  cluster(msa)
qui eststo: xi: ivreg2 ln_nonmove_dist_88 (l_rd_km_ih_83 = l_hwy1947 l_rail1898 l_pix_pre1850)  ln_nonmove_dist_83 ln_pats83 $inventors_class $geography $inventorsMSA  $population i.class  if no83inventors==0,  cluster(msa)
esttab, label b(3) se(3) star(* 0.10 ** 0.05 *** 0.01)  stats(N rkf, labels("Observations" "F-stat") fmt(a3 a3)) keep(l_rd_km_ih_83) title(Table 5: KNOWLEDGE DISTANCE)

*************************************************
* TABLE 6	- Rely on local knowledge		*
*************************************************
eststo clear
qui eststo: xi: ivreg2 ln_samemsa_pats_88 (l_rd_km_ih_83 = l_hwy1947 l_rail1898 l_pix_pre1850) ln_samemsa_pats_83 $inventors_class $geography $inventorsMSA ln_msanuminv83 i.class  if no83inventors==0,  cluster(msa)
qui eststo: xi: ivreg2 ln_samemsa_new_pats_88 (l_rd_km_ih_83 = l_hwy1947 l_rail1898 l_pix_pre1850) ln_samemsa_new_pats_83 $inventors_class $geography $inventorsMSA ln_msanuminv83 i.class  if no83inventors==0,  cluster(msa)
qui eststo: xi: ivreg2 ln_nonmove_samemsa_pats_88 (l_rd_km_ih_83 = l_hwy1947 l_rail1898 l_pix_pre1850) ln_nonmove_samemsa_pats_83 $inventors_class $geography $inventorsMSA ln_msanuminv83 i.class  if no83inventors==0,  cluster(msa)
qui eststo: xi: ivreg2 ln_nonmove_samemsa_new_pats_88 (l_rd_km_ih_83 = l_hwy1947 l_rail1898 l_pix_pre1850) ln_nonmove_samemsa_new_pats_83 $inventors_class $geography $inventorsMSA ln_msanuminv83 i.class  if no83inventors==0,  cluster(msa)
esttab, label b(3) se(3) star(* 0.10 ** 0.05 *** 0.01)  stats(N rkf, labels("Observations" "F-stat") fmt(a3 a3)) keep(  l_rd_km_ih_83 ln_samemsa_pats_83 ln_samemsa_new_pats_83 ln_nonmove_samemsa_pats_83 ln_nonmove_samemsa_new_pats_83) title(TABLE 6: Non-Movers: Patents that cite patents within their own MSA )


*******************************
*TABLE 9 - VELOCITY AND STARS *
********************************

eststo clear
* VELOCITY
qui eststo: xi: ivreg2  ln_cites88 (l_rd_km_ih_83 = l_hwy1947 l_rail1898 l_pix_pre1850)   ln_cites83 $inventors_class  $inventorsMSA $geography $population  i.class  if no83inventors==0 & highvelocity==0,  cluster(msa)
qui eststo: xi: ivreg2  ln_cites88 (l_rd_km_ih_83 = l_hwy1947 l_rail1898 l_pix_pre1850)   ln_cites83 $inventors_class  $inventorsMSA $geography $population i.class  if no83inventors==0 & highvelocity==1,  cluster(msa)
* STARS
qui eststo: xi: ivreg2  ln_cites88 (l_rd_km_ih_83 = l_hwy1947 l_rail1898 l_pix_pre1850) ln_cites83  $inventors_class  $inventorsMSA $geography $population i.class  if no83inventors==0 & star_83 == 0,  cluster(msa)
qui eststo: xi: ivreg2  ln_cites88 (l_rd_km_ih_83 = l_hwy1947 l_rail1898 l_pix_pre1850) ln_cites83  $inventors_class  $inventorsMSA $geography $population i.class  if no83inventors==0 & star_83 > 0,  cluster(msa)
esttab, label b(3) se(3) star(* 0.10 ** 0.05 *** 0.01)  stats(N r2 rkf, labels("Observations" "F-stat") fmt(a3 a3)) keep(l_rd_km_ih_83) title(TABLE 9: Velocity/Stars)



*******************************
* TABLE 10: Density and Firm Size***
************************

eststo clear
* Density
qui eststo: xi: ivreg2  ln_cites88 (l_rd_km_ih_83 = l_hwy1947 l_rail1898 l_pix_pre1850) ln_cites83 $inventors_class  $inventorsMSA $socioeco $geography i.class if no83inventors==0 & highmsadensity == 0,  cluster(msa)
qui eststo: xi: ivreg2  ln_cites88 (l_rd_km_ih_83 = l_hwy1947 l_rail1898 l_pix_pre1850) ln_cites83 $inventors_class  $inventorsMSA $socioeco $geography i.class  if no83inventors==0 & highmsadensity == 1,  cluster(msa)
* Large & Small Firms
qui eststo: xi: ivreg2 ln_smallcites88 (l_rd_km_ih_83 = l_hwy1947 l_rail1898 l_pix_pre1850) ln_cites83 ln_smallcites83 $inventors_class  $inventorsMSA  $socioeco $geography i.class dumL dum if no83inventors==0,  cluster(msa)
qui eststo: xi: ivreg2 ln_largecites88 (l_rd_km_ih_83 = l_hwy1947 l_rail1898 l_pix_pre1850) ln_cites83 ln_largecites83 $inventors_class  $inventorsMSA $socioeco  $geography i.class dumL dum if no83inventors==0,  cluster(msa)
esttab, label b(3) se(3) star(* 0.10 ** 0.05 *** 0.01)  stats(N r2 rkf, labels("Observations" "F-stat") fmt(a3 a3)) keep(l_rd_km_ih_83 ln_cites83 ln_smallcites83 ln_largecites83) title(TABLE 10: Density/Large-Small)

******************************
*
* PATENT-LEVEL ANALYSES
*
******************************

insheet using "highways_innovation-patentlevel.tab", clear

*************************************************
* TABLE 7 - Roads increase the geographic distance of local knowledge inputs		
*************************************************

*replace year = 1974 if year <= 1974
*replace year = 1989 if year >= 1989

eststo clear
qui: eststo: ivreg2 ln_dist (l_rd_km_ih_83 = l_hwy1947 l_rail1898 l_pix_pre1850) i(1973/1988).year i.citedsubcat i.subcat,first  cluster(msa) rob, if cited == 1
qui: eststo: ivreg2 ln_dist (l_rd_km_ih_83 = l_hwy1947 l_rail1898 l_pix_pre1850)  $geography  i(1973/1988).year i.citedsubcat i.subcat, first cluster(msa) rob, if cited == 1
qui: eststo: ivreg2 ln_dist (l_rd_km_ih_83 = l_hwy1947 l_rail1898 l_pix_pre1850) $geography $inventorsMSA i(1973/1988).year i.citedsubcat i.subcat, first cluster(msa) rob, if cited == 1
qui: eststo: ivreg2 ln_dist_other (l_rd_km_ih_83 = l_hwy1947 l_rail1898 l_pix_pre1850)  $geography $inventorsMSA i(1973/1988).year i.citedsubcat i.subcat, first cluster(msa) rob, if cited == 1


esttab, keep(l_rd_km_ih_83) label b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) title (IV - Regressions: Impact of Highways on Citation Distance) stats(N rkf r2, labels("Observations" "F-stat" "R2") fmt(a3 a3))
*************************************************
* TABLE 8 - Roads increase the probability of building upon local knowledge
*************************************************


eststo clear
qui: eststo: reg cited ln_dist l_rd_km_ih_83 i(1973/1988).year i.citedsubcat i.subcat, cluster(msa) rob
qui: eststo: reg cited ln_dist l_rd_km_ih_83 i(1973/1988).year i.citedsubcat i.subcat $geography $inventorsMSA, cluster(msa) rob
qui: eststo: ivreg2 cited ln_dist (l_rd_km_ih_83 = l_hwy1947 l_rail1898 l_pix_pre1850) i(1973/1988).year i.citedsubcat i.subcat, cluster(msa) rob
qui: eststo: ivreg2 cited ln_dist (l_rd_km_ih_83 = l_hwy1947 l_rail1898 l_pix_pre1850) i(1973/1988).year i.citedsubcat i.subcat $geography $inventorsMSA, cluster(msa) rob

esttab, keep(l_rd_km_ih_83 ln_dist) label b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) title (Highways and Probability of Citations) stats(N rkf r2, labels("Observations" "F-stat" "R2") fmt(a3 a3)) 
