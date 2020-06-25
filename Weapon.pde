class Weapon {
  WeaponType type;
  Entity projectile;
  int ejectionSpeed;
  int munitions;
  float cooldown;
  float time;

  Weapon(WeaponType pType) {
    switch(pType) {
    case BIG_BOMB:
      projectile=new Entity(Ai.MISSILE, new Vector(0), new Vector(0), new Vector(16, 4, false), 10);
      projectile.skin=0;
      projectile.explosionRay=200;
      projectile.damage=300;
      projectile.time=2;
      ejectionSpeed=1000;
      cooldown=0.5;
      munitions=10;
      break;
    case SMALL_LASER:
      projectile=new Entity(Ai.MISSILE, new Vector(0), new Vector(0), new Vector(16, 4, false), 1);
      projectile.skin=1;
      ejectionSpeed=1000;
      projectile.explosionRay=20;
      projectile.damage=30;
      cooldown=0.1;
      munitions=-1;
      break;
    case LASER:
      projectile=new Entity(Ai.LASER, new Vector(0), new Vector(0), new Vector(2000, 50, false), 5);
      projectile.skin=5;
      ejectionSpeed=0;
      cooldown=15;
      break;
    }
    time=1;
    type=pType;
  }

  void update() {
    time-=1/frameRate;
    if (time<0)
      time=0;
  }
  float shoot(Vector pos, Vector speed, float angle, float distance) {
    if (munitions!=0&&time==0) {
      if (munitions>0)
        munitions--;
      ents=(Entity[])append(ents, projectile.getClone(plus(pos, new Vector(distance+projectile.size.x/2, angle, true)), plus(speed, new Vector(ejectionSpeed, angle, true)), angle));
      time=cooldown;
      makeHashMatch();
      return ejectionSpeed*projectile.mass;
    }
    return 0;
  }
}