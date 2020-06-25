import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
Minim minim;
AudioPlayer music;
String actualMusic;

enum Action {
  CHANGE_ACTIVITY, 
    FREE_CAM, 
    CHANGE_SKIN_P, 
    CHANGE_SKIN_M
}
enum Activity {
  START_MENU, 
    GAME, 
    CHOOSE_VESSEL, 
    BONUS, 
    INFOS, 
    MULTI, 
    SKIN, 
    SETTINGS, 
    DEADSCREEN
}
enum Ai {
  KAMIKAZE, 
    PLAYER, 
    TIME_BOMB, 
    MISSILE, 
    EXPLOSION, 
    SNIPER, 
    LASER, 
    AREA_OF_DAMAGE, 
    TAKE_DAMAGE, 
    EXPLODE_ON_PLAYER_CONTACT, 
    EXPLODE_ON_VESSEL_CONTACT, 
    BOUNCE, 
    VESSEL, 
    STICK, 
    HEALTH, 
    DEATH_RAY, 
    BONUS
}
enum WeaponType {
  BIG_BOMB, 
    SMALL_LASER, 
    LASER
}
enum ButtonType {
  RECTA, 
    TRIANG
}
enum Appearance {
  RECTANGLE, 
    PLAYER, 
    PROJECTILE, 
    EXPLOSION, 
    MECHANT, 
    BONUS, 
    HEALTH
}

Activity activity;         //Variables qui permetent de décrire de plus

PImage[] playableVessels;  //Tableaux qui contiennent les différentes images du jeu
PImage[] projectiles;
PImage[] mechants;
PImage[] autres;
PImage[] explosions;
PImage[] fire;

Entity[] ents;             //Liste des entités
Button[] buttons;          //Liste des boutons
Laser[] lasers;

Camera camera=new Camera();//Camera qui permet d'afficher tout ce qui n'est pas HUD à l'écran
Background background;
int timerToDeathScreen;
int score;
boolean pause=false;

void setup() {
  //MUSIQUE
  minim = new Minim(this);
  music = minim.loadFile("music/menus.wav");
  actualMusic="music/menus.wav";
  music.play();
  music.setGain(-24);
  music.loop();

  fullScreen();
  pixelDensity(2);
  //size(1000, 600);         //On définit la taille de l'écran
  background=new Background(new Vector(width, height, false));
  loadImages();            //On charge toutes les images dans les différents tableaux d'images
  changeActivity(Activity.START_MENU);       //On commence au menu de démarage
}
void draw() {
  if (!pause) {
    background.draw();
    showActivity(activity);//On affiche l'activité
    showHUD(activity);     //Puis l'HUD (tout ce qui est "collé" à l'écran et qui ne dépend pas de la camera)
  } else
    showText("Pause", width/10, new Vector(0.35*width, 0.5*height, false), color(255, 255, 255));
}