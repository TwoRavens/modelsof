gl dropbox "E:/Dropbox/CleanWaterAct/dataSTATA/keiserShapiro_replication"
cd "$dropbox"


gl X   "miss_hour hour hour_2 hour_3 doy_1 doy_2 doy_3 prcp tmean lnflownhd_cfs lnvelocitynhd_fps"
gl Xid "miss_hour hour hour_2 hour_3 doy_1 doy_2 doy_3 prcp tmean"
gl Xtrends "miss_hour hour hour_2 hour_3 doy_1 doy_2 doy_3"

set matsize 10000
set maxvar  10000
cap ssc install reghdfe
cap ssc install tuples
cap ssc install renvars
cap ssc install eclplot
