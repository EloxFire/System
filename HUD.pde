void showHUD(Activity act) {
  switch(act) {
  case GAME:
    if (findPlayer()>-1) {
      showLife(ents[findPlayer()].hp);
      showSpeed(ents[findPlayer()].speed, 1);
      showText("Time : "+round(camera.date, 2), width/70, new Vector(0.9*width, height/50, false), color(255, 255, 255));
      showText("Score : "+score, width/70, new Vector(width/10, height/50, false), color(255, 255, 255));
      showText("FrameSpawn : "+probability(), width/70, new Vector(width/1.5, height/50, false), color(255, 255, 255));
      showArrow(camera.gameToScreen(ents[findPlayer()].pos));

      for (int i=0; i<ents[findPlayer()].weapon.length; i++) {
        String text;
        if (ents[findPlayer()].weapon[i] != null) {
          text = ""+ents[findPlayer()].weapon[i].munitions;
          drawImage(projectiles[ents[findPlayer()].weapon[i].projectile.skin], width/2 + width/5 + 32 + i*100, height - 100, 70/2, 40/2, -PI/4);
        } else {
          text = "0";
        }
        showText(text, width/70, new Vector(width/2 + width/5 + (i*98), height - 55, false), color(255, 255, 255));
        if (i==ents[findPlayer()].actualWeapon) {
          stroke(255, 0, 0);
          rect(width/2 + width/5 + i*97.5, height-120, 70, 70);
          pushStyle();
          fill(255, 0, 0);
          triangle((width/2 + 390 + i*97.5) + 20, height-20, (width/2 + 390 + i*97.5) + 30, height-35, (width/2 + 390 + i*97.5) + 40, height-20);
          popStyle();
        } else {
          stroke(255);
          noFill();
          rect(width/2 + width/5 + i*97.5, height-120, 70, 70);
        }
      }
    }
    break;
  case SETTINGS:
    showSettings();
    break;
  case MULTI:
    multiplayerMenu();
    break;
  case SKIN:
    selectVessel();
    break;
  case DEADSCREEN:
    deadScreen();
    break;
  case BONUS:
    showBonusMenu();
    break;
  case INFOS:
    showInfosMenu();
    break;
  }
  showButtons();
}

void showBar(Vector pos, Vector size, color color1, color color2, float percentage) {
  pos=minus(pos, dividedBy(size, 2));
  pushStyle();
  noStroke();
  fill(color1);//Barre
  rect(pos.x, pos.y, size.x, size.y);
  fill(color2);//Vie
  rect(pos.x, pos.y, percentage*size.x/100, size.y);
  popStyle();
}
void showText(String text, float size, Vector p, color c) {
  pushStyle();
  fill(c);
  textSize(size);
  text(text, p.x, p.y);
  popStyle();
}
void showHorloge(float angle, Vector p, float size, color c) {
  pushStyle();
  stroke(c);
  noFill();
  ellipse(p.x, p.y, size, size);
  p.show(new Vector(size/2.1, angle, true), c);
  popStyle();
}
void drawImage(PImage img, float x, float y, float sizeX, float sizeY, float angle) {
  pushMatrix();
  pushStyle();
  translate(x, y);
  rotate(angle);
  image(img, -sizeX/2, -sizeY/2, sizeX, sizeY);
  popStyle();
  popMatrix();
}


void showArrow(Vector p) {
  Vector arrow=new Vector(0);
  float dist=20;
  boolean in=true;

  if (p.x<dist||p.x>width-dist) {
    if (p.x<dist)
      arrow.x=dist;
    else
      arrow.x=width-dist;
    arrow.y=p.y;
    in=false;
  }
  if (p.y<dist||p.y>height-dist) {
    if (p.y<dist)
      arrow.y=dist;
    else
      arrow.y=height-dist;
    if (in)
      arrow.x=p.x;
    in=false;
  }
  if (!in)
    drawImage(autres[1], arrow.x, arrow.y, dist, dist, arrow.onRadar(p));
}
void showLife(float life) {//Affiche une barre de vie (en %)
  showText("Life :", width/70, new Vector(width/45, 0.92*height, false), color(255, 255, 255));
  showBar(new Vector(width/10, 0.96*height, false), new Vector(width/6, width/60, false), color(255, 0, 0), color(0, 255, 0), life);
}
void showSpeed(Vector speed, int precision) {//Affiche la vitesse
  showText("Speed :", width/70, new Vector(width/4, 0.92*height, false), color(255, 255, 255));
  showText(round(speed.getNorm(), precision) + " Px/s", width/80, new Vector(width/4.5, 0.96*height, false), color(255, 255, 255));
  showHorloge(speed.getAngle(), new Vector(width/3.3, 0.95*height, false), 20, color(255, 255, 255));
}

void showMunitions(float percent, int proj) {//Affiche un cercle avec les munitions
  pushStyle();
  pushMatrix();
  textSize(width/45);//Affichage du texte
  text("Munitions", 0.68*width, 0.92*height);
  noStroke();
  fill(255, 0, 0);//Affichage du disque complet
  ellipse(0.71*width, 0.96*height, width/28, width/28);
  fill(0, 255, 0);//Affichage de l'arc
  arc(0.71*width, 0.96*height, width/28, width/28, -PI/2, percent*PI/50-PI/2);
  translate(0.78*width, 0.95*height);
  rotate(0.75*PI);
  image(projectiles[proj], 0, 0, width/30, width/60);
  popMatrix();
  popStyle();
}

void showCross() {
  pushStyle();
  stroke(255);
  line(width/2+10, height/2, width/2-10, height/2);
  line(width/2, height/2+10, width/2, height/2-10);
  popStyle();
}
void showButtons() {
  for (int i=0; i<buttons.length; i++)
    buttons[i].draw();
}
