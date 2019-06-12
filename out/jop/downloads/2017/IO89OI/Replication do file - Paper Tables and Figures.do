/******************************************************************************

Replication Materials for Tables and Figures in:

"Can’t Buy Them Love:  How Party Culture among Donors Contributes to the Party Gap in Women’s Representation "

By Melody Crowder-Meyer and Rosalyn Cooperman

The Journal of Politics 


Notes: 
Codebook provided at end of this Do File
Please see separate Do File for Replication of Online Appendix Materials

******************************************************************************/

* use 2014 NSS.dta

// Table 1 

* Models 1 and 2
	regress motiv_sex_rev repub womPACdonor female whiteonly age income education ideology, robust  
	regress motiv_sex_rev repub womPACdonor female whiteonly age income education ideology evangelical womstmt_3, robust  
* Models 3 and 4
	regress issue_gender repub womPACdonor female whiteonly age income education ideology, robust
	regress issue_gender repub womPACdonor female whiteonly age income education ideology evangelical womstmt_3, robust 
* Models 5 and 6
	regress sup_pop repub womPACdonor female whiteonly age income education ideology, robust
	regress sup_pop repub womPACdonor female whiteonly age income education ideology evangelical womstmt_3, robust 


// Table 2
* Models 1 and 2
	logit sn_gender repub womPACdonor female whiteonly age income education ideology, robust  
	logit sn_gender repub womPACdonor female whiteonly age income education ideology evangelical womstmt_3, robust  
* Models 3 and 4
	logit check_gender repub womPACdonor female whiteonly age income education ideology, robust  
	logit check_gender repub womPACdonor female whiteonly age income education ideology evangelical womstmt_3, robust  



// Figures 1 and 2
* First tabulation for each group contains figures for Democratic and Republican *party* donors in Figures 1 and 2
* Second tabulation for each group contains figures for Liberal and Conservative Women's PAC donors in Figures 1 and 2

	tab grp_teaparty repub if womPACdonor==0, col
	tab grp_teaparty repub if womPACdonor==1, col

	tab grp_prosperity repub if womPACdonor==0, col
	tab grp_prosperity repub if womPACdonor==1, col

	tab grp_crossroads repub if womPACdonor==0, col
	tab grp_crossroads repub if womPACdonor==1, col

	tab grp_susan repub if womPACdonor==0, col
	tab grp_susan repub if womPACdonor==1, col

	tab grp_rfc repub if womPACdonor==0, col
	tab grp_rfc repub if womPACdonor==1, col

	tab grp_shepac repub if womPACdonor==0, col
	tab grp_shepac repub if womPACdonor==1, col

	tab grp_maggie repub if womPACdonor==0, col
	tab grp_maggie repub if womPACdonor==1, col

	tab grp_viewpac repub if womPACdonor==0, col
	tab grp_viewpac repub if womPACdonor==1, col

	tab grp_emily repub if womPACdonor==0, col
	tab grp_emily repub if womPACdonor==1, col

	tab grp_now repub if womPACdonor==0, col
	tab grp_now repub if womPACdonor==1, col

	tab grp_actblue repub if womPACdonor==0, col
	tab grp_actblue repub if womPACdonor==1, col

	tab grp_moveon repub if womPACdonor==0, col
	tab grp_moveon repub if womPACdonor==1, col


	
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
motiv_sex_rev - Motivated to act by candidate sex/gender; 1-3; 1=None of activity motivated by sex/gender, 3=A lot
issue_gender - Gender issues important to candidate support; 1-3; 1=Gender issues not important, 3=very important
sup_pop - Specific population groups used to find candidate to support; 1-4; 1=Specific population groups never used, 4=used in most elections
sn_gender - Gender group helped decide on candidates to support; 0/1; 0=gender group not listed in open-ended response, 1=gender group listed
check_gender - Gender group delivered check to candidate; 0/1; 0=gender group not listed in open-ended response, 1=gender group listed
grp_***** - Level of familiarity with various groups; 1-4; 1=Never heard of group, 4=actively support group

******************************************************************************/

