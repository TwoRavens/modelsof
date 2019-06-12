*TABLE 4: Summary Statistics #2*
xtreg lfdi chinese1 lgdp ldistance contiguity dtt pta wto legal polity2 lfdi1, cluster(ccode)
sum lfdi chinese chinese1 chinese2 chinese3 chinese4 chinese5  ldistance contiguity lgdp legal wto dtt pta polity2 if e(sample) == 1

*TABLE 5: Chinese Language and Chinese FDI*
xi: xtreg lfdi chinese lgdp ldistance contiguity dtt pta wto legal polity2 lfdi1, cluster(ccode)
xi: xtreg lfdi chinese1 lgdp ldistance contiguity dtt pta wto legal polity2 lfdi1, cluster(ccode)
xi: xtreg lfdi chinese2 lgdp ldistance contiguity dtt pta wto legal polity2 lfdi1, cluster(ccode)
xi: xtreg lfdi chinese3 lgdp ldistance contiguity dtt pta wto legal polity2 lfdi1, cluster(ccode)
xi: xtreg lfdi chinese4 lgdp ldistance contiguity dtt pta wto legal polity2 lfdi1, cluster(ccode)
xi: xtreg lfdi chinese5 lgdp ldistance contiguity dtt pta wto legal polity2 lfdi1, cluster(ccode)

*TABLE 6: Assessing Alternative Explanations*
xi: xtreg lfdi chinese chinese5 ldistance contiguity lgdp legal wto dtt pta polity2 lfdi1, cluster(ccode)
xi: xtivreg lfdi ldistance contiguity lgdp legal wto dtt pta polity2 lfdi1 (chinese1 = chinese2), fe
xi: xtreg lfdi lcount1 lgdp ldistance contiguity dtt pta wto legal polity2 lfdi1, cluster(ccode)
xi: xtreg lfdi chinese_match1 lgdp ldistance contiguity dtt pta wto legal polity2 lfdi1, cluster(ccode)
