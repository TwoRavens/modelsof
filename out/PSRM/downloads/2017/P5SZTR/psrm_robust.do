#delimit;
clear;
set more off, perm;
  quietly log;
  local logon = r(status);
  if "`logon'" == "on" {; 
log close; 
};
log using PSRM_Robust, text replace;
/*******************************/
/*  Mark David Nieman & Cameron G Thies */
/*  9/15/2017       */
/*  PRights Regimes, Tech Innovation, and FDI  */
/*  Hierarchical Model, 1970-2010   */
/*  Robustness   */
/*  Stata 14.1/MP    */
/*******************************/

/*  Note: Replication requires ado file -grinter- to plot figures R25 and R27 */
/*     available at http://myweb.uiowa.edu/fboehmke/stata */

clear;
clear matrix;
program drop _all;
set emptycells drop ;
set seed 200;
tempfile temp temp_efw;

use psrm_prr_robust, clear;

xtset ccode year;

/* Set up data */
gen ln_battle =  battlerela;
	replace ln_battle = 0 if ln_battle==. ;
	replace ln_battle = ln(ln_battle+.01);
gen log_battle =  battlerela;
	replace log_battle = 0 if log_battle==. ;
	replace log_battle = log(log_battle+.01);
gen ln_durable = ln(durable+.01);
gen lnbit_count = ln(bit_count+.01);
gen fdi_cen =  FDI_net_inflows;
	replace fdi_cen = 0 if FDI_net_inflows<0;
	replace fdi_cen = ln(fdi_cen+0.01);
/* Report percent of FDI set at zero or negative net FDI values to $10,000, reported in "Censoring net FDI prior to Logging" section of appendix  */
sum FDI_net_inflows;
sum FDI_net_inflows if FDI_net_inflows<0;
	di 429/5538;
	
	/* Center variables */
	foreach var of varlist efw2legalrights xconst GDPgrowth ln_GDP2005US ln_resource 
							ruralpopul  ln_pop ln_battle ln_durable TradePctGDP 
							lnbit_count ln_World_FDI  lji kaopen ln_GDP_pc2005USD 
							polity2 ln_pec
							{;
		quietly sum `var';
		gen c`var' = `var'-r(mean);
	};
	gen cPRdemoc = cefw2legalrights*cxconst;
	gen cPRpolity = cefw2legalrights*cpolity2;
	gen clji_democ = clji*cxconst;
save `temp', replace;


/* Robustness: Specification*/

/* Replicate main analysis with LJI data*/

	/* Table M1 Model 1 */
	/* Fixed model */
	use `temp', clear;
	xtmixed ln_FDI_net_inflows clji_democ clji cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle
		|| _all: R.ccode || _all: R.year, mle;
		egen id_lji = group(ccode) if e(sample)==1;
		matrix B = e(b);
		matrix C = e(V);
		matrix k_t_lji = e(k);
		matrix L_t_lji = e(ll);
		svmat k_t_lji;
		svmat L_t_lji;
		gen AIC_t_lji = 2*k_t_lji1 - 2*L_t_lji1;
		sum AIC_t_lji;	
		
		/* Correlation between the two property rights measures, reported in footnote in independent variables subsection */
		corr cefw2legalrights clji if e(sample)==1;
			
			/* Figure M1 */
			/* Collapse to show the marginal effect of changing Democ from their Min to their Max */
			collapse (mean) cxconst;
			expand 7;
			replace cxconst = _n-4;
			
			/* Take 1000 draws from actual values */
			expand 1000;
			drawnorm bxz bx bz b01 b02 b03 b04 b05 b06 b07 b00 b10 b20 resid , means(B) cov(C);
				
			/* Generate the marginal effects variable and change over the full range of Property Rights */
			gen gamma = bx + cxconst*(bxz);
			collapse (mean) gamma (sd) sd_gamma = gamma, by(cxconst);

			/* Generate 95% confidence intervals */
			gen gamma_lo = gamma - 1.645*sd_gamma ;
			gen gamma_hi = gamma + 1.645*sd_gamma;
			replace cxconst = cxconst + 4;	
			/* Create a kdensity plot */
			mkmat cxconst-gamma_hi , matrix(collapsed) ;
			use `temp', clear;
			keep cxconst;
			replace cxconst = cxconst + 4;
			rename cxconst kdensity_xconst;
			svmat collapsed, names(col);
	
				/* Graph marginal effects */
				twoway lowess gamma cxconst, scheme(s1mono) lcolor(black) lwidth(medthick)
				|| lowess gamma_lo cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| lowess gamma_hi cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| kdensity kdensity_xconst, n(7) yaxis(2) lpattern(shortdash_dot) lcolor(gs8) lwidth(thin) 
				yline(0, lpattern(dot) lcolor(gs8))  xtitle("Level of Democracy")
				legend(off) 
				note("Note: Dashed lines give 90% confidence interval. Light dashed-dot line displays the Kernal density" "estimate. Displayed value is from model 1 of Table M1.")
				ytitle("Kernal Density Estimate of Democracy", axis(2))
				ytitle("Marginal Effect of Property Rights on FDI")
				title("Figure M1. Marginal Effects of Property Rights on FDI.")
				t2("(LJI, all years)");
					graph save Figure_M1, replace;

	/* Table M1 Model 2 */
	/* Time-varying model */
		use `temp', clear; 
		xtmixed ln_FDI_net_inflows c.clji_democ#year c.clji#year cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle
		|| _all: R.ccode || _all: R.year , mle ;
		gen time_lji= 1 if e(sample)==1;
		egen id_lji = group(ccode) if e(sample)==1;	
		save `temp', replace;
		matrix k_id_lji = e(k);
		matrix L_id_lji = e(ll);
		svmat k_id_lji;
		svmat L_id_lji;
		gen AIC_id_lji = 2*k_id_lji1 - 2*L_id_lji1;
		sum AIC_id_lji;			
			predict REccode_yr REyear_yr, reffects level(_all);

		/* Figure M2 */	
		/* Generate marginal effects of PR*/
		gen MEslope_1970 = (_b[1970b.year#clji_democ])*cxconst + _b[1970b.year#clji] + REyear_yr if year==1970;
		gen MEslope_t=0;

		forvalues year=1971(1)2009  {;	
		replace MEslope_t = (_b[`year'.year#clji_democ])*cxconst + _b[`year'.year#clji] + REyear_yr if year==`year';
		};
		replace MEslope_t=MEslope_1970 if year==1970;
			
		/* Plot slope over time */
		collapse MEslope_t, by(xconst year time_lji);
		#delimit;
			twoway connected MEslope_t year if year<2010 & xconst==1 & time_lji==1, connect(L) scheme(s1mono) lpattern(solid) msymbol(circle) mcolor(gs14) lcolor(gs14)
			|| connected MEslope_t year if year<2010 & xconst==2 & time_lji==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs12) lcolor(gs12)
			|| connected MEslope_t year if year<2010 & xconst==3 & time_lji==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs10) lcolor(gs10)
			|| connected MEslope_t year if year<2010 & xconst==4 & time_lji==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs8) lcolor(gs8)
			|| connected MEslope_t year if year<2010 & xconst==5 & time_lji==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs6) lcolor(gs6)
			|| connected MEslope_t year if year<2010 & xconst==6 & time_lji==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs4) lcolor(gs4)
			|| connected MEslope_t year if year<2010 & xconst==7 & time_lji==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs2) lcolor(gs2)
				xtitle("Year") legend(off) yline(0, lpattern(dot) lcolor(gs8))
				ytitle("Marginal Effect of Property Rights on FDI")
				title("Figure M2. Time-varying Marginal Effect of Property" "Rights on FDI at Different Levels of Democracy.")
				t2("(LJI, all years)")
				note("Note: Displayed value is the marginal effect of Property Rights when interacted with Democracy from" 
				"model 2 of Table M1. Darker lines indicate greater levels of Democracy.");
					graph save Figure_M2, replace;


