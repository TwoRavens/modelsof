* Replication Do File for "How Do Target Leaders Survive Economic Sanctions?" 
* Note: Make sure to first install the "xtfevd" file. See the replication folder.

* TABLE 1 CIM MEASURE
xtfevd cim lagsanction lagpolity21 laglndurable lagincidence ethfrac colbrit colfra timetrend eeurop lamerica ssafrica nafrme asia, invariant(ethfrac colbrit colfra eeurop lamerica ssafrica nafrme asia) ar1
xtfevd cim lagcompsanct laglimitsanct lagpolity21 laglndurable lagincidence ethfrac colbrit colfra timetrend eeurop lamerica ssafrica nafrme asia, invariant(ethfrac colbrit colfra eeurop lamerica ssafrica nafrme asia) ar1
xtfevd cim lmajsanct lminsanct lagpolity21 laglndurable lagincidence ethfrac colbrit colfra timetrend eeurop lamerica ssafrica nafrme asia, invariant(ethfrac colbrit colfra eeurop lamerica ssafrica nafrme asia) ar1
xtfevd cim lagsanction lagmultilateral lagpolity21 laglndurable lagincidence ethfrac colbrit colfra timetrend eeurop lamerica ssafrica nafrme asia, invariant(ethfrac colbrit colfra eeurop lamerica ssafrica nafrme asia) ar1
xtfevd cim lagsanction lagUSsanctions lagpolity21 laglndurable lagincidence ethfrac colbrit colfra timetrend eeurop lamerica ssafrica nafrme asia, invariant(ethfrac colbrit colfra eeurop lamerica ssafrica nafrme asia) ar1

* Table 2 CIM MEASURE - FIRST DIFFERENCED 
xtreg d.cim sanction polity21 lndurable incidence ethfrac colbrit colfra timetrend l.cim eeurop lamerica ssafrica nafrme asia
xtreg d.cim compsanct limitsanct lagpolity21 laglndurable lagincidence ethfrac colbrit colfra timetrend l.cim eeurop lamerica ssafrica nafrme asia 
xtreg d.cim majsanct minsanct polity21 lndurable incidence ethfrac colbrit colfra timetrend l.cim eeurop lamerica ssafrica nafrme asia
xtreg d.cim sanction multilateral polity21 lndurable incidence ethfrac colbrit colfra timetrend l.cim eeurop lamerica ssafrica nafrme asia
xtreg d.cim sanction sanction_us polity21 lndurable lagincidence ethfrac colbrit colfra timetrend l.cim eeurop lamerica ssafrica nafrme asia

* Table 3 ICRG INVST MODEL
xtfevd icrginvstprof lagsanction lagpolity21 laglndurable lagincidence ethfrac colbrit colfra timetrend eeurop lamerica ssafrica nafrme asia, invariant(ethfrac colbrit colfra eeurop lamerica ssafrica nafrme asia) ar1
xtfevd icrginvstprof lagcompsanct laglimitsanct lagpolity21 laglndurable lagincidence ethfrac colbrit colfra timetrend eeurop lamerica ssafrica nafrme asia, invariant(ethfrac colbrit colfra eeurop lamerica ssafrica nafrme asia) ar1
xtfevd icrginvstprof lmajsanct lminsanct lagpolity21 laglndurable lagincidence ethfrac colbrit colfra timetrend eeurop lamerica ssafrica nafrme asia, invariant(ethfrac colbrit colfra eeurop lamerica ssafrica nafrme asia) ar1
xtfevd icrginvstprof lagsanction lagmultilateral lagpolity2 laglndurable lagincidence ethfrac colbrit colfra timetrend eeurop lamerica ssafrica nafrme asia, invariant(ethfrac colbrit colfra eeurop lamerica ssafrica nafrme asia) ar1
xtfevd icrginvstprof lagsanction lagUSsanctions lagpolity2 laglndurable lagincidence ethfrac colbrit colfra timetrend eeurop lamerica ssafrica nafrme asia, invariant(ethfrac colbrit colfra eeurop lamerica ssafrica nafrme asia) ar1

*Table 4 ICRG INVTS - FIRST DIFFERENCED
xtreg d.icrginvstprof sanction polity21 lndurable incidence ethfrac colbrit colfra timetrend l.icrginvstprof eeurop lamerica ssafrica nafrme asia 
xtreg d.icrginvstprof compsanct limitsanct polity21 lndurable incidence ethfrac colbrit colfra timetrend l.icrginvstprof eeurop lamerica ssafrica nafrme asia
xtreg d.icrginvstprof majsanct minsanct polity21 lndurable incidence ethfrac colbrit colfra timetrend l.icrginvstprof eeurop lamerica ssafrica nafrme asia
xtreg d.icrginvstprof sanction multilateral polity21 lndurable incidence ethfrac colbrit colfra timetrend l.icrginvstprof eeurop lamerica ssafrica nafrme asia
xtreg d.icrginvstprof sanction sanction_us polity21 lndurable incidence ethfrac colbrit colfra timetrend l.icrginvstprof eeurop lamerica ssafrica nafrme asia


