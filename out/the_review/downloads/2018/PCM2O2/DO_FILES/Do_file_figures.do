*-----------------------------------------*
*** DO-FILE VARIABLE GENERATION ***
*-----------------------------------------*
  
/*
PAPER: 
"Endogenous taxation in ongoing internal conflict: The Case of Colombia"

AUTHORS:
-Rafael Ch (New York University)
-Jacob Shapiro (Princeton University)
-Abbey Steele (University of Amsterdam)
-Juan F. Vargas (Universidad del Rosario)

DO-FILE: 
-This do-file generates Figures 1-3, 5, 6, E7, and E8.

*/
***********************************

clear all
set maxvar 32500
set more off 
set varabbrev off

*Set working directory wherever the "Replication_material_R&R/DO_FILES" folder is:
cd "/Users/rafach/Dropbox/PRINCETON-COLOMBIA/RESEARCH/TAXATION/Dropbox/Taxation paper/Analysis/Replication_material_R&R/DO_FILES"


                                *---------------*
                                    *FIGURE 1*
                                *---------------*


*We get the means (average) of all the fiscal variables per capita (at constant prices, 2008) for the 2000-2012 period:

use "../DATA/PANEL_FISCAL.dta", clear

drop if ano<2000

collapse (mean) y_total_1_nm_pc y_corr_1_nm_pc y_corr_tribut_1_nm_pc y_corr_tribut_predial_1_nm_pc y_corr_tribut_IyC_1_nm_pc y_corr_tribut_gasol_1_nm_pc y_corr_tribut_otros_1_1_nm_pc y_corr_tribut_otros_2_1_nm_pc y_no_tribut_1_nm_pc y_transf_1_nm_pc y_transf_nal_1_nm_pc y_transf_otra_1_nm_pc g_total_1_nm_pc g_corr_1_nm_pc g_func_1_nm_pc g_func_personal_1_nm_pc g_func_general_1_nm_pc g_func_trans_1_nm_pc g_int_deudap_1_nm_pc g_otros_1_nm_pc deficit_1_nm_pc y_cap_1_nm_pc y_cap_regalias_1_nm_pc y_cap_transf_1_nm_pc y_cap_cofinan_1_nm_pc y_cap_otros_1_nm_pc g_cap_1_nm_pc g_cap_FBKF_1_nm_pc g_cap_resto_1_nm_pc deficit_total_1_nm_pc finan_1_nm finan_credito_1_nm_pc finan_credito_desemb_1_nm_pc finan_credito_amort_1_nm_pc finan_credito_balance_1_nm_pc ing_func_1_nm_pc deuda_1_nm_pc ing_trans_1_nm_pc ing_propios_1_nm_pc gast_inv_1_nm_pc ahorro_1_nm_pc desemp_fisc_1_nm_pc p_nal_1_nm_pc p_dep_1_nm_pc total_inv_educ_1_nm_pc inv_per_docente_1_nm_pc inv_a_patronales_1_nm_pc inv_inst_priv_1_nm_pc inv_calidad_1_nm_pc inv_a_educacion_1_nm_pc inv_crecusion_1_nm_pc inv_fortinst_1_nm_pc inv_promdllo_1_nm_pc inv_sp_1_nm_pc inv_tranporte_1_nm_pc inv_cult_1_nm_pc inv_agropecuario_1_nm_pc inv_aguasani_1_nm_pc inv_ambiental_1_nm_pc inv_dllocomun_1_nm_pc inv_dyr_1_nm_pc inv_en_educacion_1_nm_pc inv_equipamiento_1_nm_pc inv_gruposvunera_1_nm_pc inv_en_justicia_1_nm_pc inv_prevdesastr_1_nm_pc inv_en_salud_1_nm_pc inv_total_1_nm_pc inv_en_vias_1_nm_pc inv_en_vivienda_1_nm_pc SGP_alescolar_1_nm_pc SGP_educacion_1_nm_pc SGP_salud_1_nm_pc SGP_propgeneral_1_nm_pc ingr_corr_ld_1_nm_pc ingr_corr_de_1_nm_pc regalias_compensa_1_nm_pc FNR_1_nm_pc ing_trans ing_propios, by(codmpio)

*The following database has the fiscal data per capita from 2000 to 2012: 
save "../DATA/PANEL_FISCAL_pc.dta", replace

*We estimate the ratios of different types of incomes over total expenditure:
use "../DATA/PANEL_FISCAL_pc.dta", clear

*total current income/total expenses:
gen ingresotot_gastotot00_12= y_corr_1_nm_pc/g_total_1_nm_pc 

*total tributary and non-tributary current income/total expenses:
gen ingreso1_gasto_tot00_12= (y_corr_tribut_1_nm_pc+ y_no_tribut_1_nm_pc)/g_total_1_nm_pc 

*total tributary current income/total expenses (this is the one used by Juan):
gen ingreso2_gasto_tot00_12= (y_corr_tribut_1_nm_pc)/g_total_1_nm_pc 

*Finally, we build the histogram: 

hist ingreso2_gasto_tot00_12, kdensity subtitle("period 2002-2012") xtitle("Tax Revenue^ / Total Expenditure") note("Source: Elaborated using fiscal data from CEDE." "^Tax Revenue = tributary income, that corresponds to income by concept of tax on property," "industry and commerce, and gasoline.") scheme(s1color)
graph export "../FIGURES/figure1.png", as(png) replace
graph export "../FIGURES/figure1.pdf", as(pdf) replace
graph export "../FIGURES/figure1.tif", as(tif) replace


                                *---------------*
                                    *FIGURE 2*
                                *---------------*
                                

************************************************************
*1. Tributary and property tax income per capita, histogram*
************************************************************

