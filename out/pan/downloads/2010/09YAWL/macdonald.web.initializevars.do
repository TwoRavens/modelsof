version 6.0 
#delimit ;
program define initvar ;
   while "`1'"~="" {;
               capture confirm new variable `1' ;
               if (_rc==0) {;
                       gen `1'=0;
               };
              else display "`1' previously generated" ;
              macro shift ;
   };
end;
