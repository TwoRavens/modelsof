
set matsize 8000
set memory 500m
set maxvar 10000

use RESTAT_data5years_TABLE_1.dta

*TABLE 1

*FIVE_YEARS: column1 and 2

iis number
tis period5years
tsset number period5years

* Panel A
xi: regress  PRIOcwt12 lnrgdpch lpop i.period5years, cluster(number)
xi: regress  PRIOcwt12 lnrgdpch lpop i.code i.period5years, cluster(number)

* Panel B
xi: regress   waronset2prio07 lnrgdpch lpop i.period5years, cluster(number)
xi: regress   waronset2prio07 lnrgdpch lpop i.code i.period5years, cluster(number)

*Panel C
xi: regress  PRIOcwt2 lnrgdpch lpop i.period5years, cluster(number)
xi: regress  PRIOcwt2 lnrgdpch lpop i.code i.period5years, cluster(number)

clear
use RESTAT_data10years_TABLE_1.dta


*TEN YEARs: Column 3 and 4

iis number
tis period10years
tsset number period10years


***Panel A
xi: regress  PRIOcwt12 lnrgdpch lpop i.period10years, cluster(number)
xi: regress  PRIOcwt12 lnrgdpch lpop i.code i.period10years, cluster(number)

*Panel B
xi: regress   waronset2prio07  lnrgdpch lpop i.period10years, cluster(number)
xi: regress   waronset2prio07  lnrgdpch lpop i.code i.period10years, cluster(number)

***Panel C
xi: regress  PRIOcwt2 lnrgdpch lpop i.period10years, cluster(number)
xi: regress  PRIOcwt2 lnrgdpch lpop i.code i.period10years, cluster(number)

clear
use RESTAT_data20years_TABLE_1.dta


*TWENTY YEARS: column 5 and 6

iis number
tis period20years
tsset number period20years


*Panel A
xi: regress  PRIOcwt12 lnrgdpch lpop i.period20years, cluster(number)
xi: regress  PRIOcwt12 lnrgdpch lpop i.code i.period20years, cluster(number)

*Panel B
xi: regress   waronset2prio07 lnrgdpch lpop  i.period20years, cluster(number)
xi: regress   waronset2prio07 lnrgdpch lpop i.code i.period20years, cluster(number)

*Panel C
xi: regress  PRIOcwt2 lnrgdpch lpop i.period20years, cluster(number)
xi: regress  PRIOcwt2 lnrgdpch lpop i.code i.period20years, cluster(number)

clear
use RESTAT_dataANNUALyears_TABLE_1.dta


*ANNUAL: column 7 and 8
iis number
tis year
tsset number year


*Panel A
xi: regress  PRIOcwt12 lnrgdpchl lnrgdpchl2 lnrgdpchl3  lnrgdpchl4 lnrgdpchl5   lpopl lpopl2  lpopl3 lpopl4 lpopl5  i.year if year>1959 & year<2000, cluster(number)
test lnrgdpchl lnrgdpchl2 lnrgdpchl3  lnrgdpchl4 lnrgdpchl5  
test lpopl lpopl2  lpopl3 lpopl4 lpopl5 
xi: regress  PRIOcwt12 lnrgdpchl lnrgdpchl2 lnrgdpchl3  lnrgdpchl4 lnrgdpchl5   lpopl lpopl2  lpopl3 lpopl4 lpopl5  i.code i.year if year>1959 & year<2000, cluster(number)
test lnrgdpchl lnrgdpchl2 lnrgdpchl3  lnrgdpchl4 lnrgdpchl5  
test lpopl lpopl2  lpopl3 lpopl4 lpopl5 

