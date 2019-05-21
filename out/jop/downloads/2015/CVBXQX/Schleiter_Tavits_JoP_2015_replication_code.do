*****************************************************************************************************
*Replication code for Schleiter and Tavits "The Electoral Benefits of Opportunistic Election Timing"*
*****************************************************************************************************

use "C:\Users\User\Dropbox\Early Election Calling\Analysis\Replication Data and Code\Schleiter_Tavits_JoP_2015_replication_data.dta", clear
cd "C:\Users\User\Dropbox\Early Election Calling\Analysis\Replicated_Results"

			
*******************
*Published Article*
*******************

/**Table 1: Opportunistic elecions and incumbent electoral performance (difference-of-means tests)**/

			quietly foreach x of varlist pm_voteshare_next pm_seat_shares_next surv_pm {
				mat T = J(2,6,.)
				ttest `x', by(term2) 
				mat T[1,1] = r(N_1)
				mat T[1,2] = r(mu_1)
				mat T[1,3] = r(N_2)
				mat T[1,4] = r(mu_2)
				mat T[1,5] = r(mu_1) - r(mu_2)
				mat T[1,6] = r(p)
				
				ttest `x' if term3!=1, by(term2)
				mat T[2,1] = r(N_1)
				mat T[2,2] = r(mu_1)
				mat T[2,3] = r(N_2)
				mat T[2,4] = r(mu_2)
				mat T[2,5] = r(mu_1) - r(mu_2)
				mat T[2,6] = r(p)
				
				mat rownames T = `x'refe `x're 
				
				frmttable using table1.rtf, statmat(T) varlabels replace ///
				title(Table 1: Opportunistic elections and incumbent electoral performance (difference-of-means tests)) ///
				ctitle("", N, Mean (Comparator Group), N, Mean (Opportunistic Elections), Difference-of-means, "(p-value)")
			}
			
				quietly foreach x of varlist pm_voteshare_next pm_seat_shares_next surv_pm {
				mat T = J(2,6,.)
				ttest `x', by(term2) 
				mat T[1,1] = r(N_1)
				mat T[1,2] = r(mu_1)
				mat T[1,3] = r(N_2)
				mat T[1,4] = r(mu_2)
				mat T[1,5] = r(mu_1) - r(mu_2)
				mat T[1,6] = r(p)
				
				ttest `x' if term3!=1, by(term2)
				mat T[2,1] = r(N_1)
				mat T[2,2] = r(mu_1)
				mat T[2,3] = r(N_2)
				mat T[2,4] = r(mu_2)
				mat T[2,5] = r(mu_1) - r(mu_2)
				mat T[2,6] = r(p)
				
				mat rownames T = `x'refe `x're 
				
				frmttable using table1.rtf, statmat(T) varlabels append ///
				title(Table 1: Opportunistic elections and incumbent electoral performance (difference-of-means tests)) ///
				ctitle("", N, Mean (Comparator Group), N, Mean (Opportunistic Elections), Difference-of-means, "(p-value)")
			}
			
/**Table 2: PM dissolution powers and incumbent electoral performance (difference-of-means tests)**/

			quietly foreach x of varlist pm_voteshare_next pm_seat_shares_next surv_pm {
				mat T = J(2,6,.)
				ttest `x' if term3!=1, by(disspm_8) 
				mat T[1,1] = r(N_1)
				mat T[1,2] = r(mu_1)
				mat T[1,3] = r(N_2)
				mat T[1,4] = r(mu_2)
				mat T[1,5] = r(mu_1) - r(mu_2)
				mat T[1,6] = r(p)

				ttest `x' if term3!=1, by(disspm_0)
				mat T[2,1] = r(N_1)
				mat T[2,2] = r(mu_1)
				mat T[2,3] = r(N_2)
				mat T[2,4] = r(mu_2)
				mat T[2,5] = r(mu_1) - r(mu_2)
				mat T[2,6] = r(p)
				
				mat rownames T = `x'_8 `x'_0 
				
				frmttable using table2.rtf, statmat(T) varlabels replace ///
				title(Table 2: PM dissolution powers and incumbent electoral performance (difference-of-means tests)) ///
				ctitle("", N, Mean (Low diss power), N, Mean (High diss power), Difference-of-means, "(p-value)")
			}	
				quietly foreach x of varlist pm_voteshare_next pm_seat_shares_next surv_pm {
				mat T = J(2,6,.)
				ttest `x' if term3!=1, by(disspm_8) 
				mat T[1,1] = r(N_1)
				mat T[1,2] = r(mu_1)
				mat T[1,3] = r(N_2)
				mat T[1,4] = r(mu_2)
				mat T[1,5] = r(mu_1) - r(mu_2)
				mat T[1,6] = r(p)

				ttest `x' if term3!=1, by(disspm_0)
				mat T[2,1] = r(N_1)
				mat T[2,2] = r(mu_1)
				mat T[2,3] = r(N_2)
				mat T[2,4] = r(mu_2)
				mat T[2,5] = r(mu_1) - r(mu_2)
				mat T[2,6] = r(p)
				
				mat rownames T = `x'_8 `x'_0 
				
				frmttable using table2.rtf, statmat(T) varlabels append ///
				title(Table 2: PM dissolution powers and incumbent electoral performance (difference-of-means tests)) ///
				ctitle("", N, Mean (Low diss power), N, Mean (High diss power), Difference-of-means, "(p-value)")
			}	
			
