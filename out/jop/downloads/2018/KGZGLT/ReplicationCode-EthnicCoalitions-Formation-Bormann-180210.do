/******************************************************************************/
**** Uncertainty, Cleavages and Ethnic Coalitions
*** Replication Code: Formation Analysis
*** Nils-Christian Bormann
*** Journal of Politics

/******************************************************************************/
**** Header
clear
cd "/home/ncb/Documents/Academics/Research/12-2-Ethnic Coalition Formation/replication"
set more off
set seed 2508

/** This script requires the mixlogit command */
/* if not installed, uncomment the following command and run it */
// ssc install mixlogit

/******************************************************************************/
**** Data

import delim "ReplicationData-EthnicCoalitions-Formation-Bormann-180209.csv", ///
	clear numericcols(16 29 34 35 36 37 38 39 40 41 44 47)


label var realcoal_flag "Realized Coalition"
label var singlemaj_flag "Single Majority"
label var coalminwin_flag "Minimum-Winning Coalition"
label var coalosize_flag "Oversized Coalition"
label var coal_maxgrp_flag "Largest Group"
label var coalmemb "Member Count"
label var coal_cleav_count "Cleavage Dimension Count"
label var coal_cleav_totcount "Cleavage Count"
label var coal_relctr_cleav "Cleavage Dimension Share"
label var coal_relctr_totcleav "Cleavage Share"
label var pastgov_flag "Past Government"
label var coalpastprop "Past Government Share"
label var coal_maxwar "Coalition After Civil War"
label var coal_minwar "Prior Civil War"
label var coal_langfrac "Linguistic Fractionalization"
label var coal_langpol "Linguistic Polarization"
label var coal_relfrac  "Religious Fractionalization"
label var coal_relpol "Religious Polarization"
label var coal_phenofrac  "Phenotype Fractionalization"
label var coal_phenopol "Phenotype Polarization"

** Define subsample dummies
gen oecd = 0
replace oecd = 1 if inlist(cowid, 2, 20, 70, 155, 200, 205, 210, 211, 212, 220, ///
				225, 235, 255, 260, 290, 305, 310, 316, 317, ///
				325, 350, 366, 367,  375, 380, 385, 390, 395, ///
				640, 666, 730, 731, 740, 900, 920) 

gen west = 0 // americas + eu27 + small west european states + australia + new zealand
replace west = 1 if inrange(cowid, 2, 325) |  inlist(cowid, 344, 349, 350, ///
				352, 355, 360, 375, 380, 385, 390, 900, 920)
				  
gen postsoviet = 0 // any soviet successor state or warsaw pact member
replace postsoviet = 1 if inrange(cowid, 365, 373) | inlist(cowid, 290, 310, ///
				315, 316, 317, 355, 360, 701, 702, 703, 704, 705)
				
gen dem_flag = 0
replace dem_flag = 1 if ddregime <= 2 
		
gen year = mod(cyear,10000)		
gen coldwar = 0
replace coldwar = 1 if year <= 1990
drop year



********************************************************************************
********************************************************************************
********************************** TABLES **************************************
********************************************************************************
********************************************************************************

********************************************************************************
**** Table 1 - Main analysis 
** Conditional models may take several minutes to converge

*** Data 1 (EPR Periods)
** M1
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
			coal_maxgrp_flag coalmemb, group(cyear) vce(cluster cowid)
estat ic

** M2
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb coal_cleav_count, ///
		     group(cyear) vce(cluster cowid)
estat ic

** M3
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb coal_cleav_count coalpastprop, ///
		     group(cyear) vce(cluster cowid)
estat ic
		     
** M4 - authoritarian systems
clogit realcoal_flag singlemaj_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb coal_cleav_count coalpastprop ///
		     if dem_flag==0, group(cyear) vce(cluster cowid)
estat ic		     

** M5 - democracies
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb coal_cleav_count coalpastprop ///
		     if dem_flag==1, group(cyear) vce(cluster cowid)
