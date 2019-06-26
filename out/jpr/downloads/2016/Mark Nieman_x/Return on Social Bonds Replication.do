#delimit;
clear;
set more off, perm;
version 11.1;
  quietly log;
  local logon = r(status);
  if "`logon'" == "on" {; log close; };
log using Return_on_Social_Bonds_Replication.log, text replace;


/*******************************/
/*  Mark David Nieman  */
/*  Return on Social Bonds    */
/*  Data Analysis Replication    */
/*  1/16/2016  */
/*  Tables 1 and 3 */
/*  Figures 3 and 4 */
/*  Stata 11.2           */
/*  The Stata package "grc1leg" must be downloaded in order to completely run this file: */
/*******************************/

#delimit;
clear; clear matrix;
program drop _all;
set seed 83;
clear mata;
set memory 4g;
#delimit;
use BargHierGenData_JPR, clear;

/* Table 1 Cross tab*/
tab tgt_gtr Punished_MID_Sanct_lag;

#delimit;
/* Table 3 */
/* Statistical Backwards Induction */

	/* Punish equation*/
	probit Punished_MID_Sanct_lag relUS_SecHierBA relUS_EconHierBA rus_ally_hierA  
		PowerRatio100A_US PowerRatio100A_US2 lndistance_US Democ_Chal ongoingMID_US Prev_Chal constantXB22, nocons ;
				estimates store pun;	
				matrix beta_pun = e(b);
				matrix se_pun = e(V);
		#delimit;
		predict pr_pun;
		
#delimit;
	/* conflict utility */
	gen FPowerRatioA = PowerRatioA*pr_pun;
	gen FPowerRatioA_2 = (PowerRatioA^2)*pr_pun;
	gen FpowerchangeA = powerchange100*pr_pun;
	gen FPrev_Chal = Prev_Chal*pr_pun;
	gen FcivwarA = civwarA*pr_pun;
	gen Flndistance = lndistance*pr_pun;
	gen Fcontig = contig*pr_pun;
	gen FJointDem = JointDem*pr_pun;	
	gen Fbitrade = bitrade_gdp*pr_pun;
	gen Fally = ally*pr_pun;
	gen FconstantXA21 = constantXA21*(1-pr_pun);
	
	/* status quo utility */
	gen FUS_SecHierA = -US_SecHierA;
	gen FUS_EconHierA = -US_EconHierA;
	gen FconstantA1 = -constantXA1;

	/* Challenge equation */
	#delimit;
	probit Challenge FUS_SecHierA FUS_EconHierA 
			FPowerRatioA FPowerRatioA_2 FpowerchangeA FPrev_Chal Fcontig 
			FJointDem Fally Fbitrade FcivwarA FconstantA1 FconstantXA21
			, nocons iterate(50) vce(bootstrap, reps(500) reject(e(converged)==0));
				#delimit;
				estimates store chal;
				matrix beta_chal = e(b);
				matrix se_chal = e(V);				
							