/* Sample: Non-OECD */					
	
	/* Table R1 Model 1 */				
	/* Fixed model */
	use `temp', clear;
	xtmixed ln_FDI_net_inflows cPRdemoc cefw2legalrights cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle
		|| _all: R.ccode || _all: R.year if OECD==0, mle;
		
		matrix B = e(b);
		matrix C = e(V);
		matrix k = e(k);
		matrix L = e(ll);
		svmat k;
		svmat L;
		gen AIC = 2*k1 - 2*L1;
		sum AIC;
		
			/* Figure R1 */
			/* Collapse to show the impact of changing Democ from their Min to their Max */
			collapse (mean) cxconst;
			expand 7;
			replace cxconst = _n-4;
			
			/* Take 1000 draws from actual values */
			expand 1000;
			drawnorm bxz bx bz b01 b02 b03 b04 b05 b06 b07 b00 b10 b20 resid , means(B) cov(C);
				
			/* Generate the marginal effects variable and change over the full range of Property Rights */
			gen gamma = bx + cxconst*(bxz);
			collapse (mean) gamma (sd) sd_gamma = gamma, by(cxconst);

			/* Generate 95% confidence intervals */
			gen gamma_lo = gamma - 1.645*sd_gamma ;
			gen gamma_hi = gamma + 1.645*sd_gamma;
			replace cxconst = cxconst + 4;	
			/* create a kdensity plot */
			mkmat cxconst-gamma_hi , matrix(collapsed) ;
			use `temp', clear;
			keep cxconst;
			replace cxconst = cxconst + 4;
			rename cxconst kdensity_xconst;
			svmat collapsed, names(col);
	
				/* Graph marginal effects */
				twoway lowess gamma cxconst, scheme(s1mono) lcolor(black) lwidth(medthick)
				|| lowess gamma_lo cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| lowess gamma_hi cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| kdensity kdensity_xconst, n(7) yaxis(2) lpattern(shortdash_dot) lcolor(gs8) lwidth(thin) 
				yline(0, lpattern(dot) lcolor(gs8))  xtitle("Level of Democracy")
				legend(off)
				ytitle("Kernal Density Estimate of Democracy", axis(2))
				ytitle("Marginal Effect of Property Rights on FDI")
				title("Figure R1. Marginal Effects of Property Rights on FDI." "(Non-OECD)")
				note("Note: Dashed lines give 90% confidence interval. Light dashed-dot line displays the Kernal density" "estimate.")
				;
					graph save Figure_R1, replace;
	
	/* Table R1 Model 2 */
	/* Time-varying model */
		use `temp', clear;
		xtmixed ln_FDI_net_inflows c.cPRdemoc#year c.cefw2legalrights#year cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle
		|| _all: R.ccode || _all: R.year if OECD==0, mle ;
		gen time= 1 if e(sample)==1;
		egen id = group(ccode) if e(sample)==1;	
		matrix k_t = e(k);
		matrix L_t = e(ll);
		svmat k_t;
		svmat L_t;
		gen AIC_t = 2*k_t1 - 2*L_t1;
		sum AIC_t;
			predict REccode_yr REyear_yr, reffects level(_all);

		/* Figure R2 */	
		/* Generate marginal effects of PR*/
		gen MEslope_1970 = (_b[1970b.year#cPRdemoc])*cxconst + _b[1970b.year#cefw2legalrights] + REyear_yr if year==1970;
		gen MEslope_t=0;
		#delimit;
			forvalues year=1975(5)2000  {;
			
			replace MEslope_t = (_b[`year'.year#cPRdemoc])*cxconst + _b[`year'.year#cefw2legalrights] + REyear_yr if year==`year';
			};		
			forvalues year=2001/2009  {;		
			replace MEslope_t = (_b[`year'.year#cPRdemoc])*cxconst + _b[`year'.year#cefw2legalrights] + REyear_yr if year==`year';
			};
			replace MEslope_t=MEslope_1970 if year==1970;
					
			/* Plot slope over time */
			collapse MEslope_t, by(xconst year time);
				twoway connected MEslope_t year if year<2010 & xconst==1 & time==1, connect(L) scheme(s1mono) lpattern(solid) msymbol(circle) mcolor(gs14) lcolor(gs14)
				|| connected MEslope_t year if year<2010 & xconst==2 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs12) lcolor(gs12)
				|| connected MEslope_t year if year<2010 & xconst==3 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs10) lcolor(gs10)
				|| connected MEslope_t year if year<2010 & xconst==4 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs8) lcolor(gs8)
				|| connected MEslope_t year if year<2010 & xconst==5 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs6) lcolor(gs6)
				|| connected MEslope_t year if year<2010 & xconst==6 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs4) lcolor(gs4)
				|| connected MEslope_t year if year<2010 & xconst==7 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs2) lcolor(gs2) 
					xtitle("Year") legend(off) yline(0, lpattern(dot) lcolor(gs8))
					ytitle("Marginal Effect of Property Rights on FDI")
					title("Figure R2. Time-varying Marginal Effect of Property" "Rights at Different Levels of Democracy on FDI." "(Non-OECD)")
					note("Note: Displayed value is the marginal effect of Property Rights when interacted with Democracy. Darker" 
					"lines indicate greater levels of Democracy.");
						graph save Figure_R2, replace;
										
	/* Table R1 Model 3 */
	/* lji*/
	/* Fixed model */
	use `temp', clear;
	xtmixed ln_FDI_net_inflows clji_democ clji cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle
		|| _all: R.ccode || _all: R.year if OECD==0, mle;
		
		matrix B = e(b);
		matrix C = e(V);
		matrix k = e(k);
		matrix L = e(ll);
		svmat k;
		svmat L;
		gen AIC = 2*k1 - 2*L1;
		sum AIC;
		
			/* Figure R3 */
			/* Collapse to show the impact of changing Democ from their Min to their Max */
			collapse (mean) cxconst;
			expand 7;
			replace cxconst = _n-4;
					
			/* Take 1000 draws from actual values */
			expand 1000;
			drawnorm bxz bx bz b01 b02 b03 b04 b05 b06 b07 b00 b10 b20 resid , means(B) cov(C);
				
			/* Generate the marginal effects variable and change over the full range of Property Rights */
			gen gamma = bx + cxconst*(bxz);
			collapse (mean) gamma (sd) sd_gamma = gamma, by(cxconst);

			/* Generate 95% confidence intervals */
			gen gamma_lo = gamma - 1.645*sd_gamma ;
			gen gamma_hi = gamma + 1.645*sd_gamma;
			replace cxconst = cxconst + 4;	
			/* create a kdensity plot */
			mkmat cxconst-gamma_hi , matrix(collapsed) ;
			use `temp', clear;
			keep cxconst;
			replace cxconst = cxconst + 4;
			rename cxconst kdensity_xconst;
			svmat collapsed, names(col);
	
				/* Graph marginal effects */
				twoway lowess gamma cxconst, scheme(s1mono) lcolor(black) lwidth(medthick)
				|| lowess gamma_lo cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| lowess gamma_hi cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| kdensity kdensity_xconst, n(7) yaxis(2) lpattern(shortdash_dot) lcolor(gs8) lwidth(thin) 
				yline(0, lpattern(dot) lcolor(gs8))  xtitle("Level of Democracy")
				legend(off)
				ytitle("Kernal Density Estimate of Democracy", axis(2))
				ytitle("Marginal Effect of Property Rights on FDI")
				title("Figure R3. Marginal Effects of Property Rights on FDI." "(LJI: Non-OECD)")
				note("Note: Dashed lines give 90% confidence interval. Light dashed-dot line displays the Kernal density" "estimate.")
				;
					graph save Figure_R3, replace;
	
	/* Table R1 Model 4 */
	/* Time-varying model */
		use `temp', clear;
		xtmixed ln_FDI_net_inflows c.clji_democ#year c.clji#year cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle
		|| _all: R.ccode || _all: R.year if OECD==0, mle tech(bfgs);
		gen time= 1 if e(sample)==1;
		egen id = group(ccode) if e(sample)==1;	
		matrix k_t = e(k);
		matrix L_t = e(ll);
		svmat k_t;
		svmat L_t;
		gen AIC_t = 2*k_t1 - 2*L_t1;
		sum AIC_t;
			predict REccode_yr REyear_yr, reffects level(_all);

		/* Figure R4 */	
		/* Generate marginal effects of PR*/
		gen MEslope_1970 = (_b[1970b.year#clji_democ])*cxconst + _b[1970b.year#clji] + REyear_yr if year==1970;
		gen MEslope_t=0;
		
			forvalues year=1971(1)2009  {;			
			replace MEslope_t = (_b[`year'.year#clji_democ])*cxconst + _b[`year'.year#clji] + REyear_yr if year==`year';
			};
			replace MEslope_t=MEslope_1970 if year==1970;
			
			/* Plot slope over time */
			collapse MEslope_t, by(xconst year time);
			#delimit;
				twoway connected MEslope_t year if year<2010 & xconst==1 & time==1, connect(L) scheme(s1mono) lpattern(solid) msymbol(circle) mcolor(gs14) lcolor(gs14)
				|| connected MEslope_t year if year<2010 & xconst==2 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs12) lcolor(gs12)
				|| connected MEslope_t year if year<2010 & xconst==3 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs10) lcolor(gs10)
				|| connected MEslope_t year if year<2010 & xconst==4 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs8) lcolor(gs8)
				|| connected MEslope_t year if year<2010 & xconst==5 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs6) lcolor(gs6)
				|| connected MEslope_t year if year<2010 & xconst==6 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs4) lcolor(gs4)
				|| connected MEslope_t year if year<2010 & xconst==7 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs2) lcolor(gs2) 
					xtitle("Year") legend(off) yline(0, lpattern(dot) lcolor(gs8))
					ytitle("Marginal Effect of Property Rights on FDI")
					title("Figure R4. Time-varying Marginal Effect of Property" "Rights at Different Levels of Democracy on FDI." "(LJI: Non-OECD)")
					note("Note: Displayed value is the marginal effect of Property Rights when interacted with Democracy. Darker" 
					"lines indicate greater levels of Democracy.");
						graph save Figure_R4, replace;					
					
/* Sample: All Countries with BITs */
	
	/* Table R2 Model 1 */
	/* Fixed model */
	use `temp', clear;
	xtmixed ln_FDI_net_inflows cPRdemoc cefw2legalrights cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle lnbit_count
		|| _all: R.ccode || _all: R.year, mle;
		
		matrix B = e(b);
		matrix C = e(V);
		matrix k = e(k);
		matrix L = e(ll);
		svmat k;
		svmat L;
		gen AIC = 2*k1 - 2*L1;
		sum AIC;
		
			/* Figure R5 */
			/* Collapse to show the impact of changing Democ from their Min to their Max */
			collapse (mean) cxconst;
			expand 7;
			replace cxconst = _n-4;
			
			/* Take 1000 draws from actual values */
			expand 1000;
			drawnorm bxz bx bz b01 b02 b03 b04 b05 b06 b07 b08 b00 b10 b20 resid , means(B) cov(C);
				
			/* Generate the marginal effects variable and change over the full range of Property Rights */
			gen gamma = bx + cxconst*(bxz);
			collapse (mean) gamma (sd) sd_gamma = gamma, by(cxconst);

			/* Generate 95% confidence intervals */
			gen gamma_lo = gamma - 1.645*sd_gamma ;
			gen gamma_hi = gamma + 1.645*sd_gamma;
			replace cxconst = cxconst + 4;	
			/* create a kdensity plot */
			mkmat cxconst-gamma_hi , matrix(collapsed) ;
			use `temp', clear;
			keep cxconst;
			replace cxconst = cxconst + 4;
			rename cxconst kdensity_xconst;
			svmat collapsed, names(col);

				/* Graph marginal effects */
				twoway lowess gamma cxconst, scheme(s1mono) lcolor(black) lwidth(medthick)
				|| lowess gamma_lo cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| lowess gamma_hi cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| kdensity kdensity_xconst, n(7) yaxis(2) lpattern(shortdash_dot) lcolor(gs8) lwidth(thin) 
				yline(0, lpattern(dot) lcolor(gs8))  xtitle("Level of Democracy")
				legend(off)
				ytitle("Kernal Density Estimate of Democracy", axis(2))
				ytitle("Marginal Effect of Property Rights on FDI")
				title("Figure R5. Marginal Effects of Property Rights on FDI." "(BITs, all countries)")
				note("Note: Dashed lines give 90% confidence interval. Light dashed-dot line displays the Kernal density" "estimate.")
				;
					graph save Figure_R5, replace;
	
	/* Table R2 Model 2 */
	/* Time-varying model */
		use `temp', clear;
		xtmixed ln_FDI_net_inflows c.cPRdemoc#year c.cefw2legalrights#year cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle lnbit_count
		|| _all: R.ccode || _all: R.year , mle ;
		gen time= 1 if e(sample)==1;
		egen id = group(ccode) if e(sample)==1;	
		matrix k_t = e(k);
		matrix L_t = e(ll);
		svmat k_t;
		svmat L_t;
		gen AIC_t = 2*k_t1 - 2*L_t1;
		sum AIC_t;
			predict REccode_yr REyear_yr, reffects level(_all);

		/* Generate marginal effects of PR*/
		gen MEslope_1970 = (_b[1970b.year#cPRdemoc])*cxconst + _b[1970b.year#cefw2legalrights] + REyear_yr if year==1970;
		gen MEslope_t=0;
	
		forvalues year=1975(5)2000  {;	
		replace MEslope_t = (_b[`year'.year#cPRdemoc])*cxconst + _b[`year'.year#cefw2legalrights] + REyear_yr if year==`year';
		};
		
	/* Figure R6 */	
	/* Plot slope over time */
		collapse MEslope_t, by(xconst year time);
			twoway connected MEslope_t year if year<2010 & xconst==1 & time==1, connect(L) scheme(s1mono) lpattern(solid) msymbol(circle) mcolor(gs14) lcolor(gs14)
			|| connected MEslope_t year if year<2010 & xconst==2 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs12) lcolor(gs12)
			|| connected MEslope_t year if year<2010 & xconst==3 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs10) lcolor(gs10)
			|| connected MEslope_t year if year<2010 & xconst==4 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs8) lcolor(gs8)
			|| connected MEslope_t year if year<2010 & xconst==5 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs6) lcolor(gs6)
			|| connected MEslope_t year if year<2010 & xconst==6 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs4) lcolor(gs4)
			|| connected MEslope_t year if year<2010 & xconst==7 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs2) lcolor(gs2) 
				xtitle("Year") legend(off) yline(0, lpattern(dot) lcolor(gs8))
				ytitle("Marginal Effect of Property Rights on FDI")
				title("Figure R6. Time-varying Marginal Effect of Property" "Rights at Different Levels of Democracy on FDI." "(BITs, all countries)")
				note("Note: Displayed value is the marginal effect of Property Rights when interacted with Democracy. Darker" 
				"lines indicate greater levels of Democracy.");
					graph save Figure_R6, replace;
					
	/* Table R2 Model 3 */				
	/* lji*/
	/* Fixed model */
	use `temp', clear;
	xtmixed ln_FDI_net_inflows clji_democ clji cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle lnbit_count
		|| _all: R.ccode || _all: R.year, mle;
		
		matrix B = e(b);
		matrix C = e(V);
		matrix k = e(k);
		matrix L = e(ll);
		svmat k;
		svmat L;
		gen AIC = 2*k1 - 2*L1;
		sum AIC;

			/* Figure R7 */		
			/* Collapse to show the impact of changing Democ from their Min to their Max */
			collapse (mean) cxconst;
			expand 7;
			replace cxconst = _n-4;

			/* Take 1000 draws from actual values */
			expand 1000;
			drawnorm bxz bx bz b01 b02 b03 b04 b05 b06 b07 b08 b00 b10 b20 resid , means(B) cov(C);
				
			/* Generate the marginal effects variable and change over the full range of Property Rights */
			gen gamma = bx + cxconst*(bxz);
			collapse (mean) gamma (sd) sd_gamma = gamma, by(cxconst);

			/* Generate 95% confidence intervals */
			gen gamma_lo = gamma - 1.645*sd_gamma ;
			gen gamma_hi = gamma + 1.645*sd_gamma;
			replace cxconst = cxconst + 4;	
			/* create a kdensity plot */
			mkmat cxconst-gamma_hi , matrix(collapsed) ;
			use `temp', clear;
			keep cxconst;
			replace cxconst = cxconst + 4;
			rename cxconst kdensity_xconst;
			svmat collapsed, names(col);
			
				/* Graph marginal effects */
				twoway lowess gamma cxconst, scheme(s1mono) lcolor(black) lwidth(medthick)
				|| lowess gamma_lo cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| lowess gamma_hi cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| kdensity kdensity_xconst, n(7) yaxis(2) lpattern(shortdash_dot) lcolor(gs8) lwidth(thin) 
				yline(0, lpattern(dot) lcolor(gs8))  xtitle("Level of Democracy")
				legend(off)
				ytitle("Kernal Density Estimate of Democracy", axis(2))
				ytitle("Marginal Effect of Property Rights on FDI")
				title("Figure R7. Marginal Effects of Property Rights on FDI." "(LJI: BITs, all countries)")
				note("Note: Dashed lines give 90% confidence interval. Light dashed-dot line displays the Kernal density" "estimate.")
				;
					graph save Figure_R7, replace;
	
	/* Table R2 Model 4 */
	/* Time-varying model */
		use `temp', clear;
		xtmixed ln_FDI_net_inflows c.clji_democ#year c.clji#year cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle lnbit_count
		|| _all: R.ccode || _all: R.year , mle ;
		gen time= 1 if e(sample)==1;
		egen id = group(ccode) if e(sample)==1;	
		matrix k_t = e(k);
		matrix L_t = e(ll);
		svmat k_t;
		svmat L_t;
		gen AIC_t = 2*k_t1 - 2*L_t1;
		sum AIC_t;
			predict REccode_yr REyear_yr, reffects level(_all);

		/* Figure R8 */		
		/* Generate marginal effects of PR*/
		gen MEslope_1970 = (_b[1970b.year#clji_democ])*cxconst + _b[1970b.year#clji] + REyear_yr if year==1970;
		gen MEslope_t=0;
	
		forvalues year=1971(1)2000  {;		
		replace MEslope_t = (_b[`year'.year#clji_democ])*cxconst + _b[`year'.year#clji] + REyear_yr if year==`year';
		};
				
		/* Plot slope over time */
		collapse MEslope_t, by(xconst year time);
			twoway connected MEslope_t year if year<2010 & xconst==1 & time==1, connect(L) scheme(s1mono) lpattern(solid) msymbol(circle) mcolor(gs14) lcolor(gs14)
			|| connected MEslope_t year if year<2010 & xconst==2 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs12) lcolor(gs12)
			|| connected MEslope_t year if year<2010 & xconst==3 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs10) lcolor(gs10)
			|| connected MEslope_t year if year<2010 & xconst==4 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs8) lcolor(gs8)
			|| connected MEslope_t year if year<2010 & xconst==5 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs6) lcolor(gs6)
			|| connected MEslope_t year if year<2010 & xconst==6 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs4) lcolor(gs4)
			|| connected MEslope_t year if year<2010 & xconst==7 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs2) lcolor(gs2) 
				xtitle("Year") legend(off) yline(0, lpattern(dot) lcolor(gs8))
				ytitle("Marginal Effect of Property Rights on FDI")
				title("Figure R8. Time-varying Marginal Effect of Property" "Rights at Different Levels of Democracy on FDI." "(LJI: BITs, all countries)")
				note("Note: Displayed value is the marginal effect of Property Rights when interacted with Democracy. Darker" 
				"lines indicate greater levels of Democracy.");
					graph save Figure_R8, replace;			
					
