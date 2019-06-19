* Auxiliary programs
program display_rf
		args endo ols
		if (`ols'==0) {
			est restore rf_`endo'
			est replay
		}
end
* Instrument and treatment indicator
global inst eualue100i   
global treat enter_program
* Clustering variable
global cvar "nuts4_07"
* Estimations
local c=1
foreach ols in 0 1  {  /* if ols=0 TSLS models are estimated */
	* For TSLS
	global instopt "($treat=$inst)"
	* For OLS
	if (`ols'==1){
		global instopt "$treat"    
	}
	foreach ylab in lysyht lhkb lkayto llvti leprod {
		global ylab `ylab'
		* Set up control variables:
		if ("$ylab"=="lysyht"){
			global x "llvti_la1 lhkb_la1 lkayto_la1 age agee2 i.tilimpex i.tol_vuosi"
			global x_94b "llvti94 lhkb94 lkayto94 age agee2            i.tol_vuosi"
			global xp2 "llvti_la1 llvti_la1e2 lhkb_la1 lhkb_la1e2 lkayto_la1 lkayto_la1e2 age agee2 i.tilimpex i.tol_vuosi"
			global xp3 "llvti_la1 llvti_la1e2 llvti_la1e3 lhkb_la1 lhkb_la1e2 lhkb_la1e3 lkayto_la1 lkayto_la1e2 lkayto_la1e3 age agee2 agee3 i.tilimpex i.tol_vuosi"
			global x_la2 "llvti_la2 lhkb_la2 lkayto_la2 age agee2 i.tilimpex i.tol_vuosi"
			global xl2_94 ""  /* Note: R&D expenditure not available for 1994 */
			global ytitle "R&D expenditure"
		}
		if ("$ylab"=="lhkb"){
			global x "llvti_la1 lysyht_la1 lkayto_la1 age agee2 i.tilimpex i.tol_vuosi"
			global x_94b "llvti94 lkayto94 age agee2            i.tol_vuosi"
			global xp2 "llvti_la1 llvti_la1e2 lysyht_la1 lysyht_la1e2 lkayto_la1 lkayto_la1e2 age agee2 i.tilimpex i.tol_vuosi"
			global xp3 "llvti_la1 llvti_la1e2 llvti_la1e3 lysyht_la1 lysyht_la1e2 lysyht_la1e3 lkayto_la1 lkayto_la1e2 lkayto_la1e3 age agee2 agee3 i.tilimpex i.tol_vuosi"
			global x_la2 "llvti_la2 lysyht_la2 lkayto_la2 age agee2 i.tilimpex i.tol_vuosi"
			global xl2_94 "${ylab}94 ${ylab}94e2"
			global ytitle "Employment"
		}
		if ("$ylab"=="lkayto"){
			global x "llvti_la1 lhkb_la1 lysyht_la1 age agee2 i.tilimpex i.tol_vuosi"
			global x_94b "llvti94 lhkb94 age agee2            i.tol_vuosi"
			global xp2 "llvti_la1 llvti_la1e2 lhkb_la1 lhkb_la1e2 lysyht_la1 lysyht_la1e2 age agee2 i.tilimpex i.tol_vuosi"
			global xp3 "llvti_la1 llvti_la1e2 llvti_la1e3 lhkb_la1 lhkb_la1e2 lhkb_la1e3 lysyht_la1 lysyht_la1e2 lysyht_la1e3 age agee2 agee3 i.tilimpex i.tol_vuosi"
			global x_la2 "llvti_la2 lhkb_la2 lysyht_la2 age agee2 i.tilimpex i.tol_vuosi"
			global xl2_94 "${ylab}94 ${ylab}94e2"
			global ytitle "Fixed assets"
		}
		if ("$ylab"=="llvti"){
			global x " lysyht_la1 lhkb_la1 lkayto_la1 age agee2 i.tilimpex i.tol_vuosi"
			global x_94b "lhkb94 lkayto94 age agee2            i.tol_vuosi"
			global xp2 "lysyht_la1 lysyht_la1e2 lhkb_la1 lhkb_la1e2 lkayto_la1 lkayto_la1e2 age agee2 i.tilimpex i.tol_vuosi"
			global xp3 "lysyht_la1 lysyht_la1e2 lysyht_la1e3 lhkb_la1 lhkb_la1e2 lhkb_la1e3 lkayto_la1 lkayto_la1e2 lkayto_la1e3 age agee2 agee3 i.tilimpex i.tol_vuosi"
			global x_la2 " lysyht_la2 lhkb_la2 lkayto_la2 age agee2 i.tilimpex i.tol_vuosi"
			global xl2_94 "${ylab}94 ${ylab}94e2" 
			global ytitle "Sales"
		}
		if ("$ylab"=="leprod"){
			global x " lysyht_la1 lkayto_la1 age agee2 i.tilimpex i.tol_vuosi"
			global x_94b "lkayto94 age agee2            i.tol_vuosi"
			global xp2 "lysyht_la1 lysyht_la1e2 lkayto_la1 lkayto_la1e2 age agee2 i.tilimpex i.tol_vuosi"
			global xp3 "lysyht_la1 lysyht_la1e2 lysyht_la1e3 lkayto_la1 lkayto_la1e2 lkayto_la1e3 age agee2 agee3 i.tilimpex i.tol_vuosi"
			global x_la2 " lysyht_la2 lkayto_la2 age agee2 i.tilimpex i.tol_vuosi"
			global xl2_94 "${ylab}94 ${ylab}94e2" 
			global ytitle "Labor productivity"
		}
		if ("$ylab"=="rdint"){
			global x "lhkb_la1 lkayto_la1 age agee2 i.tilimpex i.tol_vuosi"
			global x_94b "lhkb94 lkayto94 age agee2            i.tol_vuosi"			
			global xp2 "lhkb_la1 lhkb_la1e2 lkayto_la1 lkayto_la1e2 age agee2 i.tilimpex i.tol_vuosi"
			global xp3 "lhkb_la1 lhkb_la1e2 lhkb_la1e3 lkayto_la1 lkayto_la1e2 lkayto_la1e3 age agee2 agee3 i.tilimpex i.tol_vuosi"
			global x_la2 "lhkb_la2 lkayto_la2 age agee2 i.tilimpex i.tol_vuosi"
			global xl2_94 ""  /* Note: R&D expenditure not available for 1994 */
			global ytitle "R&D intensity"
		}
		global xl2 "${ylab}_la1 ${ylab}_la1e2"
		global xl3 "${ylab}_la1 ${ylab}_la1e2 ${ylab}_la1e3"
		global xl2_la2 "${ylab}_la2 ${ylab}_la2e2"
		global lseutuk "lrdcons_la1 lgdpcap_la1 urate_la1 os_jal_la1 dist00"
		global lpopden "lpopden_92_sk94"		
		* Sample restiriction
		global sampre "& !missing(d2lysyht_le1) & !missing($inst)"
		* Outcome
		global y d2${ylab}_le1
		**** Table 3 - Panel A/ Table 4
		di "Table 3 - Panel A/ Table 4, Column 1"
		xi:ivreg2 ${y}           $instopt if vuosi>=2000 & vuosi<=2005 $sampre ,  cluster($cvar) first saverf saverfprefix(rf_) 
		display_rf $y `ols'	
		if (`c'==1) { /* Mark estimation sample for descriptive statistics*/
			gen asamp=e(sample)
		}		
		di "Table 3 - Panel A/ Table 4, Column 2"
		xi:ivreg2 ${y}   i.tol_vuosi    $instopt if vuosi>=2000 & vuosi<=2005 $sampre ,  cluster($cvar) first saverf saverfprefix(rf_) partial(i.tol_vuosi)
		cap display_rf $y `ols'
		di "Table 3 - Panel A/ Table 4, Column 3"
		xi:ivreg2 ${y}          $x      $instopt if vuosi>=2000 & vuosi<=2005 $sampre ,  cluster($cvar) first saverf saverfprefix(rf_) partial(i.tol_vuosi)
		display_rf $y `ols'	
		di "Table 3 - Panel A/ Table 4, Column 4"
		xi:ivreg2 ${y} $lpopden $x      $instopt if vuosi>=2000 & vuosi<=2005 $sampre ,  cluster($cvar) first saverf saverfprefix(rf_) partial(i.tol_vuosi)
		display_rf $y `ols'	
		di "Table 3 - Panel A/ Table 4, Column 5"
		xi:ivreg2 ${y} $lpopden $x $xl2 $instopt if vuosi>=2000 & vuosi<=2005 $sampre ,  cluster($cvar) first saverf saverfprefix(rf_) partial(i.tol_vuosi) 
		display_rf $y `ols'	
		**** Table 3, panel B :
		if ("$ylab"=="lysyht") {
			di "Table 3, Panel B, Column 1"
			xi:ivreg2 ${y}                  $instopt if vuosi>=2000 & vuosi<=2002 $sampre ,  cluster($cvar) first saverf saverfprefix(rf_) 
			display_rf $y `ols'	
			di "Table 3, Panel B, Column 2"
			xi:ivreg2 ${y}   i.tol_vuosi    $instopt if vuosi>=2000 & vuosi<=2002 $sampre ,  cluster($cvar) first saverf saverfprefix(rf_) partial(i.tol_vuosi)
			display_rf $y `ols'	
			di "Table 3, Panel B, Column 3"
			xi:ivreg2 ${y}          $x      $instopt if vuosi>=2000 & vuosi<=2002 $sampre ,  cluster($cvar) first saverf saverfprefix(rf_) partial(i.tol_vuosi) 
			display_rf $y `ols'	
			di "Table 3, Panel B, Column 4"
			xi:ivreg2 ${y} $lpopden $x      $instopt if vuosi>=2000 & vuosi<=2002 $sampre ,  cluster($cvar) first saverf saverfprefix(rf_) partial(i.tol_vuosi)
			display_rf $y `ols'	
		}
		if ("$ylab"=="lysyht") {
			di "Table 3, Panel B, Column 5"
		}
		if ("$ylab"!="lysyht") {
			di "Table 4 Column 6"
		}
		xi:ivreg2 ${y} $lpopden $x $xl2 $instopt if vuosi>=2000 & vuosi<=2002 $sampre ,  cluster($cvar) first saverf saverfprefix(rf_) partial(i.tol_vuosi)
		display_rf $y `ols'	 
		**** Tables 3, panel C:
		if ("$ylab"=="lysyht") {
			di "Table 3, Panel C, Column 1"
			xi:ivreg2 ${y}                  $instopt if vuosi>=2003 & vuosi<=2005 $sampre ,  cluster($cvar) first saverf saverfprefix(rf_) 
			display_rf $y `ols'	
			di "Table 3, Panel C, Column 2"
			xi:ivreg2 ${y}   i.tol_vuosi    $instopt if vuosi>=2003 & vuosi<=2005 $sampre ,  cluster($cvar) first saverf saverfprefix(rf_) partial(i.tol_vuosi)
			display_rf $y `ols'	
			di "Table 3, Panel C, Column 3"
			xi:ivreg2 ${y}          $x      $instopt if vuosi>=2003 & vuosi<=2005 $sampre ,  cluster($cvar) first saverf saverfprefix(rf_) partial(i.tol_vuosi) 
			display_rf $y `ols'	
			di "Table 3, Panel C, Column 4"
			xi:ivreg2 ${y} $lpopden $x      $instopt if vuosi>=2003 & vuosi<=2005 $sampre ,  cluster($cvar) first saverf saverfprefix(rf_) partial(i.tol_vuosi)
			display_rf $y `ols'	
			di "Table 3, Panel C, Column 5"
			xi:ivreg2 ${y} $lpopden $x $xl2 $instopt if vuosi>=2003 & vuosi<=2005 $sampre ,  cluster($cvar) first saverf saverfprefix(rf_) partial(i.tol_vuosi) 
			display_rf $y `ols'	
		}
		**** Robustness tests, table 5/6
		di "Excluding ERDF 0"
		xi:ivreg2 ${y} $lpopden $xl2 $x $instopt if vuosi>=2000 & vuosi<=2005 & ysyht_eu0==0 $sampre,  cluster($cvar) first saverf saverfprefix(rf_)   partial(i.tol_vuosi) 
		display_rf $y `ols'	
		di "Excluding Areas in Pohjois-Savo Entering ERDF 1 in 2000"
		xi:ivreg2 ${y} $lpopden $xl2 $x $instopt if vuosi>=2000 & vuosi<=2005 & nuts4_94!=111 & nuts4_94!=112 & nuts4_94!=114 & nuts4_94!=115 $sampre,  cluster($cvar) first saverf saverfprefix(rf_)   partial(i.tol_vuosi) 
		display_rf $y `ols'	
		di "Controlling for Additional Regional Characteristics"
		xi:ivreg2 ${y} $lpopden $xl2 $x $lseutuk $instopt if vuosi>=2000 & vuosi<=2005 $sampre,  cluster($cvar) first saverf saverfprefix(rf_)   partial(i.tol_vuosi) 
		display_rf $y `ols'	
		di "Exclude firms that have started up in 1995 or later"
		xi:ivreg2 ${y} $lpopden $xl2 $x          $instopt if vuosi>=2000 & vuosi<=2005 $sampre & minvuosi<=1994 $sampre,  cluster($cvar) first saverf saverfprefix(rf_)   partial(i.tol_vuosi) 
		display_rf $y `ols'	
		di "Control variables from 1994 - excluding R&D and exporter status"
		xi:ivreg2 ${y} $lpopden $xl2_94 $x_94b   $instopt if vuosi>=2000 & vuosi<=2005 $sampre & minvuosi<=1994 $sampre,  cluster($cvar) first saverf saverfprefix(rf_)   partial(i.tol_vuosi) 
		display_rf $y `ols'	
		di "2nd order polynomial terms"
		xi:ivreg2 ${y} $lpopden $xp2 $xl2        $instopt if vuosi>=2000 & vuosi<=2005 $sampre,  cluster($cvar) first saverf saverfprefix(rf_)  partial(i.tol_vuosi)
		display_rf $y `ols'	
		di "3rd order polynomial terms"
		xi:ivreg2 ${y} $lpopden $xp3 $xl3        $instopt if vuosi>=2000 & vuosi<=2005 $sampre,  cluster($cvar) first saverf saverfprefix(rf_)  partial(i.tol_vuosi)
		display_rf $y `ols'	
		di "Reduced form for untreated"
		if (`ols'==0) {
			 xi:ivreg2 ${y} $lpopden $x $xl2 $inst if $treat==0 & vuosi>=2000 & vuosi<=2005 $sampre,  cluster($cvar) first saverf saverfprefix(rf_)   partial(i.tol_vuosi) 
		display_rf $y `ols'	
		}
		di "Pre-Treatment trend: y_la1 - y_la2"
		global y d1${ylab}_la1
		xi:ivreg2 ${y} $lpopden $xl2_la2 $x_la2 $instopt if vuosi>=2000 & vuosi<=2005 & !missing(${ylab}_le1) $sampre ,  cluster($cvar) first saverf saverfprefix(rf_)   partial(i.tol_vuosi) 
		display_rf $y `ols'	
		global y d3${ylab}_le1	
		di "Treatment effect net of pre-treatment trend: y_le1 - y_la2"
		xi:ivreg2 ${y} $lpopden $xl2_la2 $x_la2 $instopt if vuosi>=2000 & vuosi<=2005 & !missing(${ylab}_le1) $sampre ,  cluster($cvar) first saverf saverfprefix(rf_)   partial(i.tol_vuosi) 
		display_rf $y `ols'	
		**** Long-term effects
		global y d4${ylab}_le3 		
		* Sample restriction
		global sampre "& !missing(d4lysyht_le3) & !missing($inst)"
		di "Table 7"
		xi:ivreg2 ${y} $lpopden $x              $instopt if vuosi>=2000 & vuosi<=2005 $sampre,  cluster($cvar) first saverf saverfprefix(rf_) partial(i.tol_vuosi)
		display_rf $y `ols'	
		xi:ivreg2 ${y} $lpopden $x $xl2         $instopt if vuosi>=2000 & vuosi<=2005 $sampre,  cluster($cvar) first saverf saverfprefix(rf_) partial(i.tol_vuosi) 
		display_rf $y `ols'	
		local c=`c'+1
	}	
}	

