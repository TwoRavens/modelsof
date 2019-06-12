*Model 1
reg lndead gpro dem strength numgrps duration gdp1000 int1 int2 int3, cluster(id)

*Model 2 (include W)
reg lndead w dem strength numgrps duration gdp1000 int1 int2 int3, cluster(id)

*Model 3 (include interaction)
reg lndead gpro dem demgpro strength numgrps duration gdp1000 int1 int2 int3, cluster(id)

*Model 4 (include territory dummy)
reg lndead gpro dem demgpro strength numgrps duration gdp1000 int1 int2 int3 terr, cluster(id)

*Model 5 (gov't conflicts)
reg lndead gpro dem demgpro strength numgrps duration gdp1000 int1 int2 int3 if terr==0, cluster(id)

*Model 6 (territorial conflicts)
reg lndead gpro dem demgpro strength numgrps duration gdp1000 int1 int2 int3 if terr==1, cluster(id)

*Heckman model
heckman lndead w dem terr strength numgrps duration gdp1000 int1 int2 int3, select(uonset =w lgdpen lpop lmtnest polity2) twostep





