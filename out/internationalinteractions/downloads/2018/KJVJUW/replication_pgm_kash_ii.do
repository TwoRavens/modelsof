*** Replication Materials for "Threats to Leaders' Political Survival and Pro-Government Militia Formation" - International Interaction - Konstantin Ash***

***Note: Please see codebook for detailed descriptions of variables. For most of the models, the results produced by state will report COEFFICIENTS. The ESTOUT command will then transform the coefficients into ODDS RATIOS, which***
***appear in the final paper. In some instances, such as selection models, tables that appeared in the final paper were rearranged manually from the products produces by STATA. Figures were created in R. Please see R code for ***
***replication materials for all figures. Results are presented in the order they appear in the paper/appendix. Some variable names are changed from the labels listed in the replication data. Estout package required to create tables. ***
#delimit;
clear;
use "~\master_pgm_ii.dta";
***TABLES IN MAIN PAPER***

***Replication for Table 1 (note: relogit package necessary). Relogit not utilized for model 6 due to convergence problems.****

#delimit;
relogit   groupformation civilwar recentcoupattempt antigovforeign leaderirregularentry groupdiss overthrowdummy nomilitia nomilitiasq nomilitiacub,cluster( countrycode);
eststo a1;
relogit   groupformation civilwar recentcoupattempt antigovforeign leaderirregularentry groupdiss overthrowdummy lpop lcgdp milexgdp log_dem_aid_gdp log_aut_aid_gdp  lexclpop lnleaderpop nomilitia nomilitiasq nomilitiacub,cluster( countrycode);
eststo a2;
relogit   groupformation civilwar recentcoupattempt antigovforeign groupdiss overthrowdummy lpop lcgdp milexgdp xpolity xpolitysq log_dem_aid_gdp log_aut_aid_gdp  lexclpop lnleaderpop nomilitia nomilitiasq nomilitiacub,cluster( countrycode);
eststo a3;
relogit   groupformation recentcoupattempt antigovforeign leaderirregularentry groupdiss overthrowdummy lpop lcgdp milexgdp log_dem_aid_gdp log_aut_aid_gdp  lexclpop lnleaderpop nomilitia nomilitiasq nomilitiacub if civilwar==0,cluster( countrycode);
eststo a4;
xi: relogit   groupformation civilwar recentcoupattempt antigovforeign leaderirregularentry groupdiss overthrowdummy lpop lcgdp milexgdp log_dem_aid_gdp log_aut_aid_gdp  lexclpop lnleaderpop nomilitia nomilitiasq nomilitiacub i.year ,cluster (countrycode);
eststo a5;
xi: logit groupformation recentcoupattempt antigovforeign leaderirregularentry groupdiss overthrowdummy lpop lcgdp milexgdp log_dem_aid_gdp log_aut_aid_gdp  lexclpop lnleaderpop nomilitia nomilitiasq nomilitiacub i.year if civilwar==0,vce(cluster countrycode);
eststo a6;
estout a1 a2 a3 a4 a5 a6 using tab3.tex, replace eform cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons \_cons) style(tex); 

