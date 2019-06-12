
use C:\Users\owner\Desktop\New_Computer\ZZZ_CURRENT\paul\material_energy_MPSA\Jan2012\JEPO\IntInteractions_250312\dataset\dataset_GINI_July2012.dta

##################### Preparing data ########################

gen myend=mdy( month, day, year2)
gen mybegin=mdy(month, day, year1)
drop if polity<-10

stset myend, id(code) time0(mybegin) origin(time mybegin) failure(igonewdef==1) exit(time .) scale(365.25)



################## Ln of covariates ################

gen pop_ln= ln(pop)

gen gdppc_ln=ln(gdppc+1)

gen fuel_export_ln =ln(fuel_export+1)

gen fuel_import_ln =ln(fuel_import+1)

gen oilprice_lag_ln=ln(oilprice_lag)

gen energyintensity_ln=ln(energyintensity)

gen oil_reserve_ln=ln(oil_reserves+1)

gen oil_gas_pro=oil_pro+ngas_pro

gen oil_gas_con=oil_con+ngas_con

gen oil_gas_pro_ln=ln(oil_gas_pro+1)

gen oil_gas_con_ln=ln(oil_gas_con+1)

gen ngas_reserves_ln=ln(ngas_reserves+1)

gen gdppc1=gdppc/1000

# impute fuel_export pop, gen(fuel_export_imp)

# impute fuel_import pop, gen(fuel_import_imp)



################## Ln of spatial terms ###################

gen fuel_import_spatial_ln=ln(fuel_import_spatial+1)

gen fuel_export_spatial_ln=ln(fuel_export_spatial+1)

gen total_exp_spatial_ln=ln(total_exp_spatial+1)

gen total_imp_spatial_ln=ln(total_imp_spatial+1)

gen spatial_comp_cons_ln=ln( spatial_comp_cons+1)

gen spatial_comp_prod_ln=ln( spatial_comp_prod+1)

gen spatial_pipeline1_ln=ln(spatial_pipeline1+1)


# gen colony_spatial_ln=ln(colony_spatial+1)

# gen trade_spatial_ln=ln(trade_spatial+1)

# gen  wdi_spatial_ln=ln(wdi_spatial+1)



gen compconsln=ln( compcons+1)

gen compprodln=ln( compprod+1)

gen compprodaidln=ln( compprodaid+1)

gen compconsaidln=ln( compconsaid+1)

gen compprodcartelln=ln( compprodcartel+1)

gen compconscartelln=ln( compconscartel+1)

gen distanceln=ln( distance+1)

gen pipelineln=ln( pipeline+1)


########################################################### MAIN TEXT #########################

####################### Table 1 #################### 

streg pop_ln gdppc1 polity igo_t compconsln compprodln, nohr d(wei) frailty(invga) r diff

streg pop_ln gdppc1 polity igo_t distanceln compconsln compprodln, nohr d(wei) frailty(invga) r diff

streg pop_ln gdppc1 polity igo_t oilprice_lag compconsln compprodln, nohr d(wei) frailty(invga) r diff

streg pop_ln gdppc1 polity igo_t energyintensity_ lnuclearshare lhydroshare compconsln compprodln, nohr d(wei) frailty(invga) r diff

streg pop_ln gdppc1 polity igo_t energyintensity_ lnuclearshare lhydroshare oil_reserves ngas_reserves_ln compconsln compprodln,  nohr d(wei) frailty(invga) r diff

streg pop_ln gdppc1 polity igo_t oil_gas_con_ln energyintensity_ lnuclearshare lhydroshare oil_reserves ngas_reserves_ln compconsln compprodln, nohr d(wei) frailty(invga) r diff

streg pop_ln gdppc1 polity igo_t oil_gas_pro_ln energyintensity_ lnuclearshare lhydroshare oil_reserves ngas_reserves_ln compconsln compprodln, nohr d(wei) frailty(invga) r 



####################### Figure 5 #################### 

gen pop1_ln=pop_ln-11.0728
gen gdppc1_ln=gdppc_ln-0.030403
gen igo1_tot=igo_total-1

streg pop1_ln gdppc1 polity igo1_t compconsln compprodln, nohr d(wei) frailty(invga) r diff

stcurve, survival at1(compprodln=0) at2(compprodln=51.2)




########################################################### APPENDIX #########################


########## Table A6 ##########

