
/* RUN AFTER DO-FILE: "AEW_1_Table 3 and Table 2" */
gen gdpgrowth = (ny_gdp_pcap_kd - L_ny_gdp_pcap_kd)/ ny_gdp_pcap_kd
regress dparty_all lparty_all pmposition_ch_all ingovt ingovtxpmposition_ch_all if pm!=1 & sl_uem_totl_zs>6.7 , cluster(cmpcode)
regress dparty_all lparty_all pmposition_ch_all ingovt ingovtxpmposition_ch_all if pm!=1 & sl_uem_totl_zs<6.7 , cluster(cmpcode)
gen highunemp = .
replace highunemp = 1 if sl_uem_totl_zs>6.7 & sl_uem_totl_zs !=.
replace highunemp = 0 if sl_uem_totl_zs<6.7 & sl_uem_totl_zs !=.
gen highunempTriple = highunemp*ingovt*pmposition_ch_all
gen highunempxingovt = highunemp*ingovt
gen highunempxpmposition_ch_all = highunemp*pmposition_ch_all
regress dparty_all lparty_all pmposition_ch_all ingovt ingovtxpmposition_ch_all highunemp highunempxingovt highunempxpmposition_ch_all highunempTriple if pm!=1, cluster(cmpcode)



regress dparty_all lparty_all pmposition_ch_all ingovt ingovtxpmposition_ch_all if pm!=1 & fp_cpi_totl_zg > 1.19 , cluster(cmpcode)
regress dparty_all lparty_all pmposition_ch_all ingovt ingovtxpmposition_ch_all if pm!=1 & fp_cpi_totl_zg < 1.19 , cluster(cmpcode)

gen highinf = .
replace highinf = 1 if fp_cpi_totl_zg > 1.19 & fp_cpi_totl_zg !=.
replace highinf = 0 if fp_cpi_totl_zg < 1.19 & fp_cpi_totl_zg !=.
gen highinfTriple = highinf*ingovt*pmposition_ch_all
gen highinfxingovt = highinf*ingovt
gen highinfxpmposition_ch_all = highinf*pmposition_ch_all
regress dparty_all lparty_all pmposition_ch_all ingovt ingovtxpmposition_ch_all highinf highinfxingovt highinfxpmposition_ch_all highinfTriple if pm!=1, cluster(cmpcode)


regress dparty_all lparty_all pmposition_ch_all ingovt ingovtxpmposition_ch_all if pm!=1 &gdpgrowth> .0096 , cluster(cmpcode)
regress dparty_all lparty_all pmposition_ch_all ingovt ingovtxpmposition_ch_all if pm!=1 &gdpgrowth< .0096 , cluster(cmpcode)

gen highgdp = .
replace highgdp = 1 if gdpgrowth>.0096 & gdpgrowth !=.
replace highgdp = 0 if gdpgrowth < .0096 & gdpgrowth !=.
gen highgdpTriple = highgdp*ingovt*pmposition_ch_all
gen highgdpxingovt = highgdp*ingovt
gen highgdpxpmposition_ch_all = highgdp*pmposition_ch_all
regress dparty_all lparty_all pmposition_ch_all ingovt ingovtxpmposition_ch_all highgdp highgdpxingovt highgdpxpmposition_ch_all highgdpTriple if pm!=1, cluster(cmpcode)
