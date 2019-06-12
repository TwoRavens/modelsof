
*ISQ Replication

*Table 1: Generates list of fences

list stateA origin year datefenced if fence==1

*Table 2: Preliminary look

tab1 fenced incident

*The rest of the code replicates the balance metrics followed by treatment effects presented in Figures 1 and 2, respectively.

*Propensity Score model with caliper

psmatch2 fenced dyadalliance logpop incidentsumlag ethnictie polity2b polity2borigin loggdptarget ///
logGDPorigin cinctarget cincorigin  simmonsdispute samecivrussett mid, ///
  outcome(incident) caliper(.01)

  *balance for propensity score
  pstest dyadalliance logpop incidentsumlag ethnictie polity2b polity2borigin loggdptarget logGDPorigin cinctarget cincorigin simmonsdispute samecivrussett mid
  
  *Nearest neighbor with caliper
  
  psmatch2 fenced, mahal( dyadalliance logpop incidentsumlag ethnictie polity2b polity2borigin loggdptarget logGDPorigin ///
  cinctarget cincorigin simmonsdispute samecivrussett mid) outcome(incident) caliper(1)
  
  *balance
  pstest dyadalliance logpop incidentsumlag ethnictie polity2b polity2borigin loggdptarget logGDPorigin cinctarget cincorigin simmonsdispute samecivrussett mid

    *NN with bootstraped SEs
 bootstrap r(att): psmatch2 fenced, mahal( dyadalliance logpop incidentsumlag ethnictie polity2b polity2borigin loggdptarget logGDPorigin ///
  cinctarget cincorigin simmonsdispute samecivrussett mid) outcome(incident) caliper(1)
  
  *balance
  pstest dyadalliance logpop incidentsumlag ethnictie polity2b polity2borigin loggdptarget logGDPorigin cinctarget cincorigin simmonsdispute samecivrussett mid

  *NN with Bias adjusted
  nnmatch incident fenced dyadalliance logpop incidentsumlag ethnictie polity2b polity2borigin loggdptarget logGDPorigin cinctarget ///
  cincorigin simmonsdispute samecivrussett mid , tc(att)  biasadj(bias)
  
  pstest dyadalliance logpop incidentsumlag ethnictie polity2b polity2borigin loggdptarget logGDPorigin cinctarget ///
  cincorigin simmonsdispute samecivrussett mid
  
  *NN with log number of attacks
  
   psmatch2 fenced, mahal( dyadalliance logpop incidentsumlag ethnictie polity2b polity2borigin loggdptarget logGDPorigin cinctarget cincorigin ///
   simmonsdispute samecivrussett mid) outcome(lnincidentannualsum) caliper(1)
  
  pstest dyadalliance logpop incidentsumlag ethnictie polity2b polity2borigin loggdptarget logGDPorigin cinctarget ///
  cincorigin simmonsdispute samecivrussett mid

  
  *Supplementary file
  
 *Replicates baseline model, presented in Table A of the online appendix
  
  egen dyadno=group(cowcode1 cowcode2)
  
  eststo m1, title("Model 1"): relogit incident  fenced olddismantled incidentsumlag simmonsdispute dyadalliance mid logpop cinctarget cincorigin polity2b polity2borigin loggdptarget logGDPorigin ethnictie ///
  commoncivilizationrussett dyadpcyear1 dyadpcyear2 dyadpcyear3 dyadpcyear4 , cl(dyadno)

  lab var incidentsumlag "Incident sum (lagged)"
  lab  var fenced "Border Fenced"
  lab var olddismantled "Dismantled fence"
  lab var dyadalliance "Dyadic alliance"
  lab var mid "Militarized dispute"
  lab var logpop "Target log population"
  lab var majpowhome "Target major powe"
  lab var polity2b "Target democracy"
  lab var polity2borigin "Origin democracy"
  lab var cincorigin "Origin capabilities"
  lab var cinctarget "Target capabilities"
  lab var loggdptarget "Target log GDP per capita"
  lab var logGDPorigin "Origin log GDP"
  lab var commoncivilizationrussett "Common civilization"
  lab var simmonsdispute "Border Dispute"
  lab var ethnictie "Ethnic tie"
  
  *Set Directory (alter as you see fit)
  cd "C:\Documents\Fences ISQ replication"
  
 estout m1,  cells(b(star fmt(3)label(Coef.)) se(par fmt(3))) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) ///
stats(chi p rho N , labels("Chi squared" "Model Fit" "rho" "observations")) label legend varlabels(_cons Constant) varwidth(30) modelwidth(10) ///
 collabel(coefficient) style(fixed) ///
 order (fenced olddismantled incidentsumlag simmonsdispute dyadalliance mid logpop  polity2b polity2borigin cinctarget cincorigin loggdptarget logGDPorigin ethnictie ///
  commoncivilizationrussett dyadpcyear1 dyadpcyear2 dyadpcyear3 dyadpcyear4)  ///
, using tableAappendix.txt, replace


*Replicates alternative model matching on peace years
*Balance statistics presented in Figure A1 and treatment effects in A2 in the online appendix 

*Propensity Score
psmatch2 fenced dyadalliance logpop peaceyrsdyad ethnictie polity2b polity2borigin loggdptarget logGDPorigin ///
cinctarget cincorigin simmonsdispute commoncivilizationrussett  mid,  outcome(incident) caliper(.01)

 pstest dyadalliance logpop peaceyrsdyad ethnictie polity2b polity2borigin loggdptarget logGDPorigin ///
 cinctarget cincorigin simmonsdispute commoncivilizationrussett  mid
 

*Nearest Neighbor

psmatch2 fenced, mahal(dyadalliance logpop peaceyrsdyad ethnictie polity2b polity2borigin loggdptarget logGDPorigin cinctarget cincorigin simmonsdispute ///
commoncivilizationrussett  mid) outcome(incident) caliper(1)

 pstest dyadalliance logpop peaceyrsdyad ethnictie polity2b polity2borigin loggdptarget logGDPorigin ///
 cinctarget cincorigin simmonsdispute commoncivilizationrussett  mid


