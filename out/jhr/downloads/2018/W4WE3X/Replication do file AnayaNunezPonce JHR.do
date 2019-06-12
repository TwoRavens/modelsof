********************************************************************************
************** Setting the agenda: Social influence in the effects *************
************** of the Human Rights Committee in Latin America and **************
************** Central and Eastern Europe **************************************
************** Anaya Muñoz, Alejandro; Núñez, Héctor M.; Ponce, Aldo ***********
************** Code by Núñez, Héctor M.****** **********************************
********************************************************************************

clear all
set more off

*cd "C:\Users\Hector\Dropbox (Personal)\Regional\UN_countries\JHR\Third submission"

use Replication_data_set_AnayaNunezPonce_JHR.dta

* Main Text ********************************************************************
* These commands produce the results in Table 1. *****************************
* Model for Change in the Relative Saliency of Rights in States’ Periodic Reports 

*(1)
mixed deptasa_change indeptasa_change i.country_id i.cluster_id||   region:
*(2)
mixed deptasa_change indeptasa_change i.country_id i.cluster_id l_gdp_pc trade cicle INGO poli_r c.poli_r#c.indeptasa_change || region:
margins, dydx(*) post
*(3)
mixed deptasa_change indeptasa_change i.country_id i.cluster_id  l_gdp_pc trade cicle INGO civil_l c.civil_l#c.indeptasa_change || region:
margins, dydx(*) post

* Online appendix **************************************************************
* These commands produce in Table D1. 
* Summary Statistics
sort region

by region: sum autoc cicle cinc civil_l cl_d cl_e cl_f cl_g democ deptasa_change depyear diffyear ///
goveff indeptasa_change INGO l_gdp l_gdp_pc l_pop ODA parcomp poli_r pr_a pr_b pr_c shamingI tasa_agg_ind trade xconst xrcomp

sum autoc cicle cinc civil_l cl_d cl_e cl_f cl_g democ deptasa_change depyear diffyear ///
goveff indeptasa_change INGO l_gdp l_gdp_pc l_pop ODA parcomp poli_r pr_a pr_b pr_c shamingI tasa_agg_ind trade xconst xrcomp

* These commands produce the results in Table E1. 
* Alternative specifications for the change in the relative saliency of rights in states periodic reports

*(1)
mixed deptasa_change indeptasa_change l_gdp_pc trade cicle c.cicle#c.indeptasa_change || region:
margins, dydx(*) post
*(2)
mixed deptasa_change indeptasa_change i.depyear i.cluster_id l_gdp_pc trade cicle   || region:
*(3)
mixed deptasa_change indeptasa_change l_gdp_pc trade cicle goveff || region:
*(4)
mixed deptasa_change indeptasa_change l_gdp_pc trade cicle diffyear  || region:
*(5)
mixed deptasa_change indeptasa_change l_gdp_pc trade shamingI  || region:
*(6)
mixed deptasa_change indeptasa_change l_pop trade cicle c.cicle#c.indeptasa_change  || region:
margins, dydx(*) post
*(7)
mixed deptasa_change indeptasa_change l_gdp trade cicle c.cicle#c.indeptasa_change  || region:
margins, dydx(*) post
*(8)
mixed deptasa_change indeptasa_change l_gdp_pc trade cicle poli_r INGO ODA c.ODA#c.indeptasa_change  || region:
margins, dydx(*) post
*(9) This model does not converge under multilevel
reg deptasa_change indeptasa_change l_gdp_pc trade cicle poli_r INGO cinc
*(10)
mixed deptasa_change indeptasa_change l_gdp_pc cicle poli_r INGO trade c.trade#c.indeptasa_change  || region:
margins, dydx(*) post
*(11)
mixed deptasa_change indeptasa_change l_gdp_pc trade cicle poli_r INGO c.INGO#c.indeptasa_change  || region:
margins, dydx(*) post
*(12)
mixed deptasa_change indeptasa_change l_gdp_pc trade cicle INGO tasa_agg_ind  || region:
*(13) This model does not converge under multilevel
reg deptasa_change indeptasa_change l_gdp_pc trade cicle INGO i.region##c.indeptasa_change
margins, dydx(*) post
*(14) This model does not converge under multilevel
reg deptasa_change indeptasa_change l_gdp_pc trade cicle INGO i.region##c.poli_r
margins, dydx(*) post
*(15) This model does not converge under multilevel
reg deptasa_change indeptasa_change l_gdp_pc trade cicle INGO i.region##c.indeptasa_change##c.poli_r
margins, dydx(*) post

* These commands produce the results in Tabla E2. 
* Effects of Freedom House components on the change in the relative saliency of rights, groups or issues in states periodic reports

*(1)
mixed deptasa_change indeptasa_change l_gdp_pc trade cicle INGO pr_a c.pr_a#c.indeptasa_change  || region:
margins, dydx(*) post
*(2)
mixed deptasa_change indeptasa_change l_gdp_pc trade cicle INGO pr_b c.pr_b#c.indeptasa_change  || region:
margins, dydx(*) post
*(3)
mixed deptasa_change indeptasa_change l_gdp_pc trade cicle INGO pr_c c.pr_c#c.indeptasa_change  || region:
margins, dydx(*) post
*(4)
mixed deptasa_change indeptasa_change l_gdp_pc trade cicle INGO cl_d c.cl_d#c.indeptasa_change  || region:
margins, dydx(*) post
*(5)
mixed deptasa_change indeptasa_change l_gdp_pc trade cicle INGO cl_e c.cl_e#c.indeptasa_change  || region:
margins, dydx(*) post
*(6)
mixed deptasa_change indeptasa_change l_gdp_pc trade cicle INGO cl_f c.cl_f#c.indeptasa_change  || region:
margins, dydx(*) post
*(7)
mixed deptasa_change indeptasa_change l_gdp_pc trade cicle INGO cl_g c.cl_g#c.indeptasa_change  || region:
margins, dydx(*) post

* These commands produce the results in Table E3. 
* Effects of Polity components on the change in the relative saliency of rights, groups or issues in states periodic reports

*(1)
mixed deptasa_change indeptasa_change l_gdp_pc trade cicle INGO democ c.democ#c.indeptasa_change  || region:
margins, dydx(*) post
*(2)
mixed deptasa_change indeptasa_change l_gdp_pc trade cicle INGO autoc c.autoc#c.indeptasa_change  || region:
margins, dydx(*) post
*(3)
mixed deptasa_change indeptasa_change l_gdp_pc trade cicle INGO xrcomp c.xrcomp#c.indeptasa_change  || region:
margins, dydx(*) post
*(4)
mixed deptasa_change indeptasa_change l_gdp_pc trade cicle INGO xconst c.xconst#c.indeptasa_change  || region:
margins, dydx(*) post
*(5)
mixed deptasa_change indeptasa_change l_gdp_pc trade cicle INGO parcomp c.parcomp#c.indeptasa_change  || region:
margins, dydx(*) post
