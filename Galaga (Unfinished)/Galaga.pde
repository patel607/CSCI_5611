Ship s;
float shipSpeed = 15;
ArrayList <ShipBullet> bullet = new ArrayList <ShipBullet> ();
ArrayList <Enemy> enemy = new ArrayList <Enemy> ();
ArrayList <ShipBullet> enemyBullet = new ArrayList <ShipBullet> ();
ArrayList <Explosion> explosions = new ArrayList <Explosion> ();
PVector initPos = new PVector (500, 900);
PVector change = new PVector (0, 0);
boolean left = false;
boolean right = false;
boolean fire = true; //so you can't press and hold space to shoot, pressing and holding is OP and weird functionality in processing. 
int bulletSpeed = 300;
int level = 0;
int enemyRadius = 20;

ArrayList<PVector> stars = new ArrayList<PVector>();

float dt = 0.1;
PImage ship_tex;
PImage bee_tex;
PFont font;

void setup () {
  size(1000, 1000, P3D);

  s = new Ship(initPos);
  //enemy.add(new Enemy());
  ship_tex = loadImage("ship-sprite.png");
  bee_tex = loadImage("bee-sprite.png");
  font = loadFont("Emulogic-48.vlw");

  for (int i = 0; i < 30; i++) {
    stars.add(new PVector(random(width), random(height), int(random(4))));
  }
}


void draw () {
  background(0);
  stars();
  textFont(font, 12);
  textAlign(LEFT, TOP);
  text("LEVEL " + level, 10, 10);
  textAlign(LEFT, BOTTOM);
  textFont(font, 12);
  text("HEALTH: " + (s.health - s.hits), 25, 975);

  if (s.pos.x - s.radius > 0 && s.pos.x + s.radius < width)
    s.pos.add(change);
  else if (s.pos.x - s.radius <= 0 && change.x > 0)
    s.pos.add(change);
  else if (s.pos.x + s.radius >= width && change.x < 0)
    s.pos.add(change);
  s.display();

  for (ShipBullet bullet : bullet) {
    stroke(255);
    bullet.display();
    bullet.update(dt);
  }

  if (enemy.size() == 0) {
    level++;
    spawnEnemies(level);
  }

  for (Enemy e : enemy) {
    e.display();
    e.update(dt, level);
  }

  for (ShipBullet bullet : enemyBullet) {
    stroke(255, 0, 0);
    bullet.display();
    bullet.update(dt);
  }

  handleHit();

  for (Explosion ex : explosions) {
    ex.display(dt);
  }

  for (int i = 0; i < explosions.size(); i++) {
    if (!explosions.get(i).alive())
      explosions.remove(explosions.get(i));
  }

  if (!s.alive()) {
    push();
    fill(255);
    textAlign(CENTER);
    textFont(font, 16);
    text("LEVEL " + level, 500, 400);
    textFont(font, 32);
    text("Game Over", 500, 500);
    textFont(font, 20);
    text("Press 'r' to Restart", 500, 600);
    fire = false;
    pop();
  }
}

void stars() {
  for (PVector s : stars) {
    s.y += random(1);
    if (s.y >= height) {
      s.y = 0;
      s.x = random(width);
    }
    float black = random(1);
    if (black < 0.5)
      stroke(0);
    else if (s.z == 0)
      stroke(255, 0, 255);
    else if (s.z == 1)
      stroke(255, 255, 0);
    else if (s.z == 2)
      stroke(0, 0, 255);
    else if (s.z == 3)
      stroke(0, 255, 0);    

    strokeWeight(3);  
    point(s.x, s.y);
  }
}

int fireCollision(ShipBullet sb, Enemy e) { //for ship shooting enemies
  if (dist(sb.pos.x, sb.pos.y, e.pos.x, e.pos.y) < enemyRadius) {
    e.hits++;
    if (e.hits >= e.health)
      return 0;
    return 1;
    //bullet.remove(sb);
  }
  //enemy.remove(e);
  return -1;
}

void handleHit() {
  for (int i = 0; i < bullet.size(); i++) {
    if (bullet.get(i).pos.y > height || bullet.get(i).pos.y < 0) {
      bullet.remove(bullet.get(i));
    } else {
      for (int j = 0; j < enemy.size(); j++) {
        int x = fireCollision(bullet.get(i), enemy.get(j));
        if (x == 1) {
          bullet.remove(bullet.get(i));
          break;
        } else if (x == 0) {
          bullet.remove(bullet.get(i));
          explosions.add(new Explosion(enemy.get(j).pos));
          enemy.remove(enemy.get(j));
          break;
        }
      }
    }
  }

  for (int i = 0; i < enemyBullet.size(); i++) {
    if (dist(enemyBullet.get(i).pos.x, enemyBullet.get(i).pos.y, s.pos.x, s.pos.y) < s.radius) {
      s.hits++;
      enemyBullet.remove(enemyBullet.get(i));
    }
  }

  for (int i = 0; i < enemy.size(); i++) {
    if (dist(enemy.get(i).pos.x, enemy.get(i).pos.y, s.pos.x, s.pos.y) < s.radius + enemyRadius) {
      s.hits++;
      explosions.add(new Explosion(enemy.get(i).pos));
      explosions.add(new Explosion(s.pos));
      enemy.remove(enemy.get(i));
    }
  }
}

