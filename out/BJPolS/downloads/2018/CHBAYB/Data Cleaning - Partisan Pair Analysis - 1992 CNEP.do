**********************************************************************
**********************************************************************
***********************1992 CNEP**************************************
**********************************************************************
**********************************************************************
**********************************************************************


**********************************************************************
****************************Data Cleaning: Disagreement will**********
****************************only focus on major party supporters******
**********************************************************************
**********************************************************************
**********************************************************************
**********************************************************************

	
clear all
use "1992 CNEP.dta"		
set more off
	
		************************************
		*********Economic Assessments*******
		************************************
	label def eco 1 "Worse" 2 "Same" 3 "Better"
	
	recode Z_US92_A_EconSit (1=3) (3=2) (5=1), gen(retro)
	label values retro eco
	label var retro "Retrospective Assessments"
	
	recode Z_US92_A_EconSitFuture (1=3) (3=2) (5=1), gen(prosp)
	label var prosp "Prospective Assessments"
	label values prosp eco
	
	
		************************************
		*********Partisanship***************
		************************************
*7 pt scale	
	label def part 1 "Strong Dem" 2 "Weak Dem" 3 "Lean Dem" 4 "Ind." 5 "Lean Rep" 6 "Weak rep" 7 "Strong Dem"
	rename Z_US92_C_pid7 partyid
	label values partyid part
	label var partyid "Party ID"
	
*3 pt scale
	gen pid_3 = . 
	replace pid_3 = 1 if partyid >=1 & partyid <= 3
	replace pid_3 = 3 if partyid == 4
	replace pid_3 = 2 if partyid >=5 & partyid <= 7
	label var pid_3 "Party ID (Categorical)"
	label def pi2 1 "Democrat" 3 "Independent" 2 "Republican"
	label values pid_3 pi2
	
*Republican vs. Democrat
	gen pid_2 = . 
	replace pid_2 = 1 if partyid >=1 & partyid <= 3
	replace pid_2 = 0 if partyid >=5 & partyid <= 7
	label var pid_2 "PID" 
	label def pi3 1 "Democrat" 0 "Republican"
	label values pid_2 pi3
	
*Party of Incumbent President
	*1 = Rep; 0 = Dem
	gen partisan = . 
	replace partisan = 1 if pid_2 == 0 
	replace partisan = 0 if pid_2 == 1
	label var partisan "Co-Partisan to Inc. President"
	label def part1 1 "In-Partisan" 0 "Out-Partisan"
	label values partisan part1


*PID Strength (Non-Independents)*
	gen pid_str = . 
	replace pid_str = 1 if partyid == 3
	replace pid_str = 1 if partyid == 5
	replace pid_str = 2 if partyid == 2
	replace pid_str = 2 if partyid == 6
	replace pid_str = 3 if partyid == 1
	replace pid_str = 3 if partyid == 7
	label var pid_str "PID Str."
	label def pi4 1 "Leaner" 2 "Weak" 3 "Strong"
	label values pid_str pi4

	tab pid_str	
	
	recode partyid (1 7 = 4) (2 6 = 3) (3 5 = 2) (4 = 1), gen(pid_str_full)
	label var pid_str_full "PID Str."

		
	
		*****************************************************
		*********Network Size and Disagreement***************
		*****************************************************
		
