
use "timberauctionbidobservations_80to90.dta", clear

gen advertisedrate2 = advertisedrate
replace advertisedrate = advertisedrate*volumetotal2/volumetotal
gen sellingvalue2 = sellingvalue
replace sellingvalue = sellingvalue*volumetotal2/volumetotal
gen mfgcost2 = mfgcost
replace mfgcost= mfgcost*volumetotal2/volumetotal
gen loggingcosts2 = loggingcosts
replace loggingcosts = loggingcosts*volumetotal2/volumetotal

gen lnadvertisedrate = log(advertisedrate)
gen lnsellingvalue = log(sellingvalue)
gen lnmfgcost = log(mfgcost)
gen lnvolume = log(volumetotal)
gen lnlogging = log(loggingcosts)
gen lnroad = log(roadcosts)


gen numofmillifmill = nummills*milldummy
gen numofmilliflogger = nummills*loggerdummy
gen numofloggerifmill = numloggers*milldummy
gen numofloggeriflogger = numloggers*loggerdummy


replace lnmfgcost = 0 if lnmfgcost == .
replace lnadvertisedrate = 0 if lnadvertisedrate == .
replace lnsellingvalue = 0 if lnsellingvalue == .
replace lnvolume = 0 if lnvolume == .
replace lnlogging = 0 if lnlogging == .
replace lnroad = 0 if lnroad == .

gen bid4 = bid2*volumetotal
gen advertisedrate4 = advertisedrate*volumetotal
gen sellingvalue4 = sellingvalue*volumetotal
gen mfgcost4 = mfgcost*volumetotal
gen loggingcosts4 = loggingcosts*volumetotal
gen roadcosts4 = roadcosts*volumetotal
gen lnsellingvalue4 = log(sellingvalue4)
gen lnmfgcost4 = log(mfgcost4)
gen lnlogging4 = log(loggingcosts4)
gen lnroad4 = log(roadcosts4)
replace lnmfgcost4 = 0 if lnmfgcost4 == .
replace lnsellingvalue4 = 0 if lnsellingvalue4 == .
replace lnlogging4 = 0 if lnlogging4 == .
replace lnroad4 = 0 if lnroad4 == .


gen bid4_log = log(bid4)
gen advertisedrate4_log = log(advertisedrate4)



///OLS REGRESSION ALL DUMMIES

reg bid4_log advertisedrate4_log lnsellingvalue4 lnmfgcost4 density lnvolume lnlogging4 lnroad4 salvagesaledummy ///
specieshhi contractlength ///
milldummy numbidders numofmillifmill numofmilliflogger ///
dummy82 dummy83 dummy84 dummy85 dummy86 dummy87 dummy88 dummy90 ///
region2dummy region3dummy region4dummy region5dummy region6dummy region8dummy region9dummy region10dummy ///
if dummy78==0 & dummy79==0 & dummy80==0 & dummy81==0 




//SAME REGRESSIONS BUT WITH PREDICTED BIDDERS - 2SLS

gen numbidders_p = nummills_predict+numloggers_predict+numsb_predict

gen numofmillifmill_p = nummills_predict*milldummy
gen numofmilliflogger_p = nummills_predict*loggerdummy
gen numofloggerifmill_p = numloggers_predict*milldummy
gen numofloggeriflogger_p = numloggers_predict*loggerdummy

///IV REGRESSION ALL DUMMIES

reg bid4_log advertisedrate4_log lnsellingvalue4 lnmfgcost4 density lnvolume lnlogging4 lnroad4 salvagesaledummy ///
specieshhi contractlength ///
milldummy numbidders_p numofmillifmill_p numofmilliflogger_p ///
dummy82 dummy83 dummy84 dummy85 dummy86 dummy87 dummy88 dummy90 ///
region2dummy region3dummy region4dummy region5dummy region6dummy region8dummy region9dummy region10dummy ///
if dummy78==0 & dummy79==0 & dummy80==0 & dummy81==0 


