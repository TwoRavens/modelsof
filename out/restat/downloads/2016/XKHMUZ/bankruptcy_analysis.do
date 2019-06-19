
*APPENDIX TABLE B1

use bankruptcy_data

des

sum

macro define controls "lunemp lp80 lp50 lp20"

xi:reg lrat lma2480 [aw=pop],cluster(statefip)
xi:reg lrat lma2490 [aw=pop],cluster(statefip)


xi:reg lrat lma2480 i.statefip i.year [aw=pop],cluster(statefip)
xi:reg lrat lma2490  i.statefip i.year [aw=pop],cluster(statefip)

xi:reg lrat lma2480 i.statefip i.year $controls [aw=pop],cluster(statefip)
xi:reg lrat lma2490  i.statefip i.year $controls [aw=pop],cluster(statefip)


xi:reg lrat lma2480  i.statefip i.year $controls [aw=pop] if year==1980|year==1985|year==1990|year==1995|year==2000|year==2005|year==2009,cluster(statefip)
xi:reg lrat lma2490  i.statefip i.year $controls [aw=pop] if year==1980|year==1985|year==1990|year==1995|year==2000|year==2005|year==2009,cluster(statefip)

xi:reg lrat lma2480  i.statefip*year i.year $controls [aw=pop],cluster(statefip)
xi:reg lrat lma2480  blma80 i.year i.statefip $controls [aw=pop],cluster(statefip)
xi:reg lrat lma2480 lma2450 lma2420  blma80 i.statefip i.year $controls [aw=pop],cluster(statefip)





