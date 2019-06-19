*** NOTE:  To reduce the number of iterations required for the MNL model with unobserved ***
***        heterogeneity program to reach convergence, this do-file uses the coefficient ***
***        estimates from a standard MNL model to create a matrix of starting estimates  ***
***        for the unobserved heterogeneity program.  Testing indicated that providing   ***
***        starting estimates rather than using the default starting esitmates (all      ***
***        zeroes) affects only the speed of convergence, not the values of the final    ***
***        coefficient estimates.                                                        ***
***        This program differs from the other "creating starter matrix" do-file in that ***
***        this one does not include a starting estimate for the parameter indicating    ***
***        the relative sizes of the two groups.  Under the constant heterogeneity       ***
***        weight approach, that parameter is directly assigned particular values.       ***



/*
NOTE:  This do-file should be run after you run the mlogit model that
       provides the starting values for the unobserved heterogeneity
       program

NOTE:  This do-file uses the value e(df_m), the saved total number of
       explanatory variables (not counting constant terms) from both
	   equations of the mlogit model, and divides it by 2 to get the
	   number of explanatory variables in each equation
*/



*** Save the matrix of mlogit coefficient estimates ***
matrix a = e(b)
*matrix list a



*** That matrix will have constant values, which need to be moved to the end ***
*** of the matrix to serve as the mymlogit_uh_lf starter intercept estimates ***



*** Get the mlogit first equation coefficients (not the constant) ***
matrix afirst = a[1,((e(df_m)/2)+2)..(((e(df_m)/2)*2)+1)]
*matrix list afirst

*** Get the mlogit first constant term ***
matrix constfirst = a[1,(((e(df_m)/2)+1)*2)]
*matrix list constfirst

*** Get the mlogit second equation coefficients (not the constant) ***
matrix asecond = a[1,(((e(df_m)/2)*2)+3)..(((e(df_m)/2)*3)+2)]
*matrix list asecond

*** Get the mlogit second constant term ***
matrix constsecond = a[1,(((e(df_m)/2)+1)*3)]
*matrix list constsecond



*** In the original program used to estimate the model, having equal values across ***
*** groups for the constant terms seemed to cause some convergence trouble, but    ***
*** adjusting them as shown below resolved it                                      ***
matrix starter = (afirst,asecond,constfirst-0.5,constfirst+0.5,constsecond-0.5,constsecond+0.5)
matrix list starter



