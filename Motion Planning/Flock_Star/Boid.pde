float aR = 30;
float sR = 40;
float cR = 50;
float oR = 100;

float force = 0.1;
float speed = 2;



class Boid {

  PVector pos;
  PVector vel;
  PVector acc;
  int current_target = 0;
  
  Boid() {
    pos = new PVector(start.x + random(-25,25), start.y + random(-25,25));
    vel = new PVector(0,0);
    //vel.setMag(random(0.5,1.5));
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
      avg.limit(force+0.1);
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
      avg.limit(force+0.15);
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
      avg.limit(force+0.5);
    } 
       
    acc.add(avg);
    
  }
  
  void obstacle(ArrayList<PVector> obs) {
    PVector avg = new PVector(0,0);
    int total = 0;
    for (PVector p: obs) {
      float d = this.pos.dist(p); 
      if (d < oR + 30) {
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
      avg.limit(force+0.65);
    } 
       
    acc.add(avg);    
  }
  
  void toTarget(PVector target) {
    PVector startEndVector = PVector.sub(target, this.pos);
    startEndVector.setMag(speed);
    PVector steer = PVector.sub(startEndVector, this.vel);
    steer.limit(force+0.25);
    acc.add(steer);
  }

  
  
  void flock(ArrayList<Boid> boids, ArrayList<PVector> obs) {
    acc.mult(0);
    //PVector al = align(boids);
    //acc.add(al);
    align(boids);
    separate(boids);
    cohere(boids);
    
    if(current_target != sol.size() - 1) {
      if(this.pos.dist(sol.get(current_target)) < oR+50) {
        current_target++;
      } else if(this.pos.dist(sol.get(sol.size()-1)) < oR+50) {
        current_target = sol.size()-1;
      }
    }
    
    toTarget(sol.get(current_target));
       
    obstacle(obs);
    
  }
  
  
  void update(float dt) {
    pos.add(vel.copy().mult(dt));
    vel.add(acc.copy().mult(dt));
    vel.limit(speed);
    //borders();
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
