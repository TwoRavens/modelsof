recode MCAP20 (1=1)(2=.5)(3=0)(4/9=.5), into(health_308)

recode y12CAP20 (1=1)(2=.5)(3=0)(4/99=.5), into(health_712)

recode MCAP700S (6=.5) (1=0) (2=.25) (3=.5) (4=.75) (5=1) (7/99=.), into(ideol_308)

recode MCAP8 (8=4)(9/99=.), into(pid7_308)

gen pid_308 = (pid7_308-1)/6

recode PROFILE57 (1 = 0) (2=.25) (3/4 =.5) (5=.75) (6=1), into(edu)

recode PROFILE55 (2 = 1) (1=0)(3/99=0), into(black)

recode PROFILE54 (1=1)(2=0), into(male)

 recode PROFILE59 (12/14=1)(15/99=0)(1/11=0), into(highinc)
 
 recode PROFILE59 (1/5=1)(6/99=0), into(linc)
 
 gen age = 2008-birthyr
 
 recode MCAP300O (0=0) (1/2=1)(3/99=0), into(bofav_308)
 
 recode y12CAP300BO (0=0) (1/2=1)(3/99=0), into(bofav_712)
 
 recode MCAP605A (1=1)(2=0)(3/9=.), into(bovote_308)
 
  recode MCAP605A (1=1)(2=0)(3/9=.5), into(bovote3_308)
 
 recode y12CAP600 (1=1)(2=0)(3/9=.), into(bovote_712)
 
  recode y12CAP600 (1=1)(2=0)(3/9=.5), into(bovote3_712)
 
 gen votedem08_12 = bovote_712*bovote_308
 
gen ch_health = health_712 - health_308

gen ch_bovote = bovote3_712-bovote3_308


 
 
 ##################Table A9############################
 
 logit bovote_308 health_308 pid_308 ideol_308 edu highinc lowinc black male south age if votedem08_12<=1 [pweight=weight]
 
 logit	bovote_712	health_308	pid_308	ideol_308	edu	highinc	lowinc	black	male	south	age	if	votedem08_12<=1	[pweight=weight]
 
 logit bofav_308 health_308 pid_308 ideol_308 edu highinc lowinc black male south age [pweight=weight]
 
 logit bofav_712 health_308 pid_308 ideol_308 edu highinc lowinc black male south age [pweight=weight]
 
  ##################Table A10############################
  
   reg ch_health bovote_308 health_308 pid_308 ideol_308 edu highinc lowinc black male south age [pweight=weight]
   
   reg ch_bovote bovote_308 health_308 pid_308 ideol_308 edu highinc lowinc black male south age [pweight=weight]
   
   ####################Figure 5A######################################
   
 logit bovote_308 health_308 pid_308 ideol_308 edu highinc lowinc black male south age if votedem08_12<=1 [pweight=weight]
 
 adjust  pid_308 ideol_308 edu highinc lowinc black male south age, by(health_308) pr ci
 
  logit bovote_712 health_308 pid_308 ideol_308 edu highinc lowinc black male south age if votedem08_12<=1 [pweight=weight]
 
 adjust  pid_308 ideol_308 edu highinc lowinc black male south age, by(health_308) pr ci
 
 logit	bovote_712	health_308	pid_308	ideol_308	edu	highinc	lowinc	black	male	south	age	if	votedem08_12<=1	[pweight=weight]
   
   
 ####################Figure 5B######################################
 
 logit bofav_308 health_308 pid_308 ideol_308 edu highinc lowinc black male south age [pweight=weight]
 
  adjust  pid_308 ideol_308 edu highinc lowinc black male south age, by(health_308) pr ci
 

 logit bofav_712 health_308 pid_308 ideol_308 edu highinc lowinc black male south age [pweight=weight]
 
  adjust  pid_308 ideol_308 edu highinc lowinc black male south age, by(health_308) pr ci
  
  #########Figure 5C############################
  
  reg ch_bovote bovote_308 health_308 pid_308 ideol_308 edu highinc lowinc black male south age [pweight=weight]
  
  adjust bovote_308 pid_308 ideol_308 edu highinc lowinc black male south age, by(health_308) ci
  
   #########Figure 5D############################
   
   reg ch_health bovote3_308 health_308 pid_308 ideol_308 edu highinc lowinc black male south age [pweight=weight]
   
   adjust health_308 pid_308 ideol_308 edu highinc lowinc black male south age, by(bovote3_308) ci
