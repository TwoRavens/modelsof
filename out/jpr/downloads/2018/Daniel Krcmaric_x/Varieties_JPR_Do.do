*The following code will replicate the results presented in my Journal of Peace Research article titled "Varieties of Civil War and Mass Killing" (by Daniel Krcmaric)
*Use this do file with the dataset uploaded to the JPR website titled "Varieties_JPR_Data.dta"


**Models from Table 1**
logit start_specific irregular gwf_dem ETHPOL tradeopeni exclusion rgdpch_PWT intensity territorial pop_PWT, cluster(ccode)
logit start_specific irregular SNC gwf_dem ETHPOL tradeopeni exclusion rgdpch_PWT intensity territorial pop_PWT, cluster(ccode)
logit start_specific irregular conventional gwf_dem ETHPOL tradeopeni exclusion rgdpch_PWT intensity territorial pop_PWT, cluster(ccode)


**First Differences from Figure 1**
estsimp logit start_specific irregular gwf_dem ETHPOL tradeopeni exclusion rgdpch_PWT intensity territorial pop_PWT, cluster(ccode)
*irregular 
setx median
simqi, fd(prval(1)) changex(irregular 0 1) level(90)
*gwf_dem
setx median
simqi, fd(prval(1)) changex(gwf_dem 0 1) level(90)
*ETHPOL
setx median
simqi, fd(prval(1)) changex(ETHPOL p25 p75) level(90)
*tradeopeni
setx median
simqi, fd(prval(1)) changex(tradeopeni p25 p75) level(90)
*exclusion
setx median
simqi, fd(prval(1)) changex(exclusion 0 1) level(90)
*rgdpch_PWT
setx median
simqi, fd(prval(1)) changex(rgdpch_PWT p25 p75) level(90)
*intensity
setx median
simqi, fd(prval(1)) changex(intensity 1 2) level(90)
*territorial
setx median
simqi, fd(prval(1)) changex(territorial 0 1) level(90)
*pop_PWT
setx median
simqi, fd(prval(1)) changex(pop_PWT p25 p75) level(90)







