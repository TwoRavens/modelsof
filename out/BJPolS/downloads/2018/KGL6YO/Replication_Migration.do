%% Replication code for Restraining the Huddled Masses: Migration Policy and Autocratic Survival, by Michael K. Miller and Margaret E. Peters
%% Prepared August 11, 2017


% Tables

% Emigration Flows (Table 1) (Dyadic Data)

eststo clear
global se "r cluster(dyadid)"
global main "cirifor_1 lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 ldist2 d_contig d_colony2 langshare year"
global flow "lwbflowsout"
eststo: quietly reg $flow $main if polity2_1 < 6, $se
global main "cirifor_1 cirifor_2 violence_domestic_1 violence_domestic_2 urban_1 urban_2 lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 ldist2 d_contig d_colony2 langshare year polity_s_2 imports1000 exports1000 alliance war"
global flow "lwbflowsout lwbflowsin"
eststo: quietly reg $flow $main if polity2_1 < 6, $se
global flow "ladflowsout_low ladflowsin_low"
eststo: quietly reg $flow $main if polity2_1 < 6, $se
global flow "ladflowsout_high ladflowsin_high"
eststo: quietly reg $flow $main if polity2_1 < 6, $se
global flow "lwbflowsout lwbflowsin"
eststo: quietly reg $flow $main state_capacity_s_1 cirifor_scs_1 if polity2_1 < 6, $se
esttab, ar2 b(3)


% Democratization (Table 2)

eststo clear
global dem "q2meanpol_lasflowsout"
global se "r"
global base "q2share_lasflowsout polity_s_1 year"
eststo: quietly reg d5pol_s_1 $base $dem if yearid==1 & polity2_1 < 6 & cirifor_1!=., $se
global base "durable_1 q2share_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
eststo: quietly reg d5pol_s_1 $base $dem if yearid==1 & polity2_1 < 6 & cirifor_1!=., $se
eststo: quietly reg d5pol_s_1 $base $dem cirifor_1 ef_q2meanpol ef_q2lasflowsout if yearid==1 & polity2_1 < 6, $se
eststo: quietly probit f5bmr_1 $base $dem if yearid==1 & bmr_1==0 & cirifor_1!=., $se
esttab, ar2 bic b(3)


% Democratization w/ Democracy Diffusion Controls (Table 3)

eststo clear
global dem "q2meanpol_lasflowsout"
global base "durable_1 q2share_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
global diffuse "regionpolity_1"
eststo: quietly reg d5pol_s_1 $base $dem $diffuse if yearid==1 & polity2_1 < 6 & cirifor_1!=., $se
global diffuse "nbrpolity_1"
eststo: quietly reg d5pol_s_1 $base $dem $diffuse if yearid==1 & polity2_1 < 6 & cirifor_1!=., $se
global diffuse "meanpol_trade1000"
eststo: quietly reg d5pol_s_1 $base $dem $diffuse if yearid==1 & polity2_1 < 6 & cirifor_1!=., $se
global diffuse "regionpolity_1 nbrpolity_1 meanpol_trade1000"
eststo: quietly reg d5pol_s_1 $base $dem $diffuse if yearid==1 & polity2_1 < 6 & cirifor_1!=., $se
esttab, ar2 bic b(3)

eststo clear
global diffuse "regionpolity_1"
eststo: quietly probit f5bmr_1 $base $dem $diffuse if yearid==1 & bmr_1==0 & cirifor_1!=., $se
global diffuse "nbrpolity_1"
eststo: quietly probit f5bmr_1 $base $dem $diffuse if yearid==1 & bmr_1==0 & cirifor_1!=., $se
global diffuse "meanpol_trade1000"
eststo: quietly probit f5bmr_1 $base $dem $diffuse if yearid==1 & bmr_1==0 & cirifor_1!=., $se
global diffuse "regionpolity_1 nbrpolity_1 meanpol_trade1000"
eststo: quietly probit f5bmr_1 $base $dem $diffuse if yearid==1 & bmr_1==0 & cirifor_1!=., $se
esttab, ar2 bic b(3)


% Emigration Freedom (Table 4)

