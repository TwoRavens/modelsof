*get data
clear
use "/[FILE-PATH]/data for R&R 2.dta"

*OVERALL CONCERN
	*recode to run low to high
generate zikaconcern=.
replace zikaconcern=1 if MIA438==5
replace zikaconcern=2 if MIA438==4
replace zikaconcern=3 if MIA438==3
replace zikaconcern=4 if MIA438==2
replace zikaconcern=5 if MIA438==1
tab MIA438 zikaconcern [aweight=weight]
summarize zikaconcern [aweight=weight]
tab zikaconcern [aweight=weight]
tabstat zikaconcern [aweight=weight], stats(mean sd semean min max n)
	
*CREATE CONSPIRACY VARIABLE
	*recode all variables to run low-high on conspiratorial beliefs
		*Much of our lives are being controlled by plots hatched in secret places
generate plots=.
replace plots=1 if MIA342a==5
replace plots=2 if MIA342a==4
replace plots=3 if MIA342a==3
replace plots=4 if MIA342a==2
replace plots=5 if MIA342a==1
tab MIA342a plots
		*Even though we live in a democracy, a few people will always run things anyway
generate few_people=.
replace few_people=1 if MIA342b==5
replace few_people=2 if MIA342b==4
replace few_people=3 if MIA342b==3
replace few_people=4 if MIA342b==2
replace few_people=5 if MIA342b==1
tab MIA342b few_people
		*The people who really 'run' the country, are not known to the voters
generate not_known=.
replace not_known=1 if MIA342c==5
replace not_known=2 if MIA342c==4
replace not_known=3 if MIA342c==3
replace not_known=4 if MIA342c==2
replace not_known=5 if MIA342c==1
tab MIA342c not_known
		*Big events ... are controlled by small groups of people who are working in secret against the rest of us
generate big_events=.
replace big_events=1 if MIA344b==5
replace big_events=2 if MIA344b==4
replace big_events=3 if MIA344b==3
replace big_events=4 if MIA344b==2
replace big_events=5 if MIA344b==1
tab MIA344b big_events
	*run pca
factor plots few_people not_known big_events [aweight=weight], pcf
rotate
	*get and save PC1 scores as a new variable (factor1)
predict factor1
summarize factor1
	*rescale factor1 to run 0-1 into new variable (consp_beliefs), where 0 = least and 1 = most conspiratorial
generate consp_beliefs=(factor1-(-2.951893 ))/(2.03734 - (-2.951893 ))
summarize consp_beliefs  [aweight=weight]
tabstat consp_beliefs [aweight=weight], stats(mean sd semean min max n)
pwcorr factor1 consp_beliefs [aweight=weight], sig  

*RECODE PID TO CLEAN UP MISSING CASES
generate dem_rep=.
replace dem_rep=1 if pid7==1
replace dem_rep=2 if pid7==2
replace dem_rep=3 if pid7==3
replace dem_rep=4 if pid7==4
replace dem_rep=5 if pid7==5
replace dem_rep=6 if pid7==6
replace dem_rep=7 if pid7==7
tab dem_rep 
tab pid7 
tabstat dem_rep [aweight=weight], stats(mean sd semean min max n)

*DESCRIPTIVES ON ED
tabstat educ [aweight=weight], stats(mean sd semean min max n)

*RECODE KIDS IN FUTURE
generate kidsinfuture=.
replace kidsinfuture=1 if MIA441==1
replace kidsinfuture=0 if MIA441==2
tab MIA441  
tab kidsinfuture
tabstat kidsinfuture [aweight=weight], stats(mean sd semean min max n)  

*RECODE GENDER
generate female=.
replace female=1 if gender==2
replace female=0 if gender==1
tab female  
tab gender
tabstat female [aweight=weight], stats(mean sd semean min max n) 

*DESCRIPTIVES ON BIRTH YEAR
tabstat birthyr [aweight=weight], stats(mean sd semean min max n)

*RECODE IMP RELIGION
generate religious=.
replace religious=1 if pew_religimp==4
replace religious=2 if pew_religimp==3
replace religious=3 if pew_religimp==2
replace religious=4 if pew_religimp==1
tab pew_religimp
tab religious
tabstat religious [aweight=weight], stats(mean sd semean min max n)

*RECODE NO HEALTH INSURANCE
generate noinsurance=.
replace noinsurance=1 if healthins_6==1
replace noinsurance=0 if healthins_6==2
tab noinsurance
tab healthins_6
tabstat noinsurance [aweight=weight], stats(mean sd semean min max n)

