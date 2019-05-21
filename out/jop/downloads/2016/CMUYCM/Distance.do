
** THIS FILE IS BUILDING ON "distanskod_msldh.DO" FROM 'POWER OF PARTIES' (Fiva, Folke and Sørensen, 2016)


/**************************************Program definitions************************************************/
/**************************************Program definitions************************************************/


****************************************************/
/* define program to define minimal distance to seat change          */
/****************************************************/

capture program drop calmindiff_msl
program calmindiff_msl
  args namelist namelist2
   gen start=0
  foreach parti in `namelist'{
    gen spr`parti' =pr`parti'         /* CHANGE HERE IF OBTAIN DATA ON LISTESTEMMER */
	gen m`parti' = mslm`parti'
  }
 
   foreach parti in `namelist'{
   	gen p`parti'=m`parti'>0 & m`parti'!=.
		gen p1`parti'=m`parti'==1

		}

**define comparison numbers*******
   foreach parti in `namelist'{
		gen j`parti'=spr`parti'*(1-p`parti')/1.4 +spr`parti'*p`parti'/(1+2*m`parti')
		}

   foreach parti in `namelist'{
		gen j2`parti'=spr`parti'*(p1`parti')/1.4 +spr`parti'*(1-p1`parti')/(1+2*(m`parti'-1)) if m`parti'>0 &  m`parti'!=.
		}

	

***define minimal and maximal comparison numbers*******
	gen maxj1=0 
	 foreach parti in `namelist'{
		replace maxj1= j`parti' if j`parti'>maxj1 & j`parti'!=.
		}

	gen minj2=100000000000000
	foreach parti in `namelist'{
		replace minj2= j2`parti' if j2`parti'<minj2 & j2`parti'!=0.
		}

		*****************ALTERNATIVE 1  ( a og c i olle-appendix) ***************************************************
	foreach parti in `namelist'{
		gen `parti'diffjminj2 =10000000000000000000
		foreach parti2 in `namelist2'{ 
		replace `parti'diffjminj2= (j2`parti2' -j`parti')  *  ((1-p`parti') * 1.4 + p`parti'*(1+2*m`parti') ) if `parti'diffjminj2> (j2`parti2' -j`parti') *  ( (1-p`parti') * 1.4 + p`parti'*(1+2*m`parti') ) &  m`parti2'>0 & m`parti2'!=. & j`parti'!=j`parti2'
		}
	}

	

***define distance to seat loss in own votes*****	


	
		foreach parti in `namelist'{
			gen `parti'diffj2maxj =100000000000000000000
			foreach parti2 in `namelist2'{ 

			replace `parti'diffj2maxj=(j2`parti' -j`parti2') * (p1`parti' *1.4 +(1-p1`parti')*(1+2*(m`parti'-1))) if `parti'diffj2maxj> (j2`parti' -j`parti2') * (p1`parti' *1.4 +(1-p1`parti')*(1+2*(m`parti'-1))) & j`parti'!=j`parti2'
			replace `parti'diffj2maxj =. if m`parti'==0 | m`parti'==.
		}
	}

	
	foreach parti in `namelist'{
		gen mindiff`parti'p1= `parti'diffjminj2 
		gen mindiff`parti'n1=`parti'diffj2maxj   if m`parti'>0 & m`parti'!=.
	}


*****************ALTERNATIVE 2 ( tilfelle b og d) ***************************************************
****define smallest distance in own votes for any party gaining a seat*********
	gen mindiffjminj2=100000000000000
	foreach parti in `namelist'{
		replace mindiffjminj2= `parti'diffjminj2 if `parti'diffjminj2<mindiffjminj2 & `parti'diffjminj2!=0 & `parti'diffjminj2!=.
		}	

***define smallest distance in own votes for any party losing a seat*********
	gen mindiffj2maxj=100000000000000
	foreach parti in `namelist'{
		replace mindiffj2maxj= `parti'diffj2maxj if `parti'diffj2maxj<mindiffj2maxj & `parti'diffj2maxj!=0 & `parti'diffj2maxj!=.
	}	


*** Define distance for a party gaining a seat through gaining votes such that j=maxj1 and another party losing votes (tilfelle d) ****
	
	foreach parti in `namelist'{
		gen mindiff`parti'p2= mindiffj2maxj  + (maxj1 -j`parti')*((1-p`parti')*1.4 +p`parti'*(1+2*m`parti'))
		replace mindiff`parti'p2=. if maxj1 < j`parti' | mindiffj2maxj== `parti'diffj2maxj
	}

