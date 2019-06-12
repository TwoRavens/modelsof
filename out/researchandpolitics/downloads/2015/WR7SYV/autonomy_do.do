///This file reproduces the results reported in James Igoe Walsh, "Political Accountability and Autonomous Weapons," Research and Politics
///This .do file is associated with the data fille "autonomy.dta". 

///Create figure 1. This requires installation of ciplot package. Type "ssc install ciplot" to install this package.///
ciplot secdef commanders engineers sensors, by(treatments) miss hor

///Create figure 2. this requires installation of ciplot package.
recode investigatesecdef (5 = .25) (4 = .5) (3 = .75) (2 = 1)
la var investigatesecdef "Secetary of Defense"
recode investigatecommanders (5 = .25) (4 = .5) (3 = .75) (2 = 1)
la var investigatecommanders "Commanders"
recode investigateengineers (5 = .25) (4 = .5) (3 = .75) (2 = 1)
la var investigateengineers "Engineers"
recode investigatesensors (5 = .25) (4 = .5) (3 = .75) (2 = 1)
la var investigatesensors "Sensors"

ciplot investigatesecdef investigatecommanders investigateengineers investigatesensors, by(treatments) miss hor

///Note that attribution to pilot does not vary across t1 and t2///
reg pilot t2
reg pilot t2 idaq militarismscale trust partyid white age sex education

///table A3///
reg secdef t2 t3 
reg commanders t2 t3
reg engineers t2 t3
reg sensors t2 t3

///table A4///
reg secdef t2 t3  idaq militarismscale trust partyid white age sex education
reg commanders t2 t3 idaq militarismscale trust partyid white age sex education
reg engineers t2 t3 idaq militarismscale trust partyid white age sex education
reg sensors t2 t3 idaq militarismscale trust partyid white age sex education

///table A5///
reg secdef t2 t3  idaq militarismscale trust partyid white age sex education if success <.7
reg commanders t2 t3 idaq militarismscale trust partyid white age sex education if success <.7
reg engineers t2 t3 idaq militarismscale trust partyid white age sex education if success <.7
reg sensors t2 t3 idaq militarismscale trust partyid white age sex education if success <.7

///table A6///
reg secdef t2 t3  idaq militarismscale trust partyid white age sex education if success >.7
reg commanders t2 t3 idaq militarismscale trust partyid white age sex education if success >.7
reg engineers t2 t3 idaq militarismscale trust partyid white age sex education if success >.7
reg sensors t2 t3 idaq militarismscale trust partyid white age sex education if success >.7

///table A7///
reg secdef t2 t3  idaq militarismscale trust partyid white age sex education if civcas <.88
reg commanders t2 t3 idaq militarismscale trust partyid white age sex education if civcas <.88
reg engineers t2 t3 idaq militarismscale trust partyid white age sex education if civcas <.88
reg sensors t2 t3 idaq militarismscale trust partyid white age sex education if civcas <.88

///table A8///
reg secdef t2 t3  idaq militarismscale trust partyid white age sex education if civcas >.88
reg commanders t2 t3 idaq militarismscale trust partyid white age sex education if civcas >.88
reg engineers t2 t3 idaq militarismscale trust partyid white age sex education if civcas >.88
reg sensors t2 t3 idaq militarismscale trust partyid white age sex education if civcas >.88

///Note that attribution to pilot does not vary across t1 and t2///
reg investigatepilot t2
reg investigatepilot t2 idaq militarismscale trust partyid white age sex education


///table A9///
reg investigatesecdef t2 t3 
reg investigatecommanders t2 t3
reg investigateengineers t2 t3
reg investigatesensors t2 t3

///table A10///
reg investigatesecdef t2 t3  idaq militarismscale trust partyid white age sex education
reg investigatecommanders t2 t3 idaq militarismscale trust partyid white age sex education
reg investigateengineers t2 t3 idaq militarismscale trust partyid white age sex education
reg investigatesensors t2 t3 idaq militarismscale trust partyid white age sex education

///table A11///
reg investigatesecdef t2 t3  idaq militarismscale trust partyid white age sex education if success <.7
reg investigatecommanders t2 t3 idaq militarismscale trust partyid white age sex education if success <.7
reg investigateengineers t2 t3 idaq militarismscale trust partyid white age sex education if success <.7
reg investigatesensors t2 t3 idaq militarismscale trust partyid white age sex education if success <.7

