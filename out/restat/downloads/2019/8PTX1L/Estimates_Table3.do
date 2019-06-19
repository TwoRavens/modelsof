clear all
set more off
cd "C:\Users\rozovill\Dropbox\Research\Violence in Colombia - JMP\Replication Materials\Tables\"  /*specify preferred folder*/
use panel, clear
*OLS*
areg lw lhom_r i.year, absorb(nordest) vce(cluster muncod)
areg lw lhom_r i.year pop_tot, absorb(nordest) vce(cluster muncod)
areg lw lhom_r i.year pop_tot exp sgp_educ sgp_health sgp_other, absorb(nordest) vce(cluster muncod)
*2SLS*
reghdfe lw i.year pop_tot exp sgp_educ sgp_health sgp_other (lhom_r = d1), absorb(nordest) cluster (muncod) ffirst stages(first)
reghdfe lw i.year pop_tot exp sgp_educ sgp_health sgp_other nlight95_y s_ind_y s_ss_y s_agri_y (lhom_r = d1), absorb(nordest) cluster (muncod) ffirst
reghdfe lw i.year pop_tot exp sgp_educ sgp_health sgp_other nlight95_y s_ind_y s_ss_y s_agri_y pebancaria_y petotalins_y ba_tot_vr ba_tot_nu y_corr_tribut_IyC hom94_y (lhom_r = d1), absorb(nordest) cluster (muncod) ffirst stages(first)
reghdfe lw i.year pop_tot exp sgp_educ sgp_health sgp_other nlight95_y s_ind_y s_ss_y s_agri_y pebancaria_y petotalins_y ba_tot_vr ba_tot_nu y_corr_tribut_IyC hom94_y va aa (lhom_r = d1), absorb(nordest) cluster (muncod) ffirst stages(first)

