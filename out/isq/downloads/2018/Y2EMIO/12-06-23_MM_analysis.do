
*********************************************************************************************************
******************************************ANALYSES*******************************************************
*********************************************************************************************************

clear
cd "$filetree"
*AD: 
use "MM_precise.dta"
*AD*use "C:\Users\mmousseau\Documents\Working Papers Data Sets\Cap Peace\DPUNRAV.dta", clear


********************************************************************************************
****Table 1: Contract Intensive Economy, Democracy, and Militarized Interstate Conflict*****
********************************************************************************************
global fmcontrols lncprt mjpw cntg dist numstate fpceyrs fspl1 fspl2 fspl3
global amcontrols lncprt mjpw cntg dist numstate apceyrs aspl1 aspl2 aspl3

quietly {

eststo clear
eststo: logit mzfmidl 		dml 					   $fmcontrols if MMsample==1, cl(ID) nolog
eststo: logit mzfmidl CIEl 	dml 					   $fmcontrols if MMsample==1, cl(ID) nolog
eststo: logit mzfmidl CIEl 	dml  			 	PolDis $fmcontrols				 if MMsample==1, cl(ID) nolog
eststo: logit mzfmidl CIEl  	bdm 		 	PolDis $fmcontrols				 if MMsample==1, cl(ID) nolog
eststo: logit mzamidl CIEl 			h10dm    	PolDis $amcontrols if MMsample==1 , cl(ID) nolog
eststo: logit mzfmidl CIEl 			dmlsq 		PolDis $fmcontrols  if MMsample==1 , cl(ID) nolog

}

esttab, b(2) se(2) replace label star(t 0.10 * 0.05 ** 0.01 *** 0.001)  order(CIEl dml bdm h10dm dmlsq PolDis  $fmcontrols	$amcontrol) scalars("ll Log lik.") pr2 varwidth(25) modelwidth(8)


********************************************************************************************
****Table A1: Contract Intensive Economy, Democracy, and Militarized Interstate Conflict****
********************************************************************************************
quietly {

eststo clear
eststo: logit mzamidl CIEl 	dml  			PolDis 	$amcontrols , cl(ID) nolog
eststo: logit mzamidl CIEl 		bdm 		PolDis 	$amcontrols , cl(ID) nolog

eststo: logit mzamidl CIEl dmlsq 			PolDis 	$amcontrols , cl(ID) nolog
}



esttab, b(2) se(2) replace label star(t 0.10 * 0.05 ** 0.01 *** 0.001)  order(CIEl dml bdm dmlsq PolDis $amcontrol) scalars("ll Log lik.") pr2 varwidth(25) modelwidth(8)


********************************************************************************************
****************Table 2: Tests for Competing Theories of Capitalist Peace ******************
********************************************************************************************
quietly {

eststo clear
eststo: logit mzfmidl CIEl edvl  							PolDis $fmcontrols		, cl(ID) nolog
eststo: logit mzfmidl CIEl 		dpl  						PolDis $fmcontrols		, cl(ID) nolog
eststo: logit mzfmidl CIEl 			capopenl_ipol2 			PolDis $fmcontrols		, cl(ID) nolog
eststo: logit mzfmidl CIEl 							pubh 	PolDis $fmcontrols		, cl(ID) nolog
}

esttab, b(2) se(2) replace label star(t 0.10 * 0.05 ** 0.01 *** 0.001)  order(CIEl edvl dpl capopenl_ipol2 pubh PolDis $fmcontrols) scalars("ll Log lik.") pr2 varwidth(25) modelwidth(8)



********************************************************************************************
***************Table A2: Tests for Competing Theories of Capitalist Peace ******************
********************************************************************************************
quietly {

eststo clear

eststo: logit mzfmidl  edvl  					PolDis  $fmcontrols		, cl(ID) nolog
eststo: logit mzfmidl  		dpl  				PolDis  $fmcontrols		, cl(ID) nolog
eststo: logit mzfmidl  			capopenl_ipol2 	PolDis  $fmcontrols		, cl(ID) nolog
eststo: logit mzfmidl  					pubh 	PolDis  $fmcontrols		, cl(ID) nolog
}

esttab, b(2) se(2) replace label star(t 0.10 * 0.05 ** 0.01 *** 0.001)  order(edvl dpl capopenl_ipol2 pubh PolDis $fmcontrols) scalars("ll Log lik.") pr2 varwidth(25) modelwidth(8)



********************************************************************************************

***************Table A3: Tests for Competing Theories of Capitalist Peace ******************

********************************************************************************************

quietly {

eststo clear

eststo: logit mzfmidl CIEl dvl  			PolDis $fmcontrols		, cl(ID) nolog

eststo: logit mzamidl CIEl dvl  			PolDis $amcontrols		, cl(ID) nolog

eststo: logit mzamidl CIEl edvl  			PolDis $amcontrols		, cl(ID) nolog

eststo: logit mzamidl CIEl dpl  			PolDis $amcontrols		, cl(ID) nolog

eststo: logit mzamidl CIEl capopenl_ipol2 	PolDis $amcontrols		, cl(ID) nolog

eststo: logit mzamidl CIEl pubh 		 	PolDis $amcontrols		, cl(ID) nolog

}

