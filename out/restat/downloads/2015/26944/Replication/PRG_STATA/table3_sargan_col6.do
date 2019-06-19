***************  28/02/2013 tableau 3 : SORTIE SARGAN de la colonne 6 - "Without B0" 

clear
cd "\\intra\partages\au_amic2\Obstacles_CDLP\Résultats_révision\ESTIM_CONSER\TABLEAUX_STATA"
log using "\\intra\partages\au_amic2\Obstacles_CDLP\Résultats_révision\ESTIM_CONSER\TABLEAUX_STATA\Journal_reg_table3sargan.log",replace
set mem 600m
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
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_x_new_corr dk_corr dl dk_adj_corr dl_adj delta_tu delta_dt delta_due = dk_moy dl_moy ldp42 v40 v29 L2.lci age2 L2.tu L2.dt D.A_constr L.v20 L.delta_due) if secteur_4~="Autres", robust first
gen echantillon=e(sample)

************** ROBUSTESSE

* en enlevant les secteurs 1 a 1
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if d27~="B0 Industries agricoles et alimentaires" & echantillon==1  
test delta_x_new=1
eststo

esttab using tableau3_sargan.rtf, se keep(delta_x_new delta_due delta_dt delta_tu) stat(N j jp) star(* 0.10 ** 0.05 *** 0.01) mtitle("Estim. ini" "Without B0" "Without C2") title("TABLE 3 SARGAN (18/03/2013)" {\b Robustness: Estimate 2}) nonum modelwidth(4) replace
 
* Wu-Hausmann

xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if d27~="B0 Industries agricoles et alimentaires" & echantillon==1
estat endogenous
