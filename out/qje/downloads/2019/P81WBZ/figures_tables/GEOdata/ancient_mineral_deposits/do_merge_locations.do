clear
use "/Users/ke.3747/Dropbox/Research/BCH_AssyrianTrade/data/Ancient mineral deposits/ancientminedata-step3.dta"

replace province = lower(province)
replace district = lower(district)
replace province = "afyonkarahisar" if province=="afyon"

merge m:1 province district using "/Users/ke.3747/Dropbox/Research/Data/Turkey_district_populations/Turkey_2012_district_populations_coordinates",keepusing(long_x lat_y)
sort province district


keep if _merge==1
keep province district long_x lat_y
duplicates drop province district, force

save ancient_metal_district_coords_unmerge-part2 // we then fill these in from the file above ("/Users/ke.3747/Dropbox/Research/Data/Turkey_district_populations/Turkey_2012_district_populations_coordinates")
                                                 // A few mistakes: Ankara-Bogazkoy is Corum-Bogazkale; Aydin-Gumuldur is Izmir/Menderes which is now Izmir-Merkez
												 
												 
												 

