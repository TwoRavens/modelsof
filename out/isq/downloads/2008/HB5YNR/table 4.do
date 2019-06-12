foreach x in 1 {
display _newline(6)
display " ~~~~~~~~~~~~~~~~~~~~~~~~~~ Table 4 ~~~~~~~~~~~~~~~~~~~~~~~~~~ "
display _newline(2)
sort fitness_criterion generation run
by fitness_criterion: sum  number range swings sensitivity_DC sensitivity_DD if generation == 40
}
