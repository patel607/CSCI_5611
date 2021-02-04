import peasy.*;

float x;
float y;
float z = 0;
float genRate = 200;
float life = 10;
int floor = 400;
ArrayList<PVector> posList = new ArrayList<PVector>();
ArrayList<PVector> velList = new ArrayList<PVector>();
ArrayList<PVector> colList = new ArrayList<PVector>();
FloatList lifeList = new FloatList();
PShape rocket;
PImage img;
PImage img2;
PeasyCam cam;


void setup() {
  size(800, 800, P3D);
  //noStroke();
  lights();
  surface.setTitle("Rocket");
  
  cam = new PeasyCam(this, 0, -100, 0, 500);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(3000);
  
  x = 0;
  y = 0;
  rocket = loadShape("Missile AIM-120 D [AMRAAM].obj");
  img = loadImage("smoke.png");
  img2 = loadImage("flame.png");
}

void generateF() {
  PVector rndPos = rndPointOnDisk(20);
  posList.add(rndPos);
  PVector vel = new PVector(random(-10,10),random(-70,-75),random(-10,10));
  velList.add(vel);
  colList.add(new PVector(250, 200, 0));
  lifeList.append(0);
}

void generateS() {
  PVector rndPos = rndPointOnDisk(20);
  posList.add(rndPos);
  PVector vel = new PVector(random(-15,15),random(-72,-80),random(-15,15));
  velList.add(vel);
  colList.add(new PVector(0,0,0));
  lifeList.append(0);
}

void generateStar() {
  PVector field = rndPointOnDisk(3000);
  field.y += 10000;
  posList.add(field);
  PVector vel = new PVector(0,random(-500, -1000),0);
  velList.add(vel);
  colList.add(new PVector(255,255,255));
  lifeList.append(-15);
}

PVector rndPointOnDisk(int rad) {
  float r = rad*random(1);
  float theta = 2*PI*random(1);
  return new PVector(r*sin(theta),0, r*cos(theta));
}

void moveParticles(float dt) {
  for(int i =0; i < posList.size(); i++) {
    if (lifeList.get(i) > life + random(-2,2)) {
      posList.remove(i);
      velList.remove(i);
      colList.remove(i);
      lifeList.remove(i);
      i--;
      continue;
    }
    posList.get(i).x += velList.get(i).x *dt;
    posList.get(i).y += velList.get(i).y *dt;
    posList.get(i).z += velList.get(i).z *dt;
    if (velList.get(i).x != 0) {
      velList.get(i).y += 5*dt;
    }
    lifeList.add(i, dt);
    
    if (posList.get(i).y > floor) {
      posList.get(i).y = floor;
      velList.get(i).y *= -0.4;
      velList.get(i).z += 3*random(-1,1);
    }
  }
}


void draw() {
  
  // allow for translation which PeasyCam lacks
  if (keyPressed) {
    if (keyCode == UP) {
      y+=10;
    }else if (keyCode == DOWN) {
      y-=10;
    }else if (keyCode == LEFT) {
      x+=10;
    }else if (keyCode == RIGHT) {
      x-=10;
    }
  }
  translate(x,y);
  
  background(0);
 rotateX(PI);
  shape(rocket);
  
  spawnParticles(0.15);
  moveParticles(0.15);
  
  strokeWeight(3);
  for (int i =0; i < posList.size(); i++) {
    PVector p = posList.get(i);
    PVector c = colList.get(i);
    //fill(c.x, c.y, c.z);
    //lights();
    //pushMatrix();
    //translate(p.x, p.y, p.z);
    //sphere(1);
    
    z = lifeList.get(i);
    if (c.x ==0) {
      
      pushMatrix();
      noStroke();
      beginShape();
      texture(img);
      tint(255,-18*(z-4)*(z-4)+200);
      
      // vertex( x, y, z, u, v) where u and v are the texture coordinates in pixels
      vertex(p.x-7, p.y-7, p.z, 0, 0);
      vertex(p.x+7, p.y-7, p.z, img.width, 0);
      vertex(p.x+7, p.y+7, p.z, img.width, img.height);
      vertex(p.x-7, p.y+7, p.z, 0, img.height);
      //image(img, p.x, p.y);
      endShape();
      popMatrix();
      
    } else if (c.z == 0) {
      //stroke(c.x, c.y - z*15, c.z, 150 - 10*z);
      //point(p.x, p.y, p.z);
      pushMatrix();
      noStroke();
      beginShape();
      texture(img2);
      tint(200,200-z*15, 0 , 200-z*15);
      
      // vertex( x, y, z, u, v) where u and v are the texture coordinates in pixels
      vertex(p.x-10, p.y-10, p.z, 0, 0);
      vertex(p.x+10, p.y-10, p.z, img.width, 0);
      vertex(p.x+10, p.y+10, p.z, img.width, img.height);
      vertex(p.x-10, p.y+10, p.z, 0, img.height);
           
      
      endShape();
       popMatrix();
      
      // for stars
    } else {
      stroke(c.x, c.y, c.z);
      point(p.x, p.y, p.z);
    }
    //popMatrix();
  }
  stroke(96,96,96);
  
  
}

// slide 22 on lecture 2
void spawnParticles(float dt) {
  float numParticles= dt*genRate;
  numParticles= int(numParticles);
  if (random(1) < dt*genRate) {
    numParticles+= 1;
  }
  for (int i = 0; i < numParticles; i ++) {
    generateF();
    generateS();
    if (random(1) < 0.001) {
      generateStar();
    }
  }
}
