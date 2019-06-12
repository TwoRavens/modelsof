%% Replication code for Restraining the Huddled Masses: Migration Policy and Autocratic Survival, by Michael K. Miller and Margaret E. Peters
%% Prepared August 11, 2017
%% Loops are used to calculate standard errors for models run in Replication_Migration.do


% Migration_boot
quietly reg year lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 ldist2 dd_contig2-dd_contig6 d_colony2 langshare ldist2_gdp_2 ldist2_lpop_2 dcontig_gdp_2 dcontig_lpop_2
predict zz
keep if zz!=. & polity2_1 < 6

% Migration_boot_dem
keep if zz!=. & polity2_1 >= 6

% Standard Error Calculation
gen count = _n
encode var, gen(var2)
by var2, sort: egen sd = sd(coef)
gen truecoef = .
sort count
edit var2 truecoef

by var2, sort: egen truecoef2 = mean(truecoef)
gen tval2 = truecoef2/sd
mean tval2, over(var2)



% Bootstrapping for Main Models

local counter "1"
set more off

forvalues i = 1/1000{

use "Migration_boot.dta",clear 

bsample

drop q2meanpol_q2share q2party_lasflowsout q2party_meanpol q2mil_lasflowsout q2mil_meanpol q2pers_lasflowsout q2pers_meanpol q2meanvfor_lasflowsout ef_q2lasflowsout ef_q2meanpol q2pol_meanpol q2pol_lasflowsout q2_lasflowsout q2tot_lasflowsout q2share_lasflowsout q2meanpol_lasflowsout q2meanlgdp_lasflowsout q2meanfor_lasflowsout q2meanassn_lasflowsout q2meanrel_lasflowsout q2meanspeech_lasflowsout
global main "lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 ldist2 dd_contig2-dd_contig6 d_colony2 langshare year ldist2_gdp_2 ldist2_lpop_2 dcontig_gdp_2 dcontig_lpop_2"
global flow "lwbstocksout_full"
global flow2 "lwbstocksout_full"
quietly reg $flow $main if polity2_1 < 6, $se
predict q2_lasflowsout
by ccode1 year, sort: egen q2tot_lasflowsout = total(exp(q2_lasflowsout)-1)
gen q2share_lasflowsout = q2tot_lasflowsout/exp(lpop_1)
replace q2tot_lasflowsout = log(1+q2tot_lasflowsout)
replace q2tot_lasflowsout = . if q2tot_lasflowsout==0
by ccode1 year, sort: egen q2meanpol_lasflowsout = wtmean(polity_s_2), weight(exp(q2_lasflowsout))
by ccode1 year, sort: egen q2meanlgdp_lasflowsout = wtmean(lgdpcap_2), weight(exp(q2_lasflowsout))
by ccode1 year, sort: egen q2meanfor_lasflowsout = wtmean(cirifor_2), weight(exp(q2_lasflowsout))
by ccode1 year, sort: egen q2meanvfor_lasflowsout = wtmean(vdem_formove_2), weight(exp(q2_lasflowsout))
by ccode1 year, sort: egen q2meanassn_lasflowsout = wtmean(ciriassn_2), weight(exp(q2_lasflowsout))
by ccode1 year, sort: egen q2meanrel_lasflowsout = wtmean(cirirel_2), weight(exp(q2_lasflowsout))
by ccode1 year, sort: egen q2meanspeech_lasflowsout = wtmean(cirispeech_2), weight(exp(q2_lasflowsout))
gen q2pol_lasflowsout = polity_s_1*q2share_lasflowsout
gen q2pol_meanpol = polity_s_1*q2meanpol_lasflowsout
gen ef_q2meanpol = q2meanpol_lasflowsout*cirifor_1
gen ef_q2lasflowsout = q2share_lasflowsout*cirifor_1
gen q2party_lasflowsout = geddesparty_1*q2share_lasflowsout
gen q2party_meanpol = geddesparty_1*q2meanpol_lasflowsout
gen q2mil_lasflowsout = geddesmil_1*q2share_lasflowsout
gen q2mil_meanpol = geddesmil_1*q2meanpol_lasflowsout
gen q2pers_lasflowsout = geddespers_1*q2share_lasflowsout
gen q2pers_meanpol = geddespers_1*q2meanpol_lasflowsout
gen q2meanpol_q2share = q2meanpol_lasflowsout*q2share_lasflowsout

drop q2_lasflowsin q2tot_lasflowsin q2share_lasflowsin q2dif q2meanpol_lasflowsin q2meanfor_lasflowsin q2meanlgdp_lasflowsin q2pol_lasflowsin q2pol_meanpolin
global main "lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 ldist2 dd_contig2-dd_contig6 d_colony2 langshare year ldist2_gdp_1 ldist2_lpop_1 dcontig_gdp_1 dcontig_lpop_1"
global main "lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 ldist2 dd_contig2-dd_contig6 d_colony2 langshare year ldist2_gdp_2 ldist2_lpop_2 dcontig_gdp_2 dcontig_lpop_2"
global flow "lwbstocksin_full"
global flow2 "lwbstocksin_full"
quietly reg $flow $main if polity2_1 < 6, $se
predict q2_lasflowsin
by ccode1 year, sort: egen q2tot_lasflowsin = total(exp(q2_lasflowsin)-1)
gen q2share_lasflowsin = q2tot_lasflowsin/exp(lpop_1)
replace q2tot_lasflowsin = log(1+q2tot_lasflowsin)
replace q2tot_lasflowsin = . if q2tot_lasflowsin==0
gen q2dif = q2share_lasflowsout - q2share_lasflowsin
by ccode1 year, sort: egen q2meanpol_lasflowsin = wtmean(polity_s_2), weight(exp(q2_lasflowsin))
by ccode1 year, sort: egen q2meanfor_lasflowsin = wtmean(cirifor_2), weight(exp(q2_lasflowsin))
by ccode1 year, sort: egen q2meanlgdp_lasflowsin = wtmean(lgdpcap_2), weight(exp(q2_lasflowsin))
gen q2pol_lasflowsin = polity_s_1*q2share_lasflowsin
gen q2pol_meanpolin = polity_s_1*q2meanpol_lasflowsin



global base ""
quietly reg lremdyad_in q2_lasflowsout $base if year==2009 & polity2_1 < 6, $se
if `counter'==1{
regsave q2_lasflowsout using boot_dyad_1, tstat pval ci autoid 
}
if `counter'>1{
regsave q2_lasflowsout using boot_dyad_1, tstat pval ci autoid append
}
global base "lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 ldist2"
quietly reg lremdyad_in q2_lasflowsout $base if year==2009 & polity2_1 < 6, $se
if `counter'==1{
regsave q2_lasflowsout $base using boot_dyad_2, tstat pval ci autoid 
}
if `counter'>1{
regsave q2_lasflowsout $base using boot_dyad_2, tstat pval ci autoid append
}
global out "exports1000"
global base ""
quietly reg $out q2_lasflowsout $base if polity2_1 < 6, $se
if `counter'==1{
regsave q2_lasflowsout $base using boot_dyad_3, tstat pval ci autoid 
}
if `counter'>1{
regsave q2_lasflowsout $base using boot_dyad_3, tstat pval ci autoid append
}
global base "lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 ldist2 year"
quietly reg $out q2_lasflowsout $base if polity2_1 < 6, $se
if `counter'==1{
regsave q2_lasflowsout $base using boot_dyad_4, tstat pval ci autoid 
}
if `counter'>1{
regsave q2_lasflowsout $base using boot_dyad_4, tstat pval ci autoid append
}
global out "trade1000"
global base ""
quietly reg $out q2_lasflowsout $base if polity2_1 < 6, $se
if `counter'==1{
regsave q2_lasflowsout $base using boot_dyad_5, tstat pval ci autoid 
}
if `counter'>1{
regsave q2_lasflowsout $base using boot_dyad_5, tstat pval ci autoid append
}
global base "lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 ldist2 year"
quietly reg $out q2_lasflowsout $base if polity2_1 < 6, $se
if `counter'==1{
regsave q2_lasflowsout $base using boot_dyad_6, tstat pval ci autoid 
}
if `counter'>1{
regsave q2_lasflowsout $base using boot_dyad_6, tstat pval ci autoid append
}




