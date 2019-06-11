cd "/Users/ykim/Desktop/ISDS"




use "Kim_main.dta", clear
xtset ccode year

### POL ###
global P1 "l.cpolity2"
global P2 "l.cfreedom"
global P3 "l.cliec"
global P4 "l.voiceAccountability"

global P5 "l.cexrec2"
global P6 "l.cexconst2"
global P7 "l.cpolcom2"
global P8 "l.ceiec"

global P13 "l.creccom"
############

### PSQ ###
global Q1 "l.polity_sq"
global Q2 "l.freedom_sq"
global Q3 "l.liec_sq"
global Q4 "l.voiceAccountability_sq"

global Q5 "l.exrec2_sq"
global Q6 "l.exconst2_sq"
global Q7 "l.polcom2_sq"
global Q8 "l.eiec_sq"

global Q13 "l.reccom_sq"
############

### ROL ###
global R1 "l.lji"
global R2 "l.FI2"
global R3 "l.lawAndOrder"
global R4 "l.ruleOfLaw"
############

global D1 "isds72"

global Y1 "i.year"
global Y2 "year"

global C1 "l.checks"
global C2 "l.polconiii"
global C3 "l.polconv"

global control "l.polariz l.lngdpcap l.left l.GDPgrowth l.cumpriv2GDP2 l.cum_n_allbit_effect l.lnFDIstock l.lngdp l.trade2GDP l.resource2 ECA LAC SSA SAS oecd if year<2014"

global oecd "& oecd==0"

global YEAR "i.year year"
global CHECK "l.checks l.polconiii l.polconv"

global fe ", fe"

global M1 "xtnbreg"
global M2 "xtlogit"

### Table 1

# Table 1-1
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' $control $oecd

# Table 1-2
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' $control $oecd

# Table 1-3
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' $control $oecd

# Table 1-4
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' $control $oecd


### Table 2

# Table 2-1
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P2"
local q="$Q2"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' $control $oecd

# Table 2-2
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P2"
local q="$Q2"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' $control $oecd

# Table 2-3
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P2"
local q="$Q2"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' $control $oecd

# Table 2-4
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P2"
local q="$Q2"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' $control $oecd

# Table 2-5
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P3"
local q="$Q3"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' $control $oecd

# Table 2-6
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P3"
local q="$Q3"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' $control $oecd

# Table 2-7
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P3"
local q="$Q3"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' $control $oecd

# Table 2-8
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P3"
local q="$Q3"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' $control $oecd

# Table 2-9
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P4"
local q="$Q4"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' $control $oecd

# Table 2-10
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P4"
local q="$Q4"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' $control $oecd

# Table 2-11
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P4"
local q="$Q4"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' $control $oecd

# Table 2-12
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P4"
local q="$Q4"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' $control $oecd

### Table 3
use "Kim_risk.dta", clear

# Table 3-1
xi:logit regRisk i.year lpolity2 lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)

# Table 3-2
xi:logit regRisk i.year lpolity2 lFI2 lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)

# Table 3-3
xi:logit regRisk i.year lFI2 lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)

# Table 3-4
xi:logit regRisk i.year lpolity2 llji lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)

# Table 3-5
xi:logit regRisk i.year llji lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)

# Table 3-6
xi:logit regRisk i.year lpolity2 llawAndOrder lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)

# Table 3-7
xi:logit regRisk i.year llawAndOrder lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)

# Table 3-8
xi:logit regRisk i.year lpolity2 lruleOfLaw lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)

# Table 3-9
xi:logit regRisk i.year lruleOfLaw lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)

# Table 3-10
xi:logit tradRisk i.year lpolity2 lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)

# Table 3-11
xi:logit tradRisk i.year lpolity2 lFI2 lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)

# Table 3-12
xi:logit tradRisk i.year lFI2 lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)

# Table 3-13
xi:logit tradRisk i.year lpolity2 llji lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)

# Table 3-14
xi:logit tradRisk i.year llji lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)

# Table 3-15
xi:logit tradRisk i.year lpolity2 llawAndOrder lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)

# Table 3-16
xi:logit tradRisk i.year llawAndOrder lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)