*CREATE NUMBER OF ZIKA CASES BY STATE MEASURE (03/09/17)
generate zikacases=.
replace zikacases=0 if inputstate==2
replace zikacases=38 if inputstate==1
replace zikacases=55 if inputstate==4
replace zikacases=15 if inputstate==5
replace zikacases=426 if inputstate==6
replace zikacases=55 if inputstate==8
replace zikacases=58 if inputstate==9
replace zikacases=17 if inputstate==10
replace zikacases=31 if inputstate==11
replace zikacases=1083 if inputstate==12
replace zikacases=109 if inputstate==13
replace zikacases=16 if inputstate==15
replace zikacases=5 if inputstate==16
replace zikacases=94 if inputstate==17
replace zikacases=53 if inputstate==18
replace zikacases=26 if inputstate==19
replace zikacases=22 if inputstate==20
replace zikacases=32 if inputstate==21
replace zikacases=39 if inputstate==22
replace zikacases=14 if inputstate==23
replace zikacases=131 if inputstate==24
replace zikacases=121 if inputstate==25
replace zikacases=68 if inputstate==26
replace zikacases=64 if inputstate==27
replace zikacases=25 if inputstate==28
replace zikacases=36 if inputstate==29
replace zikacases=9 if inputstate==30
replace zikacases=13 if inputstate==31
replace zikacases=22 if inputstate==32
replace zikacases=12 if inputstate==33
replace zikacases=180 if inputstate==34
replace zikacases=10 if inputstate==35
replace zikacases=1004 if inputstate==36
replace zikacases=91 if inputstate==37
replace zikacases=3 if inputstate==38
replace zikacases=85 if inputstate==39
replace zikacases=29 if inputstate==40
replace zikacases=47 if inputstate==41
replace zikacases=174 if inputstate==42
replace zikacases=54 if inputstate==44
replace zikacases=54 if inputstate==45
replace zikacases=2 if inputstate==46
replace zikacases=61 if inputstate==47
replace zikacases=312 if inputstate==48
replace zikacases=22 if inputstate==49
replace zikacases=11 if inputstate==50
replace zikacases=113 if inputstate==51
replace zikacases=70 if inputstate==53
replace zikacases=11 if inputstate==54
replace zikacases=50 if inputstate==55
replace zikacases=55 if inputstate==2
summarize zikacases
tabstat zikacases [aweight=weight], stats(mean sd semean min max n)

*CREATE GOOGLE TRENDS MEASURE BY STATE MEASURE (11/2016)
generate google=.
replace google=74 if inputstate==2
replace google=29 if inputstate==1
replace google=37 if inputstate==4
replace google=31 if inputstate==5
replace google=45 if inputstate==6
replace google=51 if inputstate==8
replace google=76 if inputstate==9
replace google=77 if inputstate==10
replace google=81 if inputstate==11
replace google=94 if inputstate==12
replace google=43 if inputstate==13
replace google=63 if inputstate==15
replace google=38 if inputstate==16
replace google=51 if inputstate==17
replace google=38 if inputstate==18
replace google=41 if inputstate==19
replace google=37 if inputstate==20
replace google=33 if inputstate==21
replace google=41 if inputstate==22
replace google=59 if inputstate==23
replace google=76 if inputstate==24
replace google=77 if inputstate==25
replace google=41 if inputstate==26
replace google=55 if inputstate==27
replace google=29 if inputstate==28
replace google=47 if inputstate==29
replace google=32 if inputstate==30
replace google=53 if inputstate==31
replace google=33 if inputstate==32
replace google=61 if inputstate==33
replace google=64 if inputstate==34
replace google=32 if inputstate==35
replace google=89 if inputstate==36
replace google=41 if inputstate==37
replace google=69 if inputstate==38
replace google=37 if inputstate==39
replace google=25 if inputstate==40
replace google=29 if inputstate==41
replace google=47 if inputstate==42
replace google=90 if inputstate==44
replace google=42 if inputstate==45
replace google=83 if inputstate==46
replace google=28 if inputstate==47
replace google=40 if inputstate==48
replace google=45 if inputstate==49
replace google=100 if inputstate==50
replace google=49 if inputstate==51
replace google=44 if inputstate==53
replace google=31 if inputstate==54
replace google=50 if inputstate==55
replace google=49 if inputstate==2
summarize google
tabstat google [aweight=weight], stats(mean sd semean min max n)
pwcorr google zikacases zikaconcern, sig

*FLIP TRUST ON LOCAL GOV'T
generate loc_trust=.
replace loc_trust=1 if MIA304c==3
replace loc_trust=2 if MIA304c==2
replace loc_trust=3 if MIA304c==1
tab MIA304c loc_trust
tabstat loc_trust [aweight=weight], stats(mean sd semean min max n)

*FLIP GENERAL GOV'T TRUST
generate gov_trust=.
replace gov_trust=1 if MIA342d==5
replace gov_trust=2 if MIA342d==4
replace gov_trust=3 if MIA342d==3
replace gov_trust=4 if MIA342d==2
replace gov_trust=5 if MIA342d==1
tab MIA342d gov_trust
tabstat gov_trust [aweight=weight], stats(mean sd semean min max n)
	*now look at correlation between the two trust measures for text/R&R memo reference
pwcorr gov_trust loc_trust, sig
ttest gov_trust == loc_trust

*CLEAN UP IDEOLOGY
generate lib_con=.
replace lib_con=1 if CC16_340a==1
replace lib_con=2 if CC16_340a==2
replace lib_con=3 if CC16_340a==3
replace lib_con=4 if CC16_340a==4
replace lib_con=5 if CC16_340a==5
replace lib_con=6 if CC16_340a==6
replace lib_con=7 if CC16_340a==7
tab lib_con CC16_340a

*TABLE 1: WHO SHOULD DO WHAT
		*educate public (MIA439a)
tab MIA439a_1 [aweight=weight]
tab MIA439a_2 [aweight=weight]
tab MIA439a_3 [aweight=weight]
tab MIA439a_4 [aweight=weight]
tab MIA439a_5 [aweight=weight]
tab MIA439a_6 [aweight=weight]
tab MIA439a_7 [aweight=weight]
		*use insecticides (MIA439b)
tab MIA439b_1 [aweight=weight]
tab MIA439b_2 [aweight=weight]
tab MIA439b_3 [aweight=weight]
tab MIA439b_4 [aweight=weight]
tab MIA439b_5 [aweight=weight]
tab MIA439b_6 [aweight=weight]
tab MIA439b_7 [aweight=weight]
		*fine for standing water (MIA439c)
