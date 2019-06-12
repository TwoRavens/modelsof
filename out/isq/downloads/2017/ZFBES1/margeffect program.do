program margeffect
	/* 1st argument `1' is X variable name */
	/* 2nd argument `2' is Z variable name */
	/* 3rd argument `3' is variable name of interaction term */
	/* 4th argument `4' is y axis title in quotes */
	/* 5th argument `5' is x axis title in quotes */
	/* Sample: margeffect X Z XtimesZ "Marginal Effect of X" "Level of Z" */
	
	/* The original program file is from Brambor, Clark and Golder.  See https://files.nyu.edu/mrg217/public/interaction.html.  Modifications to appearance of graphs, and addition of axis labeling option, by Jonathan Hanson.*/


#delimit ;

matrix Xcol=colnumb(e(b),"`1'");
scalar Xnum=Xcol[1,1];
matrix Zcol=colnumb(e(b),"`2'");
scalar Znum=Zcol[1,1];
matrix XZcol=colnumb(e(b),"`3'");
scalar XZnum=XZcol[1,1];

egen zmin = min(`2');
egen zmax = max(`2');
gen z0 = (((_n-1)/(20-1))*(zmax-zmin))+zmin in 1/20;
generate MV=z0;



*     ****************************************************************  *;
*       Grab elements of the coefficient and variance-covariance matrix *;
*       that are required to calculate the marginal effect and standard *;
*       errors.                                                         *;
*     ****************************************************************  *;

matrix b=e(b); 
matrix V=e(V);
 
scalar b1=b[1,Xnum]; 
scalar b2=b[1,Znum];
scalar b3=b[1,XZnum];


scalar varb1=V[Xnum,Xnum]; 
scalar varb2=V[Znum,Znum]; 
scalar varb3=V[XZnum,XZnum];

scalar covb1b3=V[Xnum,XZnum]; 
scalar covb2b3=V[Znum,XZnum];



*     ****************************************************************  *;
*       Calculate the marginal effect of X on Y for all MV values of    *;
*       the modifying variable Z.                                       *;
*     ****************************************************************  *;
#delimit;
gen conb=b1+b3*MV;


*     ****************************************************************  *;
*       Calculate the standard errors for the marginal effect of X on Y *;
*       for all MV values of the modifying variable Z.                  *;
*     ****************************************************************  *;
#delimit;
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV); 


*     ****************************************************************  *;
*       Generate upper and lower bounds of the confidence interval.     *;
*       Specify the significance of the confidence interval.            *;
*     ****************************************************************  *;

gen a=1.96*conse;
 
gen upper=conb+a;
 
gen lower=conb-a;

*     ****************************************************************  *;
*       Graph the marginal effect of X on Y across the desired range of *;
*       the modifying variable Z.  Show the confidence interval.        *;
*     ****************************************************************  *;

graph twoway line conb   MV, clwidth(thin) clcolor(blue) clcolor(black)
        ||   line upper  MV, clpattern(dot) clwidth(medthin) clcolor(gs0)
        ||   line lower  MV, clpattern(dot) clwidth(medthin) clcolor(gs0)
        ||   ,   
		 xlabel(, labsize(3)) 
             ylabel(, labsize(3))
		 legend(off)
             yline(0, lcolor(gs4) lwidth(vvthin) lpatter(dash))   
             xtitle(`5', size(4)  margin(small))
             xsca(titlegap(1.5))
             ysca(titlegap(1.5))
             ytitle(`4', margin(small) size(4))
             xsize(6.5) ysize(4.25)
             scheme(s1mono) aspectratio(.60) graphregion(fcolor(white));
             
*     ****************************************************************  *;
*                 Figure can be saved in a variety of formats.          *;
*     ****************************************************************  *; 



*     ****************************************************************  *;
*                                   THE END                             *;
*     ****************************************************************  *;


drop zmin zmax z0 MV conb conse a upper lower;

end;
