float round(float n, int d) {//Arrondissement de n à 10^-d près
  return round(pow(10, d)*n)/pow(10, d);
}
float cleanAngle(float angle) {
  while(angle>PI)
    angle-=2*PI;
  while(angle<=-PI)
    angle+=2*PI;
  return angle;
}

//Opérations sur des tableaux
int minA(float[] array) {
  int m=0;
  for (int i=1; i<array.length; i++) {
    if (array[i]<array[m])
      m=i;
  }
  return m;
}
int maxA(float[] array) {
  int m=0;
  for (int i=1; i<array.length; i++) {
    if (array[i]>array[m])
      m=i;
  }
  return m;
}
float minV(float[] array) {
  return array[minA(array)];
}
float maxV(float[] array) {
  return array[maxA(array)];
}
float extrem(float[] array) {
  return maxV(array)-minV(array);
}
float moyenne(float[] array) {
  float m=0;
  for (int i=0; i<array.length; i++) {
    m+=array[i];
  }
  return (float)(m/array.length);
}

//Opérations sur des vecteurs
Vector times(Vector vect, float nb) {
  return new Vector(vect.x*nb, vect.y*nb, false);
}
Vector dividedBy(Vector vect, float nb) {
  return new Vector(vect.x/nb, vect.y/nb, false);
}
Vector plus(Vector vect, Vector vect2) {
  return new Vector(vect.x+vect2.x, vect.y+vect2.y, false);
}
Vector minus(Vector vect, Vector vect2) {
  return new Vector(vect.x-vect2.x, vect.y-vect2.y, false);
}
Vector minus(Vector vect, float nb) {
  return new Vector(vect.x-nb, vect.y-nb, false);
}
Vector center(Vector v1, Vector v2) {
  return times(plus(v1, v2), 0.5);
}