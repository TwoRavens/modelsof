
*****************************************************
** Appendix
*****************************************************

clear
set more off

use "~services_admin_tscs.dta"

xtset ccodecow

global controls "lpop_l wdi_urban_l lgdppc_l conflict_l dpi_state_l p_polity2_l loilpc_l aid_pc_l"


gen quinq5 = 1 if year==1970 | year==1975 | year==1980 | year==1985 | year==1990 | year==1995 | year==2000 | year==2005 | year==2010


keep if region_x=="Sub-Saharan Africa"
fvset base 2000 year


*****************************************************
** Section A: Data Sources and Coding
*****************************************************

***** Table A1 *****
estpost tabstat primarydiv_num, by(cname) statistics (mean min max) 
esttab, cells("mean(fmt(1)) min(fmt(0)) max(fmt(0))") noobs nonumber label title("Administrative Units") replace


*****************************************************
** Section C: Summary Statistics
*****************************************************

***** Table C1 *****
estpost summarize ServicesA ServicesCA $controls adminpc
esttab using "Analysis/tables/summarystats.tex", cells("mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))") noobs nonumber label title("Summary statistics") replace

*****************************************************
** Section D: Robustness checks: Country-level Analysis
*****************************************************

***** Table D1 *****
xtreg ServicesA $controls adminpc_l3 adminpc2_l3 i.year,fe r cluster(ccodecow)
est store A
xtreg ServicesA $controls ladminpc_l3 i.year,fe r cluster(ccodecow)
est store B
ivregress 2sls ServicesA $controls al_ethnic i.year (adminpc_l3 adminpc2_l3=lmeanMINUSi_adminpc_l4 lmeanMINUSi_adminpc2_l4 herf herf2 llength llength2), r cluster(ccodecow)
est store C
ivregress 2sls ServicesA $controls al_ethnic i.year (ladminpc_l3=lmeanMINUSi_adminpc_l4 lmeanMINUSi_adminpc2_l4 herf herf2 llength llength2), r cluster(ccodecow)
est store D
xtreg ServicesCA $controls adminpc_l3 adminpc2_l3 i.year,fe r cluster(ccodecow)
est store E
xtreg ServicesCA $controls ladminpc_l3 i.year,fe r cluster(ccodecow)
est store F
ivregress 2sls ServicesCA $controls al_ethnic i.year (adminpc_l3 adminpc2_l3=lmeanMINUSi_adminpc_l4 lmeanMINUSi_adminpc2_l4 herf herf2 llength llength2), r cluster(ccodecow)
est store G
ivregress 2sls ServicesCA $controls al_ethnic i.year (ladminpc_l3=lmeanMINUSi_adminpc_l4 lmeanMINUSi_adminpc2_l4 herf herf2 llength llength2), r cluster(ccodecow)
est store H
esttab A B C D E F G H using "Analysis/tables/main_table_3yr.tex", replace cells(b(star fmt(3)) se(par fmt(3))) scalars(N ll aic bic) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) label title("Fixed Effects and IV Models, Annual") mtitles("Main, FE" "Main, FE" "Main, IV" "Main, IV" "Ext, FE" "Ext, FE" "Ext, IV" "Ext, IV")
eststo clear

***** Table D2 *****

preserve 

# delimit;
keep admin adminpc_l3 adminpc2_l3 adminpc_l5 adminpc2_l5 
ladminpc_l3 ladminpc_l5 lpop_l wdi_urban_l aid_pc_l lgdppc_l
al_ethnic conflict_l dpi_state_l p_polity2_l loilpc_l  
WDITopic8var45 WDITopic8var63H WDITopic8var37 WDITopic4var48 WDITopic4var60H WDITopic4var75 ccodecow region_x decades year;
# delimit cr


global to_be_imputed "adminpc_l3 adminpc2_l3 adminpc_l5 adminpc2_l5 ladminpc_l3 ladminpc_l5 lpop_l wdi_urban_l aid_pc_l lgdppc_l conflict_l dpi_state_l p_polity2_l loilpc_l WDITopic8var45 WDITopic8var63H WDITopic8var37 WDITopic4var48 WDITopic4var60H WDITopic4var75"