/**Table 3: Instrumental variable regression**/

		**Panel A: First Stage**
			*OLS Models*
			*(1)*
				regress term2 disspm if term3!=1, cluster(countryn)
				outreg2 disspm using table3aa.rtf, replace nocons label se bdec(3) tdec(3) ctitle("OLS") ///
				title("Table 3: Instrumental variable regression, Panel A: First Stage OLS Regressions (Dependent variable: Opportunistic election)")
			*(2)*
				regress term2 i.decade disspm if term3!=1, cluster(countryn)
				outreg2 disspm using table3aa.rtf, append nocons label se bdec(3) tdec(3) ctitle("OLS") ///
				addtext(Decade Dummies,Yes)
			*(3)*
				regress term2 pm_voteshare i.decade disspm if term3!=1, cluster(countryn)
				outreg2 disspm pm_voteshare using table3aa.rtf, append sortvar(disspm pm_voteshare) nocons label se bdec(3) tdec(3) ctitle("OLS") ///
				addtext(Decade Dummies,Yes)
			*(4)*
				regress term2 pm_voteshare gdp_chg1yr cpi1yr  dumcpi1yr i.decade disspm if term3!=1, cluster(countryn)
				outreg2 disspm pm_voteshare gdp_chg1yr cpi1yr  using table3aa.rtf, append ///
				sortvar(disspm pm_voteshare gdp_chg1yr cpi1yr) nocons label se bdec(3) tdec(3) ctitle("OLS") ///
				addtext(Decade Dummies, Yes, Dummies for time series breaks, Yes) 
			
			*Logistic Regression Models*
			*(1a)*
				logit term2 disspm if term3!=1, cluster(countryn)
				outreg2 disspm using table3ab.rtf, replace eform nocons label se bdec(3) tdec(3) ctitle("Logit") ///
				title("Table 3: Instrumental variable regression, Panel A: First Stage Logistic Regressions(Dependent variable: Opportunistic election)")
			*(2a)*
				logit term2 i.decade disspm if term3!=1, cluster(countryn)
				outreg2 disspm using table3ab.rtf, append eform nocons label se bdec(3) tdec(3) ctitle("Logit") ///
				addtext(Decade Dummies,Yes)
			*(3a)*
				logit term2 pm_voteshare i.decade disspm if term3!=1, cluster(countryn)
				outreg2 disspm pm_voteshare using table3ab.rtf, append sortvar(disspm pm_voteshare) eform nocons label se bdec(3) tdec(3) ctitle("Logit") ///
				addtext(Decade Dummies,Yes)
			*(4a)*
				logit term2 pm_voteshare gdp_chg1yr cpi1yr  dumcpi1yr i.decade disspm if term3!=1, cluster(countryn)
				outreg2 disspm pm_voteshare gdp_chg1yr cpi1yr  using table3ab.rtf, append sortvar(disspm pm_voteshare gdp_chg1yr cpi1yr) eform nocons label se bdec(3) tdec(3) ctitle("Logit") ///
				addtext(Decade Dummies, Yes, Dummies for time series breaks, Yes) 
			
		
		**Panel B: Two Stage Least Squares and Durbin-Wu-Hausman Tests **
			*(1) *
				ivregress 2sls pm_voteshare_next (term2 = disspm) if term3!=1, first cluster(countryn)
				estat endogenous
				estat firststage, all
				outreg2 term2 using table3b.rtf, replace nocons label se bdec(3) tdec(3) ctitle(" ") ///
				title("Table 3: Instrumental variable regression, Panel B: Two Stage Least Squares (Dependent variable: PM Party Vote Share (next election), IV: Opportunistic election = PM dissolution power)") ///
				nonotes addn("Note: Table entries are regression coefficients with country-clustered standard errors in parentheses. †Thirteen observations dropped because decade 2010 predicts failure perfectly. ††Nine observations dropped because decade 2010 predicts failure perfectly. ***p<0.01, **p<0.05, *p<0.1")
			*(2) *
				ivregress 2sls pm_voteshare_next i.decade (term2 = disspm) if term3!=1, first cluster(countryn)
				estat endogenous
				estat firststage, all
				outreg2 term2 using table3b.rtf, append nocons label se bdec(3) tdec(3) ctitle(" ") ///
				addtext(Decade Dummies,Yes)
			*(3) *
				ivregress 2sls pm_voteshare_next pm_voteshare i.decade (term2 = disspm) if term3!=1, first cluster(countryn)
				estat endogenous
				estat firststage, all
				outreg2 term2 pm_voteshare using table3b.rtf, append nocons label se bdec(3) tdec(3) ctitle(" ") ///
				addtext(Decade Dummies,Yes)
			*(4) *
				ivregress 2sls pm_voteshare_next pm_voteshare gdp_chg1yr cpi1yr  dumcpi1yr i.decade (term2 = disspm) if term3!=1, first cluster(countryn)
				estat endogenous
				estat firststage, all
				outreg2 term2 pm_voteshare gdp_chg1yr cpi1yr using table3b.rtf, append nocons label se bdec(3) tdec(3) ctitle(" ") ///
				addtext(Decade Dummies, Yes, Dummies for time series breaks, Yes) 
				
		**Panel C: Ordinary Least Squares**		
			*(1) *
				regress pm_voteshare_next term2 if term3!=1, cluster(countryn)
				outreg2 term2 using table3c.rtf, replace  nor2 nocons label se bdec(3) tdec(3) ctitle(" ") ///
				title("Table 3: Instrumental variable regression, Panel C: Ordinary Least Squares (Dependent variable: PM Party Vote Share (next election))") ///
				nonotes 
			*(2) *
				regress pm_voteshare_next term2 i.decade if term3!=1, cluster(countryn)
				outreg2 term2 using table3c.rtf, append  nor2 nocons label se bdec(3) tdec(3) ctitle(" ") ///
				nonotes 
			*(3) *
				regress pm_voteshare_next pm_voteshare term2 i.decade if term3!=1, cluster(countryn)
				outreg2 term2 using table3c.rtf, append  nor2 nocons label se bdec(3) tdec(3) ctitle(" ") ///
				nonotes 
			*(4) *
				regress pm_voteshare_next pm_voteshare term2 gdp_chg1yr cpi1yr  dumcpi1yr i.decade if term3!=1, cluster(countryn)
				outreg2 term2 using table3c.rtf, append  nor2 nocons label se bdec(3) tdec(3) ctitle(" ") ///
				nonotes  

				