bsample 2322 if polity2_1 < 6 & cirifor_1!=. & q2meanpol_lasflowsout!=.
global se "r"


global dem "q2meanpol_lasflowsout"
global base "q2share_lasflowsout polity_s_1 year"
quietly reg d5pol_s_1 $base $dem if polity2_1 < 6 & cirifor_1!=., $se
if `counter'==1{
regsave $base $dem using boot_table2_1, tstat pval ci autoid 
}
if `counter'>1{
regsave $base $dem using boot_table2_1, tstat pval ci autoid append
}

global base "durable_1 q2share_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
quietly reg d5pol_s_1 $base $dem if polity2_1 < 6 & cirifor_1!=., $se
if `counter'==1{
regsave $base $dem using boot_table2_2, tstat pval ci autoid 
}
if `counter'>1{
regsave $base $dem using boot_table2_2, tstat pval ci autoid append
}

quietly reg d5pol_s_1 $base $dem cirifor_1 ef_q2meanpol ef_q2lasflowsout if polity2_1 < 6, $se
if `counter'==1{
regsave $base $dem cirifor_1 ef_q2meanpol ef_q2lasflowsout using boot_table2_3, tstat pval ci autoid 
}
if `counter'>1{
regsave $base $dem cirifor_1 ef_q2meanpol ef_q2lasflowsout using boot_table2_3, tstat pval ci autoid append
}

quietly probit f5bmr_1 $base $dem if bmr_1==0 & cirifor_1!=., $se
if `counter'==1{
regsave $base $dem using boot_table2_4, tstat pval ci autoid 
}
if `counter'>1{
regsave $base $dem using boot_table2_4, tstat pval ci autoid append
}



