#delimit;
clear;
set memory 300m;

cd "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist";

use "native and immigrants\census00_5pc_occmet.dta";
rename p_country_total_occmet_wt p_count_occmet00_wt;
rename p_country_total_occmet p_count_occmet00;
by  pwmetro occ1990 bpl, sort: generate p_occ_count00= pop_unwght/metpop_country ;
by  pwmetro occ1990 bpl, sort: generate p_occ_count00_wt= pop_wght/metpop_country_wt ;
by  occ1990 , sort: egen total_occ_pop00 = sum( pop_unwght);
by  occ1990 , sort: egen total_occ_pop00_wt = sum( pop_wght);
by  occ1990 bpl , sort: egen cntryocc_pop00_wt=sum(pop_wght);
by  occ1990 bpl , sort: egen cntryocc_pop00=sum(pop_unwght);
by  occ1990 bpl , sort: generate p_occ_uspop00_wt = cntryocc_pop00_wt/total_occ_pop00_wt;
by  occ1990 bpl , sort: generate p_occ_uspop00 = cntryocc_pop00/total_occ_pop00;
by pwmetro bpl, sort:  egen rankocc00=rank(p_occ_count00), field;
by pwmetro bpl, sort:  egen rankocc00_wt=rank(p_occ_count00_wt), field;

rename metoccpop_total metoccpop_total00;
rename metpop_country metpop_country00;
rename p_metpop_total p_metpop_total00;
rename p_metpop_total_wt p_metpop_total00_wt;
rename metpop_total metpop_total00;
keep occ1990 pwmetro bpl p_count_occmet00_wt p_count_occmet00 p_occ_count00 p_occ_count00_wt metpop_country00 metoccpop_total00 metpop_total00 p_metpop_total00 p_metpop_total00_wt total_occ_pop00 cntryocc_pop00 p_occ_uspop00_wt p_occ_uspop00 rankocc00 rankocc00_wt;
drop if bpl==1;
sort occ1990 pwmetro bpl;
save "trends\imm_introtable_00.dta", replace;


clear;
use "native and immigrants\census90_5pc_occmet.dta";
rename p_country_total_occmet_wt p_count_occmet90_wt;
rename p_country_total_occmet p_count_occmet90;
by  pwmetro occ1990 bpl, sort: generate p_occ_count90= pop_unwght/metpop_country ;
by  pwmetro occ1990 bpl, sort: generate p_occ_count90_wt= pop_wght/metpop_country_wt ;
by  occ1990 , sort: egen total_occ_pop90 = sum( pop_unwght);
by  occ1990 , sort: egen total_occ_pop90_wt = sum( pop_wght);
by  occ1990 bpl , sort: egen cntryocc_pop90_wt=sum(pop_wght);
by  occ1990 bpl , sort: egen cntryocc_pop90=sum(pop_unwght);
by  occ1990 bpl , sort: generate p_occ_uspop90_wt = cntryocc_pop90_wt/total_occ_pop90_wt;
by  occ1990 bpl , sort: generate p_occ_uspop90 = cntryocc_pop90/total_occ_pop90;
by pwmetro bpl, sort:  egen rankocc90=rank(p_occ_count90), field;
by pwmetro bpl, sort:  egen rankocc90_wt=rank(p_occ_count90_wt), field;

rename metoccpop_total metoccpop_total90;
rename metpop_country metpop_country90;
rename p_metpop_total p_metpop_total90;
rename p_metpop_total_wt p_metpop_total90_wt;
rename metpop_total metpop_total90;
keep occ1990 pwmetro bpl p_count_occmet90_wt p_count_occmet90 p_occ_count90 p_occ_count90_wt  metoccpop_total90 metpop_total90 metpop_country90 p_metpop_total90 p_metpop_total90_wt total_occ_pop90 cntryocc_pop90 p_occ_uspop90_wt p_occ_uspop90  rankocc90 rankocc90_wt;
drop if bpl==1;
sort occ1990 pwmetro bpl;
save "trends\imm_introtable_90.dta", replace;


