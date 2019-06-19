# delimit;
capture log close;
clear;
set mem 300m;
set matsize 800;
*set maxvar  1000;
set more off;

/*
*************************************;
31st  October 2005
Randolph Bruno
Merging Files 2002 and 2005 in 
order to obtain panel
and to create the panel variable 1, 0
*************************************;
*/

cd "$dir";

log using logs/data.panel.txt, text replace;

***************************************************2002;
use data/data_merged.dta, clear;

keep if year==2002;
gen exporter= (exp_prc_sale > 0);

replace age=0 if age<0;

foreach var of varlist *
{;
rename `var' `var'2002; 
};

gen  id_merge=serialno2002;

sort id_merge;

save data/tempy2002.dta, replace;

***************************************************2005;

use data/data_merged.dta, clear;

keep if year==2005;
gen exporter= (exp_prc_sale > 0);

replace age=0 if age<0;
foreach var of varlist * {;
rename `var' `var'2005; 
};

gen  id_merge=Q3srl_no20022005;

sort id_merge;

save data/tempy2005.dta, replace;

*******************MERGING;

merge id_merge using data/tempy2002.dta;

tab _merge, m;
keep if _merge==3;

ren _merge mergingcode;

***********************************************************
ELIMINATING SOME INCONSISTENCIES ACCORDING TO SAVVAS MAIL
1ST JULY 2005
***********************************************************;

/*CORRECTING (DELETING) DOUBLE CODING*/
drop if id_merge==209 & serialno2005==3578;
drop if id_merge==305 & serialno2005==3005;
drop if id_merge==306 & serialno2005==3451;
drop if id_merge==337 & serialno2005==3403;
drop if id_merge==340 & serialno2005==3251;
drop if id_merge==344 & serialno2005==3351;
drop if id_merge==350 & serialno2005==3552;
drop if id_merge==537 & serialno2005==4033;
drop if id_merge==1628 & serialno2005==5437;
drop if id_merge==1832 & serialno2005==10001;
drop if id_merge==1960 & serialno2005==10082;
drop if id_merge==6261 & serialno2005==27133;
drop if id_merge==6261 & serialno2005==27109;
drop if id_merge==6501 & serialno2005==26231;

/*CORRECTING (DELETING) FIRM CHANGING COUNTRY BETWEEN 2002 AND 2005*/
drop if id_merge==2 & serialno2005==6400;
drop if id_merge==7 & serialno2005==6401;
drop if id_merge==9 & serialno2005==6407;
drop if id_merge==10 & serialno2005==6408;
drop if id_merge==11 & serialno2005==6403;
drop if id_merge==15 & serialno2005==6405;

/*CORRECTING (DELETING) FIRM ACCORDING TO SAVVAS SUGGESTION*/
drop if id_merge==1362 & serialno2005==8073;
drop if id_merge==3111 & serialno2005==27142;
drop if id_merge==3317 & serialno2005==22037;
drop if id_merge==9579 & serialno2005==22089;
drop if id_merge==8005 & serialno2005==5007;
drop if id_merge==8012 & serialno2005==5013;
drop if id_merge==9452 & serialno2005==10172;


*************************************************************
IF THE PREVIOUS DELETING PROCEDURE IS CORRECT THE FOLLOWING CHECK
 SHOULD GENEREATE csum always = 1 (never two)
*************************************************************;

gen c=1 ;
egen csum=sum(c), by(id_merge);
tab csum;

drop if csum==2;

sort csum id_merge;

save data/Panel_WIDE_02_05.dta, replace;

******************************
RESHAPING LONG
******************************;

reshape long 

exporter
year
age 
age2
regmacro
Q3panel
init_index
init_index_dual
country
country1
reg
Q2reason05
Q2_3permis
perc_sales_tax
exp_prc_sales
Q2_3salesonemp
Q2_3salesonemp_new
Q2_3salesonemp_new_def
LQ2_3salesonemp
Q2_3sales_per_def
Q2_3sales_per_PPP