global diffuse "regionpolity_1"
quietly reg d5pol_s_1 $base $dem $diffuse if polity2_1 < 6 & cirifor_1!=., $se
if `counter'==1{
regsave $base $dem $diffuse using boot_table3_1, tstat pval ci autoid 
}
if `counter'>1{
regsave $base $dem $diffuse using boot_table3_1, tstat pval ci autoid append
}
global diffuse "nbrpolity_1"
quietly reg d5pol_s_1 $base $dem $diffuse if polity2_1 < 6 & cirifor_1!=., $se
if `counter'==1{
regsave $base $dem $diffuse using boot_table3_2, tstat pval ci autoid 
}
if `counter'>1{
regsave $base $dem $diffuse using boot_table3_2, tstat pval ci autoid append
}
global diffuse "meanpol_trade1000"
quietly reg d5pol_s_1 $base $dem $diffuse if polity2_1 < 6 & cirifor_1!=., $se
if `counter'==1{
regsave $base $dem $diffuse using boot_table3_3, tstat pval ci autoid 
}
if `counter'>1{
regsave $base $dem $diffuse using boot_table3_3, tstat pval ci autoid append
}
global diffuse "regionpolity_1 nbrpolity_1 meanpol_trade1000"
quietly reg d5pol_s_1 $base $dem $diffuse if polity2_1 < 6 & cirifor_1!=., $se
if `counter'==1{
regsave $base $dem $diffuse using boot_table3_4, tstat pval ci autoid 
}
if `counter'>1{
regsave $base $dem $diffuse using boot_table3_4, tstat pval ci autoid append
}

global diffuse "regionpolity_1"
quietly probit f5bmr_1 $base $dem $diffuse if bmr_1==0 & cirifor_1!=., $se
if `counter'==1{
regsave $base $dem $diffuse using boot_table3_5, tstat pval ci autoid 
}
if `counter'>1{
regsave $base $dem $diffuse using boot_table3_5, tstat pval ci autoid append
}
global diffuse "nbrpolity_1"
quietly probit f5bmr_1 $base $dem $diffuse if bmr_1==0 & cirifor_1!=., $se
if `counter'==1{
regsave $base $dem $diffuse using boot_table3_6, tstat pval ci autoid 
}
if `counter'>1{
regsave $base $dem $diffuse using boot_table3_6, tstat pval ci autoid append
}
global diffuse "meanpol_trade1000"
quietly probit f5bmr_1 $base $dem $diffuse if bmr_1==0 & cirifor_1!=., $se
if `counter'==1{
regsave $base $dem $diffuse using boot_table3_7, tstat pval ci autoid 
}
if `counter'>1{
regsave $base $dem $diffuse using boot_table3_7, tstat pval ci autoid append
}
global diffuse "regionpolity_1 nbrpolity_1 meanpol_trade1000"
quietly probit f5bmr_1 $base $dem $diffuse if bmr_1==0 & cirifor_1!=., $se
if `counter'==1{
regsave $base $dem $diffuse using boot_table3_8, tstat pval ci autoid 
}
if `counter'>1{
regsave $base $dem $diffuse using boot_table3_8, tstat pval ci autoid append
}



global impute "q2meanlgdp_lasflowsout urban_1 lfpr_1 regionpolity_1 meanpol_trade1000 durable_1 q2meanfor_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
quietly oprobit cirifor_1 q2share_lasflowsout q2meanpol_lasflowsout q2meanfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 if polity2_1 < 6, $se
if `counter'==1{
regsave q2share_lasflowsout q2meanpol_lasflowsout q2meanfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 using boot_table4_1, tstat pval ci autoid 
}
if `counter'>1{
regsave q2share_lasflowsout q2meanpol_lasflowsout q2meanfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 using boot_table4_1, tstat pval ci autoid append
}
quietly oprobit cirifor_1 q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol q2meanfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 if polity2_1 < 6, $se
if `counter'==1{
regsave q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol q2meanfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 using boot_table4_2, tstat pval ci autoid 
}
if `counter'>1{
regsave q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol q2meanfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 using boot_table4_2, tstat pval ci autoid append
}
quietly oprobit cirifor_1 q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol q2meanfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 q2meanlgdp_lasflowsout urban_1 lfpr_1 if polity2_1 < 6, $se
if `counter'==1{
regsave q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol q2meanfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 q2meanlgdp_lasflowsout urban_1 lfpr_1 using boot_table4_3, tstat pval ci autoid 
}
if `counter'>1{
regsave q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol q2meanfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 q2meanlgdp_lasflowsout urban_1 lfpr_1 using boot_table4_3, tstat pval ci autoid append
}
quietly oprobit cirifor_1 q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute if polity2_1 < 6, $se
if `counter'==1{
regsave q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute using boot_table4_4, tstat pval ci autoid 
}
if `counter'>1{
regsave q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute using boot_table4_4, tstat pval ci autoid append
}



