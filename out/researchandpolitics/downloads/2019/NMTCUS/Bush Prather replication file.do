/*Code to produce tables and figures in manuscript*/

/*Log*/
log using "manuscript1.txt", text replace

/*Table 1*/

ttest income if wave1==1, by(tablet)
ttest nidaa if wave1==1, by(tablet)
ttest age if wave1==1, by(tablet)
ttest sex if wave1==1, by(tablet)
ttest education if wave1==1, by(tablet)
ttest employed if wave1==1, by(tablet)
ttest polknowledge if wave1==1, by(tablet)
ttest polint if wave1==1, by(tablet)

/*Figure 1*/

tab income if wave1==1

/*Figure 2*/

reg income tablet##wave2 if poor==1, cluster(id)
/*ATE estimate from interaction - coeff. = 0.31, std. err. = 0.139*/
reg income tablet##wave2 if poor==0, cluster(id)
/*ATE estimate from interaction - coeff. = -0.05, std. err. = 0.067*/

/*Figure 3*/

/*left panel*/
logit essebsi_respond tablet income_w1 polknowledge educ if nidaa==0 & wave2==1
/*tablets estimate - coef. = 0.21, std. err. = 0.613*/

/*right panel, government opponents*/
ologit essebsi tablet income_w1 polknowledge educ if nidaa==0 & wave2==1
/*tablets estimate - coef. = -0.34, std. err. = 0.262*/

/*right panel, government supporters*/
ologit essebsi tablet income_w1 polknowledge educ if nidaa==1 & wave2==1
/*tablets estimate - coef. = -0.07, std. err. = 0.169*/

log close
