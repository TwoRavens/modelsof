******
* Healthy Business? - Bloom, Lemos, Sadun, and Van Reenen
* Replication File
* 6 APRIL 2019
******

cap clear matrix
cd "CHANGE TO DIRECTORY WHERE FILES ARE SAVED"


** GLOBALS
global spec				"hos_ss_*"
global noise 			"ss* i_posttenure miss_i_posttenure reliability miss_reliability duration miss_duration aa* tt*"
global qual				"com_lage com_lagem com_qsdummy lqs_com com_phd"

global geo_minA	 		"latanon lonanon lpopdens"
global geo_reg			"lnreggdp yearsed highsch college popij temp invdistcoast lnoilpc ethnic miss_yearsed"
global geo_full 		"n_ldis_river* n_ldis_ocean* n_lmerpop2005* n_lppppop2005* n_prec_new* n_temp_new* n_elev_srtm_pred* "

global geo_reg_us		"lnreggdp yearsed highsch college popij temp invdistcoast lnoilpc ethnic miss_yearsed"
global geo_min_us	 	"hospital_lat hospital_lon lpopdens*"
global hos_us			"profit nprofit lbed teaching"

**----------------------------------------------------------------------------------------------------**
**                                          MAIN FIGURES AND TABLES                                   **
**----------------------------------------------------------------------------------------------------**

**-------------------------------------------------------------------------------**
** FIGURE 1: MANAGEMENT PRACTICES ACROSS COUNTRIES
**-------------------------------------------------------------------------------**
u analysis/input/wms_hos_anon, clear

* basic set up
foreach y in management {
xi: reg `y' cc_* i.yy oo_* *lbed $spec $noise , rob cluster(net_id)
keep if e(sample)==1
gen `y'_raw=.
gen `y'_con=.
foreach var in br ca ge sw uk it in fr{

reg `y' cc_*, rob
ge raw_`y'_`var'=_b[_cons]+_b[cc_`var']
replace `y'_raw=raw_`y'_`var' if cty=="`var'"
replace `y'_raw=_b[_cons] if cty=="us"

xi: reg `y' cc_* i.yy oo_* *lbed  $spec $noise , rob cluster(net_id)
gen cont_`y'_`var'=_b[_cons]+_b[cc_`var']
replace `y'_con=cont_`y'_`var' if cty=="`var'"
replace `y'_con=_b[_cons] if cty=="us"
}
}

egen mean_con=mean(management_con)
egen mean_raw=mean(management_raw)
gen management_con1=management_con+mean_raw-mean_con

* graph
graph hbar (mean) management management_con1, over(country, sort(1) descending) ///
	exclude0 ylab(1.5(.2)3.3) ///
	graphregion(fcolor(white) lcolor(white)) ///
	ytitle("Management practices score") ///
	legend(label(1 "Average") label(2 "Average with controls") col(1) pos(5) ring(0) symxsize(5) size(small)) ///
	bar(1,color(black)) bar(2,color(gs12)) ///
	blabel(bar, size(small) format(%12.1f) position(outside) color(black)) blabel(total)


**-------------------------------------------------------------------------------**
** FIGURE 2: MANAGEMENT PRACTICES WITHIN COUNTRIES
**-------------------------------------------------------------------------------**
u analysis/input/wms_hos_anon, clear

* basic set up
replace country="1 US" if cty=="us"
replace country="2 UK" if cty=="uk"
replace country="3 Sweden" if cty=="sw"
replace country="4 Germany" if cty=="ge"
replace country="5 Canada" if cty=="ca"
replace country="6 Italy" if cty=="it"
replace country="7 France" if cty=="fr"
replace country="8 Brazil" if cty=="br"
replace country="9 India" if cty=="in"
gen us=(cty=="us")
qui ksmirnov management, by(us)
gen count=1
so cty
by cty:replace count=count[_n-1]+1 if count[_n-1]~=.
cap qui kdensity management if cty=="us", generate(us_x us_y) n(40)
egen usx=max(us_x),by(count)
egen usy=max(us_y),by(count)

* graph
graph twoway	(histogram management, bin(25) fcolor(gs12) lcolor(gs10) xtitle(Management practices score) by(country, legend(off)) graphregion(fcolor(white) lcolor(white))) || ///
	(scatter usy usx, by(country, graphregion(fcolor(white) lcolor(white) )) c(d) s(p) lc(black) legend(off))


**-------------------------------------------------------------------------------**
** Figure 3: CORRELATES OF MANAGEMENT PRACTICE SCORE     						                    
**-------------------------------------------------------------------------------**
u  analysis\input\wms_hos_anon, replace

* basic set up
quietly cap estimates drop *
xi i.region_survey i.yy i.cty

quietly eststo: reg zmanagement *lbed	  							$spec $noise _Iyy_* _Icty*, cluster(net_id) 
estimates store size
quietly eststo: reg zmanagement oo_* 								$spec $noise _Iyy_* _Icty*, cluster(net_id) 
estimates store own
quietly eststo: reg zmanagement compe miss_compe 					$spec $noise _Iyy_* _Icty*, cluster(net_id) 
estimates store comp
quietly eststo: reg zmanagement lmba_m  							$spec $noise _Iyy_* _Icty*, cluster(net_id) 
estimates store mba
quietly eststo: reg zmanagement lmba_m *lbed oo_* compe miss_compe 	$spec $noise _Iyy_* _Icty*, cluster(net_id) 
estimates store all

* graph
coefplot (size own comp mba, drop (_cons _* $spec $noise i.yy i.cty miss_lbed miss_competition ldegree_m ldegree_mm) ytitle("") graphregion(color(white)) xline(0) msymbol(D) mcolor(black) ) ///
		 (all, drop (_cons _* $spec $noise i.yy i.cty miss_lbed miss_competition) ytitle("") graphregion(color(white)) xline(0) msymbol(S) mcolor(gs10) mfcolor(gs10) mlcolor(gs10)), ///
		 legend(order(2 "Coef. from individual regressions" 4 "Coef. including all variables jointly") row(2)) scheme(s2mono)


**-------------------------------------------------------------------------------**
** FIGURE 4: DRIVE-TIMES FROM HOSPITAL TO JOINT M-B AND STAND-ALONE HUM SCHOOLS
**-------------------------------------------------------------------------------**
u  analysis\input\wms_hos_anon, replace

* basic set up
gen diff=lib_ttime-com_ttime
drop if diff==.

gen dmore=diff if diff>0
gen dless=diff if diff<0
replace dmore=8 if dmore>8 & dmore!=.
replace dless=-8 if dless<-8 & dless!=.

gen n=1 if dmore<2 & dmore!=.
replace n=1 if dless>-2 & dless!=.
replace n=0 if n==.
egen p=sum(n)
egen t=count(n)
gen pct=round(p/t*100)

* graph
twoway  histogram dmore, frequency bin(8) xlabel(-8(1)8, grid) color(gs6) lcolor(black)|| ///
		histogram dless, bin(8) frequency xlabel(-8(1)8, grid) color(gs12) lcolor(black)|| ///
		scatteri 0 2 1000 2, c(l) color(black) m(i) clpattern(dash) || ///
		scatteri 0 -2 1000 -2, c(l) color(black) m(i) clpattern(dash) || ///
		scatteri 1000 -1.65 "Less than 2-hour", msymbol(i) mlabcolor(black) || ///
		scatteri 950 -1.80 "difference for `=pct'%", msymbol(i) mlabcolor(black) || ///
		scatteri 900 -1.2 "of hospitals", msymbol(i) mlabcolor(black) ///
		legend(order(2 "Additional time to" "joint M-B schools" 1 "Additional time to" "stand-alone HUM") col(1) pos(2) ring(0) symxsize(5) size(vsmall)) ///
		xtitle("Driving time difference in hours between stand-alone HUM and joint M-B schools") ///
		ytitle("# of hospitals") graphregion(fcolor(white) lcolor(white))


