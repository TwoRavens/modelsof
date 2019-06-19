clear
set mem 500m


*global n_states "01 02 04 05 06 08 09 10 11 12 13 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 44 45 46 47 48 49 50 51 53 54 55 56"
global n_states "01"

foreach i in $n_states   {
infile using "C:\Users\HW462587\Documents\Leah\STF 3A\1970\dictionary.dct", using("C:\Users\HW462587\Documents\Leah\STF 3A\1970\10223931\10223931\ICPSR_08107\DS00`i'\08107-00`i'-Data.txt")
}