*Panel B
xi: regress waronset2prio07 lnrgdpchl lnrgdpchl2 lnrgdpchl3  lnrgdpchl4 lnrgdpchl5   lpopl lpopl2  lpopl3 lpopl4 lpopl5 i.year if year>1959 & year<2000, robust  cluster(number)
test lnrgdpchl lnrgdpchl2 lnrgdpchl3  lnrgdpchl4 lnrgdpchl5 
test  lpopl lpopl2  lpopl3 lpopl4 lpopl5 
xi: regress waronset2prio07 lnrgdpchl lnrgdpchl2 lnrgdpchl3  lnrgdpchl4 lnrgdpchl5   lpopl lpopl2  lpopl3 lpopl4 lpopl5 i.code i.year if year>1959 & year<2000, robust  cluster(number)
test lnrgdpchl lnrgdpchl2 lnrgdpchl3  lnrgdpchl4 lnrgdpchl5 
test  lpopl lpopl2  lpopl3 lpopl4 lpopl5 

*Panel C
xi: regress  PRIOcwt2 lnrgdpchl lnrgdpchl2 lnrgdpchl3  lnrgdpchl4 lnrgdpchl5   lpopl lpopl2  lpopl3 lpopl4 lpopl5  i.year if year>1959 & year<2000, cluster(number)
test lnrgdpchl lnrgdpchl2 lnrgdpchl3  lnrgdpchl4 lnrgdpchl5 
test  lpopl lpopl2  lpopl3 lpopl4 lpopl5 
xi: regress  PRIOcwt2 lnrgdpchl lnrgdpchl2 lnrgdpchl3  lnrgdpchl4 lnrgdpchl5   lpopl lpopl2  lpopl3 lpopl4 lpopl5 i.code i.year if year>1959 & year<2000, cluster(number)
test lnrgdpchl lnrgdpchl2 lnrgdpchl3  lnrgdpchl4 lnrgdpchl5  
test lpopl lpopl2  lpopl3 lpopl4 lpopl5 

clear
use RESTAT_dataCROSSECTION_TABLE_2_3.dta 

**TABLE 2 & 3 : CROSSECTION

*TABLE 2

**Panel A
regress PRIOcwt126099  lngdp60 lnpop60 ,  robust
regress PRIOcwt126099  lngdp60 lnpop60  Oil ,  robust
regress PRIOcwt126099  lngdp60 lnpop60  Oil  mount ncontig ,  robust
regress PRIOcwt126099  lngdp60 lnpop60  Oil  mount ncontig ETHPOL democ1965,  robust
probit PRIOcwt126099  lngdp60 lnpop60 ,  robust
probit PRIOcwt126099  lngdp60 lnpop60  Oil ,  robust
probit PRIOcwt126099  lngdp60 lnpop60  Oil  mount ncontig  ,  robust
probit PRIOcwt126099  lngdp60 lnpop60  Oil  mount ncontig ETHPOL democ1965,  robust

*Panel B
regress PRIOcw1000all6099  lngdp60 lnpop60  ,  robust
regress PRIOcw1000all6099  lngdp60 lnpop60  Oil  ,  robust
regress PRIOcw1000all6099  lngdp60 lnpop60  Oil  mount ncontig,  robust
regress PRIOcw1000all6099  lngdp60 lnpop60  Oil  mount ncontig ETHPOL democ1965,  robust
probit PRIOcw1000all6099  lngdp60 lnpop60  ,  robust
probit PRIOcw1000all6099  lngdp60 lnpop60  Oil ,  robust
probit PRIOcw1000all6099  lngdp60 lnpop60  Oil  mount ncontig ,  robust
probit PRIOcw1000all6099  lngdp60 lnpop60  Oil  mount ncontig ETHPOL democ1965,  robust

             ***excolonies (gdp in italics, tables 1)
