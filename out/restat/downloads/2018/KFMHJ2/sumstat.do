* To produce summary statistics (need to reformat to get Table 1 exactly)

use all_hexagon_iv.dta, clear

gen white3rdpct00 = (white3rd00/pop00)*100
gen white3rdpct10 = (white3rd10/pop10)*100
gen white3rdpct20 = (white3rd20/pop20)*100
gen white3rdpct30 = (white3rd30/pop30)*100

gen forbornpct00 = (forborn00/pop00)*100
gen forbornpct10 = (forborn10/pop10)*100
gen forbornpct20 = (forborn20/pop20)*100
gen forbornpct30 = (forborn30/pop30)*100

gen fforbornpct00 = (fforborn00/pop00)*100
gen fforbornpct10 = (fforborn10/pop10)*100
gen fforbornpct20 = (fforborn20/pop20)*100
gen fforbornpct30 = (fforborn30/pop30)*100

drop pop00a

mat sumstat = J(22,4,.)

local year = 1900
local dec = 00
local k = 1

summ blackpct`dec' if year==`year'
mat sumstat[13,`k'] = r(mean)
mat sumstat[14,`k'] = r(sd)
summ white3rdpct`dec' if year==`year'
mat sumstat[15,`k'] = r(mean)
mat sumstat[16,`k'] = r(sd)
summ fforbornpct`dec' if year==`year'
mat sumstat[17,`k'] = r(mean)
mat sumstat[18,`k'] = r(sd)
summ forbornpct`dec' if year==`year'
mat sumstat[19,`k'] = r(mean)
mat sumstat[20,`k'] = r(sd)
summ pop`dec' if year==`year'
mat sumstat[21,`k'] = r(mean)
mat sumstat[22,`k'] = r(sd)

local year = 1910
local dec = 10
local k = 2

summ whitediff`dec' if year==`year'
mat sumstat[1,`k'] = r(mean)
mat sumstat[2,`k'] = r(sd)
summ blackdiff`dec' if year==`year'
mat sumstat[3,`k'] = r(mean)
mat sumstat[4,`k'] = r(sd)
summ IV_black`dec' if year==`year'
mat sumstat[5,`k'] = r(mean)
mat sumstat[6,`k'] = r(sd)
summ white3rddiff`dec' if year==`year'
mat sumstat[7,`k'] = r(mean)
mat sumstat[8,`k'] = r(sd)
summ fforborndiff`dec' if year==`year'
mat sumstat[9,`k'] = r(mean)
mat sumstat[10,`k'] = r(sd)
summ forborndiff`dec' if year==`year'
mat sumstat[11,`k'] = r(mean)
mat sumstat[12,`k'] = r(sd)
summ blackpct`dec' if year==`year'
mat sumstat[13,`k'] = r(mean)
mat sumstat[14,`k'] = r(sd)
summ white3rdpct`dec' if year==`year'
mat sumstat[15,`k'] = r(mean)
mat sumstat[16,`k'] = r(sd)
summ fforbornpct`dec' if year==`year'
mat sumstat[17,`k'] = r(mean)
mat sumstat[18,`k'] = r(sd)
summ forbornpct`dec' if year==`year'
mat sumstat[19,`k'] = r(mean)
mat sumstat[20,`k'] = r(sd)
summ pop`dec' if year==`year'
mat sumstat[21,`k'] = r(mean)
mat sumstat[22,`k'] = r(sd)

local year = 1920
local dec = 20
local k = 3

summ whitediff`dec' if year==`year'
mat sumstat[1,`k'] = r(mean)
mat sumstat[2,`k'] = r(sd)
summ blackdiff`dec' if year==`year'
mat sumstat[3,`k'] = r(mean)
mat sumstat[4,`k'] = r(sd)
summ IV_black`dec' if year==`year'
mat sumstat[5,`k'] = r(mean)
mat sumstat[6,`k'] = r(sd)
summ white3rddiff`dec' if year==`year'
mat sumstat[7,`k'] = r(mean)
mat sumstat[8,`k'] = r(sd)
summ fforborndiff`dec' if year==`year'
mat sumstat[9,`k'] = r(mean)
mat sumstat[10,`k'] = r(sd)
summ forborndiff`dec' if year==`year'
mat sumstat[11,`k'] = r(mean)
mat sumstat[12,`k'] = r(sd)
summ blackpct`dec' if year==`year'
mat sumstat[13,`k'] = r(mean)
mat sumstat[14,`k'] = r(sd)
summ white3rdpct`dec' if year==`year'
mat sumstat[15,`k'] = r(mean)
mat sumstat[16,`k'] = r(sd)
summ fforbornpct`dec' if year==`year'
mat sumstat[17,`k'] = r(mean)
mat sumstat[18,`k'] = r(sd)
summ forbornpct`dec' if year==`year'
mat sumstat[19,`k'] = r(mean)
mat sumstat[20,`k'] = r(sd)
summ pop`dec' if year==`year'
mat sumstat[21,`k'] = r(mean)
mat sumstat[22,`k'] = r(sd)

local year = 1930
local dec = 30
local k = 4

summ whitediff`dec' if year==`year'
mat sumstat[1,`k'] = r(mean)
mat sumstat[2,`k'] = r(sd)
summ blackdiff`dec' if year==`year'
mat sumstat[3,`k'] = r(mean)
mat sumstat[4,`k'] = r(sd)
summ IV_black`dec' if year==`year'
mat sumstat[5,`k'] = r(mean)
mat sumstat[6,`k'] = r(sd)
summ white3rddiff`dec' if year==`year'
mat sumstat[7,`k'] = r(mean)
mat sumstat[8,`k'] = r(sd)
summ fforborndiff`dec' if year==`year'
mat sumstat[9,`k'] = r(mean)
mat sumstat[10,`k'] = r(sd)
summ forborndiff`dec' if year==`year'
mat sumstat[11,`k'] = r(mean)
mat sumstat[12,`k'] = r(sd)
summ blackpct`dec' if year==`year'
mat sumstat[13,`k'] = r(mean)
mat sumstat[14,`k'] = r(sd)
summ white3rdpct`dec' if year==`year'
mat sumstat[15,`k'] = r(mean)
mat sumstat[16,`k'] = r(sd)
summ fforbornpct`dec' if year==`year'
mat sumstat[17,`k'] = r(mean)
mat sumstat[18,`k'] = r(sd)
summ forbornpct`dec' if year==`year'
mat sumstat[19,`k'] = r(mean)
mat sumstat[20,`k'] = r(sd)
summ pop`dec' if year==`year'
mat sumstat[21,`k'] = r(mean)
mat sumstat[22,`k'] = r(sd)

drop _all
svmat sumstat
outsheet using sumstat.xls, replace