estat ic		     

	     
********************************************************************************
****************************** ONLINE APPENDIX *********************************
********************************************************************************

********************************************************************************
**** Table A9 - Mixed Logit
** Mixed logit models may take several hours to converge

** Model A1
mixlogit realcoal_flag if cowid != 750, group(cyear) ///
	rand(singlemaj_flag coalminwin_flag coalosize_flag coal_maxgrp_flag ///
		coalmemb) id(cowid) nrep(500) burn(50)
		
** Model A2
mixlogit realcoal_flag if cowid != 750, group(cyear) ///
	rand(singlemaj_flag coalminwin_flag coalosize_flag coal_maxgrp_flag ///
		coalmemb coal_cleav_count) id(cowid) nrep(500) burn(50)

** Model A3
mixlogit realcoal_flag if cowid != 750, group(cyear) ///
	rand(singlemaj_flag coalminwin_flag coalosize_flag coal_maxgrp_flag ///
		coalmemb coal_cleav_count coalpastprop) id(cowid) nrep(500) burn(50)		

********************************************************************************
**** Table A10 - Institution-based sample 
    
		     
		     
********************************************************************************
**** Table A11 - Regional subsamples
** Model A8 - Non-OECD
clogit realcoal_flag singlemaj_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb coal_cleav_count coalpastprop ///
		     if oecd==0, group(cyear) vce(cluster cowid)
		     
** Model A9 - Non-West
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb coal_cleav_count coalpastprop ///
		     if west==0, group(cyear) vce(cluster cowid)

** Model A10 - Non-post-Soviet
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb coal_cleav_count coalpastprop ///
		     if postsoviet==0, group(cyear) vce(cluster cowid)		     		     

** Model A11 - Sub-Saharan Africa, Middle East and Asia
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb coal_cleav_count coalpastprop ///
		     if inrange(cowid, 400, 705) | inrange(cowid,750,899), ///
		     group(cyear) vce(cluster cowid)		     		     

	     
********************************************************************************
**** Table A12 - Additional variable specifications and controls

** Model A12 - alternative min-win coalition
* re-define minimum winning analysis as all majority coalitions below 60%
gen coalminwin2_flag = 0
replace coalminwin2_flag = 1 if coalsize < 0.6 & coalsize > 0.5 & coalmemb > 1
gen coalosize2_flag = coalosize_flag
replace coalosize2_flag = 0 if coalminwin2_flag == 1

clogit realcoal_flag singlemaj_flag coalminwin2_flag coalosize2_flag coal_maxgrp_flag ///
			coalmemb coal_cleav_count pastgov_flag ///
			, group(cyear) vce(cluster cowid)

** Model A13 - largest group in formation opportunity not > 0.6
bys cyear: egen maxgroupsize = max(coalmaxmsize)				
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag coal_maxgrp_flag ///
			coalmemb coal_cleav_count coalpastprop ///
			if maxgroupsize <= 0.6, group(cyear) vce(cluster cowid)

** Model A14 - former civil war opponents in coalition
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag coal_maxgrp_flag ///
			coalmemb coal_cleav_count coalpastprop ///
			coal_maxwar, group(cyear) vce(cluster cowid)

** Model A15 - any member with past civil war experience
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag coal_maxgrp_flag ///
			coalmemb c.coal_cleav_count coalpastprop ///
			coal_minwar, group(cyear) vce(cluster cowid)



********************************************************************************
**** Table A13 - Alternative Ethnic Cleavage Operationalizations

** Model A16 - Count of total cleavages in coalition
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag coal_maxgrp_flag ///
coalmemb coal_cleav_totcount coalpastprop, group(cyear) vce(cluster cowid)

** Model A17 - Share of total cleavage dimensions
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag coal_maxgrp_flag ///
coalmemb coal_relctr_cleav coalpastprop, group(cyear) vce(cluster cowid)

