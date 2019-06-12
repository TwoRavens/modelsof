#delimit;
set more off;
use nopooling.dta;
graph drop _all;
local vars Income Education;
/*Graph for Figure 2*/;
foreach j of local vars{;
	twoway(rbar ciu_`j' cil_`j' gdppc, lcolor(black))
		(scatter coef_`j' gdppc, mcolor(black))
		(lowess coef_`j' gdppc, lcolor(black)) if file==1,
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

/*Graph for each variable. Second row of Figure 2*/;	
foreach j of local vars{;
twoway(rbar ciu_`j' cil_`j' gdppc, lcolor(black))
	(scatter coef_`j' gdppc, mcolor(black))
	(lowess coef_`j' gdppc, lcolor(black)) if file==2,
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
	name(wvsgraph);

/*Graph for each variable. Third row in Figure 2*/;

foreach j of local vars{;
twoway(rbar ciu_`j' cil_`j' gdppc, lcolor(black))
	(scatter coef_`j' gdppc, mcolor(black))
	(lowess coef_`j' gdppc, lcolor(black)) if file==3,
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
	csesIncome csesEducation csesgraph
	wvsIncome wvsEducation wvsgraph
	isspIncome isspEducation isspgraph;

