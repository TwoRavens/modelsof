* / Replication data for Eck, Kristine. 2014. "Law of the Land: Communal Conflict and Legal Authority." Journal of Peace Research / *
* / For information on vars, see data labels in Stata * /


** / TABLE II / **

* / M1: BIVARIATE MODEL / *
logit landconf_broad multijuris yearcount peace2 peace3_alt, robust

set seed 123456789
prvalue, x(multijuris=0) 
prvalue, x(multijuris=1) 

* / M2: BASIC MODEL / *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

prvalue, x(multijuris=0 french=0) rest(mean)
prvalue, x(multijuris=1 french=0) rest(mean)

* / M3: LAGGED DV / *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep landconflag yearcount peace2 peace3_alt, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

prvalue, x(multijuris=0 french=0) rest(mean)
prvalue, x(multijuris=1 french=0) rest(mean)

* / M4: WITH LAND TENURE/ *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep recog_cust_tenure yearcount peace2 peace3_alt, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

prvalue, x(multijuris=0 french=0) rest(mean)
prvalue, x(multijuris=1 french=0) rest(mean)

* / M5: WITHOUT CABINET MEASURE/ * 
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

prvalue, x(multijuris=0 french=0) rest(mean)
prvalue, x(multijuris=1 french=0) rest(mean)


* / M6: WITH RULE OF LAW MEASURE/ * 

logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth rol_per ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

prvalue, x(multijuris=0 french=0) rest(mean)
prvalue, x(multijuris=1 french=0) rest(mean)



**/ VARIOUS ROBUSTNESS TESTS / **

* / 5 fatality DV threshold / *
logit landconf_5fat multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt, robust

* / 10 fatality DV threshold / *
logit landconf_10fat multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt, robust

* / all models w. population density (wb lagged pop / cia area sqkm) / *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep popdensity yearcount peace2 peace3_alt, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

* / basic model with IMF SAP / * 
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep imfsap_tenthou yearcount peace2 peace3_alt, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

* / basic model with leader tenure  / *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep ldrtenure yearcount peace2 peace3_alt, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

* / basic model using EPR on ethnic monopolization or dominance  / *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt ethnic_rulel, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

* / basic model w. local elections (state)  / *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt dpi_state1, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

* / basic model w. population (world bank) per parliamentarian (totalseats)  / *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep popperparla yearcount peace2 peace3_alt, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

* / basic model w. cash crop dummy: cotton / *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt cottonl, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

* / basic model w. cash crop dummy: cocoa / *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt cocoal, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

* / basic model w. cash crop dummy: coffee / *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt coffeel, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

* / basic model w. cash crop dummy: fruit / *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt fruitsl, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

* / basic model w. cash crop dummy: groundnuts / *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt groundnutsl, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

* / basic model w. % arable land + permanent crops CIA) / *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt ag_land, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

* / basic model with ag value added as % gdp (WB-WDI) / *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt aglag, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

* / other forms of land tenure systems: private ownership (all) / *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt privown_all, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

* / other forms of land tenure systems: state leasehold (all) / *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt stateleasehold_all, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

* / basic model using F&L ELF / *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag ethfrac cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

* / basic model using EPR_ELF  / *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag epr_elf cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

* / basic model w. minor regime change / *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt regime_minorl, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

* / basic model w. major regime change/ *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt regime_majorl, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

* / basic model w. rainfall deviation / *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conf_3yrs yrssinceindep yearcount peace2 peace3_alt gpcp_precip_mm_deviation_sd, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

* / basic model w. rainfall deviation lagged / *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conf_3yrs yrssinceindep yearcount peace2 peace3_alt gpcp_precip_mm_deviation_sd_l, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

* / basic model w. squared rainfall deviation lagged / *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conf_3yrs yrssinceindep yearcount peace2 peace3_alt gpcp_precip_mm_deviation_sd gpcp_precip_mm_deviation_sd_sq, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

* / basic model w. rainfall deviation lagged and interaction effect / *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conf_3yrs yrssinceindep yearcount peace2 peace3_alt gpcp_precip_mm_deviation_sd_l cj_rainl, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

* / basic model w. squared rainfall deviation lagged and interaction effect / *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conf_3yrs yrssinceindep yearcount peace2 peace3_alt gpcp_precip_mm_deviation_sd_l gpcp_precip_mm_deviation_sd_l_sq ///
cj_rainl_sq, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

* / basic model w. 3 yr. conflict lag / *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conf_3yrs yrssinceindep yearcount peace2 peace3_alt, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

* / basic model w. 5 yr. conflict lag / *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conf_5yrs yrssinceindep yearcount peace2 peace3_alt, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)

* / without year polynomials / *
logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep, robust

set seed 123456789
prvalue, x(multijuris=0 french=1) rest(mean)
prvalue, x(multijuris=1 french=1) rest(mean)


**/ DROPPING COUNTRIES / **

logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt, robust

logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt if ccodecow !=434, robust

logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt if ccodecow !=439, robust

logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt if ccodecow !=471, robust

logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt if ccodecow !=483, robust

logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt if ccodecow !=437, robust

logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt if ccodecow !=420, robust

logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt if ccodecow !=452, robust

logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt if ccodecow !=438, robust

logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt if ccodecow !=404, robust

logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt if ccodecow !=450, robust

logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt if ccodecow !=432, robust

logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt if ccodecow !=435, robust

logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt if ccodecow !=436, robust

logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt if ccodecow !=475, robust

logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt if ccodecow !=433, robust

logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt if ccodecow !=451, robust

logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt if ccodecow !=461, robust


**/ And finally, one Referee wanted to know about the effects of time **/

logit landconf_broad multijuris french gdpcaplag polity2lag polity2sqlag alesina_eth cabinet ///
conflag1yr yrssinceindep yearcount peace2 peace3_alt, robust

egen meanmultijuris=mean(multijuris)
egen meanfrench=mean(french)
egen meangdpcaplag=mean(gdpcaplag)
egen meanpolity2lag=mean(polity2lag)
egen meanpolity2sqlag=mean(polity2sqlag)
egen meanalesina_eth=mean(alesina_eth)
egen meancabinet=mean(cabinet)
egen meanconflag1yr=mean(conflag1yr)
egen meanyrssinceindep=mean(yrssinceindep)

duplicates drop yearcount, force

keep yearcount peace2 peace3_alt meanmultijuris meanfrench meangdpcaplag meanpolity2lag meanpolity2sqlag ///
meanalesina_eth meancabinet meanconflag1yr meanyrssinceindep

rename meanmultijuris multijuris
rename meanfrench french
rename meangdpcaplag gdpcaplag
rename meanpolity2lag polity2lag
rename meanpolity2sqlag polity2sqlag
rename meanalesina_eth alesina_eth
rename meancabinet cabinet
rename meanconflag1yr conflag1yr
rename meanyrssinceindep yrssinceindep

predict p1

label var p1 "Probability Y=1"
label var yearcount "Time"
twoway line p1 yearcount
