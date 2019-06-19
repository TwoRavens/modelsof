/**************************************
  ADJUST DATA TO 1) Employed within 3 months
                2) Shifting SSB-variables
***************************************/
/***** 
Adjust first 3 months if employed within 3 months
  but not employed at start (with migration motive labour) 
******/
by rin: gen byte eerste = (_n==1)
gen byte tmp3mnd = (SEC!=1& SEC!=2)*eerste
by rin: replace tmp3mnd = 1 if _n > 1 & ///
    (SEC!=1 & SEC!=2) & (datum - datum[1] < 91) & ///
    tmp3mnd[1]==1 & tmp3mnd[_n-1]==1
gen byte ind3 = 0
by rin: replace ind3 = 1 if _n > 1 & ///
    tmp3mnd[_n-1]==1 & tmp3mnd==0

clonevar SECa = SEC
forvalues j=1(1)4 {
  by rin: replace SECa = SEC[_n+`j'] if tmp3mnd==1 & ///
     ind3[_n+`j'] ==1
}
drop ind3 tmp3mnd eerste

/*************************************************
 Adjustment of all timevarying covariates
  for STSET
**************************************************/
global SSBtv "SECa MNDINK SBI NAT BURGST AANTKINDHH HuurKoop WOZWAARDE PlaatsINHH TypeHH"

foreach i of global SSBtv {
  clonevar `i'1 = `i'
  by rin: replace `i'1 = `i'[_n-1]
}
drop MNDINK SBI NAT BURGST AANTKINDHH HuurKoop WOZWAARDE PlaatsINHH TypeHH
