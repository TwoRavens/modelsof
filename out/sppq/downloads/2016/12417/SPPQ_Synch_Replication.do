*Load Replication Data
use "...\160127_RTW_Replication.dta", clear

*Specify directory for saving Stat output
cd "...\StataOut_Replication"
xtset fips year

*Louisiana: 1977
*Top 1%
synth  top1_ps top1_ps(1940(1)1976) urban(1940(1)1976) dem_share(1940(1)1976) log_pop(1940(1)1976) manufacturing(1940(1)1976) homeown(1940(1)1976), trunit(22) counit(6 8 9 10 17 21 23 24 25 26 27 29 30 34 35 36 39 41 42 44 50 53 54 55 ) trperiod(1977) resultsperiod(1977(1)1987) keep(LA_1_out_replication.dta)

*Top 10%
synth  top10_ps top10_ps(1940(1)1976) urban(1940(1)1976) dem_share(1940(1)1976) log_pop(1940(1)1976) manufacturing(1940(1)1976) homeown(1940(1)1976), trunit(22) counit(6 8 9 10 17 21 23 24 25 26 27 29 30 34 35 36 39 41 42 44 50 53 54 55 ) trperiod(1977) resultsperiod(1977(1)1987) keep(LA_10_out_replication.dta)

*Gini
synth  gini gini(1940(1)1976) urban(1940(1)1976) dem_share(1940(1)1976) log_pop(1940(1)1976) manufacturing(1940(1)1976) homeown(1940(1)1976), trunit(22) counit(6 8 9 10 17 21 23 24 25 26 27 29 30 34 35 36 39 41 42 44 50 53 54 55 ) trperiod(1977) resultsperiod(1977(1)1987) keep(LA_gini_out_replication.dta)

*Idaho: 1986
*Top 1%
synth  top1_ps top1_ps(1940(1)1985) urban(1940(1)1985) dem_share(1940(1)1985) log_pop(1940(1)1985) manufacturing(1940(1)1985) homeown(1940(1)1985), trunit(16) counit(6 8 9 10 17 21 23 24 25 26 27 29 30 34 35 36 39 41 42 44 50 53 54 55 ) trperiod(1986) resultsperiod(1986(1)1996) keep(ID_1_out_replication.dta)

*Top 10%
synth  top10_ps top10_ps(1940(1)1985) urban(1940(1)1985) dem_share(1940(1)1985) log_pop(1940(1)1985) manufacturing(1940(1)1985) homeown(1940(1)1985), trunit(16) counit(6 8 9 10 17 21 23 24 25 26 27 29 30 34 35 36 39 41 42 44 50 53 54 55 ) trperiod(1986) resultsperiod(1986(1)1996) keep(ID_10_out_replication.dta)

*Gini
synth  gini gini(1940(1)1985) urban(1940(1)1985) dem_share(1940(1)1985) log_pop(1940(1)1985) manufacturing(1940(1)1985) homeown(1940(1)1985), trunit(16) counit(6 8 9 10 17 21 23 24 25 26 27 29 30 34 35 36 39 41 42 44 50 53 54 55 ) trperiod(1986) resultsperiod(1986(1)1996) keep(ID_gini_out_replication.dta)

*Oklahoma: 2002
*Top 1%
synth  top1_ps top1_ps(1940(1)2001) urban(1940(1)2001) dem_share(1940(1)2001) log_pop(1940(1)2001) manufacturing(1940(1)2001) homeown(1940(1)2001), trunit(40) counit(6 8 9 10 17 21 23 24 25 26 27 29 30 34 35 36 39 41 42 44 50 53 54 55 ) trperiod(2002) resultsperiod(2002(1)2012) keep(OK_1_out_replication.dta)

*Top 10%
synth  top10_ps top10_ps(1940(1)2001)  urban(1940(1)2001) dem_share(1940(1)2001) log_pop(1940(1)2001) manufacturing(1940(1)2001) homeown(1940(1)2001), trunit(40) counit(6 8 9 10 17 21 23 24 25 26 27 29 30 34 35 36 39 41 42 44 50 53 54 55 ) trperiod(2002) resultsperiod(2002(1)2012) keep(OK_10_out_replication.dta)

*Gini
synth  gini gini(1940(1)2001) urban(1940(1)2001) dem_share(1940(1)2001) log_pop(1940(1)2001) manufacturing(1940(1)2001) homeown(1940(1)2001), trunit(40) counit(6 8 9 10 17 21 23 24 25 26 27 29 30 34 35 36 39 41 42 44 50 53 54 55 ) trperiod(2002) resultsperiod(2002(1)2012) keep(OK_gini_out_replication.dta)
