*** Now for each of the shortest routes, we construct a measure of the difficulty to run, using the percentage vote share by county of the Democratic party
*** (which was pro-slavery)

*** The idea is for each path to freedom, we weigh our measured voting shares by the distance of that voting share to the path (voting shares in counties
*** further away get weighted less).  Then we take the weighted average voting share along the path as our estimate of the difficulty

*** Added 11/03/09: Bandwidth is now a fraction of distance (10%) to take into account the actual difficulty is less variable the shorter the path (because people can wander off path)

*** Added 08/18/12: Paths to Mexico allowed, as are paths to Canada via Chicago and Cleveland

clear
set mem 400m
set more off
global date = "022313"
* global dropbox = "C:\Users\dallen\Dropbox"
global dropbox = "C:\Users\Treb\Documents\My Dropbox"
global dir_source = "$dropbox\Research\Fugitive Slave Law\Data\County Level Data\" /* source location */
global dir_dest = "$dropbox\Research\Fugitive Slave Law\Data\" /* destination location */
cd "$dir_source"
set seed 01361412
cap log close
log using distance_difficulty_$date.log, replace
use distances_081712.dta



	*** Merging on railroad data
		sort state_fips county_code, stable
		merge state_fips county_code using "county_070610.dta", keep(pres* rail* water*) /* this gets us a little bit more information on voting, as well as water and rail transportation information */
		tab _merge /* 99.97% */
		keep if _merge==3
		drop _merge
		
*** estimated time to complete loop: 6.5 hours

*** Step 0: Defining the path to freedom

	gen dest_1850_lat = nearest_north_lat
	replace dest_1850_lat = 27.5 if dist_texas<dist_north
	
	gen dest_1850_lon = nearest_north_lon
	replace dest_1850_lon = 99.52 if dist_texas<dist_north
	
	gen dest_1860_lat = nearest_canada_lat
	replace dest_1860_lat = 27.5 if dist_texas<dist_north
	
	gen dest_1860_lon = nearest_canada_lon
	replace dest_1860_lon = 99.52 if dist_texas<dist_north	

*** Step 1: Defining Program

