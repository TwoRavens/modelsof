//////////////////////////////
//////////////////////////////
////// First Experiment //////
//////////////////////////////
//////////////////////////////

//////////////////////////////////////////////////
////// Tables for Stopround Graph           //////
//////////////////////////////////////////////////

tab stopround if exp1&round==1&lab
tab stopround if exp1&round==1&limelight

//////////////////////////////
////// Simple Tests     //////
//////////////////////////////

ttest stopround if exp1 &round==1, by(limelight)
ranksum stopround if exp1&round==1, by(limelight)

//////////////////////////////
////// Probit model     //////
//////////////////////////////

probit deal ev100 evoffer stdevev limelight         if exp1 , vce(cluster subject)
probit deal ev100 evoffer stdevev limelight gender  if exp1 , vce(cluster subject)

///////////////////////////////////////////////////////////
////// Data for Descriptive Table Winners/Losers     //////
///////////////////////////////////////////////////////////

// Lab
tabstat deal offerev if loser&exp1&lab     		, statistics(n mean) by(round)
tabstat deal offerev if neutral&exp1&lab		, statistics(n mean) by(round)
tabstat deal offerev if winner&exp1&lab			, statistics(n mean) by(round)

// Limelight
tabstat deal offerev if loser&exp1&limelight	, statistics(n mean) by(round)
tabstat deal offerev if neutral&exp1&limelight	, statistics(n mean) by(round)
tabstat deal offerev if winner&exp1&limelight	, statistics(n mean) by(round)

//////////////////////////////
////// EV Estimations   //////
//////////////////////////////

// Lab
version 11: ml model lf MLneutral (noise: decision = ) if exp1&lab,    ///
maximize search(on) iter(20) vce(cluster subject)
ml display
est store MLneutralLab

// Limelight
version 11: ml model lf MLneutral (noise: decision = )   if exp1&limelight,  ///
maximize search(on)   iter(20) vce(cluster subject)
ml display
est store MLneutralLim

est table MLneutralLab MLneutralLim, star(0.01 0.05 0.1) stats(aic, bic, ll N)

//////////////////////////////
////// EU Estimations   //////
//////////////////////////////

// Lab
version 11: ml model lf MLexpo (alpha: decision = ) (beta:) (noise: )  if exp1 & lab ///
, maximize search(on) init(-0.0001 -.86 .54, copy) iter(10) technique(dfp bfgs)  vce(cluster subject)
ml display
* Convergence towards CRRA, so we estimate a CRRA model in this case
version 11: ml model lf MLcrra (beta: decision = )  (noise: )  if exp1 & lab ///
, maximize search(on) init( -1  0.5, copy) iter(100) technique(dfp bfgs)  vce(cluster subject)
ml display
est store MLeutLab

lrtest MLneutralLab MLeutLab, df(2) force
*AIC
display -2 * e(ll) + 2*3
*BIC
display -2 * e(ll) + 3*ln(e(N))

// Limelight
version 11: ml model lf MLexpo (alpha: decision = ) (beta:) (noise: )  if exp1 & lim ///
, maximize search(on) init( .0204901 0.0001 .3140, copy) iter(10)   vce(cluster subject)
ml display
* Convergence to CARA, so we estimate a CARA model in this case 
version 11: ml model lf MLcara (alpha: decision = ) (noise: )  if exp1 & limelight, ///
maximize search(on) init(0.1 0.4, copy) iter(20)  technique(bfgs) vce(cluster subject)
ml display
est store MLeutLim

lrtest MLneutralLim MLeutLim, df(2) force
*AIC
display -2 * e(ll) + 2*3
*BIC
display -2 * e(ll) + 3*ln(e(N))

est table MLeutLab    MLeutLim, star(0.01 0.05 0.1) stats(ll N)

////////////////////////////////////////////
////// EU Estimations Winners/Losers  //////
////////////////////////////////////////////

