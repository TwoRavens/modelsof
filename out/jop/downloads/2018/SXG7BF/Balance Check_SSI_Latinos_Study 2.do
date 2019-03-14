**this file produces the results reported in tables OA.5.1 and OA.5.2

**conduct balance check

**create variable with all three experimental cells

gen exper = .
recode exper(.=3) if melt==1
recode exper (.=2) if mosaic==1
recode exper (.=1) if melt==0 & mosaic==0

tab exper

tab usborn exper, chi2 col
tab usparents exper, chi2 col
tab democrat exper, chi2 col
tab repub exper, chi2 col
tab mexican exper, chi2 col
tab female exper, chi2 col
tab college exper, chi2 col
tab age exper, chi2 col


mlogit exper usborn usparents democrat repub mexican female college age
test usborn usparents democrat repub mexican female college age
est store balance_test_lat2

est table balance_test_lat2, b(%9.2f) se(%9.2f) stats(N) style(col)
est table balance_test_lat2, b(%9.2f) star(.1 .05 .01) stats(N) style(col)
