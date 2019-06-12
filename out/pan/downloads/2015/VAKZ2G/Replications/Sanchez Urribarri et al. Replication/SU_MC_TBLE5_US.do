cd "dir:"
use "dir/SU_US_rep.dta", clear
 global nobs = 61
 global nmc = 10000
 set seed 5000
 set obs $nobs
 tsset year
 
 *Dfuller -3.683; MCV of Dfuller is-2.922 
 * Set the values of the parameters
 scalar ecmsig = -1.645
 scalar ecmMCV = -4.229
 scalar up = 1.96
 scalar lp = -1.96
 scalar alpha = .05

 * Generating random starting values for DV
 gen iv1 = uniform()*100
 gen iv2 = uniform()*100
 gen iv3 = uniform()*100
 gen iv4 = uniform()*100
 gen iv5 = uniform()*100

* generating errors
 gen e = .
 gen u = .
 gen v = .
 gen w = .
 gen o = .

 tempname sim

 postfile `sim' da1 dsea1 dta1 db0 dse0 dtb0 db1 dse1 dtb1 db2 dse2 dtb2 db3 dse3 dtb3 db4 dse4 dtb4 db5 dse5 dtb5 db6 dse6 dtb6 db7 dse7 dtb7 db8 dse8 dtb8 db9 dse9 dtb9 dasig dasigMCV ddxsig dxlsig /// 
 	ddxecm ddxecmMCV dlxecm dlxecmMCV   using SU_MC_TBLE5_US, replace     
 
 quietly {
 forvalues i = 1/$nmc {
 replace e = rnormal()
 replace u = rnormal()
 replace v = rnormal()
 replace w = rnormal()
 replace o = rnormal()

 replace iv1 = .75*l.iv1 + e in 2/$nobs
 replace iv2 = .75*l.iv2 + u in 2/$nobs
 replace iv3 = .75*l.iv3 + v in 2/$nobs
 replace iv4 = .75*l.iv4 + w in 2/$nobs
 replace iv5 = .75*l.iv5 + o in 2/$nobs
 reg d.rights_agenda l.rights_agenda d.iv1 l.iv1 d.iv2 l.iv2 d.iv3 l.iv3 d.iv4 l.iv4 d.iv5 l.iv5

  * coefficient values
 scalar da1 = _b[l.rights_agenda]
 scalar db0 = _b[d.iv1]
 scalar db1 = _b[l.iv1]
 scalar db2 = _b[d.iv2]
 scalar db3 = _b[l.iv2]
 scalar db4 = _b[d.iv3]
 scalar db5 = _b[l.iv3]
 scalar db6 = _b[d.iv4]
 scalar db7 = _b[l.iv4]
 scalar db8 = _b[d.iv5]
 scalar db9 = _b[l.iv5]
 * standard errors
 scalar dsea1 = _se[l.rights_agenda]
 scalar dse0 = _se[d.iv1]
 scalar dse1 = _se[l.iv1]
 scalar dse2 = _se[d.iv2]
 scalar dse3 = _se[l.iv2]
 scalar dse4 = _se[d.iv3]
 scalar dse5 = _se[l.iv3]
 scalar dse6 = _se[d.iv4]
 scalar dse7 = _se[l.iv4]
 scalar dse8 = _se[d.iv5]
 scalar dse9 = _se[l.iv5]
 * t-statistics
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
  * Calculating significance totals 
 scalar dasig = dta1<ecmsig
 scalar dasigMCV = dta1<ecmMCV
 scalar ddxsig = (dtb0>up | dtb0<lp) | (dtb2>up | dtb2<lp) | (dtb4>up | dtb4<lp) | (dtb6>up | dtb6<lp) | (dtb8>up | dtb8<lp)
 scalar dxlsig = (dtb1>up | dtb1<lp) | (dtb3>up | dtb3<lp) | (dtb5>up | dtb5<lp) | (dtb7>up | dtb7<lp) | (dtb9>up | dtb9<lp)
 scalar ddxecm = (dta1<ecmsig & (dtb0>up | dtb0<lp)) | (dta1<ecmsig & (dtb2>up | dtb2<lp)) | (dta1<ecmsig & (dtb4>up | dtb4<lp)) | (dta1<ecmsig & (dtb6>up | dtb6<lp)) | (dta1<ecmsig & (dtb8>up | dtb8<lp))
 scalar ddxecmMCV = (dta1<ecmMCV & (dtb0>up | dtb0<lp)) | (dta1<ecmMCV & (dtb2>up | dtb2<lp)) | (dta1<ecmMCV & (dtb4>up | dtb4<lp)) | (dta1<ecmMCV & (dtb6>up | dtb6<lp)) | (dta1<ecmMCV & (dtb8>up | dtb8<lp))
 scalar dlxecm = (dta1<ecmsig & (dtb1>up | dtb1<lp)) | (dta1<ecmsig & (dtb3>up | dtb3<lp)) | (dta1<ecmsig & (dtb5>up | dtb5<lp)) | (dta1<ecmsig & (dtb7>up | dtb7<lp)) | (dta1<ecmsig & (dtb9>up | dtb9<lp))
 scalar dlxecmMCV = (dta1<ecmMCV & (dtb1>up | dtb1<lp)) | (dta1<ecmMCV & (dtb3>up | dtb3<lp)) | (dta1<ecmMCV & (dtb5>up | dtb5<lp)) | (dta1<ecmsig & (dtb7>up | dtb7<lp)) | (dta1<ecmsig & (dtb9>up | dtb9<lp))


 post `sim' (da1) (dsea1) (dta1) (db0) (dse0) (dtb0) (db1) (dse1) (dtb1) (db2) (dse2) (dtb2) (db3) (dse3) (dtb3) (db4) (dse4) (dtb4) (db5) (dse5) (dtb5) (db6) (dse6) (dtb6) (db7) (dse7) (dtb7) ///
 		(db8) (dse8) (dtb8) (db9) (dse9) (dtb9) (dasig) (dasigMCV) (ddxsig) (dxlsig) (ddxecm) (ddxecmMCV) (dlxecm) (dlxecmMCV)
     
 }
 }
 postclose `sim'

 use SU_MC_TBLE5_US, clear

 sum dasig dasigMCV dta1 da1 ddxsig dxlsig ddxecm ddxecmMCV dlxecm dlxecmMCV

 
 