*** Define distance for a party losing a seat through loosing votes such that j2=minj2 and another party gaining votes****
	foreach parti in `namelist'{
		gen mindiff`parti'n2=mindiffjminj2+ (j2`parti'-minj2 ) * (p1`parti'*1.4 + (1-p1`parti') * (1+2*(m`parti'-1) ) )  if m`parti'>0 & m`parti'!=.
		replace mindiff`parti'n2=. if j2`parti'< minj2 | mindiffjminj2== `parti'diffjminj2
	}

*****************ALTERNATIVE 3 ( tilfelle e)  ***************************************************
		
*** Define how many votes  party2 would need to lose to such that party2j<party1j****
	foreach parti in `namelist'{
		
		foreach parti2 in `namelist2'{ 
			gen `parti'`parti2'jdiff=(j`parti2' -j`parti') *((1-p`parti2')*1.4 +p`parti2'*(1+2*m`parti2')) 
			replace `parti'`parti2'jdiff =. if `parti'`parti2'jdiff < 0
		}
	}
*** Define total vote losses for other parties such that  party1j=j1max*********
 
	foreach parti in `namelist'{
		gen	`parti'sumjdiff=0 
		foreach parti2 in `namelist2'{
			replace `parti'sumjdiff= `parti'sumjdiff +`parti'`parti2'jdiff if `parti'`parti2'jdiff !=.
		}
		replace `parti'sumjdiff=. if `parti'sumjdiff==0 
	}

*** Define how many votes  party2 would need to lose such that party2j2<party1j1****

	foreach parti in `namelist'{
		foreach parti2 in `namelist2'{ 
			gen `parti'`parti2'diffj2j= (j2`parti2' -j`parti') * (p1`parti2'*1.4 +(1-p1`parti2')*(1+2*(m`parti2'-1))) if m`parti2'>0 &  m`parti2'!=.
			replace `parti'`parti2'diffj2j =. if j`parti'==j`parti2' |`parti'`parti2'diffj2j<0
		}
	}

*** Define vote minimal loss for ANY party2  such that party2j2<party1j1****
	foreach parti in `namelist'{	
	gen `parti'mindiffj2j=100000000000000
		foreach parti2 in `namelist2'{ 
			replace `parti'mindiffj2j= `parti'`parti2'diffj2j if `parti'`parti2'diffj2j<`parti'mindiffj2j & `parti'`parti2'diffj2j!=.
		}	
	}

**** Define combination of minimal loss for any party2  such that party2j2<party1j1 and ****
	**** total vote losses for other parties such that  party1j<j1max to define distance to seat gain*****
	
foreach parti in `namelist'{
	gen mindiff`parti'p3=  `parti'sumjdiff+`parti'mindiffj2j
	}
 


*** Define how many votes  party2 would need to gain to such that party2j2>party1j2****
	foreach parti in `namelist'{	
		foreach parti2 in `namelist2'{ 
			gen `parti'`parti2'j2diff=(j2`parti'-j2`parti2') *(p1`parti2'*1.4 +(1-p1`parti2')*(1+2*(m`parti2'-1))) if m`parti2'>0 & m`parti2'!=. 
			replace `parti'`parti2'j2diff=. if `parti'`parti2'j2diff<0
		}
	}

