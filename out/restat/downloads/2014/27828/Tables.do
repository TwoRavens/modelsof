
use "Rural_ALL_March2013_ReStat.dta", clear
global controls _age _married _lincome _yrseduc _assets _hadsexlastwk  _chewa _nyanja _lomwe _yao _muslim 
global media_controls _mediaexp _mediaexpmiss
global allcontrols $controls $media_controls

**************************
** NUMBERS USED IN TEXT **
**************************
**Overall attrition rate
su complete

**Baseline beliefs based on q. c10 
su _circIncHIVc10 _circDecHIVc10 _circEquivHIVc10 _circUnknHIVc10 if _circum !=.

** Baseline Beliefs using continuous measure (used in footnote #11)
su _inc100B _dec100B _eql100B

**Overall attrition by treat status 
reg complete _treatm, robust cluster(r7bvill)

** Baseline Beliefs for control group - discrete and continuous questions (p.21)
su _circIncHIVc10 _circDecHIVc10 _circEquivHIVc10 _circUnknHIVc10 if _circum !=. & _treatm == 0 
su _circIncHIVc8_09 _circDecHIVc8_09 if _treatm == 0 

**Media exposure in control group at follow-up
su _mediaexp _mediaexp09 if _treatm == 0 & complete ==1 & _circum !=., detail

*******************************************************
** TABLE 1: SAMPLE SIZE AND BASELINE CHARACTERISTICS **
*******************************************************
**COLUMN 1: Mean, SD in full sample
su _age _married _yrseduc _circum _numBoysEvr
su _chewa _lomwe _nyanja _yao 
su _christian _muslim 
su _lincome _assets _farmer _salary _selfempld
su _ageSexDeb _hadsexlastmth _numSexEver _numprtnrsyr08 _everCondom _fracsafesexmth08
su _mediaexp
su c14 c15 _circIncHIVc10 _circDecHIVc10 

**COLUMN 2: Mean in the control 
su _age _married _yrseduc _circum _numBoysEvr if _treatm == 0
su _chewa _lomwe _nyanja _yao if _treatm == 0
su _christian _muslim if _treatm == 0
su _lincome _assets _farmer _salary _selfempld if _treatm == 0
su _ageSexDeb _hadsexlastmth _numSexEver _numprtnrsyr08 _everCondom _fracsafesexmth08 if _treatm == 0
su _mediaexp if _treatm == 0
su c14 c15 _circIncHIVc10 _circDecHIVc10 if _treatm == 0

**COLUMN 3: Mean in the treatment 
su _age _married _yrseduc _circum _numBoysEvr if _treatm == 1
su _chewa _lomwe _nyanja _yao if _treatm == 1
su _christian _muslim if _treatm == 1
su _lincome _assets _farmer _salary _selfempld if _treatm == 1
su _ageSexDeb _hadsexlastmth _numSexEver _numprtnrsyr08 _everCondom _fracsafesexmth08 if _treatm == 1
su _mediaexp  if _treatm == 1
su c14 c15 _circIncHIVc10 _circDecHIVc10 if _treatm == 1

**COLUMN 4: Determining p-value of balance test
reg _age _treatm, robust cluster(r7bvill)
outreg2 using T1_Balance.xls, replace se bra bdec(3) coefastr  
foreach var of varlist _age _married _yrseduc _circum _numBoysEvr _chewa _lomwe _nyanja _yao _christian _muslim _lincome _assets _farmer _salary _selfempld _ageSexDeb _hadsexlastmth _numSexEver _numprtnrsyr08 _everCondom _fracsafesexmth08 _mediaexp c14 c15 _circIncHIVc10 _circDecHIVc10 {
reg `var' _treatm, robust cluster(r7bvill)
outreg2 using T1_Balance.xls, append se bra bdec(3) coefastr  
}

**COLUMN 5: Determining p-value of attrition test
reg complete  _treatm , robust cluster(r7bvill)
outreg2 using T1_Attrition.xls, replace se bra bdec(3) coefastr  

foreach var of varlist _age _married _yrseduc _circum _numBoysEvr _chewa _lomwe _nyanja _yao _christian _muslim _lincome _assets _farmer _salary _selfempld _ageSexDeb _hadsexlastmth _numSexEver _numprtnrsyr08 _everCondom _fracsafesexmth08 _mediaexp c14 c15 _circIncHIVc10 _circDecHIVc10{
gen `var'Xtrt =`var'*_treatm
reg complete  _treatm `var'Xtrt `var', robust cluster(r7bvill)
outreg2 using T1_Attrition.xls, append se bra bdec(3) coefastr  
test `var'Xtrt + _treatm == 0 
}

**SAMPLE RESTRICTIONS for analysis
**Found at follow-up
keep if complete == 1
**Circumcision status not missing
keep if _circum !=.

**************************************************************
** TABLE 2: IMPACT ON SEXUAL BEHAVIOR **
**************************************************************
** WITH CONTROLS
global sex _hadsexlstmth09 _timesexmth09 _totsexmth09 _numcondmth09 _fracsafesexmth09 _numprtnrsmth09 _numprtnrsyr09 _numcondpurch09 _numcondfree09  _anycond09 RSMindex1 
reg _wifepreg09 _treatm _circXtreat _circum $allcontrols, robust cluster(r7bvill)
outreg2 _treatm _circXtreat _circum  using T2_Sex.xls, replace se bra bdec(3) coefastr  
test _treatm + _circXtreat = 0
foreach var of varlist $sex{
reg `var' _treatm _circXtreat _circum $allcontrols, robust cluster(r7bvill)
outreg2 _treatm _circXtreat _circum  using T2_Sex.xls, append se bra bdec(3) coefastr  
test _treatm + _circXtreat = 0 
}
su _wifepreg09 $sex if _treatm == 0 

**************************************************************
** TABLE 3 PANEL A: IMPACT ON CIRCUMCISIONS **
**************************************************************
reg circpos _treatm if _circum == 0, robust cluster(r7bvill) 
outreg2 using T3_PanelA.xls, replace se bra bdec(3) coefastr  
reg circpos _treatm $allcontrols if _circum == 0, robust cluster(r7bvill) 
outreg2 using T3_PanelA.xls, append se bra bdec(3) coefastr  

su circpos if _treatm == 0 & _circum == 0 

**************************************************************
** TABLE 3 PANEL B: IMPACT ON CHILDREN CIRCUMCISIONS **
**************************************************************
global anykids _anywillcircF _anyScircF 
reg _anywillcircF _treatm _circXtreat _circum $allcontrols if complete==1, robust cluster(r7bvill)
outreg2 using Kids_March2013.xls, replace se bra bdec(3) coefastr  
reg _anyScircF _treatm _circXtreat _circum $allcontrols if complete==1, robust cluster(r7bvill)
outreg2 using Kids_March2013.xls, append se bra bdec(3) coefastr  
test _treatm + _circXtreat = 0 

su $anykids if _treatm == 0 

**************************************************************
** TABLE 4: IMPACT ON BELIEFS **
**************************************************************
global beliefs  _circDecHIVc8_09 _circEquivHIVc8_09 _100circmen09 _100uncircmen09 _Countries

reg  _circIncHIVc8_09 _treatm _circXtreat _circum $allcontrols, robust cluster(r7bvill)
outreg2 using T4_Beliefs.xls, replace se bra bdec(3) coefastr  
test _treatm + _circXtreat = 0 
foreach var of varlist $beliefs {
reg `var' _treatm _circXtreat _circum $allcontrols, robust cluster(r7bvill)
outreg2 using T4_Beliefs.xls, append se bra bdec(3) coefastr  
test _treatm + _circXtreat = 0 
}
su _circIncHIVc8_09 $beliefs if _treatm == 0

**************************************************************
** TABLE 5: OTHER CHANNELS **
**************************************************************
reg _hivpost _treatm _circXtreat _circum $allcontrols, robust cluster(r7bvill)
outreg2 using T5_Channels.xls, replace se bra bdec(3) coefastr  
test _treatm + _circXtreat = 0 
reg _le09 _treatm _circXtreat _circum $allcontrols, robust cluster(r7bvill)
outreg2 using T5_Channels.xls, append se bra bdec(3) coefastr  
test _treatm + _circXtreat = 0 

su _hivpost _le09 if _treatm == 0 & complete == 1

*****************************************************
** TABLE 6: BEHAVIOR, CIRC BY DIFFERENTIAL BELIEFS **
*****************************************************
reg RSMindex1 _treatm _circXtreat _circum  _circDecHIVc10 _circDecHIVc10Xcirc _circDecHIVc10Xtreat  _circDecHIVc10XtreatXcirc   $allcontrols, robust cluster(r7bvill)
test  _circDecHIVc10Xtreat + _circDecHIVc10XtreatXcirc     = 0
outreg2 _treatm _circXtreat _circum  _circDecHIVc10 _circDecHIVc10Xcirc _circDecHIVc10Xtreat  _circDecHIVc10XtreatXcirc   using T6_exante.xls, replace se bra bdec(3) coefastr  

foreach var of varlist _anywillcircF _circDecHIVc8_09 {
reg `var' _treatm _circXtreat _circum  _circDecHIVc10 _circDecHIVc10Xcirc _circDecHIVc10Xtreat  _circDecHIVc10XtreatXcirc    $allcontrols, robust cluster(r7bvill)
outreg2 __treatm _circXtreat _circum  _circDecHIVc10 _circDecHIVc10Xcirc _circDecHIVc10Xtreat  _circDecHIVc10XtreatXcirc     using T6_exante.xls, append se bra bdec(3) coefastr  
test  _circDecHIVc10Xtreat + _circDecHIVc10XtreatXcirc     = 0
}
su RSMindex1 _anywillcircF _circDecHIVc8_09  if _treatm ==0


**************************************************************
** TABLE 7: SPILLOVERS **
**************************************************************
use "Rural_ALL_March2013_withSN.dta", replace

gen mindistXcircum =Ndistclose*_circum
gen mindistXtreat =Ndistclose*_treatm
gen mindistXcircXtreat =Ndistclose*_treatm*_circum

global depvar RSMindex1 _anywillcircF _circDecHIVc8_09 
global distint  mindistXtreat mindistXcircXtreat mindistXcircum

**TABLE 1 summstats on mindist
su Ndistclose
su Ndistclose if _treatm ==0
su Ndistclose if _treatm ==1

gen NdistcloseXtrt = Ndistclose * _treatm
reg Ndistclose _treatm, robust cluster(r7bvill)
reg complete Ndistclose  , robust cluster(r7bvill)
reg complete  _treatm NdistcloseXtrt Ndistclose , robust cluster(r7bvill)

**Appendix Table B summstats on mindist
su Ndistclose if _circum ==1
su Ndistclose if _circum ==1 & _treatm ==1
su Ndistclose if _circum ==1 & _treatm ==0

reg Ndistclose _treatm if _circum ==1, robust cluster(r7bvill)
reg complete Ndistclose  if _circum ==1, robust cluster(r7bvill)
reg complete  _treatm NdistcloseXtrt Ndistclose if _circum ==1, robust cluster(r7bvill)

su Ndistclose if _circum ==0
su Ndistclose if _circum ==0 & _treatm ==1
su Ndistclose if _circum ==0 & _treatm ==0

reg Ndistclose _treatm if _circum ==0, robust cluster(r7bvill)
reg complete Ndistclose  if _circum ==0, robust cluster(r7bvill)
reg complete  _treatm NdistcloseXtrt Ndistclose if _circum ==0, robust cluster(r7bvill)

**Table7: SPILLOVER TABLE:
reg RSMindex1  _treatm _circXtreat $distint _circum Ndistclose $allcontrols, robust cluster(r7bvill)
outreg2 _treatm _circXtreat $distint _circum Ndistclose using "T7_Spillovers.xls", replace se bra bdec(3)   coefastr
test _treatm + _circXtreat = 0 
foreach var of varlist $depvar {
reg `var'  _treatm _circXtreat $distint _circum Ndistclose $allcontrols, robust cluster(r7bvill)
test _treatm + _circXtreat = 0 
outreg2  _treatm _circXtreat $distint _circum Ndistclose using "T7_Spillovers.xls", append se bra bdec(3)   coefastr
}


