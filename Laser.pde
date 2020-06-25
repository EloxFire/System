class Laser {
  static final int minTime=30, maxTime=120, distBetweenLasers=200, activTime=60, l=50;
  boolean orientation;//true=>vertical
  float position;
  int time;
  boolean activated;
  int hash;
  float speed;

  Laser() {
    if (lasers==null)
      hash=0;
    else
      hash=lasers.length;

    orientation=int(random(0, 100))%2==0;
    activated=int(random(0, 100))%5==0;
    if (activated) {
      speed=random(-5, 5);
      position=speed>0?-l/2:orientation?width+l/2:height+l/2;
    } else {
      do
        position=random(0, orientation?width:height);
      while (minDistance(position, orientation)<distBetweenLasers);
    }
    time=(activated?2:1)*int(random(minTime, maxTime));
  }
  void draw() {
    position+=speed;
    pushStyle();
    stroke(150, speed!=0?255:0, 0);
    fill(150, speed!=0?255:0, 0);
    if (activated) {
      if (orientation)
        rect(position-l/2, 0, l, height);
      else
        rect(0, position-l/2, width, l);
    } else {
      if (orientation)
        line(position, 0, position, height);
      else
        line(0, position, width, position);
    }
    popStyle();

    time--;
    if (time==0) {
      if (!activated) {
        activated=true;
        time=activTime;
      } else
        destroyLaser(hash);
    }
    if (activated)tryToHurt();
  }
  void tryToHurt() {
    float gPos=orientation?camera.screenToGameX(position):camera.screenToGameY(position);
    for (int i=0; i<ents.length; i++) {
      if (orientation) {
        if (ents[i].pos.x+ents[i].size.x/2>gPos-l/2&&ents[i].pos.x-ents[i].size.x/2<gPos+l/2)
          ents[i].damage(400);
      } else if (!orientation) {
        if (ents[i].pos.y+ents[i].size.y/2>gPos-l/2&&ents[i].pos.y-ents[i].size.y/2<gPos+l/2)
          ents[i].damage(400);
      }
    }
  }
}
void destroyLaser(int h) {
  if (lasers.length==1)
    lasers=new Laser[0];
  else if (lasers.length>1) {
    if (h<lasers.length-1) {
      lasers[h]=lasers[lasers.length-1];
      lasers[h].hash=h;
    }
    lasers=(Laser[])shorten(lasers);
  }
}
float minDistance(float d, boolean o) {
  if (lasers!=null) {
    float m=width;
    for (int i=0; i<lasers.length; i++)
      if (lasers[i].orientation==o&&abs(lasers[i].position-d)<m)
        m=abs(lasers[i].position-d);
    return m;
  } else
    return width;
}
void showLasers() {
  if (lasers!=null)
    for (int i=0; i<lasers.length; i++)
      lasers[i].draw();
}