global dem "q2meanpol_lasflowsout"
global outcome "fdi_1"
global base "q2share_lasflowsout"
quietly reg $outcome $base $dem if polity2_1 < 6, $se
if `counter'==1{
regsave $base $dem using boot_mech_1, tstat pval ci autoid 
}
if `counter'>1{
regsave $base $dem using boot_mech_1, tstat pval ci autoid append
}
global base "q2share_lasflowsout lpop_1 lgdpcap_1 mean_imports1000 mean_exports1000 year"
quietly reg $outcome $base $dem if polity2_1 < 6, $se
if `counter'==1{
regsave $base $dem using boot_mech_2, tstat pval ci autoid 
}
if `counter'>1{
regsave $base $dem using boot_mech_2, tstat pval ci autoid append
}
global base "q2share_lasflowsout durable_1 cirifor_1 polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
quietly reg $outcome $base $dem if polity2_1 < 6, $se
if `counter'==1{
regsave $base $dem using boot_mech_3, tstat pval ci autoid 
}
if `counter'>1{
regsave $base $dem using boot_mech_3, tstat pval ci autoid append
}
global outcome "aid2_1"
global base "q2share_lasflowsout"
quietly reg $outcome $base $dem if polity2_1 < 6, $se
if `counter'==1{
regsave $base $dem using boot_mech_4, tstat pval ci autoid 
}
if `counter'>1{
regsave $base $dem using boot_mech_4, tstat pval ci autoid append
}
global base "q2share_lasflowsout lpop_1 lgdpcap_1 mean_imports1000 mean_exports1000 year"
quietly reg $outcome $base $dem if polity2_1 < 6, $se
if `counter'==1{
regsave $base $dem using boot_mech_5, tstat pval ci autoid 
}
if `counter'>1{
regsave $base $dem using boot_mech_5, tstat pval ci autoid append
}
global base "q2share_lasflowsout durable_1 cirifor_1 polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
quietly reg $outcome $base $dem if polity2_1 < 6, $se
if `counter'==1{
regsave $base $dem using boot_mech_6, tstat pval ci autoid 
}
if `counter'>1{
regsave $base $dem using boot_mech_6, tstat pval ci autoid append
}



global dem "q2meanpol_lasflowsout"
global added "fueldep_1 literacy_1 fdi_1 aid2_1"
global base "durable_1 q2share_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
quietly reg d5pol_s_1 $added $base $dem if polity2_1 < 6 & cirifor_1 !=., $se
if `counter'==1{
regsave $added $base $dem using boot_added_1, tstat pval ci autoid 
}
if `counter'>1{
regsave $added $base $dem using boot_added_1, tstat pval ci autoid append
}
global impute "q2meanlgdp_lasflowsout urban_1 lfpr_1 regionpolity_1 meanpol_trade1000 durable_1 q2meanfor_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
quietly oprobit cirifor_1 $added q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute if polity2_1 < 6, $se
if `counter'==1{
regsave $added q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute using boot_added_2, tstat pval ci autoid 
}
if `counter'>1{
regsave $added q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute using boot_added_2, tstat pval ci autoid append
}
global added "gini_1 fueldep_1 literacy_1 fdi_1 aid2_1"
global base "durable_1 q2share_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
quietly reg d5pol_s_1 $added $base $dem if polity2_1 < 6 & cirifor_1 !=., $se
if `counter'==1{
regsave $added $base $dem using boot_added_3, tstat pval ci autoid 
}
if `counter'>1{
regsave $added $base $dem using boot_added_3, tstat pval ci autoid append
}
global impute "q2meanlgdp_lasflowsout urban_1 lfpr_1 regionpolity_1 meanpol_trade1000 durable_1 q2meanfor_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
quietly oprobit cirifor_1 $added q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute if polity2_1 < 6, $se
if `counter'==1{
regsave $added q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute using boot_added_4, tstat pval ci autoid 
}
if `counter'>1{
regsave $added q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute using boot_added_4, tstat pval ci autoid append
}
global added "cow_milsize_1 violence_domestic_1 ciriworker_s_1 communist_1"
global base "durable_1 q2share_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
quietly reg d5pol_s_1 $added $base $dem if polity2_1 < 6 & cirifor_1 !=., $se
if `counter'==1{
regsave $added $base $dem using boot_added_5, tstat pval ci autoid 
}
if `counter'>1{
regsave $added $base $dem using boot_added_5, tstat pval ci autoid append
}
global impute "q2meanlgdp_lasflowsout urban_1 lfpr_1 regionpolity_1 meanpol_trade1000 durable_1 q2meanfor_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
quietly oprobit cirifor_1 $added q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute if polity2_1 < 6, $se
if `counter'==1{
regsave $added q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute using boot_added_6, tstat pval ci autoid 
}
if `counter'>1{
regsave $added q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute using boot_added_6, tstat pval ci autoid append
}



