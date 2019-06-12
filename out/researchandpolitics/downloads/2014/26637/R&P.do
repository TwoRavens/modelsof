*********************************************
*Project: English Official					*
*Authors: Liu, Sokhey, Kennedy, and Miller)	*
*Research and Politics					    *
*Date: March 2014                           *
*********************************************


*stset the data
stset count, failure(english) id(snumb)


*graph the baseline hazard in the data, messing with smoothing per Cleves et al. 
sts graph, hazard kernel(epan2) width(6 7)
*this follows Cleves et al. 116-117


*splitting the sample at the mean value of the nyt count variable, with "hi"=1
bysort nyhilo: stcox immig_perc initiative intimmper citi6008 lf_perc south, efron nohr
*so, in effect, this is actually a three-way interaction, as we focus on lo vs. hi, and on the interaction between initiative states and immigration percentage 

*this is the syntax for the key interaction:
generate intimmper= initiative* immig_perc



*now, create a version of the data with nytimes "lo" dropped so you can test the ph assumption -- stata won't do it with a bysort or "if" statement 
*re-estimate the model on this data set, called "hiobservationsonly"
stcox immig_perc initiative intimmper citi6008 lf_perc south, schoenfeld(sch*) scaledsch(sca*) efron nohr
stphtest, detail
*nothing violates 
*note, if you want to do post-estimation on Stcox commands, the syntax changed between stata 10 (which Anand has) and stata 11 (which Amy has)

The following works for pre-11 versions:
stcox  immig_perc initiative intimmper citi6008 lf_perc south, efron basehc(hazardcon) basechazard(cumhas)
*these commands set you up to be able to then retrieve the baseline hazard, cumulative hazard, etc. 
*in the cox model, the baseline hazard is like a covariate-adjusted kaplan-meier estimate (i.e., what we present in Figure 2) 
stcurve, hazard kernel(epan2)
*note: the use of the boundary adjustments in the smoothed hazard plot using the "epan2" command 

stcurve, cumhaz
*note: adjustments (labels, etc.) were then made with graph editor



*robustness check 1: splitting by median 
recode nyt_count (0/186.5=0) (186.6/440=1), gen(nyhilo2) 
*note: A standard deviation on the measure is 104.5758
*replicate model, conditioning on this split
bysort nyhilo2: stcox immig_perc initiative intimmper citi6008 lf_perc south, efron nohr
*the original results hold - they are almost identical. 


*robustness check 2: higher cut points
*note: while the median is fine, cutting higher keeps the direction and relative sizes of coefficients, but starts to lose significance 
*for example: 
recode nyt_count (0/237=0) (238/440=1), gen(nyhilohigh)
bysort nyhilohigh: stcox immig_perc initiative intimmper citi6008 lf_perc south, efron nohr
*note: even more/"higher" splits on the sample have a hard time converging.


*robustness check 3: seeing whether there is an increase in the count from the previous year
gen nyhilo3==1 if nyt_count>nyt_count[_n-1] if snumb==snumb[_n-1]
replace nyhilo3==0 if nyt_count<nyt_count[_n-1] if snumb==snumb[_n-1]
replace nyhilo3==0 if year==1994
*note that 1980 is assigned a missing value.
*note there is no change in 1994, so nyhilo3==0.
stcox immig_perc initiative intimmper citi6008 lf_perc south if nyhilo3==0, efron nohr
stcox immig_perc initiative intimmper citi6008 lf_perc south if nyhilo3==1, efron nohr


*robustness check 4: seeing whether there is an increase in the count from the moving average of all previous years
*create a new variable (nyt_movemean) that is the average of all previous years.
gen nyhilo4==1 if nyt_count>nyt_movemean
replace nyhilo4==0 if nyt_count<nyt_movemean
stcox immig_perc initiative intimmper citi6008 lf_perc south if nyhilo4==0, efron nohr
stcox immig_perc initiative intimmper citi6008 lf_perc south if nyhilo4==1, efron nohr

*We reoprtused these, and the results were quite robust 
