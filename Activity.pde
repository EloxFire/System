void showActivity(Activity act) {
  switch(act) {//On affiche l'activité actuelle
  case START_MENU: 
    showStartMenu();
    break;
  case GAME:
    showGame();
    break;
  }
}


void changeActivity(Activity act) {
  if (act != Activity.DEADSCREEN) camera=new Camera();
  camera.zoom=1;
  switch(act) {

    //MENU PRINCIPAL
  case START_MENU:
    //LES TROIS BOUTONS PRINCIPALS
    buttons=new Button[3];
    buttons[0]=new Button(ButtonType.RECTA, new Vector(20, 400, false), new Vector(300, 100, false), "Play", 100, Activity.GAME, color(255, 255, 255));
    buttons[1]=new Button(ButtonType.RECTA, new Vector(20, 520, false), new Vector(300, 100, false), "Settings", 70, Activity.SETTINGS, color(255, 255, 255));
    buttons[2]=new Button(ButtonType.RECTA, new Vector(20, 640, false), new Vector(300, 100, false), "Multiplayer", 50, Activity.MULTI, color(255, 255, 255));
    playMusic("music/menus.wav");
    break;

    //GAMEPLAY
  case GAME:
    background.changeSpeed(0.5, 3);
    score=0;
    buttons=new Button[0];
    lasers=new Laser[0];
    ents=new Entity[2];
    ents[0]=new Entity(Ai.PLAYER, new Vector(0, 0, false), new Vector(0, 0, false), new Vector(30, 20, false), 200);
    ents[1]=new Entity(Ai.SNIPER, new Vector(200, 0, false), new Vector(0, 0, false), new Vector(30, 20, false), 100);
    makeHashMatch();

    String file="save.txt";
    String[] lines =loadStrings(file) ;
    ents[0].skin=int(lines[2]);
    playMusic("music/game.wav");
    break;

    //MENU DE PARAMETRES
  case SETTINGS:
    buttons=new Button[4];
    buttons[0]=new Button(ButtonType.RECTA, new Vector(width - 300, 400, false), new Vector(200, 100, false), "Skin", 90, Activity.SKIN, color(255, 255, 255));
    buttons[1]=new Button(ButtonType.RECTA, new Vector(width - 300, 520, false), new Vector(200, 100, false), "Bonus", 60, Activity.BONUS, color(255, 255, 255));
    buttons[2]=new Button(ButtonType.RECTA, new Vector(width - 300, 640, false), new Vector(200, 100, false), "Infos", 60, Activity.INFOS, color(255, 255, 255));
    buttons[3]=new Button(ButtonType.RECTA, new Vector(width - 300, height - 90, false), new Vector(250, 55, false), "Back to main menu", 25, Activity.START_MENU, color(255, 255, 255));
    break;

    //MENU MULTI JOUEUR
  case MULTI:
    buttons=new Button[2];
    buttons[0]=new Button(ButtonType.RECTA, new Vector(width - 300, height - 90, false), new Vector(250, 55, false), "Back to main menu", 26, Activity.START_MENU, color(255, 255, 255));
    buttons[1]=new Button(ButtonType.RECTA, new Vector(width - 600, height - 90, false), new Vector(250, 55, false), "About multiplayer", 26, Activity.INFOS, color(255, 255, 255));
    break;

    //MENU DE SELECTION DE VAISSEAU
  case SKIN:
    buttons=new Button[3];
    buttons[0]=new Button(ButtonType.TRIANG, new Vector(width*0.30, height/2, false), new Vector(100, 100, false), "G", 300, Action.CHANGE_SKIN_M, color(255, 255, 255));
    buttons[1]=new Button(ButtonType.TRIANG, new Vector(width*0.70, height/2, false), new Vector(100, 100, false), "D", 300, Action.CHANGE_SKIN_P, color(255, 255, 255));
    buttons[2]=new Button(ButtonType.RECTA, new Vector(width - 300, height - 90, false), new Vector(250, 55, false), "Back to main menu", 25, Activity.START_MENU, color(255, 255, 255));
    break;

    //MENU DE FIN DE JEU / MORT
  case DEADSCREEN:
    buttons = new Button[2];
    buttons[0] = new Button(ButtonType.RECTA, new Vector(100, height - 200, false), new Vector(250, 60, false), "Respawn", 50, Activity.GAME, color(255, 255, 255));
    buttons[1] = new Button(ButtonType.RECTA, new Vector(width - 320, height - 200, false), new Vector(250, 60, false), "Main menu", 40, Activity.START_MENU, color(255, 255, 255));
    playMusic("music/dead.wav");
    break;

    //MENU DES BONUS
  case BONUS:
    buttons = new Button[1];
    buttons[0]=new Button(ButtonType.RECTA, new Vector(width - 300, height - 90, false), new Vector(250, 55, false), "Back to main menu", 25, Activity.START_MENU, color(255, 255, 255));
    break;

    //MENU D'INFORMATIONS
  case INFOS:
    buttons = new Button[1];
    buttons[0]=new Button(ButtonType.RECTA, new Vector(width - 300, height - 90, false), new Vector(250, 55, false), "Back to main menu", 25, Activity.START_MENU, color(255, 255, 255));
    break;
  }
  activity=act;
}

void showGame() {
  camera.update();
  actWithTime();
  //  tryCollide(ents);
  applySpeed(ents);

  showEntities();
  showLasers();

  if (findPlayer()==-1) {
    timerToDeathScreen++;
    playMusic("music/dead.wav");
    background.changeColor(color(0), 3);
    background.changeSpeed(60,2 );
  } else
    timerToDeathScreen=0;
    if(frameCount%100==0)
      lasers=(Laser[])append(lasers,new Laser());
  if (timerToDeathScreen>=2*frameRate)changeActivity(Activity.DEADSCREEN);

  makeSpawn();
}