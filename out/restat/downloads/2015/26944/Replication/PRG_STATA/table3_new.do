***************  28/02/2013 table 3 

clear
cd "\\intra\partages\au_amic2\Obstacles_CDLP\Résultats_révision\ESTIM_CONSER\TABLEAUX_STATA"
log using "\\intra\partages\au_amic2\Obstacles_CDLP\Résultats_révision\ESTIM_CONSER\TABLEAUX_STATA\Journal_reg_table3new.log",replace
set mem 600m
set more off
set matsize 600

use \\intra\partages\au_amic2\Obstacles_CDLP\Résultats_révision\ESTIM_CONSER\BASES_SAS\fusion_agreg_compl

***********************
tsset siren annee
***********************

***********************************************************************
* CREATION DE LA VARIABLE AGE2 
gen age2=age^2
***********************************************************************

save \\intra\partages\au_amic2\Obstacles_CDLP\Résultats_révision\ESTIM_CONSER\BASES_SAS\fusion_agreg_compl2, replace

use \\intra\partages\au_amic2\Obstacles_CDLP\Résultats_révision\ESTIM_CONSER\BASES_SAS\fusion_agreg_compl2

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

***** TABLEAU 3
eststo clear
* Estimation de base
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if echantillon==1, robust 
test delta_x_new=1
eststo

* Estimation en OLS
xi: regress dva i.annee*i.secteur_4 i.taille delta_x_new delta_tu delta_dt delta_due if echantillon==1, robust 
eststo
test delta_x_new=1

* sous-periodes *
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if (annee>=1992 & annee<=2003) & echantillon==1, robust 
test delta_x_new=1
eststo
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if (annee>=1997 & annee<=2008) & echantillon==1, robust   
test delta_x_new=1
eststo
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if (annee>=1992 & annee<=1998 | annee>=2004 & annee<=2008) & echantillon==1, robust 
test delta_x_new=1
eststo

* en enlevant les secteurs 1 a 1
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if d27~="B0 Industries agricoles et alimentaires" & echantillon==1, robust 
test delta_x_new=1
eststo
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if d27~="C2 Edition, imprimerie, reproduction" & echantillon==1, robust  
test delta_x_new=1
eststo
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if d27~="E2 Industries des équipements mécaniques" & echantillon==1, robust  
test delta_x_new=1
eststo
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if d27~="F3 Industrie du bois et du papier" & echantillon==1, robust  
test delta_x_new=1
eststo
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if d27~="F4 Chimie, caoutchouc, plastiques" & echantillon==1, robust  
test delta_x_new=1
eststo
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if d27~="F5 Métallurgie et transformation des métaux" & echantillon==1, robust  
test delta_x_new=1
eststo


*col12
xi: ivreg2 dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if echantillon==1 & agregation==., robust first
eststo
test delta_x_new=1


esttab using tableau3new.rtf, se keep(delta_x_new delta_due delta_dt delta_tu) stat(N j jp exexog) star(* 0.10 ** 0.05 *** 0.01) mtitle("Estim. ini" "OLS" "1992-2003" "1997-2008" "1992-1998 & 2004-2008" "Without B0" "Without C2" "Without E2" "Without F3" "Without F4" "Without F5" "est 12") title("TABLE 3 (18/03/2013)" {\b Robustness: Estimate 2}) nonum modelwidth(4) replace
 

* Wu-Hausmann
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if echantillon==1, robust  
estat endogenous

* sous-periodes *
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if (annee>=1992 & annee<=2003) & echantillon==1, robust
estat endogenous
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if (annee>=1997 & annee<=2008) & echantillon==1, robust 
estat endogenous
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if (annee>=1992 & annee<=1998 | annee>=2004 & annee<=2008) & echantillon==1, robust  
estat endogenous
* Wu-Hausmann
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if d27~="B0 Industries agricoles et alimentaires" & echantillon==1, robust  
estat endogenous
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if d27~="C2 Edition, imprimerie, reproduction" & echantillon==1, robust    
estat endogenous
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if d27~="E2 Industries des équipements mécaniques" & echantillon==1, robust    
estat endogenous
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if d27~="F3 Industrie du bois et du papier" & echantillon==1, robust   
estat endogenous
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if d27~="F4 Chimie, caoutchouc, plastiques" & echantillon==1, robust    
estat endogenous
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if d27~="F5 Métallurgie et transformation des métaux" & echantillon==1, robust  
estat endogenous


*col12
xi: ivregress 2sls dva i.annee*i.secteur_4 i.taille (delta_x_new delta_tu delta_dt delta_due=dk_moy dl_moy ldp42 L2.lci age2 L2.tu L2.dt D.A_constr L.v20) if echantillon==1 & agregation==., robust
estat endogenous












