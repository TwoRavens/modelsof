* Table 1 *
areg dinc2party pctdgrants  years1-years7 if year !=1984 & pctdgrants < 2.41, a(fips_state_county_code)  cluster(fips_state_county_code)
areg dinc2party pctdgrants dpcincomecdv2   years1-years7 if year !=1984 & pctdgrants < 2.41, a(fips_state_county_code)  cluster(fips_state_county_code)
areg dinc2party pctdgrants dpcincomecdv2   inctvdiff incappdiff newdincpphousevote  cas2004 cas2008 pctdpop years1-years7 if year !=1984 & pctdgrants < 2.41, a(fips_state_county_code)  cluster(fips_state_county_code)

* Table 2 *
areg dinc2party pctdgrantsxnotcompstate  pctdgrantsxcompstate dpcincomecdv2   inctvdiff incappdiff newdincpphousevote  cas2004 cas2008 pctdpop   compstate  years1-years7 if year !=1984 & pctdgrants < 2.41, a(fips_state_county_code) cluster(fips_state_county_code)

* Table 3 *
areg dinc2party  pctdgrantsxtc0 pctdgrantsxtc1 pctdgrantsxtc2 pctdgrantsxtc3 dpcincomecdv2   inctvdiff incappdiff newdincpphousevote  cas2004 cas2008 pctdpop  totalconginc1 totalconginc2 totalconginc3  years1-years7 if year !=1984 & pctdgrants < 2.41, a(fips_state_county_code)  cluster(fips_state_county_code)

* Table 4 *
areg dinc2party pctdgrants dpcincomecdv2   inctvdiff incappdiff newdincpphousevote  cas2004 cas2008 pctdpop  years1-years7 if year !=1984 & pctdgrants < 2.41 & gopthirds == 1, a(fips_state_county_code)  cluster(fips_state_county_code)
areg dinc2party pctdgrants dpcincomecdv2   inctvdiff incappdiff newdincpphousevote  cas2004 cas2008 pctdpop  years1-years7 if year !=1984 & pctdgrants < 2.41 & gopthirds == 2, a(fips_state_county_code)  cluster(fips_state_county_code)
areg dinc2party pctdgrants dpcincomecdv2   inctvdiff incappdiff newdincpphousevote  cas2004 cas2008 pctdpop years1-years7 if year !=1984 & pctdgrants < 2.41 & gopthirds == 3, a(fips_state_county_code)  cluster(fips_state_county_code)

* Alternatively, estimating the models using xtreg yields identical coefficients, but smaller SEs *
xtset fips_state_county_code year

* Table 1 *
xtreg dinc2party pctdgrants  years1-years7 if year !=1984 & pctdgrants < 2.41, cluster(fips_state_county_code) fe
xtreg dinc2party pctdgrants dpcincomecdv2   years1-years7 if year !=1984 & pctdgrants < 2.41,  cluster(fips_state_county_code) fe
xtreg dinc2party pctdgrants dpcincomecdv2   inctvdiff incappdiff newdincpphousevote  cas2004 cas2008 pctdpop years1-years7 if year !=1984 & pctdgrants < 2.41, cluster(fips_state_county_code) fe

* Table 2 *
xtreg dinc2party pctdgrantsxnotcompstate  pctdgrantsxcompstate dpcincomecdv2   inctvdiff incappdiff newdincpphousevote  cas2004 cas2008 pctdpop   compstate  years1-years7 if year !=1984 & pctdgrants < 2.41, cluster(fips_state_county_code) fe

* Table 3 *
xtreg dinc2party  pctdgrantsxtc0 pctdgrantsxtc1 pctdgrantsxtc2 pctdgrantsxtc3 dpcincomecdv2   inctvdiff incappdiff newdincpphousevote  cas2004 cas2008 pctdpop  totalconginc1 totalconginc2 totalconginc3  years1-years7 if year !=1984 & pctdgrants < 2.41, cluster(fips_state_county_code) fe

* Table 4 *
xtreg dinc2party pctdgrants dpcincomecdv2   inctvdiff incappdiff newdincpphousevote  cas2004 cas2008 pctdpop  years1-years7 if year !=1984 & pctdgrants < 2.41 & gopthirds == 1,  cluster(fips_state_county_code) fe
xtreg dinc2party pctdgrants dpcincomecdv2   inctvdiff incappdiff newdincpphousevote  cas2004 cas2008 pctdpop  years1-years7 if year !=1984 & pctdgrants < 2.41 & gopthirds == 2,  cluster(fips_state_county_code) fe
xtreg dinc2party pctdgrants dpcincomecdv2   inctvdiff incappdiff newdincpphousevote  cas2004 cas2008 pctdpop years1-years7 if year !=1984 & pctdgrants < 2.41 & gopthirds == 3,  cluster(fips_state_county_code) fe
