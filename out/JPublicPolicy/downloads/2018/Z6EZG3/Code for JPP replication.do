
/* Stata codes for replicating the paper entitled "Lobbying, Learning, and Policy Reinvention: An Examination of the American States’ Drunk Driving Laws"

Note: The following codes show how to reproduce the results reported in Table 2, Figure 1, and Figure 2. There are two parts. The first part
shows how to construct the measure of the dependent variable. The dependent variable has been constructed and present in the data, so interested readers 
can go to the second step directly to run the model to reproduce the results. The second step shows how to replicate the results.*/ 

/*Part 1 Measuring policy reinvention*/
/* It takes three steps to construct the measure for the dependent variable. 
First, we generate a dummy variable indicating whether there is a policy change in state i from year t-1 to year t.*/
gen pc1 = ( minfinelaw_i!=minfinelaw_i[_n-1]) if year>1980&minfinelaw_i!=.
gen pc2 = (baclaw_i!=baclaw_i[_n-1]) if year>1980&baclaw_i!=.
gen pc3 = ( zerotolerancelaw_i != zerotolerancelaw_i [_n-1]) if year>1980& zerotolerancelaw_i !=.
gen pc4 = ( mprisdm_i != mprisdm_i [_n-1]) if year>1980& mprisdm_i !=.
gen pc5 = ( opencont_i != opencont_i [_n-1]) if year>1980& opencont_i !=.
gen pc6 = ( comsrv12_i != comsrv12_i [_n-1]) if year>1980& comsrv12_i !=.
gen pc7 = (preconvictlaw_i  != preconvictlaw_i [_n-1]) if year>1980& preconvictlaw_i !=.
gen pc8 = (postconvictlaw_i  != postconvictlaw_i [_n-1]) if year>1980& postconvictlaw_i !=.

/* Second, we define the emulation of one policy component as that state i adopts a policy component in year t 
that has been in place in state j in year t-1*/
gen exp_emu_1 = (minfinelaw_i==1&minfinelaw_j[_n-1]==1&pc1==1)
gen exp_emu_2 = (baclaw_i==1&baclaw_j[_n-1]==1&pc2==1)
gen exp_emu_3 = ( zerotolerancelaw_i ==1& zerotolerancelaw_j [_n-1]==1&pc3==1)
gen exp_emu_4 = ( mprisdm_i ==1& mprisdm_j [_n-1]==1&pc4==1)
gen exp_emu_5 = ( opencont_i ==1& opencont_j [_n-1]==1&pc5==1)
gen exp_emu_6 = ( comsrv12_i ==1& comsrv12_j [_n-1]==1&pc6==1)
gen exp_emu_7 = ( preconvictlaw_i ==1& preconvictlaw_j [_n-1]==1&pc7==1)
gen exp_emu_8 = ( postconvictlaw_i ==1& postconvictlaw_j [_n-1]==1&pc8==1)

/* Third, we sum up the emulation of eight policy components*/
gen emu_total_8= exp_emu_1+exp_emu_2+exp_emu_3+exp_emu_4+exp_emu_5+exp_emu_6+exp_emu_7+exp_emu_8

/* In addition, we define the conditions for possible policy learning as that state j must have a policy component in place in year t-1*/
gen poss_exp_emu_1 = (minfinelaw_i==1&minfinelaw_j[_n-1]==1&pc1==1|minfinelaw_i==0&minfinelaw_j[_n-1]==1&pc1==0)
gen poss_exp_emu_2 = (baclaw_i ==1& baclaw_j [_n-1]==1&pc2==1| baclaw_i ==0& baclaw_j [_n-1]==1&pc2==0)
gen poss_exp_emu_3 = ( zerotolerancelaw_i ==1& zerotolerancelaw_j [_n-1]==1&pc3==1| zerotolerancelaw_i ==0& zerotolerancelaw_j [_n-1]==1&pc3==0)
gen poss_exp_emu_4 = ( mprisdm_i ==1& mprisdm_j [_n-1]==1&pc4==1| mprisdm_i ==0& mprisdm_j [_n-1]==1&pc4==0)
gen poss_exp_emu_5 = ( opencont_i ==1& opencont_j [_n-1]==1&pc5==1| opencont_i ==0& opencont_j [_n-1]==1&pc5==0)
gen poss_exp_emu_6 = ( comsrv12_i ==1& comsrv12_j [_n-1]==1&pc6==1| comsrv12_i ==0& comsrv12_j [_n-1]==1&pc6==0)
gen poss_exp_emu_7 = ( preconvictlaw_i ==1& preconvictlaw_j [_n-1]==1&pc7==1| preconvictlaw_i ==0& preconvictlaw_j [_n-1]==1&pc7==0)
gen poss_exp_emu_8 = ( postconvictlaw_i ==1& postconvictlaw_j [_n-1]==1&pc8==1| postconvictlaw_i ==0& postconvictlaw_j [_n-1]==1&pc8==0)