tab MIA439c_1 [aweight=weight]
tab MIA439c_2 [aweight=weight]
tab MIA439c_3 [aweight=weight]
tab MIA439c_4 [aweight=weight]
tab MIA439c_5 [aweight=weight]
tab MIA439c_6 [aweight=weight]
tab MIA439c_7 [aweight=weight]
		*delay pregnancy (MIA439d)
tab MIA439d_1 [aweight=weight]
tab MIA439d_2 [aweight=weight]
tab MIA439d_3 [aweight=weight]
tab MIA439d_4 [aweight=weight]
tab MIA439d_5 [aweight=weight]
tab MIA439d_6 [aweight=weight]
tab MIA439d_7 [aweight=weight]
		*travel bans (MIA439e)
tab MIA439e_1 [aweight=weight]
tab MIA439e_2 [aweight=weight]
tab MIA439e_3 [aweight=weight]
tab MIA439e_4 [aweight=weight]
tab MIA439e_5 [aweight=weight]
tab MIA439e_6 [aweight=weight]
tab MIA439e_7 [aweight=weight]
		*fund research (MIA439f)
tab MIA439f_1 [aweight=weight]
tab MIA439f_2 [aweight=weight]
tab MIA439f_3 [aweight=weight]
tab MIA439f_4 [aweight=weight]
tab MIA439f_5 [aweight=weight]
tab MIA439f_6 [aweight=weight]
tab MIA439f_7 [aweight=weight]
		*GMMs(MIA439g)
tab MIA439g_1 [aweight=weight]
tab MIA439g_2 [aweight=weight]
tab MIA439g_3 [aweight=weight]
tab MIA439g_4 [aweight=weight]
tab MIA439g_5 [aweight=weight]
tab MIA439g_6 [aweight=weight]
tab MIA439g_7 [aweight=weight]

*RECODE: CONVERT ALL POLICY OPTIONS TO 0/1
	*educate public (MIA439a)
		*feds
generate ed_feds=.
replace ed_feds=1 if MIA439a_1==1
replace ed_feds=0 if MIA439a_1==2
tab MIA439a_1 ed_feds
		*state
generate ed_state=.
replace ed_state=1 if MIA439a_2==1
replace ed_state=0 if MIA439a_2==2
tab MIA439a_2 ed_state
		*local
generate ed_local=.
replace ed_local=1 if MIA439a_3==1
replace ed_local=0 if MIA439a_3==2
tab MIA439a_3 ed_local		
		*non-profits
generate ed_np=.
replace ed_np=1 if MIA439a_4==1
replace ed_np=0 if MIA439a_4==2
tab MIA439a_4 ed_np
		*private sector
generate ed_priv=.
replace ed_priv=1 if MIA439a_5==1
replace ed_priv=0 if MIA439a_5==2
tab MIA439a_5 ed_priv
		*individuals
generate ed_indv=.
replace ed_indv=1 if MIA439a_6==1
replace ed_indv=0 if MIA439a_6==2
tab MIA439a_6 ed_indv
		*no one (note that we are flipping this one to be 1 = no, 0 = yes to get values for figure 2)
generate ed_no=.
replace ed_no=1 if MIA439a_7==2
replace ed_no=0 if MIA439a_7==1
tab MIA439a_7 ed_no
ci means ed_no [aweight=weight]
	*use insecticides (MIA439b)
		*feds
generate in_feds=.
replace in_feds=1 if MIA439b_1==1
replace in_feds=0 if MIA439b_1==2
tab MIA439b_1 in_feds
		*state
generate in_state=.
replace in_state=1 if MIA439b_2==1
replace in_state=0 if MIA439b_2==2
tab MIA439b_2 in_state
		*local
generate in_local=.
replace in_local=1 if MIA439b_3==1
replace in_local=0 if MIA439b_3==2
tab MIA439b_3 in_local
		*non-profits
generate in_np=.
replace in_np=1 if MIA439b_4==1
replace in_np=0 if MIA439b_4==2
tab MIA439b_4 in_np
		*private sector
generate in_priv=.
replace in_priv=1 if MIA439b_5==1
replace in_priv=0 if MIA439b_5==2
tab MIA439b_5 in_priv
		*individuals
generate in_indv=.
replace in_indv=1 if MIA439b_6==1
replace in_indv=0 if MIA439b_6==2
tab MIA439b_6 in_indv
		*no one (note that we are flipping this one to be 1 = no, 0 = yes to get values for figure 2)
generate in_no=.
replace in_no=1 if MIA439b_7==2
replace in_no=0 if MIA439b_7==1
tab MIA439b_7 in_no
ci means in_no [aweight=weight]
	*fine for standing water (MIA439c)
		*feds
generate fine_feds=.
replace fine_feds=1 if MIA439c_1==1
replace fine_feds=0 if MIA439c_1==2
tab MIA439c_1 fine_feds
		*state
generate fine_state=.
replace fine_state=1 if MIA439c_2==1
replace fine_state=0 if MIA439c_2==2
tab MIA439c_2 fine_state
		*local
generate fine_local=.
replace fine_local=1 if MIA439c_3==1
replace fine_local=0 if MIA439c_3==2
tab MIA439c_3 fine_local
		*non-profits
generate fine_np=.
replace fine_np=1 if MIA439c_4==1
replace fine_np=0 if MIA439c_4==2
tab MIA439c_4 fine_np
		*private sector
generate fine_priv=.
replace fine_priv=1 if MIA439c_5==1
replace fine_priv=0 if MIA439c_5==2
tab MIA439c_5 fine_priv
		*individuals
generate fine_indv=.
replace fine_indv=1 if MIA439c_6==1
replace fine_indv=0 if MIA439c_6==2
tab MIA439c_6 fine_indv
		*no one (note that we are flipping this one to be 1 = no, 0 = yes to get values for figure 2)
