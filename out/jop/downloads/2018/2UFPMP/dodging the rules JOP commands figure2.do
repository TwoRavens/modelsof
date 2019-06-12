*Sarah Binder, "Dodging the Rules in Trump's Republican Congress"
*binder@gwu.edu

*These are commands to replicate logit model estimates that appear in Table A.1 and Figure 2


logit filisave running18 gop goprun18 wings leader stdrank servedmin  , robust cluster (stateid)
  coefplot, drop(_cons) xline(0) sort( , by(b))

 
 
 *notes on variables
 
 *"filisave" coded 1 if senator signed letter, 0 otherwise
 *https://www.politico.com/story/2017/04/senators-urge-save-filibuster-237014
 
 *"wings" measures absolute distance from mean chamber 1st dimension (2017) NOMINATE on http://www.voteview.com
 *note NOMINATE score for 2017 on voteview.com is Common Space score  
 *chamber mean Common Space score is .097
 *wings=abs(dim1-.097)
 
 *"rank" = 1 (longest serving), 102 (least time served)
 *https://en.wikipedia.org/wiki/Seniority_in_the_United_States_Senate
 *model standardizes rank variable
 
 *"servedmin" (various internet sources)
 
 *running18 coded 1 if senator running for re-election to Senate seat, 0 otherwise
 *gop coded 1 if Republican, 0 otherwise (independents coded 0)
 *goprun18 = running18 * gop
 
 *"leader" coded 1 if leader of either party, 0 otherwise
 * http://www.senate.gov/senators/leadership.htm 
 
 *NOTE: No observations for SESSIONS (AL), STRANGE (AL), SMITH (MN)
