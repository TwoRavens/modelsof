*  BeniniAfghanModelJPR2004.do    Stata file run under version 8.0
*  12/26/2003

*  Fits main regression model of: 

*  Civilian Victims in an Asymmetrical Conflict: Operation Enduring Freedom, Afghanistan
*  by AA Benini and LH Moulton
*
*  Change the following line to indicate the correct path
use  c:\d\consult\landmine\afghan\final\beniniafghandata.dta, clear

set logtype text
log using c:\d\consult\landmine\afghan\final\beniniafghan.log, replace

 zip  recbomball  isnorth logpopcurr log10distancetoroadexcltracks daysinwa airstrik groundop  munitiondepots  /*
*/ rbtot3km4categ3 rbtot3km4categ4 rmtot3km4categ3 rmtot3km4categ4  bbnonzeromed bbnonzerohig bmnonzeromediu bmnonzerohigh /*
*/ , inflate(isnorth logpopcurr log10distancetoroadexcltracks daysinwa airstrik groundop  munitiondepots      /*
*/ rbtot3km4categ3 rbtot3km4categ4 rmtot3km4categ3 rmtot3km4categ4 bbnonzeromed  bbnonzerohig bmnonzeromediu bmnonzerohigh)/*
*/ robust