global impute "q2meanlgdp_lasflowsout urban_1 lfpr_1 regionpolity_1 meanpol_trade1000 durable_1 polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
global free "ciriassn_1 q2meanassn_lasflowsout"
quietly oprobit $free q2meanfor_lasflowsout q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute if polity2_1 < 6, $se
if `counter'==1{
regsave q2meanassn_lasflowsout q2meanfor_lasflowsout q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute using boot_placebo_1, tstat pval ci autoid 
}
if `counter'>1{
regsave q2meanassn_lasflowsout q2meanfor_lasflowsout q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute using boot_placebo_1, tstat pval ci autoid append
}
global free "ciriassn_1 q2meanassn_lasflowsout cirifor_1"
quietly oprobit $free q2meanfor_lasflowsout q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute if polity2_1 < 6, $se
if `counter'==1{
regsave q2meanassn_lasflowsout cirifor_1 q2meanfor_lasflowsout q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute using boot_placebo_2, tstat pval ci autoid 
}
if `counter'>1{
regsave q2meanassn_lasflowsout cirifor_1 q2meanfor_lasflowsout q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute using boot_placebo_2, tstat pval ci autoid append
}
global free "cirirel_1 q2meanrel_lasflowsout"
quietly oprobit $free q2meanfor_lasflowsout q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute if polity2_1 < 6, $se
if `counter'==1{
regsave q2meanrel_lasflowsout q2meanfor_lasflowsout q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute using boot_placebo_3, tstat pval ci autoid 
}
if `counter'>1{
regsave q2meanrel_lasflowsout q2meanfor_lasflowsout q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute using boot_placebo_3, tstat pval ci autoid append
}
global free "cirirel_1 q2meanrel_lasflowsout cirifor_1"
quietly oprobit $free q2meanfor_lasflowsout q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute if polity2_1 < 6, $se
if `counter'==1{
regsave q2meanrel_lasflowsout cirifor_1 q2meanfor_lasflowsout q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute using boot_placebo_4, tstat pval ci autoid 
}
if `counter'>1{
regsave q2meanrel_lasflowsout cirifor_1 q2meanfor_lasflowsout q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute using boot_placebo_4, tstat pval ci autoid append
}
global free "cirispeech_1 q2meanspeech_lasflowsout"
quietly oprobit $free q2meanfor_lasflowsout q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute if polity2_1 < 6, $se
if `counter'==1{
regsave q2meanspeech_lasflowsout q2meanfor_lasflowsout q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute using boot_placebo_5, tstat pval ci autoid 
}
if `counter'>1{
regsave q2meanspeech_lasflowsout q2meanfor_lasflowsout q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute using boot_placebo_5, tstat pval ci autoid append
}
global free "cirispeech_1 q2meanspeech_lasflowsout cirifor_1"
quietly oprobit $free q2meanfor_lasflowsout q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute if polity2_1 < 6, $se
if `counter'==1{
regsave q2meanspeech_lasflowsout cirifor_1 q2meanfor_lasflowsout q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute using boot_placebo_6, tstat pval ci autoid 
}
if `counter'>1{
regsave q2meanspeech_lasflowsout cirifor_1 q2meanfor_lasflowsout q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute using boot_placebo_6, tstat pval ci autoid append
}


global dem "q2meanpol_lasflowsout q2meanpol_lasflowsin q2share_lasflowsout q2share_lasflowsin"
global base "polity_s_1 year"
quietly reg d5pol_s_1 $base $dem if polity2_1 < 6 & cirifor_1!=., $se
if `counter'==1{
regsave $base $dem using boot_immem_1, tstat pval ci autoid 
}
if `counter'>1{
regsave $base $dem using boot_immem_1, tstat pval ci autoid append
}
global base "durable_1 polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
quietly reg d5pol_s_1 $base $dem if polity2_1 < 6 & cirifor_1!=., $se
if `counter'==1{
regsave $base $dem using boot_immem_2, tstat pval ci autoid 
}
if `counter'>1{
regsave $base $dem using boot_immem_2, tstat pval ci autoid append
}
global impute "q2meanlgdp_lasflowsout urban_1 lfpr_1 regionpolity_1 meanpol_trade1000 durable_1 q2meanfor_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
quietly oprobit cirifor_1 q2share_lasflowsin q2meanpol_lasflowsin q2meanfor_lasflowsin q2share_lasflowsout q2meanpol_lasflowsout q2meanfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 if polity2_1 < 6, $se
if `counter'==1{
regsave q2share_lasflowsin q2meanpol_lasflowsin q2meanfor_lasflowsin q2share_lasflowsout q2meanpol_lasflowsout q2meanfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 using boot_immem_3, tstat pval ci autoid 
}
if `counter'>1{
regsave q2share_lasflowsin q2meanpol_lasflowsin q2meanfor_lasflowsin q2share_lasflowsout q2meanpol_lasflowsout q2meanfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 using boot_immem_3, tstat pval ci autoid append
}
quietly oprobit cirifor_1 q2share_lasflowsin q2meanpol_lasflowsin q2meanfor_lasflowsin q2share_lasflowsout q2meanpol_lasflowsout $impute if polity2_1 < 6, $se
if `counter'==1{
regsave q2share_lasflowsin q2meanpol_lasflowsin q2meanfor_lasflowsin q2share_lasflowsout q2meanpol_lasflowsout $impute using boot_immem_4, tstat pval ci autoid 
}
if `counter'>1{
regsave q2share_lasflowsin q2meanpol_lasflowsin q2meanfor_lasflowsin q2share_lasflowsout q2meanpol_lasflowsout $impute using boot_immem_4, tstat pval ci autoid append
}