/* Sample: Non-OECD with BITs */

	/* Table R3 Model 1 */
	/* Fixed model */ 
	use `temp', clear;
	xtmixed ln_FDI_net_inflows cPRdemoc cefw2legalrights cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle lnbit_count
		|| _all: R.ccode || _all: R.year if OECD==0, mle;
		
		matrix B = e(b);
		matrix C = e(V);
		matrix k = e(k);
		matrix L = e(ll);
		svmat k;
		svmat L;
		gen AIC = 2*k1 - 2*L1;
		sum AIC;
		
			/* Figure R9 */
			/* Collapse to show the impact of changing Democ from their Min to their Max */
			collapse (mean) cxconst;
			expand 7;
			replace cxconst = _n-4;
			
			/* Take 1000 draws from actual values */
			expand 1000;
			drawnorm bxz bx bz b01 b02 b03 b04 b05 b06 b07 b08 b00 b10 b20 resid , means(B) cov(C);
				
			/* Generate the marginal effects variable and change over the full range of Property Rights */
			gen gamma = bx + cxconst*(bxz);
			collapse (mean) gamma (sd) sd_gamma = gamma, by(cxconst);

			/* Generate 95% confidence intervals */
			gen gamma_lo = gamma - 1.645*sd_gamma ;
			gen gamma_hi = gamma + 1.645*sd_gamma;
			replace cxconst = cxconst + 4;	
			/* create a kdensity plot */
			mkmat cxconst-gamma_hi , matrix(collapsed) ;
			use `temp', clear;
			keep cxconst;
			replace cxconst = cxconst + 4;
			rename cxconst kdensity_xconst;
			svmat collapsed, names(col);
			
				/* Graph marginal effects */
				twoway lowess gamma cxconst, scheme(s1mono) lcolor(black) lwidth(medthick)
				|| lowess gamma_lo cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| lowess gamma_hi cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| kdensity kdensity_xconst, n(7) yaxis(2) lpattern(shortdash_dot) lcolor(gs8) lwidth(thin) 
				yline(0, lpattern(dot) lcolor(gs8))  xtitle("Level of Democracy")
				legend(off)
				ytitle("Kernal Density Estimate of Democracy", axis(2))
				ytitle("Marginal Effect of Property Rights on FDI")
				title("Figure R9. Marginal Effects of Property Rights on FDI." "(BITs, Non-OECD)")
				note("Note: Dashed lines give 90% confidence interval. Light dashed-dot line displays the Kernal density" "estimate.")
				;
					graph save Figure_R9, replace;
	
	/* Table R3 Model 2 */
	/* Time-varying model */ 
		use `temp', clear;
		xtmixed ln_FDI_net_inflows c.cPRdemoc#year c.cefw2legalrights#year cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle lnbit_count
		|| _all: R.ccode || _all: R.year if OECD==0, mle ;
		gen time= 1 if e(sample)==1;
		egen id = group(ccode) if e(sample)==1;	
		matrix k_t = e(k);
		matrix L_t = e(ll);
		svmat k_t;
		svmat L_t;
		gen AIC_t = 2*k_t1 - 2*L_t1;
		sum AIC_t;
			predict REccode_yr REyear_yr, reffects level(_all);

		/* Figure R10 */	
		/* Generate marginal effects of PR*/
		gen MEslope_1970 = (_b[1970b.year#cPRdemoc])*cxconst + _b[1970b.year#cefw2legalrights] + REyear_yr if year==1970;
		gen MEslope_t=0;
	
		forvalues year=1975(5)2000  {;	
		replace MEslope_t = (_b[`year'.year#cPRdemoc])*cxconst + _b[`year'.year#cefw2legalrights] + REyear_yr if year==`year';
		};
				
		/* Plot slope over time */
		collapse MEslope_t, by(xconst year time);
			twoway connected MEslope_t year if year<2010 & xconst==1 & time==1, connect(L) scheme(s1mono) lpattern(solid) msymbol(circle) mcolor(gs14) lcolor(gs14)
			|| connected MEslope_t year if year<2010 & xconst==2 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs12) lcolor(gs12)
			|| connected MEslope_t year if year<2010 & xconst==3 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs10) lcolor(gs10)
			|| connected MEslope_t year if year<2010 & xconst==4 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs8) lcolor(gs8)
			|| connected MEslope_t year if year<2010 & xconst==5 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs6) lcolor(gs6)
			|| connected MEslope_t year if year<2010 & xconst==6 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs4) lcolor(gs4)
			|| connected MEslope_t year if year<2010 & xconst==7 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs2) lcolor(gs2) 
				xtitle("Year") legend(off) yline(0, lpattern(dot) lcolor(gs8))
				ytitle("Marginal Effect of Property Rights on FDI")
				title("Figure R10. Time-varying Marginal Effect of Property" "Rights at Different Levels of Democracy on FDI." "(BITs, Non-OECD)")
				note("Note: Displayed value is the marginal effect of Property Rights when interacted with Democracy. Darker" 
				"lines indicate greater levels of Democracy.");
					graph save Figure_R10, replace;
	
	/* Table R3 Model 3 */ 
	/* lji*/
	/* Fixed model */
	use `temp', clear;
	xtmixed ln_FDI_net_inflows clji_democ clji cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle lnbit_count
		|| _all: R.ccode || _all: R.year if OECD==0, mle;
		
		matrix B = e(b);
		matrix C = e(V);
		matrix k = e(k);
		matrix L = e(ll);
		svmat k;
		svmat L;
		gen AIC = 2*k1 - 2*L1;
		sum AIC;
		
			/* Figure R11 */
			/* Collapse to show the impact of changing Democ from their Min to their Max */
			collapse (mean) cxconst;
			expand 7;
			replace cxconst = _n-4;
			
			/* Take 1000 draws from actual values */
			expand 1000;
			drawnorm bxz bx bz b01 b02 b03 b04 b05 b06 b07 b08 b00 b10 b20 resid , means(B) cov(C);
				
			/* Generate the marginal effects variable and change over the full range of Property Rights */
			gen gamma = bx + cxconst*(bxz);
			collapse (mean) gamma (sd) sd_gamma = gamma, by(cxconst);

			/* Generate 95% confidence intervals */
			gen gamma_lo = gamma - 1.645*sd_gamma ;
			gen gamma_hi = gamma + 1.645*sd_gamma;
			replace cxconst = cxconst + 4;	
			/* create a kdensity plot */
			mkmat cxconst-gamma_hi , matrix(collapsed) ;
			use `temp', clear;
			keep cxconst;
			replace cxconst = cxconst + 4;
			rename cxconst kdensity_xconst;
			svmat collapsed, names(col);
		
				/* Graph marginal effects */
				twoway lowess gamma cxconst, scheme(s1mono) lcolor(black) lwidth(medthick)
				|| lowess gamma_lo cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| lowess gamma_hi cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| kdensity kdensity_xconst, n(7) yaxis(2) lpattern(shortdash_dot) lcolor(gs8) lwidth(thin) 
				yline(0, lpattern(dot) lcolor(gs8))  xtitle("Level of Democracy")
				legend(off)
				ytitle("Kernal Density Estimate of Democracy", axis(2))
				ytitle("Marginal Effect of Property Rights on FDI")
				title("Figure R11. Marginal Effects of Property Rights on FDI." "(LJI: BITs, Non-OECD)")
				note("Note: Dashed lines give 90% confidence interval. Light dashed-dot line displays the Kernal density" "estimate.")
				;
					graph save Figure_R11, replace;
	
	/* Table R3 Model 4 */
	/* Time-varying model */ 
		use `temp', clear;
		xtmixed ln_FDI_net_inflows c.clji_democ#year c.clji#year cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle lnbit_count
		|| _all: R.ccode || _all: R.year if OECD==0, mle ;
		gen time= 1 if e(sample)==1;
		egen id = group(ccode) if e(sample)==1;	
		matrix k_t = e(k);
		matrix L_t = e(ll);
		svmat k_t;
		svmat L_t;
		gen AIC_t = 2*k_t1 - 2*L_t1;
		sum AIC_t;
			predict REccode_yr REyear_yr, reffects level(_all);

		/* Figure R12 */	
		/* generate marginal effects of PR*/
		gen MEslope_1970 = (_b[1970b.year#clji_democ])*cxconst + _b[1970b.year#clji] + REyear_yr if year==1970;
		gen MEslope_t=0;
	
		forvalues year=1971(1)2000  {;
		replace MEslope_t = (_b[`year'.year#clji_democ])*cxconst + _b[`year'.year#clji] + REyear_yr if year==`year';
		};
			
		/* Plot slope over time */
		collapse MEslope_t, by(xconst year time);
			twoway connected MEslope_t year if year<2010 & xconst==1 & time==1, connect(L) scheme(s1mono) lpattern(solid) msymbol(circle) mcolor(gs14) lcolor(gs14)
			|| connected MEslope_t year if year<2010 & xconst==2 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs12) lcolor(gs12)
			|| connected MEslope_t year if year<2010 & xconst==3 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs10) lcolor(gs10)
			|| connected MEslope_t year if year<2010 & xconst==4 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs8) lcolor(gs8)
			|| connected MEslope_t year if year<2010 & xconst==5 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs6) lcolor(gs6)
			|| connected MEslope_t year if year<2010 & xconst==6 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs4) lcolor(gs4)
			|| connected MEslope_t year if year<2010 & xconst==7 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs2) lcolor(gs2) 
				xtitle("Year") legend(off) yline(0, lpattern(dot) lcolor(gs8))
				ytitle("Marginal Effect of Property Rights on FDI")
				title("Figure R12. Time-varying Marginal Effect of Property" "Rights at Different Levels of Democracy on FDI." "(LJI: BITs, Non-OECD)")
				note("Note: Displayed value is the marginal effect of Property Rights when interacted with Democracy. Darker" 
				"lines indicate greater levels of Democracy.");
					graph save Figure_R12, replace;					
			
