#delimit;
version 11;
set more off;

/*CSES*/;
/*Read CSES module 2*/;
use cses2.dta, clear;
graph drop _all;

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
gen eduxgdp=Education*gdp;

/*multilevel models*/;

xtmixed corruption Income gdp incxgdp||country_num:Income;
est store cses2inc;
xtmixed corruption Education gdp eduxgdp||country_num:Education;
est store cses2edu;

/*Graph for Income and Education using results from the multilevel model*/;
est restore cses2inc;
predict coef_i*, reffects;
predict se_i*, reses;
gen coef_Income=coef_i1 + .0600551 + gdp*-.0034468;
gen ciu_Income= coef_Income+1.96*se_i1;
gen cil_Income= coef_Income-1.96*se_i1;

est restore cses2edu;
predict coef_e*, reffects;
predict se_e*, reses;
gen coef_Education=coef_e1 + .042435 + gdp*-.0026051;
gen ciu_Education= coef_Education+1.96*se_e1;
gen cil_Education= coef_Education-1.96*se_e1;

/*Collapse the dataset and draw graphs based on the multilevel model*/;
collapse (mean) coef_Income coef_Education ciu_Income cil_Income ciu_Education cil_Education gdp, by(B1003);

twoway
		(rbar ciu_Income cil_Income gdp, lcolor(black) fcolor(black) barwidth(0.01))
		(scatter coef_Income gdp, mcolor(black))
		(scatteri 0.04628507 3.99502 -0.08507586 42.106, recast(line) lcolor(black))
		if coef_Income!=.,
		legend(off)
		yline(0, lcolor(black) lpattern(dash))
		xtitle("")
		xlabel(0 "0" 10 "10000" 20 "20000" 30 "30000" 40 "40000")
		ytitle("")
		title(Income)
		graphregion(color(white)) bgcolor(white)
		name(csesIncomemixed);

twoway
		(rbar ciu_Education cil_Education gdp, lcolor(black) fcolor(black) barwidth(0.01))
		(scatter coef_Education gdp, mcolor(black))
		(scatteri 0.03202757 3.99502 -0.06725534 42.106, recast(line) lcolor(black))
		if coef_Education!=.,
		legend(off)
		yline(0, lcolor(black) lpattern(dash))
		xtitle("")
		xlabel(0 "0" 10 "10000" 20 "20000" 30 "30000" 40 "40000")
		ytitle("")
		title(Education)
		graphregion(color(white)) bgcolor(white)
		name(csesEducationmixed);

graph combine csesIncomemixed csesEducationmixed,
	rows(1)
	xsize(6)
	ysize(3)
	ycommon
	b1title(Per Capita GDP)
	l1title(Marginal Effects)
	title((1) CSES, position(11))
	graphregion(color(white)) 
	name(csesgraph);

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

/*merge with macro data. divide per capita GDP by 1000, interact predictors with per capita GDP and gini index*/;
sort iso year;
merge m:1 iso year using cp_macro.dta;
gen gdp=rgdpl/1000;
gen incxgdp=Income*gdp;
gen malexgdp=Male*gdp;
gen eduxgdp=Educ*gdp;

/*multilevel models*/;

/*Mixed-effects regression. Table A5*/;
xtmixed corruption Income gdp incxgdp||country_num:Income;
est store wvs2inc;
xtmixed corruption Education gdp eduxgdp||country_num:Education;
est store wvs2edu;

/*Graph for Income and Education using the results from the multilevel model*/;
est restore wvs2inc;
predict coef_i*, reffects;
predict se_i*, reses;
gen coef_Income=coef_i1 + -3.63e-06 + gdp* -.0010431;
gen ciu_Income= coef_Income+1.96*se_i1;
gen cil_Income= coef_Income-1.96*se_i1;
est restore wvs2edu;
predict coef_e*, reffects;
predict se_e*, reses;
gen coef_Education=coef_e1 + .0047318 + gdp*-.001849;
gen ciu_Education= coef_Education+1.96*se_e1;
gen cil_Education= coef_Education-1.96*se_e1;

/*Collapse the dataset and draw graphs based on the multilevel model*/;
collapse (mean) coef_Income coef_Education ciu_Income cil_Income ciu_Education cil_Education gdp, by(country_num);

