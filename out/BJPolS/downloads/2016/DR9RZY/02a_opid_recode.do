/* This do file is called by bhps_gen.do

 It fixes enumerator/data entry errors in egoaltcomplete.dta that are identified when imposing the rule that birth parent may not
 change over time. */


 
* The following changes do not require wave qualifiers since they refer to natural (i.e., birth) mother/father.


/* Grandmother misidentified as "natural mother" in hhold's entry into sample (wave 9) but correctly identified in all subsequent 
   (waves 10-18).  It is clear that this is grandmother from both respondents' relationships with others in hhold. */
replace rel=17 if pid==95039244 & opid==95039279 
replace rel=16 if pid==95039279 & opid==95039244

/* Grandmother misidentified as "natural mother" in hhold's entry into sample (wave 11) but correctly identified in all subsequent 
   (waves 12-18)--except wave 17 when ego was mysteriously "undefined".  It is clear that this is grandmother from both respondents' 
   relationships with others in hhold. */
replace rel=17 if pid==118969439 & opid==118969528   
replace rel=16 if pid==118969528 & opid==118969439

/* Grandmother misidentified as "natural mother" in hhold's entry into sample (wave 11) but correctly identified in all subsequent 
   (waves 12-18)--except wave 14 when ego was mysteriously "undefined" and wave 15 where he is "adopted child". */
replace rel=17 if pid==119086999 & opid==119087103 
replace rel=16 if pid==119087103 & opid==119086999



* The following changes are wave-specific as the relationship may change over time.


/* Stepfather misidentified as natural father in waves 5-9, identified correctly as stepfather in waves 10-11, and incorrectly as
   natural father in waves 12-14.  It is clear that this is not the natural father. */
replace rel=25 if pid==11610077 & opid==46558039 & inrange(wave,5,14)
replace rel=7 if pid==46558039 & opid==11610077 & inrange(wave,5,14)   
   
/* One man is identified as natural father in waves 7-11, and a different man as natural father in waves 12-18.  Evidence from
   other hhold members does not clarify.  We default to the first as being the "natural father" and the second as miscategorized. */
replace rel=7 if pid==122483855 & opid==76094588 & inrange(wave,12,18)
replace rel=25 if pid==76094588 & opid==122483855 & inrange(wave,12,18)   
      
/* One woman is identified as natural mother in waves 13-15, and a different woman as natural mother in waves 16-18.
   Both women are only present in the survey for those waves.  Evidence from the natural father does not clarify.  
   We default to the first as being the "natural mother" and the second as miscategorized. */
replace rel=25 if pid==134718178 & opid==85065889 & inrange(wave,16,18)  
replace rel=7 if pid==85065889 & opid==134718178 & inrange(wave,16,18)
   
/* One man is identified as natural father in waves 6-17 and different man as natural father in wave 18.  Evidence from natural mother 
   does not clarify.  The twist is that the wave 18 father was natural mother's legal husband before ego's birth.  
   Neither man is a hhold member in wave of ego's birth.  We default to wave 6-17 father due to precedence and length of reported 
   relationship. */   
replace rel=25 if pid==52147738 & opid==23830751 & wave==18   
replace rel=7 if pid==23830751 & opid==52147738 & wave==18   
   	  
/* Stepmother misidentified as "natural mother" in hhold's entry into sample (wave 9) but correctly identified in all subsequent 
   (waves 10-11).  In wave 12-13, ego went to live with his natural mother, then left the sample.  */
replace rel=25 if pid==97401234 & opid==97401218 & wave==9
replace rel=7  if pid==97401218 & opid==97401234 & wave==9

/* Foster mother (of two sisters) misidentified as natural mother.  We know "foster" (vs. adopted) from foster father's code. */
replace rel=6 if pid==174108745 & opid==26075261 & wave==18 
replace rel=6 if pid==174108745 & opid==92759068 & wave==18
replace rel=14 if pid==26075261 & opid==174108745 & wave==18
replace rel=14 if pid==92759068 & opid==174108745 & wave==18

/* Foster mother incorrectly identified as natural mother.  We know "foster" (vs. adopted) from foster father's code.  Ego 
   lived with her natural mother in waves 1-12, missing from sample in wave 13, with foster parents in wave 14, then returned to 
   live with natural mother in waves 15-16 ... */
replace rel=6 if pid==144675919 & opid==13224549 & wave==14
replace rel=14 if pid==13224549 & opid==144675919 & wave==14

/* ... meanwhile, her natural brother, who had also lived with their natural mother in waves 1-12 (although missing from sample 
   in wave 5), also went missing from the sample in wave 13, and went to live with different foster parents.  In his case as well, 
   his foster mother was misidentified as natural mother in wave 14.  We know "foster" (vs. adopted) from foster father's code 
   in wave 14 ... */
replace rel=6 if pid==144525844 & opid==13224573 & wave==14   
replace rel=14 if pid==13224573 & opid==144525844 & wave==14

/* ... unfortunately, while the brother's foster mother was later (in wave 15) correctly identified as "other parent", in that wave 
   his foster father misidentified as "natural father".  After wave 15, having suitably wreaked havoc on the BHPS, the brother
   left the sample. */
replace rel=14 if pid==13224573 & opid==144525879 & wave==15
replace rel=6 if pid==144525879 & opid==13224573 & wave==15
