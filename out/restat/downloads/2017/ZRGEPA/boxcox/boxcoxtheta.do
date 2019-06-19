clear all
infile earnings assignmt age age2 married prevearn wkless13 hsorged black hispanic sda1-sda12 using jtpa.raw

drop if assignmt == 1
drop if earnings == 0

boxcox earnings age age2 married prevearn wkless13 hsorged black hispanic sda1-sda12
