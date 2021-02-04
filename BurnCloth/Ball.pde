class Ball {
  PVector pos;
  float radius;
  PImage p;
  PShape ball;

  Ball (PVector pos, float radius) {
    this.pos = pos;
    this.radius = radius;
    p = loadImage("sonic.jpg");
        noStroke();
    ball = createShape(SPHERE, radius);
    ball.setTexture(p);
    ball.rotateY(PI/2);
    ambientLight(51, 102, 126);
    spotLight(51, 102, 126, 80, 20, 40, -1, 0, 0, PI/2, 2);
    directionalLight(51, 102, 126, -1, 0, 0);
    fill(50, 200, 150);
  }

  void display(PVector curPos, PVector change) {
    //push();
    translate(curPos.x+=change.x, curPos.y+=change.y, curPos.z+= change.z);
    shape(ball);
    //sphere(radius);
    //pop();
  }

  //  void handleKeyPress() {

  //  }
}