*Panel A
regress PRIOcwt126099  lngdp60 lnpop60   if excolony==1,  robust
regress PRIOcwt126099  lngdp60 lnpop60  Oil  if excolony==1,  robust
regress PRIOcwt126099  lngdp60 lnpop60  Oil  mount ncontig    if excolony==1,  robust
regress PRIOcwt126099  lngdp60 lnpop60  Oil  mount ncontig ETHPOL democ1965    if excolony==1,  robust
probit PRIOcwt126099  lngdp60 lnpop60   if excolony==1,  robust
probit PRIOcwt126099  lngdp60 lnpop60  Oil  if excolony==1,  robust
probit PRIOcwt126099  lngdp60 lnpop60  Oil  mount ncontig    if excolony==1,  robust
probit PRIOcwt126099  lngdp60 lnpop60  Oil  mount ncontig ETHPOL democ1965    if excolony==1,  robust

*Panel B
regress PRIOcw1000all6099  lngdp60 lnpop60   if excolony==1,  robust
regress PRIOcw1000all6099  lngdp60 lnpop60  Oil  if excolony==1,  robust
regress PRIOcw1000all6099  lngdp60 lnpop60  Oil  mount ncontig    if excolony==1,  robust
regress PRIOcw1000all6099  lngdp60 lnpop60  Oil  mount ncontig ETHPOL democ1965    if excolony==1,  robust
probit PRIOcw1000all6099  lngdp60 lnpop60   if excolony==1,  robust
probit PRIOcw1000all6099  lngdp60 lnpop60  Oil  if excolony==1,  robust
probit PRIOcw1000all6099  lngdp60 lnpop60  Oil  mount ncontig    if excolony==1,  robust
probit PRIOcw1000all6099  lngdp60 lnpop60  Oil  mount ncontig ETHPOL democ1965    if excolony==1,  robust


*TABLE 3

*Panel A
regress  PRIOcwt126099   lngdp60 lnpop60 if excolony==1, robust 
regress  PRIOcwt126099   lngdp60 lnpop60 logem4 if excolony==1, robust 
regress  PRIOcwt126099   lngdp60 lnpop60  popdens1500 if excolony==1, robust
regress  PRIOcwt126099   lngdp60 lnpop60 euro1900 if excolony==1, robust
regress  PRIOcwt126099   lngdp60 lnpop60  logem4  indtime f_brit f_french f_spain f_pothco f_dutch f_belg f_italy f_germ  if excolony==1, robust
regress  PRIOcwt126099   lngdp60 lnpop60  euro1900  indtime f_brit f_french f_spain f_pothco f_dutch f_belg f_italy f_germ  if excolony==1, robust
probit  PRIOcwt126099   lngdp60 lnpop60 if excolony==1, robust 
probit  PRIOcwt126099   lngdp60 lnpop60 logem4 if excolony==1, robust 
probit  PRIOcwt126099   lngdp60 lnpop60  popdens1500 if excolony==1, robust
probit  PRIOcwt126099   lngdp60 lnpop60 euro1900 if excolony==1, robust
probit  PRIOcwt126099   lngdp60 lnpop60  logem4  indtime f_brit f_french f_spain f_pothco f_dutch f_belg f_italy f_germ  if excolony==1, robust
probit  PRIOcwt126099   lngdp60 lnpop60  euro1900  indtime f_brit f_french f_spain f_pothco f_dutch f_belg f_italy f_germ  if excolony==1, robust


*Panel B
regress  PRIOcw1000all6099   lngdp60 lnpop60 if excolony==1, robust 
regress  PRIOcw1000all6099   lngdp60 lnpop60 logem4 if excolony==1, robust 
regress  PRIOcw1000all6099   lngdp60 lnpop60  popdens1500 if excolony==1, robust
regress  PRIOcw1000all6099   lngdp60 lnpop60 euro1900 if excolony==1, robust
regress  PRIOcw1000all6099   lngdp60 lnpop60  popdens1500  indtime f_brit f_french f_spain f_pothco f_dutch f_belg f_italy f_germ  if excolony==1, robust
regress  PRIOcw1000all6099   lngdp60 lnpop60  euro1900  indtime f_brit f_french f_spain f_pothco f_dutch f_belg f_italy f_germ  if excolony==1, robust
probit  PRIOcw1000all6099   lngdp60 lnpop60 if excolony==1, robust 
probit  PRIOcw1000all6099   lngdp60 lnpop60 logem4 if excolony==1, robust 
probit  PRIOcw1000all6099   lngdp60 lnpop60  popdens1500 if excolony==1, robust
probit  PRIOcw1000all6099   lngdp60 lnpop60 euro1900 if excolony==1, robust
probit  PRIOcw1000all6099   lngdp60 lnpop60  popdens1500  indtime f_brit f_french f_spain f_pothco f_dutch f_belg f_italy f_germ  if excolony==1, robust
probit  PRIOcw1000all6099   lngdp60 lnpop60  euro1900  indtime f_brit f_french f_spain f_pothco f_dutch f_belg f_italy f_germ  if excolony==1, robust

