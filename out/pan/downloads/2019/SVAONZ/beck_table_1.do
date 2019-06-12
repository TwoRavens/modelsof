
**** Make sure to first set the working directory so this do file can find the data
clear
capture log close
capture erase beck_table_1.log
log using beck_table_1.log, text
timer clear
timer on 1
use "besley.dta"
*** Note that table 1 has only a small subset of the output produced here
*** The output for table 1 is saved and then printed in tabular form in beck_table_1.txt
 regress  graduate  Democracy logGDPcapita i.country   , cluster(country)
 scalar b1=_b[Democracy]
 scalar se1=_se[Democracy]
 scalar n1=e(N)
 logit graduate  Democracy logGDPcapita i.country   , cluster(country)
  scalar b3=_b[Democracy]
 scalar se3=_se[Democracy]
 scalar n3=e(N)
margins, dydx(Democracy)
matrix rt=r(table)
scalar ame=rt[1,1]
scalar amese =rt[2,1]
gen notall0=e(sample)
**** This generates a dummy variable which is one for an observation in an AllZero group and 0 for observaions in an  Allzero  group - note that this is saved in the R workspace 
 regress  graduate  Democracy logGDPcapita i.country  if notall0==1 , cluster(country)
 scalar b2=_b[Democracy]
 scalar se2=_se[Democracy]
 scalar n2=e(N)
regress  graduate  Democracy logGDPcapita i.country  if notall0==0 , cluster(country)
scalar b4=_b[Democracy]
 scalar se4=_se[Democracy]
 scalar n4=e(N)
timer off 1
timer list 1
log close
capture erase beck_table_1.txt
quietly {
log using beck_table_1.txt, text replace
noisily display "Replication of Table 1"
noisily display  "                                      b       se      N        AME    se(AME)"
noisily display "LpmFE(All)                 " %5.3f b1 "   " %5.3f se1 "  "%4.0f n1
noisily display "LpmFE(NotAllZero)       " %5.3f b2 "   " %5.3f se2 "  "%4.0f n2
noisily display "LogitFE                      "%5.3f b3 "   " %5.3f se3 "  "%4.0f n3 "    " %5.3f  ame "    " %5.3f amese
noisily display "LpmFE (AllZero)            "%5.3f b4 "   " %5.3f se4 "  "%4.0f n4
log close
}


