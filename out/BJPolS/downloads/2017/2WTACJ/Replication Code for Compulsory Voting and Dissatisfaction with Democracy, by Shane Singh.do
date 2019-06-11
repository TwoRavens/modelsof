******			
****This code replicates the models in the paper "Compulsory Voting and Dissatisfaction with Democracy", by Shane Singh, which appears in the British Journal of Political Science.
******			


******	
*First, create variable that will limit the sample to observations that are not missing on the key covariates.  Exclude people living in countries with compulsory voting that are above or below age enforcement thresholds, and exlude observations in the USA and Canada
******	
destring year, replace
gen ageCV = .
label var ageCV "person was of CV age in Ecuador, Peru, Argentina, Bolivia, or Brazil"
replace ageCV = 1 if country == "Ecuador"  | country == "Peru"  | country == "Argentina"| country ==  "Brazil"  | country ==  "Bolivia" 
replace ageCV = 0 if country == "Ecuador" & age>64 | country == "Peru" & age>69 | country == "Argentina" & age>69 | country ==  "Brazil" & age>69 | country ==  "Brazil" & age<18 | country ==  "Bolivia" & age>69
replace ageCV = 0 if country == "Ecuador" & age<18 & year > 2008
replace ageCV = 0 if country == "Argentina" & age<18 & year > 2011
replace ageCV = 0 if country == "Bolivia"  & age<21 


reg dissatisfaction age_10 educ    GDPpercapita_PPP  polity_Bel cpi if ageCV ~= 0 & country~= "United States" & country~= "Canada" , cl(countryandyear)
gen samp_CVsat_noUSCAN = 1 if e(sample)



******			
****Multilevel Ordered Logit Models
******

**
*Model 1
**
xtologit dissatisfaction b0.CVscale_Payne    age_10 educ    GDPpercapita_PPP  polity_Bel cpi presidential majoritarian if samp_CVsat_noUSCAN == 1, i(countryandyear) intmethod(ghermite) intpoints(4) iterate(43) difficult


**
*Model 2
**
xtologit dissatisfaction b0.CVscale_Payne##c.dem_church_rev    age_10 educ    GDPpercapita_PPP  polity_Bel cpi presidential majoritarian if samp_CVsat_noUSCAN == 1, i(countryandyear) intmethod(ghermite) intpoints(11) iterate(43)


**
*Model 3
**
xtologit dissatisfaction b0.CVscale_Payne##c.overthrow_ok    age_10 educ    GDPpercapita_PPP  polity_Bel cpi presidential majoritarian if samp_CVsat_noUSCAN == 1, i(countryandyear) intmethod(ghermite) intpoints(11) iterate(43)


**
*Model 4
**
xtologit dissatisfaction b0.CVscale_Payne##c.auth_better    age_10 educ    GDPpercapita_PPP  polity_Bel cpi presidential majoritarian if samp_CVsat_noUSCAN == 1, i(countryandyear) intmethod(ghermite) intpoints(15) iterate(43) difficult


**
*Model 5
**
xtologit dissatisfaction b0.CVscale_Payne##c.strong_leader    age_10 educ    GDPpercapita_PPP  polity_Bel cpi presidential majoritarian if samp_CVsat_noUSCAN == 1, i(countryandyear) intmethod(ghermite) intpoints(11) iterate(43)






******			
****Regression discontinuity models
******


*create a variable that takes the cutoff to be one year above the cutoff age---that is, set this value to 0, as per the way the rd package works
gen age_rd = age-71 if country~="Ecuador"
replace age_rd = age-66 if country=="Ecuador"
label var age_rd "age variable set to 0 at CV cutoff age"


*create a scale of "anti-democraticness" and save the 25th and 75th percentiles to memory
polychoric  dem_church_rev  overthrow_ok   auth_better  strong_leader      if samp_CVsat_noUSCAN == 1
display r(sum_w)
matrix r = r(R)
factormat r, n(100228) ipf
predict antidem_scale
label var antidem_scale "predicted values from FA of anti-democratic attitudes"

sum antidem_scale, detail
global p25 = r(p25)
global p75 = r(p75)


*run an RD model for those low on anti-democraticness in countries with thresholds. Exclude people right at the cutoff age. 
rd  dissatisfaction  age_rd if antidem_scale<$p25 & age_rd ~= -1 & (country == "Peru" | country == "Bolivia" | country == "Brazil" | country == "Ecuador" | country == "Argentina") , gr noscatter mbw(200)

*run an RD model for those high on anti-democraticness in countries with thresholds. Exclude people right at the cutoff age. 
rd  dissatisfaction  age_rd if antidem_scale>$p75 &  age_rd ~= -1 & (country == "Peru" | country == "Bolivia" | country == "Brazil" | country == "Ecuador" | country == "Argentina") , gr noscatter mbw(200)
