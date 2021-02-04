
ArrayList<Boid> flock = new ArrayList<Boid>();
ArrayList<PVector> obs = new ArrayList<PVector>();
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
  for (int i = 0; i < 50; i++) {
    flock.add(new Boid());
  }
  
  
  PVector ob1 = new PVector(width/2, height/2, 0);

  obs.add(ob1);
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

  for (PVector o: obs) {
    ellipse(o.x, o.y, 200, 200);
  }


  for (Boid b : flock) {
    b.flock(flock, obs);
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
