/// Replication of Tables and Figures from "The Limitations of the Backfire Effect"
/// Author: Kathryn Haglin, Texas A&M University
/// Last Updated: November 1, 2016


/// Table 1: Characteristics of Respondents in Nyhan and Reifler (2015) and Replication Sample by %
/// These frequencies apply to the variables in columns 2 and 4 of Table 1
/// Condition 2 corresponds to the correction condition 
tab age condition, col
tab gender condition, col
tab education condition, col
tab race condition, col
tab vaxxconcern condition, col


/// Figure 1: Distribution of Vaccine Misperception Measure in the Replication Sample
gen vaxgivesflu2=vaxgivesflu
graph bar (percent) vaxgivesflu, over(vaxgivesflu2, relabel(4 `" "Very" "accurate" "' 3 `" "Somewhat" "accurate" "' 2 `" "Somewhat" "inaccurate" "' 1 `" "Very" "inaccurate" "')) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) scheme(s2mono) yscale(r(0 .5)) ytitle("Distribution (%)") title("Vaccine can give you the flu",size(*1.1)) 

/// Figure 2: Distribution of Vaccine Safety Measure in the Replication Sample
gen vaxunsafe2=vaxunsafe
graph bar (percent) vaxunsafe, over(vaxunsafe2, relabel(1 `" "Very" "safe" "' 2 `" "Somewhat" "safe" "' 3`" "Not very" "safe" "' 4 `" "Not at all" "safe" "')) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) scheme(s2mono) yscale(r(0 .3)) ytitle("Distribution (%)") title("Perceived safety of flu vaccine",size(*1.1)) 

/// Figure 3: Distribution of Intent to Vaccinate Measure in the Replication Sample
gen getvax2=getvax
graph bar (percent) getvax, over(getvax2, relabel(6 `" "Very" "likely" "' 5 `" "Somewhat" "likely" "' 4 `" "Slightly" "likely" "' 3 `" "Slightly" "unlikely" "' 2 `" "Somewhat" "unlikely" "' 1 `" "Very" "unlikely" "')) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) scheme(s2mono) yscale(r(0 .3)) ytitle("Distribution (%)") title("Likelihood of vaccination",size(*1.1)) 



/// Table 2: Replication of Correction Treatment on "Vaccine Can Give Flu"
/// Coefficients here are reported in columns two, four, and six of Table 2
oprobit vaxgivesflu correction 
oprobit vaxgivesflu correction if lowconcern==1
oprobit vaxgivesflu correction if highconcern==1

/// Table 3: Replication of Correction Treatment on Vaccine Safety
/// Coefficients here are reported in columns two, four, and six of Table 3
oprobit vaxunsafe correction
oprobit vaxunsafe correction if lowconcern==1
oprobit vaxunsafe correction if highconcern==1

/// Table 4: Replication of Correction Treatment on Intent to Vaccinate
/// Coefficients here are reported in columns two, four, and six of Table 4
oprobit getvax correction 
oprobit getvax correction if lowconcern==1
oprobit getvax correction if highconcern==1

/// Supplementary Materials

/// Table 1: Distribution of Party Identification in the Replication Sample
tab partyid 

/// Table 2: Distribution of Ideology in the Replication Sample
tab ideology

/// Table 3: Responses to Social and Economic Views Questions
tab inequality 
tab singlepayer



