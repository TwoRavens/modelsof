* Sep 21 2008
* This program provides subroutines finding the initial values for the extended analyses.
* Used with Actual_q_FSA.do

/* This subprogram calculates residual given gamA, gamB, gamD */
capture program drop resid
program define resid

	mat temp = `0'

	local gamA = el(temp,1,1)
	local gamB = el(temp,1,2)
	local gamD = el(temp,1,3)

	foreach var in $expvar {
		quietly replace x_`var' = (1 - 2*`gamA' -`gamB')*o_`var' + ///
		`gamA'*((1-D_a1) + `gamD'*D_a1)*a1_`var' + `gamA'*((1-D_a2) + `gamD'*D_a2)*a2_`var' + ///
		`gamB'*((1-D_b) + `gamD'*D_b)*b_`var'
	}

	qui regress crop_$cropnum x_*, noconstant
*	di "(`gamA',`gamB',`gamD', " e(rss) ")"
end

/* This subprogram calculates reflection point of the 1st point against surface created by the 2nd and 3rd points */
/* Then calculates the RSS at the reflection point */

capture program drop refl
program define refl, rclass

	mat refsim0 = `0'

	mat define p1 = refsim0[1,1..3]'
	mat define p2 = refsim0[2,1..3]'
	mat define p3 = refsim0[3,1..3]'

	mat define inner1 = (p1 - p3)' * (p2 - p3)
	scalar s_inner1 = el(inner1,1,1)
	mat div = ((p2 - p3)' * (p2 - p3))
	scalar s_div = el(div,1,1)
	
	mat matrefl = -p1 + 2*p3 + (2*(p2 - p3)*s_inner1) / s_div

	resid matrefl'
	mat temp = matrefl', (e(rss))
	return mat refl = temp
end

/* Sort rows in descending order of rss for 3 by 4 matrices. The 4th column is RSS */

capture program drop mat3sort
program define mat3sort, rclass

	mat tsim0 = `0'
	mat tsim1 = tsim0[1, 1...]
	mat tsim2 = tsim0[2, 1...]	
	mat tsim3 = tsim0[3, 1...]

	local p1R = el(tsim1,1,4)
	local p2R = el(tsim2,1,4)
	local p3R = el(tsim3,1,4)	

	if (`p1R' > `p2R' & `p2R' > `p3R') {
		mat tR = tsim1 \ tsim2 \ tsim3
	}
	if (`p1R' > `p3R' & `p3R' > `p2R') {
		mat tR = tsim1 \ tsim3 \ tsim2
	}
	if (`p2R' > `p1R' & `p1R' > `p3R') {
		mat tR = tsim2 \ tsim1 \ tsim3
	}
	if (`p2R' > `p3R' & `p3R' > `p1R') {
		mat tR = tsim2 \ tsim3 \ tsim1
	}
	if (`p3R' > `p1R' & `p1R' > `p2R') {
		mat tR = tsim3 \ tsim1 \ tsim2
	}
	if (`p3R' > `p2R' & `p2R' > `p1R') {
		mat tR = tsim3 \ tsim2 \ tsim1
	}
end


