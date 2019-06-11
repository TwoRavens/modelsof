use "Replication_PA_2013041.dta", replace


/*  This do file replicates the all empirical results in the paper: "Incumbency Effects in a Comparative Perspective:
    Evidence from Brazilian Mayoral Elections".
	
	
	In the .dta file each observations is either the winner or the runner-up in the 1996 mayoral elections.
	
	
	
	Variables:
	
    The main outcome variable of interest is "run_win_m_00", which measures the unconditional incumbency advantage.
	Defined from the source variables: result_00 and cod_cargo_00.
	
	The treatment variable is "right_96", which takes value 1 if the politician became Mayor 1996 and
	0 if the politician is the runner-up in 1996. Defined from the source variables result_96 and cod_cargo_96.
	
	The forcing variale if margin_96, which measures the margin of victory (or loss) as a percentages of the total municipality vote.
	Defined from the source variable qtd_votos_96 and vote_mun_96.

	The second outcome variable is "run_m_96_00", which takes value 1 if politician ran for Mayor in 2000, and 0 otherwise
	Defined from the source variables: cod_cargo_00.

	The third outcome variable is "run_win_98_after_96", which takes value 1 if ran and won office in the 1998 election for state and federal legislators
	Defined from the source variables cod_cargo_98 result_98.
	
	The proxy for the exogenous propensity to retire is "run_again_m_or_v_00", which takes value 1 if ran for any local office in 2000.
	Defined from the source variables cod_cargo_00.
	
	The vote share in 2000 "vote_m_00_96" is constructed from qtd_votos_00 and vote_mun_00.
	
	The variable indicating party swtiching "party_switch_96_00" is defined from partido_96 and partido_00.
	
	
	
	Estimation:
	
	The command "ttest" is used to retrieve the averages on both side of the discontinuity.
	The command "reg" with the option  "cluster(cod_mun_96)" is used to retrieve the standard errors;
	and the estimated discontinuity in Table 3, which uses polynomials.
	
	
*/

***** Table 1 ********************************************************************************************************************************
	
	*** unconditional effects - causal interpretation
	
	* Main result: unconditional incumbency advantage
	reg  run_win_m_00 right_96 if  margin_96<=2 & margin_96>=-2, cluster(cod_mun_96)
	* ttest calculates the mean on each side.
	ttest run_win_m_00  if  margin_96<=2 & margin_96>=-2, by (win_m_96)
	
	* ran again for mayor in 2000
	ttest run_m_96_00  if  margin_96<=2 & margin_96>=-2 , by (win_m_96)
	reg   run_m_96_00 right_96 if  margin_96<=2 & margin_96>=-2, cluster(cod_mun_96)

	* ran and won in the midterm 98 state and federal election
	ttest  run_win_98_after_96 if  margin_96<=2 & margin_96>=-2 , by (win_m_96)
	reg    run_win_98_after_96 right_96 if  margin_96<=2 & margin_96>=-2, cluster(cod_mun_96)

	
	
	*** balane test of pre-determined characteristics
	
	reg   edu_high_96 right_96 if  margin_96<=2 & margin_96>=-2, cluster(cod_mun_96)
	ttest edu_high_96 if  margin_96<=2 & margin_96>=-2 , by (win_m_96)

	reg    single1_dummy_96 right_96 if  margin_96<=2 & margin_96>=-2, cluster(cod_mun_96)
	ttest  single1_dummy_96 if  margin_96<=2 & margin_96>=-2 , by (win_m_96)

	reg    age_96 right_96 if  margin_96<=2 & margin_96>=-2, cluster(cod_mun_96)
	ttest  age_96 if  margin_96<=2 & margin_96>=-2 , by (win_m_96)

	reg   gender_96 right_96 if  margin_96<=2 & margin_96>=-2, cluster(cod_mun_96)
	ttest gender_96 if  margin_96<=2 & margin_96>=-2 , by (win_m_96)

	reg    party_PSDB_96 right_96 if  margin_96<=2 & margin_96>=-2, cluster(cod_mun_96)
	ttest  party_PSDB_96 if  margin_96<=2 & margin_96>=-2 , by (win_m_96)

    reg    party_coalition_96 right_96 if  margin_96<=2 & margin_96>=-2, cluster(cod_mun_96)
	ttest  party_coalition_96 if  margin_96<=2 & margin_96>=-2 , by (win_m_96)

	* ran for either mayor, vice-mayor, or local council in 2000
	ttest  run_again_m_or_v_00 if  margin_96<=2 & margin_96>=-2 , by (win_m_96)
	reg    run_again_m_or_v_00 right_96 if  margin_96<=2 & margin_96>=-2, cluster(cod_mun_96)


	*** effects conditional on rerunning

	* Prob of winning conditional on running for mayor
	ttest  win_m_00   if  margin_96<=2 & margin_96>=-2 , by (win_m_96)
	reg    win_m_00 right_96 if  margin_96<=2 & margin_96>=-2, cluster(cod_mun_96)

	* Difference in vote share.
	ttest  vote_m_00_96      if  margin_96<=2 & margin_96>=-2 , by (win_m_96)
	reg    vote_m_00_96 right_96 if  margin_96<=2 & margin_96>=-2, cluster(cod_mun_96)

	* party switching 
	ttest  party_switch_96_00 if  margin_96<=2 & margin_96>=-2 , by (win_m_96)
	reg    party_switch_96_00 right_96 if  margin_96<=2 & margin_96>=-2, cluster(cod_mun_96)
	
***************************************************************************************************************************************************