****Replication for table 2 (note columns 2, 4, 6 manually aligned with columns 1, 3 and 5 on the paper.****;
#delimit;
heckprob identity civilwar antigovforeign leaderirregularentry overthrowdummy recentcoupattempt milexgdp lcgdp lpop log_dem_aid_gdp log_aut_aid_gdp  lexclpop lnleaderpop , select(groupformation = civilwar antigovforeign leaderirregularentry overthrowdummy groupdiss recentcoupattempt  milexgdp lpop lcgdp log_dem_aid_gdp log_aut_aid_gdp lexclpop lnleaderpop  nomilitia nomilitiasq nomilitiacub) vce(cluster ccode);
eststo b1;
heckprob identity civilwar antigovforeign overthrowdummy recentcoupattempt xpolity xpolitysq milexgdp lcgdp lpop log_dem_aid_gdp log_aut_aid_gdp lexclpop lnleaderpop , select(groupformation = civilwar antigovforeign overthrowdummy groupdiss recentcoupattempt xpolity xpolitysq milexgdp lpop lcgdp log_dem_aid_gdp log_aut_aid_gdp lexclpop lnleaderpop nomilitia nomilitiasq nomilitiacub) vce(cluster ccode);
eststo b2;
heckprob identity civilwar antigovforeign leaderirregularentry  overthrowdummy recentcoupattempt milexgdp lpop log_dem_aid_gdp log_aut_aid_gdp elf85 , select(groupformation = civilwar antigovforeign leaderirregularentry overthrowdummy groupdiss recentcoupattempt milexgdp lpop log_dem_aid_gdp log_aut_aid_gdp elf85 nomilitia nomilitiasq nomilitiacub) vce(cluster ccode);
eststo b3;
estout b1 b2 b3 using tab4.tex, replace eform cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons \_cons) style(tex); 

***TABLES IN APPENDIX***

***Summary Statistics in Table 1; copied to LaTeX directly from STATA output***
sum  groupformation identity  groupdissolve civilwar foreigntroops  antigovforeign leaderirregularentry recentcoupattempt  overthrowdummy  lpop lcgdp xpolity xpolitysq milexgdp elf85 log_dem_aid_gdp log_aut_aid_gdp lexclpop lnleaderpop;

*** Correlation matrices for Tables 2 and 3***
corr antigovforeign leaderirregularentry recentcoupattempt overthrowdummy;
corr xpolity leaderirregularentry  lcgdp elf85 mediascore hrfilled;

***Table 4; predictors of overthrow - relogit package required**
#delimit;
relogit  overthrowdummy leaderirregularentry  antigovforeign recentcoupattempt  gwf_party gwf_personal gwf_military lcgdp  timesinceoverthrow timesinceoverthrowsq timesinceoverthrowcub, cluster(ccode);
eststo aa1;
relogit  overthrowdummy leaderirregularentry  antigovforeign recentcoupattempt  gwf_party gwf_personal gwf_military elf  timesinceoverthrow timesinceoverthrowsq timesinceoverthrowcub, cluster(ccode);
eststo aa2;
estout aa1 aa2 using overthrow.tex, replace eform cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons \_cons) style(tex); 


***MEDIA BIAS***
** Table 5: relogit package for STATA needed to run models!**
#delimit;
relogit groupformation  civilwar recentcoupattempt antigovforeign groupdiss overthrowdummy mediascore Media_ai_tot nomilitia nomilitiasq nomilitiacub, cluster (countrycode);
eststo g1;
relogit groupformation  civilwar recentcoupattempt antigovforeign groupdiss overthrowdummy lpop mediascore Media_ai_tot  milexgdp log_dem_aid_gdp log_aut_aid_gdp lexclpop lnleaderpop  nomilitia nomilitiasq nomilitiacub, cluster (countrycode);
eststo g2;
relogit groupformation  civilwar recentcoupattempt antigovforeign groupdiss overthrowdummy hrfilled Media_ai_tot nomilitia nomilitiasq nomilitiacub, cluster (countrycode);
eststo g3;
relogit groupformation  civilwar recentcoupattempt antigovforeign groupdiss overthrowdummy lpop hrfilled Media_ai_tot  milexgdp log_dem_aid_gdp log_aut_aid_gdp lexclpop lnleaderpop  nomilitia nomilitiasq nomilitiacub, cluster (countrycode);
eststo g4;
estout g1 g2 g3 g4 using tab9.tex, replace eform cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons \_cons) style(tex); 

** Table 6**

