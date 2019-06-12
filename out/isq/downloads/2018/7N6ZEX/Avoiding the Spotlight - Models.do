				****************************************
	     				*FDI Models (05.30.2011)*
				****************************************

						

					**All Countries, 1994-2004**
	eststo clear
	sort cowcode year
	*(1)Base Model:
		eststo: xtpcse F.ln_aggflows physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005, pairwise corr(ar1)
	*(2)Shaming Model:
		eststo: xtpcse F.ln_aggflows  hrnc2gcnc2 physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005, pairwise corr(ar1)
	*(3)Full Model:
		eststo: xtpcse F.ln_aggflows hrnc2gcnc2 physint  instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005, pairwise corr(ar1)	
	*(4)Base & Shaming Models, Nested:
		xtpcse F.ln_aggflows physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&e(sample), pairwise corr(ar1)
		xtpcse F.ln_aggflows  hrnc2gcnc2 physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&e(sample), pairwise corr(ar1)
	esttab est1 est2 est3 using fdi_shaming_ALL.tex, se title(FDI Flows -- All Countires) label nogaps order(hrnc2gcnc2 physint instability_mag int_proprights kaopen) star(* 0.1 ** 0.05 *** 0.01) replace
			
	*(Full Model Minus Shaming)
	eststo: xtpcse F.ln_aggflows physint instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005, pairwise corr(ar1)
			
				**Developing Countries, 1994-2004**
	eststo clear
	sort cowcode year
	*(5)Base Model:
		eststo: xtpcse F.ln_aggflows physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0, pairwise corr(ar1)
	*(6)Shaming Model:
		eststo: xtpcse F.ln_aggflows  hrnc2gcnc2 physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0, pairwise corr(ar1)
	*(7)Full Model:
		eststo: xtpcse F.ln_aggflows hrnc2gcnc2 physint  instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0, pairwise corr(ar1)
	*(8)Base & Shaming Models, Nested:
		xtpcse F.ln_aggflows physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0&e(sample), pairwise corr(ar1)
		xtpcse F.ln_aggflows  hrnc2gcnc2 physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0&e(sample), pairwise corr(ar1)
	 *(Full Model Minus Shaming)
	 xtpcse F.ln_aggflows physint  instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0, pairwise corr(ar1)
				
				
				**Developed Countries, 1994-2004**
	*(5)Base Model:
		 eststo: xtpcse F.ln_aggflows physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==1, pairwise corr(ar1)
	*(6)Shaming Model:
		eststo: xtpcse F.ln_aggflows  hrnc2gcnc2 physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==1, pairwise corr(ar1)
	*(7)Full Model:
		eststo: xtpcse F.ln_aggflows hrnc2gcnc2 physint  instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==1, pairwise corr(ar1)
	*(8)Base & Shaming Models, Nested:
		xtpcse F.ln_aggflows physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==1&e(sample), pairwise corr(ar1)
		xtpcse F.ln_aggflows  hrnc2gcnc2 physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==1&e(sample), pairwise corr(ar1)
	*(Full Model Minus Shaming)
		xtpcse F.ln_aggflows hrnc2gcnc2 physint  instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==1, pairwise corr(ar1)
		
		esttab est1 est2 est3 est4 est5 est6 using fdi_shaming_disagg.tex, se title(FDI Flows Disaggregated by Development)label nogaps order(hrnc2gcnc2 physint instability_mag int_proprights kaopen ) star(* 0.1 ** 0.05 *** 0.01) replace
			
	*(Developed States Minus United States and Great Britain)
	xtpcse F.ln_aggflows hrnc2gcnc2 physint  instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==1&cowcode~=2&cowcode~=200, pairwise corr(ar1)
				
				
	**Robustness Checks on Developing States using Alternative Estimators (Model 7)**
eststo clear
*PCSE w.out ar(1), and PCSE w. LDV
xtpcse F.ln_aggflows hrnc2gcnc2 physint  instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0, pairwise
eststo: xtpcse F.ln_aggflows ln_aggflows hrnc2gcnc2 physint  instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0, pairwise