/*Footnote 18: Estimates of OLS regressions with country-level random intercepts*/
			xtset countryn
			*(1) 
				xtreg pm_voteshare_next term2 if term3!=1 & disspm!=., re
				outreg2 term2 using fn18.rtf, replace nocons label se bdec(3) tdec(3) ctitle(" ") ///
				title("Footnot 18: Ordinary Least Squares with country-level random intercepts (Dependent variable: PM Party Vote Share (next election))") 
			*(2) 
				xtreg pm_voteshare_next term2 i.decade if term3!=1 & disspm!=., re
				outreg2 term2 using fn18.rtf, append nocons label se bdec(3) tdec(3) ctitle(" ") 
			*(3) 
				xtreg pm_voteshare_next term2 pm_voteshare i.decade if term3!=1 & disspm!=., re
				outreg2 term2 using fn18.rtf, append nocons label se bdec(3) tdec(3) ctitle(" ") 
			*(4) 
				xtreg pm_voteshare_next term2 pm_voteshare gdp_chg1yr cpi1yr dumcpi1yr i.decade if term3!=1 & disspm!=., re
				outreg2 term2 using fn18.rtf, append nocons label se bdec(3) tdec(3) ctitle(" ") 

				
/**Table 4: Examining the causal chain (separate regressions)**/

			*(1) Logistic regression for comparison to first stage IV reg in Table 3*
				logit term2 dissjointgov pm_voteshare gdp_chg1yr cpi1yr dumcpi1yr i.decade if term3!=1, cluster(country)
				outreg2 dissjointgov pm_voteshare gdp_chg1yr cpi1yr  using table4_1.rtf, replace ///
				sortvar(dissjointgov pm_voteshare gdp_chg1yr cpi1yr) ///
				eform label se bdec(3) tdec(3) ctitle("Model 1 Logit") ///
				addtext(Decade Dummies, Yes, Dummies for time series breaks, Yes) ///
				title ("Table 4: Examining the causal chain (separate regressions)") ///
				nonotes addn("Note: Table entries are regression coefficients with country-clustered standard errors in parentheses. †Nine observations dropped because decade 2010 predicts failure perfectly. ***p<0.01, **p<0.05, *p<0.1")
			*(2) OLS for comparison to first stage IV reg in Table 3*
				regress term2 dissjointgov pm_voteshare gdp_chg1yr cpi1yr dumcpi1yr i.decade if term3!=1, cluster(country)
				outreg2 dissjointgov pm_voteshare gdp_chg1yr cpi1yr  using table4_2.rtf, replace  ///
				sortvar(dissjointgov pm_voteshare gdp_chg1yr cpi1yr) ///
				label se bdec(3) tdec(3) ctitle("Model 2 OLS") ///
				title ("Table 4: Examining the causal chain (separate regressions)") ///
				addtext(Decade Dummies, Yes, Dummies for time series breaks, Yes) 
			*(3) OLS for comparison to second stage IV reg in Table 3*
				regress pm_voteshare_next term2 dissjointgov gdp_chg1yr cpi1yr dumcpi1yr pm_voteshare  i.decade if term3!=1, cluster(countryn)
				outreg2 term2 dissjointgov pm_voteshare gdp_chg1yr cpi1yr  using table4_3.rtf, replace ///
				sortvar(term2 dissjointgov pm_voteshare gdp_chg1yr cpi1yr) ///
				label se bdec(3) tdec(3) ctitle("Model 3 OLS") ///
				title ("Table 4: Examining the causal chain (separate regressions)") ///
				addtext(Decade Dummies, Yes, Dummies for time series breaks, Yes) 

			
				
