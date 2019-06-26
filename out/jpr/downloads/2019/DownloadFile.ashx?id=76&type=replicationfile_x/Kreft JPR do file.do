//PROTEST MODELS
//Descriptive statistics
sum nonvprot nonvprotgovt deaths1000 mediabias v2x_gencl under5mortality FH lpop asia latinam nafrica ssafrica log_ODA if sample_protest==1                         
tab1 svconflict y2000s peace_op if sample_protest==1

//sample_protest=1 if observations are included in Model 2 below


//Baseline Model Protest
nbreg nonvprot i.svconflict i.ccode if sample_protest==1, irr vce(cluster ccode) nolog

//Model 1 Protest
nbreg nonvprot i.svconflict deaths1000 v2x_gencl under5mortality FH log_ODA peace_op y2000s i.ccode if sample_protest==1, irr vce(cluster ccode) nolog

//Model 2 Protest (including media bias control)
nbreg nonvprot i.svconflict deaths1000 v2x_gencl under5mortality FH log_ODA peace_op y2000s mediabias i.ccode if year>=1990, irr vce(cluster ccode) nolog

//sample_protest generated after this with gen sample_protest=e(sample)



//WINGO LINKAGES MODELS
//Descriptive statistics
sum wingos l.deaths1000 v2x_gencl FH_avg under5mortality log_ODA if sample_wingos==1

tab1 l_svconflict peace_op y2000s if sample_wingos==1

tab1 ccode if sample_wingos==1

//sample-wingo=1 if observation included in Model 3 below.


//Baseline
nbreg wingos i.l_svconflict i.ccode if sample_wingos==1, irr vce(cluster ccode) nolog

//Model 3 WINGO linkages
nbreg wingos i.l_svconflict l.deaths1000 v2x_gencl under5mortality FH log_ODA peace_op y2000s i.ccode if year>=1990, irr vce(cluster ccode) nolog

//sample_wingos generated after this with gen sample_wingos=e(sample)







//ONLINE APPENDIX
//Endogeneity checks

//Anti-government protests and government sexual violence
mlogit svgovlev nonvprotgovt deaths1000 i.ethwar magfail govt_pressgang conscript genocide_gov2, vce(robust) b(0) nolog

//Residual category of protests and rebel sexual violence
mlogit svreblev nonvprot_res deaths1000 i.ethwar magfail rebel_abduct rebel_forced genocide_reb2, vce(robust) b(0) nolog



//Robustness checks for protest models
//With population
nbreg nonvprot i.svconflict deaths1000 v2x_gencl under5mortality FH log_ODA peace_op y2000s mediabia lpop i.ccode if sample_protest==1, irr vce(cluster ccode) nolog

//With ethnic conflict
nbreg nonvprot i.svconflict deaths1000 v2x_gencl under5mortality FH log_ODA peace_op y2000s mediabias i.ethnic i.ccode if sample_protest==1, irr vce(cluster ccode) nolog

//With GDP
nbreg nonvprot i.svconflict deaths1000 v2x_gencl lGDPpc FH log_ODA peace_op y2000s mediabia i.ccode if sample_protest==1, irr vce(cluster ccode) nolog

//Excluding big countries with localized conflict
nbreg nonvprot i.svconflict deaths1000 v2x_gencl under5mortality FH log_ODA peace_op y2000s mediabias i.ccode if sample_protest==1 & ccode!=365 & ccode!=750 & ccode!=640, irr vce(cluster ccode) nolog

//Zero-inflated negative binomial model
zinb nonvprot i.svconflict deaths1000 v2x_gencl under5mortality FH log_ODA peace_op y2000s mediabias asia latinam nafrica ssafrica if sample_protest==1, irr inflate(mediabias) vce(cluster ccode) nolog

//Panel-averaged negative binormial model
xtnbreg nonvprot i.svconflict deaths1000 v2x_gencl under5mortality FH log_ODA peace_op y2000s mediabias asia latinam nafrica ssafrica, pa vce(robust) irr nolog

//With peace negotiation
nbreg nonvprot i.svconflict deaths1000 v2x_gencl under5mortality FH log_ODA negotiation y2000s mediabias i.ccode if sample_protest==1, irr vce(cluster ccode) nolog



