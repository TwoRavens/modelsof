use "timberauctionbidobservations_80to90.dta", clear

gen advertisedrate2 = advertisedrate
replace advertisedrate = advertisedrate*volumetotal2/volumetotal
gen sellingvalue2 = sellingvalue
replace sellingvalue = sellingvalue*volumetotal2/volumetotal
gen mfgcost2 = mfgcost
replace mfgcost= mfgcost*volumetotal2/volumetotal
gen loggingcosts2 = loggingcosts
replace loggingcosts = loggingcosts*volumetotal2/volumetotal

gen lnadvertisedrate = log(advertisedrate)
gen lnsellingvalue = log(sellingvalue)
gen lnmfgcost = log(mfgcost)
gen lnvolume = log(volumetotal)
gen lnlogging = log(loggingcosts)
gen lnroad = log(roadcosts)

gen numofmillifmill = nummills*milldummy
gen numofmilliflogger = nummills*loggerdummy
gen numofloggerifmill = numloggers*milldummy
gen numofloggeriflogger = numloggers*loggerdummy


replace lnmfgcost = 0 if lnmfgcost == .
replace lnadvertisedrate = 0 if lnadvertisedrate == .
replace lnsellingvalue = 0 if lnsellingvalue == .
replace lnvolume = 0 if lnvolume == .
replace lnlogging = 0 if lnlogging == .
replace lnroad = 0 if lnroad == .

gen bid4 = bid2*volumetotal
gen advertisedrate4 = advertisedrate*volumetotal
gen sellingvalue4 = sellingvalue*volumetotal
gen mfgcost4 = mfgcost*volumetotal
gen loggingcosts4 = loggingcosts*volumetotal
gen roadcosts4 = roadcosts*volumetotal
gen lnsellingvalue4 = log(sellingvalue4)
gen lnmfgcost4 = log(mfgcost4)
gen lnlogging4 = log(loggingcosts4)
gen lnroad4 = log(roadcosts4)
replace lnmfgcost4 = 0 if lnmfgcost4 == .
replace lnsellingvalue4 = 0 if lnsellingvalue4 == .
replace lnlogging4 = 0 if lnlogging4 == .
replace lnroad4 = 0 if lnroad4 == .

replace nummills_predict_round = 0 if nummills_predict_round < 0
replace numloggers_predict_round = 0 if numloggers_predict_round < 0
replace numsb_predict_round = 0 if numsb_predict_round < 0

drop if dummy78 == 1 | dummy79 == 1 | dummy80 == 1 | dummy81 == 1


gen bid4_log = log(bid4)
gen advertisedrate4_log = log(advertisedrate4)

reg bid4_log i.nummills i.numloggers i.numsb ///
advertisedrate4_log lnsellingvalue4 lnmfgcost4 density lnvolume lnlogging4 lnroad4 salvagesaledummy ///
specieshhi contractlength ///
dummy82 dummy83 dummy84 dummy85 dummy86 dummy87 dummy88 dummy89 ///
region2dummy region3dummy region4dummy region5dummy region6dummy region8dummy region9dummy region10dummy

gen bidloghomo = bid4_log-(region10dummy*_b[region10dummy]+region9dummy*_b[region9dummy] ///
+region8dummy*_b[region8dummy] +region6dummy*_b[region6dummy] +region5dummy*_b[region5dummy] ///
+region4dummy*_b[region4dummy] +region3dummy*_b[region3dummy] +region2dummy*_b[region2dummy] ///
+dummy89*_b[dummy89] +dummy88*_b[dummy88] +dummy87*_b[dummy87] +dummy86*_b[dummy86] +dummy85*_b[dummy85] ///
+dummy84*_b[dummy84] +dummy83*_b[dummy83] +dummy82*_b[dummy82] + salvagesaledummy*_b[salvagesaledummy] ///
+lnroad4*_b[lnroad4] + lnlogging4*_b[lnlogging4] + lnvolume*_b[lnvolume] + density*_b[density] ///
+lnmfgcost4*_b[lnmfgcost4]+lnsellingvalue4*_b[lnsellingvalue4]+advertisedrate4_log*_b[advertisedrate4] ///
+specieshhi*_b[specieshhi]+contractlength*_b[contractlength])

