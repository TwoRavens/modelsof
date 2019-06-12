************bivariate
bysort race: tab stricty votegenval, row
bysort race: tab stricty voteprival, row



****table 1 -race interactions
logit votegenval stricty newstrict blackstricty hispstricty asianstricty mixedracestricty  black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz unemp  ownhome    protestant catholic jewish atheist  days_before_election early_in_person vote_by_mail no_excuse_absence_  presidentialelectionyear     gubernatorialelectionyear senateelectionyear marginpnew  y2006 y2008 y2010 if voteregpre==1   [pw=weight] ,  cluster(inputstate)
logit voteprival stricty newstrict blackstricty hispstricty asianstricty mixedracestricty  black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz unemp  ownhome    protestant catholic jewish atheist  days_before_election early_in_person vote_by_mail no_excuse_absence_  presidentialelectionyear     gubernatorialelectionyear senateelectionyear marginpnew  y2006 y2008 y2010 if voteregpre==1   [pw=weight] ,  cluster(inputstate)
logit votegenval stricty newstrict whitestricty  white foreignb firstgen age educ inc male married childrenz unionz unemp  ownhome    protestant catholic jewish atheist  days_before_election early_in_person vote_by_mail no_excuse_absence_  presidentialelectionyear     gubernatorialelectionyear senateelectionyear marginpnew  y2006 y2008 y2010 if voteregpre==1   [pw=weight] ,  cluster(inputstate)
logit voteprival stricty newstrict whitestricty white  foreignb firstgen age educ inc male married childrenz unionz unemp  ownhome    protestant catholic jewish atheist  days_before_election early_in_person vote_by_mail no_excuse_absence_  presidentialelectionyear     gubernatorialelectionyear senateelectionyear marginpnew  y2006 y2008 y2010 if voteregpre==1   [pw=weight] ,  cluster(inputstate)

****table 2 -politics interactions
logit votegenval stricty newstrict libconnewstricty libconnew black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz unemp  ownhome    protestant catholic jewish atheist  days_before_election early_in_person vote_by_mail no_excuse_absence_  presidentialelectionyear     gubernatorialelectionyear senateelectionyear marginpnew  y2006 y2008 y2010 if voteregpre==1   [pw=weight] ,  cluster(inputstate)
logit voteprival stricty newstrict libconnewstricty libconnew black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz unemp  ownhome    protestant catholic jewish atheist  days_before_election early_in_person vote_by_mail no_excuse_absence_  presidentialelectionyear     gubernatorialelectionyear senateelectionyear marginpnew  y2006 y2008 y2010 if voteregpre==1   [pw=weight] ,  cluster(inputstate)
logit votegenval stricty newstrict pid7stricty pid7 black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz unemp  ownhome    protestant catholic jewish atheist  days_before_election early_in_person vote_by_mail no_excuse_absence_  presidentialelectionyear     gubernatorialelectionyear senateelectionyear marginpnew  y2006 y2008 y2010 if voteregpre==1   [pw=weight] ,  cluster(inputstate)
logit voteprival stricty newstrict pid7stricty pid7 black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz unemp  ownhome    protestant catholic jewish atheist  days_before_election early_in_person vote_by_mail no_excuse_absence_  presidentialelectionyear     gubernatorialelectionyear senateelectionyear marginpnew  y2006 y2008 y2010 if voteregpre==1   [pw=weight] ,  cluster(inputstate)



***diff in diff
bysort race: summ votegenval if year==2010 & state~="Mississippi" & state~="North Dakota" & state~="Texas" 
bysort race: summ votegenval if year==2010 & ( state=="Mississippi" | state=="North Dakota" | state=="Texas" )
bysort race: summ votegenval if year==2014 & state~="Mississippi" & state~="North Dakota" & state~="Texas" 
bysort race: summ votegenval if year==2014 & (  state=="Mississippi" | state=="North Dakota" | state=="Texas"  )
bysort race: summ voteprival if year==2010   & state~="Mississippi" & state~="North Dakota" & state~="Texas"  
bysort race: summ voteprival if year==2010 & (  state=="Mississippi" | state=="North Dakota" | state=="Texas"  )
bysort race: summ voteprival if year==2014   & state~="Mississippi" & state~="North Dakota" & state~="Texas"  
bysort race: summ voteprival if year==2014 & (  state=="Mississippi" | state=="North Dakota" | state=="Texas"  )
bysort pid3z: summ votegenval if year==2010   & state~="Mississippi" & state~="North Dakota" & state~="Texas"  
bysort pid3z: summ votegenval if year==2010 & (  state=="Mississippi" | state=="North Dakota" | state=="Texas"  )
bysort pid3z: summ votegenval if year==2014   & state~="Mississippi" & state~="North Dakota" & state~="Texas"  
bysort pid3z: summ votegenval if year==2014 & (  state=="Mississippi" | state=="North Dakota" | state=="Texas"  )
bysort pid3z: summ voteprival if year==2010   & state~="Mississippi" & state~="North Dakota" & state~="Texas"  
bysort pid3z: summ voteprival if year==2010 & (  state=="Mississippi" | state=="North Dakota" | state=="Texas"  )
bysort pid3z: summ voteprival if year==2014   & state~="Mississippi" & state~="North Dakota" & state~="Texas"  
bysort pid3z: summ voteprival if year==2014 & (  state=="Mississippi" | state=="North Dakota" | state=="Texas"  )
bysort libcon3: summ votegenval if year==2010   & state~="Mississippi" & state~="North Dakota" & state~="Texas"  
bysort libcon3: summ votegenval if year==2010 & (  state=="Mississippi" | state=="North Dakota" | state=="Texas"  )
bysort libcon3: summ votegenval if year==2014   & state~="Mississippi" & state~="North Dakota" & state~="Texas"  
bysort libcon3: summ votegenval if year==2014 & (  state=="Mississippi" | state=="North Dakota" | state=="Texas"  )
bysort libcon3: summ voteprival if year==2010   & state~="Mississippi" & state~="North Dakota" & state~="Texas"  
bysort libcon3: summ voteprival if year==2010 & (  state=="Mississippi" | state=="North Dakota" | state=="Texas"  )
bysort libcon3: summ voteprival if year==2014   & state~="Mississippi" & state~="North Dakota" & state~="Texas"  
bysort libcon3: summ voteprival if year==2014 & (  state=="Mississippi" | state=="North Dakota" | state=="Texas"  )
