cd "dir:" 
use "dir/UE_rep.dta", clear
 tsset year
 
 global nobs = 38
 global nmc = 10000
 set seed 5000
 set obs $nobs

 * Set the values of the parameters
 scalar ecmsig = -1.645
 scalar ecmMCV = -4.268
 scalar up = 1.96
 scalar lp = -1.96
 scalar alpha = .05

 * Generating random starting values for DV
 gen demy = (99-1)*runiform()+1
 gen repy = (99-1)*runiform()+1
 
* generating errors
 gen u =.
 gen e = .

 tempname sim

 postfile `sim' da1 dsea1 dta1 db0 dse0 dtb0 db1 dse1 dtb1 db2 dse2 dtb2 db3 dse3 dtb3 db4 dse4 dtb4 db5 dse5 dtb5 db6 dse6 dtb6 db7 dse7 dtb7 db8 dse8 dtb8 db9 dse9 dtb9 dasig dasigMCV ddxsig dxlsig /// 
 	ddxecm ddxecmMCV dlxecm dlxecmMCV ra1 rsea1 rta1 rb0 rse0 rtb0 rb1 rse1 rtb1 rb2 rse2 rtb2 rb3 rse3 rtb3 rb4 rse4 rtb4 rb5 rse5 rtb5 rb6 rse6 rtb6 rb7 rse7 rtb7 rb8 rse8 rtb8 rb9 rse9 rtb9 rasig rasigMCV /// 
 	rdxsig rxlsig rdxecm rdxecmMCV rlxecm rlxecmMCV  using UE_MC_res, replace     
 
 quietly {
 forvalues i = 1/$nmc {
 replace u = rnormal()
 replace e = rnormal()
 replace demy = l.demy + u in 2/$nobs
 replace repy = l.repy + e in 2/$nobs
 
 reg d.demy l.demy d.domestic10b l.domestic10b d.defense10b l.defense10b d.top1share l.top1share d.inflation l.inflation d.unemployment l.unemployment
 est store dem
 reg d.repy l.repy d.domestic10b l.domestic10b d.defense10b l.defense10b d.top1share l.top1share d.inflation l.inflation d.unemployment l.unemployment
 est store rep 
 suest dem rep
 
 * Dem coefficient values
 scalar da1 = _b[dem_mean:l.demy]
 scalar db0 = _b[dem_mean:d.domestic10b]
 scalar db1 = _b[dem_mean:l.domestic10b]
 scalar db2 = _b[dem_mean:d.defense10b]
 scalar db3 = _b[dem_mean:l.defense10b]
 scalar db4 = _b[dem_mean:d.top1share]
 scalar db5 = _b[dem_mean:l.top1share]
 scalar db6 = _b[dem_mean:d.inflation]
 scalar db7 = _b[dem_mean:l.inflation]
 scalar db8 = _b[dem_mean:d.unemployment]
 scalar db9 = _b[dem_mean:l.unemployment]
 * Dem standard errors
 scalar dsea1 = _se[dem_mean:l.demy]
 scalar dse0 = _se[dem_mean:d.domestic10b]
 scalar dse1 = _se[dem_mean:l.domestic10b]
 scalar dse2 = _se[dem_mean:d.defense10b]
 scalar dse3 = _se[dem_mean:l.defense10b]
 scalar dse4 = _se[dem_mean:d.top1share]
 scalar dse5 = _se[dem_mean:l.top1share]
 scalar dse6 = _se[dem_mean:d.inflation]
 scalar dse7 = _se[dem_mean:l.inflation]
 scalar dse8 = _se[dem_mean:d.unemployment]
 scalar dse9 = _se[dem_mean:l.unemployment]
 * Dem t-statistics
 scalar dta1 = da1/dsea1
 scalar dtb0 = db0/dse0
 scalar dtb1 = db1/dse1
 scalar dtb2 = db2/dse2
 scalar dtb3 = db3/dse3
 scalar dtb4 = db4/dse4
 scalar dtb5 = db5/dse5
 scalar dtb6 = db6/dse6
 scalar dtb7 = db7/dse7
 scalar dtb8 = db8/dse8
 scalar dtb9 = db9/dse9
 * Rep Coefficient values
 scalar ra1 = _b[rep_mean:l.repy]
 scalar rb0 = _b[rep_mean:d.domestic10b]
 scalar rb1 = _b[rep_mean:l.domestic10b]
 scalar rb2 = _b[rep_mean:d.defense10b]
 scalar rb3 = _b[rep_mean:l.defense10b]
 scalar rb4 = _b[rep_mean:d.top1share]
 scalar rb5 = _b[rep_mean:l.top1share]
 scalar rb6 = _b[rep_mean:d.inflation]
 scalar rb7 = _b[rep_mean:l.inflation]
 scalar rb8 = _b[rep_mean:d.unemployment]
 scalar rb9 = _b[rep_mean:l.unemployment]
 * Rep standard errors
 scalar rsea1 = _se[rep_mean:l.repy]
 scalar rse0 = _se[rep_mean:d.domestic10b]
 scalar rse1 = _se[rep_mean:l.domestic10b]
 scalar rse2 = _se[rep_mean:d.defense10b]
 scalar rse3 = _se[rep_mean:l.defense10b]
 scalar rse4 = _se[rep_mean:d.top1share]
 scalar rse5 = _se[rep_mean:l.top1share]
 scalar rse6 = _se[rep_mean:d.inflation]
 scalar rse7 = _se[rep_mean:l.inflation]
 scalar rse8 = _se[rep_mean:d.unemployment]
 scalar rse9 = _se[rep_mean:l.unemployment]
 * Rep t-statistics
 scalar rta1 = ra1/rsea1
 scalar rtb0 = rb0/rse0
 scalar rtb1 = rb1/rse1
 scalar rtb2 = rb2/rse2
 scalar rtb3 = rb3/rse3
 scalar rtb4 = rb4/rse4
 scalar rtb5 = rb5/rse5
 scalar rtb6 = rb6/rse6
 scalar rtb7 = rb7/rse7
 scalar rtb8 = rb8/rse8
 scalar rtb9 = rb9/rse9
 * Calculating significance totals 
 scalar dasig = dta1<ecmsig
 scalar dasigMCV = dta1<ecmMCV
 scalar rasig = rta1<ecmsig
 scalar rasigMCV = rta1<ecmMCV
 scalar ddxsig = (dtb0>up | dtb0<lp) | (dtb2>up | dtb2<lp) | (dtb4>up | dtb4<lp) | (dtb6>up | dtb6<lp) | (dtb8>up | dtb8<lp)
 scalar rdxsig = (rtb0>up | rtb0<lp) | (rtb2>up | rtb2<lp) | (rtb4>up | rtb4<lp) | (rtb6>up | rtb6<lp) | (rtb8>up | rtb8<lp)
 scalar dxlsig = (dtb1>up | dtb1<lp) | (dtb3>up | dtb3<lp) | (dtb5>up | dtb5<lp) | (dtb7>up | dtb7<lp) | (dtb9>up | dtb9<lp)
 scalar rxlsig = (rtb1>up | rtb1<lp) | (rtb3>up | rtb3<lp) | (rtb5>up | rtb5<lp) | (rtb7>up | rtb7<lp) | (rtb9>up | rtb9<lp)
 scalar ddxecm = (dta1<ecmsig & (dtb0>up | dtb0<lp)) | (dta1<ecmsig & (dtb2>up | dtb2<lp)) | (dta1<ecmsig & (dtb4>up | dtb4<lp)) | (dta1<ecmsig & (dtb6>up | dtb6<lp)) | (dta1<ecmsig & (dtb8>up | dtb8<lp))
 scalar ddxecmMCV = (dta1<ecmMCV & (dtb0>up | dtb0<lp)) | (dta1<ecmMCV & (dtb2>up | dtb2<lp)) | (dta1<ecmMCV & (dtb4>up | dtb4<lp)) | (dta1<ecmMCV & (dtb6>up | dtb6<lp)) | (dta1<ecmMCV & (dtb8>up | dtb8<lp))
 scalar rdxecm = (rta1<ecmsig & (rtb0>up | rtb0<lp)) | (rta1<ecmsig & (rtb2>up | rtb2<lp)) | (rta1<ecmsig & (rtb4>up | rtb4<lp)) | (rta1<ecmsig & (rtb6>up | rtb6<lp)) | (rta1<ecmsig & (rtb8>up | rtb8<lp))
 scalar rdxecmMCV = (rta1<ecmMCV & (rtb0>up | rtb0<lp)) | (rta1<ecmMCV & (rtb2>up | rtb2<lp)) | (rta1<ecmMCV & (rtb4>up | rtb4<lp)) | (rta1<ecmMCV & (rtb6>up | rtb6<lp)) | (rta1<ecmMCV & (rtb8>up | rtb8<lp))
 scalar dlxecm = (dta1<ecmsig & (dtb1>up | dtb1<lp)) | (dta1<ecmsig & (dtb3>up | dtb3<lp)) | (dta1<ecmsig & (dtb5>up | dtb5<lp)) | (dta1<ecmsig & (dtb7>up | dtb7<lp)) | (dta1<ecmsig & (dtb9>up | dtb9<lp))
 scalar dlxecmMCV = (dta1<ecmMCV & (dtb1>up | dtb1<lp)) | (dta1<ecmMCV & (dtb3>up | dtb3<lp)) | (dta1<ecmMCV & (dtb5>up | dtb5<lp)) | (dta1<ecmMCV & (dtb7>up | dtb7<lp)) | (dta1<ecmMCV & (dtb9>up | dtb9<lp))
 scalar rlxecm = (rta1<ecmsig & (rtb1>up | rtb1<lp)) | (rta1<ecmsig & (rtb3>up | rtb3<lp)) | (rta1<ecmsig & (rtb5>up | rtb5<lp)) | (rta1<ecmsig & (rtb7>up | rtb7<lp)) | (rta1<ecmsig & (rtb9>up | rtb9<lp))
 scalar rlxecmMCV = (rta1<ecmMCV & (rtb1>up | rtb1<lp)) | (rta1<ecmMCV & (rtb3>up | rtb3<lp)) | (rta1<ecmMCV & (rtb5>up | rtb5<lp)) | (rta1<ecmMCV & (rtb7>up | rtb7<lp)) | (rta1<ecmMCV & (rtb9>up | rtb9<lp))


 post `sim' (da1) (dsea1) (dta1) (db0) (dse0) (dtb0) (db1) (dse1) (dtb1) (db2) (dse2) (dtb2) (db3) (dse3) (dtb3) (db4) (dse4) (dtb4) (db5) (dse5) (dtb5) (db6) (dse6) (dtb6) (db7) (dse7) (dtb7) ///
 		(db8) (dse8) (dtb8) (db9) (dse9) (dtb9) (dasig) (dasigMCV) (ddxsig) (dxlsig) (ddxecm) (ddxecmMCV) (dlxecm) (dlxecmMCV) /// 
 	(ra1) (rsea1) (rta1) (rb0) (rse0) (rtb0) (rb1) (rse1) (rtb1) (rb2) (rse2) (rtb2) (rb3) (rse3) (rtb3) (rb4) (rse4) (rtb4) (rb5) (rse5) (rtb5) (rb6) (rse6) (rtb6) (rb7) (rse7) (rtb7) ///
 		(rb8) (rse8) (rtb8) (rb9) (rse9) (rtb9) (rasig) (rasigMCV) (rdxsig) (rxlsig) (rdxecm) (rdxecmMCV) (rlxecm) (rlxecmMCV) 
     
 }
 }
 postclose `sim'

 use UE_MC_res, clear

 sum dasig dasigMCV da1 ddxsig dxlsig ddxecm ddxecmMCV dlxecm dlxecmMCV
 
 sum rasig rasigMCV ra1 rdxsig rxlsig rdxecm rdxecmMCV rlxecm rlxecmMCV
 

 
 
