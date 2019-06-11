#delimit;
set more off;
graph drop _all;

******************************************************************************************************
******************************************************************************************************
/*Read CSES module 2*/;
use cses2.dta, clear;

/*Drop elections that are missing either income, corruption, or education*/;
drop if B1004=="BEL_2003"|B1004=="KGZ_2005";

/*encode election number to simplify*/;
encode B1004, gen(country_num);

/*create iso country codes*/;
destring B1006, gen(iso_p);
replace iso_p=2760 if iso_p==2761|iso_p==2762;
replace iso_p=1520 if iso_p==1502;
gen iso=iso_p/10;
gen year=B1008;

/*Create outcome*/;
gen corruption=5-B3044 if B3044<5;

/*Create a dichotomous outcome variable based on the national average*/;
gen corruption2=.;
gen corruption_mean=.;
forvalues i=1(1)39 {;
sum corruption if country_num==`i';
replace corruption_mean=r(mean);
replace corruption2=1 if corruption>corruption_mean & corruption!=. & country_num==`i';
replace corruption2=0 if corruption<corruption_mean & corruption!=. & country_num==`i';
};

/*create predictors*/;
gen Male=2-B2002 if B2002<3;
gen Education=B2003 if B2003<9;
gen Income=B2020 if B2020<6;
gen Age=B2001 if B2001<997;

/*merge with macro data. divide per capita GDP by 1000, interact predictors with per capita GDP and gini index*/;
sort iso year;
merge m:1 iso year using cp_macro.dta;
gen gdp=rgdpl/1000;
gen incxgdp=Income*gdp;
gen malexgdp=Male*gdp;
gen eduxgdp=Educ*gdp;
gen agexgdp=Age*gdp;
gen incxgini=Income*gini;
gen malexgini=Male*gini;
gen eduxgini=Educ*gini;
gen agexgini=Age*gini;

/*pooled regression with multiple predictors.  Model (1)-(4) in Table A3*/;
tab country_num, gen(countrydum);
drop countrydum39;
regress corruption Income countrydum*;
est store csesinc;
regress corruption Education countrydum*;
est store cseseduc;
regress corruption Male countrydum*;
est store csesmale;
regress corruption Income Education countrydum*;
est store csesinceduc;
regress corruption Income Education Male countrydum*;
est store csesinceducmale;
regress corruption Income Education Male Age countrydum*;
est store csesinceducmaleage;

outreg2 Income Education Male Age
	[csesinc csesinceduc csesinceducmale csesinceducmaleage] 
	using TableA3.xls, bdec(3) 2aster replace;

/*Multilevel model. Table A4*/;
xtmixed corruption Income gdp incxgdp||country_num:Income;
est store cses2inc;
xtmixed corruption Education gdp eduxgdp||country_num:Education;
est store cses2edu;
xtmixed corruption Male gdp malexgdp||country_num:Male;
est store cses2male;
xtmixed corruption Age gdp agexgdp||country_num:Age;
est store cses2age;
xtmixed corruption Income gini incxgini||country_num:Income;
est store cses2incgini;
xtmixed corruption Income gdp gini incxgdp incxgini||country_num:Income;
est store cses2incginigdp;
xtmixed corruption Income Education gdp incxgdp eduxgdp||country_num:Income Education;
est store cses2inceduc;
xtmixed corruption Income Education Male Age gdp incxgdp eduxgdp malexgdp agexgdp||country_num:Income Education Male Age;
est store cses2all;
outreg2 [cses2*] using TableA4.xls,bdec(3) 2aster replace;

/*Multilevel logistic regression. Model (1)- (3) in Table A7*/;
xtmelogit corruption2 Income gdp incxgdp||country_num:Income, laplace;
est store cses22inc;
xtmelogit corruption2 Education gdp eduxgdp||country_num:Education, laplace;
est store cses22edu;
xtmelogit corruption2 Male gdp malexgdp||country_num:Male, laplace;
est store cses22male;
xtmelogit corruption2 Income Education Male gdp incxgdp eduxgdp malexgdp||country_num:Income Education Male, laplace;
est store cses22all;
outreg2 [cses22*] using TableA7.xls,bdec(3) ;

/*Now for the two-step model. First I create some new variables to save country-level results*/;
gen survey=.;
label values survey country_num;
gen sample=.;
gen mean=.;
gen isoaxis=.;
gen yearaxis=.;
gen gdppc=.;
gen giniaxis=.;
local vars Income Education Male;
foreach j of local vars{;
	gen coef_`j'=.;
	gen ciu_`j'=.;
	gen cil_`j'=.;
	};

/*Run the two-step model.*/;
forvalues i=1(1)39 {;
	replace survey=`i' if _n==`i';
	sum corruption if country_num==`i';
	replace sample=r(N) if survey==`i';
	replace mean=r(mean) if survey==`i';
	sum iso if country_num==`i';
	replace isoaxis=r(mean) if survey==`i';
	sum year if country_num==`i';
	replace yearaxis=r(mean) if survey==`i';
	sum gdp if country_num==`i';
	replace gdppc=r(mean) if survey==`i';
	sum gini if country_num==`i';
	replace giniaxis=r(mean) if survey==`i';
	foreach j of local vars{;
		reg corruption `j' if country_num==`i';
		matrix biv=e(b);
		matrix sebiv=e(V);
		svmat biv;
		svmat sebiv;
		replace coef_`j'=biv1[1] if survey==`i';
		replace ciu_`j'=coef_`j'+1.96*sqrt(sebiv1[1]) if survey==`i';
		replace cil_`j'=coef_`j'-1.96*sqrt(sebiv1[1]) if survey==`i';
		drop biv* sebiv*; 
		};
	};
/*Graph for sample size. Rescale GDP per capita to the original values. Figure A1*/;
replace mean=1.2 in 100;
replace gdppc=gdppc*1000;
replace gdppc=1000 in 100;
replace sample=1000 in 100;
twoway (scatter mean gdppc [fweight = sample], mcolor(black) msymbol(circle_hollow)),
	ytitle("") 
	xtitle("") 
	ylabel(1(1)4)
	title((1) CSES)
	text(1.22 5100 "n = 1000")
	graphregion(color(white))
	name(csessample);