predict bidlog_preds, xb

gen bidlog_resids = bid4_log-bidlog_preds


gen unob_mills = nummills - nummills_predict_round 
gen unob_loggers = numloggers - numloggers_predict_round
gen unob_sb = numsb - numsb_predict_round
egen millmin = min(unob_mills)
egen logmin = min(unob_loggers)
egen sbmin = min(unob_sb)
replace unob_mills = unob_mills-millmin
replace unob_loggers = unob_loggers-logmin
replace unob_sb = unob_sb-sbmin

reg bid4_log i.nummills i.numloggers i.numsb i.unob_mills i.unob_loggers i.unob_sb ///
advertisedrate4_log lnsellingvalue4 lnmfgcost4 density lnvolume lnlogging4 lnroad4 salvagesaledummy ///
specieshhi contractlength ///
dummy82 dummy83 dummy84 dummy85 dummy86 dummy87 dummy88 dummy89 ///
region2dummy region3dummy region4dummy region5dummy region6dummy region8dummy region9dummy region10dummy


gen bidloghomo_unob = bid4_log-(region10dummy*_b[region10dummy]+region9dummy*_b[region9dummy] ///
+region8dummy*_b[region8dummy] +region6dummy*_b[region6dummy] +region5dummy*_b[region5dummy] ///
+region4dummy*_b[region4dummy] +region3dummy*_b[region3dummy] +region2dummy*_b[region2dummy] ///
+dummy89*_b[dummy89] +dummy88*_b[dummy88] +dummy87*_b[dummy87] +dummy86*_b[dummy86] +dummy85*_b[dummy85] ///
+dummy84*_b[dummy84] +dummy83*_b[dummy83] +dummy82*_b[dummy82] + salvagesaledummy*_b[salvagesaledummy] ///
+lnroad4*_b[lnroad4] + lnlogging4*_b[lnlogging4] + lnvolume*_b[lnvolume] + density*_b[density] ///
+lnmfgcost4*_b[lnmfgcost4]+lnsellingvalue4*_b[lnsellingvalue4]+advertisedrate4_log*_b[advertisedrate4] ///
+specieshhi*_b[specieshhi]+contractlength*_b[contractlength])-(_b[1.unob_mills]*1.unob_mills+_b[2.unob_mills]*2.unob_mills ///
+_b[3.unob_mills]*3.unob_mills+_b[4.unob_mills]*4.unob_mills+_b[5.unob_mills]*5.unob_mills+_b[6.unob_mills]*6.unob_mills ///
+_b[7.unob_mills]*7.unob_mills+_b[8.unob_mills]*8.unob_mills+_b[9.unob_mills]*9.unob_mills+_b[10.unob_mills]*10.unob_mills ///
+_b[1.unob_loggers]*1.unob_loggers+_b[2.unob_loggers]*2.unob_loggers+_b[3.unob_loggers]*3.unob_loggers+_b[4.unob_loggers]*4.unob_loggers ///
+_b[5.unob_loggers]*5.unob_loggers+_b[6.unob_loggers]*6.unob_loggers+_b[7.unob_loggers]*7.unob_loggers+_b[8.unob_loggers]*8.unob_loggers ///
+_b[9.unob_loggers]*9.unob_loggers+_b[10.unob_loggers]*10.unob_loggers+_b[1.unob_sb]*1.unob_sb+_b[2.unob_sb]*2.unob_sb ///
+_b[3.unob_sb]*3.unob_sb+_b[4.unob_sb]*4.unob_sb+_b[5.unob_sb]*5.unob_sb+_b[6.unob_sb]*6.unob_sb+_b[7.unob_sb]*7.unob_sb ///
+_b[8.unob_sb]*8.unob_sb+_b[9.unob_sb]*9.unob_sb+_b[10.unob_sb]*10.unob_sb)

predict bidlog_preds_unob, xb

gen bidlog_resids_unob = bid4_log-bidlog_preds_unob


keep unob_mills unob_loggers unob_sb ///
bid4_log bidloghomo bidloghomo_unob bidlog_resids bidlog_preds bidlog_resids_unob bidlog_preds_unob

export excel using "homotimberauctionbids.xlsx", firstrow(variables)