** Model A18 - Fractionalization indices by cleavage dimension
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag coal_maxgrp_flag ///
coalmemb coal_langfrac coal_relfrac coal_phenofrac coalpastprop, ///
group(cyear) vce(cluster cowid)

** Model A19 - Polarization indices by cleavage dimension
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag coal_maxgrp_flag ///
coalmemb coal_langpol coal_relpol coal_phenopol coalpastprop, ///
group(cyear) vce(cluster cowid)


********************************************************************************
**** Table A14 - Regime and electoral system sub-samples

** Model A20 - Democracy and Dictatorship data: only dictatorships
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb coal_cleav_count coalpastprop ///
		     if ddregime>2, group(cyear) vce(cluster cowid)
predict pp_dic if e(sample)

** Model A21 - Democracy and Dictatorship data: only democracies
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb coal_cleav_count coalpastprop ///
		     if ddregime <= 2, group(cyear) vce(cluster cowid) 		
predict pp_dem if e(sample)
		     

** Model A22 - Democratic Electoral Systems data - only majoritarian systems
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb coal_cleav_count coalpastprop ///
		     if elecsys==1, group(cyear) vce(cluster cowid) 
predict pp_maj if e(sample)
		     

** Model A23 - Democratic Electoral Systems data - only PR systems
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb coal_cleav_count coalpastprop ///
		     if elecsys==2, group(cyear) vce(cluster cowid) 		
predict pp_pr if e(sample)
		     
outsheet cyear cowid realcoal_flag coalsize coalmemb coalosize_flag pp* ///
using "coalition_pp_by_regime.csv", comma replace


********************************************************************************
**** Table A15 - Mixed logit models by Polity IV regime classification

** Model A24 - Polity IV data: only autocracies
mixlogit realcoal_flag if cowid != 750 & polity < -6, group(cyear) 
		rand(coal_maxgrp_flag singlemaj_flag coalminwin_flag coalosize_flag 
			coalmemb coal_cleav_count) id(cowid) nrep(500) burn(50)

** Model A25 - Polity IV data: only anocracies
mixlogit realcoal_flag if cowid != 750 & polity < 6 & polity > -6, group(cyear) 
		rand(coal_maxgrp_flag singlemaj_flag coalminwin_flag coalosize_flag 
			coalmemb coal_cleav_count)  id(cowid) nrep(500) burn(50)

** Model A26 - Polity IV data: only democracies
mixlogit realcoal_flag if cowid != 750 & polity > 6, group(cyear) 
		rand(coal_maxgrp_flag singlemaj_flag coalminwin_flag coalosize_flag 
			coalmemb coal_cleav_count) id(cowid) nrep(500) burn(50)


********************************************************************************
**** Table A16 - Mixed logit models by autocratic institutions

** Model A27 - Gandhi data: only party dictatorships
mixlogit realcoal_flag if cowid != 750 & ddparty>0, group(cyear) 
		rand(coal_maxgrp_flag singlemaj_flag coalminwin_flag coalosize_flag 
			coalmemb coal_cleav_count) id(cowid) nrep(500) burn(50)

** Model A28 - Gandhi data: only dictatorships with legislature
mixlogit realcoal_flag if cowid != 750 & ddlegis>0, group(cyear) 
		rand(coal_maxgrp_flag singlemaj_flag coalminwin_flag coalosize_flag 
			coalmemb coal_cleav_count)  id(cowid) nrep(500) burn(50)

** Model A29 - Democracy and Dictatorship data - only civilian dictatorships
mixlogit realcoal_flag if cowid != 750 & ddregime==3, group(cyear) 
		rand(coal_maxgrp_flag singlemaj_flag coalminwin_flag coalosize_flag 
			coalmemb coal_cleav_count) id(cowid) nrep(500) burn(50)

** Model A30 - Democracy and Dictatorship data - only military dictatorships
mixlogit realcoal_flag if cowid != 750 & ddregime==4, group(cyear) 
		rand(coal_maxgrp_flag singlemaj_flag coalminwin_flag coalosize_flag 
			coalmemb coal_cleav_count) id(cowid) nrep(500) burn(50)


