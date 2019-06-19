/*************************************************************
This do file opens the main data and merges in supplementary information to carry out the empirical analysis

Content: the results presented are in order/with labels similar to the ones in the tables of the submitted draft
Part of the analysis addresses the referees' concerns which are discussed in the paper but not necessarily tabulated
**************************************************************/

clear all
set mem 1g
set matsize 11000
set maxvar 32767
set more off

global home "\\dasdsn02\projects$\53523_Sorting\"
global working "$home\Working"
global BSD_data "$working\BSD"
global logs "$working\Logs\Coaggl\REStat_Rev1"
global temp "$working\Coaggl"
global geodata "$working\Data\GeoData"
global output "$working\Data\Coaggl"

adopath + "R:\ADO_Files"

cap log close
log using $logs\MainAnalysis_Extended.log, replace

********************************************
********************************************
*Open some data sources, rename some variables and prepare for merging
********************************************
********************************************

*Inupt-Output sharing data for extended years (robustness check)
use "$output\IOforSDS\io_info_tomerge_ext_04.dta", clear
rename io_coeff_app io_coeff_app_04
keep sec io_coeff_app_04
save "$temp\io_info_04.dta", replace

*Knowledge spillovers/patent data - Sector of Use for extended years (robustness check)
use "$output\pat_citations_EPO_coagglomeration_prob_08.dta", clear
rename io_coeff_pat_pr io_coeff_pat_pr_08
keep sec io_coeff_pat_pr_08
save "$temp\pat_cit_prob_info_08.dta", replace

*Knowledge spillovers/patent data - Sector of Manufacture for extended years (robustness check)
use "$output\pat_citations_EPO_coagglomeration_prob_SOM_08.dta", clear
rename io_coeff_pat_pr_SOM io_coeff_pat_pr_SOM_08
keep sec io_coeff_pat_pr_SOM_08
save "$temp\pat_cit_prob_SOM_info_08.dta", replace

*Coagglomeration metric - calculated excluding London (robustness check)
use "$output\EG_all_plants_manuf_ttwa_max_1997-2008_NOL.dta", clear
rename e_gamma e_gamma_NOL
rename gamma gamma_NOL
keep sec year e_gamma_NOL gamma_NOL
save "$temp\gammas_1997-2008_NOL.dta", replace

*Coagglomeration metric - calculated using only single-plant companies (robustness check)
use "$output\EG_all_plants_manuf_ttwa_max_1997-2008_SGL.dta", clear
rename e_gamma e_gamma_SGL
rename gamma gamma_SGL
keep sec year e_gamma_SGL gamma_SGL
save "$temp\gammas_1997-2008_SGL.dta", replace

*Coagglomeration metric - calculated dropping printing and publishing (robustness check)
use "$output\EG_all_plants_manuf_ttwa_max_1997-2008_NOS.dta", clear
rename e_gamma e_gamma_NOS
rename gamma gamma_NOS
keep sec year e_gamma_NOS gamma_NOS
save "$temp\gammas_1997-2008_NOS.dta", replace

*Coagglomeration metric - calculated both urban and rural areas (robustness check)
use "$output\EG_all_plants_manuf_ttwa_max_1997-2008_UR.dta", clear
rename e_gamma e_gamma_UR
rename gamma gamma_UR
keep sec year e_gamma_UR gamma_UR
save "$temp\gammas_1997-2008_UR.dta", replace


********************************************
********************************************
*Create dataset 
********************************************
********************************************

*Open various datasets and start gathering/merging information

*Open coagglomeration data and data on three TTWA with highest concentration of pair colocation
use "$output\EG_all_plants_manuf_ttwa_max_1997-2008.dta", clear

*adding labour_pooling measures 
sort sec
merge m:1 sec using "$output\lab_pool9599.dta"
drop _merge sic slab
rename c lb_pool9599

gen sic_i= substr(sec,1,3)
gen sic_j= substr(sec,-3,3)
order  year sec sic_i sic_j

*Merge data on the share of highly educated workers from LFS (sector i and j separately)
sort sic_i
merge m:1 sic_i using "$output\high_di.dta"
drop if sic_i=="372"
drop _merge
rename s_high s_high_i

sort sic_j
merge m:1 sic_j using "$output\high_dj.dta"
drop if sic_j=="151"
drop _merge
rename s_high s_high_j

egen skill_d=concat(high_di high_dj), punct("_")
label var skill_d"1=high 0=low share of college graduates"
drop s_high high_di high_dj

*Create high/low tech sectors using OECD classification - see Web Appendix of Manuscript for more information
foreach x in i j {

#delimit;
gen tech_`x'=1 if sic_`x'=="353" | sic_`x'=="300" | sic_`x'>="321" & sic_`x'<="323" | sic_`x'=="244"; /*High tech*/

replace tech_`x'=1 if sic_`x'>="331" & sic_`x'<="335" | sic_`x'>="341" & sic_`x'<="343" | sic_`x'>="311" & sic_`x'<="316" | 
sic_`x'>="241" & sic_`x'<="243" | sic_`x'>="245" & sic_`x'<="247" | sic_`x'=="352" | sic_`x'>="354" & sic_`x'<="355" | 
sic_`x'>="291" & sic_`x'<="297"; /*Medium high tech*/

replace tech_`x'=0 if sic_`x'>="251" & sic_`x'<="252" | sic_`x'=="351" | sic_`x'>="362" & sic_`x'<="366" | 
sic_`x'>="271" & sic_`x'<="275" | sic_`x'>="261" & sic_`x'<="268" |
sic_`x'>="281" & sic_`x'<="287" | sic_`x'>="231" & sic_`x'<="233"; /*Medium low tech*/

replace tech_`x'=0 if sic_`x'>="151" & sic_`x'<="223" | sic_`x'=="361" | sic_`x'>="371" & sic_`x'<="372"; /*Low tech*/

#delimit cr
}

egen tech_d=concat(tech_i tech_j), punct("_")
label var tech_d"1=high 0=low tech industries"
drop tech_i tech_j

*Adding birth date measures to identify mature/less mature industries
order  year sec sic_i sic_j

sort sic_i year
merge m:1 sic_i year using "$output\birth_date_i.dta"
drop if sic_i=="372"
drop _merge

sort sic_j year
merge m:1 sic_j year using "$output\birth_date_j.dta"
drop if sic_j=="151"
drop _merge

label var b_mdi"birth date median sic_i" 
label var b_mdj"birth date median sic_j" 
label var b_Mi"birth date max sic_i" 
label var b_Mj"birth date max sic_j" 
label var b_mi"birth date min sic_i" 
label var b_mj"birth date min sic_j" 
sort sec

***********************************
*Merge main IO, LP and KS measures based on short-sample of initial years

*Inupt-Output sharing data 
sort sec
merge m:1 sec using "$output\IOforSDS\io_info_tomerge_ext.dta"
drop _merge

*Knowledge spillovers/patent data - Sector of Use
sort sec
merge m:1 sec using "$output\pat_citations_EPO_coagglomeration_prob.dta"
drop _merge

*Knowledge spillovers/patent data - Sector of Manufacture
sort sec
merge m:1 sec using "$output\pat_citations_EPO_coagglomeration_prob_SOM.dta"
drop _merge

***********************************
*Merge additional IO, LP and KS measures based on more years (see above)

sort sec
merge m:1 sec using "$temp\io_info_04.dta"
drop _merge

sort sec
merge m:1 sec using "$temp\pat_cit_prob_info_08.dta"
drop _merge

sort sec
merge m:1 sec using "$temp\pat_cit_prob_SOM_info_08.dta"
drop _merge

***********************************
*Merge additional EGK measures based on samples that exclude London or excludes single plants firms 
*or drop some sectors (media/publishing/recycling) or consider both urban and rural areas - see above

sort sec year
merge 1:1 sec year using "$temp\gammas_1997-2008_NOL.dta"
drop _merge

sort sec year
merge 1:1 sec year using "$temp\gammas_1997-2008_SGL.dta"
drop _merge

sort sec year
merge 1:1 sec year using "$temp\gammas_1997-2008_NOS.dta"
drop _merge

sort sec year
merge 1:1 sec year using "$temp\gammas_1997-2008_UR.dta"
drop _merge


***********************************
*Merge additional information about entry and exit - do this first by sector i and then sector j
*NOTE NOTE: this has some sectoral and !!!!SOME YEAR VARIATION!!!!
*We will collapse at a later stage

