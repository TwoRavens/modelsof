* normalise a variable by its base year value
* syntax: do normalise varname group_level1 group_level2 timevar baseyear startyear

	local var `1'
	local level1 `2'
	local level2 `3'
	local time `4'
	local baseyr `5'
	local startyr `6'
		
	//local i = `baseyr'-`startyr'+1
	
	sort `level1' `level2' `time'
	
	//by `level1' `level2': replace `var' = `var'/`var'[`i']*100 if _n!=`i'
	//by `level1' `level2': replace `var' = 100 if _n==`i'

	
* try version that is robust to different startyears within groups
	
	by `level1' `level2': gen `var'_baseyr = `var' if `time'==`baseyr'
	by `level1' `level2': egen `var'_baseyr_mean = mean(`var'_baseyr)
	
	replace `var' = `var'/`var'_baseyr_mean*100
	
	drop `var'_baseyr*