global dem "q2meanpol_lasflowsout"
global base "durable_1 q2share_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
quietly probit frfailure5_1 $base $dem if polity2_1 < 6 & cirifor_1!=., $se
if `counter'==1{
regsave $base $dem using boot_failure_1, tstat pval ci autoid 
}
if `counter'>1{
regsave $base $dem using boot_failure_1, tstat pval ci autoid append
}
global base "durable_1 cirifor_1 q2share_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
quietly probit frfailure5_1 $base $dem if polity2_1 < 6 & cirifor_1!=., $se
if `counter'==1{
regsave $base $dem using boot_failure_2, tstat pval ci autoid 
}
if `counter'>1{
regsave $base $dem using boot_failure_2, tstat pval ci autoid append
}
global base "durable_1 q2share_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
quietly probit firreg5_c $base $dem if polity2_1 < 6 & cirifor_1!=., $se
if `counter'==1{
regsave $base $dem using boot_failure_3, tstat pval ci autoid 
}
if `counter'>1{
regsave $base $dem using boot_failure_3, tstat pval ci autoid append
}
global base "durable_1 cirifor_1 q2share_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
quietly probit firreg5_c $base $dem if polity2_1 < 6 & cirifor_1!=., $se
if `counter'==1{
regsave $base $dem using boot_failure_4, tstat pval ci autoid 
}
if `counter'>1{
regsave $base $dem using boot_failure_4, tstat pval ci autoid append
}



global dem "q2meanpol_lasflowsout"
global base "durable_1 q2share_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
quietly reg d5pol_s_1 geddesmil_1 geddesparty_1 $base $dem if polity2_1 < 6 & cirifor_1!=., $se
if `counter'==1{
regsave geddesmil_1 geddesparty_1 $base $dem using boot_regtype_1, tstat pval ci autoid 
}
if `counter'>1{
regsave geddesmil_1 geddesparty_1 $base $dem using boot_regtype_1, tstat pval ci autoid append
}
quietly reg d5pol_s_1 geddesmil_1 geddesparty_1 q2party_meanpol q2party_lasflowsout q2mil_lasflowsout q2mil_meanpol $base $dem if polity2_1 < 6 & cirifor_1!=., $se
if `counter'==1{
regsave geddesmil_1 geddesparty_1 q2party_meanpol q2party_lasflowsout q2mil_lasflowsout q2mil_meanpol $base $dem using boot_regtype_2, tstat pval ci autoid 
}
if `counter'>1{
regsave geddesmil_1 geddesparty_1 q2party_meanpol q2party_lasflowsout q2mil_lasflowsout q2mil_meanpol $base $dem using boot_regtype_2, tstat pval ci autoid append
}
global impute "q2meanlgdp_lasflowsout urban_1 lfpr_1 regionpolity_1 meanpol_trade1000 durable_1 q2meanfor_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
quietly oprobit cirifor_1 q2share_lasflowsout q2meanpol_lasflowsout geddesmil_1 geddesparty_1 $impute if polity2_1 < 6, $se
if `counter'==1{
regsave q2share_lasflowsout q2meanpol_lasflowsout geddesmil_1 geddesparty_1 $impute using boot_regtype_3, tstat pval ci autoid 
}
if `counter'>1{
regsave q2share_lasflowsout q2meanpol_lasflowsout geddesmil_1 geddesparty_1 $impute using boot_regtype_3, tstat pval ci autoid append
}
quietly oprobit cirifor_1 q2share_lasflowsout q2meanpol_lasflowsout geddesmil_1 geddesparty_1 q2party_meanpol q2party_lasflowsout q2mil_lasflowsout q2mil_meanpol $impute if polity2_1 < 6, $se
if `counter'==1{
regsave q2share_lasflowsout q2meanpol_lasflowsout geddesmil_1 geddesparty_1 q2party_meanpol q2party_lasflowsout q2mil_lasflowsout q2mil_meanpol $impute using boot_regtype_4, tstat pval ci autoid 
}
if `counter'>1{
regsave q2share_lasflowsout q2meanpol_lasflowsout geddesmil_1 geddesparty_1 q2party_meanpol q2party_lasflowsout q2mil_lasflowsout q2mil_meanpol $impute using boot_regtype_4, tstat pval ci autoid append
}



global impute "q2meanlgdp_lasflowsout urban_1 lfpr_1 regionpolity_1 meanpol_trade1000 durable_1 q2meanvfor_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
quietly reg vdem_formove_1 q2share_lasflowsout q2meanpol_lasflowsout q2meanvfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 if polity2_1 < 6, $se
if `counter'==1{
regsave q2share_lasflowsout q2meanpol_lasflowsout q2meanvfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 using boot_vdem_1, tstat pval ci autoid 
}
if `counter'>1{
regsave q2share_lasflowsout q2meanpol_lasflowsout q2meanvfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 using boot_vdem_1, tstat pval ci autoid append
}
quietly reg vdem_formove_1 q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol q2meanvfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 if polity2_1 < 6, $se
if `counter'==1{
regsave q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol q2meanvfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 using boot_vdem_2, tstat pval ci autoid 
}
if `counter'>1{
regsave q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol q2meanvfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 using boot_vdem_2, tstat pval ci autoid append
}
quietly reg vdem_formove_1 q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol q2meanvfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 q2meanlgdp_lasflowsout urban_1 lfpr_1 if polity2_1 < 6, $se
if `counter'==1{
regsave q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol q2meanvfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 q2meanlgdp_lasflowsout urban_1 lfpr_1 using boot_vdem_3, tstat pval ci autoid 
}
if `counter'>1{
regsave q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol q2meanvfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 q2meanlgdp_lasflowsout urban_1 lfpr_1 using boot_vdem_3, tstat pval ci autoid append
}
quietly reg vdem_formove_1 q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute if polity2_1 < 6, $se
if `counter'==1{
regsave q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute using boot_vdem_4, tstat pval ci autoid 
}
if `counter'>1{
regsave q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute using boot_vdem_4, tstat pval ci autoid append
}