generate fine_no=.
replace fine_no=1 if MIA439c_7==2
replace fine_no=0 if MIA439c_7==1
tab MIA439c_7 fine_no
ci means fine_no [aweight=weight]
	*delay pregnancy (MIA439d)
		*feds
generate preg_feds=.
replace preg_feds=1 if MIA439d_1==1
replace preg_feds=0 if MIA439d_1==2
tab MIA439d_1 preg_feds
		*state
generate preg_state=.
replace preg_state=1 if MIA439d_2==1
replace preg_state=0 if MIA439d_2==2
tab MIA439d_2 preg_state
		*local
generate preg_local=.
replace preg_local=1 if MIA439d_3==1
replace preg_local=0 if MIA439d_3==2
tab MIA439d_3 preg_local
		*non-profits
generate preg_np=.
replace preg_np=1 if MIA439d_4==1
replace preg_np=0 if MIA439d_4==2
tab MIA439d_4 preg_np
		*private sector
generate preg_priv=.
replace preg_priv=1 if MIA439d_5==1
replace preg_priv=0 if MIA439d_5==2
tab MIA439d_5 preg_priv
		*individuals
generate preg_indv=.
replace preg_indv=1 if MIA439d_6==1
replace preg_indv=0 if MIA439d_6==2
tab MIA439d_6 preg_indv
		*no one (note that we are flipping this one to be 1 = no, 0 = yes to get values for figure 2)
generate preg_no=.
replace preg_no=1 if MIA439d_7==2
replace preg_no=0 if MIA439d_7==1
tab MIA439d_7 preg_no
ci means preg_no [aweight=weight]
	*travel bans (MIA439e)
		*feds
generate ban_feds=.
replace ban_feds=1 if MIA439e_1==1
replace ban_feds=0 if MIA439e_1==2
tab MIA439e_1 ban_feds
		*state
generate ban_state=.
replace ban_state=1 if MIA439e_2==1
replace ban_state=0 if MIA439e_2==2
tab MIA439e_2 ban_state
		*local
generate ban_local=.
replace ban_local=1 if MIA439e_3==1
replace ban_local=0 if MIA439e_3==2
tab MIA439e_3 ban_local
		*non-profits
generate ban_np=.
replace ban_np=1 if MIA439e_4==1
replace ban_np=0 if MIA439e_4==2
tab MIA439e_4 ban_np
		*private sector
generate ban_priv=.
replace ban_priv=1 if MIA439e_5==1
replace ban_priv=0 if MIA439e_5==2
tab MIA439e_5 ban_priv
		*individuals
generate ban_indv=.
replace ban_indv=1 if MIA439e_6==1
replace ban_indv=0 if MIA439e_6==2
tab MIA439e_6 ban_indv
		*no one (note that we are flipping this one to be 1 = no, 0 = yes to get values for figure 2)
generate ban_no=.
replace ban_no=1 if MIA439e_7==2
replace ban_no=0 if MIA439e_7==1
tab MIA439e_7 ban_no
ci means ban_no [aweight=weight]
	*fund research (MIA439f)
		*feds
generate res_feds=.
replace res_feds=1 if MIA439f_1==1
replace res_feds=0 if MIA439f_1==2
tab MIA439f_1 res_feds
		*state
generate res_state=.
replace res_state=1 if MIA439f_2==1
replace res_state=0 if MIA439f_2==2
tab MIA439f_2 res_state
		*local
generate res_local=.
replace res_local=1 if MIA439f_3==1
replace res_local=0 if MIA439f_3==2
tab MIA439f_3 res_local
		*non-profits
generate res_np=.
replace res_np=1 if MIA439f_4==1
replace res_np=0 if MIA439f_4==2
tab MIA439f_4 res_np
		*private sector
generate res_priv=.
replace res_priv=1 if MIA439f_5==1
replace res_priv=0 if MIA439f_5==2
tab MIA439f_5 res_priv
		*individuals
generate res_indv=.
replace res_indv=1 if MIA439f_6==1
replace res_indv=0 if MIA439f_6==2
tab MIA439f_6 res_indv
		*no one (note that we are flipping this one to be 1 = no, 0 = yes to get values for figure 2)
generate res_no=.
replace res_no=1 if MIA439f_7==2
replace res_no=0 if MIA439f_7==1
tab MIA439f_7 res_no
ci means res_no [aweight=weight]
	*GMMs(MIA439g)
		*feds
generate gmm_feds=.
replace gmm_feds=1 if MIA439g_1==1
replace gmm_feds=0 if MIA439g_1==2
tab MIA439g_1 gmm_feds
		*state
generate gmm_state=.
replace gmm_state=1 if MIA439g_2==1
replace gmm_state=0 if MIA439g_2==2
tab MIA439g_2 gmm_state
		*local
generate gmm_local=.
replace gmm_local=1 if MIA439g_3==1
replace gmm_local=0 if MIA439g_3==2
tab MIA439g_3 gmm_local
		*non-profits
generate gmm_np=.
replace gmm_np=1 if MIA439g_4==1
replace gmm_np=0 if MIA439g_4==2
tab MIA439g_4 gmm_np
		*private sector
generate gmm_priv=.
replace gmm_priv=1 if MIA439g_5==1
replace gmm_priv=0 if MIA439g_5==2
tab MIA439g_5 gmm_priv
		*individuals
