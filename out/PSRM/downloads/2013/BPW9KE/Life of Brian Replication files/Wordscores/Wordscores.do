/***********************************************************
************************************************************
** Alexander Baturo and Slava Mikhaylov (2013). "Life of Brian Revisited: Assessing Informational and Non-Informational Leadership Tools." Political Science Research and Methods, 2013, 1(1): 139-157.
** Replication files
************************************************************
**  Wordscores replication
************************************************************
************************************************************/


*** You'll need to change the pathway for each panel estimation to the folder containing these speeches



set more off


/************************************************/
/**WITHOUT FOREIGN POLICY IN MEDVED AND PUTIN **/
/***********************************************/


/**************************************************
****            2011.txt                           ****
**************************************************/
clear all

  
  /******  using Java environment     ******/
wordfreqj *.txt

  
/* set ref. scores/texts at Medv&Put in 2010.txt */
setref tmedvedev_dom_10 -1 tputin_dom_10 1
/* descr. stats on texts */
describetext t*
/* score words for dimension of interest  */
wordscore dimension11
/* score virgin texts    */
textscore dimension11 t* 


/**************************************************
****            2010.txt                           ****
**************************************************/
clear all

  
  /******  using Java environment     ******/
wordfreqj *.txt

  
/* set ref. scores/texts at Medv&Put in 2009.txt */
setref tmedvedev_dom_09 -1 tputin_dom_09 1
/* descr. stats on texts */
describetext t*
/* score words for dimension of interest  */
wordscore dimension10
/* score virgin texts    */
textscore dimension10 t* 


/**************************************************
****            2009.txt                           ****
**************************************************/
clear all

  
  /******  using Java environment     ******/
wordfreqj *.txt

  
/* set ref. scores/texts at Medv&Put in 2008.txt */
setref tmedvedev_dom_08 -1 tputin_dom_08 1
/* descr. stats on texts */
describetext t*
/* score words for dimension of interest  */
wordscore dimension09
/* score virgin texts    */
textscore dimension09 t*    


 /**************************************************
****  all in 2011 and 2012 (from Nov 2010 to June 2012) ****
**************************************************/

  /******  using Java environment     ******/
wordfreqj *.txt

  
/* set ref. scores/texts at Medv&Put in 2010 */
setref tmedvedev_dom_10 -1 tputin_dom_10 1
/* descr. stats on texts */
describetext t*
/* score words for dimension of interest  */
wordscore dimension11
/* score virgin texts    */
textscore dimension11 t*



/**************************************************
****            2012.txt                           ****
**************************************************/
clear all

  
  /******  using Java environment     ******/
wordfreqj *.txt

  
/* set ref. scores/texts at Medv&Put in 2011.txt */
setref tmedvedev_dom_11 -1 tputin_dom_11 1
/* descr. stats on texts */
describetext t*
/* score words for dimension of interest  */
wordscore dimension12
/* score virgin texts    */
textscore dimension12 t* 