Q3val_add
Q3val_add1
mats
matsp

cost
cost2
cost_mat
cost_pers
cost_nrg

Q3val_add_new
Q3val_add_new_def
LQ3val_add1

prod1DIG
prod4DIG
prod2DIG

size
sizeb

cardno
serialno
Q2_3yugo
citytown
Q3region
Q3srl_no2002
start

legstqA
legstqB

ind

Q2_3main_prdc

full_empqA
full_empqB
Q1full_empqC

Q1ownedqA
ownedqB
Q2_3ownedqC
Q1ownedqD
ownedqE
Q2_3ownedqF

sell_out

Q2_3plants
ops_abro

Q2_3sale_sctrqA
Q2_3sale_sctrqB
Q2_3sale_sctrqC
Q2_3sale_sctrqD
Q2_3sale_sctrqE
Q2_3sale_sctrqF
Q2_3sale_sctrqG
Q2_3sale_sctrqH

owner

estb

Q2_3priv


Q2_3custqA
Q2_3custqB
Q2_3custqC
Q2_3custqD
Q2_3custqE
Q2_3custqF
Q3custqE1
Q3custqE2
Q3custqE3

Q3local_off
compt
comps
Q3compsR
Q2_3ex_comps_ntl
Q3ex_comps_ntlR
Q3c_local
Q3comps_local
Q3comps_localR
Q3ex_comps_loc
Q3ex_comps_locR
Q2_3imp_cmpt
nocomp
nocompR
exnocomR
markupqA

Q2_3inputqA
Q2_3inputqB
Q2_3inputqC
custm_dly
Q2_3suppl_prc
Q2_3dys_inf_dfcqA
Q2_3dys_inf_dfcqB
Q2_3dys_inf_dfcqC
Q2_3int_clntsqA
Q2_3int_clntsqB
Q2_3int_clntsqC
Q2_3int_clntsqD
Q2_3int_clntsqE
Q2_3dys_dly_srvcqA
Q2_3dys_dly_srvcqB

court_sys_prcptqA
court_sys_prcptqB
court_sys_prcptqC
court_sys_prcptqD
court_sys_prcptqE
Q1court_sys_prcptqF

conf_lgl_systm
Q1conf_lgl_systmR

Q2_3sal_cred
Q2_3ovrdue_pymnt
Q2_3days_rslv_pymnt
Q2_3pay_scrtyqA
Q2_3pay_scrtyqB
Q2_3pay_prtctnqA
Q2_3pay_prtctnqB
Q2_3lossesqA
Q2_3lossesqB

info_laws               
intrp_laws              
Q1intrp_lawsR

time_pub_off_cat
Q2_3time_pub_off_prc

pay_perc_sales
Q2_3pay_perc_sales_prc
pay_reasonqJ 
pay_impctqA
pay_impctqB


unoff_pay

memb_lobby

add_pay
know_add_pay

Q2_3source_fin_capqA
Q2_3source_fin_capqB
Q2_3source_fin_capqC
Q2_3source_fin_capqD
Q2_3source_fin_capqE
Q2_3source_fin_capqF
Q2_3source_fin_capqG
Q2_3source_fin_capqH
Q2_3source_fin_capqI
Q2_3source_fin_capqJ
Q2_3source_fin_capqK
Q2_3source_fin_capqL
Q2_3source_fin_capqM
Q2_3source_fin_capqN

source_fin_invqA
source_fin_invqB
source_fin_invqC
source_fin_invqD
Q2_3source_fin_invqE
source_fin_invqF
source_fin_invqG
source_fin_invqH
Q2_3source_fin_invqI
Q2_3source_fin_invqJ
source_fin_invqK
source_fin_invqL
source_fin_invqM
source_fin_invqN
Q1source_fin_invqO

