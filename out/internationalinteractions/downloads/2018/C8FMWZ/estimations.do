********************************************************************************
********************************************************************************

						*PTA Negotiation Duration*
				           *Empirical Analysis*

********************************************************************************
********************************************************************************

******* set path
capture cd "~/replication/"


****** read data
drop _all
use  "data_estimation.dta"
stset negotiationduration 


********************************************	
* BASELINE MODEL
********************************************

 
************
* general (baseline results - Table 2)
************

dursel negotiationduration democracy_ave acr_max democracy_ave_acr_max difave_max ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave rule_lawave /// 
	trade_cow_ln ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power trade_gdpave rule_lawave polconiiiave ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time	

* with maximum observations
	
dursel negotiationduration democracy_ave acr_max democracy_ave_acr_max difave_max ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave rule_lawave /// 
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power rule_lawave polconiiiave ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time	
	
dursel negotiationduration democracy_ave acr_max democracy_ave_acr_max difave_max, ///
	select(treat= polity2ave difave_max) ///
    vce(robust) dist(weibull) time	
	
************
* separate issue areas (baseline results: splitted - Table 4)
************

* competition
dursel negotiationduration democracy_ave compp_max democracy_ave_compp_max dif_compmax acr_max difave_max ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave rule_lawave /// 
	trade_cow_ln ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power trade_gdpave rule_lawave polconiiiave ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time	


* ipr
dursel negotiationduration democracy_ave iprp_max democracy_ave_iprp_max dif_iprmax acr_max  difave_max ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave rule_lawave /// 
	trade_cow_ln ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power trade_gdpave rule_lawave polconiiiave ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time


* investment
dursel negotiationduration democracy_ave invp_max democracy_ave_invp_max dif_invmax acr_max  difave_max ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave rule_lawave /// 
	trade_cow_ln ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power trade_gdpave rule_lawave polconiiiave ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time

* NTI
dursel negotiationduration democracy_ave ntip_max democracy_ave_ntip_max dif_ntimax acr_max difave_max ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave rule_lawave /// 
	trade_cow_ln ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power trade_gdpave rule_lawave polconiiiave ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time

* procurement
dursel negotiationduration democracy_ave procp_max democracy_ave_procp_max dif_procmax acr_max difave_max ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave rule_lawave /// 
	trade_cow_ln ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power trade_gdpave rule_lawave polconiiiave ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time


* services
dursel negotiationduration democracy_ave servp_max democracy_ave_servp_max dif_servmax acr_max difave_max ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave rule_lawave /// 
	trade_cow_ln ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power trade_gdpave rule_lawave polconiiiave ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time

* standards
dursel negotiationduration democracy_ave standardsp_max democracy_ave_standardsp_max dif_standardsmax acr_max difave_max ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave rule_lawave /// 
	trade_cow_ln ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power trade_gdpave rule_lawave polconiiiave ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time

****************************************************************************************
****************************************************************************************	
* ROBUSTNESS CHECKS
****************************************************************************************
****************************************************************************************


********************************************	
* ALTERNATIVE DEMOCRACY MEASURES
********************************************

******* unified democracy score > 1

replace udsave = 1 if udsave>=1
replace udsave = 0 if udsave<1

generate udsave_acr_all = udsave*acr_all
generate udsave_acr_max = udsave*acr_max

generate udsave_servp_max = udsave*servp_max
generate udsave_invp_max = udsave*invp_max
generate udsave_standardsp_max = udsave*standardsp_max
generate udsave_iprp_max = udsave*iprp_max
generate udsave_procp_max = udsave*procp_max
generate udsave_compp_max = udsave*compp_max
generate udsave_ntip_max = udsave*ntip_max


************
* general
************

dursel negotiationduration udsave acr_max udsave_acr_max difave_max ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave /// 
	trade_cow ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power ///
	wto_member fta_activityave /// 
	distcap diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time	
	

************
* separate issue areas
************

* competition
dursel negotiationduration udsave compp_max udsave_compp_max dif_compmax ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave /// 
	trade_cow ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave  difave_max ///
	power ///
	wto_member fta_activityave /// 
	distcap contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time	


* ipr
dursel negotiationduration udsave iprp_max udsave_iprp_max dif_iprmax ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave /// 
	trade_cow ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave  difave_max ///
	power ///
	wto_member fta_activityave /// 
	distcap contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time	


