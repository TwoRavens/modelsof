#delimit;
set more off;
version 11;
graph drop _all;

/*CSES*/;
/*Read CSES module 2*/;
use cses2.dta, clear;

/*I drop elections that are missing either income, corruption, or education*/;
drop if B1004=="BEL_2003"|B1004=="KGZ_2005";

/*encode election number to simplify*/;
encode B1004, gen(country_num);

/*create iso country codes*/;
destring B1006, gen(iso_p);
replace iso_p=2760 if iso_p==2761|iso_p==2762;
replace iso_p=1520 if iso_p==1502;
gen iso=iso_p/10;
gen year=B1008;

/*Create outcome, both binary and 4 point. Higher values indicate higher percpetion*/;
gen corruption=5-B3044 if B3044<5;

/*create predictors*/;
gen Male=2-B2002 if B2002<3;
gen Education=B2003 if B2003<9;
gen Income=B2020 if B2020<6;
gen Age=B2001 if B2001<997;

/*merge with GDP data and create per capita GDP*/;
sort iso year;
merge m:1 iso year using cp_macro.dta;
gen gdp=rgdpl;
drop _merge;

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


/*Now the same thing with control variables for income*/;
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

/*Graph for Figure 1*/;
merge m:m isoaxis using cp_iso_country.dta;
drop if _merge==2;
drop _merge;
replace countryaxis="Taiwan(2001)" if survey==38;
replace countryaxis="Tawiwan(2004)" if survey==37;
replace countryaxis="Portugal(2002)" if survey==31;
replace countryaxis="Porgutal(2005)" if survey==32;
replace countryaxis="Germany(Phone)" if survey==9;
replace countryaxis="Germany(Mail)" if survey==10;
gsort -coef_Income;
gen Incorder=_n if survey!=.;
twoway
	(scatter Incorder coef_Income_c, mcolor(gray))
	(rbar cil_Income_c ciu_Income_c Incorder, horizontal lcolor(gray) lwidth(none) barwidth(0.01))
	(scatter Incorder coef_Income, mcolor(black))
	(rbar cil_Income ciu_Income Incorder, horizontal lcolor(black) lwidth(none) barwidth(0.01))
	(scatter Incorder cil_Income, msymbol(none) mlabel(countryaxis) mlabposition(9) mlabcolor(black) mlabsize(vsmall)), 
	yscale(off) legend(off) xtitle(Coefficients) ysize(12) xsize(10) xline(0, lwidth(vthin) lcolor(black)) 
	text(45 .15 "Rich citizens") text(43 .15 "perceive more corruption") text(45 -.15 "Poor citizens") text(43 -.15 "perceive more corruption") yscale(range(-4 46)) xscale(range(-.25 .25)) 
	ylabel(,nogrid) xline(-.0197, lcolor(black) lpattern(dot)) text(-3 -.06 "pooled average", size(vsmall))
	graphregion(color(white)) bgcolor(white)
	name(Figure1);

/*Graph for Figure 2*/;
foreach j of local vars{;
	twoway(rbar ciu_`j' cil_`j' gdppc, lcolor(black))
		(scatter coef_`j' gdppc, mcolor(black))
		(lowess coef_`j' gdppc, lcolor(black)),
		legend(off)
		yline(0, lcolor(black) lpattern(dash))
		xtitle("")
		ytitle("")
		title(`j')
		graphregion(color(white)) bgcolor(white)
		name(cses`j');
	};
graph combine csesIncome csesEducation,
	rows(1)
	xsize(6)
	ysize(3)
	b1title(Per Capita GDP)
	l1title(Coefficients)
	title((1) CSES, position(11))
	graphregion(color(white)) 
	name(csesgraph)
	;

/*WVS*/;
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

/*generate predictors*/;
gen Male=2-X001 if X001>0;
gen Education=X025 if X025>0;
gen Income=X047 if X047>0;
gen Age=X003 if X003>0;


/*merge data*/;
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

/*Graph for each variable. Second row of Figure 2*/;	
foreach j of local vars{;
twoway(rbar ciu_`j' cil_`j' gdppc, lcolor(black))
	(scatter coef_`j' gdppc, mcolor(black))
	(lowess coef_`j' gdppc, lcolor(black)),
	legend(off)
	yline(0, lcolor(black) lpattern(dash))
	xtitle("")
	ytitle("")
	title(`j')
	graphregion(color(white)) bgcolor(white)
	name(wvs`j');
	};

graph combine wvsIncome wvsEducation,
	rows(1)
	xsize(6)
	ysize(3)
	b1title(Per Capita GDP)
	l1title(Coefficients)
	title((2) WVS, position(11))
	graphregion(color(white))
	name(wvsgraph)

/*ISSP*/;
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


/*generate predictors*/
gen Male=2-SEX if SEX!=.;
gen Education=DEGREE;
gen Trust=5-V50;
gen Age=AGE;

/*generate income in USD (It's not a 4 point scale. It's raw numbers)*/;
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

/*recode income*/;
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

/*Merge data and generate gdp*/;
sort iso year;
merge m:m iso year using cp_macro.dta;
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

/*Graph for each variable. Third row in Figure 2*/;

foreach j of local vars{;
twoway(rbar ciu_`j' cil_`j' gdppc, lcolor(black))
	(scatter coef_`j' gdppc, mcolor(black))
	(lowess coef_`j' gdppc, lcolor(black)),
	legend(off)
	yline(0, lcolor(black) lpattern(dash))
	xtitle("")
	ytitle("")
	title(`j')
	graphregion(color(white)) bgcolor(white)
	name(issp`j');
	};

graph combine isspIncome isspEducation,
	rows(1)
	xsize(6)
	ysize(3)
	b1title(Per Capita GDP)
	l1title(Coefficients)
	title((3) ISSP, position(11))
	graphregion(color(white))	
	name(isspgraph)

/*Figure 2*/;
graph combine csesgraph wvsgraph isspgraph
	, rows(3) iscale(*0.7) title(, size(large) position(11)) xsize(7) ysize(10)
	graphregion(color(white))
	name(Figure2);

graph drop
	csesIncome csesEducation csesMale csesgraph
	wvsIncome wvsEducation wvsMale wvsgraph
	isspIncome isspEducation isspMale isspgraph;
