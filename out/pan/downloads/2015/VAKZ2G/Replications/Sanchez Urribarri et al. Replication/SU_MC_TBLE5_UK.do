cd "dir:"
use "dir/SU_UK_rep.dta", clear
 global nobs = 38
 global nmc = 10000
 set seed 5000
 set obs $nobs
 tsset year
 
 * Dfuller is -5.068; MCV of Dfuller is -2.966
 * coefficient is -0.86, t-stat of 5.07
 * Set the values of the parameters
 scalar ecmsig = -1.645
 scalar ecmMCV = -3.867
 scalar up = 1.96
 scalar lp = -1.96
 scalar alpha = .05

 * Generating random starting values for DV
 gen iv1 = 0
 gen iv2 = 0
 gen iv3 = 0

* generating errors
 gen e = .
 gen u = .
 gen v = .

 tempname sim

 postfile `sim' da1 dsea1 dta1 db0 dse0 dtb0 db1 dse1 dtb1 db2 dse2 dtb2 db3 dse3 dtb3 db4 dse4 dtb4 db5 dse5 dtb5 dasig dasigMCV ddxsig dxlsig /// 
 	ddxecm ddxecmMCV dlxecm dlxecmMCV   using SU_MC_TBLE5_UK, replace     
 
 quietly {
 forvalues i = 1/$nmc {
 replace e = rnormal()
 replace u = rnormal()
 replace v = rnormal()

 replace iv1 = .75*l.iv1 + e in 2/$nobs
 replace iv2 = .75*l.iv2 + u in 2/$nobs
 replace iv3 = .75*l.iv3 + v in 2/$nobs
 reg d.rights_agenda l.rights_agenda d.iv1 l.iv1 d.iv2 l.iv2 d.iv3 l.iv3 

  * Coefficient values
 scalar da1 = _b[l.rights_agenda]
 scalar db0 = _b[d.iv1]
 scalar db1 = _b[l.iv1]
 scalar db2 = _b[d.iv2]
 scalar db3 = _b[l.iv2]
 scalar db4 = _b[d.iv3]
 scalar db5 = _b[l.iv3]
 * Standard errors
 scalar dsea1 = _se[l.rights_agenda]
 scalar dse0 = _se[d.iv1]
 scalar dse1 = _se[l.iv1]
 scalar dse2 = _se[d.iv2]
 scalar dse3 = _se[l.iv2]
 scalar dse4 = _se[d.iv3]
 scalar dse5 = _se[l.iv3]
 * t-statistics
 scalar dta1 = da1/dsea1
 scalar dtb0 = db0/dse0
 scalar dtb1 = db1/dse1
 scalar dtb2 = db2/dse2
 scalar dtb3 = db3/dse3
 scalar dtb4 = db4/dse4
 scalar dtb5 = db5/dse5
  * Calculating significance totals 
 scalar dasig = dta1<ecmsig
 scalar dasigMCV = dta1<ecmMCV
 scalar ddxsig = (dtb0>up | dtb0<lp) | (dtb2>up | dtb2<lp) | (dtb4>up | dtb4<lp) 
 scalar dxlsig = (dtb1>up | dtb1<lp) | (dtb3>up | dtb3<lp) | (dtb5>up | dtb5<lp)  
 scalar ddxecm = (dta1<ecmsig & (dtb0>up | dtb0<lp)) | (dta1<ecmsig & (dtb2>up | dtb2<lp)) | (dta1<ecmsig & (dtb4>up | dtb4<lp)) 
 scalar ddxecmMCV = (dta1<ecmMCV & (dtb0>up | dtb0<lp)) | (dta1<ecmMCV & (dtb2>up | dtb2<lp)) | (dta1<ecmMCV & (dtb4>up | dtb4<lp)) 
 scalar dlxecm = (dta1<ecmsig & (dtb1>up | dtb1<lp)) | (dta1<ecmsig & (dtb3>up | dtb3<lp)) | (dta1<ecmsig & (dtb5>up | dtb5<lp)) 
 scalar dlxecmMCV = (dta1<ecmMCV & (dtb1>up | dtb1<lp)) | (dta1<ecmMCV & (dtb3>up | dtb3<lp)) | (dta1<ecmMCV & (dtb5>up | dtb5<lp)) 


 post `sim' (da1) (dsea1) (dta1) (db0) (dse0) (dtb0) (db1) (dse1) (dtb1) (db2) (dse2) (dtb2) (db3) (dse3) (dtb3) (db4) (dse4) (dtb4) (db5) (dse5) (dtb5) ///
 		 (dasig) (dasigMCV) (ddxsig) (dxlsig) (ddxecm) (ddxecmMCV) (dlxecm) (dlxecmMCV) 
     
 }
 }
 postclose `sim'

 use SU_MC_TBLE5_UK, clear

 sum dasig dasigMCV dta1 da1 ddxsig dxlsig ddxecm ddxecmMCV dlxecm dlxecmMCV
 
 
 
