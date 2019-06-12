* Replication data for Benjamin O. Fordham, "Power or Plenty?
* Economic Interests, Security Concerns, and American Intervention,"
* International Studies Quarterly.

* Five datasets are used in the article and included with this
* do file:
* 1. 'cwdata.dta' contains data on civil war intervention
* 2. 'icbdata.dta' contains data on crisis intervention
* 3. 'aformation.dta' contains data on alliance formation
* 4. 'adissolution.dta' contains data on alliance dissolution
* 5. 'atrade.dta' contains data on trade and alliances

* Using 'cwdata.dta', the following will replicate the results in the
* first two columns of Table 1 and the predicted probabilities discussed
* in the text.

* Model of civil war intervention for Table 1
probit usinv rivalinv atopdo lnexports1
probit usinv rivalinv lnexports1 atopdo powerratio lndistance lnpop polity2 coldwar gnpgrow inflation

* Predicted probabilities
* Average state with no alliance or rival intervention
prvalue, x(rivalinv=0 atopdo=0) rest(mean) ept
prvalue, x(rivalinv=0 atopdo=1) rest(mean) ept
prvalue, x(rivalinv=1 atopdo=0) rest(mean) ept

* Comparison of Morocco and El Salvador
* Morocco:
prvalue, x(rivalinv=0 lnexports1=6.27 atopdo=0 powerratio=0.017 lndistance=15.16 lnpop=9.76 coldwar=1 gnpgrow=-0.4 inflation=9.47) ept
prvalue, x(rivalinv=1 lnexports1=6.27 atopdo=0 powerratio=0.017 lndistance=15.16 lnpop=9.76 coldwar=1 gnpgrow=-0.4 inflation=9.47) ept
prvalue, x(rivalinv=0 lnexports1=6.27 atopdo=1 powerratio=0.017 lndistance=15.16 lnpop=9.76 coldwar=1 gnpgrow=-0.4 inflation=9.47) ept
prvalue, x(rivalinv=1 lnexports1=6.27 atopdo=1 powerratio=0.017 lndistance=15.16 lnpop=9.76 coldwar=1 gnpgrow=-0.4 inflation=9.47) ept
* El Salvador:
prvalue, x(rivalinv=0 lnexports1=6.69 atopdo=0 powerratio=.0034 lndistance=14.46 lnpop=8.40 coldwar=1 gnpgrow=3.5 inflation=8.29) ept
prvalue, x(rivalinv=1 lnexports1=6.69 atopdo=0 powerratio=.0034 lndistance=14.46 lnpop=8.40 coldwar=1 gnpgrow=3.5 inflation=8.29) ept
prvalue, x(rivalinv=0 lnexports1=6.69 atopdo=1 powerratio=.0034 lndistance=14.46 lnpop=8.40 coldwar=1 gnpgrow=3.5 inflation=8.29) ept
prvalue, x(rivalinv=1 lnexports1=6.69 atopdo=1 powerratio=.0034 lndistance=14.46 lnpop=8.40 coldwar=1 gnpgrow=3.5 inflation=8.29) ept

* Using 'icbdata.dta', the following will replicate the results in the
* third and fourth columns of Table 1, and teh predicted probabilities 
* discussed in the text.
probit usinv3 rivalinv3 atopdo_count lnexports1, nolog
probit usinv3 rivalinv3 atopdo_count lnexports1 number powerratio lndistance lntpop polity2 natomember_count coldwar gnpgrow inflation, nolog
prvalue, x(rivalinv3=0 atopdo_count=0) ept
prvalue, x(rivalinv3=1 atopdo_count=0) ept
prvalue, x(rivalinv3=0 atopdo_count=1) ept
prvalue, x(rivalinv3=0 atopdo_count=2) ept
prvalue, x(rivalinv3=1 atopdo_count=1) ept
prvalue, x(rivalinv3=1 atopdo_count=2) ept
prvalue, x(rivalinv3=0 atopdo_count=0 lnexports1=22) ept
prvalue, x(rivalinv3=0 atopdo_count=0 lnexports1=3) ept
prvalue, x(rivalinv3=0 atopdo_count=1 lnexports1=3) ept
prvalue, x(rivalinv3=0 atopdo_count=0 lnexports1=7) ept
prvalue, x(rivalinv3=0 atopdo_count=1 lnexports1=7) ept

