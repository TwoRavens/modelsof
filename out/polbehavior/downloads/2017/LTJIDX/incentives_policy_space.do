******************************************************************************************
******************************************************************************************
**		Date: July 2017																	**
**																						**
**		Replication files for article													**
**		DO INDIVIDUALS VALUE DISTRIBUTIONAL FAIRNESS? 									**
**		HOW INEQUALITY AFFECTS MAJORITY DECISIONS										**
**		in: Political Behavior															**
**																						**
**		Author: JAN SAUERMANN															**
**				Cologne Center for Comparative Politics									**
**				University of Cologne													**
**																						**
**																						**
**		Note: 	Complete analysis can be run from file "Analyses_Political_Behavior.do".**
**																	 					**
**																						**
******************************************************************************************
******************************************************************************************


clear

spgrid, shape(sq) res(w1) xrange(0 200) yrange(0 150) cells("payoutcells.dta") points("payoutgrid.dta") replace

use "payoutgrid.dta", clear

drop spgrid_id spgrid_status spgrid_xcoord spgrid_ycoord
rename spgrid_xdim x
rename spgrid_ydim y

// Ideal points

generate t1_opt_x1=49
generate t1_opt_y1=68
generate t1_opt_x2=39
generate t1_opt_y2=52
generate t1_opt_x3=25
generate t1_opt_y3=74
generate t1_opt_x4=69
generate t1_opt_y4=100
generate t1_opt_x5=109
generate t1_opt_y5=53

generate t2_opt_x1=49
generate t2_opt_y1=68
generate t2_opt_x2=39
generate t2_opt_y2=52
generate t2_opt_x3=25
generate t2_opt_y3=74
generate t2_opt_x4=69
generate t2_opt_y4=100
generate t2_opt_x5=109
generate t2_opt_y5=53

generate t3_opt_x1=49
generate t3_opt_y1=68
generate t3_opt_x2=39
generate t3_opt_y2=52
generate t3_opt_x3=25
generate t3_opt_y3=74
generate t3_opt_x4=69
generate t3_opt_y4=100
generate t3_opt_x5=109
generate t3_opt_y5=53


generate t1_a1 = 0.75
generate t1_a2 = 0.75
generate t1_a3 = 0.75
generate t1_a4 = 0.75
generate t1_a5 = 0.75

generate t2_a1 = 0.75
generate t2_a2 = 0.75
generate t2_a3 = 0.75
generate t2_a4 = 0.5
generate t2_a5 = 0.5

generate t3_a1 = 0.5
generate t3_a2 = 0.5
generate t3_a3 = 0.5
generate t3_a4 = 0.5
generate t3_a5 = 0.5


generate t1_k1 = 7200
generate t1_k2 = 7200
generate t1_k3 = 7200
generate t1_k4 = 7200
generate t1_k5 = 7200

generate t2_k1 = 7200
generate t2_k2 = 7200
generate t2_k3 = 7200
generate t2_k4 = 1800
generate t2_k5 = 1800

generate t3_k1 = 1800
generate t3_k2 = 1800
generate t3_k3 = 1800
generate t3_k4 = 1800
generate t3_k5 = 1800


generate t1_l1 = 125
generate t1_l2 = 125
generate t1_l3 = 125
generate t1_l4 = 125
generate t1_l5 = 125

generate t2_l1 = 125
generate t2_l2 = 125
generate t2_l3 = 125
generate t2_l4 = 25
generate t2_l5 = 25

generate t3_l1 = 25
generate t3_l2 = 25
generate t3_l3 = 25
generate t3_l4 = 25
generate t3_l5 = 25



// Points in ideal points
generate maxi = 1000

// Distance from every point in grid to ideal point
foreach a in ///
	1 2 3 ///
	{
	foreach b in ///
		1 2 3 4 5 ///
		{
		generate t`a'_dist`b' = ((x-t`a'_opt_x`b')^2+(y-t`a'_opt_y`b')^2)^0.5
		}
	}
	
// Earnings for every player for every point of grid	
foreach a in ///
	1 2 3 ///
	{
	foreach b in ///
		1 2 3 4 5 ///
		{
		generate t`a'_points`b' = round(t`a'_a`b'*(maxi*exp(-t`a'_dist`b'/t`a'_l`b'))+(1-t`a'_a`b')*(maxi*exp(-(t`a'_dist`b')^2/t`a'_k`b')))
		}
	}

// Total points
foreach a in ///
	1 2 3 ///
	{
		generate t`a'tot_points = (t`a'_points1 + t`a'_points2 + t`a'_points3 + t`a'_points4 + t`a'_points5)
		}
	
// Social optimum "Efficient point"
foreach a in ///
	1 2 3 ///
	{
		egen max_t`a'tot_points1 = max(t`a'tot_points)
		generate max_t`a'tot_points = 0
		replace max_t`a'tot_points = 1 if max_t`a'tot_points1==t`a'tot_points
		drop max_t`a'tot_points1
		}

// Average earnings
foreach a in ///
	1 2 3 ///
	{
		generate t`a'avg_points = (t`a'tot_points)/5
		}


// Inequality: Standard deviation of payouts
foreach a in ///
	1 2 3 ///
	{
		generate t`a'_sd_points = (((t`a'_points1 - t`a'avg_points)^2 + (t`a'_points2 - t`a'avg_points)^2 ///
		+ (t`a'_points3 - t`a'avg_points)^2 + (t`a'_points4 - t`a'avg_points)^2 + (t`a'_points5 - t`a'avg_points)^2) / 5 )^0.5
		}


// Maximin
foreach a in ///
	1 2 3 ///
	{
		egen t`a'_min = rowmin(t`a'_points1 t`a'_points2 t`a'_points3 t`a'_points4 t`a'_points5)
		egen max_t`a'_min1 = max(t`a'_min)
		generate max_t`a'_min = 0
		replace max_t`a'_min = 1 if max_t`a'_min1==t`a'_min
		drop max_t`a'_min1
		}

		
// Maximum of individual payouts
foreach a in ///
	1 2 3 ///
	{
		egen t`a'_max = rowmax(t`a'_points1 t`a'_points2 t`a'_points3 t`a'_points4 t`a'_points5)
		}

		
// Range of individual payouts
foreach a in ///
	1 2 3 ///
	{
		gen t`a'_range = t`a'_max - t`a'_min
		}
		
		

// Median of individual payouts
foreach a in ///
	1 2 3 ///
	{
		egen t`a'_median = rowmedian(t`a'_points1 t`a'_points2 t`a'_points3 t`a'_points4 t`a'_points5)
		}


// Average payout / standard deviation
foreach a in ///
	1 2 3 ///
	{
		gen t`a'_avgpay_sd = t`a'avg_points / t`a'_sd_points
		}

// Median payout / standard deviation
foreach a in ///
	1 2 3 ///
	{
		gen t`a'_medpay_sd = t`a'_median / t`a'_sd_points
		}

foreach x in A B C D E A* B* C* D* E*{
capture gen player_`x'="`x'"
}
