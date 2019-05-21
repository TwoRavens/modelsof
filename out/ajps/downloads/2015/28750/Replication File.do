*Title: AJPS Replication File
*Date: January 19, 2015
*Paper Title: "Voting Rights for Whom?: Examining the Effects of the Voting Rights Act on Latino Political Incorporation"

*Variable notes: Variable definitions available in labels of the STATA .dta file


***Table Three***
*Model 1: All/Some Years Logit
logit dbsh sec203_allyrs sec203_someyrs sec4f4 tsbm alpct per_hisp_vap per_blk_vap logtot_pop logmedhomeval pct_hispowner  pct_speak_Span_only ///
pct_fb hcol wcol pctpov_allage predwhite year1 year2 year3 year5 year6 year7 year8 if appct<1, robust cluster (leaid)
est store Model1A
estimates stats
*Model 1: All/Some Years ZTP
ztp numbmh sec203_allyrs sec203_someyrs sec4f4 tsbm alpct per_hisp_vap per_blk_vap logtot_pop logmedhomeval pct_hispowner  pct_speak_Span_only ///
pct_fb hcol wcol pctpov_allage predwhite year1 year2 year3 year5 year6 year7 year8 if appct<1, robust cluster (leaid)
est store Model1B
estimates stats
*Model 2: Covered Years Logit
logit dbsh sec203_covyear sec4f4 tsbm alpct per_hisp_vap per_blk_vap logtot_pop logmedhomeval pct_hispowner  pct_speak_Span_only ///
pct_fb hcol wcol pctpov_allage predwhite year1 year2 year3 year5 year6 year7 year8 if appct<1, robust cluster (leaid)
est store Model2A
estimates stats
*Model 2: Covered Years ZTP
ztp numbmh sec203_covyear  sec4f4 tsbm alpct per_hisp_vap per_blk_vap logtot_pop logmedhomeval pct_hispowner   pct_speak_Span_only ///
pct_fb hcol wcol pctpov_allage predwhite year1 year2 year3 year5 year6 year7 year8 if appct<1, robust cluster (leaid)
est store Model2B
estimates stats
*Model 3: Any Years Logit
logit dbsh sec203_any sec4f4 tsbm alpct per_hisp_vap per_blk_vap logtot_pop logmedhomeval pct_hispowner   pct_speak_Span_only ///
pct_fb hcol wcol pctpov_allage predwhite year1 year2 year3 year5 year6 year7 year8 if appct<1, robust cluster (leaid)
est store Model3A
estimates stats
*Model 3: Any Years ZTP
ztp numbmh sec203_any  sec4f4 tsbm alpct per_hisp_vap per_blk_vap logtot_pop logmedhomeval pct_hispowner  pct_speak_Span_only ///
pct_fb hcol wcol pctpov_allage predwhite year1 year2 year3 year5 year6 year7 year8 if appct<1, robust cluster (leaid)
est store Model3B
estimates stats

estout  Model1A Model1B Model2A Model2B Model3A Model3B, style(fixed) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) collabels ("") mlabels ("Model 1a" "Model 1b" "Model 2a" "Model 2b" "Model 3a" "Model 3b") ///
 eqlabels(,none) stats(N chi2 aic bic, fmt(%9.0f %9.3f)) varlabels (lnalpha:_cons) legend

****************************************************************************************************************************************************************************************************************
****************************************************************************************************************************************************************************************************************

***TABLE FOUR***
*Model One, All Years Logit
logit dbsh sec203_allyrs  sec4f4  anyobsever dojcurrent tsbm alpct per_hisp_vap per_blk_vap logtot_pop logmedhomeval pct_hispowner  pct_speak_Span_only ///
pct_fb hcol wcol pctpov_allage predwhite year1 year2 year3 year5 year6 year7 year8 if vraany==1 & appct<1, robust cluster (leaid)
est store Model1A
estimates stats
*Model One, All YEars ZTP
ztp numbmh sec203_allyrs   sec4f4 anyobsever  dojcurrent tsbm alpct per_hisp_vap per_blk_vap logtot_pop logmedhomeval pct_hispowner  pct_speak_Span_only ///
pct_fb hcol wcol pctpov_allage predwhite year1 year2 year3 year5 year6 year7 year8 if vraany==1 & appct<1, robust cluster (leaid)
est store Model1B
estimates stats
*Model Two, Covered Years Logit
logit dbsh sec203_covyear  sec4f4  anyobsever dojcurrent tsbm alpct per_hisp_vap per_blk_vap logtot_pop logmedhomeval pct_hispowner  pct_speak_Span_only ///
pct_fb hcol wcol pctpov_allage predwhite year1 year2 year3 year5 year6 year7 year8 if vraany==1 & appct<1, robust cluster (leaid)
est store Model2A
estimates stats
*Model Two, Covered Years ZTP
ztp numbmh sec203_covyear   sec4f4 anyobsever dojcurrent  tsbm alpct per_hisp_vap per_blk_vap logtot_pop logmedhomeval pct_hispowner  pct_speak_Span_only ///
pct_fb hcol wcol pctpov_allage predwhite year1 year2 year3 year5 year6 year7 year8 if vraany==1 & appct<1, robust cluster (leaid)
est store Model2B
estimates stats

estout  Model1A Model1B Model2A Model2B, style(fixed) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) collabels ("") mlabels ("Model 1a" "Model 1b" "Model 2a" "Model 2b" "Model 3a" "Model 3b") ///
 eqlabels(,none) stats(N chi2 aic bic, fmt(%9.0f %9.3f)) varlabels (lnalpha:_cons) legend
 