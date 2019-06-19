/* ML Estimators.do */
/* This file writes two maximum likelihood estimators */
/* Estimator 1: Quasi-hyperbolic discounting with Luce Errors */
/* Estimator 2: Pure hyperbolic discounting with Luce Errors */

/**** Estimator 1 ****/
/* Quasi-hyperbolic Discounting */

capture drop llbdgen llbd = .capture drop duhatgen duhat = .
capture program drop ML_quasiprogram define ML_quasi	* specifiy the arguments for the program	args lnf b d mu		* declare temporary variables	tempvar choice optionA optionB t k duA duB  duDiff			quietly {		* initialize the data 		generate int `choice' = $ML_y1		generate double `optionA' = $ML_y2		generate double `optionB' = $ML_y3		generate double `t' = $ML_y4		generate double `k' = $ML_y5
		
		* evaluate the discounted utilities		generate double `duA' = `optionA'
		generate double `duB' = (`b'*(`d'^`k')*(`optionB'))		replace `duB' =  ((`d'^`k')*(`optionB')) if `t'== 6				* get the difference		generate `duDiff' = (`duB'^(1/`mu'))/((`duB'^(1/`mu'))+(`duA'^(1/`mu'))) 		replace duhat = `duDiff'				* evaluate the likelihood         replace `lnf' = ln(`duDiff') if `choice' ==1         replace `lnf' = ln(1-`duDiff') if `choice' ==0 	    * save the calculated likelihood in an external storage variable         replace llbd = `lnf'     } end 

/**** Estimator 2 ****/
/* Hyperbolic Discounting */

capture program drop ML_hypprogram define ML_hyp	* specifiy the arguments for the program	args lnf a mu		* declare temporary variables	tempvar choice optionA optionB t k  duA duB  duDiff			quietly {		* initialize the data 		generate int `choice' = $ML_y1		generate double `optionA' = $ML_y2		generate double `optionB' = $ML_y3		generate double `t' = $ML_y4		generate double `k' = $ML_y5
		
		* evaluate the discounted utilities		generate double `duA' = (1/(1+(`a'*t)))*`optionA'
		generate double `duB' = (1/(1+(`a'*(t+k))))*`optionB'						* get the difference		generate `duDiff' = (`duB'^(1/`mu'))/((`duB'^(1/`mu'))+(`duA'^(1/`mu'))) 		replace duhat = `duDiff'				* evaluate the likelihood         replace `lnf' = ln(`duDiff') if `choice' ==1         replace `lnf' = ln(1-`duDiff') if `choice' ==0         *replace `lnf' = ln(normal(`duDiff')) if `choice' ==1         *replace `lnf' = ln(normal(-`duDiff')) if `choice' ==0 	    * save the calculated likelihood in an external storage variable         replace llbd = `lnf'     } end 