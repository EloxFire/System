class Background {
  final static int h=50;

  Vector size;
  Chunk[] chunks;
  float speed=3;
  float speedRequest;
  float speedAcceleration;

  color colorRequest;
  color oldColor;
  int colorSpeed;

  Background(Vector pSize) {
    size=pSize.getClone();
    int n=int(size.y/h)+3;
    chunks=new Chunk[n];
    for (int i=0; i<n; i++)
      chunks[i]=new Chunk(i*h, 0, 8, i);
  }
  void changeSpeed(float newSpeed, float time) {
    if (newSpeed!=speedRequest) {
      speedAcceleration=(newSpeed-speed)/(time*frameRate);
      speedRequest=newSpeed;
    }
  }
  void draw() {
    if (abs(speedRequest-speed)<abs(speedAcceleration))
      speed=speedRequest;
    else {
      speed+=speedAcceleration;
      if (ents!=null)for (int i=0; i<ents.length; i++)
        ents[i].speed.y-=speedAcceleration*10;
    }
    for (int i=0; i<chunks.length; i++)
      chunks[i].draw();
    if (keyPressed) {
      if (key=='r')
        changeColor(color(255, 0, 0), 10);
      else if (key=='t')
        changeColor(color(0, 255, 0), 10);
      else
        changeColor(color(0), 10);
    }
  }
  void changeColor(color c, int s) {
    colorRequest=c;
    colorSpeed=s;
  }
  int after(int id) {
    if (speed>=0)
      return id+1==chunks.length?0:id+1;
    else
      return id==0?chunks.length-1:id-1;
  }
  void reset(int id) {
    if (chunks[after(id)].c2==colorRequest) {//Si le chunk suivant a déja commencé à changer de couleur
      chunks[id].opacity=chunks[after(id)].opacity+colorSpeed;//On augmente l'opacité de notre chunk

      if (chunks[id].opacity>255)//255 est le max
        chunks[id].opacity=255;
    } else {//Sinon, cela veut dire que l'on est le premier à changer
      if (chunks[after(id)].opacity==255)//Si on est totalement opaque, c'est à dire que l'ancien changement a été total
        oldColor=chunks[id].c2;//On set l'ancienne couleur à la couleur que l'on avait auparavant
      else { //Sinon, l'ancienne couleur sera celle du chunk précédent
        loadPixels();
        oldColor=pixels[width*(int)(chunks[after(id)].pos+Background.h)];
        println(oldColor);
      }

      chunks[id].opacity=0;
    }

    chunks[id].c1=oldColor;
    chunks[id].c2=colorRequest;
  }
}
class Chunk {
  float pos, opacity=255;
  Vector[] stars;
  color c1, c2;
  int hash;

  Chunk(int pPos, int min, int max, int pHash) {
    hash=pHash;
    pos=pPos;
    int n=(int)random(min, max);
    stars=new Vector[n];
    for (int i=0; i<n; i++) {
      Vector v;
      do {
        v=new Vector((int)random(width), (int)random(Background.h), false);
      } while (v.getNorm()==0);
      stars[i]=v;
    }
    opacity=255;
    c1=color(0);
    c2=color(0);
  }
  void draw() {
    pos+=background.speed;
    if (pos>height+Background.h) {
      pos-=background.chunks.length*background.h;
      background.reset(hash);
    } else if (pos<-2*Background.h) {
      pos+=background.chunks.length*background.h; 
      background.reset(hash);
    }

    pushStyle();
    noStroke();
    fill(c1);
    rect(0, pos, width, background.h);
    fill(c2, opacity);
    //fill(color(random(255) ,random(255),random(255)));
    rect(0, pos, width, background.h);
    stroke(255);
    for (int i=0; i<stars.length; i++)
      point(stars[i].x, stars[i].y+pos);
    popStyle();
  }
}
