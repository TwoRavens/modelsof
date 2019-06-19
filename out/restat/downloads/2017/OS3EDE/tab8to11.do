use cl.dta, clear

***** Table 8 *****
global Xfull="i.xtile_sale_price fico fulldoc pp_pen var_rate i.grp_cltv i.grp_cltv_adj init_rate i.fyr i.state i.duemth i.xtile_prop_inc2004 i.xtile_hpa i.p_ue_pre i.p_ue_post"
global X="i.state i.fyr i.duemth"

***** Panel A *****
foreach n of numlist 30 60 90 120 {
  foreach m of numlist 12 {
    preserve
    qui keep if sale_price!=. & fico!=. & fulldoc!=. & pp_pen!=. & var_rate!=. & cltv!=. & init_rate!=. & fyr!=. & duemth!=. 
	 qui summ def`n'_`m' if agegrp==1
	 global x1_def`n'_`m'=round(r(mean),.0001)
	 global se1_def`n'_`m'=round(r(sd)/sqrt(r(N)),.0001)
	 restore
	 qui xi: logit def`n'_`m' $X i.agegrp, r 
	   foreach c of numlist 2/4 {
		  qui margins, dydx(_Iagegrp_`c')
		  matrix mfx`c'=r(b)
		  matrix semfx`c'=r(V)
		  global x`c'_def`n'_`m'=round(mfx`c'[1,1],.0001)
		  global se`c'_def`n'_`m'=round(sqrt(semfx`c'[1,1]),.0001)
		  }
		di "def`n'_`m'" _col(15) ${x1_def`n'_`m'} _col(23) ${x2_def`n'_`m'} _col(31) ${x3_def`n'_`m'} _col(39) ${x4_def`n'_`m'}
		di _col(15) "(${se1_def`n'_`m'})" _col(23) "(${se2_def`n'_`m'})" _col(31) "(${se3_def`n'_`m'})" _col(39) "(${se4_def`n'_`m'})"
		}
  }
  
***** Panel B *****
foreach n of numlist 30 60 90 120 {
  foreach m of numlist 12 {
    preserve
    qui keep if sale_price!=. & fico!=. & fulldoc!=. & pp_pen!=. & var_rate!=. & cltv!=. & init_rate!=. & fyr!=. & duemth!=. 
	 qui summ def`n'_`m' if agegrp==1
	 global x1_def`n'_`m'=round(r(mean),.0001)
	 global se1_def`n'_`m'=round(r(sd)/sqrt(r(N)),.0001)
	 restore
	 qui xi: logit def`n'_`m' $Xfull i.agegrp, r 
	   foreach c of numlist 2/4 {
		  qui margins, dydx(_Iagegrp_`c')
		  matrix mfx`c'=r(b)
		  matrix semfx`c'=r(V)
		  global x`c'_def`n'_`m'=round(mfx`c'[1,1],.0001)
		  global se`c'_def`n'_`m'=round(sqrt(semfx`c'[1,1]),.0001)
		  }
		di "def`n'_`m'" _col(15) ${x1_def`n'_`m'} _col(23) ${x2_def`n'_`m'} _col(31) ${x3_def`n'_`m'} _col(39) ${x4_def`n'_`m'}
		di _col(15) "(${se1_def`n'_`m'})" _col(23) "(${se2_def`n'_`m'})" _col(31) "(${se3_def`n'_`m'})" _col(39) "(${se4_def`n'_`m'})"
		}
  }
  
***** Table 9 *****
foreach n of numlist 30 60 90 120 {
  foreach m of numlist 12 {
    preserve
    qui keep if sale_price!=. & fico!=. & fulldoc!=. & pp_pen!=. & var_rate!=. & cltv!=. & init_rate!=. & fyr!=. & duemth!=. 
	 qui summ def`n'_`m' if agegrp==1
	 global x1_def`n'_`m'=round(r(mean),.0001)
	 global se1_def`n'_`m'=round(r(sd)/sqrt(r(N)),.0001)
	 restore
	 qui xi: logit def`n'_`m' $Xfull i.agegrp, r 
	   foreach c of numlist 2/4 {
		  qui margins, dydx(_Iagegrp_`c')
		  matrix mfx`c'=r(b)
		  matrix semfx`c'=r(V)
		  global x`c'_def`n'_`m'=round(mfx`c'[1,1],.0001)
		  global se`c'_def`n'_`m'=round(sqrt(semfx`c'[1,1]),.0001)
		  }
      qui margins, dydx(ue_pre ue_post)
		matrix mfxue=r(b)
		matrix seue=r(V)
		global uepre=round(mfxue[1,1],.001)
		global seuepre=round(sqrt(seue[1,1]),.0001)
		global uepost=round(mfxue[1,2],.001)
		global seuepost=round(sqrt(seue[2,2]),.0001)
		di "def`n'_`m'" _col(15) ${x1_def`n'_`m'} _col(23) ${x2_def`n'_`m'} _col(31) ${x3_def`n'_`m'} _col(39) ${x4_def`n'_`m'}
		di _col(15) "(${se1_def`n'_`m'})" _col(23) "(${se2_def`n'_`m'})" _col(31) "(${se3_def`n'_`m'})" _col(39) "(${se4_def`n'_`m'})"
		di "UE Pre" _col(15) $uepre _col(25) "UE Post" _col(35) $uepost
		di _col(15) "($seuepre)" _col(35) "($seuepost)"
		test ue_pre=ue_post
		global sign=sign($uepost-$uepre)
		di "H_0: uepost>=uepre coef. p-value = " 1-normal($sign*sqrt(e(chi2)))
		}
  }
  
***** Table 10 *****
foreach y of varlist def30_2year def60_2year def90_2year deff_2year { 
  qui summ `y' if agegrp==1 
  global x1_`y'=round(r(mean),.0001) 
  global se1_`y'=round(r(sd)/sqrt(r(N)),.0001) 
  qui xi: logit `y' $Xfull i.agegrp, r 
  foreach c of numlist 2/4 { 
    qui margins , dydx(_Iagegrp_`c') 
    matrix mfx`c'=r(b) 
	 matrix semfx`c'=r(V) 
	 global x`c'_`y'=round(mfx`c'[1,1],.0001) 
	 global se`c'_`y'=round(sqrt(semfx`c'[1,1]),.0001) 
	 } 
  di "`y'" _col(15) ${x1_`y'} _col(23) ${x2_`y'} _col(31) ${x3_`y'} _col(39) ${x4_`y'} 
  di _col(15) "(${se1_`y'})" _col(23) "(${se2_`y'})" _col(31) "(${se3_`y'})" _col(39) "(${se4_`y'})" 
  } 
  
***** Table 11 *****
foreach n of numlist 30 60 90 120 {
  foreach m of numlist 12 {
    preserve
    qui keep if sale_price!=. & fico!=. & fulldoc!=. & pp_pen!=. & var_rate!=. & cltv!=. & init_rate!=. & fyr!=. & duemth!=. 
	 qui summ cure`n' if agegrp==1
	 global x1_def`n'_`m'=round(r(mean),.0001)
	 global se1_def`n'_`m'=round(r(sd)/sqrt(r(N)),.0001)
	 restore
	 qui xi: logit cure`n' $Xfull i.agegrp, r
	   foreach c of numlist 2/4 {
		  qui margins, dydx(_Iagegrp_`c')
		  matrix mfx`c'=r(b)
		  matrix semfx`c'=r(V)
		  global x`c'_def`n'_`m'=round(mfx`c'[1,1],.0001)
		  global se`c'_def`n'_`m'=round(sqrt(semfx`c'[1,1]),.0001)
		  }
		di "def`n'_`m'" _col(15) ${x1_def`n'_`m'} _col(23) ${x2_def`n'_`m'} _col(31) ${x3_def`n'_`m'} _col(39) ${x4_def`n'_`m'}
		di _col(15) "(${se1_def`n'_`m'})" _col(23) "(${se2_def`n'_`m'})" _col(31) "(${se3_def`n'_`m'})" _col(39) "(${se4_def`n'_`m'})"
		}
  }
  