*OLS, and OLS w. LDV
regress F.ln_aggflows hrnc2gcnc2 physint  instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0, robust
eststo: regress F.ln_aggflows ln_aggflows hrnc2gcnc2 physint  instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0, robust

*Random Effects, and RE w. LDV
xtreg F.ln_aggflows hrnc2gcnc2 physint  instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0, robust
eststo: xtreg F.ln_aggflows ln_aggflows hrnc2gcnc2 physint  instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0, robust

*Fixed Effects, and FE w. LDV
xtreg F.ln_aggflows hrnc2gcnc2 physint  instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0, fe robust
eststo: xtreg F.ln_aggflows ln_aggflows hrnc2gcnc2 physint  instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0, fe robust

esttab est1 est2 est3 est4 using fdi_shaming_altestimators.tex, se title(Robustness Checks with Alternate Estimators)label nogaps order(hrnc2gcnc2 physint instability_mag int_proprights kaopen) star(* 0.1 ** 0.05 *** 0.01) replace

	**Robustness Checks using Alternative Instability Measures (Model 7)**
eststo clear
*Weighted Conflict Index (Banks CNTS)
eststo: xtpcse F.ln_aggflows hrnc2gcnc2 physint  domestic9 int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0&ln_aggflows>=0, pairwise corr(ar1)

*Civil Conflict, Civil War (PRIO)
xtpcse F.ln_aggflows hrnc2gcnc2 physint  civconf_intensity int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0&ln_aggflows>=0, pairwise corr(ar1)
eststo: xtpcse F.ln_aggflows hrnc2gcnc2 physint  civwar int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0&ln_aggflows>=0, pairwise corr(ar1)

*War on Location (PRIO?)
xtpcse F.ln_aggflows hrnc2gcnc2 physint  waronlocation int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0&ln_aggflows>=0, pairwise corr(ar1)

esttab est1 est2 using FDI_Shaming_Robustness.tex, se title(Alternative Instability Indicators--Developing States Only) label nogaps order(hrnc2gcnc2 physint domestic9 civwar int_proprights kaopen ) star(* 0.1 ** 0.05 *** 0.01) replace



**Summary Stats Table--All Countries
sutex ln_aggflows hrnc2gcnc2 physint instability_mag domestic9 civwar int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock worldflows if year>1993&year<2005, labels minmax

**Summary Stats Table--Developing Countries
sutex ln_aggflows hrnc2gcnc2 physint instability_mag domestic9 civwar int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock worldflows if year>1993&year<2005&oecd==0, labels minmax

**Summary Stats TAble--Developed Countries
sutex ln_aggflows hrnc2gcnc2 physint instability_mag domestic9 civwar int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock worldflows if year>1993&year<2005&oecd==1, labels minmax



			***WEB APPENDIX ROBUSTNESS CHECKS -- TABLES 1 AND 2 INCLUDING GDP***
			
**All Countries, 1994-2004**
	eststo clear
	sort cowcode year
	*(1)Base Model:
		eststo: xtpcse F.ln_aggflows physint  growth ln_develop ln_gdp ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005, pairwise corr(ar1)
	*(2)Shaming Model:
		eststo: xtpcse F.ln_aggflows  hrnc2gcnc2 physint  growth ln_develop ln_gdp ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005, pairwise corr(ar1)
	*(3)Full Model:
		eststo: xtpcse F.ln_aggflows hrnc2gcnc2 physint  instability_mag int_proprights growth ln_develop ln_gdp ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005, pairwise corr(ar1)	
	*(4)Base & Shaming Models, Nested:
		xtpcse F.ln_aggflows physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&e(sample), pairwise corr(ar1)
		xtpcse F.ln_aggflows  hrnc2gcnc2 physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&e(sample), pairwise corr(ar1)
	esttab est1 est2 est3 using fdi_shaming_ALL.tex, se title(FDI Flows -- All Countires w/Market Size) label nogaps order(hrnc2gcnc2 physint instability_mag int_proprights kaopen) star(* 0.1 ** 0.05 *** 0.01) replace
			
	*(Full Model Minus Shaming)
	eststo: xtpcse F.ln_aggflows physint instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005, pairwise corr(ar1)
			
