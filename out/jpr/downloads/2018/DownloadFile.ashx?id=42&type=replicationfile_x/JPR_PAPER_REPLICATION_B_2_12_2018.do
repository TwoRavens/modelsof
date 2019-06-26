* *********************************************************** *
* *********************************************************** *
* "Leader survival and purges after a failed coup d'etat"     *   
* JPR Forthcoming                                             *
* Malcolm Easton and Randolph Siversion (February 2018)       *
* mreaston@ucdavis.edu, rmsiverson@ucdavis.edu                *
* *********************************************************** * 
* *********************************************************** *


	


	
	use "C:\Users\Muskoka\Documents\Malcolm's Folder\UC Davis\Dropbox\My Dropbox\Siverson_1\3_28_2017\JPR_PAPER_REPLICATION_AA_2_12_2018.dta", clear
	
	*Table I
	tab purge_XX
	
	
	use "C:\Users\Muskoka\Documents\Malcolm's Folder\UC Davis\Dropbox\My Dropbox\Siverson_1\3_28_2017\JPR_PAPER_REPLICATION_A_2_12_2018.dta", clear

	
	*Table II
	stset tenure_X, failure(lead_out)
	streg success failed_coup age_entry democracy swz, dist(weib) cluster(ccode)
	
	
	
	
	
	use "C:\Users\Muskoka\Documents\Malcolm's Folder\UC Davis\Dropbox\My Dropbox\Siverson_1\3_28_2017\JPR_PAPER_REPLICATION_AA_2_12_2018.dta", clear

	*Table III
	sum pre_coupten_X purge_XX age_entry demd_verified mil_change_1year mil_change_2year if Erdogon==. & Lansana_drop==.


	*Table IV
	*Model (1)
	stset post_coup_time_XX, failure(lead_irreg_XX)
	streg purge_XX demd_verified mil_change_1year mil_change_2year age_entry pre_coupten_X if Erdogon==. & Lansana_drop==., dist(weib) cluster(ccode)
	
	*Model (2)
	streg purge_XX demd_verified purge_demXX mil_change_1year mil_change_2year age_entry pre_coupten_X if Erdogon==. & Lansana_drop==., dist(weib) cluster(ccode)
	
	*Model (3)
	streg purge_XX mil_change_1year mil_change_2year age_entry pre_coupten_X if Erdogon==. & Lansana_drop==. & demd_verified==0, dist(weib) cluster(ccode)
	
	
	
	
	*Table V
	*Model (1)
	stset post_coup_XX, failure(lead_irr2nd)
	streg purge_dum1 purge_dum2 purge_dum3 age_entry pre_coupten_X if Erdogon==. & Lansana_drop==. & demd_verified==0, dist(weib) cluster(ccode)
	
	*Model (2)
	stset post_coup_XX, failure(lead_2nd_coup)
	streg purge_dum1 purge_dum2 purge_dum3 age_entry pre_coupten_X if Erdogon==. & Lansana_drop==. & demd_verified==0, dist(weib)	cluster(ccode)	


 