mi set mlong
mi register imputed $to_be_imputed

set seed 072014
mi impute mvn $to_be_imputed = admin year decades, add(20)

do "~genindex.do"

* create service summary index
mi xeq:genindex WDITopic8var45 WDITopic8var63H WDITopic4var48 WDITopic4var75, nv(Services)
mi xeq:genindex WDITopic8var45 WDITopic8var63H WDITopic4var48 WDITopic4var60H WDITopic4var75, nv(ServicesB)
mi xeq:genindex WDITopic8var45 WDITopic8var63H WDITopic8var37 WDITopic4var48 WDITopic4var60H WDITopic4var75, nv(ServicesC)

mi xeq: keep if region_x=="Sub-Saharan Africa"

* set panel vars
mi xtset ccodecow year

global controls "lpop_l wdi_urban_l lgdppc_l conflict_l dpi_state_l p_polity2_l loilpc_l aid_pc_l"

mi fvset base 2000 year

* models
mi estimate, cmdok post:xtreg ServicesA $controls adminpc_l5 adminpc2_l5 i.year if year >1979,fe r cluster(ccodecow)
est store A
mi estimate, cmdok post:xtreg ServicesA $controls ladminpc_l5 i.year if year >1979,fe r cluster(ccodecow)
est store B
mi estimate, cmdok post:xtreg ServicesA $controls adminpc_l3 adminpc2_l3 i.year if year >1979,fe r cluster(ccodecow)
est store C
mi estimate, cmdok post:xtreg ServicesA $controls ladminpc_l3 i.year if year >1979,fe r cluster(ccodecow)
est store D
mi estimate, cmdok post:xtreg ServicesCA $controls adminpc_l5 adminpc2_l5 i.year,fe r cluster(ccodecow)
est store E
mi estimate, cmdok post:xtreg ServicesCA $controls ladminpc_l5 i.year,fe r cluster(ccodecow)
est store F
mi estimate, cmdok post:xtreg ServicesCA $controls adminpc_l3 adminpc2_l3 i.year,fe r cluster(ccodecow)
est store G
mi estimate, cmdok post:xtreg ServicesCA $controls ladminpc_l3 i.year,fe r cluster(ccodecow)
est store H
esttab A B C D E F G H using "Analysis/tables/Annual_FE_A_andCA_imputed.tex", replace cells(b(star fmt(3)) se(par fmt(3))) scalars(N ll aic bic) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) label title("Fixed Effects Models, Annual") mtitles("Main" "Main" "Main" "Main" "Ext" "Ext" "Ext" "Ext")
eststo clear

restore, preserve

***** Table D3 *****

xtreg quinq5_ServicesA quinq5_lpop quinq5_aid_pc quinq5_wdi_urban quinq5_lgdppc quinq5_conflict quinq5_dpi_state quinq5_p_polity2 quinq5_loilpc quinq5_adminpc quinq5_adminpc2 i.year,fe r cluster(ccodecow)
est store A
xtreg quinq5_ServicesA quinq5_lpop quinq5_aid_pc quinq5_wdi_urban quinq5_lgdppc quinq5_conflict quinq5_dpi_state quinq5_p_polity2 quinq5_loilpc quinq5_ladminpc i.year,fe r cluster(ccodecow)
est store B
xtreg quinq5_ServicesA quinq53_lpop quinq53_aid_pc quinq53_wdi_urban quinq53_lgdppc quinq53_conflict quinq53_dpi_state quinq53_p_polity2 quinq53_loilpc quinq53_adminpc quinq53_adminpc2 i.year,fe r cluster(ccodecow)
est store C
xtreg quinq5_ServicesA quinq53_lpop quinq53_aid_pc quinq53_wdi_urban quinq53_lgdppc quinq53_conflict quinq53_dpi_state quinq53_p_polity2 quinq53_loilpc quinq53_ladminpc i.year,fe r cluster(ccodecow)
est store D
esttab A B C D using "Analysis/tables/Quinn_FE_A_all.tex", replace cells(b(star fmt(3)) se(par fmt(3))) scalars(N ll aic bic) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) label title("Fixed Effects Models, Quinquennial, All Years") mtitles("FE" "FE" "FE" "FE")
eststo clear