gen poss_emu_total_8= poss_exp_emu_1+poss_exp_emu_2+poss_exp_emu_3+poss_exp_emu_4+poss_exp_emu_5+poss_exp_emu_6+poss_exp_emu_7+poss_exp_emu_8


 /*Part 2 Starting data analysis*/
 /*Codes for reproducing Table 2*/
 xtreg emu_total_8 n_fatal_per_j_lag n_fatal_per_j_lag_madd_i madd_i n_fatal_per_i citizenideology_i_20s government_cont2_i legprof_squire_i ln_mileage_i ln_vmt_i_per alc_cons_per_i alc_tax_real_per_i real_gdp_per_i60s abs_state_20s abs_tot_pop_new60s_samey real_gdp_per_j60s i.year if poss_emu_total_8>0, fe i(dyad_no) vce(robust)
 outreg2 using Table2.doc, se bdec(3) sdec(3) word replace ctitle (model 1)

 xtreg emu_total_8 n_fatal_per_j_lag n_fatal_per_j_lag_madd_i predbornprot_i madd_i n_fatal_per_i citizenideology_i_20s government_cont2_i legprof_squire_i ln_mileage_i ln_vmt_i_per alc_cons_per_i alc_tax_real_per_i real_gdp_per_i60s abs_state_20s abs_tot_pop_new60s_samey real_gdp_per_j60s i.year if poss_emu_total_8>0, fe i(dyad_no) vce(robust)
 outreg2 using Table2.doc, se bdec(3) sdec(3) word append ctitle (model 2)

 xtreg emu_total_8 n_fatal_dri_per_lag_30s n_fatal_dri_per_lag_madd_i_30s madd_i n_fatal_dri_per_i_30s citizenideology_i_20s government_cont2_i legprof_squire_i ln_mileage_i ln_vmt_i_per alc_cons_per_i alc_tax_real_per_i real_gdp_per_i60s abs_state_20s abs_tot_pop_new60s_samey real_gdp_per_j60s i.year if poss_emu_total_8>0, fe i(dyad_no) vce(robust)
 outreg2 using Table2.doc, se bdec(3) sdec(3) word append ctitle (model 3)
 
 xtreg emu_total_8 n_fatal_dri_per_lag_30s n_fatal_dri_per_lag_madd_i_30s predbornprot_i madd_i n_fatal_dri_per_i_30s citizenideology_i_20s government_cont2_i legprof_squire_i ln_mileage_i ln_vmt_i_per alc_cons_per_i alc_tax_real_per_i real_gdp_per_i60s abs_state_20s abs_tot_pop_new60s_samey real_gdp_per_j60s i.year if poss_emu_total_8>0, fe i(dyad_no) vce(robust)
 outreg2 using Table2.doc, se bdec(3) sdec(3) word append ctitle (model 4)
 
 
 /* Codes for reproducing Figure 1*/
 set scheme s2mono
 xtreg emu_total_8 c.n_fatal_per_j_lag##c.madd_i n_fatal_per_i citizenideology_i_20s government_cont2_i legprof_squire_i ln_mileage_i ln_vmt_i_per alc_cons_per_i alc_tax_real_per_i real_gdp_per_i60s abs_state_20s abs_tot_pop_new60s_samey real_gdp_per_j60s i.year if poss_emu_total_8>0, fe i(dyad_no) vce(robust)
 margins,dydx(n_fatal_per_j_lag)at(madd_i=(0(1)21))vsquish
 marginsplot
 
 
 /* Codes for reproducing Figure 2*/
 set scheme s2mono
 xtreg emu_total_8 c.n_fatal_per_j_lag##c.madd_i n_fatal_per_i citizenideology_i_20s government_cont2_i legprof_squire_i ln_mileage_i ln_vmt_i_per alc_cons_per_i alc_tax_real_per_i real_gdp_per_i60s abs_state_20s abs_tot_pop_new60s_samey real_gdp_per_j60s i.year if poss_emu_total_8>0, fe i(dyad_no) vce(robust)
 margins,dydx(madd_i)at(n_fatal_per_j_lag=(-.55(-.05)-.12))vsquish
 marginsplot
