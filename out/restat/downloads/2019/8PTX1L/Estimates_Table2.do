clear all
set more off
cd "C:\Users\rozovill\Dropbox\Research\Violence in Colombia - JMP\Replication Materials\Tables\"  /*specify preferred folder*/
use op, clear
/*Columns 1 through 5*/
set matsize 10000
*OLS*
areg lvuv lhom_r i.year i.prod_cod pop_tot, absorb(nordest) vce(cluster muncod)
areg lvuv lhom_r i.year i.prod_cod pop_tot exp sgp_educ sgp_health sgp_other, absorb(nordest) vce(cluster muncod)
*2SLS*
reghdfe lvuv i.year i.prod_cod pop_tot exp sgp_educ sgp_health sgp_other (lhom_r = d1), absorb(nordest) cluster (muncod) ffirst stages(first)
reghdfe lvuv i.year i.prod_cod pop_tot exp sgp_educ sgp_health sgp_other nlight95_y s_ind_y s_ss_y s_agri_y pebancaria_y petotalins_y ba_tot_vr ba_tot_nu y_corr_tribut_IyC hom94_y (lhom_r = d1), absorb(nordest) cluster (muncod) ffirst stages(first)
reghdfe lvuv i.year i.prod_cod pop_tot exp sgp_educ sgp_health sgp_other nlight95_y s_ind_y s_ss_y s_agri_y pebancaria_y petotalins_y ba_tot_vr ba_tot_nu y_corr_tribut_IyC hom94_y va aa (lhom_r = d1), absorb(nordest) cluster (muncod) ffirst stages(first)
/*Columns 6 through 10*/
use ip, clear
set matsize 10000
*OLS*
areg lvuc lhom_r i.year i.prod_cod pop_tot, absorb(nordest) vce(cluster muncod)
areg lvuc lhom_r i.year i.prod_cod pop_tot exp sgp_educ sgp_health sgp_other, absorb(nordest) vce(cluster muncod)
*2SLS*
reghdfe lvuc i.year i.prod_cod pop_tot exp sgp_educ sgp_health sgp_other (lhom_r = d1), absorb(nordest) cluster (muncod) ffirst stages(first)
reghdfe lvuc i.year i.prod_cod pop_tot exp sgp_educ sgp_health sgp_other nlight95_y s_ind_y s_ss_y s_agri_y pebancaria_y petotalins_y ba_tot_vr ba_tot_nu y_corr_tribut_IyC hom94_y (lhom_r = d1), absorb(nordest) cluster (muncod) ffirst stages(first)
reghdfe lvuc i.year i.prod_cod pop_tot exp sgp_educ sgp_health sgp_other nlight95_y s_ind_y s_ss_y s_agri_y pebancaria_y petotalins_y ba_tot_vr ba_tot_nu y_corr_tribut_IyC hom94_y va aa (lhom_r = d1), absorb(nordest) cluster (muncod) ffirst stages(first)