cap prog drop treb_dist
prog treb_dist, rclass
	*** This program will calculate the overland distance between the path between two counties and any third county

	local s_lat =`1' /* your starting latitude (in radians) */
	local s_lon =`2' /* your starting longitude (in radians) */

	local f_lat =`3' /* your finishing latitude (in radians) */
	local f_lon =`4' /* your finishing longitude (in radians */

	local lat =`5' /* latitude of the third county (in radians) */
	local lon =`6' /* longitude of the third county (in radians) */

	** Step 1: Calculate the overland distances between each of the three counties
	* Here is the distance between any two points 1 and 2, where 1 has lattitude a1 and longitude b1 and 2 has lattitude a2 and longitude b2
	* acos(cos(a1)*cos(b1)*cos(a2)*cos(b2) + cos(a1)*sin(b1)*cos(a2)*sin(b2)+ sin(a1)*sin(a2)) * `radius'
	* courtesy of http://www.mathforum.com/library/drmath/view/51711.html
	
	local radius = 3693 /* in miles */

	* Between finish and third (A_over)
	local A_over=(acos(cos(`lat')*cos(-`lon')*cos(`f_lat')*cos(-`f_lon') + cos(`lat')*sin(-`lon')*cos(`f_lat')*sin(-`f_lon')+ sin(`lat')*sin(`f_lat')))*`radius'

	* Between start and finish (B_over)
	local B_over=(acos(cos(`s_lat')*cos(-`s_lon')*cos(`f_lat')*cos(-`f_lon') + cos(`s_lat')*sin(-`s_lon')*cos(`f_lat')*sin(-`f_lon')+ sin(`s_lat')*sin(`f_lat')))*`radius'

	* Between start and third (C_over)
	local C_over=(acos(cos(`lat')*cos(-`lon')*cos(`s_lat')*cos(-`s_lon') + cos(`lat')*sin(-`lon')*cos(`s_lat')*sin(-`s_lon')+ sin(`lat')*sin(`s_lat')))*`radius'

	** Step 2: Pretend these are the straight line distances and calculate the angles between them using the law of cosines, then do a scalar projection
	
		* angle between vector going from start to finish and vector going from start to third
			local theta_start = acos((`B_over'^2+`C_over'^2-`A_over'^2)/(2*`B_over'*`C_over'))
			
		* angle between vectorgoing from finish to start and vector going from finish to third
			local theta_finish = acos((`A_over'^2+`B_over'^2-`C_over'^2)/(2*`A_over'*`B_over'))
			
		* scalar projection of vector from start to third onto vector from start to finish (gives distance along path)
			local distance_along_path = `C_over' * cos(`theta_start')
			
		* distance from third to closest point along path
			local distance_to_path = sqrt(`C_over'^2 - `distance_along_path'^2)
		
	** saving results
		return local distance = `distance_to_path' 
		return local bandwidth = `distance_along_path'
		return local angle_start = `theta_start'
		return local angle_finish = `theta_finish'

end

*** Step 2: Setting up the loop

* degrees to radians
ren lattitude lattitude_deg
ren longitude longitude_deg
gen lattitude=(lattitude_deg/180)*_pi
gen longitude=(longitude_deg/180)*_pi

cap drop temp*
gen temp_dist_data=(longitude<. & lattitude<.)
sort temp_dist_data slave_state, stable
by temp_dist_data slave_state: gen temp=_n if slave_state==1 & temp_dist_data==1

qui sum temp
local maxcounty_south = r(max)
local maxcounty = _N

*** Step 3: The Loop!
* There will be multiple measures of difficulty that I will consider: free black population, fraction of free blacks in total population, railroad density, and % democrats along route

	* Fraction democrats as a measure of difficulty stays the same in both periods
	gen pres_1850 = pres_1848_dem / 100
	gen pres_1860 = pres_1848_dem / 100 
	
	* Number of free blacks along route
	gen freeblack_1850 = black_total_1850
	gen freeblack_1860 = black_total_1860
	
	* Fraction of total free population comprised by free blacks along route
	gen freeblack_frac_1850 = black_total_1850 / (white_total_1850 + black_total_1850)
	gen freeblack_frac_1860 = black_total_1860 / (white_total_1860 + black_total_1860)
	
	* Number of slaves along route
	gen slaves_1850 = slave_total_1850
	gen slaves_1860 = slave_total_1860
	
	* Fraction of slaves of total population along route
	gen slaves_frac_1850 = slave_total_1850 / (white_total_1850 + black_total_1850 + slave_total_1850)
	gen slaves_frac_1860 = slave_total_1860 / (white_total_1860 + black_total_1860 + slave_total_1860)
	
	* Total Population
	gen population_1850 = white_total_1850 + black_total_1850 + slave_total_1850
	gen population_1860 = white_total_1860 + black_total_1860 + slave_total_1860
	
* The loop
set more off

local sd_scalar = 0.2 /* this parameter determines how large the standard deviation of the kernel is (as a multiple of the distance) */

* foreach var in rail water pres freeblack freeblack_frac slaves slaves_frac { NEED TO CHANGE
foreach var in rail {

	gen `var'_1850_difficulty = 0
	gen `var'_1860_difficulty = 0
	gen `var'_1850_weight = 0
	gen `var'_1860_weight = 0
	
	forvalues i=1(1)`maxcounty_south' {												/* the origin county */			
		local k_1 = 0
		local k_2 = 0
		local k_3 = 0
		disp "`var' `i'"
		forvalues j=1(1)`maxcounty' {													/* the third county */ 
			if `var'_1850[`j']<. & lattitude[`j']<. & longitude[`j']<.	{

				qui sum lattitude if temp==`i'
				local s_lat = r(mean)
			
				qui sum longitude if temp==`i'
				local s_lon = r(mean)

				local lat = lattitude[`j']

				local lon = longitude[`j']

				* Distance to North (1850 measure of difficulty) [or mexico, if that's closer]
				qui sum dest_1850_lat if temp==`i'
				local f_lat_north = r(mean)

				qui sum dest_1850_lon if temp==`i'
				local f_lon_north = r(mean)

				local pres_1850 = `var'_1850[`j']

				if `s_lat'~=`lat' & `f_lat_north'~=`lat' & `s_lon'~=`lon' & `f_lon_north'~=`lon' & `s_lat'~=`f_lat_north' & `s_lon'~=`f_lon_north'   { /* makes sure they're not the same point */		
					treb_dist `s_lat' `s_lon' `f_lat_north' `f_lon_north' `lat' `lon'
					local distance = r(distance) /* distance of third county to path between origin and destination counties */
					local bw_0 = r(bandwidth) /* bandwidth expands as distance from start increases */ 
					local bw = `sd_scalar' *`bw_0'
					local angle_start = r(angle_start)
					local angle_finish = r(angle_finish)
					}
				
				else {			
					local distance = 0
					local bw = 1
					local k_1 = `k_1'+1
					}

				if `distance'==. {
					disp " third county is _n=`j'"
					}

				if `bw'==. {
					disp " third county is _n=`j'"
					}
					
				if (abs(`angle_start')<=(_pi/2)) & (abs(`angle_finish')<=(_pi/2)) { /* then we use this county in the average (otherwise it would never be on the route) */
					local k_1 = `k_1'+1
				}

				assert `distance'<.
				assert `bw'<.

				qui replace `var'_1850_difficulty= (1/`k_1')*`pres_1850'*(1/`bw')*exp(-.5*((`distance')/`bw')^2)+((`k_1'-1)/(`k_1'))*`var'_1850_difficulty if temp==`i' & (abs(`angle_start')<=(_pi/2)) & (abs(`angle_finish')<=(_pi/2))
				qui replace `var'_1850_weight= (1/`k_1')*(1/`bw')*exp(-.5*((`distance')/`bw')^2)+((`k_1'-1)/(`k_1'))*`var'_1850_weight if temp==`i' & (abs(`angle_start')<=(_pi/2)) & (abs(`angle_finish')<=(_pi/2))
				
				if `var'_1850_difficulty==. | `var'_1850_weight==. {
					disp " third county is _n=`j'"
					disp "k_1 is `k_1'"
					disp "distance is `distance'"
					disp "bandwidth is `bw'"
					disp "Value of difficulty measure is `pres_1850'"
					}
				
				assert `var'_1850_difficulty<.
				assert `var'_1850_weight<.

				* Distance to Canada (1860 measure of difficulty) [or mexico, if that's closer]
				qui sum dest_1860_lat if temp==`i'
				local f_lat_canada = r(mean)

				qui sum dest_1860_lon if temp==`i'
				local f_lon_canada = r(mean)

				if `s_lat'~=`lat' & `f_lat_canada'~=`lat' & `s_lon'~=`lon' & `f_lon_canada'~=`lon' & `s_lat'~=`f_lat_canada' & `s_lon'~=`f_lon_canada'   { /* makes sure they're not the same point */
					treb_dist `s_lat' `s_lon' `f_lat_canada' `f_lon_canada' `lat' `lon'
					local distance = r(distance) /* distance of third county to path between origin and destination counties */
					local bw_0 = r(bandwidth) /* bandwidth expands as distance from start increases */ 
					local bw = `sd_scalar' *`bw_0'
					local angle_start = r(angle_start)
					local angle_finish = r(angle_finish)
					}

				else {
					local distance = 0
					local bw = 1
					local k_2 = `k_2'+1
					}

				if `distance'==. {
					disp " third county is _n=`j'"
					}
					
				if (abs(`angle_start')<=(_pi/2)) & (abs(`angle_finish')<=(_pi/2)) { /* then we use this county in the average (otherwise it would never be on the route) */
					local k_2 = `k_2'+1
				}

				assert `distance'<.
				
				local pres_1860 = `var'_1860[`j']

				qui replace `var'_1860_difficulty= (1/`k_1')*`pres_1860'*(1/`bw')*exp(-.5*((`distance')/`bw')^2)+((`k_1'-1)/(`k_1'))*`var'_1860_difficulty if temp==`i' & (abs(`angle_start')<=(_pi/2)) & (abs(`angle_finish')<=(_pi/2))
				qui replace `var'_1860_weight= (1/`k_1')*(1/`bw')*exp(-.5*((`distance')/`bw')^2)+((`k_1'-1)/(`k_1'))*`var'_1860_weight if temp==`i' & (abs(`angle_start')<=(_pi/2)) & (abs(`angle_finish')<=(_pi/2))
				
				}
			}
		}
	
	* to normalize the estimates controlling for the number of counties nearby
	qui replace `var'_1850_difficulty=`var'_1850_difficulty/`var'_1850_weight
	qui replace `var'_1860_difficulty=`var'_1860_difficulty/`var'_1860_weight
	
	}

*** Step 4: Cleaning up and saving

* radians to degrees
drop lattitude longitude
ren lattitude_deg lattitude
ren longitude_deg longitude

lab dat "County Distance and Difficulty Measure"
cd "$dir_dest"
sort state_fips county_code, stable
save distance_difficulty_$date.dta, replace





