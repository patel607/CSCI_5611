
class Ship {
  PVector pos;
  PVector vel;
  int radius = 26;
  int hits = 0;
  int health = 3;

  Ship (PVector pos) {
    this.pos = new PVector (pos.x, pos.y);
  }

  void display() {
    noStroke();
    if (!s.alive()) return;
    beginShape();
    texture(ship_tex);
    vertex(pos.x-30, pos.y-30, 0, 0, 0);
    vertex(pos.x+30, pos.y-30, 0, ship_tex.width, 0);
    vertex(pos.x+30, pos.y+30, 0, ship_tex.width, ship_tex.height);
    vertex(pos.x-30, pos.y+30, 0, 0, ship_tex.height);
    endShape();
    //circle(pos.x, pos.y, radius*2);
  }

  boolean alive() {
    if (s.hits >= s.health) 
      return false;
    return true;
  }
}