destring sic_i, gen(sic3d)
sort sic3d year
merge m:1 sic3d year using "$output\big_small\BSD_entry_exit_emp.dta"
drop if _merge==2
drop _merge
local z "entry_sh exit_sh net_sh entry_emp exit_emp cont_emp avg_emp"
foreach i of local z {
rename `i' `i'_i
}
drop sic3d

destring sic_j, gen(sic3d)
sort sic3d year
merge m:1 sic3d year using "$output\big_small\BSD_entry_exit_emp.dta"
drop if _merge==2
drop _merge
local z "entry_sh exit_sh net_sh entry_emp exit_emp cont_emp avg_emp"
foreach j of local z {
rename `j' `j'_j
}
drop sic3d

***********************************
*Merge additional information on population density of TTWAs by sectors
*THIS IS CALCULATED FOR THE INITIAL YEARS AND DOES NOT VARY OVER TIME

destring sic_i, gen(sic3d)
sort sic3d year
merge m:1 sic3d using "$output\pop_density_sectors.dta"
drop if _merge==2
drop _merge
local z "population pop_1664 p_density p1664_density emp_density plant_density emp_density_ns plant_density_ns population_w_e pop_1664_w_e p_density_w_e p1664_density_w_e population_w_p pop_1664_w_p p_density_w_p p1664_density_w_p"
foreach i of local z {
rename `i' `i'_i
}
drop sic3d

destring sic_j, gen(sic3d)
sort sic3d year
merge m:1 sic3d  using "$output\pop_density_sectors.dta"
drop if _merge==2
drop _merge
local z "population pop_1664 p_density p1664_density emp_density plant_density emp_density_ns plant_density_ns population_w_e pop_1664_w_e p_density_w_e p1664_density_w_e population_w_p pop_1664_w_p p_density_w_p p1664_density_w_p"
foreach j of local z {
rename `j' `j'_j
}
drop sic3d

**************************************
*Merge Herfindahl and Ellison-Glaeser agglomeration indices for urban and rural
*Note that these vary by sectors and by years

**Sector i**
destring sic_i, gen(sic3d)
sort sic3d year
merge m:1 sic3d year using "$output\hh_1997-2008_UR.dta"
drop if _merge==2
drop _merge
local z "hh e_agglo"
foreach i of local z {
rename `i' `i'_UR_i
}
drop sic3d

**Sector j**
destring sic_j, gen(sic3d)
sort sic3d year
merge m:1 sic3d year using "$output\hh_1997-2008_UR.dta"
drop if _merge==2
drop _merge
local z "hh e_agglo"
foreach i of local z {
rename `i' `i'_UR_j
}
drop sic3d

***********************************
*Merge data on percentage of product sold for final consumption
sort sic_i
merge m:1 sic_i using "$output\cons_share_i.dta"
keep if _merge==3
drop _merge

sort sic_j
merge m:1 sic_j using "$output\cons_share_j.dta"
keep if _merge==3

gen cons_dis=0.5*abs(cons_share_i-cons_share_j)
gen cons_dis_apport=0.5*abs(cons_share_apport_i-cons_share_apport_j)
egen cons_av=rowmean(cons_share_i cons_share_j)
egen cons_av_apport=rowmean(cons_share_apport_i cons_share_apport_j)

********************************************
********************************************
*Clean the data and create additional variables
********************************************
********************************************

*Recode missings as zeros (given how the data is constructed this is necessary)
*These are patent citation flows (in/out and max of the two, using either sector of use or of manufacturing and for either the extended sample or for the normal one)
local z "io_coeff_pat_pr out_coeff_pat_pr in_coeff_pat_pr io_coeff_pat_pr_SOM out_coeff_pat_pr_SOM in_coeff_pat_pr_SOM io_coeff_pat_pr_08 io_coeff_pat_pr_SOM_08"
foreach i of local z {
replace `i'=0 if `i'==.
}

