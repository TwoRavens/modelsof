#delimit;
clear;
version 11;
set more off, perm;
  quietly log;
  local logon = r(status);
  if "`logon'" == "on" {; log close; };
log using fearon_laitin_rep.log, text replace;

/*******************************/
/*****  Mark David Nieman  *****/
/*****  11/3/2013          *****/
/*****  Empirical Replication*****/
/*****  Stata 12.1         *****/
/*******************************/
#delimit;
clear;
clear matrix;
clear mata;
set memory 4g;
program drop _all;

set seed 17;

	use Fearon_Laitin_2003.dta, replace;


		/* Program Strategic Probit with Partial Observability estimator */
		#delimit;
		program define sppo_lf, rclass;
			
			args lnf r_det r_war r_acq g_war; 						
			tempvar pun chal;
				quietly gen double `pun' = normal(`g_war'/sqrt(2));			
				quietly gen double `chal' = normal((`pun'*`r_war' + (1-`pun')*`r_acq'-`r_det')/(sqrt(`pun'^2+ (1-`pun')^2+1))); 
			quietly replace `lnf' = ln((1-`chal')+(`chal')*(1-`pun')) if $ML_y1==0; 						
			quietly replace `lnf' = ln((`chal')*(`pun')) if $ML_y1==1;
		end;
		
/* Exact replication of Fearon and Laitin 2003 */
#delimit;		
logit onset warl gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac;
gen sample=1 if e(sample)==1;
keep if sample==1;
/* Replicate Fearon and Laitin 2003 with probit */
#delimit;
probit onset warl gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac;
/*Correct Russia coding error of "4" for onset*/
recode onset (4=1);
/*rerun logit replication to show same with Russia recode */
#delimit;		
logit onset warl gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac;
/*rerun probit replication to show same with Russia recode */
#delimit;
probit onset warl gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac;
matrix P_cw = e(b);
matrix P_cw_se = e(V);
matrix ll_p = e(ll);

/* Model comparison */
/* Generate individual likelihoods for Clarke's nonparametric test (with correction for number of parameters)*/
		gen double lnfj_p = .;
			replace lnfj_p = ln(normal(-(_b[gdpenl]*gdpenl + _b[lpopl]*lpopl + _b[lmtnest]*lmtnest + _b[ncontig]*ncontig
				+ _b[Oil]*Oil + _b[nwstate]*nwstate + _b[instab]*instab + _b[polity2l]*polity2l + _b[ethfrac]*ethfrac + _b[relfrac]*relfrac + _b[_cons]))) if onset==0;
			replace lnfj_p = ln(normal((_b[gdpenl]*gdpenl + _b[lpopl]*lpopl + _b[lmtnest]*lmtnest + _b[ncontig]*ncontig
				+ _b[Oil]*Oil + _b[nwstate]*nwstate + _b[instab]*instab + _b[polity2l]*polity2l + _b[ethfrac]*ethfrac + _b[relfrac]*relfrac + _b[_cons]))) if onset==1;
			replace lnfj_p = lnfj_p*(12/(2*_N))*ln(_N);
		/* probability of war (probit) */
		gen double pr_War_p = normal(_b[gdpenl]*gdpenl + _b[lpopl]*lpopl + _b[lmtnest]*lmtnest + _b[ncontig]*ncontig
				+ _b[Oil]*Oil + _b[nwstate]*nwstate + _b[instab]*instab + _b[polity2l]*polity2l + _b[ethfrac]*ethfrac + _b[relfrac]*relfrac + _b[_cons]);
		gen p_predict_War = 0 if sample==1;
				replace p_predict_War =1 if pr_War_p > .5;
			/* observations correctly predicted */	
			gen correct_p = 0 if sample==1;
				replace correct_p = 1 if (p_predict_War==1 & onset==1) | (p_predict_War==0 & onset==0);
			/* observations correctly predicted as war */
			gen correct_war_p = .;
				replace correct_war_p = 0 if (p_predict_War==0 & onset==1);
				replace correct_war_p = 1 if (p_predict_War==1 & onset==1);
			/* observations incorrectly predicted as war*/
			gen incorrect_war_p =.;
				replace incorrect_war_p = 0 if (p_predict_War==0 & onset==0);
				replace incorrect_war_p = 1 if (p_predict_War==1 & onset==0);		
			/* results*/
			sum correct_p correct_war_p incorrect_war_p;
			



/* Strategic Probit with Partial Observability */
	/* run second stage model to find initial conditions (following Bas, Signorino, and Walker (2008)'s strategic backwards induction logic) */ 
	#delimit;
	probit onset  gdpenl Oil nwstate instab ncontig warl;
	matrix B2 = e(b);
	predict pr;
	gen prT = normal(pr);
	/* run first stage model to find initial conditions (following Bas, Signorino, and Walker (2008)'s strategic backwards induction logic) */
	gen Ngdpenl = -gdpenl;
	gen Npolity2l = -polity2l;
	gen Ncons_11 = -1;
	gen Ninstab = -instab;
	gen Tlpopl = prT*lpopl; 
	gen Tlmtnest = prT*lmtnest;
	gen TOil = prT*Oil;
	gen Tethfrac = prT*ethfrac;
	gen Trelfrac = prT*relfrac;
	gen Twarl = prT*warl;
	
	probit onset Ngdpenl Npolity2l Ninstab Ncons_11  Tlpopl Tlmtnest TOil Tethfrac Trelfrac Twarl, nocons;
	matrix B1 = e(b);
	
	/* Maximize the model */ 
	#delimit;
	ml model lf sppo_lf 
		(R_SQ:onset= gdpenl polity2l instab) 
		(R_War:onset=  lpopl lmtnest Oil ethfrac relfrac warl, nocons)
		(R_Acq: onset=)
		(G_War:onset=  gdpenl Oil nwstate instab ncontig warl) ;
	ml check;
	ml init B1 0 B2 , copy ;
	ml maximize,  diff;
	
	matrix beta_cw = e(b);
	matrix se_cw = e(V);
	matrix ll_sppo = e(ll);
	
	
	/* Model comparison */
	/* Generate individual likelihoods for Clarke's nonparametric test (with correction for number of parameters)*/
	gen double pun = normal( ([G_War]_b[gdpenl]*gdpenl + [G_War]_b[Oil]*Oil 
			+ [G_War]_b[nwstate]*nwstate + [G_War]_b[instab]*instab + [G_War]_b[ncontig]*ncontig 
			+ [G_War]_b[warl]*warl + [G_War]_b[_cons]*1) / sqrt(2) );
		gen double chal = normal( 
			( pun*([R_War]_b[lpopl]*lpopl + [R_War]_b[lmtnest]*lmtnest + [R_War]_b[Oil]*Oil 
					+ [R_War]_b[ethfrac]*ethfrac + [R_War]_b[relfrac]*relfrac + [R_War]_b[warl]*warl)
			+ (1-pun)*([R_Acq]_b[_cons])
			- ([R_SQ]_b[gdpenl]*gdpenl + [R_SQ]_b[polity2l]*polity2l + [R_SQ]_b[instab]*instab + [R_SQ]_b[_cons]) ) 
			/(sqrt(pun^2+ (1-pun)^2+1) )); 
		gen double lnfj_sppo = .;
			replace  lnfj_sppo = ln((1-chal)+(chal)*(1-pun)) if onset==0;
			replace  lnfj_sppo = ln((chal)*(pun)) if onset==1;
			#delimit;
			replace lnfj_sppo = lnfj_sppo*(18/(2*_N))*ln(_N);
		#delimit;
		/* probability of war (sppo) */
		gen double pr_War_sppo = pun*chal;
		gen double pr_Acq_sppo = chal*(1-pun);
		gen double pr_Det_sppo = 1-chal;
			gen sppo_predict_War = 0 if sample==1;
				replace sppo_predict_War =1 if (pr_War_sppo > pr_Acq_sppo) & (pr_War_sppo > pr_Det_sppo);
			/* observations correctly predicted */
			gen correct_sppo = 0 if sample==1;
				replace correct_sppo = 1 if (sppo_predict_War==1 & onset==1) | (sppo_predict_War==0 & onset==0);
			/* observations correctly predicted as war*/
			gen correct_war_sppo = .;
				replace correct_war_sppo = 0 if (sppo_predict_War==0 & onset==1);
				replace correct_war_sppo = 1 if (sppo_predict_War==1 & onset==1);
			/* observations incorrectly predicted as war*/
			gen incorrect_war_sppo =.;
				replace incorrect_war_sppo = 0 if (sppo_predict_War==0 & onset==0);
				replace incorrect_war_sppo = 1 if (sppo_predict_War==1 & onset==0);				
			/* results*/
			sum correct_sppo correct_war_sppo incorrect_war_sppo;
			
				
	/* Clarke Test */
	signtest lnfj_p=lnfj_sppo;
	/* Voung Test*/
	svmat ll_p;
	svmat ll_sppo;
	gen num_V = ll_p1 - ll_sppo1 + ((12/2)*ln(_N)-(18/2)*ln(_N));
	egen denom1_V = mean((lnfj_p/lnfj_sppo)^2);
	gen denom2_V = sqrt(denom1_V);
	gen Voung = num_V/denom2_V;
	sum num_V denom2_V Voung;

/* Generate predicted probabilities */
collapse (mean) polity2l  lmtnest lpopl ethfrac relfrac
	(median) ncontig nwstate  warl
	(max)  Oil     instab
	(min) gdpenl_p5 = gdpenl (p92) gdpenl_p95= gdpenl;
	
	expand 100;
	gen gdpenl = gdpenl_p5 + (gdpenl_p95 - gdpenl_p5)*(_n-1)/_N;
	expand 100;	
	
#delimit;

/* SPPO xbhat */
drawnorm R_SQ_B1 R_SQ_B2 SQ_B3 R_SQ_B0 
		 R_War_B1 R_War_B2 R_War_B3 R_War_B4 R_War_B5 R_War_B6 
		 R_Acq_B0
		 G_War_B1 G_War_B2 G_War_B3 G_War_B4 G_War_B5 G_War_B6 G_War_B0,
	means(beta_cw) cov(se_cw);
	
gen double xbhat_R_SQ = R_SQ_B1*gdpenl + R_SQ_B2*polity2l + SQ_B3*instab + R_SQ_B0;
gen double xbhat_R_War = R_War_B1*lpopl + R_War_B2*lmtnest + R_War_B3*Oil + R_War_B4*ethfrac + R_War_B5*relfrac 
							+ R_War_B6*warl;
gen double xbhat_R_Acq = R_Acq_B0;
gen double xbhat_G_War = G_War_B1*gdpenl + G_War_B2*Oil + G_War_B3*nwstate + G_War_B4*instab 
							+ G_War_B5*ncontig + G_War_B6*warl + G_War_B0;

/* Probit xbhat */
drawnorm B1 B2 B3 B4 B5 B6 B7 B8 B9 B10 B11 B0, means(P_cw) cov(P_cw_se);
gen double xbhat_probit = B1*warl + B2*gdpenl + B3*lpopl + B4*lmtnest + B5*ncontig + B6*Oil + B7*nwstate + B8*instab 
						+ B9*polity2l + B10*ethfrac + B11*relfrac + B0;

/* collapse and compare SPPO and probit predicted probabilities*/							
collapse xbhat_R_SQ	xbhat_R_War	xbhat_R_Acq	xbhat_G_War xbhat_probit, by(gdpenl);				
							
gen double pr_pun = normal(xbhat_G_War/sqrt(2));
gen double pr_chal = normal((pr_pun*xbhat_R_War+(1-pr_pun)*xbhat_R_Acq-xbhat_R_SQ)/sqrt(pr_pun^2+ (1-pr_pun)^2+1));
	
gen double pr_War = pr_pun*pr_chal;
gen double pr_Acq = pr_chal*(1-pr_pun);
gen double pr_Det = 1-pr_chal;

gen prop_War = pr_War / pr_chal;
gen prop_Acq = pr_Acq / pr_chal;

gen pr_War_probit = normal(xbhat_probit);

		/* Graph the results */
		#delimit;
		twoway lowess pr_War_probit gdpenl, sort lpattern(solid) ||
				lowess pr_chal gdpenl, sort lpattern(dash) lwidth(medthick) lcolor(gs0) ||
				lowess pr_War gdpenl,  sort lpattern(longdash_dot) lwidth(medthick) ||
				lowess pr_Acq gdpenl,  sort lpattern(shortdash) lwidth(medthick)
				scheme(s1mono) 
				title("Probabilities for All Outcomes")
				ytitle("Pr(Outcome)")
				xtitle("GDP per Capita (in thousands)") 
				legend(lab(1 "War (Probit)") lab(2 "Challenge (SPPO)") lab(3 "War (SPPO)") lab(4 "Gov. Acquiesce (SPPO)"))
				note("Note: Predicted probabilities are for oil exporting and experienced recent political instability." 
				     "All other variables held at mean or median. ''SPPO'' indicates Strategic Probit with Partial"
					 "Observability.");
					 graph save F&L_War, asis replace;
					 graph export F&L_War.eps, replace;

		
