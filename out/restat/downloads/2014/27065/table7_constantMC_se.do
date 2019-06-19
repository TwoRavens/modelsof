clear all
set more off

*log using se_method2.log, replace
use dif1.dta

local no_of_samples=100
set seed 1234
gen one=1
quietly for num 1/`no_of_samples': gen uniX = uniform()
quietly for num 1/`no_of_samples': bysort one (uniX): gen sampleX=(_n<=680)
drop one uni*

save se_method2_1.dta, replace

clear all

mata
//mata matuse est_model1_k
//mata drop B pvals z
B = J(0,5,.)
mata matsave Bmatrix1c B, replace
end

clear all

forvalues i = 1/100{
	disp `i'
	clear all
	use se_method2_1.dta, replace
	drop if sample`i'==0
	quietly do matafile1c.do
}

mata:

mata matuse Bmatrix1c, replace
B
st_matrix("B",B)

end

svmat B
sum B*