/* Sample: Net FDI/GDP */

	/* Table R4 Model 1 */
	/* Fixed model */ 
	use `temp', clear;
	xtmixed FDIinflowsPctGDP cPRdemoc cefw2legalrights cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle
		|| _all: R.ccode || _all: R.year, mle;
		
		matrix B = e(b);
		matrix C = e(V);
		matrix k = e(k);
		matrix L = e(ll);
		svmat k;
		svmat L;
		gen AIC = 2*k1 - 2*L1;
		sum AIC;
		
			/* Figure R13 */
			/* Collapse to show the impact of changing Democ from their Min to their Max */
			collapse (mean) cxconst;
			expand 7;
			replace cxconst = _n-4;
			
			/* Take 1000 draws from actual values */
			expand 1000;
			drawnorm bxz bx bz b01 b02 b03 b04 b05 b06 b07 b00 b10 b20 resid , means(B) cov(C);
				
			/* Generate the marginal effects variable and change over the full range of Property Rights */
			gen gamma = bx + cxconst*(bxz);
			collapse (mean) gamma (sd) sd_gamma = gamma, by(cxconst);

			/* Generate 95% confidence intervals */
			gen gamma_lo = gamma - 1.645*sd_gamma ;
			gen gamma_hi = gamma + 1.645*sd_gamma;
			replace cxconst = cxconst + 4;	
			/* create a kdensity plot */
			mkmat cxconst-gamma_hi , matrix(collapsed) ;
			use `temp', clear;
			keep cxconst;
			replace cxconst = cxconst + 4;
			rename cxconst kdensity_xconst;
			svmat collapsed, names(col);
			
				/* Graph marginal effects */
				twoway lowess gamma cxconst, scheme(s1mono) lcolor(black) lwidth(medthick)
				|| lowess gamma_lo cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| lowess gamma_hi cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| kdensity kdensity_xconst, n(7) yaxis(2) lpattern(shortdash_dot) lcolor(gs8) lwidth(thin) 
				yline(0, lpattern(dot) lcolor(gs8))  xtitle("Level of Democracy")
				legend(off)
				ytitle("Kernal Density Estimate of Democracy", axis(2))
				ytitle("Marginal Effect of Property Rights on FDI")
				title("Figure R13. Marginal Effects of Property Rights on FDI." "(Net FDI as Percent GDP)")
				note("Note: Dashed lines give 90% confidence interval. Light dashed-dot line displays the Kernal density" "estimate.")
				;
					graph save Figure_R13, replace;
	
	/* Table R4 Model 2 */
	/* Time-varying model */ 
		use `temp', clear;
		xtmixed FDIinflowsPctGDP c.cPRdemoc#year c.cefw2legalrights#year cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle
		|| _all: R.ccode || _all: R.year, mle ;
		gen time= 1 if e(sample)==1;
		egen id = group(ccode) if e(sample)==1;	
		matrix k_t = e(k);
		matrix L_t = e(ll);
		svmat k_t;
		svmat L_t;
		gen AIC_t = 2*k_t1 - 2*L_t1;
		sum AIC_t;
			predict REccode_yr REyear_yr, reffects level(_all);

		/* Figure R14 */ 	
		/* generate marginal effects of PR*/
		gen MEslope_1970 = (_b[1970b.year#cPRdemoc])*cxconst + _b[1970b.year#cefw2legalrights] + REyear_yr if year==1970;
		gen MEslope_t=0;
	
		forvalues year=1975(5)2000  {;
		replace MEslope_t = (_b[`year'.year#cPRdemoc])*cxconst + _b[`year'.year#cefw2legalrights] + REyear_yr if year==`year';
		};	
		forvalues year=2001/2009  {;
		replace MEslope_t = (_b[`year'.year#cPRdemoc])*cxconst + _b[`year'.year#cefw2legalrights] + REyear_yr if year==`year';
		};
		replace MEslope_t=MEslope_1970 if year==1970;
				
		/* Plot slope over time */
		collapse MEslope_t, by(xconst year time);
			twoway connected MEslope_t year if year<2010 & xconst==1 & time==1, connect(L) scheme(s1mono) lpattern(solid) msymbol(circle) mcolor(gs14) lcolor(gs14)
			|| connected MEslope_t year if year<2010 & xconst==2 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs12) lcolor(gs12)
			|| connected MEslope_t year if year<2010 & xconst==3 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs10) lcolor(gs10)
			|| connected MEslope_t year if year<2010 & xconst==4 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs8) lcolor(gs8)
			|| connected MEslope_t year if year<2010 & xconst==5 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs6) lcolor(gs6)
			|| connected MEslope_t year if year<2010 & xconst==6 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs4) lcolor(gs4)
			|| connected MEslope_t year if year<2010 & xconst==7 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs2) lcolor(gs2) 
				xtitle("Year") legend(off) yline(0, lpattern(dot) lcolor(gs8))
				ytitle("Marginal Effect of Property Rights on FDI")
				title("Figure R14. Time-varying Marginal Effect of Property" "Rights at Different Levels of Democracy on FDI." "(Net FDI as Percent GDP)")
				note("Note: Displayed value is the marginal effect of Property Rights when interacted with Democracy. Darker" 
				"lines indicate greater levels of Democracy.");
					graph save Figure_R14, replace;
		
	/* Table R4 Model 3 */	
	/* lji */
	/* Fixed model */ 
	use `temp', clear;
	xtmixed FDIinflowsPctGDP clji_democ clji cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle
		|| _all: R.ccode || _all: R.year, mle;
		
		matrix B = e(b);
		matrix C = e(V);
		matrix k = e(k);
		matrix L = e(ll);
		svmat k;
		svmat L;
		gen AIC = 2*k1 - 2*L1;
		sum AIC;
		
			/* Figure R15 */
			/* Collapse to show the impact of changing Democ from their Min to their Max */
			collapse (mean) cxconst;
			expand 7;
			replace cxconst = _n-4;
			
			/* Take 1000 draws from actual values */
			expand 1000;
			drawnorm bxz bx bz b01 b02 b03 b04 b05 b06 b07 b00 b10 b20 resid , means(B) cov(C);
				
			/* Generate the marginal effects variable and change over the full range of Property Rights */
			gen gamma = bx + cxconst*(bxz);
			collapse (mean) gamma (sd) sd_gamma = gamma, by(cxconst);

			/* Generate 95% confidence intervals */
			gen gamma_lo = gamma - 1.645*sd_gamma ;
			gen gamma_hi = gamma + 1.645*sd_gamma;
			replace cxconst = cxconst + 4;	
			/* create a kdensity plot */
			mkmat cxconst-gamma_hi , matrix(collapsed) ;
			use `temp', clear;
			keep cxconst;
			replace cxconst = cxconst + 4;
			rename cxconst kdensity_xconst;
			svmat collapsed, names(col);
			
				/* Graph marginal effects */
				twoway lowess gamma cxconst, scheme(s1mono) lcolor(black) lwidth(medthick)
				|| lowess gamma_lo cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| lowess gamma_hi cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| kdensity kdensity_xconst, n(7) yaxis(2) lpattern(shortdash_dot) lcolor(gs8) lwidth(thin) 
				yline(0, lpattern(dot) lcolor(gs8))  xtitle("Level of Democracy")
				legend(off)
				ytitle("Kernal Density Estimate of Democracy", axis(2))
				ytitle("Marginal Effect of Property Rights on FDI")
				title("Figure R15. Marginal Effects of Property Rights on FDI." "(LJI: Net FDI as Percent GDP)")
				note("Note: Dashed lines give 90% confidence interval. Light dashed-dot line displays the Kernal density" "estimate.")
				;
					graph save Figure_R15, replace;
	
	/* Table R4 Model 4 */
	/* Time-varying model */ 
		use `temp', clear;
		xtmixed FDIinflowsPctGDP c.clji_democ#year c.clji#year cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle
		|| _all: R.ccode || _all: R.year, mle ;
		gen time= 1 if e(sample)==1;
		egen id = group(ccode) if e(sample)==1;	
		matrix k_t = e(k);
		matrix L_t = e(ll);
		svmat k_t;
		svmat L_t;
		gen AIC_t = 2*k_t1 - 2*L_t1;
		sum AIC_t;
			predict REccode_yr REyear_yr, reffects level(_all);

		/* Figure R16 */	
		/* generate marginal effects of PR*/
		gen MEslope_1970 = (_b[1970b.year#clji_democ])*cxconst + _b[1970b.year#clji] + REyear_yr if year==1970;
		gen MEslope_t=0;
	
		forvalues year=1971(1)2009  {;		
		replace MEslope_t = (_b[`year'.year#clji_democ])*cxconst + _b[`year'.year#clji] + REyear_yr if year==`year';
		};		
		replace MEslope_t=MEslope_1970 if year==1970;
			
		/* Plot slope over time */
		collapse MEslope_t, by(xconst year time);
			twoway connected MEslope_t year if year<2010 & xconst==1 & time==1, connect(L) scheme(s1mono) lpattern(solid) msymbol(circle) mcolor(gs14) lcolor(gs14)
			|| connected MEslope_t year if year<2010 & xconst==2 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs12) lcolor(gs12)
			|| connected MEslope_t year if year<2010 & xconst==3 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs10) lcolor(gs10)
			|| connected MEslope_t year if year<2010 & xconst==4 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs8) lcolor(gs8)
			|| connected MEslope_t year if year<2010 & xconst==5 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs6) lcolor(gs6)
			|| connected MEslope_t year if year<2010 & xconst==6 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs4) lcolor(gs4)
			|| connected MEslope_t year if year<2010 & xconst==7 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs2) lcolor(gs2) 
				xtitle("Year") legend(off) yline(0, lpattern(dot) lcolor(gs8))
				ytitle("Marginal Effect of Property Rights on FDI")
				title("Figure R16. Time-varying Marginal Effect of Property" "Rights at Different Levels of Democracy on FDI." "(LJI: Net FDI as Percent GDP)")
				note("Note: Displayed value is the marginal effect of Property Rights when interacted with Democracy. Darker" 
				"lines indicate greater levels of Democracy.");
					graph save Figure_R16, replace;	
					
