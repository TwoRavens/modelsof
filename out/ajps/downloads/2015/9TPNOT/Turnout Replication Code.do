* CODEBOOK
* ctr: country code
* ctr_n: country name
* cst: district code
* cst_n: district name
* yr: year
* fptp: dummy for FPTP electoral system
* ppi: parliamentary power index
* highppi: dummy for high parliamentary power index
* turnout: turnout
* margin: margin between candidate with the pluralruty of votes and runner up
* marginfptp: interaction between margin and FPTP
* marginhighppi: interaction between margin and highppi

* CODE TO CREATE TABLE IN SUPPLEMENTARY INFORMATION

* COLUMN 1
reg turnout margin fptp marginfptp if ppi>=0.63, robust
* COLUMN 2
reg turnout margin fptp marginfptp if ppi<0.63, robust
* COLUMN 3
reg turnout margin highppi marginhighppi if fptp==0, robust
* COLUMN 4
reg turnout margin highppi marginhighppi if fptp==1, robust
 