generate gmm_indv=.
replace gmm_indv=1 if MIA439g_6==1
replace gmm_indv=0 if MIA439g_6==2
tab MIA439g_6 gmm_indv [aweight=weight]
		*no one (note that we are flipping this one to be 1 = no, 0 = yes to get values for figure 2)
generate gmm_no=.
replace gmm_no=1 if MIA439g_7==2
replace gmm_no=0 if MIA439g_7==1
tab MIA439g_7 gmm_no
ci means gmm_no [aweight=weight]

*FIGURE 2 & TABLE 2: MODEL COUNT BY TYPE OF POLICY
	*create scales
		*educate public
generate ed_do=0
replace ed_do=ed_feds+ed_state+ed_local+ed_np+ed_priv+ed_indv
tab ed_do [aweight=weight]
summarize ed_do [aweight=weight]		
		*use insecticides
generate in_do=0
replace in_do=in_feds+in_state+in_local+in_np+in_priv+in_indv
tab in_do [aweight=weight]
summarize in_do [aweight=weight]				
		*fines
generate fine_do=0
replace fine_do=fine_feds+fine_state+fine_local+fine_np+fine_priv+fine_indv
tab fine_do [aweight=weight]
summarize fine_do [aweight=weight]
		*delay pregnancy
generate preg_do=0
replace preg_do=preg_feds+preg_state+preg_local+preg_np+preg_priv+preg_indv
tab preg_do [aweight=weight]
summarize preg_do [aweight=weight]
		*travel bans
generate ban_do=0
replace ban_do=ban_feds+ban_state+ban_local+ban_np+ban_priv+ban_indv
tab ban_do [aweight=weight]
summarize ban_do [aweight=weight]
		*fund research
generate res_do=0
replace res_do=res_feds+res_state+res_local+res_np+res_priv+res_indv
tab res_do [aweight=weight]
summarize res_do [aweight=weight]
		*GMMs
generate gmm_do=0
replace gmm_do=gmm_feds+gmm_state+gmm_local+gmm_np+gmm_priv+gmm_indv
tab gmm_do [aweight=weight]
summarize gmm_do [aweight=weight]	
		*run regression analysis for TABLE 2
			*(1) educate
poisson ed_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
				*robustness check with neg bin
nbreg ed_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
				*strong dem
quietly poisson ed_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(dem_rep=1) atmeans post		
				*strong rep
quietly poisson ed_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]		
margins, at(dem_rep=7) atmeans post	
				*HS
quietly poisson ed_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(educ=2) atmeans post		
				*4 year degree
quietly poisson ed_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]		
margins, at(educ=5) atmeans post
			*(2) insecticides
poisson in_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]	
				*robustness check with neg bin
nbreg in_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
				*mean number of zika cases
quietly poisson in_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(zikacases=260) atmeans post		
				*maximum number of zika cases
quietly poisson in_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]		
margins, at(zikacases=1083) atmeans post	
				*mean number of google searches (52.6201)
quietly poisson in_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(google=52.6201) atmeans post		
				*maximum number of google searches (100)
quietly poisson in_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]		
margins, at(google=100) atmeans post	
				*strong trust in gov
quietly poisson in_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(gov_trust=5) atmeans post		
				*weak trust in gov
quietly poisson in_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]		
margins, at(gov_trust=1) atmeans post
				*HS
quietly poisson in_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(educ=2) atmeans post		
				*4 year degree
quietly poisson in_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]		
margins, at(educ=5) atmeans post
			*(3) fines for standing water
poisson fine_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]	
				*robustness check using neg bin
nbreg fine_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]	
				*strong trust in gov
quietly poisson fine_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(gov_trust=5) atmeans post		
				*weak trust in gov
quietly poisson fine_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]		
margins, at(gov_trust=1) atmeans post
			*(4) delay pregnancy
poisson preg_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
				*robustness check using neg bin
nbreg preg_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
				*strong trust in gov
quietly poisson preg_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(gov_trust=5) atmeans post		
				*weak trust in gov
quietly poisson preg_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]		
margins, at(gov_trust=1) atmeans post
				*HS
quietly poisson preg_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(educ=2) atmeans post		
				*4 year degree
quietly poisson preg_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]		
margins, at(educ=5) atmeans post
			*(5) travel bans
poisson ban_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]	
				*robustness check with neg bin
nbreg ban_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]	
				*very concerned about zika
quietly poisson ban_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(zikaconcern=5) atmeans post		
				*not all concerned about zika
quietly poisson ban_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]		
margins, at(zikaconcern=1) atmeans post	
			*(6) fund research
poisson res_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]	
				*robustness check with neg bin [note: won't converge]
nbreg res_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
				*strong dem
quietly poisson res_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(dem_rep=1) atmeans post		
				*strong rep
quietly poisson res_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]		
margins, at(dem_rep=7) atmeans post	
				*mean age (49, or bithyr 1968)
quietly poisson res_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(birthyr=1968) atmeans post
				*min age (18 or birthyear 1998)
quietly poisson res_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(birthyr=1998) atmeans post
			*(7) GMMs
poisson gmm_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
				*robustness check using neg bin
nbreg gmm_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]				
				*women
quietly poisson gmm_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(female=1) atmeans post		
				*men
quietly poisson gmm_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]		
margins, at(female=0) atmeans post
				*strong trust in gov
quietly poisson gmm_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(gov_trust=5) atmeans post		
				*weak trust in gov
quietly poisson gmm_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]		
margins, at(gov_trust=1) atmeans post

*FIGURE 3: MODEL COUNT BY SOURCE OF POLICY
	*create scales
		*feds
