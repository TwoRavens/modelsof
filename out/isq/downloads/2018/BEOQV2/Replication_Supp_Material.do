
*Supplementary Material Except PPML (runs off separate data sets)
*****************************************************************************************************************************************************
*****************************************************************************************************************************************************
*Time Country Split
*Table A9
ologit cat_dv_land int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==1 & expcode==2
ologit cat_dv_land int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==0 & expcode==2
ologit cat_dv_land int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if pcw==1 & expcode==2
ologit cat_dv_land int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if p911==1 & expcode==2
ologit cat_dv_air int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==1 & expcode==2
ologit cat_dv_air int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==0 & expcode==2
ologit cat_dv_air int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if pcw==1 & expcode==2
ologit cat_dv_air int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if p911==1 & expcode==2

*Table A10
ologit cat_dv_land int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==1 & expcode==200
ologit cat_dv_land int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==0 & expcode==200
ologit cat_dv_land int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if pcw==1 & expcode==200
ologit cat_dv_land int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if p911==1 & expcode==200
ologit cat_dv_air int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==1 & expcode==200
ologit cat_dv_air int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==0 & expcode==200
ologit cat_dv_air int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if pcw==1 & expcode==200
ologit cat_dv_air int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if p911==1 & expcode==200

*Table A11
ologit cat_dv_land int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==1 & expcode==220
ologit cat_dv_land int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==0 & expcode==220
ologit cat_dv_land int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if pcw==1 & expcode==220
ologit cat_dv_land int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if p911==1 & expcode==220
ologit cat_dv_air int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==1 & expcode==220
ologit cat_dv_air int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==0 & expcode==220
ologit cat_dv_air int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if pcw==1 & expcode==220
ologit cat_dv_air int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if p911==1 & expcode==220

*Table A12
ologit cat_dv_land int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==1 & expcode==255 | expcode==260
ologit cat_dv_land int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==0 & expcode==255 | expcode==260
ologit cat_dv_land int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if pcw==1 & expcode==255 | expcode==260
ologit cat_dv_land int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if p911==1 & expcode==255 | expcode==260
ologit cat_dv_air int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==1 & expcode==255 | expcode==260
ologit cat_dv_air int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==0 & expcode==255 | expcode==260
ologit cat_dv_air int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if pcw==1 & expcode==255 | expcode==260
ologit cat_dv_air int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if p911==1 & expcode==255 | expcode==260