eststo clear
global impute "q2meanlgdp_lasflowsout urban_1 lfpr_1 regionpolity_1 meanpol_trade1000 durable_1 q2meanfor_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
global se "r"
eststo: quietly oprobit cirifor_1 q2share_lasflowsout q2meanpol_lasflowsout q2meanfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 if yearid==1 & polity2_1 < 6, $se
eststo: quietly oprobit cirifor_1 q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol q2meanfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 if yearid==1 & polity2_1 < 6, $se
eststo: quietly oprobit cirifor_1 q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol q2meanfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 q2meanlgdp_lasflowsout urban_1 lfpr_1 if yearid==1 & polity2_1 < 6, $se
eststo: quietly oprobit cirifor_1 q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute if yearid==1 & polity2_1 < 6, $se
esttab, ar2 bic b(3)







% Summary Statistics (Table A1)

sutex cirifor_1 q2meanpol_lasflowsout q2share_lasflowsout q2meanfor_lasflowsout q2meanlgdp_lasflowsout polity_s_1 regionpolity_1 nbrpolity_1 meanpol_trade1000 state_capacity_s_1 violence_domestic_1 urban_1 lfpr_1 durable_1 lpop_1 lgdpcap_1 growth2_1 nbrs_1 mean_imports1000 mean_exports1000 year if polity2_1 < 6 & yearid==1 & cirifor_1!=. & q2meanpol_lasflowsout!=., minmax labels file("sum.tex") replace


% 1st Stage Predicting Stocks (Table A3) (Dyadic Data)

eststo clear
global main "lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 ldist2 dd_contig1-dd_contig5 d_colony2 langshare year ldist2_gdp_2 ldist2_lpop_2 dcontig_gdp_2 dcontig_lpop_2"
global flow "lwbstocksout_full"
global se "r cluster(dyadid)"
quietly reg $flow $main if polity2_1 < 6, $se
esttab, ar2 b(3)


% Mediation: Dyadic (Table A4) (Dyadic Data)

eststo clear
global se "r"
global base ""
eststo: quietly reg lremdyad_in q2_lasflowsout $base if year==2009 & polity2_1 < 6, $se
global base "lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 ldist2"
eststo: quietly reg lremdyad_in q2_lasflowsout $base if year==2009 & polity2_1 < 6, $se
global out "exports1000"
global base ""
eststo: quietly reg $out q2_lasflowsout $base if polity2_1 < 6, $se
global base "lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 ldist2 year"
eststo: quietly reg $out q2_lasflowsout $base if polity2_1 < 6, $se
global out "trade1000"
global base ""
eststo: quietly reg $out q2_lasflowsout $base if polity2_1 < 6, $se
global base "lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 ldist2 year"
eststo: quietly reg $out q2_lasflowsout $base if polity2_1 < 6, $se
esttab, ar2 b(3)


% Mediation: Cross-country (Table A5)

eststo clear
global se "r"
global dem "q2meanpol_lasflowsout"
global outcome "fdi_1"
global base "q2share_lasflowsout"
eststo: quietly reg $outcome $base $dem if yearid==1 & polity2_1 < 6, $se
global base "q2share_lasflowsout lpop_1 lgdpcap_1 mean_imports1000 mean_exports1000 year"
eststo: quietly reg $outcome $base $dem if yearid==1 & polity2_1 < 6, $se
global base "q2share_lasflowsout durable_1 cirifor_1 polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
eststo: quietly reg $outcome $base $dem if yearid==1 & polity2_1 < 6, $se
global outcome "aid2_1"
global base "q2share_lasflowsout"
eststo: quietly reg $outcome $base $dem if yearid==1 & polity2_1 < 6, $se
global base "q2share_lasflowsout lpop_1 lgdpcap_1 mean_imports1000 mean_exports1000 year"
eststo: quietly reg $outcome $base $dem if yearid==1 & polity2_1 < 6, $se
global base "q2share_lasflowsout durable_1 cirifor_1 polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
eststo: quietly reg $outcome $base $dem if yearid==1 & polity2_1 < 6, $se
esttab, ar2 b(3)


% Added Controls (Table A6)

