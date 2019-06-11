

global cluster = "school_id"

*Part I - Tables 2 & 4 - 2001 regressions (treatment year only, not specification checks)

use DatAL1, clear

global i = 1
global j = 1
*Table 2
foreach g in 0 1 {
	mycmd (treated) brl zakaibag treated semarab semrel if boy == `g', cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel if boy == `g', logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls50 b`g'ls75 b`g'ls100 educav educem ah4 ole5, cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls50 b`g'ls75 b`g'ls100 educav educem ah4 ole5, logit cluster(school_id)
	}

mycmd (treated) brl zakaibag treated semarab semrel, cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel, logit cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel PAIR2-PAIR19, cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel PAIR2-PAIR19, logit cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5, cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5, logit cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5 PAIR2-PAIR19, cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5 PAIR2-PAIR19, logit cluster(school_id)

*Table 4
foreach g in 0 1 {
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls100 if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls50 if boy == `g' & b`g'bot_ls == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'p100 if boy == `g' & b`g'top_p == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'p50 if boy == `g' & b`g'bot_p == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'bot_ls == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'top_p == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'bot_p == 1, logit cluster(school_id)
	}

********************************

*Part II:  Table 5 - First part 

use DatAL2, clear

foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls100 year S2-S39 if b`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls25 year S2-S39 if b`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p100 year S2-S39 if b`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p year S2-S39 if b`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p25 year S2-S39 if b`g'bot_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p year S2-S39 if b`g'bot_p == 1, robust
	}

*****************************

*Part III: Table 5, second part

use DatAL3, clear

foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls100 year S2-S39 if b`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls25 year S2-S39 if b`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p100 year S2-S39 if b`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p year S2-S39 if b`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p25 year S2-S39 if b`g'bot_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p year S2-S39 if b`g'bot_p == 1, robust
	}

*************

*Part IV: Table 5, third part

use DatAL4, clear

foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls100 S2-S39 if b`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls S2-S39 if b`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls25 S2-S39 if b`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls S2-S39 if b`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p100 S2-S39 if b`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p S2-S39 if b`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p25 S2-S39 if b`g'bot_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p S2-S39 if b`g'bot_p == 1, robust
	}

************************

*Part V:  Table 6 , top panel 2001

use DatAL5, clear

foreach g in 0 1 {
	mycmd (treated) brl zakaibag treated semarab semrel if boy == `g' & b`g'top_lsq == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'top_lsq == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel if boy == `g' & b`g'bot_lsq == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'bot_lsq == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel if boy == `g' & b`g'top_pq == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'top_pq == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel if boy == `g' & b`g'bot_pq == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'bot_pq == 1, logit cluster(school_id)
	}

*******************

*Part VI:  Table 6, bottom panel

use DatAL6, clear

foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab semrel year S2-S39 if b`g'top_lsq == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel year b`g'ls S2-S39 if b`g'top_lsq == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel year S2-S39 if b`g'bot_lsq == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel year b`g'ls S2-S39 if b`g'bot_lsq == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel year S2-S39 if b`g'top_pq == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel year b`g'p S2-S39 if b`g'top_pq == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel year S2-S39 if b`g'bot_pq == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel year b`g'p S2-S39 if b`g'bot_pq == 1, robust
	}


*************************

*Part 7 - Table 7 - 2001 and 2000/2001 regressions only (not 2000 regressions, following procedure for all such regressions in this paper)

use DatAL7, clear

foreach g in 0 1 {
	foreach outcome in att18 att20 att22 att24 awr18 awr20 awr22 awr24 achv_math achv_eng achv_hib bag_cond_att18 bag_cond_att20 bag_cond_att22 bag_cond_att24 {
		mycmd (treated01) logit `outcome' treated01 semarab01 semrel01 b`g'ls100 year01 S2-S39 if boy == `g' & b`g'zak_`outcome' == 1, robust
		}
	}
foreach g in 0 1 {
	foreach year in 1 {
		foreach outcome in att18 att20 att22 att24 awr18 awr20 awr22 awr24 achv_math achv_eng achv_hib bag_cond_att18 bag_cond_att20 bag_cond_att22 bag_cond_att24 {
			mycmd (treated) brl `outcome' treated semarab semrel b`g'ls100 if year == `year' & boy == `g' & b`g'zak_`outcome' == 1, logit cluster(school_id)
			}
		}
	}

************

*Part 8:  Table A5 - Regressions that are new (not reproducing Table 5) 

use DatAL8, clear

foreach g in 0 1 {
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls100 if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls50 if boy == `g' & b`g'top_ls == 0, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 0, logit cluster(school_id)
	}