use "../DATA/PANEL_FISCAL.dta", clear

*We will use the tributary and property income variables, million Colombian pesos at constant prices (2008) per apita: y_corr_tribut_1_nm_pc y_corr_tribut_predial_1_nm_pc 

*1) Tributary income per capita: 
gen ln_tributary_income=ln(y_corr_tribut_1_nm_pc)

hist ln_tributary_income, name(figure2a) title("Tributary income") xtitle("log(tributary income per capita)") scheme(s1color)
graph save "../FIGURES/figure2a.gph", replace

*2) Property income per capita:
gen ln_property_income=ln(y_corr_tribut_predial_1_nm_pc)

hist ln_property_income, name(figure2b) title("Property tax income") xtitle("log(property tax income per capita)") scheme(s1color) ytitle(" ", size(zero))
graph save "../FIGURES/figure2b.gph", replace


********************************************************************************
*2. Tributary and property income - normalized using nighttime light, histogram*
********************************************************************************

*Merge night light data:
use "../DATA/PANEL_FISCAL.dta", clear
drop _merge
rename codmpio codmun
sort codmun
merge codmun using "../DATA/LIGHT92_13.dta"
drop if _merge==1 | _merge==2
drop _merge

save "../DATA/PANEL_FISCAL_lights.dta", replace

*We will use the tributary income variable, million Colombian pesos at constant prices (2008): y_corr_tribut_1

use "../DATA/PANEL_FISCAL_lights.dta", clear

*Tributary income:
*1) Normalization 
gen norm_tribut_income= (y_corr_tribut_1-light_mean)/light_std

*2) Average for the 2000-2012 period
drop if ano<2000
collapse (mean) norm_tribut_income light_mean light_std, by(codmun)
gen ln_norm_t_income=ln(norm_tribut_income)

*3) Histogram of tributary income per capita
hist ln_norm_t_income, name(figure2c) title(" ") xtitle("log(tributary income)" "normalized by nighttime lights") scheme(s1color)
graph save "../FIGURES/figure2c.gph", replace


*Property income:
*1) Normalization 
use "../DATA/PANEL_FISCAL_lights.dta", clear

gen norm_property_income= (y_corr_tribut_predial_1-light_mean)/light_std

*2) Average for the 2000-2012 period
drop if ano<2000
collapse (mean) norm_property_income light_mean light_std, by(codmun)
gen ln_norm_property_income=ln(norm_property_income)

*3) Histogram of property income per capita
hist ln_norm_property_income, name(figure2d) title(" ") xtitle("log(property tax income)" "normalized by nighttime lights") scheme(s1color) ytitle(" ", size(zero))
graph save "../FIGURES/figure2d.gph", replace


*Figure 2: 
graph combine figure2a figure2b figure2c figure2d, subtitle("average 2000-2012") note("Source: Elaborated using fiscal data from CEDE and nighttime light from NOAA." "Tributary income: income by concept of tax on property, industry and commerce, and gasoline.") scheme(s1color) xcommon ycommon imargin(vsmall)
graph export "../FIGURES/figure2.png", as(png) replace
graph export "../FIGURES/figure2.pdf", as(pdf) replace
graph export "../FIGURES/figure2.tif", as(tif) replace


                                *---------------*
                                    *FIGURE 4*
                                *---------------*
                                
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

