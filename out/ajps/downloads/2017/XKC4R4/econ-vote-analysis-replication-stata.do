clear
set more off
set mem 500m

** Set working directory
** Note: need to insert a path below
** cd ""

use replication-data-naomit.dta, replace

generate egoecon_x_shareur=egoecon*shareur_new
generate retroecon_x_shareur=retroecon*shareur_new
generate log_grp=log(grp)

**// REPLICATE RESULTS IN TABLE 2  

** Pocketbook mediator

eststo clear

eststo: quietly meprobit urvote  delta_rgdp egoecon_x_shareur egoecon shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state ||svy_oblast:

eststo: quietly meprobit urvote  delta_unempl egoecon_x_shareur egoecon shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state ||svy_oblast:

**  Regional (sociotropic) mediator

eststo: quietly meprobit urvote  delta_rgdp retroecon_x_shareur retroecon shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state ||svy_oblast:

eststo: quietly meprobit urvote  delta_unempl retroecon_x_shareur retroecon shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state ||svy_oblast:

** Both mediators

eststo: quietly meprobit urvote  delta_rgdp egoecon retroecon_x_shareur retroecon shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state ||svy_oblast:

eststo: quietly meprobit urvote  delta_unempl egoecon retroecon_x_shareur retroecon shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state ||svy_oblast:

esttab using ymods-table2.tex, scalars(ll) se(3) b(3) starlevels(* 0.05 ** 0.01 *** 0.001) aic bic replace


**// REPLICATE RESULTS IN TABLE 3  

use replication-data.dta, replace

generate egoecon_x_media=egoecon*media_recode
generate retroecon_x_media=retroecon*media_recode
generate natlecon_x_media=natlecon*media_recode
generate egoecon_x_shareur=egoecon*shareur_new
generate retroecon_x_shareur=retroecon*shareur_new
generate log_grp=log(grp)
generate log_inc=log(inc_num)

eststo clear

eststo: quietly meprobit urvote  delta_rgdp egoecon_x_media egoecon media_recode shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state ||svy_oblast:

eststo: quietly meprobit urvote  delta_rgdp egoecon_x_media retroecon_x_media  egoecon retroecon media_recode shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state ||svy_oblast:

eststo: quietly meprobit urvote  delta_rgdp egoecon_x_media retroecon_x_media natlecon_x_media egoecon retroecon natlecon media_recode shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state ||svy_oblast:

esttab using mediamods-table3.tex, scalars(ll) se(3) b(3) starlevels(* 0.05 ** 0.01 *** 0.001) aic bic replace

**// REPLICATE RESULTS IN TABLE A4
**// DISCRETE CHOICE MEDIATOR MODEL

use replication-data-naomit.dta, replace

generate log_grp=log(grp)

eststo clear

eststo: quietly meprobit egoecon_bin  delta_rgdp shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state ||svy_oblast:

eststo: quietly meprobit egoecon_bin  delta_unempl shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state ||svy_oblast:

eststo: quietly meprobit retroecon_bin  delta_rgdp shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state ||svy_oblast:

eststo: quietly meprobit retroecon_bin  delta_unempl shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state ||svy_oblast:

esttab using mmods-discrete-tableA4.tex, scalars(ll) se(3) b(3) starlevels(* 0.05 ** 0.01 *** 0.001) aic bic replace

**// REPLICATE RESULTS IN TABLE A6
**// OUTCOME MODEL WITH DISCRETE CHOICE MEDIATOR

use replication-data-naomit.dta, replace

generate egoecon_bin_x_shareur=egoecon_bin*shareur_new
generate retroecon_bin_x_shareur=retroecon_bin*shareur_new
generate egoecon_x_shareur=egoecon*shareur_new
generate retroecon_x_shareur=retroecon*shareur_new
generate log_grp=log(grp)

** Pocketbook mediator

eststo clear

eststo: quietly meprobit urvote  delta_rgdp egoecon_bin_x_shareur egoecon_bin shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state ||svy_oblast:

eststo: quietly meprobit urvote  delta_unempl egoecon_bin_x_shareur egoecon_bin shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state ||svy_oblast:

**  Regional (sociotropic) mediator

eststo: quietly meprobit urvote  delta_rgdp retroecon_bin_x_shareur retroecon_bin shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state ||svy_oblast:

eststo: quietly meprobit urvote  delta_unempl retroecon_bin_x_shareur retroecon_bin shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state ||svy_oblast:

** Both mediators

eststo: quietly meprobit urvote  delta_rgdp egoecon_bin_x_shareur egoecon_bin retroecon_bin_x_shareur retroecon_bin shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state ||svy_oblast:

eststo: quietly meprobit urvote  delta_unempl egoecon_bin_x_shareur egoecon_bin retroecon_bin_x_shareur retroecon_bin shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state ||svy_oblast:

