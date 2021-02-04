class ShipBullet {
  PVector pos;
  PVector vel;

  ShipBullet (PVector pos, PVector vel) {
    this.pos = new PVector (pos.x, pos.y);
    this.vel = vel;
  }

  void display() {
    push();
    //stroke(255);
    strokeWeight(10);
    point(pos.x, pos.y);
    pop();
  }

  void update(float dt) {
    pos.add(PVector.mult(vel, dt));
  }
}
