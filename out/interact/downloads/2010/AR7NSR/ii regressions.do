*REGIONAL PTA REGRESSIONS (TABLE 2)


use "gravity data.dta", clear


gen pta_ptanum=pta*ptanum
gen prepta_ptanum=prepta*ptanum
quietly tab pta_ptanum, gen(ptadum)
quietly tab prepta_ptanum, gen(preptadum)


rename ptadum2 afta
rename preptadum2 pafta
rename ptadum3 andpact
rename preptadum3 pandpact
rename ptadum4 anzcerta
rename preptadum4 panzcerta
rename ptadum5 cacm
rename preptadum5 pcacm
rename ptadum6 caricom
rename preptadum6 pcaricom
rename ptadum7 ceao
rename preptadum7 pceao
rename ptadum8 comesa
rename preptadum8 pcomesa
rename ptadum9 eac
rename preptadum9 peac
rename ptadum10 ec6
rename preptadum10 pec6
rename ptadum11 ecbul
rename preptadum11 pecbul
rename ptadum12 eccypmal
rename preptadum12 peccypmal
rename ptadum13 ecefta
rename preptadum13 pecefta
rename ptadum14 ecenlg1
rename preptadum14 pecenlg1
rename ptadum15 ecenlg2
rename preptadum15 pecenlg2
rename ptadum16 ecenlg3
rename preptadum16 pecenlg3
rename ptadum17 ecenlg4
rename preptadum17 pecenlg4
rename ptadum18 echun
rename preptadum18 pechun
rename ptadum19 ecowas
rename preptadum19 pecowas
rename ptadum20 ecpol
rename preptadum20 pecpol
rename ptadum21 ecrom
rename preptadum21 pecrom
rename ptadum22 ecturk
rename preptadum22 pecturk
rename ptadum23 eea
rename preptadum23 peea
rename ptadum24 efta
rename preptadum24 pefta
rename ptadum25 eftabul
rename preptadum25 peftabul
rename ptadum26 eftahun
rename preptadum26 peftahun
rename ptadum27 eftaisr
rename preptadum27 peftaisr
rename ptadum28 eftapol
rename preptadum28 peftapol
rename ptadum29 eftarom
rename preptadum29 peftarom
rename ptadum30 eftatur
rename preptadum30 peftatur
rename ptadum31 gcc
rename preptadum31 pgcc
rename ptadum32 mano
rename preptadum32 pmano
rename ptadum33 merc
rename preptadum33 pmerc
rename ptadum34 nafta
rename preptadum34 pnafta
rename ptadum35 usisr
rename preptadum35 pusisr


sort dyadpta year


regress lnimpshare l.lnimpshare d.lngdp d.lnpop lndist contig commlang alliance mid demdyad gattdyad afta pafta andpact pandpact anzcerta panzcerta cacm pcacm caricom pcaricom ceao pceao comesa pcomesa eac peac ec6 pec6 ecbul pecbul echun pechun ecpol pecpol ecrom pecrom eccypmal peccypmal ecefta pecefta  ecenlg1 pecenlg1 ecenlg2 pecenlg2 ecenlg3 pecenlg3 ecenlg4 pecenlg4 ecowas pecowas ecturk pecturk eea peea efta pefta eftabul peftabul eftahun peftahun eftaisr peftaisr eftapol peftapol eftarom peftarom eftatur peftatur gcc pgcc mano pmano merc pmerc nafta pnafta usisr pusisr, cluster(dyad)


test afta=pafta
test andpact=pandpact
test anzcerta=panzcerta
test cacm=pcacm
test caricom=pcaricom
test ceao=pceao
test comesa=pcomesa
test eac=peac
test ec6=pec6
test ecbul=pecbul
test echun=pechun
test ecpol=pecpol
test ecrom=pecrom
test eccypmal=peccypmal
test ecefta=pecefta
test ecenlg1=pecenlg1
test ecenlg2=pecenlg2
test ecenlg3=pecenlg3
test ecenlg4=pecenlg4
test ecowas=pecowas
test ecturk=pecturk
test eea=peea
test efta=pefta
test eftabul=peftabul
test eftahun=peftahun
test eftaisr=peftaisr
test eftapol=peftapol
test eftarom=peftarom
test eftatur=peftatur
test gcc=pgcc
test mano=pmano
test merc=pmerc
test nafta=pnafta
test usisr=pusisr



*DYADIC PTA REGRESSIONS (TO CREATE PTA EFFECT VARIABLE)


use "gravity data.dta", clear


gen long dyadpta_pta=dyadpta*pta
gen long dyadpta_prepta=dyadpta*prepta

quietly tab dyadpta_pta, gen(ptadum)
quietly tab dyadpta_prepta, gen(preptadum)


regress lnimpshare l.lnimpshare d.lngdp d.lnpop lndist contig commlang alliance mid demdyad gattdyad ptadum2-ptadum1281 preptadum2-preptadum1281, cluster(dyad)




*INTRA-PTA LIBERALIZATION REGRESSIONS (TABLE 3)


use "pta data.dta", clear


reg ptaeffect propint alliance demhome lnexpshare asymmetry dsm veto facsim, cluster(ptanum)

reg ptaeffect propint alliance demhome lnexpshare asymmetry dsm veto facsim d1970 d1980 d1990 europe latin africa, cluster(ptanum)

reg ptaeffect propint alliance demhome lnexpshare asymmetry dsm veto facsim if ecassoc==0 & eftassoc==0, cluster(ptanum)




