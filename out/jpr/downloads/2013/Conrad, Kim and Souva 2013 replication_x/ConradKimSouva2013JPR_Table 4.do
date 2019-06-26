
* Table 4, Nordhaus et al replication on autocratic subsample 
ivregress 2sls lmilex pn6 lnrgdp lnfoes lnfriends democ (lmilex1= pn6_1 pn6_2 lnrgdp_1 lnrgdp_2) if year>=1950 &  year<=2000 & demcgx==0, vce(robust)

* Table 4, Model 5
ivregress 2sls lmilex pn6 lnrgdp lnfoes lnfriends parcomp2mod lnage (lmilex1= pn6_1 pn6_2 lnrgdp_1 lnrgdp_2) if year>=1950 & year<=2000 & demcgx==0, vce(robust)

* Table 4, Model 6
ivregress 2sls lmilex pn6 lnrgdp lnfoes lnfriends parcomp2mod lntimesincelastcoup_pt (lmilex1= pn6_1 pn6_2 lnrgdp_1 lnrgdp_2) if year>=1950 & year<=2000 & demcgx==0, vce(robust)

* Table 4, Model 7
ivregress 2sls lmilex pn6 lnrgdp lnfoes lnfriends lparty2 lnage civx milx (lmilex1= pn6_1 pn6_2 lnrgdp_1 lnrgdp_2) if year>=1950 & year<=2000 & demcgx==0, vce(robust)

* Table 4, Model 8
ivregress 2sls lmilex pn6 lnrgdp lnfoes lnfriends lparty2 lntimesincelastcoup_pt civx milx (lmilex1= pn6_1 pn6_2 lnrgdp_1 lnrgdp_2) if year>=1950 & year<=2000 & demcgx==0, vce(robust)