**Developing Countries, 1994-2004**
	eststo clear
	sort cowcode year
	*(5)Base Model:
		eststo: xtpcse F.ln_aggflows physint  growth ln_develop ln_gdp ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0, pairwise corr(ar1)
	*(6)Shaming Model:
		eststo: xtpcse F.ln_aggflows  hrnc2gcnc2 physint  growth ln_develop ln_gdp ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0, pairwise corr(ar1)
	*(7)Full Model:
		eststo: xtpcse F.ln_aggflows hrnc2gcnc2 physint  instability_mag int_proprights growth ln_develop ln_gdp ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0, pairwise corr(ar1)
	*(8)Base & Shaming Models, Nested:
		xtpcse F.ln_aggflows physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0&e(sample), pairwise corr(ar1)
		xtpcse F.ln_aggflows  hrnc2gcnc2 physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0&e(sample), pairwise corr(ar1)
	 *(Full Model Minus Shaming)
	 xtpcse F.ln_aggflows physint  instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0, pairwise corr(ar1)
				
				
**Developed Countries, 1994-2004**
	*(5)Base Model:
		 eststo: xtpcse F.ln_aggflows physint  growth ln_develop ln_gdp ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==1, pairwise corr(ar1)
	*(6)Shaming Model:
		eststo: xtpcse F.ln_aggflows  hrnc2gcnc2 physint  growth ln_develop ln_gdp ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==1, pairwise corr(ar1)
	*(7)Full Model:
		eststo: xtpcse F.ln_aggflows hrnc2gcnc2 physint  instability_mag int_proprights growth ln_develop  ln_gdp ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==1, pairwise corr(ar1)
	*(8)Base & Shaming Models, Nested:
		xtpcse F.ln_aggflows physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==1&e(sample), pairwise corr(ar1)
		xtpcse F.ln_aggflows  hrnc2gcnc2 physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==1&e(sample), pairwise corr(ar1)
	*(Full Model Minus Shaming)
		xtpcse F.ln_aggflows hrnc2gcnc2 physint  instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==1, pairwise corr(ar1)
		
		esttab est1 est2 est3 est4 est5 est6 using fdi_shaming_disagg.tex, se title(FDI Flows Disaggregated by Development)label nogaps order(hrnc2gcnc2 physint instability_mag int_proprights kaopen ) star(* 0.1 ** 0.05 *** 0.01) replace
			
	*(Developed States Minus United States and Great Britain)
	xtpcse F.ln_aggflows hrnc2gcnc2 physint  instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==1&cowcode~=2&cowcode~=200, pairwise corr(ar1)
				
				

			***WEB APPENDIX ROBUSTNESS CHECKS -- TABLES 1 AND 2 INCLUDING POPULATION***
			
**All Countries, 1994-2004**
	eststo clear
	sort cowcode year
	*(1)Base Model:
		eststo: xtpcse F.ln_aggflows physint  growth ln_develop ln_population ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005, pairwise corr(ar1)
	*(2)Shaming Model:
		eststo: xtpcse F.ln_aggflows  hrnc2gcnc2 physint  growth ln_develop ln_population ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005, pairwise corr(ar1)
	*(3)Full Model:
		eststo: xtpcse F.ln_aggflows hrnc2gcnc2 physint  instability_mag int_proprights growth ln_develop ln_population ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005, pairwise corr(ar1)	
	*(4)Base & Shaming Models, Nested:
		xtpcse F.ln_aggflows physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&e(sample), pairwise corr(ar1)
		xtpcse F.ln_aggflows  hrnc2gcnc2 physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&e(sample), pairwise corr(ar1)
	esttab est1 est2 est3 using fdi_shaming_ALL.tex, se title(FDI Flows -- All Countires w/Market Size) label nogaps order(hrnc2gcnc2 physint instability_mag int_proprights kaopen) star(* 0.1 ** 0.05 *** 0.01) replace
			
	*(Full Model Minus Shaming)
	eststo: xtpcse F.ln_aggflows physint instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005, pairwise corr(ar1)
			