eststo clear
global dem "q2meanpol_lasflowsout"
global se "r"
global added "fueldep_1 literacy_1 fdi_1 aid2_1"
global base "durable_1 q2share_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
eststo: quietly reg d5pol_s_1 $added $base $dem if yearid==1 & polity2_1 < 6 & cirifor_1 !=., $se
global impute "q2meanlgdp_lasflowsout urban_1 lfpr_1 regionpolity_1 meanpol_trade1000 durable_1 q2meanfor_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
eststo: quietly oprobit cirifor_1 $added q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute if yearid==1 & polity2_1 < 6, $se
global added "gini_1 fueldep_1 literacy_1 fdi_1 aid2_1"
global base "durable_1 q2share_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
eststo: quietly reg d5pol_s_1 $added $base $dem if yearid==1 & polity2_1 < 6 & cirifor_1 !=., $se
global impute "q2meanlgdp_lasflowsout urban_1 lfpr_1 regionpolity_1 meanpol_trade1000 durable_1 q2meanfor_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
eststo: quietly oprobit cirifor_1 $added q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute if yearid==1 & polity2_1 < 6, $se
global added "cow_milsize_1 violence_domestic_1 ciriworker_s_1 communist_1"
global base "durable_1 q2share_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
eststo: quietly reg d5pol_s_1 $added $base $dem if yearid==1 & polity2_1 < 6 & cirifor_1 !=., $se
global impute "q2meanlgdp_lasflowsout urban_1 lfpr_1 regionpolity_1 meanpol_trade1000 durable_1 q2meanfor_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
eststo: quietly oprobit cirifor_1 $added q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute if yearid==1 & polity2_1 < 6, $se
esttab, ar2 bic b(3)


% Placebo Tests (Table A7)

eststo clear
global impute "q2meanlgdp_lasflowsout urban_1 lfpr_1 regionpolity_1 meanpol_trade1000 durable_1 polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
global se "r"
global free "ciriassn_1 q2meanassn_lasflowsout"
eststo: quietly oprobit $free q2meanfor_lasflowsout q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute if yearid==1 & polity2_1 < 6, $se
global free "ciriassn_1 q2meanassn_lasflowsout cirifor_1"
eststo: quietly oprobit $free q2meanfor_lasflowsout q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute if yearid==1 & polity2_1 < 6, $se
global free "cirirel_1 q2meanrel_lasflowsout"
eststo: quietly oprobit $free q2meanfor_lasflowsout q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute if yearid==1 & polity2_1 < 6, $se
global free "cirirel_1 q2meanrel_lasflowsout cirifor_1"
eststo: quietly oprobit $free q2meanfor_lasflowsout q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute if yearid==1 & polity2_1 < 6, $se
global free "cirispeech_1 q2meanspeech_lasflowsout"
eststo: quietly oprobit $free q2meanfor_lasflowsout q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute if yearid==1 & polity2_1 < 6, $se
global free "cirispeech_1 q2meanspeech_lasflowsout cirifor_1"
eststo: quietly oprobit $free q2meanfor_lasflowsout q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute if yearid==1 & polity2_1 < 6, $se
esttab, ar2 bic b(3)


% Regime Types (Table A8)

eststo clear
global dem "q2meanpol_lasflowsout"
global base "durable_1 q2share_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
eststo: quietly reg d5pol_s_1 geddesmil_1 geddesparty_1 $base $dem if yearid==1 & polity2_1 < 6 & cirifor_1!=., $se
eststo: quietly reg d5pol_s_1 geddesmil_1 geddesparty_1 q2party_meanpol q2party_lasflowsout q2mil_lasflowsout q2mil_meanpol $base $dem if yearid==1 & polity2_1 < 6 & cirifor_1!=., $se
global impute "q2meanlgdp_lasflowsout urban_1 lfpr_1 regionpolity_1 meanpol_trade1000 durable_1 q2meanfor_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
eststo: quietly oprobit cirifor_1 q2share_lasflowsout q2meanpol_lasflowsout geddesmil_1 geddesparty_1 $impute if yearid==1 & polity2_1 < 6, $se
eststo: quietly oprobit cirifor_1 q2share_lasflowsout q2meanpol_lasflowsout geddesmil_1 geddesparty_1 q2party_meanpol q2party_lasflowsout q2mil_lasflowsout q2mil_meanpol $impute if yearid==1 & polity2_1 < 6, $se
esttab, ar2 pr2 b(3)


