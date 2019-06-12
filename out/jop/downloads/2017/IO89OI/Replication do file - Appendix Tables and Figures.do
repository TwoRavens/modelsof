/******************************************************************************

Replication Materials for Tables and Figures in Online Appendix of:

"Can’t Buy Them Love:  How Party Culture among Donors Contributes to the Party Gap in Women’s Representation"

By Melody Crowder-Meyer and Rosalyn Cooperman

The Journal of Politics 


Notes: 
Codebook provided at end of this Do File
Please see separate Do File for Replication of Paper Materials

******************************************************************************/

// Table A.4 and A.5

* Table A.4 Model 1
* use 2014 NSS - never heard.dta
	logit neverhrd_grp_  WRPD##repub##ConsGrp female womPACdonor whiteonly ideology OrgAgein2014, vce(cluster Identifier)
	* Table A.5 Never Heard probabilities
	margins WRPD, at(repub=1 ConsGrp==1 female=1 womPACdonor=1 whiteonly=1) atmeans 
	margins WRPD, at(repub=0 ConsGrp==0 female=1 womPACdonor=1 whiteonly=1) atmeans


* Table A.4 Model 2
* use 2014 NSS - active support.dta
	logit activesupt_grp_  WRPD##repub##ConsGrp female womPACdonor whiteonly ideology OrgAgein2014, vce(cluster Identifier)
	* Table A.5 Actively Support probabilities 
	margins WRPD, at(repub=1 ConsGrp==1 female=1 womPACdonor=1 whiteonly=1) atmeans 
	margins WRPD, at(repub=0 ConsGrp==0 female=1 womPACdonor=1 whiteonly=1) atmeans


// Table A.7
* use 2014 NSS.dta

* Models 1 and 2
	regress motiv_ideology_rev repub womPACdonor female whiteonly age income education ideology , robust 
	regress motiv_ideology_rev repub womPACdonor female whiteonly age income education ideology evangelical womstmt_3, robust 
* Models 3 and 4
	logit sn_ideology repub womPACdonor female whiteonly age income education ideology, robust  
	logit sn_ideology repub womPACdonor female whiteonly age income education ideology evangelical womstmt_3, robust  
* Models 5 and 6
	logit check_ideology repub womPACdonor female whiteonly age income education ideology, robust  
	logit check_ideology repub womPACdonor female whiteonly age income education ideology evangelical womstmt_3, robust  

	
	
// Table A.8
* use 2014 NSS.dta

regress issue_race repub womPACdonor female whiteonly age income education ideology, robust 
regress issue_race repub womPACdonor female whiteonly age income education ideology evangelical womstmt_3, robust 

	
	

// Figures A.1 and A.2
* use 2014 NSS.dta

tab grp_teaparty repub if female==0, col
tab grp_teaparty repub if female==1, col
tab grp_teaparty repub if evangelical==0, col
tab grp_teaparty repub if evangelical==1, col
tab grp_teaparty repub if libwomstmt_3==0, col
tab grp_teaparty repub if libwomstmt_3==1, col

tab grp_prosperity repub if female==0, col
tab grp_prosperity repub if female==1, col
tab grp_prosperity repub if evangelical==0, col
tab grp_prosperity repub if evangelical==1, col
tab grp_prosperity repub if libwomstmt_3==0, col
tab grp_prosperity repub if libwomstmt_3==1, col

tab grp_crossroads repub if female==0, col
tab grp_crossroads repub if female==1, col
tab grp_crossroads repub if evangelical==0, col
tab grp_crossroads repub if evangelical==1, col
tab grp_crossroads repub if libwomstmt_3==0, col
tab grp_crossroads repub if libwomstmt_3==1, col

tab grp_susan repub if female==0, col
tab grp_susan repub if female==1, col
tab grp_susan repub if evangelical==0, col
tab grp_susan repub if evangelical==1, col
tab grp_susan repub if libwomstmt_3==0, col
tab grp_susan repub if libwomstmt_3==1, col

tab grp_rfc repub if female==0, col
tab grp_rfc repub if female==1, col
tab grp_rfc repub if evangelical==0, col
tab grp_rfc repub if evangelical==1, col
tab grp_rfc repub if libwomstmt_3==0, col
tab grp_rfc repub if libwomstmt_3==1, col

