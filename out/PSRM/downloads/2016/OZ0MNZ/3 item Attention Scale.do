
* *********************************************************************
*
*  Create ATTENTION(3item) scale
*
* *********************************************************************
*
egen ATTENTION3=rmean(mentalnote google searchweb)
  replace ATTENTION3 = (ATTENTION3-1)/4
  label variable ATTENTION3 "Attention 3 item scale"
  