*Network Size
	foreach var in Z_US92_E_v185 Z_US92_E_v187 Z_US92_E_v189 Z_US92_E_v191 Z_US92_E_v193 {
		codebook `var'
		}
		
	gen names = .
	replace names =  4 if Z_US92_E_v191 == 1 & Z_US92_E_v189 == 1 & Z_US92_E_v187 == 1 & Z_US92_E_v185 == 1
	replace names =  3 if Z_US92_E_v191 == 5 & Z_US92_E_v189 == 1 & Z_US92_E_v187 == 1 & Z_US92_E_v185 == 1
	replace names =  2 if Z_US92_E_v189 == 5 & Z_US92_E_v187 == 1 & Z_US92_E_v185 == 1
	replace names =  1 if Z_US92_E_v187 == 5 & Z_US92_E_v185 == 1
	replace names =  0 if Z_US92_E_v185 == 5
	label var names "# Listed Discussants"
	
	recode Z_US92_E_v193 (1=1) (5=0) (995 =.), gen(d5)
	
	gen numgiven = names + d5
	label var numgiven "Network Size" 
	
	gen numgiven01 = numgiven/5
	label var numgiven01 "Network Size"
	
	
*Candidate Disagreement
	*discussant vote choice
		foreach var in  Z_US92_E_Disc1Part  Z_US92_E_Disc2Part  Z_US92_E_Disc3Part  Z_US92_E_Disc4Part  Z_US92_E_Disc5Part {
			codebook `var'
			}
		*-1 = . 
		*0 = none
		*1 = bush
		*2 = clinton
		*3 = perot
		*4 = other
		*7 = clinton & perot
		*8 = dk
		*9 = refused
	
	*respondent vote choice
		codebook H_Vote92
			*1 = Clinton
			*3 Perot
			*5 = Bush
	
	*# Agreeing Respondents
		label def agre 1 "Agree" 0 "Disagree" 
			*agree: Bush/Bush; Clinton/Clinton; Perot/Perot
			*disagree: bush/clinton; clinton/bush; perot/bush; perot/bush; 
				*bush/other; clinton/other; none, dk, refused and clinton/perot are dropped
		gen d1_agree = . 
		replace d1_agree = 1 if H_Vote92 == 1 & Z_US92_E_Disc1Part == 2
		replace d1_agree = 1 if H_Vote92 == 5 & Z_US92_E_Disc1Part == 1
		replace d1_agree = 0 if H_Vote92 == 1 & Z_US92_E_Disc1Part == 1
		replace d1_agree = 0 if H_Vote92 == 5 & Z_US92_E_Disc1Part == 2
		label var d1_agree "D1: Same Cand Pref?"
		label values d1_agree agre
	
		gen d2_agree = . 
		replace d2_agree = 1 if H_Vote92 == 1 & Z_US92_E_Disc2Part == 2
		replace d2_agree = 1 if H_Vote92 == 5 & Z_US92_E_Disc2Part == 1
		replace d2_agree = 0 if H_Vote92 == 1 & Z_US92_E_Disc2Part == 1
		replace d2_agree = 0 if H_Vote92 == 5 & Z_US92_E_Disc2Part == 2
		label var d2_agree "D2: Same Cand Pref?"
		label values d2_agree agre
	
		gen d3_agree = . 
		replace d3_agree = 1 if H_Vote92 == 1 & Z_US92_E_Disc3Part == 2
		replace d3_agree = 1 if H_Vote92 == 5 & Z_US92_E_Disc3Part == 1
		replace d3_agree = 0 if H_Vote92 == 1 & Z_US92_E_Disc3Part == 1
		replace d3_agree = 0 if H_Vote92 == 5 & Z_US92_E_Disc3Part == 2
		label var d3_agree "D3: Same Cand Pref?"
		label values d3_agree agre
		
		gen d4_agree = . 
		replace d4_agree = 1 if H_Vote92 == 1 & Z_US92_E_Disc4Part == 2
		replace d4_agree = 1 if H_Vote92 == 5 & Z_US92_E_Disc4Part == 1
		replace d4_agree = 0 if H_Vote92 == 1 & Z_US92_E_Disc4Part == 1
		replace d4_agree = 0 if H_Vote92 == 5 & Z_US92_E_Disc4Part == 2
		label var d4_agree "D4: Same Cand Pref?"
		label values d4_agree agre
		
		gen d5_agree = . 
		replace d5_agree = 1 if H_Vote92 == 1 & Z_US92_E_Disc5Part == 2
		replace d5_agree = 1 if H_Vote92 == 5 & Z_US92_E_Disc5Part == 1
		replace d5_agree = 0 if H_Vote92 == 1 & Z_US92_E_Disc5Part == 1
		replace d5_agree = 0 if H_Vote92 == 5 & Z_US92_E_Disc5Part == 2
		label var d5_agree "D5: Same Cand Pref?"
		label values d5_agree agre
		
		foreach var in d1_agree d2_agree d3_agree d4_agree d5_agree {
			tab `var'
			}
	*Candidate **Disagreement
		label def disa 1 "Disagree" 0 "Agree"
		
		foreach var in d1_agree d2_agree d3_agree d4_agree d5_agree {
			omscore `var'
			}
		
		rename rr_d1_agree d1_dagree
		rename rr_d2_agree d2_dagree
		rename rr_d3_agree d3_dagree
		rename rr_d4_agree d4_dagree
		rename rr_d5_agree d5_dagree
	
		
		label var d1_dagree "D1: Same Cand Pref?"
		label values d1_dagree disa

		label var d2_dagree "D2: Same Cand Pref?"
		label values d2_dagree disa
	
		label var d3_dagree "D3: Same Cand Pref?"
		label values d3_dagree disa
		
		label var d4_dagree "D4: Same Cand Pref?"
		label values d4_dagree disa
		
		label var d5_dagree "D5: Same Cand Pref?"
		label values d5_dagree disa
			
	
	*#Disagreeing Respondents
		egen agree = rowtotal(d1_agree d2_agree d3_agree d4_agree d5_agree), missing
		egen disagree = rowtotal(d1_dagree d2_dagree d3_dagree d4_dagree d5_dagree), missing
		label var agree "# Agreeing Partners"
		label var disagree "# Disagreeing Partners"
					
	*Exposure to Disagreement Measures
		*Summary Scale
			*See Lupton and Thornton: Exposure = D - A
			gen disagree_total = disagree - agree
			label var disagree_total "Network Disagreement"
		*Divided by network size
			*See Lupton and Thonrton: (D-A)/(D+A)
			gen disagree_avg = [disagree - agree]/[disagree + agree]
			label var disagree_avg "Network Disagreement"
						
		*Standardized*
			foreach var in disagree_total disagree_avg {
				summ `var'
				gen `var'01 = (`var' - r(min))/(r(max)-r(min))
			}
			
			label var disagree_total01 "Network Disagreement"
			label var disagree_avg01 "Network Disagreement"
			
		*Categorical
			gen cand_cat1 = .
			replace cand_cat1 = 1 if numgiven == 0
			replace cand_cat1 = 2 if disagree_total >= -5 & disagree_total <= -1
			replace cand_cat1 = 3 if disagree_total == 0
			replace cand_cat1 = 4 if disagree_total >=1 & disagree_total <= 5
			label var cand_cat1 "Network Type"
			label def can 1 "No Discussants" 2 "Agree > Disagree" 3 "Ambivalent" 4 "Agree < Disagree"
			label values cand_cat1 can
			
			gen cand_cat2 = .
			replace cand_cat2 = 1 if disagree_total >= -5 & disagree_total <= -1
			replace cand_cat2 = 2 if disagree_total == 0
			replace cand_cat2 = 3 if disagree_total >=1 & disagree_total <= 5
			label var cand_cat2 "Network Type"
			label def canb 1 "Agree > Disagree" 2 "Ambivalent" 3 "Agree < Disagree"
			label values cand_cat2 canb

	*Diversity Measure*
		*From Nir (2005): [(Agree+Disagree)/2] - |A-D|
			gen network_ambiv = [(agree+disagree)/2] - abs(agree - disagree)
			label var network_ambiv "Network Political Diversity"
		
			summ network_ambiv
			gen network_ambiv01=(network_ambiv - r(min))/(r(max)-r(min))
			label var network_ambiv01 "Network Political Diversity"

			
		