// Losers Lab
version 11: ml model lf MLexpo (alpha: decision = ) (beta:) (noise: )  if exp1 & lab &loser ///
, maximize search(on) init(  -0.00001   -1.4  .5    , copy) iter(10) technique(dfp bfgs)  vce(cluster subject)
ml display
* Convergence towards CRRA, so we estimate a CRRA model in this case 
version 11: ml model lf MLcrra (beta: decision = )  (noise: )  if exp1 & lab &loser ///
, maximize search(on) init( -1.5  0.5     , copy) iter(100) technique(dfp bfgs)  vce(cluster subject)
ml display
est store MLeutLabLoser

// Neutral Lab
version 11: ml model lf MLexpo (alpha: decision = ) (beta:) (noise: )  if exp1 & lab &neutral ///
, maximize search(on) init(  -0.000001   -0.4  .4    , copy) iter(10) technique(dfp bfgs)  vce(cluster subject)
ml display
* Convergence towards CRRA, so we estimate a CRRA model in this case 
version 11: ml model lf MLcrra (beta: decision = )  (noise: )  if exp1 & lab &neutral ///
, maximize search(on) init( -1.5  0.5     , copy) iter(100) technique(dfp bfgs)  vce(cluster subject)
ml display
est store MLeutLabNeutral

// Winners Lab
version 11: ml model lf MLexpo (alpha: decision = ) (beta:) (noise: )  if exp1 & lab &winner ///
, maximize search(on) init(  0.1  0.1  .4    , copy) iter(10) technique(dfp bfgs)  vce(cluster subject)
ml display
* Convergence towards CRRA, so we estimate a CRRA model in this case 
version 11: ml model lf MLcrra (beta: decision = )  (noise: )  if exp1 & lab &winner ///
, maximize search(on) init( -1.5  0.5     , copy) iter(100) technique(dfp bfgs)  vce(cluster subject)
ml display
est store MLeutLabWinner

est table  MLeutLabLoser MLeutLabNeutral MLeutLabWinner, star(0.01 0.05 0.1) stats(ll N)

// Losers Limelight
version 11: ml model lf MLexpo (alpha: decision = ) (beta:) (noise: )  if exp1 & lim &loser ///
, maximize search(on) init(  -2    -0.2 0.3    , copy) iter(10) technique(dfp bfgs)  vce(cluster subject)
ml display
* Convergence to CARA, so we estimate a CARA model in this case 
version 11: ml model lf MLcara (alpha: decision = )  (noise: )  if exp1 & lim &loser ///
, maximize search(on) init( 0.002  0.5     , copy) iter(100) technique(dfp bfgs)  vce(cluster subject)
ml display
est store MLeutLimLoser

// Neutral Limelight
version 11: ml model lf MLexpo (alpha: decision = ) (beta:) (noise: )  if exp1 & lim &neutral ///
, maximize search(on) init(  0.018    0.00001  .5    , copy) iter(10)  vce(cluster subject)
ml display
* Convergence to CARA, so we estimate a CARA model in this case 
version 11: ml model lf MLcara (alpha: decision = )  (noise: )  if exp1 & lim &neutral ///
, maximize search(on) init( -1.5  0.5     , copy) iter(100) technique(dfp bfgs)  vce(cluster subject)
ml display
est store MLeutLimNeutral

// Winners Limelight
version 11: ml model lf MLexpo (alpha: decision = ) (beta:) (noise: )  if exp1 & lim &winner ///
, maximize search(on) init(  0.00001    .0271401  .2523007     , copy) iter(10) technique(dfp bfgs)  vce(cluster subject)
ml display
* Convergence to CARA, so we estimate a CARA model in this case 
version 11: ml model lf MLcara (alpha: decision = )  (noise: )  if exp1 & lim &winner ///
, maximize search(on) init( -1.5  0.5     , copy) iter(100) technique(dfp bfgs)  vce(cluster subject)
ml display
est store MLeutLimWinner

est table  MLeutLimLoser MLeutLimNeutral MLeutLimWinner, star(0.01 0.05 0.1) stats(ll N)

//////////////////////////////
////// CPT tests        //////
//////////////////////////////