*** Define total vote gains for other parties such that  party1j2=j2min*********
 
	foreach parti in `namelist'{
		gen	`parti'sumj2diff=0 
		foreach parti2 in `namelist2'{
			replace `parti'sumj2diff= `parti'sumj2diff +`parti'`parti2'j2diff if `parti'`parti2'j2diff !=.
		}
	}

*** Define how many votes  party2 would need to gain such that party2j>party1j2****

	foreach parti in `namelist'{
		foreach parti2 in `namelist2'{ 
			gen `parti'`parti2'diffjj2=(j2`parti' -j`parti2') * ((1-p`parti2')*1.4 + p`parti2'*(1+2*m`parti2')) 
			replace `parti'`parti2'diffjj2 =. if j`parti'==j`parti2' |`parti'`parti2'diffjj2<0
		}
	}
*** Define vote minimal gain for any party2  such that party2j>party1j2****
	foreach parti in `namelist'{	
	gen `parti'mindiffjj2=100000000000000
		foreach parti2 in `namelist2'{ 
			replace `parti'mindiffjj2= `parti'`parti2'diffjj2 if `parti'`parti2'diffjj2<`parti'mindiffjj2 & `parti'`parti2'diffjj2!=.
		}	
	}
	
**** Define combination of minimal gain for any party2  such that party2j>party1j2 and ****
	**** total vote gains for other parties such that  party1j2=j2min to define disance to seat gain*****

	foreach parti in `namelist'{
	gen mindiff`parti'n3= (`parti'sumj2diff+ `parti'mindiffjj2) if m`parti'>0 & m`parti'!=.
	}

	gen stop=0

*****Define minimal distance to seat change******
	foreach parti in `namelist'{
	egen mindiff`parti'p= rowmin (mindiff`parti'p1 mindiff`parti'p2 mindiff`parti'p3 ) 
	replace mindiff`parti'p=. if mindiff`parti'p<0
	egen mindiff`parti'n= rowmin (mindiff`parti'n1 mindiff`parti'n2 mindiff`parti'n3)  if m`parti'>0 & m`parti'!=. 
	replace mindiff`parti'n=. if mindiff`parti'n<0
	}
end




/****************************************************/
/****************************************************/

/****************************************************/
/* define program to define minimal distance to seat change          */
/****************************************************/

capture program drop calmindiff_dh
program calmindiff_dh
  args namelist namelist2
  
  gen start=0
  foreach parti in `namelist'{
    gen spr`parti' =pr`parti'         /* CHANGE HERE IF OBTAIN DATA ON LISTESTEMMER */
	gen m`parti' = dhm`parti'
  }

   foreach parti in `namelist'{
   	gen p`parti'=m`parti'>0 & m`parti'!=.
		gen p1`parti'=m`parti'==1
	}

**define comparison numbers*******
   foreach parti in `namelist'{
		gen j`parti'= spr`parti'/(2+2*m`parti') if   m`parti'!=.
		}

   foreach parti in `namelist'{
		gen j2`parti'=spr`parti'/(2*m`parti') if m`parti'>0 &  m`parti'!=.
		}

	

