 /*Appendix: Testing all the models with HI variables calculated based on the sample mean*/
 
  *Table A4_1*/
/*Model A4_1*/
 logit  agreeQ50missing HI_AWI_district_sample HI_LC_district_sample comp_AWI_induvidual  relative_lc_2 ///
Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
 outreg2 using C:\Users\SiriR\Dropbox, excel replace
 
 /*Model A4_2*/
logit  agreeQ55missing HI_AWI_district_sample HI_LC_district_sample comp_AWI_induvidual  relative_lc_2 ///
 Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
 outreg2 using C:\Users\SiriR\Dropbox, excel append
 
 /*Model A4_3*/
logit agreeQ50missing HI_AWI_ethnicALL_sample HI_LC_ethnicALL_sample  comp_AWI_induvidual  relative_lc_2 ///
 Abia Delta Rivers  man age oil_producing  primary_secondary  informal_schooling
 outreg2 using C:\Users\SiriR\Dropbox, excel append
 
 /*Model A4_4*/
logit  agreeQ55missing HI_AWI_ethnicALL_sample HI_LC_ethnicALL_sample  comp_AWI_induvidual relative_lc_2 ///
 Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
  outreg2 using C:\Users\SiriR\Dropbox, excel append
  
 
 /*Table A4_2*/ 
 /*model A4_5*/
 logit  agreeQ50missing HI_AWI_district_sample  AWI_dist_samp_SQ  comp_AWI_induvidual  relative_lc_2 ///
Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
 outreg2 using C:\Users\SiriR\Dropbox, excel replace
 
 /*model A4_6*/
logit  agreeQ55missing HI_AWI_district_sample  AWI_dist_samp_SQ comp_AWI_induvidual  relative_lc_2 ///
 Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
  outreg2 using C:\Users\SiriR\Dropbox, excel append
  
 /*model A4_7*/
  logit  agreeQ50missing HI_LC_district_sample LC_dist_samp_SQ comp_AWI_induvidual  relative_lc_2 ///
Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
 outreg2 using C:\Users\SiriR\Dropbox, excel append
 
 /*model A4_8*/
logit  agreeQ55missing HI_LC_district_sample LC_dist_samp_SQ comp_AWI_induvidual  relative_lc_2 ///
 Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
  outreg2 using C:\Users\SiriR\Dropbox, excel append
  
 
  /*Table A4_3*/
  /*Model A4_9*/
 logit agreeQ50missing HI_AWI_district_sample comp_AWI_induvidual  relative_lc_2 HI_AWI_district_sample_oil ///
Abia Delta Rivers man oil_producing age primary_secondary  informal_schooling
 outreg2 using C:\Users\SiriR\Dropbox, excel replace
 
 /*Model A4_10*/
 logit  agreeQ50missing  HI_LC_district_sample comp_AWI_induvidual  relative_lc_2 HI_LC_district_sample_oil ///
Abia Delta Rivers man oil_producing age primary_secondary  informal_schooling
outreg2 using C:\Users\SiriR\Dropbox, excel append

 /*Model A4_11*/
logit agreeQ50missing  HI_AWI_ethnicALL_sample  comp_AWI_induvidual  relative_lc_2 HI_AWI_ethnicALL_sample_oil ///
 Abia Delta Rivers man oil_producing age primary_secondary  informal_schooling
 outreg2 using C:\Users\SiriR\Dropbox, excel append
 
 /*Model A4_12*/
 logit agreeQ50missing HI_LC_ethnicALL_sample  comp_AWI_induvidual  relative_lc_2 HI_LC_ethnicALL_sample_oil ///
 Abia Delta Rivers man oil_producing age primary_secondary  informal_schooling
 outreg2 using C:\Users\SiriR\Dropbox, excel append