clear

*TABLE 4

use RESTAT_dataFROM1825_25yearsperiod_TABLE_4.dta

*25 years period: panel A and Panel B

*Panel A

*column 1 and 2: 1825 to 2000
xi: regress cowintra  lngdpcap lpop i.period25years, cluster(number)
xi: regress  cowintra  lngdpcap lpop i.period25years i.number , cluster(number)

*column 3 and 4: 1850 to 2000
xi: regress cowintra  lngdpcap lpop i.period25years if period25years>1, cluster(number)
xi: regress  cowintra  lngdpcap lpop i.period25years i.number if period25years>1, cluster(number)

*column 5 and 6: from 1875 to 2000
xi: regress cowintra  lngdpcap lpop i.period25years if period25years>2, cluster(number)
xi: regress  cowintra  lngdpcap lpop i.period25years i.number if period25years>2, cluster(number)

*column 7 and 8: from 1900 to 2000
xi: regress cowintra  lngdpcap lpop i.period25years if period25years>3, cluster(number)
xi: regress  cowintra  lngdpcap lpop i.period25years i.number if period25years>3, cluster(number)


*Panel B

*column1 and 2
xi: regress  cowintraextratype3  lngdpcap lpop i.period25years, cluster(number)
xi: regress   cowintraextratype3 lngdpcap lpop i.period25years i.number , cluster(number)

*column3 and 4
xi: regress  cowintraextratype3  lngdpcap lpop i.period25years if period25years>1, cluster(number)
xi: regress   cowintraextratype3 lngdpcap lpop i.period25years i.number if period25years>1, cluster(number)

*column 5 nad 6
xi: regress  cowintraextratype3  lngdpcap lpop i.period25years if period25years>2, cluster(number)
xi: regress   cowintraextratype3 lngdpcap lpop i.period25years i.number if period25years>2, cluster(number)

*column 7 and 8
xi: regress  cowintraextratype3  lngdpcap lpop i.period25years if period25years>3, cluster(number)
xi: regress   cowintraextratype3 lngdpcap lpop i.period25years i.number if period25years>3, cluster(number)

clear
use RESTAT_dataFROM1850_50yearsperiod_TABLE_4.dta

*50 years period: Panel C and Panel D

*Panel C

*column 3 and 4: from 1850 to 2000
xi: regress cowintra lngdpcap lpop i.period50years, cluster(number)
xi: regress cowintra lngdpcap lpop i.period50years i.number, cluster(number)

*column 7 nad 8: from 1900 to 2000
xi: regress cowintra lngdpcap lpop i.period50years if  period50years>1, cluster(number)
xi: regress cowintra lngdpcap lpop i.period50years i.number if  period50years>1, cluster(number)

*Panel D

*column 3 and 4
xi: regress cowintraextratype3 lngdpcap lpop i.period50years, cluster(number)
xi: regress cowintraextratype3 lngdpcap lpop i.period50years i.number, cluster(number)

*column 7 and 8
xi: regress cowintraextratype3 lngdpcap lpop i.period50years if  period50years>1, cluster(number)
xi: regress cowintraextratype3 lngdpcap lpop i.period50years i.number if  period50years>1, cluster(number)

clear