clear;
use "native and immigrants\census80_5pc_occmet.dta";
rename p_country_total_occmet_wt p_count_occmet80_wt;
rename p_country_total_occmet p_count_occmet80;
by  pwmetro occ1990 bpl, sort: generate p_occ_count80= pop_unwght/metpop_country ;
by  pwmetro occ1990 bpl, sort: generate p_occ_count80_wt= pop_wght/metpop_country_wt ;
by  occ1990 , sort: egen total_occ_pop80 = sum( pop_unwght);
by  occ1990 , sort: egen total_occ_pop80_wt = sum( pop_wght);
by  occ1990 bpl , sort: egen cntryocc_pop80_wt=sum(pop_wght);
by  occ1990 bpl , sort: egen cntryocc_pop80=sum(pop_unwght);
by  occ1990 bpl , sort: generate p_occ_uspop80_wt = cntryocc_pop80_wt/total_occ_pop80_wt;
by  occ1990 bpl , sort: generate p_occ_uspop80 = cntryocc_pop80/total_occ_pop80;
by pwmetro bpl, sort:  egen rankocc80=rank(p_occ_count80), field;
by pwmetro bpl, sort:  egen rankocc80_wt=rank(p_occ_count80_wt), field;


rename metoccpop_total metoccpop_total80;
rename metpop_country metpop_country80;
rename p_metpop_total p_metpop_total80;
rename p_metpop_total_wt p_metpop_total80_wt;
rename metpop_total metpop_total80;
keep occ1990 pwmetro bpl p_count_occmet80_wt p_count_occmet80 p_occ_count80 p_occ_count80_wt metoccpop_total80 metpop_total80 metpop_country80 p_metpop_total80 p_metpop_total80_wt total_occ_pop80 cntryocc_pop80 p_occ_uspop80_wt p_occ_uspop80 rankocc80 rankocc80_wt;
drop if bpl==1;
sort occ1990 pwmetro bpl;
save "trends\imm_introtable_80.dta", replace;

clear;
use "trends\imm_introtable_00.dta";
sort occ1990 pwmetro bpl;
merge occ1990 pwmetro bpl using "trends\imm_introtable_90.dta";
drop _merge;
sort occ1990 pwmetro bpl;
merge occ1990 pwmetro bpl using "trends\imm_introtable_80.dta";
drop _merge;
save "trends\imm_introtable.dta", replace;

sort pwmetro bpl rankocc00_wt;

twoway (scatter p_count_occmet00_wt p_count_occmet90_wt  if rankocc90_wt>=1 & rankocc90_wt<=5 ) (line p_count_occmet90_wt p_count_occmet90_wt), ytitle(2000 share) xtitle(1990 share) title(Share of Occupation that is Immigrant) subtitle(by birthplace metroarea and occupation) legend(order(1 "2000 share" 2 "45 degree line"));
twoway (scatter p_count_occmet90_wt p_count_occmet80_wt  if rankocc80_wt>=1 & rankocc80_wt<=5 ) (line p_count_occmet90_wt p_count_occmet90_wt), ytitle(1990 share) xtitle(1980 share) title(Share of Occupation that is Immigrant) subtitle(by birthplace metroarea and occupation) legend(order(1 "1990 share" 2 "45 degree line"));
twoway (scatter p_occ_count00_wt p_occ_count90_wt if rankocc90_wt>=1 & rankocc90_wt<=5 ) (line p_occ_count90_wt p_occ_count90_wt), ytitle(2000 share) xtitle(1990 share) title(Share of Immigrant that is in Occupation) subtitle(by birthplace metroarea and occupation) legend(order(1 "2000 share" 2 "45 degree line"));
twoway (scatter p_occ_count90_wt p_occ_count80_wt if rankocc80_wt>=1 & rankocc80_wt<=5 ) (line p_occ_count80_wt p_occ_count80_wt), ytitle(1990 share) xtitle(1980 share) title(Share of Immigrant that is in Occupation) subtitle(by birthplace metroarea and occupation) legend(order(1 "1990 share" 2 "45 degree line"));