*****************************
**Supplementary Information**
*****************************				

/**Table SI4.1: Instrument strength**/

			foreach x of varlist disspm dissjointgov {
				mat T = J(2,3,.)
				correlate `x' term2
				mat T[1,1] = r(N)
				mat T[1,2] = r(rho) 
				mat T[1,3] = e(p)
				
				correlate `x' term2 if term3!=1
				mat T[2,1] = r(N)
				mat T[2,2] = r(rho) 
				mat T[2,3] = e(p)
				
				mat rownames T = `x'_all_elections `x'_opp_reg_elections 
				
				frmttable using tableSI4.1.doc, statmat(T) varlabels replace ///
				title(Table SI4.1: Instrument strength) ///
				ctitle("", N, Correlation, "p-value")
			}	
			foreach x of varlist disspm dissjointgov {
				mat T = J(2,3,.)
				correlate `x' term2 
				mat T[1,1] = r(N)
				mat T[1,2] = r(rho) 
				mat T[1,3] = e(p)
				
				correlate `x' term2 if term3!=1
				mat T[2,1] = r(N)
				mat T[2,2] = r(rho) 
				mat T[2,3] = e(p)
				
				mat rownames T = `x'_all_elections `x'_opp_reg_elections 
				
				frmttable using tableSI4.1.doc, statmat(T) varlabels append ///
				title(Table SI4.1: Instrument strength) ///
				ctitle("", N, Correlation, "p-value")
			}	
	
/**Table SI6.1: Alternative instruments and dependent variables (instrumental variable regression, second stage results)**/
		*Instrument: PM Dissolution Power*
			*(1)*
				ivregress 2sls pm_voteshare_next (term2 = disspm) if term3!=1, first cluster(countryn)
				outreg2 using tableSI6_1.rtf, replace label nor2 se bdec(3) tdec(3) cti(PM vote share (next)) ///
				title("Table SI6.1: Alternative instruments and dependent variables (IV 2SLS, second stage results, instrument models 1-3 = PM dissolution power, instrument models 4-6 = Government Dissolution Power)") ///
				nonotes addn("Note: Table entries are regression coefficients with country-clustered standard errors in parentheses. ***p<0.01, **p<0.05, *p<0.1")
			*(3)*
				ivregress 2sls surv_pm (term2 = disspm) if term3!=1, first cluster(countryn)
				outreg2 using tableSI6_1.rtf, append label nor2 se bdec(3) tdec(3) cti(PM survival - IV 2SLS) 
			*(4)*
				ivregress 2sls pm_seat_shares_next (term2 = disspm) if term3!=1, first cluster(countryn)
				outreg2 using tableSI6_1.rtf, append label nor2 se bdec(3) tdec(3) cti(PM seat share (next)) 
		*Instrument: Government Dissolution Power*
			*(1a)*
				ivregress 2sls pm_voteshare_next (term2 = dissjointgov) if term3!=1, first cluster(countryn)
				outreg2 using tableSI6_1.rtf, append label nor2 se bdec(3) tdec(3) cti(PM vote share (next))
			*(3a)*
				ivregress 2sls surv_pm (term2 = dissjointgov) if term3!=1, first cluster(countryn)
				outreg2 using tableSI6_1.rtf, append label nor2 se bdec(3) tdec(3) cti(PM survival)
			*(4a)*
				ivregress 2sls pm_seat_shares_next (term2 = dissjointgov) if term3!=1, first cluster(countryn)
				outreg2 using tableSI6_1.rtf, append label nor2 se bdec(3) tdec(3) cti(PM seat share next)
		*Bivariate Probit models*
				lab var disspm "Opportunistic Election"
				lab var dissjointgov "Opportunistic Election"
			*(2)*
				biprobit surv_pm term2 disspm if term3!=1, cluster(countryn)
				outreg2 using tableSI6_1bi.rtf, replace label nor2 se bdec(3) tdec(3) cti(PM survival) ///
				eqdrop(term2 athrho) ///
				title("Table SI6.1_1: Alternative instruments and dependent variables (PM survival, bivariate probit models, second stage results, instrument model 1 = PM dissolution power, instrument model 2 = Government dissolution power)") ///
				nonotes addn("Note: Table entries are regression coefficients with country-clustered standard errors in parentheses. ***p<0.01, **p<0.05, *p<0.1")
			*(2a)*
				biprobit surv_pm term2 dissjointgov if term3!=1, cluster(countryn)
				outreg2 using tableSI6_1bi.rtf, append label se bdec(3) tdec(3) cti(PM survival) ///
				eqdrop(term2 athrho) 
				lab var disspm "PM dissolution power"
				lab var dissjointgov "Govt dissolution power"

