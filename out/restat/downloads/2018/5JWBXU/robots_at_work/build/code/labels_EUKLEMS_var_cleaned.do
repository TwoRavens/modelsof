* label EUKLEMS variables after normalization
* syntax: do label_EUKLEMS_variables baseyear

	local baseyr = `1'
	
	la var VA "Gross value added in historical US$"
	la var VA_local "Gross value added in historical local currency"
	la var VA_QI "Gross value added in `baseyr' US$"
	
	la var LAB "Labor compensation in historical US$"
	la var LAB_local "Labor compensation in historical local currency"
	la var LAB_QI "Labor compensation in `baseyr' US$"
	
	la var CAPLAB "Ratio of capital to labor compensation"
	
	la var CAP "Capital compensation in historical US$"
	la var CAP_local "Capital compensation in historical local currency"
	la var CAP_QI "Capital compensation in `baseyr' US$"
	
	la var CAPIT "ICT Capital compensation in historical US$"
	la var CAPIT_QI "ICT Capital compensation in `baseyr' US$"
	
	la var CAPITSHR "Share of ICT capital in total capital compensation"
	
	la var CAPNIT "Non-ICT Capital compensation in historical US$"
	la var CAPNIT_QI "Non-ICT Capital compensation in `baseyr' US$"
