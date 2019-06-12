**code to replicate Braithwaite and Lemke (2011)

heckprob reciprocated joint_democ territory jointsatis powerratio defense ,sel(onset = contiguous thom_rival min_min joint_democ  jointsatis terrdisp powerratio defense peaceyears pax2 pax3) cluster(dyadid)
eststo model1

heckprob force joint_democ territory  jointsatis powerratio defense ,sel(onset = contiguous thom_rival min_min joint_democ  jointsatis terrdisp powerratio defense peaceyears pax2 pax3) cluster(dyadid)
eststo model2

heckprob mutualforce joint_democ territory  jointsatis powerratio defense ,sel(onset = contiguous thom_rival min_min joint_democ  jointsatis terrdisp powerratio defense peaceyears pax2 pax3) cluster(dyadid)
eststo model3

heckprob fatal_0 joint_democ territory  jointsatis powerratio defense ,sel(onset = contiguous thom_rival min_min joint_democ  jointsatis terrdisp powerratio defense peaceyears pax2 pax3) cluster(dyadid)
eststo model4

heckprob fatal_250 joint_democ territory  jointsatis powerratio defense ,sel(onset = contiguous thom_rival min_min joint_democ  jointsatis terrdisp powerratio defense peaceyears pax2 pax3) cluster(dyadid)
eststo model5

heckprob war joint_democ territory  jointsatis powerratio defense ,sel(onset = contiguous thom_rival min_min joint_democ  jointsatis terrdisp powerratio defense peaceyears pax2 pax3) cluster(dyadid)
eststo model6

****with GML revised data

heckprob gml_recip joint_democ gml_terrdisp jointsatis powerratio defense ,sel(gml_onset = contiguous thom_rival min_min joint_democ  jointsatis terrdisp powerratio defense peaceyears pax2 pax3) cluster(dyadid)
eststo model1a

heckprob gml_force joint_democ gml_terrdisp jointsatis powerratio defense ,sel(gml_onset = contiguous thom_rival min_min joint_democ  jointsatis terrdisp powerratio defense peaceyears pax2 pax3) cluster(dyadid)
eststo model2a

heckprob gml_mutualforce joint_democ gml_terrdisp jointsatis powerratio defense ,sel(gml_onset = contiguous thom_rival min_min joint_democ  jointsatis terrdisp powerratio defense peaceyears pax2 pax3) cluster(dyadid)
eststo model3a

heckprob gml_fatal_0 joint_democ gml_terrdisp jointsatis powerratio defense ,sel(gml_onset = contiguous thom_rival min_min joint_democ  jointsatis terrdisp powerratio defense peaceyears pax2 pax3) cluster(dyadid)
eststo model4a

heckprob gml_fatal_250 joint_democ gml_terrdisp jointsatis powerratio defense ,sel(gml_onset = contiguous thom_rival min_min joint_democ  jointsatis terrdisp powerratio defense peaceyears pax2 pax3) cluster(dyadid)
eststo model5a

heckprob gml_war joint_democ gml_terrdisp jointsatis powerratio defense ,sel(gml_onset = contiguous thom_rival min_min joint_democ  jointsatis terrdisp powerratio defense peaceyears pax2 pax3) cluster(dyadid)
eststo model6a

*esttab model1a model2a model3a model4a model5a model6a using "braithlemkeredux.tex", b(3) se(3)