///table A12///
reg investigatesecdef t2 t3  idaq militarismscale trust partyid white age sex education if success >.7
reg investigatecommanders t2 t3 idaq militarismscale trust partyid white age sex education if success >.7
reg investigateengineers t2 t3 idaq militarismscale trust partyid white age sex education if success >.7
reg investigatesensors t2 t3 idaq militarismscale trust partyid white age sex education if success >.7

///table A13///
reg investigatesecdef t2 t3  idaq militarismscale trust partyid white age sex education if civcas <.88
reg investigatecommanders t2 t3 idaq militarismscale trust partyid white age sex education if civcas <.88
reg investigateengineers t2 t3 idaq militarismscale trust partyid white age sex education if civcas <.88
reg investigatesensors t2 t3 idaq militarismscale trust partyid white age sex education if civcas <.88

///table A14///
reg investigatesecdef t2 t3  idaq militarismscale trust partyid white age sex education if civcas >.88
reg investigatecommanders t2 t3 idaq militarismscale trust partyid white age sex education if civcas >.88
reg investigateengineers t2 t3 idaq militarismscale trust partyid white age sex education if civcas >.88
reg investigatesensors t2 t3 idaq militarismscale trust partyid white age sex education if civcas >.88

///Robustness check: Same models as above, but estimation with ordered logit rather than OLS///
///treatment variables only///
ologit investigatesecdef t2 t3 
ologit investigatecommanders t2 t3
ologit investigateengineers t2 t3
ologit investigatesensors t2 t3

///treatments and control variables///
ologit investigatesecdef t2 t3  idaq militarismscale trust partyid white age sex education
ologit investigatecommanders t2 t3 idaq militarismscale trust partyid white age sex education
ologit investigateengineers t2 t3 idaq militarismscale trust partyid white age sex education
ologit investigatesensors t2 t3 idaq militarismscale trust partyid white age sex education

///Participants with low expectation of success///
ologit investigatesecdef t2 t3  idaq militarismscale trust partyid white age sex education if success <.7
ologit investigatecommanders t2 t3 idaq militarismscale trust partyid white age sex education if success <.7
ologit investigateengineers t2 t3 idaq militarismscale trust partyid white age sex education if success <.7
ologit investigatesensors t2 t3 idaq militarismscale trust partyid white age sex education if success <.7

///Participants with high expectation of success///
ologit investigatesecdef t2 t3  idaq militarismscale trust partyid white age sex education if success >.7
ologit investigatecommanders t2 t3 idaq militarismscale trust partyid white age sex education if success >.7
ologit investigateengineers t2 t3 idaq militarismscale trust partyid white age sex education if success >.7
ologit investigatesensors t2 t3 idaq militarismscale trust partyid white age sex education if success >.7

///Robustness check: Does IDAQ interact with treatment assignment?///
///Create a dummy variable measuring if assigned to fully autonomous treatment or to another treatment///
gen autonomy = 0
replace autonomy = 1 if t3 == 1

///Responsibility attribution
reg secdef autonomy##c.idaq militarismscale trust partyid white age sex education
margins autonomy, at (idaq = (0(.01)1))
marginsplot, xdimension(at(idaq))

reg commanders autonomy##c.idaq militarismscale trust partyid white age sex education
margins autonomy, at (idaq = (0(.01)1))
marginsplot, xdimension(at(idaq))

reg engineers autonomy##c.idaq militarismscale trust partyid white age sex education
margins autonomy, at (idaq = (0(.01)1))
marginsplot, xdimension(at(idaq))

reg sensors autonomy##c.idaq militarismscale trust partyid white age sex education
margins autonomy, at (idaq = (0(.01)1))
marginsplot, xdimension(at(idaq))

///Investigation
ologit investigatesecdef autonomy##c.idaq militarismscale trust partyid white age sex education
margins autonomy, at (idaq = (0(.01)1))
marginsplot, xdimension(at(idaq))

ologit investigatecommanders autonomy##c.idaq militarismscale trust partyid white age sex education
margins autonomy, at (idaq = (0(.01)1))
marginsplot, xdimension(at(idaq))

ologit investigateengineers autonomy##c.idaq militarismscale trust partyid white age sex education
margins autonomy, at (idaq = (0(.01)1))
marginsplot, xdimension(at(idaq))

ologit investigatesensors autonomy##c.idaq militarismscale trust partyid white age sex education
margins autonomy, at (idaq = (0(.01)1))
marginsplot, xdimension(at(idaq))