*Figures -- combine code at bottom of section
*Figure A2
ologit cat_dv_land i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==1 & expcode==2

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(us_l_cw_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(us_l_cw_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(us_l_cw_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(us_l_cw_4 , replace)

ologit cat_dv_land i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==0 & expcode==2

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(us_l_92_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(us_l_92_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(us_l_92_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(us_l_92_4 , replace)

ologit cat_dv_land i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if pcw==1 & expcode==2

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(us_l_pcw_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(us_l_pcw_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(us_l_pcw_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(us_l_pcw_4 , replace)

ologit cat_dv_land i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if p911==1 & expcode==2

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(us_l_p911_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(us_l_p911_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(us_l_p911_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(us_l_p911_4 , replace)

*****************************************************************************************************************************************************
*Figure A3
ologit cat_dv_air i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==1 & expcode==2

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(us_a_cw_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(us_a_cw_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(us_a_cw_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(us_a_cw_4 , replace)

ologit cat_dv_air i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==0 & expcode==2

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(us_a_92_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(us_a_92_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(us_a_92_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(us_a_92_4 , replace)

ologit cat_dv_air i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if pcw==1 & expcode==2

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(us_a_pcw_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(us_a_pcw_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(us_a_pcw_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(us_a_pcw_4 , replace)

ologit cat_dv_air i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if p911==1 & expcode==2

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(us_a_p911_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(us_a_p911_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(us_a_p911_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(us_a_p911_4 , replace)

*****************************************************************************************************************************************************
*****************************************************************************************************************************************************
*Figure A4
ologit cat_dv_land i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==1 & expcode==200

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(uk_l_cw_1 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(uk_l_cw_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(uk_l_cw_4 , replace)

ologit cat_dv_land i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==0 & expcode==200

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(uk_l_92_1 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(uk_l_92_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(uk_l_92_4 , replace)

ologit cat_dv_land i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if pcw==1 & expcode==200

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(uk_l_pcw_1 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(uk_l_pcw_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(uk_l_pcw_4 , replace)

ologit cat_dv_land i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if p911==1 & expcode==200

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(uk_l_p911_1 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(uk_l_p911_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(uk_l_p911_4 , replace)

*****************************************************************************************************************************************************
*Figure A5
ologit cat_dv_air i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==1 & expcode==200

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(uk_a_cw_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(uk_a_cw_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(uk_a_cw_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(uk_a_cw_4 , replace)

ologit cat_dv_air i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==0 & expcode==200

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(uk_a_92_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(uk_a_92_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(uk_a_92_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(uk_a_92_4 , replace)

ologit cat_dv_air i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if pcw==1 & expcode==200

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(uk_a_pcw_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(uk_a_pcw_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(uk_a_pcw_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(uk_a_pcw_4 , replace)

ologit cat_dv_air i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if p911==1 & expcode==200

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(uk_a_p911_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(uk_a_p911_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(uk_a_p911_4 , replace)

*****************************************************************************************************************************************************
*****************************************************************************************************************************************************
*Figure A6
ologit cat_dv_land i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==1 & expcode==220

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(fr_l_cw_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(fr_l_cw_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(fr_l_cw_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(fr_l_cw_4 , replace)

ologit cat_dv_land i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==0 & expcode==220

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(fr_l_92_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(fr_l_92_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(fr_l_92_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(fr_l_92_4 , replace)

ologit cat_dv_land i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if pcw==1 & expcode==220

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(fr_l_pcw_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(fr_l_pcw_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(fr_l_pcw_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(fr_l_pcw_4 , replace)


ologit cat_dv_land i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if p911==1 & expcode==220

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(fr_l_p911_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(fr_l_p911_2 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(fr_l_p911_4 , replace)

*****************************************************************************************************************************************************
*Figure A7
ologit cat_dv_air i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==1 & expcode==220

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(fr_a_cw_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(fr_a_cw_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(fr_a_cw_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(fr_a_cw_4 , replace)

ologit cat_dv_air i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==0 & expcode==220

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(fr_a_92_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(fr_a_92_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(fr_a_92_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(fr_a_92_4 , replace)

ologit cat_dv_air i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if pcw==1 & expcode==220

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(fr_a_pcw_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(fr_a_pcw_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(fr_a_pcw_4 , replace)

ologit cat_dv_air i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if p911==1 & expcode==220

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(fr_a_p911_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(fr_a_p911_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(fr_a_p911_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(fr_a_p911_4 , replace)

*****************************************************************************************************************************************************
*****************************************************************************************************************************************************
*Figure A8
ologit cat_dv_land i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==1 & expcode==255 | expcode==260

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(ge_l_cw_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(ge_l_cw_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(ge_l_cw_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(ge_l_cw_4 , replace)

ologit cat_dv_land i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==0 & expcode==255 | expcode==260

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(ge_l_92_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(ge_l_92_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(ge_l_92_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(ge_l_92_4 , replace)

ologit cat_dv_land i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if pcw==1 & expcode==255 | expcode==260

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(ge_l_pcw_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(ge_l_pcw_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(ge_l_pcw_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(ge_l_pcw_4 , replace)

ologit cat_dv_land i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if p911==1 & expcode==255 | expcode==260

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(ge_l_p911_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(ge_l_p911_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(ge_l_p911_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(ge_l_p911_4 , replace)

*****************************************************************************************************************************************************
*Figure A9
ologit cat_dv_air i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==1 & expcode==255 | expcode==260

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(ge_a_cw_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(ge_a_cw_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(ge_a_cw_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(ge_a_cw_4 , replace)

ologit cat_dv_air i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if coldwar==0 & expcode==255 | expcode==260

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(ge_a_92_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(ge_a_92_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(ge_a_92_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(ge_a_92_4 , replace)

ologit cat_dv_air i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if pcw==1 & expcode==255 | expcode==260

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(ge_a_pcw_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(ge_a_pcw_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(ge_a_pcw_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(ge_a_pcw_4 , replace)

ologit cat_dv_air i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp    if p911==1 & expcode==255 | expcode==260

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(ge_a_p911_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(ge_a_p911_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(ge_a_p911_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(ge_a_p911_4 , replace)
*****************************************************************************************************************************************************
*****************************************************************************************************************************************************

*Figure A2
graph combine us_l_cw_1 us_l_cw_2 us_l_cw_3 us_l_cw_4 us_l_92_1 us_l_92_2 us_l_92_3 us_l_92_4 ///
us_l_pcw_1 us_l_pcw_2 us_l_pcw_3 us_l_pcw_4 us_l_p911_1 us_l_p911_2 us_l_p911_3 us_l_p911_4 , col(4) ycommon
*Figure A23
graph combine us_a_cw_1 us_a_cw_2 us_a_cw_3 us_a_cw_4 us_a_92_1 us_a_92_2 us_a_92_3 us_a_92_4 ///
us_a_pcw_1 us_a_pcw_2 us_a_pcw_3 us_a_pcw_4 us_a_p911_1 us_a_p911_2 us_a_p911_3 us_a_p911_4 , col(4) ycommon

*Figure A4
graph combine uk_l_cw_1 uk_l_cw_3 uk_l_cw_4 uk_l_92_1 uk_l_92_3 uk_l_92_4 ///
uk_l_pcw_1 uk_l_pcw_3 uk_l_pcw_4 uk_l_p911_1 uk_l_p911_3 uk_l_p911_4 , col(4) ycommon
*Figure A5
graph combine uk_a_cw_1 uk_a_cw_2 uk_a_cw_3 uk_a_cw_4 uk_a_92_1 uk_a_92_2 uk_a_92_3 uk_a_92_4 ///
uk_a_pcw_1 uk_a_pcw_2 uk_a_pcw_3 uk_a_pcw_4 uk_a_p911_2 uk_a_p911_3 uk_a_p911_4 , col(4) ycommon

*Figure A6
graph combine fr_l_cw_1 fr_l_cw_2 fr_l_cw_3 fr_l_cw_4 fr_l_92_1 fr_l_92_2 fr_l_92_3 fr_l_92_4 ///
fr_l_pcw_1 fr_l_pcw_2 fr_l_pcw_3 fr_l_pcw_4 fr_l_p911_1 fr_l_p911_2 fr_l_p911_4 , col(4) ycommon
*Figure A7
graph combine fr_a_cw_1 fr_a_cw_2 fr_a_cw_3 fr_a_cw_4 fr_a_92_1 fr_a_92_2 fr_a_92_3 fr_a_92_4 ///
fr_a_pcw_2 fr_a_pcw_3 fr_a_pcw_4 fr_a_p911_1 fr_a_p911_2 fr_a_p911_3 fr_a_p911_4 , col(4) ycommon

*Figure A8
graph combine ge_l_cw_1 ge_l_cw_2 ge_l_cw_3 ge_l_cw_4 ge_l_92_1 ge_l_92_2 ge_l_92_3 ge_l_92_4 ///
ge_l_pcw_1 ge_l_pcw_2 ge_l_pcw_3 ge_l_pcw_4 ge_l_p911_1 ge_l_p911_2 ge_l_p911_3 ge_l_p911_4 , col(4) ycommon
*Figure A9
graph combine ge_a_cw_1 ge_a_cw_2 ge_a_cw_3 ge_a_cw_4 ge_a_92_1 ge_a_92_2 ge_a_92_3 ge_a_92_4 ///
ge_a_pcw_1 ge_a_pcw_2 ge_a_pcw_3 ge_a_pcw_4 ge_a_p911_1 ge_a_p911_2 ge_a_p911_3 ge_a_p911_4 , col(4) ycommon





*****************************************************************************************************************************************************
*****************************************************************************************************************************************************

*****************************************************************************************************************************************************
*****************************************************************************************************************************************************

*****************************************************************************************************************************************************
*****************************************************************************************************************************************************

*****************************************************************************************************************************************************
*****************************************************************************************************************************************************
*Split Time Not Country
*Table A13
ologit cat_dv_land int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   uk fr ge  if coldwar==1 
ologit cat_dv_land int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   uk fr ge  if coldwar==0 
ologit cat_dv_land int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp  uk fr ge  if pcw==1 
ologit cat_dv_land int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   uk fr ge  if p911==1 

*Table A14
ologit cat_dv_air int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   uk fr ge  if coldwar==1 
ologit cat_dv_air int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   uk fr ge  if coldwar==0 
ologit cat_dv_air int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   uk fr ge  if pcw==1 
ologit cat_dv_air int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   uk fr ge  if p911==1 


*Figure A10 A11, combination below
ologit cat_dv_land i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   uk fr ge  if coldwar==1 

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(land_cw_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(land_cw_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(land_cw_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(land_cw_4 , replace)

ologit cat_dv_air i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   uk fr ge  if coldwar==1 

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(air_cw_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(air_cw_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(air_cw_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(air_cw_4 , replace)

ologit cat_dv_land i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   uk fr ge  if coldwar==0 

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(land_p92_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(land_p92_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(land_p92_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(land_p92_4 , replace)

ologit cat_dv_air i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   uk fr ge  if coldwar==0 

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(air_p92_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(air_p92_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(air_p92_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(air_p92_4 , replace)

ologit cat_dv_land i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp  uk fr ge  if pcw==1 

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(land_pcw_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(land_pcw_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(land_pcw_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(land_pcw_4 , replace)

ologit cat_dv_air i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   uk fr ge  if pcw==1 

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(air_pcw_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(air_pcw_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(air_pcw_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(air_pcw_4 , replace)

ologit cat_dv_land i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   uk fr ge  if p911==1 

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(land_p911_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(land_p911_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(land_p911_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(land_p911_4 , replace)

ologit cat_dv_air i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp   uk fr ge  if p911==1 

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(air_p911_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(air_p911_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(air_p911_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(air_p911_4 , replace)



graph combine land_cw_1 land_cw_2 land_cw_3 land_cw_4 land_p92_1 land_p92_2 land_p92_3 land_p92_4 ///
land_pcw_1 land_pcw_2 land_pcw_3 land_pcw_4 land_p911_1 land_p911_2 land_p911_3 land_p911_4  , col(4) ycommon


graph combine air_cw_1 air_cw_2 air_cw_3 air_cw_4 air_p92_1 air_p92_2 air_p92_3 air_p92_4 ///
air_pcw_1 air_pcw_2 air_pcw_3 air_pcw_4 air_p911_1 air_p911_2 air_p911_3 air_p911_4 , col(4) ycommon


*****************************************************************************************************************************************************
*****************************************************************************************************************************************************

*****************************************************************************************************************************************************
*****************************************************************************************************************************************************

*****************************************************************************************************************************************************
*****************************************************************************************************************************************************

*****************************************************************************************************************************************************
*****************************************************************************************************************************************************
*All Dummies
*Table A15
ologit cat_dv_land int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp  coldwar p911 uk fr ge
ologit cat_dv_air int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp  coldwar p911 uk fr ge


*Figure A12
ologit cat_dv_land i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp  coldwar p911 uk fr ge

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(land_alldummy_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(land_alldummy_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(land_alldummy_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(land_alldummy_4 , replace)

ologit cat_dv_air i.int_hr  imp_dep_ma polity2_imp ln_gdp   defense hostlev_imp cw_intensity_imp  coldwar p911 uk fr ge

margins int_hr, atmeans predict(outcome(1))
marginsplot , name(air_alldummy_1 , replace)

margins int_hr, atmeans predict(outcome(2))
marginsplot , name(air_alldummy_2 , replace)

margins int_hr, atmeans predict(outcome(3))
marginsplot , name(air_alldummy_3 , replace)

margins int_hr, atmeans predict(outcome(4))
marginsplot , name(air_alldummy_4 , replace)

graph combine land_alldummy_1 land_alldummy_2 land_alldummy_3 land_alldummy_4 ///
air_alldummy_1 air_alldummy_2 air_alldummy_3 air_alldummy_4 , col(4) ycommon














