/*Estimating the effects of IMF loans on Human Rights _ Eriksen & de Soysa _JPR_100108*/

set mem 15m
use eds_jpr_repdata, clear
sort cow year
tsset cow year


/*Replicate POE, TATE, and KEITH with CIRI data  (Not Reported_JPR)*/

xi: xtpcse physint lngnipc growth democ_dummy iplegalbrit iplegalsocialist ipethfrac ipoil lnpop civil_war civpeaceyrs interstate_war intpeaceyrs year if netimfgdp~=., pairwise corr(ar1)

xi: newey physint lngnipc growth democ_dummy iplegalbrit iplegalsocialist ipethfrac ipoil lnpop civil_war civpeaceyrs interstate_war intpeaceyrs i.year if netimfgdp~=., force lag(1)


/*Regressions of base model with total debt (Not reported_JPR)*/

xi: xtpcse physint lntotdebtgdp lngnipc growth democ_dummy iplegalbrit iplegalsocialist ipethfrac ipoil lnpop civil_war civpeaceyrs interstate_war intpeaceyrs year , pairwise corr(ar1) 

xi: newey physint lntotdebtgdp lngnipc growth democ_dummy iplegalbrit iplegalsocialist ipethfrac ipoil lnpop civil_war civpeaceyrs interstate_war intpeaceyrs i.year, force lag(1)


/*Regressions of base model with total debt & international financial flows (TABLE I _ JPR)*/

xi: xtpcse physint netimfgdp negaimfgdp netibrdgdp negaibrdgdp netidagdp negaidagdp netrdbgdp negardbgdp netothergdp negaothergdp lntotdebtgdp  lngnipc growth democ_dummy iplegalbrit iplegalsocialist ipethfrac ipoil lnpop civil_war civpeaceyrs interstate_war intpeaceyrs year , pairwise corr(ar1)

xi: newey physint netimfgdp negaimfgdp netibrdgdp negaibrdgdp netidagdp negaidagdp netrdbgdp negardbgdp netothergdp negaothergdp lntotdebtgdp  lngnipc growth democ_dummy iplegalbrit iplegalsocialist ipethfrac ipoil lnpop civil_war civpeaceyrs interstate_war intpeaceyrs i.year, force lag(1)

xi: xtpcse physint netimfgdp negaimfgdp netibrdgdp negaibrdgdp netidagdp negaidagdp lntotdebtgdp  lngnipc growth democ_dummy iplegalbrit iplegalsocialist ipethfrac ipoil lnpop civil_war civpeaceyrs interstate_war intpeaceyrs year , pairwise corr(ar1)

xi: newey physint netimfgdp negaimfgdp netibrdgdp negaibrdgdp netidagdp negaidagdp lntotdebtgdp lngnipc growth democ_dummy iplegalbrit iplegalsocialist ipethfrac ipoil lnpop civil_war civpeaceyrs interstate_war intpeaceyrs i.year, force lag(1)


/*with selection effects from Rodwan Abouharb*/

xi: xtpcse physint IMFindirecteffect3rd netimfgdp negaimfgdp netibrdgdp negaibrdgdp netidagdp negaidagdp netrdbgdp negardbgdp netothergdp negaothergdp lntotdebtgdp  lngnipc growth democ_dummy iplegalbrit iplegalsocialist ipethfrac ipoil lnpop civil_war civpeaceyrs interstate_war intpeaceyrs year , pairwise corr(ar1)


/*sensitivity tests with LDV (Table II_JPR)*/

xi: xtpcse physint l.physint netimfgdp negaimfgdp netibrdgdp negaibrdgdp netidagdp negaidagdp netrdbgdp negardbgdp netothergdp negaothergdp lntotdebtgdp  lngnipc growth democ_dummy iplegalbrit iplegalsocialist ipethfrac ipoil lnpop civil_war civpeaceyrs interstate_war intpeaceyrs year , pairwise

xi: xtpcse physint l.physint netimfgdp negaimfgdp netibrdgdp negaibrdgdp netidagdp negaidagdp lntotdebtgdp  lngnipc growth democ_dummy iplegalbrit iplegalsocialist ipethfrac ipoil lnpop civil_war civpeaceyrs interstate_war intpeaceyrs year , pairwise 


