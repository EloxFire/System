class Entity {
  /////////////
  //Variables//
  /////////////
  int hash;//Identifiant de l'entité
  Vector pos;
  Vector speed;
  Vector size;
  Weapon[] weapon;

  int mass;
  int skin;
  float angle;
  float explosionRay;
  float damage;
  int actualWeapon;

  Ai[] ai;
  Appearance ap;
  float time;
  int fireStep;
  boolean memoryBool=false;
  Vector memoryVector;

  int acceleration;
  float rotationSpeed;
  float hp;
  float limit;//Limite de vitesse tangentielle
  int armor;

  ///////////////
  //Déclaration//
  ///////////////
  Entity() {
    ap=Appearance.RECTANGLE;
    pos=new Vector(0);
    speed=new Vector(0);
    size=new Vector(1);
    weapon=new Weapon[5];
    mass=1;
    explosionRay=0;
    damage=0;
    angle=0;
    actualWeapon=0;
    hp=100;
    hash=ents.length;
    armor=1;
  }
  Entity(Ai pAi, Vector pPos, Vector pSpeed, Vector pSize) {
    this();
    pos=pPos;
    speed=pSpeed;
    size=pSize;
    ai=new Ai[1];
    ai[0]=pAi;
    switch(pAi) {
    case TIME_BOMB:
      time=5;//Temps avent que le missile n'explose
      break;
    case MISSILE:
      ap=Appearance.PROJECTILE;
      skin=1;
      rotationSpeed=PI/4;
      ai=(Ai[])append(ai, Ai.TIME_BOMB);
      ai=(Ai[])append(ai, Ai.STICK);
      ai=(Ai[])append(ai, Ai.EXPLODE_ON_VESSEL_CONTACT);
      time=5;
      break;
    case PLAYER:
      ap=Appearance.PLAYER;
      skin=0;
      ai=(Ai[])append(ai, Ai.VESSEL);
      ai=(Ai[])append(ai, Ai.BOUNCE);
      ai=(Ai[])append(ai, Ai.TAKE_DAMAGE);
      weaponInit();
      weapon[0]=new Weapon(WeaponType.SMALL_LASER);
      acceleration=400;
      explosionRay=300;
      damage=500;
      rotationSpeed=2*PI;
      armor=11;
      break;
    case KAMIKAZE:
      ap=Appearance.MECHANT;
      limit=(int)random(50, 200);
      skin=0;
      explosionRay=250;
      damage=400;
      ai=(Ai[])append(ai, Ai.VESSEL);
      ai=(Ai[])append(ai, Ai.BOUNCE);
      ai=(Ai[])append(ai, Ai.TAKE_DAMAGE);
      ai=(Ai[])append(ai, Ai.EXPLODE_ON_PLAYER_CONTACT);
      rotationSpeed=PI;
      acceleration=100;
      armor=4;
      break;
    case EXPLOSION:
      time=5;
      break;
    case SNIPER:
      ap=Appearance.MECHANT;
      memoryVector=pos.getClone();
      memoryBool=true;
      ai=(Ai[])append(ai, Ai.VESSEL);
      ai=(Ai[])append(ai, Ai.BOUNCE);
      ai=(Ai[])append(ai, Ai.TAKE_DAMAGE);
      skin=1;
      explosionRay=300;
      damage=500;
      weapon[0]=new Weapon(WeaponType.SMALL_LASER);
      rotationSpeed=PI*2;
      acceleration=200;
      break;
    case HEALTH:
      skin=6;
      armor=20;
      break;
    }
  }
  Entity(Ai pAi, Vector pPos, Vector pSpeed, Vector pSize, int pMass) {
    this(pAi, pPos, pSpeed, pSize);
    mass=pMass;
  }
  Entity(Ai pAi, Vector pPos, Vector pSpeed, Vector pSize, int pMass, float pAngle) {
    this(pAi, pPos, pSpeed, pSize, pMass);
    angle=pAngle;
  }
  Entity(Ai pAi, Vector pPos, Vector pSpeed, Vector pSize, int pMass, float pAngle, int pSkin) {
    this(pAi, pPos, pSpeed, pSize, pMass, pAngle);
    skin=pSkin;
  }
  void weaponInit() {
    weapon[0]=new Weapon(WeaponType.SMALL_LASER);
    weapon[1]=new Weapon(WeaponType.BIG_BOMB);
    for (int i=0; i<weapon.length; i++)
      if (weapon[i]!=null)
        weapon[i].munitions=0;
  }

  /////////////
  //Affichage//
  /////////////
  void show(Vector v) {
    camera.gameToScreen(pos).show(v, color(255, 0, 0));
  }
  void show(Vector v, color c) {
    camera.gameToScreen(pos).show(v, c);
  }
  void draw() {
    update(weapon);
    applyIntelligence();
    show();
  }
  void showHP() {
    Vector p=minus(camera.gameToScreen(pos), new Vector(0, 20, false));
    showBar(p, new Vector(10, 5, false), color(255, 0, 0), color(0, 255, 0), hp);
  }
  void show() {
    switch(ap) {
    case RECTANGLE:
      break;
    case PROJECTILE:
      camera.drawImage(projectiles[skin], pos.x, pos.y, size.x, size.y, angle);
      break;
    case MECHANT:
      camera.drawImage(mechants[skin], pos.x, pos.y, size.x, size.y, angle);
      break;
    case EXPLOSION:
      camera.drawImage(explosions[skin], pos.x, pos.y, size.x, size.y, angle);
      break;
    case HEALTH:
      camera.drawImage(autres[0], pos.x, pos.y, size.x, size.y, angle);
      break;
    case BONUS:
      camera.drawImage(projectiles[skin], pos.x, pos.y, size.x/1.5, size.y/1.5, angle);
      pushStyle();
      noFill();
      stroke(255, 127, 80);
      strokeWeight(4);
      ellipse(camera.gameToScreenX(pos.x), camera.gameToScreenY(pos.y), size.x, size.y);
      popStyle();
      break;
    case PLAYER:
      camera.drawImage(playableVessels[skin], pos.x, pos.y, size.x, size.y, angle);
      break;
    }
  }

  /////////////
  //Collision//
  /////////////
  Vector[] listOfPoints() {
    Vector[] resp={new Vector(size.x/2, size.y/2, false), new Vector(-size.x/2, size.y/2, false), new Vector(size.x/2, -size.y/2, false), new Vector(-size.x/2, -size.y/2, false)};
    for (int i=0; i<resp.length; i++) {
      resp[i].rotate(angle);
      resp[i].add(pos);
    }
    return resp;
  }
  float[] extremums(Vector[] list, float angle) {
    float m=list[0].projetedOn(angle);
    float[] resp={m, m};
    for (int i=1; i<list.length; i++) {
      m=list[i].projetedOn(angle);
      if (m<resp[0])
        resp[0]=m;
      else if (m>resp[1])
        resp[1]=m;
    }
    return resp;
  }
  boolean isConcatened(float[] u, float[] v) {
    println(u[1]-v[0]);
    return u[1]<=v[0]||v[1]<=u[0];
  }
  boolean isConcatened(Vector[] u, Vector[] v, float angle) {
    return isConcatened(extremums(u, angle), extremums(v, angle));
  }
  boolean detectCollision(Entity ent) {
    return dividedBy(size, 2).getNorm()+dividedBy(ent.size, 2).getNorm()>=distance(ent).getNorm();
    //Vector[] l1=listOfPoints(), l2=ent.listOfPoints();
    //return isConcatened(l1, l2, angle)&&isConcatened(l1, l2, angle+PI/2)&&isConcatened(l1, l2, ent.angle)&&isConcatened(l1, l2, ent.angle+PI/2);
  }
  int[] detectCollision(Entity[] ent) {
    int[] a=new int[0];
    for (int i=0; i<ent.length; i++) {
      if (detectCollision(ent[i])&&ent[i].hash!=hash) {
        a=append(a, i);
      }
    }
    return a;
  }
  boolean isOnMe() {
    return false;//camera.cursorPos().getDist(pos).getNorm()<size.x;
  }
  void collide(Entity e) {
    if (contains(ai, Ai.AREA_OF_DAMAGE))
      e.damage(damage);
    //else if (contains(e.ai, Ai.AREA_OF_DAMAGE))
    //damage(e.explosionRay);

    if ((contains(ai, Ai.STICK)&&contains(e.ai, Ai.BOUNCE))||(contains(e.ai, Ai.STICK)&&contains(ai, Ai.BOUNCE)))
      stick(e);
    else if (contains(ai, Ai.BOUNCE)&&contains(e.ai, Ai.BOUNCE))
      bounce(e);

    if (contains(ai, Ai.EXPLODE_ON_PLAYER_CONTACT)&&contains(e.ai, Ai.PLAYER))
      explode();
    else if (contains(e.ai, Ai.EXPLODE_ON_PLAYER_CONTACT)&&contains(ai, Ai.PLAYER))
      e.explode();
    else if (contains(ai, Ai.EXPLODE_ON_VESSEL_CONTACT)&&contains(e.ai, Ai.VESSEL))
      explode();
    else if (contains(e.ai, Ai.EXPLODE_ON_VESSEL_CONTACT)&&contains(ai, Ai.VESSEL))
      e.explode();

    if (contains(e.ai, Ai.EXPLOSION)&&contains(ai, Ai.TIME_BOMB)&&time>0.2)
      time=0.2;
    else if (contains(ai, Ai.EXPLOSION)&&contains(e.ai, Ai.TIME_BOMB)&&e.time>0.2)
      e.time=0.2;

    if (contains(ai, Ai.HEALTH)&&contains(e.ai, Ai.PLAYER)) {
      e.hp+=hp;
      if (e.hp>100)
        e.hp=100;
      destroy();
    }
    if (contains(ai, Ai.BONUS)&&contains(e.ai, Ai.PLAYER)) {
      for (int i=0; i<e.weapon.length; i++) {
        if (e.weapon[i]!=null&&e.weapon[i].projectile.skin==skin)
          e.weapon[i].munitions+=hp;
      }
      destroy();
    }
  }
  void bounce(Entity e) {
    Vector dist=distance(e);
    float a=dist.getAngle();
    Vector center=plus(pos, dividedBy(dist, 2));
    Vector rel=new Vector(relativeSpeed(e).projetedOn(a), a, true);
    e.speed.add(times(rel, mass/e.mass));
    speed.rem(times(rel, e.mass/mass));
    pos.rem(new Vector(rel.getNorm()/(2*frameRate), pos.onRadar(center), true));
    e.pos.rem(new Vector(rel.getNorm()/(2*frameRate), e.pos.onRadar(center), true));

    if (rel.getNorm()>50) {
      damage(rel.getNorm()*e.mass/5);
      e.damage(rel.getNorm()*mass/5);
    }
  }
  void stick(Entity e) {
    Vector rel=relativeSpeed(e);
    Vector newSpeed=dividedBy(plus(times(speed, mass), times(e.speed, e.mass)), mass+e.mass);
    speed=newSpeed.getClone();
    e.speed=newSpeed;

    if (rel.getNorm()>50) {
      damage(rel.getNorm()*e.mass/5);
      e.damage(rel.getNorm()*mass/5);
    }
  }

  ///////////////
  //Information//
  ///////////////
  float onRadar(Entity ent) {
    return pos.onRadar(ent.pos);
  }
  boolean isLookingAt(float target, float precision) {
    return sq(cleanAngle(angle-target))<=sq(precision);
  }
  boolean isLookingAt(float target) {
    return isLookingAt(target, PI/16);
  }
  Vector relativeSpeed(Entity e) {
    return minus(speed, e.speed);
  }
  Vector distance(Entity e) {
    return distance(e.pos);
  }
  Vector distance(Vector v) {
    return minus(v, pos);
  }
  float timeToRotate(float a) {
    return cleanAngle(angle-a)/rotationSpeed;
  }

  /////////////////////////
  //Action de déplacement//
  /////////////////////////
  void goTo(float target) {
    lookAt(target);
    if (isLookingAt(target, PI/20))
      acceleration();
  }
  void goTo(float target, int power) {
    if (power>100)power=100;
    lookAt(target);
    if (isLookingAt(target, PI/20))
      acceleration(power);
  }
  boolean goTo(Vector target) {
    return goTo(target, new Vector(0));
  }
  boolean goTo(Vector target, Vector targetSpeed) {
    Vector relativeSpeed=minus(speed, targetSpeed);
    float distance=distance(target).getNorm();
    float relativeSpeedNorm=relativeSpeed.getNorm();

    if (relativeSpeedNorm>acceleration/frameRate||distance>10*acceleration/frameRate) {//Si on n'est pas à la position cible ni à la vitesse cible (à peu près)
      float limit=distance/5;//Limite de vitesse tengencielle acceptable (dépend de la distance)
      float angleWithTarget=pos.onRadar(target);//Position angulaite de la cible

      float normalSpeed=relativeSpeed.projetedOn(angleWithTarget+PI);//Vitesse normale relative (vers la cible) => on décompose le vecteur vitesse pour calculer les actions à effectuer
      float tangentialSpeed=relativeSpeed.projetedOn(angleWithTarget-PI/2);//Vitesse tangentielle relative (perpendiculaire à la cible)

      float distToKillSpeed=sq(normalSpeed)/acceleration;//Distance que l'on vas parcourir pendant un freinage (calculé à l'aide des équations horaires x2 pour qu'il ai plus de temps)
      float distToRotate=timeToRotate(angleWithTarget)*relativeSpeedNorm;//Distance que l'on vas parcourir pendant la rotation se mettre dans l'axe
      float totalDistToStop=distToKillSpeed+distToRotate;//Distance totale pour le freinage (rotation+freinage)

      if (normalSpeed>0||totalDistToStop+acceleration/10<distance) {//Si on s'éloigne de la cible ou que l'on a plus de temps qu'il n'en faut pour freiner
        if (tangentialSpeed>limit)//Si la vitesse tangentielle est trop grande
          goTo(angleWithTarget+PI/2);//On va à fond à 90° pour la freiner le plus rapidement possible
        else if (tangentialSpeed<-limit)//Pareil si la vitesse est trop grande dans les négatifs
          goTo(angleWithTarget-PI/2);
        else//Sinon on fait un compromis entre vitesse tangentielle et normale
          goTo(angleWithTarget+(tangentialSpeed*PI)/(2*limit));
      } else if (totalDistToStop>=distance||relativeSpeedNorm>acceleration/10)//Si on est trop prêt de la cible et/ou que l'on a trop de vitesse
        goTo(relativeSpeed.getAngle()+PI);//On freine à fond
      else {//Sinon on adapte notre vitesse de freinage pour arriver à temps, le plus précisément possible
        int l=5;//Limite du minimum de poussée du moteur en % (sinon on freine trop lentement)
        int power=(int)(relativeSpeedNorm*100/acceleration);//Poussée du moteur en % en fonction de la vitesse relative
        power=power>l?power:l;//Si on est inferieur à la limite on se met à la limite
        goTo(relativeSpeed.getAngle()+PI, power);//On ralentit à la puissance définie
      }
    } else { //Si on est arrivé à la cible
      speed.rem(relativeSpeed);//On supprime la vitesse relative
      return true;
    }
    return false;
  }
  void killSpeed() {
    killSpeed(speed);
  }
  void killSpeed(Vector relativeSpeed) {
    if (relativeSpeed.getNorm()>acceleration/10)
      goTo(relativeSpeed.getAngle()+PI);
    else if (relativeSpeed.getNorm()>1) {
      int limit=5;
      int power=(int)(relativeSpeed.getNorm()*100/acceleration);
      power=power>limit?power:limit;
      goTo(relativeSpeed.getAngle()+PI, power);
    } else
      speed.rem(relativeSpeed);
  }
  boolean lookAt(float target) {
    if (isLookingAt(target, rotationSpeed/frameRate)) {
      angle=target;
      return true;
    } else {
      if (cleanAngle(target-angle)>0)
        rotation(true);
      else
        rotation(false);
      return false;
    }
  }
  void rotation(boolean sens) {//Rotation (true => sens trigo; false => sens anti-trigo)
    angle+=(sens?1:-1)*rotationSpeed/frameRate;
    angle=cleanAngle(angle);
  }
  void acceleration() { //Rotation (true=> avancer;false =>arret )
    acceleration(100);
  }
  void acceleration(int power) { //Rotation (true=> avancer;false =>arret )
    if (power>100)
      power=100;
    speed.add(new Vector(power*acceleration/(frameRate*100), angle, true));
    if (frameCount%5==0)
      fireStep=(fireStep+1)%fire.length;
    camera.drawImage(fire[fireStep], minus(pos, new Vector(size.x*power/100, angle, true)), times(size, 2*power/100), angle);
  }

  ////////////////
  //Autre action//
  ////////////////
  void shoot() {
    if (weapon[actualWeapon]!=null) {
      float resultante=weapon[actualWeapon].shoot(pos, speed, angle, size.getNorm());
      if (resultante>0)
        speed.add(new Vector(-resultante/mass, angle, true));
    }
  }
  void shoot(float angle) {
    if (lookAt(angle))
      shoot();
  }
  void shoot(Entity ent) {
    Vector relativeSpeed=relativeSpeed(ent);
    Vector distance=distance(ent);
    float x=distance.x, y=distance.y, a=relativeSpeed.x, b=relativeSpeed.y;

    float delta=2*(sq(weapon[actualWeapon].ejectionSpeed)*(sq(x)+sq(y))+2*x*a*y*b-sq(x*b)-sq(y*a));
    float t1=(x*a+y*b+sqrt(delta)/2)/(sq(weapon[actualWeapon].ejectionSpeed)+sq(a)+sq(b));
    float t2=(x*a+y*b-sqrt(delta)/2)/(sq(weapon[actualWeapon].ejectionSpeed)+sq(a)+sq(b));
    showText("DELTA "+delta, width/70, new Vector(0.5*width, 150, false), color(255, 255, 255));
    showText("T1 "+t1, width/70, new Vector(0.5*width, 200, false), color(255, 255, 255));
    showText("T2 "+t2, width/70, new Vector(0.5*width, 250, false), color(255, 255, 255));


    float ang=cleanAngle(distance.getAngle()+PI);

    float normalSpeed=relativeSpeed.projetedOn(ang);
    float tangentialSpeed=relativeSpeed.projetedOn(ang+PI/2);

    float timeToArrive=distance.getNorm()/(weapon[actualWeapon].ejectionSpeed-tangentialSpeed);
    showText("T3 "+timeToArrive, width/70, new Vector(0.5*width, 300, false), color(255, 255, 255));
    Vector relativeCoord=minus(distance(ent), times(relativeSpeed(ent), t1));
    Vector newCoord=plus(pos, relativeCoord);

    shoot(pos.onRadar(newCoord));
    newCoord=camera.gameToScreen(newCoord);
  }
  void damage(float d) {
    if (contains(ai, Ai.TAKE_DAMAGE)) {
      hp-=d/(armor*frameRate);
      if (hp<=0)
        explode();
      showHP();
    }
  }
  void damage() {
    hp-=10/frameRate;
    if (hp<=0)
      explode();
    showHP();
  }
  void explode() {
    if (contains(ai, Ai.KAMIKAZE))
      score+=10;
    else if (contains(ai, Ai.SNIPER))
      score+=30;

    size=new Vector(explosionRay);

    ai=new Ai[2];
    ai[0]=Ai.EXPLOSION;
    ai[1]=Ai.AREA_OF_DAMAGE;
    ap=Appearance.EXPLOSION;
    time=5;
  }
  void applyIntelligence() {
    for (int i=0; i<ai.length; i++) {
      switch(ai[i]) {
      case KAMIKAZE:// on veut faire en sorte que un objet suive le vaisseau
        int player=findPlayer();
        if (player>-1) {
          Entity target=ents[findPlayer()];
          Vector relativeSpeed=minus(target.speed, speed);//Vitesse à laquelle la cible va par rapport à nous
          float angleWithTarget=pos.onRadar(target.pos);//Angle avec la cible

          float tangentialSpeed=relativeSpeed.projetedOn(angleWithTarget+PI/2);//Vitesse tangentielle (perpendiculaire) avec la cible

          if (tangentialSpeed>limit)//Si la vitesse tengentielle dépasse la limite, on va à 90° à l'opposé de manière à la stopper le plus rapidement possible
            goTo(angleWithTarget+PI/2);
          else if (tangentialSpeed<-limit)//Pareil si elle est négative
            goTo(angleWithTarget-PI/2);
          else//Sinon on fait un compromis pour stopper la vitesse tangentielle et foncer vers la cible
            goTo(angleWithTarget+(tangentialSpeed*PI)/(2*limit));
        }
        break;
      case TIME_BOMB:
        time-=1/frameRate;
        if (time<=0)
          explode();
        break;
      case PLAYER:
        if (mousePressed) {
          if (mouseButton==LEFT) 
            shoot();
          if (mouseButton==RIGHT) {
            acceleration();
          }
          if (mouseButton==CENTER) {
            goTo(new Vector(0));
          } else
            lookAt(ents[findPlayer()].pos.onRadar(camera.cursorPos()));
        } else
          lookAt(ents[findPlayer()].pos.onRadar(camera.cursorPos()));
        break;
      case LASER:
        pos=plus(ents[findPlayer()].pos, new Vector(ents[findPlayer()].size.x+size.x/2, ents[findPlayer()].angle, true));
        angle=ents[findPlayer()].angle;
        break;
      case EXPLOSION:
        if (frameCount%time==0) {
          skin++;
        }
        if (skin>=explosions.length) {
          skin--;
          destroy();
        }
        break;
      case SNIPER:
        if (weapon[actualWeapon].time==0&&distance(memoryVector).getNorm()<100&&findPlayer()>-1) {
          shoot(ents[findPlayer()]);
        } else
          goTo(pos.onRadar(memoryVector));
        // else goTo(memoryVector);
        /*if (goTo(memoryVector)) {
         if (lookAt(pos.onRadar(ents[findPlayer()].pos)))
         shoot();
         }*/
        break;
      }
      if (pos.getNorm()>new Vector(width, height, false).getNorm())
        damage();
      int[] e=detectCollision(ents);
      for (int j=0; j<e.length; j++)
        collide(ents[e[j]]);
    }
  }

  ////////
  //Meta//
  ////////
  String type() {
    return getClass().getSimpleName();
  }
  boolean isTheLast() {
    return hash==ents.length-1;
  }
  Entity getClone(Vector pPos, Vector pSpeed, float pAngle) {
    Entity e=new Entity(ai[0], pPos, pSpeed, size.getClone(), mass, pAngle, skin);
    e.ai=ai;
    e.time=time;
    e.explosionRay=explosionRay;
    e.damage=damage;
    return e;
  }
  void destroy() {
    makeHashMatch();
    if (!isTheLast())
      ents[hash]=ents[ents.length-1];
    ents=(Entity[])shorten(ents);
    makeHashMatch();
  }
}