* TABLE 5 Substantive Effects
xtreg Dicrginvstprof sanction polity21 lndurable incidence ethfrac colbrit colfra timetrend Licrginvstprof eeurop lamerica ssafrica nafrme asia 
*When sanction=0 and sanction=1
adjust sanction=0 polity21=13.4 lndurable=2.6 incidence=0 ethfrac=0.4 colbrit=0 colfra=0 timetrend=1985 Licrginvstprof=6.5 eeurop=0 lamerica=0 ssafrica=0 nafrme=0 asia=0

adjust sanction=1 polity21=13.4 lndurable=2.6 incidence=0 ethfrac=0.4 colbrit=0 colfra=0 timetrend=1985 Licrginvstprof=6.5 eeurop=0 lamerica=0 ssafrica=0 nafrme=0 asia=0

* When Democracy is at its mean and 1td. above
adjust sanction=0 polity21=13.4 lndurable=2.6 incidence=0 ethfrac=0.4 colbrit=0 colfra=0 timetrend=1985 Licrginvstprof=6.5 eeurop=0 lamerica=0 ssafrica=0 nafrme=0 asia=0

adjust sanction=0 polity21=20.5 lndurable=2.6 incidence=0 ethfrac=0.4 colbrit=0 colfra=0 timetrend=1985 Licrginvstprof=6.5 eeurop=0 lamerica=0 ssafrica=0 nafrme=0 asia=0

* When regime stability is at its mean and 1 std above
adjust sanction=0 polity21=13.4 lndurable=2.6 incidence=0 ethfrac=0.4 colbrit=0 colfra=0 timetrend=1985 Licrginvstprof=6.5 eeurop=0 lamerica=0 ssafrica=0 nafrme=0 asia=0

adjust sanction=0 polity21=13.4 lndurable=3.94 incidence=0 ethfrac=0.4 colbrit=0 colfra=0 timetrend=1985 Licrginvstprof=6.5 eeurop=0 lamerica=0 ssafrica=0 nafrme=0 asia=0

* When civil war =0 and 1
adjust sanction=0 polity21=13.4 lndurable=2.6 incidence=0 ethfrac=0.4 colbrit=0 colfra=0 timetrend=1985 Licrginvstprof=6.5 eeurop=0 lamerica=0 ssafrica=0 nafrme=0 asia=0

adjust sanction=0 polity21=13.4 lndurable=2.6 incidence=1 ethfrac=0.4 colbrit=0 colfra=0 timetrend=1985 Licrginvstprof=6.5 eeurop=0 lamerica=0 ssafrica=0 nafrme=0 asia=0

*when extensive sanction = 0 and extensive sanction =1
xtreg Dicrginvstprof compsanct limitsanct polity21 lndurable incidence ethfrac colbrit colfra timetrend Licrginvstprof eeurop lamerica ssafrica nafrme asia 

adjust compsanct=0 limitsanct=0 polity21=13.4 lndurable=2.6 incidence=0 ethfrac=0.4 colbrit=0 colfra=0 timetrend=1985 Licrginvstprof=6.5 eeurop=0 lamerica=0 ssafrica=0 nafrme=0 asia=0

adjust compsanct=1 limitsanct=0 polity21=13.4 lndurable=2.6 incidence=0 ethfrac=0.4 colbrit=0 colfra=0 timetrend=1985 Licrginvstprof=6.5 eeurop=0 lamerica=0 ssafrica=0 nafrme=0 asia=0

*when high cost sanction =0 and 1
xtreg Dicrginvstprof majsanct minsanct polity21 lndurable incidence ethfrac colbrit colfra timetrend Licrginvstprof eeurop lamerica ssafrica nafrme asia 

adjust majsanct=0 minsanct=0 polity21=13.4 lndurable=2.6 incidence=0 ethfrac=0.4 colbrit=0 colfra=0 timetrend=1985 Licrginvstprof=6.5 eeurop=0 lamerica=0 ssafrica=0 nafrme=0 asia=0

adjust majsanct=1 minsanct=0 polity21=13.4 lndurable=2.6 incidence=0 ethfrac=0.4 colbrit=0 colfra=0 timetrend=1985 Licrginvstprof=6.5 eeurop=0 lamerica=0 ssafrica=0 nafrme=0 asia=0


