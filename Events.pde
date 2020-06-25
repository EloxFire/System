void mousePressed() {
  boolean buttonClicked=false;//Le bouton a-t-il été cliqué?
  for (int i=0; i<buttons.length; i++) {//On regarde si on clique sur un bouton
    if (buttons[i].isOnMe()) {
      buttonClicked=true;
      buttons[i].click();
      break;
    }
  }
}
void keyPressed() {
  int p=findPlayer();
  switch(key) {
  case 'a':
    if (p!=-1)
      ents[p].actualWeapon = 0;
    break;
  case 'z':
    if (p!=-1)
      ents[p].actualWeapon = 1;
    break;
  case 'e':
    if (p!=-1)
      ents[p].actualWeapon = 2;
    break;
  case 'r':
    if (p!=-1)
      ents[p].actualWeapon = 3;
    break;
  case 't':
    if (p!=-1)
      ents[p].actualWeapon = 4;
    break;
  case 'p':
    if (activity==Activity.GAME)
      pause=!pause;
    break;
  }
  if (keyCode == UP)
    music.setGain(music.getGain() + 3);
  else if (keyCode == DOWN)
    music.setGain(music.getGain() - 3);
}