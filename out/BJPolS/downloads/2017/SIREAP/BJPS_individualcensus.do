
use "BJPS_individualcensus.dta", replace

 
*******************************************************************************
* Table 8
*******************************************************************************

eststo clear 
quiet logit employed averlogoilsale uyghur han age agesqu gender eduyear hukou ,  robust cluster(ID)
eststo
quiet logit employed averloggassale uyghur han age agesqu gender eduyear hukou ,  robust cluster(ID)
eststo
quiet logit employed averlogoilgassale uyghur han age agesqu gender eduyear hukou ,  robust cluster(ID)
eststo
quiet logit employed logoilreserve1  uyghur han age agesqu gender eduyear hukou ,  robust cluster(ID)
eststo
quiet logit employed loggasreserve1 uyghur han age agesqu gender eduyear hukou ,  robust cluster(ID)
eststo 
esttab, se(3) b(3) star(* .1 ** .05 *** .01) tex


*******************************************************************************
* Table A5
*******************************************************************************

** Panel A: Income of All Population

eststo clear 
quiet reg logincome averlogoilsale uyghur han  hour age agesqu gender eduyear hukou if soe==1,  robust cluster(ID)
eststo 
quiet reg logincome averlogoilsale uyghur han  hour age agesqu gender eduyear hukou if private==1, robust cluster(ID)
eststo 

quiet reg logincome averloggassale uyghur han  hour age agesqu gender eduyear hukou if soe==1,  robust cluster(ID)
eststo 
quiet reg logincome averloggassale uyghur han  hour age agesqu gender eduyear hukou if private==1, robust cluster(ID)
eststo 

quiet reg logincome logoilreserve1 uyghur han  hour age agesqu gender eduyear hukou if soe==1,  robust cluster(ID)
eststo 
quiet reg logincome logoilreserve1 uyghur han  hour age agesqu gender eduyear hukou if private==1, robust cluster(ID)
eststo 

quiet reg logincome loggasreserve1 uyghur han  hour age agesqu gender eduyear hukou if soe==1,  robust cluster(ID)
eststo 
quiet reg logincome loggasreserve1 uyghur han  hour age agesqu gender eduyear hukou if private==1, robust cluster(ID)
eststo 
esttab, se(3) b(3) star(* .1 ** .05 *** .01) tex


** Panel B: Income of Han Population

eststo clear 
quiet reg logincome averlogoilsale hour age agesqu gender eduyear hukou if soe==1& han==1,  robust cluster(ID)
eststo 
quiet reg logincome averlogoilsale hour age agesqu gender eduyear hukou if private==1& han==1, robust cluster(ID)
eststo 

quiet reg logincome averloggassale  hour age agesqu gender eduyear hukou if soe==1& han==1,  robust cluster(ID)
eststo 
quiet reg logincome averloggassale hour age agesqu gender eduyear hukou if private==1& han==1, robust cluster(ID)
eststo 

quiet reg logincome logoilreserve1 hour age agesqu gender eduyear hukou if soe==1& han==1,  robust cluster(ID)
eststo 
reg logincome logoilreserve1 hour age agesqu gender eduyear hukou if private==1& han==1, robust cluster(ID)
eststo 

quiet reg logincome loggasreserve1 hour age agesqu gender eduyear hukou if soe==1& han==1,  robust cluster(ID)
eststo 
quiet reg logincome loggasreserve1 hour age agesqu gender eduyear hukou if private==1& han==1, robust cluster(ID)
eststo 
esttab, se(3) b(3) star(* .1 ** .05 *** .01) tex


** Panel C: Income of Uighur Population
eststo clear 
quiet reg logincome averlogoilsale hour age agesqu gender eduyear hukou if soe==1& uyghur ==1,  robust cluster(ID)
eststo 
quiet reg logincome averlogoilsale hour age agesqu gender eduyear hukou if private==1& uyghur ==1, robust cluster(ID)
eststo 

quiet reg logincome averloggassale  hour age agesqu gender eduyear hukou if soe==1& uyghur ==1,  robust cluster(ID)
eststo 
quiet reg logincome averloggassale hour age agesqu gender eduyear hukou if private==1& uyghur ==1, robust cluster(ID)
eststo 

quiet reg logincome logoilreserve1 hour age agesqu gender eduyear hukou if soe==1& uyghur ==1,  robust cluster(ID)
eststo 
quiet reg logincome logoilreserve1 hour age agesqu gender eduyear hukou if private==1& uyghur ==1, robust cluster(ID)
eststo 

quiet reg logincome loggasreserve1 hour age agesqu gender eduyear hukou if soe==1& uyghur ==1,  robust cluster(ID)
eststo 
quiet reg logincome loggasreserve1 hour age agesqu gender eduyear hukou if private==1& uyghur ==1, robust cluster(ID)
eststo 
esttab, se(3) b(3) star(* .1 ** .05 *** .01) tex