***define minimal and maximal comparison numbers*******
	gen maxj1=0 
	 foreach parti in `namelist'{
		replace maxj1= j`parti' if j`parti'>maxj1 & j`parti'!=.
		}

	gen minj2=100000000000000
	foreach parti in `namelist'{
		replace minj2= j2`parti' if j2`parti'<minj2 & j2`parti'!=0.
		}

		*****************ALTERNATIVE 1***************************************************

		foreach parti in `namelist'{
		gen `parti'diffjminj2 =10000000000000000000
		foreach parti2 in `namelist2'{ 
		replace `parti'diffjminj2=(j2`parti2' -j`parti') *  (2+2*m`parti') if `parti'diffjminj2> (j2`parti2' -j`parti') *  (2+2*m`parti') &  m`parti2'>0 & m`parti2'!=. & j`parti'!=j`parti2'
		}
	}

	

***define distance to seat loss in own votes*****	


	
		foreach parti in `namelist'{
			gen `parti'diffj2maxj =100000000000000000000
			foreach parti2 in `namelist2'{ 

			replace `parti'diffj2maxj=(j2`parti' -j`parti2') * 2*m`parti' if `parti'diffj2maxj> (j2`parti' -j`parti2')   * 2*m`parti' & j`parti'!=j`parti2'
			replace `parti'diffj2maxj =. if m`parti'==0 | m`parti'==.
		}
	}

	
	foreach parti in `namelist'{
		gen mindiff`parti'p1= `parti'diffjminj2 
		gen mindiff`parti'n1=`parti'diffj2maxj   if m`parti'>0 & m`parti'!=.
	}
	
		
	

*****************ALTERNATIVE 2***************************************************
****define smallest distance in own votes for any party gaining a seat*********
	gen mindiffjminj2=100000000000000
	foreach parti in `namelist'{
		replace mindiffjminj2= `parti'diffjminj2 if `parti'diffjminj2<mindiffjminj2 & `parti'diffjminj2!=0 & `parti'diffjminj2!=.
		}	

***define smallest distance in own votes for any party loosing a seat*********
	gen mindiffj2maxj=100000000000000
	foreach parti in `namelist'{
		replace mindiffj2maxj= `parti'diffj2maxj if `parti'diffj2maxj<mindiffj2maxj & `parti'diffj2maxj!=0 & `parti'diffj2maxj!=.
	}	

	
*** Define distance for a party gaining a seat through gaining votes such that j=maxj1 and another party loosing votes****
	
	foreach parti in `namelist'{
		gen mindiff`parti'p2= mindiffj2maxj  + (maxj1 -j`parti')*(2+2*m`parti')
		*replace mindiff`parti'p2=. if maxj1 < j`parti' | mindiffj2maxj== `parti'diffj2maxj
		replace mindiff`parti'p2=. if maxj1 < j`parti'  /* FROM FOLKE JEEA.DO */
	
	}

*** Define distance for a party loosing a seat through loosing votes such that j2=minj2 and another party gaining votes****
	foreach parti in `namelist'{
		gen mindiff`parti'n2=mindiffjminj2+ (j2`parti'-minj2 ) * 2*m`parti' if m`parti'>0 & m`parti'!=.
		*replace mindiff`parti'n2=. if j2`parti'< minj2 | mindiffjminj2== `parti'diffjminj2
		replace mindiff`parti'n2=. if j2`parti'< minj2  /* FROM FOLKE JEEA.DO */
		}

				
*****************ALTERNATIVE 3***************************************************
		
*** Define how many votes  party2 would need to loose to such that party2j<party1j****
	foreach parti in `namelist'{
		
		foreach parti2 in `namelist2'{ 
			gen `parti'`parti2'jdiff=(j`parti2' -j`parti') *(2+2*m`parti2') 
			replace `parti'`parti2'jdiff =. if `parti'`parti2'jdiff < 0
		}
	}
*** Define total vote losses for other parties such that  party1j=j1max*********
 
	foreach parti in `namelist'{
		gen	`parti'sumjdiff=0 
		foreach parti2 in `namelist2'{
			replace `parti'sumjdiff= `parti'sumjdiff +`parti'`parti2'jdiff if `parti'`parti2'jdiff !=.
		}
	}

*** Define how many votes  party2 would need to loose such that party2j2<party1j1****

	foreach parti in `namelist'{
		foreach parti2 in `namelist2'{ 
			gen `parti'`parti2'diffj2j= (j2`parti2' -j`parti') * 2*m`parti' if m`parti2'>0 &  m`parti2'!=.
			replace `parti'`parti2'diffj2j =. if j`parti'==j`parti2' |`parti'`parti2'diffj2j<=0
		}
	}

*** Define vote minimal loss for any party2  such that party2j2<party1j1****
	foreach parti in `namelist'{	
	gen `parti'mindiffj2j=100000000000000
		foreach parti2 in `namelist2'{ 
			replace `parti'mindiffj2j= `parti'`parti2'diffj2j if `parti'`parti2'diffj2j<`parti'mindiffj2j & `parti'`parti2'diffj2j!=.
		}	
	}

**** Define combination of minimal loss for any party2  such that party2j2<party1j1 and ****
	**** total vote losses for other parties such that  party1j<j1max to define disance to seat gain*****
	
