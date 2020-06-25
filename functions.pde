void makeHashMatch() {//Donne un identifiant à chaque entité en fonction de sa place dans le tableau
  println("There are actually "+ents.length+" entities.");
  for (int i=0; i<ents.length; i++) {
    ents[i].hash=i;
  }
}
void applySpeed(Entity[] ent) {
  for (int i=0; i<ent.length; i++) {
    ents[i].pos.add(times(ents[i].speed, 1/frameRate));
  }
}
void playMusic(String m) {
  if(actualMusic!=m){
  float g=music.getGain();
  
  music.close();
  music = minim.loadFile(m);
  music.play();
  music.setGain(g);
  music.loop();
  actualMusic=m;
  }
}
void uploadSkin(int s) {
  String file="save.txt";
  String[] lines =loadStrings(file) ;
  lines[2]=s+"";
  saveStrings(file, lines);
}
int getSkin() {
  String file="save.txt";
  String[] lines =loadStrings(file) ;
  return int(lines[2]);
}
boolean contains(Ai[] array, Ai a) {
  for (int i=0; i<array.length; i++) {
    if (array[i]==a)
      return true;
  }
  return false;
}
int findPlayer() {
  if (ents!=null)
    for (int i=0; i<ents.length; i++)
      if (contains(ents[i].ai, Ai.PLAYER))
        return i;
  return -1;
}
int probability() {
  return int(60+300*exp(-camera.date/70));
}
Vector randomOnScreen() {
  Vector v=new Vector(0);
  int rand=(int)random(0, 100);
  if (rand%2==0) {//Proba de 1/2 d'être sur un coté
    v.x=width/2+(width/2+30)*(rand>=50?1:-1);
    v.y=random(0, height);
  } else {//Proba de 1/2 de ne pas être sur un coté (en haut ou en bas)
    v.y=height/2+(height/2+30)*(rand>=50?1:-1);
    v.x=random(0, width);
  }
  return v;
}
void makeSpawn() {
  if (frameCount%probability()==0&&camera.date<150) {
    Entity e;
    int rand=(int)random(0, 100);
    if (0<rand&&rand<5) {
      e=new Entity(Ai.HEALTH, camera.screenToGame(new Vector(random(width), 10, false)), new Vector(0, -random(10, 100), false), new Vector(20, 20, false), 100);
      e.hp=(int)random(20, 100);
      e.ap=Appearance.HEALTH;
    } else if (5<rand&&rand<10) {
      e=new Entity(Ai.BONUS, camera.screenToGame(new Vector(random(width), 10, false)), new Vector(0, -random(10, 100), false), new Vector(20, 20, false), 100);
      e.hp=(int)random(1, 20);
      e.ap=Appearance.BONUS;
      e.skin=0;
    } else
      e=new Entity(Ai.KAMIKAZE, camera.screenToGame(randomOnScreen()), new Vector(0, 0, false), new Vector(30, 20, false), 100);
    ents=(Entity[])append(ents, e);
    makeHashMatch();
  }
}
void actWithTime() {
  if (camera.date>170)background.changeSpeed(1, 1);
  else if (camera.date>150) {
    //background.changeColor(color(200,0,0), 1);
    background.changeSpeed(10, 3);
  }
}
void update(Weapon[] w) {
  for (int i=0; i<w.length; i++)
    if (w[i]!=null)
      w[i].update();
}

//Fonctions de setup
void loadImages() {
  File[] files=listFiles("img/playableVessels");
  playableVessels=new PImage[files.length];
  for (int i=0; i<files.length; i++) {
    playableVessels[i]=loadImage("img/playableVessels/"+files[i].getName());
  }
  files=listFiles("img/projectiles");
  projectiles=new PImage[files.length];
  for (int i=0; i<files.length; i++) {
    projectiles[i]=loadImage("img/projectiles/"+files[i].getName());
  }
  files=listFiles("img/mechants");
  mechants=new PImage[files.length];
  for (int i=0; i<files.length; i++) {
    mechants[i]=loadImage("img/mechants/"+files[i].getName());
  }
  files=listFiles("img/autres");
  autres=new PImage[files.length];
  for (int i=0; i<files.length; i++) {
    autres[i]=loadImage("img/autres/"+files[i].getName());
  }
  files=listFiles("img/explosion");
  explosions=new PImage[files.length];
  for (int i=0; i<files.length; i++) {
    explosions[i]=loadImage("img/explosion/"+files[i].getName());
  }
  files=listFiles("img/flames");
  fire=new PImage[files.length];
  for (int i=0; i<files.length; i++) {
    fire[i]=loadImage("img/flames/"+files[i].getName());
  }
}

//Fonctions d'affichage
void showEntities() {
  for (int i=0; i<ents.length; i++) {
    ents[i].draw();
  }
}