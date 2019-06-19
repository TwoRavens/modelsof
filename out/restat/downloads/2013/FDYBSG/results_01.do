*** 2011.10.28 amit k. khandelwal
*** these code produces code for "Import Competition and Quality Upgrading", Review of Economics and Statistics

cd c:\research\d2f\replication\

cap log close
clear
set mem 500m
set matsize 5000
set more off

global today=string(date("`c(current_date)'","DMY"),"%tdCCYY-NN-DD")
log using d2f_$today.log,replace
**************************************
**** TABLE 1 - SUMMARY STATISTICS ****
****************&*********************
use d2f,clear
	** Report statistics that we use in the baseline regressions, so drop lt==. **
	drop if lt==.
	noisily tabstat dzeta2 ld2f5 lt if lt~=., by(r) s(mean sd) not
	noisily tabstat dzeta2 ld2f5 lt if lt~=., by(idb) s(mean sd) not
	noisily tabstat dzeta2 ld2f5 lt if lt~=., s(mean sd)
	noisily tab r idb if lt~=.
	noisily keep countryname r idb
	noisily duplicates drop
	noisily tab r idb
	

****************************
**** TABLE 2            ****
****************************
cap erase table2.csv
use d2f,clear
		areg dzeta2 lt, absorb(hs_yr) cluster(cc_eu_hs6) robust
			est store tf
		areg dzeta2 lt _T*, absorb(hs_yr) cluster(cc_eu_hs6) robust
			est store tf_ut
		areg dzeta2 ld2f5 lt ld2f5_lt _T*, absorb(hs_yr) cluster(cc_eu_hs6) robust
			est store d2f5_ut
		areg dzeta2 r_ld2f5 r_lt r_ld2f5_lt p_ld2f5 p_lt p_ld2f5_lt _T*, absorb(hs_yr) cluster(cc_eu_hs6) robust
			est store pr_d2f5_ut

		noisily dis ["********* TABLE 2 *********"]
			noisily esttab tf tf_ut d2f5_ut pr_d2f5_ut using table2.csv, cells(b(star fmt(%9.6f)) se(fmt(%9.6f))) starlevel(* .1 ** .05 *** .01) stardetach stats(r2_a N, fmt(%9.3g)) drop(_cons _T*) style(tab) varwidth(8) modelwidth(8) plain replace
		est clear

****************************
**** TABLE 3            ****
****************************
use d2f,clear
		areg dzeta2 hidb_ld2f5 hidb_lt hidb_ld2f5_lt lidb_ld2f5 lidb_lt lidb_ld2f5_lt _T*, a(hs_yr) cluster(cc_eu_hs6)
			est store db_d2f5_ut
		areg dzeta2 r_hidb_ld2f5 r_hidb_lt r_hidb_ld2f5_lt r_lidb_ld2f5 r_lidb_lt r_lidb_ld2f5_lt p_hidb_ld2f5 p_hidb_lt p_hidb_ld2f5_lt p_lidb_ld2f5 p_lidb_lt p_lidb_ld2f5_lt _T*, a(hs_yr) cluster(cc_eu_hs6)
			est store pr_db_d2f5_ut
		areg dzeta2 ld2f5 lt ld2f5_lt _T* if idb==1, absorb(hs_yr) cluster(cc_eu_hs6) robust
			est store d2f5_db

		noisily dis ["********* TABLE 3 *********"]
			noisily esttab db_d2f5_ut pr_db_d2f5_ut d2f5_db using table3.csv, cells(b(star fmt(%9.6f)) se(fmt(%9.6f))) starlevel(* .1 ** .05 *** .01) stardetach stats(r2_a N, fmt(%9.3g)) drop(_cons _T*) style(tab) a varwidth(8) modelwidth(8) plain 