#delimit;
hetprob groupformation  civilwar recentcoupattempt antigovforeign leaderirregularentry groupdiss overthrowdummy nomilitia nomilitiasq nomilitiacub, het(mediascore Media_ai_tot) vce(cluster countrycode);
eststo h1;
hetprob groupformation  civilwar recentcoupattempt antigovforeign leaderirregularentry groupdiss overthrowdummy lpop milexgdp log_dem_aid_gdp log_aut_aid_gdp lexclpop lnleaderpop   nomilitia nomilitiasq nomilitiacub, het(mediascore Media_ai_tot) vce(cluster countrycode);
eststo h2;
hetprob groupformation  civilwar recentcoupattempt antigovforeign leaderirregularentry groupdiss overthrowdummy nomilitia nomilitiasq nomilitiacub, het(Media_ai_tot hrfilled) vce(cluster countrycode);
eststo h3;
hetprob groupformation  civilwar recentcoupattempt antigovforeign leaderirregularentry groupdiss overthrowdummy lpop milexgdp log_dem_aid_gdp log_aut_aid_gdp lexclpop lnleaderpop  nomilitia nomilitiasq nomilitiacub, het(Media_ai_tot  hrfilled) vce(cluster countrycode);
eststo h4;
estout h1 h2 h3 h4 using tab10.tex, replace eform cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons \_cons) style(tex); 


***Testing for validity of group diss as an instrument: leter regression model forms Table 7 - manually rearranged for Coefficients and SEs to be on same line.***;
glm identity civilwar numberofgroups antigovforeign recentcoupattempt overthrowdummy xpolity xpolitysq milexgdp lpop lcgdp log_dem_aid_gdp log_aut_aid_gdp lexclpop lnleaderpop  nomilitia nomilitiasq nomilitiacub, family(binomial) link(logit) eform vce(cluster ccode);
predict error4, p;
corr groupdiss error4;
reg error4  civilwar numberofgroups antigovforeign overthrowdummy recentcoupattempt xpolity xpolitysq milexgdp lpop lcgdp log_dem_aid_gdp log_aut_aid_gdp lexclpop lnleaderpop  nomilitia nomilitiasq nomilitiacub groupdiss, vce(cluster ccode);
eststo inst;
estout inst using intstrument.tex, replace cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons \_cons) style(tex); 


****Table 8: Selection Models with full foreign troops variable included -- Table manually rearranged to appear in appendix****;
#delimit;
heckprob identity civilwar foreigntroops leaderirregularentry overthrowdummy recentcoupattempt milexgdp lcgdp lpop log_dem_aid_gdp log_aut_aid_gdp lexclpop lnleaderpop   , select(groupformation = civilwar foreigntroops leaderirregularentry overthrowdummy groupdiss recentcoupattempt  milexgdp lpop lcgdp log_dem_aid_gdp log_aut_aid_gdp lexclpop lnleaderpop    nomilitia nomilitiasq nomilitiacub) vce(cluster ccode);
eststo x1;
heckprob identity civilwar foreigntroops overthrowdummy recentcoupattempt xpolity xpolitysq milexgdp lcgdp lpop log_dem_aid_gdp log_aut_aid_gdp lexclpop lnleaderpop   , select(groupformation = civilwar foreigntroops overthrowdummy groupdiss recentcoupattempt xpolity xpolitysq milexgdp lpop lcgdp log_dem_aid_gdp log_aut_aid_gdp lexclpop lnleaderpop    nomilitia nomilitiasq nomilitiacub) vce(cluster ccode);
eststo x2;
heckprob identity civilwar foreigntroops leaderirregularentry  overthrowdummy recentcoupattempt milexgdp lpop log_dem_aid_gdp log_aut_aid_gdp elf85, select(groupformation = civilwar foreigntroops leaderirregularentry overthrowdummy groupdiss recentcoupattempt milexgdp lpop log_dem_aid_gdp log_aut_aid_gdp elf85 nomilitia nomilitiasq nomilitiacub) vce(cluster ccode);
eststo x3;
estout x1 x2 x3 using tab12.tex, replace eform cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons \_cons) style(tex); 