***** Appendix - Table 2 - Summary Statistics ******************************************************************************************************
	
	*** unconditional effects - causal interpretation
	
	* Main result: unconditional incumbency advantage
	reg   run_win_m_00 right_96 , cluster(cod_mun_96)
	* ttest calculates the mean on each side.
	ttest run_win_m_00  , by (win_m_96)
	
	* ran again for mayor in 2000
	ttest run_m_96_00   , by (win_m_96)
	reg   run_m_96_00 right_96 , cluster(cod_mun_96)

	* ran and won in the midterm 98 state and federal election
	ttest  run_win_98_after_96  , by (win_m_96)
	reg    run_win_98_after_96 right_96 , cluster(cod_mun_96)

	
	
	*** balane test of pre-determined characteristics
	
	reg   edu_high_96 right_96 , cluster(cod_mun_96)
	ttest edu_high_96  , by (win_m_96)

	reg   single1_dummy_96 right_96 , cluster(cod_mun_96)
	ttest single1_dummy_96  , by (win_m_96)

	reg   age_96 right_96 , cluster(cod_mun_96)
	ttest age_96  , by (win_m_96)

	reg   gender_96 right_96 , cluster(cod_mun_96)
	ttest gender_96  , by (win_m_96)

	reg   party_PSDB_96 right_96 , cluster(cod_mun_96)
	ttest party_PSDB_96  , by (win_m_96)

    reg    party_coalition_96 right_96 , cluster(cod_mun_96)
	ttest  party_coalition_96  , by (win_m_96)

	* ran for either mayor, vice-mayor, or local council in 2000
	ttest  run_again_m_or_v_00  , by (win_m_96)
	reg    run_again_m_or_v_00 right_96 , cluster(cod_mun_96)


	*** effects conditional on rerunning

	* Prob of winning conditional on running for mayor
	ttest  win_m_00    , by (win_m_96)
	reg    win_m_00 right_96 , cluster(cod_mun_96)

	* Difference in vote share.
	ttest  vote_m_00_96       , by (win_m_96)
	reg    vote_m_00_96 right_96 , cluster(cod_mun_96)

	* party switching 
	ttest  party_switch_96_00  , by (win_m_96)
	reg    party_switch_96_00 right_96 , cluster(cod_mun_96)
	
******************************************************************************************************************************************************



****** Appendix - Table 3 - Different Polynomials ****************************************************************************************************

	reg   run_win_m_00 right_96  gRight_96 gRight2_96 gRight3_96  gLeft_96 gLeft2_96 gLeft3_96  , cluster(cod_mun_96)
	reg   run_win_m_00 right_96  gRight_96 gRight2_96 gRight3_96 gRight4_96 gLeft_96 gLeft2_96 gLeft3_96 gLeft4_96 , cluster(cod_mun_96)
	reg   run_win_m_00 right_96  gRight_96 gRight2_96 gRight3_96 gRight4_96 gRight5_96 gLeft_96 gLeft2_96 gLeft3_96 gLeft4_96 gLeft5_96 , cluster(cod_mun_96)
	reg   run_win_m_00 right_96  gRight_96 gRight2_96 gRight3_96 gRight4_96 gRight5_96 gRight6_96 gLeft_96 gLeft2_96 gLeft3_96 gLeft4_96 gLeft5_96 gLeft6_96 , cluster(cod_mun_96)


******************************************************************************************************************************************************




/* The variable "mun_Coalition_96" takes value 1 if Mayor belonged to a party in the Presidential Coalitions.
   The variable "mun_Coalition_2nd_96" takes value 1 if the runner-up belonged to a party in the Presidential Coalitions.
   Both variables defined by partido_96 and partido_00.
*/

****** Appendix - Table 4 - Sample split by type of race *********************************************************************

	    ttest run_win_m_00  if  mun_Coalition_2nd_96==1 & mun_Coalition_96==1 &  margin_96<=2 & margin_96>=-2 , by (win_m_96)
	    reg   run_win_m_00 right_96 if mun_Coalition_2nd_96==1 & mun_Coalition_96==1 &  margin_96<=2 & margin_96>=-2, cluster(cod_mun_96)

		*** 1st place from the coalition, 2nd place not from the coalition (107 mun)
		ttest run_win_m_00  if  mun_Coalition_2nd_96~=1 & mun_Coalition_96==1 &  margin_96<=2 & margin_96>=-2 , by (win_m_96)
		reg   run_win_m_00 right_96 if mun_Coalition_2nd_96~=1 & mun_Coalition_96==1 &  margin_96<=2 & margin_96>=-2, cluster(cod_mun_96)
	
		*** 2nd place from the coalition, 1st place not from the coalition (107 mun: 107+107+315=529 <551 (neither winner or loser from the coalition are the remaining) )
		ttest run_win_m_00         if  mun_Coalition_2nd_96==1 & mun_Coalition_96~=1 &  margin_96<=2 & margin_96>=-2 , by (win_m_96)
	    reg   run_win_m_00 right_96 if  mun_Coalition_2nd_96==1 & mun_Coalition_96~=1 &  margin_96<=2 & margin_96>=-2, cluster(cod_mun_96)

		*** 1st place not coalition, 2nd place not in coalition (107 mun)
		ttest run_win_m_00  if  mun_Coalition_2nd_96~=1 & mun_Coalition_96~=1 &  margin_96<=2 & margin_96>=-2 , by (win_m_96)
		reg   run_win_m_00 right_96 if  mun_Coalition_2nd_96~=1 & mun_Coalition_96~=1 &  margin_96<=2 & margin_96>=-2 , cluster(cod_mun_96)
	
********************************************************************************************************************************************************

