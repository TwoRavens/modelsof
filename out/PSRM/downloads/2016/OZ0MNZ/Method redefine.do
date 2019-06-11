generate Method2=Method
  replace Method2=1 if Method==1
  replace Method2=2 if Method==2
  replace Method2=. if Method==3
  replace Method2=. if Method==4
  label variable Method2 "RadioButton[1] v Slider[2]"
