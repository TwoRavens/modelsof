#delimit;
clear;
version 11;
set more off, perm;
  quietly log;
  local logon = r(status);
  if "`logon'" == "on" {; log close; };
log using SPPO_MC_PA.log, text replace;

/*******************************/
/*****  Mark David Nieman  *****/
/*****  1/10/2015          *****/
/*****  Strategic Model, Split-sample Model, Probit  *****/
/***** DGP: strategic *****/
/*****  Monte Carlos & Comparisons  *****/
/*****  Stata 11.2         *****/
/*******************************/
#delimit;
clear;
clear matrix;
clear mata;
set memory 4g;
program drop _all;

set seed 17;

/* Structure of game (utilities in parentheses where r_ is player 1 and g_ is player 2). The application is civil war, so we can treat r as rebels, and g as government.
           Player 1 (r)
            /   \
    ~Chal  /	 \ Chal
          /       \
        Det      Player 2 (g)
	 (r_det)       /	\
                  /      \
                 /        \
                Acq		  War
               (0,0)	(r_war, g_war) */

/* create a likelihood function for a strategic probit where the first actor's (r) action (chal or 1-chal) is unobservable. This means that while there are three outcomes (det, acq, war), we can only see if war=0 or war=1. */
		#delimit;
		program define sppo_lf, rclass;
			
			args lnf r_det r_war g_war; 						
			tempvar pun chal ;
				quietly gen double `pun' = normal(`g_war'/sqrt(2));			
				quietly gen double `chal' = normal((`pun'*`r_war' -`r_det')/(sqrt(`pun'^2+ (1-`pun')^2+1))); 
			quietly replace `lnf' = ln((1-`chal')+(`chal')*(1-`pun')) if $ML_y1==0; 						
			quietly replace `lnf' = ln((`chal')*(`pun')) if $ML_y1==1;
		end;
		
/* create the split sample probit */
		#delimit;
		program define ssp_lf, rclass;
		
			args lnf sq fight;
			tempvar sel_in war;
				quietly gen double `sel_in' = normal(-`sq');
				quietly gen double `war' = normal(`fight');
			quietly replace `lnf' = ln((1-`sel_in')+(`sel_in'*(1-`war'))) if $ML_y1==0;	
			quietly replace `lnf' = ln((`sel_in')*(`war')) if $ML_y1==1;
		end;
		

#delimit;
/* program to generate y */
program define mc_strat, rclass;
  syntax, indvars(string);
	use "`indvars'.dta", clear;

	#delimit;
	/* generate 5 normally distributed error terms (private information for each outcome, see Signorino 2003)*/
	gen double u1 = invnorm(uniform());
	gen double u2 = invnorm(uniform());
	gen double u3 = invnorm(uniform());
	gen double u4 = invnorm(uniform());
	gen double u5 = invnorm(uniform());

	/* generate 3 utilities for Player 1: deterred (status quo), acquiesces, war. Acquiescence is set to 0. */
	gen double U_R_Det = 1*x1+u1;
	gen double U_R_Acq = u2; 					
	gen double U_R_War = 1*x2 + 1*c1 + u3;

	/* generate 2 utilities for Player 2: acquiesce and war */
	gen double U_G_No_War = u4;
	gen double U_G_War = 1*z1 + 1*c1 +u5;
	gen double pi_Pun=normal((U_G_War-U_G_No_War)/sqrt(2));
		  
	/* calculate the "correct" outcomes contingent on each actor's utility */
		/* Rebels Deterred */
		gen Det = 0;
		replace Det =1 if 	U_R_Det >= U_R_Acq*(1-pi_Pun) +U_R_War*pi_Pun ;
		/* Government Acquiesces */
		gen Acq = 0;
		replace Acq =1 if 	(U_R_Acq*(1-pi_Pun) +U_R_War*pi_Pun > U_R_Det) & (U_G_No_War >= U_G_War);
		/* Civil War */
		gen War = 0;
		replace War =1 if 	(U_R_Acq*(1-pi_Pun) +U_R_War*pi_Pun > U_R_Det) & (U_G_War > U_G_No_War);
	
	sum Acq;
	return scalar Acq_true=r(mean);
	
		#delimit;		
	
		/* run a traditional probit model to compare results */
		gen x1_prime = -x1;
		probit War x1_prime x2 z1 c1, nocons;
		return scalar x2_prob=_b[x2]; 
		return scalar x2_prob_se=_se[x2];		 
		return scalar x1_prob=_b[x1_prime]; 
		return scalar x1_prob_se=_se[x1_prime];
		return scalar z1_prob=_b[z1]; 
		return scalar z1_prob_se=_se[z1];
		return scalar c1_prob=_b[c1]; 
		return scalar c1_prob_se=_se[c1];
		matrix ll_p = e(ll);
		#delimit;
		/* obtain each individual observation's likelihood for use in the Clarke test, as well as other in-sample test statistics (pct correct, pct war correct, false positive)*/
		/* generate likelihood (this can also be recovered from a hand-written probit program, but is computationally intensive and takes a significantly longer time.) */
		/* probit likelihood with Schwartz correction */
		gen double lnfj_p = .;
			replace lnfj_p = ln(normal(-(_b[x1_prime]*x1_prime + _b[z1]*z1 + _b[x2]*x2 + _b[c1]*c1))) if War==0;
			replace lnfj_p = ln(normal(_b[x1]*x1 + _b[z1]*z1 + _b[x2]*x2 + _b[c1]*c1)) if War==1;
			replace lnfj_p = lnfj_p*(4/(2*_N))*ln(_N);
		/* probability of war (probit) */
		gen double pr_War_p = normal(_b[x1]*x1 + _b[z1]*z1 + _b[x2]*x2 + _b[c1]*c1);
		gen p_predict_War = 0;
				replace p_predict_War =1 if pr_War_p > .5;
			/* observations correctly predicted */
			gen correct_p = 0;
				replace correct_p = 1 if (p_predict_War==1 & War==1) | (p_predict_War==0 & War==0);
			/* observations correctly predicted as war */
			gen correct_war_p = .;
				replace correct_war_p = 0 if (p_predict_War==0 & War==1);
				replace correct_war_p = 1 if (p_predict_War==1 & War==1);
			/* observations incorrectly predicted as war*/
			gen incorrect_war_p =.;
				replace incorrect_war_p = 0 if (p_predict_War==0 & War==0);
				replace incorrect_war_p = 1 if (p_predict_War==1 & War==0);
			/* results */	
			sum correct_p;
				return scalar correct_pct_p = r(mean);
			sum correct_war_p;
				return scalar correct_war_pct_p = r(mean);
			sum incorrect_war_p;
				return scalar incorrect_war_pct_p = r(mean);
		
		
		/* call the strategic probit with partial observability model to estimate the parameters */
		#delimit;
		ml model lf sppo_lf (R_Det:War=x1, nocons) (R_War:War = x2 c1, nocons) (G_War: War= z1 c1, nocons) ;
		ml maximize, diff;
		return scalar x1_sppo=[R_Det]_b[x1];
		return scalar x1_sppo_se=[R_Det]_se[x1];		 
		return scalar x2_sppo=[R_War]_b[x2]; 
		return scalar x2_sppo_se=[R_War]_se[x2];
		return scalar c1a_sppo=[R_War]_b[c1]; 
		return scalar c1a_sppo_se=[R_War]_se[c1];
		return scalar z1_sppo=[G_War]_b[z1]; 
		return scalar z1_sppo_se=[G_War]_se[z1];
		return scalar c1b_sppo=[G_War]_b[c1]; 
		return scalar c1b_sppo_se=[G_War]_se[c1];
		matrix ll_sppo = e(ll);
		#delimit;
		/* obtain each individual observation's likelihood for use in the Clarke test, as well as other in-sample test statistics (pct correct, pct war correct, false positive, correctly predicted acquiesce)*/
		/* generate likelihood (this can also be recovered in the lf_sppo program, but is computationally intensive and takes a significantly longer time.) */
		/* sppo likelihood with Schwartz correction */		
		gen double pun = normal( ([G_War]_b[z1]*z1 + [G_War]_b[c1]*c1) / sqrt(2) );
		gen double chal = normal( ( pun*([R_War]_b[x2]*x2+[R_War]_b[c1]*c1) - ([R_Det]_b[x1]*x1) ) /(sqrt(pun^2+ (1-pun)^2+1) )); 
		gen double lnfj_sppo = .;
			replace  lnfj_sppo = ln((1-chal)+(chal)*(1-pun)) if War==0;
			replace  lnfj_sppo = ln((chal)*(pun)) if War==1;
			#delimit;
			replace lnfj_sppo = lnfj_sppo*(5/(2*_N))*ln(_N);
		#delimit;
		/* probability of war (sppo) */
		gen double pr_War_sppo = pun*chal;
		gen double pr_Acq_sppo = chal*(1-pun);
		gen double pr_Det_sppo = 1-chal;
			gen sppo_predict_War = 0;
				replace sppo_predict_War =1 if (pr_War_sppo > pr_Acq_sppo) & (pr_War_sppo > pr_Det_sppo);
			/* observations correctly predicted */
			gen correct_sppo = 0;
				replace correct_sppo = 1 if (sppo_predict_War==1 & War==1) | (sppo_predict_War==0 & War==0);
			/* observations correctly predicted as war */
			gen correct_war_sppo = .;
				replace correct_war_sppo = 0 if (sppo_predict_War==0 & War==1);
				replace correct_war_sppo = 1 if (sppo_predict_War==1 & War==1);
			/* observations incorrectly predicted as war*/
			gen incorrect_war_sppo =.;
				replace incorrect_war_sppo = 0 if (sppo_predict_War==0 & War==0);
				replace incorrect_war_sppo = 1 if (sppo_predict_War==1 & War==0);
			/* percent correctly predicted unobserved Y3 (acquiesce) */
			gen sppo_predict_acq=0;
				replace sppo_predict_acq=  1 if (pr_War_sppo < pr_Acq_sppo) & (pr_Acq_sppo > pr_Det_sppo);
			gen correct_acq_sppo=.;	
				replace correct_acq_sppo = 0 if (sppo_predict_acq==0 & Acq==1);
				replace correct_acq_sppo = 1 if (sppo_predict_acq==1 & Acq==1);
			/* results*/
			sum correct_sppo;
				return scalar correct_pct_sppo = r(mean);
			sum correct_war_sppo;
				return scalar correct_war_pct_sppo = r(mean);
			sum incorrect_war_sppo;
				return scalar incorrect_war_pct_sppo = r(mean);
			sum correct_acq_sppo;
				return scalar correct_acq_sppo=r(mean);
				
				
		/* call the split-sample probit model to estimate the parameters */
		#delimit;
		gen c1_prime = -c1;
		ml model lf ssp_lf (SQ:War=x1 c1_prime, nocons) (War:War = x2 z1 c1, nocons);
		ml maximize, diff;	
		return scalar x1_ssp=[SQ]_b[x1];
		return scalar x1_ssp_se=[SQ]_se[x1];		 
		return scalar x2_ssp=[War]_b[x2]; 
		return scalar x2_ssp_se=[War]_se[x2];
		return scalar z1_ssp=[War]_b[z1]; 
		return scalar z1_ssp_se=[War]_se[z1];
		return scalar c1a_ssp=[SQ]_b[c1_prime];
		return scalar c1a_ssp_se=[SQ]_se[c1_prime];
		return scalar c1b_ssp=[War]_b[c1]; 
		return scalar c1b_ssp_se=[War]_se[c1];
		matrix ll_ssp = e(ll);
		/* obtain each individual observation's likelihood for use in the Clarke test, as well as other in-sample test statistics (pct correct, pct war correct, false positive)*/
		/* generate likelihood (this can also be recovered in the lf_ssp program, but is computationally intensive and takes a significantly longer time.) */
		/* ssp likelihood with Schwartz correction */
		#delimit;
		gen double sel_in = normal( -([SQ]_b[x1]*x1 + [SQ]_b[c1_prime]*c1_prime) );
		gen double confl = normal([War]_b[x2]*x2+ [War]_b[z1]*z1+ [War]_b[c1]*c1);
		#delimit;
		gen double lnfj_ssp = .;
			replace  lnfj_ssp = ln((1-sel_in)+(sel_in*(1-confl))) if War==0;	;
			replace  lnfj_ssp = ln((sel_in)*(confl)) if War==1;
			replace lnfj_ssp = lnfj_ssp*(5/(2*_N))*ln(_N);
		#delimit;
		/* probability of war (ssp) */
		gen double pr_War_ssp = sel_in*confl;
			gen ssp_predict_War = 0;
				replace ssp_predict_War =1 if pr_War_sppo > .5;
			/* observations correctly predicted */	
			gen correct_ssp = 0;
				replace correct_ssp = 1 if (ssp_predict_War==1 & War==1) | (ssp_predict_War==0 & War==0);
			/* observations correctly predicted as war */
			gen correct_war_ssp = .;
				replace correct_war_ssp = 0 if (ssp_predict_War==0 & War==1);
				replace correct_war_ssp = 1 if (ssp_predict_War==1 & War==1);
			/* observations incorrectly predicted as war*/
			gen incorrect_war_ssp =.;
				replace incorrect_war_ssp = 0 if (ssp_predict_War==0 & War==0);
				replace incorrect_war_ssp = 1 if (ssp_predict_War==1 & War==0);	
			/* results */
			sum correct_ssp;
				return scalar correct_pct_ssp = r(mean);
			sum correct_war_ssp;
				return scalar correct_war_pct_ssp = r(mean);
			sum incorrect_war_ssp;
				return scalar incorrect_war_pct_ssp = r(mean);				
				
				
		
		/* Use Clarke's non-parametric approach to compare each observation's likelihood: SPPO vs SSP*/
		signtest lnfj_sppo=lnfj_ssp;
		return scalar Clark_sppo_ssp_pos = r(N_pos);
		return scalar Clark_sppo_ssp_pos_1s = r(p_pos);
		return scalar Clark_sppo_ssp_neg_1s = r(p_neg);
		return scalar Clark_sppo_ssp_eq_2s = r(p_2);

		/* Use Clark's non-parametric approach to compare each observation's likelihood: SPPO vs probit*/
		signtest lnfj_sppo=lnfj_p;
		return scalar Clark_sppo_p_pos = r(N_pos);
		return scalar Clark_sppo_p_pos_1s = r(p_pos);
		return scalar Clark_sppo_p_neg_1s = r(p_neg);
		return scalar Clark_sppo_p_eq_2s = r(p_2);		
		
		/* Voung Test: SPPO vs probit*/
		svmat ll_p;
		svmat ll_sppo;
		gen num_V_sppo_p = ll_sppo1 - ll_p1 + ((5/2)*ln(_N)-(4/2)*ln(_N));
		sum num_V_sppo_p;
			return scalar num_V_sppo_p = r(mean);
		egen denom1_V_sppo_p = mean((lnfj_sppo/lnfj_p)^2);
		gen denom2_V_sppo_p = sqrt(denom1_V_sppo_p);
		sum denom2_V_sppo_p;
			return scalar denom2_V_sppo_p = r(mean);
		gen Voung_sppo_p = num_V_sppo_p/denom2_V_sppo_p;
		sum Voung_sppo_p;
			return scalar Voung_sppo_p = r(mean);
		/* Voung Test: SPPO vs SSP*/
		svmat ll_ssp;
		gen num_V_sppo_ssp = ll_sppo1 - ll_ssp1 + ((5/2)*ln(_N)-(5/2)*ln(_N));
		sum num_V_sppo_ssp;
			return scalar num_V_sppo_ssp = r(mean);
		egen denom1_V_sppo_ssp = mean((lnfj_sppo/lnfj_ssp)^2);
		gen denom2_V_sppo_ssp = sqrt(denom1_V_sppo_ssp);
		sum denom2_V_sppo_ssp;
			return scalar denom2_V_sppo_ssp = r(mean);
		gen Voung_sppo_ssp = num_V_sppo_ssp/denom2_V_sppo_ssp;
		sum Voung_sppo_ssp;
			return scalar Voung_sppo_ssp = r(mean);
			
			
		/* Robustness Check */	
		/* call the strategic probit with partial observability model to estimate the parameters when model misspecified */
		#delimit;
		ml model lf sppo_lf (R_Det:War=x1 x2, nocons) (R_War:War = x2 c1 x4, nocons) (G_War: War= z1 c1 x2, nocons) ;
		ml maximize, diff;
		return scalar x1_sppo_mis=[R_Det]_b[x1];
		return scalar x1_sppo_se_mis=[R_Det]_se[x1];
		return scalar x3_sppo_mis=[R_Det]_b[x2];
		return scalar x3_sppo_se_mis=[R_Det]_se[x2];		 
		return scalar x2_sppo_mis=[R_War]_b[x2]; 
		return scalar x2_sppo_se_mis=[R_War]_se[x2];
		return scalar c1_sppo_mis=[R_War]_b[c1];
		return scalar c1_sppo_se_mis=[R_War]_se[c1];
		return scalar x4_sppo_mis=[R_War]_b[x4]; 
		return scalar x4_sppo_se_mis=[R_War]_se[x4];
		return scalar g_z1_sppo_mis=[G_War]_b[z1]; 
		return scalar g_z1_sppo_se_mis=[G_War]_se[z1];
		return scalar g_c1_sppo_mis=[G_War]_b[c1];
		return scalar g_c1_sppo_se_mis=[G_War]_se[c1];
		return scalar g_x4_sppo_mis=[G_War]_b[x2];
		return scalar g_x4_sppo_se_mis=[G_War]_se[x2];
		#delimit;
		/* obtain each individual observation's likelihood for use in the Clarke test, as well as other in-sample test statistics (pct correct, pct war correct, false positive, correctly predicted acquiesce)*/
		/* generate likelihood (this can also be recovered in the lf_sppo program, but is computationally intensive and takes a significantly longer time.) */
		/* sppo likelihood  */	
		gen double pun_mis = normal(([G_War]_b[z1]*z1 + [G_War]_b[c1]*c1 + [G_War]_b[x2]*x2)/sqrt(2));
		gen double chal_mis = normal((pun*([R_War]_b[x2]*x2 + [R_War]_b[c1]*c1 + [R_War]_b[x4]*x4) -([R_Det]_b[x1]*x1 + [R_Det]_b[x2]*x2))/(sqrt(pun^2+ (1-pun)^2+1))); 
		gen double lnfj_sppo_mis = .;
			replace  lnfj_sppo_mis = ln((1-chal_mis)+(chal_mis)*(1-pun_mis)) if War==0;
			replace  lnfj_sppo_mis = ln((chal_mis)*(pun_mis)) if War==1;
		#delimit;
		/* probability of war (sppo) */
		gen double pr_War_sppo_mis = pun_mis*chal_mis;
		gen double pr_Acq_sppo_mis = chal_mis*(1-pun_mis);
		gen double pr_Det_sppo_mis = 1-chal_mis;
			gen sppo_predict_War_mis = 0;
				replace sppo_predict_War_mis =1 if (pr_War_sppo_mis > pr_Acq_sppo_mis) & (pr_War_sppo_mis > pr_Det_sppo_mis);
			/* observations correctly predicted */
			gen correct_sppo_mis = 0;
				replace correct_sppo_mis = 1 if (sppo_predict_War_mis==1 & War==1) | (sppo_predict_War_mis==0 & War==0);
			/* observations correctly predicted as war */
			gen correct_war_sppo_mis = .;
				replace correct_war_sppo_mis = 0 if (sppo_predict_War_mis==0 & War==1);
				replace correct_war_sppo_mis = 1 if (sppo_predict_War_mis==1 & War==1);
			/* observations incorrectly predicted as war*/
			gen incorrect_war_sppo_mis =.;
				replace incorrect_war_sppo_mis = 0 if (sppo_predict_War_mis==0 & War==0);
				replace incorrect_war_sppo_mis = 1 if (sppo_predict_War_mis==1 & War==0);
			/* percent correctly predicted unobserved Y3 (acquiesce) */
			gen sppo_predict_acq_mis=0;
				replace sppo_predict_acq_mis=  1 if (pr_War_sppo_mis < pr_Acq_sppo_mis) & (pr_Acq_sppo_mis > pr_Det_sppo_mis);
			gen correct_acq_sppo_mis=.;	
				replace correct_acq_sppo_mis = 0 if (sppo_predict_acq_mis==0 & Acq==1);
				replace correct_acq_sppo_mis = 1 if (sppo_predict_acq_mis==1 & Acq==1);
			/* results */
			sum correct_sppo_mis;
				return scalar correct_pct_sppo_mis = r(mean);
			sum correct_war_sppo_mis;
				return scalar correct_war_pct_sppo_mis = r(mean);
			sum incorrect_war_sppo_mis;
				return scalar incorrect_war_pct_sppo_mis = r(mean);
			sum correct_acq_sppo_mis;
				return scalar correct_acq_sppo_mis=r(mean);				
		
end;

	
#delimit;	
clear;	
	/* generate independent variables. */
	drawnorm z1 x1 x2 c1 x3 x4, n(5000) ;

#delimit;
save indvars.dta, replace;

simulate 
	x2_prob=r(x2_prob) x2_prob_se=r(x2_prob_se)
	x1_prob=r(x1_prob) x1_prob_se=r(x1_prob_se)
	z1_prob=r(z1_prob) z1_prob_se=r(z1_prob_se)
	c1_prob=r(c1_prob) c1_prob_se=r(c1_prob_se)
	
	
	R_Det_x1=r(x1_sppo) R_Det_x1_se=r(x1_sppo_se)
	R_War_x2=r(x2_sppo) R_War_x2_se=r(x2_sppo_se)
	R_War_c1=r(c1a_sppo) R_War_c1_se=r(c1a_sppo_se)
	G_War_z1=r(z1_sppo) G_War_z1_se=r(z1_sppo_se)
	G_War_c1=r(c1b_sppo) G_War_c1_se=r(c1b_sppo_se)
	
	
	x1_ssp=r(x1_ssp) x1_ssp_se=r(x1_ssp_se)
	x2_ssp=r(x2_ssp) x2_ssp_se=r(x2_ssp_se)
	z1_ssp=r(z1_ssp) z1_ssp_se=r(z1_ssp_se)
	c1a_ssp=r(c1a_ssp) c1a_ssp_se=r(c1a_ssp_se)
	c1b_ssp=r(c1b_ssp) c1b_ssp_se=r(c1b_ssp_se)
	
	correct_pct_p = r(correct_pct_p)
	correct_war_pct_p = r(correct_war_pct_p)
	incorrect_war_pct_p=r(incorrect_war_pct_p)
	correct_pct_sppo = r(correct_pct_sppo)
	correct_war_pct_sppo = r(correct_war_pct_sppo)
	incorrect_war_pct_sppo = r(incorrect_war_pct_sppo)
	correct_pct_ssp = r(correct_pct_ssp)
	correct_war_pct_ssp = r(correct_war_pct_ssp)
	incorrect_war_pct_ssp = r(incorrect_war_pct_ssp)
	
	/*Predicting Unobserved Outcome Acquiesce*/	
	correct_acq_sppo=r(correct_acq_sppo)
	Acq_true=r(Acq_true)
	
	Clark_sppo_ssp_pos = r(Clark_sppo_ssp_pos)
	Clark_sppo_ssp_pos_1s = r(Clark_sppo_ssp_pos_1s)
	Clark_sppo_ssp_neg_1s = r(Clark_sppo_ssp_neg_1s)
	Clark_sppo_ssp_eq_2s = r(Clark_sppo_ssp_eq_2s)
	Clark_sppo_p_pos = r(Clark_sppo_p_pos)
	Clark_sppo_p_pos_1s = r(Clark_sppo_p_pos_1s)
	Clark_sppo_p_neg_1s = r(Clark_sppo_p_neg_1s)
	Clark_sppo_p_eq_2s = r(Clark_sppo_p_eq_2s)
	num_V_sppo_ssp = r(num_V_sppo_ssp)
	denom2_V_sppo_ssp = r(denom2_V_sppo_ssp)
	num_V_sppo_p = r(num_V_sppo_p)
	denom2_V_sppo_p = r(denom2_V_sppo_p)
	Voung_sppo_ssp = r(Voung_sppo_ssp)
	Voung_sppo_p = r(Voung_sppo_p)
	
	R_Det_x1_mis=r(x1_sppo_mis) R_Det_x1_se_mis=r(x1_sppo_se_mis)
	R_Det_x3_mis=r(x3_sppo_mis) R_Det_x3_se_mis=r(x3_sppo_se_mis)
	R_War_x2_mis=r(x2_sppo_mis) R_War_x2_se_mis=r(x2_sppo_se_mis)
	R_War_c1_mis=r(c1_sppo_mis) R_War_c1_se_mis=r(c1_sppo_se_mis)
	R_War_x4_mis=r(x4_sppo_mis) R_War_x4_se_mis=r(x4_sppo_se_mis)
	G_War_z1_mis=r(g_z1_sppo_mis) G_War_z1_se_mis=r(g_z1_sppo_se_mis)
	G_War_c1_mis=r(g_c1_sppo_mis) G_War_c1_se_mis=r(g_c1_sppo_se_mis)
	G_War_x4_mis=r(g_x4_sppo_mis) G_War_x4_se_mis=r(g_x4_sppo_se_mis) 
	
	correct_pct_sppo_mis = r(correct_pct_sppo_mis)
	correct_war_pct_sppo_mis = r(correct_war_pct_sppo_mis)
	incorrect_war_pct_sppo_mis = r(incorrect_war_pct_sppo_mis)
	correct_acq_sppo_mis = r(correct_acq_sppo_mis)
	,
	
	reps(2000): 
	mc_strat, indvars(indvars) ;
	
	/* see results and compare to the "real" values  */
	sum;
	
 /*generate root mean standard error for each parameter */
#delimit;
gen rmse_x2_sppo = sqrt((R_War_x2 - 1)^2 + (R_War_x2_se)); 
gen rmse_x2_p = sqrt((x2_prob - 1)^2 + (x2_prob_se));
gen rmse_x2_ssp = sqrt((x2_ssp - 1)^2 + (x2_ssp_se));
gen rmse_z1_sppo = sqrt((G_War_z1 - 1)^2 + (G_War_z1_se)); 
gen rmse_z1_p = sqrt((z1_prob - 1)^2 + (z1_prob_se));
gen rmse_z1_ssp = sqrt((z1_ssp - 1)^2 + (z1_ssp_se));
gen rmse_x1_sppo = sqrt((R_Det_x1 - 1)^2 + (R_Det_x1_se)); 
gen rmse_x1_p = sqrt((x1_prob - 1)^2 + (x1_prob_se));
gen rmse_x1_ssp = sqrt((x1_ssp - 1)^2 + (x1_ssp_se));
gen rmse_c1a_p = sqrt((c1_prob - 1)^2 + (c1_prob_se));
gen rmse_c1a_ssp = sqrt((c1a_ssp - 1)^2 + (c1a_ssp_se));
gen rmse_c1a_sppo = sqrt((R_War_c1 - 1)^2 + (R_War_c1_se));
gen rmse_c1b_p = sqrt((c1_prob - 1)^2 + (c1_prob_se));
gen rmse_c1b_ssp = sqrt((c1b_ssp - 1)^2 + (c1b_ssp_se));
gen rmse_c1b_sppo = sqrt((G_War_c1 - 1)^2 + (G_War_c1_se));

sum rmse_x1_sppo rmse_x1_p rmse_x1_ssp rmse_z1_sppo rmse_z1_p rmse_z1_ssp 
	rmse_x2_sppo rmse_x2_p rmse_x2_ssp rmse_c1a_p rmse_c1a_ssp rmse_c1a_sppo
	rmse_c1b_p rmse_c1b_ssp rmse_c1b_sppo;


save indvars, replace;
#delimit;
use indvars, clear;

/* graph the betas */
#delimit;
twoway kdensity x1_prob, scheme(s1color) color(gs5) lwidth(medthick) lpattern(shortdash)
	|| kdensity x1_ssp, color(gs9) lwidth(medthin) lpattern(longdash_dot)
	|| kdensity R_Det_x1, color(black) lwidth(medthick)
	xtitle("") xline(1, lcolor(gs8) lpattern(dash)) title(X_11 B_11)
	legend(label(1 "Traditional Probit") label(2 "Split-Sample Probit") label(3 "Censored Strategic Probit"))
	ylabel(0 "0" 15 "15" 30 "30");
	graph save Strat_x1_compare, replace;
	
twoway kdensity x2_prob, scheme(s1color) color(gs5) lwidth(medthick) lpattern(shortdash)
|| kdensity x2_ssp, color(gs9) lwidth(medthin) lpattern(longdash_dot)
|| kdensity R_War_x2, color(black) lwidth(medthick)
	xtitle("") xline(1, lcolor(gs8) lpattern(dash)) title(X_14 B_14)
	legend(label(1 "Traditional Probit") label(2 "Split-Sample Probit") label(3 "Censored Strategic Probit"))
	ylabel(0 "0" 15 "15" 30 "30");
	graph save Strat_x2_compare, replace;
	
#delimit;
twoway kdensity z1_prob, scheme(s1color) color(gs5) lwidth(medthick) lpattern(shortdash)
|| kdensity z1_ssp, color(gs9) lwidth(medthin) lpattern(longdash_dot)
|| kdensity G_War_z1, color(black) lwidth(medthick)
	xtitle("") xline(1, lcolor(gs8) lpattern(dash)) title(X_24 B_24)
	legend(label(1 "Traditional Probit") label(2 "Split-Sample Probit") label(3 "Strategic Probit w/ Partial Observability"))
	legend(off) ylabel(0 "0" 15 "15" 30 "30");
	graph save Strat_z1_compare, replace;

#delimit;
twoway  kdensity c1a_ssp, scheme(s1color) color(gs9) lwidth(medthin) lpattern(longdash_dot)
|| kdensity R_War_c1, color(black) lwidth(medthick)
	xtitle("") xline(1, lcolor(gs8) lpattern(dash)) title("X_C B_14C")
	/*legend(label(1 "Traditional Probit") label(2 "Split-Sample Probit") label(3 "Censored Strategic Probit"))*/
	legend(off) ylabel(0 "0" 15 "15" 30 "30");
	graph save Strat_c1a_compare, replace;	
	
#delimit;
twoway kdensity c1_prob, scheme(s1color) color(gs5) lwidth(medthick) lpattern(shortdash)
|| kdensity c1b_ssp, color(gs9) lwidth(medthin) lpattern(longdash_dot)
|| kdensity G_War_c1, color(black) lwidth(medthick)
	xtitle("") xline(1, lcolor(gs8) lpattern(dash)) title("X_C B_24C")
	legend(label(1 "Probit") label(2 "SSP") label(3 "SPwPO"))
	legend(off) ylabel(0 "0" 15 "15" 30 "30");
	graph save Strat_c1b_compare, replace;	
	
#delimit;
grc1leg Strat_x1_compare.gph Strat_x2_compare.gph Strat_c1a_compare.gph Strat_z1_compare.gph Strat_c1b_compare.gph,
	scheme(s1color) ycommon xcommon col(3) holes(4)
	title("Comparison of Estimated Coefficients")
	l1title("Kernel Density")
	leg(Strat_z1_compare.gph)
	b1title("Coefficient") imargin(tiny)
	note("Note: Dashed verticle line represents the equation's true coefficient. Results of 2000 simulations with 5000" 
		 "observations each. B_ij represents the estimated coeffient for regressor X_ij, where i is the player and"
		 "j is the outcome. X_C is a common regressor that appears in each player's utility. Because the traditional"
		 "probit is a single equation model, it estimates only one parameter for X_C, which is displayed in X_C B_24C.");
		graph save Strat_Coef_compare, replace asis;
		graph export Strat_Coef_compare.eps, replace;