local counter "2"

}
























% Bootstrapping for IV Alternatives

local counter "1"
set more off

forvalues i = 1/100{

forvalues j = 1/10{

use "Migration_boot.dta",clear 

bsample

if `j'==1{
global main "lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 ldist2 dd_contig2-dd_contig6 d_colony2 langshare year ldist2_gdp_2 ldist2_lpop_2 dcontig_gdp_2 dcontig_lpop_2"
}
if `j'==2{
global main "lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 ldist2 d_colony2 langshare year ldist2_gdp_2 ldist2_lpop_2 dcontig_gdp_2 dcontig_lpop_2"
local counter "2"
}
if `j'==3{
global main "lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 ldist2 dd_contig2-dd_contig6 langshare year ldist2_gdp_2 ldist2_lpop_2 dcontig_gdp_2 dcontig_lpop_2"
}
if `j'==4{
global main "lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 ldist2 dd_contig2-dd_contig6 d_colony2 year ldist2_gdp_2 ldist2_lpop_2 dcontig_gdp_2 dcontig_lpop_2"
}
if `j'==5{
global main "lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 ldist2 dd_contig2-dd_contig6 d_colony2 langshare ldist2_gdp_2 ldist2_lpop_2 dcontig_gdp_2 dcontig_lpop_2"
}
if `j'==6{
global main "lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 ldist2 dd_contig2-dd_contig6 d_colony2 langshare year dcontig_gdp_2 dcontig_lpop_2"
}
if `j'==7{
global main "lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 ldist2 dd_contig2-dd_contig6 d_colony2 langshare year ldist2_gdp_2 ldist2_lpop_2"
}
if `j'==8{
global main "lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 dd_contig2-dd_contig6 d_colony2 langshare year ldist2_gdp_2 ldist2_lpop_2 dcontig_gdp_2 dcontig_lpop_2"
}
if `j'==9{
global main "lgdpcap_1 lgdpcap_2 ldist2 dd_contig2-dd_contig6 d_colony2 langshare year ldist2_gdp_2 ldist2_lpop_2 dcontig_gdp_2 dcontig_lpop_2"
}
if `j'==10{
global main "lpop_1 lpop_2 ldist2 dd_contig2-dd_contig6 d_colony2 langshare year ldist2_gdp_2 ldist2_lpop_2 dcontig_gdp_2 dcontig_lpop_2"
}

drop xq2meanvfor_lasflowsout ef_xq2lasflowsout ef_xq2meanpol xq2pol_meanpol xq2pol_lasflowsout xq2_lasflowsout xq2tot_lasflowsout xq2share_lasflowsout xq2meanpol_lasflowsout xq2meanlgdp_lasflowsout xq2meanfor_lasflowsout xq2meanassn_lasflowsout xq2meanrel_lasflowsout xq2meanspeech_lasflowsout
global flow "lwbstocksout_full"
quietly reg $flow $main if polity2_1 < 6, $se
predict xq2_lasflowsout
by ccode1 year, sort: egen xq2tot_lasflowsout = total(exp(xq2_lasflowsout)-1)
gen xq2share_lasflowsout = xq2tot_lasflowsout/exp(lpop_1)
replace xq2tot_lasflowsout = log(1+xq2tot_lasflowsout)
replace xq2tot_lasflowsout = . if xq2tot_lasflowsout==0
by ccode1 year, sort: egen xq2meanpol_lasflowsout = wtmean(polity_s_2), weight(exp(xq2_lasflowsout))
by ccode1 year, sort: egen xq2meanlgdp_lasflowsout = wtmean(lgdpcap_2), weight(exp(xq2_lasflowsout))
by ccode1 year, sort: egen xq2meanfor_lasflowsout = wtmean(cirifor_2), weight(exp(xq2_lasflowsout))
by ccode1 year, sort: egen xq2meanvfor_lasflowsout = wtmean(vdem_formove_2), weight(exp(xq2_lasflowsout))
by ccode1 year, sort: egen xq2meanassn_lasflowsout = wtmean(ciriassn_2), weight(exp(xq2_lasflowsout))
by ccode1 year, sort: egen xq2meanrel_lasflowsout = wtmean(cirirel_2), weight(exp(xq2_lasflowsout))
by ccode1 year, sort: egen xq2meanspeech_lasflowsout = wtmean(cirispeech_2), weight(exp(xq2_lasflowsout))
gen xq2pol_lasflowsout = polity_s_1*xq2share_lasflowsout
gen xq2pol_meanpol = polity_s_1*xq2meanpol_lasflowsout
gen ef_xq2meanpol = xq2meanpol_lasflowsout*cirifor_1
gen ef_xq2lasflowsout = xq2share_lasflowsout*cirifor_1

bsample 2322 if polity2_1 < 6 & cirifor_1!=. & xq2meanpol_lasflowsout!=.
global se "r"