generate feds_do=0
replace feds_do=ed_feds+in_feds+fine_feds+preg_feds+ban_feds+res_feds+gmm_feds
tab feds_do [aweight=weight]
summarize feds_do [aweight=weight]
ci means feds_do [aweight=weight]		
		*state
generate state_do=0
replace state_do=ed_state+in_state+fine_state+preg_state+ban_state+res_state+gmm_state
tab state_do [aweight=weight]
summarize state_do [aweight=weight]		
ci means state_do [aweight=weight]		
		*local
generate local_do=0
replace local_do=ed_local+in_local+fine_local+preg_local+ban_local+res_local+gmm_local
tab local_do [aweight=weight]
summarize local_do [aweight=weight]
ci means local_do [aweight=weight]	
		*non-profits
generate np_do=0
replace np_do=ed_np+in_np+fine_np+preg_np+ban_np+res_np+gmm_np
tab np_do [aweight=weight]
summarize np_do [aweight=weight]
ci means np_do [aweight=weight]		
		*private sector
generate priv_do=0
replace priv_do=ed_priv+in_priv+fine_priv+preg_priv+ban_priv+res_priv+gmm_priv
tab priv_do [aweight=weight]
summarize priv_do [aweight=weight]
ci means priv_do [aweight=weight]	
		*individuals
generate indv_do=0
replace indv_do=ed_indv+in_indv+fine_indv+preg_indv+ban_indv+res_indv+gmm_indv
tab indv_do [aweight=weight]
summarize indv_do [aweight=weight]
ci means indv_do [aweight=weight]	
		*run regression analysis [note: this is old from R&R v.1, but keep it here for documentation]
			*feds
poisson feds_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
				*replicate with neg bin
nbreg feds_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]				
				*strong dem
quietly poisson feds_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(dem_rep=1) atmeans post		
				*strong rep
quietly poisson feds_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]		
margins, at(dem_rep=7) atmeans post					
				*strong trust in gov
quietly poisson feds_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(gov_trust=5) atmeans post		
				*weak trust in gov
quietly poisson feds_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]		
margins, at(gov_trust=1) atmeans post
				*HS
quietly poisson feds_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(educ=2) atmeans post		
				*4 year degree
quietly poisson feds_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]		
margins, at(educ=5) atmeans post						
			*state
poisson state_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]	
				*replicate using neg bin
nbreg state_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
			*local
poisson local_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]	
				*replicate using neg bin
nbreg local_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
				*very concerned about zika
quietly poisson local_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(zikaconcern=5) atmeans post		
				*not all concerned about zika
quietly poisson local_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]		
margins, at(zikaconcern=1) atmeans post	
				*mean number of zika cases
quietly poisson local_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(zikacases=260) atmeans post		
				*maximum number of zika cases
quietly poisson local_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]		
margins, at(zikacases=1083) atmeans post	
				*strong dem
quietly poisson local_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(dem_rep=1) atmeans post		
				*strong rep
quietly poisson local_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]		
margins, at(dem_rep=7) atmeans post	
			*non-profits
poisson np_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
				*replicate using neg bin
nbreg np_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
				*HS
quietly poisson np_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(educ=2) atmeans post		
				*4 year degree
quietly poisson np_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]		
margins, at(educ=5) atmeans post
				*mean age (49, or bithyr 1968)
quietly poisson np_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(birthyr=1968) atmeans post
				*min age (18 or birthyear 1998)
quietly poisson np_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(birthyr=1998) atmeans post
			*private sector
poisson priv_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]	
				*replicate using neg bin
nbreg priv_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]	
				*HS
quietly poisson priv_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(educ=2) atmeans post		
				*4 year degree
quietly poisson priv_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]		
margins, at(educ=5) atmeans post
				*mean age (49, or bithyr 1968)
quietly poisson priv_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(birthyr=1968) atmeans post
				*min age (18 or birthyear 1998)
quietly poisson priv_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(birthyr=1998) atmeans post
			*individuals
poisson indv_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]	
				*replicate with neg bin
nbreg indv_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]		
				*very concerned about zika
quietly poisson indv_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(zikaconcern=5) atmeans post		
				*not all concerned about zika
quietly poisson indv_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]		
margins, at(zikaconcern=1) atmeans post	
				*mean age (49, or bithyr 1968)
quietly poisson indv_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(birthyr=1968) atmeans post
				*min age (18 or birthyear 1998)
quietly poisson indv_do zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
margins, at(birthyr=1998) atmeans post

********
********

*BEGIN R&R v.2 ADITIONAL ANALYSES

*JC RECODES
	*CAK comment: the "mia" prefix is case-sensitive, so I needed to alter this code to "MIA"

***Create Dummy (1=yes) for selection of Fed Gov for Each Policy A-G***
gen feda=.
gen fedb=.
gen fedc=.
gen fedd=.
gen fede=.
gen fedf=.
gen fedg=.

recode feda .=1 if MIA439a_1==1
recode feda .=0 if MIA439a_1==2

recode fedb .=1 if MIA439b_1==1
recode fedb .=0 if MIA439b_1==2

recode fedc .=1 if MIA439c_1==1
recode fedc .=0 if MIA439c_1==2

recode fedd .=1 if MIA439d_1==1
recode fedd .=0 if MIA439d_1==2

recode fede .=1 if MIA439e_1==1
recode fede .=0 if MIA439e_1==2

recode fedf .=1 if MIA439f_1==1
recode fedf .=0 if MIA439f_1==2

recode fedg .=1 if MIA439g_1==1
recode fedg .=0 if MIA439g_1==2

***Create Dummy (1=yes) for selection of State Gov for Each Policy A-G***
gen statea=.
gen stateb=.
gen statec=.
gen stated=.
gen statee=.
gen statef=.
gen stateg=.

