	use PAGE_REPLICATION_DATA_ESS.dta, clear 
		
	*Weighting
	gen myweight = pweight*pspwght

	*Interaction term
	gen IGLAdiscr = ILGAscore*dscrsex
	
	*Table 5 
	reg euftf dscrsex dscrrce dscretn dcrnat dscrwomen lrscale gayrights agea eduyrs [pweight=myweight] 

	reg euftf dscrsex dscrrce dscretn dcrnat dscrwomen lrscale gayrights agea eduyrs [pweight=myweight] if EU15==1

	reg euftf dscrsex dscrrce dscretn dcrnat dscrwomen lrscale gayrights agea eduyrs [pweight=myweight] if EU15==0 

	reg euftf ILGAscore dscrsex dscrrce dscretn dcrnat dscrwomen lrscale gayrights agea eduyrs [pweight=myweight] 

	reg euftf ILGAscore dscrsex IGLAdiscr dscrrce dscretn dcrnat dscrwomen lrscale gayrights agea eduyrs [pweight=myweight] 
