


use "20171204_AJPS_MaleskyMosely_w_markups.dta", clear
set more off


/********************************************Appendix B***********************************************************/

/*Appendix B1: Bar Graphs of Distribution by Sector*/
#delimit;
preserve;
generate constant=1;
drop if export_potential==0;
collapse (count) constant if  g13!=. & g13 !=.b, by(sector_id) ;

#delimit;
graph hbar (sum) constant, stack over(sector_id, sort(constant) descending label(labcolor(black)labsize(vsmall))) ytitle("")
title("Firms in Exporting Sectors", size(large) margin(medium)) 
bar(1, fcolor(navy)) blabel(bar, size(vsmall)) legend(off) ylab(0(10)120, labsize(vsmall)) scheme(s1mono);
graph save "sector_exporting.gph", replace;
restore;


#delimit;
preserve;
generate constant=1;
collapse (count) constant if  g13!=. & g13 !=.b, by(sector_id) ;

#delimit;
graph hbar (sum) constant, stack over(sector_id, sort(constant) descending label(labcolor(black)labsize(vsmall))) ytitle("")
title("All Firms", size(large) margin(medium)) 
bar(1, fcolor(navy)) blabel(bar, size(vsmall)) legend(off) ylab(0(10)120, labsize(vsmall)) scheme(s1mono);
graph save "sector_all.gph", replace;
restore;

#delimit;
graph combine "sector_all.gph" "sector_exporting.gph" ,  ycommon imargin(tiny)  cols(2)
scheme(s1mono)
note("Second panel only includes firms in exporting sectors that responded to survey experiment; M: Denotes Manufacturing Sector.", size(vsmall));


graph save "AppendixB1_Sector.gph", replace;
graph export "AppendixB1_Sector.pdf", as(pdf) replace;


/****************************************Appendix B2: Labor Quality by Sector********************************************************/
/*Multiply by 100 for presentation*/

#delimit;
by companycountry, sort: gen count_country=_n;
by companycountry, sort: egen n_country=max(count_country);
tab n_country;
replace g9=g9*100;


#delimit;
ciplot g1_4 if sector_plus !="B" & export_potential==1 , level(90) horizontal by(sector_id) ytitle("") xtitle("No Formal Contract %", size(small) margin(small)) 
note(,size(vsmall) position(7) ring(0)) title("Workers w/o Contracts", size(medium)) fxsize(100) scheme(s1mono);
graph save "contracts.gph", replace;

#delimit;
ciplot g9 if sector_plus !="B" & export_potential==1 , level(90)  horizontal by(sector_plus) ytitle("") xtitle("Share of Firms %", size(small) margin(small)) 
note("") title("Strikes in 3 Years", size(medium)) fxsize(55) scheme(s1mono);
graph save "strike.gph", replace;

#delimit;
ciplot g12_2014 if sector_plus !="B" & export_potential==1 , level(90)  horizontal by(sector_plus) ytitle("") xtitle("Number of Labor Inspections", size(small) margin(small)) 
note("") title("Inspections in 2 Years", size(medium)) fxsize(55) scheme(s1mono);
graph save "inspections.gph", replace;

#delimit;
graph combine "contracts.gph" "strike.gph" "inspections.gph", imargin(tiny) cols(3) scheme(s1mono);
graph save "AppendixB2_LaborQualCIs.gph", replace;
graph export "AppendixB2_LaborQualCIs.pdf", as(pdf) replace;


/*****************************************************Appendix C*********************************************************/

/*Appendix C1: Bar Graphs of Distribution by Country*/

#delimit;
preserve;
generate constant=1;
collapse (count) constant, by(companycountry);

#delimit;
graph hbar (sum) constant if  companycountry !="Vietnam", stack over(companycountry, sort(constant) descending label(labcolor(black)labsize(vsmall))) ytitle("")
title("All Firms", size(medium)) bar(1, fcolor(navy)) blabel(bar, size(vsmall)) legend(off) ylab(0(50)400, labsize(vsmall)) scheme(s1mono) ;
graph save "country_all.gph", replace;
restore;

#delimit;
preserve;
generate constant=1;
collapse (count) constant if export_potential==1 & g13!=. & g13 !=.b, by(companycountry) ;

#delimit;
graph hbar (sum) constant if  companycountry !="Vietnam", stack over(companycountry, sort(constant) descending label(labcolor(black)labsize(vsmall))) ytitle("")
title("Firms in Exporting Sectors", size(medium)) bar(1, fcolor(navy)) blabel(bar, size(vsmall)) legend(off) ylab(0(25)250, labsize(vsmall)) scheme(s1mono);
graph save "country_export.gph", replace;
restore;

#delimit;
graph combine "country_all.gph" "country_export.gph"  ,  ycommon imargin(tiny)  cols(2)
scheme(s1mono)
note("Second panel only includes firms in exporting sectors that responded to survey experiment.", size(vsmall));
graph save "AppendixC1_Country.gph", replace;
graph export "AppendixC1_Country.pdf", as(pdf) replace;

/****************************************Appendix C2: Labor Quality by Country********************************************************/
/*Appendix C2*/

#delimit;
ciplot g1_4  if  companycountry !="Vietnam"  & n_country>12 , level(90) horizontal by(companycountry) ytitle("") xtitle("No Formal Contract %", size(small) margin(small)) 
note(,size(vsmall) position(7) ring(0)) title("Workers w/o Contracts", size(medium)) scheme(s1mono) fxsize(60);
graph save "contracts.gph", replace;

#delimit;

ciplot g9 if  companycountry !="Vietnam"   & n_country>12 , level(90)  horizontal by(companycountry) ytitle("") xtitle("Share of Firms %", size(small) margin(small)) 
note("") title("Strikes in 3 Years", size(medium))  scheme(s1mono) fxsize(50);
graph save "strike.gph", replace;

#delimit;
ciplot g12_2014 if  companycountry !="Vietnam"  & n_country>12 , level(90)  horizontal by(companycountry) ytitle("") xtitle("Number of Labor Inspections", size(small) margin(small)) 
note("") title("Inspections in 2 Years", size(medium))  scheme(s1mono) fxsize(50);
graph save "inspections.gph", replace;

#delimit;
graph combine "contracts.gph" "strike.gph" "inspections.gph", imargin(tiny) cols(3) scheme(s1mono);
graph save "AppendixC2_LaborQualCIcountry.gph", replace;
graph export "AppendixC2__LaborQualCIscountry.pdf", as(pdf) replace;

