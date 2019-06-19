/********************************************************
  TIMING OF EVENTS LIKELIHOOD

WITH ADJUSTMENT FOR ADMINISTRATIVE REMOVAL !!

    - ONE MAIN PROCES (time measure since start of process)
    - ONE OR TWO TREATMENT PROCESSES (ALTERNATING)
       time of treatment measured since start of that process
        (NB not necessary equal to time in main process)

USING  MULTIVARIATE COMPETING RISKS MIXED PROPORTIONAL HAZARD:
    - EXPONENTIAL BASELINE (OR PIECEWISE CONSTANT (alpha_k), after stplit):
         lambda_m(t|x_m,v_m) = v_m exp(alpha_km+beta_m*x_m)
         m = 2...., M
       
    - DISCRETE UNOBSERVED HETEROGENEITY (2 FACTOR MODEL)
       
       Pr(V1=V11) = P1;  Pr(V1=1/V11) = 1-P1
m> 2   Pr(Vm=Vm1) = P1*P2;  
       Pr(Vm=Vm2) = (1-P1)*P2;  
       Pr(Vm=Vm3) = P1*(1-P2);  
       Pr(Vm=Vm4) = (1-P1)*(1-P2);  
      
with   V11=exp(a_11); 
       Vm1=exp(a_m1+a_m2); 
       Vm2=exp(-a_m1+a_m2); 
       Vm3=exp(a_m1-a_m2); 
       Vm4=exp(-a_m1-a_m2); 
  
  and P1= exp(th1)/(1+exp(th1))
      P2= exp(th2)/(1+exp(th2))
       
Data setup:
   run for each event STSET and create: tm0 = _t0, tm=_t
      (carefull with piecewise constant!)
       dm (= _d for mth event)

- make global ID: id for heterogeneity

TOEadmin1: 1 treatment process

TOEadmin2: 2 (alternating) treatment processes

*******************************************************/

******  ONE TREATMENT PROCESS **********
capture program drop TOEadmin1
program TOEadmin1
  version 9.0
  args todo b lnf g 

  tempvar beta1 gam1 beta2
  tempvar a11 a12 a21 a22 
  tempname logitp1  logitp2 
  mleval `beta1' = `b', eq(1)
  mleval `beta2' = `b', eq(2)
  mleval `gam1' = `b', eq(3)
  mleval `a11' = `b', eq(4) scalar
  mleval `a21' = `b', eq(5) scalar
  mleval `a22' = `b', eq(6) scalar
  mleval `logitp1' = `b', eq(7) scalar
  mleval `logitp2' = `b', eq(8) scalar

/* main process */
  local t0 = "$ML_y1" 
  local t1 = "$ML_y2"
  local d1 = "$ML_y3" /* event indicator */