/**Table SI6.2: Instrumental variable regression (two instruments)**/

			*Panel A: First Stage
			*(1) 
				regress term2 disspm pm_med i.decade if term3!=1, cluster(countryn)
				outreg2 disspm pm_med using tableSI6_2a.rtf, replace nocons label se bdec(3) tdec(3) ctitle("OLS") ///
				title("Table SI6.2: Instrumental variable regression (two instruments), Panel A: First Stage (Dependent variable: Opportunistic election)") ///
				nonotes addn("Note: Table entries are regression coefficients with country-clustered standard errors in parentheses. ***p<0.01, **p<0.05, *p<0.1") ///
				addtext(Decade Dummies, Yes) 
			*(2) 
				regress term2 disspm pm_med gdp_chg1yr cpi1yr dumcpi1yr i.decade if term3!=1, cluster(countryn)
				outreg2 disspm pm_med gdp_chg1yr cpi1yr using tableSI6_2a.rtf, append nocons label se bdec(3) tdec(3) ctitle("OLS") ///
				addtext(Decade Dummies, Yes, Dummies for time series breaks, Yes) 

			*Panel B: Two Stage Least Squares
			*(1) 
				ivregress 2sls pm_voteshare_next i.decade (term2 pm_voteshare = disspm pm_med) if term3!=1, first cluster(countryn)
				estat endogenous
				estat firststage, all
				outreg2 term2 pm_voteshare using tableSI6_2b.rtf, replace noobs nocons label se bdec(3) tdec(3) ctitle(" ") ///
				title("Table SI6.2: Instrumental variable regression (two instruments), Panel B: Two Stage Least Squares (Dependent variable: PM Party Vote Share (next election), IV1: Opportunistic election = PM dissolution power, IV2: PM previous vote = PM median party)") ///
				nonotes addn("Note: Table entries are regression coefficients with country-clustered standard errors in parentheses. ***p<0.01, **p<0.05, *p<0.1") ///
				addtext(Decade Dummies, Yes) 
			*(2) 
				ivregress 2sls pm_voteshare_next gdp_chg1yr cpi1yr dumcpi1yr i.decade (term2 pm_voteshare = disspm pm_med) if term3!=1, first cluster(countryn)
				estat endogenous
				estat firststage, all
				outreg2 term2 pm_voteshare gdp_chg1yr cpi1yr using tableSI6_2b.rtf, append noobs nocons label se bdec(3) tdec(3) ctitle(" ") ///
				addtext(Decade Dummies, Yes, Dummies for time series breaks, Yes) 


