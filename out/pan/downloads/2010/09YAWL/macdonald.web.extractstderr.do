version 6.0 
#delimit ;
program define getstde ;
tempname i n;
matrix std_errs = vecdiag(`1') ;
scalar `i'=1 ;
scalar `n'=`2' ;
*scalar list `n' ;
while `i'<=`n' {;
      matrix std_errs[1,`i']=sqrt(std_errs[1,`i']) ;
      scalar `i'=`i'+ 1 ;
};
end;