% Regime Failure (Table A9)

eststo clear
global dem "q2meanpol_lasflowsout"
global base "durable_1 q2share_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
eststo: quietly probit frfailure5_1 $base $dem if yearid==1 & polity2_1 < 6 & cirifor_1!=., $se
global base "durable_1 cirifor_1 q2share_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
eststo: quietly probit frfailure5_1 $base $dem if yearid==1 & polity2_1 < 6 & cirifor_1!=., $se
global base "durable_1 q2share_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
eststo: quietly probit firreg5_c $base $dem if yearid==1 & polity2_1 < 6 & cirifor_1!=., $se
global base "durable_1 cirifor_1 q2share_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
eststo: quietly probit firreg5_c $base $dem if yearid==1 & polity2_1 < 6 & cirifor_1!=., $se
esttab, ar2 pr2 b(3)


% Immigration (Table A10)

eststo clear
global dem "q2meanpol_lasflowsout q2meanpol_lasflowsin q2share_lasflowsout q2share_lasflowsin"
global base "polity_s_1 year"
eststo: quietly reg d5pol_s_1 $base $dem if yearid==1 & polity2_1 < 6 & cirifor_1!=., $se
global base "durable_1 polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
eststo: quietly reg d5pol_s_1 $base $dem if yearid==1 & polity2_1 < 6 & cirifor_1!=., $se
global impute "q2meanlgdp_lasflowsout urban_1 lfpr_1 regionpolity_1 meanpol_trade1000 durable_1 q2meanfor_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
global se "r"
eststo: quietly oprobit cirifor_1 q2share_lasflowsin q2meanpol_lasflowsin q2meanfor_lasflowsin q2share_lasflowsout q2meanpol_lasflowsout q2meanfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 if yearid==1 & polity2_1 < 6, $se
eststo: quietly oprobit cirifor_1 q2share_lasflowsin q2meanpol_lasflowsin q2meanfor_lasflowsin q2share_lasflowsout q2meanpol_lasflowsout $impute if yearid==1 & polity2_1 < 6, $se
esttab, ar2 pr2 b(3)


% Actual Stocks (Table A11)

eststo clear
global dem "meanpol_s_lasflowsout share_lasflowsout"
global dem "meanpol_s_wbstocksout share_wbstocksout"
global base "polity_s_1 year"
eststo: quietly reg d5pol_s_1 $base $dem if yearid==1 & polity2_1 < 6 & cirifor_1!=., $se
global base "durable_1 polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
eststo: quietly reg d5pol_s_1 $base $dem if yearid==1 & polity2_1 < 6 & cirifor_1!=., $se
eststo: quietly reg d5pol_s_1 $base $dem cirifor_1 ef_realmeanpol ef_reallasflowsout if yearid==1 & polity2_1 < 6, $se
eststo: quietly probit f5bmr_1 $base $dem if yearid==1 & bmr_1==0 & cirifor_1!=., $se
esttab, ar2 pr2 b(3)


% Democracies (Table A12)

eststo clear
global dem "d2meanpol_lasflowsout"
global se "r"
global base "d2share_lasflowsout polity_s_1 year"
eststo: quietly probit f5bmr_1 $base $dem if yearid==1 & bmr_1==1 & cirifor_1!=., $se
global impute "regionpolity_1 meanpol_trade1000 d2meanfor_lasflowsout polity_s_1"
global se "r"
eststo: quietly oprobit cirifor_1 d2share_lasflowsout d2meanpol_lasflowsout $impute if yearid==1 & polity2_1 >= 6, $se
esttab, ar2 pr2 b(3)


% V-Dem Measures (Table A13)