/* Sample: Net FDI censored at zero */
	
	/* Table R5 Model 1 */
	/* Fixed model */
	use `temp', clear;
	xtmixed fdi_cen cPRdemoc cefw2legalrights cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle
		|| _all: R.ccode || _all: R.year, mle;
		
		matrix B = e(b);
		matrix C = e(V);
		matrix k = e(k);
		matrix L = e(ll);
		svmat k;
		svmat L;
		gen AIC = 2*k1 - 2*L1;
		sum AIC;
		
			/* Figure R17 */
			/* Collapse to show the impact of changing Democ from their Min to their Max */
			collapse (mean) cxconst;
			expand 7;
			replace cxconst = _n-4;
			
			/* Take 1000 draws from actual values */
			expand 1000;
			drawnorm bxz bx bz b01 b02 b03 b04 b05 b06 b07 b00 b10 b20 resid , means(B) cov(C);
				
			/* Generate the marginal effects variable and change over the full range of Property Rights */
			gen gamma = bx + cxconst*(bxz);
			collapse (mean) gamma (sd) sd_gamma = gamma, by(cxconst);

			/* Generate 95% confidence intervals */
			gen gamma_lo = gamma - 1.645*sd_gamma ;
			gen gamma_hi = gamma + 1.645*sd_gamma;
			replace cxconst = cxconst + 4;	
			/* Create a kdensity plot */
			mkmat cxconst-gamma_hi , matrix(collapsed) ;
			use `temp', clear;
			keep cxconst;
			replace cxconst = cxconst + 4;
			rename cxconst kdensity_xconst;
			svmat collapsed, names(col);
	
				/* Graph marginal effects */
				twoway lowess gamma cxconst, scheme(s1mono) lcolor(black) lwidth(medthick)
				|| lowess gamma_lo cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| lowess gamma_hi cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| kdensity kdensity_xconst, n(7) yaxis(2) lpattern(shortdash_dot) lcolor(gs8) lwidth(thin) 
				yline(0, lpattern(dot) lcolor(gs8))  xtitle("Level of Democracy")
				legend(off)
				ytitle("Kernal Density Estimate of Democracy", axis(2))
				ytitle("Marginal Effect of Property Rights on FDI")
				title("Figure R17. Marginal Effects of Property Rights on FDI." "(Log of censored net FDI)")
				note("Note: Dashed lines give 90% confidence interval. Light dashed-dot line displays the Kernal density" "estimate.")
				;
					graph save Figure_R17, replace;
	
	/* Table R5 Model 2 */
	/* Time-varying model */
		use `temp', clear;
		xtmixed fdi_cen c.cPRdemoc#year c.cefw2legalrights#year cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle
		|| _all: R.ccode || _all: R.year, mle ;
		gen time= 1 if e(sample)==1;
		egen id = group(ccode) if e(sample)==1;	
		matrix k_t = e(k);
		matrix L_t = e(ll);
		svmat k_t;
		svmat L_t;
		gen AIC_t = 2*k_t1 - 2*L_t1;
		sum AIC_t;
			predict REccode_yr REyear_yr, reffects level(_all);

		/* Figure R18 */	
		/* Generate marginal effects of PR*/
		gen MEslope_1970 = (_b[1970b.year#cPRdemoc])*cxconst + _b[1970b.year#cefw2legalrights] + REyear_yr if year==1970;
		gen MEslope_t=0;

			forvalues year=1975(5)2000  {;		
			replace MEslope_t = (_b[`year'.year#cPRdemoc])*cxconst + _b[`year'.year#cefw2legalrights] + REyear_yr if year==`year';
			};		
			forvalues year=2001/2009  {;		
			replace MEslope_t = (_b[`year'.year#cPRdemoc])*cxconst + _b[`year'.year#cefw2legalrights] + REyear_yr if year==`year';
			};
			replace MEslope_t=MEslope_1970 if year==1970;
				
			/* Plot slope over time */
			collapse MEslope_t, by(xconst year time);
			#delimit;
				twoway connected MEslope_t year if year<2010 & xconst==1 & time==1, connect(L) scheme(s1mono) lpattern(solid) msymbol(circle) mcolor(gs14) lcolor(gs14)
				|| connected MEslope_t year if year<2010 & xconst==2 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs12) lcolor(gs12)
				|| connected MEslope_t year if year<2010 & xconst==3 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs10) lcolor(gs10)
				|| connected MEslope_t year if year<2010 & xconst==4 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs8) lcolor(gs8)
				|| connected MEslope_t year if year<2010 & xconst==5 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs6) lcolor(gs6)
				|| connected MEslope_t year if year<2010 & xconst==6 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs4) lcolor(gs4)
				|| connected MEslope_t year if year<2010 & xconst==7 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs2) lcolor(gs2) 
					xtitle("Year") legend(off) yline(0, lpattern(dot) lcolor(gs8))
					ytitle("Marginal Effect of Property Rights on FDI")
					title("Figure R18. Time-varying Marginal Effect of Property" "Rights at Different Levels of Democracy on FDI." "(Log of censored net FDI)")
					note("Note: Displayed value is the marginal effect of Property Rights when interacted with Democracy. Darker" 
					"lines indicate greater levels of Democracy.");
						graph save Figure_R18, replace;
					
	/* Table R5 Model 3 */				
	/* lji */
	/* Fixed model */
	use `temp', clear;
	xtmixed fdi_cen clji_democ clji cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle
		|| _all: R.ccode || _all: R.year, mle;
		
		matrix B = e(b);
		matrix C = e(V);
		matrix k = e(k);
		matrix L = e(ll);
		svmat k;
		svmat L;
		gen AIC = 2*k1 - 2*L1;
		sum AIC;
		
			/* Figure 19 */
			/* Collapse to show the impact of changing Democ from their Min to their Max */
			collapse (mean) cxconst;
			expand 7;
			replace cxconst = _n-4;
			
			/* Take 1000 draws from actual values */
			expand 1000;
			drawnorm bxz bx bz b01 b02 b03 b04 b05 b06 b07 b00 b10 b20 resid , means(B) cov(C);
				
			/* Generate the marginal effects variable and change over the full range of Property Rights */
			gen gamma = bx + cxconst*(bxz);
			collapse (mean) gamma (sd) sd_gamma = gamma, by(cxconst);

			/* Generate 95% confidence intervals */
			gen gamma_lo = gamma - 1.645*sd_gamma ;
			gen gamma_hi = gamma + 1.645*sd_gamma;
			replace cxconst = cxconst + 4;	
			/* create a kdensity plot */
			mkmat cxconst-gamma_hi , matrix(collapsed) ;
			use `temp', clear;
			keep cxconst;
			replace cxconst = cxconst + 4;
			rename cxconst kdensity_xconst;
			svmat collapsed, names(col);
			
				/* Graph marginal effects */
				twoway lowess gamma cxconst, scheme(s1mono) lcolor(black) lwidth(medthick)
				|| lowess gamma_lo cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| lowess gamma_hi cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| kdensity kdensity_xconst, n(7) yaxis(2) lpattern(shortdash_dot) lcolor(gs8) lwidth(thin) 
				yline(0, lpattern(dot) lcolor(gs8))  xtitle("Level of Democracy")
				legend(off)
				ytitle("Kernal Density Estimate of Democracy", axis(2))
				ytitle("Marginal Effect of Property Rights on FDI")
				title("Figure R19. Marginal Effects of Property Rights on FDI." "(LJI: Log of censored net FDI)")
				note("Note: Dashed lines give 90% confidence interval. Light dashed-dot line displays the Kernal density" "estimate.")
				;
					graph save Figure_R19, replace;
					
	/* Table R5 Model 4 */				
	/* Time-varying model */
		use `temp', clear;
		xtmixed fdi_cen c.clji_democ#year c.clji#year cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle
		|| _all: R.ccode || _all: R.year, mle ;
		gen time= 1 if e(sample)==1;
		egen id = group(ccode) if e(sample)==1;	
		matrix k_t = e(k);
		matrix L_t = e(ll);
		svmat k_t;
		svmat L_t;
		gen AIC_t = 2*k_t1 - 2*L_t1;
		sum AIC_t;
			predict REccode_yr REyear_yr, reffects level(_all);

		/* Figure R20 */	
		/* generate marginal effects of PR*/
		gen MEslope_1970 = (_b[1970b.year#clji_democ])*cxconst + _b[1970b.year#clji] + REyear_yr if year==1970;
		gen MEslope_t=0;
		
			forvalues year=1971(1)2009  {;			
			replace MEslope_t = (_b[`year'.year#clji_democ])*cxconst + _b[`year'.year#clji] + REyear_yr if year==`year';
			};		
			replace MEslope_t=MEslope_1970 if year==1970;
					
			/* Plot slope over time */
			collapse MEslope_t, by(xconst year time);
				twoway connected MEslope_t year if year<2010 & xconst==1 & time==1, connect(L) scheme(s1mono) lpattern(solid) msymbol(circle) mcolor(gs14) lcolor(gs14)
				|| connected MEslope_t year if year<2010 & xconst==2 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs12) lcolor(gs12)
				|| connected MEslope_t year if year<2010 & xconst==3 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs10) lcolor(gs10)
				|| connected MEslope_t year if year<2010 & xconst==4 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs8) lcolor(gs8)
				|| connected MEslope_t year if year<2010 & xconst==5 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs6) lcolor(gs6)
				|| connected MEslope_t year if year<2010 & xconst==6 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs4) lcolor(gs4)
				|| connected MEslope_t year if year<2010 & xconst==7 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs2) lcolor(gs2) 
					xtitle("Year") legend(off) yline(0, lpattern(dot) lcolor(gs8))
					ytitle("Marginal Effect of Property Rights on FDI")
					title("Figure R20. Time-varying Marginal Effect of Property" "Rights at Different Levels of Democracy on FDI." "(LJI: Log of censored net FDI)")
					note("Note: Displayed value is the marginal effect of Property Rights when interacted with Democracy. Darker" 
					"lines indicate greater levels of Democracy.");
						graph save Figure_R20, replace;						
					