/* Repeat the two-step model with control variables for income*/;
foreach j of local vars{;
	gen coef_`j'_c=.;
	gen ciu_`j'_c=.;
	gen cil_`j'_c=.;
	};

forvalues i=1(1)39 {;
	reg corruption Income Education Male Age if country_num==`i';
		matrix biv=e(b);
		matrix sebiv=e(V);
		svmat biv;
		svmat sebiv;
		replace coef_Income_c=biv1[1] if survey==`i';
		replace ciu_Income_c=coef_Income_c+1.96*sqrt(sebiv1[1]) if survey==`i';
		replace cil_Income_c=coef_Income_c-1.96*sqrt(sebiv1[1]) if survey==`i';
		drop biv* sebiv*; 
		};

/*Graph for gdp controlling for education, gender, and age. Left panel in Figure A2*/;
twoway
		(rbar ciu_Income cil_Income gdppc, lcolor(gray))
		(scatter coef_Income gdppc, mcolor(gray))
		(lowess coef_Income gdppc, lcolor(gray))
		(rbar ciu_Income_c cil_Income_c gdppc, lcolor(black))
		(scatter coef_Income_c gdppc, mcolor(black))
		(lowess coef_Income_c gdppc, lcolor(black)),
		legend(off)
		yline(0, lcolor(black) lpattern(dash))
		xtitle("")
		ytitle("")
		title(CSES)
		graphregion(color(white))
		name(csesIncomecontrols);

/*Control for ethnicity. Left panel in Figure A4*/;
gen coef_Income_e=.;
gen ciu_Income_e=.;
gen cil_Income_e=.;

gen ETHNIC=B2029;

forvalues i=1(1)39 {;
	xi: reg corruption Income i.ETHNIC if country_num==`i';
		matrix biv=e(b);
		matrix sebiv=e(V);
		svmat biv;
		svmat sebiv;
		replace coef_Income_e=biv1[1] if survey==`i';
		replace ciu_Income_e=coef_Income_e+1.96*sqrt(sebiv1[1]) if survey==`i';
		replace cil_Income_e=coef_Income_e-1.96*sqrt(sebiv1[1]) if survey==`i';
		drop biv* sebiv*; 
		};

twoway
		(rbar ciu_Income cil_Income gdppc, lcolor(gray))
		(scatter coef_Income gdppc, mcolor(gray))
		(lowess coef_Income gdppc, lcolor(gray))
		(rbar ciu_Income_e cil_Income_e gdppc if coef_Income_e!= coef_Income, lcolor(black))
		(scatter coef_Income_e gdppc if coef_Income_e!= coef_Income, mcolor(black))
		(lowess coef_Income_e gdppc if coef_Income_e!= coef_Income, lcolor(black)), 
		legend(off)
		yline(0, lcolor(black) lpattern(dash))
		title("CSES")
		xtitle("")
		ytitle("")
		graphregion(color(white)) bgcolor(white)
		name(cseseth);	

/*Graph for inequality. First row in Figure A5*/;
foreach j of local vars{;
	twoway(rbar ciu_`j' cil_`j' giniaxis, lcolor(black) lwidth(none) barwidth(0.01))
		(scatter coef_`j' giniaxis, mcolor(black))
		(lowess coef_`j' giniaxis, lcolor(black)),
		legend(off)
		yline(0, lcolor(black) lpattern(dash))
		xtitle("")
		ytitle("")
		title(`j')
		xscale(reverse)
		graphregion(color(white)) bgcolor(white)
		name(cses`j');
	};
graph combine csesIncome csesEducation,
	rows(1)
	xsize(6)
	ysize(3)
	b1title(Gini Index)
	l1title(Coefficients)
	title((1) CSES, position(11))
	graphregion(color(white))
	name(csesgini)
	;

graph drop csesIncome csesEducation csesMale;

/*Now the two-step model with binary outcomes. First, transform variables. For CSES, I recode education*/;
replace Education=Education-1;
replace Education=1 if Education==0;
replace Education=Education-1 if Education==6 | Education==7;

/*Get the country-level estimates*/;
foreach j of local vars{;
	gen coef_`j'2=.;
	gen ciu_`j'2=.;
	gen cil_`j'2=.;
	};

forvalues i=1(1)39 {;
	foreach j of local vars{;
		reg corruption2 `j' if country_num==`i';
		matrix biv=e(b);
		matrix sebiv=e(V);
		svmat biv;
		svmat sebiv;
		replace coef_`j'2=biv1[1] if survey==`i';
		replace ciu_`j'2=coef_`j'2+1.96*sqrt(sebiv1[1]) if survey==`i';
		replace cil_`j'2=coef_`j'2-1.96*sqrt(sebiv1[1]) if survey==`i';
		drop biv* sebiv*; 
		};
	};