*Entry and size of entrants and existing plants
sort sic_i year
local z "entry_sh_i entry_emp_i cont_emp_i"
foreach i of local z {
by sic_i: egen av_`i'=mean(`i')
sum av_`i'
}

sort sic_j year
local z "entry_sh_j entry_emp_j cont_emp_j"
foreach j of local z {
by sic_j: egen av_`j'=mean(`j')
sum av_`j'
}

*Age of plants (on average across years)
capture drop av_b_m_i
sort sic_i year
by sic_i: egen av_b_m_i=mean(b_mi)
capture drop av_b_m_j
sort sic_j year
by sic_j: egen av_b_m_j=mean(b_mj)

*Averages across sector pairs
egen av_s_high=rowmean(s_high_i s_high_j)
egen av_b_mi=rowmean(b_mi b_mj)
egen av_entry_sh=rowmean(av_entry_sh_i av_entry_sh_j)
egen av_entry_emp=rowmean(av_entry_emp_i av_entry_emp_j)
egen av_cont_emp=rowmean(av_cont_emp_i av_cont_emp_j)

ge tech_i=0
replace tech_i=1 if tech_d=="1_1"
replace tech_i=1 if tech_d=="1_0"
gen tech_j=0
replace tech_j=1 if tech_d=="1_1"
replace tech_j=1 if tech_d=="0_1"
egen av_tech=rowmean(tech_i tech_j)


*******************
*Standardize main variables for regression analysis
*******************

gsort sec year
egen gamma_std =std(gamma) /*coagglomeration on plant numbers*/
egen e_gamma_std =std(e_gamma)	/*coagglomeration based on employment*/
egen lb_pool_std = std(lb_pool9599) /*labour pooling - basic years */
egen io_coeff_app_std = std(io_coeff_app) /*Max IO sharing - basic years  */
egen in_coeff_app_std = std(in_coeff_app) /* Input sharing - basic years */
egen out_coeff_app_std = std(out_coeff_app) /* Output sharing - basic years */
egen io_coeff_pat_pr_std = std(io_coeff_pat_pr) /*Max Patent citations - Industry of Use - basic years */
egen in_coeff_pat_pr_std = std(in_coeff_pat_pr) /*Inwards Patent citations - Industry of Use - basic years */
egen out_coeff_pat_pr_std = std(out_coeff_pat_pr) /*Outwards Patent citations - Industry of Use - basic years */
egen io_coeff_pat_pr_SOM_std = std(io_coeff_pat_pr_SOM) /*Max Patent citations - Sector of Manuf - basic years */
egen in_coeff_pat_pr_SOM_std = std(in_coeff_pat_pr_SOM) /*Inwards Patent citations - Sector of Manuf - basic years */
egen out_coeff_pat_pr_SOM_std = std(out_coeff_pat_pr_SOM) /*Outwards Patent citations - Sector of Manuf - basic years */

********************************************
********************************************
*Start producing results
********************************************
********************************************

*********************************************
* 		TABLE 1, PANELS A and B				*
*********************************************

sum e_gamma lb_pool9599 io_coeff_app out_coeff_app in_coeff_app io_coeff_pat_pr_SOM io_coeff_pat_pr
sum enrg_dis wat_dis trns_dis natur_dis serv_dis /*dissimilarity measures */

*Extra info on correlation of coagglomeration metrics
corr e_gamma e_gamma_NOL e_gamma_SGL e_gamma_NOS e_gamma_UR 

*********************************************
* 		TABLE W1, ALL BREAKDOWN				*
*********************************************

*New/old breakdown
sum e_gamma lb_pool9599 io_coeff_app io_coeff_pat_pr_SOM av_b_mi mean_av_e_agglo if av_b_m_i>1967 & av_b_m_j>1967
sum e_gamma lb_pool9599 io_coeff_app io_coeff_pat_pr_SOM av_b_mi mean_av_e_agglo if (av_b_m_i<=1967 & av_b_m_j>1967) | (av_b_m_i>1967 & av_b_m_j<=1967)
sum e_gamma lb_pool9599 io_coeff_app io_coeff_pat_pr_SOM av_b_mi mean_av_e_agglo if av_b_m_i<=1967 & av_b_m_j<=1967

*Dynamic/steady breakdown
sum e_gamma lb_pool9599 io_coeff_app io_coeff_pat_pr_SOM av_entry_sh mean_av_e_agglo if av_entry_sh_i>0.100 & av_entry_sh_j>0.100
sum e_gamma lb_pool9599 io_coeff_app io_coeff_pat_pr_SOM av_entry_sh mean_av_e_agglo if (av_entry_sh_i<=0.100 & av_entry_sh_j>0.100) | (av_entry_sh_i>0.100& av_entry_sh_j<=0.100)
sum e_gamma lb_pool9599 io_coeff_app io_coeff_pat_pr_SOM av_entry_sh mean_av_e_agglo if av_entry_sh_i<=0.100 & av_entry_sh_j<=0.100

*Tech breakdown
sum e_gamma lb_pool9599 io_coeff_app io_coeff_pat_pr_SOM av_tech mean_av_e_agglo if tech_d=="1_1"
sum e_gamma lb_pool9599 io_coeff_app io_coeff_pat_pr_SOM av_tech mean_av_e_agglo if tech_d=="1_0" | tech_d=="0_1"
sum e_gamma lb_pool9599 io_coeff_app io_coeff_pat_pr_SOM av_tech mean_av_e_agglo if tech_d=="0_0"

*Skill breakdown
sum e_gamma lb_pool9599 io_coeff_app io_coeff_pat_pr_SOM av_s_high mean_av_e_agglo if s_high_i>0.0783 & s_high_j>0.0783
sum e_gamma lb_pool9599 io_coeff_app io_coeff_pat_pr_SOM av_s_high mean_av_e_agglo if (s_high_i<=0.0783 & s_high_j>0.0783) | (s_high_i>0.0783& s_high_j<=0.0783)
sum e_gamma lb_pool9599 io_coeff_app io_coeff_pat_pr_SOM av_s_high mean_av_e_agglo if s_high_i<=0.0783 & s_high_j<=0.0783
	
*Small/big entrants breakdown
sum e_gamma lb_pool9599 io_coeff_app io_coeff_pat_pr_SOM av_entry_emp mean_av_e_agglo if av_entry_emp_i<=8.59 & av_entry_emp_j<=8.59
sum e_gamma lb_pool9599 io_coeff_app io_coeff_pat_pr_SOM av_entry_emp mean_av_e_agglo if (av_entry_emp_i<=8.59 & av_entry_emp_j>8.59) | (av_entry_emp_i>8.59 & av_entry_emp_j<=8.59)
sum e_gamma lb_pool9599 io_coeff_app io_coeff_pat_pr_SOM av_entry_emp mean_av_e_agglo if av_entry_emp_i>8.59 & av_entry_emp_j>8.59

*Small/big breakdown
sum e_gamma lb_pool9599 io_coeff_app io_coeff_pat_pr_SOM av_cont_emp mean_av_e_agglo if av_cont_emp_i<=18.95 & av_cont_emp_j<=18.95
sum e_gamma lb_pool9599 io_coeff_app io_coeff_pat_pr_SOM av_cont_emp mean_av_e_agglo if (av_cont_emp_i<=18.95 & av_cont_emp_j>18.95) | (av_cont_emp_i>18.95 & av_cont_emp_j<=18.95)
sum e_gamma lb_pool9599 io_coeff_app io_coeff_pat_pr_SOM av_cont_emp mean_av_e_agglo if av_cont_emp_i>18.95 & av_cont_emp_j>18.95

*********************************************
* 		TABLE 2, POOLED REGRESSIONS			*
*********************************************

******************************
* Univariate, no controls
reg e_gamma_std lb_pool_std , cluster(sec)
reg e_gamma_std io_coeff_app_std, cluster(sec)
reg e_gamma_std io_coeff_pat_pr_SOM_std , cluster(sec)

******************************
* Univariate, with controls
reg e_gamma_std lb_pool_std enrg_dis wat_dis trns_dis natur_dis serv_dis, cluster(sec)
reg e_gamma_std io_coeff_app_std enrg_dis wat_dis trns_dis natur_dis serv_dis, cluster(sec)
reg e_gamma_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis, cluster(sec)

******************************
* Multivariate, no controls
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std , cluster(sec)

******************************
* Multivariate, with controls
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis, cluster(sec)
testparm lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std
testparm lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std, eq
testparm lb_pool_std io_coeff_app_std , eq
testparm lb_pool_std io_coeff_pat_pr_SOM_std, eq
testparm io_coeff_app_std io_coeff_pat_pr_SOM_std, eq

*********************************************
* 		TABLE W2, ROBUSTNESS 			*
*********************************************

reg e_gamma_std lb_pool_std in_coeff_app_std out_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis if year==1997, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis if year==2002, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis if year==2008, cluster(sec)

*Extra checks not shown
*Controlling for sector i and sector j dummies
xi: reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis i.sic_i i.sic_j, cluster(sec)
*Using coagglomeration on plant numbers as opposed to employment
reg gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis, cluster(sec)

*Regs on collapsed (or constant) data
sort sec year
local z "e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis"
foreach j of local z {
by sec: egen const_`j'=mean(`j')
sum const_`j'
}
reg const_e_gamma_std const_lb_pool_std const_io_coeff_app_std const_io_coeff_pat_pr_SOM_std const_enrg_dis const_wat_dis const_trns_dis const_natur_dis const_serv_dis if year==2002, cluster(sec)
reg const_e_gamma_std const_lb_pool_std const_io_coeff_app_std const_io_coeff_pat_pr_SOM_std const_enrg_dis const_wat_dis const_trns_dis const_natur_dis const_serv_dis if year==1997, cluster(sec)

*********************************************
* 		TABLE W2, ROBUSTNESS 2			*
*********************************************

*Using Industry of Use for Knowledge Spillovers 
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_std enrg_dis wat_dis trns_dis natur_dis serv_dis, cluster(sec)
reg e_gamma_std lb_pool_std in_coeff_app_std out_coeff_app_std io_coeff_pat_pr_std enrg_dis wat_dis trns_dis natur_dis serv_dis, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_std enrg_dis wat_dis trns_dis natur_dis serv_dis if year==1997, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_std enrg_dis wat_dis trns_dis natur_dis serv_dis if year==2002, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_std enrg_dis wat_dis trns_dis natur_dis serv_dis if year==2008, cluster(sec)

*********************************************
* 		APP. TABLE 2
*********************************************

*Stagger data
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis if year>=2000, cluster(sec)
*No London
egen e_gamma_NOL_std=std(e_gamma_NOL) 
reg e_gamma_NOL_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis, cluster(sec)

local z "p_density emp_density_ns hh"
foreach k of local z {
gen `k'_mean=0.5*(`k'_i+`k'_j)
gen `k'_diss=0.5*abs(`k'_i-`k'_j)
}

local z "p_density emp_density_ns hh"
foreach k of local z {
	display "Proxy for agglomeratin is `k'"
	reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std `k'_mean ///
	enrg_dis wat_dis trns_dis natur_dis serv_dis, cluster(sec)
	}

*These results control instead for dissimilarity or both mean and diss.
local z "p_density emp_density_ns hh_KU"
foreach k of local z {
	display "Proxy for agglomeratin is `k'"
	reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std `k'_diss ///
	enrg_dis wat_dis trns_dis natur_dis serv_dis, cluster(sec)
	reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std `k'_diss `k'_mean ///
	enrg_dis wat_dis trns_dis natur_dis serv_dis, cluster(sec)
	}
	
*Additional checks not shown

*Single plants
egen e_gamma_SGL_std=std(e_gamma_SGL)
*No print and publish
egen e_gamma_NOS_std=std(e_gamma_NOS) 
*Include urban and rural 
egen e_gamma_UR_std=std(e_gamma_UR) 

*Same with controls
reg e_gamma_SGL_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis, cluster(sec)
reg e_gamma_NOS_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis, cluster(sec)
reg e_gamma_UR_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis, cluster(sec)

