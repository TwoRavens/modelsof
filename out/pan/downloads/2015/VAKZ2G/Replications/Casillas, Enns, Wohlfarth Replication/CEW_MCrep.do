cd "dir:"
use "dir/CEW_rep.dta", clear

 global nobs = 46
 global nmc = 10000
 set seed 5000
 set obs $nobs
 tsset term
 
 * Set the values of the parameters
 scalar ecmsig = -1.645
 scalar ecmMCVm1 = -3.838
 scalar ecmMCVm2 = -3.838
 scalar ecmMCVm3 = -3.838
 scalar up = 1.96
 scalar lp = -1.96
 scalar alpha = .05

 * Generating random starting values for DV
 gen iv1 = (99-1)*runiform()+1
 gen iv2 = (99-1)*runiform()+1
 gen iv3 = (99-1)*runiform()+1

* generating errors
 gen e = .
 gen u = .
 gen v = .

 tempname sim

 postfile `sim'   m1a1 m1sea1 m1ta1 m1b0 m1se0 m1tb0 m1b1 m1se1 m1tb1 m1b2 m1se2 m1tb2 m1b3 m1se3 m1tb3 m1b4 m1se4 m1tb4 m1b5 m1se5 m1tb5 m1asig m1asigMCV m1dxsig m1xlsig ///
 	m1dxecm m1dxecmMCV m1lxecm m1lxecmMCV ///
 	   m2a1 m2sea1 m2ta1 m2b0 m2se0 m2tb0 m2b1 m2se1 m2tb1 m2b2 m2se2 m2tb2 m2b3 m2se3 m2tb3 m2b4 m2se4 m2tb4 m2b5 m2se5 m2tb5 m2asig m2asigMCV m2dxsig m2xlsig ///
 	m2dxecm m2dxecmMCV m2lxecm m2lxecmMCV	/// 
 	   m3a1 m3sea1 m3ta1 m3b0 m3se0 m3tb0 m3b1 m3se1 m3tb1 m3b2 m3se2 m3tb2 m3b3 m3se3 m3tb3 m3b4 m3se4 m3tb4 m3b5 m3se5 m3tb5 m3asig m3asigMCV m3dxsig m3xlsig ///
 	m3dxecm m3dxecmMCV m3lxecm m3lxecmMCV   using casillas_results_mackinnon_m1-m3, replace     
 
 quietly {
 forvalues i = 1/$nmc {
 replace e = rnormal()
 replace u = rnormal()
 replace v = rnormal()

 replace iv1 = l.iv1 + e in 2/$nobs
 replace iv2 = l.iv2 + u in 2/$nobs
 replace iv3 = l.iv3 + v in 2/$nobs
 
 * Model 1 *
 ivregress 2sls d.all_rev l.all_rev d.iv1 l.iv1 d.iv2 l.iv2 (d.iv3 l.iv3 = d.perchcpi d.unem d.policylib d.def_budg d.homicide d.inequality l.perchcpi l.unem l.policylib l.def_budg l.homicide l.inequality)

 * Model 1 coefficient values
 scalar m1a1 = _b[l.all_rev]
 scalar m1b0 = _b[d.iv1]
 scalar m1b1 = _b[l.iv1]
 scalar m1b2 = _b[d.iv2]
 scalar m1b3 = _b[l.iv2]
 scalar m1b4 = _b[d.iv3]
 scalar m1b5 = _b[l.iv3]
 * Model 1 standard errors
 scalar m1sea1 = _se[l.all_rev]
 scalar m1se0 = _se[d.iv1]
 scalar m1se1 = _se[l.iv1]
 scalar m1se2 = _se[d.iv2]
 scalar m1se3 = _se[l.iv2]
 scalar m1se4 = _se[d.iv3]
 scalar m1se5 = _se[l.iv3]
 * Model 1 t-statistics
 scalar m1ta1 = m1a1/m1sea1
 scalar m1tb0 = m1b0/m1se0
 scalar m1tb1 = m1b1/m1se1
 scalar m1tb2 = m1b2/m1se2
 scalar m1tb3 = m1b3/m1se3
 scalar m1tb4 = m1b4/m1se4
 scalar m1tb5 = m1b5/m1se5

 * Model 2 *
 ivregress 2sls d.sal_rev l.sal_rev d.iv1 l.iv1 d.iv2 l.iv2 (d.iv3 l.iv3 = d.perchcpi d.unem d.policylib d.def_budg d.homicide d.inequality l.perchcpi l.unem l.policylib l.def_budg l.homicide l.inequality)
 
 * Model 2 coefficient values
 scalar m2a1 = _b[l.sal_rev]
 scalar m2b0 = _b[d.iv1]
 scalar m2b1 = _b[l.iv1]
 scalar m2b2 = _b[d.iv2]
 scalar m2b3 = _b[l.iv2]
 scalar m2b4 = _b[d.iv3]
 scalar m2b5 = _b[l.iv3]
 * Model 2 standard errors
 scalar m2sea1 = _se[l.sal_rev]
 scalar m2se0 = _se[d.iv1]
 scalar m2se1 = _se[l.iv1]
 scalar m2se2 = _se[d.iv2]
 scalar m2se3 = _se[l.iv2]
 scalar m2se4 = _se[d.iv3]
 scalar m2se5 = _se[l.iv3]
 * Model 2 t-statistics
 scalar m2ta1 = m2a1/m2sea1
 scalar m2tb0 = m2b0/m2se0
 scalar m2tb1 = m2b1/m2se1
 scalar m2tb2 = m2b2/m2se2
 scalar m2tb3 = m2b3/m2se3
 scalar m2tb4 = m2b4/m2se4
 scalar m2tb5 = m2b5/m2se5
 
 * Model 3 *
 ivregress 2sls d.nosal_rev l.nosal_rev d.iv1 l.iv1 d.iv2 l.iv2 (d.iv3 l.iv3 = d.perchcpi d.unem d.policylib d.def_budg d.homicide d.inequality l.perchcpi l.unem l.policylib l.def_budg l.homicide l.inequality)

 * Model 1 coefficient values
 scalar m3a1 = _b[l.nosal_rev]
 scalar m3b0 = _b[d.iv1]
 scalar m3b1 = _b[l.iv1]
 scalar m3b2 = _b[d.iv2]
 scalar m3b3 = _b[l.iv2]
 scalar m3b4 = _b[d.iv3]
 scalar m3b5 = _b[l.iv3]
 * Model 1 standard errors
 scalar m3sea1 = _se[l.nosal_rev]
 scalar m3se0 = _se[d.iv1]
 scalar m3se1 = _se[l.iv1]
 scalar m3se2 = _se[d.iv2]
 scalar m3se3 = _se[l.iv2]
 scalar m3se4 = _se[d.iv3]
 scalar m3se5 = _se[l.iv3]
 * Model 1 t-statistics
 scalar m3ta1 = m3a1/m3sea1
 scalar m3tb0 = m3b0/m3se0
 scalar m3tb1 = m3b1/m3se1
 scalar m3tb2 = m3b2/m3se2
 scalar m3tb3 = m3b3/m3se3
 scalar m3tb4 = m3b4/m3se4
 scalar m3tb5 = m3b5/m3se5


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
 scalar m2dxsig = (m2tb0>up | m2tb0<lp) | (m2tb2>up | m2tb2<lp) | (m2tb4>up | m2tb4<lp)  
 scalar m2xlsig = (m2tb1>up | m2tb1<lp) | (m2tb3>up | m2tb3<lp) | (m2tb5>up | m2tb5<lp)
 scalar m2dxecm = (m2ta1<ecmsig & (m2tb0>up | m2tb0<lp)) | (m2ta1<ecmsig & (m2tb2>up | m2tb2<lp)) | (m2ta1<ecmsig & (m2tb4>up | m2tb4<lp))
 scalar m2dxecmMCV = (m2ta1<ecmMCVm2 & (m2tb0>up | m2tb0<lp)) | (m2ta1<ecmMCVm2 & (m2tb2>up | m2tb2<lp)) | (m2ta1<ecmMCVm2 & (m2tb4>up | m2tb4<lp))
 scalar m2lxecm = (m2ta1<ecmsig & (m2tb1>up | m2tb1<lp)) | (m2ta1<ecmsig & (m2tb3>up | m2tb3<lp)) | (m2ta1<ecmsig & (m2tb5>up | m2tb5<lp))
 scalar m2lxecmMCV = (m2ta1<ecmMCVm2 & (m2tb1>up | m2tb1<lp)) | (m2ta1<ecmMCVm2 & (m2tb3>up | m2tb3<lp)) | (m2ta1<ecmMCVm2 & (m2tb5>up | m2tb5<lp))
 
 * Calculating significance totals (Model 3)
 scalar m3asig = m3ta1<ecmsig
 scalar m3asigMCV = m3ta1<ecmMCVm3
 scalar m3dxsig = (m3tb0>up | m3tb0<lp) | (m3tb2>up | m3tb2<lp) | (m3tb4>up | m3tb4<lp)  
 scalar m3xlsig = (m3tb1>up | m3tb1<lp) | (m3tb3>up | m3tb3<lp) | (m3tb5>up | m3tb5<lp)
 scalar m3dxecm = (m3ta1<ecmsig & (m3tb0>up | m3tb0<lp)) | (m3ta1<ecmsig & (m3tb2>up | m3tb2<lp)) | (m3ta1<ecmsig & (m3tb4>up | m3tb4<lp))
 scalar m3dxecmMCV = (m3ta1<ecmMCVm3 & (m3tb0>up | m3tb0<lp)) | (m3ta1<ecmMCVm3 & (m3tb2>up | m3tb2<lp)) | (m3ta1<ecmMCVm3 & (m3tb4>up | m3tb4<lp))
 scalar m3lxecm = (m3ta1<ecmsig & (m3tb1>up | m3tb1<lp)) | (m3ta1<ecmsig & (m3tb3>up | m3tb3<lp)) | (m3ta1<ecmsig & (m3tb5>up | m3tb5<lp))
 scalar m3lxecmMCV = (m3ta1<ecmMCVm3 & (m3tb1>up | m3tb1<lp)) | (m3ta1<ecmMCVm3 & (m3tb3>up | m3tb3<lp)) | (m3ta1<ecmMCVm3 & (m3tb5>up | m3tb5<lp))
 
 
 post `sim' (m1a1) (m1sea1) (m1ta1) (m1b0) (m1se0) (m1tb0) (m1b1) (m1se1) (m1tb1) (m1b2) (m1se2) (m1tb2) (m1b3) (m1se3) (m1tb3) (m1b4) (m1se4) (m1tb4) (m1b5) (m1se5) (m1tb5) (m1asig) (m1asigMCV) (m1dxsig) (m1xlsig) ///
 		  (m1dxecm) (m1dxecmMCV) (m1lxecm) (m1lxecmMCV)  ///
 		    (m2a1) (m2sea1) (m2ta1) (m2b0) (m2se0) (m2tb0) (m2b1) (m2se1) (m2tb1) (m2b2) (m2se2) (m2tb2) (m2b3) (m2se3) (m2tb3) (m2b4) (m2se4) (m2tb4) (m2b5) (m2se5) (m2tb5) (m2asig) (m2asigMCV) (m2dxsig) (m2xlsig) ///
 		  (m2dxecm) (m2dxecmMCV) (m2lxecm) (m2lxecmMCV) ///
 		    (m3a1) (m3sea1) (m3ta1) (m3b0) (m3se0) (m3tb0) (m3b1) (m3se1) (m3tb1) (m3b2) (m3se2) (m3tb2) (m3b3) (m3se3) (m3tb3) (m3b4) (m3se4) (m3tb4) (m3b5) (m3se5) (m3tb5) (m3asig) (m3asigMCV) (m3dxsig) (m3xlsig) ///
 		  (m3dxecm) (m3dxecmMCV) (m3lxecm) (m3lxecmMCV) 
 }
 }
 postclose `sim'

 use casillas_results_mackinnon_m1-m3, clear

 
 sum m1asig m1asigMCV m1a1 m1dxsig m1xlsig m1dxecm m1dxecmMCV m1lxecm m1lxecmMCV 
 
 sum m2asig m2asigMCV m2a1 m2dxsig m2xlsig m2dxecm m2dxecmMCV m2lxecm m2lxecmMCV
 
 sum m3asig m3asigMCV m3a1 m3dxsig m3xlsig m3dxecm m3dxecmMCV m3lxecm m3lxecmMCV