/**Table SI6.3: Robustness of causal chain to clarity of responsibility (separate regressions)**/

		*Separate regressions*
		*Logistic regression for comparison to first stage in table 3*
			*(1)*
				logit term2 gov_s dissjointgov pm_voteshare gdp_chg1yr cpi1yr dumcpi1yr i.decade if term3!=1, cluster(country)
				outreg2 dissjointgov gov_s pm_voteshare gdp_chg1yr cpi1yr using tableSI6_3a.rtf, replace eform label se bdec(3) tdec(3) ctitle("Model 1 Logit") ///
				sortvar(dissjointgov gov_s pm_voteshare gdp_chg1yr cpi1yr govs_gdpch1yr) ///
				nonotes addn("Note: Table entries are odds ratios with country-clustered standard errors in parentheses. †Nine observations dropped because decade 2010 predicts failure perfectly. ***p<0.01, **p<0.05, *p<0.1") ///
				addtext(Decade Dummies, Yes, Dummies for time series breaks, Yes) 
			*(2)*
				logit term2 gov_s dissjointgov pm_voteshare gdp_chg1yr govs_gdpch1yr cpi1yr dumcpi1yr i.decade if term3!=1, cluster(country)
				outreg2 dissjointgov gov_s pm_voteshare gdp_chg1yr cpi1yr govs_gdpch1yr using tableSI6_3a.rtf, append eform label se bdec(3) tdec(3) ctitle("Model 2 Logit") ///
				sortvar(dissjointgov gov_s pm_voteshare gdp_chg1yr cpi1yr govs_gdpch1yr) ///
				addtext(Decade Dummies, Yes, Dummies for time series breaks, Yes) 
			*(3)*
				logit term2 gov_s dissjointgov pm_voteshare gdp_chg1yr govs_cpi1yr cpi1yr dumcpi1yr i.decade if term3!=1, cluster(country)
				outreg2 dissjointgov gov_s pm_voteshare gdp_chg1yr govs_cpi1yr cpi1yr using tableSI6_3a.rtf, ///
				sortvar(dissjointgov gov_s pm_voteshare gdp_chg1yr cpi1yr govs_gdpch1yr govs_cpi1yr) ///
				append eform label se bdec(3) tdec(3) ctitle("Model 3 Logit") ///
				title("Table SI6.3: Robustness of causal chain to clarity of responsibility (separate regressions), DV: Opportunistic election") ///
				addtext(Decade Dummies, Yes, Dummies for time series breaks, Yes) 

		*OLS voteshare for comparison to second stage IV reg*
			*(4)*
				regress pm_voteshare_next term2 dissjointgov gov_s gdp_chg1yr cpi1yr dumcpi1yr pm_voteshare  i.decade if term3!=1, cluster(countryn)
				outreg2 term2 dissjointgov gov_s pm_voteshare gdp_chg1yr cpi1yr using tableSI6_3b.rtf, replace label se bdec(3) tdec(3) ctitle("Model 4 OLS") ///
				sortvar(term2 dissjointgov gov_s pm_voteshare gdp_chg1yr cpi1yr govs_gdpch1yr) ///
				nonotes addn("Note: Table entries are regression coefficients with country-clustered standard errors in parentheses. ***p<0.01, **p<0.05, *p<0.1") ///
				addtext(Decade Dummies, Yes, Dummies for time series breaks, Yes) 
			*(5)*
				regress pm_voteshare_next term2 dissjointgov gov_s gdp_chg1yr govs_gdpch1yr cpi1yr dumcpi1yr pm_voteshare i.decade if term3!=1, cluster(countryn)
				outreg2 term2 dissjointgov gov_s pm_voteshare gdp_chg1yr cpi1yr govs_gdpch1yr using tableSI6_3b.rtf, append label se bdec(3) tdec(3) ctitle("Model 5 OLS") ///
				sortvar(term2 dissjointgov gov_s pm_voteshare gdp_chg1yr cpi1yr govs_gdpch1yr) ///
				addtext(Decade Dummies, Yes, Dummies for time series breaks, Yes) 
			*(6)*
				regress pm_voteshare_next term2 dissjointgov gov_s gdp_chg1yr govs_cpi1yr cpi1yr dumcpi1yr pm_voteshare  i.decade if term3!=1, cluster(countryn)
				outreg2 term2 dissjointgov gov_s pm_voteshare gdp_chg1yr cpi1yr govs_cpi1yr using tableSI6_3b.rtf, append label se bdec(3) tdec(3) ctitle("Model 6 OLS") ///
				sortvar(term2 dissjointgov gov_s pm_voteshare gdp_chg1yr cpi1yr govs_gdpch1yr govs_cpi1yr) ///
				title("Table SI6.3: Robustness of causal chain to clarity of responsibility (separate regressions), models 4-6, DV: PM party vote share (next)") ///
				addtext(Decade Dummies, Yes, Dummies for time series breaks, Yes) 

