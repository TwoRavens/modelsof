#delimit;
clear;
set more off, perm;
  quietly log;
  local logon = r(status);
  if "`logon'" == "on" {; 
log close; 
};
log using PSRM_PRR, text replace;
/*******************************/
/*  Mark David Nieman & Cameron G Thies */
/*  9/15/2017        */
/*  Property Rights Regimes, Tech Innovation, and FDI  */
/*  Data Analysis  */
/*  Stata 14.1/MP    */
/*******************************/
clear;
clear matrix;
program drop _all;
set emptycells drop ;
set seed 200;
tempfile temp temp_efw;

/* Load data */
use psrm_prr;
	
	/* Center variables */
	foreach var of varlist efw2legalrights xconst GDPgrowth ln_GDP2005US ln_resource 
							ruralpopul  ln_pop ln_battle ln_durable TradePctGDP 
							lnbit_count ln_World_FDI  lji kaopen ln_GDP_pc2005USD 
							{;
		quietly sum `var';
		gen c`var' = `var'-r(mean);
	};
	gen cPRdemoc = cefw2legalrights*cxconst;
	gen clji_democ = clji*cxconst;
save `temp', replace;


/* Figure 1 */
/* Graph PR and Democ */
use `temp', clear;
	/* identify sample */
	xtmixed ln_FDI_net_inflows efw2legalrights polity2  || _all: R.ccode || _all: R.year, mle;	
	/* make graph */
twoway kdensity efw2legalrights if polity2>6 & e(sample)==1, scheme(s1mono) lpattern(solid) 
	|| kdensity efw2legalrights if polity2<7 & e(sample)==1, lpattern(dash)	
		xtitle("Property Right Protections") 
		ytitle("Kernel Density") ylabel("")
		legend(lab(1 "Democracy") lab(2 "Non-democracy")) 
		note("Note: Democracy is coded as polity2>6 using Polity IV (Marshall and Jaggers 2014). Property Rights" 
			"measured as the Legal System and Structure of Property Rights (Gwartney, Hall and Lawson 2011).")
		title("Figure 1. Rule of Law and Democracy.");
			graph save Figure_1, replace;	

