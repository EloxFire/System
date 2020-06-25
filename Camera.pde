class Camera {
  Vector coord;
  float zoom;
  float date;

  Camera() {
    coord=new Vector(0, 0, false);
    zoom=1;
    date=0;
  }
  float gameToScreenX(float x) {
    return width/2-(float)(coord.x-x)*zoom;
  }
  float gameToScreenY(float y) {
    return height/2+(float)(coord.y-y)*zoom;
  }
  float screenToGameX(float x) {
    return (x-width/2)/zoom-coord.x;
  }
  float screenToGameY(float y) {
    return coord.y-(y-height/2)/zoom;
  }
  Vector gameToScreen(Vector v) {
    return new Vector(gameToScreenX(v.x), gameToScreenY(v.y), false);
  }
  Vector screenToGame(Vector v) {
    return new Vector(screenToGameX(v.x), screenToGameY(v.y), false);
  }
  Vector cursorPos() {
    return screenToGame(new Vector(mouseX, mouseY, false));
  }

  void drawImage(PImage img, float x, float y, float sizeX, float sizeY, float angle) {
    pushMatrix();
    translate(camera.gameToScreenX(x), camera.gameToScreenY(y));
    rotate(-angle);
    //noStroke();fill(255);rect(-sizeX*camera.zoom/2, -sizeY*camera.zoom/2, sizeX*camera.zoom, sizeY*camera.zoom);
    image(img, -sizeX*camera.zoom/2, -sizeY*camera.zoom/2, sizeX*camera.zoom, sizeY*camera.zoom);
    popMatrix();
  }
  void drawImage(PImage img, Vector pPos, Vector pSize, float angle) {
    drawImage(img, pPos.x, pPos.y, pSize.x, pSize.y, angle);
  }
  void update(){
    date+=1/frameRate;
  }
}