foreach i in guer{
foreach j in para{
egen total1988_1996_pc=rowtotal(`i'1988_1996_pc `j'1988_1996_pc)
egen total1997_2002_pc=rowtotal(`i'1997_2002_pc `j'1997_2002_pc)
egen total2003_2010_pc=rowtotal(`i'2003_2010_pc `j'2003_2010_pc)
egen total1988_2010_pc=rowtotal(`i'1988_1996_pc `i'1997_2002_pc `i'2003_2010_pc `j'1988_1996_pc `j'1997_2002_pc `j'2003_2010_pc)
}
}


*Figure 3 (1988-2010):
hist total1988_2010_pc, kdensity subtitle("cumulative violence 1988-2010") xtitle("Attacks^ per 100,000 inhabitants") scheme(s1color) note("Source: Elaborated using violence data from the Human Rights Observatory of the Office" "of the Vice-President, Colombia." "^Sum of guerrilla and paramilitary attacks.")
graph export "../FIGURES/figure4.png", as(png) replace
graph export "../FIGURES/figure4.pdf", as(pdf) replace
graph export "../FIGURES/figure4.tif", as(tif) replace


                                *---------------*
                                    *FIGURE 5*
                                *---------------*

************************************************************************************************************************

**** INSTALL RELEVANT ADO-FILES
*ssc install coefplot, replace

************************************************************************************************************************

eststo clear 

 * [1997-2002]
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial85_87_pc2==.
 
local controls1 regalias1988_1996_pc transferencias1988_1996_pc areakm2 alt_mun discapital left1994 trad1994 third1994 peaceful1988_1996 rec_total1993_1996 exp_total1993_1996 desplazados1993_1996 coca1993_1996 

foreach i in lningreso_predial97_02_pc2 {
 eststo: quietly xi: reg `i' lnguer1988_1996_pc_2 lnpara1988_1996_pc_2 lningreso_predial85_87_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark

 }


* [2003-2006]
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lningreso_predial93_96_pc2==.

local controls2 regalias1997_2002_pc transferencias1997_2002_pc areakm2 alt_mun discapital left2000 trad2000 third2000 peaceful1997_2002 mil_bases_1999_2002 rec_total1997_2002 exp_total1997_2002 desplazados1997_2002 coca1997_2002 endowments1997_2002 

foreach i in lningreso_predial03_06_pc2 {
 eststo: quietly xi: reg `i' lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lningreso_predial93_96_pc2 `controls2'  i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark

}



*[2007-2010]

*download dataset again:
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lningreso_predial00_02_pc2==.

local controls3 regalias2003_2006_pc transferencias2003_2006_pc areakm2 alt_mun discapital left2003 trad2003 third2003 peaceful2003_2006 mil_bases_2003_2006 rec_total2003_2006 exp_total2003_2006 desplazados2003_2006 coca2003_2006 endowments2003_2006 

foreach i in lningreso_predial07_10_pc2 {
 eststo: quietly xi: reg `i' lnguer2003_2006_pc_2 lnpara2003_2006_pc_2 lningreso_predial00_02_pc2 `controls3' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark
 }

*[2011-2013] - Falsification test

*download dataset again:
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lningreso_predial03_06_pc2==.

local controls4 regalias2007_2010_pc transferencias2007_2010_pc areakm2 alt_mun discapital left2007 trad2007 third2007 peaceful2007_2010 mil_bases_2007_2009 rec_total2007_2010 exp_total2007_2010 desplazados2007_2010 coca2007_2010 endowments2007_2010 

foreach i in lningreso_predial11_13_pc2 {
 eststo: quietly xi: reg `i' lnguer2007_2010_pc_2 lnpara2007_2010_pc_2 lningreso_predial03_06_pc2 `controls4' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark
 }

coefplot (est1) (est2) (est3) (est4),  scheme(s1color) legend(off) xline(0)   ///
ytitle("(log) cum. attacks per capita") ///
keep(lnguer1988_1996_pc_2 lnpara1988_1996_pc_2 lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lnguer2003_2006_pc_2 lnpara2003_2006_pc_2 lnguer2007_2010_pc_2 lnpara2007_2010_pc_2) ///
coeflabels(lnguer1988_1996_pc_2 = "Guerrilla, 1988-1996" lnpara1988_1996_pc_2 = "Paramilitary, 1988-1996" lnguer1997_2002_pc_2 = "Guerrilla, 1997-2002" lnpara1997_2002_pc_2 = "Paramilitary, 1997-2002" lnguer2003_2006_pc_2 = "Guerrilla, 2003-2006" lnpara2003_2006_pc_2 = "Paramilitary, 2003-2006" lnguer2007_2010_pc_2 = "Guerrilla, 2007-2010" lnpara2007_2010_pc_2 = "Paramilitary, 2007-2010")
graph export "../FIGURES/figure5.png", as(png) replace
graph export "../FIGURES/figure5.pdf", as(pdf) replace
graph export "../FIGURES/figure5.tif", as(tif) replace

                                *---------------*
                                    *FIGURE 6*
                                *---------------*
								
eststo clear 

graph drop _all

foreach i in lningreso_predial03_06_pc2 avaluo_rur_pcrur03_06 rezago_catastral03_06 numactualizaciones03_06 informalidad03_06{
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lningreso_predial93_96_pc2==.

local controls2 regalias1997_2002_pc transferencias1997_2002_pc areakm2 alt_mun discapital left2000 trad2000 third2000 peaceful1997_2002 mil_bases_1999_2002 rec_total1997_2002 exp_total1997_2002 desplazados1997_2002 coca1997_2002 endowments1997_2002 

quietly xi: reg `i' lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lningreso_predial93_96_pc2 `controls2'  i.cod_depto, cluster(cod_depto)	
keep if e(sample)
format lnguer1997_2002_pc_2 %4.1f
format lnpara1997_2002_pc_2 %4.1f


sum lnguer1997_2002_pc_2, d
local guer_p50=r(p50)
local guer_p90=r(p90)

sum lnpara1997_2002_pc_2, d
local para_p50=r(p50)
local para_p90=r(p90)

margins, at(lnguer1997_2002_pc_2=(`guer_p50'(5)`guer_p90')) vsquish
marginsplot, scheme(s1color) title("") subtitle("") ytitle("prediction") xtitle("(log)guerrilla attacks per capita") name(`i'_guer)

margins,  at(lnpara1997_2002_pc_2=(`para_p50'(5)`para_p90')) vsquish
marginsplot, scheme(s1color) title("") subtitle("") ytitle("") xtitle("(log)paramilitary attacks per capita") name(`i'_para)

}

*Figure 6 combine: 
graph combine lningreso_predial03_06_pc2_guer lningreso_predial03_06_pc2_para, ///
subtitle("Property tax revenue") ///
scheme(s1color)  ycommon imargin(vsmall)  name(figure6_1)

graph combine avaluo_rur_pcrur03_06_guer avaluo_rur_pcrur03_06_para, ///
subtitle("Per capita land value") ///
scheme(s1color)  ycommon imargin(vsmall) name(figure6_2)

graph combine rezago_catastral03_06_guer rezago_catastral03_06_para, ///
subtitle("Cadastral update lag") ///
scheme(s1color)  ycommon imargin(vsmall) name(figure6_3)

graph combine numactualizaciones03_06_guer numactualizaciones03_06_para, ///
subtitle("# cadastral updates") ///
scheme(s1color)  ycommon imargin(vsmall) name(figure6_4)

graph combine informalidad03_06_guer informalidad03_06_para, ///
subtitle("Land informality rate") ///
scheme(s1color)  ycommon imargin(vsmall) name(figure6_5)


graph combine figure6_1, ///
subtitle("predictive margins, 95% CIs") ///
scheme(s1color)  col(1) name(main)
graph export "../FIGURES/figure6_part1.png", as(png) replace
graph export "../FIGURES/figure6_part1.pdf", as(pdf) replace
graph export "../FIGURES/figure6_part1.tif", as(tif) replace

graph combine figure6_2 figure6_3 figure6_4 figure6_5, ///
scheme(s1color)  col(2) name(mechanisms)
graph export "../FIGURES/figure6_part2.png", as(png) replace
graph export "../FIGURES/figure6_part2.pdf", as(pdf) replace
graph export "../FIGURES/figure6_part2.tif", as(tif) replace



								*---------------*
                                    *FIGURE E7*
                                *---------------*
                                
                                
*Six year moving window:

clear all
set maxvar 32500 
set more off 
set varabbrev off

eststo clear 

use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial85_87_pc2==.
local controls1 regalias1988_1993_pc transferencias1988_1993_pc areakm2 alt_mun discapital left1994 trad1994 third1994 peaceful1988_1993 

 eststo: quietly  xi: reg lningreso_predial94_96_pc2 lnguer1988_1993_pc_2 lnpara1988_1993_pc_2 lningreso_predial85_87_pc2  `controls1'  i.cod_depto, cluster(cod_depto)

use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial86_88_pc2==.
local controls1 regalias1989_1994_pc transferencias1989_1994_pc areakm2 alt_mun discapital left1994 trad1994 third1994 peaceful1989_1994  

 eststo: quietly  xi: reg lningreso_predial95_97_pc2 lnguer1989_1994_pc_2 lnpara1989_1994_pc_2 lningreso_predial86_88_pc2  `controls1'  i.cod_depto, cluster(cod_depto)

 use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial87_89_pc2==.
local controls1 regalias1990_1995_pc transferencias1990_1995_pc areakm2 alt_mun discapital left1994 trad1994 third1994 peaceful1990_1995  

 eststo: quietly  xi: reg lningreso_predial96_98_pc2 lnguer1990_1995_pc_2 lnpara1990_1995_pc_2 lningreso_predial87_89_pc2  `controls1'  i.cod_depto, cluster(cod_depto)

use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial88_90_pc2==.
local controls1 regalias1991_1996_pc transferencias1991_1996_pc areakm2 alt_mun discapital left1994 trad1994 third1994 peaceful1991_1996  

 eststo: quietly  xi: reg lningreso_predial97_99_pc2 lnguer1991_1996_pc_2 lnpara1991_1996_pc_2 lningreso_predial88_90_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 
*include endowments
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial89_91_pc2==.
local controls1 regalias1992_1997_pc transferencias1992_1997_pc areakm2 alt_mun discapital left1994 trad1994 third1994 peaceful1992_1997  endowments1997

 eststo: quietly  xi: reg lningreso_predial98_00_pc2 lnguer1992_1997_pc_2 lnpara1992_1997_pc_2 lningreso_predial89_91_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 
*include rec_total exp_total desplazados & coca
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial90_92_pc2==.
local controls1 regalias1993_1998_pc transferencias1993_1998_pc areakm2 alt_mun discapital left1994 trad1994 third1994 peaceful1993_1998 rec_total1993_1998 exp_total1993_1998 desplazados1993_1998 coca1993_1998 endowments1997_1998

 eststo: quietly  xi: reg lningreso_predial99_01_pc2 lnguer1993_1998_pc_2 lnpara1993_1998_pc_2 lningreso_predial90_92_pc2  `controls1'  i.cod_depto, cluster(cod_depto)

*Mil bases 
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial91_93_pc2==.
local controls1 regalias1994_1999_pc transferencias1994_1999_pc areakm2 alt_mun discapital left1994 trad1994 third1994 peaceful1994_1999 rec_total1994_1999 exp_total1994_1999 desplazados1994_1999 coca1994_1999 mil_bases_1999 endowments1997_1999

 eststo: quietly  xi: reg lningreso_predial00_02_pc2 lnguer1994_1999_pc_2 lnpara1994_1999_pc_2 lningreso_predial91_93_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial92_94_pc2==.
local controls1 regalias1995_2000_pc transferencias1995_2000_pc areakm2 alt_mun discapital left2000 trad2000 third2000 peaceful1995_2000 rec_total1995_2000 exp_total1995_2000 desplazados1995_2000 coca1995_2000 mil_bases_1999_2000 endowments1997_2000

 eststo: quietly  xi: reg lningreso_predial01_03_pc2 lnguer1995_2000_pc_2 lnpara1995_2000_pc_2 lningreso_predial92_94_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial93_95_pc2==.
local controls1 regalias1996_2001_pc transferencias1996_2001_pc areakm2 alt_mun discapital left2000 trad2000 third2000 peaceful1996_2001 rec_total1996_2001 exp_total1996_2001 desplazados1996_2001 coca1996_2001 mil_bases_1999_2001 endowments1997_2001

 eststo: quietly  xi: reg lningreso_predial02_04_pc2 lnguer1996_2001_pc_2 lnpara1996_2001_pc_2 lningreso_predial93_95_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
   
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial94_96_pc2==.
local controls1 regalias1997_2002_pc transferencias1997_2002_pc areakm2 alt_mun discapital left2000 trad2000 third2000 peaceful1997_2002 rec_total1997_2002 exp_total1997_2002 desplazados1997_2002 coca1997_2002 mil_bases_1999_2002 endowments1997_2002

 eststo: quietly  xi: reg lningreso_predial03_05_pc2 lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lningreso_predial94_96_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial95_97_pc2==.
local controls1 regalias1998_2003_pc transferencias1998_2003_pc areakm2 alt_mun discapital left2003 trad2003 third2003 peaceful1998_2003 rec_total1998_2003 exp_total1998_2003 desplazados1998_2003 coca1998_2003 mil_bases_1999_2003 endowments1998_2003

 eststo: quietly  xi: reg lningreso_predial04_06_pc2 lnguer1998_2003_pc_2 lnpara1998_2003_pc_2 lningreso_predial95_97_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial96_98_pc2==.
local controls1 regalias1999_2004_pc transferencias1999_2004_pc areakm2 alt_mun discapital left2003 trad2003 third2003 peaceful1999_2004 rec_total1999_2004 exp_total1999_2004 desplazados1999_2004 coca1999_2004 mil_bases_1999_2004 endowments1999_2004

 eststo: quietly  xi: reg lningreso_predial05_07_pc2 lnguer1999_2004_pc_2 lnpara1999_2004_pc_2 lningreso_predial96_98_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial97_99_pc2==.
local controls1 regalias2000_2005_pc transferencias2000_2005_pc areakm2 alt_mun discapital left2003 trad2003 third2003 peaceful2000_2005 rec_total2000_2005 exp_total2000_2005 desplazados2000_2005 coca2000_2005 mil_bases_2000_2005 endowments2000_2005

 eststo: quietly  xi: reg lningreso_predial06_08_pc2 lnguer2000_2005_pc_2 lnpara2000_2005_pc_2 lningreso_predial97_99_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial98_00_pc2==.
local controls1 regalias2001_2006_pc transferencias2001_2006_pc areakm2 alt_mun discapital left2003 trad2003 third2003 peaceful2001_2006 rec_total2001_2006 exp_total2001_2006 desplazados2001_2006 coca2001_2006 mil_bases_2001_2006 endowments2001_2006

 eststo: quietly  xi: reg lningreso_predial07_09_pc2 lnguer2001_2006_pc_2 lnpara2001_2006_pc_2 lningreso_predial98_00_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 

use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial99_01_pc2==.
local controls1 regalias2002_2007_pc transferencias2002_2007_pc areakm2 alt_mun discapital left2007 trad2007 third2007 peaceful2002_2007 rec_total2002_2007 exp_total2002_2007 desplazados2002_2007 coca2002_2007 mil_bases_2002_2007 endowments2002_2007

 eststo: quietly  xi: reg lningreso_predial08_10_pc2 lnguer2002_2007_pc_2 lnpara2002_2007_pc_2 lningreso_predial99_01_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial00_02_pc2==.
local controls1 regalias2003_2008_pc transferencias2003_2008_pc areakm2 alt_mun discapital left2007 trad2007 third2007 peaceful2003_2008 rec_total2003_2008 exp_total2003_2008 desplazados2003_2008 coca2003_2008 mil_bases_2003_2008 endowments2003_2008

 eststo: quietly  xi: reg lningreso_predial09_11_pc2 lnguer2003_2008_pc_2 lnpara2003_2008_pc_2 lningreso_predial00_02_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial01_03_pc2==.
local controls1 regalias2004_2009_pc transferencias2004_2009_pc areakm2 alt_mun discapital left2007 trad2007 third2007 peaceful2004_2009 rec_total2004_2009 exp_total2004_2009 desplazados2004_2009 coca2004_2009 mil_bases_2004_2009 endowments2004_2009

 eststo: quietly  xi: reg lningreso_predial10_12_pc2 lnguer2004_2009_pc_2 lnpara2004_2009_pc_2 lningreso_predial01_03_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 
*Mil bases up to 2009
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial02_04_pc2==.
local controls1 regalias2005_2010_pc transferencias2005_2010_pc areakm2 alt_mun discapital left2007 trad2007 third2007 peaceful2005_2010 rec_total2005_2010 exp_total2005_2010 desplazados2005_2010 coca2005_2010 mil_bases_2005_2009 endowments2005_2010

 eststo: quietly  xi: reg lningreso_predial11_13_pc2 lnguer2005_2010_pc_2 lnpara2005_2010_pc_2 lningreso_predial02_04_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 
coefplot (est1, mlabels(* = 12  "1994-1996")) (est2, mlabels(* = 12  "1995-1997")) (est3, mlabels(* = 12  "1996-1998")) ///
(est4, mlabels(* = 12  "1997-1999")) (est5, mlabels(* = 12  "1998-2000")) (est6, mlabels(* = 12  "1999-2001")) ///
(est7, mlabels(* = 12  "2000-2002")) (est8, mlabels(* = 12  "2001-2003")) (est9, mlabels(* = 12  "2002-2004")) ///
(est10, mlabels(* = 12  "2003-2005")) (est11, mlabels(* = 12  "2004-2006")) (est12, mlabels(* = 12  "2005-2007")) ///
(est13, mlabels(* = 12  "2006-2008")) (est14, mlabels(* = 12  "2007-2009")) (est15, mlabels(* = 12  "2008-2010")) ///
(est16, mlabels(* = 12  "2009-2011")) (est17, mlabels(* = 12  "2010-2012")) (est18, mlabels(* = 12  "2011-2013")), ///
legend(off) xline(0) ytitle("(log) cum. attacks per capita", size(small)) grid(between glcolor(white))   /// 
graphregion(color(white) lwidth(large)) fcolor(white) ///
xtitle("estimated coefficients") ///
keep(lnguer1988_1993_pc_2 lnpara1988_1993_pc_2 lnguer1989_1994_pc_2 lnpara1989_1994_pc_2 lnguer1990_1995_pc_2 lnpara1990_1995_pc_2 lnguer1991_1996_pc_2 lnpara1991_1996_pc_2 lnguer1992_1997_pc_2 lnpara1992_1997_pc_2 lnguer1993_1998_pc_2 lnpara1993_1998_pc_2 lnguer1994_1999_pc_2 lnpara1994_1999_pc_2 lnguer1995_2000_pc_2 lnpara1995_2000_pc_2 lnguer1996_2001_pc_2 lnpara1996_2001_pc_2 lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lnguer1998_2003_pc_2 lnpara1998_2003_pc_2 lnguer1999_2004_pc_2 lnpara1999_2004_pc_2 lnguer2000_2005_pc_2 lnpara2000_2005_pc_2 lnguer2001_2006_pc_2 lnpara2001_2006_pc_2 lnguer2002_2007_pc_2 lnpara2002_2007_pc_2  lnguer2003_2008_pc_2 lnpara2003_2008_pc_2  lnguer2004_2009_pc_2 lnpara2004_2009_pc_2 lnguer2005_2010_pc_2 lnpara2005_2010_pc_2) ///
coeflabels(lnguer1988_1993_pc_2 = "Guerrilla, 1988-1993" lnpara1988_1993_pc_2="Paramilitary, 1988-1993" lnguer1989_1994_pc_2="Guerrilla, 1989-1994" lnpara1989_1994_pc_2="Paramilitary, 1989-1994" lnguer1990_1995_pc_2="Guerrilla, 1990-1995" lnpara1990_1995_pc_2="Paramilitary, 1990-1995" lnguer1991_1996_pc_2="Guerrilla, 1991-1996" lnpara1991_1996_pc_2="Paramilitary, 1991-1996" lnguer1992_1997_pc_2="Guerrilla, 1992-1997" lnpara1992_1997_pc_2="Paramilitary, 1992-1997" lnguer1993_1998_pc_2="Guerrilla, 1993-1998" lnpara1993_1998_pc_2="Paramilitary, 1993-1998" lnguer1994_1999_pc_2="Guerrilla, 1994-1999" lnpara1994_1999_pc_2="Paramilitary, 1994-1999" lnguer1995_2000_pc_2="Guerrilla, 1995-2000" lnpara1995_2000_pc_2="Paramilitary, 1995-2000" lnguer1996_2001_pc_2="Guerrilla, 1996-2001" lnpara1996_2001_pc_2= "Paramilitary, 1996-2001"  lnguer1997_2002_pc_2="Guerrilla, 1997-2002"  lnpara1997_2002_pc_2="Paramilitary, 1997-2002" lnguer1998_2003_pc_2="Guerrilla, 1998-2003" lnpara1998_2003_pc_2 ="Paramilitary, 1998-2003" lnguer1999_2004_pc_2="Guerrilla, 1999-2004" lnpara1999_2004_pc_2="Paramilitary, 1999-2004" lnguer2000_2005_pc_2="Guerrilla, 2000-2005" lnpara2000_2005_pc_2="Paramilitary, 2000-2005" lnguer2001_2006_pc_2="Guerrilla, 2001-2006" lnpara2001_2006_pc_2="Paramilitary, 2001-2006" lnguer2002_2007_pc_2="Guerrilla, 2002-2007" lnpara2002_2007_pc_2="Paramilitary, 2002-2007"  lnguer2003_2008_pc_2="Guerrilla, 2003-2008" lnpara2003_2008_pc_2="Paramilitary, 2003-2008"  lnguer2004_2009_pc_2="Guerrilla, 2004-2009" lnpara2004_2009_pc_2="Paramilitary, 2004-2009" lnguer2005_2010_pc_2="Guerrilla, 2005-2010" lnpara2005_2010_pc_2="Paramilitary, 2005-2010", labsize(small) labgap(3))

graph export "../FIGURES/figureE7.png", as(png) replace
graph export "../FIGURES/figureE7.pdf", as(pdf) replace
graph export "../FIGURES/figureE7.tif", as(tif) replace


                                *---------------*
                                    *FIGURE E8*
                                *---------------*
                                
                                
*Eight year moving window:

clear all
set maxvar 32500 
set more off 
set varabbrev off

eststo clear 

use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial85_87_pc2==.
local controls1 regalias1988_1995_pc transferencias1988_1995_pc areakm2 alt_mun discapital left1994 trad1994 third1994 peaceful1988_1995 rec_total1993_1995 exp_total1993_1995 desplazados1993_1995

 eststo: quietly  xi: reg lningreso_predial96_00_pc2 lnguer1988_1995_pc_2 lnpara1988_1995_pc_2 lningreso_predial85_87_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 
 use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial85_88_pc2==.
local controls1 regalias1989_1996_pc transferencias1989_1996_pc areakm2 alt_mun discapital left1994 trad1994 third1994 peaceful1989_1996  rec_total1993_1996 exp_total1993_1996 desplazados1993_1996

 eststo: quietly  xi: reg lningreso_predial97_01_pc2 lnguer1989_1996_pc_2 lnpara1989_1996_pc_2 lningreso_predial85_88_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 
 use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial85_89_pc2==.
local controls1 regalias1990_1997_pc transferencias1990_1997_pc areakm2 alt_mun discapital left1994 trad1994 third1994 peaceful1990_1997 rec_total1993_1997 exp_total1993_1997 desplazados1993_1997  endowments1997

 eststo: quietly  xi: reg lningreso_predial98_02_pc2 lnguer1990_1997_pc_2 lnpara1990_1997_pc_2 lningreso_predial85_89_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial86_90_pc2==.
local controls1 regalias1991_1998_pc transferencias1991_1998_pc areakm2 alt_mun discapital left1994 trad1994 third1994 peaceful1991_1998 rec_total1993_1998 exp_total1993_1998 desplazados1993_1998  endowments1997_1998

 eststo: quietly  xi: reg lningreso_predial99_03_pc2 lnguer1991_1998_pc_2 lnpara1991_1998_pc_2 lningreso_predial86_90_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial87_91_pc2==.
local controls1 regalias1992_1999_pc transferencias1992_1999_pc areakm2 alt_mun discapital left1994 trad1994 third1994 peaceful1992_1999  rec_total1993_1999 exp_total1993_1999 desplazados1993_1999  endowments1997_1999 mil_bases_1999

 eststo: quietly  xi: reg lningreso_predial00_04_pc2 lnguer1992_1999_pc_2 lnpara1992_1999_pc_2 lningreso_predial87_91_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial88_92_pc2==.
local controls1 regalias1993_2000_pc transferencias1993_2000_pc areakm2 alt_mun discapital left2000 trad2000 third2000 peaceful1993_2000 rec_total1993_2000 exp_total1993_2000 desplazados1993_2000 coca1993_2000 endowments1997_2000 mil_bases_1999_2000

 eststo: quietly  xi: reg lningreso_predial01_05_pc2 lnguer1993_2000_pc_2 lnpara1993_2000_pc_2 lningreso_predial88_92_pc2  `controls1'  i.cod_depto, cluster(cod_depto)

use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial89_93_pc2==.
local controls1 regalias1994_2001_pc transferencias1994_2001_pc areakm2 alt_mun discapital left2000 trad2000 third2000 peaceful1994_2001 rec_total1994_2001 exp_total1994_2001 desplazados1994_2001 coca1994_2001 endowments1997_2001 mil_bases_1999_2001

 eststo: quietly  xi: reg lningreso_predial02_06_pc2 lnguer1994_2001_pc_2 lnpara1994_2001_pc_2 lningreso_predial89_93_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial90_94_pc2==.
local controls1 regalias1995_2002_pc transferencias1995_2002_pc areakm2 alt_mun discapital left2000 trad2000 third2000 peaceful1995_2002 rec_total1995_2002 exp_total1995_2002 desplazados1995_2002 coca1995_2002 endowments1997_2002 mil_bases_1999_2002

 eststo: quietly  xi: reg lningreso_predial03_07_pc2 lnguer1995_2002_pc_2 lnpara1995_2002_pc_2 lningreso_predial90_94_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial91_95_pc2==.
local controls1 regalias1996_2003_pc transferencias1996_2003_pc areakm2 alt_mun discapital left2003 trad2003 third2003 peaceful1996_2003 rec_total1996_2003 exp_total1996_2003 desplazados1996_2003 coca1996_2003 endowments1997_2003 mil_bases_1999_2003

 eststo: quietly  xi: reg lningreso_predial04_08_pc2 lnguer1996_2003_pc_2 lnpara1996_2003_pc_2 lningreso_predial91_95_pc2  `controls1'  i.cod_depto, cluster(cod_depto)

use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial92_96_pc2==.
local controls1 regalias1997_2004_pc transferencias1997_2004_pc areakm2 alt_mun discapital left2003 trad2003 third2003 peaceful1997_2004 rec_total1997_2004 exp_total1997_2004 desplazados1997_2004 coca1997_2004 endowments1997_2004 mil_bases_1999_2004

 eststo: quietly  xi: reg lningreso_predial05_09_pc2 lnguer1997_2004_pc_2 lnpara1997_2004_pc_2 lningreso_predial92_96_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial93_97_pc2==.
local controls1 regalias1998_2005_pc transferencias1998_2005_pc areakm2 alt_mun discapital left2003 trad2003 third2003 peaceful1998_2005 rec_total1998_2005 exp_total1998_2005 desplazados1998_2005 coca1998_2005 endowments1998_2005 mil_bases_1999_2005

 eststo: quietly  xi: reg lningreso_predial06_10_pc2 lnguer1998_2005_pc_2 lnpara1998_2005_pc_2 lningreso_predial93_97_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial94_98_pc2==.
local controls1 regalias1999_2006_pc transferencias1999_2006_pc areakm2 alt_mun discapital left2003 trad2003 third2003 peaceful1999_2006 rec_total1999_2006 exp_total1999_2006 desplazados1999_2006 coca1999_2006 endowments1999_2006 mil_bases_1999_2006

 eststo: quietly  xi: reg lningreso_predial07_11_pc2 lnguer1999_2006_pc_2 lnpara1999_2006_pc_2 lningreso_predial94_98_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial95_99_pc2==.
local controls1 regalias2000_2007_pc transferencias2000_2007_pc areakm2 alt_mun discapital left2007 trad2007 third2007 peaceful2000_2007 rec_total2000_2007 exp_total2000_2007 desplazados2000_2007 coca2000_2007 endowments2000_2007 mil_bases_2000_2007

 eststo: quietly  xi: reg lningreso_predial08_12_pc2 lnguer2000_2007_pc_2 lnpara2000_2007_pc_2 lningreso_predial95_99_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial96_00_pc2==.
local controls1 regalias2001_2008_pc transferencias2001_2008_pc areakm2 alt_mun discapital left2007 trad2007 third2007 peaceful2001_2008 rec_total2001_2008 exp_total2001_2008 desplazados2001_2008 coca2001_2008 endowments2001_2008 mil_bases_2001_2008

 eststo: quietly  xi: reg lningreso_predial09_13_pc2 lnguer2001_2008_pc_2 lnpara2001_2008_pc_2 lningreso_predial96_00_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial97_01_pc2==.
local controls1 regalias2002_2009_pc transferencias2002_2009_pc areakm2 alt_mun discapital left2007 trad2007 third2007 peaceful2002_2009 rec_total2002_2009 exp_total2002_2009 desplazados2002_2009 coca2002_2009 endowments2002_2009 mil_bases_2002_2009

 eststo: quietly  xi: reg lningreso_predial10_13_pc2 lnguer2002_2009_pc_2 lnpara2002_2009_pc_2 lningreso_predial97_01_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 
 use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial98_02_pc2==.
local controls1 regalias2003_2010_pc transferencias2003_2010_pc areakm2 alt_mun discapital left2007 trad2007 third2007 peaceful2003_2010 rec_total2003_2010 exp_total2003_2010 desplazados2003_2010 coca2003_2010 endowments2003_2010 mil_bases_2003_2010

 eststo: quietly  xi: reg lningreso_predial11_13_pc2 lnguer2003_2010_pc_2 lnpara2003_2010_pc_2 lningreso_predial98_02_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 
coefplot (est1, mlabels(* = 12  "1996-2000")) (est2, mlabels(* = 12  "1997-2001")) (est3, mlabels(* = 12  "1998-2002")) ///
(est4, mlabels(* = 12  "1999-2003")) (est5, mlabels(* = 12  "2000-2004")) (est6, mlabels(* = 12  "2001-2005")) ///
(est7, mlabels(* = 12  "2002-2006")) (est8, mlabels(* = 12  "2003-2007")) (est9, mlabels(* = 12  "2004-2008")) ///
(est10, mlabels(* = 12  "2005-2009")) (est11, mlabels(* = 12  "2006-2010")) (est12, mlabels(* = 12  "2007-2011")) ///
(est13, mlabels(* = 12  "2008-2012")) (est14, mlabels(* = 12  "2009-2013")) (est15, mlabels(* = 12  "2010-2013")) ///
(est16, mlabels(* = 12  "2011-2013")), ///
legend(off) xline(0) ytitle("(log) cum. attacks per capita", size(small)) grid(between glcolor(white))   /// 
xtitle("estimated coefficients") ///
graphregion(color(white) lwidth(large)) fcolor(white) ///
keep(lnguer1988_1995_pc_2 lnpara1988_1995_pc_2 lnguer1989_1996_pc_2 lnpara1989_1996_pc_2 lnguer1990_1997_pc_2 lnpara1990_1997_pc_2 lnguer1991_1998_pc_2 lnpara1991_1998_pc_2 lnguer1992_1999_pc_2 lnpara1992_1999_pc_2 lnguer1993_2000_pc_2 lnpara1993_2000_pc_2 lnguer1994_2001_pc_2 lnpara1994_2001_pc_2 lnguer1995_2002_pc_2 lnpara1995_2002_pc_2 ///
lnguer1996_2003_pc_2 lnpara1996_2003_pc_2 lnguer1997_2004_pc_2 lnpara1997_2004_pc_2 lnguer1998_2005_pc_2 lnpara1998_2005_pc_2  lnguer1999_2006_pc_2 lnpara1999_2006_pc_2 lnguer2000_2007_pc_2 lnpara2000_2007_pc_2 lnguer2001_2008_pc_2 lnpara2001_2008_pc_2 lnguer2002_2009_pc_2 lnpara2002_2009_pc_2 lnguer2003_2010_pc_2 lnpara2003_2010_pc_2) ///
coeflabels(lnguer1988_1995_pc_2 = "Guerrilla, 1988-1995" lnpara1988_1995_pc_2="Paramilitary, 1988-1995" lnguer1989_1996_pc_2="Guerrilla, 1989-1996" /// 
lnpara1989_1996_pc_2="Paramilitary, 1989-1996" lnguer1990_1997_pc_2="Guerrilla, 1990-1997" lnpara1990_1997_pc_2="Paramilitary, 1990-1997" /// 
lnguer1991_1998_pc_2="Guerrilla, 1991-1998" lnpara1991_1998_pc_2="Paramilitary, 1991-1998" lnguer1992_1999_pc_2="Guerrilla, 1992-1999" /// 
lnpara1992_1999_pc_2="Paramilitary, 1992-1999" lnguer1993_2000_pc_2="Guerrilla, 1993-2000" lnpara1993_2000_pc_2="Paramilitary, 1993-2000" /// 
lnguer1994_2001_pc_2="Guerrilla, 1994-2001" lnpara1994_2001_pc_2="Paramilitary, 1994-2001" lnguer1995_2002_pc_2="Guerrilla, 1995-2002" /// 
lnpara1995_2002_pc_2="Paramilitary, 1995-2002" lnguer1996_2003_pc_2="Guerrilla, 1996-2003" lnpara1996_2003_pc_2= "Paramilitary, 1996-2003" /// 
lnguer1997_2004_pc_2="Guerrilla, 1997-2004"  lnpara1997_2004_pc_2="Paramilitary, 1997-2004" lnguer1998_2005_pc_2="Guerrilla, 1998-2005" /// 
lnpara1998_2005_pc_2 ="Paramilitary, 1998-2005" lnguer1999_2006_pc_2="Guerrilla, 1999-2006" lnpara1999_2006_pc_2="Paramilitary, 1999-2006" /// 
lnguer2000_2007_pc_2="Guerrilla, 2000-2007" lnpara2000_2007_pc_2="Paramilitary, 2000-2007" lnguer2001_2008_pc_2="Guerrilla, 2001-2008" /// 
lnpara2001_2008_pc_2="Paramilitary, 2001-2008" lnguer2002_2009_pc_2="Guerrilla, 2002-2009" lnpara2002_2009_pc_2="Paramilitary, 2002-2009"   /// 
lnguer2003_2010_pc_2="Guerrilla, 2003-2010" lnpara2003_2010_pc_2="Paramilitary, 2003-2010", labsize(small) labgap(3))

graph export "../FIGURES/figureE8.png", as(png) replace
graph export "../FIGURES/figureE8.pdf", as(pdf) replace
graph export "../FIGURES/figureE8.tif", as(tif) replace



***************** END ***********************






















