/*
Replication Materials for
"Economic Competitiveness and Social Policy in Open Economies" 
*/

//STATA 14.2 was used for analyses

xtset id year

/* Table 1 in the Main Manuscript */

//1) Random effects model without an interaction term
xtreg protratio c.rulc c.tropen lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus , re 

//2) Random effects model with an interaction term
xtreg protratio c.rulc##c.tropen lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus , re 

//3) Fixed effects model without an interaction term
xtreg protratio c.rulc c.tropen lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus , fe  
	   
//4) Fixed effects model with an interaction term	  
xtreg protratio c.rulc##c.tropen lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus , fe 
	  
/* 
//Figure 1 
(Figures are based on the random effects model with an interaction term from Table 1)*/
  
xtreg protratio c.rulc##c.tropen lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus , re 
margins, dydx(rulc) at(tropen=(0.5 (0.5) 3.5)) atmean
marginsplot, recast(line) recastci(rarea)


//Figure 2
xtreg protratio c.rulc##c.tropen lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus , re 
margins, at(tropen=(0.5 (0.5) 3.5 ) rulc=(0.2 0.7 1.0)) vsquish
marginsplot, noci x(tropen) recast(line) xlabel(0.5 (0.5) 3.5)


***** Robustness Check
/* From here, codes for robustness checks in Appendices */
// Appendix 1. Data Index
	
// Appendix 2. Robustness Check

// 2-1. Use cluster-robust variance to account for heteroskedasticity and serial correlation
xtreg protratio c.rulc c.tropen lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus , re cluster(cntry)
	  
xtreg protratio c.rulc##c.tropen lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus, re cluster(cntry)

// 2-2. Alternative Measure of Globalizaiton
xtreg protratio c.rulc c.kofglob lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus , re 
	  
xtreg protratio c.rulc##c.kofglob lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus, re 

xtreg protratio c.rulc c.kofglob lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus , fe 
	  
xtreg protratio c.rulc##c.kofglob lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus, fe
  
// 2-3. Lagged RULCs
xtset id year
// 1) One year lag
xtreg protratio c.l.rulc c.tropen lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus, re 
	  
xtreg protratio c.l.rulc##c.tropen lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus, re 

xtreg protratio c.l.rulc c.tropen lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus, fe
	  
xtreg protratio c.l.rulc##c.tropen lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus, fe

// 2) Three year lag
xtreg protratio c.l3.rulc c.tropen lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus, re 
	  
xtreg protratio c.l3.rulc##c.tropen lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus, re 

xtreg protratio c.l3.rulc c.tropen lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus, fe
	  
xtreg protratio c.l3.rulc##c.tropen lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus, fe


// 2-4. Endogeneity problem - Using an Instrumental Variable
xtivreg protratio tropen lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus  (rulc = ivRULC) , re
		
xtivreg protratio tropen lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus  (rulc tropenXrulc = ivRULC tropenXIV) , re

xtivreg protratio tropen lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus  (rulc = ivRULC) , fe
		
xtivreg protratio tropen lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus  (rulc tropenXrulc = ivRULC tropenXIV) , fe
	  
   
// 2-5. Use total social expenditure as DV
xtreg tsocexp_gdp c.rulc c.tropen lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus  , re 
	  
xtreg tsocexp_gdp c.rulc##c.tropen lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus , re 

xtreg tsocexp_gdp c.rulc c.tropen lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus  , fe
	  
xtreg tsocexp_gdp c.rulc##c.tropen lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus , fe
	   
		
// 2-6.Estimate separately according to government's partisanship

// 1) Left-wing gov't
xtreg protratio c.rulc c.tropen taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus if lrpos<0, re
	   
xtreg protratio c.rulc##c.tropen taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus if lrpos<0, re
	   
// 2) Right-wing gov't
xtreg protratio c.rulc c.tropen taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus if lrpos>0 & !missing(lrpos), re

xtreg protratio c.rulc##c.tropen taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus if lrpos>0 & !missing(lrpos), re

	  
// 2-7. Exclude top 5% RULC
xtreg protratio c.rulc c.tropen lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus if rulc<0.80, re 
	  
xtreg protratio c.rulc##c.tropen lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus if rulc<0.80, re 

xtreg protratio c.rulc c.tropen lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus if rulc<0.80, fe 
	  
xtreg protratio c.rulc##c.tropen lrpos taxrev lababun unemprate gdp gini_net ///
       demo unionden deindus if rulc<0.80, fe 
	   

// Appendix 3. Name of Country
