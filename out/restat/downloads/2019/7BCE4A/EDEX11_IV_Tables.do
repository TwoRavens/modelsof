 /***********************************
* IV_do_all.do          *
***********************************/
/* Now IVs */
u $data\edex_data_analytic, clear
#delimit;
qui do $dofiles/EdEx_Replication_generate_instruments;

global instrument1 passive_eng passive_math;
global instrument2 talks_outclass_eng talks_outclass_mth;
global instrument3 passive_eng passive_math ;
global instrument4 never_attentive_eng rarely_attentive_eng some_attentive_eng mostly_attentive_eng never_attentive_math rarely_attentive_math some_attentive_math mostly_attentive_math;
global instrument5 sa_read_fun a_read_fun d_read_fun sa_math_fun a_math_fun d_math_fun;
global teacherx_abs tchblack_dif_abs tchhisp_dif_abs tchasian_dif_abs tchnative_dif_abs tchmulti_dif_abs tchmale_dif_abs tchassociate_dif_abs tchbachelor_dif_abs tchedspec_dif_abs tchmasters_dif_abs tchdoctor_dif_abs tchprof_dif_abs majorinsubject_dif_abs;
global instrument6 passive_dif_abs talks_outclass_dif_abs never_attentive_dif_abs rarely_attentive_dif_abs some_attentive_dif_abs mostly_attentive_dif_abs sa_fun_dif_abs a_fun_dif_abs d_fun_dif_abs;
global instrument_avg tchavg_col_eb tchavg_col_mb;

capture drop tidmth tideng;
capture drop tidm tide;
capture drop Tm Te;
capture drop numberstudents_*;
capture drop tchavg*;
keep if sample;

egen tidmth = group(sch_id bytm26c bymrace bytm22 bytmhdeg bytm31a);
egen tideng = group(sch_id byte26c byerace byte22 bytehdeg byte31a);

rename tidmth tidm; rename tideng tide;
 

gen Tm = T2; gen Te = T1;
replace tidm=. if bytm20<0;
replace tide=. if byte20<0;

foreach v in e m {;
by tid`v', sort: gen numberstudents_`v' = _N;
by tid`v', sort: egen numberstudents_col_`v' = sum(T`v');
sort stu_id;
gen numberstudents_b_`v' = (numberstudents_`v'-1);
gen numberstudents_col_b_`v' = (numberstudents_col_`v' - T`v');
gen tchavg_col_`v'b = (numberstudents_col_b_`v' / numberstudents_b_`v');
replace tchavg_col_`v'b = . if tid`v'==.;
};


qui do $dofiles/EdEx_Replication_IV_do_1ststage;
qui do $dofiles/EdEx_Replication_IV_do_ivregs;
qui do $dofiles/EdEx_Replication_IV_do_hausman_test;


