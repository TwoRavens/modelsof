
use ISQ_Replication_Data, clear

*Table 1
ologit cat_dv_land int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   coldwar  p911 if expcode==2
ologit cat_dv_land int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   coldwar  p911 if expcode==200
ologit cat_dv_land int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   coldwar  p911 if expcode==220
ologit cat_dv_land int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   coldwar  p911 if expcode==255 | expcode==260

*Table 2
ologit cat_dv_air int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   coldwar  p911 if expcode==2
ologit cat_dv_air int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   coldwar  p911 if expcode==200
ologit cat_dv_air int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   coldwar  p911 if expcode==220
ologit cat_dv_air int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   coldwar  p911 if expcode==255 | expcode==260


*****************************************************************************************************************************************************
*****************************************************************************************************************************************************
*Figures 1-3 -- combine command at bottom of section
*United States
ologit cat_dv_land i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   coldwar  p911 if expcode==2

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(us_l_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(us_l_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(us_l_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(us_l_4 , replace)

*UK
ologit cat_dv_land i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   coldwar  p911 if expcode==200

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(uk_l_1 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(uk_l_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(uk_l_4 , replace)

*France
ologit cat_dv_land i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   coldwar  p911 if expcode==220

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(fr_l_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(fr_l_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(fr_l_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(fr_l_4 , replace)

*Germany
ologit cat_dv_land i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   coldwar  p911 if expcode==255 | expcode==260

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(ge_l_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(ge_l_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(ge_l_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(ge_l_4 , replace)

*US
ologit cat_dv_air i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   coldwar  p911 if expcode==2

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(us_a_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(us_a_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(us_a_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(us_a_4 , replace)

*UK
ologit cat_dv_air i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   coldwar  p911 if expcode==200

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(uk_a_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(uk_a_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(uk_a_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(uk_a_4 , replace)

*France
ologit cat_dv_air i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   coldwar  p911 if expcode==220

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(fr_a_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(fr_a_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(fr_a_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(fr_a_4 , replace)

*Germany
ologit cat_dv_air i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   coldwar  p911 if expcode==255 | expcode==260

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(ge_a_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(ge_a_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(ge_a_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(ge_a_4 , replace)

*Figure 1
graph combine us_l_1 us_l_2 us_l_3 us_l_4 uk_l_1 uk_l_3 uk_l_4 ///
fr_l_1 fr_l_2 fr_l_3 fr_l_4 ge_l_1 ge_l_2 ge_l_3 ge_l_4 , ycommon col(5)

*Figure 2
graph combine us_a_1 us_a_2 us_a_3 us_a_4, ycommon col(4)

*Figure 3
graph combine uk_a_1 uk_a_2 uk_a_3 uk_a_4 ///
fr_a_1 fr_a_2 fr_a_3 fr_a_4 ge_a_1 ge_a_2 ge_a_3 ge_a_4, ycommon col(4)

*****************************************************************************************************************************************************
*****************************************************************************************************************************************************

*****************************************************************************************************************************************************
*****************************************************************************************************************************************************
