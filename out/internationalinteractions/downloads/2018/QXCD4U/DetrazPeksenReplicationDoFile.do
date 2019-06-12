*Replication Do File: Detraz, Nicole and Dursun Peksen. "The Effect of IMF Programs on Women's Economic and Political Rights" (International Interactions)

*Table I WECON Rights
cmp setup
cmp(wecon = imfdummy polity2 gdpecon indexipo Dindexipo cedawdummy lntotalfempop civilconflict nafrme  lagweconglobe trend lwecon1 lwecon2 lwecon3 ) (imfdummy = gdpecon gdpgrowth currency exchrate tradelog polity2 coldwar usalliance colbrit colfra eeurop lamerica ssafrica asia) if year>1980, nolr ind($cmp_oprobit $cmp_probit) robust quietly cluster(ccode)

cmp(wecon = imfdummy imfpolity polity2 gdpecon indexipo Dindexipo cedawdummy lntotalfempop civilconflict nafrme  lagweconglobe trend lwecon1 lwecon2 lwecon3 ) (imfdummy = gdpecon gdpgrowth currency exchrate tradelog polity2 coldwar usalliance colbrit colfra eeurop lamerica ssafrica asia) if year>1980, nolr ind($cmp_oprobit $cmp_probit) robust quietly cluster(ccode)

cmp(wecon = imfdummy imfgdp polity2 gdpecon indexipo Dindexipo cedawdummy lntotalfempop civilconflict nafrme  lagweconglobe trend lwecon1 lwecon2 lwecon3 ) (imfdummy = gdpecon gdpgrowth currency exchrate tradelog polity2 coldwar usalliance colbrit colfra eeurop lamerica ssafrica asia) if year>1980, nolr ind($cmp_oprobit $cmp_probit) robust quietly cluster(ccode)

*Table III WOPOL Rights
cmp(wopol = imfdummy polity2 gdpecon indexipo Dindexipo cedawdummy lntotalfempop civilconflict nafrme lagwopolglobe trend lwopol1 lwopol2 lwopol3) (imfdummy = gdpecon gdpgrowth currency exchrate tradelog polity2 coldwar usalliance colbrit colfra eeurop lamerica ssafrica asia) if year>1980, nolr ind($cmp_oprobit $cmp_probit) robust quietly cluster(ccode)

cmp(wopol = imfdummy imfpolity polity2 gdpecon indexipo Dindexipo cedawdummy lntotalfempop civilconflict nafrme lagwopolglobe trend lwopol1 lwopol2 lwopol3) (imfdummy = gdpecon gdpgrowth currency exchrate tradelog polity2 coldwar usalliance colbrit colfra eeurop lamerica ssafrica asia) if year>1980, nolr ind($cmp_oprobit $cmp_probit) robust quietly cluster(ccode)

cmp(wopol = imfdummy imfgdp polity2 gdpecon indexipo Dindexipo cedawdummy lntotalfempop civilconflict nafrme lagwopolglobe trend lwopol1 lwopol2 lwopol3) (imfdummy = gdpecon gdpgrowth currency exchrate tradelog polity2 coldwar usalliance colbrit colfra eeurop lamerica ssafrica asia) if year>1980, nolr ind($cmp_oprobit $cmp_probit) robust quietly cluster(ccode)

* Table II Substantive Effects
probit wecondummy imfdummy polity2 gdpecon indexipo Dindexipo cedawdummy lntotalfempop civilconflict nafrme  lagweconglobe trend, robust
* IMF impact
prvalue, x(imfdummy=0 cedawdummy=0 civilconflict=0 nafrme=0) rest(mean)

prvalue, x(imfdummy=1 cedawdummy=0 civilconflict=0 nafrme=0) rest(mean)
**OTHER CONTROLS
* Democracy Impact 1 Std. below to 1 std. above
prvalue, x( polity2=5.8 imfdummy=0 cedawdummy=0 civilconflict=0 nafrme=0) rest(mean)

prvalue, x( polity2=17.8 imfdummy=0 cedawdummy=0 civilconflict=0 nafrme=0) rest(mean)

