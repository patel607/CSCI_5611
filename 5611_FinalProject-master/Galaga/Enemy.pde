class Enemy {
  PVector pos = new PVector(0, 0);
  PVector vel = new PVector(0, 0);
  int hits;
  int health = 2;
  //float enemyRadius = 30;
  int sec = second();
  int mill = millis();
  //float bulletSpeed = 100;
  float motion = 1;
  float n = 0;
  int fireRate = 10;
  boolean fire = true;

  //for Boids potentially
  PVector acc;
  float maxVel = 80;
  float maxAcc = 120;
  float sepR = 60;
  float sepW = 6000;
  float alignR = 60;
  float alignW = 500;
  float cohR = 120;
  float cohW = 100;


  Enemy (PVector pos, PVector vel) {
    this.pos = pos;
    this.vel = vel;
    this.acc = new PVector (0, 0);
  }

  void display() {
    push();
    noStroke();
    switch (hits) { //change color & Bullet speed based on health? might be a dumb idea
    case 0: 
      fill(0, 255, 0);
      //bulletSpeed = random(25,30);
      break;
    case 1: 
      fill(255, 255, 0);
      //bulletSpeed = random(20,25);
      break;
    case 2: 
      fill(255, 255, 0);
      //bulletSpeed = random(15,20);
      break;
    case 3: 
      fill(255, 128, 0);
      break;
    case 4: 
      fill(255, 0, 0);
      break;
    }
    circle (pos.x, pos.y, enemyRadius*2);
    pop();
  }

  void update(float dt, int level) {
    //if ((millis()-x) % 8000 < 10 && millis() > 1000)
    //  motion = int(random(1,3));
    if (pos.x - enemyRadius < 0) {
      vel.x *= -1;
      pos.x = 0 + enemyRadius;
    }
    if (pos.x + enemyRadius > 1000) {
      vel.x *= -1;
      pos.x = 1000-enemyRadius;
    }
    if (pos.y - enemyRadius < 0) {
      vel.y *= -1;
      pos.y = enemyRadius;
    }
    if (pos.y + enemyRadius > 200+33*20) {
      vel.y *= -1;
      pos.y = (200+33*20) - enemyRadius;  // will hit ship at level 34
    } 

    if (level < 20)
      level1(dt);
    else if (level % 2 == 0) {
      enemyRadius = 10;
      boids(dt, enemy);
    }
    else
        level1(dt);
    float r;
    if (level < 15)
      r = random(500, 2000);
    else
      r = random (2000, 8000);
    if ((millis() > mill + r)) {
      fire();
      mill = millis();
    }
  }

  void fire() {
    float bulletSpeed = random(90, 110);
    enemyBullet.add(new ShipBullet(new PVector (pos.x, pos.y), new PVector (0, bulletSpeed)));
  }

  void level1(float dt) {
    if (pos.y + enemyRadius > 200+level*20) {
      vel.y *= -1;
      pos.y = (200+level*20) - enemyRadius;  // will hit ship at level 34
    } 

    pos.add(PVector.mult(vel, dt));
  }

  void level2(float dt) {
    if (vel.y < 0)
      vel.y *= -1;

    pos.x += 75*sin(n) * dt;
    pos.y += 2.5 * vel.y * dt;
    n += 0.05;
    if (pos.y - enemyRadius < 0) {
      vel.y *= -1;
      pos.y = enemyRadius;
      n = 0;
    }
    if (pos.y >= height) {
      motion = 0;
      pos.y = enemyRadius;
      n = 0;
    }
  }

  void path2(float dt) {
    if (vel.y < 0)
      vel.y *= -1;

    if (n < 6.25 || n > 12) {
      if (n < 6.25) pos.x += vel.x * dt;

      pos.y += 2 * vel.y * dt;
    } else {
      pos.x += (vel.x/abs(vel.x)) * 75*cos(n*0.9) * dt;
      pos.y += -75*sin(n*0.9) * dt;
    }
    n += 0.05;

    if (pos.y >= height) {
      motion = 0;
      pos.y = enemyRadius;
      n = 0;
    }
  }

  void boids(float dt, ArrayList <Enemy> enemy) {
    acc.add(PVector.mult(separation(enemy), dt*sepW));
    acc.add(PVector.mult(alignment(enemy), dt*alignW));
    acc.add(PVector.mult(cohesion(enemy), dt * cohW));
    acc.limit(maxAcc);
    vel.add(PVector.mult(acc, dt));
    vel.limit(maxVel);
    pos.add(PVector.mult(vel, dt));

    acc.mult(0); // new acc calculated every update
  }

  PVector separation(ArrayList <Enemy> enemy) {
    PVector force = new PVector (0, 0);
    for (Enemy b : enemy) {
      float d = getDist(b);
      if (d < sepR && this != b) {
        PVector dir = PVector.sub(pos, b.pos);
        //dir.normalize();
        force.add(PVector.div(dir, d));
      }
    }
    return force;
  }

  PVector alignment(ArrayList <Enemy> enemy) {
    PVector force = new PVector (0, 0);
    int count = 0;
    for (Enemy b : enemy) {
      float d = getDist(b);
      if (d < alignR && this != b) {
        //println(b.vel);
        force.add(b.vel);
        count++;
      }
    }
    if (count > 0)
      force.div(count);
    return force;
  }

  PVector cohesion(ArrayList <Enemy> enemy) {
    PVector avgPos = new PVector (0, 0);
    int count = 0;
    for (Enemy b : enemy) {
      float d = getDist(b);
      if (d < cohR && this != b) {
        avgPos.add(b.pos);
        count++;
      }
    }
    PVector force = new PVector (0, 0);
    if (count > 0) {
      avgPos.div(count);
      force = PVector.sub(avgPos, pos);
    }
    return force;
  }

  float getDist (Enemy b) {
    return PVector.dist(pos, b.pos);
  }
}
