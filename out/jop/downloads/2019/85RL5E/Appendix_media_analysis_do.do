* Setting the working directory <to be changed in one's own WD> * 
cd "C:\Users\теош\Desktop"

* Loading the dataset *
use "Institutions_corruption_JOP_Appendix_media_analysis_data.dta", replace


* FIGURE A5:
twoway (fpfit no_dismayors week if year==2003) ///
(fpfit no_dismayors week if year==2008)(fpfit no_dismayors week if year==2013)

* TABLE A6:
asdoc poisson no_dismayors ib2013.year i.haaretz i.late_period, nest replace
asdoc poisson no_dismayors ib2013.year i.haaretz if late_period==1, nest append
asdoc poisson no_dismayors ib2013.year##i.late_period i.haaretz, nest append

* FIGURE A6:
margins late_period#year
marginsplot, level(68.2)