**-------------------------------------------------------------------------------**
** FIGURE 5: DRIVE-TIMES BETWEEN HOSPITALS AND NEAREST SCHOOL BY SCHOOL TYPE
**-------------------------------------------------------------------------------**
u  analysis\input\wms_hos_anon, replace

* graph
histogram com_ttime if com_ttime<8, w(.25) xtitle("") title("Joint M-B school", color(black)) xlabel(0(1)8, grid) ylabel(0(.5)1, grid) normal  normopts(lcolor(black)) fcolor(gs12) lcolor(gs10) graphregion(fcolor(white) lcolor(white))
graph save "analysis\output\figs\vector\hist_com", replace 

histogram boz_ttime if boz_ttime<8, w(.25) xtitle("") title("B school, no M", color(black)) xlabel(0(1)8, grid) ylabel(0(.5)1, grid) normal normopts(lcolor(black)) fcolor(gs12) lcolor(gs10) graphregion(fcolor(white) lcolor(white))
graph save "analysis\output\figs\vector\hist_boz", replace 

histogram mod_ttime if mod_ttime<8, w(.25) xtitle("") title("M school, no B", color(black)) xlabel(0(1)8, grid) ylabel(0(.5)1, grid) normal normopts(lcolor(black)) fcolor(gs12) lcolor(gs10) graphregion(fcolor(white) lcolor(white))
graph save "analysis\output\figs\vector\hist_mod", replace

histogram nmb_ttime if nmb_ttime<8, w(.25) xtitle("") title("No M-B school", color(black)) xlabel(0(1)8, grid) ylabel(0(.5)1, grid) normal normopts(lcolor(black)) fcolor(gs12) lcolor(gs10) graphregion(fcolor(white) lcolor(white))
graph save "analysis\output\figs\vector\hist_nmb", replace 

graph combine "analysis\output\figs\vector\hist_com.gph" "analysis\output\figs\vector\hist_boz.gph" "analysis\output\figs\vector\hist_mod.gph" "analysis\output\figs\vector\hist_nmb.gph", ///
	b1title(Driving hours from hospital to nearest school (15min bins)) graphregion(fcolor(white) lcolor(white))


**-------------------------------------------------------------------------------**
** FIGURE 6: SHARE OF MANAGERS WITH MBA-TYPE COURSE AND DRIVING HOURS TO NEAREST SCHOOLS
**-------------------------------------------------------------------------------**
/// First stage with controls manually
u  analysis\input\wms_hos_anon, replace

*basic set up
pwcorr mba_m com_ttime, sig
pwcorr mba_m lib_ttime, sig

gen id=_n
foreach var in mba_m lib_ttime com_ttime{
cap estimates drop *
xi i.region_survey i.yy i.cty
eststo: xi: reg `var'	i.yy  $spec $noise $geo_minA $geo_full, cluster(net_id)
predict double resid, residuals
summarize resid
egen m_`var'=mean(`var')
gen _`var'=resid+m_`var'
drop resid m_`var' `var'
}

reshape long @_ttime, i(id _mba_m) j(sch) string
keep if sch=="_lib"|sch=="_com"
drop if _ttime>5
drop if _ttime<-5
egen dist_bin=cut(_ttime), at(-25(.25)20) 
gen n=1
collapse (mean) _mba_m _ttime (sum)n , by(sch dist_bin)