twoway
		(rbar ciu_Income cil_Income gdp, lcolor(black) fcolor(black) barwidth(0.01))
		(scatter coef_Income gdp, mcolor(black))
		(scatteri -0.00126699 1.21116 -0.03875292 37.1482, recast(line) lcolor(black))
		if coef_Income!=.,
		legend(off)
		yline(0, lcolor(black) lpattern(dash))
		xtitle("")
		xlabel(0 "0" 10 "10000" 20 "20000" 30 "30000" 40 "40000")
		ytitle("")
		title(Income)
		graphregion(color(white)) bgcolor(white)
		name(wvsIncomemixed);

twoway
		(rbar ciu_Education cil_Education gdp, lcolor(black) fcolor(black) barwidth(0.01))
		(scatter coef_Education gdp, mcolor(black))
		(scatteri  0.00249237 1.21116 -0.06395522 37.1482, recast(line) lcolor(black))
		if coef_Education!=.,
		legend(off)
		yline(0, lcolor(black) lpattern(dash))
		xtitle("")
		xlabel(0 "0" 10 "10000" 20 "20000" 30 "30000" 40 "40000")
		ytitle("")
		title(Education)
		graphregion(color(white)) bgcolor(white)
		name(wvsEducationmixed);

graph combine wvsIncomemixed wvsEducationmixed,
	rows(1)
	xsize(6)
	ysize(3)
	ycommon
	b1title(Per Capita GDP)
	l1title(Marginal Effects)
	title((2) WVS, position(11))
	graphregion(color(white)) 
	name(wvsgraph)
	;

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


/*merge with macro data. divide per capita GDP by 1000, interact predictors with per capita GDP and gini index*/;
sort iso year;
merge m:1 iso year using cp_macro.dta;
gen gdp=rgdpl/1000;
gen incxgdp=Income*gdp;
gen eduxgdp=Educ*gdp;

/*multilevel models*/;
xtmixed corruption Income gdp incxgdp||country_num:Income;
est store issp2inc;
xtmixed corruption Education gdp eduxgdp||country_num:Education;
est store issp2edu;


/*Prepare data for the graph for Income and Education*/;
est restore issp2inc;
predict coef_i*, reffects;
predict se_i*, reses;
gen coef_Income=coef_i1 + .0745655 + gdp* -.0047802;
gen ciu_Income= coef_Income+1.96*se_i1;
gen cil_Income= coef_Income-1.96*se_i1;

est restore issp2edu;
predict coef_e*, reffects;
predict se_e*, reses;
gen coef_Education=coef_e1 + .0388025  + gdp*-.0026963;
gen ciu_Education= coef_Education+1.96*se_e1;
gen cil_Education= coef_Education-1.96*se_e1;


/*Collapse the dataset*/;
collapse (mean) coef_Income coef_Education ciu_Income cil_Income ciu_Education cil_Education gdp, by(country_num);

twoway
		(rbar ciu_Income cil_Income gdp, lcolor(black) fcolor(black) barwidth(0.01))
		(scatter coef_Income gdp, mcolor(black))
		(scatteri 0.05357354 4.39144 -0.14880942 46.7292, recast(line) lcolor(black))
		if coef_Income!=.,
		legend(off)
		yline(0, lcolor(black) lpattern(dash))
		xtitle("")
		xlabel(0 "0" 10 "10000" 20 "20000" 30 "30000" 40 "40000")
		ytitle("")
		title(Income)
		graphregion(color(white)) bgcolor(white)
		name(isspIncomemixed);

twoway
		(rbar ciu_Education cil_Education gdp, lcolor(black) fcolor(black) barwidth(0.01))
		(scatter coef_Education gdp, mcolor(black))
		(scatteri 0.02696186 4.39144 -0.08719344 46.7292, recast(line) lcolor(black))
		if coef_Education!=.,
		legend(off)
		yline(0, lcolor(black) lpattern(dash))
		xtitle("")
		xlabel(0 "0" 10 "10000" 20 "20000" 30 "30000" 40 "40000")
		ytitle("")
		title(Education)
		graphregion(color(white)) bgcolor(white)
		name(isspEducationmixed);

graph combine isspIncomemixed isspEducationmixed,
	rows(1)
	xsize(6)
	ysize(3)
	ycommon
	b1title(Per Capita GDP)
	l1title(Marginal Effects)
	title((3) ISSP, position(11))
	graphregion(color(white)) 
	name(isspgraph)
	;

/*Figure 3*/;
graph combine csesgraph wvsgraph isspgraph,
	rows(3) iscale(*0.7) title(, size(large) position(11)) xsize(7) ysize(10)
	graphregion(color(white))
	name(Figure3);

graph drop
	csesIncomemixed csesEducationmixed
	wvsIncomemixed wvsEducationmixed
	isspIncomemixed isspEducationmixed;