tab grp_shepac repub if female==0, col
tab grp_shepac repub if female==1, col
tab grp_shepac repub if evangelical==0, col
tab grp_shepac repub if evangelical==1, col
tab grp_shepac repub if libwomstmt_3==0, col
tab grp_shepac repub if libwomstmt_3==1, col

tab grp_maggie repub if female==0, col
tab grp_maggie repub if female==1, col
tab grp_maggie repub if evangelical==0, col
tab grp_maggie repub if evangelical==1, col
tab grp_maggie repub if libwomstmt_3==0, col
tab grp_maggie repub if libwomstmt_3==1, col

tab grp_viewpac repub if female==0, col
tab grp_viewpac repub if female==1, col
tab grp_viewpac repub if evangelical==0, col
tab grp_viewpac repub if evangelical==1, col
tab grp_viewpac repub if libwomstmt_3==0, col
tab grp_viewpac repub if libwomstmt_3==1, col

tab grp_emily repub if female==0, col
tab grp_emily repub if female==1, col
tab grp_emily repub if evangelical==0, col
tab grp_emily repub if evangelical==1, col
tab grp_emily repub if libwomstmt_3==0, col
tab grp_emily repub if libwomstmt_3==1, col

tab grp_now repub if female==0, col
tab grp_now repub if female==1, col
tab grp_now repub if evangelical==0, col
tab grp_now repub if evangelical==1, col
tab grp_now repub if libwomstmt_3==0, col
tab grp_now repub if libwomstmt_3==1, col

tab grp_actblue repub if female==0, col
tab grp_actblue repub if female==1, col
tab grp_actblue repub if evangelical==0, col
tab grp_actblue repub if evangelical==1, col
tab grp_actblue repub if libwomstmt_3==0, col
tab grp_actblue repub if libwomstmt_3==1, col

tab grp_moveon repub if female==0, col
tab grp_moveon repub if female==1, col
tab grp_moveon repub if evangelical==0, col
tab grp_moveon repub if evangelical==1, col
tab grp_moveon repub if libwomstmt_3==0, col
tab grp_moveon repub if libwomstmt_3==1, col


/******************************************************************************

Codebook:

Please see the paper and Online Appendix for additional details about question wordings and variables

repub - Respondent party identification; 0/1; 0=Democrat, 1=Republican
womPACdonor - Group to which respondent contributed; 0/1; 0=Party Committee, 1=Women's PAC
female - Respondent gender; 0/1; 0=male, 1=female
whiteonly - Respondent race; 0/1; 0=Other races, 1=white
age - Respondent age; 26-100; age in years old
income - Respondent family income; 1-6; higher values = higher income
education - Respondent education; 1-5; higher values = more education
ideology - Respondent ideology; 1-7; 1=Very liberal, 4=Moderate, 7=Very Conservative
evangelical - Respondent evangelical identification; 0/1; 0=not "born again or Evangelical", 1="born again or Evangelical"
womstmt_3 - Gender role views; 1-6; 1=strongly agree almost impossible to be good wife and mother and hold public office, 6=strongly disagree
libwomstmt_3 - Gender role views; 0/1; 0=strongly to slightly agree almost impossible to be good wife and mother and hold public office, 1=strongly to slightly disagree
motiv_ideology_rev - Motivated to act by candidate's ideology; 1-3; 1=None of activity motivated by ideology, 3=A lot
sn_ideology - Ideological group helped decide on candidates to support; 0/1; 0=ideological group not listed in open-ended response, 1=ideological group listed
check_ideology - Ideological group delivered check to candidate; 0/1; 0=ideological group not listed in open-ended response, 1=ideological group listed
issue_race - Racial/ethnic issues important to candidate support; 1-3; 1=Racial/ethnic issues not important, 3=very important
grp_***** - Level of familiarity with various groups; 1-4; 1=Never heard of group, 4=actively support group
WRPD - Group asked about is Women's Representation Policy Demander; 0/1; 0=non-WRPD group, 1=WRPD group
ConsGrp - Group asked about is conservative; 0/1; 0=liberal group, 1=conservative group
OrgAgein2014 - Group asked about age; 2-48; Number of years between organization's founding and 2014 (year of survey)
Identifier - Unique identifier for each respondent 
******************************************************************************/
