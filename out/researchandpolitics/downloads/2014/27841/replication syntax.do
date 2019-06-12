*Initial variable transformations
*Transforming occupational diversification into a 0-10 (theoretically) measure
*(For ease-of-interpretation purposes)
gen iod10=iod/10

*Generating interaction effects
gen priod10=pr*iod10
gen multimemberiod10=multimember*iod10
gen tworoundiod10=tworound*iod10


*Figure 1
line enepm year if country=="Denmark" , name(mden1)
line enepm year if country=="Germany" , name(mger1)
line enepm year if country=="Italy" , name(mita1)
line enepm year if country=="Netherlands" , name(mnet1)
line enepm year if country=="Norway" , name(mnor1)
line enepm year if country=="Switzerland" , name(mswi1)
line enepm year if country=="UK" , name(muk1)

graph combine mden1 mger1 mita1 mnet1 mnor1 mswi1 muk1


*Figure 2
line iod year if country=="Denmark" , name(mden2)
line iod year if country=="Germany" , name(mger2)
line iod year if country=="Italy" , name(mita2)
line iod year if country=="Netherlands" , name(mnet2)
line iod year if country=="Norway" , name(mnor2)
line iod year if country=="Switzerland" , name(mswi2)
line iod year if country=="UK" & year>1849 , name(muk2)

graph combine mden2 mger2 mita2 mnet2 mnor2 mswi2 muk2


*Models - Table 1

reg enepm iod10 pr priod10 multimember multimemberiod10 tworound tworoundiod10 ger ita net nor swi uk , vce(jackknife)
mixed enepm iod10 pr priod10 multimember multimemberiod10 tworound tworoundiod10 || countrynumber: , stddev level(99)


*Robustness Tests

*Using alternative measures of the DV

*Dropping Italy and Switzerland
reg enepm iod10 pr priod10 multimember multimemberiod10 tworound tworoundiod10 ger net nor uk if ita==0 & swi==0 , vce(jackknife)
mixed enepm iod10 pr priod10 multimember multimemberiod10 tworound tworoundiod10 || countrynumber: if ita==0 & swi==0 , stddev level(99)

*Percentage voting for third- and lower-placed parties 
reg third iod10 pr priod10 multimember multimemberiod10 tworound tworoundiod10 ger ita net nor swi uk , vce(jackknife)
mixed third iod10 pr priod10 multimember multimemberiod10 tworound tworoundiod10 || countrynumber: , stddev level(99)

*Re-estimating models using 'enepm' and 'third' with alternate data for the Netherlands
*Treats the Netherlands (post-1917) as a single constituency instead of examining variation across provinces
reg enepm2 iod10 pr priod10 multimember multimemberiod10 tworound tworoundiod10 ger ita net nor swi uk , vce(jackknife)
mixed enepm2 iod10 pr priod10 multimember multimemberiod10 tworound tworoundiod10 || countrynumber: , stddev level(99)
reg third2 iod10 pr priod10 multimember multimemberiod10 tworound tworoundiod10 ger ita net nor swi uk , vce(jackknife)
mixed third2 iod10 pr priod10 multimember multimemberiod10 tworound tworoundiod10 || countrynumber: , stddev level(99)


*Using PCSEs
*Setting up the data for time-series, cross-sectional analysis
xtset countrynumber election

*without a lag
xtpcse enepm iod10 pr priod10 multimember multimemberiod10 tworound tworoundiod10 ger ita net nor swi uk , p 

*with a lag
xtpcse enepm L.enepm iod10 pr priod10 multimember multimemberiod10 tworound tworoundiod10 ger ita net nor swi uk , p 


*De-trending both party system fragmentation and occupational diversification
reg enepm year
predict renepm , resid

reg iod10 year
predict riod10 , resid

*Interacting de-trended occupational diversification with the three electoral system variables
gen prriod10=pr*riod10
gen multimemberriod10=multimember*riod10
gen tworoundriod10=tworound*riod10

*The de-trended models
reg renepm riod10 pr prriod10 multimember multimemberriod10 tworound tworoundriod10 ger ita net nor swi uk , vce(bootstrap, reps(10000))
mixed renepm riod10 pr prriod10 multimember multimemberriod10 tworound tworoundriod10 || countrynumber: , 


*Models using future values of ENEP
reg F.enepm iod10 pr priod10 multimember multimemberiod10 tworound tworoundiod10 ger ita net nor swi uk , vce(jackknife)
mixed F.enepm iod10 pr priod10 multimember multimemberiod10 tworound tworoundiod10 || countrynumber: , 


*Using lagged values of occupational diversification
*Generating lagged occupational diversification
gen liod10=L.iod10

*Interacting lagged occupational diversification with the three electoral system variables
gen prliod10=pr*liod10
gen multimemberliod10=multimember*liod10
gen tworoundliod10=tworound*liod10

*The models using lagged occupational diversification
reg enepm liod10 pr prliod10 multimember multimemberliod10 tworound tworoundliod10 ger ita net nor swi uk , vce(jackknife)
mixed enepm liod10 pr prliod10 multimember multimemberliod10 tworound tworoundliod10 || countrynumber: , 


*Testing for World War I effects
*Separate models are estimated for both models presented in Table 1 using 
*(1) a post-WWI dummy variable 
*(2) a post-WWI dummy variable interacted with occupation diversification 
*(3) including only those elections prior to WWI
*Generating the WWI variable and interaction
gen wwi=0
replace wwi=1 if year>1918
gen wwiiod10=wwi*iod10

*Re-estimated models
reg enepm iod10 pr priod10 multimember multimemberiod10 tworound tworoundiod10 wwi ger ita net nor swi uk , vce(jackknife)
reg enepm iod10 pr priod10 multimember multimemberiod10 tworound tworoundiod10 wwi wwiiod10 ger ita net nor swi uk , vce(jackknife)
reg enepm iod10 pr priod10 multimember multimemberiod10 tworound tworoundiod10 ger ita net nor swi uk if wwi==0 , vce(jackknife)

mixed enepm iod10 pr priod10 multimember multimemberiod10 tworound tworoundiod10 wwi || countrynumber: , 
mixed enepm iod10 pr priod10 multimember multimemberiod10 tworound tworoundiod10 wwi wwiiod10 || countrynumber: , 
mixed enepm iod10 pr priod10 multimember multimemberiod10 tworound tworoundiod10 if wwi==0 || countrynumber: , 