* Descriptive statistics (Note: analysis sample marker "asamp" generated on line 86.) 
format ysyht_le1 ysyht_la1 tukis_le1 lvti_le1 lvti_la1 kayto_le1 kayto_la1 %12.0fc
format age %5.1fc
format hkb* %9.1fc
format popden_92_sk94 %5.1fc
format enter_program tukis_ysyht_le1 %5.3f
format enter_program d2lysyht_le1 %5.3f
* Analysis sample, by treatment status
tabstat ysyht_le1 ysyht_la1  d2lysyht_le1 enter_program tukis_le1 tukis_ysyht_le1 age lvti_le1 lvti_la1 kayto_le1 kayto_la1 hkb_le1 hkb_la1 popden_92_sk94 if asamp==1, by(${treat}) stat(mean p25 p50 p75 sd n) nototal format 
* Analysis sample, by ERDF area
tabstat ysyht_le1 ysyht_la1  d2lysyht_le1 enter_program tukis_le1 tukis_ysyht_le1 age lvti_le1 lvti_la1 kayto_le1 kayto_la1 hkb_le1 hkb_la1 popden_92_sk94 if asamp==1, by(eualue100i)  stat(mean p25 p50 p75 sd n) nototal format 
* Analysis sample, all
tabstat ysyht_le1 ysyht_la1  d2lysyht_le1 enter_program tukis_le1 tukis_ysyht_le1 age lvti_le1 lvti_la1 kayto_le1 kayto_la1 hkb_le1 hkb_la1 popden_92_sk94 if asamp==1,                stat(mean p25 p50 p75 sd n)         format 
* R&D survey sample, all
tabstat ysyht_le1 ysyht_la1  d2lysyht_le1 enter_program tukis_le1 tukis_ysyht_le1 age lvti_le1 lvti_la1 kayto_le1 kayto_la1 hkb_le1 hkb_la1 popden_92_sk94 if !missing(d2lysyht_le1), stat(mean p25 p50 p75 sd n) format