* investment
dursel negotiationduration udsave invp_max udsave_invp_max dif_invmax ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave /// 
	trade_cow ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave  difave_max ///
	power ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time	

* NTI
dursel negotiationduration udsave ntip_max udsave_ntip_max dif_ntimax ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave /// 
	trade_cow ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave  difave_max ///
	power ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time	


* procurement
dursel negotiationduration udsave procp_max udsave_procp_max dif_procmax ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave /// 
	trade_cow ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave  difave_max ///
	power ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time	

* services
dursel negotiationduration udsave servp_max udsave_servp_max dif_servmax ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave /// 
	trade_cow ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave  difave_max ///
	power ///
	wto_member fta_activityave /// 
	distcap contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time	

* standards
dursel negotiationduration udsave standardsp_max udsave_standardsp_max dif_standardsmax ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave /// 
	trade_cow ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave  difave_max ///
	power ///
	wto_member fta_activityave /// 
	distcap contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time	


**************************************
* ALTERNATIVE RELATIVE SCOPE MEASURES
*************************************

************** PLACEBO TEST: Absolute instead of relative scope


generate scope = serv_abs+inv_abs+ipr_abs+standards_abs+proc_abs+comp_abs+nti_abs
generate democracy_ave_scope = democracy_ave*scope

generate democracy_ave_serv_abs = democracy_ave*serv_abs
generate democracy_ave_inv_abs = democracy_ave*inv_abs
generate democracy_ave_standards_abs = democracy_ave*standards_abs
generate democracy_ave_ipr_abs = democracy_ave*ipr_abs
generate democracy_ave_proc_abs = democracy_ave*proc_abs
generate democracy_ave_comp_abs = democracy_ave*comp_abs
generate democracy_ave_nti_abs = democracy_ave*nti_abs

************
* general
************

dursel negotiationduration democracy_ave scope democracy_ave_scope difave_max ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave rule_lawave /// 
	trade_cow_ln ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power trade_gdpave rule_lawave polconiiiave ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time	
	

************
* separate issue areas
************

* competition
dursel negotiationduration democracy_ave comp_abs democracy_ave_comp_abs dif_compmax ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave rule_lawave /// 
	trade_cow_ln ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power trade_gdpave rule_lawave polconiiiave ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time	

* ipr
dursel negotiationduration democracy_ave ipr_abs democracy_ave_ipr_abs dif_iprmax ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave rule_lawave /// 
	trade_cow_ln ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power trade_gdpave rule_lawave polconiiiave ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time


* investment
dursel negotiationduration democracy_ave inv_abs democracy_ave_inv_abs dif_invmax ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave rule_lawave /// 
	trade_cow_ln ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power trade_gdpave rule_lawave polconiiiave ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time


* NTI
dursel negotiationduration democracy_ave nti_abs democracy_ave_nti_abs dif_ntimax ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave rule_lawave /// 
	trade_cow_ln ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power trade_gdpave rule_lawave polconiiiave ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time

* procurement
dursel negotiationduration democracy_ave proc_abs democracy_ave_proc_abs dif_procmax ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave rule_lawave /// 
	trade_cow_ln ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power trade_gdpave rule_lawave polconiiiave ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time

* services
dursel negotiationduration democracy_ave serv_abs democracy_ave_serv_abs dif_servmax ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave rule_lawave /// 
	trade_cow_ln ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power trade_gdpave rule_lawave polconiiiave ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time

* standards
dursel negotiationduration democracy_ave standards_abs democracy_ave_standards_abs dif_standardsmax ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave rule_lawave /// 
	trade_cow_ln ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power trade_gdpave rule_lawave polconiiiave ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time

************* Match according to GDP category

generate democracy_ave_acr_all_gdp_cat = democracy_ave*acr_all_gdp_cat

generate democracy_ave_servp_gdp_cat = democracy_ave*servp_gdp_cat
generate democracy_ave_invp_gdp_cat = democracy_ave*invp_gdp_cat
generate democracy_ave_standardsp_gdp_cat = democracy_ave*standardsp_gdp_cat
generate democracy_ave_iprp_gdp_cat = democracy_ave*iprp_gdp_cat
generate democracy_ave_procp_gdp_cat = democracy_ave*procp_gdp_cat
generate democracy_ave_compp_gdp_cat = democracy_ave*compp_gdp_cat
generate democracy_ave_ntip_gdp_cat = democracy_ave*ntip_gdp_cat
 
************
* general
************

