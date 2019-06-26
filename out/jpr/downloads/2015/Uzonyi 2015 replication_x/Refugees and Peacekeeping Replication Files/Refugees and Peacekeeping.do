****Table 1:
*Model 1: 
logit contribute laglogref yrssincecontribute yrssincecontribute2 yrssincecontribute3, cluster(dyad)

*Model 2: 
logit contribute laglogref lagpolity2 lagloggdppc laglogmilper laglogdistance laglogpop lagjteth lagally lagcolony laglogtotalrefs lagmasskilling laglogothercontributors lagp5 yrssincecontribute yrssincecontribute2 yrssincecontribute3 if year<2008, cluster(dyad)

*Model 3: 
logit contribute laglogref lagpolity2 lagloggdppc laglogcinc laglogdistance laglogpop lagjteth lagally lagcolony laglogtotalrefs lagmasskilling laglogothercontributors lagp5 yrssincecontribute yrssincecontribute2 yrssincecontribute3 if year<2008, cluster(dyad)

*Model 4: 
logit contribute laglogref lagpolity2 lagloggdppc laglogmilper laglogpop lagjteth lagally lagcolony laglogtotalrefs lagmasskilling laglogothercontributors lagp5 yrssincecontribute yrssincecontribute2 yrssincecontribute3 if year<2008, cluster(dyad)

*Model 5: 
xtset missioncode
xtlogit contribute laglogref lagpolity2 lagloggdppc laglogmilper laglogdistance laglogpop lagjteth lagally lagcolony laglogtotalrefs lagmasskilling laglogothercontributors lagp5 yrssincecontribute yrssincecontribute2 yrssincecontribute3 if year<2008, fe

*****Table 2:
*Model 6: 
zinb maxtroops laglogref laglogmaxtroops, cluster(dyad) inflate(laglogref yrssincecontribute yrssincecontribute2 yrssincecontribute3)

*Model 7: 
zinb maxtroops laglogref lagpolity2 lagloggdppc laglogmilper laglogdistance laglogpop lagjteth lagally lagcolony laglogtotalrefs lagmasskilling laglogothercontributors lagp5 laglogmaxtroops if year<2008, cluster(dyad) inflate(laglogref lagpolity2 lagloggdppc laglogmilper laglogdistance laglogpop lagjteth lagally lagcolony laglogtotalrefs lagmasskilling laglogothercontributors lagp5 yrssincecontribute yrssincecontribute2 yrssincecontribute3)

*Model 8: 
zinb maxtroops laglogref lagpolity2 lagloggdppc laglogcinc laglogdistance laglogpop lagjteth lagally lagcolony laglogtotalrefs lagmasskilling laglogothercontributors lagp5 laglogmaxtroops if year<2008, cluster(dyad) inflate(laglogref lagpolity2 lagloggdppc laglogcinc laglogdistance laglogpop lagjteth lagally lagcolony laglogtotalrefs lagmasskilling laglogothercontributors lagp5 yrssincecontribute yrssincecontribute2 yrssincecontribute3)

*Model 9: 
zinb maxtroops laglogref lagpolity2 lagloggdppc laglogmilper laglogpop lagjteth lagally lagcolony laglogtotalrefs lagmasskilling laglogothercontributors lagp5 laglogmaxtroops if year<2008, cluster(dyad) inflate(laglogref lagpolity2 lagloggdppc laglogmilper laglogpop lagjteth lagally lagcolony laglogtotalrefs lagmasskilling laglogothercontributors lagp5 yrssincecontribute yrssincecontribute2 yrssincecontribute3)


