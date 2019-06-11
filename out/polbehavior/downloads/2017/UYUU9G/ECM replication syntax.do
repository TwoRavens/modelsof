use  "C:\Users\gwwri.USERS\Documents\Diss\diss quant article\PB\replication files\Wright PB ECM replication dataset.dta", clear

/* initial cleaning/recodes */

*tsset data for time series analysis and declare time variable
tsset year

*create "concern * 100" for ease of reporting coefficients
gen concern100=concern*100

* create lag and differenced variables for use in error correction models *

foreach x in  mood urate gini allitems concern demcontrol incshare10 csentiment edmood redistmood incshare01 concern100 {
gen dif_`x'=D1.`x'
gen lag_`x'=L1.`x'
format dif_`x' %9.2f
}


/* end recodes */

************** Analyses in main document**************



/* Table 1: Wcalc Loadings for Potential Measures of Concern over Economic Inequality  - created via Wcalc. See "codebook for concern creation datasets" for more details */


/* footnote 10: correlation between % of Democratic House seats, % of Democratic Senate seats, and party control of White House */
corr hdpercen sdpercen
logit demcontrol hdpercen sdpercen, or 


/*Table 2 - Column A: ECM of mood as a function of concern and democratic control */
reg dif_mood lag_mood dif_demcontrol lag_demcontrol dif_incshare10 lag_incshare10 
predict m1resid, resid
wntestq m1resid /* Q test fails to reject white noise */


/*Table 2 - Column B: ECM of edmood as a function of concern and democratic control */
reg dif_edmood lag_edmood dif_demcontrol lag_demcontrol dif_incshare10 lag_incshare10
predict m2aresid, resid
wntestq m2aresid /* Q test fails to reject white noise */

/*Table 2 - Column B: ECM of concern as a function of concern and democratic control */
reg dif_concern100 lag_concern100 dif_demcontrol lag_demcontrol dif_incshare10 lag_incshare10
predict m3resid, resid
wntestq m3resid  /* Q test fails to reject white noise */


/* Table 3 - Column A: ECM of mood as a function of concern */
reg dif_mood lag_mood dif_concern100 lag_concern100 
predict m4resid, resid
wntestq m4resid  /* Q test fails to reject white noise */

/* Table 3 - Column A: ECM of edmood as a function of concern */
reg dif_edmood lag_edmood dif_concern100 lag_concern100 
predict m5resid, resid
wntestq m5resid /* Q test fails to reject white noise */



/* Table 4 - Column A: ECM of mood as a function of concern, Democratic control, and inequality */
reg dif_mood lag_mood dif_concern100 lag_concern100 dif_demcontrol lag_demcontrol dif_incshare10 lag_incshare10 
predict m6aresid, resid
wntestq m6aresid/* Q test fails to reject white noise */

/* Table 4 - Column B: ECM of edmood as a function of concern, Democratic control, and inequality */
reg dif_edmood lag_edmood dif_concern100 lag_concern100 dif_demcontrol lag_demcontrol dif_incshare10 lag_incshare10 
predict m7aresid, resid
wntestq m7aresid /* Q test fails to reject white noise */




**************Appendix ******************




/* Table 7 - Column A: ECM of mood as a function of Democratic control and inequality (Gini coefficient) */
reg dif_mood lag_mood dif_demcontrol lag_demcontrol dif_gini lag_gini
predict m8resid, resid
wntestq m8resid 


/* Table 7 - Column B: ECM of edmood as a function of Democratic control, and inequality (Gini coefficient) */
reg dif_edmood lag_edmood dif_demcontrol lag_demcontrol dif_gini lag_gini
predict m9resid, resid
wntestq m9resid 

/* Table 7 - Column C: ECM of concern as a function of Democratic control, and inequality (Gini coefficient) */
reg dif_concern100 lag_concern100 dif_demcontrol lag_demcontrol dif_gini lag_gini
predict m10resid, resid
wntestq m10resid 

/* Table 8 - univariate tests */

***mood ***
dfuller mood 
pperron mood 
kpss mood, notrend 
kpss mood 

***edmood***
dfuller edmood 
pperron edmood 
kpss edmood, notrend 
kpss edmood 


***concern ***
dfuller concern 
pperron concern 
kpss concern, notrend 
kpss concern 

***top 10% income share***
dfuller incshare10
pperron  incshare10
kpss incshare10, notrend 
kpss incshare10 

***Gini***
dfuller gini 
pperron gini 
kpss gini, notrend 
kpss gini 

*** csentiment ***
dfuller csentiment
pperron  csentiment
kpss csentiment, notrend 
kpss csentiment 

***urate***
dfuller urate
pperron urate 
kpss csentiment, notrend 
kpss csentiment



/* Table 9 - Column A: ECM of mood as a function of Democratic control and consumer sentiment */
reg dif_mood lag_mood dif_demcontrol lag_demcontrol dif_incshare10 lag_incshare10  dif_csentiment lag_csentiment
predict m11resid, resid
wntestq m11resid


/* Table 9 - Column B: ECM of edmood as a function of Democratic control and consumer sentiment */
reg dif_edmood lag_edmood dif_demcontrol lag_demcontrol dif_incshare10 lag_incshare10  dif_csentiment lag_csentiment
predict m12resid, resid
wntestq m12resid


/* Table 9 - Column C: ECM of concern as a function of Democratic control and consumer sentiment */
reg dif_concern100 lag_concern100 dif_demcontrol lag_demcontrol dif_incshare10 lag_incshare10  dif_csentiment lag_csentiment
predict m13resid, resid
wntestq m13resid

/* Table 10 - Column A: ECM of mood as a function of Democratic control and unemployment rate */
reg dif_mood lag_mood dif_demcontrol lag_demcontrol dif_incshare10 lag_incshare10  dif_urate lag_urate
predict m14resid, resid
wntestq m14resid 

/* Table 10 - Column B: ECM of edmood as a function of Democratic control and unemployment rate */
reg dif_edmood lag_edmood dif_demcontrol lag_demcontrol dif_incshare10 lag_incshare10  dif_urate lag_urate
predict m15resid, resid
wntestq m15resid 

/* Table 10 - Column C: ECM of concern as a function of Democratic control and unemployment rate */
reg dif_concern100 lag_concern100 dif_demcontrol lag_demcontrol dif_incshare10 lag_incshare10  dif_urate lag_urate
predict m16resid, resid
wntestq m16resid


/* Table 11 - Column A: ECM of mood as a function of  concern and Democratic control*/
reg dif_mood lag_mood dif_concern100 lag_concern100 dif_demcontrol lag_demcontrol 
predict m17resid, resid
wntestq m17resid


/* Table 11 - Column B: ECM of mood as a function of  concern and inequality (top 10% income share)*/
reg dif_mood lag_mood dif_concern100 lag_concern100 dif_incshare10 lag_incshare10 
predict m18resid, resid
wntestq m18resid


/* Table 11 - Column C: ECM of mood as a function of  concern, democratic control and inequality (Gini coefficient)*/
reg dif_mood lag_mood dif_concern100 lag_concern100 dif_demcontrol lag_demcontrol dif_gini lag_gini 
predict m19resid, resid
wntestq m19resid 


/* Table 12 - Column D: ECM of mood as a function of  concern, democratic control, inequality (top 10% income share), and unemployment rate*/
reg dif_mood lag_mood dif_concern100 lag_concern100 dif_demcontrol lag_demcontrol dif_incshare10 lag_incshare10  dif_urate lag_urate
predict m19resid, resid
wntestq m19resid 
