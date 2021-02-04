import peasy.*;


int numBalls = 40;  // rows  Change however you want
int numThreads = 15;  // columns  Change however you want
PVector [][] ballp = new PVector [numBalls+1][numThreads];  // [rows][columns]
PVector [][] ballv = new PVector [numBalls+1][numThreads];  // [rows][columns]

float grav = 10;
float restLen = 5;  // rest length - length of string if there was no mass.
float x = 3;
float y = 4;
float k = 40000;
float kv = 600000;
float time = 0;

PeasyCam cam;
Fire fire;
// ball stuff
//Ball b;
//PVector center = new PVector (4*x + 300, 600 + y*25, -200);
//PVector change = new PVector (0, 0, 0);
//float radius = 100;

float dt = 10E-7; // works at 8
int updates = 300;

PImage img;

// Calculate force vectors: String Force (split into x and y components), Force of Gravity.
// Use forces to update velX and velY of ball.
//Camera camera;
void setup() {
  size (1000, 1000, P3D);
  //camera = new Camera ();
  cam = new PeasyCam(this, 350, 300, 0, 1000);
  fire = new Fire();
  //more ball stuff
  //b = new Ball (center, radius);
  //ballp[0] = new PVector (anchor.x, anchor.y);
  //ballv[0] = new PVector (0, 0);
  //for (int i = 1; i < numBalls+1; i++) {
  //  ballp[i] = new PVector (ballp[i-1].x + 20, ballp[i-1].y + restLen);
  //  ballv[i] = new PVector (0, 0);
  //}

  for (int i = 0; i < numThreads; i ++) {
    ballp[0][i] = new PVector (300, 300, (-i*(restLen)));
    ballv[0][i] = new PVector (0, 0, 0);
  }

  for (int i = 1; i < numBalls+1; i++) {
    for (int j = 0; j < numThreads; j++) {
      ballp[i][j] = new PVector (ballp[i-1][j].x+x, ballp[i-1][j].y + y, (-j*(restLen))); // initial position of cloth 
      ballv[i][j] = new PVector (0, 0, 0);
    }
  }
  img = loadImage("quilt.jpg");
  noLoop();
}

void calculateForce(float dt) {
  for (int i = 1; i < numBalls + 1; i ++) {  // horizontal, calculate from leftmost ball to (second to rightmost ball)
    for (int j = 0; j < numThreads - 1; j++) {
      PVector ball1p = ballp[i][j];
      PVector ball1v = ballv[i][j];
      PVector ball2p = ballp[i][j+1]; // to the right of ball
      PVector ball2v = ballv[i][j+1];

      PVector e = PVector.sub(ball2p, ball1p);
      float l = e.mag();
      e.normalize();
      float v1 = e.dot(ball1v);
      e.normalize();
      float v2 = e.dot(ball2v);
      float f = (-k * (l - restLen));
      float d;
      d = (-kv * (v2-v1));
      f += d;
      PVector add = PVector.mult(e, f*dt);
      ballv[i][j] = PVector.sub(ballv[i][j], add);
      ballv[i][j+1] = PVector.add(ballv[i][j+1], add);
    }
  }


  for (int i = 0; i < numBalls; i++) {  // vertical
    for (int j = 0; j < numThreads; j++) {
      PVector ball1p = ballp[i][j]; //anchor
      PVector ball1v = ballv[i][j];
      PVector ball2p = ballp[i+1][j]; //ball
      PVector ball2v = ballv[i+1][j];

      PVector e = PVector.sub(ball2p, ball1p);
      float l = e.mag();
      e.normalize();
      float v1 = e.dot(ball1v);
      e.normalize();
      float v2 = e.dot(ball2v);
      float f = (-k * (l - restLen));
      float d;
      if (i == 0)
        d = (-kv * (v2));
      else
        d = (-kv * (v2-v1));
      f += d;
      PVector add = PVector.mult(e, f*dt);
      if (i == 0)
        ballv[i+1][j] = PVector.add(ballv[i+1][j], add);
      else {
        ballv[i][j] = PVector.sub(ballv[i][j], add);
        ballv[i+1][j] = PVector.add(ballv[i+1][j], add);
      }
    }
  }

  //gravity
  for (int i = 0; i < numBalls+1; i++) {
    for (int j = 0; j < numThreads; j++) {
      ballv[i][j].add(new PVector (0, grav*dt, 0));
    }
  }
}

