****look up stuff about libya, ccode 620
clear
cd "/Users/emattiacci/Dropbox/Twitter_Paper/Replication Data/Data/"
use "CW_use.dta"

* Libyan oil production in 2010 82170000, placing it in the 90th percentile
sum ross_oil_prod if year == 2010, d
list ross_oil_prod if year == 2010 & ccode == 620
sum ross_oil_prod if year == 2010 & ccode == 620

* Libyan oil exports in 2010 1378, placing it in the 92nd percentile
sum ross_oil_exp if year == 2010, d
list ross_oil_exp if year == 2010 & ccode == 620
sum ross_oil_exp if year == 2010 & ccode == 620

* Libyan excluded groups in 2010 is 3, placing it in the 75thth percentile
sum excl_groups_count if year == 2010, d
list  excl_groups_count if year == 2010 & ccode == 620
sum  excl_groups_count if year == 2010 & ccode == 620

*Ongoing civil wars in neighbors?  Chad, Algeria, Sudan
list  ccode countryname if incidence_flag == 1 & year ==2010 

*other neighborhood effects?
sum polity2 if year == 2010 & ccode >599 & ccode < 700 & ccode != 620 /* Average polity score of libya's neighbors is -2.4, , -2 is 25% percentile */
sum gle_realgdp if year == 2010 & ccode >599 & ccode < 700 & ccode != 620 /* Average gdp of libya's neighbors is 227730 - */

* Libyan gdp in 2010 is 31835, placing it in the 40th percentile
sum gle_realgdp if year == 2010, d
list  gle_realgdp if year == 2010 & ccode == 620
sum  gle_realgdp if year == 2010 & ccode == 620

* Libyan gle_pop in 2010 is 8408, placing it in the 43rd percentile
sum gle_pop if year == 2010, d
list  gle_pop if year == 2010 & ccode == 620
sum  gle_pop if year == 2010 & ccode == 620

* Libyan polity in 2010 is -7, placing it in the 10th percentile
sum polity2 if year == 2010, d
list  polity2 if year == 2010 & ccode == 620
sum  polity2 if year == 2010 & ccode == 620


