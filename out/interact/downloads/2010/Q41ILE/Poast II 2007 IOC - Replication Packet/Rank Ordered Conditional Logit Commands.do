clear all
version 8.0
set more off
set mem 100m

cd "C:\Users\Paul\Desktop\Poast II 2007 IOC - Replication Packet\"

use "IOC Bid Data 1955 - 2005.dta", clear


* All 1959 - 2003
rologit vote_rank cius euro grow_one grow_five grow_ten bribe cont pop city_pop real_gdp na if year>=1955, group (caseid)
rologit vote_rank euro grow_one grow_five grow_ten bribe cont pop city_pop real_gdp na if year>=1955, group (caseid)

* All 1959 - 1981
rologit vote_rank cius euro grow_one grow_five grow_ten bribe cont pop city_pop real_gdp na if year>=1955 & year<=1981, group (caseid)
rologit vote_rank euro grow_one grow_five grow_ten bribe cont pop city_pop real_gdp na if year>=1955 & year<=1981, group (caseid)

* All 1986 - 2003
rologit vote_rank cius euro grow_one grow_five grow_ten bribe cont pop city_pop real_gdp na if year<=1981, group (caseid)
rologit vote_rank euro grow_one grow_five grow_ten bribe cont pop city_pop real_gdp na if year<=1981, group (caseid)



* Summer 1959 - 2003
rologit vote_rank cius euro grow_one grow_five grow_ten bribe cont pop city_pop real_gdp na if year>=1955 & summer==1, group (caseid)
rologit vote_rank euro grow_one grow_five grow_ten bribe cont pop city_pop real_gdp na if year>=1955 & summer==1, group (caseid)

* Summer 1959 - 1981
rologit vote_rank cius euro grow_one grow_five grow_ten bribe cont pop city_pop real_gdp na if year>=1955 & year<=1981 & summer==1, group (caseid)
rologit vote_rank euro grow_one grow_five grow_ten bribe cont pop city_pop real_gdp na if year>=1955 & year<=1981 & summer==1, group (caseid)

* Summer 1986 - 2003
rologit vote_rank cius euro grow_one grow_five grow_ten bribe cont pop city_pop real_gdp na if year<=1981 & summer==1, group (caseid)
rologit vote_rank euro grow_one grow_five grow_ten bribe cont pop city_pop real_gdp na if year<=1981 & summer==1, group (caseid)






* Winter 1959 - 2003
rologit vote_rank cius euro grow_one grow_five grow_ten bribe cont pop city_pop real_gdp na if year>=1955 & winter==1, group (caseid)
rologit vote_rank euro grow_one grow_five grow_ten bribe cont pop city_pop real_gdp na if year>=1955 & winter==1, group (caseid)

* Winter 1959 - 1981
rologit vote_rank cius euro grow_one grow_five grow_ten bribe cont pop city_pop real_gdp na if year>=1955 & year<=1981 & winter==1, group (caseid)
rologit vote_rank euro grow_one grow_five grow_ten bribe cont pop city_pop real_gdp na if year>=1955 & year<=1981 & winter==1, group (caseid)

* Winter 1986 - 2003
rologit vote_rank cius euro grow_one grow_five grow_ten bribe cont pop city_pop real_gdp na if year<=1981 & winter==1, group (caseid)
rologit vote_rank euro grow_one grow_five grow_ten bribe cont pop city_pop real_gdp na if year<=1981 & winter==1, group (caseid)