twoway (scatter p_count_occmet00_wt p_count_occmet90_wt  if rankocc90_wt==1 ) (line p_count_occmet90_wt p_count_occmet90_wt), ytitle(2000 share) xtitle(1990 share) title(Share of Occupation that is Immigrant) subtitle(by birthplace metroarea and occupation) legend(order(1 "2000 share" 2 "45 degree line"));
twoway (scatter p_count_occmet90_wt p_count_occmet80_wt  if rankocc80_wt==1 ) (line p_count_occmet80_wt p_count_occmet80_wt), ytitle(1990 share) xtitle(1980 share) title(Share of Occupation that is Immigrant) subtitle(by birthplace metroarea and occupation) legend(order(1 "1990 share" 2 "45 degree line"));
twoway (scatter p_occ_count00_wt p_occ_count90_wt if rankocc90_wt==1 ) (line p_occ_count90_wt p_occ_count90_wt), ytitle(2000 share) xtitle(1990 share) title(Share of Immigrant that is in Occupation) subtitle(by birthplace metroarea and occupation) legend(order(1 "2000 share" 2 "45 degree line"));
twoway (scatter p_occ_count90_wt p_occ_count80_wt if rankocc80_wt==1 ) (line p_occ_count80_wt p_occ_count80_wt), ytitle(1990 share) xtitle(1980 share) title(Share of Immigrant that is in Occupation) subtitle(by birthplace metroarea and occupation) legend(order(1 "1990 share" 2 "45 degree line"));

/**** Tables ****/
#delimit;
clear;
use "trends\imm_introtable.dta";
egen max_occobs=rowmax( metoccpop_total00 metoccpop_total90 metoccpop_total80);
drop if max_occobs<100;
keep if bpl!=200;
generate growth80_00=p_count_occmet00_wt-p_count_occmet80_wt if p_count_occmet00_wt<100000 & p_count_occmet90_wt<100000 & p_count_occmet80_wt<100000;
gsort -growth80_00;
keep occ1990 pwmetro bpl p_metpop_total00_wt p_count_occmet00_wt metoccpop_total00 p_occ_uspop00_wt rankocc00_wt p_metpop_total90_wt p_count_occmet90_wt metoccpop_total90 p_occ_uspop90_wt rankocc90_wt p_metpop_total80_wt p_count_occmet80_wt metoccpop_total80 p_occ_uspop80_wt rankocc80_wt growth80_00  p_occ_count80_wt p_occ_count90_wt p_occ_count00_wt;
order occ1990 pwmetro bpl  p_occ_uspop80_wt p_occ_uspop90_wt p_occ_uspop00_wt p_metpop_total80_wt p_metpop_total90_wt p_metpop_total00_wt  p_occ_count80_wt p_occ_count90_wt p_occ_count00_wt p_count_occmet80_wt p_count_occmet90_wt p_count_occmet00_wt metoccpop_total80 metoccpop_total90 metoccpop_total00 rankocc80_wt rankocc90_wt rankocc00_wt growth80_00 ;

/* update to previous table, divide porportion of occupation from country j by proportiono f metro area from j */
#delimit;
clear;
use "trends\imm_introtable.dta";
egen max_occobs=rowmax( metoccpop_total00 metoccpop_total90 metoccpop_total80);
drop if max_occobs<100;
keep if bpl!=200;
generate net_p_count_occmet00_wt=p_count_occmet00_wt/ p_metpop_total00_wt;
generate net_p_count_occmet90_wt=p_count_occmet90_wt/ p_metpop_total90_wt;
generate net_p_count_occmet80_wt=p_count_occmet80_wt/ p_metpop_total80_wt;
generate p_occ_met00=metoccpop_total00/metpop_total00;
generate p_occ_met90=metoccpop_total90/metpop_total90;
generate p_occ_met80=metoccpop_total80/metpop_total80;
generate net_growth80_00=net_p_count_occmet00_wt-net_p_count_occmet80_wt if net_p_count_occmet00_wt<100000 & net_p_count_occmet90_wt<100000 & net_p_count_occmet80_wt<100000;
generate growth80_00=p_count_occmet00_wt-p_count_occmet80_wt if p_count_occmet00_wt<100000 & p_count_occmet90_wt<100000 & p_count_occmet80_wt<100000;
gsort -growth80_00;
keep occ1990 pwmetro bpl p_metpop_total00_wt p_count_occmet00_wt metoccpop_total00 p_occ_uspop00_wt rankocc00_wt p_metpop_total90_wt p_count_occmet90_wt metoccpop_total90 p_occ_uspop90_wt rankocc90_wt p_metpop_total80_wt p_count_occmet80_wt metoccpop_total80 p_occ_uspop80_wt rankocc80_wt net_growth80_00  p_occ_count80_wt p_occ_count90_wt p_occ_count00_wt net_p_count_occmet00_wt net_p_count_occmet90_wt net_p_count_occmet80_wt p_occ_met00 p_occ_met90 p_occ_met80;
order occ1990 pwmetro bpl  p_occ_uspop80_wt p_occ_uspop90_wt p_occ_uspop00_wt p_metpop_total80_wt p_metpop_total90_wt p_metpop_total00_wt  net_p_count_occmet80_wt net_p_count_occmet90_wt net_p_count_occmet00_wt p_occ_count80_wt p_occ_count90_wt p_occ_count00_wt p_count_occmet80_wt p_count_occmet90_wt p_count_occmet00_wt metoccpop_total80 metoccpop_total90 metoccpop_total00 p_occ_met00 p_occ_met90 p_occ_met80 rankocc80_wt rankocc90_wt rankocc00_wt net_growth80_00 ;

