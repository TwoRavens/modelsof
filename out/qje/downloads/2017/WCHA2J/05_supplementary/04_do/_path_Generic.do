**** This file sets global variables assuming the downladed folder structure
**** (projectFloder global should be separately defined in script)

**** set path globals
* data folders
global data "$projectFolder/03_data"
global rawFolder "$projectFolder/03_data/rawExp"

* do and log folders
global doFolder "$projectFolder/04_do"
global adoFolder "$doFolder/ado"
global logFolder "$doFolder/output/log"

* writeup folders
global writeupFolder "$doFolder/output"
global figFolder "$doFolder/output/fig"
global tableFolder "$doFolder/output/tab"

* other
global strategyFolder "$doFolder/05_matlab"
global learning "$doFolder/05_matlab"
