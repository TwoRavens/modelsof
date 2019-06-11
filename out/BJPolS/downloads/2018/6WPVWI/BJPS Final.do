**Ethnicity, National Identity and the State: Evidence from Sub-Saharan Africa**
**by Elliott D. Green, LSE**
**British Journal of Political Science, forthcoming**

*For Tables 2 & 3 use "BJPS Green 1"
*For Table 4 use "BJPS Green 2"
*For Table 5 use "BJPS Green 3"

**Table 2**
*Full
xtmixed NatOverEthnic CoreEthnic PresidentEG PeripheralGroup EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog BritColony LogGDPpc ELF if CountryData==1 || COUNTRY: || Q84: , variance 
*Basic Results
xtmixed NatOverEthnic CoreEthnic PeripheralGroup EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog BritColony LogGDPpc ELF if CountryData==1 & PresCore==1 || COUNTRY: || Q84: , variance 
xtmixed NatOverEthnic CoreEthnic PresidentEG PeripheralGroup EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog BritColony LogGDPpc ELF if CountryData==1 & PresCore==0 || COUNTRY: || Q84: , variance 
*Largest Group insted of Core Ethnic Group (makes 5 changes: Botswana, Burundi, Guinea, Nigeria, Sierra Leone)
xtmixed NatOverEthnic LargestGroup PeripheralGroup EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog BritColony LogGDPpc ELF if CountryData==1 & PresLargest==1 || COUNTRY: || Q84: , variance 
xtmixed NatOverEthnic LargestGroup PresidentEG PeripheralGroup EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog BritColony LogGDPpc ELF if CountryData==1 & PresLargest==0 || COUNTRY: || Q84: , variance 
*Basic Results with additional controls for public goods (electricity, piped water, sewage, post office, school, police station, health clinic, paved road*
xtmixed NatOverEthnic CoreEthnic PresidentRegion PeripheralGroup EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog BritColony LogGDPpc ELF EA_SVC_A EA_SVC_B EA_SVC_C EA_FAC_A EA_FAC_B EA_FAC_C EA_FAC_D EA_ROAD if CountryData==1 & PresCore==1 || COUNTRY: || Q84: , variance 
xtmixed NatOverEthnic CoreEthnic PresidentEG PresidentRegion PeripheralGroup EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog BritColony LogGDPpc ELF EA_SVC_A EA_SVC_B EA_SVC_C EA_FAC_A EA_FAC_B EA_FAC_C EA_FAC_D EA_ROAD if CountryData==1 & PresCore==0 || COUNTRY: || Q84: , variance 

**Table 3**
*National Identity on 5 point scale*
xtmixed NatId5points CoreEthnic PeripheralGroup EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog BritColony LogGDPpc ELF if CountryData==1 & PresCore==1 || COUNTRY: || Q84: , variance 
xtmixed NatId5points CoreEthnic PresidentEG PeripheralGroup EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog BritColony LogGDPpc ELF if CountryData==1 & PresCore==0 || COUNTRY: || Q84: , variance 
*Basic Results with additional country controls, including determinants of ELF and history of the colonial and post-colonial state*
xtmixed NatOverEthnic CoreEthnic PeripheralGroup EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog BritColony LogGDPpc LogSlaveExp LogLat LogKm2 LogColonialLength LogIndependence if CountryData==1 & PresCore==1 || COUNTRY: || Q84: , variance 
xtmixed NatOverEthnic CoreEthnic PresidentEG PeripheralGroup EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog BritColony LogGDPpc LogSlaveExp LogLat LogKm2 LogColonialLength LogIndependence if CountryData==1 & PresCore==0 || COUNTRY: || Q84: , variance 

**Table 4: Round 4**
*Basic Results*
xtmixed NatOverEthnic CoreEthnic PeripheralGroup EGperc EGpercsq Partition1 URBRUR Age Agesq Q101 Muslim Radio TV FTEmploy EdDummy BritColony LogGDPpc ELF if Q79<900 & PresCore==1 || COUNTRY: || Q79: , variance
xtmixed NatOverEthnic CoreEthnic PresidentEG PeripheralGroup EGperc EGpercsq Partition1 URBRUR Age Agesq Q101 Muslim Radio TV FTEmploy EdDummy BritColony LogGDPpc ELF if Q79<900 & PresCore==0 || COUNTRY: || Q79: , variance
*Largest Group insted of Core Ethnic Group*
xtmixed NatOverEthnic LargestGroup PeripheralGroup EGperc EGpercsq Partition1 URBRUR Age Agesq Q101 Muslim Radio TV FTEmploy EdDummy BritColony LogGDPpc ELF if Q79<900 & PresLargest==1 || COUNTRY: || Q79: , variance
xtmixed NatOverEthnic LargestGroup PresidentEG PeripheralGroup EGperc EGpercsq Partition1 URBRUR Age Agesq Q101 Muslim Radio TV FTEmploy EdDummy BritColony LogGDPpc ELF if Q79<900 & PresLargest==0 || COUNTRY: || Q79: , variance

**Table 5: Country-Level Data**
reg natoverethnic ceinpower loggdppc elf britcolony polity Round5 Round4 Round3, vce (cluster countryid)
reg natoverethnic ceinpower loggdppc elf britcolony polity Round5 if round56balanced==1, vce (cluster countryid)
reg natoverethnic ceinpower loggdppc elf britcolony polity Round5 Round4 if round456balanced==1, vce (cluster countryid)
reg natoverethnic ceinpower loggdppc elf britcolony polity Round5 Round4 Round3 if round3456balanced==1, vce (cluster countryid)

**Table A1.1: Additional Results**
*Without Asian settler countries
xtmixed NatOverEthnic CoreEthnic PeripheralGroup EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog BritColony LogGDPpc ELF if CountryData==1 & PresCore==1 & AsianMinority==0 || COUNTRY: || Q84: , variance 
xtmixed NatOverEthnic CoreEthnic PeripheralGroup PresidentEG EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog BritColony LogGDPpc ELF if CountryData==1 & PresCore==0 & AsianMinority==0  || COUNTRY: || Q84: , variance 
*Without White settler countries
xtmixed NatOverEthnic CoreEthnic PeripheralGroup EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog BritColony LogGDPpc ELF if CountryData==1 & PresCore==1 & WhiteMinority==0 || COUNTRY: || Q84: , variance 
xtmixed NatOverEthnic CoreEthnic PeripheralGroup PresidentEG EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog BritColony LogGDPpc ELF if CountryData==1 & PresCore==0 & WhiteMinority==0  || COUNTRY: || Q84: , variance 

**Table A1.2: Pooled OLS using one country at a time**
reg NatOverEthnic CoreEthnic PeripheralGroup EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog if CountryData==1 & Country19==1, r cluster (Q84)
reg NatOverEthnic CoreEthnic PeripheralGroup EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog if CountryData==1 & Country2==1, r cluster (Q84)
reg NatOverEthnic CoreEthnic PeripheralGroup EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog if CountryData==1 & Country3==1, r cluster (Q84)
reg NatOverEthnic CoreEthnic PeripheralGroup EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog if CountryData==1 & Country7==1, r cluster (Q84)
reg NatOverEthnic CoreEthnic PeripheralGroup EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog if CountryData==1 & Country16==1, r cluster (Q84)
reg NatOverEthnic CoreEthnic PeripheralGroup EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog if CountryData==1 & Country21==1, r cluster (Q84)
reg NatOverEthnic CoreEthnic PeripheralGroup EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog if CountryData==1 & Country9==1, r cluster (Q84)
reg NatOverEthnic CoreEthnic PeripheralGroup EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog if CountryData==1 & Country23==1, r cluster (Q84)
reg NatOverEthnic CoreEthnic PeripheralGroup EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog if CountryData==1 & Country25==1, r cluster (Q84)
reg NatOverEthnic CoreEthnic PeripheralGroup EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog if CountryData==1 & Country10==1, r cluster (Q84)
reg NatOverEthnic CoreEthnic PeripheralGroup EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog if CountryData==1 & Country26==1, r cluster (Race)
reg NatOverEthnic CoreEthnic PeripheralGroup EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog if CountryData==1 & Country28==1, r cluster (Q84)
reg NatOverEthnic CoreEthnic PeripheralGroup EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog if CountryData==1 & Country29==1, r cluster (Q84)

reg NatOverEthnic CoreEthnic PeripheralGroup PresidentEG EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog if CountryData==1 & Country1==1, r cluster (Q84)
reg NatOverEthnic CoreEthnic PeripheralGroup PresidentEG EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog if CountryData==1 & Country15==1, r cluster (Q84)
reg NatOverEthnic CoreEthnic PeripheralGroup PresidentEG EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog if CountryData==1 & Country5==1, r cluster (Q84)
reg NatOverEthnic CoreEthnic PeripheralGroup PresidentEG EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog if CountryData==1 & Country22==1, r cluster (Q84)
reg NatOverEthnic CoreEthnic PeripheralGroup PresidentEG EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog if CountryData==1 & Country24==1, r cluster (Q84)
reg NatOverEthnic CoreEthnic PeripheralGroup PresidentEG EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog if CountryData==1 & Country11==1, r cluster (Q84)
reg NatOverEthnic CoreEthnic PeripheralGroup PresidentEG EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog if CountryData==1 & Country12==1, r cluster (Q84)
reg NatOverEthnic CoreEthnic PeripheralGroup PresidentEG EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog if CountryData==1 & Country13==1, r cluster (Q84)
reg NatOverEthnic CoreEthnic PeripheralGroup PresidentEG EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog if CountryData==1 & Country14==1, r cluster (Q84)
reg NatOverEthnic CoreEthnic PeripheralGroup PresidentEG EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog if CountryData==1 & Country18==1, r cluster (Q84)

*Table A1.3: Descriptive Statistics
summarize NatOverEthnic CoreEthnic PeripheralGroup EGperc Partition1 Urban Age Agesq Q101 Muslim Radio TV NoInternet FTEmploy EdDummy CCDlog BritColony LogGDPpc ELF if CountryData==1