generate gr=1 if net_growth80_00>=growth80_00;
keep if gr==1;





#delimit;
clear;
use "trends\imm_introtable.dta";
egen max_occobs=rowmax( metoccpop_total00 metoccpop_total90 metoccpop_total80);
drop if max_occobs<100;
keep if rankocc00_wt>=1 & rankocc00_wt<=5;
generate growth80_00=p_count_occmet00_wt-p_count_occmet80_wt if p_count_occmet00_wt<100000 & p_count_occmet90_wt<100000 & p_count_occmet80_wt<100000;
xtile ptile=growth80_00, nq(25);
sample 1, count by(ptile);
gsort -ptile;
keep occ1990 pwmetro bpl p_metpop_total00_wt p_count_occmet00_wt metoccpop_total00 p_occ_uspop00_wt rankocc00_wt p_metpop_total90_wt p_count_occmet90_wt metoccpop_total90 p_occ_uspop90_wt rankocc90_wt p_metpop_total80_wt p_count_occmet80_wt metoccpop_total80 p_occ_uspop80_wt rankocc80_wt growth80_00 ptile  p_occ_count80_wt p_occ_count90_wt p_occ_count00_wt;
order occ1990 pwmetro bpl  p_occ_uspop80_wt p_occ_uspop90_wt p_occ_uspop00_wt p_metpop_total80_wt p_metpop_total90_wt  p_occ_count80_wt p_occ_count90_wt p_occ_count00_wt p_metpop_total00_wt p_count_occmet80_wt p_count_occmet90_wt p_count_occmet00_wt metoccpop_total80 metoccpop_total90 metoccpop_total00 rankocc80_wt rankocc90_wt rankocc00_wt growth80_00 ;



/***** SCATTER PLOT TO BE INCLUDED IN OCCUPATION SHAES SECTION 2000, 1990, 1980 occupation distribution of new versus old ******/

#delimit;
clear;
use "reg1\census00_imm.dta";
keep if imm_new5==1;
generate pop_unwght=1;
generate pop_wght=perwt;
collapse (sum) pop_unwght pop_wght (mean) metpop_country metpop_country_wt p_occ_old_countrymet_wt p_occ_old_countrymet, by (pwmetro occ1990 bpl);
by  pwmetro bpl, sort: egen metpop_newcntry00=sum(pop_unwght); 
by  pwmetro bpl, sort: egen metpop_newcntry00_wt=sum(pop_wght); 
by  pwmetro occ1990 bpl, sort: generate pnew_occ_count00= pop_unwght/metpop_newcntry00 ;
by  pwmetro occ1990 bpl, sort: generate pnew_occ_count00_wt= pop_wght/metpop_newcntry00_wt ;
rename p_occ_old_countrymet_wt p_occ_old_countrymet00_wt;
rename p_occ_old_countrymet p_occ_old_countrymet00;
sort occ1990 pwmetro bpl;
merge occ1990 pwmetro bpl using "reg1\census00_rank.dta";
drop if _merge==2;
drop _merge;
/*twoway (scatter pnew_occ_count00_wt p_occ_old_countrymet00_wt if rank_oldimm_occ_wt<=5 ) (line p_occ_old_countrymet00_wt p_occ_old_countrymet00_wt), ytitle(2000 new immigrant) xtitle(2000 old immigrant) title(Share of Immigrant that is in Occupation) subtitle(by birthplace metroarea and occupation) legend(order(1 "2000 New Immigrant" 2 "45 degree line"));*/
twoway (scatter pnew_occ_count00_wt p_occ_old_countrymet00_wt if rank_oldimm_occ_wt<=5 ) (line p_occ_old_countrymet00_wt p_occ_old_countrymet00_wt), ytitle(2000 new immigrant, size(huge)) xtitle(2000 established immigrant, size(huge)) legend(order(1 "2000 New Immigrant" 2 "45 degree line"));


