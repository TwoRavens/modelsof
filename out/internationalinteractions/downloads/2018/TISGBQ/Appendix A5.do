/*Adding Ijaw to the analysis with ethnic*/
/*Table A5*/

 /*Model A5_1*/
logit agreeQ50missing  HI_AWI_ethnicALL_comp HI_LC_ethnicALL_comp  comp_AWI_induvidual  relative_lc_2 ///
 Ijaw Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
 outreg2 using C:\Users\SiriR\Dropbox, excel replace
 
 /*Model A5_2*/
logit   agreeQ55missing  HI_AWI_ethnicALL_comp HI_LC_ethnicALL_comp  comp_AWI_induvidual relative_lc_2 ///
Ijaw  Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
  outreg2 using C:\Users\SiriR\Dropbox, excel append

   /*Model A5_3*/
logit agreeQ50missing  HI_AWI_ethnicALL_comp  comp_AWI_induvidual  relative_lc_2 HI_AWI_ethnic_oil ///
 Ijaw Abia Delta Rivers man oil_producing age primary_secondary  informal_schooling
  outreg2 using C:\Users\SiriR\Dropbox, excel append
  
 /*Model A5_4*/
 logit  agreeQ55missing  HI_LC_ethnicALL_comp  comp_AWI_induvidual  relative_lc_2 HI_LC_ethnic_oil ///
 Ijaw Abia Delta Rivers man oil_producing age primary_secondary  informal_schooling
  outreg2 using C:\Users\SiriR\Dropbox, excel append
