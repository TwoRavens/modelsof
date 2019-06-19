/*
Should you use any of these programs or data, please provide the complete citation to the paper:

Rosenthal, Stuart S. and William C. Strange, “Female Entrepreneurship, Agglomeration, and a New Spatial Mismatch,”
Review of Economics and Statistics, August 2012, 94(3): 764–788.
*/

/*
This program is a batch file that runs all programs from raw data cleaning to summary stats
and regressions.
*/

#delimit;

/**************************************************************************************************/
/*Run Batch Program For all of the Data Cleaning and Analysis Based on the Dun and Bradstreet Data*/
/**************************************************************************************************/

cd "D:\research\PROJECT\CURRENT\FemaleEntrepreneur\PostFolder\Programs-DB";
do "Batch_DB_Programs.do";


/***************************************************************************************************/
/*Run Batch Program For all of the Data Cleaning and Analysis Based on the IPUMS (2000 Census) Data*/
/***************************************************************************************************/

cd "D:\research\PROJECT\CURRENT\FemaleEntrepreneur\PostFolder\Programs-Commute";
do "Batch_Commute_Programs.do";
