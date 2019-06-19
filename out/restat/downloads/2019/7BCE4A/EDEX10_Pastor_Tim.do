u $data\edex_data_analytic, clear
#delimit;


gen sa_read_fun = 0;
replace sa_read_fun = 1 if bys87b == 1;
replace sa_read_fun = . if bys87b < 0;

gen a_read_fun = 0;
replace a_read_fun = 1 if bys87b == 2;
replace a_read_fun = . if bys87b < 0;

gen d_read_fun = 0;
replace d_read_fun = 1 if bys87b == 3;
replace d_read_fun = . if bys87b < 0;

gen sd_read_fun = 0;
replace sd_read_fun = 1 if bys87b == 4;
replace sd_read_fun = . if bys87b < 0;

gen sa_math_fun = 0;
replace sa_math_fun = 1 if bys87c == 1;
replace sa_math_fun = . if bys87c < 0;

gen a_math_fun = 0;
replace a_math_fun = 1 if bys87c == 2;
replace a_math_fun = . if bys87c < 0;

gen d_math_fun = 0;
replace d_math_fun = 1 if bys87c == 3;
replace d_math_fun = . if bys87c < 0;

gen sd_math_fun = 0;
replace sd_math_fun = 1 if bys87c == 4;
replace sd_math_fun = . if bys87c < 0;

gen never_attentive_eng = 0 if byte16>=0;
replace never_attentive_eng = 1 if byte16 == 1;
gen never_attentive_math = 0 if bytm16>=0;
replace never_attentive_math = 1 if bytm16 == 1;

gen rarely_attentive_eng = 0 if byte16>=0;
gen rarely_attentive_math = 0 if bytm16>=0;
gen some_attentive_eng = 0 if byte16>=0;
gen some_attentive_math = 0 if bytm16>=0;
gen mostly_attentive_eng = 0 if byte16>=0;
gen mostly_attentive_math = 0 if bytm16>=0;
gen always_attentive_eng = 0 if byte16>=0;
gen always_attentive_math = 0 if bytm16>=0;

replace rarely_attentive_eng = 1 if byte16 == 2;
replace rarely_attentive_math = 1 if bytm16 == 2;

replace some_attentive_eng = 1 if byte16 == 3;
replace some_attentive_math = 1 if bytm16 == 3;

replace mostly_attentive_eng = 1 if byte16 == 4;
replace mostly_attentive_math = 1 if bytm16 == 4;

replace always_attentive_eng = 1 if byte16 == 5;
replace always_attentive_math = 1 if bytm16 == 5;


gen passive_eng = byte06 if byte06>=0;
gen passive_math = bytm06 if bytm06>=0;

gen talks_outclass_eng = byte07 if byte07>=0;
gen talks_outclass_math = bytm07 if bytm07>=0;


foreach var in never_attentive some_attentive mostly_attentive rarely_attentive  passive talks_outclass {;
gen `var'_dif_abs = abs(`var'_eng-`var'_math);
};
gen sa_fun_dif_abs = abs(sa_read_fun-sa_math_fun);
gen a_fun_dif_abs = abs(a_read_fun-a_math_fun);
gen d_fun_dif_abs = abs(d_read_fun-d_math_fun);




eststo clear;
local instrument1 passive_eng passive_math;
local instrument2 talks_outclass_eng talks_outclass_mth;
local instrument3 passive_eng passive_math talks_outclass_eng talks_outclass_math;
local instrument4 never_attentive_eng rarely_attentive_eng some_attentive_eng mostly_attentive_eng never_attentive_math rarely_attentive_math some_attentive_math mostly_attentive_math;
local instrument5 sa_read_fun a_read_fun d_read_fun sa_math_fun a_math_fun d_math_fun;
local teacherx_abs tchblack_dif_abs tchhisp_dif_abs tchasian_dif_abs tchnative_dif_abs tchmulti_dif_abs tchmale_dif_abs tchassociate_dif_abs tchbachelor_dif_abs tchedspec_dif_abs tchmasters_dif_abs tchdoctor_dif_abs tchprof_dif_abs majorinsubject_dif_abs;
local instrument6 passive_dif_abs talks_outclass_dif_abs never_attentive_dif_abs rarely_attentive_dif_abs some_attentive_dif_abs mostly_attentive_dif_abs sa_fun_dif_abs a_fun_dif_abs d_fun_dif_abs;
local instrument_avg tchavg_col_mb tchavg_col_eb;

