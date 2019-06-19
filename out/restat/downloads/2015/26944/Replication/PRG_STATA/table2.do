***************  18/03/2013 tableau 2 
* ON AJOUTE L.V20 SI DELTA_DUE présent
* ON AJOUTE L2.tu SI DELTA_tu  présent
* ON AJOUTE L2.dt SI DELTA_dt  présent

clear
cd "\\intra\partages\au_amic2\Obstacles_CDLP\Résultats_révision\ESTIM_CONSER\TABLEAUX_STATA"
log using "\\intra\partages\au_amic2\Obstacles_CDLP\Résultats_révision\ESTIM_CONSER\TABLEAUX_STATA\Journal_reg_table2.log",replace
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

**************** TABLEAU 2: Measuring factors return with factor utilisation degrees
eststo clear
*col1
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new =dk_moy dl_moy ldp42 ) if echantillon==1, robust first
test delta_x_new=1
eststo
* SANS L.v20 L2.dt 
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu =dk_moy dl_moy ldp42 L2.lci age2 L2.tu D.A_constr) if echantillon==1, robust first 
test delta_x_new=1
eststo
* SANS L.v20 L2.tu 
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_dt =dk_moy dl_moy ldp42 L2.lci age2 L2.dt D.A_constr) if echantillon==1, robust first 
test delta_x_new=1
eststo
* SANS L2.tu L2.dt 
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_due=dk_moy dl_moy ldp42 L2.lci age2 D.A_constr L.v20) if echantillon==1, robust first 
test delta_x_new=1
eststo
* SANS  L.v20
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt =dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr) if echantillon==1, robust first 
test delta_x_new=1
eststo
* SANS L2.dt 
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu D.A_constr L.v20) if echantillon==1, robust first 
test delta_x_new=1
eststo
* SANS L2.tu 
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.dt D.A_constr L.v20) if echantillon==1, robust first 
test delta_x_new=1
eststo
* COL 3 TABLE 1
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if echantillon==1, robust first 
test delta_x_new=1
eststo

esttab using Tableau2.rtf,se keep(delta_x_new delta_tu delta_dt delta_due) stat(N j jp exexog) star(* 0.10 ** 0.05 *** 0.01) title("Table2 (18/03/2013) - Measuring factors return to scale with factor utilisation degrees") modelwidth(4) replace


* Wu-Hausman
*col1
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new =dk_moy dl_moy ldp42 ) if echantillon==1, robust
estat endogenous

* SANS L.v20 L2.dt 
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu =dk_moy dl_moy ldp42 L2.lci age2 L2.tu D.A_constr) if echantillon==1, robust 
estat endogenous

* SANS L.v20 L2.tu  
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_dt =dk_moy dl_moy ldp42 L2.lci age2 L2.dt D.A_constr) if echantillon==1, robust 
estat endogenous

* SANS L2.tu L2.dt 
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_due=dk_moy dl_moy ldp42 L2.lci age2 D.A_constr L.v20) if echantillon==1, robust 
estat endogenous

* SANS  L.v20
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt =dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr) if echantillon==1, robust 
estat endogenous

* SANS L2.dt 
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu D.A_constr L.v20) if echantillon==1, robust 
estat endogenous

* SANS L2.tu 
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.dt D.A_constr L.v20) if echantillon==1, robust 
estat endogenous

* COL 3 TABLE 1
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if echantillon==1, robust 
estat endogenous