/* Figure 2 */		
/* Graph World FDI */
use `temp', clear;	
replace World_FDI = World_FDI/1000;
collapse  World_FDI, by(year);
	twoway line World_FDI year, ytitle("FDI") xtitle("Year")
		title("Figure 2. Aggregated World FDI Over Time.")
		scheme(s1mono) lcolor(black) lwidth(medthick) 
		note("Note: Foreign Direct Investment figures are in billions of US dollars.");
			graph save Figure_2, replace;		

/* Analysis */

	/* Table 2 Model 1*/
	use `temp', clear;
	xtmixed ln_FDI_net_inflows cPRdemoc cefw2legalrights cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle
		|| _all: R.ccode || _all: R.year, mle;
		matrix B = e(b);
		matrix C = e(V);
		matrix k = e(k);
		matrix L = e(ll);
		svmat k;
		svmat L;
		gen AIC_fm = 2*k1 - 2*L1;
		sum AIC_fm;

			/* Correlation between democracy and property rights, reported in independent variables subsection */
			corr cefw2legalrights cxconst if e(sample)==1;
			
			
			/* Figure 3 */
			/* Generate marginal effect of changing Democ from their Min to their Max */
			collapse (mean) cxconst;
			expand 7;
			replace cxconst = _n-4;
			
			/* Take 1000 draws */
			expand 1000;
			drawnorm bxz bx bz b01 b02 b03 b04 b05 b06 b07 b00 b10 b20 resid , means(B) cov(C);
				
			/* Generate the marginal effects variable and change over the full range of Property Rights */
			gen gamma = bx + cxconst*(bxz);
			collapse (mean) gamma (sd) sd_gamma = gamma, by(cxconst);

			/* Generate 90% confidence intervals */
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
				title("Figure 3. Marginal Effects of Property Rights on FDI.")
				note("Note: Dashed lines give 90% confidence interval. Light dashed-dot line displays the Kernal density" 
					"estimate. Displayed value is from model 1 of Table 2.");
					graph save Figure_3, replace;

	
	/* Table 2 Model 2*/
	/* Time-varying model */
	/* Interactions of c.cPRdemoc#year c.cefw2legalrights#year not displayed in published table (visualized in Figure 4 instead) */
		use `temp', clear;
		xtmixed ln_FDI_net_inflows c.cPRdemoc#year c.cefw2legalrights#year cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle
		|| _all: R.ccode || _all: R.year , mle ;
		gen time= 1 if e(sample)==1;
		egen id = group(ccode) if e(sample)==1;	
		save `temp', replace;
		matrix k_t = e(k);
		matrix L_t = e(ll);
		svmat k_t;
		svmat L_t;
		gen AIC_t = 2*k_t1 - 2*L_t1;
		sum AIC_t;
			predict REccode_yr REyear_yr, reffects level(_all);

		/* Figure 4 */		
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
						title("Figure 4. Time-varying Marginal Effect of Property" "Rights on FDI at Different Levels of Democracy.")
						note("Note: Displayed value is the marginal effect of Property Rights when interacted with Democracy from" 
						"model 2 of Table 2. Darker lines indicate greater levels of Democracy.");
							graph save Figure_4, replace;
	
	
	/* Table 2 Model 3 */
	/* Time- and country-varying slope */
	/* Interactions of c.cPRdemoc#(id year) c.cefw2legalrights#(id year) not displayed in published table (visualized in Figure 5 instead) */
	use `temp', clear;	
	xtmixed ln_FDI_net_inflows c.cPRdemoc#(id year) c.cefw2legalrights#(id year) cxconst cln_GDP2005US cln_GDP_pc2005USD cGDPgrowth cTradePctGDP ckaopen cln_resource cln_battle
		|| _all: R.id || _all: R.year , mle ;	
		gen id_t=1 if e(sample)==1;
		save `temp', replace;
		matrix k_id = e(k);
		matrix L_id = e(ll);
		svmat k_id;
		svmat L_id;
		gen AIC_id = 2*k_id1 - 2*L_id1;
		sum AIC_id;

		/* Figure 5 */
		/* Isolate year and country effects */
		predict REccode_yr_id REyear_yr_id, reffects level(_all);		

		/* generate marginal effects of PR over time*/
		gen MEslope_1970_yr = (_b[1970b.year#cPRdemoc])*cxconst + _b[1970b.year#cefw2legalrights]  if year==1970;
		gen MEslope_yr=0;
		#delimit;
			forvalues year=1975(5)2000  {;
				replace MEslope_yr = (_b[`year'.year#cPRdemoc])*cxconst + _b[`year'.year#cefw2legalrights]  if year==`year' ;
			};
			
			forvalues year=2001/2009  {;
				replace MEslope_yr = (_b[`year'.year#cPRdemoc])*cxconst + _b[`year'.year#cefw2legalrights]  if year==`year' ;
			};
			replace MEslope_yr=MEslope_1970_yr if year==1970;	

		/* generate marginal effects of PR over space, but ignore the legal right aspect to not over count it when combined */
		gen MEslope_1_id = (_b[1b.id#cPRdemoc])*cxconst + _b[1.b.id#cefw2legalrights]  if id==1;	
		gen MEslope_id=0;
			forvalues id=2/127 {;
			replace MEslope_id = (_b[`id'.id#cPRdemoc])*cxconst + _b[`id'.id#cefw2legalrights]  if id==`id';
			};
			replace MEslope_id=MEslope_1_id if id==1;
		gen MEslope_yr_id = MEslope_yr + MEslope_id + REccode_yr_id + REyear_yr_id;
		save `temp_efw', replace;
		keep if (MEslope_yr_id<.9 & MEslope_yr_id!=.);
		keep if (MEslope_yr_id>(-.9) & MEslope_yr_id!=.);

			/* Plot slope for different regions */
			twoway connected MEslope_yr_id year if ccode>1 &ccode<200 & year<2010 & id_t==1, connect(L) scheme(s1mono)
				ytitle("") xtitle("") legend(off) yline(0, lcolor(gs8))
				t2("Americas") ylabel(-0.5 "-0.5" 0 "0" 0.5 "0.5", noticks) ytick(0.5(.5).5);
				graph save Figure_5a, replace;
				
			twoway connected MEslope_yr_id year if ccode>199 &ccode<400 & year<2010 & id_t==1 , connect(L) scheme(s1mono)
				ytitle("") xtitle("") legend(off) yline(0, lcolor(gs8))
				t2("Europe") ylabel(-0.5 "-0.5" 0 "0" 0.5 "0.5", noticks) ytick(0.5(.5).5);
				graph save Figure_5b, replace;		
				
			twoway connected MEslope_yr_id year if ccode>399 &ccode<600 & year<2010 & id_t==1, connect(L) scheme(s1mono)
				ytitle("") xtitle("") legend(off) yline(0, lcolor(gs8))
				t2("Africa") ylabel(-0.5 "-0.5" 0 "0" 0.5 "0.5", noticks) ytick(0.5(.5).5);
				graph save Figure_5c, replace;
				
			twoway connected MEslope_yr_id year if ccode>599 &ccode<700 & year<2010 & id_t==1 , connect(L) scheme(s1mono)
				ytitle("") xtitle("") legend(off) yline(0, lcolor(gs8))
				t2("Middle East") ylabel(-0.5 "-0.5" 0 "0" 0.5 "0.5" , noticks) ytick(0.5(.5).5);
				graph save Figure_5d, replace;
				
			twoway connected MEslope_yr_id year if ccode>699 &ccode<800 & year<2010 & id_t==1, connect(L) scheme(s1mono)
				ytitle("") xtitle("") legend(off) yline(0, lcolor(gs8))
				t2("Central & North Asia") ylabel(-0.5 "-0.5" 0 "0" 0.5 "0.5", noticks) ytick(0.5(.5).5);
				graph save Figure_5e, replace;
			#delimit;	
			twoway connected MEslope_yr_id year if ccode>799 &ccode<999 & year<2010 & id_t==1, connect(L) scheme(s1mono)
				ytitle("") xtitle("") legend(off) yline(0, lcolor(gs8))
				t2("Southeast Asia & Oceania") ylabel(-0.5 "-0.5" 0 "0" 0.5 "0.5", noticks) ytick(0.5(.5).5);
				graph save Figure_5f, replace;
		
			graph combine Figure_5a.gph Figure_5b.gph Figure_5c.gph Figure_5d.gph Figure_5e.gph Figure_5f.gph,
				sch(s1mono) 
				b1title("Year")  xcommon
				l1title("Marginal Effect of Property Rights on FDI") 
				title("Figure 5. Time-varying and Country-varying" "Marginal Effect of Property Rights on FDI.")
				note("Note: Displayed value is the marginal effect of Property Rights when interacted with Democracy from" 
				"model 3 of Table 2. Table does not display marginal effect for Russia 2007-2009 (1.714, 1.658, 1.603);"
				"Turkey 1980 (-1.506), or Uruguay 1980 (0.990), to maximize overall visualization.");
				graph save Figure_5, replace;
		
		/* Figure 6 */
		/* Present evidence that the number of countries with a positive PR marg effect has increased */
		use `temp_efw', clear;
		egen posME_yr_id = count(MEslope_yr_id) if MEslope_yr_id>0 & MEslope_yr_id!=., by(year);
		egen N_ccode = count(ccode) if MEslope_yr_id!=., by(year);
		gen pct_MEslope_pos = posME_yr_id/ N_ccode;
		#delimit;
		twoway line pct_MEslope_pos year, sort sch(s1mono) ytitle("Proportion of Countries") 
				xtitle("Year") xlabel(1970 "1970" 1980 "1980" 1990 "1990" 2000 "2000" 2010 "2010" , noticks) xtick(1970(10)2010)
				title("Figure 6. Proportion of Countries with a Positive" "Property Rights Regime Coefficient.")
				note("Note: Proportion based on marginal effect of Property Rights when interacted with Democracy from" 
				"sample in model 3 of Table 2.");
				graph save Figure_6, replace;
				
				

	log close;
		
				