***STATE CAPACITY***
*** Table 9. relogit package required. Logit used in model 5 to facilitate convergence ***
#delimit;
relogit   groupformation civilwar recentcoupattempt antigovforeign leaderirregularentry groupdiss overthrowdummy lpop lcgdp milexgdp log_dem_aid_gdp log_aut_aid_gdp rpe_gdp rpr lexclpop lnleaderpop   nomilitia nomilitiasq nomilitiacub,cluster( countrycode);
eststo n1;
relogit   groupformation civilwar recentcoupattempt antigovforeign groupdiss overthrowdummy lpop lcgdp milexgdp xpolity xpolitysq log_dem_aid_gdp log_aut_aid_gdp  rpe_gdp rpr lexclpop lnleaderpop   nomilitia nomilitiasq nomilitiacub,cluster( countrycode);
eststo n2;
relogit   groupformation recentcoupattempt antigovforeign leaderirregularentry groupdiss overthrowdummy lpop lcgdp milexgdp log_dem_aid_gdp log_aut_aid_gdp  rpe_gdp rpr lexclpop lnleaderpop  nomilitia nomilitiasq nomilitiacub if civilwar==0,cluster( countrycode);
eststo n3;
***GROUP ONSET: YEAR FE***;
xi: relogit   groupformation civilwar recentcoupattempt antigovforeign leaderirregularentry groupdiss overthrowdummy lpop lcgdp milexgdp log_dem_aid_gdp log_aut_aid_gdp  rpe_gdp rpr lexclpop lnleaderpop   nomilitia nomilitiasq nomilitiacub i.year ,cluster (countrycode);
eststo n4;
xi: logit groupformation recentcoupattempt antigovforeign leaderirregularentry groupdiss overthrowdummy lpop lcgdp milexgdp log_dem_aid_gdp log_aut_aid_gdp rpe_gdp rpr lexclpop lnleaderpop   nomilitia nomilitiasq nomilitiacub i.year if civilwar==0,vce(cluster countrycode);
eststo n5;
estout n1 n2 n3 n4 n5 using rpc1.tex, replace eform cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons \_cons) style(tex); 

***Table 10; manually arranged to appear in six columns, rather than three in the appendix ***
#delimit;
heckprob identity civilwar antigovforeign leaderirregularentry overthrowdummy recentcoupattempt milexgdp lcgdp lpop log_dem_aid_gdp log_aut_aid_gdp rpe_gdp rpr  lexclpop lnleaderpop   , select(groupformation = civilwar antigovforeign leaderirregularentry overthrowdummy groupdiss recentcoupattempt  milexgdp lpop lcgdp log_dem_aid_gdp log_aut_aid_gdp rpe_gdp rpr lexclpop lnleaderpop     nomilitia nomilitiasq nomilitiacub) vce(cluster ccode);
eststo p1;
heckprob identity civilwar antigovforeign overthrowdummy recentcoupattempt xpolity xpolitysq milexgdp lcgdp lpop log_dem_aid_gdp log_aut_aid_gdp rpe_gdp rpr  lexclpop lnleaderpop   , select(groupformation = civilwar antigovforeign overthrowdummy groupdiss recentcoupattempt xpolity xpolitysq milexgdp lpop lcgdp log_dem_aid_gdp log_aut_aid_gdp rpe_gdp rpr lexclpop lnleaderpop     nomilitia nomilitiasq nomilitiacub) vce(cluster ccode);
eststo p2;
heckprob identity civilwar antigovforeign leaderirregularentry  overthrowdummy recentcoupattempt milexgdp lpop elf85 rpe_gdp rpr , select(groupformation = civilwar antigovforeign leaderirregularentry overthrowdummy groupdiss recentcoupattempt milexgdp lpop elf85 rpe_gdp rpr nomilitia nomilitiasq nomilitiacub) vce(cluster ccode);
eststo p3;
estout p1 p2 p3 using rpc2.tex, replace eform cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons \_cons) style(tex); 


