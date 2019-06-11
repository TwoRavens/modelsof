************** Estimate model

logit VoteMajor2 info win party age2srev incomerev BlackNMrev Femalerev Southernrev RetroNatl ProspNatl RetroPocket ProspPocket infowin inforetronatl infopronatl inforetropck infopropck infowinretronatl infowinpropck infowinretropck infowinpronatl winretronatl winretropck winpropck winpronatl i.Year, cl(Year)



______________________________

***Most Informed Voters, Incumbent wins

lincom (1*ProspNatl + 1*infopronatl + 1*winpronatl + 1*infowinpronatl) - (0*ProspNatl +  0*infopronatl + 0*winpronatl + 0*infowinpronatl)

lincom (1*RetroNatl + 1*inforetronatl + 1*winretronatl + 1*infowinretronatl) - (0*RetroNatl +  0*inforetronatl + 0*winretronatl + 0*infowinretronatl)

lincom (1*ProspPocket + 1*infopropck + 1*winpropck + 1*infowinpropck) - (0*ProspPocket + 0*infopropck + 0*winpropck + 0*infowinpropck)

lincom (1*RetroPocket + 1*inforetropck + 1*winretropck + 1*infowinretropck) - (0*RetroPocket + 0*inforetropck + 0*winretropck + 0*infowinretropck)


***High Moderate Informed Voters, Incumbent wins

lincom (1*ProspNatl + .5*infopronatl + 1*winpronatl + .5*infowinpronatl) - (0*ProspNatl +  0*infopronatl + 0*winpronatl + 0*infowinpronatl)

lincom (1*RetroNatl + .5*inforetronatl + 1*winretronatl + .5*infowinretronatl) - (0*RetroNatl +  0*inforetronatl + 0*winretronatl + 0*infowinretronatl)

lincom (1*ProspPocket + .5*infopropck + 1*winpropck + .5*infowinpropck) - (0*ProspPocket + 0*infopropck + 0*winpropck + 0*infowinpropck)

lincom (1*RetroPocket + .5*inforetropck + 1*winretropck + .5*infowinretropck) - (0*RetroPocket + 0*inforetropck + 0*winretropck + 0*infowinretropck)


***Middle Info Voters, Incumbent wins

lincom (1*ProspNatl + 0*infopronatl + 1*winpronatl + 0*infowinpronatl) - (0*ProspNatl +  0*infopronatl + 0*winpronatl + 0*infowinpronatl)

lincom (1*RetroNatl + 0*inforetronatl + 1*winretronatl + 0*infowinretronatl) - (0*RetroNatl +  0*inforetronatl + 0*winretronatl + 0*infowinretronatl)

lincom (1*ProspPocket + 0*infopropck + 1*winpropck + 0*infowinpropck) - (0*ProspPocket + 0*infopropck + 0*winpropck + 0*infowinpropck)

lincom (1*RetroPocket + 0*inforetropck + 1*winretropck + 0*infowinretropck) - (0*RetroPocket + 0*inforetropck + 0*winretropck + 0*infowinretropck)



***Low-Moderately Informed Voters, Incumbent wins

lincom (1*ProspNatl - .5*infopronatl + 1*winpronatl - .5*infowinpronatl) - (0*ProspNatl +  0*infopronatl + 0*winpronatl + 0*infowinpronatl)

lincom (1*RetroNatl - .5*inforetronatl + 1*winretronatl - .5*infowinretronatl) - (0*RetroNatl +  0*inforetronatl + 0*winretronatl + 0*infowinretronatl)

lincom (1*ProspPocket - .5*infopropck + 1*winpropck - .5*infowinpropck) - (0*ProspPocket + 0*infopropck + 0*winpropck + 0*infowinpropck)

lincom (1*RetroPocket - .5*inforetropck + 1*winretropck - .5*infowinretropck) - (0*RetroPocket + 0*inforetropck + 0*winretropck + 0*infowinretropck)


***Least Informed Voters, incumbent wins

lincom (1*ProspNatl - 1*infopronatl + 1*winpronatl - 1*infowinpronatl) - (0*ProspNatl - 0*infopronatl + 0*winpronatl - 0*infowinpronatl)

lincom (1*RetroNatl - 1*inforetronatl + 1*winretronatl - 1*infowinretronatl) - (-0*RetroNatl - 0*inforetronatl + 0*winretronatl - 0*infowinretronatl)

