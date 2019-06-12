* This file is will replicate the results in Hyde and Marinov "Which Elections Can be Lost?"


use "Replication_Data_NELDA_PoliticalAnalysis.dta"

	foreach dv in nelda24 																																			{
	
*	q9extendterm q10transitional q11concerns q12confident q13prevented q14boycott q15harassed q16media fp2l1 q22successor q33civvio	

		foreach iv in q16media fp2l1																															{														
					
					*	Model (1) NELDA Competition
					
					di "logit `dv' `iv' if (nelda3==1 & nelda4==1 & nelda5==1) & l1ht_partsz!=. & l1polity!=. & l1fhspr!=." 
					
					logit `dv' `iv' if (nelda3==1 & nelda4==1 & nelda5==1) & l1ht_partsz!=. & l1polity!=. & l1fhspr!=.
	

					*	Model (2) <75 seats in legislature, http://www.qog.pol.gu.se/data/data.htm
					
					
					di "logit `dv' `iv' if (nelda3==1 & nelda4==1 & nelda5==1) & l1ht_partsz<.75" 
										
					logit `dv' `iv' if (nelda3==1 & nelda4==1 & nelda5==1) & l1ht_partsz<.75	& l1ht_partsz!=. & l1polity!=. & l1fhspr!=.


				

					*	Model (3) Polity > -5 & FHPR < 6 


					di "logit `dv' `iv' if l1polity>=-5 & l1polity!=. & l1polity>=-5 & l1ht_partsz!=. & l1fhspr!=. & l1fhspr<6" 
					
					logit `dv' `iv' if l1polity>=-5 & l1polity!=. & l1polity>=-5 & l1ht_partsz!=. & l1fhspr!=. & l1fhspr<6

	
					*	Model (4) Democracy
	
					di "logit `dv' `iv' if l1fhspr<=5 & l1ht_partsz!=. & l1polity!=. & l1fhspr!=. & regl1==1" 
					
					logit `dv' `iv' if l1fhspr<=5 & l1ht_partsz!=. & l1polity!=. & l1fhspr!=. & regl1==1
	





		}
	}
	


*	CLARIFY SIMULATION Model 1 2 4
	

	capture drop b1 b2

	estsimp logit nelda24 fp2l1 if (nelda3==1 & nelda4==1 & nelda5==1) & l1ht_partsz!=. & l1polity!=. & l1fhspr!=.

	setx 25
	simqi
	setx 75
	simqi


	drop b1 b2

	estsimp logit nelda24 fp2l1 if (nelda3==1 & nelda4==1 & nelda5==1) & l1ht_partsz<.75 & l1ht_partsz!=. & l1polity!=. & l1fhspr!=. 

	setx 25
	simqi
	setx 75
	simqi


	drop b1 b2

	estsimp logit nelda24 fp2l1 if (nelda3==1 & nelda4==1 & nelda5==1) & l1ht_partsz!=. & l1polity!=. & l1fhspr!=. & regl1==1

	setx 25
	simqi
	setx 75
	simqi