esttab using ymods-discrete-tableA6.tex, scalars(ll) se(3) b(3) starlevels(* 0.05 ** 0.01 *** 0.001) aic bic replace

**// REPLICATE RESULTS IN TABLE A7 
**// INCLUDE CONTROL FOR INCOME 

use replication-data-naomit-inc.dta, replace

generate egoecon_x_shareur=egoecon*shareur_new
generate retroecon_x_shareur=retroecon*shareur_new
generate log_grp=log(grp)
generate log_inc=log(inc_num)

** Pocketbook mediator

eststo clear

eststo: quietly meprobit urvote  delta_rgdp egoecon_x_shareur egoecon shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state log_inc ||svy_oblast:

eststo: quietly meprobit urvote  delta_unempl egoecon_x_shareur egoecon shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state log_inc ||svy_oblast:

**  Regional (sociotropic) mediator

eststo: quietly meprobit urvote  delta_rgdp retroecon_x_shareur retroecon shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state log_inc ||svy_oblast:

eststo: quietly meprobit urvote  delta_unempl retroecon_x_shareur retroecon shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state log_inc ||svy_oblast:

** Both mediators

eststo: quietly meprobit urvote  delta_rgdp egoecon retroecon_x_shareur retroecon shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state log_inc ||svy_oblast:

eststo: quietly meprobit urvote  delta_unempl egoecon retroecon_x_shareur retroecon shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state log_inc ||svy_oblast:

esttab using ymods-inc-tableA7.tex, scalars(ll) se(3) b(3) starlevels(* 0.05 ** 0.01 *** 0.001) aic bic replace

**// REPLICATE RESULTS IN TABLE A8 
**// INCLUDE CONTROL FOR INCOME 

use replication-data.dta, replace

generate egoecon_x_media=egoecon*media_recode
generate retroecon_x_media=retroecon*media_recode
generate natlecon_x_media=natlecon*media_recode
generate egoecon_x_shareur=egoecon*shareur_new
generate retroecon_x_shareur=retroecon*shareur_new
generate log_grp=log(grp)
generate log_inc=log(inc_num)

eststo clear

eststo: quietly meprobit urvote  delta_rgdp egoecon_x_media egoecon media_recode shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state log_inc ||svy_oblast:

eststo: quietly meprobit urvote  delta_rgdp retroecon_x_media retroecon media_recode shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state log_inc ||svy_oblast:

eststo: quietly meprobit urvote  delta_rgdp natlecon_x_media natlecon media_recode shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state log_inc ||svy_oblast:

eststo: quietly meprobit urvote  delta_rgdp egoecon_x_media retroecon_x_media natlecon_x_media egoecon retroecon natlecon media_recode shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state log_inc ||svy_oblast:

esttab using media-inc-tableA8.tex, scalars(ll) se(3) b(3) starlevels(* 0.05 ** 0.01 *** 0.001) aic bic replace

**// REPLICATE RESULTS IN TABLE A9
**// ROBUSTNESS CHECKS FOR OUTCOME MODEL PREDICTING MEDIA EFFECTS

eststo clear

eststo: quietly meprobit urvote  delta_rgdp media_recode  egoecon retroecon natlecon egoecon_x_media retroecon_x_media natlecon_x_media pasturvote shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state ||svy_oblast:

eststo: quietly meprobit urvote  delta_rgdp media_recode  egoecon retroecon natlecon egoecon_x_media retroecon_x_media natlecon_x_media shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state if pasturvote==1 ||svy_oblast: 

esttab using media-control-pastvoting-tableA9.tex, scalars(ll) se(3) b(3) starlevels(* 0.05 ** 0.01 *** 0.001) aic bic replace


**// REPLICATE RESULTS IN TABLE A10
**// ROBUSTNESS CHECKS WITH FIXED EFFECTS

use replication-data-naomit.dta, replace

generate egoecon_bin_x_shareur=egoecon_bin*shareur_new
generate retroecon_bin_x_shareur=retroecon_bin*shareur_new
generate egoecon_x_shareur=egoecon*shareur_new
generate retroecon_x_shareur=retroecon*shareur_new
generate log_grp=log(grp)

eststo clear

eststo: quietly mixed retroecon  delta_rgdp shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state i.year ||svy_oblast:

eststo: quietly mixed retroecon  delta_unempl shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state i.year ||svy_oblast:

eststo: quietly meprobit urvote  delta_rgdp retroecon_x_shareur retroecon shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state i.year ||svy_oblast:

eststo: quietly meprobit urvote  delta_unempl retroecon_x_shareur retroecon shareur_new log_grp share_extractive_avg5yr sex age_recode age_sq_recode edu_num nonstateworker state i.year ||svy_oblast:

esttab using robustness-fe-tableA10.tex, scalars(ll) se(3) b(3) starlevels(* 0.05 ** 0.01 *** 0.001) aic bic replace




