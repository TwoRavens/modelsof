***************  20/03/2013 APPENDIX 1

clear
cd "\\intra\partages\au_amic2\Obstacles_CDLP\Résultats_révision\ESTIM_CONSER\TABLEAUX_STATA"
log using "\\intra\partages\au_amic2\Obstacles_CDLP\Résultats_révision\ESTIM_CONSER\TABLEAUX_STATA\Journal_appendix1.log",replace
set mem 800m
set more off
set matsize 600

use \\intra\partages\au_amic2\Obstacles_CDLP\Résultats_révision\ESTIM_CONSER\BASES_SAS\base_reg_delta_x_compl

***********************
tsset siren annee
***********************

***********************************************************************
* CREATION DE LA VARIABLE AGE2 
gen age2=age^2
***********************************************************************

save \\intra\partages\au_amic2\Obstacles_CDLP\Résultats_révision\ESTIM_CONSER\BASES_SAS\base_reg_delta_x_ret, replace

use \\intra\partages\au_amic2\Obstacles_CDLP\Résultats_révision\ESTIM_CONSER\BASES_SAS\base_reg_delta_x_ret

***********************
tsset siren annee
***********************

xi i.taille, prefix(I)
xi i.annee*i.secteur_4 , prefix(J) 

*********** DEFINITION DE L'ECHANTILLON
drop echantillon
set more off
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new  delta_x_new_corr dk_corr dl dk_adj_corr dl_adj delta_tu delta_dt delta_due = dk_moy dl_moy ldp42 v40 v29 L2.lci age2 L2.tu L2.dt D.A_constr L.v20 L.delta_due) if secteur_4~="Autres", robust first
gen echantillon=e(sample)


*************** APPENDIX

* Pour la partie de présentation des données *


* statistiques descriptives *

keep if echantillon==1

proportion taille 

tabstat va, stats (p10 p25 p50 p75 p90 mean sem) 
tabstat x, stats (p10 p25 p50 p75 p90 mean sem) 
tabstat dva, stats (p10 p25 p50 p75 p90 mean sem) 
tabstat delta_x_new, stats (p10 p25 p50 p75 p90 mean sem)
tabstat delta_due, stats (p10 p25 p50 p75 p90 mean sem) 
tabstat delta_tu, stats (p10 p25 p50 p75 p90 mean sem) 
tabstat delta_dt, stats (p10 p25 p50 p75 p90 mean sem) 
tabstat tu, stats (p10 p25 p50 p75 p90 mean sem) 
gen duree_travail=v9a/100
tabstat duree_travail, stats (p10 p25 p50 p75 p90 mean sem) 
tabstat yp, stats (p10 p25 p50 p75 p90 mean sem) 
tabstat v7, stats (p10 p25 p50 p75 p90 mean sem) 