#delimit;
clear;
use "reg1\census90_imm.dta";
keep if imm_new5==1;
generate pop_unwght=1;
generate pop_wght=perwt;
collapse (sum) pop_unwght pop_wght (mean) metpop_country metpop_country_wt p_occ_old_countrymet_wt p_occ_old_countrymet, by (pwmetro occ1990 bpl);
by  pwmetro bpl, sort: egen metpop_newcntry90=sum(pop_unwght); 
by  pwmetro bpl, sort: egen metpop_newcntry90_wt=sum(pop_wght); 
by  pwmetro occ1990 bpl, sort: generate pnew_occ_count90= pop_unwght/metpop_newcntry90 ;
by  pwmetro occ1990 bpl, sort: generate pnew_occ_count90_wt= pop_wght/metpop_newcntry90_wt ;
rename p_occ_old_countrymet_wt p_occ_old_countrymet90_wt;
rename p_occ_old_countrymet p_occ_old_countrymet90;
sort occ1990 pwmetro bpl;
merge occ1990 pwmetro bpl using "reg1\census90_rank.dta";
drop if _merge==2;
drop _merge;
/*twoway (scatter pnew_occ_count90_wt p_occ_old_countrymet90_wt if rank_oldimm_occ_wt<=5 ) (line p_occ_old_countrymet90_wt p_occ_old_countrymet90_wt), ytitle(1990 new immigrant) xtitle(1990 old immigrant) title(Share of Immigrant that is in Occupation) subtitle(by birthplace metroarea and occupation) legend(order(1 "1990 New Immigrant" 2 "45 degree line"));*/
twoway (scatter pnew_occ_count90_wt p_occ_old_countrymet90_wt if rank_oldimm_occ_wt<=5 ) (line p_occ_old_countrymet90_wt p_occ_old_countrymet90_wt), ytitle(1990 new immigrant, size(huge)) xtitle(1990 established immigrant, size(huge)) legend(order(1 "1990 New Immigrant" 2 "45 degree line"));


#delimit;
clear;
use "reg1\census80_imm.dta";
keep if imm_new5==1;
generate pop_unwght=1;
generate pop_wght=perwt;
collapse (sum) pop_unwght pop_wght (mean) metpop_country metpop_country_wt p_occ_old_countrymet_wt p_occ_old_countrymet, by (pwmetro occ1990 bpl);
by  pwmetro bpl, sort: egen metpop_newcntry80=sum(pop_unwght); 
by  pwmetro bpl, sort: egen metpop_newcntry80_wt=sum(pop_wght); 
by  pwmetro occ1990 bpl, sort: generate pnew_occ_count80= pop_unwght/metpop_newcntry80 ;
by  pwmetro occ1990 bpl, sort: generate pnew_occ_count80_wt= pop_wght/metpop_newcntry80_wt ;
rename p_occ_old_countrymet_wt p_occ_old_countrymet80_wt;
rename p_occ_old_countrymet p_occ_old_countrymet80;
sort occ1990 pwmetro bpl;
merge occ1990 pwmetro bpl using "reg1\census80_rank.dta";
drop if _merge==2;
drop _merge;
/*twoway (scatter pnew_occ_count80_wt p_occ_old_countrymet80_wt if rank_oldimm_occ_wt<=5 ) (line p_occ_old_countrymet80_wt p_occ_old_countrymet80_wt), ytitle(1980 new immigrant) xtitle(1980 old immigrant) title(Share of Immigrant that is in Occupation) subtitle(by birthplace metroarea and occupation) legend(order(1 "1980 New Immigrant" 2 "45 degree line"));*/
twoway (scatter pnew_occ_count80_wt p_occ_old_countrymet80_wt if rank_oldimm_occ_wt<=5 ) (line p_occ_old_countrymet80_wt p_occ_old_countrymet80_wt), ytitle(1980 new immigrant, size(huge)) xtitle(1980 established immigrant, size(huge)) legend(order(1 "1980 New Immigrant" 2 "45 degree line"));
 