***AUTOCRATIC REGIME TYPE****
*** Table 11. Autocratic regime type measures added ***
#delimit;
logit   groupformation civilwar recentcoupattempt antigovforeign leaderirregularentry groupdiss overthrowdummy lpop lcgdp milexgdp log_dem_aid_gdp log_aut_aid_gdp lexclpop lnleaderpop    gwf_party gwf_personal gwf_military nomilitia nomilitiasq nomilitiacub,vce(cluster countrycode);;
eststo q2;
logit   groupformation civilwar recentcoupattempt antigovforeign groupdiss overthrowdummy lpop lcgdp milexgdp xpolity xpolitysq log_dem_aid_gdp log_aut_aid_gdp lexclpop lnleaderpop   gwf_party gwf_personal gwf_military nomilitia nomilitiasq nomilitiacub,vce(cluster countrycode);
eststo q3;
logit   groupformation recentcoupattempt antigovforeign leaderirregularentry groupdiss overthrowdummy lpop lcgdp milexgdp log_dem_aid_gdp log_aut_aid_gdp lexclpop lnleaderpop    gwf_party gwf_personal gwf_military nomilitia nomilitiasq nomilitiacub if civilwar==0,vce(cluster countrycode);
eststo q4;
***GROUP ONSET: YEAR FE***;
xi: logit   groupformation civilwar recentcoupattempt antigovforeign leaderirregularentry groupdiss overthrowdummy lpop lcgdp milexgdp log_dem_aid_gdp log_aut_aid_gdp lexclpop lnleaderpop   gwf_party gwf_personal gwf_military nomilitia nomilitiasq nomilitiacub i.year ,vce(cluster countrycode);
eststo q5;
xi: logit groupformation recentcoupattempt antigovforeign leaderirregularentry groupdiss overthrowdummy lpop lcgdp milexgdp log_dem_aid_gdp log_aut_aid_gdp gwf_party lexclpop lnleaderpop   gwf_personal gwf_military nomilitia nomilitiasq nomilitiacub i.year if civilwar==0,vce(cluster countrycode);
eststo q6;
estout q2 q3 q4 q5 q6 using autocracy.tex, replace eform cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons \_cons) style(tex); 

*** Table 12. Autocratic regime type measures added --  manually arranged to appear in six columns, rather than three in the appendix ***
#delimit;
heckprob identity civilwar antigovforeign leaderirregularentry overthrowdummy recentcoupattempt milexgdp lcgdp lpop log_dem_aid_gdp log_aut_aid_gdp lexclpop lnleaderpop   gwf_party gwf_personal gwf_military , select(groupformation = civilwar antigovforeign leaderirregularentry overthrowdummy groupdiss recentcoupattempt  milexgdp lpop lcgdp log_dem_aid_gdp log_aut_aid_gdp gwf_party lexclpop lnleaderpop  gwf_party gwf_personal gwf_military nomilitia nomilitiasq nomilitiacub) vce(cluster ccode);
eststo y1;
heckprob identity civilwar antigovforeign overthrowdummy recentcoupattempt xpolity xpolitysq milexgdp lcgdp lpop log_dem_aid_gdp log_aut_aid_gdp gwf_party lexclpop lnleaderpop  gwf_party gwf_personal gwf_military , select(groupformation = civilwar antigovforeign overthrowdummy groupdiss recentcoupattempt xpolity xpolitysq milexgdp lpop lcgdp log_dem_aid_gdp log_aut_aid_gdp gwf_party gwf_personal lexclpop lnleaderpop gwf_party  gwf_military nomilitia nomilitiasq nomilitiacub) vce(cluster ccode);
eststo y2;
heckprob identity civilwar antigovforeign leaderirregularentry  overthrowdummy recentcoupattempt milexgdp lpop elf85 gwf_party lexclpop lnleaderpop gwf_party  gwf_personal gwf_military , select(groupformation = civilwar antigovforeign leaderirregularentry overthrowdummy groupdiss recentcoupattempt milexgdp lpop elf85 gwf_party lexclpop lnleaderpop gwf_party  gwf_personal gwf_military nomilitia nomilitiasq nomilitiacub) vce(cluster ccode);
eststo y3;
estout y1 y2 y3 using tab11.tex, replace eform cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons \_cons) style(tex); 