**Developing Countries, 1994-2004**
	eststo clear
	sort cowcode year
	*(5)Base Model:
		eststo: xtpcse F.ln_aggflows physint  growth ln_develop ln_population ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0, pairwise corr(ar1)
	*(6)Shaming Model:
		eststo: xtpcse F.ln_aggflows  hrnc2gcnc2 physint  growth ln_develop ln_population ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0, pairwise corr(ar1)
	*(7)Full Model:
		eststo: xtpcse F.ln_aggflows hrnc2gcnc2 physint  instability_mag int_proprights growth ln_develop ln_population ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0, pairwise corr(ar1)
	*(8)Base & Shaming Models, Nested:
		xtpcse F.ln_aggflows physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0&e(sample), pairwise corr(ar1)
		xtpcse F.ln_aggflows  hrnc2gcnc2 physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0&e(sample), pairwise corr(ar1)
	 *(Full Model Minus Shaming)
	 xtpcse F.ln_aggflows physint  instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0, pairwise corr(ar1)
				
				
**Developed Countries, 1994-2004**
	*(5)Base Model:
		 eststo: xtpcse F.ln_aggflows physint  growth ln_develop ln_population ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==1, pairwise corr(ar1)
	*(6)Shaming Model:
		eststo: xtpcse F.ln_aggflows  hrnc2gcnc2 physint  growth ln_develop ln_population ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==1, pairwise corr(ar1)
	*(7)Full Model:
		eststo: xtpcse F.ln_aggflows hrnc2gcnc2 physint  instability_mag int_proprights growth ln_develop  ln_population ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==1, pairwise corr(ar1)
	*(8)Base & Shaming Models, Nested:
		xtpcse F.ln_aggflows physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==1&e(sample), pairwise corr(ar1)
		xtpcse F.ln_aggflows  hrnc2gcnc2 physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==1&e(sample), pairwise corr(ar1)
	*(Full Model Minus Shaming)
		xtpcse F.ln_aggflows hrnc2gcnc2 physint  instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==1, pairwise corr(ar1)
		
		esttab est1 est2 est3 est4 est5 est6 using fdi_shaming_disagg.tex, se title(FDI Flows Disaggregated by Development)label nogaps order(hrnc2gcnc2 physint instability_mag int_proprights kaopen ) star(* 0.1 ** 0.05 *** 0.01) replace
			
	*(Developed States Minus United States and Great Britain)
	xtpcse F.ln_aggflows hrnc2gcnc2 physint  instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==1&cowcode~=2&cowcode~=200, pairwise corr(ar1)





					***ROBUSTNESS CHECK USING HAFNER-BURTON DATA***
	eststo clear
	sort cowcode year
	*(1)Base Model:
		eststo: xtpcse F.ln_aggflows physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005, pairwise corr(ar1)
	*(2)Shaming Model:
		eststo: xtpcse F.ln_aggflows  media_ai_rn physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005, pairwise corr(ar1)
	*(3)Full Model:
		eststo: xtpcse F.ln_aggflows media_ai_rn physint  instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005, pairwise corr(ar1)	
	*(4)Base & Shaming Models, Nested:
		xtpcse F.ln_aggflows physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&e(sample), pairwise corr(ar1)
		xtpcse F.ln_aggflows  hrnc2gcnc2 physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&e(sample), pairwise corr(ar1)
	esttab est1 est2 est3 using fdi_shaming_ALL.tex, se title(FDI Flows -- All Countires) label nogaps order(media_ai_rn physint instability_mag int_proprights kaopen) star(* 0.1 ** 0.05 *** 0.01) replace
			
	*(Full Model Minus Shaming)
	eststo: xtpcse F.ln_aggflows physint instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005, pairwise corr(ar1)
			
				**Developing Countries, 1994-2004**
	eststo clear
	sort cowcode year
	*(5)Base Model:
		eststo: xtpcse F.ln_aggflows physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0, pairwise corr(ar1)
	*(6)Shaming Model:
		eststo: xtpcse F.ln_aggflows  media_ai_rn physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0, pairwise corr(ar1)
	*(7)Full Model:
		eststo: xtpcse F.ln_aggflows media_ai_rn physint  instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0, pairwise corr(ar1)
	*(8)Base & Shaming Models, Nested:
		xtpcse F.ln_aggflows physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0&e(sample), pairwise corr(ar1)
		xtpcse F.ln_aggflows  hrnc2gcnc2 physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0&e(sample), pairwise corr(ar1)
	 *(Full Model Minus Shaming)
	 xtpcse F.ln_aggflows physint  instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0, pairwise corr(ar1)
				
				
				**Developed Countries, 1994-2004**
	*(5)Base Model:
		 eststo: xtpcse F.ln_aggflows physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==1, pairwise corr(ar1)
	*(6)Shaming Model:
		eststo: xtpcse F.ln_aggflows  media_ai_rn physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==1, pairwise corr(ar1)
	*(7)Full Model:
		eststo: xtpcse F.ln_aggflows media_ai_rn physint  instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==1, pairwise corr(ar1)
	*(8)Base & Shaming Models, Nested:
		xtpcse F.ln_aggflows physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==1&e(sample), pairwise corr(ar1)
		xtpcse F.ln_aggflows  hrnc2gcnc2 physint  growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==1&e(sample), pairwise corr(ar1)
	*(Full Model Minus Shaming)
		xtpcse F.ln_aggflows hrnc2gcnc2 physint  instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==1, pairwise corr(ar1)
		
		esttab est1 est2 est3 est4 est5 est6 using fdi_shaming_disagg.tex, se title(FDI Flows Disaggregated by Development)label nogaps order(media_ai_rn physint instability_mag int_proprights kaopen ) star(* 0.1 ** 0.05 *** 0.01) replace
			
	*(Developed States Minus United States and Great Britain)
	xtpcse F.ln_aggflows hrnc2gcnc2 physint  instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==1&cowcode~=2&cowcode~=200, pairwise corr(ar1)
								
								
								
								
					*** ROBUSTNESS CHECK USING PTA, BIT, AND WTO MEMBERSHIP VARIABLES***
