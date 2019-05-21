*##=================================================================================================##*
*## Replication File 																				##*	
*## "Resist to Commit: Concrete Campaign Commitments and the Need to Clarify a Partisan Reputation" ##*
*## Journal of Politics, Forthcoming.																##*
*## Authors: Eichorst and Lin 																		##*
*## Date: 2017.11.22																				##*
*##=================================================================================================##*

use "EL_JOP_RepData.dta"

/* Note: 1. See "EL_JOP_AppendixFile.R" for the validation test in Appendix A1.
		 2. For interested readers, please contact the authors for more details about the data generating process. 
*/


*###=======================###
*## Main Table and Figures ###
*###=======================###

*## (1) Table 2 	
		
	global ctrlm1 i.periodincumb##c.gdpgrowthcpdsT1 i.ctryID
	global ctrlm2 c.period_govduration_cabinet##c.gdpgrowthcpdsT1 i.ctryID
	global ctrlm3 i.period_pmincumb##c.gdpgrowthcpdsT1 i.period_onlycabincumb##c.gdpgrowthcpdsT1 i.ctryID
	global ctrlm4 i.periodincumb##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche i.ctryID
	global ctrlm5 c.period_govduration_cabinet##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche i.ctryID	
	global ctrlm6 i.period_pmincumb##c.gdpgrowthcpdsT1 i.period_onlycabincumb##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche i.ctryID
	
	local a = 1
	foreach ctrl in "$ctrlm1" "$ctrlm2" "$ctrlm3" "$ctrlm4" "$ctrlm5" "$ctrlm6" {		
			
		glm stdConW1 `ctrl', link(logit) family(binomial) robust nolog
		est store m`a'
		local a = `a' + 1
		}
	
	esttab m1 m2 m3 m4 m5 m6, b(%10.3f) se scalars (N ll) star(+ 0.10 * 0.05 ** 0.01) noomitted /*
		*/ keep(1.periodincumb period_govduration_cabinet 1.period_pmincumb 1.period_onlycabincumb gdpgrowthcpdsT1 /*
		*/ 		1.period_pmincumb#c.gdpgrowthcpdsT1 1.period_onlycabincumb#c.gdpgrowthcpdsT1 1.periodincumb#c.gdpgrowthcpdsT1 /* 
		*/		c.period_govduration_cabinet#c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche 2.ctryID 3.ctryID 4.ctryID 5.ctryID 6.ctryID _cons) /*
		*/ order(1.periodincumb period_govduration_cabinet 1.period_pmincumb 1.period_onlycabincumb gdpgrowthcpdsT1 /*
		*/ 		1.period_pmincumb#c.gdpgrowthcpdsT1 1.period_onlycabincumb#c.gdpgrowthcpdsT1 1.periodincumb#c.gdpgrowthcpdsT1 /* 
		*/		c.period_govduration_cabinet#c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche 2.ctryID 3.ctryID 4.ctryID 5.ctryID 6.ctryID _cons) /*
		*/ coeflabels(1.periodincumb "Incumbent Party" gdpgrowthcpdsT1 "Economic Performance" period_govduration_cabinet "Governing Duration" /*
		*/ 1.periodincumb#c.gdpgrowthcpdsT1 "Incumbent * Economy"  c.period_govduration_cabinet#c.gdpgrowthcpdsT1 "Duration * Economy"/*
		*/ 1.period_pmincumb#c.gdpgrowthcpdsT1 "PM * Economy"  1.period_onlycabincumb#c.gdpgrowthcpdsT1 "Partner * Economy"/*
		*/ 1.period_pmincumb "PM" 1.period_onlycabincumb "Partner" /*
		*/ partypolar "Party Polarization" priorRVS "Previous Performance" lnAge "Party Age" niche "Niche Party" 2.ctryID "Canada" 3.ctryID "UK" /*
		*/ 4.ctryID "Ireland" 5.ctryID "New Zealand" 6.ctryID "US" _cons "Constant") 	

		

*## (2) Figure 1: Substantive Effect for Incumbent X Economy
	
	fracreg logit stdConW1 i.periodincumb##c.gdpgrowthcpdsT1 partypolar lnAge niche priorRVS ctry2-ctry6
	generate sample1 = e(sample)
	sum gdpgrowthcpdsT1 if sample1 == 1
	
	*## Effect of Economy on Incumbent 
	set more off 
	margins, over(periodincumb) at(gdpgrowthcpdsT1=(-5(.2)12)) level(90)
	marginsplot, xtitle(Economic Performance (GDP Growth Rate)) /// 
		ytitle(Predicted Manifesto Concreteness) ///
		legend(label(1 "Incumbent") label(2 "Opposition")) ///
		title("",size(samll))

	

*## (3) Figure 2: Marginal Effect for Duration X Economy
	
	fracreg logit stdConW1 c.period_govduration_cabinet##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche ctry2-ctry6
	generate sample2 = e(sample)
	sum period_govduration_cabinet if sample2 == 1, de

	*## Effect of Economy on Duration 
	set more off 
	margins, at(period_govduration_cabinet =(0(2)62) gdpgrowthcpdsT1=(-.07, 6.49)) level(90)
	marginsplot, xtitle(Governing Duration (months)) /// 
		ytitle(Predicted Manifesto Concreteness) ///
		legend(label(1 "Low Growth") label(2 "High Growth")) ///
		title("",size(samll))
	

	
*## (4) Figure 3: Marginal Effect for PM, JM, Opp X Economy
	
	gen newInc = periodincumb
		replace newInc = 1 if period_onlycabincumb == 1
		replace newInc = 2 if period_pmincumb == 1
		
	fracreg logit stdConW1 i.newInc##c.gdpgrowthcpdsT1 partypolar lnAge  priorRVS ctry2-ctry6  // Full Sample
	
	margins, dydx(gdpgrowthcpdsT1) at(newInc=(0(1)2)) level(90)
	marginsplot, yline(0)


	
*###=========================================================================================================================================


*###=========###
*## Appendix ###
*###=========###

*## (1) Table B1: Models with the Balanced DV
  
	global ctrlm1 i.periodincumb##c.gdpgrowthcpdsT1 i.ctryID
	global ctrlm2 c.period_govduration_cabinet##c.gdpgrowthcpdsT1 i.ctryID
	global ctrlm3 i.period_pmincumb##c.gdpgrowthcpdsT1 i.period_onlycabincumb##c.gdpgrowthcpdsT1 i.ctryID
	global ctrlm4 i.periodincumb##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche i.ctryID
	global ctrlm5 c.period_govduration_cabinet##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche i.ctryID	
	global ctrlm6 i.period_pmincumb##c.gdpgrowthcpdsT1 i.period_onlycabincumb##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche i.ctryID
	
	set more off
	local a = 1
		foreach ctrl in "$ctrlm1" "$ctrlm2" "$ctrlm3" "$ctrlm4" "$ctrlm5" "$ctrlm6"{		
			
			glm stdConW2 `ctrl', link(logit) family(binomial) robust nolog
			est store m`a'
			local a = `a' + 1
		}
	
		
	esttab m1 m2 m3 m4 m5 m6, b(%10.3f) se scalars (N ll) star(+ 0.10 * 0.05 ** 0.01) noomitted /*
		*/ keep(1.periodincumb period_govduration_cabinet 1.period_pmincumb 1.period_onlycabincumb gdpgrowthcpdsT1 /*
		*/ 		1.period_pmincumb#c.gdpgrowthcpdsT1 1.period_onlycabincumb#c.gdpgrowthcpdsT1 1.periodincumb#c.gdpgrowthcpdsT1 /* 
		*/		c.period_govduration_cabinet#c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche _cons) /*
		*/ order(1.periodincumb period_govduration_cabinet 1.period_pmincumb 1.period_onlycabincumb gdpgrowthcpdsT1 /*
		*/ 		1.period_pmincumb#c.gdpgrowthcpdsT1 1.period_onlycabincumb#c.gdpgrowthcpdsT1 1.periodincumb#c.gdpgrowthcpdsT1 /* 
		*/		c.period_govduration_cabinet#c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche _cons) /*
		*/ coeflabels(1.periodincumb "Incumbent Party" gdpgrowthcpdsT1 "Economic Performance" period_govduration_cabinet "Governing Duration" /*
		*/ 1.periodincumb#c.gdpgrowthcpdsT1 "Incumbent * Performance"  c.period_govduration_cabinet#c.gdpgrowthcpdsT1 "Duration * Performance"/*
		*/ 1.period_pmincumb#c.gdpgrowthcpdsT1 "PM * Performance"  1.period_onlycabincumb#c.gdpgrowthcpdsT1 "Partner * Performance"/*
		*/ 1.period_pmincumb "PM" 1.period_onlycabincumb "Partner" /*
		*/ partypolar "Party Polarization" priorRVS "Previous Electoral Outcomes" lnAge "Party Age" niche "Niche Party" _cons "Constant") 	
	
	
*## (2) Table B2: New DV that removes "all" and "or"
	
	global ctrlm1 i.periodincumb##c.gdpgrowthcpdsT1 i.ctryID
	global ctrlm2 c.period_govduration_cabinet##c.gdpgrowthcpdsT1 i.ctryID
	global ctrlm3 i.period_pmincumb##c.gdpgrowthcpdsT1 i.period_onlycabincumb##c.gdpgrowthcpdsT1 i.ctryID
	global ctrlm4 i.periodincumb##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche i.ctryID
	global ctrlm5 c.period_govduration_cabinet##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche i.ctryID	
	global ctrlm6 i.period_pmincumb##c.gdpgrowthcpdsT1 i.period_onlycabincumb##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche i.ctryID
	
	local a = 1
	foreach ctrl in "$ctrlm1" "$ctrlm2" "$ctrlm3" "$ctrlm4" "$ctrlm5" "$ctrlm6" {		
			
		glm stdConW3 `ctrl', link(logit) family(binomial) robust nolog
		est store m`a'
		local a = `a' + 1
		}
	

	esttab m1 m2 m3 m4 m5 m6, b(%10.3f) se scalars (N ll) star(+ 0.10 * 0.05 ** 0.01) noomitted /*
		*/ keep(1.periodincumb period_govduration_cabinet 1.period_pmincumb 1.period_onlycabincumb gdpgrowthcpdsT1 /*
		*/ 		1.period_pmincumb#c.gdpgrowthcpdsT1 1.period_onlycabincumb#c.gdpgrowthcpdsT1 1.periodincumb#c.gdpgrowthcpdsT1 /* 
		*/		c.period_govduration_cabinet#c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche _cons) /*
		*/ order(1.periodincumb period_govduration_cabinet 1.period_pmincumb 1.period_onlycabincumb gdpgrowthcpdsT1 /*
		*/ 		1.period_pmincumb#c.gdpgrowthcpdsT1 1.period_onlycabincumb#c.gdpgrowthcpdsT1 1.periodincumb#c.gdpgrowthcpdsT1 /* 
		*/		c.period_govduration_cabinet#c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche _cons) /*
		*/ coeflabels(1.periodincumb "Incumbent Party" gdpgrowthcpdsT1 "Economic Performance" period_govduration_cabinet "Governing Duration" /*
		*/ 1.periodincumb#c.gdpgrowthcpdsT1 "Incumbent * Economy"  c.period_govduration_cabinet#c.gdpgrowthcpdsT1 "Duration * Economy"/*
		*/ 1.period_pmincumb#c.gdpgrowthcpdsT1 "PM * Economy"  1.period_onlycabincumb#c.gdpgrowthcpdsT1 "Partner * Economy"/*
		*/ 1.period_pmincumb "PM" 1.period_onlycabincumb "Partner" /*
		*/ partypolar "Party Polarization" priorRVS "Previous Performance" lnAge "Party Age" niche "Niche Party" _cons "Constant") 	
	

*## (3) Table B3: Sentence as DV
	
	global ctrlm1 i.periodincumb##c.gdpgrowthcpdsT1 i.ctryID
	global ctrlm2 c.period_govduration_cabinet##c.gdpgrowthcpdsT1 i.ctryID
	global ctrlm3 i.period_pmincumb##c.gdpgrowthcpdsT1 i.period_onlycabincumb##c.gdpgrowthcpdsT1 i.ctryID
	global ctrlm4 i.periodincumb##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche i.ctryID
	global ctrlm5 c.period_govduration_cabinet##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche i.ctryID	
	global ctrlm6 i.period_pmincumb##c.gdpgrowthcpdsT1 i.period_onlycabincumb##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche i.ctryID
	
	local a = 1
	foreach ctrl in "$ctrlm1" "$ctrlm2" "$ctrlm3" "$ctrlm4" "$ctrlm5" "$ctrlm6" {		
			
		glm stdConS3 `ctrl', link(logit) family(binomial) robust nolog
		est store m`a'
		local a = `a' + 1
		}
	

	esttab m1 m2 m3 m4 m5 m6, b(%10.3f) se scalars (N ll) star(+ 0.10 * 0.05 ** 0.01) noomitted /*
		*/ keep(1.periodincumb period_govduration_cabinet 1.period_pmincumb 1.period_onlycabincumb gdpgrowthcpdsT1 /*
		*/ 		1.period_pmincumb#c.gdpgrowthcpdsT1 1.period_onlycabincumb#c.gdpgrowthcpdsT1 1.periodincumb#c.gdpgrowthcpdsT1 /* 
		*/		c.period_govduration_cabinet#c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche 2.ctryID 3.ctryID 4.ctryID 5.ctryID 6.ctryID _cons) /*
		*/ order(1.periodincumb period_govduration_cabinet 1.period_pmincumb 1.period_onlycabincumb gdpgrowthcpdsT1 /*
		*/ 		1.period_pmincumb#c.gdpgrowthcpdsT1 1.period_onlycabincumb#c.gdpgrowthcpdsT1 1.periodincumb#c.gdpgrowthcpdsT1 /* 
		*/		c.period_govduration_cabinet#c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche 2.ctryID 3.ctryID 4.ctryID 5.ctryID 6.ctryID _cons) /*
		*/ coeflabels(1.periodincumb "Incumbent Party" gdpgrowthcpdsT1 "Economic Performance" period_govduration_cabinet "Governing Duration" /*
		*/ 1.periodincumb#c.gdpgrowthcpdsT1 "Incumbent * Economy"  c.period_govduration_cabinet#c.gdpgrowthcpdsT1 "Duration * Economy"/*
		*/ 1.period_pmincumb#c.gdpgrowthcpdsT1 "PM * Economy"  1.period_onlycabincumb#c.gdpgrowthcpdsT1 "Partner * Economy"/*
		*/ 1.period_pmincumb "PM" 1.period_onlycabincumb "Partner" /*
		*/ partypolar "Party Polarization" priorRVS "Previous Performance" lnAge "Party Age" niche "Niche Party"_cons "Constant") 	
		
	
*## (4) Table B4: Sentence and Words as DV
	
	global ctrlm1 i.periodincumb##c.gdpgrowthcpdsT1 i.ctryID
	global ctrlm2 c.period_govduration_cabinet##c.gdpgrowthcpdsT1 i.ctryID
	global ctrlm3 i.period_pmincumb##c.gdpgrowthcpdsT1 i.period_onlycabincumb##c.gdpgrowthcpdsT1 i.ctryID
	global ctrlm4 i.periodincumb##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche i.ctryID
	global ctrlm5 c.period_govduration_cabinet##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche i.ctryID	
	global ctrlm6 i.period_pmincumb##c.gdpgrowthcpdsT1 i.period_onlycabincumb##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche i.ctryID
	
	local a = 1
	foreach ctrl in "$ctrlm1" "$ctrlm2" "$ctrlm3" "$ctrlm4" "$ctrlm5" "$ctrlm6" {		
			
		glm stdConS5 `ctrl', link(logit) family(binomial) robust nolog
		est store m`a'
		local a = `a' + 1
		}
	

	esttab m1 m2 m3 m4 m5 m6, b(%10.3f) se scalars (N ll) star(+ 0.10 * 0.05 ** 0.01) noomitted /*
		*/ keep(1.periodincumb period_govduration_cabinet 1.period_pmincumb 1.period_onlycabincumb gdpgrowthcpdsT1 /*
		*/ 		1.period_pmincumb#c.gdpgrowthcpdsT1 1.period_onlycabincumb#c.gdpgrowthcpdsT1 1.periodincumb#c.gdpgrowthcpdsT1 /* 
		*/		c.period_govduration_cabinet#c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche 2.ctryID 3.ctryID 4.ctryID 5.ctryID 6.ctryID _cons) /*
		*/ order(1.periodincumb period_govduration_cabinet 1.period_pmincumb 1.period_onlycabincumb gdpgrowthcpdsT1 /*
		*/ 		1.period_pmincumb#c.gdpgrowthcpdsT1 1.period_onlycabincumb#c.gdpgrowthcpdsT1 1.periodincumb#c.gdpgrowthcpdsT1 /* 
		*/		c.period_govduration_cabinet#c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche 2.ctryID 3.ctryID 4.ctryID 5.ctryID 6.ctryID _cons) /*
		*/ coeflabels(1.periodincumb "Incumbent Party" gdpgrowthcpdsT1 "Economic Performance" period_govduration_cabinet "Governing Duration" /*
		*/ 1.periodincumb#c.gdpgrowthcpdsT1 "Incumbent * Economy"  c.period_govduration_cabinet#c.gdpgrowthcpdsT1 "Duration * Economy"/*
		*/ 1.period_pmincumb#c.gdpgrowthcpdsT1 "PM * Economy"  1.period_onlycabincumb#c.gdpgrowthcpdsT1 "Partner * Economy"/*
		*/ 1.period_pmincumb "PM" 1.period_onlycabincumb "Partner" /*
		*/ partypolar "Party Polarization" priorRVS "Previous Performance" lnAge "Party Age" niche "Niche Party"_cons "Constant") 	
	
	
*## (5) Table B5: Models using Sequence Incumbent
   
	global ctrlm1 i.seqincumb##c.gdpgrowthcpdsT1 i.ctryID
	global ctrlm2 c.seq_govduration_cabinet##c.gdpgrowthcpdsT1 i.ctryID
	global ctrlm3 i.seq_pmincumb##c.gdpgrowthcpdsT1 i.seq_onlycabincumb##c.gdpgrowthcpdsT1 i.ctryID
	global ctrlm4 i.seqincumb##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche i.ctryID
	global ctrlm5 c.seq_govduration_cabinet##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche i.ctryID	
	global ctrlm6 i.seq_pmincumb##c.gdpgrowthcpdsT1 i.seq_onlycabincumb##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche i.ctryID
	
   
	set more off
	local a = 1
		foreach ctrl in "$ctrlm1" "$ctrlm2" "$ctrlm3" "$ctrlm4" "$ctrlm5" "$ctrlm6"{		
			
			glm stdConW1 `ctrl', link(logit) family(binomial) robust nolog
			est store m`a'
			local a = `a' + 1
		}
	
 
	esttab m1 m2 m3 m4 m5 m6, b(%10.3f) se scalars (N ll) star(+ 0.10 * 0.05 ** 0.01) noomitted /*
		*/ keep(1.seqincumb seq_govduration_cabinet 1.seq_pmincumb 1.seq_onlycabincumb gdpgrowthcpdsT1 /*
		*/ 		1.seq_pmincumb#c.gdpgrowthcpdsT1 1.seq_onlycabincumb#c.gdpgrowthcpdsT1 1.seqincumb#c.gdpgrowthcpdsT1 /* 
		*/		c.seq_govduration_cabinet#c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche _cons) /*
		*/ order(1.seqincumb seq_govduration_cabinet 1.seq_pmincumb 1.seq_onlycabincumb gdpgrowthcpdsT1 /*
		*/ 		1.seq_pmincumb#c.gdpgrowthcpdsT1 1.seq_onlycabincumb#c.gdpgrowthcpdsT1 1.seqincumb#c.gdpgrowthcpdsT1 /* 
		*/		c.seq_govduration_cabinet#c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche _cons) /*
		*/ coeflabels(1.seqincumb "Incumbent Party" gdpgrowthcpdsT1 "Economic Performance" seq_govduration_cabinet "Governing Duration" /*
		*/ 1.seqincumb#c.gdpgrowthcpdsT1 "Incumbent * Performance"  c.seq_govduration_cabinet#c.gdpgrowthcpdsT1 "Duration * Performance"/*
		*/ 1.seq_pmincumb#c.gdpgrowthcpdsT1 "PM * Performance"  1.seq_onlycabincumb#c.gdpgrowthcpdsT1 "Partner * Performance"/*
		*/ 1.seq_pmincumb "PM" 1.seq_onlycabincumb "Partner" /*
		*/ partypolar "Party Polarization" priorRVS "Previous Electoral Outcomes" lnAge "Party Age" niche "Niche Party" _cons "Constant") 	
	
  
*## (6) Table B6: OLS Models with the Raw Concreteness
   
	global ctrlm1 i.periodincumb##c.gdpgrowthcpdsT1 i.ctryID
	global ctrlm2 c.period_govduration_cabinet##c.gdpgrowthcpdsT1 i.ctryID
	global ctrlm3 i.period_pmincumb##c.gdpgrowthcpdsT1 i.period_onlycabincumb##c.gdpgrowthcpdsT1 i.ctryID
	global ctrlm4 i.periodincumb##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche i.ctryID
	global ctrlm5 c.period_govduration_cabinet##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche i.ctryID	
	global ctrlm6 i.period_pmincumb##c.gdpgrowthcpdsT1 i.period_onlycabincumb##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche i.ctryID
	
  
  	set more off
	local a = 1
		foreach ctrl in "$ctrlm1" "$ctrlm2" "$ctrlm3" "$ctrlm4" "$ctrlm5" "$ctrlm6"{		
			
			reg concreteW1 `ctrl', robust
			est store m`a'
			local a = `a' + 1
		}
	
	
	esttab m1 m2 m3 m4 m5 m6, b(%10.3f) se scalars (N ll) star(+ 0.10 * 0.05 ** 0.01) noomitted /*
		*/ keep(1.periodincumb period_govduration_cabinet 1.period_pmincumb 1.period_onlycabincumb gdpgrowthcpdsT1 /*
		*/ 		1.period_pmincumb#c.gdpgrowthcpdsT1 1.period_onlycabincumb#c.gdpgrowthcpdsT1 1.periodincumb#c.gdpgrowthcpdsT1 /* 
		*/		c.period_govduration_cabinet#c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche _cons) /*
		*/ order(1.periodincumb period_govduration_cabinet 1.period_pmincumb 1.period_onlycabincumb gdpgrowthcpdsT1 /*
		*/ 		1.period_pmincumb#c.gdpgrowthcpdsT1 1.period_onlycabincumb#c.gdpgrowthcpdsT1 1.periodincumb#c.gdpgrowthcpdsT1 /* 
		*/		c.period_govduration_cabinet#c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche _cons) /*
		*/ coeflabels(1.periodincumb "Incumbent Party" gdpgrowthcpdsT1 "Economic Performance" period_govduration_cabinet "Governing Duration" /*
		*/ 1.periodincumb#c.gdpgrowthcpdsT1 "Incumbent * Performance"  c.period_govduration_cabinet#c.gdpgrowthcpdsT1 "Duration * Performance"/*
		*/ 1.period_pmincumb#c.gdpgrowthcpdsT1 "PM * Performance"  1.period_onlycabincumb#c.gdpgrowthcpdsT1 "Partner * Performance"/*
		*/ 1.period_pmincumb "PM" 1.period_onlycabincumb "Partner" /*
		*/ partypolar "Party Polarization" priorRVS "Previous Electoral Outcomes" lnAge "Party Age" niche "Niche Party" _cons "Constant") 	

		
 *## (7) Table B8: Models with country-election fixed effect
		
	global ctrlm1 i.periodincumb##c.gdpgrowthcpdsT1 i.ctryElectID
	global ctrlm2 c.period_govduration_cabinet##c.gdpgrowthcpdsT1 i.ctryElectID
	global ctrlm3 i.period_pmincumb##c.gdpgrowthcpdsT1 i.period_onlycabincumb##c.gdpgrowthcpdsT1 i.ctryElectID
	global ctrlm4 i.periodincumb##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche i.ctryElectID
	global ctrlm5 c.period_govduration_cabinet##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche i.ctryElectID	
	global ctrlm6 i.period_pmincumb##c.gdpgrowthcpdsT1 i.period_onlycabincumb##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche i.ctryElectID
	
	local a = 1
	foreach ctrl in "$ctrlm1" "$ctrlm2" "$ctrlm3" "$ctrlm4" "$ctrlm5" "$ctrlm6" {		
			
		glm stdConW1 `ctrl', link(logit) family(binomial) robust nolog
		est store m`a'
		local a = `a' + 1
		}
	
	
	esttab m1 m2 m3 m4 m5 m6, b(%10.3f) se scalars (N ll) star(+ 0.10 * 0.05 ** 0.01) noomitted /*
		*/ keep(1.periodincumb period_govduration_cabinet 1.period_pmincumb 1.period_onlycabincumb gdpgrowthcpdsT1 /*
		*/ 		1.period_pmincumb#c.gdpgrowthcpdsT1 1.period_onlycabincumb#c.gdpgrowthcpdsT1 1.periodincumb#c.gdpgrowthcpdsT1 /* 
		*/		c.period_govduration_cabinet#c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche _cons) /*
		*/ order(1.periodincumb period_govduration_cabinet 1.period_pmincumb 1.period_onlycabincumb gdpgrowthcpdsT1 /*
		*/ 		1.period_pmincumb#c.gdpgrowthcpdsT1 1.period_onlycabincumb#c.gdpgrowthcpdsT1 1.periodincumb#c.gdpgrowthcpdsT1 /* 
		*/		c.period_govduration_cabinet#c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche _cons) /*
		*/ coeflabels(1.periodincumb "Incumbent Party" gdpgrowthcpdsT1 "Economic Performance" period_govduration_cabinet "Governing Duration" /*
		*/ 1.periodincumb#c.gdpgrowthcpdsT1 "Incumbent * Economy"  c.period_govduration_cabinet#c.gdpgrowthcpdsT1 "Duration * Economy"/*
		*/ 1.period_pmincumb#c.gdpgrowthcpdsT1 "PM * Economy"  1.period_onlycabincumb#c.gdpgrowthcpdsT1 "Partner * Economy"/*
		*/ 1.period_pmincumb "PM" 1.period_onlycabincumb "Partner" /*
		*/ partypolar "Party Polarization" priorRVS "Previous Performance" lnAge "Party Age" niche "Niche Party" _cons "Constant") 	

	
 *## (8) Table B9: Models with country and party fixed effect 
		
	global ctrlm1 i.periodincumb##c.gdpgrowthcpdsT1 i.ctryID i. partyID
	global ctrlm2 c.period_govduration_cabinet##c.gdpgrowthcpdsT1 i.ctryID i. partyID
	global ctrlm3 i.period_pmincumb##c.gdpgrowthcpdsT1 i.period_onlycabincumb##c.gdpgrowthcpdsT1 i.ctryID i. partyID
	global ctrlm4 i.periodincumb##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche i.ctryID i. partyID
	global ctrlm5 c.period_govduration_cabinet##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche i.ctryID i. partyID
	global ctrlm6 i.period_pmincumb##c.gdpgrowthcpdsT1 i.period_onlycabincumb##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche i.ctryID i. partyID
	
	local a = 1
	foreach ctrl in "$ctrlm1" "$ctrlm2" "$ctrlm3" "$ctrlm4" "$ctrlm5" "$ctrlm6" {		
			
		glm stdConW1 `ctrl', link(logit) family(binomial) robust nolog
		est store m`a'
		local a = `a' + 1
		}
	
	
	esttab m1 m2 m3 m4 m5 m6, b(%10.3f) se scalars (N ll) star(+ 0.10 * 0.05 ** 0.01) noomitted /*
		*/ keep(1.periodincumb period_govduration_cabinet 1.period_pmincumb 1.period_onlycabincumb gdpgrowthcpdsT1 /*
		*/ 		1.period_pmincumb#c.gdpgrowthcpdsT1 1.period_onlycabincumb#c.gdpgrowthcpdsT1 1.periodincumb#c.gdpgrowthcpdsT1 /* 
		*/		c.period_govduration_cabinet#c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche _cons) /*
		*/ order(1.periodincumb period_govduration_cabinet 1.period_pmincumb 1.period_onlycabincumb gdpgrowthcpdsT1 /*
		*/ 		1.period_pmincumb#c.gdpgrowthcpdsT1 1.period_onlycabincumb#c.gdpgrowthcpdsT1 1.periodincumb#c.gdpgrowthcpdsT1 /* 
		*/		c.period_govduration_cabinet#c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche _cons) /*
		*/ coeflabels(1.periodincumb "Incumbent Party" gdpgrowthcpdsT1 "Economic Performance" period_govduration_cabinet "Governing Duration" /*
		*/ 1.periodincumb#c.gdpgrowthcpdsT1 "Incumbent * Economy"  c.period_govduration_cabinet#c.gdpgrowthcpdsT1 "Duration * Economy"/*
		*/ 1.period_pmincumb#c.gdpgrowthcpdsT1 "PM * Economy"  1.period_onlycabincumb#c.gdpgrowthcpdsT1 "Partner * Economy"/*
		*/ 1.period_pmincumb "PM" 1.period_onlycabincumb "Partner" /*
		*/ partypolar "Party Polarization" priorRVS "Previous Performance" lnAge "Party Age" niche "Niche Party" _cons "Constant") 	
	
  
  *## (9) Table B10: Robustness checks by dropping one country out of the sample one at a time.
  
	global ctrl i.periodincumb##c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche i.ctryID
	
	set more off
	local a = 1
		forvalues i = 1/6{		
		
		glm stdConW1 $ctrl if ctryID!= `i', link(logit) family(binomial) robust nolo
		est store m`a'
		local a = `a' + 1
		}
		
	esttab m1 m2 m3 m4 m5 m6, b(%10.3f) se scalars (N ll) star(+ 0.10 * 0.05 ** 0.01) noomitted /*
		*/ keep(1.periodincumb gdpgrowthcpdsT1 1.period_pmincumb#c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche _cons) /*
		*/ order(1.periodincumb gdpgrowthcpdsT1 1.period_pmincumb#c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche _cons) /*
		*/ coeflabels(1.periodincumb "Incumbent Party" gdpgrowthcpdsT1 "Economic Performance" 1.periodincumb#c.gdpgrowthcpdsT1 "Incumbent * Performance" /*
		*/ partypolar "Party Polarization" priorRVS "Previous Electoral Outcomes" lnAge "Party Age" niche "Niche Party" _cons "Constant") 	
	

*## (10) Table B11: Robustness checks using countries with frequent coalition governments 
  
	global ctrlm2 i.period_pmincumb##c.gdpgrowthcpdsT1 i.period_onlycabincumb##c.gdpgrowthcpdsT1 i.ctryID
	global ctrlm6 i.period_pmincumb##c.gdpgrowthcpdsT1 i.period_onlycabincumb##c.gdpgrowthcpdsT1 partypolar lnAge niche priorRVS i.ctryID
	
	set more off
	local a = 1
		foreach ctrl in "$ctrlm2" "$ctrlm6"{		
			
		glm stdConW1 `ctrl' if ctryID!= 2 & ctryID!= 3 & ctryID!= 6, link(logit) family(binomial) robust nolo
		est store m`a'
		local a = `a' + 1
		}

	esttab m1 m2, b(%10.3f) se scalars (N ll) star(+ 0.10 * 0.05 ** 0.01) /*
		*/ keep(1.period_pmincumb gdpgrowthcpdsT1 1.period_pmincumb#c.gdpgrowthcpdsT1 1.period_onlycabincumb 1.period_onlycabincumb#c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche _cons) /*
		*/ order(1.period_pmincumb gdpgrowthcpdsT1 1.period_pmincumb#c.gdpgrowthcpdsT1 1.period_onlycabincumb 1.period_onlycabincumb#c.gdpgrowthcpdsT1 partypolar priorRVS lnAge niche _cons) /*
		*/ coeflabels(1.period_pmincumb "PM" gdpgrowthcpdsT1 "Economic Performance" 1.period_pmincumb#c.gdpgrowthcpdsT1 "PM * Performance" 1.period_onlycabincumb#c.gdpgrowthcpdsT1 "Partner * Performance" /*
		*/ partypolar "Party Polarization" priorRVS "Previous Electoral Outcomes" lnAge "Party Age" niche "Niche Party" _cons "Constant") 	
	
	

*## (11) Table C1: Additional Explanation
		
	global ctrlm1 i.periodincumb##c.gdpgrowthcpdsT1 effnv elecvola i.ctryID
	global ctrlm2 c.period_govduration_cabinet##c.gdpgrowthcpdsT1 effnv elecvola i.ctryID	
	global ctrlm3 i.period_pmincumb##c.gdpgrowthcpdsT1 i.period_onlycabincumb##c.gdpgrowthcpdsT1 effnv elecvola i.ctryID
	global ctrlm4 i.periodincumb##c.gdpgrowthcpdsT1 effnv elecvola partypolar priorRVS lnAge niche i.ctryID
	global ctrlm5 c.period_govduration_cabinet##c.gdpgrowthcpdsT1 effnv elecvola partypolar priorRVS lnAge niche i.ctryID	
	global ctrlm6 i.period_pmincumb##c.gdpgrowthcpdsT1 i.period_onlycabincumb##c.gdpgrowthcpdsT1 effnv elecvola partypolar priorRVS lnAge niche i.ctryID
	
	local a = 1
	foreach ctrl in "$ctrlm1" "$ctrlm2" "$ctrlm3" "$ctrlm4" "$ctrlm5" "$ctrlm6"  {		
			
		glm stdConW1 `ctrl', link(logit) family(binomial) robust nolog
		est store m`a'
		local a = `a' + 1
		}
	
	esttab m1 m2 m3 m4 m5 m6, b(%10.3f) se scalars (N ll) star(+ 0.10 * 0.05 ** 0.01) noomitted /*
		*/ keep(1.periodincumb period_govduration_cabinet 1.period_pmincumb 1.period_onlycabincumb gdpgrowthcpdsT1 /*
		*/ 		1.period_pmincumb#c.gdpgrowthcpdsT1 1.period_onlycabincumb#c.gdpgrowthcpdsT1 1.periodincumb#c.gdpgrowthcpdsT1 /* 
		*/		c.period_govduration_cabinet#c.gdpgrowthcpdsT1 effnv elecvola partypolar priorRVS lnAge niche 2.ctryID 3.ctryID 4.ctryID 5.ctryID 6.ctryID _cons) /*
		*/ order(1.periodincumb period_govduration_cabinet 1.period_pmincumb 1.period_onlycabincumb gdpgrowthcpdsT1 /*
		*/ 		1.period_pmincumb#c.gdpgrowthcpdsT1 1.period_onlycabincumb#c.gdpgrowthcpdsT1 1.periodincumb#c.gdpgrowthcpdsT1 /* 
		*/		c.period_govduration_cabinet#c.gdpgrowthcpdsT1 effnv elecvola partypolar priorRVS lnAge niche 2.ctryID 3.ctryID 4.ctryID 5.ctryID 6.ctryID _cons) /*
		*/ coeflabels(1.periodincumb "Incumbent Party" gdpgrowthcpdsT1 "Economic Performance" period_govduration_cabinet "Governing Duration" /*
		*/ 1.periodincumb#c.gdpgrowthcpdsT1 "Incumbent * Economy"  c.period_govduration_cabinet#c.gdpgrowthcpdsT1 "Duration * Economy"/*
		*/ 1.period_pmincumb#c.gdpgrowthcpdsT1 "PM * Economy"  1.period_onlycabincumb#c.gdpgrowthcpdsT1 "Partner * Economy" effnv "ENOP" elecvola "Volatility" /*
		*/ partypolar "Party Polarization" priorRVS "Previous Performance" lnAge "Party Age" niche "Niche Party" 2.ctryID "Canada" 3.ctryID "UK" /*
		*/ 1.period_pmincumb "PM" 1.period_onlycabincumb "Partner" /*
		*/ 4.ctryID "Ireland" 5.ctryID "New Zealand" 6.ctryID "US" _cons "Constant") 	
