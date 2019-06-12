use "/Users/maryannemadeira/Dropbox/Regionalization and Social Welfare/newestdataset.dta"

tsset country_num year, year

*Model 1: Time-Series Fixed Effects with all countries

xtreg socsecexpgovex ias tradeopen popold  totalfdistockgdp lngdppercap  servemploy polityiv eu, fe

*Model 2: Time-Series Fixed Effects, non-EU countries only

xtreg socsecexpgovex ias tradeopen popold  totalfdistockgdp lngdppercap  servemploy polityiv if eu==0 & candidate==0, fe

*Model 3: Time-Series Fixed Effects, EU countries and EU candidates only

xtreg socsecexpgovex ias tradeopen popold  totalfdistockgdp lngdppercap  servemploy if eu==1 | candidate==1, fe

*Robustness checks:

xtreg socsecexpgovex haftel tradeopen popold  totalfdistockgdp lngdppercap  servemploy polityiv eu, fe

xtreg socsecexpgovex haftel tradeopen popold  totalfdistockgdp lngdppercap  servemploy polityiv if eu==0 & candidate==0, fe

xtreg socsecexpgovex haftel tradeopen popold  totalfdistockgdp lngdppercap  servemploy if eu==1 | candidate==1, fe