dursel negotiationduration democracy_ave acr_all_gdp_cat democracy_ave_acr_all_gdp_cat difave_max ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave rule_lawave /// 
	trade_cow_ln ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power trade_gdpave rule_lawave polconiiiave ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time	

************
* separate issue areas
************

* competition
dursel negotiationduration democracy_ave compp_gdp_cat democracy_ave_compp_gdp_cat dif_compmax ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave rule_lawave /// 
	trade_cow_ln ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power trade_gdpave rule_lawave polconiiiave ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time	

* ipr
dursel negotiationduration democracy_ave iprp_gdp_cat democracy_ave_iprp_gdp_cat dif_iprmax ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave rule_lawave /// 
	trade_cow_ln ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power trade_gdpave rule_lawave polconiiiave ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time


* investment
dursel negotiationduration democracy_ave invp_gdp_cat democracy_ave_invp_gdp_cat dif_invmax ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave rule_lawave /// 
	trade_cow_ln ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power trade_gdpave rule_lawave polconiiiave ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time

* NTI
dursel negotiationduration democracy_ave ntip_gdp_cat democracy_ave_ntip_gdp_cat dif_ntimax ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave rule_lawave /// 
	trade_cow_ln ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power trade_gdpave rule_lawave polconiiiave ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time

* procurement
dursel negotiationduration democracy_ave procp_gdp_cat democracy_ave_procp_gdp_cat dif_procmax ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave rule_lawave /// 
	trade_cow_ln ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power trade_gdpave rule_lawave polconiiiave ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time

* services
dursel negotiationduration democracy_ave servp_gdp_cat democracy_ave_servp_gdp_cat dif_servmax ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave rule_lawave /// 
	trade_cow_ln ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power trade_gdpave rule_lawave polconiiiave ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time

* standards
dursel negotiationduration democracy_ave standardsp_gdp_cat democracy_ave_standardsp_gdp_cat dif_standardsmax ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave rule_lawave /// 
	trade_cow_ln ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power trade_gdpave rule_lawave polconiiiave ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time


********************************************	
* SUBSTITUTION OF THE RELATIVE SCOPE MEASURE
********************************************

generate democracy_ave_grubel_lloyed_mean = democracy_ave*grubel_lloyed_mean

dursel negotiationduration democracy_ave grubel_lloyed_mean democracy_ave_grubel_lloyed_mean difave_max ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave /// 
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time	
	

generate democracy_ave_trade_cow = democracy_ave*trade_cow

dursel negotiationduration democracy_ave trade_cow democracy_ave_trade_cow difave_max ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave /// 
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power ///
	wto_member fta_activityave /// 
	distcap comlang_ethno contig colony diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time	
	

********************************************	
* ADDITIONAL CONTROL VARIABLES
********************************************

************
* general
************

dursel negotiationduration democracy_ave acr_max democracy_ave_acr_max difave_max ///
	enf12 flexescape flexstrings numberms /// 
	power polconiiiave /// 
	trade_cow leftrightave agr ///
	wto_member fta_activityave first_pta ///
	distcap comlang_ethno  ///
	negotiationsyear, ///
	select(treat= polity2ave difave_max ///
	power ///
	wto_member fta_activityave /// 
	distcap diffusion  ///
	negotiationsyear) vce(robust) dist(weibull) time	
	

************
* separate issue areas
************

* competition
streg i.democracy_ave##c.compp_max acr_max ///
		    rogtan_compmax enf12 flexescape flexstrings numberms /// 
			power polconiiiave /// 
			trade_gdpave leftrightave agr ///
			wto_member fta_activityave first_pta ///
			distcap comlang_ethno  ///
			negotiationsyear, vce(robust) dist(weibull) time
	

* ipr
streg i.democracy_ave##c.iprp_max acr_max ///
		    rogtan_iprmax enf12 flexescape flexstrings numberms /// 
			power polconiiiave /// 
			trade_gdpave leftrightave agr ///
			wto_member fta_activityave first_pta ///
			distcap comlang_ethno  ///
			negotiationsyear, vce(robust) dist(weibull) time


* investment
streg i.democracy_ave##c.invp_max acr_max ///
		    rogtan_invmax enf12 flexescape flexstrings numberms /// 
			power polconiiiave /// 
			trade_gdpave leftrightave agr ///
			wto_member fta_activityave first_pta ///
			distcap comlang_ethno  ///
			negotiationsyear, vce(robust) dist(weibull) time


