sort fitcriterion run

foreach x in 1 {
display _newline(5)

display " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Table 3 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
display _newline(1)

by fitcriterion: sum fitness number range swings  sensitivity_DC sensitivity_DD 

}
