#delimit;
clear all;

/*********************************************************/
/*Define local path*/
/*********************************************************/

local path D:\research\PROJECT\CURRENT\FemaleEntrepreneur\PostFolder\Programs-DB;

/*********************************************************/
/*Run programs*/
/*********************************************************/

/* Programs 1a and 1b will not run because the raw data files are not provided*/
*do "`path'\POST-Program-1a - Clean D&B data of 2007 Q1 and 2005 Q4.do";
*do "`path'\POST-Program-1b - Clean D&B data of new and small establishments in 2007 Q1-SALESData.do";

do "`path'\POST-Program-2a - Combine separate private and public establishment files into a single file in 2007 Q1 and 2005 Q4.do";
do "`path'\POST-Program-2b - Combine separate private and public establishment files into a single file of new and small in 2007 Q1-SALESData.do";

do "`path'\POST-Program-3a - Convert 2007 Q1 and 2005 Q4 data from Zip to Tract Geography.do";
do "`path'\POST-Program-3b - Convert new and small establishments in 2007 Q1 from Zip to Tract Geography-SALESData.do";

do "`path'\POST-Program-4 - Create a new pseudo industry SIC 0 for All Firms.do";
do "`path'\POST-Program-5 - Convert Data from Tract to Ring Geography.do";

do "`path'\POST-Program-6 - Merge ring-level data with tract-level data and convert SIC 0 to allemp variables.do";
do "`path'\POST-Program-7a - Create variables for male-owned establishments in 2007 Q1 and 2005 Q4-SALESData.do";
do "`path'\POST-Program-7b - Create variables for male-owned new and small establishments in 2007 Q1-SALESData.do";
do "`path'\POST-Program-8a - Prepare Data to Create Summary Stats at 1- and 2-digit SIC Level.do";

do "`path'\POST-Program-8b - Merge files for the different size categories of new and small establishments in 2007 Q1 for LHS-SALES.do";
do "`path'\POST-Program-8c - Create LHS var in 2007 Q1 and Merge RHS var in 2005 Q4-SALES.do";

do "`path'\POST-Program-8d - Run regs for Tables 5 and 6.do";

do "`path'\POST-Program-9a - Calculate Table 2 Seg Indexes at 1-digit SIC Level.do";
do "`path'\POST-Program-9b - Calculate Table 3 Seg Indexes at 2-digit SIC Level.do";

do "`path'\POST-Program-10 - Calculate Table 4 and B-4 to B-6 Agglomeration using dummy var regs.do";
do "`path'\POST-Program-11 - Calculate Table 1 and B-1 to B-3 Summary Stats.do";