eststo clear
global impute "q2meanlgdp_lasflowsout urban_1 lfpr_1 regionpolity_1 meanpol_trade1000 durable_1 q2meanvfor_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
global se "r"
eststo: quietly reg vdem_formove_1 q2share_lasflowsout q2meanpol_lasflowsout q2meanvfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 if yearid==1 & polity2_1 < 6, $se
eststo: quietly reg vdem_formove_1 q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol q2meanvfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 if yearid==1 & polity2_1 < 6, $se
eststo: quietly reg vdem_formove_1 q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol q2meanvfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 q2meanlgdp_lasflowsout urban_1 lfpr_1 if yearid==1 & polity2_1 < 6, $se
eststo: quietly reg vdem_formove_1 q2share_lasflowsout q2meanpol_lasflowsout q2pol_lasflowsout q2pol_meanpol $impute if yearid==1 & polity2_1 < 6, $se
esttab, ar2 bic b(3)







% Figures

% Figure 3
by year, sort: egen aut_demtarg_year = mean(meanpoldem_wbstocksout) if polity2_1<=5 & year >= 1960 & yearid==1
by year, sort: egen dem_demtarg_year = mean(meanpoldem_wbstocksout) if polity2_1 > 5 & year >= 1960 & yearid==1
tw line aut_demtarg_year year if year >= 1960 & yearid==1, lcolor(red) lwidth(medthick) || line dem_demtarg_year year if year >= 1960 & yearid==1, lcolor(blue) lwidth(medthick) || sc aut_demtarg_year year if year==1960 & yearid==1, msize(*4) msymbol(Oh) mcolor(red) mlwidth(medthick) || sc aut_demtarg_year year if year==1970 & yearid==1, msize(*3.29) msymbol(Oh) mcolor(red) mlwidth(medthick) || sc aut_demtarg_year year if year==1980 & yearid==1, msize(*4.34) msymbol(Oh) mcolor(red) mlwidth(medthick) || sc aut_demtarg_year year if year==1990 & yearid==1, msize(*4.39) msymbol(Oh) mcolor(red) mlwidth(medthick) || sc aut_demtarg_year year if year==2000 & yearid==1, msize(*6.56) msymbol(Oh) mcolor(red) mlwidth(medthick) || sc aut_demtarg_year year if year==2010 & yearid==1, msize(*7.59) msymbol(Oh) mcolor(red) mlwidth(medthick) || sc dem_demtarg_year year if year==1960 & yearid==1, msize(*8.31) msymbol(Oh) mcolor(blue) mlwidth(medthick) || sc dem_demtarg_year year if year==1970 & yearid==1, msize(*7.47) msymbol(Oh) mcolor(blue) mlwidth(medthick) || sc dem_demtarg_year year if year==1980 & yearid==1, msize(*8.52) msymbol(Oh) mcolor(blue) mlwidth(medthick) || sc dem_demtarg_year year if year==1990 & yearid==1, msize(*9.19) msymbol(Oh) mcolor(blue) mlwidth(medthick) || sc dem_demtarg_year year if year==2000 & yearid==1, msize(*11.12) msymbol(Oh) mcolor(blue) mlwidth(medthick) || sc dem_demtarg_year year if year==2010 & yearid==1, msize(*10.15) msymbol(Oh) mcolor(blue) mlwidth(medthick)

% Figure 4
reg d5pol_s_1 c.cirifor_1##c.q2meanpol_lasflowsout c.cirifor_1##c.q2share_lasflowsout durable_1 polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1 if yearid==1 & polity2_1 < 6, r
set scheme s1color
margins, dydx(cirifor_1) at(q2share_lasflowsout=(0(.05).06) q2meanpol_lasflowsout=(0(0.5)1)) predict(xb) vsquish atmeans
marginsplot, recast(line) noci yline(0)

% Figure 5
global impute "q2meanlgdp_lasflowsout urban_1 lfpr_1 regionpolity_1 meanpol_trade1000 durable_1 q2meanfor_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
global se "r"
oprobit cirifor_1 q2share_lasflowsout q2pol_lasflowsout c.polity_s_1##c.q2meanpol_lasflowsout $impute if yearid==1 & polity2_1 < 6, $se
set scheme s1color
margins, at(q2meanpol_lasflowsout=(0(.1)1) polity_s_1=(0 .3)) predict(outcome(0)) vsquish atmeans
marginsplot, recast(line) recastci(rline)


