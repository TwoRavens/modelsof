#delimit;

clear;
set more off;
set matsize 800;
set mem 5000m;
global path ~/research;
capture log close;
/*================================================
 Program: figure_data_2_11_sp.do
 Author:  Avi Ebenstein, Shannon Phillips
 Created: February 2010
 Purpose: Employment and Wages Figures 
	   by Education, for Mfg and Services
=================================================*/

use $masterpath/datafiles/morg_data, clear;
keep if empl==1 & uhourse>0;
gen edcat=.;
replace edcat=1 if yrsed<=12;
replace edcat=2 if yrsed>=13;

gen manufacturing=man7090~=.;
gen services=ind7090==60 | (ind7090>=400 & ind7090<=901);

gen rw_mfg=rw if manufacturing==1;
gen rw_svs=rw if services==1;
collapse rwage=rw rw_mfg rw_svs [w=orgwgt],by(year edcat) fast;
tempfile figures;
save `figures', replace;

use $masterpath/datafiles/morg_data, clear;
keep if empl==1 & uhourse>0;
gen edcat=.;
replace edcat=1 if yrsed<=12;
replace edcat=2 if yrsed>=13;
sort year edcat;
merge year edcat using `figures';
tab _merge;

gen manufacturing=man7090~=.;
gen services=ind7090==60 | (ind7090>=400 & ind7090<=901);
keep manufacturing services orgwgt rwage rw_mfg rw_svs year edcat; 

egen tot_emp_all_mfg=sum(orgwgt/12) if manufacturing==1, by(year);
egen tot_emp_all_svs=sum(orgwgt/12) if services==1, by(year);

egen tot_emp_lowed_mfg=sum(orgwgt/12) if edcat==1 & manufacturing==1, by(year);
egen tot_emp_lowed_svs=sum(orgwgt/12) if edcat==1 & services==1, by(year);

egen tot_emp_highed_mfg=sum(orgwgt/12) if edcat==2 & manufacturing==1, by(year);
egen tot_emp_highed_svs=sum(orgwgt/12) if edcat==2 & services==1, by(year);

egen mean_wage_all_mfg=mean(rw_mfg) if manufacturing==1, by(year);
egen mean_wage_all_svs=mean(rw_svs) if services==1, by(year);

egen mean_wage_lowed_mfg=mean(rw_mfg) if edcat==1 & manufacturing==1, by(year);
egen mean_wage_lowed_svs=mean(rw_svs) if edcat==1 & services==1, by(year);

egen mean_wage_highed_mfg=mean(rw_mfg) if edcat==2 & manufacturing==1, by(year);
egen mean_wage_highed_svs=mean(rw_svs) if edcat==2 & services==1, by(year);

replace tot_emp_all_mfg=tot_emp_all_mfg/1000;
replace tot_emp_all_svs=tot_emp_all_svs/1000;
replace tot_emp_lowed_mfg=tot_emp_lowed_mfg/1000;
replace tot_emp_lowed_svs=tot_emp_lowed_svs/1000;
replace tot_emp_highed_mfg=tot_emp_highed_mfg/1000;
replace tot_emp_highed_svs=tot_emp_highed_svs/1000;

egen tot_lowed=sum(orgwgt/12) if edcat==1, by(year);
egen tot_highed=sum(orgwgt/12) if edcat==2, by(year);

collapse tot_emp_* mean_wage_* tot_lowed tot_highed ,by(year);
save $masterpath/datafiles/figure1data_sp, replace;*/

cd $masterpath/figures/;
twoway (line tot_emp_all_mfg year) (line tot_emp_all_svs year, yaxis(2)), ytitle("Thousands of Manufacturing Workers", size(medium)) ytitle("Thousands of Services Workers", axis(2) size(medium)) ylabel(#3, labsize(small)) ylabel(#3, labsize(small) axis(2)) legend(label(1 "Manufacturing") label(2 "Services")) xtitle("Year") title("All Education") saving(tot_emp_all, replace);
twoway (line tot_emp_lowed_mfg year) (line tot_emp_lowed_svs year, yaxis(2)), ytitle("Thousands of Manufacturing Workers", size(medium)) ytitle("Thousands of Services Workers", axis(2) size(medium)) ylabel(#3, labsize(small)) ylabel(#3, labsize(small) axis(2)) legend(label(1 "Manufacturing") label(2 "Services")) xtitle("Year") title("High School or Less") saving(tot_emp_all_lowed, replace);
twoway (line tot_emp_highed_mfg year) (line tot_emp_highed_svs year, yaxis(2)), ytitle("Thousands of Manufacturing Workers", size(medium)) ytitle("Thousands of Services Workers", axis(2) size(medium)) ylabel(#3, labsize(small)) ylabel(#3, labsize(small) axis(2)) legend(label(1 "Manufacturing") label(2 "Services")) xtitle("Year") title("Some College or More") saving(tot_emp_all_highed, replace);

twoway (line mean_wage_all_mfg year) (line mean_wage_all_svs year), ytitle("Real Wages", size(medium)) ylabel(#3, labsize(small)) legend(label(1 "Manufacturing") label(2 "Services")) ytitle("Wages") xtitle("Year") title("All Education") saving(mean_wage_all, replace);
twoway (line mean_wage_lowed_mfg year) (line mean_wage_lowed_svs year), ytitle("Real Wages", size(medium)) ylabel(#3, labsize(small)) legend(label(1 "Manufacturing") label(2 "Services")) ytitle("Wages") xtitle("Year") title("High School or Less") saving(mean_wage_all_lowed, replace);
twoway (line mean_wage_highed_mfg year) (line mean_wage_highed_svs year), ytitle("Real Wages", size(medium)) ylabel(#3, labsize(small)) legend(label(1 "Manufacturing") label(2 "Services")) ytitle("Wages") xtitle("Year") title("Some College or More") saving(mean_wage_all_highed, replace);

gr combine tot_emp_all.gph tot_emp_all_lowed.gph tot_emp_all_highed.gph mean_wage_all.gph mean_wage_all_lowed.gph mean_wage_all_highed.gph, saving(figure, replace) ;

/*If want to separate 3 employment graphs from 3 wages graphs
*title("Employment, by Education Level: 1979-2002", size(medium));
gr combine tot_emp_all.gph tot_emp_all_lowed.gph tot_emp_all_highed.gph, title("Employment, by Education Level: 1979-2002", size(medium)) saving(figureA, replace) ;
*title("Real Wages, by Education Level: 1979-2002", size(medium));
gr combine mean_wage_all.gph mean_wage_all_lowed.gph mean_wage_all_highed.gph, title("Real Wages, by Education Level: 1979-2002", size(medium)) saving(figureB, replace); */


