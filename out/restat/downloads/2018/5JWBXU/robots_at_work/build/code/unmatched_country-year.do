* diagnose observations that are unmatched - to do with country and year

	gen unmatched_country_year = "na" if _merge==3

	replace unmatched_country_year = "year not covered in World Robotics data" if year<1993 | ( year<1999 & country=="CHN" )
	replace unmatched_country_year = "country not covered in World Robotics data" if (country=="CYP"| country=="LUX"| country=="CAN") & _merge==2
	
	replace unmatched_country_year = "country not covered in EUKLEMS data" if country=="CHN"
