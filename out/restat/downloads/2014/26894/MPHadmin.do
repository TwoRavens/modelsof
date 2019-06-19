/*************************************************************
  (M)PH MODEL admin removal: 
  ONLY FIRST MIGRATION !
**************************************************************/
global savepath\\Ssb2f\ssb26\SATSET\Immigranten\GBWD\CHOICES

*** Covariaten ***
global lft "lft1825 lft2530 lft3540 lft4045 lft4550 lft5055 lft5560 lft6065"
global Burgst "gehuwd samenwonend gescheiden"
global woning "Koop WOZ100 WOZ200 WOZ300 WOZ400"
global ink "mndink_neg mndink_k mndink_1000 mndink_3000 mndink_4000 mndink_5000 mndink_g"
global SBI "SBIland SBIindus SBIbouw SBIhor SBIhand SBIver SBIfin SBIzak SBIond SBIzorg SBIcult"
global Origin "interethnic NLparent otherherkomst"

global cogroup "EU newEU DC LDC"

*** SET ST-VARIABELEN ***
global pcMig "6 12 18 24 60"
global pcWerk "3 6 12 24 60"
global pcGWerk "3 6 12 18 24 36"

foreach co of global cogroup { 
 use $savepath\Arbeid3mnd9907, clear
 run $pathimmpgm\mak_countries
 keep if `co'==1
 run $savepath\Adjust_3mos
 run $savepath\Mak_tellers
 run $savepath\set_STSET
 gen byte admin = (eventMig==2)*d_mig*(SECa1==9)
 /*** INFO ON PREVIOUS STATE ***/
 run $savepath\Mak_Previous_var

 *** Covariates ***
 run $savepath\mak_SSBvar

 run $savepath\Add_natUNemprate
 replace NatUnemrate =  NatUnemrate - 2.94
 sort rin datum, stable
 by rin: gen Unementry = NatUnemrate[1]
 global UNrate "NatUnemrate Unementry"

log using $savepath\MPHadmin_`co'.txt, replace 
/*************************************************************
 (M)PH (with admin removal): 
*************************************************************/
global ID rin
run $savepath\prgMPHadmin
replace d_mig=d_mig*(admin==0)

gen double tmpid = rin

***** PH NO CORRECTION  ******
streg indwerk indGwerk ///
     zelf Onbenefit Female $Burgst AANTK $lft $ink ///
     $SBI $woning $gebland $Origin $UNrate intmig_*, ///
     nohr dist(exp) cluster(rin)
matrix bPH`co' = e(b)
estimates clear

***** PH ADMINISTRATTIVE REMOVAL ******
ml model d1 PHadmin ///
  (beta1: t0_mig t_mig d_mig admin = indwerk indGwerk ///
   zelf Onbenefit Female $Burgst AANTK $lft $ink ///
   $SBI $woning $gebland $Origin $UNrate intmig_*), tech(bfgs)
ml init bPHstart, copy  
ml max, diff
matrix bPHadmin`co' = e(b)
estimates store bPHadmin`co', title(PH `co')
estwrite * using $savepath\MPHadmin, replace

***** MPH ADMINISTRATTIVE REMOVAL ******
ml model d1 MPHdisadmin ///
  (beta1: t0_mig t_mig d_mig admin = indwerk indGwerk ///
   zelf Onbenefit Female $Burgst AANTK $lft $ink ///
   $SBI $woning $gebland $Origin $UNrate intmig_*) ///
  /a11 /logitp1, tech(bfgs)
ml init bMPHstart, copy  
ml max, diff
matrix bMPHadmin`co' = e(b)
estimates store bMPHadmin`co', title(MPH `co')
estwrite * using $savepath\MPHadmin, replace

log close


