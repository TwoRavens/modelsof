/* Works with State MP 12.1 */


use "BoganMFIData.dta"



/* Replication of Main Results */


/* Tables 2 and 3 */
tabulate chartercode, missing
summarize reg nonprofit acceptdep loansasassets depasassets grantsasassets reasassets sharecapasassets logassets par FSDum norate activeborrowers
sort year
by year: summarize reg nonprofit acceptdep loansasassets depasassets grantsasassets reasassets sharecapasassets logassets par FSDum norate activeborrowers



/* Table 4 */
regress opselfsuff youngstage maturestage, cluster(MFICode)
regress opselfsuff loansasassets grantsasassets sharecapasassets depasassets acceptdep bank NGO logassets logborrow logsave youngstage maturestage year06, cluster(MFICode)

probit FSDum youngstage maturestage, cluster(MFICode)
probit FSDum loansasassets grantsasassets sharecapasassets depasassets acceptdep bank NGO logassets logborrow logsave youngstage maturestage year06, cluster(MFICode)




/* Table 5 */

regress opselfsuff loansasassets grantsasassets sharecapasassets depasassets acceptdep bank NGO age logassets logborrow logsave year06, cluster(MFICode)

regress opselfsuff loansasassets grantsasassets sharecapasassets depasassets acceptdep bank NGO age logassets logborrow logsave africa sasia latina easia eeurope year06 logFDIlag FDIgrowth logGDPlag Growthlag Inflationlag, cluster(MFICode)

regress opselfsuff loansasassets grantsasassets sharecapasassets depasassets acceptdep bank NGO age logassets logborrow logsave africa sasia latina easia eeurope reg norate year06 logFDIlag FDIgrowth logGDPlag Growthlag Inflationlag, cluster(MFICode)

regress opselfsuff loansasassets grantsasassets sharecapasassets depasassets acceptdep bank NGO age logassets logborrow logsave africa sasia latina easia eeurope reg norate nonprofit grouplend securitize year06 logFDIlag FDIgrowth logGDPlag Growthlag Inflationlag, cluster(MFICode)




/* Table 6 - Summary stats by charter type */
sort chartercode
by chartercode: summarize loansasassets grantsasassets sharecapasassets depasassets acceptdep par age logassets activeborrowers savers



/* Table 7 - Analysis by Charter Type */
sort chartertype
by chartertype: regress opselfsuff loansasassets grantsasassets sharecapasassets depasassets  acceptdep age logassets logborrow logsave year06 logFDIlag FDIgrowth logGDPlag Growthlag Inflationlag, cluster(MFICode)



/* Table 8 - Main 2SLS */
ivreg2 opselfsuff loansasassets depasassets acceptdep bank NGO age logassets logborrow logsave reg norate nonprofit year06 countryGrowth countryInflation (grantsasassets sharecapasassets = Growthlag Inflationlag), first
overid



clear
