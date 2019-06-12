*NOTE: MUST HAVE THEIR COMMANDS INSTALLED - SEE THEIR PUBLIC USE FILE

*Everything is interacted with all treatments, but in table report coefficients on intercepts for treat2-treat4 relative to treat1, so when 
*I recast I use treat1 as control.

use 20100142_data, clear

*Table3 - Model 1 - All okay

matrix A3=[0,0,0] 
cameronHet Vote t1_length t1_width t1_location t3_length t3_width t3_location treat3 t4_length t4_width t4_location treat4 t2_length t2_width t2_location treat2 Household_Size Income Graduate_Degree, cluster(subjectID) hetero(treat3 treat4 treat2) 
*test statistics - will show can get identical with reparameterization of the model
testparm treat*
foreach i in 2 3 4 {
	foreach j in length location width {
		test t1_`j' = t`i'_`j', accumulate
		}
	}

*Reparamaterize in a way that allows me to recover coefficients for differences (treating t1 as control, as in original specification it is included in constant)
cameronHet Vote Length Width Location t2_length t2_width t2_location t3_length t3_width t3_location t4_length t4_width t4_location treat2 treat3 treat4 Household_Size Income Graduate_Degree, cluster(subjectID) hetero(treat2 treat3 treat4) 
testparm treat*
foreach i in 2 3 4 {
	foreach j in length location width {
		test t`i'_`j' = 0, accumulate
		}
	}
*Identical
	testparm t2* t3* t4* treat*

*Table 3 - Model 2 - One rounding error
matrix A3=[0,0,0,0] 
cameronHet Vote t1_length t1_width t1_location t3_length t3_width t3_location treat3 t4_length t4_width t4_location treat4 t2_length t2_length_c t2_width t2_width_c t2_location t2_location_c treat2 t2_consequential Household_Size Income Graduate_Degree, cluster(subjectID) hetero(treat3 treat4 treat2 t2_consequential) 
testparm treat*
foreach i in 2 3 4 {
	foreach j in length location width {
		test t1_`j' = t`i'_`j', accumulate
		}
	}
foreach j in t2_length_c t2_width_c t2_location_c t2_consequential [sigma]t2_consequential {
	test `j' = 0, accumulate
	}
*Note: There is no "consequential" by itself in the regression - only allowing it have to have influence in treatment 2, so null is this coefficient is zero (i.e. restriction that only has influence in treatment 2)

matrix A3=[0,0,0,0] 
cameronHet Vote Length Width Location t2_length t2_width t2_location t3_length t3_width t3_location t4_length t4_width t4_location treat2 treat3 treat4 t2_length_c t2_width_c t2_location_c t2_consequential Household_Size Income Graduate_Degree, cluster(subjectID) hetero(treat2 treat3 treat4 t2_consequential) 
testparm treat*
foreach i in 2 3 4 {
	foreach j in length location width {
		test t`i'_`j' = 0, accumulate
		}
	}
foreach j in t2_length_c t2_width_c t2_location_c t2_consequential [sigma]t2_consequential {
	test `j' = 0, accumulate
	}
*Identical
	testparm t2* t3* t4* treat*

save DatVDR, replace