void spawnEnemies(int level) {
  switch (level) {
  case 1:
  case 2:
  default: 
    level1();
  }
}

void level1() {
  for (int i = 0; i < level; i++) {
    PVector pos = new PVector();
    PVector vel = new PVector();
    float x;
    pos.x = random(enemyRadius, 1000);
    pos.y = random(enemyRadius, 200);
    vel.x = 20+level*3 * random(0.5, 1.5);
    vel.y = 20+level*3 * random(0.5, 1.5);
    if (vel.mag() > 80)
      vel = new PVector (random(55, 70), random(55, 70));
    x = random(1);
    if (x < 0.5)
      vel.x *= -1;
    x = random(1);
    if (x < 0.5)
      vel.y *= -1;
    enemy.add(new Enemy (pos, vel));
  }
}


void keyPressed() {
  if (key == 'a' || keyCode == LEFT) {
    change.x = -shipSpeed; 
    left = true; 
    right = false;
  }
  if (key == 'd' || keyCode == RIGHT) {
    change.x = shipSpeed; 
    right = true; 
    left = false;
  }
  if (key == ' ' && fire) {
    switch (level) {
    case 1: 
    case 2: 
      bullet.add(new ShipBullet(s.pos, new PVector (0, -bulletSpeed)));
      break;
    case 3:
    case 4:
      bullet.add(new ShipBullet(new PVector (s.pos.x + 10, s.pos.y), new PVector (0, -bulletSpeed)));
      bullet.add(new ShipBullet(new PVector (s.pos.x - 10, s.pos.y), new PVector (0, -bulletSpeed)));
      break;
    case 5:
    case 6:
      bullet.add(new ShipBullet(new PVector (s.pos.x + 10, s.pos.y), new PVector (0, -bulletSpeed)));
      bullet.add(new ShipBullet(new PVector (s.pos.x - 10, s.pos.y), new PVector (0, -bulletSpeed)));
      bullet.add(new ShipBullet(s.pos, new PVector (-20, -bulletSpeed)));
      bullet.add(new ShipBullet(s.pos, new PVector (20, -bulletSpeed)));
      break;
    case 7:
    case 8:
      bullet.add(new ShipBullet(new PVector (s.pos.x + 10, s.pos.y), new PVector (0, -bulletSpeed)));
      bullet.add(new ShipBullet(new PVector (s.pos.x - 10, s.pos.y), new PVector (0, -bulletSpeed)));
      bullet.add(new ShipBullet(new PVector (s.pos.x + 25, s.pos.y), new PVector (0, -bulletSpeed)));
      bullet.add(new ShipBullet(new PVector (s.pos.x - 25, s.pos.y), new PVector (0, -bulletSpeed)));
      bullet.add(new ShipBullet(s.pos, new PVector (-30, -bulletSpeed)));
      bullet.add(new ShipBullet(s.pos, new PVector (30, -bulletSpeed)));
      break;
    default:
      bullet.add(new ShipBullet(new PVector (s.pos.x + 10, s.pos.y), new PVector (0, -bulletSpeed)));
      bullet.add(new ShipBullet(new PVector (s.pos.x - 10, s.pos.y), new PVector (0, -bulletSpeed)));
      bullet.add(new ShipBullet(new PVector (s.pos.x + 25, s.pos.y), new PVector (0, -bulletSpeed)));
      bullet.add(new ShipBullet(new PVector (s.pos.x - 25, s.pos.y), new PVector (0, -bulletSpeed)));
      bullet.add(new ShipBullet(s.pos, new PVector (-30, -bulletSpeed)));
      bullet.add(new ShipBullet(s.pos, new PVector (30, -bulletSpeed)));
      bullet.add(new ShipBullet(s.pos, new PVector (-60, -bulletSpeed)));
      bullet.add(new ShipBullet(s.pos, new PVector (60, -bulletSpeed)));
    }
    fire = false;
  } //can probably do different types of shooting here, like two or three bullets at once


  //if (keyCode == ENTER)
  //  enemy.add(new Enemy());
  if (keyCode == UP) { //increase level
    enemy.clear();
    enemyBullet.clear();
  }
  if (key == 'r') {
    enemy.clear();
    enemyBullet.clear();
    s = new Ship(initPos);
    level = 0;
  }
  if (keyCode == ENTER) {
    s = new Ship(initPos);
    enemyBullet.clear();
  }
}

void keyReleased() {
  if ((key == 'a' || keyCode == LEFT) && !right) {
    change.x = 0; 
    left = false;
  }
  if ((key == 'd'|| keyCode == RIGHT) && !left) {
    change.x = 0; 
    right = false;
  }
  if (key == ' ') {
    fire = true;
  }
}