foreach j of local vars{;
	twoway(rbar ciu_`j'2 cil_`j'2 gdppc, lcolor(black))
		(scatter coef_`j'2 gdppc, mcolor(black))
		(lowess coef_`j'2 gdppc, lcolor(black)),
		legend(off)
		yline(0, lcolor(black) lpattern(dash))
		xtitle("")
		ytitle("")
		title(`j')
		graphregion(color(white)) bgcolor(white)
		name(cses`j'2);
	};

/*First row of Figure A6*/;
graph combine csesIncome2 csesEducation2,
	ycommon
	rows(1)
	xsize(6)
	ysize(3)
	b1title(Per Capita GDP)
	l1title(Coefficients)
	title((1) CSES, position(11))
	graphregion(color(white))
	name(csesgraph2);
graph drop csesIncome2 csesEducation2 csesMale2;
******************************************************************************************************
******************************************************************************************************

/*Read World Values Survey integrated longitudinal dataset and keep wave 3*/;
use wvs.dta, clear;
keep if S002==3;
drop if S024==1563 | S024==1913| S024==3483 | S024==3923 | S024==5863 |S024==6083 |S024==7053;

/*Generate survey number and encode it*/;
gen eid=S024;
sort eid;
decode S024, gen(country);
encode country, gen(country_num);

/*Generate iso code and year*/;
gen iso=S003;
gen year=S025-iso*10000;
replace year=1997 if iso==170;

/*generate oucomes*/;
gen corruption=E196 if E196>0;
gen corruption_mean=.;
gen corruption2=.;
gen cor12=corruption>1 if corruption!=.;
gen cor23=corruption>2 if corruption!=.;
gen cor34=corruption>3 if corruption!=.;
forvalues i=1(1)47{;
	sum corruption if country_num==`i';
	replace corruption_mean=r(mean) if country_num==`i';
	replace corruption2=1 if corruption>corruption_mean & corruption!=. & country_num==`i';
	replace corruption2=0 if corruption<=corruption_mean & corruption!=. & country_num==`i';
	};

/*generate predictors*/;
gen Male=2-X001 if X001>0;
gen Education=X025 if X025>0;
gen Income=X047 if X047>0;
gen Age=X003 if X003>0;

/*generate trust variable*/;
gen Trust=2-A165 if A165>0;

/*merge with macro data. divide per capita GDP by 1000, interact predictors with per capita GDP and gini index*/;
sort iso year;
merge m:1 iso year using cp_macro.dta;
gen gdp=rgdpl/1000;
gen incxgdp=Income*gdp;
gen malexgdp=Male*gdp;
gen eduxgdp=Educ*gdp;
gen agexgdp=Age*gdp;
gen incxgini=Income*gini;
gen malexgini=Male*gini;
gen eduxgini=Educ*gini;
gen agexgini=Age*gini;

/*Pooled regression with multiple predictors and country dummies. Model (5)-(8) in Table A3*/;
tab country_num, gen(countrydum);
drop countrydum45;
regress corruption Income countrydum*;
est store wvsinc;
regress corruption Income Education countrydum*;
est store wvsinceduc;
regress corruption Income Education Male countrydum*;
est store wvsinceducmale;
regress corruption Income Education Male Age countrydum*;
est store wvsinceducmaleage;

outreg2 Income Education Male Age 
	[wvsinc wvsinceduc wvsinceducmale wvsinceducmaleage] 
	using TableA3.xls, bdec(3) 2aster;

/*Multilevel Models. Table A5*/;
xtmixed corruption Income gdp incxgdp||country_num:Income;
est store wvs2inc;
xtmixed corruption Education gdp eduxgdp||country_num:Education;
est store wvs2edu;
xtmixed corruption Male gdp malexgdp||country_num:Male;
est store wvs2male;
xtmixed corruption Age gdp agexgdp||country_num:Age;
est store wvs2age;
xtmixed corruption Income gini incxgini||country_num:Income;
est store wvs2incgini;
xtmixed corruption Income gdp gini incxgdp incxgini||country_num:Income;
est store wvs2incginigdp;
xtmixed corruption Income Education gdp incxgdp eduxgdp||country_num:Income Education;
est store wvs2inceduc;
xtmixed corruption Income Education gdp Male Age incxgdp eduxgdp malexgdp agexgdp||country_num:Income Education Male Age;
est store wvs2all;
outreg2 [wvs2*] using TableA5.xls, replace bdec(3) 2aster;

/*Mixed-effects logistic regression. Model (4)-(6) in Table A7*/;
xtmelogit corruption2 Income gdp incxgdp||country_num:Income, laplace;
est store wvs22inc;
xtmelogit corruption2 Education gdp eduxgdp||country_num:Education, laplace;
est store wvs22edu;
xtmelogit corruption2 Male gdp malexgdp||country_num:Male, laplace;
est store wvs22male;
xtmelogit corruption2 Income Education Male gdp incxgdp eduxgdp malexgdp||country_num:Income Education Male, laplace;
est store wvs22all;
outreg2 [wvs22*] using TableA7.xls,bdec(3);

/*Now for the two-step model. First I create some new variables to save country-level results*/;
gen survey=.;
label values survey country_num;
gen sample=.;
gen mean=.;
gen isoaxis=.;
gen yearaxis=.;
gen gdppc=.;
gen giniaxis=.;
local vars Income Education Male;
foreach j of local vars{;
	gen coef_`j'=.;
	gen ciu_`j'=.;
	gen cil_`j'=.;
	};

forvalues i=1(1)47 {;
	replace survey=`i' if _n==`i';
	sum corruption if country_num==`i';
	replace sample=r(N) if survey==`i';
	replace mean=r(mean) if survey==`i';
	sum iso if country_num==`i';
	replace isoaxis=r(mean) if survey==`i';
	sum year if country_num==`i';
	replace yearaxis=r(mean) if survey==`i';
	sum gdp if country_num==`i';
	replace gdppc=r(mean) if survey==`i';
	sum gini if country_num==`i';
	replace giniaxis=r(mean) if survey==`i';

	foreach j of local vars{;
		reg corruption `j' if country_num==`i';
		matrix biv=e(b);
		matrix sebiv=e(V);
		svmat biv;
		svmat sebiv;
		replace coef_`j'=biv1[1] if survey==`i';
		replace ciu_`j'=coef_`j'+1.96*sqrt(sebiv1[1]) if survey==`i';
		replace cil_`j'=coef_`j'-1.96*sqrt(sebiv1[1]) if survey==`i';
		drop biv* sebiv*; 
		};
	};

/*Graph for sample size. Rescale per capita GDP to original values. Center panel in Figure A1*/;
replace mean=1.2 in 100;
replace gdppc=gdppc*1000;
replace gdppc=1000 in 100;
replace sample=1000 in 100;
twoway (scatter mean gdppc [fweight = sample], mcolor(black) msymbol(circle_hollow)),
	ytitle("") 
	xtitle("") 
	ylabel(1(1)4)
	title((2) WVS)
	text(1.22 5100 "n = 1000")
	graphregion(color(white))
	name(wvssample);
	
/*Now the same thing with control variables*/;
foreach j of local vars{;
	gen coef_`j'_c=.;
	gen ciu_`j'_c=.;
	gen cil_`j'_c=.;
	};

forvalues i=1(1)39 {;
	reg corruption Income Education Male Age  if country_num==`i';
		matrix biv=e(b);
		matrix sebiv=e(V);
		svmat biv;
		svmat sebiv;
		replace coef_Income_c=biv1[1] if survey==`i';
		replace ciu_Income_c=coef_Income_c+1.96*sqrt(sebiv1[1]) if survey==`i';
		replace cil_Income_c=coef_Income_c-1.96*sqrt(sebiv1[1]) if survey==`i';
		drop biv* sebiv*; 
		};
/*Graph for gdp controlling for education, gender, and age. Center panel in Figure A2*/;
twoway
		(rbar ciu_Income cil_Income gdppc, lcolor(gray))
		(scatter coef_Income gdppc, mcolor(gray))
		(lowess coef_Income gdppc, lcolor(gray))
		(rbar ciu_Income_c cil_Income_c gdppc, lcolor(black))
		(scatter coef_Income_c gdppc, mcolor(black))
		(lowess coef_Income_c gdppc, lcolor(black)),
		legend(off)
		yline(0, lcolor(black) lpattern(dash))
		xtitle("")
		ytitle("")
		title(WVS)
		graphregion(color(white))
		name(wvsIncomecontrols);

/*Now the same thing with Trust as the control variable*/;
foreach j of local vars{;
	gen coef_`j'_t=.;
	gen ciu_`j'_t=.;
	gen cil_`j'_t=.;
	};

forvalues i=1(1)39 {;
	reg corruption Income Trust  if country_num==`i';
		matrix biv=e(b);
		matrix sebiv=e(V);
		svmat biv;
		svmat sebiv;
		replace coef_Income_t=biv1[1] if survey==`i';
		replace ciu_Income_t=coef_Income_t+1.96*sqrt(sebiv1[1]) if survey==`i';
		replace cil_Income_t=coef_Income_t-1.96*sqrt(sebiv1[1]) if survey==`i';
		drop biv* sebiv*; 
		};
/*Graph for gdp controlling for Trust. Left panel in Figure A3*/;
twoway
		(rbar ciu_Income cil_Income gdppc, lcolor(gray))
		(scatter coef_Income gdppc, mcolor(gray))
		(lowess coef_Income gdppc, lcolor(gray))
		(rbar ciu_Income_t cil_Income_t gdppc, lcolor(black))
		(scatter coef_Income_t gdppc, mcolor(black))
		(lowess coef_Income_t gdppc, lcolor(black)),
		legend(off)
		yline(0, lcolor(black) lpattern(dash))
		xtitle("")
		ytitle("")
		title(WVS)
		graphregion(color(white))
		name(wvsIncometrust);
		
/* Control for ethnicity. Center panel in Figure A4*/;
gen coef_Income_e=.;
gen ciu_Income_e=.;
gen cil_Income_e=.;

gen ETHNIC=X051 if X051>0;
replace ETHNIC=999 if ETHNIC==.;

forvalues i=1(1)47 {;
	xi: reg corruption Income i.ETHNIC if country_num==`i';
		matrix biv=e(b);
		matrix sebiv=e(V);
		svmat biv;
		svmat sebiv;
		replace coef_Income_e=biv1[1] if survey==`i';
		replace ciu_Income_e=coef_Income_e+1.96*sqrt(sebiv1[1]) if survey==`i';
		replace cil_Income_e=coef_Income_e-1.96*sqrt(sebiv1[1]) if survey==`i';
		drop biv* sebiv*; 
		};
twoway
		(rbar ciu_Income cil_Income gdppc, lcolor(gray))
		(scatter coef_Income gdppc, mcolor(gray))
		(lowess coef_Income gdppc, lcolor(gray))
		(rbar ciu_Income_e cil_Income_e gdppc if coef_Income_e!= coef_Income, lcolor(black))
		(scatter coef_Income_e gdppc if coef_Income_e!= coef_Income, mcolor(black))
		(lowess coef_Income_e gdppc if coef_Income_e!= coef_Income, lcolor(black)), 
	legend(off)
	yline(0, lcolor(black) lpattern(dash))
	title("WVS")
	xtitle("")
	ytitle("")
	graphregion(color(white)) bgcolor(white)
	name(wvseth);	
	
/*Graph for inequality. Second row of Figure A5*/;
foreach j of local vars{;
	twoway(rbar ciu_`j' cil_`j' giniaxis, lcolor(black) lwidth(none) barwidth(0.01))
		(scatter coef_`j' giniaxis, mcolor(black))
		(lowess coef_`j' giniaxis, lcolor(black)),
		legend(off)
		yline(0, lcolor(black) lpattern(dash))
		xtitle("")
		xscale(reverse)
		ytitle("")
		title(`j')
		graphregion(color(white)) bgcolor(white)
		name(wvs`j');
	};
graph combine wvsIncome wvsEducation,
	rows(1)
	xsize(6)
	ysize(3)
	b1title(Gini Index)
	l1title(Coefficients)
	title((2) WVS, position(11))
	graphregion(color(white))
	name(wvsgini);
graph drop wvsIncome wvsEducation wvsMale;
	
/*Now with binary outcomes. First, transform variables. For WVS, I recode income and education*/;
replace Education=3 if Education==4;
replace Education=Education-2 if Education==5 | Education==6 | Education==7 | Education==8;

/*recode income*/;
gen Income2=.;
gen p20=.;
gen p40=.;
gen p60=.;
gen p80=.;
forvalues i=1(1)47{;
	_pctile Income if country_num==`i', p(20,40,60,80);
	replace p20=r(r1);
	replace p40=r(r2);
	replace p60=r(r3);
	replace p80=r(r4);
	replace Income2=1 if Income<p20 & country_num==`i';
	replace Income2=2 if Income<p40 & Income2==. & country_num==`i';
	replace Income2=3 if Income<p60 & Income2==. & country_num==`i';
	replace Income2=4 if Income<p80 & Income2==. & country_num==`i';
	replace Income2=5 if Income2==. & Income!=. & country_num==`i';
	};
replace Income=Income2;

/*Estimate*/;
foreach j of local vars{;
	gen coef_`j'2=.;
	gen ciu_`j'2=.;
	gen cil_`j'2=.;
	};

forvalues i=1(1)47 {;
	foreach j of local vars{;
		reg corruption2 `j' if country_num==`i';
		matrix biv=e(b);
		matrix sebiv=e(V);
		svmat biv;
		svmat sebiv;
		replace coef_`j'2=biv1[1] if survey==`i';
		replace ciu_`j'2=coef_`j'2+1.96*sqrt(sebiv1[1]) if survey==`i';
		replace cil_`j'2=coef_`j'2-1.96*sqrt(sebiv1[1]) if survey==`i';
		drop biv* sebiv*; 
		};
	};

foreach j of local vars{;
	twoway(rbar ciu_`j'2 cil_`j'2 gdppc, lcolor(black))
		(scatter coef_`j'2 gdppc, mcolor(black))
		(lowess coef_`j'2 gdppc, lcolor(black)),
		legend(off)
		yline(0, lcolor(black) lpattern(dash))
		xtitle("")
		ytitle("")
		title(`j')
		graphregion(color(white)) bgcolor(white)
		name(wvs`j'2);
	};
/*Second row of Figure A6*/;
graph combine wvsIncome2 wvsEducation2,
	rows(1)
	xsize(6)
	ysize(3)
	b1title(Per Capita GDP)
	l1title(Coefficients)
	graphregion(color(white))
	title((2) WVS, position(11))
	name(wvsgraph2);
graph drop wvsIncome2 wvsEducation2 wvsMale2;
******************************************************************************************************
******************************************************************************************************

/*Read ISSP 2006 dataset*/;
use ISSP2006.dta, clear;

/*Generate year and iso code*/;
decode V3a, gen(country);
encode country, gen(country_num);
gen iso=V3a;
gen year=2006;

/*generate outcomes. corpol is for politicians, corpub is for bureaucrats*/;
gen corpol=V60;
gen corpub=V61;
egen corruption=rowmean(V60 V61);
/*binary outcomes based on national average*/;
gen corruption_mean=.;
gen corruption2=.;
forvalues i=1(1)33{;
	sum corpol if country_num==`i';
	replace corruption_mean=r(mean) if country_num==`i';
	replace corruption2=1 if corruption>corruption_mean & corruption!=. & country_num==`i';
	replace corruption2=0 if corruption<corruption_mean & corruption!=. & country_num==`i';
};

/*generate predictors*/
gen Male=2-SEX if SEX!=.;
gen Education=DEGREE;
gen Age=AGE;
gen Trust=5-V50;

/*generate income by converting local currency into USD (It's not a 4 point scale. It's raw numbers)*/;
gen inc2=.;
replace inc2=AU_INC/1.26846;
replace inc2=CA_INC/1.16638 if inc2==.;
replace inc2=CH_INC/1.21975*12 if inc2==.;
replace inc2=CL_INC/532.550 *12 if inc2==.;
replace inc2=CZ_INC/20.85500 *12 if inc2==.;
replace inc2=DE_INC/0.75798 *12 if inc2==.;
replace inc2=DK_INC/5.65260 if inc2==.;
replace inc2=DO_INC/34.44100*12  if inc2==.;
replace inc2=ES_INC/0.75798 *12 if inc2==.;
replace inc2=FI_INC/0.75798 *12 if inc2==.;
replace inc2=FR_INC/0.75798 *12 if inc2==.;
replace inc2=GB_INC/0.51069 if inc2==.;
replace inc2=HR_INC/5.57260*12 if inc2==.;
replace inc2=HU_INC/190.740 *12 if inc2==.;
replace inc2=IE_INC/0.75798  if inc2==.;
replace inc2=IL_INC/4.22169*12  if inc2==.;
replace inc2=JP_INC/119.111 if inc2==.;
replace inc2=KR_INC/939.496*12 if inc2==.;
replace inc2=LV_INC/0.52872*12 if inc2==.;
replace inc2=NL_INC/0.75798 *12 if inc2==.;
replace inc2=NO_INC/ 6.24319 if inc2==.;
replace inc2=NZ_INC/1.42052  if inc2==.;
replace inc2=PH_INC/49.14600  if inc2==.;
replace inc2=PL_INC/2.91254*12 if inc2==.;
replace inc2=PT_INC/0.75798*12 if inc2==.;
replace inc2=RU_INC/26.33100*12 if inc2==.;
replace inc2=SE_INC/ 6.85371 *12 if inc2==.;
replace inc2=SI_INC/ 181.610 *12 if inc2==.;
replace inc2=TW_INC/ 32.59000  *12 if inc2==.;
replace inc2=US_INC if V3a==840.;
replace inc2=UY_INC/25.44400 *12 if inc2==.;
replace inc2=VE_INC/2148.80 *12 if inc2==.;
replace inc2=ZA_INC/7.05510  *12 if inc2==.;
gen Income=log(inc2);

/*recode income to use for multilevel logistic models*/;
gen Income2=.;
gen p20=.;
gen p40=.;
gen p60=.;
gen p80=.;
forvalues i=1(1)33{;
	_pctile inc2 if country_num==`i', p(20,40,60,80);
	replace p20=r(r1);
	replace p40=r(r2);
	replace p60=r(r3);
	replace p80=r(r4);
	replace Income2=1 if inc2<p20 & country_num==`i';
	replace Income2=2 if inc2<p40 & Income2==. & country_num==`i';
	replace Income2=3 if inc2<p60 & Income2==. & country_num==`i';
	replace Income2=4 if inc2<p80 & Income2==. & country_num==`i';
	replace Income2=5 if Income2==. & inc2!=. & country_num==`i';
};

/*merge with macro data. */;
sort iso year;
merge m:1 iso year using cp_macro.dta;
gen gdp=rgdpl;

/*Now for the two-step model. First I create some new variables to save country-level results*/;
gen survey=.;
label values survey country_num;
gen sample=.;
gen mean=.;
gen isoaxis=.;
gen yearaxis=.;
gen gdppc=.;
gen giniaxis=.;
local vars Income Education Male;
foreach j of local vars{;
	gen coef_`j'=.;
	gen ciu_`j'=.;
	gen cil_`j'=.;
	};

forvalues i=1(1)33 {;
	replace survey=`i' if _n==`i';
	sum corruption if country_num==`i';
	replace sample=r(N) if survey==`i';
	replace mean=r(mean) if survey==`i';
	sum iso if country_num==`i';
	replace isoaxis=r(mean) if survey==`i';
	sum year if country_num==`i';
	replace yearaxis=r(mean) if survey==`i';
	sum gdp if country_num==`i';
	replace gdppc=r(mean) if survey==`i';
	sum gini if country_num==`i';
	replace giniaxis=r(mean) if survey==`i';
	foreach j of local vars{;
		reg corruption `j' if country_num==`i';
		matrix biv=e(b);
		matrix sebiv=e(V);
		svmat biv;
		svmat sebiv;
		replace coef_`j'=biv1[1] if survey==`i';
		replace ciu_`j'=coef_`j'+1.96*sqrt(sebiv1[1]) if survey==`i';
		replace cil_`j'=coef_`j'-1.96*sqrt(sebiv1[1]) if survey==`i';
		drop biv* sebiv*; 
		};
	};

/*Graph for sample size. Right panel for Figure A1*/;
replace mean=1.2 in 100;
replace gdppc=1000 in 100;
replace sample=1000 in 100;
twoway (scatter mean gdppc [fweight = sample], mcolor(black) msymbol(circle_hollow)),
	ytitle("") 
	xtitle("") 
	title((3) ISSP)
	ylabel(1(1)5)
	text(1.22 5100 "n = 1000")
	graphregion(color(white))
	name(isspsample);

/*Now the same thing with control variables for income*/;
gen coef_Income_c=.;
gen ciu_Income_c=.;
gen cil_Income_c=.;

forvalues i=1(1)33 {;
	reg corruption Income Education Male Age if country_num==`i';
		matrix biv=e(b);
		matrix sebiv=e(V);
		svmat biv;
		svmat sebiv;
		replace coef_Income_c=biv1[1] if survey==`i';
		replace ciu_Income_c=coef_Income_c+1.96*sqrt(sebiv1[1]) if survey==`i';
		replace cil_Income_c=coef_Income_c-1.96*sqrt(sebiv1[1]) if survey==`i';
		drop biv* sebiv*; 
		};

/*Graph for gdp controlling for education, gender, and age. Right panel for Figure A2*/;
twoway
		(rbar ciu_Income cil_Income gdppc, lcolor(gray))
		(scatter coef_Income gdppc, mcolor(gray))
		(lowess coef_Income gdppc, lcolor(gray))
		(rbar ciu_Income_c cil_Income_c gdppc, lcolor(black))
		(scatter coef_Income_c gdppc, mcolor(black))
		(lowess coef_Income_c gdppc, lcolor(black)),
		legend(off)
		yline(0, lcolor(black) lpattern(dash))
		xtitle("")
		ytitle("")
		title(ISSP)
		graphregion(color(white))
		name(isspIncomecontrols);

/*Now the same thing with trust as a control variable*/;
gen coef_Income_t=.;
gen ciu_Income_t=.;
gen cil_Income_t=.;

forvalues i=1(1)33 {;
	reg corruption Income Trust Male if country_num==`i';
		matrix biv=e(b);
		matrix sebiv=e(V);
		svmat biv;
		svmat sebiv;
		replace coef_Income_t=biv1[1] if survey==`i';
		replace ciu_Income_t=coef_Income_c+1.96*sqrt(sebiv1[1]) if survey==`i';
		replace cil_Income_t=coef_Income_c-1.96*sqrt(sebiv1[1]) if survey==`i';
		drop biv* sebiv*; 
		};

/*Graph for gdp controlling for Trust. Right panel for Figure A3*/;
twoway
		(rbar ciu_Income cil_Income gdppc, lcolor(gray))
		(scatter coef_Income gdppc, mcolor(gray))
		(lowess coef_Income gdppc, lcolor(gray))
		(rbar ciu_Income_t cil_Income_t gdppc, lcolor(black))
		(scatter coef_Income_t gdppc, mcolor(black))
		(lowess coef_Income_t gdppc, lcolor(black)),
		legend(off)
		yline(0, lcolor(black) lpattern(dash))
		xtitle("")
		ytitle("")
		title(ISSP)
		graphregion(color(white))
		name(isspIncometrust);

/* Control for ethnicity. Right panel of Figure A4*/;
gen coef_Income_e=.;
gen ciu_Income_e=.;
gen cil_Income_e=.;

replace ETHNIC=999 if ETHNIC==.a;

forvalues i=1(1)33 {;
	xi: reg corruption Income i.ETHNIC if country_num==`i';
		matrix biv=e(b);
		matrix sebiv=e(V);
		svmat biv;
		svmat sebiv;
		replace coef_Income_e=biv1[1] if survey==`i';
		replace ciu_Income_e=coef_Income_e+1.96*sqrt(sebiv1[1]) if survey==`i';
		replace cil_Income_e=coef_Income_e-1.96*sqrt(sebiv1[1]) if survey==`i';
		drop biv* sebiv*; 
		};

twoway
		(rbar ciu_Income cil_Income gdppc, lcolor(gray))
		(scatter coef_Income gdppc, mcolor(gray))
		(lowess coef_Income gdppc, lcolor(gray))
		(rbar ciu_Income_e cil_Income_e gdppc if coef_Income_e!= coef_Income, lcolor(black))
		(scatter coef_Income_e gdppc if coef_Income_e!= coef_Income, mcolor(black))
		(lowess coef_Income_e gdppc if coef_Income_e!= coef_Income, lcolor(black)), 
		legend(off)
		yline(0, lcolor(black) lpattern(dash))
		title("ISSP")
		xtitle("")
		ytitle("")
		graphregion(color(white)) bgcolor(white)
		name(isspeth);	

/*Graph for Inequality. Third row of Figure A5*/;
foreach j of local vars{;
	twoway(rbar ciu_`j' cil_`j' giniaxis, lcolor(black) lwidth(none) barwidth(0.01))
		(scatter coef_`j' giniaxis, mcolor(black))
		(lowess coef_`j' giniaxis, lcolor(black)),
		legend(off)
		yline(0, lcolor(black) lpattern(dash))
		xtitle("")
		xscale(reverse)
		ytitle("")
		title(`j')
		graphregion(color(white)) bgcolor(white)
		name(issp`j');
	};
graph combine isspIncome isspEducation,
	rows(1)
	xsize(6)
	ysize(3)
	b1title(Gini Index)
	l1title(Coefficients)
	title((3) ISSP, position(11))
	graphregion(color(white))
	name(isspgini);
graph drop isspIncome isspEducation isspMale;

/*Now with binary outcomes. First, transform variables. For ISSP, I recode income*/;
replace Income=Income2;

/*Estimate*/;
foreach j of local vars{;
	gen coef_`j'2=.;
	gen ciu_`j'2=.;
	gen cil_`j'2=.;
	};

forvalues i=1(1)33 {;
	foreach j of local vars{;
		reg corruption2 `j' if country_num==`i';
		matrix biv=e(b);
		matrix sebiv=e(V);
		svmat biv;
		svmat sebiv;
		replace coef_`j'2=biv1[1] if survey==`i';
		replace ciu_`j'2=coef_`j'2+1.96*sqrt(sebiv1[1]) if survey==`i';
		replace cil_`j'2=coef_`j'2-1.96*sqrt(sebiv1[1]) if survey==`i';
		drop biv* sebiv*; 
		};
	};

foreach j of local vars{;
	twoway(rbar ciu_`j'2 cil_`j'2 gdppc, lcolor(black))
		(scatter coef_`j'2 gdppc, mcolor(black))
		(lowess coef_`j'2 gdppc, lcolor(black)),
		legend(off)
		yline(0, lcolor(black) lpattern(dash))
		xtitle("")
		ytitle("")
		title(`j')
		graphregion(color(white)) bgcolor(white)
		name(issp`j'2);
	};

/*Third row of Figure A6*/;
graph combine isspIncome2 isspEducation2,
	rows(1)
	xsize(6)
	ysize(3)
	b1title(Per Capita GDP)
	l1title(Coefficients)
	title((3) ISSP, position(11))
	graphregion(color(white))
	name(isspgraph2);
graph drop isspIncome2 isspEducation2 isspMale2;
	
/*Set up for the multilevel model. Divide per capita GDP by 1000*/;
replace gdp=rgdpl/1000;
gen incxgdp=Income*gdp;
gen incxgdp2=Income2*gdp;
gen malexgdp=Male*gdp;
gen eduxgdp=Educ*gdp;
gen agexgdp=Age*gdp;
gen incxgini=Income*gini;
gen malexgini=Male*gini;
gen eduxgini=Educ*gini;
gen agexgini=Age*gini;

/*Pooled regression with multiple predictors. Models (9)-(12) in Table A3*/;
tab country_num, gen(countrydum);
drop countrydum30;
regress corruption Income countrydum*;
est store isspinc;
regress corruption Income Education countrydum*;
est store isspinceduc;
regress corruption Income Education Male countrydum*;
est store isspinceducmale;
regress corruption Income Education Male Age countrydum*;
est store isspinceducmaleage;

outreg2 Income Education Male Age
	[isspinc isspinceduc isspinceducmale isspinceducmaleage] 
	using TableA3.xls, bdec(3) 2aster;

/*Multilevel models. Table A6*/;
xtmixed corruption Income gdp incxgdp||country_num:Income;
est store issp2inc;
xtmixed corruption Education gdp eduxgdp||country_num:Education;
est store issp2edu;
xtmixed corruption Male gdp malexgdp||country_num:Male;
est store issp2male;
xtmixed corruption Age gdp agexgdp||country_num:Age;
est store issp2age;
xtmixed corruption Income gini incxgini||country_num:Income;
est store issp2incgini;
xtmixed corruption Income gdp gini incxgdp incxgini||country_num:Income;
est store issp2incginigdp;
xtmixed corruption Income Education gdp incxgdp eduxgdp||country_num:Income Education;
est store issp2inceduc;
xtmixed corruption Income Education Male Age gdp incxgdp eduxgdp malexgdp agexgdp||country_num:Income Education Male Age;
est store issp2all;
outreg2 [issp2*] using TableA6.xls, replace bdec(3) 2aster;

/*Mixed-effects logistic regression. Model (7)-(9) in Table A7*/;
ren Income Incomeraw;
ren Income2 Income;
ren incxgdp incxgdpraw;
ren incxgdp2 incxgdp;
xtmelogit corruption2 Income gdp incxgdp||country_num:Income, laplace;
est store issp22inc;
xtmelogit corruption2 Education gdp eduxgdp||country_num:Education, laplace;
est store issp22edu;
xtmelogit corruption2 Male gdp malexgdp||country_num:Male, laplace;
est store issp22male;
xtmelogit corruption2 Income Education Male gdp incxgdp eduxgdp malexgdp||country_num:Income Education Male, laplace;
est store issp22all;
outreg2 [issp22*] using TableA7.xls,bdec(3);

******************************************************************************************************
******************************************************************************************************

/*Figure A1*/;
graph combine
	csessample
	wvssample
	isspsample,
	rows(1)
	xsize(20)
	ysize(7)
	b1title(Per Capita GDP)
	l1title(Average Corruption Perception)
	graphregion(color(white))
	name(FigureA1);	
graph drop csessample wvssample isspsample;
	
/*Figure A2*/;
graph combine csesIncomecontrols wvsIncomecontrols isspIncomecontrols,
	rows(1)
	xsize(20)
	ysize(7)
	b1title(Per Capita GDP)
	l1title(Coefficients)
	graphregion(color(white))
	name(FigureA2);
graph drop csesIncomecontrols	wvsIncomecontrols isspIncomecontrols;
#delimit;	
/*Figure A3*/;
graph combine
	wvsIncometrust
	isspIncometrust,
	rows(1)
	xsize(14)
	ysize(7)
	b1title(Per Capita GDP)
	l1title(Coefficients)
	graphregion(color(white))
	name(FigureA3);
graph drop wvsIncometrust isspIncometrust;
	
/*Figure A4*/;
graph combine
	cseseth
	wvseth
	isspeth,
	rows(1)
	xsize(20)
	ysize(7)
	b1title(Per Capita GDP)
	l1title(Coefficients)
	graphregion(color(white))
	name(FigureA4);	
graph drop cseseth wvseth	isspeth;

/*Figure A5*/;
graph combine 
	csesgini wvsgini isspgini
	, rows(3) iscale(*0.7) title(, size(large) position(11)) xsize(7) ysize(10)
	graphregion(color(white))
	name(FigureA5);
graph drop csesgini wvsgini isspgini;
	
/*Figure A6*/;	
graph combine 
	csesgraph2
	wvsgraph2
	isspgraph2
	, rows(3) iscale(*0.7) title(, size(large) position(11)) xsize(7) ysize(10)
	graphregion(color(white))
	name(FigureA6);
graph drop csesgraph2 wvsgraph2 isspgraph2;


******************************************************************************************************
******************************************************************************************************
#delimit;
/*Read Afrobarometer 2 dataset*/;
use Afrobarometer2.dta, clear;

drop if country==12;
decode country, gen(countrystring);
drop country;
encode countrystring, gen(country_num);

/*create iso country codes*/;
gen iso=.;
replace iso=72 if country_num==1;
replace iso=132 if country_num==2;
replace iso=288 if country_num==3;
replace iso=404 if country_num==4;
replace iso=426 if country_num==5;
replace iso=454 if country_num==6;
replace iso=466 if country_num==7;
replace iso=508 if country_num==8;
replace iso=516 if country_num==9;
replace iso=566 if country_num==10;
replace iso=686 if country_num==11;
replace iso=710 if country_num==12;
replace iso=834 if country_num==13;
replace iso=800 if country_num==14;
replace iso=894 if country_num==15;
gen year=2002;

/*Create outcome, both binary and 4 point. Higher values indicate higher percpetion*/;
gen presidency=q51a if q51a>-1 & q51a<4;
gen politicians=q51b if q51b>-1 & q51b<4;
gen officials=q51c if q51c>-1 & q51c<4;
gen police=q51d if q51d>-1 & q51d<4;
gen customs=q51e if q51e>-1 & q51e<4;
gen judiciary=q51f if q51f>-1 & q51f<4;
gen localbus=q51g if q51g>-1 & q51g<4;
gen foreignbus=q51h if q51h>-1 & q51h<4;
gen edusys=q51i if q51i>-1 & q51i<4;
gen religious=q51j if q51j>-1 & q51j<4;
gen ngo=q51k if q51k>-1 & q51k<4;
egen corruption=rmean(presidency politicians officials police customs judiciary localbus foreignbus edusys religious ngo);

/*Then I create a dichotomous outcome variable based on the national average*/;
gen corruption2=.;
gen corruption_mean=.;
forvalues i=1(1)15 {;
sum corruption if country_num==`i';
replace corruption_mean=r(mean);
replace corruption2=1 if corruption>corruption_mean & corruption!=. & country_num==`i';
replace corruption2=0 if corruption<corruption_mean & corruption!=. & country_num==`i';
};

/*create predictors*/;
gen age=q80 if q80>17 & q80<106;
gen female=q96-1;
gen educ=q84 if q84>-1 & q84<99;
gen inc1=q90new if q90new>-1 & q90new<400;
gen income=.;
gen p20=.;
gen p40=.;
gen p60=.;
gen p80=.;
forvalues i=1(1)15{;
_pctile inc1 if country_num==`i', p(20,40,60,80);
replace p20=r(r1);
replace p40=r(r2);
replace p60=r(r3);
replace p80=r(r4);
replace income=5 if inc1>p80 & country_num==`i';
replace income=4 if inc1>p60 & income==. & country_num==`i';
replace income=3 if inc1>p40 & income==. & country_num==`i';
replace income=2 if inc1>p20 & income==. & country_num==`i';
replace income=1 if income==. & inc1!=. & country_num==`i';
};

/*merge with GDP data and create per capita GDP and divide it by 1000*/;
sort iso year;
merge m:1 iso year using cp_macro.dta;
gen gdp=rgdpl;

/*Now for the two-step model. First I create some new variables to save country-level results*/;
gen survey=.;
label values survey country_num;
gen iso_a=.;
gen year_a=.;
gen coef_b=.;
gen gdppc=.;

/*Bivariate regression with income as a predictor.*/;
forvalues i=1(1)15 {;
replace survey=`i' if _n==`i';
sum iso if country_num==`i';
replace iso_a=r(mean) if survey==`i';
sum year if country_num==`i';
replace year_a=r(mean) if survey==`i';
regress corruption2 income if country_num==`i';
matrix biv=e(b);
svmat biv;
replace coef_b=biv1[1] if survey==`i';
drop biv*;
sum gdp if country_num==`i';
replace gdppc=r(mean) if survey==`i';
};

/*Append to results from other datasets*/;
decode survey,gen(surveyname);
keep surveyname iso_a year_a coef_b gdppc;
drop if iso_a==.;
ren iso_a iso;
ren year_a year;
gen file=5;
sort iso year;
ren coef_b coef_Income2;
append using nopooling.dta;

label define survey
	1 "CSES" 2 "WVS" 3 "ISSP" 4 "AFB";
label values file survey;
decode file, gen(survey);

twoway 
	(scatter coef_Income2 gdppc if file==1, msymbol(square_hollow) mcolor(blue)) 
	(scatter coef_Income2 gdppc if file==2, msymbol(circle_hollow) mcolor(green)) 
	(scatter coef_Income2 gdppc if file==3, msymbol(triangle_hollow) mcolor(red))
	(scatter coef_Income2 gdppc if file==5, msymbol(circle) mcolor(black))
	(lowess coef_Income2 gdppc if file==1, lcolor(blue)) 
	(lowess coef_Income2 gdppc if file==2, lcolor(green)) 
	(lowess coef_Income2 gdppc if file==3, lcolor(red))
	,legend(on position(1) ring(0) order(1 "CSES" 2 "WVS" 3 "ISSP" 4 "AFB"))
	yline(0, lcolor(black) lpattern(dash))
	graphregion(color(white))
	bgcolor(white)
	ytitle(Coefficients) xtitle (Per Capita GDP) name(FigureA7);