streg pop_ln gdppc1 polity igo_t compconsln compprodln pipeline, nohr d(wei) frailty(invga) r

gen spatial_cartel_exp_tot_ln=ln( spatial_cartel_exp_tot+1)

gen spatial_cartel_imp_tot_ln=ln( spatial_cartel_imp_tot+1)

streg pop_ln gdppc1 polity igo_t compprodcartelln compconscartelln pipeline, nohr d(wei) frailty(invga) r

gen spatial_aid_exp_tot_ln=ln( spatial_aid_exp_tot+1)

gen spatial_aid_imp_tot_ln=ln( spatial_aid_imp_tot+1)

streg pop_ln gdppc1 polity igo_t  compconsaidln compprodaidln pipeline, nohr d(wei) frailty(invga) r



########## Figure A1 ##########

streg pop1_ln gdppc1 polity igo1_t compconsln compprodln pipeline, nohr d(wei) frailty(invga) r

stcurve, survival at1(pipeline=0) at2(pipeline=15)



####### Table A7 #############

stset myend, id(code) time0(mybegin) origin(time mybegin) failure(igopta2==1) exit(time .) scale(365.25)

streg pop_ln gdppc1 polity igo_t compconsln compprodln,nohr d(wei) frailty(invga) r diff

streg pop_ln gdppc1 polity igo_t compconsln compprodln pipeline,nohr d(wei) frailty(invga) r diff



############ Table A8 ######

stset myend, id(code) time0(mybegin) origin(time mybegin) failure(igonewdef==1) exit(time .) scale(365.25)

gen oil_prod_ln=ln(oil_prod+1)

gen gas_prod_ln=ln(gas_prod+1)

streg pop_ln gdppc1 polity igo_t oil_prod_ln, nohr d(wei) frailty(invga) r diff

streg pop_ln gdppc1 polity igo_t gas_prod_ln, nohr d(wei) frailty(invga) r diff



############ Figure A2 ##########

streg pop1_ln gdppc1 polity igo1_t oil_prod_ln, nohr d(wei) frailty(invga) r diff

stcurve, survival at1(oil_prod_ln=0) at2(oil_prod_ln=25.9)


streg pop1_ln gdppc1 polity igo1_t gas_prod_ln, nohr d(wei) frailty(invga) r diff

stcurve, survival at1(gas_prod_ln=0) at2(gas_prod_ln=24.2)



################## Table A9 ###########

gen sau=1 if country=="SAU"
replace sau=0 if missing(sau)
gen rus=1 if country=="RUS"
replace rus=0 if missing(rus)
gen nor=1 if country=="NOR"
replace nor=0 if missing(nor)
gen irn=1 if country=="IRN"
replace irn=0 if missing(irn)
gen are=1 if country=="ARE"
replace are=0 if missing(are)
gen ven=1 if country=="VEN"
replace ven=0 if missing(ven)
gen kwt=1 if country=="KWT"
replace kwt=0 if missing(kwt)
gen nga=1 if country=="NGA"
replace nga=0 if missing(nga)
gen dza=1 if country=="DZA"
replace dza=0 if missing(dza)
gen mex=1 if country=="MEX"
replace mex=0 if missing(mex)

xi: streg pop_ln gdppc1 polity igo_t compconsln compprodln sau rus nor irn are ven kwt nga dza mex, nohr d(wei) frailty(invga) r diff

xi: streg pop_ln gdppc1 polity igo_t compconsln compprodln i.region_label1, nohr d(wei) frailty(invga) r diff

gen shock1=0

replace shock1=1 if year1==1973 | year1==1974

gen shock2=0

replace shock2=1 if year1==1979 | year1==1980

gen shock3=0

replace shock3=1 if year1==1990 | year1==1991

gen shock4=0

replace shock4=1 if year1>2003 

xi: streg pop_ln gdppc1 polity igo_t compconsln compprodln shock1 shock2 shock3 shock4, nohr d(wei) frailty(invga) r diff



####################### Table A10 #################### 

streg pop_ln gdppc1 polity igo_t compconsln compprodln pipeline, nohr d(exp) frailty(invga) r 

streg pop_ln gdppc1 polity igo_t compconsln compprodln pipeline, nohr d(gomp) frailty(invga) r 

streg pop_ln gdppc1 polity igo_t compconsln compprodln pipeline, nohr d(exp) frailty(gamma) 





