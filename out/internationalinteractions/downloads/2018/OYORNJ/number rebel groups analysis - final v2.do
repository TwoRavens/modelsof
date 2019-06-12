**call up first data set
use "basic data set s12.dta"

****TABLE 2 - Model 1
poisson groupsyear numgrps discpop hydroD ALLGEMS mt100 milper100   gdpcapl lgini  terr internationalized democl yearsinconflict cumulativeintensity   , cluster ( conflictid)

***FIGURE 1 - estimated effects
*** Marginsplot showing predicted effect of Discriminated Population % on # of rebel groups
*** To change the names of the axes, look below at ytitle and x title. You can also add a command that says "main(*title for the figure*) if you'd like to add another title
margins, at(discpop=(0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0)) plot(ytitle(Predicted No. of Rebel Groups) xtitle(CWM Discriminated Population (in %)))
*** Marginsplot showing predicted effect of No. of societal groups on # of rebel groups
margins, at(numgrps=(0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19)) plot(ytitle(Predicted No. of Rebel Groups) xtitle(No. of Distinct Societal Groups))



****TABLE 3 
*** testing which divisions matter
 poisson groupsyear ethfra relifra discpop hydroD ALLGEMS mt100  milper100  gdpcapl lgini  terr internationalized democl yearsinconflict cumulativeintensity    , cluster ( conflictid)
   poisson groupsyear effl  cdiv discpop hydroD ALLGEMS mt100  milper100  gdpcapl lgini  terr internationalized democl yearsinconflict cumulativeintensity    , cluster ( conflictid)
 poisson groupsyear ethnicfracalesina relifracales lingfracales   discpop  hydroD ALLGEMS mt100  milper100  gdpcapl lgini  terr internationalized democl yearsinconflict cumulativeintensity , cluster ( conflictid)
 
***FIGURE 2 - INTERACTION with ethnicfractionalization and the size of the discriminated population
poisson groupsyear ethfra relifra discpop ethfradiscpop hydroD ALLGEMS mt100  milper100  gdpcapl lgini  terr internationalized democl yearsinconflict cumulativeintensity    , cluster ( conflictid)

estsimp poisson groupsyear ethfra relifra discpop ethfradiscpop hydroD ALLGEMS mt milper1  gdpcapl lgini  terr internationalized democl yearsinconflict cumulativeintensity    , cluster ( conflictid)
setx mean
setx discpop 0 ethfra .286 ethfradiscpop .23
simqi
setx discpop 0 ethfra .901 ethfradiscpop .901
simqi
 
setx discpop .43 ethfra .286 ethfradiscpop .123
simqi
setx discpop .43 ethfra .901 ethfradiscpop .387
simqi

**the following is R code used to generate the figure
**library(ggplot2)
**data <- data.frame(
  **name = c("Low","High"),
  **value = c(1.272,2.188),
  **sd = c(.1672, .211)
**)

**myplot <- ggplot(data) +
  **geom_bar( aes(x=name, y=value), stat="identity", fill="skyblue", alpha=0.7, position = position_stack(reverse = TRUE)) +
  **geom_errorbar( aes(x=name, ymin=value-sd, ymax=value+sd), width=0.4, colour="orange", alpha=0.9, size=1.3)

**myplot <- myplot + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  **      panel.background = element_blank(), axis.line = element_line(colour = "black"))

**myplot +
  **ggtitle("Predicted No. of Rebel Groups at High Discrimination") +
  **labs(x="Ethnic Fractionalization",y="Predicted No. of Rebel Groups") +
  **theme(plot.title = element_text(family = "Times", hjust = 0.5,vjust =2, size = 20, margin = margin(t = 20, r = 0, b = 0, l = 0))) 

**data2 <- data.frame(
  **name = c("Low","High"),
  **value = c(1.292,1.378),
  **sd = c(.168, .117)
**)

**myplot2 <- ggplot(data2) +
  **geom_bar( aes(x=name, y=value), stat="identity", fill="skyblue", alpha=0.7, position = position_stack(reverse = TRUE)) +
  **geom_errorbar( aes(x=name, ymin=value-sd, ymax=value+sd), width=0.4, colour="orange", alpha=0.9, size=1.3)

**myplot2 <- myplot2 + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  **                       panel.background = element_blank(), axis.line = element_line(colour = "black"))

**myplot2 +
  **ggtitle("Predicted No. of Rebel Groups at Low Discrimination") +
  **labs(x="Ethnic Fractionalization",y="Predicted No. of Rebel Groups") +
  **theme(plot.title = element_text(family = "Times", hjust = 0.5,vjust =2, size = 20, margin = margin(t = 20, r = 0, b = 0, l = 0))) 

  
***TABLE 4 terr vs not
 poisson groupsyear numgrps discpop hydroD ALLGEMS mt100  milper100  gdpcapl lgini  internationalized democl yearsinconflict cumulativeintensity if terr==1   , cluster ( conflictid)
 poisson groupsyear numgrps discpop hydroD ALLGEMS mt100  milper100  gdpcapl lgini  internationalized democl yearsinconflict cumulativeintensity if terr==0   , cluster ( conflictid)

**ONLINE APPENDIX
**extra controls for land and pop
poisson groupsyear numgrps discpop hydroD ALLGEMS mt100  milper100  gdpcapl lgini  terr internationalized democl yearsinconflict cumulativeintensity  lpopl landarea , cluster ( conflictid)
 ***INTERACTIONS
poisson groupsyear ethfra relifra discpop ethfradiscpop hydroD ALLGEMS mt100  milper100  gdpcapl lgini  terr internationalized democl yearsinconflict cumulativeintensity    , cluster ( conflictid)
  poisson groupsyear effl  cdiv discpop effldiscpop hydroD ALLGEMS mt100  milper100  gdpcapl lgini  terr internationalized democl yearsinconflict cumulativeintensity    , cluster ( conflictid)
  **lagged groupsyear
  poisson groupsyear  numgrps laggroupsyear discpop hydroD ALLGEMS mt100  milper100  gdpcapl lgini  terr internationalized democl yearsinconflict cumulativeintensity   , cluster ( conflictid)
   ****fixed effects regression
 xi: regress groupsyear numgrps discpop hydroD ALLGEMS mt100  milper100  gdpcapl lgini  terr internationalized democl yearsinconflict cumulativeintensity i.conflictid
 **no splinters
 poisson gynos numgrps discpop hydroD ALLGEMS mt100  milper100  gdpcapl lgini  terr internationalized democl yearsinconflict cumulativeintensity   , cluster ( conflictid)
 ****only splinters
 poisson splintersz numgrps discpop hydroD ALLGEMS mt100  milper100  gdpcapl lgini  terr internationalized democl yearsinconflict cumulativeintensity   , cluster ( conflictid)
 

**call up second data set
use "conflictiddatasetV4.dta"
**TABLE 2 -Models 2 and 3 
poisson totalgroupsint numgrps   discpop  hydroD ALLGEMS mt100  milper100  gdpcapl lgini  terr internationalized democl yearsinconflict cumulativeintensity
reg groupsyear numgrps   discpop  hydroD ALLGEMS mt100  milper100  gdpcapl lgini  terr internationalized democl yearsinconflict cumulativeintensity




