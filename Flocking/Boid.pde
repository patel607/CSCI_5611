float aR = 100;
float sR = 40;
float cR = 50;
float oR = 200;

float force = 0.1;
float speed = 2;

class Boid {

  PVector pos;
  PVector vel;
  PVector acc;
  
  
  Boid() {
    pos = new PVector(random(width), random(height));
    vel = PVector.random2D();
    vel.setMag(random(0.5,1.5));
    acc = new PVector(0,0);
  }
  
  void align(ArrayList<Boid> boids) {
    PVector avg = new PVector(0,0);
    int total = 0;
    for (Boid b: boids) {
      float d = this.pos.dist(b.pos); 
      if (d > 0 && d < aR) {
        avg.add(b.vel);
        total++;
      }
    }
    
    if (total > 0) {
      avg.div(total);
      avg.setMag(speed);
      avg.sub(this.vel);
      avg.limit(force);
    } 
    
    
    acc.add(avg);
    //return avg;
  }
  
  void cohere(ArrayList<Boid> boids) {
    PVector avg = new PVector(0,0);
    int total = 0;
    for (Boid b: boids) {
      float d = this.pos.dist(b.pos); 
      if (d > 0.1 && d < cR) {
        avg.add(b.pos);
        total++;
      }
    }
    
    if (total > 0) {
      avg.div(total);
      avg.sub(this.pos);
      avg.setMag(speed);
      avg.sub(this.vel);
      avg.limit(force-0.02);
    } 
    
    
    acc.add(avg);
    
  }
  
  void separate(ArrayList<Boid> boids) {
    PVector avg = new PVector(0,0);
    int total = 0;
    for (Boid b: boids) {
      float d = this.pos.dist(b.pos); 
      if (d > 0 && d < sR) {
        PVector diff = PVector.sub(this.pos, b.pos);
        diff.mult(d*d);
        avg.add(diff);
        total++;
      }
    }
    
    if (total > 0) {
      avg.div(total);
      avg.setMag(speed);
      avg.sub(this.vel);
      avg.limit(force+0.05);
    } 
    
    
    acc.add(avg);
    
  }
  
  void obstacle(ArrayList<PVector> obs) {
    PVector avg = new PVector(0,0);
    int total = 0;
    for (PVector p: obs) {
      float d = this.pos.dist(p); 
      if (d < oR) {
        PVector diff = PVector.sub(this.pos, p);
        diff.mult(d*d);
        avg.add(diff);
        total++;
      }
    }
    
    if (total > 0) {
      avg.div(total);
      avg.setMag(speed);
      avg.sub(this.vel);
      avg.limit(force+0.05);
    } 
       
    acc.add(avg);
    
  }
  
  
  void flock(ArrayList<Boid> boids, ArrayList<PVector> obs) {
    acc.mult(0);
    //PVector al = align(boids);
    //acc.add(al);
    align(boids);
    separate(boids);
    cohere(boids);
    obstacle(obs);
    
  }
  
  
  void update(float dt) {
    pos.add(vel.copy().mult(dt));
    vel.add(acc.copy().mult(dt));
    vel.limit(speed);
    borders();
  }
  
  
  void show() {
    strokeWeight(16);
    stroke(255);
    point(pos.x, pos.y);
    //pushMatrix();
    //translate(pos.x, pos.y);
    //sphere(8);
    //popMatrix();
    
  }
  
  void borders() {
    if (pos.x < 0) pos.x = width;
    if (pos.y < 0) pos.y = height;
    if (pos.x > width) pos.x =0;
    if (pos.y > height) pos.y = 0;
  }
  
}