% Alternative IVs (Figure A1) (Each $main defines a different xq2* set) (Dyadic Data)

global main "lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 ldist2 dd_contig2-dd_contig6 d_colony2 langshare year ldist2_gdp_2 ldist2_lpop_2 dcontig_gdp_2 dcontig_lpop_2"
global main "lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 ldist2 d_colony2 langshare year ldist2_gdp_2 ldist2_lpop_2 dcontig_gdp_2 dcontig_lpop_2"
global main "lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 ldist2 dd_contig2-dd_contig6 langshare year ldist2_gdp_2 ldist2_lpop_2 dcontig_gdp_2 dcontig_lpop_2"
global main "lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 ldist2 dd_contig2-dd_contig6 d_colony2 year ldist2_gdp_2 ldist2_lpop_2 dcontig_gdp_2 dcontig_lpop_2"
global main "lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 ldist2 dd_contig2-dd_contig6 d_colony2 langshare ldist2_gdp_2 ldist2_lpop_2 dcontig_gdp_2 dcontig_lpop_2"
global main "lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 ldist2 dd_contig2-dd_contig6 d_colony2 langshare year dcontig_gdp_2 dcontig_lpop_2"
global main "lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 ldist2 dd_contig2-dd_contig6 d_colony2 langshare year ldist2_gdp_2 ldist2_lpop_2"
global main "lpop_1 lpop_2 lgdpcap_1 lgdpcap_2 dd_contig2-dd_contig6 d_colony2 langshare year ldist2_gdp_2 ldist2_lpop_2 dcontig_gdp_2 dcontig_lpop_2"
global main "lgdpcap_1 lgdpcap_2 ldist2 dd_contig2-dd_contig6 d_colony2 langshare year ldist2_gdp_2 ldist2_lpop_2 dcontig_gdp_2 dcontig_lpop_2"
global main "lpop_1 lpop_2 ldist2 dd_contig2-dd_contig6 d_colony2 langshare year ldist2_gdp_2 ldist2_lpop_2 dcontig_gdp_2 dcontig_lpop_2"
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

eststo clear
global dem "xq2meanpol_lasflowsout"
global se "r"
global base "durable_1 xq2share_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
eststo: quietly reg d5pol_s_1 $base $dem if yearid==1 & polity2_1 < 6 & cirifor_1 !=., $se
eststo: quietly reg d5pol_s_1 $base $dem cirifor_1 ef_xq2meanpol ef_xq2lasflowsout if yearid==1 & polity2_1 < 6, $se
global impute "xq2meanlgdp_lasflowsout urban_1 lfpr_1 regionpolity_1 meanpol_trade1000 durable_1 xq2meanfor_lasflowsout polity_s_1 mean_imports1000 mean_exports1000 year lpop_1 nbrs_1 lgdpcap_1 growth2_1"
eststo: quietly oprobit cirifor_1 xq2share_lasflowsout xq2meanpol_lasflowsout xq2meanfor_lasflowsout polity_s_1 regionpolity_1 meanpol_trade1000 if yearid==1 & polity2_1 < 6, $se
eststo: quietly oprobit cirifor_1 xq2share_lasflowsout xq2meanpol_lasflowsout xq2pol_lasflowsout xq2pol_meanpol $impute if yearid==1 & polity2_1 < 6, $se
esttab, ar2 pr2 bic b(3) keep(xq2share_lasflowsout xq2meanpol_lasflowsout ef_xq2meanpol ef_xq2lasflowsout xq2pol_lasflowsout xq2pol_meanpol xq2meanlgdp_lasflowsout xq2meanfor_lasflowsout)







% Coding (Dyadic Data)

gen d_contig = 0
replace d_contig = 1 if contig==1
replace d_contig = . if contig==.
tab contig, gen(dd_contig)
gen ldist2_gdp_2 = ldist2*lgdpcap_2
gen ldist2_lpop_2 = ldist2*lpop_2
gen dcontig_gdp_2 = d_contig*lgdpcap_2
gen dcontig_lpop_2 = d_contig*lpop_2
gen cirifor_scs_1 = state_capacity_s_1*cirifor_1

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