****************************
**** TABLE 4            ****
****************************
use d2f,clear
		areg dzeta2 ld2f5 lt ld2f5_lt _T* if idb == 1 & ld2f5~=1, absorb(hs_yr) cluster(cc_eu_hs6) robust
			est store d2f1

		areg dzeta2 ld2f13 lt ld2f13_lt _T* if idb == 1 , absorb(hs_yr) cluster(cc_eu_hs6) robust
			est store drop_top2 

		areg dzeta2 ld2f12 lt ld2f12_lt _T* if idb == 1, absorb(hs_yr) cluster(cc_eu_hs6) robust
			est store hdb

		areg dzeta2_china ld2f5_china lt_china ld2f5_lt_china _T* if idb == 1, absorb(hs_yr) cluster(cc_eu_hs6) robust
			est store china

		areg dlp lpd2f5 lt lpd2f5_lt _T* if out_dlp~=1 & idb == 1, absorb(hs_yr) cluster(cc_eu_hs6) robust
			est store dlp_db

		areg d_qptile ld2f5 lt ld2f5_lt _T* if idb==1, absorb(hs_yr) cluster(cc_eu_hs6) robust
				est store dptile_d2f

		noisily dis ["********* TABLE 4 *********"]
			noisily esttab d2f1 drop_top2 hdb china dptile_d2f dlp_db using table4.csv, cells(b(star fmt(%9.6f)) se(fmt(%9.6f))) starlevel(* .1 ** .05 *** .01) stardetach stats(r2_a N, fmt(%9.3g)) drop(_T* _cons) style(tab) a varwidth(8) modelwidth(8) plain 
		est clear