********************************************************************************
**** Table A17 - Conditional logit models by period
	     
** Model A31 - Cold War
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb coal_cleav_count coalpastprop ///
		     if coldwar==1, group(cyear) vce(cluster cowid)		     		     

** Model A32 - post-Cold War
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb coal_cleav_count coalpastprop ///
		     if coldwar==0, group(cyear) vce(cluster cowid)		     		     

	     

	     
********************************************************************************
**** Table A18 - Negotiated Settlements
** Model A33 - Negotiated Settlements (Hartzell & Hoddie)
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb coal_cleav_count coalpastprop ///
		     if negset==1, group(cyear) vce(cluster cowid)		     		     

** Model A34 - No Negotiated Settlements (Hartzell & Hoddie)
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb coal_cleav_count coalpastprop ///
		     if negset==0, group(cyear) vce(cluster cowid)		     		     

** Model A35 - Negotiated Settlements (UCDP)
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb coal_cleav_count coalpastprop ///
		     if ucdp_negset==1, group(cyear) vce(cluster cowid)		     		     

** Model A36 - No Negotiated Settlements (UCDP)
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb coal_cleav_count coalpastprop ///
		     if ucdp_negset==0, group(cyear) vce(cluster cowid)		     		     


********************************************************************************
**** Table A19 - Institutional Strength
**  Model A37 - High Party System Institutionalization (VDem)
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb coal_cleav_count coalpastprop ///
		     if party_inst==1, group(cyear) vce(cluster cowid)		     		     

** Model A38 - Low Party System Institutionalization (VDem)
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb coal_cleav_count coalpastprop ///
		     if party_inst==0, group(cyear) vce(cluster cowid)		     		     


** Model A39 - Ongoing or past Communist Insurgency (Kalyvas & Balcells)
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb coal_cleav_count coalpastprop ///
		     if comreb_ongoing==1 | comreb_past==1, group(cyear) vce(cluster cowid)		     		     

** Model A40 - No ongoing or past Communist Insurgency
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb coal_cleav_count coalpastprop ///
		     if comreb_ongoing==0 & comreb_past==0, group(cyear) vce(cluster cowid)		     		     


********************************************************************************
**** Table A20 - State Strength
** Model A41 - Low Settler Mortality (Acemoglu & Robinson)
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb coal_cleav_count coalpastprop ///
		     if settmort==1, group(cyear) vce(cluster cowid)		     		     

** Model A42 - High Settler Mortality (Acemoglu & Robinson)
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb coal_cleav_count coalpastprop ///
		     if settmort==0, group(cyear) vce(cluster cowid)		     		     


** Model A43 - High State Antiquity Index
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb coal_cleav_count coalpastprop ///
		     if stahis==1, group(cyear) vce(cluster cowid)		     		     

** Model A44 - Low State Antiquity Index
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb coal_cleav_count coalpastprop ///
		     if stahis==0, group(cyear) vce(cluster cowid)		     		     





********************************************************************************
**** Table A10 - Institution-based sample 
** this table reproduces Models 1 & 2 from Table 1 in the main text
** and reestimates these models on another definition of formation opportunities
** the data required to estimate Models A5 & A7 is available upon request


** Model A4
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
			coal_maxgrp_flag coalmemb, group(cyear) vce(cluster cowid)

		     
** Model A6
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb coal_cleav_count, ///
		     group(cyear) vce(cluster cowid)

* load data
insheet using "", comma clear // add data file name between quotation marks

** Model A5
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb, ///
		     group(cyear) vce(cluster cowid)

** Model A7
clogit realcoal_flag singlemaj_flag coalminwin_flag coalosize_flag ///
		     coal_maxgrp_flag coalmemb coal_cleav_count, ///
		     group(cyear) vce(cluster cowid)
