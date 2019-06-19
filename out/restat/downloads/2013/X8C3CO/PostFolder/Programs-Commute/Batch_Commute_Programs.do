/* This program is a batch file that runs all four programs for the commute time analysis */

#delimit;
clear all;

/*********************************************************/
/*Define local path*/
/*********************************************************/

local path D:\research\PROJECT\CURRENT\FemaleEntrepreneur\PostFolder\Programs-Commute;

/*********************************************************/
/*Run programs*/
/*********************************************************/

/* Program 1 will not run because the raw data is not provided.*/
*do "`path'\POST-Program-1-commute - Extract relevant variables from IPUMS data.do";

do "`path'\POST-Program-2-commute - Creates and cleans control variables.do";
do "`path'\POST-Program-3-commute - Append region files to a US file.do";
do "`path'\POST-Program-4 - Runs regessions on commute time for US.do";