/* treament process */
  local dt0 = "$ML_y4" 
  local dt1 = "$ML_y5"
  local d2 = "$ML_y6"
  local I2 = "$ML_y7" /* I(t> t_tr) */  
  local admin = "$ML_y8" /*indicator of admin removal */ 

  local by "by $ID" 

 quietly {
/* Calculate the log-likelihood */

  scalar `logitp1'=cond(`logitp1'<-20,-20,`logitp1')
  scalar `logitp1'=cond(`logitp1'>20,20,`logitp1')
  scalar `logitp2'=cond(`logitp2'<-20,-20,`logitp2')
  scalar `logitp2'=cond(`logitp2'>20,20,`logitp2')

  tempname p1 p2 
  tempvar sumb1a sumb1b sumb2a sumb2b sumb2c sumb2d
  tempvar haz1a haz1b haz2a haz2b haz2c haz2d
  tempvar inthaz1 inthaz2 inthaz3 inthaz4 
  tempvar suminthaz1 suminthaz2 suminthaz3 suminthaz4 
  tempvar admin1 admin2 admin3 admin4 
  tempvar pi1 pi2 pi3 pi4
  tempvar last suml lnfi

  scalar `p1' = invlogit(`logitp1')
  scalar `p2' = invlogit(`logitp2')
	
  `by': gen double `sumb1a'= sum(`d1'*(`beta1'+`a11'+`I2'*`gam1')) if $ML_samp
  `by': gen double `sumb1b'= sum(`d1'*(`beta1'-`a11'+`I2'*`gam1')) if $ML_samp
  `by': gen double `sumb2a'= sum(`d2'*(`beta2'+`a21'+`a22')) if $ML_samp
  `by': gen double `sumb2b'= sum(`d2'*(`beta2'+`a21'-`a22')) if $ML_samp
  `by': gen double `sumb2c'= sum(`d2'*(`beta2'-`a21'+`a22')) if $ML_samp
  `by': gen double `sumb2d'= sum(`d2'*(`beta2'-`a21'-`a22')) if $ML_samp

  `by': gen double `haz1a'=exp(`sumb1a'[_N]) if $ML_samp
  `by': gen double `haz1b'=exp(`sumb1b'[_N]) if $ML_samp
  `by': gen double `haz2a'=exp(`sumb2a'[_N]) if $ML_samp
  `by': gen double `haz2b'=exp(`sumb2b'[_N]) if $ML_samp
  `by': gen double `haz2c'=exp(`sumb2c'[_N]) if $ML_samp
  `by': gen double `haz2d'=exp(`sumb2d'[_N]) if $ML_samp

 `by': gen double `inthaz1'= ///
    exp(`beta1'+`a11'+`I2'*`gam2'')*(`t1'-`t0') + ///
    exp(`beta2'+`a21'+`a22')*(`dt1'-`dt0')  if $ML_samp
 `by': gen double `inthaz2'= ///
    exp(`beta1'+`a11'+`I2'*`gam2')*(`t1'-`t0') + ///
    exp(`beta2'+`a21'-`a22')*(`dt1'-`dt0')  if $ML_samp
 `by': gen double `inthaz3'= ///
    exp(`beta1'-`a11'+`I2'*`gam2')*(`t1'-`t0') + ///
    exp(`beta2'-`a21'+`a22')*(`dt1'-`dt0')  if $ML_samp
 `by': gen double `inthaz4'= ///
    exp(`beta1'-`a11'+`I2'*`gam2')*(`t1'-`t0') + ///
    exp(`beta2'-`a21'-`a22')*(`dt1'-`dt0') if $ML_samp

 `by': gen double `suminthaz1'= ///
           sum((1-`admin')*`inthaz1') if $ML_samp
 `by': gen double `suminthaz2'= ///
           sum((1-`admin')*`inthaz2') if $ML_samp
 `by': gen double `suminthaz3'= ///
           sum((1-`admin')*`inthaz3') if $ML_samp
 `by': gen double `suminthaz4'= ///
           sum((1-`admin')*`inthaz4') if $ML_samp

  gen double `num1' = 1 - exp(-`inthaz1') if $ML_samp
  gen double `num2' = 1 - exp(-`inthaz2') if $ML_samp
  gen double `num3' = 1 - exp(-`inthaz3') if $ML_samp
  gen double `num4' = 1 - exp(-`inthaz4') if $ML_samp

  `by': gen double `admin1'= sum(`admin'*ln(`num1')) if $ML_samp
  `by': gen double `admin2'= sum(`admin'*ln(`num2')) if $ML_samp
  `by': gen double `admin3'= sum(`admin'*ln(`num3')) if $ML_samp
  `by': gen double `admin4'= sum(`admin'*ln(`num4')) if $ML_samp

  `by': gen double `pi1'=`haz1a'*`haz2a'*exp(-`suminthaz1'[_N])* ///
                   exp(`admin1'[_N]) if $ML_samp
  `by': gen double `pi2'=`haz1a'*`haz2b'*exp(-`suminthaz2'[_N])* ///
                   exp(`admin2'[_N]) if $ML_samp
  `by': gen double `pi3'=`haz1b'*`haz2c'*exp(-`suminthaz3'[_N])* ///
                   exp(`admin3'[_N]) if $ML_samp
  `by': gen double `pi4'=`haz1b'*`haz2d'*exp(-`suminthaz4'[_N])* ///
                  exp(`admin4'[_N]) if $ML_samp
    
   gen double `suml' = `p1'*`p2'*`pi1'+ `p1'*(1-`p2')*`pi2' + ///
          (1-`p1')*`p2'*`pi3' +  (1-`p1')*(1-`p2')*`pi4'  if $ML_samp

  `by': gen byte `last' = (_n==_N)
  mlsum `lnf' = ln( `suml') if `last'==1

/* Calculate the gradient */
  if ( `todo'==0 | `lnf'>=.) exit

  tempname gb1 gb2 ga11 ga21 ga22 gth1 gth2 gb1g 
  tempvar delta1a delta1b delta2a delta2b delta2c delta2d
  tempvar delta1ag delta1bg 

   gen double `delta1a'= (`p1'*`p2'*`pi1'* ///
   ( (1-`admin')*(`d1' -  exp(`beta1'+`a11'+`I2'*`gam2')*(`t1'-`t0') ) + ///
     `admin'*(exp(-`inthaz1')*exp(`beta1'+`a11'+`I2'*`gam2')*(`t1'-`t0') ///
           )/`num1') +  `p1'*(1-`p2')*`pi2'* ///
 ( (1-`admin')*(`d1' -  exp(`beta1'+`a11'+`I2'*`gam2')*(`t1'-`t0') ) + ///
     `admin'*(exp(-`inthaz2')*exp(`beta1'+`a11'+`I2'*`gam2')*(`t1'-`t0') ///
             )/`num2')  )/`suml'  if $ML_samp

 gen double `delta1b'=( (1-`p1')*`p2'*`pi3'* ///
   ( (1-`admin')*(`d1' -  exp(`beta1'-`a11'+`I2'*`gam2')*(`t1'-`t0') ) + ///
     `admin'*(exp(-`inthaz3')*exp(`beta1'-`a11'+`I2'*`gam2')*(`t1'-`t0') ///
        )/`num3') +  (1-`p1')*(1-`p2')*`pi4'* ///
 ( (1-`admin')*(`d1' -  exp(`beta1'-`a11'+`I2'*`gam2')*(`t1'-`t0') ) + ///
     `admin'*(exp(-`inthaz4')*exp(`beta1'-`a11'+`I2'*`gam2')*(`t1'-`t0') ///
            )/`num4') )/`suml'  if $ML_samp

 gen double `delta1ag' = `I2'*`delta1a'
 gen double `delta1bg' = `I2'*`delta1b'

  gen double `delta2a' = `p1'*`p2'*`pi1'*( ///
    (1-`admin')*(`d2' -  exp(`beta2'+`a21'+ `a22')*(`dt1'-`dt0') ) + ///
     `admin'*(exp(-`inthaz1')*exp(`beta2'+`a21'+ `a22')*(`dt1'-`dt0') ///
          )/`num1'  )/`suml'  if $ML_samp
  gen double `delta2b' = `p1'*(1-`p2')*`pi2'*( ///
    (1-`admin')*(`d2' -  exp(`beta2'+`a21'- `a22')*(`dt1'-`dt0') ) + ///
     `admin'*(exp(-`inthaz2')*exp(`beta2'+`a21'- `a22')*(`dt1'-`dt0') ///
          )/`num2'   )/`suml'  if $ML_samp
  gen double `delta2c' = (1-`p1')*`p2'*`pi3'*( ///
    (1-`admin')*(`d2' -  exp(`beta2'-`a21'+ `a22')*(`dt1'-`dt0') ) + ///
     `admin'*(exp(-`inthaz3')*exp(`beta2'-`a21'+ `a22')*(`dt1'-`dt0') ///
          )/`num3'    )/`suml'  if $ML_samp
  gen double `delta2d' = (1-`p1')*(1-`p2')*`pi4'*( ///
    (1-`admin')*(`d2' -  exp(`beta2'-`a21'- `a22')*(`dt1'-`dt0') ) + ///
     `admin'*(exp(-`inthaz4')*exp(`beta2'-`a21'-`a22')*(`dt1'-`dt0') ///
          )/`num4'    )/`suml'  if $ML_samp

 mlvecsum `lnf' `gb1' = `delta1a'+ `delta1b' , eq(1)
 mlvecsum `lnf' `gb2' = `delta2a'+`delta2b'+`delta2c'+`delta2d', eq(2)
 mlvecsum `lnf' `gb1g' = `delta1ag'+ `delta1bg' , eq(3)
 mlvecsum `lnf' `ga11' = `delta1a' - `delta1b' , eq(4)
 mlvecsum `lnf' `ga21' = `delta2a'+`delta2b'-`delta2c'-`delta2d', eq(5)
 mlvecsum `lnf' `ga22' = `delta2a'-`delta2b'+`delta2c'-`delta2d', eq(6)
 mlvecsum `lnf' `gth1' =  `p1'*(1-`p1')*(`p2'*`pi1'  + ///
      (1-`p2')*`pi2' - `p2'*`pi3' - (1-`p2')*`pi4' )/  ///
             `suml'  if `last'==1, eq(7)
 mlvecsum `lnf' `gth2' = `p2'*(1-`p2')*(`p1'*`pi1'  - ///
        `p1'*`pi2' + (1-`p1')*`pi3' - (1-`p1')*`pi4' )/  ///
             `suml'  if `last'==1, eq(8)

 matrix `g' = (`gb1',`gb2',`gb1', `ga11',`ga21',`ga22', ///
               `gth1', `gth2')

}
end

******  TWO TREATMENT PROCESSES **********
capture program drop TOEadmin2
program TOEadmin2
  version 9.0
  args todo b lnf g 

  tempvar beta1 beta2 beta3 gam2 gam3
  tempname a11 a21 a22 a31 a32 
  tempname logitp1  logitp2 
  mleval `beta1' = `b', eq(1)
  mleval `beta2' = `b', eq(2)
  mleval `beta3' = `b', eq(3)
  mleval `gam2' = `b', eq(4)
  mleval `gam3' = `b', eq(5)
  mleval `a11' = `b', eq(6) scalar
  mleval `a21' = `b', eq(7) scalar
  mleval `a22' = `b', eq(8) scalar
  mleval `a31' = `b', eq(9) scalar
  mleval `a32' = `b', eq(10) scalar
  mleval `logitp1' = `b', eq(11) scalar
  mleval `logitp2' = `b', eq(12) scalar

/* main process */
  local t0 = "$ML_y1" 
  local t1 = "$ML_y2"
  local d1 = "$ML_y3" /* event indicator */
/* treament process */
  local dt0_2 = "$ML_y4" 
  local dt1_2 = "$ML_y5"
  local d2 = "$ML_y6"
  local I2 = "$ML_y7" /* I(t> t_tr1) */  
  local dt0_3 = "$ML_y8" 
  local dt1_3 = "$ML_y9"
  local d3 = "$ML_y10"
  local I3 = "$ML_y11" /* I(t> t_tr2) */  
  local admin = "$ML_y12" /*indicator of admin removal */ 

  local by "by $ID" 

 quietly {

/* Calculate the log-likelihood */

  scalar `logitp1'=cond(`logitp1'<-20,-20,`logitp1')
  scalar `logitp1'=cond(`logitp1'>20,20,`logitp1')
  scalar `logitp2'=cond(`logitp2'<-20,-20,`logitp2')
  scalar `logitp2'=cond(`logitp2'>20,20,`logitp2')

  tempname p1 p2 
  tempvar sumb1a sumb1b sumb2a sumb2b sumb2c sumb2d
  tempvar haz1a haz1b haz2a haz2b haz2c haz2d
  tempvar inthaz1 inthaz2 inthaz3 inthaz4 
  tempvar suminthaz1 suminthaz2 suminthaz3 suminthaz4
  tempvar num1 num2 num3 num4
  tempvar admin1 admin2 admin3 admin4 
  tempvar pi1 pi2 pi3 pi4
  tempvar last suml lnfi
  tempvar sumb3a sumb3b sumb3c sumb3d
  tempvar haz3a haz3b haz3c haz3d

  scalar `p1' = invlogit(`logitp1')
  scalar `p2' = invlogit(`logitp2')
	
  `by': gen double `sumb1a'= sum(`d1'*(`beta1'+`a11'+`I2'*`gam2'+`I3'*`gam3')) if $ML_samp
  `by': gen double `sumb1b'= sum(`d1'*(`beta1'-`a11'+`I2'*`gam2'+`I3'*`gam3')) if $ML_samp
  `by': gen double `sumb2a'= sum(`d2'*(`beta2'+`a21'+`a22')) if $ML_samp
  `by': gen double `sumb2b'= sum(`d2'*(`beta2'+`a21'-`a22')) if $ML_samp
  `by': gen double `sumb2c'= sum(`d2'*(`beta2'-`a21'+`a22')) if $ML_samp
  `by': gen double `sumb2d'= sum(`d2'*(`beta2'-`a21'-`a22')) if $ML_samp

  `by': gen double `haz1a'=exp(`sumb1a'[_N]) if $ML_samp
  `by': gen double `haz1b'=exp(`sumb1b'[_N]) if $ML_samp
  `by': gen double `haz2a'=exp(`sumb2a'[_N]) if $ML_samp
  `by': gen double `haz2b'=exp(`sumb2b'[_N]) if $ML_samp
  `by': gen double `haz2c'=exp(`sumb2c'[_N]) if $ML_samp
  `by': gen double `haz2d'=exp(`sumb2d'[_N]) if $ML_samp

  `by': gen double `sumb3a'= sum(`d3'*(`beta3'+`a31'+`a32')) if $ML_samp
  `by': gen double `sumb3b'= sum(`d3'*(`beta3'+`a31'-`a32')) if $ML_samp
  `by': gen double `sumb3c'= sum(`d3'*(`beta3'-`a31'+`a32')) if $ML_samp
  `by': gen double `sumb3d'= sum(`d3'*(`beta3'-`a31'-`a32')) if $ML_samp
  `by': gen double `haz3a'=exp(`sumb3a'[_N]) if $ML_samp
  `by': gen double `haz3b'=exp(`sumb3b'[_N]) if $ML_samp
  `by': gen double `haz3c'=exp(`sumb3c'[_N]) if $ML_samp
  `by': gen double `haz3d'=exp(`sumb3d'[_N]) if $ML_samp

  `by': gen double `inthaz1'= ///
    exp(`beta1'+`a11'+`I2'*`gam2'+`I3'*`gam3')*(`t1'-`t0') + ///
    exp(`beta2'+`a21'+`a22')*(`dt1_2'-`dt0_2') + ///
    exp(`beta3'+`a31'+`a32')*(`dt1_3'-`dt0_3') if $ML_samp
 `by': gen double `inthaz2'= ///
    exp(`beta1'+`a11'+`I2'*`gam2'+`I3'*`gam3')*(`t1'-`t0') + ///
    exp(`beta2'+`a21'-`a22')*(`dt1_2'-`dt0_2') + ///
    exp(`beta3'+`a31'-`a32')*(`dt1_3'-`dt0_3') if $ML_samp
 `by': gen double `inthaz3'= ///
    exp(`beta1'-`a11'+`I2'*`gam2'+`I3'*`gam3')*(`t1'-`t0') + ///
    exp(`beta2'-`a21'+`a22')*(`dt1_2'-`dt0_2') + ///
    exp(`beta3'-`a31'+`a32')*(`dt1_3'-`dt0_3') if $ML_samp
 `by': gen double `inthaz4'= ///
    exp(`beta1'-`a11'+`I2'*`gam2'+`I3'*`gam3')*(`t1'-`t0') + ///
    exp(`beta2'-`a21'-`a22')*(`dt1_2'-`dt0_2') + ///
    exp(`beta3'-`a31'-`a32')*(`dt1_3'-`dt0_3') if $ML_samp

 `by': gen double `suminthaz1'= ///
           sum((1-`admin')*`inthaz1') if $ML_samp
 `by': gen double `suminthaz2'= ///
           sum((1-`admin')*`inthaz2') if $ML_samp
 `by': gen double `suminthaz3'= ///
           sum((1-`admin')*`inthaz3') if $ML_samp
 `by': gen double `suminthaz4'= ///
           sum((1-`admin')*`inthaz4') if $ML_samp

  gen double `num1' = 1 - exp(-`inthaz1') if $ML_samp
  gen double `num2' = 1 - exp(-`inthaz2') if $ML_samp
  gen double `num3' = 1 - exp(-`inthaz3') if $ML_samp
  gen double `num4' = 1 - exp(-`inthaz4') if $ML_samp

  `by': gen double `admin1'= sum(`admin'*ln(`num1')) if $ML_samp
  `by': gen double `admin2'= sum(`admin'*ln(`num2')) if $ML_samp
  `by': gen double `admin3'= sum(`admin'*ln(`num3')) if $ML_samp
  `by': gen double `admin4'= sum(`admin'*ln(`num4')) if $ML_samp

  `by': gen double `pi1'=`haz1a'*`haz2a'*`haz3a'*exp(-`suminthaz1'[_N])* ///
                   exp(`admin1'[_N]) if $ML_samp
  `by': gen double `pi2'=`haz1a'*`haz2b'*`haz3b'*exp(-`suminthaz2'[_N])* ///
                   exp(`admin2'[_N]) if $ML_samp
  `by': gen double `pi3'=`haz1b'*`haz2c'*`haz3c'*exp(-`suminthaz3'[_N])* ///
                   exp(`admin3'[_N]) if $ML_samp
  `by': gen double `pi4'=`haz1b'*`haz2d'*`haz3d'*exp(-`suminthaz4'[_N])* ///
                  exp(`admin4'[_N]) if $ML_samp
    
   gen double `suml' = `p1'*`p2'*`pi1'+ `p1'*(1-`p2')*`pi2' + ///
          (1-`p1')*`p2'*`pi3' +  (1-`p1')*(1-`p2')*`pi4'  if $ML_samp

  `by': gen byte `last' = (_n==_N)
  mlsum `lnf' = ln( `suml') if `last'==1

/* Calculate the gradient */
  if ( `todo'==0 | `lnf'>=.) exit

  tempname gb1 gb2 ga11 ga21 ga22 gth1 gth2 
  tempvar delta1a delta1b delta2a delta2b delta2c delta2d
  tempname gb3 ga31 ga32  
  tempvar delta3a delta3b delta3c delta3d
  tempname gb1g2 gb1g2 gb1g3
  tempvar delta1ag2 delta1bg2 delta1ag3 delta1bg3
 
  gen double `delta1a'= (`p1'*`p2'*`pi1'* ///
   ( (1-`admin')*(`d1' -  exp(`beta1'+`a11'+`I2'*`gam2'+`I3'*`gam3')*(`t1'-`t0') ) + ///
     `admin'*(exp(-`inthaz1')*exp(`beta1'+`a11'+`I2'*`gam2'+`I3'*`gam3')*(`t1'-`t0') ///
           )/`num1') +  `p1'*(1-`p2')*`pi2'* ///
 ( (1-`admin')*(`d1' -  exp(`beta1'+`a11'+`I2'*`gam2'+`I3'*`gam3')*(`t1'-`t0') ) + ///
     `admin'*(exp(-`inthaz2')*exp(`beta1'+`a11'+`I2'*`gam2'+`I3'*`gam3')*(`t1'-`t0') ///
             )/`num2')  )/`suml'  if $ML_samp

 gen double `delta1b'=( (1-`p1')*`p2'*`pi3'* ///
   ( (1-`admin')*(`d1' -  exp(`beta1'-`a11'+`I2'*`gam2'+`I3'*`gam3')*(`t1'-`t0') ) + ///
     `admin'*(exp(-`inthaz3')*exp(`beta1'-`a11'+`I2'*`gam2'+`I3'*`gam3')*(`t1'-`t0') ///
        )/`num3') +  (1-`p1')*(1-`p2')*`pi4'* ///
 ( (1-`admin')*(`d1' -  exp(`beta1'-`a11'+`I2'*`gam2'+`I3'*`gam3')*(`t1'-`t0') ) + ///
     `admin'*(exp(-`inthaz4')*exp(`beta1'-`a11'+`I2'*`gam2'+`I3'*`gam3')*(`t1'-`t0') ///
            )/`num4') )/`suml'  if $ML_samp

  gen double `delta1ag2' = `I2'*`delta1a'  
  gen double `delta1bg2' = `I2'*`delta1b'
  gen double `delta1ag3' = `I3'*`delta1a'
  gen double `delta1bg3' = `I3'*`delta1b'
  gen double `delta2a' = `p1'*`p2'*`pi1'*( ///
    (1-`admin')*(`d2' -  exp(`beta2'+`a21'+ `a22')*(`dt1_2'-`dt0_2') ) + ///
     `admin'*(exp(-`inthaz1')*exp(`beta2'+`a21'+ `a22')*(`dt1_2'-`dt0_2') ///
          )/`num1'  )/`suml'  if $ML_samp
  gen double `delta2b' = `p1'*(1-`p2')*`pi2'*( ///
    (1-`admin')*(`d2' -  exp(`beta2'+`a21'- `a22')*(`dt1_2'-`dt0_2') ) + ///
     `admin'*(exp(-`inthaz2')*exp(`beta2'+`a21'- `a22')*(`dt1_2'-`dt0_2') ///
          )/`num2'   )/`suml'  if $ML_samp
  gen double `delta2c' = (1-`p1')*`p2'*`pi3'*( ///
    (1-`admin')*(`d2' -  exp(`beta2'-`a21'+ `a22')*(`dt1_2'-`dt0_2') ) + ///
     `admin'*(exp(-`inthaz3')*exp(`beta2'-`a21'+ `a22')*(`dt1_2'-`dt0_2') ///
          )/`num3'    )/`suml'  if $ML_samp
  gen double `delta2d' = (1-`p1')*(1-`p2')*`pi4'*( ///
    (1-`admin')*(`d2' -  exp(`beta2'-`a21'- `a22')*(`dt1_2'-`dt0_2') ) + ///
     `admin'*(exp(-`inthaz4')*exp(`beta2'-`a21'-`a22')*(`dt1_2'-`dt0_2') ///
          )/`num4'    )/`suml'  if $ML_samp
  gen double `delta3a' = `p1'*`p2'*`pi1'*( ///
    (1-`admin')*(`d3' -  exp(`beta3'+`a31'+ `a32')*(`dt1_3'-`dt0_3') ) + ///
     `admin'*(exp(-`inthaz1')*exp(`beta3'+`a31'+ `a32')*(`dt1_3'-`dt0_3') ///
          )/`num1'    )/`suml'  if $ML_samp
  gen double `delta3b' = `p1'*(1-`p2')*`pi2'*( ///
    (1-`admin')*(`d3' -  exp(`beta3'+`a31'- `a32')*(`dt1_3'-`dt0_3') ) + ///
     `admin'*(exp(-`inthaz2')*exp(`beta3'+`a31'- `a32')*(`dt1_3'-`dt0_3') ///
          )/`num2'    )/`suml'  if $ML_samp
  gen double `delta3c' = (1-`p1')*`p2'*`pi3'*( ///
    (1-`admin')*(`d3' -  exp(`beta3'-`a31'+ `a32')*(`dt1_3'-`dt0_3') ) + ///
     `admin'*(exp(-`inthaz3')*exp(`beta3'-`a31'+ `a32')*(`dt1_3'-`dt0_3') ///
          )/`num3'    )/`suml'  if $ML_samp
  gen double `delta3d' = (1-`p1')*(1-`p2')*`pi4'*( ///
    (1-`admin')*(`d3' -  exp(`beta3'-`a31'- `a32')*(`dt1_3'-`dt0_3') ) + ///
     `admin'*(exp(-`inthaz4')*exp(`beta3'-`a31'-`a32')*(`dt1_3'-`dt0_3') ///
         )/`num4'     )/`suml'  if $ML_samp

 mlvecsum `lnf' `gb1' = `delta1a'+ `delta1b' , eq(1)
 mlvecsum `lnf' `gb2' = `delta2a'+`delta2b'+`delta2c'+`delta2d', eq(2)
 mlvecsum `lnf' `gb3' = `delta3a'+`delta3b'+`delta3c'+`delta3d', eq(3)
 mlvecsum `lnf' `gb1g2' = `delta1ag2'+ `delta1bg2' , eq(4)
 mlvecsum `lnf' `gb1g3' = `delta1ag3'+ `delta1bg3' , eq(5)
 mlvecsum `lnf' `ga11' = `delta1a' - `delta1b' , eq(6)
 mlvecsum `lnf' `ga21' = `delta2a'+`delta2b'-`delta2c'-`delta2d', eq(7)
 mlvecsum `lnf' `ga22' = `delta2a'-`delta2b'+`delta2c'-`delta2d', eq(8)
 mlvecsum `lnf' `ga31' = `delta3a'+`delta3b'-`delta3c'-`delta3d', eq(9)
 mlvecsum `lnf' `ga32' = `delta3a'-`delta3b'+`delta3c'-`delta3d', eq(10)
 mlvecsum `lnf' `gth1' =  `p1'*(1-`p1')*(`p2'*`pi1'  + ///
      (1-`p2')*`pi2' - `p2'*`pi3' - (1-`p2')*`pi4' )/  ///
             `suml'  if `last'==1, eq(11)
 mlvecsum `lnf' `gth2' = `p2'*(1-`p2')*(`p1'*`pi1'  - ///
        `p1'*`pi2' + (1-`p1')*`pi3' - (1-`p1')*`pi4' )/  ///
             `suml'  if `last'==1, eq(12)

 matrix `g' = (`gb1',`gb2',`gb3', `gb1g2',`gb1g3',`ga11',`ga21',`ga22', ///
               `ga31',`ga32', `gth1', `gth2')

}
end

