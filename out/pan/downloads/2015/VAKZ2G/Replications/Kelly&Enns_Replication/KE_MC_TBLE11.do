cd "dir"
use "dir/KE_rep.dta", clear
 global nobs = 55
 global nmc = 10000
 set seed 5000
 set obs $nobs
 tsset year
 
 * Set the values of the parameters
 scalar ecmsig = -1.645
 scalar ecmMCVm1 = -3.822
 scalar ecmMCVm2 = -3.570
 scalar ecmMCVm3 = -4.040
 scalar ecmMCVm4 = -3.621
 scalar up = 1.96
 scalar lp = -1.96
 scalar alpha = .05
 
 *Set values for Dem bounds
 scalar a = 1.5
 scalar b = 1.5
 scalar tau = 59
 scalar k = 16.5
 
 * Generating starting values for DV
 gen dv1 = (59-50)*runiform()+50
 gen dv2 = (99-1)*runiform()+1

* generating errors
 gen e = .
  
 tempname sim

 postfile `sim' m1a1 m1sea1 m1ta1 m1b0 m1se0 m1tb0 m1b1 m1se1 m1tb1 m1b2 m1se2 m1tb2 m1b3 m1se3 m1tb3 m1b4 m1se4 m1tb4 m1b5 m1se5 m1tb5 m1asig m1asigMCV m1dxsig m1xlsig /// 
 	m1dxecm m1dxecmMCV m1lxecm m1lxecmMCV    m2a1 m2sea1 m2ta1 m2b0 m2se0 m2tb0 m2b1 m2se1 m2tb1 m2b2 m2se2 m2tb2 m2b3 m2se3 m2tb3 m2asig m2asigMCV m2dxsig m2xlsig ///
 	m2dxecm m2dxecmMCV m2lxecm m2lxecmMCV	m3a1 m3sea1 m3ta1 m3b0 m3se0 m3tb0 m3b1 m3se1 m3tb1 m3b2 m3se2 m3tb2 m3b3 m3se3 m3tb3 m3b4 m3se4 m3tb4 m3b5 m3se5 m3tb5 ///
 	m3b6 m3se6 m3tb6 m3b7 m3se7 m3tb7 m3asig m3asigMCV m3dxsig m3xlsig m3dxecm m3dxecmMCV m3lxecm m3lxecmMCV  	 ///
 	m4a1 m4sea1 m4ta1 m4b0 m4se0 m4tb0 m4b1 m4se1 m4tb1 m4b2 m4se2 m4tb2 m4b3 m4se3 m4tb3 m4asig m4asigMCV m4dxsig m4xlsig ///
 	m4dxecm m4dxecmMCV m4lxecm m4lxecmMCV   using KE_MC_TBLE11, replace     
 
 quietly {
 forvalues i = 1/$nmc {
 replace e = rnormal()

 
 replace dv1 = l.dv1 + exp(-k)*(exp((-a)*(l.dv1 - tau)) - (exp((b)*(l.dv1 - tau)))) + e in 2/$nobs
 replace dv2 = l.dv2 + e in 2/$nobs	
 
 * Model 1 *
 reg d.dv1 l.dv1 d.policy l.policy d.unemployment l.unemployment d.inflation l.inflation

  * Model 1 coefficient values
 scalar m1a1 = _b[l.dv1]
 scalar m1b0 = _b[d.policy]
 scalar m1b1 = _b[l.policy]
 scalar m1b2 = _b[d.unemployment]
 scalar m1b3 = _b[l.unemployment]
 scalar m1b4 = _b[d.inflation]
 scalar m1b5 = _b[l.inflation]
 * Model 1 standard errors
 scalar m1sea1 = _se[l.dv1]
 scalar m1se0 = _se[d.policy]
 scalar m1se1 = _se[l.policy]
 scalar m1se2 = _se[d.unemployment]
 scalar m1se3 = _se[l.unemployment]
 scalar m1se4 = _se[d.inflation]
 scalar m1se5 = _se[l.inflation]
 * Model 1 t-statistics
 scalar m1ta1 = m1a1/m1sea1
 scalar m1tb0 = m1b0/m1se0
 scalar m1tb1 = m1b1/m1se1
 scalar m1tb2 = m1b2/m1se2
 scalar m1tb3 = m1b3/m1se3
 scalar m1tb4 = m1b4/m1se4
 scalar m1tb5 = m1b5/m1se5
 
 * Model 2 *
 reg d.dv1 l.dv1 d.policy l.policy d.gini l.gini

 * Model 2 coefficient values
 scalar m2a1 = _b[l.dv1]
 scalar m2b0 = _b[d.policy]
 scalar m2b1 = _b[l.policy]
 scalar m2b2 = _b[d.gini]
 scalar m2b3 = _b[l.gini]
 * Model 2 standard errors
 scalar m2sea1 = _se[l.dv1]
 scalar m2se0 = _se[d.policy]
 scalar m2se1 = _se[l.policy]
 scalar m2se2 = _se[d.gini]
 scalar m2se3 = _se[l.gini]
 * Model 2 t-statistics
 scalar m2ta1 = m2a1/m2sea1
 scalar m2tb0 = m2b0/m2se0
 scalar m2tb1 = m2b1/m2se1
 scalar m2tb2 = m2b2/m2se2
 scalar m2tb3 = m2b3/m2se3
 
 * Model 3 *
 reg d.dv1 l.dv1 d.policy l.policy d.gini l.gini d.unemployment l.unemployment d.inflation l.inflation

  * Model 3 coefficient values
 scalar m3a1 = _b[l.dv1]
 scalar m3b0 = _b[d.policy]
 scalar m3b1 = _b[l.policy]
 scalar m3b2 = _b[d.gini]
 scalar m3b3 = _b[l.gini]
 scalar m3b4 = _b[d.unemployment]
 scalar m3b5 = _b[l.unemployment]
 scalar m3b6 = _b[d.inflation]
 scalar m3b7 = _b[l.inflation]
 * Model 3 standard errors
 scalar m3sea1 = _se[l.dv1]
 scalar m3se0 = _se[d.policy]
 scalar m3se1 = _se[l.policy]
 scalar m3se2 = _se[d.gini]
 scalar m3se3 = _se[l.gini]
 scalar m3se4 = _se[d.unemployment]
 scalar m3se5 = _se[l.unemployment]
 scalar m3se6 = _se[d.inflation]
 scalar m3se7 = _se[l.inflation]
 * Model 3 t-statistics
 scalar m3ta1 = m3a1/m3sea1
 scalar m3tb0 = m3b0/m3se0
 scalar m3tb1 = m3b1/m3se1
 scalar m3tb2 = m3b2/m3se2
 scalar m3tb3 = m3b3/m3se3
 scalar m3tb4 = m3b4/m3se4
 scalar m3tb5 = m3b5/m3se5
 scalar m3tb6 = m3b6/m3se6
 scalar m3tb7 = m3b7/m3se7
 
 * Model 4 *
 reg d.dv2 l.dv2 d.policy l.policy d.gini l.gini if year>1972

 * Model 4 coefficient values
 scalar m4a1 = _b[l.dv2]
 scalar m4b0 = _b[d.policy]
 scalar m4b1 = _b[l.policy]
 scalar m4b2 = _b[d.gini]
 scalar m4b3 = _b[l.gini]
 * Model 4 standard errors
 scalar m4sea1 = _se[l.dv2]
 scalar m4se0 = _se[d.policy]
 scalar m4se1 = _se[l.policy]
 scalar m4se2 = _se[d.gini]
 scalar m4se3 = _se[l.gini]
 * Model 4 t-statistics
 scalar m4ta1 = m4a1/m4sea1
 scalar m4tb0 = m4b0/m4se0
 scalar m4tb1 = m4b1/m4se1
 scalar m4tb2 = m4b2/m4se2
 scalar m4tb3 = m4b3/m4se3
  
  * Calculating significance totals (Model 1)
 scalar m1asig = m1ta1<ecmsig
 scalar m1asigMCV = m1ta1<ecmMCVm1
 scalar m1dxsig = (m1tb0>up | m1tb0<lp) | (m1tb2>up | m1tb2<lp) | (m1tb4>up | m1tb4<lp) 
 scalar m1xlsig = (m1tb1>up | m1tb1<lp) | (m1tb3>up | m1tb3<lp) | (m1tb5>up | m1tb5<lp) 
 scalar m1dxecm = (m1ta1<ecmsig & (m1tb0>up | m1tb0<lp)) | (m1ta1<ecmsig & (m1tb2>up | m1tb2<lp)) | (m1ta1<ecmsig & (m1tb4>up | m1tb4<lp)) 
 scalar m1dxecmMCV = (m1ta1<ecmMCVm1 & (m1tb0>up | m1tb0<lp)) | (m1ta1<ecmMCVm1 & (m1tb2>up | m1tb2<lp)) | (m1ta1<ecmMCVm1 & (m1tb4>up | m1tb4<lp))
 scalar m1lxecm = (m1ta1<ecmsig & (m1tb1>up | m1tb1<lp)) | (m1ta1<ecmsig & (m1tb3>up | m1tb3<lp)) | (m1ta1<ecmsig & (m1tb5>up | m1tb5<lp))
 scalar m1lxecmMCV = (m1ta1<ecmMCVm1 & (m1tb1>up | m1tb1<lp)) | (m1ta1<ecmMCVm1 & (m1tb3>up | m1tb3<lp)) | (m1ta1<ecmMCVm1 & (m1tb5>up | m1tb5<lp))

 * Calculating significance totals (Model 2)
 scalar m2asig = m2ta1<ecmsig
 scalar m2asigMCV = m2ta1<ecmMCVm2
 scalar m2dxsig = (m2tb0>up | m2tb0<lp) | (m2tb2>up | m2tb2<lp)  
 scalar m2xlsig = (m2tb1>up | m2tb1<lp) | (m2tb3>up | m2tb3<lp) 
 scalar m2dxecm = (m2ta1<ecmsig & (m2tb0>up | m2tb0<lp)) | (m2ta1<ecmsig & (m2tb2>up | m2tb2<lp)) 
 scalar m2dxecmMCV = (m2ta1<ecmMCVm2 & (m2tb0>up | m2tb0<lp)) | (m2ta1<ecmMCVm2 & (m2tb2>up | m2tb2<lp)) 
 scalar m2lxecm = (m2ta1<ecmsig & (m2tb1>up | m2tb1<lp)) | (m2ta1<ecmsig & (m2tb3>up | m2tb3<lp))
 scalar m2lxecmMCV = (m2ta1<ecmMCVm2 & (m2tb1>up | m2tb1<lp)) | (m2ta1<ecmMCVm2 & (m2tb3>up | m2tb3<lp)) 

 * Calculating significance totals (Model 3)
 scalar m3asig = m3ta1<ecmsig
 scalar m3asigMCV = m3ta1<ecmMCVm3
 scalar m3dxsig = (m3tb0>up | m3tb0<lp) | (m3tb2>up | m3tb2<lp) | (m3tb4>up | m3tb4<lp) | (m3tb6>up | m3tb6<lp)
 scalar m3xlsig = (m3tb1>up | m3tb1<lp) | (m3tb3>up | m3tb3<lp) | (m3tb5>up | m3tb5<lp) | (m3tb7>up | m3tb7<lp) 
 scalar m3dxecm = (m3ta1<ecmsig & (m3tb0>up | m3tb0<lp)) | (m3ta1<ecmsig & (m3tb2>up | m3tb2<lp)) | (m3ta1<ecmsig & (m3tb4>up | m3tb4<lp)) | (m3ta1<ecmsig & (m3tb6>up | m3tb6<lp))
 scalar m3dxecmMCV = (m3ta1<ecmMCVm3 & (m3tb0>up | m3tb0<lp)) | (m3ta1<ecmMCVm3 & (m3tb2>up | m3tb2<lp)) | (m3ta1<ecmMCVm3 & (m3tb4>up | m3tb4<lp)) | (m3ta1<ecmMCVm3 & (m3tb6>up | m3tb6<lp))
 scalar m3lxecm = (m3ta1<ecmsig & (m3tb1>up | m3tb1<lp)) | (m3ta1<ecmsig & (m3tb3>up | m3tb3<lp)) | (m3ta1<ecmsig & (m3tb5>up | m3tb5<lp)) | (m3ta1<ecmsig & (m3tb7>up | m3tb7<lp))
 scalar m3lxecmMCV = (m3ta1<ecmMCVm3 & (m3tb1>up | m3tb1<lp)) | (m3ta1<ecmMCVm3 & (m3tb3>up | m3tb3<lp)) | (m3ta1<ecmMCVm3 & (m3tb5>up | m3tb5<lp)) | (m3ta1<ecmMCVm3 & (m3tb7>up | m3tb7<lp))
 
 * Calculating significance totals (Model 2)
 scalar m4asig = m4ta1<ecmsig
 scalar m4asigMCV = m4ta1<ecmMCVm4
 scalar m4dxsig = (m4tb0>up | m4tb0<lp) | (m4tb2>up | m4tb2<lp)  
 scalar m4xlsig = (m4tb1>up | m4tb1<lp) | (m4tb3>up | m4tb3<lp) 
 scalar m4dxecm = (m4ta1<ecmsig & (m4tb0>up | m4tb0<lp)) | (m4ta1<ecmsig & (m4tb2>up | m4tb2<lp)) 
 scalar m4dxecmMCV = (m4ta1<ecmMCVm4 & (m4tb0>up | m4tb0<lp)) | (m4ta1<ecmMCVm4 & (m4tb2>up | m4tb2<lp)) 
 scalar m4lxecm = (m4ta1<ecmsig & (m4tb1>up | m4tb1<lp)) | (m4ta1<ecmsig & (m4tb3>up | m4tb3<lp))
 scalar m4lxecmMCV = (m4ta1<ecmMCVm4 & (m4tb1>up | m4tb1<lp)) | (m4ta1<ecmMCVm4 & (m4tb3>up | m4tb3<lp)) 
 
 post `sim' (m1a1) (m1sea1) (m1ta1) (m1b0) (m1se0) (m1tb0) (m1b1) (m1se1) (m1tb1) (m1b2) (m1se2) (m1tb2) (m1b3) (m1se3) (m1tb3) (m1b4) (m1se4) (m1tb4) (m1b5) (m1se5) (m1tb5) ///
 		(m1asig) (m1asigMCV) (m1dxsig) (m1xlsig) (m1dxecm) (m1dxecmMCV) (m1lxecm) (m1lxecmMCV) ///
 		 (m2a1) (m2sea1) (m2ta1) (m2b0) (m2se0) (m2tb0) (m2b1) (m2se1) (m2tb1) (m2b2) (m2se2) (m2tb2) (m2b3) (m2se3) (m2tb3) (m2asig) (m2asigMCV) (m2dxsig) (m2xlsig) ///
 		  (m2dxecm) (m2dxecmMCV) (m2lxecm) (m2lxecmMCV)  ///
      (m3a1) (m3sea1) (m3ta1) (m3b0) (m3se0) (m3tb0) (m3b1) (m3se1) (m3tb1) (m3b2) (m3se2) (m3tb2) (m3b3) (m3se3) (m3tb3) (m3b4) (m3se4) (m3tb4) (m3b5) (m3se5) (m3tb5) ///
 			(m3b6) (m3se6) (m3tb6) (m3b7) (m3se7) (m3tb7) (m3asig) (m3asigMCV) (m3dxsig) (m3xlsig) (m3dxecm) (m3dxecmMCV) (m3lxecm) (m3lxecmMCV)  ///
 			(m4a1) (m4sea1) (m4ta1) (m4b0) (m4se0) (m4tb0) (m4b1) (m4se1) (m4tb1) (m4b2) (m4se2) (m4tb2) (m4b3) (m4se3) (m4tb3) (m4asig) (m4asigMCV) (m4dxsig) (m4xlsig) ///
 		  (m4dxecm) (m4dxecmMCV) (m4lxecm) (m4lxecmMCV)
 }
 }
 postclose `sim'

 use KE_MC_TBLE11, clear

 sum m1asig m1asigMCV m1a1 m1dxsig m1xlsig m1dxecm m1dxecmMCV m1lxecm m1lxecmMCV if m1a1 > -1
 
 sum m2asig m2asigMCV m2a1 m2dxsig m2xlsig m2dxecm m2dxecmMCV m2lxecm m2lxecmMCV if m2a1 > -1
 
 sum m3asig m3asigMCV m3a1 m3dxsig m3xlsig m3dxecm m3dxecmMCV m3lxecm m3lxecmMCV if m3a1 > -1
 
 sum m4asig m4asigMCV m4a1 m4dxsig m4xlsig m4dxecm m4dxecmMCV m4lxecm m4lxecmMCV
 
 
  
