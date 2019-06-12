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
tab female exper, chi2 col
tab college exper, chi2 col
tab age exper, chi2 col

mlogit exper usborn usparents democrat repub female college age , base(1)
test usborn usparents democrat repub female college age 
est store balance_test_wh2

est table balance_test_wh2, b(%9.2f) se(%9.2f) stats(N) style(col)
est table balance_test_wh2, b(%9.2f) star(.1 .05 .01) stats(N) style(col)
