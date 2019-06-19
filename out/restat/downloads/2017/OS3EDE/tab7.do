***** Table 7 *****
use lps.dta, clear

***** Panel A *****

global X="i.xtile_appraisal_amt fico_orig fulldoc pp_pen ltv_ratio ltv_ratio_sq mtmltv mtmltv_sq cur_int_rate i.fyr i.state i.duemth i.xtile_prop_inc2004 i.p_ue_pre i.p_ue_post"

foreach n of numlist 30 60 90 120 {
  	qui summ def`n' if agegrp==1 & appraisal_amt!=. & fico_orig!=. & & fulldoc!=. & pp_pen!=. & ltv_ratio!=. & cur_int_rate!=. & duemth!=. & fyr!=.
  	global x1_def`n'=round(r(mean),.0001)
  	global se1_def`n'=round(r(sd)/sqrt(r(N)),.0001)
  qui xi: logit def`n' $X i.agegrp, r
    foreach c of numlist 2/4 {
	   qui margins, dydx(_Iagegrp_`c')
		matrix mfx`c'=r(b)
		matrix semfx`c'=r(V)
		global x`c'_def`n'=round(mfx`c'[1,1],.0001)
		global se`c'_def`n'=round(sqrt(semfx`c'[1,1]),.0001)
		}
	 di "def`n'" _col(15) ${x1_def`n'} _col(23) ${x2_def`n'} _col(31) ${x3_def`n'} _col(39) ${x4_def`n'}
	 di _col(15) "(${se1_def`n'})" _col(23) "(${se2_def`n'})" _col(31) "(${se3_def`n'})" _col(39) "(${se4_def`n'})"
  }



***** Panel B *****
global X="i.xtile_appraisal_amt fico_orig fulldoc pp_pen ltv_ratio ltv_ratio_sq mtmltv mtmltv_sq cur_int_rate i.fyr i.state i.duemth i.xtile_prop_inc2004 i.p_ue_pre i.p_ue_post"
foreach n of numlist 30 60 90 120 {
  	qui summ def`n' if agegrp==1 & appraisal_amt!=. & fico_orig!=. & & fulldoc!=. & pp_pen!=. & ltv_ratio!=. & cur_int_rate!=. & duemth!=. & fyr!=.
  	global x1_def`n'=round(r(mean),.0001)
  	global se1_def`n'=round(r(sd)/sqrt(r(N)),.0001)
  qui xi: logit def`n' $X i.agegrp, r
    foreach c of numlist 2/4 {
	   qui margins, dydx(_Iagegrp_`c')
		matrix mfx`c'=r(b)
		matrix semfx`c'=r(V)
		global x`c'_def`n'=round(mfx`c'[1,1],.0001)
		global se`c'_def`n'=round(sqrt(semfx`c'[1,1]),.0001)
		}
	 di "def`n'" _col(15) ${x1_def`n'} _col(23) ${x2_def`n'} _col(31) ${x3_def`n'} _col(39) ${x4_def`n'}
	 di _col(15) "(${se1_def`n'})" _col(23) "(${se2_def`n'})" _col(31) "(${se3_def`n'})" _col(39) "(${se4_def`n'})"
  }