lincom (1*ProspPocket - 1*infopropck + 1*winpropck - 1*infowinpropck) - (0*ProspPocket -  0*infopropck + 0*winpropck - 0*infowinpropck)

lincom (1*RetroPocket - 1*inforetropck + 1*winretropck - 1*infowinretropck) - (0*RetroPocket -  0*inforetropck + 0*winretropck - 0*infowinretropck)



***Most Informed Voters, DK who wins

lincom (1*ProspNatl + 1*infopronatl + 0*winpronatl + 0*infowinpronatl) - (0*ProspNatl +  0*infopronatl + 0*winpronatl + 0*infowinpronatl)

lincom (1*RetroNatl + 1*inforetronatl + 0*winretronatl + 0*infowinretronatl) - (0*RetroNatl +  0*inforetronatl + 0*winretronatl + 0*infowinretronatl)

lincom (1*ProspPocket + 1*infopropck + 0*winpropck + 0*infowinpropck) - (0*ProspPocket + 0*infopropck + 0*winpropck + 0*infowinpropck)

lincom (1*RetroPocket + 1*inforetropck + 0*winretropck + 0*infowinretropck) - (0*RetroPocket + 0*inforetropck + 0*winretropck + 0*infowinretropck)


***High Moderate Informed Voters, Dk

lincom (1*ProspNatl + .5*infopronatl + 0*winpronatl + 0*infowinpronatl) - (0*ProspNatl +  0*infopronatl + 0*winpronatl + 0*infowinpronatl)

lincom (1*RetroNatl + .5*inforetronatl + 0*winretronatl + 0*infowinretronatl) - (0*RetroNatl +  0*inforetronatl + 0*winretronatl + 0*infowinretronatl)

lincom (1*ProspPocket + .5*infopropck + 0*winpropck + 0*infowinpropck) - (0*ProspPocket + 0*infopropck + 0*winpropck + 0*infowinpropck)

lincom (1*RetroPocket + .5*inforetropck + 0*winretropck + 0*infowinretropck) - (0*RetroPocket + 0*inforetropck + 0*winretropck + 0*infowinretropck)


***Moderately Informed Voters, DK

lincom (1*ProspNatl + 0*infopronatl + 0*winpronatl + 0*infowinpronatl) - (0*ProspNatl +  0*infopronatl + 0*winpronatl + 0*infowinpronatl)

lincom (1*RetroNatl + 0*inforetronatl + 0*winretronatl + 0*infowinretronatl) - (0*RetroNatl +  0*inforetronatl + 0*winretronatl + 0*infowinretronatl)

lincom (1*ProspPocket + 0*infopropck + 0*winpropck + 0*infowinpropck) - (0*ProspPocket + 0*infopropck + 0*winpropck + 0*infowinpropck)

lincom (1*RetroPocket + 0*inforetropck + 0*winretropck + 0*infowinretropck) - (0*RetroPocket + 0*inforetropck + 0*winretropck + 0*infowinretropck)


***Low-Moderately Informed Voters, Dk

lincom (1*ProspNatl - .5*infopronatl + 0*winpronatl - 0*infowinpronatl) - (0*ProspNatl +  0*infopronatl + 0*winpronatl + 0*infowinpronatl)

lincom (1*RetroNatl - .5*inforetronatl + 0*winretronatl - 0*infowinretronatl) - (0*RetroNatl +  0*inforetronatl + 0*winretronatl + 0*infowinretronatl)

lincom (1*ProspPocket - .5*infopropck + 0*winpropck - 0*infowinpropck) - (0*ProspPocket + 0*infopropck + 0*winpropck + 0*infowinpropck)

lincom (1*RetroPocket - .5*inforetropck + 0*winretropck - 0*infowinretropck) - (0*RetroPocket + 0*inforetropck + 0*winretropck + 0*infowinretropck)


***Least Informed Voters, DK

lincom (1*ProspNatl - 1*infopronatl + 0*winpronatl - 0*infowinpronatl) - (0*ProspNatl - 0*infopronatl + 0*winpronatl - 0*infowinpronatl)

lincom (1*RetroNatl - 1*inforetronatl + 0*winretronatl - 0*infowinretronatl) - (-0*RetroNatl - 0*inforetronatl + 0*winretronatl - 0*infowinretronatl)

lincom (1*ProspPocket - 1*infopropck + 0*winpropck - 0*infowinpropck) - (0*ProspPocket -  0*infopropck + 0*winpropck - 0*infowinpropck)

