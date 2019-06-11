global cluster = "date"

use DatCL, clear


global i = 1
global j = 1
*Table 7
mycmd (paintings chat oo within_subj) reg attach_to_gr paintings chat oo within_subj, cluster(date)
mycmd (paintings chat oo within_subj) ologit attach_to_gr paintings chat oo within_subj, cluster(date)