//Robubstness checks for WINGO linkages models
//With ethnic conflict
nbreg wingos i.l_svconflict l.deaths1000 v2x_gencl under5mortality FH log_ODA peace_op y2000s lpop i.ccode if sample_wingos==1, irr vce(cluster ccode) nolog

//With ethnic conflict
nbreg wingos i.l_svconflict l.deaths1000 v2x_gencl under5mortality FH log_ODA peace_op y2000s i.ethnic i.ccode if sample_wingos==1, irr vce(cluster ccode) nolog

//With GDP
nbreg wingos i.l_svconflict l.deaths1000 v2x_gencl lGDPpc FH log_ODA peace_op y2000s i.ccode if sample_wingos==1, irr vce(cluster ccode) nolog


//Panel-averaged negative binomial models
xtnbreg wingos i.l_svconflict l.deaths1000 v2x_gencl under5mortality FH log_ODA peace_op y2000s asia latinam nafrica ssafrica if sample_wingos==1, pa vce(robust) irr nolog

//Excluding big countries with localized conflict
nbreg wingos i.l_svconflict l.deaths1000 v2x_gencl under5mortality FH log_ODA peace_op y2000s i.ccode if sample_wingos==1 & ccode!=365 & ccode!=750 & ccode!=640, irr vce(cluster ccode) nolog

//With peace negotiation
nbreg wingos i.l_svconflict l.deaths1000 v2x_gencl under5mortality FH log_ODA negotiation y2000s i.ccode if year>=1990, irr vce(cluster ccode) nolog


//Robustness checks - alternative sexual violence measures
//With SVAC - the maximum recorded prevalence across all three measures
nbreg nonvprot i.svac i.ccode if sample_protest==1, irr vce(cluster ccode) nolog

nbreg nonvprot i.svac deaths1000 v2x_gencl under5mortality FH log_ODA peace_op y2000s i.ccode if sample_protest==1, irr vce(cluster ccode) nolog

nbreg nonvprot i.svac deaths1000 v2x_gencl under5mortality FH log_ODA peace_op y2000s mediabias i.ccode if year>=1990, irr vce(cluster ccode) nolog


nbreg wingos i.l_svac i.ccode if sample_wingos==1, irr vce(cluster ccode) nolog

nbreg wingos i.l_svac l.deaths1000 v2x_gencl under5mortality FH log_ODA peace_op y2000s i.ccode if year>=1990, irr vce(cluster ccode) nolog

nbreg wingos i.l.ever_prev_svac l.deaths1000 v2x_gencl under5mortality FH log_ODA peace_op y2000s i.ccode if year>=1990, irr vce(cluster ccode) nolog


//Ever widespread or systematic rape
nbreg wingos i.l.ever_prevalent2 i.ccode if sample_wingos==1, irr vce(cluster ccode) nolog

nbreg wingos i.l.ever_prevalent2 l.deaths1000 v2x_gencl under5mortality FH log_ODA peace_op y2000s i.ccode if year>=1990, irr vce(cluster ccode) nolog


//Highest sexual violence across wartime rape (Cohen) and SVAC measures
nbreg nonvprot i.sv_max i.ccode if sample_protest==1, irr vce(cluster ccode) nolog

nbreg nonvprot i.sv_max deaths1000 v2x_gencl under5mortality FH log_ODA peace_op y2000s i.ccode if sample_protest==1, irr vce(cluster ccode) nolog

nbreg nonvprot i.sv_max deaths1000 v2x_gencl under5mortality FH log_ODA peace_op y2000s mediabias i.ccode if year>=1990, irr vce(cluster ccode) nolog



nbreg wingos i.l.sv_max i.ccode if sample_wingos==1, irr vce(cluster ccode) nolog

nbreg wingos i.l.sv_max l.deaths1000 v2x_gencl under5mortality FH log_ODA peace_op y2000s i.ccode if year>=1990, irr vce(cluster ccode) nolog

nbreg wingos i.l.sv_max_ever_prev2 l.deaths1000 v2x_gencl under5mortality FH log_ODA peace_op y2000s i.ccode if year>=1990, irr vce(cluster ccode) nolog