ias
extrnl_adtr
Q1_2days_trans_domqA
Q1days_trans_domRqA
Q1_2days_trans_frgnqA
Q1days_trans_frgnRqA

subsdsqA
Q2_3subsdsqA1
Q2_3subsdsqA2
Q3subsdsqB
Q2_3subsdsqC
Q1subsdsR

Q1constrqA1
Q1constrqA2
Q1constrqA3
Q1constrqA4
Q1constrqA5
Q1constrqA6
Q1constrqA7
Q1constrqA8
Q1constrqA9
constrqA
Q1constrqB1
Q1constrqB2
Q1constrqB3
constrqB
Q2_3constrqC1
Q2_3constrqC2
Q2_3constrqC3
Q2_3constrqC4
Q2_3constrqC5
constrqC
constrqD
constrqE

constrqF
Q1constrqG1
Q1constrqG2
Q1constrqG3
constrqG
constrqH
Q2_3constrqI
constrqJ
Q1constrqK1
Q1constrqK2
constrqK
constrqL
constrqM
constrqN
constrqO
constrqP
Q2_3constrqQ
Q1_3constrqR
Q1constrqS

perfqA
perfqB
perfqC
Q1perfqD
Q1perfqE
Q3perfqF
perfqG
perfqH
perfqI
perfqJ
perfqJ_winsor
Q1perfqK
Q3perfqL
Q1perfqM
Q1perfqN
Q1perfqO
Q1perfqP
Q1perfqQ
Q1perfqR
Q1perfqS
Q1perfqT
Q1perfqU
Q1perfqV
perfqW
perfqW_winsor

Q2_3sales_per
sales_cat

Q2_3fixed_assts_per
fixed_assts_cat
Q2_3fixed_assts_per_def
Q2_3fixed_assts_per_PPP

Q1debts_val             
Q2debts_per
Q2debts_perR

Q2gr_prfts
Q2gr_prftsR

Q2_3prfts_invst_cat
Q3no_prfts      
Q3prfts_invst_per

initiativeqA
initiativeqB
initiativeqC
initiativeqD
initiativeqE
initiativeqF
Q2_3initiativeqG
initiativeqH
Q1_2initiativeqI
Q1_2initiativeqJ
Q2initiativeqK
Q1initiativeqL
Q1initiativeqM
initiativeqN
initiativeqO
initiativeqP
Q1initiativeqQ
initiativeqR

org

new_prdctqA     
new_prdctqB
new_prdctqC     
Q1_2new_prdctqD 
Q1_2new_prdctqE 
Q1_2new_prdctqF 

reduc_costqA
reduc_costqB
reduc_costqC
Q1_2reduc_costqD
Q1_2reduc_costqE
Q1_2reduc_costqF

Q2_3cap_utl
Q2_3cap_utlR
Q2_3perm_full_emp
Q2_3perm_full_empR
Q2_3part_tm_emp
Q2_3part_tm_empR
Q2_3ft_wrk_catqA
Q2_3ft_wrk_catqB
Q2_3ft_wrk_catqC
Q2_3ft_wrk_catqD
Q2_3ft_wrk_catqE
Q3ft_wrk_catRqA
Q3ft_wrk_catRqB
Q3ft_wrk_catRqC
Q3ft_wrk_catRqD
Q3ft_wrk_catRqE

Q2edu_lbrqA1
Q2edu_lbrqA2
Q2_3edu_lbrqA
Q2_3edu_lbrqB
Q2_3edu_lbrqC
Q2edu_lbrqD1
Q2edu_lbrqD2
Q2_3edu_lbrqD

Q3edu_lbrRqA
Q3edu_lbrRqB
Q3edu_lbrRqC
Q3edu_lbrRqD

Q2_3time_vacqA
Q2_3time_vacqB
Q2_3time_vacqC
Q2_3time_vacqD
Q2_3time_vacqE

