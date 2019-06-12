* Load data *
use "kriner_reeves_apsr_2015.dta"

* Table 2 from APSR Main Text *
xtreg lngrants compstate  corestate1  president majority any_chair  appropsorways  lnnewpop  pctpoverty pcincomecd years1-years26,  fe cluster(fips_state_county_code)
outreg2 using apsrtable2, word label dec(3)  drop( years1-years26) noaster replace 
xtreg lngrants compstate compstatexelyear corestate1 corestate1xelyear  president majority any_chair  appropsorways  lnnewpop  pctpoverty pcincomecd years1-years26,  fe cluster(fips_state_county_code)
outreg2 using apsrtable2, word label dec(3)  drop( years1-years26) append noaster
xtreg lngrants compstate compstatexreelectionelyear compstatexsuccessorelyear corestate1  president majority any_chair  appropsorways   lnnewpop  pctpoverty pcincomecd years1-years26,  fe cluster(fips_state_county_code)
outreg2 using apsrtable2, word label dec(3)  drop( years1-years26)  append noaster
xtreg lngrants compstate compstatexreelectionelyear compstatexsuccessorelyear corestate1  president majority any_chair  appropsorways corecounty1 corecounty1xcompstate corecounty1xcorestate lnnewpop  pctpoverty pcincomecd years1-years26,  fe cluster(fips_state_county_code)
outreg2 using apsrtable2, word label dec(3)  drop( years1-years26) append noaster sortvar(compstate corestate1 compstatexelyear corestate1xelyear compstatexreelectionelyear  compstatexsuccessorelyear corecounty1 corecounty1xcompstate corecounty1xcorestate  president majority any_chair  appropsorways  lnnewpop  pctpoverty pcincomecd) 

* Supporting Information *

* SI Table 1 -- Continuous Measures *
xtreg lngrants comploseravglast3  president majority any_chair  appropsorways  lnnewpop  pctpoverty pcincomecd years1-years26,  fe cluster(fips_state_county_code)
outreg2 using sitable1, word label dec(3) replace drop( years1-years26) noaster
xtreg lngrants comploseravglast3 stateincavglast3 president majority any_chair  appropsorways  lnnewpop  pctpoverty pcincomecd years1-years26,  fe cluster(fips_state_county_code)
outreg2 using sitable1, word label dec(3) append drop( years1-years26) noaster

* SI Table 2 -- Additional Congressional Controls from BBH *

xtreg lngrants compstate corestate1  president majority any_chair  appropsorways any_rank leader republican sn_firstterm cong_close lnnewpop  pctpoverty pcincomecd years1-years26,  fe cluster(fips_state_county_code)
outreg2 using sitable2, word label dec(3) replace drop( years1-years26) noaster

* SI Table 3 -- Excluding Counties that Do not Match Into a Single CD *
xtreg lngrants compstate  corestate1  president majority any_chair  appropsorways  lnnewpop  pctpoverty pcincomecd years1-years26 if cdmatch100!=.,  fe cluster(fips_state_county_code)
outreg2 using sitable3, word label dec(3) replace drop( years1-years26) noaster
xtreg lngrants compstate compstatexelyear corestate1 corestate1xelyear  president majority any_chair  appropsorways  lnnewpop  pctpoverty pcincomecd years1-years26 if cdmatch100!=.,  fe cluster(fips_state_county_code)
outreg2 using sitable3, word label dec(3)  drop( years1-years26) append noaster
xtreg lngrants compstate compstatexreelectionelyear compstatexsuccessorelyear corestate1  president majority any_chair  appropsorways   lnnewpop  pctpoverty pcincomecd years1-years26 if cdmatch100!=.,  fe cluster(fips_state_county_code)
outreg2 using sitable3, word label dec(3)  drop( years1-years26)  append noaster
xtreg lngrants compstate compstatexreelectionelyear compstatexsuccessorelyear corestate1  president majority any_chair  appropsorways corecounty1 corecounty1xcompstate corecounty1xcorestate lnnewpop  pctpoverty pcincomecd years1-years26 if cdmatch100!=.,  fe cluster(fips_state_county_code)
outreg2 using sitable3, word label dec(3)  drop( years1-years26) append noaster sortvar(compstate corestate1 compstatexelyear corestate1xelyear compstatexreelectionelyear  compstatexsuccessorelyear corecounty1 corecounty1xcompstate corecounty1xcorestate  president majority any_chair  appropsorways  lnnewpop  pctpoverty pcincomecd) 



