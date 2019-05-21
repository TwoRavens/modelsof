recode v2322 (1=1) (2=.75) (3=.5) (4=.25) (5=0) (8/9=.), int(attend82)

recode v6501 (0=.) (1=1) (2=.75) (3=.5) (4=.25) (5=0) (8/9=.), int(attend97)

recode v1608 (7=.)(8=3)(9/99=.), into(pid7_82)

gen pid82 = pid7_82/6

recode v5754  (7=.)(8=3)(9/99=.), into(pid7_97)

gen pid97 = pid7_97/6

recode v5803 (0=.)(1=1) (2=0) (3/4=.)(5=.75) (6=.25)(7/99=.), into (repvote5_96)

recode v5803 (0=.)(1=1) (2=0) (3/99=.), into (repvote96)

recode v1622 (0=.) (1=1) (2=0) (5=.75) (6=.25)(3/4=.)(7/99=.), into(repvote5_80)

recode v1622 (0=.) (1=1) (2=0) (3/99=.), into(repvote80)

recode v1304 (0=.5)(1=0)(2=.1667)(3=.333)(4=.5)(5=.667)(6=.833)(7=1)(8=.5)(9/99=.), into(ideol82)

recode v231 (1=1)(2=0), into(male)

 recode v651 (1=1)(2/9=0), into(grad73)
 
 recode v2326 (1=0)(2=1)(3=0), into(black)
 
 gen votedrep9680 = repvote96*repvote80
 
 recode v1530 (98/99=.), into(carter)
 
 recode v1528(98/99=.), into(reagan)
 
 gen reag_carter = (reagan-carter)
 
 recode v5622 (97/100=97)(101/999=.), into(doletherm)
 
 recode v5624 (97/100=97)(101/999=.), into(clintontherm)
 
  gen dole_clint = (doletherm-clintontherm)
 
  recode dole_clint (-97/0=0)(1/97=1), into(dole_clinton2)
  
  recode reag_carter (-97/0=0)(1/97=1), into(reag_carter2)
  
  gen ch_attend = attend97-attend82
 
 gen ch_repvote = repvote5_96-repvote5_80
 
 ###############Table A7##############################
 
 logit repvote80 attend82 pid82 ideol82 grad73 highinc lowinc  male south_82 if votedrep9680<=1
 
 
  logit repvote96 attend82 pid82 ideol82 grad73 highinc lowinc  male south_82 if votedrep9680<=1
  
  logit reag_carter2 attend82 pid82 ideol82 grad73 highinc lowinc black male south_82 
 
 
  logit dole_clinton2 attend82 pid82 ideol82 grad73 highinc lowinc black male south_82 
  
  #####################################Table A8#####################################
  
  reg ch_repvote repvote5_80 attend82 pid82 ideol82 grad73 highinc lowinc  black male south_82 
  
    reg ch_attend repvote5_80 attend82 pid82 ideol82 grad73 highinc lowinc  black male south_82 
  
  
   
 ###############Figure 4A##############################
 
  logit repvote80 attend82 pid82 ideol82 grad73 highinc lowinc  male south_82 if votedrep9680<=1
   
  adjust pid82 ideol82 grad73 highinc lowinc  male south_82, by(attend82) pr ci
  
  logit repvote96 attend82 pid82 ideol82 grad73 highinc lowinc  male south_82 if votedrep9680<=1
  
   adjust pid82 ideol82 grad73 highinc lowinc  male south_82, by(attend82) pr ci
  
  
   ###############Figure 4B##############################
 
logit reag_carter2 attend82 pid82 ideol82 grad73 highinc lowinc black male south_82 
   
  adjust pid82 ideol82 grad73 highinc lowinc black male south_82, by(attend82) pr ci
  
   logit dole_clinton2 attend82 pid82 ideol82 grad73 highinc lowinc black male south_82 
   
   
  adjust pid82 ideol82 grad73 highinc lowinc black male south_82, by(attend82) pr ci
  
  
   ###############Figure 4C##############################
  
  reg ch_repvote repvote5_80 attend82 pid82 ideol82 grad73 highinc lowinc  black male south_82 
  
 adjust repvote5_80 pid82 ideol82 grad73 highinc lowinc  black male south_82, by(attend82) ci 
 
  ###############Figure 4D##############################
  
 
 reg ch_attend repvote5_80 attend82 pid82 ideol82 grad73 highinc lowinc  black male south_82
 
  adjust attend82 pid82 ideol82 grad73 highinc lowinc  black male south_82, by(repvote5_80 ) ci 
 
  