****************************
**** TABLE 5 - Column 6 ****
****************************
use d2f,clear
	sort id yr
		cap g l2d2f5 = l.ld2f5
		cap g l2d2f5_lt = l2d2f5 * lt
	tsset,clear
	save tmp,replace

		local exo1 = "lt"
		local end1 = "ld2f5 ld2f5_lt"
		local iv1  = "l2d2f5 l2d2f5_lt"

		local dm_exo1 = "dm_lt"
		local dm_end1 = "dm_ld2f5 dm_ld2f5_lt"
		local dm_iv1  = "dm_l2d2f5 dm_l2d2f5_lt"

		forval v = 1/1 {
			use tmp,clear			
				xtivreg dzeta2 (`end`v'' = `iv`v'') `exo`v'' if idb==1, i(hs_yr) fe
					keep if e(sample)
				qui foreach b of varlist dzeta2 `end`v'' `exo`v'' `iv`v'' _T* {
					bys hs_yr: egen tmp_`b' = mean(`b')
					g dm_`b' = `b' - tmp_`b'
						drop tmp_`b'
					}

				ivreg2 dm_dzeta2 (`dm_end`v'' = `dm_iv`v'') `dm_exo`v'' dm__T*, cluster(cc_eu_hs6) ffirst
					est store iv`v'
				}
		cap erase tmp.dta

********************************
**** TABLE 5 - Columns 1-3,7  **
********************************
use d2f,clear
		drop id
		egen id2 = group(uncode hs)
		bys id2: g c = _N
		areg dzeta2 ld2f5 liptf lt ld2f5_lt _T* if idb == 1, absorb(hs_yr) cluster(cc_eu_hs6) robust
			est store liptf

		areg dzeta2 ld2f5 lt ld2f5_lt dlwx _T* if idb == 1, absorb(hs_yr) cluster(cc_eu_hs6) robust
			est store dlwx

		areg dzeta2 ld2f5 lt ld2f5_lt lrca _T* if idb==1, absorb(hs_yr) cluster(cc_eu_hs6) robust
			est store lrca

		g d2f5_lt = d2f5*lt
		areg dzeta2 d2f5 lt d2f5_lt _T* if idb==1, absorb(hs_yr) cluster(cc_eu_hs6) robust
			est store d2f


		noisily dis ["********* TABLE 5 - Columns 1-3, 7 *********"]
			noisily esttab liptf lrca dlwx d2f using table5.csv, cells(b(star fmt(%9.6f)) se(fmt(%9.6f))) starlevel(* .1 ** .05 *** .01) stardetach stats(r2_a N, fmt(%9.3g)) drop(_T* _cons) style(tab) a varwidth(8) modelwidth(8) plain 
		noisily dis ["********* TABLE 5 - Columns 6 *********"]
			noisily esttab iv1 using table5.csv, cells(b(star fmt(%9.6f)) se(fmt(%9.6f))) starlevel(* .1 ** .05 *** .01) stardetach stats(r2_a N, fmt(%9.3g)) drop(dm__T* _cons) style(tab) a varwidth(8) modelwidth(8) plain 
		est clear

	*****************************
	**** TABLE 5 - Columns 4-5 **
	*****************************
	use d2f,clear
		keep hs year db ld2f5 lt ld2f5_lt dzeta2 hs_yr uncode_yr idb cc_eu_hs6 uncode hs6
		keep if idb==1		
		sort hs
		merge hs using chinabound
			drop if _m==2
			keep if _m==3
			egen cc_hs6 = group(hs6 uncode)
			qui tab uncode_yr, g(_T)
			g post = year==105
			g pre = 1 - post
			g ld2f5_bind = ld2f5*bind_china

			g pre_ld2f5_bind = pre*ld2f5*bind_china
			g post_ld2f5_bind = post*ld2f5*bind_china

			g pre_ld2f5 = pre*ld2f5
			g post_ld2f5 = post*ld2f5
	
		areg dzeta2 ld2f5 ld2f5_bind _T* if year==105, cluster(cc_hs6) a(hs_yr)
			est store mfa1
		areg dzeta2 ld2f5 pre_ld2f5_bind post_ld2f5 post_ld2f5_bind _T*, cluster(cc_hs6) a(hs_yr)
			est store mfa2
		noisily dis ["********* TABLE 5 - Columns 4-5 *********"]
		noisily esttab mfa1 mfa2 using table5.csv, cells(b(star fmt(%9.6f)) se(fmt(%9.6f))) starlevel(* .1 ** .05 *** .01) stardetach stats(r2_a N, fmt(%9.3g)) drop(_T* _cons) style(tab) a varwidth(8) modelwidth(8) plain 


****************************
**** TABLE 6            ****
****************************
	use selection,clear
		g sample = dzeta2~=.

	** generate fixed effects **
		qui tab uncode_yr, g(_T)
		g hs2 = floor(hs/100000000)
		egen hs2_yr = group(hs2 year)
		qui tab hs2_yr, g(_S)
		compress

	** 3 Selection = ltport + _T* + _S*
		probit sample ltport _T* _S*
			est store p_tp_T_S
			predict tmp
			g double imr_tp_T_S = normalden(tmp)/normal(tmp)
			drop tmp
		areg dzeta2 ld2f5 lt ld2f5_lt imr_tp_T_S _T*, absorb(hs_yr) cluster(cc_eu_hs6) robust
			est store select

		noisily dis ["********* TABLE 6 *********"]
		noisily esttab p_tp_T_S using table6.csv, cells(b(star fmt(%9.6f)) se(fmt(%9.6f))) starlevel(* .1 ** .05 *** .01) stardetach stats(r2_a N, fmt(%9.3g)) drop(_cons _S* _T*) style(tab) varwidth(8) modelwidth(8) plain a
		noisily esttab select using table6.csv, cells(b(star fmt(%9.6f)) se(fmt(%9.6f))) starlevel(* .1 ** .05 *** .01) stardetach stats(r2_a N, fmt(%9.3g)) drop(_cons _T*) style(tab) varwidth(8) modelwidth(8) plain a

****************************
**** FIGURE 1           ****
****************************
use d2f,clear
	keep if year == 105

	***Generate leader% by zeta2 
		cap drop max*
		bys year: egen toths = nvals(hs)
		egen maxzeta2 = max(quality5), by(hs year) 
			gen qtop = 1 if quality5==maxzeta2 
			egen qtop_count = count(qtop), by(countryname year) 
			egen qcount = count(quality5), by(countryname year) 
			gen leader_zeta2 = qtop_count/qcount 
			drop maxzeta2 qtop qtop_count qcount 

	***Generate leader% by price 
		egen maxp = max(price), by(hs year) 
			gen qtop = 1 if price==maxp 
			egen qtop_count = count(qtop), by(countryname year) 
			egen qcount = count(price), by(countryname year) 
			gen leader_p = qtop_count/qcount 
			drop maxp qtop qtop_count qcount 

	***merge on iso3's 
		*sort countryname
		*	merge countryname using countryconcordancehs10 
		*	tab _merge 
		*	drop if _merge==2 

	***make graphs 
	*leader_zeta2 vs. gdppc 
	collapse (mean) leader_* gdppc, by(iso countryname year) fast
		g lgdppc = log(gdppc)
		twoway (scatter leader_zeta2 lgdppc, sort ms(x)  mlabel(iso3)), title(Quality Leaders) subtitle(2005) ytitle(Fraction of Country's Products with Highest Quality) xtitle(Log Income Per Capita) xlabel(5(1)12) nodraw
			graph save quality,replace
		twoway (scatter leader_p lgdppc, sort ms(x) mlabel(iso3)), title(Price Leaders) subtitle(2005) ytitle(Fraction of the Country's Products with Highest Price) xtitle(Log Income Per Capita) xlabel(5(1)12) nodraw
			graph save price,replace
		gr combine quality.gph price.gph, ycomm saving(figure1.gph,replace) 
			erase quality.gph 
			erase price.gph
 
****************************
**** FIGURE 2           ****
****************************
	use d2f,clear

	qui areg dzeta2 _T*, a(hs_yr)
	predict qres,res
	egen lt_mean = mean(lt) 
	egen ld2f_mean = mean(ld2f5)
		g i_tariff = lt>=lt_mean
		g i_ld2f    = ld2f5>=ld2f_mean 

			replace i_tariff = . if lt==.

	egen gp = group(i_ld2f i_tariff)
	g qres_low = qres if i_tariff==0
	g qres_high = qres if i_tariff==1

	xtile q_decile1 = ld2f5, nq(5)
	xtile q_decile2 = ld2f5, nq(10)
	xtile q_decile3 = ld2f5, nq(20)
	g qq = .
	replace qq = 1 if ld2f5<=1/20
	forval i = 1/18 {
		replace qq = (`i'+1) if ld2f5>`i'/20 & ld2f5<=(`i'+1)/20
		}
	replace qq = 20 if ld2f5>=19/20

		bys qq: egen qlow  = pctile(qres), p(5)
		bys qq: egen qhigh = pctile(qres), p(95)
		g qres_in = qres<qhigh & qres>qlow
			drop qhigh qlow

	g se = .
	g diff = .
	forval i=1/20 {
		qui ttest qres if qq==`i', by(i_tariff)
		replace diff = r(mu_1)-r(mu_2) if qq==`i'
		replace se = r(se) if qq==`i'
		}
		g diff1 = diff - 1.96*se
		g diff2 = diff + 1.96*se
	collapse (mean) diff diff1 diff2, by(qq)
	replace qq = qq/20
	twoway (scatter diff qq, mc(black)) (rcap diff1 diff2 qq), title("Quality Growth Difference Between Low & High Tariff Environments", size(medium)) subtitle("By Lag Proximity to Frontier Percentile", size(medium)) xtitle("Lag Proximity to Frontier") xmtick(0(.05)1) xlabel(0(.1)1) ytitle("Relative Quality Growth") note("Change in quality is demeaned with country-year and product-year fixed effects. Dashed lines denote 5% confidence intervals.", span size(vsmall)) legend(off) saving(figure2.gph,replace)


****************************
**** FIGURE 3           ****
****************************
	use d2f,clear
		keep db ld2f5 lt ld2f5_lt dzeta2 hs_yr _T* idb
		keep if idb==1		
		areg dzeta2 ld2f5 lt ld2f5_lt _T* if idb == 1, absorb(hs_yr) 

		g hat  = _b[ld2f5]*ld2f5 + _b[lt]*lt + _b[ld2f5_lt]*ld2f5_lt
		foreach i of numlist 10 90 {
			egen tf_p_`i' = pctile(lt), p(`i')
			}
		keep hat* ld2f5 lt tf_p_*
		
		keep if lt==tf_p_10|lt==tf_p_90
		foreach v of varlist hat ld2f5 {
			g `v'_tmp = `v'
			replace `v'_tmp = round(`v'_tmp,.001)
			drop `v'
			}
		duplicates drop
		sort lt ld2f5_tmp
			rename hat_tmp hat
			rename ld2f5_tmp ld2f5
		twoway (line hat ld2f5 if lt==tf_p_10, lp(dash)) (line hat ld2f5 if lt==tf_p_90), /*
			*/xtitle("Proximity to Frontier") caption("Predicted quality growth excludes values of estimated HS-year and country-year FEs",span) legend(rows(1) order(1 "10th Percentile Tariff: 0%" 2 "90th Percentile Tariff: 20%")) ytitle("Predicted Quality Growth")  saving(figure3.gph,replace)



*******************************************
************ MISCELLANEOUS CHECKS      ****
*******************************************
	** ANALYSIS OF VARIANCE OF FIXED EFFECTS (REFEREE 1) **
		use d2f,clear
		xi: reg zeta2 i.yr
		xi: areg zeta2 i.yr, a(id)

cap log close
