/*Appendix: Actual and percieved in different models*/


/*Table A3_1*/
/*Model A2_1*/
 logit  agreeQ50missing  HI_AWI_district_comp  comp_AWI_induvidual  relative_lc_2 ///
Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
outreg2 using C:\Users\SiriR\Dropbox, excel replace
 
 /*Model A3_2*/
logit  agreeQ55missing HI_AWI_district_comp  comp_AWI_induvidual  relative_lc_2 ///
 Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
outreg2 using C:\Users\SiriR\Dropbox, excel append

/*Model A3_3*/
 logit  agreeQ50missing  HI_LC_district_comp comp_AWI_induvidual  relative_lc_2 ///
Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
 outreg2 using C:\Users\SiriR\Dropbox, excel append
 
/*Model A3_4*/
logit  agreeQ55missing HI_LC_district_comp comp_AWI_induvidual  relative_lc_2 ///
 Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
 outreg2 using C:\Users\SiriR\Dropbox, excel append
 
 
 
 /*Table A3_2*/

  /*Model A3_5*/
logit agreeQ50missing   HI_AWI_ethnicALL_comp comp_AWI_induvidual  relative_lc_2 ///
 Abia Delta Rivers  man age oil_producing  primary_secondary  informal_schooling
outreg2 using C:\Users\SiriR\Dropbox, excel replace
 
 /*Model A3_6*/
logit  agreeQ55missing HI_AWI_ethnicALL_comp comp_AWI_induvidual relative_lc_2 ///
 Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
 outreg2 using C:\Users\SiriR\Dropbox, excel append
 
  /*Model A3_7*/
logit agreeQ50missing  HI_LC_ethnicALL_comp  comp_AWI_induvidual  relative_lc_2 ///
 Abia Delta Rivers  man age oil_producing  primary_secondary  informal_schooling
 outreg2 using C:\Users\SiriR\Dropbox, excel append
  
  /*Model A3_8*/
logit  agreeQ55missing HI_LC_ethnicALL_comp  comp_AWI_induvidual relative_lc_2 ///
 Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling
 outreg2 using C:\Users\SiriR\Dropbox, excel append


  