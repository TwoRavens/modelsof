Load the concert data (from Billboard) and merge it with the demographic data provided in demo.dta (see read_me.txt for additional information).
The file artists.txt lists the names of the artists in the dataset.
**************
*There are some inconsistencies in the Bollboard data on prices and attendance: 
gen error=1 if ticketprice1-ticketprice2<0
gen error2=1 if ticketprice1-ticketprice3<0
gen error3=1 if ticketprice1-ticketprice4<0
gen error4=1 if ticketprice2-ticketprice3<0
gen error5=1 if ticketprice2-ticketprice4<0
gen error6=1 if ticketprice3-ticketprice4<0
gen error7=1 if attendance>capacity
*We delete the corresponding observations 
tab error 
tab error2 
tab error3
tab error4
tab error5
tab error6
tab error7
drop if error ==1
drop if error2==1
drop if error3==1
drop if error4==1
drop if error5==1
drop if error6==1
drop if error7==1
*There are some inconsistencies in the spelling of some artist names:
	replace artist1="Santana" if artist1=="Carlos Santana"
	replace artist1="KORN"    if artist1=="KoRn"
	replace artist1="Prince"  if artist1=="The Artist (formerly known as Prince)"
	replace artist1="N Sync"  if artist1=="'N Sync"
*drop data for countries different from the US (the paper is entirely based on the US sample)
drop if country!="US"
*define (second degree) price discrimination:
	gen     pr_discr_2degr=1 if num_prices>1
	replace pr_discr_2degr=0 if num_prices==1
*define average price:
	gen avg_price=usgross/attendance
*define capacity utilization:
	gen capacity_utilization=attendance/capacity
*generate log variables:
	gen ln_usgross    =ln(usgross)
	gen ln_capacity   =ln(capacity)
*generate numerical identifiers from string variables: 
	egen artist1_numerical=group(artist1) 
	egen city_numerical=group(city)
	egen artist1_city_numerical=group(artist1 city)
	egen venue_numerical=group(venue) 
	egen artist1_venue_numerical=group(artist1 venue) 
	egen city_year_numerical=group(city startyear) 
	egen promoter1_numerical=group(promoter1) 
	egen artist1_promoter1_numerical=group(artist1 promoter1)
	egen promoter1_city_numerical   =group(promoter1 city)
	egen tour_numerical   =group(tour)
	egen artist1_year_numerical=group(artist1 startyear)
	egen state_numerical=group(state)
	egen promoter1_state_numerical   =group(promoter1 state)
*interactions of price discrimination variable with demographic variables:
*race diversity (city-place level data from census 2000):
	gen gini_race2000= ln(1- ((pop_frac_white2000/100)^2+(pop_frac_black2000/100)^2+(1-(pop_frac_white2000/100)-(pop_frac_black2000/100))^2))
	gen pd_2nd_gini_race2000 =pr_discr_2degr *gini_race2000
*median hausehold income (1999$), (city level data from census 2000)
	gen pd_2nd_med_hause_inc=pr_discr_2degr* med_h_inc/1000
*hausehold income diversity (city level data from census 2000):
	gen income_diversity=ln(1-((h__10k/h_tot_inc)^2+ (h_10_14k/h_tot_inc)^2+ (h_15_19k/h_tot_inc)^2+ (h_20_24k/h_tot_inc)^2+ (h_25_29k/h_tot_inc)^2+ ///
				(h_30_34k/h_tot_inc)^2+ (h_35_39k/h_tot_inc)^2+ (h_40_44k/h_tot_inc)^2+ (h_45_49k/h_tot_inc)^2+ (h_50_59k/h_tot_inc)^2+ ///
				(h_60_74k/h_tot_inc)^2+ (h_75_99k/h_tot_inc)^2+ (h_100_124k/h_tot_inc)^2+ (h_125_149k/h_tot_inc)^2+ (h_150_199k/h_tot_inc)^2+ ///
				(h__200k/h_tot_inc)^2 ))
	gen pd_2nd_inc_div= pr_discr_2degr* income_diversity
*population:
	gen pd_2nd_pop=pr_discr_2degr*population2000/1000000
*occupation diversity:
	gen occ_diversity_pop=ln(1- ( ///
					((e_f_management_001_359 + e_m_management_001_359)/ e_tot)^2+((e_f_services_360_469 +e_m_services_360_469)/e_tot)^2+((e_f_sales_470_599+e_m_sales_470_599)/e_tot)^2+ ///
					(( e_f_farming_600_619+e_m_farming_600_619)/ e_tot)^2+((e_f_construction_620_769+e_m_construction_620_769)/e_tot)^2+ ///
					(( e_f_production_770_979+e_m_production_770_979)/ e_tot)^2 ///
						))
	gen pd_2nd_occ_div= pr_discr_2degr* occ_diversity_pop
