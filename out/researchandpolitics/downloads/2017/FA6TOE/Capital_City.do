



use Capital_City_Final.dta, clear

 

**Table 1



logit civtot_dummy capital_notbigest total_pop ethfrac percenturban western nafrme eeurop lamerica ssafrica asia Oil elevdiff biggestcity_pop gdppc area 

estimates store Model1

nbreg count_civtot capital_notbigest total_pop ethfrac percenturban western nafrme eeurop lamerica ssafrica asia Oil elevdiff biggestcity_pop gdppc area 

estimates store Model2

logit civtot_dummy capital_notbigest total_pop ethfrac percenturban western nafrme eeurop lamerica ssafrica asia Oil elevdiff biggestcity_pop gdppc area if reduced_sample_remove == 0

estimates store Model3

nbreg count_civtot capital_notbigest total_pop ethfrac percenturban western nafrme eeurop lamerica ssafrica asia Oil elevdiff biggestcity_pop gdppc area if reduced_sample_remove == 0

estimates store Model4

estout Model1 Model2 Model3 Model4, cells(b(star fmt(%9.3f)) se(par)) starlevels(+ 0.10 * 0.05 ** 0.01) stats(N r2, fmt(%9.0g %9.3f)) label collabels("") varlabels(_cons Constant) varwidth(15) modelwidth(10) prefoot("") postfoot("") legend style(tex) replace 



**Table 2



logit dummyviol_or_nonviol capital_notbigest total_pop ethfrac percenturban western eeurop lamerica ssafrica asia Oil elevdiff biggestcity_pop  gdppc area  
estimates store Model1 

nbreg count_viol_or_nonviol capital_notbigest total_pop ethfrac percenturban western eeurop lamerica ssafrica asia Oil elevdiff biggestcity_pop  gdppc area 
estimates store Model2

logit dummyviol_or_nonviol capital_notbigest total_pop ethfrac percenturban western eeurop lamerica ssafrica asia Oil elevdiff biggestcity_pop  gdppc area   if reduced_sample_remove == 0
estimates store Model3

nbreg count_viol_or_nonviol capital_notbigest total_pop ethfrac percenturban western eeurop lamerica ssafrica asia Oil elevdiff biggestcity_pop  gdppc area  if reduced_sample_remove == 0
estimates store Model4

estout Model1 Model2 Model3 Model4, cells(b(star fmt(%9.2f)) se(par)) starlevels(+ 0.10 * 0.05 ** 0.01) stats(N r2, fmt(%9.0g %9.3f)) label collabels("") varlabels(_cons Constant) varwidth(15) modelwidth(10) prefoot("") postfoot("") legend style(tex) replace 


**Table 3

logit non_viol_conf_dummy capital_notbigest total_pop ethfrac percenturban western eeurop lamerica ssafrica asia Oil elevdiff biggestcity_pop  gdppc area 
estimates store Model1

logit viol_conf_dummy capital_notbigest  total_pop ethfrac percenturban western eeurop lamerica ssafrica asia Oil elevdiff biggestcity_pop  gdppc area 

estimates store Model2 


estout Model1 Model2, cells(b(star fmt(%9.2f)) se(par)) starlevels(+ 0.10 * 0.05 ** 0.01) stats(N r2, fmt(%9.0g %9.3f)) label collabels("") varlabels(_cons Constant) varwidth(15) modelwidth(10) prefoot("") postfoot("") legend style(tex) replace 




**Table 4 (Appendix)


logit UCDP_Conflict_Dummy capital_notbigest total_pop ethfrac percenturban western eeurop lamerica ssafrica asia Oil elevdiff biggestcity_pop  gdppc area  
estimates store Model1 

nbreg UCDP_Conflict_Count capital_notbigest total_pop ethfrac percenturban western eeurop lamerica ssafrica asia Oil elevdiff biggestcity_pop  gdppc area 
estimates store Model2

logit UCDP_Conflict_Dummy capital_notbigest total_pop ethfrac percenturban western eeurop lamerica ssafrica asia Oil elevdiff biggestcity_pop  gdppc area   if reduced_sample_remove == 0
estimates store Model3

nbreg UCDP_Conflict_Count capital_notbigest total_pop ethfrac percenturban western eeurop lamerica ssafrica asia Oil elevdiff biggestcity_pop  gdppc area  if reduced_sample_remove == 0
estimates store Model4

estout Model1 Model2 Model3 Model4, cells(b(star fmt(%9.2f)) se(par)) starlevels(+ 0.10 * 0.05 ** 0.01) stats(N r2, fmt(%9.0g %9.3f)) label collabels("") varlabels(_cons Constant) varwidth(15) modelwidth(10) prefoot("") postfoot("") legend style(tex) replace 






end 




