***** Table D4 *****

xtreg quinq5_ServicesA quinq5_lpop quinq5_aid_pc quinq5_wdi_urban quinq5_lgdppc quinq5_conflict quinq5_dpi_state quinq5_p_polity2 quinq5_loilpc quinq5_adminpc quinq5_adminpc2 i.year if quinq5 == 1 ,fe r cluster(ccodecow)
est store A
xtreg quinq5_ServicesA quinq5_lpop quinq5_aid_pc quinq5_wdi_urban quinq5_lgdppc quinq5_conflict quinq5_dpi_state quinq5_p_polity2 quinq5_loilpc quinq5_ladminpc i.year if quinq5 == 1 ,fe r cluster(ccodecow)
est store B
xtreg quinq5_ServicesA quinq53_lpop quinq53_aid_pc quinq53_wdi_urban quinq53_lgdppc quinq53_conflict quinq53_dpi_state quinq53_p_polity2 quinq53_loilpc quinq53_adminpc quinq53_adminpc2 i.year if quinq5 == 1 ,fe r cluster(ccodecow)
est store C
xtreg quinq5_ServicesA quinq53_lpop quinq53_aid_pc quinq53_wdi_urban quinq53_lgdppc quinq53_conflict quinq53_dpi_state quinq53_p_polity2 quinq53_loilpc quinq53_ladminpc i.year if quinq5 == 1 ,fe r cluster(ccodecow)
est store D
esttab A B C D using "Analysis/tables/Quinn_FE_A_5th.tex", replace cells(b(star fmt(3)) se(par fmt(3))) scalars(N ll aic bic) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) label title("Fixed Effects Models, Quinquennial, Every 5th Year") mtitles("FE" "FE" "FE" "FE")
eststo clear

***** Table D5 *****

xtreg quinq5_ServicesCA quinq5_lpop quinq5_aid_pc quinq5_wdi_urban quinq5_lgdppc quinq5_conflict quinq5_dpi_state quinq5_p_polity2 quinq5_loilpc quinq5_adminpc quinq5_adminpc2 i.year,fe r cluster(ccodecow)
est store A
xtreg quinq5_ServicesCA quinq5_lpop quinq5_aid_pc quinq5_wdi_urban quinq5_lgdppc quinq5_conflict quinq5_dpi_state quinq5_p_polity2 quinq5_loilpc quinq5_ladminpc i.year,fe r cluster(ccodecow)
est store B
xtreg quinq5_ServicesCA quinq53_lpop quinq53_aid_pc quinq53_wdi_urban quinq53_lgdppc quinq53_conflict quinq53_dpi_state quinq53_p_polity2 quinq53_loilpc quinq53_adminpc quinq53_adminpc2 i.year,fe r cluster(ccodecow)
est store C
xtreg quinq5_ServicesCA quinq53_lpop quinq53_aid_pc quinq53_wdi_urban quinq53_lgdppc quinq53_conflict quinq53_dpi_state quinq53_p_polity2 quinq53_loilpc quinq53_ladminpc i.year,fe r cluster(ccodecow)
est store D
esttab A B C D using "Analysis/tables/Quinn_FE_CA_all.tex", replace cells(b(star fmt(3)) se(par fmt(3))) scalars(N ll aic bic) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) label title("Fixed Effects Models, Quinquennial, All Years") mtitles("FE" "FE" "FE" "FE")
eststo clear

***** Table D6 *****