*Table 1. Summary statistics
tabstat  capacity_utilization pr_discr_2degr attendance usgross num_prices capacity avg_price ticketprice1, stat(count mean sd p10 p25 p50 p75 p90 ) c(s)
*Table 2:
xi: regr ln_usgross pr_discr_2degr ,cluster(city_numerical)
	xi: outreg2 pr_discr_2degr using T2.doc, replace nolabel se coefastr
xi: areg ln_usgross pr_discr_2degr ln_capacity ,a(city_numerical) cluster(city_numerical)
	xi: outreg2 pr_discr_2degr ln_capacity using T2.doc, append nolabel se coefastr	
xi: areg ln_usgross pr_discr_2degr ln_capacity i.startyear i.artist1,a(city_numerical) cluster(city_numerical)
	xi: outreg2 pr_discr_2degr ln_capacity using T2.doc, append nolabel se coefastr
xi: areg ln_usgross pr_discr_2degr ln_capacity i.startyear i.tour, a(venue_numerical) cluster(venue_numerical)
	xi: outreg2 pr_discr_2degr ln_capacity using T2.doc, append  nolabel se coefastr
xi: areg ln_usgross pr_discr_2degr ln_capacity i.startyear i.tour i.promoter1, a(venue_numerical) cluster(venue_numerical)
	xi: outreg2 pr_discr_2degr ln_capacity using T2.doc, append  nolabel se coefastr	
*Table 3:
xi: areg ln_usgross pr_discr_2degr ln_capacity  i.artist1*i.startyear, a(artist1_city_numerical) 
	xi: outreg2 pr_discr_2degr ln_capacity using T3.doc, replace nolabel se coefastr 
xi: areg ln_usgross pr_discr_2degr ln_capacity  i.artist1, a(city_year_numerical) 
	xi: outreg2 pr_discr_2degr ln_capacity  using T3.doc, append nolabel se coefastr 
xi: areg ln_usgross pr_discr_2degr ln_capacity  i.artist1*i.startyear, a(artist1_venue_numerical) 
	xi: outreg2 pr_discr_2degr ln_capacity using T3.doc, append nolabel se coefastr 
xi: areg ln_usgross pr_discr_2degr ln_capacity  i.artist1*i.startyear i.city|startyear, a(artist1_venue_numerical) 
	xi: outreg2 pr_discr_2degr ln_capacity using T3.doc, append nolabel se coefastr 
xi: areg ln_usgross pr_discr_2degr ln_capacity i.startyear i.artist1 i.city, a(artist1_promoter1_numerical) 
	outreg2 pr_discr_2degr ln_capacity using T3.doc, append nolabel se coefastr 
*Table 4: 
xi:areg ln_usgross pd_2nd_med_hause_inc pd_2nd_pop pd_2nd_gini_race2000 pd_2nd_occ_div pd_2nd_inc_div pr_discr_2degr ln_capacity i.startyear i.artist1, a(city_numerical) cluster(city_numerical)
	xi:outreg2 pd_2nd_med_hause_inc pd_2nd_pop pd_2nd_gini_race2000 pd_2nd_occ_div pd_2nd_inc_div pr_discr_2degr ln_capacity using T4.doc, replace nolabel se coefastr bdec(6)
xi:areg ln_usgross pd_2nd_med_hause_inc pd_2nd_pop pd_2nd_gini_race2000 pd_2nd_occ_div pd_2nd_inc_div pr_discr_2degr ln_capacity i.startyear i.tour , a(venue_numerical) cluster(venue_numerical)
	xi:outreg2 pd_2nd_med_hause_inc pd_2nd_pop pd_2nd_gini_race2000 pd_2nd_occ_div pd_2nd_inc_div pr_discr_2degr ln_capacity using T4.doc, append nolabel se coefastr bdec(6)
xi:areg ln_usgross pd_2nd_med_hause_inc pd_2nd_pop pd_2nd_gini_race2000 pd_2nd_occ_div pd_2nd_inc_div pr_discr_2degr ln_capacity i.startyear i.tour i.promoter1, a(venue_numerical) cluster(venue_numerical)
	xi:outreg2 pd_2nd_med_hause_inc pd_2nd_pop pd_2nd_gini_race2000 pd_2nd_occ_div pd_2nd_inc_div pr_discr_2degr ln_capacity using T4.doc, append nolabel se coefastr bdec(6)
*Table 5:
xi: areg ln_usgross i.num_prices ln_capacity i.startyear i.artist1, a(city_numerical) cluster(city_numerical)
	 xi: outreg2 i.num_prices ln_capacity using T5.doc, replace nolabel se coefast
xi: areg ln_usgross i.num_prices ln_capacity i.startyear i.tour, a(venue_numerical) cluster(venue_numerical)
	 xi: outreg2 i.num_prices ln_capacity using T5.doc, append  nolabel se coefastr	
xi: areg ln_usgross i.num_prices ln_capacity i.artist1*i.startyear, a(artist1_city_numerical) cluster(city_numerical)
	 xi: outreg2 i.num_prices ln_capacity using T5.doc, append nolabel se coefastr