void update(float dt) {
  calculateForce(dt);
  time ++;
  if (time % 30000 == 0) {
   numBalls --; 
  }
  for (int i = 1; i < numBalls+1; i++) {  // updating posiiton
    for (int j = 0; j < numThreads; j++) {
      ballp[i][j].add(ballv[i][j]);
      //if (ballp[i][j].dist(center) < radius) { // Ball Collision
      //  PVector n = PVector.sub(ballp[i][j], center);
      //  n.normalize();
      //  ballp[i][j] = PVector.add(center, n.mult(radius*1.01)); 
      //  ballv[i][j].mult(0.9);
      //  //ballp[i][j].add(PVector.mult(ballv[i][j], 0.99));
      //}
    }
  }
}

void display() {
  noStroke();
  push();
  for (int i = 0; i < numBalls; i++) {
    for (int j = 0; j < numThreads - 1; j++) {
      //fill(200, 100, 100);
      if (i >= numBalls - 1) {
        float r = random(1);
        if (  r< 0.33) {
          tint(255,150,0);
        } else if (r < 0.66) {
          tint(255,100,0);
        } else { 
          tint(255,0,0); 
        }
      } else {
        tint(255);
      }
      beginShape();
      texture(img);
      vertex(ballp[i][j].x, ballp[i][j].y, ballp[i][j].z, i*restLen, j*restLen);
      vertex(ballp[i][j+1].x, ballp[i][j+1].y, ballp[i][j+1].z, i*restLen, j*restLen+restLen);
      vertex(ballp[i+1][j].x, ballp[i+1][j].y, ballp[i+1][j].z, i * restLen + restLen, j*restLen);
      endShape();
      //fill(100, 100, 200);
      beginShape();
      texture(img);
      vertex(ballp[i][j+1].x, ballp[i][j+1].y, ballp[i][j+1].z, i*restLen, j*restLen+restLen);
      vertex(ballp[i+1][j+1].x, ballp[i+1][j+1].y, ballp[i+1][j+1].z, i * restLen + restLen, j*restLen + restLen);
      vertex(ballp[i+1][j].x, ballp[i+1][j].y, ballp[i+1][j].z, i * restLen + restLen, j*restLen);
      endShape();
      
      if (i == numBalls - 1) {
        fire.drawFire(ballp[i][j]);
      }
    }
  }
  pop();
}

void draw() {
  background(255);
  noLights();
  push();
  stroke(1);
  fill(100);
  line(300, ballp[0][0].y, 50, 300, ballp[0][0].y, -100); //where the fire could start
  pop();
  //push();
  ////b.display(center, change);
  //pop();
  for (int i = 0; i < updates; i++)
    update(dt);
  display();

  //uncomment for slower cloth
  for (int i = 1; i < numBalls+1; i++) {
    for (int j = 0; j < numThreads; j++) {
      ballv[i][j].mult(0.99);
    }
  }


  //camera.Update( 1.0/frameRate );

  surface.setTitle(str(round(frameRate)));
}

void mousePressed() {
  loop();
}


//Ball stuff

//void keyPressed() {
//  if ( keyCode == LEFT  ) change.x -= 1; 
//  if ( keyCode == RIGHT ) change.x += 1;
//  if ( keyCode == UP    ) change.y -= 1;
//  if ( keyCode == DOWN  ) change.y += 1;
//  if (key == 'z') change.z += 1;
//  if (key == 'x') change.z -= 1;
//}

//void keyReleased () {
//  if ( keyCode == LEFT  ) change.x = 0; 
//  if ( keyCode == RIGHT ) change.x = 0;
//  if ( keyCode == UP    ) change.y = 0;
//  if ( keyCode == DOWN  ) change.y = 0;
//  if (key == 'z') change.z = 0;
//  if (key == 'x') change.z = 0;
//}
