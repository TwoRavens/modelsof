*****************************
*Baldwin and Huber APSR 2010*
******Replication file*******
*****************************

use apsrfinaldata.dta, clear

*Table 1

reg pg  ELF_fearon_std lngdpstd popstd polity2std, robust

reg pg cultfrac_std lngdpstd popstd polity2std, robust

reg pg GIstd lngdpstd popstd polity2std, robust

reg pg betweenstd lngdpstd popstd polity2std afrobarom wvs cses, robust

reg pg ELF_fearon_std cultfrac_std betweenstd lngdpstd popstd polity2std afrobarom wvs cses, robust

reg pg ELF_fearon_std GIstd betweenstd lngdpstd popstd polity2std afrobarom wvs cses, robust

reg pg ELF_fearon_std betweenstd lngdpstd popstd polity2std afrobarom wvs cses, robust

*Table 2

reg pg ELF_fearon_std  betweenstd  gini_net_std  lngdpstd  popstd polity2std  afrobarom wvs cses   , robust

reg pg ELF_fearon_std  betweenstd  gini_net_std geo_iso_std lngdpstd  popstd polity2std  afrobarom wvs cses   , robust

reg pg ELF_fearon_std  betweenstd gini_net_std geo_iso_std lngdpstd  popstd polity2std afrobarom wvs cses if ELF_e>=.25, robust

reg pg ELF_fearon_std  betweenstd gini_net_std geo_iso_std lngdpstd  popstd polity2std afrobarom wvs cses if polity2<10, robust

reg pg_05pct elf_05pct  between_05pct gini_05pct iso_05pct lngdp_05pct pop_05pct polity_05pct afrobarom wvs cses, robust

*Table 3
		  
reg pg ELF_fearon_std  between_afrorev gini_net_std geo_iso_std lngdpstd  popstd polity2std  afrobarom wvs cses  , robust

reg pg10_year ELF_year between_year gininetstd_year isostd_year lngdpstd_year popstd_year polity2std_year year afrobarom_year wvs_year , robust

reg pg10_year ELF_year between_year gininetstd_year isostd_year lngdpstd_year popstd_year polity2std_year year afrobarom_year wvs_year if polity2_year<10, robust

reg pg6_year ELF_year between_year gininetstd_year isostd_year lngdpstd_year popstd_year polity2std_year year afrobarom_year wvs_year, robust

reg pg6_year ELF_year between_year gininetstd_year isostd_year lngdpstd_year popstd_year polity2std_year year afrobarom_year wvs_year if polity2_year<10, robust