*General Disagreement
	foreach var in Z_US92_E_Disc1Agre Z_US92_E_Disc2Agre Z_US92_E_Disc3Agre Z_US92_E_Disc4Agre Z_US92_E_Disc5Agre {
		codebook `var' 
		}

		
	*Disagreement Scale
	label def gend 1 "Never" 2 "Rarely" 3 "Sometimes" 4 "Often"
	recode 	 Z_US92_E_Disc1Agre  (-1=.) (1=4) (2=3) (3=2) (4=1) (8=.) (9=.) (95=.) (995=.), gen(d1_genagree)
	recode 	 Z_US92_E_Disc2Agre  (-1=.) (1=4) (2=3) (3=2) (4=1) (8=.) (9=.) (95=.) (995=.), gen(d2_genagree)
	recode 	 Z_US92_E_Disc3Agre  (-1=.) (1=4) (2=3) (3=2) (4=1) (8=.) (9=.) (95=.) (995=.), gen(d3_genagree)
	recode 	 Z_US92_E_Disc4Agre  (-1=.) (1=4) (2=3) (3=2) (4=1) (8=.) (9=.) (95=.) (995=.), gen(d4_genagree)
	recode 	 Z_US92_E_Disc5Agre  (-1=.) (1=4) (2=3) (3=2) (4=1) (8=.) (9=.) (95=.) (995=.), gen(d5_genagree)
		
	foreach var in d1_genagree d2_genagree d3_genagree d4_genagree d5_genagree {
		label values `var' gend
		tab `var'
		}
				
	*Avgerage Scale
	egen genavg = rowmean(d1_genagree d2_genagree d3_genagree d4_genagree d5_genagree)
	label var genavg "General Disagreement in Network"
		
		*Connection with 'disagreeidate' disagreement
		pwcorr disagree_total disagree_avg genavg, sig
		pwcorr disagree_total disagree_avg genavg, sig	
	
*Combined Index (Lupton and Thornton)
	/**fn. 5: A = sum(ai * si) where a = 1 if agree and s = agreement weight
			D = sum(di * si) where d = 1 if disagree and s = disagreement weight
			Disagreement = D - A**/
	
	*"Agreement" Coding
		foreach var in 	 Z_US92_E_Disc1Agre Z_US92_E_Disc2Agre Z_US92_E_Disc3Agre  	 Z_US92_E_Disc4Agre Z_US92_E_Disc5Agre {
			recode `var' (-1=.) (8=.) (9=.) (95=.) (995=.), gen(`var'_ag)
			}

	*Agree Scale
		gen a1 = d1_agree * Z_US92_E_Disc1Agre_ag
		gen a2 = d2_agree * Z_US92_E_Disc2Agre_ag
		gen a3 = d3_agree * Z_US92_E_Disc3Agre_ag
		gen a4 = d4_agree * Z_US92_E_Disc4Agre_ag
		gen a5 = d5_agree * Z_US92_E_Disc5Agre_ag
		egen agree_weight = rowtotal(a1 a2 a3 a4 a5), missing
	*Disagree Scale
		gen d1 = d1_dagree * d1_genagree
		gen d2 = d2_dagree * d2_genagree
		gen d3 = d3_dagree * d3_genagree
		gen d4 = d4_dagree *  d4_genagree
		gen d5a = d5_dagree *  d5_genagree
		egen disagree_weight = rowtotal(d1 d2 d3 d4 d5), missing
	
	*Exposure to Disagreement
		gen disagree_total_weight = disagree_weight - agree_weight
		gen disagree_avg_weight = disagree_total_weight/(disagree+agree)
		
		foreach var in disagree_total_weight disagree_avg_weight {
			summ `var' 
			gen `var'01 = (`var' - r(min))/(r(max)-r(min))
			tab `var'01
		}
		
		label var disagree_total_weight "Network Disagreement"
		label var disagree_total_weight "Network Disagreement"
	
		label var disagree_avg_weight "Network Disagreement"
		label var disagree_avg_weight "Network Disagreement"
	

*Combined Index (Alternative)
	gen d1_both = d1_dagree + d1_genagree
	gen d2_both = d2_dagree + d2_genagree
	gen d3_both = d3_dagree + d3_genagree
	gen d4_both = d4_dagree + d4_genagree
	gen d5_both = d5_dagree + d5_genagree
	
	egen dis_both = rowmean(d1_both d2_both d3_both d4_both d5_both)
	label var dis_both "Index of Network Disagreement"
	summ dis_both, detail
	tab dis_both
	
		
		***************************************************
		*****************Control Variables*****************
		***************************************************
	
*Ideology & Ideological Strength
	gen ideology = C_LRSelf_F
	recode ideology (999=.)
	label def ido 1 "Most Liberal" 10 "Most Conservative"
	label values ideology ido
	label var ideology "Ideology"
	
	recode ideology  (1=5) (2=4) (3=3) (4=2) (5=1)  ///
		(6=1) (7=2) (8=3) (9=4) (10=5), gen(ideol_str)
		
	foreach var in ideology ideol_str {
		summ `var'
		gen `var'01 = (`var' - r(min))/(r(max)-r(min))
		}
	label var ideology01 "Ideology" 
	label var ideol_str "Ideological Extremity"
	
	
