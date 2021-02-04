
class Fire {
  float z = 0;
  float genRate = 50;
  float life = 5;
  ArrayList<PVector> posList = new ArrayList<PVector>();
  ArrayList<PVector> velList = new ArrayList<PVector>();
  ArrayList<PVector> colList = new ArrayList<PVector>();
  FloatList lifeList = new FloatList();
  
  PImage img3 = loadImage("smoke.png");
  PImage img2 = loadImage("flame.png");
  
  Fire() {
    
  }
  
  void generateF(PVector f) {
    PVector rndPos = f.copy();
    posList.add(rndPos);
    PVector vel = new PVector(random(-1,1),random(-3,-5),random(-1,1));
    velList.add(vel);
    colList.add(new PVector(250, 200, 0));
    lifeList.append(0);
  }
  
  void generateS(PVector f) {
    PVector rndPos = f.copy();
    posList.add(rndPos);
    PVector vel = new PVector(random(-1,1),random(-4,-7),random(-1,1));
    velList.add(vel);
    colList.add(new PVector(0,0,0));
    lifeList.append(0);
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
        velList.get(i).y -= 5*dt;
      }
      lifeList.add(i, dt);
      
    }
  }
  
  
  void drawFire(PVector f) {
    
    
    spawnParticles(0.01, f);
    moveParticles(0.009);
    
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
        texture(img3);
        stroke(200,200,200,-18*(z-4)*(z-4)+200);
        
        // vertex( x, y, z, u, v) where u and v are the texture coordinates in pixels
        //vertex(p.x-7, p.y-7, p.z, 0, 0);
        //vertex(p.x+7, p.y-7, p.z, img.width, 0);
        //vertex(p.x+7, p.y+7, p.z, img.width, img.height);
        //vertex(p.x-7, p.y+7, p.z, 0, img.height);
        point(p.x, p.y, p.z);
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
        stroke(200,200-z*15, 0 , 200-z*15);
        
        // vertex( x, y, z, u, v) where u and v are the texture coordinates in pixels
        //vertex(p.x-10, p.y-10, p.z, 0, 0);
        //vertex(p.x+10, p.y-10, p.z, img.width, 0);
        //vertex(p.x+10, p.y+10, p.z, img.width, img.height);
        //vertex(p.x-10, p.y+10, p.z, 0, img.height);
        point(p.x, p.y, p.z);
        
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
  void spawnParticles(float dt, PVector f) {
    float numParticles= dt*genRate;
    numParticles= int(numParticles);
    if (random(1) < dt*genRate) {
      numParticles+= 1;
    }
    for (int i = 0; i < numParticles; i ++) {
      generateF(f);
      generateS(f);
      }
    }
}