*Further checks (now shown) that controls for urbanization and exclude London
local z "p_density emp_density_ns hh"
foreach k of local z {
	display "Proxy for agglomeratin is `k'"
	reg e_gamma_NOL_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std `k'_mean ///
	enrg_dis wat_dis trns_dis natur_dis serv_dis, cluster(sec)
	}

*Correlation patterns - negative correlations driven by London
pwcorr e_gamma population_mean p_density_mean , star(0.01)
pwcorr e_gamma_NOL population_mean p_density_mean , star(0.01)

*********************************************
* 		FIGURES 1, PARTS A, B  and C		*
*********************************************

bootstrap, cluster(sec) reps(100): sqreg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis, quantile(.1 .2 .3 .4 .5 .6 .7 .8 .9) 

*********************************************
* 		TABLE 4, ALL COLUMNS				*
*********************************************

*Age
capture drop av_b_mi_std 
egen av_b_mi_std=std(av_b_mi)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_b_mi_std , cluster(sec)
*Specification checks with dummies - not shown
capture drop dum d1 d2 d3
gen dum=0
replace dum=1 if av_b_m_i>1967 & av_b_m_j>1967
replace dum=2 if (av_b_m_i<=1967 & av_b_m_j>1967 ) | (av_b_m_i>1967 & av_b_m_j<=1967)
tab dum, gen(d)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis d2 d3, cluster(sec)

*Entry share
capture drop av_entry_sh_std
egen av_entry_sh_std=std(av_entry_sh)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_sh_std , cluster(sec)
*Specification checks with dummies - not shown
capture drop dum d1 d2 d3
gen dum=0
replace dum=1 if av_entry_sh_i>0.100 & av_entry_sh_j>0.100 
replace dum=2 if (av_entry_sh_i<=0.100 & av_entry_sh_j>0.100) | (av_entry_sh_i>0.100& av_entry_sh_j<=0.100)
tab dum, gen(d)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis d2 d3, cluster(sec)

*Education
capture drop av_s_high_std
egen av_s_high_std=std(av_s_high)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_s_high_std, cluster(sec)
*Specification checks with dummies - not shown
capture drop dum d1 d2 d3
gen dum=0
replace dum=1 if s_high_i>0.0783 & s_high_j>0.0783
replace dum=2 if (s_high_i<=0.0783 & s_high_j>0.0783) | (s_high_i>0.0783 & s_high_j<=0.0783)
tab dum, gen(d)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis d2 d3, cluster(sec)

*Emplyment of entrants	
capture drop av_entry_emp_std
egen av_entry_emp_std=std(av_entry_emp)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_emp_std , cluster(sec)
*Specification checks with dummies - not shown
capture drop dum d1 d2 d3
gen dum=0
replace dum=1 if av_entry_emp_i<=8.59 & av_entry_emp_j<=8.59
replace dum=2 if (av_entry_emp_i<=8.59 & av_entry_emp_j>8.59) | (av_entry_emp_i>8.59 & av_entry_emp_j<=8.59)
tab dum, gen(d)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis d2 d3, cluster(sec)

*Employment of incumbents
capture drop av_cont_emp_std
egen av_cont_emp_std=std(av_cont_emp)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_cont_emp_std , cluster(sec)
*Specification checks with dummies - not shown
capture drop dum d1 d2 d3
gen dum=0
replace dum=1 if av_cont_emp_i<=18.95 & av_cont_emp_j<=18.95
replace dum=2 if (av_cont_emp_i<=18.95 & av_cont_emp_j>18.95) | (av_cont_emp_i>18.95 & av_cont_emp_j<=18.95)
tab dum, gen(d)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis d2 d3, cluster(sec)

*Technology
capture drop t_dum t_d1 t_d2 t_d3
gen t_dum=0
replace t_dum=2 if tech_d=="1_1"
replace t_dum=1 if tech_d=="1_0" | tech_d=="0_1"
tab t_dum, gen(t_d)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis t_d2 t_d3, cluster(sec)

*All controls joinlt
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis ///
					av_b_mi_std av_entry_sh_std t_d2 t_d3 av_s_high_std av_entry_emp_std av_cont_emp_std ///
					, cluster(sec)

*********************************************
* 		TABLE 5, PANEL A AND PANEL B		*
*********************************************

*PANEL A
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_b_mi_std if av_b_m_i>1967 & av_b_m_j>1967, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_b_mi_std if (av_b_m_i<=1967 & av_b_m_j>1967) | (av_b_m_i>1967 & av_b_m_j<=1967), cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_b_mi_std if av_b_m_i<=1967 & av_b_m_j<=1967, cluster(sec)

*PANEL B
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_sh_std if av_entry_sh_i>0.100 & av_entry_sh_j>0.100 , cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_sh_std if (av_entry_sh_i<=0.100 & av_entry_sh_j>0.100) | (av_entry_sh_i>0.100& av_entry_sh_j<=0.100), cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_sh_std if av_entry_sh_i<=0.100 & av_entry_sh_j<=0.100, cluster(sec)

*********************************************
* 		TABLE 6, PANEL A AND PANEL B		*
*********************************************

*PANEL A
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis if tech_d=="1_1", cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis if tech_d=="0_1"| tech_d=="1_0", cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis if tech_d=="0_0", cluster(sec)

*PANEL B
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_s_high_std if s_high_i>0.0783 & s_high_j>0.0783, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_s_high_std if (s_high_i<=0.0783 & s_high_j>0.0783) | (s_high_i>0.0783 & s_high_j<=0.0783), cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_s_high_std if s_high_i<=0.0783 & s_high_j<=0.0783, cluster(sec)

*********************************************
* 		TABLE 7, PANEL A AND PANEL B		*
*********************************************

*PANEL A
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_emp_std if av_entry_emp_i<=8.59 & av_entry_emp_j<=8.59, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_emp_std if (av_entry_emp_i<=8.59 & av_entry_emp_j>8.59) | (av_entry_emp_i>8.59 & av_entry_emp_j<=8.59), cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_emp_std if av_entry_emp_i>8.59 & av_entry_emp_j>8.59, cluster(sec)

*PANEL B
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_cont_emp_std if av_cont_emp_i<=18.95 & av_cont_emp_j<=18.95, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_cont_emp_std if (av_cont_emp_i<=18.95 & av_cont_emp_j>18.95) | (av_cont_emp_i>18.95 & av_cont_emp_j<=18.95), cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_cont_emp_std if av_cont_emp_i>18.95 & av_cont_emp_j>18.95, cluster(sec)

***********************
*Start merging and preparing the data for some IV analysis
*These datasets were kindly provided by Bill Kerr. We cleaned the data for our purpose and made further correction to guarantee UK-USA industrial sectors lined up 

merge m:1 sec using "$output\IV_preparation\IO\EGK_IO_data_IV.dta"
drop if _merge==2
replace max_tot=0 if max_tot==.
sum io_coeff_app max_tot
corr io_coeff_app max_tot
egen max_tot_std=std(max_tot)

capture drop _merge
merge m:1 sec using "$output\IV_preparation\Patent\EGK_PAT_data_IV.dta"
drop if _merge==2
corr io_coeff_pat_pr_SOM_std max_use_1 max_mf_1 max_pat_1 max_use_2 max_mf_2 max_pat_2
replace max_pat_1=0 if max_pat_1==.
replace max_mf_1=0 if  max_mf_1==.
egen max_mf_1_std=std(max_mf_1)

capture drop _merge
merge m:1 sec using "$output\IV_preparation\Labour\EGK_LAB_data_IV.dta"
drop if _merge==2
sum lb_pool9599 lbrcor2
corr lb_pool9599 lbrcor2
replace lbrcor2=0 if lbrcor2==.
egen lbrcor2_std=std(lbrcor2)

save "$output\regression_analysis_data_restat_rev1.dta" , replace

*********************************
count 
gen sic_i2=substr(sic_i,1,2)
gen sic_j2=substr(sic_j,1,2)

*Drop three digit within same two digit and sectors that were reaggregated
keep if sic_i2!=sic_j2 ///
	& sic_i!="182" & sic_i!="232" & sic_i!="246" & sic_i!="158" & sic_i!="266" & sic_i!="222" ///
	& sic_j!="182" & sic_j!="232" & sic_j!="246" & sic_j!="158" & sic_j!="266" & sic_j!="222" 

******************************************
*We restandardize variables within this sample (this makes little difference)
sum e_gamma lb_pool9599 io_coeff_pat_pr_SOM io_coeff_app
local z "e_gamma lb_pool9599 io_coeff_pat_pr_SOM io_coeff_app"
foreach i of local z {
egen `i'_std_sub=std(`i')
}

*************************************
* 	TABLE 3 -- OLS UNI/MULTI-VAR	*
*************************************

