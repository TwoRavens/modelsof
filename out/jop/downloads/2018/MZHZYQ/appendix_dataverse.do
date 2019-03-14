clear
clear matrix
set more off

cd "~\Data"
use republicanincomeinequality113_northsouth, clear

*** APPENDIX - SECTION 2 ***
for any top1 top1_posttax top1_capital invert_pareto : cor housedemsouth113 housedemnorth113 housedem113 X
cor gini_family housedemsouth113 housedemnorth113 housedem113

for any top1 top1_posttax top1_capital invert_pareto : cor senatedemsouth113 senatedemnorth113 senatedem113 X
cor gini_family senatedemsouth113 senatedemnorth113 senatedem113


*** APPENDIX - SECTION 3 ***

use republicanincomeinequality_vetopoints, clear

* Create Lags and Differences

tsset cong

gen dhouserep = d.houserep
gen lhouserep = l.houserep

gen dhousedem = d.housedem
gen lhousedem = l.housedem

gen lsenaterep = l.senaterep
gen dsenaterep = d.senaterep

gen lsenatedem = l.senatedem
gen dsenatedem = d.senatedem


* Table 3A1
for any top1 top1_posttax top1_capital gini_family invert_pareto: eststo rhX: reg d.X dhouserep lhouserep d.demprez l.demprez d.demhouse l.demhouse d.divide_gov l.divide_gov l.X


* Table 3A2
for any top1 top1_posttax top1_capital gini_family invert_pareto: eststo rsX: reg d.X dsenaterep lsenaterep d.demprez l.demprez d.demsenate l.demsenate  d.divide_gov l.divide_gov l.X


*** APPENDIX - SECTION 4 ***

use republicanincomeinequality113, clear

tsset cong

for any top1 top1_posttax top1_capital gini_family invert_pareto: gen dX = d.X
for any houserep senaterep housedem senatedem housepolar senatepolar: gen dX = d.X
for any top1 top1_posttax top1_capital gini_family invert_pareto: gen ldX = l.d.X
for any houserep senaterep housedem senatedem housepolar senatepolar: gen ldX = l.d.X

* Table 4A1
foreach x of varlist top1 top1_posttax top1_capital gini_family invert_pareto{
 reg d`x' ld`x' ldhouserep, beta
}


foreach x of varlist top1 top1_posttax top1_capital gini_family invert_pareto{
 reg d`x' ld`x' ldsenaterep
}

* Table 4A2
foreach x of varlist top1 top1_posttax top1_capital gini_family invert_pareto{

reg dhouserep ldhouserep ld`x', beta

}

foreach x of varlist top1 top1_posttax top1_capital gini_family invert_pareto{

reg dsenaterep ldsenaterep ld`x', beta

}

* Table 4A3

foreach x of varlist top1 top1_posttax top1_capital gini_family invert_pareto{
 reg d`x' ld`x' ldhousedem, beta
}


foreach x of varlist top1 top1_posttax top1_capital gini_family invert_pareto{
reg d`x' ld`x' ldsenatedem
}



* Table 4A4

foreach x of varlist top1 top1_posttax top1_capital gini_family invert_pareto{

reg dhousedem ldhousedem ld`x', beta

}

foreach x of varlist top1 top1_posttax top1_capital gini_family invert_pareto{

reg dsenatedem ldsenatedem ld`x', beta

}

* Table 4A5

foreach x of varlist top1 top1_posttax top1_capital gini_family invert_pareto{
reg d`x' ld`x' ldhousepolar, beta
}


foreach x of varlist top1 top1_posttax top1_capital gini_family invert_pareto{
reg d`x' ld`x' ldsenatepolar, beta
}


* Table 4A6

foreach x of varlist top1 top1_posttax top1_capital gini_family invert_pareto{

reg dhousepolar ldhousepolar ld`x', beta

}

foreach x of varlist top1 top1_posttax top1_capital gini_family invert_pareto{

reg dsenatepolar ldsenatepolar ld`x', beta

}