esttab, b(2) se(2) replace label star(t 0.10 * 0.05 ** 0.01 *** 0.001)  order(CIEl dvl edvl dpl capopenl_ipol2 pubh PolDis $fmcontrols $amcontrols) scalars("ll Log lik.") pr2 varwidth(25) modelwidth(8)






**********************************************************************

***************TESTING FOR MULTICOLLINEARITY**************************

**********************************************************************

tab bCIE if bdm==1

corr CIEl dml if mzfmidl~=.  

reg mzfmidl 	CIEl 	dml  						$fmcontrols

vif

reg mzfmidl CIEl edvl  								$fmcontrols

vif

reg mzfmidl CIEl 		dpl  						$fmcontrols

vif

reg mzfmidl CIEl 				capopenl_ipol2 		$fmcontrols

vif

reg mzfmidl CIEl 							pubh 	$fmcontrols

vif



***********************************************************************

*******************QUANTITIES OF INTEREST******************************

***********************************************************************

clear
cd "$filetree"
*AD: 
use "MM_precise.dta"
*AD*use "C:\Users\mmousseau\Documents\Working Papers Data Sets\Cap Peace\DPUNRAV.dta", clear

estsimp logit mzfmidl CIEl lncprt mjpw cntg dist numstate fpceyrs fspl1 fspl2 fspl3	, cl(ID) nolog

setx CIEl median lncprt median mjpw 0 cntg 1 dist min numstate median fpceyrs 0 fspl1 0 fspl2 0 fspl3 0



simqi, fd(prval(1)) changex(CIEl p5 p95)

simqi, fd(prval(1)) changex(lncprt p5 p95)

simqi, fd(prval(1)) changex(mjpw 0 1)

simqi, fd(prval(1)) changex(cntg 0 1)

simqi, fd(prval(1)) changex(dist p5 p95)

simqi, fd(prval(1)) changex(fpceyrs p5 p95)





******************************

****Table 2, Model 2**********

******************************

clear
cd "$filetree"
*AD: 
use "MM_precise.dta"
*AD*use "C:\Users\mmousseau\Documents\Working Papers Data Sets\Cap Peace\DPUNRAV.dta", clear

global fmcontrols PolDis lncprt mjpw cntg dist numstate fpceyrs fspl1 fspl2 fspl3

estsimp logit mzfmidl CIEl 		dpl  						$fmcontrols		, cl(ID) nolog

setx CIEl median PolDis median dpl median lncprt median mjpw 0 cntg 1 dist min numstate median fpceyrs 0 fspl1 0 fspl2 0 fspl3 0



simqi, fd(prval(1)) changex(CIEl p5 p95)

simqi, fd(prval(1)) changex(dpl p5 p95)

simqi, fd(prval(1)) changex(PolDis p5 p95)

simqi, fd(prval(1)) changex(lncprt p5 p95)

simqi, fd(prval(1)) changex(mjpw 0 1)

simqi, fd(prval(1)) changex(cntg 0 1)

simqi, fd(prval(1)) changex(dist p5 p95)

simqi, fd(prval(1)) changex(fpceyrs p5 p95)




************AD CODE***********
******************************

****Table 1, with corrected DV********

******************************
**Returns significance to Model 2

global fmcontrols lncprt mjpw cntg dist numstate fpceyrs fspl1 fspl2 fspl3
global amcontrols lncprt mjpw cntg dist numstate apceyrs aspl1 aspl2 aspl3

quietly {

eststo clear
eststo: logit mzfmidonl 		dml 					   $fmcontrols if MMsample==1, cl(ID) nolog
eststo: logit mzfmidonl CIEl 	dml 					   $fmcontrols if MMsample==1, cl(ID) nolog
eststo: logit mzfmidonl CIEl 	dml  			 	PolDis $fmcontrols				 if MMsample==1, cl(ID) nolog
eststo: logit mzfmidonl CIEl  	bdm 		 	PolDis $fmcontrols				 if MMsample==1, cl(ID) nolog
eststo: logit mzmidonl CIEl 			h10dm    	PolDis $amcontrols if MMsample==1 , cl(ID) nolog
eststo: logit mzfmidonl CIEl 			dmlsq 		PolDis $fmcontrols  if MMsample==1 , cl(ID) nolog

}

esttab, b(2) se(2) replace label star(t 0.10 * 0.05 ** 0.01 *** 0.001)  order(CIEl dml bdm h10dm dmlsq PolDis  $fmcontrols	$amcontrol) scalars("ll Log lik.") pr2 varwidth(25) modelwidth(8)

