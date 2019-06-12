use ../Data/Country.dta, clear

reg lngdp_ave patience, ro
reg lngdp_ave patience abslat precip temp rugged kgatrstr distcr island, ro
reg lngdp_ave trust, ro
reg lngdp_ave trust abslat precip temp rugged kgatrstr distcr island, ro
reg lngdp_ave risktaking, ro
reg lngdp_ave risktaking abslat precip temp rugged kgatrstr distcr island, ro
reg lngdp_ave negrecip, ro
reg lngdp_ave negrecip abslat precip temp rugged kgatrstr distcr island, ro
reg lngdp_ave patience trust risktaking negrecip, ro
reg lngdp_ave patience trust risktaking negrecip abslat precip temp rugged kgatrstr distcr island, ro

