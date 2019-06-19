/********************************************************
  (M)PH LIKELIHOOD

WITH ADJUSTMENT FOR ADMINISTRATIVE REMOVAL !!

 1: NO UNOBSERVED HETEROGENEITY
 2: DISCRETE UNOBSERVED HETEROGENEITY (2 FACTOR MODEL)
       (in intercept)
       Pr(V1=a11) = P1;  
       Pr(V2=1/a11) = 1-P1

   and P1= exp(th1)/(1+exp(th1))

- make global ID: id for heterogeneity

PHadmin: No unobserved heterogeneity

MPHdisadmin: Discrete unobserved heterogeneity

*******************************************************/

******  NO UNOBSERVED HETEROGENEITY **********
capture program drop PHadmin
program PHadmin
  version 9.0
  args todo b lnf g 

  tempvar beta1 
  mleval `beta1' = `b', eq(1)

/* main process */
  local t0 = "$ML_y1" 
  local t1 = "$ML_y2"
  local d1 = "$ML_y3" /* event indicator */
  local admin = "$ML_y4" /*indicator of admin removal */ 

  local by "by $ID" 

 quietly {
/* Calculate the log-likelihood */

  tempvar sumb1a haz1a  inthaz1 suminthaz1 
  tempvar admin1 num1 pi1 last suml lnfi

  `by': gen double `sumb1a'= sum(`d1'*`beta1') if $ML_samp
  `by': gen double `haz1a'=exp(`sumb1a'[_N]) if $ML_samp
  
  `by': gen double `inthaz1'=  exp(`beta1')*(`t1'-`t0')  ///
                                  if $ML_samp
  `by': gen double `suminthaz1'= ///
           sum((1-`admin')*`inthaz1') if $ML_samp

  gen double `num1' = 1 - exp(-`inthaz1') if $ML_samp
  `by': gen double `admin1'= sum(`admin'*ln(`num1')) if $ML_samp
  `by': gen double `pi1'=`haz1a'*exp(-`suminthaz1'[_N])* ///
                   exp(`admin1'[_N]) if $ML_samp
    
  `by': gen byte `last' = (_n==_N)
  mlsum `lnf' = ln( `pi1') if `last'==1

/* Calculate the gradient */
  if ( `todo'==0 | `lnf'>=.) exit

  tempname gb1 
  tempvar delta1a 

   gen double `delta1a'= `pi1'* ///
   ( (1-`admin')*(`d1' -  exp(`beta1')*(`t1'-`t0') ) + ///
     `admin'*(exp(-`inthaz1')*exp(`beta1')*(`t1'-`t0') ///
           )/`num1')/`pi1'  if $ML_samp

   mlvecsum `lnf' `gb1' = `delta1a', eq(1)
   matrix `g' = (`gb1')

}
end

******  DISCRETE UNOBSERVED HETEROGENEITY **********
capture program drop MPHdisadmin
program MPHdisadmin
  version 9.0
  args todo b lnf g 

  tempvar beta1 
  tempname a11 logitp1 
  mleval `beta1' = `b', eq(1)
  mleval `a11' = `b', eq(2) scalar
  mleval `logitp1' = `b', eq(3) scalar

/* main process */
  local t0 = "$ML_y1" 
  local t1 = "$ML_y2"
  local d1 = "$ML_y3" /* event indicator */
  local admin = "$ML_y4" /*indicator of admin removal */ 

  local by "by $ID" 

 quietly {

/* Calculate the log-likelihood */

  scalar `logitp1'=cond(`logitp1'<-20,-20,`logitp1')
  scalar `logitp1'=cond(`logitp1'>20,20,`logitp1')
 
  tempname p1  
  tempvar sumb1a sumb1b haz1a haz1b 
  tempvar inthaz1 inthaz3 suminthaz1 suminthaz3 
  tempvar num1 num3 admin1 admin3  
  tempvar pi1 pi3 last lnfi suml

  scalar `p1' = invlogit(`logitp1')
 	
  `by': gen double `sumb1a'= sum(`d1'*(`beta1'+`a11')) if $ML_samp
  `by': gen double `sumb1b'= sum(`d1'*(`beta1'-`a11')) if $ML_samp
 
  `by': gen double `haz1a'=exp(`sumb1a'[_N]) if $ML_samp
  `by': gen double `haz1b'=exp(`sumb1b'[_N]) if $ML_samp

  `by': gen double `inthaz1'= ///
    exp(`beta1'+`a11')*(`t1'-`t0') if $ML_samp
  `by': gen double `inthaz3'= ///
    exp(`beta1'-`a11')*(`t1'-`t0')  if $ML_samp
 
 `by': gen double `suminthaz1'= ///
           sum((1-`admin')*`inthaz1') if $ML_samp
 `by': gen double `suminthaz3'= ///
           sum((1-`admin')*`inthaz3') if $ML_samp
 
  gen double `num1' = 1 - exp(-`inthaz1') if $ML_samp
  gen double `num3' = 1 - exp(-`inthaz3') if $ML_samp
 
  `by': gen double `admin1'= sum(`admin'*ln(`num1')) if $ML_samp
  `by': gen double `admin3'= sum(`admin'*ln(`num3')) if $ML_samp
 
  `by': gen double `pi1'=`haz1a'*exp(-`suminthaz1'[_N])* ///
                   exp(`admin1'[_N]) if $ML_samp
  `by': gen double `pi3'=`haz1b'*exp(-`suminthaz3'[_N])* ///
                   exp(`admin3'[_N]) if $ML_samp
    
  `by': gen byte `last' = (_n==_N)
  gen double `suml' = `p1'*`pi1' + (1-`p1')*`pi3' if $ML_samp
  mlsum `lnf' = ln( `suml') if `last'==1

/* Calculate the gradient */
  if ( `todo'==0 | `lnf'>=.) exit

  tempname gb1 gb2 ga11 ga21 ga22 gth1 gth2 
  tempvar delta1a delta1b delta2a delta2b delta2c delta2d
  tempname gb3 ga31 ga32  
  tempvar delta3a delta3b delta3c delta3d
  tempname gb1g2 gb1g2 gb1g3
  tempvar delta1ag2 delta1bg2 delta1ag3 delta1bg3
 
  gen double `delta1a'= `p1'*`pi1'* ///
   ( (1-`admin')*(`d1' -  exp(`beta1'+`a11')*(`t1'-`t0') ) + ///
     `admin'*(exp(-`inthaz1')*exp(`beta1'+`a11')*(`t1'-`t0') ///
           )/`num1')/`suml'  if $ML_samp

 gen double `delta1b'= (1-`p1')*`pi3'* ///
   ( (1-`admin')*(`d1' -  exp(`beta1'-`a11')*(`t1'-`t0') ) + ///
     `admin'*(exp(-`inthaz3')*exp(`beta1'-`a11')*(`t1'-`t0') ///
        )/`num3')/`suml'  if $ML_samp

  mlvecsum `lnf' `gb1' = `delta1a' + `delta1b', eq(1)
  mlvecsum `lnf' `ga11' = `delta1a' - `delta1b' , eq(2)
  mlvecsum `lnf' `gth1' =  `p1'*(1-`p1')*(`pi1' - `pi3' )/  ///
             `suml'  if `last'==1, eq(3)
  
 matrix `g' = (`gb1',`ga11',`gth1')

}
end

