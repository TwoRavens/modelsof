*********ANALYSIS FOR DETERMINANTS OF FOREIGN AID, RIVALRY, AND DOMESTIC INSTABILITY*************

tsset dyad year

***Table 1
*Model 1
logit aid l.irregular_turnover l.lngdppc2 l.polity2 l.lnpopWB2 l.physint2 l.tradedepB l.tradeopennessB l.lngdppc1 l.lnpopWB1 l.colony l.defense l.lndistance post_Cold_War aidyear aidyear2 aidyear3 , cluster(dyad)
estat ic

*Model 2
reg lnamount l.irregular_turnover l.lngdppc2 l.polity2 l.lnpopWB2 l.physint2 l.tradedepB l.tradeopennessB l.lngdppc1 l.lnpopWB1 l.colony l.defense l.lndistance post_Cold_War l.lnamount , cluster(dyad)

*Model 3
set seed 123456789
reg lnamountl irregular_turnover lngdppc2 polity2 lnpopWB2 physint2 tradedepB tradeopennessB lngdppc1 lnpopWB1 colony defense lndistance post_Cold_War lnamount imrv, vce(boot)

*Model 4
logit aid l.civilwar l.assassination  l.riot l.irregular_turnover l.lngdppc2 l.polity2 l.lnpopWB2 l.physint2 l.tradedepB l.tradeopennessB l.lngdppc1 l.lnpopWB1 l.colony l.defense l.lndistance post_Cold_War aidyear aidyear2 aidyear3 , cluster(dyad)
estat ic

*Model 5
reg lnamount l.civilwar l.assassination  l.riot l.irregular_turnover l.lngdppc2 l.polity2 l.lnpopWB2 l.physint2 l.tradedepB l.tradeopennessB l.lngdppc1 l.lnpopWB1 l.colony l.defense l.lndistance post_Cold_War l.lnamount , cluster(dyad)

*Model 6
set seed 123456789
reg lnamountl civilwar assassination  riot irregular_turnover lngdppc2 polity2 lnpopWB2 physint2 tradedepB tradeopennessB lngdppc1 lnpopWB1 colony defense lndistance post_Cold_War lnamount imrb, vce(boot)


***Table 2
*Model 7
logit aid l.kgd06riv l.civilwar l.assassination  l.riot l.irregular_turnover l.lngdppc2 l.polity2 l.lnpopWB2 l.physint2 l.tradedepB l.tradeopennessB l.lngdppc1 l.lnpopWB1 l.colony l.defense l.lndistance post_Cold_War aidyear aidyear2 aidyear3 , cluster(dyad)
estat ic

*Model 8
reg lnamount l.kgd06riv l.civilwar l.assassination  l.riot l.irregular_turnover l.lngdppc2 l.polity2 l.lnpopWB2 l.physint2 l.tradedepB l.tradeopennessB l.lngdppc1 l.lnpopWB1 l.colony l.defense l.lndistance post_Cold_War l.lnamount , cluster(dyad)

*Model 9
set seed 123456789
reg lnamountl kgd06riv civilwar assassination  riot irregular_turnover lngdppc2 polity2 lnpopWB2 physint2 tradedepB tradeopennessB lngdppc1 lnpopWB1 colony defense lndistance post_Cold_War lnamount imrr, vce(boot)

*Model 10
logit aid l.kgd06riv l.civilwar l.assassination l.riot l.irregular_turnover l.kgdcivilwar l.kgdassassination  l.kgdriot l.kdgirregular   l.lngdppc2 l.polity2 l.lnpopWB2 l.physint2 l.tradedepB l.tradeopennessB l.lngdppc1 l.lnpopWB1 l.colony l.defense l.lndistance post_Cold_War aidyear aidyear2 aidyear3 , cluster(dyad)
estat ic

*Model 11
reg lnamount l.kgd06riv l.civilwar l.assassination  l.riot l.irregular_turnover l.kgdcivilwar l.kgdassassination  l.kgdriot l.kdgirregular   l.lngdppc2 l.polity2 l.lnpopWB2 l.physint2 l.tradedepB l.tradeopennessB l.lngdppc1 l.lnpopWB1 l.colony l.defense l.lndistance post_Cold_War l.lnamount , cluster(dyad)

*Model 12
set seed 123456789
reg lnamountl kgd06riv civilwar assassination  riot irregular_turnover kgdcivilwar kgdassassination kgdriot kdgirregular lngdppc2 polity2 lnpopWB2 physint2 tradedepB tradeopennessB lngdppc1 lnpopWB1 colony defense lndistance post_Cold_War lnamount imrt, vce(boot)


***TABLE 3
*Model 13
logit aid l.kgd06riv  l.kgdcivilwar l.kgdassassination  l.kgdriot l.kdgirregular l.kgdlngppc2 l.kgdpolity2 l.kgdlnpopWB2 l.kgdphysint2 l.kgdtradedepB l.kgdtradeopenB l.kgdlngppc1 l.kgdllnpop1 l.kgdcolony l.kgddefense l.kgddistance l.kgdCW kgdaidyear kgdaiyear2 kdgaidyear3 l.civilwar l.assassination  l.riot l.irregular_turnover l.lngdppc2 l.polity2 l.lnpopWB2 l.physint2 l.tradedepB l.tradeopennessB l.lngdppc1 l.lnpopWB1 l.colony l.defense l.lndistance post_Cold_War aidyear aidyear2 aidyear3 , cluster(dyad)
estat ic

*Model 14
reg lnamount l.kgd06riv  l.kgdcivilwar l.kgdassassination  l.kgdriot l.kdgirregular l.kgdlngppc2 l.kgdpolity2 l.kgdlnpopWB2 l.kgdphysint2 l.kgdtradedepB l.kgdtradeopenB l.kgdlngppc1 l.kgdllnpop1 l.kgdcolony l.kgddefense l.kgddistance l.kgdCW l.kgdlndistribute1 l.civilwar l.assassination  l.riot l.irregular_turnover l.lngdppc2 l.polity2 l.lnpopWB2 l.physint2 l.tradedepB l.tradeopennessB l.lngdppc1 l.lnpopWB1 l.colony l.defense l.lndistance post_Cold_War l.lnamount , cluster(dyad)

*Model 15
set seed 123456789
reg lnamountl kgd06riv kgdcivilwar kgdassassination  kgdriot kdgirregular kgdlngppc2 kgdpolity2 kgdlnpopWB2 kgdphysint2 kgdtradedepB kgdtradeopenB kgdlngppc1 kgdllnpop1 kgdcolony kgddefense kgddistance kgdCW kgdlndistribute1 kgdimrf civilwar assassination  riot irregular_turnover lngdppc2 polity2 lnpopWB2 physint2 tradedepB tradeopennessB lngdppc1 lnpopWB1 colony defense lndistance post_Cold_War lnamount imrf, vce(boot)