**All Countries, 1994-2004**
	eststo clear
	sort cowcode year
		eststo: xtpcse F.ln_aggflows hrnc2gcnc2 physint wtomemberdummy instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005, pairwise corr(ar1)	
		eststo: xtpcse F.ln_aggflows hrnc2gcnc2 physint bitsumoecd instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005, pairwise corr(ar1)	
		eststo: xtpcse F.ln_aggflows hrnc2gcnc2 physint pta_cuml instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005, pairwise corr(ar1)	
		eststo: xtpcse F.ln_aggflows hrnc2gcnc2 physint wtomemberdummy bitsumoecd pta_cuml instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005, pairwise corr(ar1)	
		
		esttab est1 est2 est3 est4 using fdi_shaming_BITSnSTUFF.tex, se title(FDI Flows -- All Countires) label nogaps order(hrnc2gcnc2 physint instability_mag int_proprights kaopen wtomemberdummy bitsumoecd pta_cuml) star(* 0.1 ** 0.05 *** 0.01) replace
			
				
**Developing Countries, 1994-2004**
	eststo clear
	sort cowcode year
		eststo: xtpcse F.ln_aggflows hrnc2gcnc2 physint wtomemberdummy instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0, pairwise corr(ar1)			
		eststo: xtpcse F.ln_aggflows hrnc2gcnc2 physint bitsumoecd instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0, pairwise corr(ar1)			
		eststo: xtpcse F.ln_aggflows hrnc2gcnc2 physint pta_cuml instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0, pairwise corr(ar1)			
		eststo: xtpcse F.ln_aggflows hrnc2gcnc2 physint wtomemberdummy bitsumoecd pta_cuml instability_mag int_proprights growth ln_develop ln_trade ln_urban fuelore spending femlife polityb durable kaopen ln_aggstock F.worldflows if year>1993&year<2005&oecd==0, pairwise corr(ar1)			
				
		esttab est1 est2 est3 est4 using fdi_shaming_BITSnSTUFF.tex, se title(FDI Flows -- All Countires) label nogaps order(hrnc2gcnc2 physint instability_mag int_proprights kaopen wtomemberdummy bitsumoecd pta_cuml) star(* 0.1 ** 0.05 *** 0.01) replace
		
				                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
