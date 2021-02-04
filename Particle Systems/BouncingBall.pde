// Created for CSCI 5611

// Here is a simple processing program that demonstrates the central math used in the check-in
// to create a bouncing ball. The ball is integrated with basic Eulerian integration.
// The ball is subject to a simple PDE of constant downward acceleration  (by default, 
// down is the positive y direction).

// If you are new to processing, you can find an excellent tutorial that will quickly
// introduce the key features here: https://processing.org/tutorials/p3d/

String projectTitle = "Bouncing Ball";

//Animation Principle: Store object & world state in external variables that are used by both
//                     the drawing code and simulation code.
float y_position = 200;
float x_position = 300;
float y_velocity = 0;
float x_velocity = 30;
float radius = 40; 
float floor = 600;
float left = 0;
float right = 600;

//Creates a 600x600 window for 3D graphics 
void setup() {
 size(600, 600, P3D);
 noStroke(); //Question: What does this do?
 //perspective();
}

//Animation Principle: Separate Physical Update 
void computePhysics(float dt){
  float acceleration = 9.8;
  
  //Eulerian Numerical Integration
  y_position = y_position + y_velocity * dt;  //Question: Why update y_position before y_velocity? Does it matter?
  y_velocity = y_velocity + acceleration * dt;
  
  x_position = x_position + x_velocity * dt;
  
  //Collision Code (update y_velocity if we hit the floor)
  if (y_position + radius > floor){
    y_position = floor - radius; //Robust collision check
    y_velocity *= -.75; //Coefficient of restitution (don't bounce back all the way) 
  }
  
  if (x_position + radius > right){
    x_position = right - radius; //Robust collision check
    x_velocity *= -.9; //Coefficient of restitution (don't bounce back all the way) 
  }
  
  if (x_position - radius < left){
    x_position =left + radius; //Robust collision check
    x_velocity *= -.9; //Coefficient of restitution (don't bounce back all the way) 
  }
}

//Animation Principle: Separate Draw Code
void drawScene(){
  background(255,255,255);
  fill(0,150,255); 
  lights();
  translate(x_position,y_position,0); 
  sphere(radius);
}

//Main function which is called every timestep. Here we compute the new physics and draw the scene.
//Additionally, we also compute some timing performance numbers.
void draw() {
  float startFrame = millis(); //Time how long various components are taking
  
  //Compute the physics update
  computePhysics(0.15); //Question: Should this be a fixed number?
  float endPhysics = millis();
  
  //Draw the scene
  //rotateY(1);
  drawScene();
  float endFrame = millis();
  
  String runtimeReport = "Frame: "+str(endFrame-startFrame)+"ms,"+
        " Physics: "+ str(endPhysics-startFrame)+"ms,"+
        " FPS: "+ str(round(frameRate)) +"\n";
  surface.setTitle(projectTitle+ "  -  " +runtimeReport);
  //print(runtimeReport);
}