*Gender
		recode L_Gender (1=0) (5=1), gen(gender)
		label var gender "Gender"
		label def gen1 1 "Female" 0 "Male"
		label values gender gen1
		

*Age
		gen age = L_Age_F
		replace age = . if age > 900
		label var age "Age"
		summ age
		
		summ age
		gen age01 = (age - r(min))/(r(max)-r(min))
		label var age01 "Age"


*Education
		gen educ = . 
		replace educ = 1 if Z_US92_L_Education_F == 3
		replace educ = 2 if Z_US92_L_Education_F == 4
		replace educ = 3 if Z_US92_L_Education_F == 5
		replace educ = 4 if Z_US92_L_Education_F == 6
		replace educ = 4 if Z_US92_L_Education_F ==7
		label var educ "Education"
		label def edu 1 "< HS" 2 "HS" 3 "Some College" 4 "College+"
		label values educ edu
		summ educ 
		tab educ
		
		summ educ 
		gen educ01 = (educ - r(min))/(r(max)-r(min))
		label var educ01 "Education"

*Race
		gen race = . 
		replace race = 1 if Z_US92_L_Race  == 1
		replace race = 2 if Z_US92_L_Race  == 2
		replace race = 3 if Z_US92_L_Race  >=3 & Z_US92_L_Race <= 5
		label def rac1 1 "White" 2 "Black" 3 "Other"
		label values race rac1
		label var race "Race"
		
		tabulate race, gen(race_)
		label var race_2 "Black"
		label var race_3 "Other Race"
		label def r2 1 "Black" 
		label def r3 1 "Other Race"
		label values race_2 r2
		label values race_3 r3
		
		
*Income 
	gen income = L_Income_F2
	mvdecode income, mv(998=.a \ 999=.b)
	label def inc 1 "<15,000" 2 "15-24,999" 3 "25-34,999" 4 "34-50,000" 5 "50,001-75" 6 "75000+"
	label values income inc
	summ income
	label var income "Family Income"
	
	summ income 
	gen income01 = (income - r(min))/(r(max)-r(min))
	label var income01 "Family Income"
	
	
*Marital Status
	gen marital = .
	replace marital = 1 if L_Married == 1
	replace marital = 0 if L_Married >=2 & L_Married <= 7
	label var marital "Marriage Status"
	label def mar 1 "Married" 0 "Not Married" 
	label values marital mar
	
	
*Employment Status
	gen employment = L_WorkStat
	label var employment "Employment Status"
	replace employment = . if employment == 0 
	label def emp 1 "Employed" 2 "Unemployed" 3 "Retired" 4 "Keeping House" 5 "Student"
	label values employment emp
	
	recode employment (1=1) (2=2) (3=3) (4=4) (5=4) , gen(employed)
	label var employed "Employment Status"
	label def emp1 1 "Employed" 2 "Unemployed" 3 "Retired" 4 "Keeping House/Student"
	label values employment emp1
	
	
	tabulate employment, gen(employ)
	label var employ2 "Unemployed" 
	label var employ3 "Retired" 
	label var employ4 "Keeping House" 
	label var employ5 "Student"
	label def e2 1 "Unemployed"
	label def e3 1 "Retired" 
	label def e4 1 "Keeping House" 
	label def e5 1 "Student"
	label values employ2 e2
	label values employ3 e3
	label values employ4 e4
	label values employ5 e5

	
	
	
*Campaign Interest
	recode H_InterestCam (1=3) (3=2) (5=1), gen(camp_interest)
	label var camp_interest "Campaign Interest"
	label def int 1 "Not Much" 2 "Somewhat" 3 "Very Much"
	label values camp_interest int

	recode  D_PapAtent_F (0=1) (1=2) (2=3) (3=4) (995=.) (999=.), gen(newspaper)
	recode D_TVAtent (1=4) (2=3) (3=2) (4=1) (5=.), gen(tv)
	recode Z_US92_D_CamMag (1=4) (2=3) (3=2) (4=1), gen(mag)
	recode Z_US92_D_CamLocalTV  (1=4) (2=3) (3=2) (4=1) (5=1) , gen(localtv)
	recode Z_US92_D_CamRadio (1=4) (2=3) (3=2) (4=1) (5=1) , gen(radio)

	factor camp_interest newspaper tv,  pcf
		*loadings from 0.75-0.77
		*EV: 1.77
		*proportion: 0.57
	predict factor1 
	label var factor1 "News Attention & Interest"
	rename factor1 news_att
	
	summ news_att
	gen news_att01 = (news_att - r(min))/(r(max) - r(min))
	label var news_att01 "News Attention & Interest"

	
