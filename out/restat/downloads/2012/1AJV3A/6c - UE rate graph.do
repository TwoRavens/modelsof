use "UE_rate_data" , clear

set scheme s1mono

tsset date_num, m

global start = "1994m1"
global end = "2001m12"

local election_line "tline(1998m9 , lwidth(thin) lpattern(dash) lcolor(red) noextend)"
local reform_line "tline(1997m8, lwidth(thin) lpattern(dash) lcolor(red) noextend)" 

#delimit ;
twoway  (tsline  ue_rate if tin($start, $end), lcolor(blue) lwidth(medium) lpattern(solid)  
`election_line' ttext( 7.7 1998m4 "Election", color(red))  )
, legen(on) ytitle("Percentage (%)", size(small)) ttitle("Date", size(small)) title("German Unemployment Rate", size(medsmall)) 
fxsize(150) fysize(50)
graphregion(margin(l=10 r=10))
scale(0.75)
legend(off);
#delimit cr

graph export "C:\Users\Michael McMahon\Dropbox\GSOEP21\GiavazziMcMahonReStat\unemployment_graph.eps", replace
