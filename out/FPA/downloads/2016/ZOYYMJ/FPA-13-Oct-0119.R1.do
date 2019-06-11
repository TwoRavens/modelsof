xtset CCode Year
*Baseline
xtreg Status l5.GDP l5.MilitaryPerformance l5.Population ColdWar TimeCounter Europe WestAfrica SSAfrica MiddleEast EastAsia SouthAsia NorthAmerica SouthAmerica, robust
*Donor 1
xtreg Status l5.ProvidedAid l5.GDP l5.MilitaryPerformance l5.Population ColdWar TimeCounter Europe WestAfrica SSAfrica MiddleEast EastAsia SouthAsia NorthAmerica SouthAmerica, robust
*Donor 2
xtreg Status l5.ProvidedAid l5.AidGDPRatio l5.GDP l5.MilitaryPerformance l5.Population ColdWar TimeCounter Europe WestAfrica SSAfrica MiddleEast EastAsia SouthAsia NorthAmerica SouthAmerica, robust
*Donor 3
xtreg Status l5.ProvidedAid l5.AidPerformance l5.GDP l5.MilitaryPerformance l5.Population ColdWar TimeCounter Europe WestAfrica SSAfrica MiddleEast EastAsia SouthAsia NorthAmerica SouthAmerica, robust
*Medals
xtreg Status l5.TotalMedalPerformance l5.GDP l5.MilitaryPerformance l5.Population ColdWar TimeCounter Europe WestAfrica SSAfrica MiddleEast EastAsia SouthAsia NorthAmerica SouthAmerica, robust
*Donors & Medals
xtreg Status l5.ProvidedAid l5.TotalMedalPerformance l5.GDP l5.MilitaryPerformance l5.Population ColdWar TimeCounter Europe WestAfrica SSAfrica MiddleEast EastAsia SouthAsia NorthAmerica SouthAmerica, robust

*To find AIC and BIC
*Baseline
xtreg Status l5.GDP l5.MilitaryPerformance l5.Population ColdWar TimeCounter Europe WestAfrica SSAfrica MiddleEast EastAsia SouthAsia NorthAmerica SouthAmerica, mle
estat ic
*Donor 1
xtreg Status l5.ProvidedAid l5.GDP l5.MilitaryPerformance l5.Population ColdWar TimeCounter Europe WestAfrica SSAfrica MiddleEast EastAsia SouthAsia NorthAmerica SouthAmerica, mle
estat ic
*Donor 2
xtreg Status l5.ProvidedAid l5.AidGDPRatio l5.GDP l5.MilitaryPerformance l5.Population ColdWar TimeCounter Europe WestAfrica SSAfrica MiddleEast EastAsia SouthAsia NorthAmerica SouthAmerica, mle
estat ic
*Donor 3
xtreg Status l5.ProvidedAid l5.AidPerformance l5.GDP l5.MilitaryPerformance l5.Population ColdWar TimeCounter Europe WestAfrica SSAfrica MiddleEast EastAsia SouthAsia NorthAmerica SouthAmerica, mle
estat ic
*Medals
xtreg Status l5.TotalMedalPerformance l5.GDP l5.MilitaryPerformance l5.Population ColdWar TimeCounter Europe WestAfrica SSAfrica MiddleEast EastAsia SouthAsia NorthAmerica SouthAmerica, mle
estat ic
*Donors & Medals
xtreg Status l5.ProvidedAid l5.TotalMedalPerformance l5.GDP l5.MilitaryPerformance l5.Population ColdWar TimeCounter Europe WestAfrica SSAfrica MiddleEast EastAsia SouthAsia NorthAmerica SouthAmerica, mle
estat ic