// Lab
version 11: ml model lf MLpt (alpha: decision = ) (lambda:  ) (theta1:  )  ///
 (theta2:  ) (noise: )  if lab&exp1 , maximize iter(180) technique (dfp bfgs)             ///
  init(.553  1.505  1.014 -.0446 .334 , copy)  search(on) vce(cluster subject) 
ml display
est store MLptLab
lrtest  MLneutralLim, force
est table, star(0.01 0.05 0.1) stats(aic, bic, ll N)

test [alpha]_cons==1
test [lambda]_cons==1
test [theta1]_cons==0
test [theta2]_cons==0
test [noise]_cons==0

// Limelight
version 11: ml model lf MLpt (alpha: decision = ) (lambda:  ) (theta1:  )  ///
 (theta2:  ) (noise: )  if limelight&exp1 , maximize iter(180) technique (dfp bfgs)             ///
  init(.710 2.826 1.0394  -.0722 .25652, copy)  search(on) vce(cluster subject) 
ml display
est store MLptLim
lrtest  MLneutralLim, force
est table, star(0.01 0.05 0.1) stats(aic, bic, ll N)

test [alpha]_cons==1
test [lambda]_cons==1
test [theta1]_cons==0
test [theta2]_cons==0
test [noise]_cons==0

est table MLptLab MLptLim, star(0.01 0.05 0.1) stats(aic, bic, ll N)

// Combined
version 11: ml model lf MLpt (alpha: decision = limelight) (lambda:  limelight) (theta1: limelight  )  ///
 (theta2: limelight ) (noise: limelight )  if exp1 , maximize iter(180) technique (dfp bfgs)             ///
  init(.1567 .5538 1.3200 1.505 .025285 1.0142 -.02725 -.0446 -.0775 .33444  , copy)  search(on) vce(cluster subject) 
ml display
est store MLptComb
est table, star(0.01 0.05 0.1) stats(aic, bic, ll N)

//////////////////////////////
//////////////////////////////
////// Second Experiment /////
//////////////////////////////
//////////////////////////////

//////////////////////////////////////////////////
////// Tables for Stopround Graph           //////
//////////////////////////////////////////////////

tab stopround if exp2&round==1&lab
tab stopround if exp2&round==1&comeback
tab stopround if exp2&round==1&limelight

//////////////////////////////
////// Simple Tests     //////
//////////////////////////////

ttest stopround   if exp2&round==1&comeback==0, by(limelight)
ranksum stopround if exp2&round==1&comeback==0, by(limelight)
ttest stopround   if exp2&round==1&lab==0, by(limelight)
ranksum stopround if exp2&round==1&lab==0, by(limelight)
ttest stopround   if exp2&round==1&limelight==0, by(comeback)
ranksum stopround if exp2&round==1&limelight==0, by(comeback)

//////////////////////////////
////// Probit model     //////
//////////////////////////////

probit deal ev100 evoffer stdevev limelight comeback         if exp2 , vce(cluster subject)
test _b[comeback]==_b[limelight]
probit deal ev100 evoffer stdevev limelight comeback gender  if exp2 , vce(cluster subject)
test _b[comeback]==_b[limelight]

//////////////////////////////
////// EV Estimations   //////
//////////////////////////////

// Lab
version 11: ml model lf MLneutral (noise: decision = ) if exp2&lab,  ///
maximize search(on)   iter(20) technique( dfp) vce(cluster subject)
ml display
est store MLneutralLab2

// Comeback
version 11: ml model lf MLneutral (noise: decision = ) if exp2&comeback,  ///
maximize search(on)   iter(20) technique( dfp ) vce(cluster subject)
ml display
est store MLneutralCB2

// Limelight
version 11: ml model lf MLneutral (noise: decision = )  if exp2&limelight,  ///
maximize search(on)   iter(20) technique( dfp ) vce(cluster subject)
ml display
est store MLneutralLim2

est table MLneutralLab2 MLneutralCB2 MLneutralLim2, star(0.01 0.05 0.1) stats(aic, bic, ll N)

