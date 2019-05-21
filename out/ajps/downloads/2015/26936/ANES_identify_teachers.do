*This .do file creates a dummy variable for teachers for 1956-1982 that we then merged in by unique ID number into the Trimmed ANES Cumulative File (included with the replication materials)
*ANES Cumulative File does not include occupation codes for 1956-1982, so must open yearly files individually and create occupation variables
*1984-2004 includes occupation codes, so no need to open each year individually

*No occupation codes in ANES for 1948 and 1952

*1956
clear
set more off
use "NES_1956.dta"
gen teacher=0
*03.  PUBLIC SCHOOL TEACHERS (093)
*This code used for 1956-1964
replace teacher=1 if V560120==3
tab teacher
gen double id=19560000+V560002
keep id teacher
sort id
save "NES_Public_Employees_1956.dta", replace

*1958
clear
use "NES_1958.dta"
gen teacher=0
replace teacher=1 if V580181==3
tab teacher
gen double id=19580000+V580002
keep id teacher
sort id
save "NES_Public_Employees_1958.dta", replace

*1960
clear
use "NES_1960.dta"
gen teacher=0
replace teacher=1 if V600129==3
tab teacher
gen double id=19600000+V600002
keep id teacher
sort id
save "NES_Public_Employees_1960.dta", replace

*1962
clear
use "NES_1962.dta"
gen teacher=0
replace teacher=1 if V620080==3
tab teacher
gen double id=19620000+V620002
keep id teacher
sort id
save "NES_Public_Employees_1962.dta", replace

*1964
clear
use "NES_1964.dta"
gen teacher=0
replace teacher=1 if V640202==3
tab teacher
gen double id=19640000+V640002
keep id teacher
sort id
save "NES_Public_Employees_1964.dta", replace

*1966
*Only asked occupation of head of household
*Respondent coded as a teacher only if they are the head of household
clear
use "NES_1966.dta"
gen teacher=0
*142   TEACHERS, ELEMENTARY SCHOOLS/182/
*142   TEACHERS, SECONDARY SCHOOLS/183/
*142   TEACHERS (N.E.C.)/184/
*This code used for 1966-1974
replace teacher=1 if V660201==142 & V660238==1
tab teacher
gen double id=19660000+V660002
gen police=0
replace police=1 if V660201==615
replace police=1 if V660201==616
gen fire=0
replace fire=1 if V660201==610
keep id teacher police fire
sort id
save "NES_Public_Employees_1966.dta", replace

*1968
clear
use "NES_1968.dta"
gen teacher=0
replace teacher=1 if V680161==142
tab teacher
gen double id=19680000+V680002
gen police=0
replace police=1 if V680161==615
replace police=1 if V680161==616
gen fire=0
replace fire=1 if V680161==610
keep id teacher police fire
sort id
save "NES_Public_Employees_1968.dta", replace

*1970
clear
use "NES_1970.dta"
gen teacher=0
replace teacher=1 if V700276==142
tab teacher
gen double id=19700000+V700002
gen police=0
replace police=1 if V700276==615
replace police=1 if V700276==616
gen fire=0
replace fire=1 if V700276==610
keep id teacher police fire
sort id
save "NES_Public_Employees_1970.dta", replace

*1972
clear
use "NES_1972.dta"
gen teacher=0
replace teacher=1 if V720309==142
tab teacher
gen double id=19720000+V720002
gen police=0
replace police=1 if V720309==615
replace police=1 if V720309==616
gen fire=0
replace fire=1 if V720309==610
keep id teacher police fire
sort id
save "NES_Public_Employees_1972.dta", replace

*1974
clear
use "NES_1974.dta"
gen teacher=0
replace teacher=1 if V742446==142
tab teacher
gen double id=19740000+V742002
gen police=0
replace police=1 if V742446==615
replace police=1 if V742446==616
gen fire=0
replace fire=1 if V742446==610
keep id teacher police fire
sort id
save "NES_Public_Employees_1974.dta", replace

*1976
clear
use "NES_1976.dta"
gen teacher=0
*142 ELEMENTARY SCHOOL TEACHERS
*143 PREKINDERGARTEN AND KINDERGARTEN TEACHERS
*144 SECONDARY SCHOOL TEACHERS
*145 TEACHERS, EXCEPT COLLEGE AND UNIVERSITY
*This code used for 1976-1982
replace teacher=1 if V763412==142
replace teacher=1 if V763412==143
replace teacher=1 if V763412==144
replace teacher=1 if V763412==145
tab teacher
gen double id=19760000+V763002
gen police=0
replace police=1 if V763412==964
replace police=1 if V763412==965
gen fire=0
replace fire=1 if V763412==961
keep id teacher police fire
sort id
save "NES_Public_Employees_1976.dta", replace

*1978
clear
use "NES_1978.dta"
gen teacher=0
replace teacher=1 if V780534==142
replace teacher=1 if V780534==143
replace teacher=1 if V780534==144
replace teacher=1 if V780534==145
tab teacher
gen double id=19780000+V780002
gen police=0
replace police=1 if V780534==964
replace police=1 if V780534==965
gen fire=0
replace fire=1 if V780534==961
keep id teacher police fire
sort id
save "NES_Public_Employees_1978.dta", replace

*1980
clear
use "NES_1980.dta"
gen teacher=0
replace teacher=1 if V800455==142
replace teacher=1 if V800455==143
replace teacher=1 if V800455==144
replace teacher=1 if V800455==145
tab teacher
gen double id=19800000+V800004
gen police=0
replace police=1 if V800455==964
replace police=1 if V800455==965
gen fire=0
replace fire=1 if V800455==961
keep id teacher police fire
sort id
save "NES_Public_Employees_1980.dta", replace

*1982
clear
use "NES_1982.dta"
gen teacher=0
replace teacher=1 if V820557==142
replace teacher=1 if V820557==143
replace teacher=1 if V820557==144
replace teacher=1 if V820557==145
tab teacher
gen double id=19820000+V820004
gen police=0
replace police=1 if V820557==964
replace police=1 if V820557==965
gen fire=0
replace fire=1 if V820557==961
keep id teacher police fire
sort id
save "NES_Public_Employees_1982.dta", replace

*Append 1956-1982 files together
*The dummy variable for "teacher" is included in the Trimmed ANES Cumulative File with the replication materials
