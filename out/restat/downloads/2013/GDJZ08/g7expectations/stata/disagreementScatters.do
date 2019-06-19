
#delimit;

local basepath0 "C:/Jirka/Research/g7expectations";

local basepath "`basepath0'/g7expectations";
global basepath "`basepath'";

cd "$basepath/stata/graphs";
local Ccodes cn fr ge it jp uk us;
local variable infl gdp r3m cons un;
set scheme s1mono;
gr drop _all;

gen mseVariable=.;
gen disagreementVariable=.;
gen levelVariable=.;
gen varianceVariable=.;
gen labelVariable=".";

gen mseVariableBR=.;
gen disagreementVariableBR=.;
gen varianceVariableBR=.;
gen labelVariableBR=".";
gen varIdentifier=".";

local counter 1;

* Put scalars into vars;
foreach var of local variable {;
	foreach C of local Ccodes {;

		qui replace mseVariable=`var'meanmeane2Full`C' in `counter';
		qui replace disagreementVariable=`var'meandisagrFull`C' in `counter';
		qui replace levelVariable=`var'meanLevelFull`C' in `counter';
		qui replace varianceVariable=`var'VarFull`C' in `counter';
		local label_1=upper("`var'"); local label_2=upper("`C'"); 
		qui replace labelVariable="`label_2'`label_1'" in `counter';

		local counter=`counter'+1;
	};
};

local variable infl gdp r3m cons un;
local counter 1;

foreach var of local variable {;
	foreach C of local Ccodes {;

		qui replace mseVariableBR=`var'meanmeane2Boom`C' in `counter';
		qui replace disagreementVariableBR=`var'meandisagrBoom`C' in `counter';
		qui replace varianceVariableBR=`var'VarBoom`C' in `counter';
		local label_1=upper("`var'"); local label_2=upper("`C'"); 
		qui replace labelVariableBR="`label_2'`label_1'_B" in `counter';
		qui replace varIdentifier="`var'" in  `counter';
		
		local counter=`counter'+1;
	};
};

foreach var of local variable {;
	foreach C of local Ccodes {;

		qui replace mseVariableBR=`var'meanmeane2Recession`C' in `counter';
		qui replace disagreementVariableBR=`var'meandisagrRecession`C' in `counter';
		qui replace varianceVariableBR=`var'VarRecession`C' in `counter';
		local label_1=upper("`var'"); local label_2=upper("`C'"); 
		qui replace labelVariableBR="`label_2'`label_1'_R" in `counter';
		qui replace varIdentifier="`var'" in  `counter';
		
		local counter=`counter'+1;
	};
};

* Draw scatters;

* Disagreement&MSE vs. Level&Variance;
graph twoway (scatter mseVariable levelVariable, mlabel(labelVariable)) (lfit mseVariable levelVariable, clwidth(medthick) lcolor(black)),	name(scatMseLevel) legend(off) ytitle("MSE") xtitle("") xscale(range(0 11.0));
graph save scatMseLevel scatMseLevel, asis replace;

graph twoway (scatter mseVariable varianceVariable, mlabel(labelVariable)) (lfit mseVariable varianceVariable, clwidth(medthick) lcolor(black)),	name(scatMseVariance) legend(off) ytitle("") xtitle("");
graph save scatMseVariance scatMseVariance, asis replace;

graph twoway (scatter disagreementVariable levelVariable, mlabel(labelVariable)) (lfit disagreementVariable levelVariable, clwidth(medthick) lcolor(black)),	name(scatDisagreementLevel) legend(off) ytitle("Disagreement (%)") xtitle("Level (%)") xscale(range(0 11.0));
graph save scatDisagreementLevel scatDisagreementLevel, asis replace;

graph twoway (scatter disagreementVariable varianceVariable, mlabel(labelVariable)) (lfit disagreementVariable varianceVariable, clwidth(medthick) lcolor(black)),	name(scatDisagreementVariance) legend(off) ytitle("") xtitle("Variance");
graph save scatDisagreementVariance scatDisagreementVariance, asis replace;

graph combine scatMseLevel scatMseVariance scatDisagreementLevel scatDisagreementVariance, rows(2) cols(2) graphregion(margin(l=12 r=12)) imargin(zero) scale(0.75) name(mseDisAll);
graph save mseDisAll mseDisAll$disagrVar, asis replace;
graph export mseDisAll$disagrVar.eps, replace;

erase scatmselevel.gph; erase scatmsevariance.gph; erase scatdisagreementlevel.gph; erase scatdisagreementvariance.gph;
gr drop scatMseLevel; gr drop scatMseVariance; gr drop scatDisagreementLevel; gr drop scatDisagreementVariance;

* Disagreement&MSE vs Variance in Booms and Recessions;
local graphlist "";
foreach var of local variable {;

	local graphlist "`graphlist' scatDisagreementVarianceBR`var'";
	local header=upper("`var'");
	graph twoway (scatter disagreementVariableBR varianceVariableBR if varIdentifier=="`var'", mlabel(labelVariableBR)) (lfit disagreementVariableBR varianceVariableBR if varIdentifier=="`var'", clwidth(medthick) lcolor(black)), name(scatDisagreementVarianceBR`var') legend(off) title(`header');
	graph save scatDisagreementVarianceBR`var' scatDisagreementVarianceBR`var', asis replace;

};

graph combine `graphlist', cols(2) graphregion(margin(l=12 r=12)) imargin(small) scale(0.75) name(disagreementVarianceAll);
graph save disagreementVarianceAll disagreementVarianceAll$disagrVar, asis replace;
graph export disagreementVarianceAll$disagrVar.eps, replace;
foreach var of local variable {; erase scatdisagreementvariancebr`var'.gph; gr drop scatDisagreementVarianceBR`var'; };

local graphlist "";
foreach var of local variable {;

	local graphlist "`graphlist' scatMseVarianceBR`var'";
	local header=upper("`var'");
	graph twoway (scatter mseVariableBR varianceVariableBR if varIdentifier=="`var'", mlabel(labelVariableBR)) (lfit mseVariableBR varianceVariableBR if varIdentifier=="`var'", clwidth(medthick) lcolor(black)), name(scatMseVarianceBR`var') legend(off) title(`header');
	graph save scatMseVarianceBR`var' scatMseVarianceBR`var', asis replace;

};

graph combine `graphlist', cols(2) graphregion(margin(l=12 r=12)) imargin(small) scale(0.75) name(mseVarianceAll);
graph save mseVarianceAll mseVarianceAll$disagrVar, asis replace;
graph export mseVarianceAll$disagrVar.eps, replace;
foreach var of local variable {; erase scatmsevariancebr`var'.gph; gr drop scatMseVarianceBR`var'; };

drop mseVariable disagreementVariable levelVariable varianceVariable labelVariable mseVariableBR disagreementVariableBR labelVariableBR varianceVariableBR varIdentifier;

cd "$basepath/stata";