* graph
graph twoway (scatter _mba_m _ttime if sch=="_com" [w=n], msymbol(o) mlcolor(black) mfcolor(gs6) graphregion(fcolor(white) lcolor(white))) || ///
		(lfit _mba_m _ttime if sch=="_com" [w=n], clcolor(black)  ylab(0(.1).5) legend(off) ///
		xtitle("") title("Universities with Medical" "and Business School", color(black)))	///
		scatteri .0 -4 "Unconditional correlation: -.085 (p-level: 0.00)", msymbol(i) mlabcolor(black) 
graph save "analysis\output\figs\vector\scat_com", replace 

graph twoway (scatter _mba_m _ttime if sch=="_lib" [w=n], msymbol(o) mlcolor(black) mfcolor(gs12) graphregion(fcolor(white) lcolor(white))) || ///
		(lfit _mba_m _ttime if sch=="_lib" [w=n], clcolor(black) ylab(0(.1).5) legend(off) ///
		xtitle("") title("Stand-Alone Humanities" "Schools", color(black))) ///
		scatteri .0 -4 "Unconditional correlation: -.028 (p-level: 0.21)", msymbol(i) mlabcolor(black) 
graph save "analysis\output\figs\vector\scat_lib", replace 

graph combine "analysis\output\figs\vector\scat_com.gph" "analysis\output\figs\vector\scat_lib.gph", ///
	b1title("Driving hours from hospital to nearest school (15min bins), controls added") l2title(Share of Managers with MBA-type course) graphregion(fcolor(white) lcolor(white))

**-------------------------------------------------------------------------------**
** Table 1: DESCRIPTIVE STATISTICS    			                         
**-------------------------------------------------------------------------------**
clear matrix
u  analysis\input\wms_hos_anon, replace

