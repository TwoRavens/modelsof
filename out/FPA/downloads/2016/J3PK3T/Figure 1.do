set more off

#delimit;

ologit LoTMilitaryRecode p_polity2lag gdppclag poplag civilwarlag ucdp_type2lag catlag ITERATELoclag RstrctAccess dissentlag, robust cluster (ccodecow) nolog;

prgen ITERATELoclag, from(0) to (100) generate(prob) x(civilwarlag=0 ucdp_type2lag=0 catlag=1 RstrctAccess=0 dissentlag=0) rest(mean) ncases(10);

desc prob*;

label var probp0 "None";
label var probp1 "Infrequent";
label var probp2 "Often";
label var probp3 "Regular";
label var probp4 "Widespread";
label var probp5 "Systemic";

graph twoway connected probp0 probp1 probp2 probp3 probp4 probp5 probx, 
title("Predicted Probability of Military Torture")
subtitle("as Transnational Terror Increases") 
xtitle("Number of Transnational Terrorist Attacks") ylabel(0(.25)1) xlabel(0(10)100) 
yscale(noline) ylabel("") name(graph1, replace)
ytitle("Predicted Probability");

drop probx probp0 probp1 probp2 probp3 probp4 probp5 probs0 probs1 probs2 probs3 probs4 probs5;