reg bid4_log advertisedrate4_log density lnvolume salvagesaledummy ///
specieshhi contractlength ///
milldummy numbidders_p numofmillifmill_p numofmilliflogger_p ///
dummy82 dummy83 dummy84 dummy85 dummy86 dummy87 dummy88 dummy90 ///
region2dummy region3dummy region4dummy region5dummy region6dummy region8dummy region9dummy region10dummy ///
if dummy78==0 & dummy79==0 & dummy80==0 & dummy81==0 

//ONLY FOR MILL BIDDERS

reg bid4_log advertisedrate4_log density lnvolume salvagesaledummy ///
specieshhi contractlength ///
numbidders_p numofmillifmill_p  ///
dummy82 dummy83 dummy84 dummy85 dummy86 dummy87 dummy88 dummy90 ///
region2dummy region3dummy region4dummy region5dummy region6dummy region8dummy region9dummy region10dummy ///
if dummy78==0 & dummy79==0 & dummy80==0 & dummy81==0 & milldummy == 1

//ONLY FOR LOGGER BIDDERS

reg bid4_log advertisedrate4_log density lnvolume salvagesaledummy ///
specieshhi contractlength ///
numbidders_p numofmilliflogger_p  ///
dummy82 dummy83 dummy84 dummy85 dummy86 dummy87 dummy88 dummy90 ///
region2dummy region3dummy region4dummy region5dummy region6dummy region8dummy region9dummy region10dummy ///
if dummy78==0 & dummy79==0 & dummy80==0 & dummy81==0 & milldummy == 0



//REGRESSION BY REGION

///IV REGRESSION YEAR DUMMIES ONLY SOUTHERN REGION
reg bid4_log advertisedrate4_log density lnvolume salvagesaledummy ///
specieshhi contractlength ///
milldummy numbidders_p numofmillifmill_p ///
dummy82 dummy83 dummy84 dummy85 dummy86 dummy87 dummy88 dummy90 ///
if dummy78==0 & dummy79==0 & dummy80==0 & dummy81==0 & region8dummy == 1

///IV REGRESSION YEAR DUMMIES ONLY NORTHERN REGION
reg bid4_log advertisedrate4_log density lnvolume salvagesaledummy ///
specieshhi contractlength ///
milldummy numbidders_p numofmillifmill_p ///
dummy82 dummy83 dummy84 dummy85 dummy86 dummy87 dummy88 dummy90 ///
if dummy78==0 & dummy79==0 & dummy80==0 & dummy81==0 & region1dummy == 1



//REGRESSION BY SIZE OF MILLS
gen numofsmallmillifsmallmill = numsmallmills*smallmilldummy
gen numofsmallmilliflargemill = numsmallmills*largemilldummy
gen numofsmallmilliflogger = numsmallmills*loggerdummy
gen numoflargemillifsmallmill = numlargemills*smallmilldummy
gen numoflargemilliflargemill = numlargemills*largemilldummy
gen numoflargemilliflogger = numlargemills*loggerdummy
gen numofloggerifsmallmill = numloggers*smallmilldummy
gen numofloggeriflargemill = numloggers*largemilldummy

///REGRESSION ALL DUMMIES SMALL MILL / LARGE MILL

reg bid4_log advertisedrate4_log density lnvolume salvagesaledummy ///
specieshhi contractlength ///
largemilldummy smallmilldummy numbidders numofsmallmillifsmallmill numofsmallmilliflargemill ///
numoflargemillifsmallmill numoflargemilliflargemill ///
dummy82 dummy83 dummy84 dummy85 dummy86 dummy87 dummy88 dummy90 ///
region2dummy region3dummy region4dummy region5dummy region6dummy region8dummy region9dummy region10dummy ///
if dummy78==0 & dummy79==0 & dummy80==0 & dummy81==0 


///AFTER EACH REGRESSION TO EXPORT RESULTS INTO EXCEL
matrix results = r(table)
matrix results = results[1..6,1...]'
putexcel set putexcel2.xlsx, sheet(example1) modify
putexcel A1 = matrix(results)
