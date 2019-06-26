
* Log file "Geography of Civil War", JPR 39(4)
* H Buhaug & S Gates


* Names and labels of reported variables
 
* lndistx		"Location"
* lnconar		"Absolute scope"
* conflan2		"Relative scope"
* lnlandar		"Land area"
* identity		"Identity"
* incomp		"Incompatibility"
* duration		"Duration"
* confbord		"Border"
* resource		"Resource"
* mountain		"Mountain"
* forest		"Forest"


use 131101, clear

* Descriptive statistics
sum lndistx lnconar conflan2 lnlandar identity incomp duration confbord resource mountain forest

* Correlations
corr lndistx lnconar conflan2 lnlandar identity incomp duration confbord resource mountain forest

* Model 1
reg lndistx lnconar lnlandar identity incomp, robust

* Model 2
reg lndistx conflan2 lnlandar identity incomp, robust

* Model 3
reg lnconar lndistx lnlandar duration confbord resource, robust

* Model 4
reg lnconar lndistx lnlandar duration confbord resource mountain forest, robust

* Model 5
reg conflan2 lndistx lnlandar duration confbord resource, robust

* Model 6
reg conflan2 lndistx lnlandar duration confbord resource mountain forest, robust

* Model 7
reg3 (lnconar lndistx lnlandar duration confbord resource)(lndistx lnconar lnlandar identity incomp)

* Model 8
reg3 (lnconar lndistx lnlandar duration confbord resource mountain forest)(lndistx lnconar lnlandar identity incomp)

* Model 9
reg3 (conflan2 lndistx lnlandar duration confbord resource mountain forest)(lndistx conflan2 lnlandar identity incomp)

* Model 10
reg3 (conflan2 lndistx lnlandar duration confbord resource)(lndistx conflan2 lnlandar identity incomp)