/* Predicted Probability */	
	#delimit;
	/* Restrict to sample */
	keep if e(sample)==1;		
					
	/* Effect of changing Security Hierarhcy from p5 to p95 on probability of Conflict (Pr(Ch)=1 & Pr(Pun)=1) */
	collapse  (median) target_mid=US_SecHierA US_EconHierA   
					lndistance_US constantXB22 PowerRatio100A_US bitrade_gdp
					PowerRatioA powerchange100  constantXA1 constantXA21
				  Democ_Chal contig JointDem civwarA ongoingMID_US Prev_Chal ally rus_ally_hierA
				(p5) US_SecHierA_min=US_SecHierA (p95) US_SecHierA_max=US_SecHierA
				(p5) target_low=US_SecHierA (p95) target_high=US_SecHierA;
	#delimit;
	expand 100;
	gen US_SecHierA = US_SecHierA_min + (US_SecHierA_max - US_SecHierA_min)*(_n-1)/_N;
	expand 100;
	
		/* draws of Pun stage */
	#delimit;
	drawnorm beta1 beta2 beta3 beta4 beta5 beta6 beta7 beta8 beta9 beta10, 
			means(beta_pun) cov(se_pun);
		/* draws of Chal stage */
	drawnorm gamma1 gamma2 gamma3 gamma4 gamma5 gamma6 gamma7 gamma8 gamma9 gamma10 gamma11 gamma12 gamma13, 
			means(beta_chal) cov(se_chal);
			
		/* generate relative hierarchy with low, mid, high target state */
		gen rel_hier_tgt_low = target_low - US_SecHierA;
		gen rel_hier_tgt_mid = target_mid - US_SecHierA;
		gen rel_hier_tgt_high = target_high -US_SecHierA;
		
		/* generate squared powerratio term */
		gen PowerRatio100A_US2 = (((PowerRatio100A_US/100)^2)*100);
		
		#delimit;
		/* generate xbhat for each action when target state is low */
		/**/
		gen double xbhat_Pun_tgt_low = beta1*rel_hier_tgt_low + beta2*0 + beta3*rus_ally_hierA + beta4*PowerRatio100A_US +
			beta5*PowerRatio100A_US2 + beta6*lndistance_US + beta7*Democ_Chal + beta8*ongoingMID_US + beta9*Prev_Chal + beta10;
			
				#delimit;
				/* generate predicted action and generate Chal stage variables */
				gen prT_L = normal(xbhat_Pun_tgt_low);
				
					gen LconstantXA21 = constantXA21*(1-prT_L);
					gen LPowerRatioA = PowerRatioA* prT_L;
					gen LPowerRatioA_2 = (PowerRatioA^2)*prT_L;
					gen LpowerchangeA = powerchange100*prT_L;
					gen LPrev_Chal = Prev_Chal*prT_L;
					gen LcivwarA = civwarA*prT_L;
					gen Lcontig = contig*prT_L;
					gen LJointDem = JointDem*prT_L;
					gen Lbitrade = bitrade_gdp*prT_L;
					gen Lally = ally*prT_L;
			
			gen double xbhat_War_tgt_low = gamma3*LPowerRatioA +gamma4*LPowerRatioA_2 + gamma5*LpowerchangeA + gamma6*LPrev_Chal + gamma7*prT_L + gamma8*JointDem + gamma9*Lally + gamma10*Lbitrade + gamma11*LcivwarA;
			gen double xbhat_Acq_tgt_low = gamma13*LconstantXA21;	
			gen double xbhat_NChal_tgt_low = gamma1*(US_SecHierA) + gamma2*(US_EconHierA) + gamma12;
			
		/* generate xbhat for each action when target state is mid */
		/**/
		gen double xbhat_Pun_tgt_mid = beta1*rel_hier_tgt_mid + beta2*0 + beta3*rus_ally_hierA + beta4*PowerRatio100A_US +
			beta5*PowerRatio100A_US2 + beta6*lndistance_US + beta7*Democ_Chal + beta8*ongoingMID_US + beta9*Prev_Chal + beta10;
			
			#delimit;
				/* generate predicted action and generate Chal stage variables */
				gen prT_M = normal(xbhat_Pun_tgt_mid);
				
					gen MconstantXA21 = constantXA21*(1-prT_M);
					gen MPowerRatioA = PowerRatioA* prT_M;
					gen MPowerRatioA_2 = (PowerRatioA^2)*prT_M;
					gen MpowerchangeA = powerchange100*prT_M;
					gen MPrev_Chal = Prev_Chal*prT_M;
					gen McivwarA = civwarA*prT_M;
					gen Mcontig = contig*prT_M;
					gen MJointDem = JointDem*prT_M;
					gen Mbitrade = bitrade_gdp*prT_M;
					gen Mally = ally*prT_M;
				
			#delimit;	
			gen double xbhat_War_tgt_mid = gamma3*MPowerRatioA + gamma4*MPowerRatioA_2 + gamma5*MpowerchangeA + gamma6*MPrev_Chal + gamma7*prT_M + gamma8*JointDem +gamma9*Mally + gamma10*Mbitrade + gamma11*McivwarA;
			gen double xbhat_Acq_tgt_mid = gamma13*MconstantXA21;
			gen double xbhat_NChal_tgt_mid = gamma1*(US_SecHierA) + gamma2*(US_EconHierA) + gamma12;	
		/* generate xbhat for each action when target state is high */
		/**/
		gen double xbhat_Pun_tgt_high = beta1*rel_hier_tgt_high + beta2*0 + beta3*rus_ally_hierA + beta4*PowerRatio100A_US +
			beta5*PowerRatio100A_US2 + beta6*lndistance_US + beta7*Democ_Chal + beta8*ongoingMID_US + beta9*Prev_Chal + beta10;
			
			#delimit;
				/* generate predicted action and generate Chal stage variables */
				gen prT_H = normal(xbhat_Pun_tgt_high);
				
					gen HconstantXA21 = constantXA21*(1-prT_H);
					gen HPowerRatioA = PowerRatioA* prT_H;
					gen HPowerRatioA_2 = (PowerRatioA^2)*prT_H;
					gen HpowerchangeA = powerchange100*prT_H;
					gen HPrev_Chal = Prev_Chal*prT_H;
					gen HcivwarA = civwarA*prT_H;
					gen Hcontig = contig*prT_H;
					gen HJointDem = JointDem*prT_H;
					gen Hbitrade = bitrade_gdp*prT_H;
					gen Hally = ally*prT_H;

					
			#delimit;	
			gen double xbhat_War_tgt_high = gamma3*HPowerRatioA +gamma4*HPowerRatioA_2	+ gamma5*HpowerchangeA + gamma6*HPrev_Chal + gamma7*prT_H + gamma8*JointDem + gamma9*Hally + gamma10*Hbitrade + gamma11*HcivwarA;
			gen double xbhat_Acq_tgt_high = gamma13*HconstantXA21; 
			gen double xbhat_NChal_tgt_high = gamma1*(US_SecHierA) + gamma2*(US_EconHierA) + gamma12;
		
		/* Collapse xbhat by Security Hierarchy */
		#delimit;
		collapse (mean) xbhat_Pun_tgt_low xbhat_War_tgt_low xbhat_Acq_tgt_low xbhat_NChal_tgt_low 
			xbhat_Pun_tgt_mid xbhat_War_tgt_mid xbhat_Acq_tgt_mid xbhat_NChal_tgt_mid 
			xbhat_Pun_tgt_high xbhat_War_tgt_high xbhat_Acq_tgt_high xbhat_NChal_tgt_high
				, by(US_SecHierA);
		
		/* Outcome Probabilities */
		/* Target low */
		gen Pr_Pun_tgt_low = normal(xbhat_Pun_tgt_low);
		gen Pr_Chal_tgt_low = normal(xbhat_War_tgt_low+xbhat_Acq_tgt_low-xbhat_NChal_tgt_low);
		gen Pr_war_tgt_low = Pr_Pun_tgt_low*Pr_Chal_tgt_low;
		gen Pr_acq_tgt_low = (1-Pr_Pun_tgt_low)*Pr_Chal_tgt_low;
		
		gen Prop_war_of_chal_low = Pr_war_tgt_low / Pr_Chal_tgt_low;
		gen Prop_acq_of_chal_low = Pr_acq_tgt_low / Pr_Chal_tgt_low;
		
		/* Target middle */
		gen Pr_Pun_tgt_mid = normal(xbhat_Pun_tgt_mid);
		gen Pr_Chal_tgt_mid = normal(xbhat_War_tgt_mid+xbhat_Acq_tgt_mid-xbhat_NChal_tgt_mid);
		gen Pr_war_tgt_mid = Pr_Pun_tgt_low*Pr_Chal_tgt_mid;
		gen Pr_acq_tgt_mid = (1-Pr_Pun_tgt_low)*Pr_Chal_tgt_mid;
		
		gen Prop_war_of_chal_mid = Pr_war_tgt_mid / Pr_Chal_tgt_mid;
		gen Prop_acq_of_chal_mid = Pr_acq_tgt_mid / Pr_Chal_tgt_mid;
		
		/* Target high */
		gen Pr_Pun_tgt_high = normal(xbhat_Pun_tgt_high);
		gen Pr_Chal_tgt_high = normal(xbhat_War_tgt_high+xbhat_Acq_tgt_high-xbhat_NChal_tgt_high);
		gen Pr_war_tgt_high = Pr_Pun_tgt_high*Pr_Chal_tgt_high;
		gen Pr_acq_tgt_high = (1-Pr_Pun_tgt_high)*Pr_Chal_tgt_high;		
		
		gen Prop_war_of_chal_high = Pr_war_tgt_high / Pr_Chal_tgt_high;
		gen Prop_acq_of_chal_high = Pr_acq_tgt_high / Pr_Chal_tgt_high;
		
		
