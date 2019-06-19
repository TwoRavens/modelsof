*This program defines the treatments and their associated parameters, as well as the 
*estimation methods used
*set trace on

*Values taken by each treatment
if ("${treat}"=="q3_hm${dist}_sqcgr") {
   
   global vt 1 2 3
   global tnam q3sqc
}

*Global of lower and upper bound of coefficient for the calculation of confidence intervals         
global chigh = 300         
global clow = 0         

*Dropping observations with missing values           
if "${minstr1}"~="" {         
   qui drop if ${minstr1}>=.          
}         

*First monotone instrument values, when the instruments is a quantile
if "${minstr1}"~="" {         
   
   qui levelsof ${minstr1}
   global mvi1 `r(levels)'
}

*Counting number of values for the treatment and the instruments
global vtn: word count ${vt}
global vtn2 = ${vtn} - 1

*Global for calculating results at the mean
global meanact = 1

*Global of statistics to be calculated
global stat m
global stat_n: word count ${stat}