* Differend Economic Lib 1 Std. below to 1 std. above
prvalue, x( Dindexipo=-0.09 imfdummy=0 cedawdummy=0 civilconflict=0 nafrme=0) rest(mean)

prvalue, x( Dindexipo=0.24 imfdummy=0 cedawdummy=0 civilconflict=0 nafrme=0) rest(mean)

* Cedaw Dummy
prvalue, x( imfdummy=0 cedawdummy=1 civilconflict=0 nafrme=0) rest(mean)

* Female Pop 1 Std. below to 1 std. above
prvalue, x( lntotalfempop=13.8 imfdummy=0 cedawdummy=0 civilconflict=0 nafrme=0) rest(mean)

prvalue, x( lntotalfempop=16.8 imfdummy=0 cedawdummy=0 civilconflict=0 nafrme=0) rest(mean)

* Civil Wars
prvalue, x(imfdummy=0 cedawdummy=0 civilconflict=1 nafrme=0) rest(mean)

* Global Women's Rights 1 Std. below to 1 std. above
prvalue, x( lagweconglobe=1.09 imfdummy=0 cedawdummy=0 civilconflict=0 nafrme=0) rest(mean)

prvalue, x( lagweconglobe=1.233 imfdummy=0 cedawdummy=0 civilconflict=0 nafrme=0) rest(mean)


* TABLE AI
cmp(wecon = imfsba imfsfaorprfg polity2 gdpecon indexipo Dindexipo cedawdummy lntotalfempop civilconflict nafrme lagwopolglobe trend lwecon1 lwecon2 lwecon3) (imfdummy = gdpecon gdpgrowth currency exchrate tradelog polity2 coldwar usalliance colbrit colfra eeurop lamerica ssafrica asia) if year>1980, nolr ind($cmp_oprobit $cmp_probit) robust quietly cluster(ccode)

cmp(wopol = imfsba imfsfaorprfg polity2 gdpecon indexipo Dindexipo cedawdummy  lntotalfempop civilconflict nafrme lagwopolglobe trend lwopol1 lwopol2 lwopol3) (imfdummy = gdpecon gdpgrowth currency exchrate tradelog polity2 coldwar usalliance colbrit colfra eeurop lamerica ssafrica asia) if year>1980, nolr ind($cmp_oprobit $cmp_probit) robust quietly cluster(ccode)

*Summary Statistics TABLE AII
cmp(wopol = imfdummy polity2 gdpecon indexipo Dindexipo cedawdummy lntotalfempop civilconflict nafrme lagwopolglobe trend lwopol1 lwopol2 lwopol3) (imfdummy = gdpecon gdpgrowth currency exchrate tradelog polity2 coldwar usalliance colbrit colfra eeurop lamerica ssafrica asia) if year>1980, nolr ind($cmp_oprobit $cmp_probit) robust quietly cluster(ccode)
sum wopol imfdummy imfgdp polity2 gdpecon indexipo Dindexipo cedawdummy lntotalfempop civilconflict trend lagwopolglobe gdpgrowth currency exchrate coldwar usalliance colbrit colfra nafrme eeurop lamerica ssafrica asia if e(sample)

cmp(wecon = imfdummy polity2 gdpecon indexipo Dindexipo cedawdummy lntotalfempop civilconflict nafrme  lagweconglobe trend lwecon1 lwecon2 lwecon3 ) (imfdummy = gdpecon gdpgrowth currency exchrate tradelog polity2 coldwar usalliance colbrit colfra eeurop lamerica ssafrica asia) if year>1980, nolr ind($cmp_oprobit $cmp_probit) robust quietly cluster(ccode)
sum wecon lagweconglobe if e(sample)

*Table AIII SINGLE STAGE MODELS FOR THE IMPACT OF W RIGHTS ON IMFDUMMY
logit imfdummy wecon gdplog gdpgrowth currency exchrate tradelog polity2 coldwar usalliance colbrit colfra eeurop lamerica ssafrica asia, robust

logit imfdummy wopol gdplog gdpgrowth currency exchrate tradelog polity2 coldwar usalliance colbrit colfra eeurop lamerica ssafrica asia, robust

logit imfdummy wecon wopol gdplog gdpgrowth currency exchrate tradelog polity2 coldwar usalliance colbrit colfra eeurop lamerica ssafrica asia, robust