#delimit;
		/* Graph the results */
		/* Figure 3 */
		twoway lowess Pr_Chal_tgt_low US_SecHierA, sort lpattern(solid) ||
				lowess Pr_war_tgt_low US_SecHierA,  sort lpattern(longdash_dot) ||
				lowess Pr_acq_tgt_low US_SecHierA,  sort lpattern(shortdash_dot)
				scheme(s1mono) 
				t2("Target: Low in hierarchy" "(5th percentile of hierarchy)")
				ytitle("") xtitle("Challenger Hierarchy") xlabel(0.1 "Low" .45 "High", noticks) 
				legend(off);
					graph save Fitted_low_jpr, replace;
	
		twoway lowess Pr_Chal_tgt_mid US_SecHierA, sort lpattern(solid) ||
				lowess Pr_war_tgt_mid US_SecHierA,  sort lpattern(longdash_dot) ||
				lowess Pr_acq_tgt_mid US_SecHierA,  sort lpattern(shortdash_dot)
				scheme(s1mono) 
				t2("Target: Medium in hierarchy" "(Mean hierarchy)")
				ytitle("") xtitle("Challenger hierarchy") xlabel(0.1 "Low" .45 "High", noticks)
				legend(lab(1 "Challenge") lab(2 "Conflict") lab(3 "Acquiesce") rows(1) pos(6))
				legend(off);
					graph save Fitted_mid_jpr, replace;				

		twoway lowess Pr_Chal_tgt_high US_SecHierA, sort lpattern(solid) ||
				lowess Pr_war_tgt_high US_SecHierA,  sort lpattern(longdash_dot) ||
				lowess Pr_acq_tgt_high US_SecHierA,  sort lpattern(shortdash_dot)
				scheme(s1mono)
				t2("Target: High in hierarchy" "(95th percentile of hierarchy)")
				ytitle("") xtitle("Challenger hierarchy") xlabel(0.1 "Low" .45 "High", noticks)
				legend(off);
					graph save Fitted_high_jpr, replace;
		#delimit;
		grc1leg Fitted_low_jpr.gph Fitted_mid_jpr.gph Fitted_high_jpr.gph,
				scheme(s1mono) row(1) xcommon ycommon
				l1title("Probability")
				legendfrom(Fitted_mid_jpr.gph)
				note("Predicted probabilities for contiguous states with all other variables held at median.");
					graph save Fitted_all_jpr, replace ;
					graph export Fitted_all_jpr.eps, replace;
		
		/*Figure 4 */
		#delimit;
		twoway lowess Prop_war_of_chal_low US_SecHierA,  sort lpattern(longdash_dot)
				scheme(s1mono)
				t2("Target: Low in hierarchy " "(5th percentile of hierarchy)")
				ytitle("") xtitle("Challenger hierarchy") xlabel(0.1 "Low" .45 "High", noticks)
				legend(off);
					graph save Prop_war_low_jpr, replace;
		twoway lowess Prop_war_of_chal_mid US_SecHierA,  sort lpattern(longdash_dot)
				scheme(s1mono)
				t2("Target: Medium in hierarchy" "(Mean hierarchy)")
				ytitle("") xtitle("Challenger hierarchy") xlabel(0.1 "Low" .45 "High", noticks)
				legend(lab(1 "Punishments") rows(1) pos(6))
				legend(off);
					graph save Prop_war_mid_jpr, replace;
		twoway lowess Prop_war_of_chal_high US_SecHierA,  sort lpattern(longdash_dot)
				scheme(s1mono)
				t2("Target: High in hierarchy" "(95th percentile of hierarchy)")
				ytitle("") xtitle("Challenger hierarchy") xlabel(0.1 "Low" .45 "High", noticks)
				legend(off);
					graph save Prop_war_high_jpr, replace;
				#delimit
		grc1leg Prop_war_low_jpr.gph Prop_war_mid_jpr.gph Prop_war_high_jpr.gph,
				scheme(s1mono) row(1) xcommon ycommon
				l1title("Probability")
				/*b1title("Degree of Hierarchy")*/
				/*title("Predicted Outcomes at Varying Levels of Hierarchy")*/
				legendfrom(Prop_war_mid_jpr.gph)
				note("Predicted probabilities for contiguous states with all other variables held at median.");
					graph save Prop_war_all_jpr, replace ;
					graph export Prop_war_all_jpr.eps, replace;			
log close;
