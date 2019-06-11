use ../Data/Country.dta, clear

reg ln_patents risktaking, ro
reg ln_patents risktaking abslat precip temp rugged kgatrstr distcr island, ro
reg ln_articles risktaking, ro
reg ln_articles risktaking abslat precip temp rugged kgatrstr distcr island, ro
reg ctfp_ave risktaking, ro
reg ctfp_ave risktaking abslat precip temp rugged kgatrstr distcr island, ro
reg volunteering_gdp social, ro
reg volunteering_gdp social abslat precip temp rugged kgatrstr distcr island, ro
reg ln_total_conflicts_prio negrecip, ro
reg ln_total_conflicts_prio negrecip abslat precip temp rugged kgatrstr distcr island, ro