*OLS regressions on new (restricted) dataset
reg e_gamma_std_sub lb_pool9599_std_sub enrg_dis wat_dis trns_dis natur_dis serv_dis , cluster(sec)
reg e_gamma_std_sub io_coeff_app_std_sub enrg_dis wat_dis trns_dis natur_dis serv_dis , cluster(sec)
reg e_gamma_std_sub io_coeff_pat_pr_SOM_std_sub enrg_dis wat_dis trns_dis natur_dis serv_dis , cluster(sec)
reg e_gamma_std_sub io_coeff_pat_pr_SOM_std_sub lb_pool9599_std_sub io_coeff_app_std_sub enrg_dis wat_dis trns_dis natur_dis serv_dis , cluster(sec)

*************************************
* 	TABLE 4 -- IV UNI/MULTI-VAR	*
*************************************

*Note that the regressions below are carried out on the unstandardized variables and both using IVREG but also separately running the first and the second stage (as a check)
*The regressions reported in the paper *ARE STANDRADIZED* (as all other results in the paper)

**********************
*Uni-variate IVs
capture drop *_pred

*Labour pooling
reg lb_pool9599 lbrcor2 enrg_dis wat_dis trns_dis natur_dis serv_dis , cluster(sec)
predict lp_pred
reg e_gamma lp_pred enrg_dis wat_dis trns_dis natur_dis serv_dis, cluster(sec)
ivreg2 e_gamma (lb_pool9599 = lbrcor2) enrg_dis wat_dis trns_dis natur_dis serv_dis, first ffirst cluster(sec)
sum lp_pred e_gamma

*Input output
reg io_coeff_app max_tot enrg_dis wat_dis trns_dis natur_dis serv_dis, cluster(sec)
predict io_pred
reg e_gamma io_pred enrg_dis wat_dis trns_dis natur_dis serv_dis, cluster(sec)
ivreg2 e_gamma (io_coeff_app = max_tot) enrg_dis wat_dis trns_dis natur_dis serv_dis, first ffirst cluster(sec)
sum io_pred e_gamma

*Knowledge spillover
reg io_coeff_pat_pr_SOM max_mf_1 enrg_dis wat_dis trns_dis natur_dis serv_dis, cluster(sec)
predict ks_pred
reg e_gamma ks_pred enrg_dis wat_dis trns_dis natur_dis serv_dis, cluster(sec)
ivreg2 e_gamma (io_coeff_pat_pr_SOM = max_mf_1) enrg_dis wat_dis trns_dis natur_dis serv_dis, first ffirst cluster(sec)
sum ks_pred e_gamma

capture drop *_pred

**********
*Multivariate - all Marshallian forces
reg lb_pool9599 max_mf_1 max_tot lbrcor2 enrg_dis wat_dis trns_dis natur_dis serv_dis , cluster(sec)
predict lp_pred
reg io_coeff_pat_pr_SOM max_mf_1 max_tot lbrcor2 enrg_dis wat_dis trns_dis natur_dis serv_dis , cluster(sec)
predict pat_pred
reg io_coeff_app max_mf_1 max_tot lbrcor2 enrg_dis wat_dis trns_dis natur_dis serv_dis , cluster(sec)
predict io_pred
reg e_gamma lp_pred pat_pred io_pred enrg_dis wat_dis trns_dis natur_dis serv_dis , cluster(sec)
ivreg2 e_gamma (lb_pool9599 io_coeff_pat_pr_SOM io_coeff_app = max_mf_1 max_tot lbrcor2) enrg_dis wat_dis trns_dis natur_dis serv_dis , first ffirst cluster(sec)
sum  lp_pred pat_pred io_pred e_gamma 
capture drop *_pred

**********
*Multivariate - IO and LP only 
reg lb_pool9599 max_tot lbrcor2 enrg_dis wat_dis trns_dis natur_dis serv_dis , cluster(sec)
predict lp_pred
reg io_coeff_app max_tot lbrcor2 enrg_dis wat_dis trns_dis natur_dis serv_dis , cluster(sec)
predict io_pred
reg e_gamma lp_pred io_pred enrg_dis wat_dis trns_dis natur_dis serv_dis , cluster(sec)
ivreg2 e_gamma (lb_pool9599 io_coeff_app = max_tot lbrcor2) enrg_dis wat_dis trns_dis natur_dis serv_dis , first ffirst cluster(sec)
sum  lp_pred io_pred e_gamma 
capture drop *_pred

**********
*Multivariate - IO and KS only 
reg io_coeff_pat_pr_SOM max_tot max_mf_1 enrg_dis wat_dis trns_dis natur_dis serv_dis , cluster(sec)
predict ks_pred
reg io_coeff_app max_tot max_mf_1 enrg_dis wat_dis trns_dis natur_dis serv_dis , cluster(sec)
predict io_pred
reg e_gamma ks_pred io_pred enrg_dis wat_dis trns_dis natur_dis serv_dis , cluster(sec)
ivreg2 e_gamma (io_coeff_pat_pr_SOM io_coeff_app = max_tot max_mf_1) enrg_dis wat_dis trns_dis natur_dis serv_dis , first ffirst cluster(sec)
sum  ks_pred io_pred e_gamma 
capture drop *_pred

**********
*Multivariate - LP and KS only 
reg io_coeff_pat_pr_SOM lbrcor2 max_mf_1 enrg_dis wat_dis trns_dis natur_dis serv_dis , cluster(sec)
predict ks_pred
reg lb_pool9599 lbrcor2 max_mf_1 enrg_dis wat_dis trns_dis natur_dis serv_dis , cluster(sec)
predict lp_pred
reg e_gamma ks_pred lp_pred enrg_dis wat_dis trns_dis natur_dis serv_dis , cluster(sec)
ivreg2 e_gamma (io_coeff_pat_pr_SOM lb_pool9599 = lbrcor2 max_mf_1) enrg_dis wat_dis trns_dis natur_dis serv_dis , first ffirst cluster(sec)
sum  ks_pred lp_pred e_gamma 
capture drop *_pred


*****************************************
*	CLEAR AND REOPEN PARTS OF THE DATA TO INVESTIGATE FURTHER ROBUSTNESS OF OUR RESULTS
*	MOST OF THESE RESULTS ARE ONLY DISCUSSED AND NOT TABULATES
*	THEY FOLLOW SOME OF THE COMMENTS PROPOSED BY THE REFEREES	
*****************************************

clear

*This data uses sinlge plants to calculatte cutoffs of entry, employment of entrants and employment of incubments to generate partitioning of regressions
use "$output\big_small\BSD_entry_exit_emp_single_plants.dta", clear
keep sic3d year entry_sh entry_emp cont_emp
rename entry_sh entry_sh_sngl 
rename entry_emp entry_emp_sngl  
rename cont_emp cont_emp_sngl 
save "$temp\entry_size_single", replace

*Focuses on coagglomeration calculated only using smaller TTWAs (see manuscript for more details)
use "$output\EG_all_plants_manuf_ttwa_max_1997-2008_smaller_cities.dta", clear
sum e_gamma
rename e_gamma e_gamma_small
keep e_gamma_small sec year
sort sec year
save "$temp\e_gamma_small", replace

*Focuses on coagglomeration calculated only using bigger TTWAs (see manuscript for more details)
use "$output\EG_all_plants_manuf_ttwa_max_1997-2008_big_cities.dta", clear
sum e_gamma
rename e_gamma e_gamma_big
keep e_gamma_big sec year
sort sec year
save "$temp\e_gamma_big", replace

*Focuses on coagglomeration calculated using REGIONS instead of TTWAs (see manuscript for more details)
use "$output\EG_all_plants_manuf_max_1997-2008_region.dta", clear
sum e_gamma
rename e_gamma e_gamma_region
keep e_gamma_region sec year
sort sec year
save "$temp\e_gamma_region", replace

*Opens data saved above (prior to IV and dropping of some sectors) and merges additional information
use "$output\regression_analysis_data_restat_rev1.dta" , clear
sort sec year
capture drop _merge
merge 1:1 sec year using "$temp\e_gamma_big"
drop _merge

sort sec year
merge 1:1 sec year using "$temp\e_gamma_small"
drop _merge

sort sec year
capture drop _merge
merge 1:1 sec year using "$temp\e_gamma_region"
drop _merge


erase "$temp\e_gamma_small.dta"
erase "$temp\e_gamma_big.dta"
erase "$temp\e_gamma_region.dta"

***************************
* ROBUSTNESS OF TABLES 5-7
***************************