recode statea .=1 if MIA439a_2==1
recode statea .=0 if MIA439a_2==2

recode stateb .=1 if MIA439b_2==1
recode stateb .=0 if MIA439b_2==2

recode statec .=1 if MIA439c_2==1
recode statec .=0 if MIA439c_2==2

recode stated .=1 if MIA439d_2==1
recode stated .=0 if MIA439d_2==2

recode statee .=1 if MIA439e_2==1
recode statee .=0 if MIA439e_2==2

recode statef .=1 if MIA439f_2==1
recode statef .=0 if MIA439f_2==2

recode stateg .=1 if MIA439g_2==1
recode stateg .=0 if MIA439g_2==2

***Create Dummy (1=yes) for selection of Local Gov for Each Policy A-G***
gen locala=.
gen localb=.
gen localc=.
gen locald=.
gen locale=.
gen localf=.
gen localg=.

recode locala .=1 if MIA439a_3==1
recode locala .=0 if MIA439a_3==2

recode localb .=1 if MIA439b_3==1
recode localb .=0 if MIA439b_3==2

recode localc .=1 if MIA439c_3==1
recode localc .=0 if MIA439c_3==2

recode locald .=1 if MIA439d_3==1
recode locald .=0 if MIA439d_3==2

recode locale .=1 if MIA439e_3==1
recode locale .=0 if MIA439e_3==2

recode localf .=1 if MIA439f_3==1
recode localf .=0 if MIA439f_3==2

recode localg .=1 if MIA439g_3==1
recode localg .=0 if MIA439g_3==2

***Create Variables for total gov actors selected for each policy***
gen totalgova= feda+statea+locala
gen totalgovb= fedb+stateb+localb
gen totalgovc= fedc+statec+localc
gen totalgovd= fedd+stated+locald
gen totalgove= fede+statee+locale
gen totalgovf= fedf+statef+localf
gen totalgovg= fedg+stateg+localg

***Create Dummy Variables (1=yes) for supporting ONLY one gov actor***
gen onlyonegova=.
gen onlyonegovb=.
gen onlyonegovc=.
gen onlyonegovd=.
gen onlyonegove=.
gen onlyonegovf=.
gen onlyonegovg=.

recode onlyonegova .=1 if totalgova==1
recode onlyonegova .=0 if totalgova!=1

recode onlyonegovb .=1 if totalgovb==1
recode onlyonegovb .=0 if totalgovb!=1

recode onlyonegovc .=1 if totalgovc==1
recode onlyonegovc .=0 if totalgovc!=1

recode onlyonegovd .=1 if totalgovd==1
recode onlyonegovd .=0 if totalgovd!=1

recode onlyonegove .=1 if totalgove==1
recode onlyonegove .=0 if totalgove!=1

recode onlyonegovf .=1 if totalgovf==1
recode onlyonegovf .=0 if totalgovf!=1

recode onlyonegovg .=1 if totalgovg==1
recode onlyonegovg .=0 if totalgovg!=1

***Create New DV Dummy Variables (1=yes) for supporting ONLY fed gov and no other gov actors for each policy***
gen fedonlya=feda*onlyonegova
gen fedonlyb=fedb*onlyonegovb
gen fedonlyc=fedc*onlyonegovc
gen fedonlyd=fedd*onlyonegovd
gen fedonlye=fede*onlyonegove
gen fedonlyf=fedf*onlyonegovf
gen fedonlyg=fedg*onlyonegovg

***Notes***
*** fedonlya = 1 if respondent wanted fed gov to educate public but not state and not local
*** fedonlyb = 1 if respondent wanted fed gov to use insecticides but not state and not local 
*** fedonlyc = 1 if respondent wanted fed gov to fine for standing water but not state and not local 
*** fedonlyd = 1 if respondent wanted fed gov to encourage women delay pregnancy but not state and not local 
*** fedonlye = 1 if respondent wanted fed gov to issue travel warnings or bans but not state and not local 
*** fedonlyf = 1 if respondent wanted fed gov to fund scientific research on Zika but not state and not local 
*** fedonlyg = 1 if respondent wanted fed gov to use genetically modified mosquitos  but not state and not local 

*** any respondent coded 0 on any of above either didn't select fed gov for that policy or selected fed gov in combination with another level of gov

***Create Variable for total time selecte fed gov but not state and not local (ranges from 0 to 7)

gen totalselectfedonly=fedonlya+fedonlyb+fedonlyc+fedonlyd+fedonlye+fedonlyf+fedonlyg

***Notes***
***individuals with a 0 never selected fed gov without also selecting state or local
***individuals with a 7 selected fed gov but not state and not local for every single policy

***Create New DV Dummy Variables (1=yes) for supporting ONLY state gov and no other gov actors for each policy***
gen stateonlya=statea*onlyonegova
gen stateonlyb=stateb*onlyonegovb
gen stateonlyc=statec*onlyonegovc
gen stateonlyd=stated*onlyonegovd
gen stateonlye=statee*onlyonegove
gen stateonlyf=statef*onlyonegovf
gen stateonlyg=stateg*onlyonegovg

***Notes***
*** stateonlya = 1 if respondent wanted state gov to educate public but not fed and not local
*** stateonlyb = 1 if respondent wanted state gov to use insecticides but not fed and not local 
*** stateonlyc = 1 if respondent wanted state gov to fine for standing water but not fed and not local 
*** stateonlyd = 1 if respondent wanted state gov to encourage women delay pregnancy but not fed and not local 
*** stateonlye = 1 if respondent wanted state gov to issue travel warnings or bans but not fed and not local 
*** stateonlyf = 1 if respondent wanted state gov to fund scientific research on Zika but not fed and not local 
*** stateonlyg = 1 if respondent wanted state gov to use genetically modified mosquitos  but not fed and not local 

