class Vector {
  /////////////
  //Variables//
  /////////////
  float x;
  float y;

  //////////////
  //Définition//
  //////////////
  Vector() {
    x=(int)random(255);
    y=(int)random(255);
  }
  Vector(int n) {
    x=n;
    y=n;
  }
  Vector(float n) {
    x=n;
    y=n;
  }
  Vector(float a, float b, boolean mod) {
    if (mod) {
      x=a*cos(b);
      y=a*sin(b);
    } else {
      x=a;
      y=b;
    }
  }

  //////////////
  //Opérations//
  //////////////
  void add(Vector vect) {
    x+=vect.x;
    y+=vect.y;
  }
  void rem(Vector vect) {
    x-=vect.x;
    y-=vect.y;
  }
  void mult(float i) {
    x*=i;
    y*=i;
  }
  void div(float i) {
    x*=i;
    y*=i;
  }
  void rotate(float i) {
    Vector v=new Vector(getNorm(), getAngle()+i, true);
    x=v.x;
    y=v.y;
  }

  ////////////////
  //Informations//
  ////////////////
  float getNorm() {
    return sqrt(sq(x)+sq(y));
  }
  float getAngle() {
    return (y<0?-1:1)*(getNorm()==0?0:acos(x/getNorm()));
  }

  ///////////////////////////////
  //Informations inter-vecteurs//
  ///////////////////////////////
  float getAngle(Vector vect) {
    return vect.getAngle()-getAngle();
  }
  float getAngle(float angle) {
    return cleanAngle(angle-getAngle());
  }
  float onRadar(Vector v) {
    return minus(v, this).getAngle();
  }
  float scal(Vector v) {
    return x*v.x+y*v.y;
  }
  float projetedOn(Vector v) {
    return scal(v)/v.getNorm();
  }
  float projetedOn(float angle) {
    return getNorm()*cos(getAngle(angle));
  }

  ////////
  //Méta//
  ////////
  Vector getClone() {
    return new Vector(x, y, false);
  }
  void print() {
    println("X:"+x+" Y:"+y);
  }
  void show(Vector v, color c) {
    stroke(c);
    line(x, y, v.x+x, -v.y+y);
  }
}
