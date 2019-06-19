
local basepath "C:/Jirka/Research/g7expectations/g7expectations/stata/"
cd "`basepath'"
adopath + C:/ado/egenodd

capture log close
log using doAllDataMan.log, replace

do "`basepath'dataManagement/macro_transformation.do"
do "`basepath'dataManagement/dataManagement.do"
do "`basepath'dataManagement/stackData.do"
do "`basepath'dataManagement/stackStacked.do"

log close