***Create New DV Dummy Variables (1=yes) for supporting ONLY local gov and no other gov actors for each policy***
gen localonlya=locala*onlyonegova
gen localonlyb=localb*onlyonegovb
gen localonlyc=localc*onlyonegovc
gen localonlyd=locald*onlyonegovd
gen localonlye=locale*onlyonegove
gen localonlyf=localf*onlyonegovf
gen localonlyg=localg*onlyonegovg

***Notes***
*** localonlya = 1 if respondent wanted local gov to educate public but not fed and not state
*** localonlyb = 1 if respondent wanted local gov to use insecticides but not fed and not state
*** localonlyc = 1 if respondent wanted local gov to fine for standing water but not fed and not state 
*** localonlyd = 1 if respondent wanted local gov to encourage women delay pregnancy but not fed and not state 
*** localonlye = 1 if respondent wanted local gov to issue travel warnings or bans but not fed and not state 
*** localonlyf = 1 if respondent wanted local gov to fund scientific research on Zika but not fed and not state 
*** localonlyg = 1 if respondent wanted local gov to use genetically modified mosquitos  but not fed and not state 

***Create Variable for total times selected state gov but not fed and not local (ranges from 0 to 7)

gen totalselectstateonly=stateonlya+stateonlyb+stateonlyc+stateonlyd+stateonlye+stateonlyf+stateonlyg

***Notes***
***individuals with a 0 never selected state gov without also selecting fed or local
***individuals with a 7 selected state gov but not fed and not local for every single policy

***Create Variable for total times selected local gov but not fed and not state (ranges from 0 to 7)

gen totalselectlocalonly=localonlya+localonlyb+localonlyc+localonlyd+localonlye+localonlyf+localonlyg

***Notes***
***individuals with a 0 never selected local gov without also selecting fed or state
***individuals with a 7 selected local gov but not fed and not state for every single policy

****

*TABLE 3
logit fedonlya zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
logit fedonlyb zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
logit fedonlyc zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
logit fedonlyd zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
logit fedonlye zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
logit fedonlyf zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
logit fedonlyg zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]

*****

*TABLE 4
logit stateonlya zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
logit stateonlyb zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
logit stateonlyc zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
logit stateonlyd zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
logit stateonlye zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
logit stateonlyf zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
logit stateonlyg zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]

*****

*TABLE 5
logit localonlya zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
logit localonlyb zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
logit localonlyc zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
logit localonlyd zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
logit localonlye zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
logit localonlyf zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]
logit localonlyg zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]

*****

*TABLE 6
	*tobit version
		*only feds
tobit totalselectfedonly zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight], ll(1) ul(7) 	
		*only state
tobit totalselectstateonly zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight], ll(1) ul(7) 		
		*only local
tobit totalselectlocalonly zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight], ll(1) ul(7) 	
	
	*poisson version
		*only feds
poisson totalselectfedonly zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]		
		*only state
poisson totalselectstateonly zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]		
		*only local
poisson totalselectlocalonly zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]	

	*neg bin version
		*only feds
nbreg totalselectfedonly zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]		
		*only state
nbreg totalselectstateonly zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]		
		*only local
nbreg totalselectlocalonly zikaconcern zikacases google noinsurance kidsinfuture female dem_rep gov_trust loc_trust educ birthyr [pweight=weight]	

#####

*JC REQUESTED FOOTNOTE FOR R&R: for each of the 7 policies, what percentage of respondents selected more than one level of govenrment (fed, state, loc)?
*NOTE: you need to run most of the re-codes aboive to get the necessary variables
	*create scales
		*educate public
			*overall percentages by unit of government
tab ed_feds [aweight=weight]
tab ed_state [aweight=weight]
tab ed_local [aweight=weight]
			*generate count of the three
gen ed_govt=ed_feds+ed_state+ed_local
tab ed_govt [aweight=weight]
			
		*use insecticides
tab in_feds [aweight=weight]
tab in_state [aweight=weight]
tab in_local [aweight=weight]
			*generate count of the three
gen in_govt=in_feds+in_state+in_local
tab in_govt [aweight=weight]
				
		*fines
tab fine_feds [aweight=weight]
tab fine_state [aweight=weight]
tab fine_local [aweight=weight]
			*generate count of the three
gen fine_govt=fine_feds+fine_state+fine_local
tab fine_govt [aweight=weight]

		*delay pregnancy
tab preg_feds [aweight=weight]
tab preg_state [aweight=weight]
tab preg_local [aweight=weight]
			*generate count of the three
gen preg_govt=preg_feds+preg_state+preg_local
tab preg_govt [aweight=weight]

		*travel bans
tab ban_feds [aweight=weight]
tab ban_state [aweight=weight]
tab ban_local [aweight=weight]
			*generate count of the three
gen ban_govt=ban_feds+ban_state+ban_local
tab ban_govt [aweight=weight]

		*fund research
tab res_feds [aweight=weight]
tab res_state [aweight=weight]
tab res_local [aweight=weight]
			*generate count of the three
gen res_govt=res_feds+res_state+res_local
tab res_govt [aweight=weight]

		*GMMs
tab gmm_feds [aweight=weight]
tab gmm_state [aweight=weight]
tab gmm_local [aweight=weight]
			*generate count of the three
gen gmm_govt=gmm_feds+gmm_state+gmm_local
tab gmm_govt [aweight=weight]