xtreg quinq5_ServicesCA quinq5_lpop quinq5_aid_pc quinq5_wdi_urban quinq5_lgdppc quinq5_conflict quinq5_dpi_state quinq5_p_polity2 quinq5_loilpc quinq5_adminpc quinq5_adminpc2 i.year if quinq5 == 1 ,fe r cluster(ccodecow)
est store A
xtreg quinq5_ServicesCA quinq5_lpop quinq5_aid_pc quinq5_wdi_urban quinq5_lgdppc quinq5_conflict quinq5_dpi_state quinq5_p_polity2 quinq5_loilpc quinq5_ladminpc i.year if quinq5 == 1 ,fe r cluster(ccodecow)
est store B
xtreg quinq5_ServicesCA quinq53_lpop quinq53_aid_pc quinq53_wdi_urban quinq53_lgdppc quinq53_conflict quinq53_dpi_state quinq53_p_polity2 quinq53_loilpc quinq53_adminpc quinq53_adminpc2 i.year if quinq5 == 1 ,fe r cluster(ccodecow)
est store C
xtreg quinq5_ServicesCA quinq53_lpop quinq53_aid_pc quinq53_wdi_urban quinq53_lgdppc quinq53_conflict quinq53_dpi_state quinq53_p_polity2 quinq53_loilpc quinq53_ladminpc i.year if quinq5 == 1 ,fe r cluster(ccodecow)
est store D
esttab A B C D using "Analysis/tables/Quinn_FE_CA_5th.tex", replace cells(b(star fmt(3)) se(par fmt(3))) scalars(N ll aic bic) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) label title("Fixed Effects Models, Quinquennial, Every 5th Year") mtitles("FE" "FE" "FE" "FE")
eststo clear

***** Table D7 *****

# delimit;
keep exp_serv_l admin adminpc_l3 adminpc2_l3 adminpc_l5 adminpc2_l5 
ladminpc_l3 ladminpc_l5 lpop_l wdi_urban_l aid_pc_l lgdppc_l
al_ethnic conflict_l dpi_state_l p_polity2_l loilpc_l  
WDITopic8var45 WDITopic8var63H WDITopic8var37 WDITopic4var48 WDITopic4var60H WDITopic4var75 ccodecow region_x decades year;
# delimit cr

global to_be_imputed "exp_serv_l adminpc_l3 adminpc2_l3 adminpc_l5 adminpc2_l5 ladminpc_l3 ladminpc_l5 lpop_l wdi_urban_l aid_pc_l lgdppc_l conflict_l dpi_state_l p_polity2_l loilpc_l WDITopic8var45 WDITopic8var63H WDITopic8var37 WDITopic4var48 WDITopic4var60H WDITopic4var75"

mi set mlong
mi register imputed $to_be_imputed

set seed 072014
mi impute mvn $to_be_imputed = admin year decades, add(20)

* Run program
do "~genindex.do"

* create service summary index
mi xeq:genindex WDITopic8var45 WDITopic8var63H WDITopic4var48 WDITopic4var75, nv(Services)
mi xeq:genindex WDITopic8var45 WDITopic8var63H WDITopic4var48 WDITopic4var60H WDITopic4var75, nv(ServicesB)
mi xeq: genindex WDITopic8var45 WDITopic8var63H WDITopic8var37 WDITopic4var48 WDITopic4var60H WDITopic4var75, nv(ServicesC)

mi xeq: keep if region_x=="Sub-Saharan Africa"

* set panel vars
mi xtset ccodecow year

global controls "lpop_l wdi_urban_l lgdppc_l conflict_l dpi_state_l p_polity2_l loilpc_l aid_pc_l"

mi fvset base 2000 year

restore, preserve

* models
mi estimate, cmdok post:xtreg ServicesA $controls exp_serv_l adminpc_l5 adminpc2_l5 i.year if year >1979,fe r cluster(ccodecow)
est store A
mi estimate, cmdok post:xtreg ServicesA $controls exp_serv_l ladminpc_l5 i.year if year >1979,fe r cluster(ccodecow)
est store B
mi estimate, cmdok post:xtreg ServicesA $controls exp_serv_l adminpc_l3 adminpc2_l3 i.year if year >1979,fe r cluster(ccodecow)
est store C
mi estimate, cmdok post:xtreg ServicesA $controls exp_serv_l ladminpc_l3 i.year if year >1979,fe r cluster(ccodecow)
est store D
mi estimate, cmdok post:xtreg ServicesCA $controls exp_serv_l adminpc_l5 adminpc2_l5 i.year,fe r cluster(ccodecow)
est store E
mi estimate, cmdok post:xtreg ServicesCA $controls exp_serv_l ladminpc_l5 i.year,fe r cluster(ccodecow)
est store F
mi estimate, cmdok post:xtreg ServicesCA $controls exp_serv_l adminpc_l3 adminpc2_l3 i.year,fe r cluster(ccodecow)
est store G
mi estimate, cmdok post:xtreg ServicesCA $controls exp_serv_l ladminpc_l3 i.year,fe r cluster(ccodecow)
est store H
esttab A B C D E F G H using "Analysis/tables/Annual_FE_A_imputed_exp.tex", replace cells(b(star fmt(3)) se(par fmt(3))) scalars(N ll aic bic) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) label title("Fixed Effects Models, Annual") mtitles("Main" "Main" "Main" "Main" "Ext" "Ext" "Ext" "Ext")
eststo clear