eststo clear;
capture drop Tdiff;
gen Tdiff = T1~=T2;
gen Pass_diff = passive_eng~=passive_math if passive_eng~=. & passive_math~=.;
qui eststo: reg Tdiff Pass_diff `studentchar' i.sch_id, cluster(sch_id);
esttab, keep(Pass_diff);
eststo clear;
gen Talk_diff = abs(talks_outclass_math-talks_outclass_eng);
qui eststo: reg Tdiff Talk_diff `studentchar' i.sch_id, cluster(sch_id);
esttab, keep(Talk_diff);
eststo clear;
foreach var of var `instrument5' {;
eststo clear;
qui eststo: reg Tdiff `var' `studentchar' i.sch_id, cluster(sch_id);
esttab, keep(`var');
};
foreach var of var `instrument4' `instrument6'{;
eststo clear;
qui eststo: reg Tdiff `var' `studentchar' i.sch_id, cluster(sch_id);
esttab, keep(`var');
};
eststo clear;
qui eststo: reg Tdiff `studentchar' `instrument4' `instrument5' `instrument3' i.sch_id, cluster(sch_id);
test `instrument4' `instrument5' `instrument3';
qui eststo: reg Tdiff `studentchar' `instrument_avg' `instrument4' `instrument5' `instrument3' i.sch_id, cluster(sch_id);
test `instrument_avg' `instrument4' `instrument5' `instrument3';
qui eststo: reg Tdiff `studentchar' `instrument_avg' i.sch_id, cluster(sch_id);
test `instrument_avg' ;




qui eststo: reg Tdiff f1rgp9 `studentchar' i.sch_id, cluster(sch_id);
esttab, se keep(f1rgp9);
gen absdiff = abs(bytxrstd-bytxmstd);
gen absdiff2 = absdiff^2;
eststo clear;
qui eststo: reg Tdiff f1rgp9 `studentchar' absdiff i.sch_id, cluster(sch_id);
esttab, se keep(absdiff);
eststo clear;
qui eststo: reg Tdiff f1rgp9 `studentchar' absdiff absdiff2 i.sch_id, cluster(sch_id);
esttab, se keep(absdiff absdiff2);
gen bullied = bys22h>=2; gen msbullied = bys22h<0 | bys22h==.;
eststo clear;
qui eststo: reg Tdiff f1rgp9 `studentchar' bullied msbullied i.sch_id, cluster(sch_id);
esttab, se keep(bullied msbullied);
gen fight = bys22d>=2; gen msfight = bys22d<0 | bys22d==.;
eststo clear;
qui eststo: reg Tdiff f1rgp9 `studentchar' fight msfight i.sch_id, cluster(sch_id);
esttab using table1.tex, append cells(b(fmt(4) star) se(fmt(4) par)) starlevels(* 0.10 ** 0.05 *** 0.01) label keep(fight msfight);
gen fair = bys23e>=1; gen msfair = bys23e<0 | bys23e==.;
eststo clear;
qui eststo: reg Tdiff f1rgp9 `studentchar' fair msfair i.sch_id, cluster(sch_id);
esttab using table1.tex, append cells(b(fmt(4) star) se(fmt(4) par)) starlevels(* 0.10 ** 0.05 *** 0.01) label keep(fair msfair);
gen interesting = bys27a==1 | bys27a==2; gen msinteresting = bys27a<0 | bys27a==.;
qui eststo: reg Tdiff f1rgp9 `studentchar' interesting msinteresting i.sch_id, cluster(sch_id);
esttab using table1.tex, append cells(b(fmt(4) star) se(fmt(4) par)) starlevels(* 0.10 ** 0.05 *** 0.01) label keep(interesting msinteresting);
gen colprep = bys33l>=1; gen mscolprep = bys33l<0 | bys33l==.;
qui eststo: reg Tdiff f1rgp9 `studentchar' colprep mscolprep i.sch_id, cluster(sch_id);
esttab using table1.tex, append cells(b(fmt(4) star) se(fmt(4) par)) starlevels(* 0.10 ** 0.05 *** 0.01) label keep(colprep mscolprep);
gen disab = byp49>=1; gen msdisab = byp49<0 | byp49==.;
qui eststo: reg Tdiff f1rgp9 `studentchar' disab msdisab i.sch_id, cluster(sch_id);
esttab using $table\table_s12.tex, replace cells(b(fmt(4) star) se(fmt(4) par)) starlevels(* 0.10 ** 0.05 *** 0.01) label keep(disab msdisab);

foreach var of varlist bys23* bys33* {;
gen p`var' = `var'==1;
gen ms`var' = `var'<0;
eststo clear;
qui eststo: reg Tdiff f1rgp9 `studentchar' p`var' ms`var' i.sch_id, cluster(sch_id);
esttab using table1.tex, append cells(b(fmt(4) star) se(fmt(4) par)) starlevels(* 0.10 ** 0.05 *** 0.01) label keep(p`var' ms`var');
};

foreach var of varlist bys20* bys27* {;
gen p`var' = `var'==1 | `var'==2;
gen ms`var' = `var'<0 | `var'==.;
eststo clear;
qui eststo: reg Tdiff f1rgp9 `studentchar' p`var' ms`var' i.sch_id, cluster(sch_id);
esttab using table1.tex, append cells(b(fmt(4) star) se(fmt(4) par)) starlevels(* 0.10 ** 0.05 *** 0.01) label keep(p`var' ms`var');
};

foreach var of varlist bys24* {;
gen p`var' = `var'==1 ;
gen ms`var' = `var'<0 | `var'==.;
eststo clear;
qui eststo: reg Tdiff f1rgp9 `studentchar' p`var' ms`var' i.sch_id, cluster(sch_id);
esttab using table1.tex, append cells(b(fmt(4) star) se(fmt(4) par)) starlevels(* 0.10 ** 0.05 *** 0.01) label keep(p`var' ms`var');
};

foreach var of varlist bys29* {;
gen p`var' = `var'==1 | `var'==2 | `var'==3;
gen ms`var' = `var'<0 | `var'==.;
eststo clear;
qui eststo: reg Tdiff f1rgp9 `studentchar' p`var' ms`var' i.sch_id, cluster(sch_id);
esttab using table1.tex, append cells(b(fmt(4) star) se(fmt(4) par)) starlevels(* 0.10 ** 0.05 *** 0.01) label keep(p`var' ms`var');
};


foreach var of varlist bya28* {;
replace `var'=. if `var'<0;
};

gen epassive  = 1 if byte06==1; 
replace epassive = . if byte06<0;
gen mpassive = 1 if bytm06==1;
replace mpassive = . if bytm06<0;

replace byte16=. if byte16<0;
replace bytm16=. if bytm16<0;

estpost sum bya28*;
esttab using $table\table_s13.tex, append cells(mean(fmt(4)) sd(fmt(4) par)) label;