* Shaba I (ICB 277), historical and without rival intervention
prvalue, x(rivalinv3=1 atopdo_count=0 lnexports1=9.99 powerratio=0.0243 lndistance=8.79 lntpop=18.86 polity2=-7 natomember_count=0 coldwar=1 gnpgrow=4.7 inflation=6.36) ept
prvalue, x(rivalinv3=0 atopdo_count=0 lnexports1=9.99 powerratio=0.0243 lndistance=8.79 lntpop=18.86 polity2=-7 natomember_count=0 coldwar=1 gnpgrow=4.7 inflation=6.36) ept

* Tanzanian invasion of Uganda with and without rival intervention
prvalue, x(rivalinv3=0 atopdo_count=0 lnexports1=14.91 powerratio=0.0317 lndistance=8.49 lntpop=27.10 polity2=-7 natomember_count=0 coldwar=1 gnpgrow=5.5 inflation=8.29) ept
prvalue, x(rivalinv3=1 atopdo_count=0 lnexports1=14.91 powerratio=0.0317 lndistance=8.49 lntpop=27.10 polity2=-7 natomember_count=0 coldwar=1 gnpgrow=5.5 inflation=8.29) ept

* Tanzania-Uganda case with closer-to-average powerratio and exports 
prvalue, x(rivalinv3=0 atopdo_count=0 lnexports1=14.91 powerratio=0.21 lndistance=8.49 lntpop=27.10 polity2=1 natomember_count=0 coldwar=1) ept

* Using 'aformation.dta', the following will replicate the results
* concerning alliance formation in Table 2 and the predicted probabilities
* discussed in the text.  Predicted probabilities for Morocco with the trade
* values of El Salvador, and vice versa, were generated using artificial
* cases containing these values with ccodes 9201 (simulated El Salvador)
* 60001 (simulated Morocco).  These cases were excluded from estimation,
* but included in the generation of predicted probabilities.  Splines,
* previous alliance onsets, and the time since the previous onset were
* generated using Richard Tucker's btscs add-on to Stata.

* Effect of exports on alliance formation
probit atopdo lnexports1_doc noallyrs _prefail _spline1 _spline2 _spline3 if ccode<1000, nolog cluster(ccode)
probit atopdo lnexports1_doc lndistance lntotmids10_1 lntotmids10_2 lndyadmid10 lncap_1 lncap_2 polity22 coldwar noallyrs _prefail _spline1 _spline2 _spline3 if ccode<1000, nolog cluster(ccode)

* Simulated values for El Salvador with Morrocan trade levels
predict pr_alliance, asif

prvalue, x(lnexports1_doc=0) brief
prvalue, x(lnexports1_doc=1.86) brief
prvalue, x(lnexports1_doc=4.20) brief
prvalue, x(lnexports1_doc=6.54) brief

*Effects of other variables for comparison
prvalue, x(lntotmids10_2=1.19) brief 
prvalue, x(lntotmids10_2=2.15) brief 
prvalue, x(lncap_1=-1.72) brief 
prvalue, x(lncap_1=-1.44) brief 
prvalue, x(lndyadmid10=0.15) brief 
prvalue, x(lndyadmid10=0.58) brief 
prvalue, x(lncap_2=-6.30) brief 
prvalue, x(lncap_2=-8.16) brief 

* Using 'adissolution.dta', the following will replicate the alliance
* dissolution results from Table 2 and the predicted probabilities
* discussed in the text.
probit atopend lnexports1_doc noallyrs _prefail _spline1 _spline2 _spline3, nolog robust
probit atopend lnexports1_doc lndistance lntotmids10_1 lntotmids10_2 lndyadmid10 lncap_1 lncap_2 polity22 coldwar noallyrs _prefail _spline1 _spline2 _spline3, nolog robust
prvalue, x(lnexports1_doc=5.19) brief
prvalue, x(lnexports1_doc=6.95) brief
prvalue, x(lnexports1_doc=8.71) brief

* Using 'atrade.dta', the following will replicate the results in
* Table 3.
tsset dyadid year
xtpcse difflnexp12 difflnexp12lag difflngdp1 difflngdp2 difflnpop1 difflnpop2 diffatopdo, pairwise
xtpcse difflnexp12 difflnexp12lag difflngdp1 difflngdp2 difflnpop1 difflnpop2 atopdo, pairwise
xtpcse difflnexp12 difflnexp12lag difflngdp1 difflngdp2 difflnpop1 difflnpop2 recentalliance, pairwise