/* Sample: using polity2 as alternative democracy measure */
	
	/* Table R6 Model 1 */
	/* Fixed model */
	use `temp', clear;	
	xtmixed ln_FDI_net_inflows cPRpolity cefw2legalrights polity2 cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle
		|| _all: R.ccode || _all: R.year, mle;
		
		matrix B = e(b);
		matrix C = e(V);
		matrix k = e(k);
		matrix L = e(ll);
		svmat k;
		svmat L;
		gen AIC = 2*k1 - 2*L1;
		sum AIC;
		
			/* Figure R21 */
			/* Collapse to show the impact of changing Democ from their Min to their Max */
			collapse (mean) polity2;
			expand 21;
			replace polity2 = _n-11;			
		
			/* Take 1000 draws from actual values */
			expand 1000;
			drawnorm bxz bx bz b01 b02 b03 b04 b05 b06 b07 b00 b10 b20 resid , means(B) cov(C);
				
			/* Generate the marginal effects variable and change over the full range of Property Rights */
			gen gamma = bx + polity2*(bxz);
			collapse (mean) gamma (sd) sd_gamma = gamma, by(polity2);

			/* Generate 95% confidence intervals */
			gen gamma_lo = gamma - 1.645*sd_gamma ;
			gen gamma_hi = gamma + 1.645*sd_gamma;;	
			/* create a kdensity plot */
			mkmat polity2-gamma_hi , matrix(collapsed) ;
			use `temp', clear;
			keep polity2;
			rename polity2 kdensity_polity2;
			svmat collapsed, names(col);
			
				/* Graph marginal effects */
				twoway lowess gamma polity2, scheme(s1mono) lcolor(black) lwidth(medthick)
				|| lowess gamma_lo polity2, lcolor(gray) lwidth(medium) lpattern(dash)
				|| lowess gamma_hi polity2, lcolor(gray) lwidth(medium) lpattern(dash)
				|| kdensity kdensity_polity2, n(21) yaxis(2) lpattern(shortdash_dot) lcolor(gs8) lwidth(thin) 
				yline(0, lpattern(dot) lcolor(gs8))  xtitle("Level of Democracy")
				legend(off)
				ytitle("Kernal Density Estimate of Democracy", axis(2))
				ytitle("Marginal Effect of Property Rights on FDI")
				title("Figure R21. Marginal Effects of Property Rights on FDI." "(21-pt Democracy Scale)")
				note("Note: Dashed lines give 90% confidence interval. Light dashed-dot line displays the Kernal density" "estimate.")
				;
					graph save Figure_R21, replace;
	
	/* Table R6 Model 2 */
	/* Time-varying model */
		use `temp', clear;
		xtmixed ln_FDI_net_inflows c.cPRpolity#year c.cefw2legalrights#year polity2 cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle
		|| _all: R.ccode || _all: R.year, mle ;
		gen time= 1 if e(sample)==1;
		matrix k_t = e(k);
		matrix L_t = e(ll);
		svmat k_t;
		svmat L_t;
		gen AIC_t = 2*k_t1 - 2*L_t1;
		sum AIC_t;
			predict REccode_yr REyear_yr, reffects level(_all);

		/* Figure R22 */	
		/* generate marginal effects of PR*/
		gen MEslope_1970 = (_b[1970b.year#cPRpolity])*polity2 + _b[1970b.year#cefw2legalrights] + REyear_yr if year==1970;
		gen MEslope_t=0;
		
			forvalues year=1975(5)2000  {;			
			replace MEslope_t = (_b[`year'.year#cPRpolity])*polity2 + _b[`year'.year#cefw2legalrights] + REyear_yr if year==`year';
			};		
			forvalues year=2001/2009  {;		
			replace MEslope_t = (_b[`year'.year#cPRpolity])*polity2 + _b[`year'.year#cefw2legalrights] + REyear_yr if year==`year';
			};
			replace MEslope_t=MEslope_1970 if year==1970;
	
			/* Plot slope over time */
			collapse MEslope_t, by(polity2 year time);
			#delimit;
				twoway connected MEslope_t year if year<2010 & polity2==(-10) & time==1, connect(L) scheme(s1mono) lpattern(solid) msymbol(circle) mcolor(gs14) lcolor(gs14)
				|| connected MEslope_t year if year<2010 & polity2==(-9) & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs13) lcolor(gs13)
				|| connected MEslope_t year if year<2010 & polity2==(-8) & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs13) lcolor(gs13)
				|| connected MEslope_t year if year<2010 & polity2==(-7) & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs12) lcolor(gs12)
				|| connected MEslope_t year if year<2010 & polity2==(-6) & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs12) lcolor(gs12)
				|| connected MEslope_t year if year<2010 & polity2==(-5) & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs11) lcolor(gs11)
				|| connected MEslope_t year if year<2010 & polity2==(-4) & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs10) lcolor(gs10)
				|| connected MEslope_t year if year<2010 & polity2==(-3) & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs9) lcolor(gs9)
				|| connected MEslope_t year if year<2010 & polity2==(-2) & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs9) lcolor(gs9)
				|| connected MEslope_t year if year<2010 & polity2==(-1) & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs8) lcolor(gs8)
				|| connected MEslope_t year if year<2010 & polity2==0 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs7) lcolor(gs7)
				|| connected MEslope_t year if year<2010 & polity2==1 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs7) lcolor(gs7)
				|| connected MEslope_t year if year<2010 & polity2==2 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs6) lcolor(gs6)
				|| connected MEslope_t year if year<2010 & polity2==3 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs5) lcolor(gs5)
				|| connected MEslope_t year if year<2010 & polity2==4 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs5) lcolor(gs5)
				|| connected MEslope_t year if year<2010 & polity2==5 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs4) lcolor(gs4)
				|| connected MEslope_t year if year<2010 & polity2==6 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs3) lcolor(gs3)
				|| connected MEslope_t year if year<2010 & polity2==7 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs2) lcolor(gs2)
				|| connected MEslope_t year if year<2010 & polity2==8 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs2) lcolor(gs2)
				|| connected MEslope_t year if year<2010 & polity2==9 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs1) lcolor(gs1)
				|| connected MEslope_t year if year<2010 & polity2==10 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs0) lcolor(gs0)			
					xtitle("Year") legend(off) yline(0, lpattern(dot) lcolor(gs8))
					ytitle("Marginal Effect of Property Rights on FDI")
					title("Figure R22. Time-varying Marginal Effect of Property" "Rights at Different Levels of Democracy on FDI." "(21-pt Democracy Scale)")
					note("Note: Displayed value is the marginal effect of Property Rights when interacted with Democracy. Darker" 
					"lines indicate greater levels of Democracy.");
						graph save Figure_R22, replace;
					
	/* Table R6 Model 3 */				
	/* lji */
	/* Fixed model */
	use `temp', clear;	
	xtmixed ln_FDI_net_inflows clji_democ clji polity2 cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle
		|| _all: R.ccode || _all: R.year, mle;
		
		matrix B = e(b);
		matrix C = e(V);
		matrix k = e(k);
		matrix L = e(ll);
		svmat k;
		svmat L;
		gen AIC = 2*k1 - 2*L1;
		sum AIC;
		
			/* Figure R23 */
			/* Collapse to show the impact of changing Democ from their Min to their Max */
			collapse (mean) polity2;
			expand 21;
			replace polity2 = _n-11;
				
			/* Take 1000 draws from actual values */
			expand 1000;
			drawnorm bxz bx bz b01 b02 b03 b04 b05 b06 b07 b00 b10 b20 resid , means(B) cov(C);
				
			/* Generate the marginal effects variable and change over the full range of Property Rights */
			gen gamma = bx + polity2*(bxz);
			collapse (mean) gamma (sd) sd_gamma = gamma, by(polity2);

			/* Generate 95% confidence intervals */
			gen gamma_lo = gamma - 1.645*sd_gamma ;
			gen gamma_hi = gamma + 1.645*sd_gamma;;	
			/* create a kdensity plot */
			mkmat polity2-gamma_hi , matrix(collapsed) ;
			use `temp', clear;
			keep polity2;
			rename polity2 kdensity_polity2;
			svmat collapsed, names(col);
			
				/* Graph marginal effects */
				twoway lowess gamma polity2, scheme(s1mono) lcolor(black) lwidth(medthick)
				|| lowess gamma_lo polity2, lcolor(gray) lwidth(medium) lpattern(dash)
				|| lowess gamma_hi polity2, lcolor(gray) lwidth(medium) lpattern(dash)
				|| kdensity kdensity_polity2, n(21) yaxis(2) lpattern(shortdash_dot) lcolor(gs8) lwidth(thin) 
				yline(0, lpattern(dot) lcolor(gs8))  xtitle("Level of Democracy")
				legend(off)
				ytitle("Kernal Density Estimate of Democracy", axis(2))
				ytitle("Marginal Effect of Property Rights on FDI")
				title("Figure R23. Marginal Effects of Property Rights on FDI." "(LJI: 21-pt Democracy Scale)")
				note("Note: Dashed lines give 90% confidence interval. Light dashed-dot line displays the Kernal density" "estimate.")
				;
					graph save Figure_R23, replace;
	
	/* Table R6 Model 4 */
	/* Time-varying model */
		use `temp', clear;
		xtmixed ln_FDI_net_inflows c.clji_democ#year c.clji#year polity2 cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle
		|| _all: R.ccode || _all: R.year, mle ;
		gen time= 1 if e(sample)==1;
		matrix k_t = e(k);
		matrix L_t = e(ll);
		svmat k_t;
		svmat L_t;
		gen AIC_t = 2*k_t1 - 2*L_t1;
		sum AIC_t;
			predict REccode_yr REyear_yr, reffects level(_all);

		/* Figure R24 */	
		/* generate marginal effects of PR*/
		gen MEslope_1970 = (_b[1970b.year#clji_democ])*polity2 + _b[1970b.year#clji] + REyear_yr if year==1970;
		gen MEslope_t=0;
	
		forvalues year=1971(1)2009  {;		
		replace MEslope_t = (_b[`year'.year#clji_democ])*polity2 + _b[`year'.year#clji] + REyear_yr if year==`year';
		};	
		replace MEslope_t=MEslope_1970 if year==1970;	
			
			/* Plot slope over time */
			collapse MEslope_t, by(polity2 year time);	
				twoway connected MEslope_t year if year<2010 & polity2==(-10) & time==1, connect(L) scheme(s1mono) lpattern(solid) msymbol(circle) mcolor(gs14) lcolor(gs14)
				|| connected MEslope_t year if year<2010 & polity2==(-9) & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs13) lcolor(gs13)
				|| connected MEslope_t year if year<2010 & polity2==(-8) & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs13) lcolor(gs13)
				|| connected MEslope_t year if year<2010 & polity2==(-7) & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs12) lcolor(gs12)
				|| connected MEslope_t year if year<2010 & polity2==(-6) & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs12) lcolor(gs12)
				|| connected MEslope_t year if year<2010 & polity2==(-5) & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs11) lcolor(gs11)
				|| connected MEslope_t year if year<2010 & polity2==(-4) & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs10) lcolor(gs10)
				|| connected MEslope_t year if year<2010 & polity2==(-3) & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs9) lcolor(gs9)
				|| connected MEslope_t year if year<2010 & polity2==(-2) & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs9) lcolor(gs9)
				|| connected MEslope_t year if year<2010 & polity2==(-1) & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs8) lcolor(gs8)
				|| connected MEslope_t year if year<2010 & polity2==0 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs7) lcolor(gs7)
				|| connected MEslope_t year if year<2010 & polity2==1 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs7) lcolor(gs7)
				|| connected MEslope_t year if year<2010 & polity2==2 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs6) lcolor(gs6)
				|| connected MEslope_t year if year<2010 & polity2==3 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs5) lcolor(gs5)
				|| connected MEslope_t year if year<2010 & polity2==4 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs5) lcolor(gs5)
				|| connected MEslope_t year if year<2010 & polity2==5 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs4) lcolor(gs4)
				|| connected MEslope_t year if year<2010 & polity2==6 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs3) lcolor(gs3)
				|| connected MEslope_t year if year<2010 & polity2==7 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs2) lcolor(gs2)
				|| connected MEslope_t year if year<2010 & polity2==8 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs2) lcolor(gs2)
				|| connected MEslope_t year if year<2010 & polity2==9 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs1) lcolor(gs1)
				|| connected MEslope_t year if year<2010 & polity2==10 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs0) lcolor(gs0)			
					xtitle("Year") legend(off) yline(0, lpattern(dot) lcolor(gs8))
					ytitle("Marginal Effect of Property Rights on FDI")
					title("Figure R24. Time-varying Marginal Effect of Property" "Rights at Different Levels of Democracy on FDI." "(LJI: 21-pt Democracy Scale)")
					note("Note: Displayed value is the marginal effect of Property Rights when interacted with Democracy. Darker" 
					"lines indicate greater levels of Democracy.");
						graph save Figure_R24, replace;					
					
	
/* Sample: Using PCSE instead of MLM */
	
	/* Table R7 Model 1 */
	/* Fixed model */
	use `temp', clear;	
	xtpcse ln_FDI_net_inflows cPRdemoc cefw2legalrights cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle
		 i.ccode, p het;
		
			/* Figure R25 */
			/* Marginal effects */
			grinter cefw2legalrights, inter(cPRdemoc) con(cxconst) scheme(s1mono) yline(0, lpattern(dot) lcolor(gs8)) kdensity nomean clevel(90)
				title(Figure R25. Marginal Effects of Property Rights on FDI.);
					graph save Figure_R25, replace;
	
	/* Table R7 Model 2 */
	/* Time-varying model */
		use `temp', clear;
		xtpcse ln_FDI_net_inflows c.cPRdemoc#year c.cefw2legalrights#year cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle
		i.ccode, p het;
		gen time= 1 if e(sample)==1;

		/* Figure R26 */
		/* Generate marginal effects of PR*/
		gen MEslope_1970 = (_b[1970b.year#cPRdemoc])*cxconst + _b[1970b.year#cefw2legalrights] if year==1970;
		gen MEslope_t=0;
		#delimit;
			forvalues year=1975(5)2000  {;			
			replace MEslope_t = (_b[`year'.year#cPRdemoc])*cxconst + _b[`year'.year#cefw2legalrights] if year==`year';
			};			
			forvalues year=2001/2009  {;		
			replace MEslope_t = (_b[`year'.year#cPRdemoc])*cxconst + _b[`year'.year#cefw2legalrights] if year==`year';
			};
			replace MEslope_t=MEslope_1970 if year==1970;
		
			/* Plot slope over time */
			collapse MEslope_t, by(xconst year time);
				twoway connected MEslope_t year if year<2010 & xconst==1 & time==1, connect(L) scheme(s1mono) lpattern(solid) msymbol(circle) mcolor(gs14) lcolor(gs14)
				|| connected MEslope_t year if year<2010 & xconst==2 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs12) lcolor(gs12)
				|| connected MEslope_t year if year<2010 & xconst==3 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs10) lcolor(gs10)
				|| connected MEslope_t year if year<2010 & xconst==4 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs8) lcolor(gs8)
				|| connected MEslope_t year if year<2010 & xconst==5 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs6) lcolor(gs6)
				|| connected MEslope_t year if year<2010 & xconst==6 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs4) lcolor(gs4)
				|| connected MEslope_t year if year<2010 & xconst==7 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs2) lcolor(gs2) 
					xtitle("Year") legend(off) yline(0, lpattern(dot) lcolor(gs8))
					ytitle("Marginal Effect of Property Rights on FDI")
					title("Figure R26. Time-varying Marginal Effect of Property" "Rights at Different Levels of Democracy on FDI." "(Panel Corrected Standard Errors)")
					note("Note: Displayed value is the marginal effect of Property Rights when interacted with Democracy. Darker" 
					"lines indicate greater levels of Democracy.");
						graph save Figure_R26, replace;
					
	/* Table R7 Model 3 */				
	/* lji */
	/* Fixed model */
	use `temp', clear;	
	xtpcse ln_FDI_net_inflows clji_democ clji cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle
		 i.ccode, p het;
		
			/* Figure R27 */
			/* Marginal effects */
			grinter clji, inter(clji_democ) con(cxconst) scheme(s1mono) yline(0, lpattern(dot) lcolor(gs8)) kdensity nomean clevel(90)
				title(Figure R27. Marginal Effects of Property Rights on FDI (LJI).);
					graph save Figure_R27, replace;

	/* Table R7 Model 4 */				
	/* Time-varying model */
		use `temp', clear;
		xtpcse ln_FDI_net_inflows c.clji_democ#year c.clji#year cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle
		i.ccode, p het;
		gen time= 1 if e(sample)==1;

		/* Figure R28 */
		/* generate marginal effects of PR*/
		gen MEslope_1970 = (_b[1970b.year#clji_democ])*cxconst + _b[1970b.year#clji] if year==1970;
		gen MEslope_t=0;
		
			forvalues year=1971(1)2009  {;
			replace MEslope_t = (_b[`year'.year#clji_democ])*cxconst + _b[`year'.year#clji] if year==`year';
			};			
			replace MEslope_t=MEslope_1970 if year==1970;
		
			/* Plot slope over time */
			collapse MEslope_t, by(xconst year time);
				twoway connected MEslope_t year if year<2010 & xconst==1 & time==1, connect(L) scheme(s1mono) lpattern(solid) msymbol(circle) mcolor(gs14) lcolor(gs14)
				|| connected MEslope_t year if year<2010 & xconst==2 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs12) lcolor(gs12)
				|| connected MEslope_t year if year<2010 & xconst==3 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs10) lcolor(gs10)
				|| connected MEslope_t year if year<2010 & xconst==4 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs8) lcolor(gs8)
				|| connected MEslope_t year if year<2010 & xconst==5 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs6) lcolor(gs6)
				|| connected MEslope_t year if year<2010 & xconst==6 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs4) lcolor(gs4)
				|| connected MEslope_t year if year<2010 & xconst==7 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs2) lcolor(gs2) 
					xtitle("Year") legend(off) yline(0, lpattern(dot) lcolor(gs8))
					ytitle("Marginal Effect of Property Rights on FDI")
					title("Figure R28. Time-varying Marginal Effect of Property" "Rights at Different Levels of Democracy on FDI." "(LJI: Panel Corrected Standard Errors)")
					note("Note: Displayed value is the marginal effect of Property Rights when interacted with Democracy. Darker" 
					"lines indicate greater levels of Democracy.");
						graph save Figure_R28, replace;				
					