***** Table D8 *****

xtreg ServicesA ServicesA_lag_1 $controls adminpc_l5 adminpc2_l5 i.year,fe r cluster(ccodecow)
est store A
xtreg ServicesA ServicesA_lag_1 $controls ladminpc_l5 i.year,fe r cluster(ccodecow)
est store B 
xtreg ServicesA ServicesA_lag_1 $controls adminpc_l3 adminpc2_l3 i.year,fe r cluster(ccodecow)
est store C
xtreg ServicesA ServicesA_lag_1 $controls ladminpc_l3 i.year,fe r cluster(ccodecow)
est store D
esttab A B C D using "Analysis/tables/Annual_FE_A_lag.tex", replace cells(b(star fmt(3)) se(par fmt(3))) scalars(N ll aic bic) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) label title("Fixed Effects Models, Annual") mtitles("FE" "FE" "FE" "FE")
eststo clear

***** Table D9 *****

xtreg ServicesCA $controls adminpc_l5 adminpc2_l5 i.year if wdi_pop>500000,fe r cluster(ccodecow)
est store A
xtreg ServicesCA $controls ladminpc_l5 i.year if wdi_pop>500000,fe r cluster(ccodecow)
est store B 
xtreg ServicesCA $controls adminpc_l3 adminpc2_l3 i.year if wdi_pop>500000,fe r cluster(ccodecow)
est store C
xtreg ServicesCA $controls ladminpc_l3 i.year if wdi_pop>500000,fe r cluster(ccodecow)
est store D
esttab A B C D using "Analysis/tables/Annual_FE_CA_nosmall.tex", replace cells(b(star fmt(3)) se(par fmt(3))) scalars(N ll aic bic) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) label title("Fixed Effects Models, Annual") mtitles("FE" "FE" "FE" "FE")
eststo clear

***** Table D10 *****
gen p_polity2_l_dum=0
replace p_polity2_l_dum=1 if p_polity2_l>5
global controls2 "lpop_l wdi_urban_l lgdppc_l conflict_l dpi_state_l p_polity2_l_dum loilpc_l aid_pc_l"

xtreg ServicesA $controls2 c.ladminpc_l5##i.p_polity2_l_dum i.year,fe r cluster(ccodecow)
est store A 
xtreg ServicesA $controls2 c.ladminpc_l5##i.p_polity2_l_dum i.year,fe r cluster(ccodecow)
est store B
xtreg ServicesCA $controls2 c.ladminpc_l5##i.p_polity2_l_dum i.year,fe r cluster(ccodecow)
est store C 
xtreg ServicesCA $controls2 c.ladminpc_l5##i.p_polity2_l_dum i.year,fe r cluster(ccodecow)
est store D
esttab A B C D using "Analysis/tables/Annual_FE_CAand_A_polity_dum.tex", replace cells(b(star fmt(3)) se(par fmt(3))) scalars(N ll aic bic) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) label title("Fixed Effects Models, Annual") mtitles("Main" "Main" "Main" "Main" "Ext" "Ext" "Ext" "Ext")
eststo clear


***** Table D11 *****

