PFont f;

void showStartMenu() {
  f = loadFont("AshbyLight-120.vlw");
  pushStyle();
  textFont(f, 48);
  showText("System.exe", 100, new Vector(20, 350, false), color(255, 255, 255));
  popStyle();
}

void showSettings() {
  pushStyle();
  textFont(f, 48);
  showText("Settings", 70, new Vector(width - 350, 350, false), color(255, 255, 255));
  popStyle();
}

void multiplayerMenu() {
  pushStyle();
  textFont(f, 48);
  showText("Select a server to join", 70, new Vector(width - width/1.4, 100, false), color(255, 255, 255));
  popStyle();
}
void selectVessel() {
  pushStyle();
  textFont(f, 48);
  textSize(70);
  showText("Select a vessel", 65, new Vector(width - width/1.5, 100, false), color(255, 255, 255));
  popStyle();
  drawImage(playableVessels[getSkin()], width/2, height/2, width/5, width/5, -PI/2);
}

void showBonusMenu() {
  pushStyle();
  textFont(f, 48);
  textSize(70);
  showText("List of bonus", 65, new Vector(width - width/1.5, 100, false), color(255, 255, 255));
  showText("Il y a plusieur types de bonus, par exemple : \n-La vie; elle apparait de maniere aléatoire sur la map, mais une fois touchée, ce bonus vous redonne TOUTE VOTRE VIE !\n-Les munitions; elle apparaissent de la même manière que la vie et vous donne un CERTAIN NOMBRE DE MUNITIONS.", 30, new Vector(20, 350, false), color(255, 255, 255));
  popStyle();
}

void showInfosMenu() {
  pushStyle();
  textFont(f, 48);
  textSize(70);
  showText("Infos page", 65, new Vector(width - width/1.5, 100, false), color(255, 255, 255));
  showText("-Règles du jeu : \n Bla \n bla \n bla \n-Multijoueur : \nPour jouer en multi joueur, il faut que vous et la personne avec qui vous souhaitez jouer soyez sur le même réseau internet.", 30, new Vector(20, 350, false), color(255, 255, 255));
  popStyle();
}

void selectWeaponMenu() {
  pushStyle();
  textFont(f, 48);
  textSize(70);
  showText("Select a weapon", 70, new Vector(width - width/1.5, 100, false), color(255, 255, 255));
  popStyle();
}
void deadScreen() {
  pushStyle();
  textFont(f, 48);
  textSize(70);
  String file="save.txt";
  String[] lines =loadStrings(file) ;
  if (score >int(lines[0]))
    lines[0]=""+score;
  if (int(camera.date) >int(lines[1]))
    lines[1]=""+int(camera.date);


  saveStrings(file, lines);
  showText("Final Score", 70, new Vector(width - width/1.4, 100, false), color(255, 255, 255));
  showText("Score :" + score, 70, new Vector(width - width/1.5, 400, false), color(255, 255, 255));
  showText("High Score :" + lines[0], 50, new Vector(width - width/1.5, 500, false), color(255, 255, 255));
  showText("High played time :" + round(camera.date, 2), 70, new Vector(width - width/1.5, 600, false), color(255, 255, 255));
  popStyle();
}