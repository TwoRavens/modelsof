* This file replicates the empirical analysis presented in "External Threat and Alliance Formation"
* Jesse C. Johnson
* 6/30/16

set more off
cd "E:\Jesse's Documents\Alliance and External Threat\JohnsonISQrep\"
use "JohnsonISQrep.dta", clear
 
 * Table 1
 
	tab form if allied==0 & sample==1
	tab form if allied==0 & precold==1 & sample==1
	tab form if allied==0 & cold==1 & sample==1
	tab form if allied==0 & precold==0 & cold==0 & sample==1
 
	tab form if allied==0 & icow==1 & sample==1
	tab form if allied==0 & icow==1 & precold==1 & sample==1
	tab form if allied==0 & icow==1 & cold==1 & sample==1
	tab form if allied==0 & icow==1 & precold==0 & cold==0 & sample==1
 
* Table 2

	probit form c_win t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0  
	probit form c_wina t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0  
	probit form c_spend t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0   
	
	probit form c_win t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0  & icow==1
	probit form c_wina t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & icow==1 
	probit form c_spend t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & icow==1
	
* Table 3

	probit form c_win t_maj ct_contig c_ally precold cold form_years form_years2 form_years3   
	probit form c_win t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & big==0
			logit form c_win t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0  
			predict db1, dbeta
	probit form c_win t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & db1<.02
			drop db1
	
	probit form c_win t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if icow==1
	probit form c_win t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & icow==1 & big==0
			logit form c_win t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & icow==1
			predict db2, dbeta
	probit form c_win t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & icow==1 & db2<.1
			drop db2

* Table 4
	
	probit form midcount if allied==0  & sample==1
	probit form midcount t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & sample==1
	probit form midcount c_win t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & sample==1 

	probit form midcount if allied==0  & icow==1 & sample==1
	probit form midcount t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0  & icow==1 & sample==1
	probit form midcount t_maj c_win ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0  & icow==1 & sample==1
	
********************************************************************************************************************************

* Appendix

* Figures A1 and A2: Delta-Beta Scatterplots

	logit form c_win t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0  
	predict db1, dbeta
	scatter db1 tc, scheme(s1mono) ytitle("Pregibon's Delta-Beta") yline(.02, lpattern(dash)) plotregion(margin(medium)) 
	drop db1
	
	logit form c_win t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & icow==1
	predict db2, dbeta
	scatter db2 tc, scheme(s1mono) ytitle("Pregibon's Delta-Beta") yline(.1, lpattern(dash)) plotregion(margin(medium)) 
	drop db2
	
* Table A1: Classical versus Robust Standard Errors 

	probit form c_win t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 
	probit form c_win t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0, robust  

	probit form c_wina t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0  
	probit form c_wina t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0, robust  

	probit form c_spend t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0   
	probit form c_spend t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0, robust   		

* Table A2: Classical versus Robust Standard Errors (Territory)

	probit form c_win t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & icow==1
	probit form c_win t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & icow==1, robust  

	probit form c_wina t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & icow==1  
	probit form c_wina t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & icow==1, robust  

	probit form c_spend t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & icow==1   
	probit form c_spend t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & icow==1, robust   	
	
* Table A3: Politically Relevant Dyads

	probit form c_win t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0  & pol_rel==1
	probit form c_wina t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & pol_rel==1 
	probit form c_spend t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & pol_rel==1	
	
* Table A4: Region 
	
	probit form c_win t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 eur afr me asia if allied==0 & icow==1 & reg_id==1
	probit form c_wina t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 eur afr me asia if allied==0 & icow==1 & reg_id==1
	probit form c_spend t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 eur afr me asia if allied==0 & icow==1 & reg_id==1

* Table A5: Contiguity

	probit form c_win t_maj c_ally precold cold form_years form_years2 form_years3 if allied==0  
	probit form c_wina t_maj c_ally precold cold form_years form_years2 form_years3 if allied==0  
	probit form c_spend t_maj c_ally precold cold form_years form_years2 form_years3 if allied==0   
	
	probit form c_win t_maj c_ally precold cold form_years form_years2 form_years3 if allied==0  & icow==1
	probit form c_wina t_maj c_ally precold cold form_years form_years2 form_years3 if allied==0 & icow==1 
	probit form c_spend t_maj c_ally precold cold form_years form_years2 form_years3 if allied==0 & icow==1
	
* Table A6: Low Level MIDs

	probit form midcount_low if allied==0 & sample==1
	probit form midcount_low t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & sample==1 
	probit form midcount_low c_win t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & sample==1

	probit form midcount_low if allied==0  & icow==1 & sample==1
	probit form midcount_low t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0  & icow==1 & sample==1
	probit form midcount_low t_maj c_win ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0  & icow==1 & sample==1
	
* Table A7: US & Soviet Cold War Alliances

	probit form c_win t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & us_cold==0 & sov_cold==0
	probit form c_wina t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & us_cold==0 & sov_cold==0  
	probit form c_spend t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & us_cold==0 & sov_cold==0
	
	probit form c_win t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0  & icow==1 & us_cold==0 & sov_cold==0
	probit form c_wina t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & icow==1 & us_cold==0 & sov_cold==0
	probit form c_spend t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & icow==1 & us_cold==0 & sov_cold==0
		
* Table A8: Alliances with Non-military Organizations

	probit form c_win t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & nonmilorg~=1
	probit form c_wina t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & nonmilorg~=1 
	probit form c_spend t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & nonmilorg~=1 
	
	probit form c_win t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0  & icow==1 & nonmilorg~=1
	probit form c_wina t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & icow==1 & nonmilorg~=1
	probit form c_spend t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0 & icow==1 & nonmilorg~=1
	
* Table A9: Military Personnel

	probit form c_pers t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0  

	probit form c_pers t_maj ct_contig c_ally precold cold form_years form_years2 form_years3 if allied==0  & icow==1
