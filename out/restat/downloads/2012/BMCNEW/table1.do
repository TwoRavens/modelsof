clear
set more off
set mem 900m
set matsize 1000
set scheme s2mono

cd "C:\Users\sfreedm\Documents\My Dropbox\toy-replication-files\pgm"

**Panel A of Table 1 lists number of recalls by year and product category.
**These numbers came from counting recalls listed on the CPSC website by product category: http://www.cpsc.gov/cpscpub/prerel/prerel.html

**Panel B
use ..\data\recall-info, clear


gen year = year(recall_date)

/*Made in China Dummy*/
gen made_in_china = made_in=="China"
ta made_in_china

/*Hazard Type Dummies*/
gen choking = prim_hazard=="Choking"
gen entrapment = prim_hazard=="Entrapment"
gen fire_burn_expl = prim_hazard=="Fire, Burn and Explosion"
gen impact = prim_hazard=="Impact"
gen lacer_punct = prim_hazard == "Laceration and Puncture"
gen lead = prim_hazard=="Lead"
gen magnets = prim_hazard == "Magnets"
gen severing = prim_hazard == "Severing"
gen strang_suff = prim_hazard == "Strangulation and Suffocation"
gen toxic = prim_hazard == "Toxic"

tabstat made_in_china choking  lacer_punct lead magnets, by(year)