lincom (1*RetroPocket - 1*inforetropck + 0*winretropck - 0*infowinretropck) - (0*RetroPocket -  0*inforetropck + 0*winretropck - 0*infowinretropck)


***Most Informed Voters, Chall wins

lincom (1*ProspNatl + 1*infopronatl - 1*winpronatl - 1*infowinpronatl) - (0*ProspNatl +  0*infopronatl + 0*winpronatl + 0*infowinpronatl)

lincom (1*RetroNatl + 1*inforetronatl - 1*winretronatl - 1*infowinretronatl) - (0*RetroNatl +  0*inforetronatl + 0*winretronatl + 0*infowinretronatl)

lincom (1*ProspPocket + 1*infopropck - 1*winpropck - 1*infowinpropck) - (0*ProspPocket + 0*infopropck + 0*winpropck + 0*infowinpropck)

lincom (1*RetroPocket + 1*inforetropck - 1*winretropck - 1*infowinretropck) - (0*RetroPocket + 0*inforetropck + 0*winretropck + 0*infowinretropck)


***High Moderate Informed Voters, Chall wins

lincom (1*ProspNatl + .5*infopronatl - 1*winpronatl - .5*infowinpronatl) - (0*ProspNatl +  0*infopronatl + 0*winpronatl + 0*infowinpronatl)

lincom (1*RetroNatl + .5*inforetronatl - 1*winretronatl - .5*infowinretronatl) - (0*RetroNatl +  0*inforetronatl + 0*winretronatl + 0*infowinretronatl)

lincom (1*ProspPocket + .5*infopropck - 1*winpropck - .5*infowinpropck) - (0*ProspPocket + 0*infopropck + 0*winpropck + 0*infowinpropck)

lincom (1*RetroPocket + .5*inforetropck - 1*winretropck - .5*infowinretropck) - (0*RetroPocket + 0*inforetropck + 0*winretropck + 0*infowinretropck)


***Middle Info Voters, Chall wins

lincom (1*ProspNatl + 0*infopronatl - 1*winpronatl + 0*infowinpronatl) - (0*ProspNatl +  0*infopronatl + 0*winpronatl + 0*infowinpronatl)

lincom (1*RetroNatl + 0*inforetronatl - 1*winretronatl + 0*infowinretronatl) - (0*RetroNatl +  0*inforetronatl + 0*winretronatl + 0*infowinretronatl)

lincom (1*ProspPocket + 0*infopropck - 1*winpropck + 0*infowinpropck) - (0*ProspPocket + 0*infopropck + 0*winpropck + 0*infowinpropck)

lincom (1*RetroPocket + 0*inforetropck - 1*winretropck + 0*infowinretropck) - (0*RetroPocket + 0*inforetropck + 0*winretropck + 0*infowinretropck)


***Low-Moderately Informed Voters, Chall wins

lincom (1*ProspNatl - .5*infopronatl - 1*winpronatl + .5*infowinpronatl) - (0*ProspNatl +  0*infopronatl + 0*winpronatl + 0*infowinpronatl)

lincom (1*RetroNatl - .5*inforetronatl - 1*winretronatl + .5*infowinretronatl) - (0*RetroNatl +  0*inforetronatl + 0*winretronatl + 0*infowinretronatl)

lincom (1*ProspPocket - .5*infopropck - 1*winpropck + .5*infowinpropck) - (0*ProspPocket + 0*infopropck + 0*winpropck + 0*infowinpropck)

lincom (1*RetroPocket - .5*inforetropck - 1*winretropck + .5*infowinretropck) - (0*RetroPocket + 0*inforetropck + 0*winretropck + 0*infowinretropck)


***Least Informed Voters, Chall wins

lincom (1*ProspNatl - 1*infopronatl - 1*winpronatl + 1*infowinpronatl) - (0*ProspNatl - 0*infopronatl + 0*winpronatl - 0*infowinpronatl)

lincom (1*RetroNatl - 1*inforetronatl - 1*winretronatl + 1*infowinretronatl) - (-0*RetroNatl - 0*inforetronatl + 0*winretronatl - 0*infowinretronatl)

lincom (1*ProspPocket - 1*infopropck - 1*winpropck + 1*infowinpropck) - (0*ProspPocket -  0*infopropck + 0*winpropck - 0*infowinpropck)

lincom (1*RetroPocket - 1*inforetropck - 1*winretropck + 1*infowinretropck) - (0*RetroPocket -  0*inforetropck + 0*winretropck - 0*infowinretropck)

