class Explosion {

  ArrayList<PVector> posList = new ArrayList<PVector>();
  ArrayList<PVector> velList = new ArrayList<PVector>();
  float death = 5;
  float life = 0;
  int particles = 80;

  Explosion (PVector pos) {
    for  (int i = 0; i < particles; i++) {
      float r = enemyRadius * sqrt(random(1));
      float theta = 2 * PI * random(1);
      float partX = r * sin(theta);
      float partY = r * cos(theta);
      PVector newPos = new PVector (pos.x + partX, pos.y + partY);
      posList.add(newPos);
      velList.add(new PVector (partX, partY, int(random(3))));
      //posList.add(pos.copy());
      //velList.add(new PVector(random(-8, 8), random(-8, 8), int(random(3))));
    }
  }

  boolean alive() {
    if (life > death) 
      return false;
    return true;
  }


  void display(float dt) {
    //if (!alive()) return;

    strokeWeight(3);

    for (int i = 0; i < particles; i++) {
      float col = velList.get(i).z;
      float opacity = (5-life)*40;
      if (col == 0)
        stroke(255, 255, 0, opacity);
      else if (col == 1)
        stroke(255, 0, 0, opacity);
      else
        stroke(0, 255, 0, opacity);

      point(posList.get(i).x, posList.get(i).y);

      posList.get(i).x += velList.get(i).x *dt;
      posList.get(i).y += velList.get(i).y *dt;
    }

    life += dt;
    //println(posList.get(1).x);
    //println(posList.get(2).x);
  }
}
