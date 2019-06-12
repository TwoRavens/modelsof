/*Appendix: Replication of Tables 1-3 coding only those that strongly agree with statement A as 1 and all others 0 */


/*Table A2_1*/
/*Model A2_1*/
 logit  strongagreeQ50missing HI_AWI_district_comp HI_LC_district_comp comp_AWI_induvidual  relative_lc_2 ///
Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
 outreg2 using C:\Users\SiriR\Dropbox, excel replace
 
 /*Model A2_2*/
logit  strongagreeQ55missing HI_AWI_district_comp HI_LC_district_comp comp_AWI_induvidual  relative_lc_2 ///
 Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
 outreg2 using C:\Users\SiriR\Dropbox, excel append
 
 /*Model A2_3*/
logit strongagreeQ50missing  HI_AWI_ethnicALL_comp HI_LC_ethnicALL_comp  comp_AWI_induvidual  relative_lc_2 ///
 Abia Delta Rivers  man age oil_producing  primary_secondary  informal_schooling
 outreg2 using C:\Users\SiriR\Dropbox, excel append
 
 /*Model A2_4*/
logit  strongagreeQ55missing HI_AWI_ethnicALL_comp HI_LC_ethnicALL_comp  comp_AWI_induvidual relative_lc_2 ///
 Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
  outreg2 using C:\Users\SiriR\Dropbox, excel append
  
 
 /*Table A2_2*/ 
 /*model A2_5*/
 logit  strongagreeQ50missing HI_AWI_district_comp  HI_AWI_distSQ  comp_AWI_induvidual  relative_lc_2 ///
Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
 outreg2 using C:\Users\SiriR\Dropbox, excel replace
 
 /*model A2_6*/
logit  strongagreeQ55missing HI_AWI_district_comp  HI_AWI_distSQ comp_AWI_induvidual  relative_lc_2 ///
 Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
  outreg2 using C:\Users\SiriR\Dropbox, excel append
  
 /*model A2_7*/
  logit  strongagreeQ50missing HI_LC_district_comp HI_LC_distSQ comp_AWI_induvidual  relative_lc_2 ///
Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
 outreg2 using C:\Users\SiriR\Dropbox, excel append
 
 /*model A2_8*/
logit  strongagreeQ55missing HI_LC_district_comp HI_LC_distSQ comp_AWI_induvidual  relative_lc_2 ///
 Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
  outreg2 using C:\Users\SiriR\Dropbox, excel append
 
 
 /*Table A2_3*/
  /*ModelA2_9*/
 logit  strongagreeQ50missing HI_AWI_district_comp comp_AWI_induvidual  relative_lc_2 HI_AWI_dist_oil ///
Abia Delta Rivers man oil_producing age primary_secondary  informal_schooling
  outreg2 using C:\Users\SiriR\Dropbox, excel replace
  
 /*Model A2_10*/
 logit  strongagreeQ50missing  HI_LC_district_comp comp_AWI_induvidual  relative_lc_2 HI_LC_dist_oil ///
Abia Delta Rivers man oil_producing age primary_secondary  informal_schooling
 outreg2 using C:\Users\SiriR\Dropbox, excel append
 
 /*Model A2_11*/
logit strongagreeQ50missing  HI_AWI_ethnicALL_comp  comp_AWI_induvidual  relative_lc_2 HI_AWI_ethnic_oil ///
 Abia Delta Rivers man oil_producing age primary_secondary  informal_schooling
  outreg2 using C:\Users\SiriR\Dropbox, excel append
  
 /*Model A2_12*/
 logit strongagreeQ50missing HI_LC_ethnicALL_comp  comp_AWI_induvidual  relative_lc_2 HI_LC_ethnic_oil ///
 Abia Delta Rivers man oil_producing age primary_secondary  informal_schooling
  outreg2 using C:\Users\SiriR\Dropbox, excel append
  