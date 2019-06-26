****Models in Table I****
ologit hi_forcelvl cinc_1 pwr_rat intdem coalition localally state targ_asst, r
ologit hi_forcelvl cinc_1 pwr_rat intdem coalition localally state targ_asst crisis res_even, r
ologit hi_forcelvl cinc_1 pwr_rat intdem coalition localally state targ_asst crisis res_even c_ppo modc_ppo, r
ologit hi_forcelvl c_ppo modc_ppo cinc_1 pwr_rat intdem coalition localally state targ_asst crisis res_even pwrXcppo, r


****Table I models using only original MIPS interventions****
ologit hi_forcelvl cinc_1 pwr_rat intdem coalition localally state targ_asst if case<141, r
ologit hi_forcelvl cinc_1 pwr_rat intdem coalition localally state targ_asst crisis res_even if case<141, r
ologit hi_forcelvl cinc_1 pwr_rat intdem coalition localally state targ_asst crisis res_even c_ppo modc_ppo if case<141, r
ologit hi_forcelvl c_ppo modc_ppo cinc_1 pwr_rat intdem coalition localally state targ_asst crisis res_even pwrXcppo if case<141, r


****Models in Table IV****

logit escdelay crisis res_even c_ppo modc_ppo cinc_1 pwr_rat intdem coalition localally state targ_asst, r
logit escdelay crisis res_even c_ppo modc_ppo cinc_1 pwr_rat intdem coalition localally state targ_asst pwrXcppo, r
logit delaywk crisis res_even c_ppo modc_ppo cinc_1 pwr_rat intdem coalition localally state targ_asst, r
logit delaywk crisis res_even c_ppo modc_ppo cinc_1 pwr_rat intdem coalition localally state targ_asst pwrXcppo, r


****Data for Figure 1****

ologit hi_forcelvl c_ppo modc_ppo cinc_1 pwr_rat intdem coalition localally state targ_asst crisis res_even pwrXcppo, r

prvalue, x(c_ppo=1 modc_ppo=0 cinc_1=.018 intdem=1 coalition=0 localally=0 state=1 targ_asst=0 crisis=1 res_even=0 ////
pwrXcppo=.018) rest (mean) save

prvalue, x(c_ppo=1 modc_ppo=0 cinc_1=.139 intdem=1 coalition=0 localally=0 state=1 targ_asst=0 crisis=1 res_even=0 ////
pwrXcppo=.139) rest(mean) diff

prvalue, x(c_ppo=0 modc_ppo=0 cinc_1=.018 intdem=1 coalition=0 localally=0 state=1 targ_asst=0 crisis=1 res_even=0 ////
pwrXcppo=0) rest (mean) save

prvalue, x(c_ppo=0 modc_ppo=0 cinc_1=.139 intdem=1 coalition=0 localally=0 state=1 targ_asst=0 crisis=1 res_even=0 ////
pwrXcppo=0) rest (mean) diff


****Data for Tables II and III****
prvalue, x(c_ppo=0 modc_ppo=0 cinc_1=.018 intdem=1 coalition=0 localally=0 state=1 targ_asst=0 crisis=1 res_even=0 ////
pwrXcppo=0) rest (mean) save

prvalue, x(c_ppo=1 modc_ppo=0 cinc_1=.018 intdem=1 coalition=0 localally=0 state=1 targ_asst=0 crisis=1 res_even=0 ////
pwrXcppo=.018) rest (mean) diff

prvalue, x(c_ppo=0 modc_ppo=0 cinc_1=.139 intdem=1 coalition=0 localally=0 state=1 targ_asst=0 crisis=1 res_even=0 ////
pwrXcppo=0) rest (mean) save

prvalue, x(c_ppo=1 modc_ppo=0 cinc_1=.139 intdem=1 coalition=0 localally=0 state=1 targ_asst=0 crisis=1 res_even=0 ////
pwrXcppo=.139) rest(mean) diff

****Table V****

logit escdelay crisis res_even c_ppo modc_ppo cinc_1 pwr_rat intdem coalition localally state targ_asst pwrXcppo, r

prvalue, x(crisis=1 res_even=0 c_ppo=0 modc_ppo=0 cinc_1=.018 intdem=1 coalition=0 localally=0 state=1 targ_asst=0 pwrXcppo=0) rest(mean) save
prvalue, x(crisis=1 res_even=0 c_ppo=0 modc_ppo=0 cinc_1=.139 intdem=1 coalition=0 localally=0 state=1 targ_asst=0 pwrXcppo=0) rest(mean) diff

prvalue, x(crisis=1 res_even=0 c_ppo=1 modc_ppo=0 cinc_1=.018 intdem=1 coalition=0 localally=0 state=1 targ_asst=0 pwrXcppo=.018) rest(mean) save
prvalue, x(crisis=1 res_even=0 c_ppo=1 modc_ppo=0 cinc_1=.139 intdem=1 coalition=0 localally=0 state=1 targ_asst=0 pwrXcppo=.139) rest(mean) diff

****Demonstrating that the findings in Sullivan 2007 are consistent if non-UNSC P5 powers are added (Appendix 1, 1st table)****
logit attain1yr c_ppo modc_ppo pwr_rat state coalition localally targ_asst if case<141, r
logit attain1yr c_ppo modc_ppo pwr_rat state coalition localally targ_asst, r