xtreg WDITopic8var45 $controls adminpc_l5 adminpc2_l5 i.year,fe r cluster(ccodecow)
est store A
xtreg WDITopic8var45 $controls ladminpc_l5 i.year,fe r cluster(ccodecow)
est store B 
xtreg WDITopic8var45 $controls adminpc_l3 adminpc2_l3 i.year,fe r cluster(ccodecow)
est store C
xtreg WDITopic8var45 $controls ladminpc_l3 i.year,fe r cluster(ccodecow)
est store D
xtreg WDITopic8var63H $controls adminpc_l5 adminpc2_l5 i.year,fe r cluster(ccodecow)
est store E
xtreg WDITopic8var63H $controls ladminpc_l5 i.year,fe r cluster(ccodecow)
est store F 
xtreg WDITopic8var63H $controls adminpc_l3 adminpc2_l3 i.year,fe r cluster(ccodecow)
est store G
xtreg WDITopic8var63H $controls ladminpc_l3 i.year,fe r cluster(ccodecow)
est store H
esttab A B C D E F G H using "Analysis/tables/Annual_FE_comp12.tex", replace cells(b(star fmt(3)) se(par fmt(3))) scalars(N ll aic bic) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) label title("Fixed Effects Models, Annual") mtitles("Main" "Main" "Main" "Main" "Ext" "Ext" "Ext" "Ext")
eststo clear

***** Table D12 *****

xtreg WDITopic8var37 $controls adminpc_l5 adminpc2_l5 i.year,fe r cluster(ccodecow)
est store A
xtreg WDITopic8var37 $controls ladminpc_l5 i.year,fe r cluster(ccodecow)
est store B 
xtreg WDITopic8var37 $controls adminpc_l3 adminpc2_l3 i.year,fe r cluster(ccodecow)
est store C
xtreg WDITopic8var37 $controls ladminpc_l3 i.year,fe r cluster(ccodecow)
est store D
xtreg WDITopic4var48 $controls adminpc_l5 adminpc2_l5 i.year,fe r cluster(ccodecow)
est store E
xtreg WDITopic4var48 $controls ladminpc_l5 i.year,fe r cluster(ccodecow)
est store F 
xtreg WDITopic4var48 $controls adminpc_l3 adminpc2_l3 i.year,fe r cluster(ccodecow)
est store G
xtreg WDITopic4var48 $controls ladminpc_l3 i.year,fe r cluster(ccodecow)
est store H
esttab A B C D E F G H using "Analysis/tables/Annual_FE_comp34.tex", replace cells(b(star fmt(3)) se(par fmt(3))) scalars(N ll aic bic) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) label title("Fixed Effects Models, Annual") mtitles("Main" "Main" "Main" "Main" "Ext" "Ext" "Ext" "Ext")
eststo clear

***** Table D13 *****

xtreg WDITopic4var60H $controls adminpc_l5 adminpc2_l5 i.year,fe r cluster(ccodecow)
est store A
xtreg WDITopic4var60H $controls ladminpc_l5 i.year,fe r cluster(ccodecow)
est store B 
xtreg WDITopic4var60H $controls adminpc_l3 adminpc2_l3 i.year,fe r cluster(ccodecow)
est store C
xtreg WDITopic4var60H $controls ladminpc_l3 i.year,fe r cluster(ccodecow)
est store D
xtreg WDITopic4var75 $controls adminpc_l5 adminpc2_l5 i.year,fe r cluster(ccodecow)
est store E
xtreg WDITopic4var75 $controls ladminpc_l5 i.year,fe r cluster(ccodecow)
est store F 
xtreg WDITopic4var75 $controls adminpc_l3 adminpc2_l3 i.year,fe r cluster(ccodecow)
est store G
xtreg WDITopic4var75 $controls ladminpc_l3 i.year,fe r cluster(ccodecow)
est store H
esttab A B C D E F G H using "Analysis/tables/Annual_FE_comp56.tex", replace cells(b(star fmt(3)) se(par fmt(3))) scalars(N ll aic bic) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) label title("Fixed Effects Models, Annual") mtitles("Main" "Main" "Main" "Main" "Ext" "Ext" "Ext" "Ext")
eststo clear

***** Table D14 *****

