* EUKLEMS industries to World robotics industries
	
	gen code_robots = ""
	cap rename code code_euklems
			
	replace code_robots = 	"10-12" if code_euklems=="15t16"
	replace code_robots = 	"13-15" if code_euklems=="17t19"
	
	replace code_robots = 	"13-15" if code_euklems=="17t18" & country=="CHN"
	replace code_robots = 	"13-15" if code_euklems=="19" & country=="CHN"
	
	replace code_robots = 	"16" 	if code_euklems=="20"
	replace code_robots = 	"17-18" if code_euklems=="21t22"
	replace code_robots = 	"19-22" if code_euklems=="23t25"
	replace code_robots = 	"23" 	if code_euklems=="26" 
	replace code_robots = 	"24-28" if code_euklems=="27t28"
	replace code_robots = 	"26-27" if code_euklems=="30t33"
	replace code_robots = 	"29a" 	if code_euklems=="34t35"
	replace code_robots = 	"A-B" 	if code_euklems=="AtB"
	replace code_robots = 	"C"	 	if code_euklems=="C"
	replace code_robots = 	"E"	 	if code_euklems=="E"
	replace code_robots = 	"F"	 	if code_euklems=="F"
	
	replace code_robots = 	"90" 	if code_euklems=="36t37" 
	//replace code_robots = 	"91" 	if code_euklems=="" (services) // all other non-manu - don't use
	//replace code_robots = 	"99" 	if code_euklems=="" // unspecified, drop this - don't use
	replace code_robots = 	"M"	 	if code_euklems=="M"