capture program drop matsort
program define matsort, rclass

	mat sim0 = `0'
	mat sim1 = sim0[1, 1...]
	mat sim2 = sim0[2, 1...]	
	mat sim3 = sim0[3, 1...]
	mat sim4 = sim0[4, 1...]

	local p1R = el(sim1,1,4)
	local p2R = el(sim2,1,4)
	local p3R = el(sim3,1,4)
	local p4R = el(sim4,1,4)	

	if (`p1R' > `p2R' & `p1R' > `p3R' & `p1R' > `p4R') {
		mat3sort sim2 \ sim3 \ sim4
		mat R = sim1 \ tR
	}

	if (`p2R' > `p1R' & `p2R' > `p3R' & `p2R' > `p4R') {
		mat3sort sim1 \ sim3 \ sim4
		mat R = sim2 \ tR
	}

	if (`p3R' > `p1R' & `p3R' > `p2R' & `p3R' > `p4R') {
		mat3sort sim1 \ sim2 \ sim4
		mat R = sim3 \ tR
	}

	if (`p4R' > `p1R' & `p4R' > `p2R' & `p4R' > `p3R') {
		mat3sort sim1 \ sim2 \ sim3
		mat R = sim4 \ tR
	}

end



/* This program produces the next simplex matrix given the old one sorted in */

capture program drop newsimplex
program define newsimplex, rclass

	matsort `0'

	mat list R

	/* Calculate RSS at reflection pt and make swapping if reflection pt has lower RSS. */

	mat R1 = R[1, 1...]
	mat R2 = R[2, 1...]	
	mat R3 = R[3, 1...]
	mat R4 = R[4, 1...]

	mat tempsim = R
	refl tempsim
	if (el(R,1,4) > el(r(refl),1,4)) {
		display "Replacing vertex #1..."
		mat R = r(refl) \ R2 \ R3 \ R4
		exit
	}

	mat tempsim = R2 \ R1 \ R3 \ R4
	refl tempsim
	if (el(R,2,4) > el(r(refl),1,4)) {
		display "Replacing vertex #2..."
		mat R = R1 \ r(refl) \ R3 \ R4
		exit
	}

	mat tempsim = R3 \ R1 \ R2 \ R4
	refl tempsim
	if (el(R,3,4) > el(r(refl),1,4)) {
		mat R = R1 \ R2 \ r(refl) \ R4
		display "Replacing vertex #3..."
		exit
	}

	mat tempsim = R4 \ R1 \ R2 \ R3
	refl tempsim
	if (el(R,4,4) > el(r(refl),4,4)) {
		mat R = R1 \ R2 \ R3 \ r(refl)
		display "Replacing vertex #4..."
		exit
	}

	di "Shrinking the Simplex..."
	mat R1 = (R1[1,1..3] + R4[1,1..3])/2 
	resid R1
	mat R1 = R1 , (e(rss))

	mat R2 = (R2[1,1..3] + R4[1,1..3])/2 
	resid R2
	mat R2 = R2, (e(rss))

	mat R3 = (R3[1,1..3] + R4[1,1..3])/2 
	resid R3
	mat R3 = R3, (e(rss))

	mat R = R1 \ R2 \ R3 \ R4

	mat width1 = (R1[1,1..3] - R3[1,1..3])*(R1[1,1..3] - R3[1,1..3])' 
	mat width2 = (R1[1,1..3] - R2[1,1..3])*(R1[1,1..3] - R2[1,1..3])' 
	mat width3 = (R2[1,1..3] - R3[1,1..3])*(R2[1,1..3] - R3[1,1..3])'

	mat width4 = (R1[1,1..3] - R4[1,1..3])*(R1[1,1..3] - R4[1,1..3])' 
	mat width5 = (R2[1,1..3] - R4[1,1..3])*(R2[1,1..3] - R4[1,1..3])' 
	mat width6 = (R3[1,1..3] - R4[1,1..3])*(R3[1,1..3] - R4[1,1..3])'

	scalar width = max(el(width1,1,1), el(width2,1,1), el(width3,1,1), el(width4,1,1), el(width5,1,1), el(width6,1,1)) ^ (1/2)
	display "Now the simplex width is " width "."

end

/* Have to work on from here!! */


capture program drop init_search
program init_search

	display "Searching for initial values using the Polytope algorithm..."

	mat R = (0, .1, 1 \ .1, 0, 1 \ .1, .1, 1 \ .1, .1, .5 )
	resid R[1,1..3]
	local temp1 = e(rss)
	resid R[2,1..3]
	local temp2 = e(rss)
	resid R[3,1..3]
	local temp3 = e(rss)
	resid R[4,1..3]
	local temp4 = e(rss)

	mat R = R, (`temp1' \ `temp2' \ `temp3' \ `temp4')

	set more off
	scalar width = 1
	local i 1
	while width > 0.01 {
		di " "
		di "Simplex `i'"
		newsimplex R
		local i = `i' + 1
	}

	matsort R
	global InitGamA el(R,3,1)
	global InitGamB el(R,3,2)
	global InitGamD el(R,3,3)

end
