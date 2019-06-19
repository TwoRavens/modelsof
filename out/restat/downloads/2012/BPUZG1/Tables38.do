
clear 

set mem 150m
set matsize 1000
set more on

use tables38

/* Figure 2 */

gen d3=1 if crday>=1 & crday<=3
replace d3=2 if crday>=4 & crday<=6
replace d3=3 if crday>=7 & crday<=9
replace d3=4 if crday>=10 & crday<=12
replace d3=5 if crday>=13 & crday<=15
replace d3=6 if crday>=16 & crday<=18
replace d3=7 if crday>=19 & crday<=21
replace d3=8 if crday>=22 & crday<=24
replace d3=9 if crday>=25 & crday<=27
replace d3=10 if crday>=28 & crday~=.

egen mnratswkd3=mean(totrat), by(d3 his)
egen mnecratswkd3=mean(ecrat), by(d3 his)
egen mnnoecratswkd3=mean(nonecrat), by(d3 his)

sort his d3
by his d3: sum mnratswkd3 
by his d3: sum mnecratswkd3 
by his d3: sum mnnoecratswkd3 

/* Table 3 */
sum totrat totcrime ecrat eccrime nonecrat noneccrime burgt larct motort robt fst10 popind crday avgtemp precip snowfall holiday 

centile totrat totcrime ecrat eccrime nonecrat noneccrime burgt larct motort robt fst10 popind crday avgtemp precip snowfall holiday 


/* Table 4 */

xtreg totrat fst10 fst10his ctdwn*, fe i(ctmnyr) vce(bootstrap) 

xtreg totrat fst10 fst10his avgtemp precip snowfall holiday ctdwn*, fe i(ctmnyr) vce(bootstrap)

xtreg totrat popind crdn* ctdwn*, fe i(ctmnyr) vce(bootstrap)

xtreg totrat popind avgtemp precip snowfall holiday crdn* ctdwn*, fe i(ctmnyr) vce(bootstrap)

xtnbreg totcrime fst10 fst10his ctdwn*, fe i(ctmnyr)  iterate(12) vce(bootstrap) 

xtnbreg totcrime fst10 fst10his avgtemp precip snowfall holiday ctdwn*, fe i(ctmnyr)  iterate(12) vce(bootstrap) 

xtnbreg totcrime popind crdn* ctdwn*, fe i(ctmnyr)  iterate(12) vce(bootstrap) 

xtnbreg totcrime popind avgtemp precip snowfall holiday crdn* ctdwn*, fe i(ctmnyr)  iterate(12) vce(bootstrap) 


/* Table 5 */

xtreg ecrat fst10 fst10his ctdwn*, fe i(ctmnyr) vce(bootstrap)

xtreg ecrat fst10 fst10his avgtemp precip snowfall holiday ctdwn*, fe i(ctmnyr) vce(bootstrap)

xtreg ecrat popind crdn* ctdwn*, fe i(ctmnyr) vce(bootstrap)

xtreg ecrat popind avgtemp precip snowfall holiday crdn* ctdwn*, fe i(ctmnyr) vce(bootstrap)


xtnbreg eccrime fst10 fst10his ctdwn*, fe i(ctmnyr)  iterate(12) vce(bootstrap) 

xtnbreg eccrime fst10 fst10his avgtemp precip snowfall holiday ctdwn*, fe i(ctmnyr)  iterate(12) vce(bootstrap) 

xtnbreg eccrime popind crdn* ctdwn*, fe i(ctmnyr)  iterate(12) vce(bootstrap) 

xtnbreg eccrime popind avgtemp precip snowfall holiday crdn* ctdwn*, fe i(ctmnyr)  iterate(12) vce(bootstrap) 




/* Table 6 */

xtreg nonecrat fst10 fst10his ctdwn*, fe i(ctmnyr) vce(bootstrap)

xtreg nonecrat fst10 fst10his avgtemp precip snowfall holiday ctdwn*, fe i(ctmnyr) vce(bootstrap)

xtreg nonecrat popind crdn* ctdwn*, fe i(ctmnyr) vce(bootstrap)

xtreg nonecrat popind avgtemp precip snowfall holiday crdn* ctdwn*, fe i(ctmnyr) vce(bootstrap)


xtnbreg noneccrime fst10 fst10his ctdwn*, fe i(ctmnyr)  iterate(12) vce(bootstrap) 

xtnbreg noneccrime fst10 fst10his avgtemp precip snowfall holiday ctdwn*, fe i(ctmnyr)  iterate(12) vce(bootstrap) 

xtnbreg noneccrime popind crdn* ctdwn*, fe i(ctmnyr)  iterate(12) vce(bootstrap) 

