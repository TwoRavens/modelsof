tsset icpsr year

xtpcse polarization shifts gini south professionalism dividedgvt tpos chambersize pcturban time, correlation(ar1) rhotype(tscorr) pairwise
margins, at(shifts==0)
margins, at(shifts==2)

xtpcse polarization partycomp gini south professionalism dividedgvt tpos chambersize pcturban time, correlation(ar1) rhotype(tscorr) pairwise
margins, at(partycomp==.01)
margins, at(partycomp==.23)

xtpcse polarization prespartycomp gini south professionalism dividedgvt tpos chambersize pcturban time, correlation(ar1) rhotype(tscorr) pairwise
margins, at(prespartycomp==.0126)
margins, at(prespartycomp==.1391)

xtpcse polarization ratiodtor gini south professionalism dividedgvt tpos chambersize pcturban time, correlation(ar1) rhotype(tscorr) pairwise
margins, at(ratiodtor==.0408)
margins, at(ratiodtor==.6159)

xtpcse polarization margin gini south professionalism dividedgvt tpos chambersize pcturban time, correlation(ar1) rhotype(tscorr) pairwise
margins, at(margin==.05)
margins, at(margin==.5035)

xtpcse polarization aldrich gini south professionalism dividedgvt tpos chambersize pcturban time, correlation(ar1) rhotype(tscorr) pairwise
margins, at(aldrich==1.5743)
margins, at(aldrich==1.9968)

xtpcse polarization partycomp gini south professionalism dividedgvt tpos chambersize pcturban time, correlation(ar1) rhotype(tscorr) pairwise
margins, at(professionalism==.0652)
margins, at(professionalism==.3390)
margins, at(tpos==1)
margins, at(tpos==5)
margins, at(south==0)
margins, at(south==1)
margins, at(pcturban==51.8)
margins, at(pcturban==90.6)
margins, at(chambersize==51.9)
margins, at(chambersize==159.10)

xtreg polarization partycomp gini professionalism dividedgvt pcturban time, fe

xtreg polarization margin gini professionalism dividedgvt pcturban time, fe

xtreg polarization aldrich gini professionalism dividedgvt pcturban time, fe

xtreg polarization prespartycomp gini professionalism dividedgvt pcturban time, fe

xtreg polarization ratiodtor gini professionalism dividedgvt pcturban time, fe

xtreg polarization shifts gini professionalism dividedgvt pcturban time, fe