//////////////////////////////
////// EU Estimations   //////
//////////////////////////////

// Lab
version 11: ml model lf MLexpo (alpha: decision = ) (beta:)  (noise: )  if exp2 & lab ///
, maximize search(on) init(  -0.00001   -0.468            .366    , copy) iter(10) technique(dfp bfgs)  vce(cluster subject)
ml display
* Convergence towards CRRA, so we estimate a CRRA model in this case 
version 11: ml model lf MLcrra (beta: decision = )  (noise: )  if exp2 & lab ///
, maximize search(on) init(   -.5011697    .3746394 , copy) iter(20)  vce(cluster subject)
ml display
est store MLeutLab2
lrtest MLneutralLab2 MLeutLab2, df(2) force

*AIC
display -2 * e(ll) + 2*3
*BIC
display -2 * e(ll) + 3*ln(e(N))


// Comeback
version 11: ml model lf MLexpo (alpha: decision = ) (beta:)  (noise: )  if exp2 & comeback ///
, maximize search(on) init(  -.00001   -.33            .29    , copy) iter(10) technique(dfp bfgs)  vce(cluster subject)
ml display
* Convergence towards CRRA, so we estimate a CRRA model in this case 
version 11: ml model lf MLcrra (beta: decision = )  (noise: )  if exp2 & comeback ///
, maximize search(on) init(    -.5044146         .38, copy) iter(20)  vce(cluster subject)
ml display
est store MLeutCB2
lrtest MLneutralCB2 MLeutCB2, df(2) force

*AIC
display -2 * e(ll) + 2*3
*BIC
display -2 * e(ll) + 3*ln(e(N))


// Limelight
version 11: ml model lf MLexpo (alpha: decision = ) (beta:)  (noise: )  if exp2 & lim ///
, maximize search(on) init(  0.01   .00001   .19    , copy) iter(10) technique(dfp bfgs)  vce(cluster subject)
ml display
* Convergence towards CARA, so we estimate a CARA model in this case 
version 11: ml model lf MLcara (alpha: decision = )  (noise: )  if exp2 & limelight ///
, maximize search(on) init(    0.010         .2, copy) iter(20)  vce(cluster subject)
ml display
est store MLeutLim2

lrtest MLneutralLim2 MLeutLim2, df(2) force

*AIC
display -2 * e(ll) + 2*3
*BIC
display -2 * e(ll) + 3*ln(e(N))


est table  MLeutLab2 MLeutCB2 MLeutLim2, star(0.01 0.05 0.1) stats(ll N)


// Comparing the Beta parameter between the lab treatments
version 11: ml model lf MLcrra (beta: decision = comeback)  (noise: comeback )  if exp2&(lab|comeback) ///
, maximize search(on) init(0.27  -.60  -0.12 .41 , copy) iter(20)  vce(cluster subject)
ml display


//////////////////////////////
////// PT tests         //////
//////////////////////////////

// Lab
version 11: ml model lf MLpt (alpha: decision = ) (lambda:  ) (theta1:  )  ///
 (theta2:  ) (noise: )  if exp2&lab , maximize iter(40) technique (dfp)             ///
  init(.40869763 1.2593326 1.0018527  -.00937187 .22344563, copy) search(on)  vce(cluster subject)
ml display
est store MLptLab2
est table, star(0.01 0.05 0.1) stats(aic, bic, ll N)

test [alpha]_cons==1
test [lambda]_cons==1
test [theta1]_cons==0
test [theta2]_cons==0
test [noise]_cons==0

// Comeback
version 11: ml model lf MLpt (alpha: decision = ) (lambda:  ) (theta1:  ) ///
  (theta2:  ) (noise: )  if exp2&comeback , maximize iter(40) technique (dfp )             ///
  init(.64416409 1.4043464 1.0152062  -.06869766 .16289193, copy)  search(on) vce(cluster subject)
ml display
est store MLptCB2
est table MLptCB2, star(0.01 0.05 0.1) stats(aic, bic, ll N)

