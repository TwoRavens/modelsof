*change working directory, ex: "cd /Users/username/folder"
use anes_cdf.dta
log using figure7.log,replace

*blacks
 cor vcf0211 vcf0206 if vcf0004==1964 
 cor vcf0211 vcf0206 if vcf0004==1966
 cor vcf0211 vcf0206 if vcf0004==1968
 cor vcf0211 vcf0206 if vcf0004==1970
 cor vcf0211 vcf0206 if vcf0004==1972
 cor vcf0211 vcf0206 if vcf0004==1974
 cor vcf0211 vcf0206 if vcf0004==1976
 cor vcf0211 vcf0206 if vcf0004==1980
 
*unions
 cor vcf0211 vcf0210 if vcf0004==1964 
 cor vcf0211 vcf0210 if vcf0004==1966
 cor vcf0211 vcf0210 if vcf0004==1968
 cor vcf0211 vcf0210 if vcf0004==1972
 cor vcf0211 vcf0210 if vcf0004==1976
 cor vcf0211 vcf0210 if vcf0004==1980
 
 *black militants
 cor vcf0211 vcf0215 if vcf0004==1970 
 cor vcf0211 vcf0215 if vcf0004==1972
 cor vcf0211 vcf0215 if vcf0004==1974
 cor vcf0211 vcf0215 if vcf0004==1976
 cor vcf0211 vcf0215 if vcf0004==1980
 cor vcf0211 vcf0216 if vcf0004==1970 
 
 *civil rights leaders
 cor vcf0211 vcf0216 if vcf0004==1972
 cor vcf0211 vcf0216 if vcf0004==1974
 cor vcf0211 vcf0216 if vcf0004==1976
 cor vcf0211 vcf0216 if vcf0004==1980
 
 *poor people
 cor vcf0211 vcf0223 if vcf0004==1972
 cor vcf0211 vcf0223 if vcf0004==1974
 cor vcf0211 vcf0223 if vcf0004==1976
 cor vcf0211 vcf0223 if vcf0004==1980
 
 *urban unreast scale
 cor vcf0211 vcf0811 if vcf0004==1968
 cor vcf0211 vcf0811 if vcf0004==1970
 cor vcf0211 vcf0811 if vcf0004==1972
 cor vcf0211 vcf0811 if vcf0004==1974
 cor vcf0211 vcf0811 if vcf0004==1976
 log close