/*Testing the ratio multilateral debt to total debt burden  (Table III_JPR)*/

xi: xtpcse physint multidebtpertotdebt netimfgdp negaimfgdp netibrdgdp negaibrdgdp netidagdp negaidagdp lngnipc growth democ_dummy iplegalbrit iplegalsocialist ipethfrac ipoil lnpop civil_war civpeaceyrs interstate_war intpeaceyrs year , pairwise corr(ar1)

xi: newey physint multidebtpertotdebt netimfgdp negaimfgdp netibrdgdp negaibrdgdp netidagdp negaidagdp lngnipc growth democ_dummy iplegalbrit iplegalsocialist ipethfrac ipoil lnpop civil_war civpeaceyrs interstate_war intpeaceyrs i.year, force lag(1)


/*Tests of neo-liberal policy and government finance on human rights (Table IV_JPR)*/

xi: xtpcse physint educgni lngnipc growth democ_dummy iplegalbrit iplegalsocialist ipethfrac ipoil lnpop civil_war civpeaceyrs interstate_war intpeaceyrs year if e(sample), pairwise corr(ar1)

xi: xtpcse physint govt lngnipc growth democ_dummy iplegalbrit iplegalsocialist ipethfrac ipoil lnpop civil_war civpeaceyrs interstate_war intpeaceyrs year if e(sample), pairwise corr(ar1)

xi: xtpcse physint educgni govt lngnipc growth democ_dummy iplegalbrit iplegalsocialist ipethfrac ipoil lnpop civil_war civpeaceyrs interstate_war intpeaceyrs year if e(sample) , pairwise corr(ar1)

xi: xtpcse physint ipef lngnipc growth democ_dummy iplegalbrit iplegalsocialist ipethfrac ipoil lnpop civil_war civpeaceyrs interstate_war intpeaceyrs year if e(sample), pairwise corr(ar1)

/*with selection effects*/
xi: xtpcse physint IMFindirecteffect3rd ipef lngnipc growth democ_dummy iplegalbrit iplegalsocialist ipethfrac ipoil lnpop civil_war civpeaceyrs interstate_war intpeaceyrs year if e(sample), pairwise corr(ar1)

/*with LDV*/
xi: xtpcse physint l.physint ipef lngnipc growth democ_dummy iplegalbrit iplegalsocialist ipethfrac ipoil lnpop civil_war civpeaceyrs interstate_war intpeaceyrs year , pairwise 


/*additional tests and sensitivity analyses_reply to reviewers*/
xi: xtpcse physint aidgni netimfgdp negaimfgdp netibrdgdp negaibrdgdp netidagdp negaidagdp lntotdebtgdp lngnipc growth democ_dummy iplegalbrit iplegalsocialist ipethfrac ipoil lnpop civil_war civpeaceyrs interstate_war intpeaceyrs year , pairwise corr(ar1)
xi: newey physint aidgni netimfgdp negaimfgdp netibrdgdp negaibrdgdp netidagdp negaidagdp lntotdebtgdp  lngnipc growth democ_dummy iplegalbrit iplegalsocialist ipethfrac ipoil lnpop civil_war civpeaceyrs interstate_war intpeaceyrs i.year, force lag(1)
xi: xtpcse educgni lngnipc lnpop ipoil democ_dummy  lntotdebtgdp netibrdgdp negaibrdgdp netidagdp negaidagdp netimfgdp negaimfgdp year, pairwise corr(ar1)
xi: xtpcse govt lngnipc lnpop ipoil democ_dummy lntotdebtgdp netibrdgdp negaibrdgdp netidagdp negaidagdp netimfgdp negaimfgdp year, pairwise corr(ar1)

*******summary stats**************
sum physint multidebtpertotdebt netimfcongdp negaimfnoncongdp netimfgdp negaimfgdp netibrdgdp negaibrdgdp netidagdp negaidagdp netrdbgdp negardbgdp netothergdp negaothergdp lntotdebtgdp  lngnipc growth democ_dummy iplegalbrit iplegalsocialist ipethfrac ipoil lnpop civil_war civpeaceyrs interstate_war intpeaceyrs aidgni educgni govt ipef IMFindirecteffect3rd if e(sample)

exit 