***HUMAN RIGHTS TRIALS****
*** Table 13 - relogit package needed to run***
#delimit;
relogit   groupformation civilwar recentcoupattempt antigovforeign leaderirregularentry groupdiss overthrowdummy lpop lcgdp milexgdp log_dem_aid_gdp log_aut_aid_gdp trt_filled lexclpop lnleaderpop nomilitia nomilitiasq nomilitiacub,cluster( countrycode);
eststo p2;
relogit   groupformation civilwar recentcoupattempt antigovforeign groupdiss overthrowdummy lpop lcgdp milexgdp xpolity xpolitysq log_dem_aid_gdp log_aut_aid_gdp  lexclpop lnleaderpop trt_filled nomilitia nomilitiasq nomilitiacub,cluster( countrycode);
eststo p3;
***GROUP ONSET: YEAR FE WITH HUMAN RIGHTS TRIALS***;
xi: relogit   groupformation civilwar recentcoupattempt antigovforeign leaderirregularentry groupdiss overthrowdummy lpop lcgdp milexgdp log_dem_aid_gdp log_aut_aid_gdp  lexclpop lnleaderpop trt_filled  nomilitia nomilitiasq nomilitiacub i.year ,cluster (countrycode);
eststo p4;
estout p2 p3 p4 using prosec1.tex, replace eform cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons \_cons) style(tex); 

****Table 14.  manually arranged to appear in six columns, rather than three in the appendix ****;
#delimit;
heckprob identity civilwar antigovforeign leaderirregularentry overthrowdummy recentcoupattempt milexgdp lcgdp lpop log_dem_aid_gdp log_aut_aid_gdp  lexclpop lnleaderpop trt_filled , select(groupformation = civilwar antigovforeign leaderirregularentry overthrowdummy groupdiss recentcoupattempt  milexgdp lpop lcgdp log_dem_aid_gdp log_aut_aid_gdp lexclpop lnleaderpop trt_filled  nomilitia nomilitiasq nomilitiacub) vce(cluster ccode);
eststo p5;
heckprob identity civilwar antigovforeign overthrowdummy recentcoupattempt xpolity xpolitysq milexgdp lcgdp lpop log_dem_aid_gdp log_aut_aid_gdp lexclpop lnleaderpop trt_filled , select(groupformation = civilwar antigovforeign overthrowdummy groupdiss recentcoupattempt xpolity xpolitysq milexgdp lpop lcgdp log_dem_aid_gdp log_aut_aid_gdp lexclpop lnleaderpop trt_filled  nomilitia nomilitiasq nomilitiacub) vce(cluster ccode);
eststo p6;
heckprob identity civilwar antigovforeign leaderirregularentry  overthrowdummy recentcoupattempt milexgdp lpop log_dem_aid_gdp log_aut_aid_gdp elf85 trt_filled , select(groupformation = civilwar antigovforeign leaderirregularentry overthrowdummy groupdiss recentcoupattempt milexgdp lpop log_dem_aid_gdp log_aut_aid_gdp elf85 trt_filled  nomilitia nomilitiasq nomilitiacub) vce(cluster ccode);
eststo p7;
estout p5 p6 p7 using prosec2.tex, replace eform cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons \_cons) style(tex); 

***LEADER FATE***
***Creates Table 15***
tab remained group_d, exact;
***Creates Table 16***
#delimit;
logit  remainedpolitics group_dummy;
eststo f1;
logit  remainedpolitics group_d  elf85 military civilwar coup foreign xpolitysq;
eststo f2;
logit  remainedpolitics group_dummy, vce(cluster ccode);
eststo f3;
logit  remainedpolitics group_d elf85 military civilwar coup foreign xpolitysq, vce(cluster ccode);
eststo f4;
estout f1 f2 f3 f4 using tab8.tex, replace eform cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons \_cons) style(tex); 