*Discussant Knowledge
	foreach var in  Z_US92_E_Disc1Know  Z_US92_E_Disc2Know  Z_US92_E_Disc3Know  Z_US92_E_Disc4Know  Z_US92_E_Disc5Know  {
		tab `var'
		codebook `var'
		}
	
	recode Z_US92_E_Disc1Know (1=3) (3=2) (5=1), gen(disc1_knowl)
	recode Z_US92_E_Disc2Know (1=3) (3=2) (5=1), gen(disc2_knowl)
	recode Z_US92_E_Disc3Know (1=3) (3=2) (5=1), gen(disc3_knowl)
	recode Z_US92_E_Disc4Know (1=3) (3=2) (5=1), gen(disc4_knowl)
	recode Z_US92_E_Disc5Know (1=3) (3=2) (5=1), gen(disc5_knowl)
	foreach var in disc1_knowl disc2_knowl disc3_knowl disc4_knowl disc5_knowl {
		tab `var'
		}
	mvdecode disc1_knowl disc2_knowl disc3_knowl disc4_knowl disc5_knowl, mv(-1 = . \ 8 = . \ 9 = . \ 95 = . )
	label def kno 1 "Not Much" 2 "Avg." 3 "Great Deal"
	foreach var in disc1_knowl disc2_knowl disc3_knowl disc4_knowl disc5_knowl {
		label values `var' kno
		}

	egen disc_knowl = rowmean(disc1_knowl disc2_knowl disc3_knowl disc4_knowl disc5_knowl)
	label var disc_knowl "Network Pol. Knowl."
	summ disc_knowl
	
	summ disc_knowl 
	gen disc_knowl01 = (disc_knowl - r(min))/(r(max)-r(min))
	label var disc_knowl01 "Network Pol. Knowledge"
	

	
		*Weighted Scale of Exposure to Disagreement
			*Agree/Weight
				gen a1k = d1_agree * disc1_knowl
				gen a2k = d2_agree * disc2_knowl
				gen a3k = d3_agree * disc3_knowl
				gen a4k = d4_agree * disc4_knowl
				gen a5k = d5_agree * disc5_knowl
				egen agree_knowl = rowtotal(a1k a2k a3k a4k a5k), missing
			*Disagree/Weight
				gen d1k = d1_dagree * disc1_knowl
				gen d2k = d1_dagree * disc2_knowl
				gen d3k = d1_dagree * disc3_knowl
				gen d4k = d1_dagree * disc4_knowl
				gen d5k = d1_dagree * disc5_knowl
				egen dagree_knowl = rowtotal(d1k d2k d3k d4k d5k), missing
			*Scale
				gen disagree_total_knowl = dagree_knowl - agree_knowl
				gen disagree_avg_knowl = disagree_total_knowl/(disagree+agree)
				label var disagree_total_knowl "Network Disagreement (Knowledge Weighted)"
				label var disagree_avg_knowl "Network Disagreement (Knowledge Weighted)"
				
				foreach var in disagree_total_knowl disagree_avg_knowl {
					summ `var'
					gen `var'01 = (`var' - r(min))/(r(max)-r(min))
					}
				
				label var disagree_total_knowl01 "Network Disagreement (Knowledge Weighted)"
				label var disagree_avg_knowl01 "Network Disagreement (Knowledge Weighted)"
				
	
*Frequency of Political Discussion*
	foreach var in Z_US92_E_Disc1Freq Z_US92_E_Disc2Freq 	Z_US92_E_Disc3Freq Z_US92_E_Disc4Freq ///
		Z_US92_E_Disc5Freq {
		codebook `var'
		}
		
	recode Z_US92_E_Disc1Freq (1=4) (2=3) (3=2) (4=1), gen(disc1_freq)
	recode Z_US92_E_Disc2Freq (1=4) (2=3) (3=2) (4=1), gen(disc2_freq)
	recode Z_US92_E_Disc3Freq (1=4) (2=3) (3=2) (4=1), gen(disc3_freq)
	recode Z_US92_E_Disc4Freq (1=4) (2=3) (3=2) (4=1), gen(disc4_freq)
	recode Z_US92_E_Disc5Freq (1=4) (2=3) (3=2) (4=1), gen(disc5_freq)
	foreach var in disc1_freq disc2_freq disc3_freq disc4_freq disc5_freq {
		tab `var'
		}
	
	mvdecode disc1_freq disc2_freq disc3_freq disc4_freq disc5_freq, mv(-1 = . \ 8 = . \ 9 = . \ 95 = . )
	
	egen disc_freq = rowmean(disc1_freq disc2_freq disc3_freq disc4_freq disc5_freq)
	label var disc_freq "Avg. Pol Discussion Freq"
	summ disc_freq 

		*Weighted Scale of Exposure to Disagreement
			*Agree/Weight
				gen a1f = d1_agree * disc1_freq
				gen a2f = d2_agree * disc2_freq
				gen a3f = d3_agree * disc3_freq
				gen a4f = d4_agree * disc4_freq
				gen a5f = d5_agree * disc5_freq
				egen agree_freq = rowtotal(a1f a2f a3f a4f a5f), missing
			*Disagree/Weight
				gen d1f = d1_dagree * disc1_freq
				gen d2f = d1_dagree * disc2_freq
				gen d3f = d1_dagree * disc3_freq
				gen d4f = d1_dagree * disc4_freq
				gen d5f = d1_dagree * disc5_freq
				egen dagree_freq = rowtotal(d1f d2f d3f d4f d5f), missing
			*Scale
				gen disagree_total_freq = dagree_freq - agree_freq
				gen disagree_avg_freq = disagree_total_freq/(disagree+agree)
				label var disagree_total_freq "Network Disagreement (Frequency Weighted)"
				label var disagree_avg_freq "Network Disagreement (Frequency Weighted)"
				
				foreach var in disagree_total_freq disagree_avg_freq {
					summ `var'
					gen `var'01 = (`var' - r(min))/(r(max)-r(min))
					}
				
				label var disagree_total_freq01 "Network Disagreement (Frequency Weighted)"
				label var disagree_avg_freq01 "Network Disagreement (Frequency Weighted)"
				
				