*Construct dissimilarity of cut-off variables
gen diss_s_high=0.5*abs(s_high_i-s_high_j)
gen diss_b_mi=0.5*abs(b_mi-b_mj)
gen diss_entry_sh=0.5*abs(av_entry_sh_i-av_entry_sh_j)
gen diss_entry_emp=0.5*abs(av_entry_emp_i-av_entry_emp_j)
gen diss_cont_emp=0.5*abs(av_cont_emp_i-av_cont_emp_j)

local z "diss_s_high diss_b_mi diss_entry_sh diss_entry_emp diss_cont_emp"
foreach i of local z {
egen `i'_std=std(`i')
}

egen e_gamma_big_std=std(e_gamma_big)
egen e_gamma_small_std=std(e_gamma_small)
egen e_gamma_region_std=std(e_gamma_region)
corr e_gamma  e_gamma_big e_gamma_small e_gamma_region

******************************
*Merge info constructed using single plants

capture drop sic3d
destring sic_i, gen(sic3d)
sort sic3d year
capture drop _merge
merge m:1 sic3d year using "$temp\entry_size_single"
drop if _merge==2
drop _merge
local z "entry_sh_sngl entry_emp_sngl cont_emp_sngl"
foreach i of local z {
rename `i' `i'_i
}
drop sic3d

destring sic_j, gen(sic3d)
sort sic3d year
capture drop _merge
merge m:1 sic3d year using "$temp\entry_size_single"
drop if _merge==2
drop _merge
local z "entry_sh_sngl entry_emp_sngl cont_emp_sngl"
foreach j of local z {
rename `j' `j'_j
}
drop sic3d

