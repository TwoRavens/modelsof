*VARIABLE DESCRIPTIONS
*country = Country name (string variable)
*cow = Country's Correlates of War code
*year = Year of observation
*claims = Count of treaty-based arbitral claims brought against country in a given year
*cim = Contract-intensive money (IMF Financial Statistics database)
*lawordr = ICRG "Law & Order" measure
*icrgcorrupt = ICRG "Corruption" measure
*rulelaw = World Governance Indicators "Rule of Law" measure
*gicorrupt = World Governance Indiators "Control of Corruption" measure
*cpi = Transparency International's "Perceptions of Corruption Index"
*exposr = Cumulative number of investment treaties a country has concluded with all countries since 1985 which have entered into force (including Energy Charter Treaty and trade agreements)
*lnfdistk = Country's FDI stock (logged, UNCTADStat)
*globlclms = Cumulative total number of known treaty-based arbitral claims worldwide (against all countries)
*glbclmsq = globlclms squared
*growth = Country's annual GDP growth rate (World Development Indicators)
*fdigdp = Country's FDI inflows as percentage of its GDP (UNCTADStat)
*polcon = POLCON III (Henisz 2000) measure of political constraints
*leftexec = Dummy variable indicating whether a country's executive's party is leftist (derived from World Bank's Database of Political Institutions)
*currency = Dummy variable indicating whether a country experienced a currency crisis and abandoned a fixed exchange rate in a given year

*DESCRIPTIVE STATISTICS
summarize claims cim lawordr icrgcorrupt rulelaw gicorrupt cpi exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency

*All models estimated using Intercooled Stata 8.0

*VUONG TEST (indicates that ZINB model is appropriate estimator; sample includes all countries)
zinb claims cim exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv, inflate(nobits) exposure(year) vuong nolog

*Note: The Vuong statistic cannot be computed with any vce or constraints options. However, all models from this point forward include clustering effects. 

*For each of the models estimated below, I report both coefficients (first set of estimates) and incidence-rate ratios (second set of estimates)
*Models shown in Table 2 are labeled as such

*INSTITUTIONAL CAPACITY INDICATOR = CIM (sample includes all countries; estimates are coefficients)
zinb claims cim exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv, inflate(nobits) exposure(year) cluster(cow) nolog

*MODEL 1, TABLE 2: INSTITUTIONAL CAPACITY INDICATOR = CIM (sample includes all countries; estimates are incidence-rate ratios)
zinb claims cim exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv, inflate(nobits) exposure(year) cluster(cow) irr nolog

*INSTITUTIONAL CAPACITY INDICATOR = ICRG "Law & Order" (sample includes all countries; estimates are coefficients)
zinb claims lawordr exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv, inflate(nobits) exposure(year) cluster(cow) nolog

*MODEL 2, TABLE 2: INSTITUTIONAL CAPACITY INDICATOR = ICRG "Law & Order" (sample includes all countries; estimates are incidence-rate ratios)
zinb claims lawordr exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv, inflate(nobits) exposure(year) cluster(cow) irr nolog

*INSTITUTIONAL CAPACITY INDICATOR = ICRG "Corruption" (sample includes all countries; estimates are coefficients)
zinb claims icrgcorrupt exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv, inflate(nobits) exposure(year) cluster(cow) nolog

*MODEL 3, TABLE 2: INSTITUTIONAL CAPACITY INDICATOR = ICRG "Corruption" (sample includes all countries; estimates are incidence-rate ratios)
zinb claims icrgcorrupt exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv, inflate(nobits) exposure(year) cluster(cow) irr nolog

*INSTITUTIONAL CAPACITY INDICATOR = World Governance Indicators "Rule of Law" (sample includes all countries; estimates are coefficients)
zinb claims rulelaw exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv, inflate(nobits) exposure(year) cluster(cow) nolog

*MODEL 4, TABLE 2: INSTITUTIONAL CAPACITY INDICATOR = World Governance Indicators "Rule of Law" (sample includes all countries; estimates are incidence-rate ratios)
zinb claims rulelaw exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv, inflate(nobits) exposure(year) cluster(cow) irr nolog

*INSTITUTIONAL CAPACITY INDICATOR = World Governance Indicators "Control of Corruption" (sample includes all countries; estimates are coefficients)
zinb claims gicorrupt exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv, inflate(nobits) exposure(year) cluster(cow) nolog

*MODEL 5, TABLE 2: INSTITUTIONAL CAPACITY INDICATOR = World Governance Indicators "Control of Corruption" (sample includes all countries; estimates are incidence-rate ratios)
zinb claims gicorrupt exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv, inflate(nobits) exposure(year) cluster(cow) irr nolog

*INSTITUTIONAL CAPACITY INDICATOR = Transparency International Corruption Perceptions Index (sample includes all countries; estimates are coefficients)
zinb claims cpi exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv, inflate(nobits) exposure(year) cluster(cow) nolog

*MODEL 6, TABLE 2: INSTITUTIONAL CAPACITY INDICATOR = Transparency International Corruption Perceptions Index (sample includes all countries; estimates are incidence-rate ratios)
zinb claims cpi exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv, inflate(nobits) exposure(year) cluster(cow) irr nolog

*The following models exclude all observations for which the variable "gdpcap" is equal to or greater than 9000 (i.e., "developed countries" are dropped from the sample)

*INSTITUTIONAL CAPACITY INDICATOR = CIM (sample includes developing countries only; estimates are coefficients)
zinb claims cim exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if gdpcap<9000, inflate(nobits) exposure(year) cluster(cow) nolog

*INSTITUTIONAL CAPACITY INDICATOR = CIM (sample includes all countries; estimates are incidence-rate ratios)
zinb claims cim exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if gdpcap<9000, inflate(nobits) exposure(year) cluster(cow) irr nolog

*INSTITUTIONAL CAPACITY INDICATOR = ICRG "Law & Order" (sample includes all countries; estimates are coefficients)
zinb claims lawordr exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if gdpcap<9000, inflate(nobits) exposure(year) cluster(cow) nolog

*INSTITUTIONAL CAPACITY INDICATOR = ICRG "Law & Order" (sample includes all countries; estimates are incidence-rate ratios)
zinb claims lawordr exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if gdpcap<9000, inflate(nobits) exposure(year) cluster(cow) irr nolog

*INSTITUTIONAL CAPACITY INDICATOR = ICRG "Corruption" (sample includes all countries; estimates are coefficients)
zinb claims icrgcorrupt exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if gdpcap<9000, inflate(nobits) exposure(year) cluster(cow) nolog

*INSTITUTIONAL CAPACITY INDICATOR = ICRG "Corruption" (sample includes all countries; estimates are incidence-rate ratios)
zinb claims icrgcorrupt exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if gdpcap<9000, inflate(nobits) exposure(year) cluster(cow) irr nolog

*INSTITUTIONAL CAPACITY INDICATOR = World Governance Indicators "Rule of Law" (sample includes all countries; estimates are coefficients)
zinb claims rulelaw exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if gdpcap<9000, inflate(nobits) exposure(year) cluster(cow) nolog

*INSTITUTIONAL CAPACITY INDICATOR = World Governance Indicators "Rule of Law" (sample includes all countries; estimates are incidence-rate ratios)
zinb claims rulelaw exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if gdpcap<9000, inflate(nobits) exposure(year) cluster(cow) irr nolog

*INSTITUTIONAL CAPACITY INDICATOR = World Governance Indicators "Control of Corruption" (sample includes all countries; estimates are coefficients)
zinb claims gicorrupt exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if gdpcap<9000, inflate(nobits) exposure(year) cluster(cow) nolog

*INSTITUTIONAL CAPACITY INDICATOR = World Governance Indicators "Control of Corruption" (sample includes all countries; estimates are incidence-rate ratios)
zinb claims gicorrupt exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if gdpcap<9000, inflate(nobits) exposure(year) cluster(cow) irr nolog

*INSTITUTIONAL CAPACITY INDICATOR = Transparency International Corruption Perceptions Index (sample includes all countries; estimates are coefficients)
zinb claims cpi exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if gdpcap<9000, inflate(nobits) exposure(year) cluster(cow) nolog

*INSTITUTIONAL CAPACITY INDICATOR = Transparency International Corruption Perceptions Index (sample includes all countries; estimates are incidence-rate ratios)
zinb claims cpi exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if gdpcap<9000, inflate(nobits) exposure(year) cluster(cow) irr nolog

*The following models employ an alternative estimator, a random-effects negative binomial model (coefficients only)
*All observations in which the "exposr" variable = 0 are excluded from the sample

tsset cow year, yearly

*INSTITUTIONAL CAPACITY INDICATOR = CIM (sample includes developing countries only; estimates are coefficients)
xtnbreg claims cim exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if exposr>0, exposure(year) nolog

*INSTITUTIONAL CAPACITY INDICATOR = ICRG "Law & Order" (sample includes developing countries only; estimates are coefficients)
xtnbreg claims lawordr exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if exposr>0, exposure(year) nolog

*INSTITUTIONAL CAPACITY INDICATOR = ICRG "Corruption" (sample includes developing countries only; estimates are coefficients)
xtnbreg claims icrgcorrupt exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if exposr>0, exposure(year) nolog

*INSTITUTIONAL CAPACITY INDICATOR = World Governance Indicators "Rule of Law" (sample includes developing countries only; estimates are coefficients)
xtnbreg claims rulelaw exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if exposr>0, exposure(year) nolog

*INSTITUTIONAL CAPACITY INDICATOR = World Governance Indicators "Control of Corruption" (sample includes developing countries only; estimates are coefficients)
xtnbreg claims gicorrupt exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if exposr>0, exposure(year) nolog

*INSTITUTIONAL CAPACITY INDICATOR = Transparency International Corruption Perceptions Index (sample includes developing countries only; estimates are coefficients)
xtnbreg claims cpi exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if exposr>0, exposure(year) nolog

*The following models employ an alternative estimator, a population-averaged negative binomial model (coefficients only)
*All observations in which the "exposr" variable = 0 are excluded from the sample

*INSTITUTIONAL CAPACITY INDICATOR = CIM (sample includes developing countries only; estimates are coefficients)
xtnbreg claims cim exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if exposr>0, pa robust exposure(year) nolog

*INSTITUTIONAL CAPACITY INDICATOR = ICRG "Law & Order" (sample includes developing countries only; estimates are coefficients)
xtnbreg claims lawordr exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if exposr>0, pa robust exposure(year) nolog

*INSTITUTIONAL CAPACITY INDICATOR = ICRG "Corruption" (sample includes developing countries only; estimates are coefficients)
xtnbreg claims icrgcorrupt exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if exposr>0, pa robust exposure(year) nolog

*INSTITUTIONAL CAPACITY INDICATOR = World Governance Indicators "Rule of Law" (sample includes developing countries only; estimates are coefficients)
xtnbreg claims rulelaw exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if exposr>0, pa robust exposure(year) nolog

*INSTITUTIONAL CAPACITY INDICATOR = World Governance Indicators "Control of Corruption" (sample includes developing countries only; estimates are coefficients)
xtnbreg claims gicorrupt exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if exposr>0, pa robust exposure(year) nolog

*INSTITUTIONAL CAPACITY INDICATOR = Transparency International Corruption Perceptions Index (sample includes developing countries only; estimates are coefficients)
xtnbreg claims cpi exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if exposr>0, pa robust exposure(year) nolog

*The following models employ an alternative estimator, a regular/standard negative binomial model (coefficients only)
*All observations in which the "exposr" variable = 0 are excluded from the sample

*INSTITUTIONAL CAPACITY INDICATOR = CIM (sample includes developing countries only; estimates are coefficients)
nbreg claims cim exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if exposr>0, exposure(year) cluster(cow) nolog

*INSTITUTIONAL CAPACITY INDICATOR = ICRG "Law & Order" (sample includes developing countries only; estimates are coefficients)
nbreg claims lawordr exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if exposr>0, exposure(year) cluster(cow) nolog

*INSTITUTIONAL CAPACITY INDICATOR = ICRG "Corruption" (sample includes developing countries only; estimates are coefficients)
nbreg claims icrgcorrupt exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if exposr>0, exposure(year) cluster(cow) nolog

*INSTITUTIONAL CAPACITY INDICATOR = World Governance Indicators "Rule of Law" (sample includes developing countries only; estimates are coefficients)
nbreg claims rulelaw exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if exposr>0, exposure(year) cluster(cow) nolog

*INSTITUTIONAL CAPACITY INDICATOR = World Governance Indicators "Control of Corruption" (sample includes developing countries only; estimates are coefficients)
nbreg claims gicorrupt exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if exposr>0, exposure(year) cluster(cow) nolog

*INSTITUTIONAL CAPACITY INDICATOR = Transparency International Corruption Perceptions Index (sample includes developing countries only; estimates are coefficients)
nbreg claims cpi exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv if exposr>0, exposure(year) cluster(cow) nolog

*The following models are exactly the same as those which appear in TABLE 2 except that all observations for Argentina are excluded from the sample

drop if country == "Argentina"

*INSTITUTIONAL CAPACITY INDICATOR = CIM (sample includes all countries; estimates are coefficients)
zinb claims cim exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv, inflate(nobits) exposure(year) cluster(cow) nolog

*INSTITUTIONAL CAPACITY INDICATOR = ICRG "Law & Order" (sample includes all countries; estimates are coefficients)
zinb claims lawordr exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv, inflate(nobits) exposure(year) cluster(cow) nolog

*INSTITUTIONAL CAPACITY INDICATOR = ICRG "Corruption" (sample includes all countries; estimates are coefficients)
zinb claims icrgcorrupt exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv, inflate(nobits) exposure(year) cluster(cow) nolog

*INSTITUTIONAL CAPACITY INDICATOR = World Governance Indicators "Rule of Law" (sample includes all countries; estimates are coefficients)
zinb claims rulelaw exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv, inflate(nobits) exposure(year) cluster(cow) nolog

*INSTITUTIONAL CAPACITY INDICATOR = World Governance Indicators "Control of Corruption" (sample includes all countries; estimates are coefficients)
zinb claims gicorrupt exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv, inflate(nobits) exposure(year) cluster(cow) nolog

*INSTITUTIONAL CAPACITY INDICATOR = Transparency International Corruption Perceptions Index (sample includes all countries; estimates are coefficients)
zinb claims cpi exposr lnfdistk globlclms glbclmsq growth fdigdp polcon leftexec currency lagdv, inflate(nobits) exposure(year) cluster(cow) nolog