/**Table SI6.4: Alternative specifications (instrumental variable regression, second stage results)**/
	
			
	*(1) Ambiguous cases excluded (full sample)**			
				ivregress 2sls pm_voteshare_next pm_voteshare gdp_chg1yr cpi1yr  dumcpi1yr i.decade (term2 = disspm) if ///
				cc_id!=1013 & cc_id!=1016 &	cc_id!=1724	& cc_id!=1725 &	cc_id!=1914 & cc_id!=1319 &	cc_id!=1402 & cc_id!=1403 ///
				&	cc_id!=1410	& cc_id!=2123 & cc_id!=2511, first cluster(countryn)
				outreg2 term2 pm_voteshare gdp_chg1yr cpi1yr  ///
				using tableSI6_4.rtf, replace label se bdec(3) tdec(3) ///
				ctitle("Ambiguous cases excluded") ///
				sortvar(term2 pm_voteshare_next pm_voteshare gdp_chg1yr cpi1yr) ///
				title("Table SI6.4: Alternative specifications (instrumental variable regression, second stage results)") ///
				nonotes addn("Note: Instrumental variable: PM Dissolution Power. Dependent variable: PM Vote Share (next). Table entries are regression coefficients with country-clustered standard errors in parentheses. ***p<0.01, **p<0.05, *p<0.1") ///
				addtext(Decade Dummies, Yes, Dummies for time series breaks, Yes) 
	*(2) WEU only *
				ivregress 2sls pm_voteshare_next pm_voteshare gdp_chg1yr cpi1yr  dumcpi1yr i.decade (term2 = disspm)if term3!=1 & fsu!=1, first cluster(countryn)
				outreg2 term2 pm_voteshare gdp_chg1yr cpi1yr  ///
				using tableSI6_4.rtf, append label se bdec(3) tdec(3) ///
				ctitle("West Europe") ///
				sortvar(term2 pm_voteshare_next pm_voteshare gdp_chg1yr cpi1yr) ///
				addtext(Decade Dummies, Yes, Dummies for time series breaks, Yes) 
	*(3) WEU only no decade*
				ivregress 2sls pm_voteshare_next pm_voteshare gdp_chg1yr cpi1yr  dumcpi1yr (term2 = disspm)if term3!=1 & fsu!=1, first cluster(countryn)
				outreg2 term2 pm_voteshare gdp_chg1yr cpi1yr  ///
				using tableSI6_4.rtf, append label se bdec(3) tdec(3) ///
				ctitle("West Europe w/o decade") ///
				sortvar(term2 pm_voteshare_next pm_voteshare gdp_chg1yr cpi1yr) ///
				addtext(Decade Dummies, Yes, Dummies for time series breaks, Yes) 
	*(4) Alternative lag structure for economic variables - 6 month lags
				ivregress 2sls pm_voteshare_next pm_voteshare gdp_chg6m cpi6m  dumlagcpi i.decade (term2 = disspm) if term3!=1, first cluster(countryn)
				outreg2 term2 pm_voteshare gdp_chg6m cpi6m   ///
				using tableSI6_4.rtf, append label se bdec(3) tdec(3) ///
				ctitle("Alternative lag structure") ///
				sortvar(term2 pm_voteshare_next pm_voteshare gdp_chg1yr cpi1yr gdp_chg6m cpi6m ) ///
				addtext(Decade Dummies, Yes, Dummies for time series breaks, Yes) 
	*(5) Controlling for length of Parliamentary term 3 years
				ivregress 2sls pm_voteshare_next pm_voteshare gdp_chg1yr cpi1yr  dumcpi1yr i.decade ciep3 (term2 = disspm) if term3!=1, first cluster(countryn)
				outreg2 term2 pm_voteshare gdp_chg1yr cpi1yr ciep3   ///
				using tableSI6_4.rtf, append label se bdec(3) tdec(3) ///
				ctitle("Lenght of parl. term") ///
				sortvar(term2 pm_voteshare_next pm_voteshare gdp_chg1yr cpi1yr gdp_chg6m cpi6m ciep3) ///
				addtext(Decade Dummies, Yes, Dummies for time series breaks, Yes) 
	*(6) Controls for cabinet characteristics
				ivregress 2sls pm_voteshare_next pm_voteshare gdp_chg1yr cpi1yr  dumcpi1yr i.decade gov_s gov_med gov_min range_g (term2 = disspm) if term3!=1, first cluster(countryn)
				outreg2 term2 pm_voteshare gdp_chg1yr cpi1yr gov_s gov_med gov_min range_g ///
				using tableSI6_4.rtf, append label se bdec(3) tdec(3) ///
				ctitle("Government characteristics") ///
				sortvar(term2 pm_voteshare_next pm_voteshare gdp_chg1yr cpi1yr gdp_chg6m cpi6m ciep3 gov_s gov_med gov_min range_g) ///
				addtext(Decade Dummies, Yes, Dummies for time series breaks, Yes) 
	*(7) Control for electoral system characteristics
				ivregress 2sls pm_voteshare_next pm_voteshare gdp_chg1yr cpi1yr  dumcpi1yr i.decade major_elect (term2 = disspm) if term3!=1, first cluster(countryn)
				outreg2 term2 pm_voteshare gdp_chg1yr cpi1yr major_elect ///
				using tableSI6_4.rtf, append label se bdec(3) tdec(3) ///
				ctitle("Electoral system") ///
				sortvar(term2 pm_voteshare_next pm_voteshare gdp_chg1yr cpi1yr gdp_chg6m cpi6m ciep3 gov_s gov_med gov_min range_g major_elect) ///
				addtext(Decade Dummies, Yes, Dummies for time series breaks, Yes) 
				

