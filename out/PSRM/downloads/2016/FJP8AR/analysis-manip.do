clear all
use manip.dta

* Table A1
reg policy policycond
margins, at(policy=(0 1))
reg fact policycond
margins, at(policy=(0 1))
reg econ policycond
margins, at(policy=(0 1))

reg age policycond
margins, at(policy=(0 1))
reg race policycond
margins, at(policy=(0 1))
reg novel policycond
margins, at(policy=(0 1))