/* Sample: Add Energy Consumption variable */

	/* Table R8 Model 1 */
	/* Fixed model */
	use `temp', clear;
	xtmixed ln_FDI_net_inflows cPRdemoc cefw2legalrights cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle cln_pec 
		|| _all: R.ccode || _all: R.year, mle;
		
		matrix B = e(b);
		matrix C = e(V);
		matrix k = e(k);
		matrix L = e(ll);
		svmat k;
		svmat L;
		gen AIC = 2*k1 - 2*L1;
		sum AIC;
		
			/* Figure R29 */
			/* Collapse to show the impact of changing Democ from their Min to their Max */
			collapse (mean) cxconst;
			expand 7;
			replace cxconst = _n-4;
				
			/* Take 1000 draws from actual values */
			expand 1000;
			drawnorm bxz bx bz b01 b02 b03 b04 b05 b06 b07 b08 b00 b10 b20 resid , means(B) cov(C);
				
			/* Generate the marginal effects variable and change over the full range of Property Rights */
			gen gamma = bx + cxconst*(bxz);
			collapse (mean) gamma (sd) sd_gamma = gamma, by(cxconst);

			/* Generate 95% confidence intervals */
			gen gamma_lo = gamma - 1.645*sd_gamma ;
			gen gamma_hi = gamma + 1.645*sd_gamma;
			replace cxconst = cxconst + 4;	
			/* create a kdensity plot */
			mkmat cxconst-gamma_hi , matrix(collapsed) ;
			use `temp', clear;
			keep cxconst;
			replace cxconst = cxconst + 4;
			rename cxconst kdensity_xconst;
			svmat collapsed, names(col);
			
				/* Graph marginal effects */
				twoway lowess gamma cxconst, scheme(s1mono) lcolor(black) lwidth(medthick)
				|| lowess gamma_lo cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| lowess gamma_hi cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| kdensity kdensity_xconst, n(7) yaxis(2) lpattern(shortdash_dot) lcolor(gs8) lwidth(thin) 
				yline(0, lpattern(dot) lcolor(gs8))  xtitle("Level of Democracy")
				legend(off)
				ytitle("Kernal Density Estimate of Democracy", axis(2))
				ytitle("Marginal Effect of Property Rights on FDI")
				title("Figure R29. Marginal Effects of Property Rights on FDI." "(Energy Consumption)")
				note("Note: Dashed lines give 90% confidence interval. Light dashed-dot line displays the Kernal density" "estimate.")
				;
					graph save Figure_R29, replace;
	
	/* Table R8 Model 2 */
	/* Time-varying model */
		use `temp', clear;
		xtmixed ln_FDI_net_inflows c.cPRdemoc#year c.cefw2legalrights#year cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle cln_pec
		|| _all: R.ccode || _all: R.year, mle ;
		gen time= 1 if e(sample)==1;
		egen id = group(ccode) if e(sample)==1;	
		matrix k_t = e(k);
		matrix L_t = e(ll);
		svmat k_t;
		svmat L_t;
		gen AIC_t = 2*k_t1 - 2*L_t1;
		sum AIC_t;
			predict REccode_yr REyear_yr, reffects level(_all);

		/* Figure R30 */	
		/* generate marginal effects of PR*/
		gen MEslope_1970 = (_b[1970b.year#cPRdemoc])*cxconst + _b[1970b.year#cefw2legalrights] + REyear_yr if year==1970;
		gen MEslope_t=0;
		
			forvalues year=1975(5)2000  {;		
			replace MEslope_t = (_b[`year'.year#cPRdemoc])*cxconst + _b[`year'.year#cefw2legalrights] + REyear_yr if year==`year';
			};		
			forvalues year=2001/2007  {;		
			replace MEslope_t = (_b[`year'.year#cPRdemoc])*cxconst + _b[`year'.year#cefw2legalrights] + REyear_yr if year==`year';
			};
			replace MEslope_t=MEslope_1970 if year==1970;
	
			/* Plot slope over time */
			collapse MEslope_t, by(xconst year time);
				twoway connected MEslope_t year if year<2010 & xconst==1 & time==1, connect(L) scheme(s1mono) lpattern(solid) msymbol(circle) mcolor(gs14) lcolor(gs14)
				|| connected MEslope_t year if year<2010 & xconst==2 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs12) lcolor(gs12)
				|| connected MEslope_t year if year<2010 & xconst==3 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs10) lcolor(gs10)
				|| connected MEslope_t year if year<2010 & xconst==4 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs8) lcolor(gs8)
				|| connected MEslope_t year if year<2010 & xconst==5 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs6) lcolor(gs6)
				|| connected MEslope_t year if year<2010 & xconst==6 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs4) lcolor(gs4)
				|| connected MEslope_t year if year<2010 & xconst==7 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs2) lcolor(gs2) 
					xtitle("Year") legend(off) yline(0, lpattern(dot) lcolor(gs8))
					ytitle("Marginal Effect of Property Rights on FDI")
					title("Figure R30. Time-varying Marginal Effect of Property" "Rights at Different Levels of Democracy on FDI." "(Energy Consumption)")
					note("Note: Displayed value is the marginal effect of Property Rights when interacted with Democracy. Darker" 
					"lines indicate greater levels of Democracy.");
						graph save Figure_R30, replace;
					
	/* Table R8 Model 3 */				
	/* lji */
	/* Fixed model */
	use `temp', clear;
	xtmixed ln_FDI_net_inflows clji_democ clji cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle cln_pec 
		|| _all: R.ccode || _all: R.year, mle;
		
		matrix B = e(b);
		matrix C = e(V);
		matrix k = e(k);
		matrix L = e(ll);
		svmat k;
		svmat L;
		gen AIC = 2*k1 - 2*L1;
		sum AIC;
		
			/* Figure R31 */
			/* Collapse to show the impact of changing Democ from their Min to their Max */
			collapse (mean) cxconst;
			expand 7;
			replace cxconst = _n-4;
			
			/* Take 1000 draws from actual values */
			expand 1000;
			drawnorm bxz bx bz b01 b02 b03 b04 b05 b06 b07 b08 b00 b10 b20 resid , means(B) cov(C);
				
			/* Generate the marginal effects variable and change over the full range of Property Rights */
			gen gamma = bx + cxconst*(bxz);
			collapse (mean) gamma (sd) sd_gamma = gamma, by(cxconst);

			/* Generate 95% confidence intervals */
			gen gamma_lo = gamma - 1.645*sd_gamma ;
			gen gamma_hi = gamma + 1.645*sd_gamma;
			replace cxconst = cxconst + 4;	
			/* create a kdensity plot */
			mkmat cxconst-gamma_hi , matrix(collapsed) ;
			use `temp', clear;
			keep cxconst;
			replace cxconst = cxconst + 4;
			rename cxconst kdensity_xconst;
			svmat collapsed, names(col);

				/* Graph marginal effects */
				twoway lowess gamma cxconst, scheme(s1mono) lcolor(black) lwidth(medthick)
				|| lowess gamma_lo cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| lowess gamma_hi cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| kdensity kdensity_xconst, n(7) yaxis(2) lpattern(shortdash_dot) lcolor(gs8) lwidth(thin) 
				yline(0, lpattern(dot) lcolor(gs8))  xtitle("Level of Democracy")
				legend(off)
				ytitle("Kernal Density Estimate of Democracy", axis(2))
				ytitle("Marginal Effect of Property Rights on FDI")
				title("Figure R31. Marginal Effects of Property Rights on FDI." "(LJI: Energy Consumption)")
				note("Note: Dashed lines give 90% confidence interval. Light dashed-dot line displays the Kernal density" "estimate.")
				;
					graph save Figure_R31, replace;
	
	/* Table R8 Model 4 */
	/* Time-varying model */
		use `temp', clear;
		xtmixed ln_FDI_net_inflows c.clji_democ#year c.clji#year cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle cln_pec
		|| _all: R.ccode || _all: R.year, mle ;
		gen time= 1 if e(sample)==1;
		egen id = group(ccode) if e(sample)==1;	
		matrix k_t = e(k);
		matrix L_t = e(ll);
		svmat k_t;
		svmat L_t;
		gen AIC_t = 2*k_t1 - 2*L_t1;
		sum AIC_t;
			predict REccode_yr REyear_yr, reffects level(_all);

		/* Figure R32 */
		/* Generate marginal effects of PR*/
		gen MEslope_1970 = (_b[1970b.year#clji_democ])*cxconst + _b[1970b.year#clji] + REyear_yr if year==1970;
		gen MEslope_t=0;
		
			forvalues year=1971(1)2007  {;			
			replace MEslope_t = (_b[`year'.year#clji_democ])*cxconst + _b[`year'.year#clji] + REyear_yr if year==`year';
			};		
			replace MEslope_t=MEslope_1970 if year==1970;
					
			/* Plot slope over time */
			collapse MEslope_t, by(xconst year time);
				twoway connected MEslope_t year if year<2010 & xconst==1 & time==1, connect(L) scheme(s1mono) lpattern(solid) msymbol(circle) mcolor(gs14) lcolor(gs14)
				|| connected MEslope_t year if year<2010 & xconst==2 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs12) lcolor(gs12)
				|| connected MEslope_t year if year<2010 & xconst==3 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs10) lcolor(gs10)
				|| connected MEslope_t year if year<2010 & xconst==4 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs8) lcolor(gs8)
				|| connected MEslope_t year if year<2010 & xconst==5 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs6) lcolor(gs6)
				|| connected MEslope_t year if year<2010 & xconst==6 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs4) lcolor(gs4)
				|| connected MEslope_t year if year<2010 & xconst==7 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs2) lcolor(gs2) 
					xtitle("Year") legend(off) yline(0, lpattern(dot) lcolor(gs8))
					ytitle("Marginal Effect of Property Rights on FDI")
					title("Figure R32. Time-varying Marginal Effect of Property" "Rights at Different Levels of Democracy on FDI." "(LJI: Energy Consumption)")
					note("Note: Displayed value is the marginal effect of Property Rights when interacted with Democracy. Darker" 
					"lines indicate greater levels of Democracy.");
						graph save Figure_R32, replace;					
					
