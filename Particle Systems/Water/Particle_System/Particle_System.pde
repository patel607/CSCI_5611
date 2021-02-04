import peasy.*;


float zoom = 1;
float angle = 0;
float x;
float y;
float sx;
int sphereR;
//float sy;
//float sz;
float z = 0;
float genRate = 800;
float life = 25;
int floor = 400;
ArrayList<PVector> posList = new ArrayList<PVector>();
ArrayList<PVector> velList = new ArrayList<PVector>();
ArrayList<PVector> colList = new ArrayList<PVector>();
FloatList lifeList = new FloatList();
//PShape hydrant;

PeasyCam cam;


void setup() {
  size(800, 800, P3D);
  noStroke();
  lights();
  surface.setTitle("Water ");
  
  
  cam = new PeasyCam(this, 100,200,00,500);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(3000);
  x = 0;
  y = 0;
  sphereR = 40;
  //generate();
  //hydrant = loadShape("C:\\Users\\Neil\\Documents\\School\\Year 3\\CSCI 5611\\Particle Systems\\10554_FireHydrant_v1-L2.obj");
  
  
}

void generate() {
  PVector rndPos = rndPointOnDisk(20);
  posList.add(rndPos);
  PVector vel = new PVector(random(18,20),-15,.1*random(10));
  velList.add(vel);
  colList.add(new PVector(0,50,100));
  lifeList.append(0);
}

PVector rndPointOnDisk(int rad) {
  float r = rad*random(1);
  float theta = 2*PI*random(1);
  return new PVector(40, r*sin(theta)+40, r*cos(theta));
}

void moveParticles(float dt) {
  for(int i =0; i < posList.size(); i++) {
    // remove from all lists if lifespan is reached
    if (lifeList.get(i) > life) {
      posList.remove(i);
      velList.remove(i);
      colList.remove(i);
      lifeList.remove(i);
      i--;
      continue;
    }
    // eulerian integration for position
    posList.get(i).x += velList.get(i).x *dt;
    posList.get(i).y += velList.get(i).y *dt;
    posList.get(i).z += velList.get(i).z *dt;
    velList.get(i).y += 9.8*dt;
    lifeList.add(i, dt);
    
    // collision detection with floor
    if (posList.get(i).y > floor) {
      posList.get(i).y = floor;
      velList.get(i).y *= -0.4;
      velList.get(i).z += 3*random(-1,1);
    }
    
    // based on slide 27 from lecture 04
    PVector spherePos = new PVector(sx, 200, 0);
    if (posList.get(i).dist(spherePos) < sphereR) {
      PVector normal = posList.get(i).sub(spherePos);
      normal.normalize();
      
      posList.set(i, (spherePos.copy().add(normal.copy().mult(sphereR*1.01))));
 
      
      PVector vNorm = normal.copy().mult(velList.get(i).dot(normal));
      
      velList.get(i).sub(vNorm);
      
      
      velList.get(i).sub(vNorm.copy().mult(0.7));
    }    
  }
}


void draw() {
  lights();
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
  
  background(255,255,255);
  
  fill(128,128,128);
  pushMatrix();
  // faucet for water
  translate(-35,200,0);
  box(30,400,30);
  translate(45,-160,0);
  box(60,30,30);
  popMatrix();
  
  // moveable ball
  pushMatrix();
  sx = mouseX+25;
  translate(sx, 200, 0);
  fill(0,200,0);
  noStroke();
  sphere(sphereR);
  popMatrix();
  
  // black floor
  fill(0,0,0);
  
  beginShape();
  vertex(-1000, floor, -1000);
  vertex( 1000, floor, -1000);
  vertex( 1000, floor,  1000);
  vertex(-1000, floor, 1000);
  endShape();
  
  spawnParticles(0.15);
  moveParticles(0.15);
  stroke(0, 100, 200, 100);
  strokeWeight(3);
  for (int i =0; i < posList.size(); i++) {
    PVector p = posList.get(i);
    point(p.x, p.y, p.z);
  }
  stroke(96,96,96);
  
  println("FPS: " + frameRate);
  println("Particles: " + lifeList.size() + "\n");
}

// slide 22
void spawnParticles(float dt) {
  float numParticles= dt*genRate;
  numParticles= int(numParticles);
  if (random(1) < dt*genRate) {
    numParticles+= 1;
  }
  for (int i = 0; i < numParticles; i ++) {
    generate();
  }
}
