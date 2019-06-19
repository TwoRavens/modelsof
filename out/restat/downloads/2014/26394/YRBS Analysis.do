




********************
*LPM models everyone
********************
*Miss school for fear of safety
regress SAFE mda18 sex age15 age16 age17 age18 grade10 grade11 grade12 grade_ungraded NativeAm Asian Black Hispanic Other_race state_fe* year_fe* trend [pweight = weight], vce(cluster state_fips)
sum SAFE if mda18 == 0 & sex != . & age15 != . & grade10 != . & Asian != . 

*Had sex within last 3 months
regress RECENT_SEX mda18 sex age15 age16 age17 age18 grade10 grade11 grade12 grade_ungraded NativeAm Asian Black Hispanic Other_race state_fe* year_fe* trend [pweight = weight], vce(cluster state_fips)
sum RECENT_SEX if mda18 == 0 & sex != . & age15 != . & grade10 != . & Asian != . 



******************
*LPM models males
******************
*Miss school for fear of safety
regress SAFE mda18 sex age15 age16 age17 age18 grade10 grade11 grade12 grade_ungraded NativeAm Asian Black Hispanic Other_race state_fe* year_fe* trend [pweight = weight] if sex == 1, vce(cluster state_fips)
sum SAFE if mda18 == 0 & sex == 1 & age15 != . & grade10 != . & Asian != . 

*Had sex within last 3 months
regress RECENT_SEX mda18 sex age15 age16 age17 age18 grade10 grade11 grade12 grade_ungraded NativeAm Asian Black Hispanic Other_race state_fe* year_fe* trend [pweight = weight] if sex == 1, vce(cluster state_fips)
sum RECENT_SEX if mda18 == 0 & sex == 1 & age15 != . & grade10 != . & Asian != . 




********************
*LPM models females
********************
*Miss school for fear of safety
regress SAFE mda18 sex age15 age16 age17 age18 grade10 grade11 grade12 grade_ungraded NativeAm Asian Black Hispanic Other_race state_fe* year_fe* trend [pweight = weight] if sex == 0, vce(cluster state_fips)
sum SAFE if mda18 == 0 & sex == 0 & age15 != . & grade10 != . & Asian != . 

*Had sex within last 3 months
regress RECENT_SEX mda18 sex age15 age16 age17 age18 grade10 grade11 grade12 grade_ungraded NativeAm Asian Black Hispanic Other_race state_fe* year_fe* trend [pweight = weight] if sex == 0, vce(cluster state_fips)
sum RECENT_SEX if mda18 == 0 & sex == 0 & age15 != . & grade10 != . & Asian != . 

*Been pregnant
regress PREGNANCY mda18 sex age15 age16 age17 age18 grade10 grade11 grade12 grade_ungraded NativeAm Asian Black Hispanic Other_race state_fe* year_fe* trend [pweight = weight] if sex == 0, vce(cluster state_fips)
sum PREGNANCY if mda18 == 0 & sex == 0 & age15 != . & grade10 != . & Asian != . 