global dem "xq2meanpol_lasflowsout"
global base "durable_1 xq2share_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
quietly reg d5pol_s_1 $base $dem if polity2_1 < 6 & cirifor_1 !=., $se
if `counter'==1{
regsave $base $dem using boot_ivalt_1, tstat pval ci autoid addlabel(ivalt,`j')
}
if `counter'>1{
regsave $base $dem using boot_ivalt_1, tstat pval ci autoid addlabel(ivalt,`j') append
}
quietly reg d5pol_s_1 $base $dem cirifor_1 ef_xq2meanpol ef_xq2lasflowsout if polity2_1 < 6, $se
if `counter'==1{
regsave $base $dem cirifor_1 ef_xq2meanpol ef_xq2lasflowsout using boot_ivalt_2, tstat pval ci autoid addlabel(ivalt,`j')
}
if `counter'>1{
regsave $base $dem cirifor_1 ef_xq2meanpol ef_xq2lasflowsout using boot_ivalt_2, tstat pval ci autoid addlabel(ivalt,`j') append
}

global impute "xq2meanlgdp_lasflowsout urban_1 lfpr_1 regionpolity_1 meanpol_trade1000 durable_1 xq2meanfor_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
quietly oprobit cirifor_1 xq2share_lasflowsout xq2meanpol_lasflowsout xq2meanfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 if polity2_1 < 6, $se
if `counter'==1{
regsave xq2share_lasflowsout xq2meanpol_lasflowsout xq2meanfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 using boot_ivalt_3, tstat pval ci autoid addlabel(ivalt,`j') 
}
if `counter'>1{
regsave xq2share_lasflowsout xq2meanpol_lasflowsout xq2meanfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 using boot_ivalt_3, tstat pval ci autoid addlabel(ivalt,`j') append
}
quietly oprobit cirifor_1 xq2share_lasflowsout xq2meanpol_lasflowsout xq2pol_lasflowsout xq2pol_meanpol $impute if polity2_1 < 6, $se
if `counter'==1{
regsave xq2share_lasflowsout xq2meanpol_lasflowsout xq2pol_lasflowsout xq2pol_meanpol $impute using boot_ivalt_4, tstat pval ci autoid addlabel(ivalt,`j') 
}
if `counter'>1{
regsave xq2share_lasflowsout xq2meanpol_lasflowsout xq2pol_lasflowsout xq2pol_meanpol $impute using boot_ivalt_4, tstat pval ci autoid addlabel(ivalt,`j') append
}


}

local counter "2"

}














% Bootstrapping for Democracy Models

local counter "1"
set more off

forvalues i = 1/1000{

use "Migration_boot_dem.dta",clear 

bsample

drop ef_d2meanpol ef_d2lasflowsout d2pol_meanpol d2pol_lasflowsout d2_lasflowsout d2tot_lasflowsout d2share_lasflowsout d2meanpol_lasflowsout d2meanlgdp_lasflowsout d2meanfor_lasflowsout
global main "lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 ldist2 dd_contig2-dd_contig6 d_colony2 langshare year ldist2_gdp_2 ldist2_lpop_2 dcontig_gdp_2 dcontig_lpop_2"
global flow "lwbstocksout_full"
global flow2 "lwbstocksout_full"
quietly reg $flow $main if polity2_1 >= 6, $se
predict d2_lasflowsout
by ccode1 year, sort: egen d2tot_lasflowsout = total(exp(d2_lasflowsout)-1)
gen d2share_lasflowsout = d2tot_lasflowsout/exp(lpop_1)
replace d2tot_lasflowsout = log(1+d2tot_lasflowsout)
replace d2tot_lasflowsout = . if d2tot_lasflowsout==0
by ccode1 year, sort: egen d2meanpol_lasflowsout = wtmean(polity_s_2), weight(exp(d2_lasflowsout))
by ccode1 year, sort: egen d2meanlgdp_lasflowsout = wtmean(lgdpcap_2), weight(exp(d2_lasflowsout))
by ccode1 year, sort: egen d2meanfor_lasflowsout = wtmean(cirifor_2), weight(exp(d2_lasflowsout))
gen d2pol_lasflowsout = polity_s_1*d2share_lasflowsout
gen d2pol_meanpol = polity_s_1*d2meanpol_lasflowsout
gen ef_d2meanpol = d2meanpol_lasflowsout*cirifor_1
gen ef_d2lasflowsout = d2share_lasflowsout*cirifor_1


bsample 1976 if polity2_1 >= 6 & cirifor_1!=. & d2meanpol_lasflowsout!=.
global se "r"


global dem "d2meanpol_lasflowsout"
global base "d2share_lasflowsout polity_s_1 year"
quietly probit f5bmr_1 $base $dem if bmr_1==1 & cirifor_1!=., $se
if `counter'==1{
regsave $base $dem using boot_dem_1, tstat pval ci autoid 
}
if `counter'>1{
regsave $base $dem using boot_dem_1, tstat pval ci autoid append
}

global impute "regionpolity_1 meanpol_trade1000 q2meanfor_lasflowsout polity_s_1"
quietly oprobit cirifor_1 d2share_lasflowsout d2meanpol_lasflowsout $impute if polity2_1 >= 6, $se
if `counter'==1{
regsave d2share_lasflowsout d2meanpol_lasflowsout $impute using boot_dem_2, tstat pval ci autoid 
}
if `counter'>1{
regsave d2share_lasflowsout d2meanpol_lasflowsout $impute using boot_dem_2, tstat pval ci autoid append
}


local counter "2"

}
