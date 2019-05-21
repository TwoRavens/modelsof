*Using data file: "MEVMLB_DATA_TABLE4.dta"
*These instructions begin with the command for creating the summary stats in Online Appendix II. 
*These instructions are for creating interactions as well as running models. 
sum  voteincparfirst voteinclagged winstability gdpgrowthlag tradegdp sharedrule termlimited negretlegpow freedommedia concurrentordinal majleg
xtset country time, yearly
gen gdplag_concurord= concurrentordinal* gdpgrowthlag
xtreg voteincparfirst gdpgrowthlag voteinclagged winstability tradegdp concurrentordinal gdplag_concurord, re robust
gen gdplag_sharedrule= sharedrule*gdpgrowthlag 
xtreg voteincparfirst gdpgrowthlag voteinclagged winstability tradegdp sharedrule gdplag_sharedrule, re robust
gen gdplag_termlimit=  gdpgrowthlag* termlimited
xtreg voteincparfirst gdpgrowthlag voteinclagged winstability tradegdp termlimited gdplag_termlimit, re robust
gen gdplag_freedomMedia= freedommedia* gdpgrowthlag
xtreg voteincparfirst gdpgrowthlag voteinclagged tradegdp winstability freedommedia gdplag_freedomMedia, re robust
gen gdplag_majleg = majleg*gdpgrowthlag
xtreg voteincparfirst gdpgrowthlag voteinclagged tradegdp winstability majleg gdplag_majleg, re robust
gen gdplag_Negretto= negretlegpow* gdpgrowthlag
xtreg voteincparfirst gdpgrowthlag winstability voteinclagged tradegdp negretlegpow gdplag_Negretto, re robust
