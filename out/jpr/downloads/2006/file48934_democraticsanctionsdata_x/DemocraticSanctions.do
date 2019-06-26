*Setup
gen dyadcode=(ccode1*1000)+ccode2
tsset dyadcode year
label variable dyadcode "Dyad ID Code"

*General recodes
recode sanction .=0
recode expab 0=.
recode impab 0=.
recode tottra 0=.
recode politya -99=.
recode polityb -99=.

*Label Variables
label variable sanction "Sanction Onset"
label variable ccode1 "Country Code for Actor"
label variable ccode2 "Country Code for Target"
label variable year "Year"
label variable alliance "Alliance Type"
label variable politya "Polity Score for Actor"
label variable polityb "Polity Score for Target"
label variable expab "Exports from Sender to Target"
label variable impab "Imports from Target to Sender"
label variable tottra "Total Bilateral Trade"
label variable expba "Exports from Target to Sender"
label variable impba "Imports from Sender to Target"
label variable rgdpca "Sender's GDP Per Capita"
label variable rgdpcb "Target's GDP Per Capita"

*Generate ally dummy variable
gen ally=alliance
recode ally 4=0 *=1
label variable ally "Alliance between Dyad Members"

*Generate democracy variables
gen sdem=politya
recode sdem -10/3=0 4/10=1
label variable sdem "Sender Democracy/Autocracy"
gen tdem=polityb
recode tdem -10/3=0 4/10=1
label variable tdem "Target Democracy/Autocracy"
gen demdyad=sdem+tdem
recode demdyad 1=0 2=1
label variable demdyad "Democratic Dyad"

*Generate US dummy variable
gen us=ccode1
recode us 2=1 *=0
label variable us "United States"

*Generate relative power variable
recode rgdpca 0=.
recode rgdpcb 0=.
gen relpow=rgdpca/rgdpcb
label variable relpow "Relative Power Between Sender and Target"

*Generate logged trade variables
gen lnexp=ln(expab)
label variable lnexp "Logged Exports from Sender"
gen lnimp=ln(impab)
label variable lnimp "Logged Imports from Target"
gen lnttrde=ln(tottra)
label variable lnttrde "Logged Total Bilateral Trade"

*Generate temporal dependence variables
btscs sanction year ccode1 ccode2, g(sancyear) nspline(3)

*Analysis
relogit sanction demdyad sdem lnexp relpow ally year sancyear _spline1 _spline2 _spline3
relogit sanction demdyad sdem lnexp relpow ally us year sancyear _spline1 _spline2 _spline3
relogit sanction demdyad sdem lnimp relpow ally year sancyear _spline1 _spline2 _spline3
relogit sanction demdyad sdem lnimp relpow ally us year sancyear _spline1 _spline2 _spline3
