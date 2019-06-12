
*************************************************************
*Events data as Bismarck's sausages? 				*
*Intercoder Reliability, Coders Selection and Data Quality	*
*International Interactions, September 2011			*								
*					                              *
*Andrea Ruggeri, Ismene Gizelis, Han Dorussenn			*
*Stata 9 do-file (9 August 2010)             			*
*Machine: AR's Amsterdam Office                         	*
*************************************************************




**********
*READ ME *
**********



We provide two different datasets, in order to replicate our models you will need to append them following the instructions.

However, if you want to use the dataset for other purposes beside mere replication, you should contact us in order to have the latest and cleanest version of our data.

For further clarifications contact: A.Ruggeri@uva.nl




*merge two datasets


use "\\GoodCoders.dta"

append using "\\BadCoders.dta"



*Table 5
*Model 1
probit conflictdummy  gov_involvement rebel_involvement  local_involvement  capacity_strengthen policy_central  Igov Ireb Iloc Istrengh Icentral goodVSbad if UN_involvement==1 & sierra_leone==0 & liberia==0


*Model 2

probit conflictdummy  gov_involvement rebel_involvement  local_involvement  capacity_strengthen policy_central if UN_involvement==1 & goodVSbad==0 & sierra_leone==0 & liberia==0 
predict pmod4 if e(sample),p
predict rmod4 if e(sample), stdp

*Model 3
probit conflictdummy  gov_involvement rebel_involvement  local_involvement  capacity_strengthen policy_central if UN_involvement==1 & goodVSbad==1 & sierra_leone==0 & liberia==0 

predict pmod5 if e(sample),p
predict rmod5 if e(sample), stdp


* Figure 5

twoway (lfitci rmod4 pmod4 , ciplot(rline))   ||  (lfitci rmod5 pmod5 , ciplot(rline)), title("Predicted Values against Residuals") subtitle("Conflict-Bad & Good Coders")legend(lab (2 "Bad Coders")) legend(lab (3 "Good Coders")) xtitle("Probability") ytitle("Residuals") caption("All Countries") graphregion(fcolor(white))

*Model 4
probit conflictdummy  gov_involvement rebel_involvement  local_involvement  capacity_strengthen policy_central if UN_involvement==1 & goodVSbad==1 


*Model 5


probit conflictdummy  gov_involvement rebel_involvement  local_involvement  capacity_strengthen policy_central  Igov Ireb Iloc Istrengh Icentral goodVSbad if UN_involvement==1 & sierra_leone==0 & liberia==0 & firstbunch==1


*Model 6

probit conflictdummy  gov_involvement rebel_involvement  local_involvement  capacity_strengthen policy_central  Igov Ireb Iloc Istrengh Icentral goodVSbad if UN_involvement==1 & sierra_leone==0 & liberia==0 & secondbunch==1




*Table 6

*Model 7
probit cooperationdummy  gov_involvement rebel_involvement  local_involvement  capacity_strengthen policy_central  Igov Ireb Iloc Istrengh Icentral goodVSbad if UN_involvement==1 & sierra_leone==0 & liberia==0


*Model 8

probit cooperationdummy  gov_involvement rebel_involvement  local_involvement  capacity_strengthen policy_central if UN_involvement==1 & goodVSbad==0 & sierra_leone==0 & liberia==0 
predict pmod8 if e(sample),p
predict rmod8 if e(sample), stdp

*Model 9
probit cooperationdummy  gov_involvement rebel_involvement  local_involvement  capacity_strengthen policy_central if UN_involvement==1 & goodVSbad==1 & sierra_leone==0 & liberia==0 

predict pmod9 if e(sample),p
predict rmod9 if e(sample), stdp


* Figure 6

twoway (lfitci rmod8 pmod8 , ciplot(rline))   ||  (lfitci rmod9 pmod9 , ciplot(rline)), title("Predicted Values against Residuals") subtitle("Cooperation-Bad & Good Coders")legend(lab (2 "Bad Coders")) legend(lab (3 "Good Coders")) xtitle("Probability") ytitle("Residuals") caption("All Countries") graphregion(fcolor(white))

*Model 10
probit cooperationdummy  gov_involvement rebel_involvement  local_involvement  capacity_strengthen policy_central if UN_involvement==1 & goodVSbad==1 


*Model 11


probit cooperationdummy  gov_involvement rebel_involvement  local_involvement  capacity_strengthen policy_central  Igov Ireb Iloc Istrengh Icentral goodVSbad if UN_involvement==1 & sierra_leone==0 & liberia==0 & firstbunch==1


*Model 12

probit cooperationdummy gov_involvement rebel_involvement  local_involvement  capacity_strengthen policy_central  Igov Ireb Iloc Istrengh Icentral goodVSbad if UN_involvement==1 & sierra_leone==0 & liberia==0 & secondbunch==1



