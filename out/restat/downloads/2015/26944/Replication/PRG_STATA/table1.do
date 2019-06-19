***************  18/03/2013 - tableau 1  
clear
cd "\\intra\partages\au_amic2\Obstacles_CDLP\Résultats_révision\ESTIM_CONSER\TABLEAUX_STATA"
log using "\\intra\partages\au_amic2\Obstacles_CDLP\Résultats_révision\ESTIM_CONSER\TABLEAUX_STATA\Journal_reg_table1.log",replace
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


******************************************************* ECHANTILLON FIXE **********************************************

*********** DEFINITION DE L'ECHANTILLON
drop echantillon
set more off
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new  delta_x_new_corr dk_corr dl dk_adj_corr dl_adj delta_tu delta_dt delta_due = dk_moy dl_moy ldp42 v40 v29 L2.lci age2 L2.tu L2.dt D.A_constr L.v20 L.delta_due) if secteur_4~="Autres", robust first
gen echantillon=e(sample)


************ TABLEAU 1: 2SLS Delta
eststo clear
*col1
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new =dk_moy dl_moy ldp42 ) if echantillon==1, robust first
eststo
test delta_x_new=1

*col2
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (dk_corr dl =dk_moy dl_moy ldp42 ) if echantillon==1, robust first
eststo
test dk_corr+dl =1

*col3
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if echantillon==1, robust first
eststo
test delta_x_new=1

*col4 
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (dk_corr dl delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt L.v20) if echantillon==1, robust first
eststo
test dk_corr+dl =1

*col5
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new_corr =dk_moy dl_moy ldp42 v40 v29) if echantillon==1, robust first
eststo
test delta_x_new_corr=1

*col6
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (dk_adj_corr dl_adj =dk_moy dl_moy ldp42 v29 v40 L2.l L2.k) if echantillon==1, robust first
eststo
test dk_adj_corr+dl_adj =1


esttab using Tableau1.rtf,se keep(delta_x_new delta_x_new_corr dk_corr dl dk_adj_corr dl_adj delta_tu delta_dt delta_due) stat(N j jp exexog) star(* 0.10 ** 0.05 *** 0.01) title("TABLE 1 (18/03/2013)") nonum modelwidth(4) replace



**************** Wu-Hausmann
*col1
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new =dk_moy dl_moy ldp42 ) if echantillon==1, robust
estat endogenous

*col2
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (dk_corr dl =dk_moy dl_moy ldp42 ) if echantillon==1, robust
estat endogenous

*col3
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if echantillon==1, robust
estat endogenous

*col4 
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (dk_corr dl delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt L.v20) if echantillon==1, robust
estat endogenous

*col5
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new_corr =dk_moy dl_moy ldp42 v40 v29) if echantillon==1, robust
estat endogenous

*col6
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (dk_adj_corr dl_adj =dk_moy dl_moy ldp42 v29 v40 L2.l L2.k) if echantillon==1, robust
estat endogenous