/* Sample: Add Proportion Rural Population variable */
	
	/* Table R9 Model 1 */
	/* Fixed model */
	use `temp', clear;
	xtmixed ln_FDI_net_inflows cPRdemoc cefw2legalrights cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle cruralpopul 
		|| _all: R.ccode || _all: R.year, mle;
		
		matrix B = e(b);
		matrix C = e(V);
		matrix k = e(k);
		matrix L = e(ll);
		svmat k;
		svmat L;
		gen AIC = 2*k1 - 2*L1;
		sum AIC;
		
			/* Figure R33 */
			/* Collapse to show the impact of changing Democ from their Min to their Max */
			collapse (mean) cxconst;
			expand 7;
			replace cxconst = _n-4;
				
			/* Take 1000 draws from actual values */
			expand 1000;
			drawnorm bxz bx bz b01 b02 b03 b04 b05 b06 b07 b08 b00 b10 b20 resid , means(B) cov(C);
				
			/* Generate the marginal effects variable and change over the full range of Property Rights */
			gen gamma = bx + cxconst*(bxz);
			collapse (mean) gamma (sd) sd_gamma = gamma, by(cxconst);

			/* Generate 95% confidence intervals */
			gen gamma_lo = gamma - 1.645*sd_gamma ;
			gen gamma_hi = gamma + 1.645*sd_gamma;
			replace cxconst = cxconst + 4;	
			/* create a kdensity plot */
			mkmat cxconst-gamma_hi , matrix(collapsed) ;
			use `temp', clear;
			keep cxconst;
			replace cxconst = cxconst + 4;
			rename cxconst kdensity_xconst;
			svmat collapsed, names(col);
	
				/* Graph marginal effects */
				twoway lowess gamma cxconst, scheme(s1mono) lcolor(black) lwidth(medthick)
				|| lowess gamma_lo cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| lowess gamma_hi cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| kdensity kdensity_xconst, n(7) yaxis(2) lpattern(shortdash_dot) lcolor(gs8) lwidth(thin) 
				yline(0, lpattern(dot) lcolor(gs8))  xtitle("Level of Democracy")
				legend(off)
				ytitle("Kernal Density Estimate of Democracy", axis(2))
				ytitle("Marginal Effect of Property Rights on FDI")
				title("Figure R33. Marginal Effects of Property Rights on FDI." "(Rural Population)")
				note("Note: Dashed lines give 90% confidence interval. Light dashed-dot line displays the Kernal density" "estimate.")
				;
					graph save Figure_R33, replace;
	
	/* Table R9 Model 2 */
	/* Time-varying model */
		use `temp', clear;
		xtmixed ln_FDI_net_inflows c.cPRdemoc#year c.cefw2legalrights#year cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle cruralpopul
		|| _all: R.ccode || _all: R.year, mle ;
		gen time= 1 if e(sample)==1;
		egen id = group(ccode) if e(sample)==1;	
		matrix k_t = e(k);
		matrix L_t = e(ll);
		svmat k_t;
		svmat L_t;
		gen AIC_t = 2*k_t1 - 2*L_t1;
		sum AIC_t;
			predict REccode_yr REyear_yr, reffects level(_all);

		/* Figure R34 */	
		/* Generate marginal effects of PR*/
		gen MEslope_1970 = (_b[1970b.year#cPRdemoc])*cxconst + _b[1970b.year#cefw2legalrights] + REyear_yr if year==1970;
		gen MEslope_t=0;
		
			forvalues year=1975(5)2000  {;			
			replace MEslope_t = (_b[`year'.year#cPRdemoc])*cxconst + _b[`year'.year#cefw2legalrights] + REyear_yr if year==`year';
			};			
			forvalues year=2001/2009  {;			
			replace MEslope_t = (_b[`year'.year#cPRdemoc])*cxconst + _b[`year'.year#cefw2legalrights] + REyear_yr if year==`year';
			};
			replace MEslope_t=MEslope_1970 if year==1970;
	
			/* Plot slope over time */
			collapse MEslope_t, by(xconst year time);
				twoway connected MEslope_t year if year<2010 & xconst==1 & time==1, connect(L) scheme(s1mono) lpattern(solid) msymbol(circle) mcolor(gs14) lcolor(gs14)
				|| connected MEslope_t year if year<2010 & xconst==2 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs12) lcolor(gs12)
				|| connected MEslope_t year if year<2010 & xconst==3 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs10) lcolor(gs10)
				|| connected MEslope_t year if year<2010 & xconst==4 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs8) lcolor(gs8)
				|| connected MEslope_t year if year<2010 & xconst==5 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs6) lcolor(gs6)
				|| connected MEslope_t year if year<2010 & xconst==6 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs4) lcolor(gs4)
				|| connected MEslope_t year if year<2010 & xconst==7 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs2) lcolor(gs2) 
					xtitle("Year") legend(off) yline(0, lpattern(dot) lcolor(gs8))
					ytitle("Marginal Effect of Property Rights on FDI")
					title("Figure R34. Time-varying Marginal Effect of Property" "Rights at Different Levels of Democracy on FDI." "(Rural Population)")
					note("Note: Displayed value is the marginal effect of Property Rights when interacted with Democracy. Darker" 
					"lines indicate greater levels of Democracy.");
						graph save Figure_R34, replace;	
					
	/* Table R9 Model 3 */				
	/* lji */
	/* Fixed model */
	use `temp', clear;
	xtmixed ln_FDI_net_inflows clji_democ clji cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle cruralpopul 
		|| _all: R.ccode || _all: R.year, mle;
		
		matrix B = e(b);
		matrix C = e(V);
		matrix k = e(k);
		matrix L = e(ll);
		svmat k;
		svmat L;
		gen AIC = 2*k1 - 2*L1;
		sum AIC;
		
			/* Figure R35 */
			/* Collapse to show the impact of changing Democ from their Min to their Max */
			collapse (mean) cxconst;
			expand 7;
			replace cxconst = _n-4;
			
			/* Take 1000 draws from actual values */
			expand 1000;
			drawnorm bxz bx bz b01 b02 b03 b04 b05 b06 b07 b08 b00 b10 b20 resid , means(B) cov(C);
				
			/* Generate the marginal effects variable and change over the full range of Property Rights */
			gen gamma = bx + cxconst*(bxz);
			collapse (mean) gamma (sd) sd_gamma = gamma, by(cxconst);

			/* Generate 95% confidence intervals */
			gen gamma_lo = gamma - 1.645*sd_gamma ;
			gen gamma_hi = gamma + 1.645*sd_gamma;
			replace cxconst = cxconst + 4;	
			/* create a kdensity plot */
			mkmat cxconst-gamma_hi , matrix(collapsed) ;
			use `temp', clear;
			keep cxconst;
			replace cxconst = cxconst + 4;
			rename cxconst kdensity_xconst;
			svmat collapsed, names(col);
			
				/* Graph marginal effects */
				twoway lowess gamma cxconst, scheme(s1mono) lcolor(black) lwidth(medthick)
				|| lowess gamma_lo cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| lowess gamma_hi cxconst, lcolor(gray) lwidth(medium) lpattern(dash)
				|| kdensity kdensity_xconst, n(7) yaxis(2) lpattern(shortdash_dot) lcolor(gs8) lwidth(thin) 
				yline(0, lpattern(dot) lcolor(gs8))  xtitle("Level of Democracy")
				legend(off)
				ytitle("Kernal Density Estimate of Democracy", axis(2))
				ytitle("Marginal Effect of Property Rights on FDI")
				title("Figure R35. Marginal Effects of Property Rights on FDI." "(LJI: Rural Population)")
				note("Note: Dashed lines give 90% confidence interval. Light dashed-dot line displays the Kernal density" "estimate.")
				;
					graph save Figure_R35, replace;
	
	/* Table R9 Model 4 */
	/* Time-varying model */
		use `temp', clear;
		xtmixed ln_FDI_net_inflows c.clji_democ#year c.clji#year cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle cruralpopul
		|| _all: R.ccode || _all: R.year, mle ;
		gen time= 1 if e(sample)==1;
		egen id = group(ccode) if e(sample)==1;	
		matrix k_t = e(k);
		matrix L_t = e(ll);
		svmat k_t;
		svmat L_t;
		gen AIC_t = 2*k_t1 - 2*L_t1;
		sum AIC_t;
			predict REccode_yr REyear_yr, reffects level(_all);

		/* Figure R36 */	
		/* Generate marginal effects of PR*/
		gen MEslope_1970 = (_b[1970b.year#clji_democ])*cxconst + _b[1970b.year#clji] + REyear_yr if year==1970;
		gen MEslope_t=0;
		
			forvalues year=1971(1)2009  {;		
			replace MEslope_t = (_b[`year'.year#clji_democ])*cxconst + _b[`year'.year#clji] + REyear_yr if year==`year';
			};		
			replace MEslope_t=MEslope_1970 if year==1970;
			
		/* Plot slope over time */
		collapse MEslope_t, by(xconst year time);
			twoway connected MEslope_t year if year<2010 & xconst==1 & time==1, connect(L) scheme(s1mono) lpattern(solid) msymbol(circle) mcolor(gs14) lcolor(gs14)
			|| connected MEslope_t year if year<2010 & xconst==2 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs12) lcolor(gs12)
			|| connected MEslope_t year if year<2010 & xconst==3 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs10) lcolor(gs10)
			|| connected MEslope_t year if year<2010 & xconst==4 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs8) lcolor(gs8)
			|| connected MEslope_t year if year<2010 & xconst==5 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs6) lcolor(gs6)
			|| connected MEslope_t year if year<2010 & xconst==6 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs4) lcolor(gs4)
			|| connected MEslope_t year if year<2010 & xconst==7 & time==1, connect(L) lpattern(solid) msymbol(circle) mcolor(gs2) lcolor(gs2) 
				xtitle("Year") legend(off) yline(0, lpattern(dot) lcolor(gs8))
				ytitle("Marginal Effect of Property Rights on FDI")
				title("Figure R36. Time-varying Marginal Effect of Property" "Rights at Different Levels of Democracy on FDI." "(LJI: Rural Population)")
				note("Note: Displayed value is the marginal effect of Property Rights when interacted with Democracy. Darker" 
				"lines indicate greater levels of Democracy.");
					graph save Figure_R36, replace;					
					
/* Sample: No interaction */
	
	/* Table R10 Model 1 */
	/* Time-varying, no interaction */
		use `temp', clear;
		xtmixed ln_FDI_net_inflows c.cefw2legalrights#year c.cxconst#year cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle
		|| _all: R.ccode || _all: R.year , mle ;
		gen time= 1 if e(sample)==1;
		egen id1 = group(ccode) if e(sample)==1;	
		matrix k_t = e(k);
		matrix L_t = e(ll);
		svmat k_t;
		svmat L_t;
		gen AIC_t = 2*k_t1 - 2*L_t1;
		sum AIC_t;
			predict REccode_yr REyear_yr, reffects level(_all);
				
			/* Figure R37 */	
			/* Generate marginal effects of PR*/
			gen RLslope_1970 = _b[1970b.year#cefw2legalrights] if year==1970;
			gen Dslope_1970 = _b[1970b.year#cxconst] if year==1970;
			gen RLslope_t=0;
			gen Dslope_t=0;

				forvalues year=1975(5)2000  {;	
				replace RLslope_t = _b[`year'.year#cefw2legalrights] if year==`year';
				replace Dslope_t = _b[`year'.year#cxconst] if year==`year';
				};		
				forvalues year=2001/2009  {;
				replace RLslope_t = _b[`year'.year#cefw2legalrights] if year==`year';
				replace Dslope_t = _b[`year'.year#cxconst] if year==`year';
				};
				replace RLslope_t=RLslope_1970 if year==1970;	
				replace Dslope_t=Dslope_1970 if year==1970;
			
				/* Plot slope over time */		
				twoway connected RLslope_t year if year<2010 & time==1, sort connect(L) scheme(s1mono) lpattern(solid) msymbol(circle) mcolor(gs2) lcolor(gs2)
				|| connected Dslope_t year if year<2010 & time==1, sort connect(L) lpattern(dash) msymbol(circle) mcolor(gs10) lcolor(gs10)
				xtitle("Year") legend(lab(1 "Rule of Law") lab(2 "Democracy")) yline(0, lpattern(dot) lcolor(gs8))
					ytitle("Coefficient")
					title("Figure R37. Time-varying Coefficients without Interaction");
					graph save Figure_R37, replace;
			
	/* Table R10 Model 2 */		
	/* Time-varying, no interaction */
	/* LJI */
		use `temp', clear;
		xtmixed ln_FDI_net_inflows c.lji#year c.cxconst#year cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle
		|| _all: R.ccode || _all: R.year , mle ;
		gen time= 1 if e(sample)==1;
		egen id1 = group(ccode) if e(sample)==1;	
		matrix k_t = e(k);
		matrix L_t = e(ll);
		svmat k_t;
		svmat L_t;
		gen AIC_t = 2*k_t1 - 2*L_t1;
		sum AIC_t;
			predict REccode_yr REyear_yr, reffects level(_all);
			
		/* Figure R38 */	
		/* Generate marginal effects of PR*/
		gen RLslope_1970 = _b[1970b.year#lji] if year==1970;
		gen Dslope_1970 = _b[1970b.year#cxconst] if year==1970;
		gen RLslope_t=0;
		gen Dslope_t=0;
	
			forvalues year=1971/2009  {;
			replace RLslope_t = _b[`year'.year#lji] if year==`year';
			replace Dslope_t = _b[`year'.year#cxconst] if year==`year';
			};
			replace RLslope_t=RLslope_1970 if year==1970;	
			replace Dslope_t=Dslope_1970 if year==1970;

				/* Plot slope over time */			
				twoway connected RLslope_t year if year<2010 & time==1, sort connect(L) scheme(s1mono) lpattern(solid) msymbol(circle) mcolor(gs2) lcolor(gs2)
				|| connected Dslope_t year if year<2010 & time==1, sort connect(L) lpattern(dash) msymbol(circle) mcolor(gs10) lcolor(gs10)
				xtitle("Year") legend(lab(1 "Rule of Law") lab(2 "Democracy")) yline(0, lpattern(dot) lcolor(gs8))
					ytitle("Coefficient")
					title("Figure R38. Time-varying Coefficients without Interaction" "(LJI)");				
					graph save Figure_R38, replace;
		
log close;					