Q2trainingqA1
Q2trainingqA2
Q2_3trainingqA
Q2_3trainingqB
Q2_3trainingqC  
Q2trainingqD

Q2per_trainedqA1
Q2per_trainedqA2
Q2_3per_trainedqA
Q2_3per_trainedqB
Q2_3per_trainedqC
Q2per_trainedqD

Q2_3days_lostqA
Q2_3days_lostqB


Q1wkfc_levelqA
Q1wkfc_levelqB
Q2_3chg_wkfc

perc_cntr_val


Q2pay_impctqBloc
Q1_2pay_impctqC
Q1_2pay_impctqD
Q1_2pay_impctqE
Q1_2pay_impctqF
Q1pay_impctqG
Q1pay_impctqH

Q2_3serv_ass1
Q2_3serv_ass2
Q2_3serv_ass3
Q2_3serv_ass4
Q2_3serv_ass5
Q2_3serv_ass6

Q2_3seek_infl

country_name 
gdppc_market 
gdppc_ppp 
gdpgrowth 
agricgdp 
net_taxgdp 
priv_sectgdp 
tradegdp 
cpi_ann 
cpi_end 
cpi_ann_ind 
cpi_end_ind 
ppi_ann 
ppi_end 
adm_prices 
unempl 
teleph_lines 
direct_taxgdp 
inc_taxgdp 
soc_contgdp 
work_force_taxgdp 
ind_taxgdp 
vat_gdp 
tariff_gdp 
dom_credgdp 
dom_cred_psgdp 
dom_credgdp1 
stocksgdp 
off_rate 
interbank 
moneymark_rate 
treas_bill 
dep_rate 
lend_rate 
averageti8 
averageti9 
enterpr 
large_priv 
small_priv 
ent_restr 
mark_trade 
price_lib 
trade_forex 
comp_policy 
fin_inst 
bank_ref 
sec_market 
overall_infr 
telec 
rails 
power 
roads 
water 

corr_index 
trade 
fisc_brdn 
govt_interv 
mnt_policy 
for_inv 
banking 
wg_prc 
prop_rghts 
regulat 
inform_mrkt 
hrtg_score 
sb_no_proc 
sb_days 
sb_cost 
sb_mincap 
lr_dif_hire 
lr_rig_hrs 
lr_diff_fire 
lr_rig_empl 
lr_fr_cost 
rp_no_proc 
rp_days 
rp_cost 
cr_cost_cll 
cr_lg_rghts 
cr_cr_inf 
cr_rgstr_cov 
cr_prbur_cov 
protect 
ec_no_proc 
ec_days 
ec_cost 
cb_years 
cb_cost 
cb_rcv_rt 
parties 
parliament 
legalsyst 
police 
business 
taxrevenue 
customs 
media 
medicalserv 
educatsyst 
registryserv 
utilities 
military 
ngos 
religious

populat
prim_sch_enr
sec_sch_enr
rer_ch_usd
rer_ch_usd2
rer_ch_usd3

rer_ch_euro
rer_ch_euro2
rer_ch_euro3

lab_force
emplmnt
unemplmnt
health_gdp
educ_gdp
density
pop_04
surface
hlth_ed_gdp
real_int_rate
gdpchng_1
gdpchng_3

cpiachng_3
cpiechng_3
Q2_3salesonemp_new_PPP

, i(id_merge) j(time 2002 2005) string;

drop year;
ren time year;
drop if country==5; /* Turkey */

destring year, replace;

save data/Panel_LONG_02_05.dta, replace;

gen panel=1;
keep id_merge panel;
sort id_merge;

save data/Panel_Dummy_02_05.dta, replace;

use data/data_merged.dta, clear;
sort id_merge;

merge id_merge using data/Panel_Dummy_02_05.dta;

tab _merge;

replace panel=0 if panel==.;

drop _merge;

save data/data_panel.dta, replace;


capture log close;

