clear all
set more off
cd "C:\Users\rozovill\Dropbox\Research\Violence in Colombia - JMP\Replication Materials\Tables\"  /*specify preferred folder*/
use panel, clear
/*Columns 1 through 5*/
*OLS*
areg lrvv lhom_r i.year pop_tot, absorb(nordest) vce(cluster muncod)
areg lrvv lhom_r i.year pop_tot exp sgp_educ sgp_health sgp_other, absorb(nordest) vce(cluster muncod)
*2SLS*
reghdfe lrvv i.year pop_tot exp sgp_educ sgp_health sgp_other (lhom_r = d1), absorb(nordest) cluster (muncod) ffirst stages(first)
reghdfe lrvv i.year pop_tot exp sgp_educ sgp_health sgp_other nlight95_y s_ind_y s_ss_y s_agri_y pebancaria_y petotalins_y ba_tot_vr ba_tot_nu y_corr_tribut_IyC hom94_y (lhom_r = d1), absorb(nordest) cluster (muncod) ffirst stages(first)
reghdfe lrvv i.year pop_tot exp sgp_educ sgp_health sgp_other nlight95_y s_ind_y s_ss_y s_agri_y pebancaria_y petotalins_y ba_tot_vr ba_tot_nu y_corr_tribut_IyC hom94_y va aa (lhom_r = d1), absorb(nordest) cluster (muncod) ffirst stages(first)

/*Columns 6 through 10*/
g n=1
collapse (sum) n, by(muncod year)
g ln=log(n)
merge 1:1 muncod year using controls
drop if _merge==2
drop _merge
*OLS*
xtset muncod
areg ln lhom_r i.year pop_tot, absorb(muncod) vce(cluster muncod)
areg ln lhom_r i.year pop_tot exp sgp_educ sgp_health sgp_other, absorb(muncod) vce(cluster muncod)
*2SLS*
reghdfe ln i.year pop_tot exp sgp_educ sgp_health sgp_other (lhom_r = d1), absorb(muncod) cluster (muncod) ffirst stages(first)
reghdfe ln i.year pop_tot exp sgp_educ sgp_health sgp_other nlight95_y s_ind_y s_ss_y s_agri_y pebancaria_y petotalins_y ba_tot_vr ba_tot_nu y_corr_tribut_IyC hom94_y (lhom_r = d1), absorb(muncod) cluster (muncod) ffirst stages(first)
reghdfe ln i.year pop_tot exp sgp_educ sgp_health sgp_other nlight95_y s_ind_y s_ss_y s_agri_y pebancaria_y petotalins_y ba_tot_vr ba_tot_nu y_corr_tribut_IyC hom94_y va aa (lhom_r = d1), absorb(muncod) cluster (muncod) ffirst stages(first)
