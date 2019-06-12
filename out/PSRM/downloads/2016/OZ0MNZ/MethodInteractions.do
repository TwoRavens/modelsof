* Create Interaction terms for Method (Radio Button or Slider) with each of the three affect scales

gen MDAX = Method2 * ANXIETY
gen MDAV = Method2 * AVERSION
gen MDEN = Method2 * ENTHUSIASM