* NTI
streg i.democracy_ave##c.ntip_max acr_max ///
		    rogtan_ntimax enf12 flexescape flexstrings numberms /// 
			power polconiiiave /// 
			trade_gdpave leftrightave agr ///
			wto_member fta_activityave first_pta ///
			distcap comlang_ethno  ///
			negotiationsyear, vce(robust) dist(weibull) time	


* procurement
streg i.democracy_ave##c.procp_max acr_max ///
		    rogtan_procmax enf12 flexescape flexstrings numberms /// 
			power polconiiiave /// 
			trade_gdpave leftrightave agr ///
			wto_member fta_activityave first_pta ///
			distcap comlang_ethno  ///
			negotiationsyear, vce(robust) dist(weibull) time	


* services
streg i.democracy_ave##c.servp_max acr_max ///
		    rogtan_servmax enf12 flexescape flexstrings numberms /// 
			power polconiiiave /// 
			trade_gdpave leftrightave agr ///
			wto_member fta_activityave first_pta ///
			distcap comlang_ethno  ///
			negotiationsyear, vce(robust) dist(weibull) time	


* standards
streg i.democracy_ave##c.standardsp_max acr_max ///
		    rogtan_standardsmax enf12 flexescape flexstrings numberms /// 
			power polconiiiave /// 
			trade_gdpave leftrightave agr ///
			wto_member fta_activityave first_pta ///
			distcap comlang_ethno  ///
			negotiationsyear, vce(robust) dist(weibull) time	



*************************************************************
* SUBSAMPLE ANALYSIS (drop Australia-South Korea Agreement) *
*************************************************************

drop if number==911


************
* general
************

* all
	
streg i.democracy_ave##c.acr_max ///
		    difave_max enf12 flexescape flexstrings numberms /// 
			power polconiiiave /// 
			trade_gdpave ///
			wto_member fta_activityave first_pta ///
			distcap comlang_ethno  ///
			negotiationsyear, vce(robust) dist(weibull) time
	


************
* separate issue areas
************

* competition
streg i.democracy_ave##c.compp_max acr_max ///
		    dif_compmax enf12 flexescape flexstrings numberms /// 
			power polconiiiave /// 
			trade_gdpave ///
			wto_member fta_activityave first_pta ///
			distcap comlang_ethno  ///
			negotiationsyear, vce(robust) dist(weibull) time
	

* ipr
streg i.democracy_ave##c.iprp_max acr_max ///
		    dif_iprmax enf12 flexescape flexstrings numberms /// 
			power polconiiiave /// 
			trade_gdpave ///
			wto_member fta_activityave first_pta ///
			distcap comlang_ethno  ///
			negotiationsyear, vce(robust) dist(weibull) time



* investment
streg i.democracy_ave##c.invp_max acr_max ///
		    dif_invmax enf12 flexescape flexstrings numberms /// 
			power polconiiiave /// 
			trade_gdpave ///
			wto_member fta_activityave first_pta ///
			distcap comlang_ethno  ///
			negotiationsyear, vce(robust) dist(weibull) time

* NTI
streg i.democracy_ave##c.ntip_max acr_max ///
		    dif_ntimax enf12 flexescape flexstrings numberms /// 
			power polconiiiave /// 
			trade_gdpave ///
			wto_member fta_activityave first_pta ///
			distcap comlang_ethno  ///
			negotiationsyear, vce(robust) dist(weibull) time	

* procurement
streg i.democracy_ave##c.procp_max acr_max ///
		    dif_procmax enf12 flexescape flexstrings numberms /// 
			power polconiiiave /// 
			trade_gdpave ///
			wto_member fta_activityave first_pta ///
			distcap comlang_ethno  ///
			negotiationsyear, vce(robust) dist(weibull) time	



* services
streg i.democracy_ave##c.servp_max acr_max ///
		    dif_servmax enf12 flexescape flexstrings numberms /// 
			power polconiiiave /// 
			trade_gdpave ///
			wto_member fta_activityave first_pta ///
			distcap comlang_ethno  ///
			negotiationsyear, vce(robust) dist(weibull) time	

* standards
streg i.democracy_ave##c.standardsp_max acr_max ///
		    dif_standardsmax enf12 flexescape flexstrings numberms /// 
			power polconiiiave /// 
			trade_gdpave ///
			wto_member fta_activityave first_pta ///
			distcap comlang_ethno  ///
			negotiationsyear, vce(robust) dist(weibull) time	