test [alpha]_cons==1
test [lambda]_cons==1
test [theta1]_cons==0
test [theta2]_cons==0
test [noise]_cons==0

// Limelight
version 11: ml model lf MLpt (alpha: decision = ) (lambda:  ) (theta1:  )  ///
 (theta2:  ) (noise: )   if exp2&limelight , maximize iter(40) technique (dfp)             ///
  init(.75078456 1.8632522 1.0883977 -.15420736 .23108512, copy)  search(on) vce(cluster subject) 
ml display
est store MLptLim2
est table, star(0.01 0.05 0.1) stats(aic, bic, ll N)

test [alpha]_cons==1
test [lambda]_cons==1
test [theta1]_cons==0
test [theta2]_cons==0
test [noise]_cons==0

est table MLptLab2 MLptCB2 MLptLim2, star(0.01 0.05 0.1) stats(aic, bic, ll N)


// Combined
version 11: ml model lf MLpt (alpha: decision = comeback limelight ) (lambda: comeback limelight ) (theta1: comeback limelight )  ///
  (theta2: comeback limelight ) (noise: comeback limelight )  if exp2, maximize  iter(80) search(on)          ///
  init(.23052841 .34236592 .40857674 .1472385 .6038277 1.2596819  .012982 .0867105 1.0018525 -.05764671 -.14512201  -.0093703 -.06053312 .00778017 .22330256    ,copy)   vce(cluster subject)          
ml display
est store MLptcomb2
est table MLptLab2 MLptCB2 MLptLim2 , star(0.01 0.05 0.1) stats(aic, bic, ll N)

test [alpha]comeback == [alpha]limelight
test [lambda]comeback== [lambda]limelight
test [theta1]comeback== [theta1]limelight
test [theta2]comeback== [theta2]limelight
test [noise]comeback == [noise]limelight


/////////////////////////////////////////
/////////////////////////////////////////
////// Comparing Between Experiments ////
/////////////////////////////////////////
/////////////////////////////////////////

//////////////////////////////
////// EU Estimations   //////
//////////////////////////////

// Lab
version 11: ml model lf MLcrra (beta: decision = exp1 ) (noise: exp1 ) if lab, ///
maximize search(on) init(0 -0.1 0 0.2 , copy) iter(20) vce(cluster subject)
ml display
est store Lab_amb

// Limelight
version 11: ml model lf MLcara (alpha: decision = exp1 )  (noise: exp1 ) if lim, ///
maximize search(on) init(0 0.1  0.2 0.2 , copy) iter(20) vce(cluster subject)
ml display
est store Lim_amb

est table MLeutLab MLeutLab2 , star(0.01 0.05 0.1) stats(aic, bic, ll N)
est table MLeutLim MLeutLim2 , star(0.01 0.05 0.1) stats(aic, bic, ll N)
est table Lab_amb Lim_amb, star(0.01 0.05 0.1) stats(aic,bic,ll N)

//////////////////////////////
////// PT tests         //////
//////////////////////////////


// Lab
est table MLptLab MLptLab2 , star(0.01 0.05 0.1) stats(aic, bic, ll N)

version 11: ml model lf MLpt (alpha: decision = exp1) (lambda: exp1 ) (theta1: exp1 )   ///
 (theta2: exp1 ) (noise: exp1 )  if lab , maximize iter(80) technique ( dfp bfgs )             ///
  init(.1453 .40849 .245559  1.259  .01237  1.0018 -.0352 -.00936  .111 .2234    ,copy) search(on) vce(cluster subject) 
ml display


// Limelight
est table MLptLim MLptLim2 , star(0.01 0.05 0.1) stats(aic, bic, ll N)

version 11: ml model lf MLpt (alpha: decision = exp1) (lambda: exp1 ) (theta1: exp1 )   ///
 (theta2: exp1 ) (noise: exp1 )  if limelight , maximize iter(80) technique(dfp bfgs)            ///
  init(-.0402 .75078 .9618 1.8632 -.0488 1.088 .0823 -.1542 .0258 .23108 ,copy) search(on) vce(cluster subject) 
ml display


