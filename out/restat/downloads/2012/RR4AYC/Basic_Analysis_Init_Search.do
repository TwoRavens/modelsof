// Sep 14 2008
// This program provides subroutines finding the initial values for base analysis.do. Have to be used with Base Analysis.

/* This subprogram calculates residual given gamA and gamB */
capture program drop resid
program define resid

	mat temp = `0'

	local gamA = el(temp,1,1)
	local gamB = el(temp,1,2)

	foreach var in $expvar {
		quietly replace x_`var' = (1 - 2*`gamA' -`gamB')*o_`var' + `gamA'*gamA_`var'+ `gamB'*b_`var'
	}

	qui regress crop_$cropnum x_*, noconstant
*	di "(`gamA',`gamB'," e(rss) ")"
end

/* This subprogram calculates reflection point of the 1st point against surface created by the 2nd and 3rd points */
/* Then calculates the RSS at the reflection point */

capture program drop refl
program define refl, rclass

	mat refsim0 = `0'

	mat define p1 = refsim0[1,1..2]'
	mat define p2 = refsim0[2,1..2]'
	mat define p3 = refsim0[3,1..2]'

	mat define inner1 = (p1 - p3)' * (p2 - p3)
	scalar s_inner1 = el(inner1,1,1)
	mat div = ((p2 - p3)' * (p2 - p3))
	scalar s_div = el(div,1,1)
	
	mat matrefl = -p1 + 2*p3 + (2*(p2 - p3)*s_inner1) / s_div

	resid matrefl'
	mat temp = matrefl', (e(rss))
	return mat refl = temp
end

/* Sort rows in descending order of rss */

capture program drop matsort
program define matsort, rclass

	mat sim0 = `0'
	mat sim1 = sim0[1, 1...]
	mat sim2 = sim0[2, 1...]	
	mat sim3 = sim0[3, 1...]

	local p1R = el(sim1,1,3)
	local p2R = el(sim2,1,3)
	local p3R = el(sim3,1,3)	

	if (`p1R' > `p2R' & `p2R' > `p3R') {
		mat R = sim1 \ sim2 \ sim3
	}
	if (`p1R' > `p3R' & `p3R' > `p2R') {
		mat R = sim1 \ sim3 \ sim2
	}

	if (`p2R' > `p1R' & `p1R' > `p3R') {
		mat R = sim2 \ sim1 \ sim3
	}

	if (`p2R' > `p3R' & `p3R' > `p1R') {
		mat R = sim2 \ sim3 \ sim1
	}

	if (`p3R' > `p1R' & `p1R' > `p2R') {
		mat R = sim3 \ sim1 \ sim2
	}

	if (`p3R' > `p2R' & `p2R' > `p1R') {
		mat R = sim3 \ sim2 \ sim1
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

	mat tempsim = R
	refl tempsim
	if (el(R,1,3) > el(r(refl),1,3)) {
		display "Replacing vertex #1..."
		mat R = r(refl) \ R2 \ R3
		exit
	}

	mat tempsim = R2 \ R1 \ R3
	refl tempsim
	if (el(R,2,3) > el(r(refl),1,3)) {
		display "Replacing vertex #2..."
		mat R = R1 \ r(refl) \ R3
		exit
	}

	mat tempsim = R3 \ R1 \ R2
	refl tempsim
	if (el(R,3,3) > el(r(refl),1,3)) {
		mat R = R1 \ R2 \ r(refl)
		display "Replacing vertex #3..."
		exit
	}

/* Needs to insert the simplex width checking routine here */

	di "Shrinking the Simplex..."
	mat R1 = (R1[1,1..2] + R3[1,1..2])/2 
	resid R1
	mat R1 = R1 , (e(rss))

	mat R2 = (R2[1,1..2] + R3[1,1..2])/2 
	resid R2
	mat R2 = R2, (e(rss))

	mat R = R1 \ R2 \ R3

	mat width1 = (R1[1,1..2] - R3[1,1..2])*(R1[1,1..2] - R3[1,1..2])' 
	mat width2 = (R1[1,1..2] - R2[1,1..2])*(R1[1,1..2] - R2[1,1..2])' 
	mat width3 = (R2[1,1..2] - R3[1,1..2])*(R2[1,1..2] - R3[1,1..2])'
	scalar width = max(el(width1,1,1), el(width2,1,1), el(width3,1,1)) ^ (1/2)
	display "Now the simplex width is " width "."

end

capture program drop init_search
program init_search

	display "Searching for initial values using the Polytope algorithm..."

	mat R = (.1,.1 \ .2,.1 \ .1,.2)
	resid R[1,1..2]
	local temp1 = e(rss)
	resid R[2,1..2]
	local temp2 = e(rss)
	resid R[3,1..2]
	local temp3 = e(rss)

	mat R = R, (`temp1' \ `temp2' \ `temp3')

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

end