foreach parti in `namelist'{
	gen mindiff`parti'p3=  `parti'sumjdiff+`parti'mindiffj2j
	}
 


*** Define how many votes  party2 would need to gain to such that party2j2>party1j2****
	foreach parti in `namelist'{	
		foreach parti2 in `namelist2'{ 
			gen `parti'`parti2'j2diff=(j2`parti'-j2`parti2') *2*m`parti' if m`parti2'>0 & m`parti2'!=. 
			replace `parti'`parti2'j2diff=. if `parti'`parti2'j2diff<0
		}
	}

*** Define total vote gains for other parties such that  party1j2=j2min*********
 
	foreach parti in `namelist'{
		gen	`parti'sumj2diff=0 
		foreach parti2 in `namelist2'{
			replace `parti'sumj2diff= `parti'sumj2diff +`parti'`parti2'j2diff if `parti'`parti2'j2diff !=.
		}
	}

*** Define how many votes  party2 would need to gain such that party2j>party1j2****

	foreach parti in `namelist'{
		foreach parti2 in `namelist2'{ 
			gen `parti'`parti2'diffjj2=(j2`parti' -j`parti2') *(2+2*m`parti2') 
			replace `parti'`parti2'diffjj2 =. if j`parti'==j`parti2' |`parti'`parti2'diffjj2<0
		}
	}
*** Define vote minimal gain for any party2  such that party2j>party1j2****
	foreach parti in `namelist'{	
	gen `parti'mindiffjj2=100000000000000
		foreach parti2 in `namelist2'{ 
			replace `parti'mindiffjj2= `parti'`parti2'diffjj2 if `parti'`parti2'diffjj2<`parti'mindiffjj2 & `parti'`parti2'diffjj2!=.
		}	
	}
	
**** Define combination of minimal gain for any party2  such that party2j>party1j2 and ****
	**** total vote gains for other parties such that  party1j2=j2min to define disance to seat gain*****

	foreach parti in `namelist'{
	gen mindiff`parti'n3= (`parti'sumj2diff+ `parti'mindiffjj2) if m`parti'>0 & m`parti'!=.
	}

	gen stop=0

*****Define minimal distance to seat change******
	foreach parti in `namelist'{
	egen mindiff`parti'p= rowmin (mindiff`parti'p1 mindiff`parti'p2 mindiff`parti'p3 ) 
	replace mindiff`parti'p=. if mindiff`parti'p<0
	egen mindiff`parti'n= rowmin (mindiff`parti'n1 mindiff`parti'n2 mindiff`parti'n3)  if m`parti'>0 & m`parti'!=. 
	replace mindiff`parti'n=. if mindiff`parti'n<0
	}
	
	
end




/****************************************************/
/****************************************************/
/* define program to dummies from minimum distance to change  calculated measured in vote share         */
/****************************************************/

capture program drop dum_mindiffpartycalvs
program dum_mindiffpartycalvs
args namelist namelist2 

foreach lim in `namelist2' {   
   foreach parti in `namelist'{
			gen `parti'diffpcalvs`lim'=  (mindiff`parti'p)<0.0`lim'

			gen `parti'diffncalvs`lim'=  (mindiff`parti'n)<0.0`lim'
			gen `parti'_treat_`lim' =(`parti'diffncalvs`lim'-`parti'diffpcalvs`lim')*.5
			drop `parti'diffncalvs`lim'  `parti'diffpcalvs`lim' 
		}
} 


foreach lim in `namelist2' {   
   foreach parti in `namelist'{

			gen `parti'_treat_w_`lim' =`parti'_treat_`lim'/ antalmandat
		}
} 
end










/****************************************************/



/****************************************************/
/* define program to define dummies for random interval  */
/****************************************************/
capture program drop dum_diffpartyclosevs
program dum_diffpartyclosevs
args namelist namelist2
foreach lim in `namelist2' {   
   foreach parti in `namelist'{
 	gen `parti'_dum_`lim'= abs(`parti'_treat_`lim')
	}
}

foreach lim in `namelist2' {   
   foreach parti in `namelist'{
 	gen `parti'_dum_w_`lim'= `parti'_dum_`lim'/ antalmandat
	}
}
end
/****************************************************/