/***********************************original disagree_total**********************/
	gen d1_agree1 = . 
		replace d1_agree1 = 1 if H_Vote92 == 1 & Z_US92_E_Disc1Part == 2
		replace d1_agree1 = 1 if H_Vote92 == 3 & Z_US92_E_Disc1Part == 3
		replace d1_agree1 = 1 if H_Vote92 == 5 & Z_US92_E_Disc1Part == 1
		replace d1_agree1 = 0 if H_Vote92 == 1 & Z_US92_E_Disc1Part == 1
		replace d1_agree1 = 0 if H_Vote92 == 1 & Z_US92_E_Disc1Part == 3
		replace d1_agree1 = 0 if H_Vote92 == 1 & Z_US92_E_Disc1Part == 4
		replace d1_agree1 = 0 if H_Vote92 == 3 & Z_US92_E_Disc1Part == 1
		replace d1_agree1 = 0 if H_Vote92 == 3 & Z_US92_E_Disc1Part == 2
		replace d1_agree1 = 0 if H_Vote92 == 3 & Z_US92_E_Disc1Part == 4
		replace d1_agree1 = 0 if H_Vote92 == 5 & Z_US92_E_Disc1Part == 2
		replace d1_agree1 = 0 if H_Vote92 == 5 & Z_US92_E_Disc1Part == 3
		replace d1_agree1 = 0 if H_Vote92 == 5 & Z_US92_E_Disc1Part == 4
		label var d1_agree1 "D1: Same Cand Pref?"
		label values d1_agree1 agre
	
	
	
		gen d2_agree1 = . 
		replace d2_agree1 = 1 if H_Vote92 == 1 & Z_US92_E_Disc2Part == 2
		replace d2_agree1 = 1 if H_Vote92 == 3 & Z_US92_E_Disc2Part == 3
		replace d2_agree1 = 1 if H_Vote92 == 5 & Z_US92_E_Disc2Part == 1
		replace d2_agree1 = 0 if H_Vote92 == 1 & Z_US92_E_Disc2Part == 1
		replace d2_agree1 = 0 if H_Vote92 == 1 & Z_US92_E_Disc2Part == 3
		replace d2_agree1 = 0 if H_Vote92 == 1 & Z_US92_E_Disc2Part == 4
		replace d2_agree1 = 0 if H_Vote92 == 3 & Z_US92_E_Disc2Part == 1
		replace d2_agree1 = 0 if H_Vote92 == 3 & Z_US92_E_Disc2Part == 2
		replace d2_agree1 = 0 if H_Vote92 == 3 & Z_US92_E_Disc2Part == 4
		replace d2_agree1 = 0 if H_Vote92 == 5 & Z_US92_E_Disc2Part == 2
		replace d2_agree1 = 0 if H_Vote92 == 5 & Z_US92_E_Disc2Part == 3
		replace d2_agree1 = 0 if H_Vote92 == 5 & Z_US92_E_Disc2Part == 4
		label var d2_agree1 "D2: Same Cand Pref?"
		label values d2_agree1 agre
	
	
		gen d3_agree1 = . 
		replace d3_agree1 = 1 if H_Vote92 == 1 & Z_US92_E_Disc3Part == 2
		replace d3_agree1 = 1 if H_Vote92 == 3 & Z_US92_E_Disc3Part == 3
		replace d3_agree1 = 1 if H_Vote92 == 5 & Z_US92_E_Disc3Part == 1
		replace d3_agree1 = 0 if H_Vote92 == 1 & Z_US92_E_Disc3Part == 1
		replace d3_agree1 = 0 if H_Vote92 == 1 & Z_US92_E_Disc3Part == 3
		replace d3_agree1 = 0 if H_Vote92 == 1 & Z_US92_E_Disc3Part == 4
		replace d3_agree1 = 0 if H_Vote92 == 3 & Z_US92_E_Disc3Part == 1
		replace d3_agree1 = 0 if H_Vote92 == 3 & Z_US92_E_Disc3Part == 2
		replace d3_agree1 = 0 if H_Vote92 == 3 & Z_US92_E_Disc3Part == 4
		replace d3_agree1 = 0 if H_Vote92 == 5 & Z_US92_E_Disc3Part == 2
		replace d3_agree1 = 0 if H_Vote92 == 5 & Z_US92_E_Disc3Part == 3
		replace d3_agree1 = 0 if H_Vote92 == 5 & Z_US92_E_Disc3Part == 4
		label var d3_agree1 "D3: Same Cand Pref?"
		label values d3_agree1 agre
		
		gen d4_agree1 = . 
		replace d4_agree1 = 1 if H_Vote92 == 1 & Z_US92_E_Disc4Part == 2
		replace d4_agree1 = 1 if H_Vote92 == 3 & Z_US92_E_Disc4Part == 3
		replace d4_agree1 = 1 if H_Vote92 == 5 & Z_US92_E_Disc4Part == 1
		replace d4_agree1 = 0 if H_Vote92 == 1 & Z_US92_E_Disc4Part == 1
		replace d4_agree1 = 0 if H_Vote92 == 1 & Z_US92_E_Disc4Part == 3
		replace d4_agree1 = 0 if H_Vote92 == 1 & Z_US92_E_Disc4Part == 4
		replace d4_agree1 = 0 if H_Vote92 == 3 & Z_US92_E_Disc4Part == 1
		replace d4_agree1 = 0 if H_Vote92 == 3 & Z_US92_E_Disc4Part == 2
		replace d4_agree1 = 0 if H_Vote92 == 3 & Z_US92_E_Disc4Part == 4
		replace d4_agree1 = 0 if H_Vote92 == 5 & Z_US92_E_Disc4Part == 2
		replace d4_agree1 = 0 if H_Vote92 == 5 & Z_US92_E_Disc4Part == 3
		replace d4_agree1 = 0 if H_Vote92 == 5 & Z_US92_E_Disc4Part == 4
		label var d4_agree1 "D4: Same Cand Pref?"
		label values d4_agree1 agre
		
		gen d5_agree1 = . 
		replace d5_agree1 = 1 if H_Vote92 == 1 & Z_US92_E_Disc5Part == 2
		replace d5_agree1 = 1 if H_Vote92 == 3 & Z_US92_E_Disc5Part == 3
		replace d5_agree1 = 1 if H_Vote92 == 5 & Z_US92_E_Disc5Part == 1
		replace d5_agree1 = 0 if H_Vote92 == 1 & Z_US92_E_Disc5Part == 1
		replace d5_agree1 = 0 if H_Vote92 == 1 & Z_US92_E_Disc5Part == 3
		replace d5_agree1 = 0 if H_Vote92 == 1 & Z_US92_E_Disc5Part == 4
		replace d5_agree1 = 0 if H_Vote92 == 3 & Z_US92_E_Disc5Part == 1
		replace d5_agree1 = 0 if H_Vote92 == 3 & Z_US92_E_Disc5Part == 2
		replace d5_agree1 = 0 if H_Vote92 == 3 & Z_US92_E_Disc5Part == 4
		replace d5_agree1 = 0 if H_Vote92 == 5 & Z_US92_E_Disc5Part == 2
		replace d5_agree1 = 0 if H_Vote92 == 5 & Z_US92_E_Disc5Part == 3
		replace d5_agree1 = 0 if H_Vote92 == 5 & Z_US92_E_Disc5Part == 4
		label var d5_agree1 "D5: Same Cand Pref?"
		label values d5_agree1 agre
		
		foreach var in d1_agree1 d2_agree1 d3_agree1 d4_agree1 d5_agree1 {
			tab `var'
			}
	*Candidate **Disagree1ment
			*agree1: Bush/Bush; Clinton/Clinton; Perot/Perot
			*disagree: bush/clinton; clinton/bush; perot/bush; perot/bush; 
				*bush/other; clinton/other; none, dk, refused and clinton/perot are dropped
	
		gen d1_dagree1 = . 
		replace d1_dagree1 = 0 if H_Vote92 == 1 & Z_US92_E_Disc1Part == 2
		replace d1_dagree1 = 0 if H_Vote92 == 3 & Z_US92_E_Disc1Part == 3
		replace d1_dagree1 = 0 if H_Vote92 == 5 & Z_US92_E_Disc1Part == 1
		replace d1_dagree1 = 1 if H_Vote92 == 1 & Z_US92_E_Disc1Part == 1
		replace d1_dagree1 = 1 if H_Vote92 == 1 & Z_US92_E_Disc1Part == 3
		replace d1_dagree1 = 1 if H_Vote92 == 1 & Z_US92_E_Disc1Part == 4
		replace d1_dagree1 = 1 if H_Vote92 == 3 & Z_US92_E_Disc1Part == 1
		replace d1_dagree1 = 1 if H_Vote92 == 3 & Z_US92_E_Disc1Part == 2
		replace d1_dagree1 = 1 if H_Vote92 == 3 & Z_US92_E_Disc1Part == 4
		replace d1_dagree1 = 1 if H_Vote92 == 5 & Z_US92_E_Disc1Part == 2
		replace d1_dagree1 = 1 if H_Vote92 == 5 & Z_US92_E_Disc1Part == 3
		replace d1_dagree1 = 1 if H_Vote92 == 5 & Z_US92_E_Disc1Part == 4
		label var d1_dagree1 "D1: Same Cand Pref?"
		label values d1_dagree1 disa
	
			
		gen d2_dagree1 = . 
		replace d2_dagree1 = 0 if H_Vote92 == 1 & Z_US92_E_Disc2Part == 2
		replace d2_dagree1 = 0 if H_Vote92 == 3 & Z_US92_E_Disc2Part == 3
		replace d2_dagree1 = 0 if H_Vote92 == 5 & Z_US92_E_Disc2Part == 1
		
		replace d2_dagree1 = 1 if H_Vote92 == 1 & Z_US92_E_Disc2Part == 1
		replace d2_dagree1 = 1 if H_Vote92 == 1 & Z_US92_E_Disc2Part == 3
		replace d2_dagree1 = 1 if H_Vote92 == 1 & Z_US92_E_Disc2Part == 4
		replace d2_dagree1 = 1 if H_Vote92 == 3 & Z_US92_E_Disc2Part == 1
		replace d2_dagree1 = 1 if H_Vote92 == 3 & Z_US92_E_Disc2Part == 2
		replace d2_dagree1 = 1 if H_Vote92 == 3 & Z_US92_E_Disc2Part == 4
		replace d2_dagree1 = 1 if H_Vote92 == 5 & Z_US92_E_Disc2Part == 2
		replace d2_dagree1 = 1 if H_Vote92 == 5 & Z_US92_E_Disc2Part == 3
		replace d2_dagree1 = 1 if H_Vote92 == 5 & Z_US92_E_Disc2Part == 4
		label var d2_dagree1 "D2: Same Cand Pref?"
		label values d2_dagree1 disa
	
	
		gen d3_dagree1 = . 
		replace d3_dagree1 = 0 if H_Vote92 == 1 & Z_US92_E_Disc3Part == 2
		replace d3_dagree1 = 0 if H_Vote92 == 3 & Z_US92_E_Disc3Part == 3
		replace d3_dagree1 = 0 if H_Vote92 == 5 & Z_US92_E_Disc3Part == 1
		
		replace d3_dagree1 = 1 if H_Vote92 == 1 & Z_US92_E_Disc3Part == 1
		replace d3_dagree1 = 1 if H_Vote92 == 1 & Z_US92_E_Disc3Part == 3
		replace d3_dagree1 = 1 if H_Vote92 == 1 & Z_US92_E_Disc3Part == 4
		replace d3_dagree1 = 1 if H_Vote92 == 3 & Z_US92_E_Disc3Part == 1
		replace d3_dagree1 = 1 if H_Vote92 == 3 & Z_US92_E_Disc3Part == 2
		replace d3_dagree1 = 1 if H_Vote92 == 3 & Z_US92_E_Disc3Part == 4
		replace d3_dagree1 = 1 if H_Vote92 == 5 & Z_US92_E_Disc3Part == 2
		replace d3_dagree1 = 1 if H_Vote92 == 5 & Z_US92_E_Disc3Part == 3
		replace d3_dagree1 = 1 if H_Vote92 == 5 & Z_US92_E_Disc3Part == 4
		label var d3_dagree1 "D3: Same Cand Pref?"
		label values d3_dagree1 disa
		
		gen d4_dagree1 = . 
		replace d4_dagree1 = 0 if H_Vote92 == 1 & Z_US92_E_Disc4Part == 2
		replace d4_dagree1 = 0 if H_Vote92 == 3 & Z_US92_E_Disc4Part == 3
		replace d4_dagree1 = 0 if H_Vote92 == 5 & Z_US92_E_Disc4Part == 1
		
		replace d4_dagree1 = 1 if H_Vote92 == 1 & Z_US92_E_Disc4Part == 1
		replace d4_dagree1 = 1 if H_Vote92 == 1 & Z_US92_E_Disc4Part == 3
		replace d4_dagree1 = 1 if H_Vote92 == 1 & Z_US92_E_Disc4Part == 4
		replace d4_dagree1 = 1 if H_Vote92 == 3 & Z_US92_E_Disc4Part == 1
		replace d4_dagree1 = 1 if H_Vote92 == 3 & Z_US92_E_Disc4Part == 2
		replace d4_dagree1 = 1 if H_Vote92 == 3 & Z_US92_E_Disc4Part == 4
		replace d4_dagree1 = 1 if H_Vote92 == 5 & Z_US92_E_Disc4Part == 2
		replace d4_dagree1 = 1 if H_Vote92 == 5 & Z_US92_E_Disc4Part == 3
		replace d4_dagree1 = 1 if H_Vote92 == 5 & Z_US92_E_Disc4Part == 4
		label var d4_dagree1 "D4: Same Cand Pref?"
		label values d4_dagree1 disa
		
		gen d5_dagree1 = . 
		replace d5_dagree1 = 0 if H_Vote92 == 1 & Z_US92_E_Disc5Part == 2
		replace d5_dagree1 = 0 if H_Vote92 == 3 & Z_US92_E_Disc5Part == 3
		replace d5_dagree1 = 0 if H_Vote92 == 5 & Z_US92_E_Disc5Part == 1
		
		replace d5_dagree1 = 1 if H_Vote92 == 1 & Z_US92_E_Disc5Part == 1
		replace d5_dagree1 = 1 if H_Vote92 == 1 & Z_US92_E_Disc5Part == 3
		replace d5_dagree1 = 1 if H_Vote92 == 1 & Z_US92_E_Disc5Part == 4
		replace d5_dagree1 = 1 if H_Vote92 == 3 & Z_US92_E_Disc5Part == 1
		replace d5_dagree1 = 1 if H_Vote92 == 3 & Z_US92_E_Disc5Part == 2
		replace d5_dagree1 = 1 if H_Vote92 == 3 & Z_US92_E_Disc5Part == 4
		replace d5_dagree1 = 1 if H_Vote92 == 5 & Z_US92_E_Disc5Part == 2
		replace d5_dagree1 = 1 if H_Vote92 == 5 & Z_US92_E_Disc5Part == 3
		replace d5_dagree1 = 1 if H_Vote92 == 5 & Z_US92_E_Disc5Part == 4
		label var d5_dagree1 "D5: Same Cand Pref?"
		label values d5_dagree1 disa
			
	
	*#Disagree1ing Respondents
		egen agree1 = rowtotal(d1_agree1 d2_agree1 d3_agree1 d4_agree1 d5_agree1), missing
		egen disagree1 = rowtotal(d1_dagree1 d2_dagree1 d3_dagree1 d4_dagree1 d5_dagree1), missing
		label var agree1 "# Agreeing Partners"
		label var disagree1 "# Disagreeing Partners"
					
	*Exposure to Disagreement Measures
		*Summary Scale
			*See Lupton and Thornton: Exposure = D - A
			gen disagree_total_1 = disagree1 - agree1
			label var disagree_total_1 "Network Disagreement"
