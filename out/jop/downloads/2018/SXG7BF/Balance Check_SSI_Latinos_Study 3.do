**conduct balance check

**create variable with all three experimental cells

gen exper = .
recode exper(.=3) if melt==1
recode exper (.=2) if mosaic==1
recode exper (.=1) if melt==0 & mosaic==0

tab exper

tab native exper, chi2 col
tab uspar exper, chi2 col
tab dem exper, chi2 col
tab rep exper, chi2 col
tab mexican exper, chi2 col
tab female exper, chi2 col
tab college exper, chi2 col
tab age exper, chi2 col


mlogit exper native uspar dem rep mexican female college age , base(1)
test native uspar dem rep mexican female college age
est store balance_test_lat3

est table balance_test_lat3, b(%9.2f) se(%9.2f) stats(N) style(col)
est table balance_test_lat3, b(%9.2f) star(.1 .05 .01) stats(N) style(col)

