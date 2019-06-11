**Models in Paper**
tsset dyadid year
**Model 1**
xtreg sun3cati l.sun3cati l5.hsubs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
**Model 2**
xtreg sun3cati l.sun3cati l5.jtIGOsubs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
**Model 3**
xtreg sun3cati l.sun3cati l5.minmtgs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
**Model 4**
xtreg sun3cati l.sun3cati l5.secretariat dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
**Model 5**
xtreg sun3cati l.sun3cati l5.secretariat l5.minmtgs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
**Model 6**
xtreg sun3cati l.sun3cati l5.jtIGOsubsnoun dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
**Model 7**
xtreg sun3cati l.sun3cati l5.noIGOs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
**Model 8**
xtreg sun3cati l.sun3cati l5.noIGOs l5.hsubs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
**Model 9**
xtreg sun3cati l.sun3cati l5.noIGOs l5.jtIGOsubs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
**Model 10**
xtreg sun3cati l.sun3cati l5.jtIGOsubs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe vce (jack)

**BASE MODELS**
tsset dyadid year
xtreg sun3cati l.sun3cati l5.hsubs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.jtIGOsubs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.secretariat dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.minmtgs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.secretariat l5.minmtgs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)

**Dropping UN from IGO variables**
tsset dyadid year
xtreg sun3cati l.sun3cati l5.hsubsnoun dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.jtIGOsubsnoun dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.secretariatwoun dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)xtreg sun3cati l.sun3cati l5.hsubsnouneeceu dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.minmtgsnoun dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)

**Dropping UN, EEC, and EU from IGO variables**
xtreg sun3cati l.sun3cati l5.jtIGOsubsnouneeceu dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.secretariatwouneeceu dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.minmtgsnouneeceu dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.secretariatwouneeceu l5.minmtgsnouneeceu dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)

**Total number of IGOs in model with Taninchev IGO variables**
tsset dyadid year
xtreg sun3cati l.sun3cati l5.noIGOs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.noIGOs l5.hsubs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.noIGOs l5.jtIGOsubs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.noIGOs l5.secretariat dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.noIGOs l5.minmtgs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)

**Stuctured interventionist IGO variable with Taninchev IGO variables**
tsset dyadid year
xtreg sun3cati l.sun3cati l5.IGOstrintv dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.IGOstrintv l5.hsubs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.IGOstrintv l5.jtIGOsubs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.IGOstrintv l5.secretariat dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.IGOstrintv l5.minmtgs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)

**Lagging all variables 5 years**
tsset dyadid year
xtreg sun3cati l.sun3cati l5.hsubs l5.dompoldiff l5.dependL l5.allies l5.lncapratio l5.releconsize l5.relecondev l5.coldwar l5.contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.jtIGOsubs l5.dompoldiff l5.dependL l5.allies l5.lncapratio l5.releconsize l5.relecondev l5.coldwar l5.contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.secretariat l5.dompoldiff l5.dependL l5.allies l5.lncapratio l5.releconsize l5.relecondev l5.coldwar l5.contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.minmtgs l5.dompoldiff l5.dependL l5.allies l5.lncapratio l5.releconsize l5.relecondev l5.coldwar l5.contiguity, fe robust cluster (dyadid)
**Also lagging LDV 5 years**
tsset dyadid year
xtreg sun3cati l5.sun3cati l5.hsubs l5.dompoldiff l5.dependL l5.allies l5.lncapratio l5.releconsize l5.relecondev l5.coldwar l5.contiguity, fe robust cluster (dyadid)
xtreg sun3cati l5.sun3cati l5.jtIGOsubs l5.dompoldiff l5.dependL l5.allies l5.lncapratio l5.releconsize l5.relecondev l5.coldwar l5.contiguity, fe robust cluster (dyadid)
xtreg sun3cati l5.sun3cati l5.secretariat l5.dompoldiff l5.dependL l5.allies l5.lncapratio l5.releconsize l5.relecondev l5.coldwar l5.contiguity, fe robust cluster (dyadid)
xtreg sun3cati l5.sun3cati l5.minmtgs l5.dompoldiff l5.dependL l5.allies l5.lncapratio l5.releconsize l5.relecondev l5.coldwar l5.contiguity, fe robust cluster (dyadid)

**Varying Lags of High Substructures IGO Membership**
tsset dyadid year
xtreg sun3cati l.sun3cati l.hsubs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l2.hsubs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l3.hsubs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l4.hsubs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.hsubs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)

**Varying Lags of Joint IGO Substructures**
tsset dyadid year
xtreg sun3cati l.sun3cati l.jtIGOsubs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l2.jtIGOsubs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l3.jtIGOsubs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l4.jtIGOsubs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.jtIGOsubs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)

**Varying Lags of Secretariat and Technical Divisions**
tsset dyadid year
xtreg sun3cati l.sun3cati l.secretariat dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l2.secretariat dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l3.secretariat dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l4.secretariat dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.secretariat dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)

**Varying Lags of Ministerial Bodies**
tsset dyadid year
xtreg sun3cati l.sun3cati l.minmtgs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l2.minmtgs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l3.minmtgs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l4.minmtgs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.minmtgs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)

**DemLow (lower of democ-autoc) robustness tests**
**With only DemLow**
tsset dyadid year
xtreg sun3cati l.sun3cati l5.hsubs demL dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.jtIGOsubs demL dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.secretariat demL dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.minmtgs demL dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
**With both dompoldiff and demL2**
tsset dyadid year
xtreg sun3cati l.sun3cati l5.hsubs dompoldiff demL dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.jtIGOsubs dompoldiff demL dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.secretariat dompoldiff demL dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)
xtreg sun3cati l.sun3cati l5.minmtgs dompoldiff demL dependL allies lncapratio releconsize relecondev coldwar contiguity, fe robust cluster (dyadid)

**Bootstrapping models**
tsset dyadid year
xtreg sun3cati l.sun3cati l5.hsubs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe vce (boot, rep(100))
xtreg sun3cati l.sun3cati l5.jtIGOsubs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe vce (boot, rep(100))
xtreg sun3cati l.sun3cati l5.secretariat dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe vce (boot, rep(100))
xtreg sun3cati l.sun3cati l5.minmtgs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe vce (boot, rep(100))
xtreg sun3cati l.sun3cati l5.secretariat l5.minmtgs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe vce (boot, rep(100))

**Base models with Jacknifed standard errors**
**WARNING: Each of these tests takes about 40 hours to run because they make 12,740 replications!**
tsset dyadid year
xtreg sun3cati l.sun3cati l5.hsubs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe vce (jack)
xtreg sun3cati l.sun3cati l5.jtIGOsubs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe vce (jack)
xtreg sun3cati l.sun3cati l5.secretariat dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe vce (jack)
xtreg sun3cati l.sun3cati l5.minmtgs dompoldiff dependL allies lncapratio releconsize relecondev coldwar contiguity, fe vce (jack)

