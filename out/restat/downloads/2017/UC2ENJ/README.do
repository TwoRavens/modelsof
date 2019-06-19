README file: 
Author of dataset: Lauren Lanahan, www.laurenlanahan.com
This work was part of Lanahan's dissertation research, under the direction of Maryann Feldman.
Software used: Stata 14

********************************************************************************
I. Refer to Appendix C in the Supplementary Materials for detail on matching procedure for construction of the dataset

********************************************************************************
II. Refer to "Dataverse_Data Building_File_Final" for Stata 14 code used to construct the project-level SBIR dataset.

	
	Primary Data Sources:

	1. SBIR award data for the following states - NC, VA, SC, KY, MO, AR.
		a. Phase I award activity from 2000 - 2010
		b. Phase II award activity from 2000 - 2014
	
		website: https://www.sbir.gov/sbirsearch/award/all

	2. State Match Phase I & II Programmatic Activity for NC and KY
		a. NC Department of Commerce provided award level data from 2006 - 2010

		website: http://www.nccommerce.com/sti/grant-programs/one-nc-small-business-program
	
		b. KY Science and Technology Corporation provided award level data from 2007 - 2010
	
		website: http://www.kstc.com/

	3. Lanahan handmatched the DUNS ID for the set of firms with a Phase I SBIR award 
		from the sample using Hoover's Mergent Intellect. Lanahan had access to this proprietary
		database through the University of North Carolina's library.

	4. The authors purchased firm-level data from Don Walls & Associates. Primary sources
		of data: National Establishment Time Series (NETS). The following link provides an
		overview of the longitudinal database.

		http://maryannfeldman.web.unc.edu/data-sources/longitudinal-databases/national-establishment-time-series-nets/

	*************************************

	Building Dataset Part I:

	Appendix C.1 in the supplementary materials details the match procedure for this dataset.
	There was no unique identifier between any of the data sources. Thus Lanahan relied 
	on a series of string matches. Parts of the match procedure were automated; however,
	every step was vetted with handmatching to ensure accuracy of the match.

	1. Match Phase II awards to Phase I awards: based on firm name, title, abstract
	2. Match State Match Phase I and Phase II awards to Phase I: based on firm name, title
	3. Identify DUNS ID using SBIR firm name and address. Additional websearches were
		conducted to ensure accuracy of DUNS match
	4. Contracted Don Walls & Associates automated the DUNS to NETS match 

********************************************************************************
III. Refer to "Dataverse_Analysis_File_Final" for Stata 14 code used for analysis. 

	** Data Dictionary -- Line 16
	** Table 1: Descriptive statistics (2002 - 2010) -- Line 74
	** TABLE 2: Differential Model -- Analysis for significant results 	--Line 99
	** TABLE 3: Marginal Model -- Analysis for significant results -- Line 139
	** Table 4: Robustness checks for differential model -- Line 165
	** Table 5: Robustness checks for marginal model -- Line 276
	** Table 6: Sensitivity analysis for differential model -- Line 325
	** Table 7 Sensitivity Analysis: Marginal Model -- Line 424
	** Appendix A -- Line 518
	** Appendix B -- Line 542
	** Appendix D -- Line 965
	** Analysis fir references in text (not reported in tables or figures) -- Line 1757
	
