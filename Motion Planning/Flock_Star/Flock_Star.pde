
ArrayList<Boid> flock = new ArrayList<Boid>();
ArrayList<PVector> obstacles = new ArrayList<PVector>();
float dt = 1;
Camera cam = new Camera();

void setup() {

  size(1000, 1000, P3D);
  //  float fov = PI/3.0;
  //float cameraZ = (height/2.0) / tan(fov/2.0);
  //perspective(fov, float(width)/float(height), 
  //            cameraZ/10.0, cameraZ*10.0);

  //rotateX(-PI/6);
  //rotateY(PI/3);
  // Add an initial set of boids into the system
  
  
  start = new PVector(100, height-100, 0);
  goal = new PVector(width-100,100);
  
  for (int i = 0; i < 20; i++) {
    flock.add(new Boid());
  }
  
  
  //PVector ob1 = new PVector(width/2, height/2, 0);
  //obstacles.add(ob1);
  
  // obstacles.add(new PVector(width/2 - 50, height/2 - 50));
  // obstacles.add(new PVector(width/2 - 100, height/2 - 100));
  //  obstacles.add(new PVector(width/2 - 150, height/2 - 150));
  //   obstacles.add(new PVector(width/2 - 200, height/2 - 200));
     
   //    obstacles.add(new PVector(width/2 + 50, height/2 + 50));
   //obstacles.add(new PVector(width/2 + 100, height/2 + 100));
   // obstacles.add(new PVector(width/2 + 150, height/2 + 150));
   //  obstacles.add(new PVector(width/2 + 200, height/2 + 200));

  for (int i = 0; i < 4; i++) {
    obstacles.add(new PVector(100 + 150*i, 650));
  }
  
  for (int i = 0; i < 4; i++) {
    obstacles.add(new PVector(900 - 150*i, 300));
  }
  
  run_A();
}

void draw() {
  background(50);
  lights();
  surface.setTitle("" + frameRate);

  cam.Update(dt/frameRate);

  strokeWeight(3);

  fill(0, 0, 200);
  beginShape();
  vertex(0, 0, 100);
  vertex(width, 0, 100);
  vertex(width, 0, -100);
  vertex(0, 0, -100);
  endShape();

  beginShape();
  vertex(width, 0, 100);
  vertex(width, height, 100);
  vertex(width, height, -100);
  vertex(width, 0, -100);
  endShape();

  beginShape();
  vertex(0, height, 100);
  vertex(width, height, 100);
  vertex(width, height, -100);
  vertex(0, height, -100);
  endShape();

  beginShape();
  vertex(0, 0, 100);
  vertex(0, height, 100);
  vertex(0, height, -100);
  vertex(0, 0, -100);
  endShape();
  
  drawEnv();
  
  for (PVector o: obstacles) {
    circle(o.x, o.y, 200);
  }


  for (Boid b : flock) {
    b.flock(flock, obstacles);
    b.update(dt);
    b.show();
  } 
}

void keyPressed()
{
  cam.HandleKeyPressed();
}

void keyReleased()
{
  cam.HandleKeyReleased();
}