***** ONLINE APPENDIX TABLES ******
*ROBUSTNESS CHECK : RELIGION DUMMIES ADDED
cmp(wecon = imfdummy polity2 gdpecon indexipo Dindexipo cedawdummy lntotalfempop civilconflict nafrme lagweconglobe trend budhismdom catholicdom hinduismdom islamdom protestantdom   lwecon1 lwecon2 lwecon3 ) (imfdummy = gdpecon gdpgrowth currency exchrate tradelog polity2 coldwar usalliance colbrit colfra eeurop lamerica ssafrica asia) if year>1980, nolr ind($cmp_oprobit $cmp_probit) robust quietly cluster(ccode)

cmp(wopol = imfdummy polity2 gdpecon indexipo Dindexipo cedawdummy lntotalfempop civilconflict nafrme lagwopolglobe trend budhismdom catholicdom hinduismdom islamdom protestantdom   lwopol1 lwopol2 lwopol3) (imfdummy = gdpecon gdpgrowth currency exchrate tradelog polity2 coldwar usalliance colbrit colfra eeurop lamerica ssafrica asia) if year>1980, nolr ind($cmp_oprobit $cmp_probit) robust quietly cluster(ccode)

*ROBUSTNESS CHECK : Ethnic and Religious Fractionalization
cmp(wecon = imfdummy polity2 gdpecon indexipo Dindexipo cedawdummy lntotalfempop civilconflict nafrme lagweconglobe trend ef relfrac lwecon1 lwecon2 lwecon3 ) (imfdummy = gdpecon gdpgrowth currency exchrate tradelog polity2 coldwar usalliance colbrit colfra eeurop lamerica ssafrica asia) if year>1980, nolr ind($cmp_oprobit $cmp_probit) robust quietly cluster(ccode)

cmp(wopol = imfdummy polity2 gdpecon indexipo Dindexipo cedawdummy lntotalfempop civilconflict nafrme lagwopolglobe trend ef relfrac lwopol1 lwopol2 lwopol3) (imfdummy = gdpecon gdpgrowth currency exchrate tradelog polity2 coldwar usalliance colbrit colfra eeurop lamerica ssafrica asia) if year>1980, nolr ind($cmp_oprobit $cmp_probit) robust quietly cluster(ccode)

*ROBUSTNESS CHECK : Civil war variable dropped
cmp(wecon = imfdummy polity2 gdpecon indexipo Dindexipo cedawdummy lntotalfempop nafrme lagweconglobe trend lwecon1 lwecon2 lwecon3 ) (imfdummy = gdpecon gdpgrowth currency exchrate tradelog polity2 coldwar usalliance colbrit colfra eeurop lamerica ssafrica asia) if year>1980, nolr ind($cmp_oprobit $cmp_probit) robust quietly cluster(ccode)

cmp(wopol = imfdummy polity2 gdpecon indexipo Dindexipo cedawdummy lntotalfempop nafrme lagwopolglobe trend lwopol1 lwopol2 lwopol3) (imfdummy = gdpecon gdpgrowth currency exchrate tradelog polity2 coldwar usalliance colbrit colfra eeurop lamerica ssafrica asia) if year>1980, nolr ind($cmp_oprobit $cmp_probit) robust quietly cluster(ccode)

* CORRELATION MATRIX
cmp(wecon = wopol imfdummy polity2 gdpecon liberalization Dliberalization cedawdummy lntotalfempop civilconflict nafrme  lagweconglobe lagwopolglobe trend lwecon1 lwecon2 lwecon3 ) (imfdummy = gdpecon gdpgrowth currency exchrate tradelog polity2 coldwar usalliance colbrit colfra eeurop lamerica ssafrica asia) if year>1980, nolr ind($cmp_oprobit $cmp_probit) robust quietly cluster(ccode)

corr wecon wopol imfdummy polity2 gdpecon liberalization Dliberalization cedawdummy lntotalfempop civilconflict lagweconglobe lagwopolglobe trend gdpgrowth currency exchrate tradelog coldwar usalliance colbrit colfra nafrme eeurop lamerica ssafrica asia if e(sample)






