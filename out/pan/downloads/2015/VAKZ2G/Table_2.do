cd "dir:"

/* Original code for Table 2 was run in RATS. 
 Results will closely approximate, but not perfectly match. All conclusions
 drawn are the same
*/

clear 

 global nobs = 60
 global nmc = 10000
 set seed 5000
 set obs $nobs
 gen id = _n
 tsset id
 
 * Set the values of the parameters
 scalar ecmsig = -1.645
 scalar ecmMCVm1 = -3.27
 scalar ecmMCVm2 = -3.565
 scalar ecmMCVm3 = -3.816
 scalar ecmMCVm4 = -4.035
 scalar ecmMCVm5 = -4.229

 scalar up = 1.96
 scalar lp = -1.96
 scalar alpha = .05

 * Generating random starting values for DV
 gen dv1 = 0
 gen iv1 = 0
 gen iv2 = 0
 gen iv3 = 0
 gen iv4 = 0
 gen iv5 = 0
 
 * generating errors
 gen q = .
 gen u = .
 gen e = .
 gen w = .
 gen o = .
 gen v = . 
 
 tempname sim

 postfile `sim' m1a1 m1sea1 m1ta1 m1b0 m1se0 m1tb0 m1b1 m1se1 m1tb1  m1asig m1asigMCV m1dxsig m1xlsig m1dxecm m1dxecmMCV m1lxecm m1lxecmMCV  ///
 			m2a1 m2sea1 m2ta1 m2b0 m2se0 m2tb0 m2b1 m2se1 m2tb1 m2b2 m2se2 m2tb2 m2b3 m2se3 m2tb3 m2asig m2asigMCV m2dxsig m2xlsig ///
 				m2dxecm m2dxecmMCV m2lxecm m2lxecmMCV  ///
 				m3a1 m3sea1 m3ta1 m3b0 m3se0 m3tb0 m3b1 m3se1 m3tb1 m3b2 m3se2 m3tb2 m3b3 m3se3 m3tb3 m3b4 m3se4 m3tb4 m3b5 m3se5 m3tb5 m3asig m3asigMCV m3dxsig m3xlsig /// 
 				m3dxecm m3dxecmMCV m3lxecm m3lxecmMCV /// 
 				m4a1 m4sea1 m4ta1 m4b0 m4se0 m4tb0 m4b1 m4se1 m4tb1 m4b2 m4se2 m4tb2 m4b3 m4se3 m4tb3 m4b4 m4se4 m4tb4 m4b5 m4se5 m4tb5 ///
 				m4b6 m4se6 m4tb6 m4b7 m4se7 m4tb7 m4asig m4asigMCV m4dxsig m4xlsig m4dxecm m4dxecmMCV m4lxecm m4lxecmMCV  /// 
 				m5a1 m5sea1 m5ta1 m5b0 m5se0 m5tb0 m5b1 m5se1 m5tb1 m5b2 m5se2 m5tb2 m5b3 m5se3 m5tb3 m5b4 m5se4 m5tb4 m5b5 m5se5 m5tb5 ///
 				m5b6 m5se6 m5tb6 m5b7 m5se7 m5tb7 m5b8 m5se8 m5tb8 m5b9 m5se9 m5tb9 m5asig m5asigMCV m5dxsig m5xlsig m5dxecm m5dxecmMCV m5lxecm m5lxecmMCV   using MC_TBL2_complete, replace     
 
 quietly {
 forvalues i = 1/$nmc {
 replace q = rnormal()
 replace e = rnormal()
 replace u = rnormal()
 replace w = rnormal()
 replace o = rnormal()
 replace v = rnormal()
 
 replace dv1 = l.dv1 + q in 2/$nobs
 replace iv1 = l.iv1 + u in 2/$nobs
 replace iv2 = l.iv2 + e in 2/$nobs
 replace iv3 = l.iv3 + w in 2/$nobs
 replace iv4 = l.iv4 + o in 2/$nobs
 replace iv5 = l.iv5 + v in 2/$nobs
 
 * Model 1 *
 reg d.dv1 l.dv1 d.iv1 l.iv1
 
 * Model 1 coefficient values
 scalar m1a1 = _b[l.dv1]
 scalar m1b0 = _b[d.iv1]
 scalar m1b1 = _b[l.iv1]

 * Model 1 standard errors
 scalar m1sea1 = _se[l.dv1]
 scalar m1se0 = _se[d.iv1]
 scalar m1se1 = _se[l.iv1]
 
 * Model 1 t-statistics
 scalar m1ta1 = m1a1/m1sea1
 scalar m1tb0 = m1b0/m1se0
 scalar m1tb1 = m1b1/m1se1
 
 
 * Model 2 *
 reg d.dv1 l.dv1 d.iv1 l.iv1 d.iv2 l.iv2
 
 * Model 2 coefficient values
 scalar m2a1 = _b[l.dv1]
 scalar m2b0 = _b[d.iv1]
 scalar m2b1 = _b[l.iv1]
 scalar m2b2 = _b[d.iv2]
 scalar m2b3 = _b[l.iv2]
 * Model 2 standard errors
 scalar m2sea1 = _se[l.dv1]
 scalar m2se0 = _se[d.iv1]
 scalar m2se1 = _se[l.iv1]
 scalar m2se2 = _se[d.iv2]
 scalar m2se3 = _se[l.iv2]
 * Model 2 t-statistics
 scalar m2ta1 = m2a1/m2sea1
 scalar m2tb0 = m2b0/m2se0
 scalar m2tb1 = m2b1/m2se1
 scalar m2tb2 = m2b2/m2se2
 scalar m2tb3 = m2b3/m2se3

 
 * Model 3 *
 reg d.dv1 l.dv1 d.iv1 l.iv1 d.iv2 l.iv2 d.iv3 l.iv3

  * Model 3 coefficient values
 scalar m3a1 = _b[l.dv1]
 scalar m3b0 = _b[d.iv1]
 scalar m3b1 = _b[l.iv1]
 scalar m3b2 = _b[d.iv2]
 scalar m3b3 = _b[l.iv2]
 scalar m3b4 = _b[d.iv3]
 scalar m3b5 = _b[l.iv3]
 * Model 3 standard errors
 scalar m3sea1 = _se[l.dv1]
 scalar m3se0 = _se[d.iv1]
 scalar m3se1 = _se[l.iv1]
 scalar m3se2 = _se[d.iv2]
 scalar m3se3 = _se[l.iv2]
 scalar m3se4 = _se[d.iv3]
 scalar m3se5 = _se[l.iv3]
 * Model 3 t-statistics
 scalar m3ta1 = m3a1/m3sea1
 scalar m3tb0 = m3b0/m3se0
 scalar m3tb1 = m3b1/m3se1
 scalar m3tb2 = m3b2/m3se2
 scalar m3tb3 = m3b3/m3se3
 scalar m3tb4 = m3b4/m3se4
 scalar m3tb5 = m3b5/m3se5
 
 
 * Model 4 *
 reg d.dv1 l.dv1 d.iv1 l.iv1 d.iv2 l.iv2 d.iv3 l.iv3 d.iv4 l.iv4

  * Model 4 coefficient values
 scalar m4a1 = _b[l.dv1]
 scalar m4b0 = _b[d.iv1]
 scalar m4b1 = _b[l.iv1]
 scalar m4b2 = _b[d.iv2]
 scalar m4b3 = _b[l.iv2]
 scalar m4b4 = _b[d.iv3]
 scalar m4b5 = _b[l.iv3]
 scalar m4b6 = _b[d.iv4]
 scalar m4b7 = _b[l.iv4]
 * Model 4 standard errors
 scalar m4sea1 = _se[l.dv1]
 scalar m4se0 = _se[d.iv1]
 scalar m4se1 = _se[l.iv1]
 scalar m4se2 = _se[d.iv2]
 scalar m4se3 = _se[l.iv2]
 scalar m4se4 = _se[d.iv3]
 scalar m4se5 = _se[l.iv3]
 scalar m4se6 = _se[d.iv4]
 scalar m4se7 = _se[l.iv4]
 * Model 4 t-statistics
 scalar m4ta1 = m4a1/m4sea1
 scalar m4tb0 = m4b0/m4se0
 scalar m4tb1 = m4b1/m4se1
 scalar m4tb2 = m4b2/m4se2
 scalar m4tb3 = m4b3/m4se3
 scalar m4tb4 = m4b4/m4se4
 scalar m4tb5 = m4b5/m4se5
 scalar m4tb6 = m4b6/m4se6
 scalar m4tb7 = m4b7/m4se7

 
 * Model 5 *
 reg d.dv1 l.dv1 d.iv1 l.iv1 d.iv2 l.iv2 d.iv3 l.iv3 d.iv4 l.iv4 d.iv5 l.iv5

  * Model 5 coefficient values
 scalar m5a1 = _b[l.dv1]
 scalar m5b0 = _b[d.iv1]
 scalar m5b1 = _b[l.iv1]
 scalar m5b2 = _b[d.iv2]
 scalar m5b3 = _b[l.iv2]
 scalar m5b4 = _b[d.iv3]
 scalar m5b5 = _b[l.iv3]
 scalar m5b6 = _b[d.iv4]
 scalar m5b7 = _b[l.iv4]
 scalar m5b8 = _b[d.iv5]
 scalar m5b9 = _b[l.iv5]
 * Model 5 standard errors
 scalar m5sea1 = _se[l.dv1]
 scalar m5se0 = _se[d.iv1]
 scalar m5se1 = _se[l.iv1]
 scalar m5se2 = _se[d.iv2]
 scalar m5se3 = _se[l.iv2]
 scalar m5se4 = _se[d.iv3]
 scalar m5se5 = _se[l.iv3]
 scalar m5se6 = _se[d.iv4]
 scalar m5se7 = _se[l.iv4]
 scalar m5se8 = _se[d.iv5]
 scalar m5se9 = _se[l.iv5]
 * Model 5 t-statistics
 scalar m5ta1 = m5a1/m5sea1
 scalar m5tb0 = m5b0/m5se0
 scalar m5tb1 = m5b1/m5se1
 scalar m5tb2 = m5b2/m5se2
 scalar m5tb3 = m5b3/m5se3
 scalar m5tb4 = m5b4/m5se4
 scalar m5tb5 = m5b5/m5se5
 scalar m5tb6 = m5b6/m5se6
 scalar m5tb7 = m5b7/m5se7
 scalar m5tb8 = m5b8/m5se8
 scalar m5tb9 = m5b9/m5se9

 * Calculating significance totals (Model 1)
 scalar m1asig = m1ta1<ecmsig
 scalar m1asigMCV = m1ta1<=ecmMCVm1
 scalar m1dxsig = (m1tb0>up | m1tb0<lp) 
 scalar m1xlsig = (m1tb1>up | m1tb1<lp)  
 scalar m1dxecm = (m1ta1<ecmsig & (m1tb0>up | m1tb0<lp)) 
 scalar m1dxecmMCV = (m1ta1<ecmMCVm1 & (m1tb0>up | m1tb0<lp)) 
 scalar m1lxecm = (m1ta1<ecmsig & (m1tb1>up | m1tb1<lp)) 
 scalar m1lxecmMCV = (m1ta1<ecmMCVm1 & (m1tb1>up | m1tb1<lp)) 
 
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
 scalar m3dxsig = (m3tb0>up | m3tb0<lp) | (m3tb2>up | m3tb2<lp) | (m3tb4>up | m3tb4<lp) 
 scalar m3xlsig = (m3tb1>up | m3tb1<lp) | (m3tb3>up | m3tb3<lp) | (m3tb5>up | m3tb5<lp) 
 scalar m3dxecm = (m3ta1<ecmsig & (m3tb0>up | m3tb0<lp)) | (m3ta1<ecmsig & (m3tb2>up | m3tb2<lp)) | (m3ta1<ecmsig & (m3tb4>up | m3tb4<lp)) 
 scalar m3dxecmMCV = (m3ta1<ecmMCVm3 & (m3tb0>up | m3tb0<lp)) | (m3ta1<ecmMCVm3 & (m3tb2>up | m3tb2<lp)) | (m3ta1<ecmMCVm3 & (m3tb4>up | m3tb4<lp))
 scalar m3lxecm = (m3ta1<ecmsig & (m3tb1>up | m3tb1<lp)) | (m3ta1<ecmsig & (m3tb3>up | m3tb3<lp)) | (m3ta1<ecmsig & (m3tb5>up | m3tb5<lp))
 scalar m3lxecmMCV = (m3ta1<ecmMCVm3 & (m3tb1>up | m3tb1<lp)) | (m3ta1<ecmMCVm3 & (m3tb3>up | m3tb3<lp)) | (m3ta1<ecmMCVm3 & (m3tb5>up | m3tb5<lp))
 
 * Calculating significance totals (Model 4)
 scalar m4asig = m4ta1<ecmsig
 scalar m4asigMCV = m4ta1<ecmMCVm4
 scalar m4dxsig = (m4tb0>up | m4tb0<lp) | (m4tb2>up | m4tb2<lp) | (m4tb4>up | m4tb4<lp) | (m4tb6>up | m4tb6<lp)
 scalar m4xlsig = (m4tb1>up | m4tb1<lp) | (m4tb3>up | m4tb3<lp) | (m4tb5>up | m4tb5<lp) | (m4tb7>up | m4tb7<lp) 
 scalar m4dxecm = (m4ta1<ecmsig & (m4tb0>up | m4tb0<lp)) | (m4ta1<ecmsig & (m4tb2>up | m4tb2<lp)) | (m4ta1<ecmsig & (m4tb4>up | m4tb4<lp)) | (m4ta1<ecmsig & (m4tb6>up | m4tb6<lp))
 scalar m4dxecmMCV = (m4ta1<ecmMCVm4 & (m4tb0>up | m4tb0<lp)) | (m4ta1<ecmMCVm4 & (m4tb2>up | m4tb2<lp)) | (m4ta1<ecmMCVm4 & (m4tb4>up | m4tb4<lp)) | (m4ta1<ecmMCVm4 & (m4tb6>up | m4tb6<lp))
 scalar m4lxecm = (m4ta1<ecmsig & (m4tb1>up | m4tb1<lp)) | (m4ta1<ecmsig & (m4tb3>up | m4tb3<lp)) | (m4ta1<ecmsig & (m4tb5>up | m4tb5<lp)) | (m4ta1<ecmsig & (m4tb7>up | m4tb7<lp))
 scalar m4lxecmMCV = (m4ta1<ecmMCVm4 & (m4tb1>up | m4tb1<lp)) | (m4ta1<ecmMCVm4 & (m4tb3>up | m4tb3<lp)) | (m4ta1<ecmMCVm4 & (m4tb5>up | m4tb5<lp)) | (m4ta1<ecmMCVm4 & (m4tb7>up | m4tb7<lp))
 
 * Calculating significance totals (Model 5)
 scalar m5asig = m5ta1<ecmsig
 scalar m5asigMCV = m5ta1<ecmMCVm5
 scalar m5dxsig = (m5tb0>up | m5tb0<lp) | (m5tb2>up | m5tb2<lp) | (m5tb4>up | m5tb4<lp) | (m5tb6>up | m5tb6<lp) | (m5tb8>up | m5tb8<lp)
 scalar m5xlsig = (m5tb1>up | m5tb1<lp) | (m5tb3>up | m5tb3<lp) | (m5tb5>up | m5tb5<lp) | (m5tb7>up | m5tb7<lp) | (m5tb9>up | m5tb9<lp)
 scalar m5dxecm = (m5ta1<ecmsig & (m5tb0>up | m5tb0<lp)) | (m5ta1<ecmsig & (m5tb2>up | m5tb2<lp)) | (m5ta1<ecmsig & (m5tb4>up | m5tb4<lp)) | (m5ta1<ecmsig & (m5tb6>up | m5tb6<lp)) | (m5ta1<ecmsig & (m5tb8>up | m5tb8<lp))
 scalar m5dxecmMCV = (m5ta1<ecmMCVm5 & (m5tb0>up | m5tb0<lp)) | (m5ta1<ecmMCVm5 & (m5tb2>up | m5tb2<lp)) | (m5ta1<ecmMCVm5 & (m5tb4>up | m5tb4<lp)) | (m5ta1<ecmMCVm5 & (m5tb6>up | m5tb6<lp)) | (m5ta1<ecmMCVm5 & (m5tb8>up | m5tb8<lp))
 scalar m5lxecm = (m5ta1<ecmsig & (m5tb1>up | m5tb1<lp)) | (m5ta1<ecmsig & (m5tb3>up | m5tb3<lp)) | (m5ta1<ecmsig & (m5tb5>up | m5tb5<lp)) | (m5ta1<ecmsig & (m5tb7>up | m5tb7<lp)) | (m5ta1<ecmsig & (m5tb9>up | m5tb9<lp))
 scalar m5lxecmMCV = (m5ta1<ecmMCVm5 & (m5tb1>up | m5tb1<lp)) | (m5ta1<ecmMCVm5 & (m5tb3>up | m5tb3<lp)) | (m5ta1<ecmMCVm5 & (m5tb5>up | m5tb5<lp)) | (m5ta1<ecmMCVm5 & (m5tb7>up | m5tb7<lp)) | (m5ta1<ecmMCVm5 & (m5tb9>up | m5tb9<lp))
 
 post `sim' (m1a1) (m1sea1) (m1ta1) (m1b0) (m1se0) (m1tb0) (m1b1) (m1se1) (m1tb1) (m1asig) (m1asigMCV) (m1dxsig) (m1xlsig) (m1dxecm) (m1dxecmMCV) (m1lxecm) (m1lxecmMCV)  ///
 			(m2a1) (m2sea1) (m2ta1) (m2b0) (m2se0) (m2tb0) (m2b1) (m2se1) (m2tb1) (m2b2) (m2se2) (m2tb2) (m2b3) (m2se3) (m2tb3) (m2asig) (m2asigMCV) (m2dxsig) (m2xlsig) ///
 		  		(m2dxecm) (m2dxecmMCV) (m2lxecm) (m2lxecmMCV)  /// 
 		  		 (m3a1) (m3sea1) (m3ta1) (m3b0) (m3se0) (m3tb0) (m3b1) (m3se1) (m3tb1) (m3b2) (m3se2) (m3tb2) (m3b3) (m3se3) (m3tb3) (m3b4) (m3se4) (m3tb4) (m3b5) (m3se5) (m3tb5) ///
 			(m3asig) (m3asigMCV) (m3dxsig) (m3xlsig) (m3dxecm) (m3dxecmMCV) (m3lxecm) (m3lxecmMCV)  ///
 			(m4a1) (m4sea1) (m4ta1) (m4b0) (m4se0) (m4tb0) (m4b1) (m4se1) (m4tb1) (m4b2) (m4se2) (m4tb2) (m4b3) (m4se3) (m4tb3) (m4b4) (m4se4) (m4tb4) (m4b5) (m4se5) (m4tb5) ///
 			(m4b6) (m4se6) (m4tb6) (m4b7) (m4se7) (m4tb7) (m4asig) (m4asigMCV) (m4dxsig) (m4xlsig) (m4dxecm) (m4dxecmMCV) (m4lxecm) (m4lxecmMCV)  /// 
 			(m5a1) (m5sea1) (m5ta1) (m5b0) (m5se0) (m5tb0) (m5b1) (m5se1) (m5tb1) (m5b2) (m5se2) (m5tb2) (m5b3) (m5se3) (m5tb3) (m5b4) (m5se4) (m5tb4) (m5b5) (m5se5) (m5tb5) ///
 			(m5b6) (m5se6) (m5tb6) (m5b7) (m5se7) (m5tb7) (m5b8) (m5se8) (m5tb8) (m5b9) (m5se9) (m5tb9) (m5asig) (m5asigMCV) (m5dxsig) (m5xlsig) (m5dxecm) (m5dxecmMCV) (m5lxecm) (m5lxecmMCV)
 		
 }
 }
 postclose `sim'

 use MC_TBL2_complete, clear
 
 sum m1asig m1asigMCV m1a1 m1dxsig m1xlsig m1dxecm m1dxecmMCV m1lxecm m1lxecmMCV
 
 sum m1a1 if m1ta1 < -3.27 
 
 sum m2asig m2asigMCV m2a1 m2dxsig m2xlsig m2dxecm m2dxecmMCV m2lxecm m2lxecmMCV
 
 sum m2a1 if m2ta1 < -3.565
 
 sum m3asig m3asigMCV m3a1 m3dxsig m3xlsig m3dxecm m3dxecmMCV m3lxecm m3lxecmMCV
 
 sum m3a1 if m3ta1 < -3.816
 
 sum m4asig m4asigMCV m4a1 m3dxsig m4xlsig m4dxecm m4dxecmMCV m4lxecm m4lxecmMCV
 
 sum m4a1 if m4ta1 < -4.035
 
 sum m5asig m5asigMCV m5a1 m3dxsig m5xlsig m5dxecm m5dxecmMCV m5lxecm m5lxecmMCV

 sum m5a1 if m5ta1 < -4.229