sort sic_i year
local z "entry_sh_sngl_i entry_emp_sngl_i cont_emp_sngl_i"
foreach i of local z {
by sic_i: egen av_`i'=mean(`i')
sum av_`i'
}

sort sic_j year
local z "entry_sh_sngl_j entry_emp_sngl_j cont_emp_sngl_j"
foreach j of local z {
by sic_j: egen av_`j'=mean(`j')
sum av_`j'
}

egen av_entry_sh_sngl=rowmean(av_entry_sh_sngl_i av_entry_sh_sngl_j)
egen av_entry_emp_sngl=rowmean(av_entry_emp_sngl_i av_entry_emp_sngl_j)
egen av_cont_emp_sngl=rowmean(av_cont_emp_sngl_i av_cont_emp_sngl_j)

egen av_entry_sh_sngl_std=std(av_entry_sh_sngl)
egen av_entry_emp_sngl_std=std(av_entry_emp_sngl)
egen av_cont_emp_sngl_std=std(av_cont_emp_sngl)

************************************************
************************************************
* ADDING DISSIMILARITY TO AVERAGE AS A CONTROL 
************************************************
************************************************
   
*********************************************
* 		TABLE 5, PANEL A AND PANEL B		*
*********************************************

*PANEL A
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_b_mi_std diss_b_mi_std if av_b_m_i>1967 & av_b_m_j>1967, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_b_mi_std diss_b_mi_std if (av_b_m_i<=1967 & av_b_m_j>1967) | (av_b_m_i>1967 & av_b_m_j<=1967), cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_b_mi_std diss_b_mi_std if av_b_m_i<=1967& av_b_m_j<=1967, cluster(sec)

*PANEL B
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_sh_std diss_entry_sh_std if av_entry_sh_i>0.100 & av_entry_sh_j>0.100 , cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_sh_std diss_entry_sh_std if (av_entry_sh_i<=0.100 & av_entry_sh_j>0.100) | (av_entry_sh_i>0.100& av_entry_sh_j<=0.100), cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_sh_std diss_entry_sh_std if av_entry_sh_i<=0.100 & av_entry_sh_j<=0.100, cluster(sec)

*********************************************
* 		TABLE 6, PANEL A AND PANEL B		*
*********************************************

*PANEL B
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_s_high_std diss_s_high_std if s_high_i>0.0783 & s_high_j>0.0783, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_s_high_std diss_s_high_std if (s_high_i<=0.0783 & s_high_j>0.0783) | (s_high_i>0.0783 & s_high_j<=0.0783), cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_s_high_std diss_s_high_std if s_high_i<=0.0783 & s_high_j<=0.0783, cluster(sec)

*********************************************
* 		TABLE 7, PANEL A AND PANEL B		*
*********************************************

*PANEL A
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_emp_std diss_entry_emp_std if av_entry_emp_i<=8.59 & av_entry_emp_j<=8.59, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_emp_std diss_entry_emp_std if (av_entry_emp_i<=8.59 & av_entry_emp_j>8.59) | (av_entry_emp_i>8.59 & av_entry_emp_j<=8.59), cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_emp_std diss_entry_emp_std if av_entry_emp_i>8.59 & av_entry_emp_j>8.59, cluster(sec)

*PANEL B
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_cont_emp_std diss_cont_emp_std if av_cont_emp_i<=18.95 & av_cont_emp_j<=18.95, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_cont_emp_std diss_cont_emp_std if (av_cont_emp_i<=18.95 & av_cont_emp_j>18.95) | (av_cont_emp_i>18.95 & av_cont_emp_j<=18.95), cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_cont_emp_std diss_cont_emp_std if av_cont_emp_i>18.95 & av_cont_emp_j>18.95, cluster(sec)


************************************************
************************************************
* NEXT ONLY INCLUDING DISSIMILARITY (DROP AVE.)
************************************************
************************************************
   
*********************************************
* 		TABLE 5, PANEL A AND PANEL B		*
*********************************************

*PANEL A
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis diss_b_mi_std if av_b_m_i>1967.375 & av_b_m_j>1967.375, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis diss_b_mi_std if (av_b_m_i<=1967.375 & av_b_m_j>1967.375) | (av_b_m_i>1967.375 & av_b_m_j<=1967.375), cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis diss_b_mi_std if av_b_m_i<=1967.375& av_b_m_j<=1967.375, cluster(sec)

*PANEL B
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis diss_entry_sh_std if av_entry_sh_i>0.100 & av_entry_sh_j>0.100 , cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis diss_entry_sh_std if (av_entry_sh_i<=0.100 & av_entry_sh_j>0.100) | (av_entry_sh_i>0.100& av_entry_sh_j<=0.100), cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis diss_entry_sh_std if av_entry_sh_i<=0.100 & av_entry_sh_j<=0.100, cluster(sec)

*********************************************
* 		TABLE 6, PANEL A AND PANEL B		*
*********************************************

*PANEL B
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis diss_s_high_std if s_high_i>0.0783 & s_high_j>0.0783, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis diss_s_high_std if (s_high_i<=0.0783 & s_high_j>0.0783) | (s_high_i>0.0783 & s_high_j<=0.0783), cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis diss_s_high_std if s_high_i<=0.0783 & s_high_j<=0.0783, cluster(sec)

*********************************************
* 		TABLE 7, PANEL A AND PANEL B		*
*********************************************

*PANEL A
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis diss_entry_emp_std if av_entry_emp_i<=8.59 & av_entry_emp_j<=8.59, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis diss_entry_emp_std if (av_entry_emp_i<=8.59 & av_entry_emp_j>8.59) | (av_entry_emp_i>8.59 & av_entry_emp_j<=8.59), cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis diss_entry_emp_std if av_entry_emp_i>8.59 & av_entry_emp_j>8.59, cluster(sec)

*PANEL B
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis diss_cont_emp_std if av_cont_emp_i<=18.95 & av_cont_emp_j<=18.95, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis diss_cont_emp_std if (av_cont_emp_i<=18.95 & av_cont_emp_j>18.95) | (av_cont_emp_i>18.95 & av_cont_emp_j<=18.95), cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis diss_cont_emp_std if av_cont_emp_i>18.95 & av_cont_emp_j>18.95, cluster(sec)

*********************************************
*	COMMENT ABOUT SPATIAL SCALE				*
*	COAGGLOMERATION OF BIG/SMALL TTWAS 		*
*	AND AT THE REGIONAL LEVEL				*
*********************************************

********************
*MAIN REGRESSIONS
reg e_gamma_big_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis , cluster(sec)
reg e_gamma_small_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis , cluster(sec)
reg e_gamma_region_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis , cluster(sec)

********************
*ALL TABLES WITH HETEROGENEITY

*********************************************
* 		TABLE 5, PANEL A AND PANEL B		*
*********************************************

*PANEL A
reg e_gamma_big_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_b_mi_std if av_b_m_i>1967 & av_b_m_j>1967, cluster(sec)
reg e_gamma_small_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_b_mi_std if av_b_m_i>1967 & av_b_m_j>1967, cluster(sec)
reg e_gamma_region_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_b_mi_std if av_b_m_i>1967 & av_b_m_j>1967, cluster(sec)

reg e_gamma_big_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_b_mi_std if (av_b_m_i<=1967 & av_b_m_j>1967) | (av_b_m_i>1967 & av_b_m_j<=1967), cluster(sec)
reg e_gamma_small_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_b_mi_std if (av_b_m_i<=1967 & av_b_m_j>1967) | (av_b_m_i>1967 & av_b_m_j<=1967), cluster(sec)
reg e_gamma_region_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_b_mi_std if (av_b_m_i<=1967 & av_b_m_j>1967) | (av_b_m_i>1967 & av_b_m_j<=1967), cluster(sec)

reg e_gamma_big_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_b_mi_std if av_b_m_i<=1967& av_b_m_j<=1967, cluster(sec)
reg e_gamma_small_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_b_mi_std if av_b_m_i<=1967& av_b_m_j<=1967, cluster(sec)
reg e_gamma_region_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_b_mi_std if av_b_m_i<=1967& av_b_m_j<=1967, cluster(sec)

*PANEL B
reg e_gamma_big_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_sh_std if av_entry_sh_i>0.100 & av_entry_sh_j>0.100 , cluster(sec)
reg e_gamma_small_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_sh_std if av_entry_sh_i>0.100 & av_entry_sh_j>0.100 , cluster(sec)
reg e_gamma_region_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_sh_std if av_entry_sh_i>0.100 & av_entry_sh_j>0.100 , cluster(sec)

reg e_gamma_big_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_sh_std if (av_entry_sh_i<=0.100 & av_entry_sh_j>0.100) | (av_entry_sh_i>0.100& av_entry_sh_j<=0.100), cluster(sec)
reg e_gamma_small_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_sh_std if (av_entry_sh_i<=0.100 & av_entry_sh_j>0.100) | (av_entry_sh_i>0.100& av_entry_sh_j<=0.100), cluster(sec)
reg e_gamma_region_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_sh_std if (av_entry_sh_i<=0.100 & av_entry_sh_j>0.100) | (av_entry_sh_i>0.100& av_entry_sh_j<=0.100), cluster(sec)

reg e_gamma_big_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_sh_std if av_entry_sh_i<=0.100 & av_entry_sh_j<=0.100, cluster(sec)
reg e_gamma_small_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_sh_std if av_entry_sh_i<=0.100 & av_entry_sh_j<=0.100, cluster(sec)
reg e_gamma_region_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_sh_std if av_entry_sh_i<=0.100 & av_entry_sh_j<=0.100, cluster(sec)

*********************************************
* 		TABLE 6, PANEL A AND PANEL B		*
*********************************************

*PANEL A
reg e_gamma_big_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis if tech_d=="1_1", cluster(sec)
reg e_gamma_small_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis if tech_d=="1_1", cluster(sec)
reg e_gamma_region_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis if tech_d=="1_1", cluster(sec)

reg e_gamma_big_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis if tech_d=="0_1"| tech_d=="1_0", cluster(sec)
reg e_gamma_small_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis if tech_d=="0_1"| tech_d=="1_0", cluster(sec)
reg e_gamma_region_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis if tech_d=="0_1"| tech_d=="1_0", cluster(sec)

reg e_gamma_big_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis if tech_d=="0_0", cluster(sec)
reg e_gamma_small_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis if tech_d=="0_0", cluster(sec)
reg e_gamma_region_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis if tech_d=="0_0", cluster(sec)

*PANEL B
reg e_gamma_big_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_s_high_std if s_high_i>0.0783 & s_high_j>0.0783, cluster(sec)
reg e_gamma_small_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_s_high_std if s_high_i>0.0783 & s_high_j>0.0783, cluster(sec)
reg e_gamma_region_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_s_high_std if s_high_i>0.0783 & s_high_j>0.0783, cluster(sec)

reg e_gamma_big_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_s_high_std if (s_high_i<=0.0783 & s_high_j>0.0783) | (s_high_i>0.0783 & s_high_j<=0.0783), cluster(sec)
reg e_gamma_small_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_s_high_std if (s_high_i<=0.0783 & s_high_j>0.0783) | (s_high_i>0.0783 & s_high_j<=0.0783), cluster(sec)
reg e_gamma_region_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_s_high_std if (s_high_i<=0.0783 & s_high_j>0.0783) | (s_high_i>0.0783 & s_high_j<=0.0783), cluster(sec)

reg e_gamma_big_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_s_high_std if s_high_i<=0.0783 & s_high_j<=0.0783, cluster(sec)
reg e_gamma_small_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_s_high_std if s_high_i<=0.0783 & s_high_j<=0.0783, cluster(sec)
reg e_gamma_region_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_s_high_std if s_high_i<=0.0783 & s_high_j<=0.0783, cluster(sec)

*********************************************
* 		TABLE 7, PANEL A AND PANEL B		*
*********************************************

*PANEL A
reg e_gamma_big_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_emp_std if av_entry_emp_i<=8.59 & av_entry_emp_j<=8.59, cluster(sec)
reg e_gamma_small_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_emp_std if av_entry_emp_i<=8.59 & av_entry_emp_j<=8.59, cluster(sec)
reg e_gamma_region_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_emp_std if av_entry_emp_i<=8.59 & av_entry_emp_j<=8.59, cluster(sec)

reg e_gamma_big_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_emp_std if (av_entry_emp_i<=8.59 & av_entry_emp_j>8.59) | (av_entry_emp_i>8.59 & av_entry_emp_j<=8.59), cluster(sec)
reg e_gamma_small_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_emp_std if (av_entry_emp_i<=8.59 & av_entry_emp_j>8.59) | (av_entry_emp_i>8.59 & av_entry_emp_j<=8.59), cluster(sec)
reg e_gamma_region_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_emp_std if (av_entry_emp_i<=8.59 & av_entry_emp_j>8.59) | (av_entry_emp_i>8.59 & av_entry_emp_j<=8.59), cluster(sec)

reg e_gamma_big_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_emp_std if av_entry_emp_i>8.59 & av_entry_emp_j>8.59, cluster(sec)
reg e_gamma_small_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_emp_std if av_entry_emp_i>8.59 & av_entry_emp_j>8.59, cluster(sec)
reg e_gamma_region_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_emp_std if av_entry_emp_i>8.59 & av_entry_emp_j>8.59, cluster(sec)

*PANEL B
reg e_gamma_big_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_cont_emp_std if av_cont_emp_i<=18.95 & av_cont_emp_j<=18.95, cluster(sec)
reg e_gamma_small_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_cont_emp_std if av_cont_emp_i<=18.95 & av_cont_emp_j<=18.95, cluster(sec)
reg e_gamma_region_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_cont_emp_std if av_cont_emp_i<=18.95 & av_cont_emp_j<=18.95, cluster(sec)

reg e_gamma_big_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_cont_emp_std if (av_cont_emp_i<=18.95 & av_cont_emp_j>18.95) | (av_cont_emp_i>18.95 & av_cont_emp_j<=18.95), cluster(sec)
reg e_gamma_small_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_cont_emp_std if (av_cont_emp_i<=18.95 & av_cont_emp_j>18.95) | (av_cont_emp_i>18.95 & av_cont_emp_j<=18.95), cluster(sec)
reg e_gamma_region_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_cont_emp_std if (av_cont_emp_i<=18.95 & av_cont_emp_j>18.95) | (av_cont_emp_i>18.95 & av_cont_emp_j<=18.95), cluster(sec)

reg e_gamma_big_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_cont_emp_std if av_cont_emp_i>18.95 & av_cont_emp_j>18.95, cluster(sec)
reg e_gamma_small_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_cont_emp_std if av_cont_emp_i>18.95 & av_cont_emp_j>18.95, cluster(sec)
reg e_gamma_region_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_cont_emp_std if av_cont_emp_i>18.95 & av_cont_emp_j>18.95, cluster(sec)

*********************************************
*	FIGURES 1A TO 1C USING QUREGS 			*
*	BIG, SMALL TTWAS AND REGIONS			*
*********************************************

bootstrap, cluster(sec) reps(100): sqreg e_gamma_big_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis, quantile(.1 .2 .3 .4 .5 .6 .7 .8 .9) 
bootstrap, cluster(sec) reps(100): sqreg e_gamma_small_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis, quantile(.1 .2 .3 .4 .5 .6 .7 .8 .9) 
bootstrap, cluster(sec) reps(100): sqreg e_gamma_region_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis, quantile(.1 .2 .3 .4 .5 .6 .7 .8 .9) 

*********************************************
*	COMMENT ABOUT SPIN-OFFS/SIZE			*
*	USE SIZE & ENTRY ONLY FOR SINGLE-PLANTS	*
*********************************************

*************************
*************************
* THIS VERSION: BOTH CUT-OFFS AND DEPENDENT VARIABLE USE SINGLE PLANTS
*************************
*************************

*************************
* TABLE 5, PANEL B		*
*************************

reg e_gamma_SGL_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_sh_std if av_entry_sh_sngl_i>.12147 & av_entry_sh_sngl_j>.12147, cluster(sec)
reg e_gamma_SGL_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_sh_std if (av_entry_sh_sngl_i<=.12147 & av_entry_sh_sngl_j>.12147) | (av_entry_sh_sngl_i>.12147& av_entry_sh_sngl_j<=.12147), cluster(sec)
reg e_gamma_SGL_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_sh_std if av_entry_sh_sngl_i<=.12147 & av_entry_sh_sngl_j<=.12147, cluster(sec)

*********************************************
* 		TABLE 7, PANEL A AND PANEL B		*
*********************************************

*PANEL A
reg e_gamma_SGL_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_emp_std if av_entry_emp_sngl_i<=7.922652 & av_entry_emp_sngl_j<=7.922652, cluster(sec)
reg e_gamma_SGL_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_emp_std if (av_entry_emp_sngl_i<=7.922652 & av_entry_emp_sngl_j>7.922652) | (av_entry_emp_sngl_i>7.922652 & av_entry_emp_sngl_j<=7.922652), cluster(sec)
reg e_gamma_SGL_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_emp_std if av_entry_emp_sngl_i>7.922652 & av_entry_emp_sngl_j>7.922652, cluster(sec)

*PANEL B
reg e_gamma_SGL_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_cont_emp_std if av_cont_emp_sngl_i<=11.18996 & av_cont_emp_sngl_j<=11.18996, cluster(sec)
reg e_gamma_SGL_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_cont_emp_std if (av_cont_emp_sngl_i<=11.18996 & av_cont_emp_sngl_j>11.18996 ) | (av_cont_emp_sngl_i>11.18996 & av_cont_emp_sngl_j<=11.18996 ), cluster(sec)
reg e_gamma_SGL_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_cont_emp_std if av_cont_emp_sngl_i>11.18996 & av_cont_emp_sngl_j>11.18996 , cluster(sec)


*************************
*************************
* THIS VERSION: ONLY CUT-OFFS USE SINGLE PLANTS, NOT DEPENDENT VARIABLE 
*************************
*************************

*************************
* TABLE 5, PANEL B		*
*************************

reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_sh_std if av_entry_sh_sngl_i>.12147 & av_entry_sh_sngl_j>.12147, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_sh_std if (av_entry_sh_sngl_i<=.12147 & av_entry_sh_sngl_j>.12147) | (av_entry_sh_sngl_i>.12147& av_entry_sh_sngl_j<=.12147), cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_sh_std if av_entry_sh_sngl_i<=.12147 & av_entry_sh_sngl_j<=.12147, cluster(sec)

*********************************************
* 		TABLE 7, PANEL A AND PANEL B		*
*********************************************

*PANEL A
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_emp_std if av_entry_emp_sngl_i<=7.922652 & av_entry_emp_sngl_j<=7.922652, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_emp_std if (av_entry_emp_sngl_i<=7.922652 & av_entry_emp_sngl_j>7.922652) | (av_entry_emp_sngl_i>7.922652 & av_entry_emp_sngl_j<=7.922652), cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_emp_std if av_entry_emp_sngl_i>7.922652 & av_entry_emp_sngl_j>7.922652, cluster(sec)

*PANEL B
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_cont_emp_std if av_cont_emp_sngl_i<=11.18996 & av_cont_emp_sngl_j<=11.18996, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_cont_emp_std if (av_cont_emp_sngl_i<=11.18996 & av_cont_emp_sngl_j>11.18996 ) | (av_cont_emp_sngl_i>11.18996 & av_cont_emp_sngl_j<=11.18996 ), cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_cont_emp_std if av_cont_emp_sngl_i>11.18996 & av_cont_emp_sngl_j>11.18996 , cluster(sec)

	
******************************
* CHECK MAIN RESULTS ON COLLAPSED DATA
******************************

tab tech_d, gen(t_dum)
collapse (mean) e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std ///
				enrg_dis wat_dis trns_dis natur_dis serv_dis ///
				av_b_mi_std av_entry_sh_std av_s_high_std av_entry_emp_std av_cont_emp_std t_dum1 t_dum2 t_dum3 t_dum4 ///
				av_b_m_i av_b_m_j av_entry_sh_i av_entry_sh_j s_high_i s_high_j ///
				av_entry_emp_i av_entry_emp_j av_cont_emp_i av_cont_emp_j ///
				p_density_mean emp_density_ns_mean hh_KU_mean e_gamma_NOL_std, ///	
		by(sec)

*******************
* TABLE 2 (SELECT.)	
*******************

reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std , cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis, cluster(sec)

*******************
* APPENDIX TABLE 2 (SELECT.)	
*******************

reg e_gamma_NOL_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis p_density_mean, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis emp_density_ns_mean, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis hh_KU_mean, cluster(sec)

*********************************************
* 		TABLE 5, PANEL A AND PANEL B		*
*********************************************

*PANEL A
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_b_mi_std if av_b_m_i>1967 & av_b_m_j>1967, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_b_mi_std if (av_b_m_i<=1967 & av_b_m_j>1967 ) | (av_b_m_i>1967 & av_b_m_j<=1967), cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_b_mi_std if av_b_m_i<=1967& av_b_m_j<=1967, cluster(sec)

*PANEL B
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_sh_std if av_entry_sh_i>0.100 & av_entry_sh_j>0.100 , cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_sh_std if (av_entry_sh_i<=0.100 & av_entry_sh_j>0.100) | (av_entry_sh_i>0.100& av_entry_sh_j<=0.100), cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_sh_std if av_entry_sh_i<=0.100 & av_entry_sh_j<=0.100, cluster(sec)

*********************************************
* 		TABLE 6, PANEL A AND PANEL B		*
*********************************************

*PANEL A
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis if t_dum4==1, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis if t_dum2==1| t_dum3==1, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis if t_dum1==1, cluster(sec)

*PANEL B
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_s_high_std if s_high_i>0.0783 & s_high_j>0.0783, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_s_high_std if (s_high_i<=0.0783 & s_high_j>0.0783) | (s_high_i>0.0783 & s_high_j<=0.0783), cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_s_high_std if s_high_i<=0.0783 & s_high_j<=0.0783, cluster(sec)

*********************************************
* 		TABLE 8, PANEL A AND PANEL B		*
*********************************************

*PANEL A
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_emp_std if av_entry_emp_i<=8.59 & av_entry_emp_j<=8.59, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_emp_std if (av_entry_emp_i<=8.59 & av_entry_emp_j>8.59) | (av_entry_emp_i>8.59 & av_entry_emp_j<=8.59), cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_entry_emp_std if av_entry_emp_i>8.59 & av_entry_emp_j>8.59, cluster(sec)

*PANEL B
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_cont_emp_std if av_cont_emp_i<=18.95 & av_cont_emp_j<=18.95, cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_cont_emp_std if (av_cont_emp_i<=18.95 & av_cont_emp_j>18.95) | (av_cont_emp_i>18.95 & av_cont_emp_j<=18.95), cluster(sec)
reg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis av_cont_emp_std if av_cont_emp_i>18.95 & av_cont_emp_j>18.95, cluster(sec)


*********************************************
*	FIGURES 1A TO 1C USING QUREGS			*
*********************************************

bootstrap, cluster(sec) reps(100): sqreg e_gamma_std lb_pool_std io_coeff_app_std io_coeff_pat_pr_SOM_std enrg_dis wat_dis trns_dis natur_dis serv_dis, quantile(.1 .2 .3 .4 .5 .6 .7 .8 .9) 

******************
log close