/**Table SI6.5: Instrumental variable regressions (instrument = effective number of parties)**/

		**Panel A: First Stage**
			*OLS Models*
			*(1)*
				regress term2 enp2 if term3!=1, cluster(countryn)
				outreg2 enp2 using tableSI6_5a.rtf, replace nocons label se bdec(3) tdec(3) ctitle("OLS") ///
				title("Table SI6.5: Instrumental variable regressions (instrument = effective number of parties), Panel A: First Stage (OLS, Dependent variable: Opportunistic election)")
			*(2)*
				regress term2 enp2 i.decade if term3!=1, cluster(countryn)
				outreg2 enp2 using tableSI6_5a.rtf, append nocons label se bdec(3) tdec(3) ctitle("OLS") ///
				addtext(Decade Dummies,Yes)
			*(3)*
				regress term2 enp2 pm_voteshare i.decade if term3!=1, cluster(countryn)
				outreg2 enp2 pm_voteshare using tableSI6_5a.rtf, append sortvar(disspm pm_voteshare) nocons label se bdec(3) tdec(3) ctitle("OLS") ///
				addtext(Decade Dummies,Yes)
			*(4)*
				regress term2 enp2 pm_voteshare gdp_chg1yr cpi1yr  dumcpi1yr i.decade if term3!=1, cluster(countryn)
				outreg2 enp2 pm_voteshare gdp_chg1yr cpi1yr  using tableSI6_5a.rtf, append ///
				sortvar(enp2 pm_voteshare gdp_chg1yr cpi1yr) nocons label se bdec(3) tdec(3) ctitle("OLS") ///
				addtext(Decade Dummies, Yes, Dummies for time series breaks, Yes) 
			
		**Panel B: Two Stage Least Squares **
			*(1) *
				ivregress 2sls pm_voteshare_next (term2 = enp2) if term3!=1, first cluster(countryn)
				estat firststage, all
				outreg2 term2 using tableSI6_5b.rtf, replace nocons label se bdec(3) tdec(3) ctitle(" ") ///
				title("Table SI6.5: Instrumental variable regressions (instrument = effective number of parties), Panel B: Two Stage Least Squares (Dependent variable: PM Party Vote Share (next election)") ///
				nonotes addn("Note: Table entries are regression coefficients with country-clustered standard errors in parentheses. ***p<0.01, **p<0.05, *p<0.1")
			*(2) *
				ivregress 2sls pm_voteshare_next i.decade (term2 = enp2) if term3!=1, first cluster(countryn)
				estat firststage, all
				outreg2 term2 using tableSI6_5b.rtf, append nocons label se bdec(3) tdec(3) ctitle(" ") ///
				addtext(Decade Dummies,Yes)
			*(3) *
				ivregress 2sls pm_voteshare_next pm_voteshare i.decade (term2 = enp2) if term3!=1, first cluster(countryn)
				estat firststage, all
				outreg2 term2 pm_voteshare using tableSI6_5b.rtf, append nocons label se bdec(3) tdec(3) ctitle(" ") ///
				addtext(Decade Dummies,Yes)
			*(4) *
				ivregress 2sls pm_voteshare_next pm_voteshare gdp_chg1yr cpi1yr  dumcpi1yr i.decade (term2 = enp2) if term3!=1, first cluster(countryn)
				estat firststage, all
				outreg2 term2 pm_voteshare gdp_chg1yr cpi1yr using tableSI6_5b.rtf, append nocons label se bdec(3) tdec(3) ctitle(" ") ///
				addtext(Decade Dummies, Yes, Dummies for time series breaks, Yes) 
						
/**Table SI6.6: Instrumental Variable regression, second stage results (controlling for the effective number of parties)**/ 

		**Two Stage Least Squares **
			*(1) *
				ivregress 2sls pm_voteshare_next enp2 (term2 = disspm) if term3!=1, first cluster(countryn)
				estat endogenous
				estat firststage, all
				outreg2 term2 enp2 using tableSI6_6.rtf, replace nocons label se bdec(3) tdec(3) ctitle(" ") ///
				title("Table SI6.6: Instrumental Variable regression, second stage results (controlling for the effective number of parties)") ///
				nonotes addn("Note: Instrumental variable: PM Dissolution Power. Dependent variable: PM Vote Share (next). Table entries are regression coefficients with country-clustered standard errors in parentheses. ***p<0.01, **p<0.05, *p<0.1")
			*(2) *
				ivregress 2sls pm_voteshare_next enp2 i.decade (term2 = disspm) if term3!=1, first cluster(countryn)
				estat endogenous
				estat firststage, all
				outreg2 term2 enp2 using tableSI6_6.rtf, append nocons label se bdec(3) tdec(3) ctitle(" ") ///
				addtext(Decade Dummies,Yes)
			*(3) *
				ivregress 2sls pm_voteshare_next pm_voteshare enp2 i.decade (term2 = disspm) if term3!=1, first cluster(countryn)
				estat endogenous
				estat firststage, all
				outreg2 term2 pm_voteshare enp2 using tableSI6_6.rtf, append nocons label se bdec(3) tdec(3) ctitle(" ") ///
				addtext(Decade Dummies,Yes)
			*(4) *
				ivregress 2sls pm_voteshare_next pm_voteshare gdp_chg1yr cpi1yr enp2 dumcpi1yr i.decade (term2 = disspm) if term3!=1, first cluster(countryn)
				estat endogenous
				estat firststage, all
				outreg2 term2 pm_voteshare gdp_chg1yr cpi1yr enp2 using tableSI6_6.rtf, append nocons label se bdec(3) tdec(3) ctitle(" ") ///
				addtext(Decade Dummies, Yes, Dummies for time series breaks, Yes) 

