/*----------------------------------------------------------------------
 
 REPLICATION FILE FOR
 Gerber, Alan S., Gregory A. Huber, Albert H. Fang, and Andrew Gooch. (Forthcoming)
 "Non-Governmental Campaign Communication Providing Ballot Secrecy Assurances Increases
   Turnout: Results from Two Large Scale Experiments"
 Political Science Research and Methods
 
 FILE: 			01_CreatePublicDataset.do
 DESCRIPTION: 	Creates public dataset (provided to show how the file is created only)
 DATE: 			14 Dec 2016
 VERSION: 		1.0

----------------------------------------------------------------------*/

* Load data

use "../AnalyzeData/DeidentifiedData/VPC_NewRegistrantExp_NoPII.dta", clear
des

* Drop variables that are not needed for the analyses in the paper

drop voted10_* voted12_* voted14_* ipw_t2* ipw_t6* ipw_t3_hh1_married_nv ///
	under_over_55 t6_* state_num gender_num race_num married_num ///
	ipw_t3_pooled_st 		///
	ipw_t3_hh1_age 		///
	ipw_t3_hh1_race 		///
	ipw_t3_hh1_gender 		///
	ipw_t3_hh1_married 		///
	ipw_t3_hhmixed 		///
	ipw_t3_pooled_st_nvhh 


* Save dataset

compress
des

saveold PublicReplicationData.dta , replace version(12)