# Table 3-17
xi:logit tradRisk i.year lpolity2 lruleOfLaw lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)

# Table 3-18
xi:logit tradRisk i.year lruleOfLaw lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)


### Figure 2 (continue to R and use Kim International Interactions.R to produce Figure 2)
use "Kim_main.dta", clear
xtset ccode year

# Figure 2-1
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: quietly `m' `d' `y' `p' `q' `c' $control $oecd
est table, keep(`p' `q') b t p
egen ll=min(`p')
egen ul=max(`p')
local u=ll[1]
local v=ul[1]
drop ll ul
lincom `p' + `q'*`u'
lincom `p' + `q'*`v'
local g="polity2"
estimates store `g'
lincom `p' + `q'*`u'
gen lno=`u'
gen est_`g'=r(estimate)
gen se_`g'=r(se)
gen ll95_`g'=est_`g'-1.96*se_`g'
gen ul95_`g'=est_`g'+1.96*se_`g'
keep in 1
keep lno est_`g' se_`g' ll95_`g' ul95_`g'
save "`g'.dta", replace
use "Kim_main.dta", clear
local w=`u'+0.05
forvalue i=`w'(0.05)`v'{
estimates restore `g'
lincom `p' + `q'*(`i')
gen lno=`i'
gen est_`g'=r(estimate)
gen se_`g'=r(se)
gen ll95_`g'=est_`g'-1.96*se_`g'
gen ul95_`g'=est_`g'+1.96*se_`g'
keep in 1
keep lno est_`g' se_`g' ll95_`g' ul95_`g'
append using "`g'.dta"
save "`g'.dta", replace
use "Kim_main.dta", clear
}
use "`g'.dta", clear
outsheet using "`g'.csv", c replace
use "Kim_main.dta", clear

# Figure 2-2
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P2"
local q="$Q2"
local c="$C1"
local r="$R2"
xi: quietly `m' `d' `y' `p' `q' `c' $control $oecd
est table, keep(`p' `q') b t p
egen ll=min(`p')
egen ul=max(`p')
local u=ll[1]
local v=ul[1]
drop ll ul
lincom `p' + `q'*`u'
lincom `p' + `q'*`v'
local g="freedom"
estimates store `g'
lincom `p' + `q'*`u'
gen lno=`u'
gen est_`g'=r(estimate)
gen se_`g'=r(se)
gen ll95_`g'=est_`g'-1.96*se_`g'
gen ul95_`g'=est_`g'+1.96*se_`g'
keep in 1
keep lno est_`g' se_`g' ll95_`g' ul95_`g'
save "`g'.dta", replace
use "Kim_main.dta", clear
local w=`u'+0.05
forvalue i=`w'(0.05)`v'{
estimates restore `g'
lincom `p' + `q'*(`i')
gen lno=`i'
gen est_`g'=r(estimate)
gen se_`g'=r(se)
gen ll95_`g'=est_`g'-1.96*se_`g'
gen ul95_`g'=est_`g'+1.96*se_`g'
keep in 1
keep lno est_`g' se_`g' ll95_`g' ul95_`g'
append using "`g'.dta"
save "`g'.dta", replace
use "Kim_main.dta", clear
}
use "`g'.dta", clear
outsheet using "`g'.csv", c replace
use "Kim_main.dta", clear

# Figure 2-3
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P3"
local q="$Q3"
local c="$C1"
local r="$R2"
xi: quietly `m' `d' `y' `p' `q' `c' $control $oecd
est table, keep(`p' `q') b t p
egen ll=min(`p')
egen ul=max(`p')
local u=ll[1]
local v=ul[1]
drop ll ul
lincom `p' + `q'*`u'
lincom `p' + `q'*`v'
local g="liec"
estimates store `g'
lincom `p' + `q'*`u'
gen lno=`u'
gen est_`g'=r(estimate)
gen se_`g'=r(se)
gen ll95_`g'=est_`g'-1.96*se_`g'
gen ul95_`g'=est_`g'+1.96*se_`g'
keep in 1
keep lno est_`g' se_`g' ll95_`g' ul95_`g'
save "`g'.dta", replace
use "Kim_main.dta", clear
local w=`u'+0.05
forvalue i=`w'(0.05)`v'{
estimates restore `g'
lincom `p' + `q'*(`i')
gen lno=`i'
gen est_`g'=r(estimate)
gen se_`g'=r(se)
gen ll95_`g'=est_`g'-1.96*se_`g'
gen ul95_`g'=est_`g'+1.96*se_`g'
keep in 1
keep lno est_`g' se_`g' ll95_`g' ul95_`g'
append using "`g'.dta"
save "`g'.dta", replace
use "Kim_main.dta", clear
}
use "`g'.dta", clear
outsheet using "`g'.csv", c replace
use "Kim_main.dta", clear

# Figure 2-4
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P4"
local q="$Q4"
local c="$C1"
local r="$R2"
xi: quietly `m' `d' `y' `p' `q' `c' $control $oecd
est table, keep(`p' `q') b t p
egen ll=min(`p')
egen ul=max(`p')
local u=ll[1]
local v=ul[1]
drop ll ul
lincom `p' + `q'*`u'
lincom `p' + `q'*`v'
local g="vna"
estimates store `g'
lincom `p' + `q'*`u'
gen lno=`u'
gen est_`g'=r(estimate)
gen se_`g'=r(se)
gen ll95_`g'=est_`g'-1.96*se_`g'
gen ul95_`g'=est_`g'+1.96*se_`g'
keep in 1
keep lno est_`g' se_`g' ll95_`g' ul95_`g'
save "`g'.dta", replace
use "Kim_main.dta", clear
local w=`u'+0.05
forvalue i=`w'(0.05)`v'{
estimates restore `g'
lincom `p' + `q'*(`i')
gen lno=`i'
gen est_`g'=r(estimate)
gen se_`g'=r(se)
gen ll95_`g'=est_`g'-1.96*se_`g'
gen ul95_`g'=est_`g'+1.96*se_`g'
keep in 1
keep lno est_`g' se_`g' ll95_`g' ul95_`g'
append using "`g'.dta"
save "`g'.dta", replace
use "Kim_main.dta", clear
}
use "`g'.dta", clear
outsheet using "`g'.csv", c replace
use "Kim_main.dta", clear


### Figure 3 (continue to R and use Kim International Interactions.R to produce Figure 3)

local m="$M2"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: quietly `m' `d' `y' `p' `q' `c' $control $oecd
margins, at(`p'=-16 `q'=256)
margins, at(`p'=-15 `q'=225)
margins, at(`p'=-14 `q'=196)
margins, at(`p'=-13 `q'=169)
margins, at(`p'=-12 `q'=144)
margins, at(`p'=-11 `q'=121)
margins, at(`p'=-10 `q'=100)
margins, at(`p'=-9 `q'=81)
margins, at(`p'=-8 `q'=64)
margins, at(`p'=-7 `q'=49)
margins, at(`p'=-6 `q'=36)
margins, at(`p'=-5 `q'=25)
margins, at(`p'=-4 `q'=16)
margins, at(`p'=-3 `q'=9)
margins, at(`p'=-2 `q'=4)
margins, at(`p'=-1 `q'=1)
margins, at(`p'=0 `q'=0)
margins, at(`p'=1 `q'=1)
margins, at(`p'=2 `q'=4)
margins, at(`p'=3 `q'=9)
margins, at(`p'=4 `q'=16)


### Appendix A1
use "Kim_sector.dta", clear

# A1-1
reg longtermb2 polity2 lngdpcap lngdp if flowOrStock=="flow" & oecd==0

# A1-2
reg longtermb2 cpolity2 polity_sq lngdpcap lngdp if flowOrStock=="flow" & oecd==0

# A1-3
reg longtermb2 polity2 lngdpcap lngdp if flowOrStock=="stock" & oecd==0

# A1-4
reg longtermb2 cpolity2 polity_sq lngdpcap lngdp if flowOrStock=="stock" & oecd==0

# A1-5
reg longtermTotal2 polity2 lngdpcap lngdp if flowOrStock=="flow" & oecd==0

# A1-6
reg longtermTotal2 cpolity2 polity_sq lngdpcap lngdp if flowOrStock=="flow" & oecd==0

# A1-7
reg longtermTotal2 polity2 lngdpcap lngdp if flowOrStock=="stock" & oecd==0

# A1-8
reg longtermTotal2 cpolity2 polity_sq lngdpcap lngdp if flowOrStock=="stock" & oecd==0

# A1-9
reg longtermGDPt2 polity2 lngdpcap if flowOrStock=="flow" & oecd==0

# A1-10
reg longtermGDPt2 cpolity2 polity_sq lngdpcap if flowOrStock=="flow" & oecd==0

# A1-11
reg longtermGDPt2 polity2 lngdpcap if flowOrStock=="stock" & oecd==0

# A1-12
reg longtermGDPt2 cpolity2 polity_sq lngdpcap if flowOrStock=="stock" & oecd==0


### Appendix A2
use "Kim_risk.dta", clear

# A2-1
xi:logit settle i.year lpolity2 lchecks llngdpcap llngdp hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)

# A2-2
xi:logit settle i.year lcpolity2 lpolity_sq lchecks llngdpcap llngdp hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)

# A2-3
xi:logit settle i.year lcpolity2 lpolity_sq lFI2 lchecks llngdpcap llngdp hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)

# A2-4
xi:logit settle i.year lpolity2 lFI2 lchecks llngdpcap llngdp hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)


### Appendix B
use "Kim_main.dta", clear
xtset ccode year

# B-1
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' $control $oecd

# B-2
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' $control $oecd

# B-3
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' $control $oecd

# B-4
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' $control $oecd


### Appendix C

# C-1
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P2"
local q="$Q2"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' $control $oecd

# C-2
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P2"
local q="$Q2"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' $control $oecd

# C-3
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P2"
local q="$Q2"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' $control $oecd

# C-4
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P2"
local q="$Q2"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' $control $oecd

# C-5
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P3"
local q="$Q3"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' $control $oecd

# C-6
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P3"
local q="$Q3"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' $control $oecd

# C-7
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P3"
local q="$Q3"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' $control $oecd

# C-8
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P3"
local q="$Q3"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' $control $oecd

# C-9
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P4"
local q="$Q4"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' $control $oecd

# C-10
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P4"
local q="$Q4"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' $control $oecd

# C-11
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P4"
local q="$Q4"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' $control $oecd

# C-12
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P4"
local q="$Q4"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' $control $oecd


### Appendix D

# D-1
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R1"
xi: `m' `d' `y' `p' `c' $control $oecd

# D-2
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R1"
xi: `m' `d' `y' `p' `q' `c' $control $oecd

# D-3
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R1"
xi: `m' `d' `y' `p' `q' `r' `c' $control $oecd

# D-4
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R1"
xi: `m' `d' `y' `p' `r' `c' $control $oecd

# D-5
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R1"
xi: `m' `d' `y' `p' `c' $control $oecd

# D-6
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R1"
xi: `m' `d' `y' `p' `q' `c' $control $oecd

# D-7
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R1"
xi: `m' `d' `y' `p' `q' `r' `c' $control $oecd

# D-8
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R1"
xi: `m' `d' `y' `p' `r' `c' $control $oecd

# D-9
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R3"
xi: `m' `d' `y' `p' `q' `r' `c' $control $oecd

# D-10
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R3"
xi: `m' `d' `y' `p' `r' `c' $control $oecd

# D-11
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R3"
xi: `m' `d' `y' `p' `q' `r' `c' $control $oecd

# D-12
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R3"
xi: `m' `d' `y' `p' `r' `c' $control $oecd

# D-13
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R4"
xi: `m' `d' `y' `p' `q' `r' `c' $control $oecd

# D-14
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R4"
xi: `m' `d' `y' `p' `r' `c' $control $oecd

# D-15
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R4"
xi: `m' `d' `y' `p' `q' `r' `c' $control $oecd

# D-16
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R4"
xi: `m' `d' `y' `p' `r' `c' $control $oecd


### Appendix E

# E-1
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C2"
local r="$R2"
xi: `m' `d' `y' `p' $control $oecd

# E-2
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C2"
local r="$R2"
xi: `m' `d' `y' `p' `q' $control $oecd

# E-3
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C2"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' $control $oecd

# E-4
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C2"
local r="$R2"
xi: `m' `d' `y' `p' `r' $control $oecd

# E-5
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C2"
local r="$R2"
xi: `m' `d' `y' `p' $control $oecd

# E-6
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C2"
local r="$R2"
xi: `m' `d' `y' `p' `q' $control $oecd

# E-7
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C2"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' $control $oecd

# E-8
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C2"
local r="$R2"
xi: `m' `d' `y' `p' `r' $control $oecd

# E-9
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C2"
local r="$R2"
xi: `m' `d' `y' `p' `c' $control $oecd

# E-10
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C2"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' $control $oecd

# E-11
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C2"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' $control $oecd

# E-12
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C2"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' $control $oecd

# E-13
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C2"
local r="$R2"
xi: `m' `d' `y' `p' `c' $control $oecd

# E-14
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C2"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' $control $oecd

# E-15
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C2"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' $control $oecd

# E-16
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C2"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' $control $oecd

# E-17
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C3"
local r="$R2"
xi: `m' `d' `y' `p' `c' $control $oecd

# E-18
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C3"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' $control $oecd

# E-19
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C3"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' $control $oecd

# E-20
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C3"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' $control $oecd

# E-21
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C3"
local r="$R2"
xi: `m' `d' `y' `p' `c' $control $oecd

# E-22
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C3"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' $control $oecd

# E-23
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C3"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' $control $oecd

# E-24
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C3"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' $control $oecd


### Appendix F

global GDP "l.polariz l.left l.cumpriv2GDP2 l.cum_n_allbit_effect l.lnFDIstock l.lngdp l.trade2GDP l.resource2 ECA LAC SSA SAS oecd if year<2014"
global Growth "l.polariz l.left l.cumpriv2GDP2 l.cum_n_allbit_effect l.lnFDIstock l.GDPgrowth l.trade2GDP l.resource2 ECA LAC SSA SAS oecd if year<2014"
global pcap "l.polariz l.left l.cumpriv2GDP2 l.cum_n_allbit_effect l.lnFDIstock l.lngdpcap l.trade2GDP l.resource2 ECA LAC SSA SAS oecd if year<2014"

# F-1
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' $GDP $oecd

# F-2
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' $GDP $oecd

# F-3
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' $GDP $oecd

# F-4
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' $GDP $oecd

# F-5
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' $GDP $oecd

# F-6
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' $GDP $oecd

# F-7
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' $GDP $oecd

# F-8
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' $GDP $oecd

# F-9
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' $Growth $oecd

# F-10
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' $Growth $oecd

# F-11
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' $Growth $oecd

# F-12
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' $Growth $oecd

# F-13
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' $Growth $oecd

# F-14
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' $Growth $oecd

# F-15
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' $Growth $oecd

# F-16
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' $Growth $oecd

# F-17
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' $pcap $oecd

# F-18
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' $pcap $oecd

# F-19
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' $pcap $oecd

# F-20
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' $pcap $oecd

# F-21
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' $pcap $oecd

# F-22
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' $pcap $oecd

# F-23
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' $pcap $oecd

# F-24
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' $pcap $oecd


### Appendix G

use "Kim_main.dta", clear
 stset, clear
 sort countryname year
 mi set wide
 mi register imputed cpolity2 polity_sq cfreedom freedom_sq cliec liec_sq voiceAccountability voiceAccountability_sq creccom reccom_sq lji FI2 lawAndOrder ruleOfLaw checks polconiii polconv polariz lngdpcap left GDPgrowth cumpriv2GDP2 cum_n_allbit_effect lnFDIstock lngdp trade2GDP resource2
 mi impute mvn cpolity2 polity_sq cfreedom freedom_sq cliec liec_sq voiceAccountability voiceAccountability_sq creccom reccom_sq lji FI2 lawAndOrder ruleOfLaw checks polconiii polconv polariz lngdpcap left GDPgrowth cumpriv2GDP2 cum_n_allbit_effect lnFDIstock lngdp trade2GDP resource2, add(5)
 save "impute.dta", replace

 use "impute.dta", clear

mi xtset ccode year

# G-1
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
mi estimate: `m' `d' _Iyear_* `p' `c' $control $oecd & year>=1981

# G-2
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
mi estimate: `m' `d' _Iyear_* `p' `q' `c' $control $oecd & year>=1981

# G-3
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
mi estimate: `m' `d' _Iyear_* `p' `q' `r' `c' $control $oecd & year>=1981

# G-4
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
mi estimate: `m' `d' _Iyear_* `p' `r' `c' $control $oecd & year>=1981

# G-5
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
mi estimate: `m' `d' _Iyear_* `p' `c' $control $oecd & year>=1981

# G-6
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
mi estimate: `m' `d' _Iyear_* `p' `q' `c' $control $oecd & year>=1981

# G-7
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
mi estimate: `m' `d' _Iyear_* `p' `q' `r' `c' $control $oecd & year>=1981

# G-8
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
mi estimate: `m' `d' _Iyear_* `p' `r' `c' $control $oecd & year>=1981
use "Kim_main.dta", clear


### Appendix H
use "Kim_main.dta", clear
xtset ccode year

# H-1
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P5"
local q="$Q5"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' $control $oecd

# H-2
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P5"
local q="$Q5"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' $control $oecd

# H-3
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P5"
local q="$Q5"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' $control $oecd

# H-4
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P5"
local q="$Q5"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' $control $oecd

# H-5
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P5"
local q="$Q5"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' $control $oecd

# H-6
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P5"
local q="$Q5"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' $control $oecd

# H-7
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P5"
local q="$Q5"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' $control $oecd

# H-8
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P5"
local q="$Q5"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' $control $oecd

# H-9
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P7"
local q="$Q7"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' $control $oecd

# H-10
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P7"
local q="$Q7"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' $control $oecd

# H-11
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P7"
local q="$Q7"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' $control $oecd

# H-12
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P7"
local q="$Q7"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' $control $oecd

# H-13
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P7"
local q="$Q7"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' $control $oecd

# H-14
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P7"
local q="$Q7"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' $control $oecd

# H-15
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P7"
local q="$Q7"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' $control $oecd

# H-16
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P7"
local q="$Q7"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' $control $oecd

# H-17
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P6"
local q="$Q6"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' $control $oecd

# H-18
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P6"
local q="$Q6"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' $control $oecd

# H-19
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P6"
local q="$Q6"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' $control $oecd

# H-20
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P6"
local q="$Q6"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' $control $oecd

# H-21
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P6"
local q="$Q6"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' $control $oecd

# H-22
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P6"
local q="$Q6"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' $control $oecd

# H-23
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P6"
local q="$Q6"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' $control $oecd

# H-24
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P6"
local q="$Q6"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' $control $oecd

# H-25
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P13"
local q="$Q13"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' $control $oecd

# H-26
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P13"
local q="$Q13"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' $control $oecd

# H-27
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P13"
local q="$Q13"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' $control $oecd

# H-28
local m="$M1"
local d="$D1"
local y="$Y1"
local p="$P13"
local q="$Q13"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' $control $oecd

# H-29
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P13"
local q="$Q13"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' $control $oecd

# H-30
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P13"
local q="$Q13"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' $control $oecd

# H-31
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P13"
local q="$Q13"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' $control $oecd

# H-32
local m="$M2"
local d="$D1"
local y="$Y1"
local p="$P13"
local q="$Q13"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' $control $oecd


### Appendix I

# I-1
local m="$M1"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' l.isds72 $control $oecd

# I-2
local m="$M1"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' l.isds72 $control $oecd

# I-3
local m="$M1"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' l.isds72 $control $oecd

# I-4
local m="$M1"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' l.isds72 $control $oecd

# I-5
local m="$M2"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' l.isds72 $control $oecd

# I-6
local m="$M2"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' l.isds72 $control $oecd

# I-7
local m="$M2"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' l.isds72 $control $oecd

# I-8
local m="$M2"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' l.isds72 $control $oecd

# I-9
local m="$M1"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' l.cisds72 $control $oecd

# I-10
local m="$M1"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' l.cisds72 $control $oecd

# I-11
local m="$M1"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' l.cisds72 $control $oecd

# I-12
local m="$M1"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' l.cisds72 $control $oecd

# I-13
local m="$M2"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' l.cisds72 $control $oecd

# I-14
local m="$M2"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' l.cisds72 $control $oecd

# I-15
local m="$M2"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' l.cisds72 $control $oecd

# I-16
local m="$M2"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' l.cisds72 $control $oecd

# I-17
local m="$M1"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' l.cumninvestorWin $control $oecd

# I-18
local m="$M1"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' l.cumninvestorWin $control $oecd

# I-19
local m="$M1"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' l.cumninvestorWin $control $oecd

# I-20
local m="$M1"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' l.cumninvestorWin $control $oecd

# I-21
local m="$M2"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' l.cumninvestorWin $control $oecd

# I-22
local m="$M2"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' l.cumninvestorWin $control $oecd

# I-23
local m="$M2"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' l.cumninvestorWin $control $oecd

# I-24
local m="$M2"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' l.cumninvestorWin $control $oecd

# I-25
local m="$M1"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' l.cumnhostWin $control $oecd

# I-26
local m="$M1"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' l.cumnhostWin $control $oecd

# I-27
local m="$M1"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' l.cumnhostWin $control $oecd

# I-28
local m="$M1"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' l.cumnhostWin $control $oecd

# I-29
local m="$M2"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `c' l.cumnhostWin $control $oecd

# I-30
local m="$M2"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `c' l.cumnhostWin $control $oecd

# I-31
local m="$M2"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `q' `r' `c' l.cumnhostWin $control $oecd

# I-32
local m="$M2"
local d="$D1"
local y="$Y2"
local p="$P1"
local q="$Q1"
local c="$C1"
local r="$R2"
xi: `m' `d' `y' `p' `r' `c' l.cumnhostWin $control $oecd


### Appendix J
use "Kim_risk.dta", clear

# J-1
xi:ologit type_risk i.year lpolity2 lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)

# J-2
xi:ologit type_risk i.year lpolity2 lFI2 lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)

# J-3
xi:ologit type_risk i.year lFI2 lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)

# J-4
xi:ologit type_risk i.year lpolity2 llji lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)

# J-5
xi:ologit type_risk i.year llji lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)

# J-6
xi:ologit type_risk i.year lpolity2 llawAndOrder lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)

# J-7
xi:ologit type_risk i.year llawAndOrder lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)

# J-8
xi:ologit type_risk i.year lpolity2 lruleOfLaw lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)

# J-9
xi:ologit type_risk i.year lruleOfLaw lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, vce(cluster countryname)


### Appendix K
use "Kim_risk.dta", clear

# K-1
xi:mlogit type_risk2 year lpolity2 lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, base(0) rrr vce(cluster countryname)

# K-2
xi:mlogit type_risk2 year lpolity2 lFI2 lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, base(0) rrr vce(cluster countryname)

# K-3
xi:mlogit type_risk2 year lFI2 lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, base(0) rrr vce(cluster countryname)

# K-4
xi:mlogit type_risk2 year lpolity2 llji lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, base(0) rrr vce(cluster countryname)

# K-5
xi:mlogit type_risk2 year llji lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, base(0) rrr vce(cluster countryname)

# K-6
xi:mlogit type_risk2 year lpolity2 llawAndOrder lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, base(0) rrr vce(cluster countryname)

# K-7
xi:mlogit type_risk2 year llawAndOrder lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, base(0) rrr vce(cluster countryname)

# K-8
xi:mlogit type_risk2 year lpolity2 lruleOfLaw lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, base(0) rrr vce(cluster countryname)

# K-9
xi:mlogit type_risk2 year lruleOfLaw lchecks llngdpcap hydrocarbon roads ports mining electricity if oecd==0, base(0) rrr vce(cluster countryname)