xtreg ServicesA $controls c.ladminpc_l5##c.al_ethnic i.year,fe r cluster(ccodecow)
est store A 
xtreg ServicesA $controls c.ladminpc_l5##c.al_ethnic i.year,fe r cluster(ccodecow)
est store B
xtreg ServicesCA $controls c.ladminpc_l5##c.al_ethnic i.year,fe r cluster(ccodecow)
est store C 
xtreg ServicesCA $controls c.ladminpc_l5##c.al_ethnic i.year,fe r cluster(ccodecow)
est store D
esttab A B C D using "Analysis/tables/Annual_FE_CAand_A_elf.tex", replace cells(b(star fmt(3)) se(par fmt(3))) scalars(N ll aic bic) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) label title("Fixed Effects Models, Annual") mtitles("Main" "Main" "Main" "Main" "Ext" "Ext" "Ext" "Ext")
eststo clear

***** Table D15 *****

xtreg ServicesCA $controls adminpc_l5 adminpc2_l5 imf_dum_l i.year,fe r cluster(ccodecow)
est store A
xtreg ServicesCA $controls ladminpc_l5 imf_dum_l i.year ,fe r cluster(ccodecow)
est store B 
xtreg ServicesCA $controls adminpc_l3 imf_dum_l adminpc2_l3 i.year ,fe r cluster(ccodecow)
est store C
xtreg ServicesCA $controls ladminpc_l3 imf_dum_l i.year ,fe r cluster(ccodecow)
est store D
xtreg ServicesCA $controls adminpc_l5 adminpc2_l5 wb_dum_l i.year,fe r cluster(ccodecow)
est store E
xtreg ServicesCA $controls ladminpc_l5 wb_dum_l i.year ,fe r cluster(ccodecow)
est store F 
xtreg ServicesCA $controls adminpc_l3 wb_dum_l adminpc2_l3 i.year ,fe r cluster(ccodecow)
est store G
xtreg ServicesCA $controls ladminpc_l3 wb_dum_l i.year ,fe r cluster(ccodecow)
est store H
esttab A B C D E F G H using "Analysis/tables/Annual_FE_CA_wbimf.tex", replace cells(b(star fmt(3)) se(par fmt(3))) scalars(N ll aic bic) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) label title("Fixed Effects Models, Annual") mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")
eststo clear

***** Figure D1 *****

***** Step 1. Run Stata code below to create dataset 
***** Step 2. Run R code in file Cross-National R Code.R to create Figure D1

preserve
drop _all
save "models_all.dta", emptyok replace
restore

xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=403,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=404,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=420,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=432,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=433,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=434,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=435,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=436,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=437,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=438,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=439,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=450,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=451,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=452,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=461,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=471,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=475,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=481,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=482,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=483,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=484,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=490,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=500,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=501,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=510,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=516,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=517,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=520,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=530,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=531,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=540,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=541,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=551,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=552,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=553,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=560,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=565,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=570,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=571,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=572,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=580,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=581,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=590,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=591,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=625,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=626,fe r cluster(ccodecow)
parmest, format(estimate %8.2f p %8.1f) saving(model_1, replace)
preserve
use "models_all.dta", clear
append using "model_1.dta"
save "models_all.dta", replace
restore

***** Figure D2 *****

jackknife, cluster(ccodecow) idcluster(newclus) keep:xtreg ServicesCA $controls ladminpc_l5 i.year,fe r cluster(ccodecow)
assert e(N_misreps)==0
local N = e(N_clust)
gen dfbeta_ladminpc_l5 = (_b[ladminpc_l5] - _b_ladminpc_l5)/(`N'-1)

scatter dfbeta_ladminpc_l5 newclus, mlabel(ccodecow) ///
       title("Dfbeta Values for Variable log(N. Local Gov pc) 5yr lag") xtitle("Cluster") ytitle("DFbeta")
	   
***** Table D16 *****

* clusters 434, 461, 437, 517 could be influential
xtreg ServicesCA $controls ladminpc_l5 i.year if ccodecow!=434 & ccodecow!=461 &ccodecow!=437 & ccodecow!=517,fe r cluster(ccodecow)
est store A
esttab A using "Analysis/tables/main_table_noinfluence.tex", replace cells(b(star fmt(3)) se(par fmt(3))) scalars(N ll aic bic) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) label title("Fixed Effects and IV Models, Annual") mtitles("Ext, FE")
eststo clear   