** preparing variables
foreach var in mba_m hos_bed oo_fprofit oo_nfprofit popdens compe{
replace `var'=. if `var'==-99
}
gen dcompe0=(compe==0 & compe!=.)
gen dcompe1=(compe==1 & compe!=.)
gen dcompe2=(compe==2 & compe!=.)
foreach var in dcompe0 dcompe1 dcompe2{
replace `var'=. if compe==.
}
lab var dcompe0 "# of competitors: 0"
lab var dcompe1 "# of competitors: 1 to 5"
lab var dcompe2 "# of competitors: more than 5"

gen oo_public=(oo_fprofit==0&oo_nfprofit==0)
lab var oo_public "Dummy public"

label var any_ttime  	"Driving hrs, nearest university in general"
label var lib_ttime		"Driving hrs, nearest stand-alone humanities school"
label var com_tdist	   	"Driving distance (km) to nearest joint M-B schools"
label var nmb_ttime		"Driving hrs, nearest school, no M or B"
label var mod_ttime		"Driving hrs, nearest M school, no B"
label var boz_ttime		"Driving hrs, nearest B school, no M"
label var management	"Management Practice Score"
label var zmanagement	"Management Practice Score (Z-Score)"
label var zami_rate		"AMI mortality rate (Z-Score)"

** summary statistics for main body
cap drop estimates*
estpost su zami_rate management zmanagement hos_bed mba_m dcompe0 dcompe1 dcompe2 oo_public oo_fprofit oo_nfprofit ///
	com_ttime com_tdist boz_ttime mod_ttime nmb_ttime lib_ttime any_ttime, detail
	
** table
esttab,  replace  ///
	refcat(zami_rate "--Hospital Characteristics"  com_ttime "--Distances to Universities", nolabel) ///
	cells("mean(fmt(2)) p50(label(median) fmt(2)) sd(par) min(fmt(1)) max(fmt(1))") label nonotes nonumber noobs 


**-------------------------------------------------------------------------------**
** Table 2: AMI MORTALITY RATES ARE CORRELATED WITH MANAGEMENT PRACTICES
**-------------------------------------------------------------------------------**
u  analysis\input\wms_hos_anon, replace
drop if zami_rate==.

** basic set up
quietly cap estimates drop *
xi i.region_survey i.yy i.cty i.nuts1

** regressions
quietly eststo: reg zami_rate zmanagement  															          _Iyy_* _Icty*, 		cluster(net_id) 
quietly eststo: reg zami_rate zmanagement   oo_* compe miss_compe *lbed 						 $spec $noise _Iyy_* _Icty*,		cluster(net_id) 
quietly eststo: reg zami_rate zmanagement   oo_* compe miss_compe *lbed		$geo_minA $geo_reg   $spec $noise _Iyy_* _Icty*, 		cluster(net_id) 
quietly eststo: reg zami_rate zmanagement   oo_* compe miss_compe *lbed		$geo_minA $geo_reg   $spec $noise _Iyy_* _Iregion_su*, 	cluster(net_id) 
quietly eststo: reg zami_rate zmanagement   oo_* compe miss_compe *lbed		$geo_minA $geo_full  $spec $noise _Iyy_* , 				cluster(net_id) 

** table
esttab, ///
	label replace ///
	keep(zmanagement lbed oo_* ) ///	
	order(zmanagement lbed oo_*) ///
	collabels(none) ///
	nogap depvars ///
	cells(b(star fmt(3)) se(par fmt(3))) starlevels( * 0.10 ** 0.05 *** 0.01) ///
	stats(N N_clust fe r2, fmt(0 0 2 2) ///
	labels(`"Observations"' `"No of clusters"' `"Fixed effects (number)"' `"R-squared"')) ///
	indicate("Omitted based is government owned = $b" "Noise controls = $noise $spec" "Other hospital characteristics = compe " "Geographic controls - Regional level = $geo_reg" "Geographic controls - Grid level = $geo_full", labels(Y))
	

**-------------------------------------------------------------------------------**
** Table 3: AMI MORTALITY RATES AND MANAGERIAL EDUCATION
**-------------------------------------------------------------------------------**
u  analysis\input\wms_hos_anon, replace

** basic set up
quietly cap estimates drop *
xi i.region_survey i.yy i.cty

** regressions
quietly eststo: reg zami_rate 	lany_ttime   		 							 				 oo_* compe miss_compe *lbed $spec $noise _Icty* _Iyy_*, cluster(net_id)
quietly eststo: reg zami_rate 	lcom_ttime  llib_ttime	lcrs_ttime 								 oo_* compe miss_compe *lbed $spec $noise _Icty* _Iyy_*, cluster(net_id)
test lcom_ttime=llib_ttime
quietly estadd scalar p_diff0 = r(p)
test lcrs_ttime llib_ttime
quietly estadd scalar p_joint0 = r(p)
quietly eststo: reg zami_rate 	lcom_ttime  llib_ttime	lcrs_ttime 			  $geo_minA $geo_reg oo_* compe miss_compe *lbed $spec $noise _Icty* _Iyy_*, cluster(net_id)
test lcom_ttime=llib_ttime
quietly estadd scalar p_diff0 = r(p)
test lcrs_ttime llib_ttime
quietly estadd scalar p_joint0 = r(p)
quietly eststo: reg zami_rate 	lcom_ttime  lboz_ttime lmod_ttime lnmb_ttime  $geo_minA $geo_reg oo_* compe miss_compe *lbed $spec $noise _Icty* _Iyy_*, cluster(net_id)
test lcom_ttime=lboz_ttime
quietly estadd scalar p_diff1 = r(p)
test lcom_ttime=lmod_ttime
quietly estadd scalar p_diff2 = r(p)
test lboz_ttime lmod_ttime lnmb_ttime 	
quietly estadd scalar p_joint = r(p)
quietly eststo: reg zami_rate 	lcom_ttime  								  $geo_minA $geo_reg oo_* compe miss_compe *lbed $spec $noise _Icty* _Iyy_*, cluster(net_id)

** table
esttab, ///
	replace ///
	nodepvar nomtitles ///
	keep(lany_ttime lcom_ttime llib_ttime lcrs_ttime lboz_ttime lmod_ttime lnmb_ttime) ///	
	order(lany_ttime lcom_ttime llib_ttime lcrs_ttime lboz_ttime lmod_ttime lnmb_ttime) ///	
	collabels(none) ///
	nogap ///
	cells(b(star fmt(3)) se(par fmt(3))) starlevels( * 0.10 ** 0.05 *** 0.01) ///
	stats(N N_clust p_diff0 p_diff1 p_diff2 p_joint0 p_joint r2, fmt(0 0 2 2 2 2 2 2) ///
	labels(`"Observations"' `"No of clusters"' `"Test of Equality: Joint M-B = HUM"' `"Test of Equality: Joint M-B = B, no M"' `"Test of Equality: Joint M-B = M, no B"' `"Test of Joint Sig.: HUM, no M-B-HUM"' `"Test of Joint Sig.: B, M, No B-M"' `"R-squared"')) ///
	indicate("Geographic controls - Regional level = $geo_reg", labels(Y))

**-------------------------------------------------------------------------------**
** Table 4: HOSPITAL MANAGEMENT SCORE AND MANAGERIAL EDUCATION
**-------------------------------------------------------------------------------**
u  analysis\input\wms_hos_anon, replace

** basic set up
quietly cap estimates drop *
xi i.region_survey i.yy i.cty

** regressions
quietly eststo: reg zmanagement 	lany_ttime   		 											oo_* compe miss_compe *lbed $spec $noise _Icty* _Iyy_*, cluster(net_id)
quietly eststo: reg zmanagement 	lcom_ttime  llib_ttime	lcrs_ttime 								oo_* compe miss_compe *lbed $spec $noise _Icty* _Iyy_*, cluster(net_id)
test lcom_ttime=llib_ttime
quietly estadd scalar p_diff0 = r(p)
test lcrs_ttime llib_ttime
quietly estadd scalar p_joint0 = r(p)
quietly eststo: reg zmanagement 	lcom_ttime  llib_ttime	lcrs_ttime 			  $geo_minA $geo_reg oo_* compe miss_compe *lbed $spec $noise _Icty* _Iyy_*, cluster(net_id)
test lcom_ttime=llib_ttime
quietly estadd scalar p_diff0 = r(p)
test lcrs_ttime llib_ttime
quietly estadd scalar p_joint0 = r(p)
quietly eststo: reg zmanagement 	lcom_ttime  lboz_ttime lmod_ttime lnmb_ttime  $geo_minA $geo_reg oo_* compe miss_compe *lbed $spec $noise _Icty* _Iyy_*, cluster(net_id)
test lcom_ttime=lboz_ttime
quietly estadd scalar p_diff1 = r(p)
test lcom_ttime=lmod_ttime
quietly estadd scalar p_diff2 = r(p)
test lboz_ttime lmod_ttime lnmb_ttime 	
quietly estadd scalar p_joint = r(p)
quietly eststo: reg zmanagement 	lcom_ttime  								  $geo_minA $geo_reg oo_* compe miss_compe *lbed $spec $noise _Icty* _Iyy_*, cluster(net_id)

** table
esttab, ///
	replace ///
	nodepvar nomtitles ///
	keep(lany_ttime lcom_ttime llib_ttime lcrs_ttime lboz_ttime lmod_ttime lnmb_ttime) ///	
	order(lany_ttime lcom_ttime llib_ttime lcrs_ttime lboz_ttime lmod_ttime lnmb_ttime) ///	
	collabels(none) ///
	nogap ///
	cells(b(star fmt(3)) se(par fmt(3))) starlevels( * 0.10 ** 0.05 *** 0.01) ///
	stats(N N_clust p_diff0 p_diff1 p_diff2 p_joint0 p_joint r2, fmt(0 0 2 2 2 2 2 2) ///
	labels(`"Observations"' `"No of clusters"' `"Test of Equality: Joint M-B = HUM"' `"Test of Equality: Joint M-B = B, no M"' `"Test of Equality: Joint M-B = M, no B"' `"Test of Joint Sig.: HUM, no M-B-HUM"' `"Test of Joint Sig.: B, M, No B-M"' `"R-squared"')) ///
	indicate("Geographic controls - Regional level = $geo_reg", labels(Y))

**-------------------------------------------------------------------------------**
** Table 5: ROBUSTNESS CHECKS
**-------------------------------------------------------------------------------**
u  analysis\input\wms_hos_anon, replace

** basic set up
quietly cap estimates drop *
xi i.region_survey i.yy i.cty

** regressions (columns 1, 2, 6, 7)
quietly eststo c1: reg zami_rate 	lcom_ttime  $qual 	 $geo_minA $geo_reg  oo_* compe miss_compe *lbed $spec $noise _Icty* _Iyy_*, cluster(net_id)
estadd local fe = "country"
estadd local sample = "WMS"

quietly eststo c2: reg zami_rate 	lcom_ttime    		 $geo_minA $geo_full oo_* compe miss_compe *lbed $spec $noise _Iregion_su* _Iyy_*, cluster(net_id)
estadd local fe = "region"
estadd local sample = "WMS"

quietly eststo c6: reg zmanagement 	lcom_ttime  $qual    $geo_minA $geo_reg  oo_* compe miss_compe *lbed $spec $noise _Icty* _Iyy_*, cluster(net_id)
estadd local fe = "country"
estadd local sample = "WMS"

quietly eststo c7: reg zmanagement 	lcom_ttime   		 $geo_minA $geo_full oo_* compe miss_compe *lbed $spec $noise _Iregion_su*  _Iyy_*, cluster(net_id)
estadd local fe = "region"
estadd local sample = "WMS"

** regressions (columns 3, 4, 5)
u analysis\input\us_sample, replace

quietly eststo c3: xi: reg zami_mort 	lcom_ttime  $hos_us i.hrrcode if out==0 & hrrcode!="", cluster(COUNTY)
estadd local sample = "US AHA"
estadd local fe = "HRR"

quietly eststo c4: xi: reg zami_mort 	lcom_ttime  pct_emp_manuf emp_health_2009 pct_edu_bach lpercap_income pct_unemp_2009 empgrowth $hos_us if out==0 & hrrcode!="", cluster(COUNTY)
estadd local sample = "US AHA"

quietly eststo c5: xi: areg zami_mort 	lcom_ttime $geo_min_us $geo_reg_us $hos_us if net==1, abs(sysid) cluster(sysid)
estadd local fe = "network"
estadd local sample = "US AHA"


** table
set matsize 1000
esttab c1 c2 c3 c4 c5 c6 c7, ///
	keep(lcom_ttime com_lage com_qsdummy lqs_com com_phd pct_emp_manuf emp_health_2009 pct_edu_bach lpercap_income pct_unemp_2009 empgrowth) ///
	order(lcom_ttime com_lage com_qsdummy lqs_com com_phd pct_emp_manuf emp_health_2009 pct_edu_bach lpercap_income pct_unemp_2009 empgrowth) ///
	collabels(none) ///
	nogap ///
	refcat(com_lage "--Measures of University Quality" pct_emp_manuf "--County Level Charateristics", nolabel) ///
	cells(b(star fmt(3)) se(par fmt(3))) starlevels( * 0.10 ** 0.05 *** 0.01) ///
	stats(N N_clust fe sample r2, fmt(0 0 2 2) ///
	labels(`"Observations"' `"No of clusters"' `"Fixed effects"' `"Sample"' `"R-squared"')) ///
	indicate("Noise controls = $spec" "Hospital characteristics = oo_* *lbed compe" "Geographic controls - Regional level = $geo_reg" "Geographic controls - Grid level = $geo_full", labels(Y))

	
**----------------------------------------------------------------------------------------------------**
**                                       APPENDIX FIGURES AND TABLES                                  **
**----------------------------------------------------------------------------------------------------**

**-------------------------------------------------------------------------------**
** TABLE A2: NUMBER OF UNIQUE UNIVERSITIES USED IN EACH COUNTRY    			                       
**-------------------------------------------------------------------------------**
clear matrix
u  analysis\input\wms_hos_anon, replace

foreach var in com mod boz nmb lib any{
bys country: egen no`var'=nvals(`var'_id)
}
collapse no*, by(country)

estpost tabstat nocom noboz nomod nonmb nolib noany, by(country) stats(sum) missing 


**-------------------------------------------------------------------------------**
** FIGURE B1: SHARE OF HOSPITALS MANAGERS WITH A MBA-TYPE COURSE
**-------------------------------------------------------------------------------**
u  analysis\input\wms_hos_anon, replace

* graph
histogram mba_m, w(.10) xtitle(Share of managers with MBA-type courses (.10 bins)) xlabel(0(.2)1, grid) normal normopts(lcolor(black)) fcolor(gs12) lcolor(gs10) graphregion(fcolor(white) lcolor(white))


**-------------------------------------------------------------------------------**
** TABLE B1: DESCRIPTIVE STATISTICS    			                         
**-------------------------------------------------------------------------------**
clear matrix
u  analysis\input\wms_hos_anon, replace
append using analysis\input\us_sample 

** preparing variables
foreach var in n_merpop2005 n_ppppop2005 n_dis_major_river n_dis_ocean n_prec_new n_temp_new n_elev_srtm_pred lnreggdp yearsed highsch college popij temp invdistcoast lnoilpc ethnic hospital_lat hospital_lon popdens {
replace `var'=. if `var'==-99
}

foreach var in pct_emp_manuf emp_health_2009 pct_unemp_2009 empgrowth percap_income pct_edu_bach com_qsdummy com_qs_r com_age com_phd{
replace `var'=. if `var'==-99
}

cap drop estimates*
estpost su popdens ///
	lnreggdp yearsed highsch college popij temp invdistcoast lnoilpc ethnic ///
	n_merpop2005 n_ppppop2005 n_dis_major_river n_dis_ocean n_prec_new n_temp_new n_elev_srtm_pred ///
	pct_emp_manuf emp_health_2009 percap_income pct_unemp_2009 empgrowth pct_edu_bach ///
	com_qsdummy com_qs_r com_age com_phd, detail 
	
** table
esttab, replace ///
	refcat(popdens "--Hospital Geographic Characteristics" lnreggdp "--Hospital Geographic Characteristics - Regional level" n_merpop2005 "--Hospital Geographic Characteristics - Grid level" pct_emp_manuf "--Hospital Geographic Characteristics - US county level" com_qsdummy "--Joint M-B Characteristics - Quality proxies", nolabel) ///
	cells("mean(fmt(2)) p50(label(median) fmt(2)) sd(par) min(fmt(1)) max(fmt(1)) count(fmt(0))") label nonotes nonumber noobs 

**-------------------------------------------------------------------------------**
** Table B2: WITHIN-COUNTRY DIFFERENCE IN LOCATION CHARACTERISTICS OF THE NEAREST
**           JOINT M-B AND STAND-ALONE HUM SCHOOLS TO EACH HOSPITAL
**-------------------------------------------------------------------------------**

** Provided upon request

**-------------------------------------------------------------------------------**
** Table B3: CHARACTERISTICS OF UNIVERSITIES WITH JOINT MEDICAL-BUSINESS COURSES
**-------------------------------------------------------------------------------**

** Provided upon request

**-------------------------------------------------------------------------------**
** Table B4: SHARE OF MBA-TYPE EDUCATION AND DISTANCE TO SCHOOLS
**-------------------------------------------------------------------------------**
u  analysis\input\wms_hos_anon, replace

** basic setup
cap estimates drop *
xi i.region_survey i.yy i.cty
label var lmba_m "Ln(MBA)"

** regressions
quietly eststo: reg lmba_m 	lany_ttime   		 									   		 oo_* compe miss_compe *lbed $spec $noise _Icty* _Iyy_*, cluster(net_id)
quietly eststo: reg lmba_m 	lcom_ttime  llib_ttime	lcrs_ttime 								 oo_* compe miss_compe *lbed $spec $noise _Icty* _Iyy_*, cluster(net_id)
test lcom_ttime=llib_ttime
quietly estadd scalar p_diff0 = r(p)
test lcrs_ttime llib_ttime
quietly estadd scalar p_joint0 = r(p)
quietly eststo: reg lmba_m 	lcom_ttime  llib_ttime	lcrs_ttime 			  $geo_reg $geo_minA oo_* compe miss_compe *lbed $spec $noise _Icty* _Iyy_*, cluster(net_id)
test lcom_ttime=llib_ttime
quietly estadd scalar p_diff0 = r(p)
test lcrs_ttime llib_ttime
quietly estadd scalar p_joint0 = r(p)
quietly eststo: reg lmba_m 	lcom_ttime  lboz_ttime lmod_ttime lnmb_ttime  $geo_reg $geo_minA oo_* compe miss_compe *lbed $spec $noise _Icty* _Iyy_*, cluster(net_id)
test lcom_ttime=lboz_ttime
quietly estadd scalar p_diff1 = r(p)
test lcom_ttime=lmod_ttime
quietly estadd scalar p_diff2 = r(p)
test lboz_ttime lmod_ttime lnmb_ttime 	
quietly estadd scalar p_joint = r(p)
quietly eststo: reg lmba_m 		lcom_ttime  							  $geo_minA $geo_reg oo_* compe miss_compe *lbed $spec $noise _Icty* _Iyy_*, cluster(net_id)

** table
esttab, ///
	keep(lany_ttime lcom_ttime lcrs_ttime llib_ttime lboz_ttime lmod_ttime lnmb_ttime) ///
	order(lany_ttime lcom_ttime lcrs_ttime llib_ttime lboz_ttime lmod_ttime lnmb_ttime) ///
	collabels(none) ///
	nogap ///
	cells(b(star fmt(3)) se(par fmt(3))) starlevels( * 0.10 ** 0.05 *** 0.01) ///
	stats(N N_clust p_diff0 p_diff1 p_diff2 p_joint0 p_joint r2, fmt(0 0 2 2 2 2 2 2) ///
	labels(`"Observations"' `"No of clusters"'`"Test of Equality: Joint M-B = HUM"' `"Test of Equality: Joint M-B = B, no M"' `"Test of Equality: Joint M-B = M, no B"' `"Test of Joint Sig.: HUM, no M-B-HUM"' `"Test of Joint Sig.: B, M, No B-M"' `"R-squared"')) ///
	indicate("Geographic controls - Regional level = $geo_reg", labels(Y))


**-------------------------------------------------------------------------------**
** TABLE B5: THE EFFECTS OF MBA-TRAINED MANAGERS ON HOSPITAL MANAGEMENT
**-------------------------------------------------------------------------------**
clear matrix
u  analysis\input\wms_hos_anon, clear

** basic setup
cap estimates drop *
xi i.region_survey i.yy i.cty

** regressions
quietly eststo iv01: ivreg2 zami_rate (lmba_m =lcom_ttime ) 																$spec $noise _Icty* _Iyy_*, cluster(net_id) first ffirst savefprefix(fiv01`var') rf saverf partial($noise)
estadd local fe = "country"
quietly mat first=e(first)
quietly estadd scalar KP=first[7,1]: fiv01*
quietly est restore fiv01* 
quietly eststo iv2: ivreg2 zami_rate (lmba_m =lcom_ttime ) 										oo_* compe miss_compe *lbed $spec $noise _Icty* _Iyy_*, cluster(net_id) first ffirst savefprefix(fiv2`var') rf saverf partial($noise)
estadd local fe = "country"
quietly mat first=e(first)
quietly estadd scalar KP=first[7,1]: fiv2*
quietly est restore fiv2* 
quietly eststo iv3: ivreg2 zami_rate (lmba_m =lcom_ttime) 				 	$geo_reg $geo_minA 	oo_* compe miss_compe *lbed $spec $noise _Icty* _Iyy_*, cluster(net_id) first ffirst savefprefix(fiv3`var') rf saverf partial($noise)
estadd local fe = "country"
mat first=e(first)
quietly estadd scalar KP=first[7,1]: fiv3*
quietly est restore fiv3* 
quietly eststo iv4: ivreg2 zmanagement (lmba_m =lcom_ttime ) 																$spec $noise _Icty* _Iyy_*, cluster(net_id) first ffirst savefprefix(fiv4`var') rf saverf partial($noise)
estadd local fe = "country"
quietly mat first=e(first)
quietly estadd scalar KP=first[7,1]: fiv4*
quietly est restore fiv4* 
quietly eststo iv5: ivreg2 zmanagement (lmba_m =lcom_ttime ) 									oo_* compe miss_compe *lbed $spec $noise _Icty* _Iyy_*, cluster(net_id) first ffirst savefprefix(fiv5`var') rf saverf partial($noise)
estadd local fe = "country"
quietly mat first=e(first)
quietly estadd scalar KP=first[7,1]: fiv5*
quietly est restore fiv5* 
quietly eststo iv6: ivreg2 zmanagement (lmba_m =lcom_ttime) 				$geo_reg $geo_minA  oo_* compe miss_compe *lbed $spec $noise _Icty* _Iyy_*, cluster(net_id) first ffirst savefprefix(fiv6`var') rf saverf partial($noise)
estadd local fe = "country"
mat first=e(first)
quietly estadd scalar KP=first[7,1]: fiv6*
quietly est restore fiv6* 
quietly eststo iv7: ivreg2 zmanagement (lmba_m =lcom_ttime) llib_ttime  	$geo_reg $geo_minA  oo_* compe miss_compe *lbed $spec $noise _Icty* _Iyy_*, cluster(net_id) first ffirst savefprefix(fiv7`var') rf saverf partial($noise)
mat first=e(first)
quietly estadd scalar KP=first[7,1]: fiv7*
quietly est restore fiv7* 
estadd local placebo = "control"
estadd local fe = "country"
quietly eststo iv8: ivreg2 zmanagement (lmba_m =lcom_ttime llib_ttime) 	   	$geo_reg $geo_minA  oo_* compe miss_compe *lbed $spec $noise _Icty* _Iyy_*, cluster(net_id) first ffirst savefprefix(fiv8`var') rf saverf partial($noise)
mat first=e(first)
quietly estadd scalar KP=first[7,1]: fiv8*
estadd local placebo = "instrument"
estadd local fe = "country"
quietly est restore fiv8* 
quietly eststo iv9: ivreg2 zmanagement (lmba_m =           llib_ttime) 	   	$geo_reg $geo_minA  oo_* compe miss_compe *lbed $spec $noise _Icty* _Iyy_*, cluster(net_id) first ffirst savefprefix(fiv9`var') rf saverf partial($noise)
mat first=e(first)
quietly estadd scalar KP=first[7,1]: fiv9*
quietly est restore fiv9* 
estadd local placebo = "instrument"
estadd local fe = "country"
quietly eststo iv10: ivreg2 zmanagement (lmba_m =lcom_ttime) 				$geo_full $geo_minA  oo_* compe miss_compe *lbed $spec $noise _Iregion_su* _Iyy_*, cluster(net_id) first ffirst savefprefix(fiv10`var') rf saverf partial(_Iregion_su* $noise)
mat first=e(first)
quietly estadd scalar KP=first[7,1]: fiv10*
quietly est restore fiv10* 
estadd local fe = "region"

esttab iv01 iv2 iv3 iv4 iv5 iv6 iv7 iv8 iv9 iv10, replace stats(N N_clust fe KP placebo, fmt(0 0 2 0)) keep(lmba_m) cells(b(star fmt(3)) se(par fmt(3)) p(par fmt(3))) starlevels( * 0.10 ** 0.05 *** 0.01)  nogap
esttab fiv01* fiv2* fiv3* fiv4* fiv5* fiv6* fiv7* fiv8* fiv9* fiv10*, replace stats(N N_clust fe KP placebo, fmt(0 0 2 0 0)) keep(*ttime $geo_reg) cells(b(star fmt(3)) se(par fmt(3)) p(par fmt(3))) starlevels( * 0.10 ** 0.05 *** 0.01)  nogap


**-------------------------------------------------------------------------------**
** FIGURE C1: MANAGEMENT PRACTICES ACROSS COUNTRIES CORRECTED FOR SAMPLING RESPONSE RATES
**-------------------------------------------------------------------------------**
u analysis\input\wms_hos_frame, replace

cap estimates drop *
drop if noteligible==1
tab cty, gen(cc)

gen pprob=.
foreach var in br ca fr ge in it sw uk us{
eststo: dprobit interview *lnreggdp *yearsed *highsch  *popij *temp *invdistcoast *ethnic if cty=="`var'", cluster(hos_id)
predict prob_`var' if cty=="`var'"
replace pprob=prob_`var' if pprob==. & prob_`var'!=.
drop prob_`var'
}

gen w=1/pprob
histogram w
winsor2 w, replace cuts(0 99)
replace country="United States" if cty=="us"
replace country="United Kingdom" if cty=="uk"
lab var management "Management practices score"
gen managementw=management
gen managementr=management
drop if hos_id==.
keep cty managementw managementr hos_id w country
reshape long management, i(cty hos_id w country) j(mgmt) string
replace w=1 if mgmt=="r"
collapse (mean) management [pw=w], by(cty mgmt country)
reshape wide management, i(cty country) j(mgmt) string

lab var managementr "Unweighted management scores"
lab var managementw "Weighted management scores"

graph hbar (mean) managementr managementw, over(country, sort(managementr) descending)  ///
	exclude0 ylab(1.5(.2)3.3) ///
	graphregion(fcolor(white) lcolor(white)) ///
	ytitle("Management practices score") ///
	scheme(s1mono) ///
	blabel(bar, size(small) format(%12.2f) position(outside) color(black)) blabel(total) ///
	legend(order(1 "Unweighted" 2 "Weighted"))

**-------------------------------------------------------------------------------**
** TABLE C2: SAMPLING FRAME CHARACTERISTICS			    				 
**-------------------------------------------------------------------------------**
u analysis\input\wms_hos_frame, replace

foreach var in beds public{
replace `var'=. if `var'_sample!=1
replace `var'=. if `var'==-99
}
gen universe=1
gen eligible=1 if i_response!="" & noteligible!=1
replace beds=. if eligible!=1
replace public=. if eligible!=1

collapse (median) beds (mean) public (sum) universe eligible, by(cty)
foreach var in public{
replace `var'=`var'*100
}

tabstat universe eligible public beds, by(cty)

**-------------------------------------------------------------------------------**
**  TABLE C3: SURVEY RESPONSE RATES
**-------------------------------------------------------------------------------**

*** Panel A
u analysis\input\wms_hos_frame, replace
drop if i_response==""

gen total=1
gen no_interview=(interview==1)

collapse (mean) interview scheduling refused noteligible (sum) total no_interview, by(cty)
foreach var in interview scheduling refused noteligible{
replace `var'=`var'*100
replace `var'=round(`var',.01)
}

tabstat interview scheduling refused noteligible total no_interview, by(cty)
		
*** Panel B
u analysis\input\selection, replace
drop if i_response==""

gen total=1
gen no_interview=(interview==1)

drop if i_response==""| i_response=="Not Eligible"

collapse (mean) interview scheduling refused (sum) total no_interview, by(cty)
foreach var in interview scheduling refused{
replace `var'=`var'*100
replace `var'=round(`var',.01)
}
tabstat interview scheduling refused total no_interview, by(cty)


**-------------------------------------------------------------------------------**
** TABLE C4: SELECTION ANALYSIS
**-------------------------------------------------------------------------------**
	
u analysis\input\wms_hos_frame, replace

tab cty, gen(cc)

* For all
cap estimates drop *
drop if noteligible==1

label var interview "Interview"
* By Country
cap estimates drop *
eststo: dprobit interview 									  *lnreggdp *yearsed *highsch *popij *temp *invdistcoast *ethnic cc*, cluster(hos_id)
estadd local country = "ALL"
eststo: dprobit interview 				   public miss_public *lnreggdp *yearsed *highsch *popij *temp *invdistcoast *ethnic if cty=="br", cluster(hos_id)
estadd local country = "BR"
eststo: dprobit interview lbeds miss_lbeds public miss_public *lnreggdp *yearsed *highsch *popij *temp *invdistcoast *ethnic if cty=="ca", cluster(hos_id)
estadd local country = "CA"
eststo: dprobit interview lbeds miss_lbeds 					  *lnreggdp *yearsed *highsch *popij *temp *invdistcoast *ethnic if cty=="ge", cluster(hos_id)
estadd local country = "DE"
eststo: dprobit interview lbeds miss_lbeds public miss_public *lnreggdp *yearsed *highsch *popij *temp *invdistcoast *ethnic if cty=="fr", cluster(hos_id)
estadd local country = "FR"
eststo: dprobit interview  									  *lnreggdp *yearsed *highsch *popij *temp *invdistcoast *ethnic if cty=="in", cluster(hos_id)
estadd local country = "IN"
eststo: dprobit interview lbeds miss_lbeds  				  *lnreggdp *yearsed *highsch *popij *temp *invdistcoast *ethnic if cty=="it", cluster(hos_id)
estadd local country = "IT"
eststo: dprobit interview lbeds miss_lbeds 					  *lnreggdp *yearsed *highsch *popij *temp *invdistcoast *ethnic if cty=="sw", cluster(hos_id)
estadd local country = "SW"
eststo: dprobit interview lbeds miss_lbeds public miss_public *lnreggdp *yearsed *highsch *popij *temp *invdistcoast *ethnic if cty=="uk", cluster(hos_id)
estadd local country = "UK"
eststo: dprobit interview lbeds miss_lbeds public miss_public *lnreggdp *yearsed *highsch *popij *temp *invdistcoast *ethnic if cty=="us", cluster(hos_id)
estadd local country = "US"

** table
esttab, ///
	label replace ///
	keep(lnreggdp popij yearsed highsch temp invdistcoast ethnic public lbeds ) ///
	order(lnreggdp popij yearsed highsch temp invdistcoast ethnic public lbeds ) ///
	collabels(none) ///
	nogap ///
	cells(b(star fmt(3)) se(par fmt(3))) starlevels( * 0.10 ** 0.05 *** 0.01) ///
	stats(N country, fmt(%9.0f %9.0g) ///
	labels(`"Observations"' `"Sample"'))