xtnbreg noneccrime popind avgtemp precip snowfall holiday crdn* ctdwn*, fe i(ctmnyr)  iterate(12) vce(bootstrap) 

/* Table 7 */

xtnbreg burgt popind crdn* ctdwn*, fe i(ctmnyr) iterate (12) vce(bootstrap) 
xtnbreg burgt popind avgtemp precip snowfall holiday crdn* ctdwn*, fe i(ctmnyr) iterate (12) vce(bootstrap) 


xtnbreg larct popind crdn* ctdwn*, fe i(ctmnyr) iterate(12) vce(bootstrap) 
xtnbreg larct popind avgtemp precip snowfall holiday crdn* ctdwn*, fe i(ctmnyr) iterate(12) vce(bootstrap) 

xtnbreg motort popind crdn* ctdwn*, fe i(ctmnyr) iterate(12) vce(bootstrap) 
xtnbreg motort popind avgtemp precip snowfall holiday crdn* ctdwn*, fe i(ctmnyr) iterate(12) vce(bootstrap) 

xtnbreg robt popind crdn* ctdwn*, fe i(ctmnyr) iterate(12) vce(bootstrap) 
xtnbreg robt popind avgtemp precip snowfall holiday crdn* ctdwn*, fe i(ctmnyr) iterate(12) vce(bootstrap) 



/* Table 8 */

xtnbreg eccrime popgrpn2-popgrpn10 crdn* ctdwn*, fe i(ctmnyr)  iterate(12) vce(bootstrap) 

xtnbreg eccrime popgrpn2-popgrpn10 avgtemp precip snowfall holiday crdn* ctdwn*, fe i(ctmnyr)  iterate(12) vce(bootstrap) 

test popgrpn2=popgrpn3
test popgrpn2=popgrpn4
test popgrpn2=popgrpn5
test popgrpn2=popgrpn6
test popgrpn2=popgrpn7
test popgrpn2=popgrpn8
test popgrpn2=popgrpn9
test popgrpn2=popgrpn10

test popgrpn3=popgrpn4
test popgrpn3=popgrpn5
test popgrpn3=popgrpn6
test popgrpn3=popgrpn7
test popgrpn3=popgrpn8
test popgrpn3=popgrpn9
test popgrpn3=popgrpn10

test popgrpn4=popgrpn5
test popgrpn4=popgrpn6
test popgrpn4=popgrpn7
test popgrpn4=popgrpn8
test popgrpn4=popgrpn9
test popgrpn4=popgrpn10

test popgrpn5=popgrpn6
test popgrpn5=popgrpn7
test popgrpn5=popgrpn8
test popgrpn5=popgrpn9
test popgrpn5=popgrpn10

test popgrpn6=popgrpn7
test popgrpn6=popgrpn8
test popgrpn6=popgrpn9
test popgrpn6=popgrpn10

test popgrpn7=popgrpn8
test popgrpn7=popgrpn9
test popgrpn7=popgrpn10

test popgrpn8=popgrpn9
test popgrpn8=popgrpn10

test popgrpn9=popgrpn10

xtnbreg noneccrime popgrpn2-popgrpn10 crdn* ctdwn*, fe i(ctmnyr)  iterate(12) vce(bootstrap) 

xtnbreg noneccrime popgrpn2-popgrpn10 avgtemp precip snowfall holiday crdn* ctdwn*, fe i(ctmnyr)  iterate(12) vce(bootstrap) 

test popgrpn2=popgrpn3
test popgrpn2=popgrpn4
test popgrpn2=popgrpn5
test popgrpn2=popgrpn6
test popgrpn2=popgrpn7
test popgrpn2=popgrpn8
test popgrpn2=popgrpn9
test popgrpn2=popgrpn10

test popgrpn3=popgrpn4
test popgrpn3=popgrpn5
test popgrpn3=popgrpn6
test popgrpn3=popgrpn7
test popgrpn3=popgrpn8
test popgrpn3=popgrpn9
test popgrpn3=popgrpn10

test popgrpn4=popgrpn5
test popgrpn4=popgrpn6
test popgrpn4=popgrpn7
test popgrpn4=popgrpn8
test popgrpn4=popgrpn9
test popgrpn4=popgrpn10

test popgrpn5=popgrpn6
test popgrpn5=popgrpn7
test popgrpn5=popgrpn8
test popgrpn5=popgrpn9
test popgrpn5=popgrpn10

test popgrpn6=popgrpn7
test popgrpn6=popgrpn8
test popgrpn6=popgrpn9
test popgrpn6=popgrpn10

test popgrpn7=popgrpn8
test popgrpn7=popgrpn9
test popgrpn7=popgrpn10

test popgrpn8=popgrpn9
test popgrpn8=popgrpn10

test popgrpn9=popgrpn10

log close

 
