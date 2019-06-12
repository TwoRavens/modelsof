/*All Tables and modles included in the paper*/

/*Table 1*/
/*Model 1*/
 logit  agreeQ50missing HI_AWI_district_comp HI_LC_district_comp comp_AWI_induvidual  relative_lc_2 ///
Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
outreg2 using C:\Users\SiriR\Dropbox, excel replace

 /*Model2*/
logit  agreeQ55missing  HI_AWI_district_comp HI_LC_district_comp comp_AWI_induvidual  relative_lc_2 ///
 Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
outreg2 using C:\Users\SiriR\Dropbox, excel append
 
 /*Model3*/
logit agreeQ50missing  HI_AWI_ethnicALL_comp HI_LC_ethnicALL_comp  comp_AWI_induvidual  relative_lc_2 ///
 Abia Delta Rivers  man age oil_producing  primary_secondary  informal_schooling
outreg2 using C:\Users\SiriR\Dropbox, excel append

 /*Model4*/
logit  agreeQ55missing  HI_AWI_ethnicALL_comp HI_LC_ethnicALL_comp  comp_AWI_induvidual relative_lc_2 ///
 Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
 outreg2 using C:\Users\SiriR\Dropbox, excel append

 /*Table 2*/ 
 /*model5*/
 logit  agreeQ50missing HI_AWI_district_comp  HI_AWI_distSQ  comp_AWI_induvidual  relative_lc_2 ///
Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
 outreg2 using C:\Users\SiriR\Dropbox, excel replace
 
 /*model 6*/
logit  agreeQ55missing HI_AWI_district_comp  HI_AWI_distSQ comp_AWI_induvidual  relative_lc_2 ///
 Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
  outreg2 using C:\Users\SiriR\Dropbox, excel append
  
 /*model 7*/
  logit  agreeQ50missing HI_LC_district_comp HI_LC_distSQ comp_AWI_induvidual  relative_lc_2 ///
Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
 outreg2 using C:\Users\SiriR\Dropbox, excel append
 
 /*model 8*/
logit  agreeQ55missing HI_LC_district_comp HI_LC_distSQ comp_AWI_induvidual  relative_lc_2 ///
 Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
  outreg2 using C:\Users\SiriR\Dropbox, excel append



 /*Table 3*/
  /*Model9*/
 logit agreeQ50missing HI_AWI_district_comp comp_AWI_induvidual  relative_lc_2 HI_AWI_dist_oil ///
Abia Delta Rivers man oil_producing age primary_secondary  informal_schooling
 outreg2 using C:\Users\SiriR\Dropbox, excel replace
 
 /*Model10*/
 logit  agreeQ50missing  HI_LC_district_comp comp_AWI_induvidual  relative_lc_2 HI_LC_dist_oil ///
Abia Delta Rivers man oil_producing age primary_secondary  informal_schooling
outreg2 using C:\Users\SiriR\Dropbox, excel append

 /*Model11*/
logit agreeQ50missing  HI_AWI_ethnicALL_comp  comp_AWI_induvidual  relative_lc_2 HI_AWI_ethnic_oil ///
 Abia Delta Rivers man oil_producing age primary_secondary  informal_schooling
 outreg2 using C:\Users\SiriR\Dropbox, excel append
 
 /*Model12*/
 logit agreeQ50missing HI_LC_ethnicALL_comp  comp_AWI_induvidual  relative_lc_2 HI_LC_ethnic_oil ///
 Abia Delta Rivers man oil_producing age primary_secondary  informal_schooling
 outreg2 using C:\Users\SiriR\Dropbox, excel append
