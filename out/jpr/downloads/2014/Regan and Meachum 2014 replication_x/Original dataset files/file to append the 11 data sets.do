****appending all the data sets together to form one data set with the intervention as the UoO.  The observations without interventions need to be dropped.
use "C:\\DATA\prior_interven11.dta", clear
append using "C:\\DATA\prior_interven10.dta"
append using "C:\\DATA\prior_interven9.dta"
append using "C:\\DATA\prior_interven8.dta"
append using "C:\\DATA\prior_interven7.dta"
append using "C:\\DATA\prior_interven6.dta"
append using "C:\\DATA\prior_interven5.dta"
append using "C:\\DATA\prior_interven4.dta"
append using "C:\\DATA\prior_interven3.dta"
append using "C:\\DATA\prior_interven2.dta"
append using "C:\\DATA\prior_interven1.dta"

drop if intervention_date==.
sort ccode year intervention_date

****this results in the data file, "appended data", which is at the unit of observation of the intervention year.
