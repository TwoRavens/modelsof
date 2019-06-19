***************  28/02/2013 tableau 4 

clear
cd "\\intra\partages\au_amic2\Obstacles_CDLP\Résultats_révision\ESTIM_CONSER\TABLEAUX_STATA"
log using "\\intra\partages\au_amic2\Obstacles_CDLP\Résultats_révision\ESTIM_CONSER\TABLEAUX_STATA\Journal_reg_table4.log",replace
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
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_x_new_corr dk_corr dl dk_adj_corr dl_adj delta_tu delta_dt delta_due = dk_moy dl_moy ldp42 v40 v29 L2.lci age2 L2.tu L2.dt D.A_constr L.v20 L.delta_due) if secteur_4~="Autres", robust first
gen echantillon=e(sample)


****** TABLEAU 4 en enlevant les VI une à une 
eststo clear
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if echantillon==1, robust 
eststo
test delta_x_new=1
* SANS dk_moy 
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if echantillon==1, robust 
eststo
test delta_x_new=1
* SANS dl_moy 
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if echantillon==1, robust 
eststo
test delta_x_new=1
* SANS ldp42 
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if echantillon==1, robust 
eststo
test delta_x_new=1
* SANS L2.lci 
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 age2 L2.tu L2.dt D.A_constr L.v20) if echantillon==1, robust 
eststo
test delta_x_new=1
* SANS age2 
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci L2.tu L2.dt D.A_constr L.v20) if echantillon==1, robust 
eststo
test delta_x_new=1
* SANS L2.tu 
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.dt D.A_constr L.v20) if echantillon==1, robust 
eststo
test delta_x_new=1
* SANS L2.dt 
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu D.A_constr L.v20) if echantillon==1, robust 
eststo
test delta_x_new=1
* SANS D.A_constr 
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt L.v20) if echantillon==1, robust 
eststo
test delta_x_new=1
* SANS L.v20
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr) if echantillon==1, robust 
eststo
test delta_x_new=1

esttab using tableau4.rtf, se keep(delta_x_new delta_due delta_dt delta_tu) stat(N j jp exexog) star(* 0.10 ** 0.05 *** 0.01) mtitle("Combi. complète" "Sans dk_moy" "Sans dl_moy" "Sans ldp42" "Sans L2.lci" "Sans age2" "Sans L2.tu" "Sans L2.dt" "Sans D.A_constr" "Sans L.v20") title("TABLE 4 (18/03/2013)" {\b Robustness IV}{\i  removed one by one}) nonum modelwidth(4) replace 

* Wu-Hausman
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if echantillon==1, robust 
estat endogenous
* SANS dk_moy 
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if echantillon==1, robust 
estat endogenous
* SANS dl_moy 
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if echantillon==1, robust 
estat endogenous
* SANS ldp42 
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if echantillon==1, robust 
estat endogenous
* SANS L2.lci 
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 age2 L2.tu L2.dt D.A_constr L.v20) if echantillon==1, robust 
estat endogenous
* SANS age2 
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci L2.tu L2.dt D.A_constr L.v20) if echantillon==1, robust 
estat endogenous
* SANS L2.tu 
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.dt D.A_constr L.v20) if echantillon==1, robust 
estat endogenous
* SANS L2.dt 
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu D.A_constr L.v20) if echantillon==1, robust 
estat endogenous
* SANS D.A_constr 
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt L.v20) if echantillon==1, robust 
estat endogenous
* SANS  L.v20 
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr) if echantillon==1, robust 
estat endogenous







