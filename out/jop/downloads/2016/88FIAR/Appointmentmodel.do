/* Data is already stset.  Edit the pathway below to your file directory */
use "C:*editpathwayhere*\JOPappointment.dta", clear
stcox termlen sex minority , tvc(age ideoagree workload salary) texp(_t) vce(cluster stcode) noadjust nohr
