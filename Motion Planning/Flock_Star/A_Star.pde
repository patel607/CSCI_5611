import java.util.*;
//multiply all values by 5
final int MULT = 50;
PVector start = new PVector(100, height-100, 0);
PVector goal = new PVector(width-100,100);
//int dist = 3;
float obstacleR = 100;
float agentV = 0.0025;
  
PriorityQueue<Integer> pq = new PriorityQueue<Integer>(new distComparator()); 

ArrayList<PVector> config = new ArrayList<PVector>();
ArrayList<PVector> sol;

int numNodes = 50;

//Represent our graph structure as 3 lists
ArrayList<Integer>[] neighbors = new ArrayList[numNodes];  //A list of neighbors can can be reached from a given node
Boolean[] visited = new Boolean[numNodes]; //A list which store if a given node has been visited
int[] parent = new int[numNodes]; //A list which stores the best previous node on the optimal path to reach this node
float[] distances = new float[numNodes];

int current_node_i = 0;
PVector agentPos = start.copy();
PVector direction;

float nowt, beforet;

void run_A() {
  
  for (int i = 0; i < numNodes; i++) { 
    neighbors[i] = new ArrayList<Integer>(); 
    visited[i] = false;
    parent[i] = -1; //No parent yet
    distances[i] = MAX_FLOAT;
  }
  
  sample();
  numNodes = config.size();  
  
  neighboring();
  //sol1 = bfs();
  //println(sol1);
  sol = a_star();
  println(sol);
}


void sample() {
  int i = 2;
  boolean check = true;
  config.add(start);
  while (i < numNodes) {
    check = true;
    float xr = random(width);
    float yr = random(height);
    PVector p = new PVector(xr, yr, 0);
    for (PVector ob: obstacles) {
      if (PVector.dist(p, ob) < obstacleR + 3) {
        check = false;     
      }
    }
    if (check) {
      config.add(p);  
      i++;  
    }
  }
  config.add(goal); //end
}

float distance(int a, int b) {
  PVector p1 = config.get(a);
  PVector p2 = config.get(b);
  return sqrt ( sq(p1.x - p2.x) + sq(p1.y - p2.y) );
}

class distComparator implements Comparator<Integer> { 
  // Overriding compare()method of Comparator  
  // for descending order of cgpa 
  public int compare(Integer a, Integer b) { 
    if (distances[a] < distances[b]) 
      return -1; 
    else if (distances[a] > distances[b]) 
      return 1; 
    return 0;
  }
} 

ArrayList<PVector> a_star() {
  int start = 0;
  int goal = numNodes-1;
  //  enque StartNode, with distance 0
  config.get(start).z = 0;
  distances[start] = 0.0;
  pq.add(start);
  int current = -1;

  while (!pq.isEmpty()) {
    current = pq.remove();
    //println(current); 
    if (!visited[current]) {
      visited[current] = true;
      // if last element in PQ reached
      //println(current); 
      if (current == goal) break;

      for (int neighbor : neighbors[current]) {
        if (!visited[neighbor]) { 
          // calculate predicted distance to the end node
          float predictedDistance = distance(neighbor, goal);

          // 1. calculate distance to neighbor. 2. calculate dist from start node
          float neighborDistance = distance(current, neighbor);
          float totalDistance = distance(current, start) + neighborDistance + predictedDistance;

          // check if distance smaller
          if (totalDistance < distances[neighbor]) {
            // update n's distance
            // used for PriorityQueue
            distances[neighbor] = totalDistance;
            // set parent
            parent[neighbor] = current;
            // enqueue
            pq.add(neighbor);
          }
        }
      }
    }
  }
  ArrayList<PVector> path = new ArrayList<PVector>();
  int prevNode = parent[goal];
  path.add(config.get(goal));
  while (prevNode >= 0) {
    path.add(config.get(prevNode));
    prevNode = parent[prevNode];
  }
  Collections.reverse(path);
  return path;
}

void neighboring() {
  boolean check;
  for (int j = 0; j < config.size(); j++) {
    for (int k = j+1; k < config.size(); k++) {
      check = true;
      if (k != j) {
        PVector p1 = config.get(j);
        PVector p2 = config.get(k);
        for (PVector ob: obstacles) {
          //if (!checkCollison(p2.y-p1.y, p1.x-p2.x, p2.x*p1.y-p2.y*p1.x, ob.x, ob.y, obstacleR)) {
          if (checkCollision(p1, p2, ob, obstacleR)) {
            check = false;
          }
        }
        if (check) neighbors[j].add(k);
      }
    }
  }
}

//return if path is clear of circle
//boolean checkCollision(float a, float b, float c, float x, float y, float radius) {
//  float dist = (abs(a * x + b * y + c)) /  
//    sqrt(a * a + b * b); 
//  if (radius + 5 < dist)
//    return true;
//  else return false;
//}

//return if circle collides with path
boolean checkCollision(PVector e, PVector l, PVector circ, float r) {
  PVector d = PVector.sub(l,e);
  PVector f = PVector.sub(e,circ);
  
  float a = d.dot( d ) ;
  float b = 2*f.dot( d ) ;
  float c = f.dot( f ) - r*r ;

  float discriminant = b*b-4*a*c;
  if( discriminant < 0 ){
    return false;
  }
  else {
  // ray didn't totally miss sphere,
  // so there is a solution to
  // the equation.
  discriminant = sqrt( discriminant );

  // either solution may be on or off the ray so need to test both
  // t1 is always the smaller value, because BOTH discriminant and
  // a are nonnegative.
  float t1 = (-b - discriminant)/(2*a);
  float t2 = (-b + discriminant)/(2*a);

  // 3x HIT cases:
  //          -o->             --|-->  |            |  --|->
  // Impale(t1 hit,t2 hit), Poke(t1 hit,t2>1), ExitWound(t1<0, t2 hit), 

  // 3x MISS cases:
  //       ->  o                     o ->              | -> |
  // FallShort (t1>1,t2>1), Past (t1<0,t2<0), CompletelyInside(t1<0, t2>1)

  if( t1 >= 0 && t1 <= 1 )
  {
    // t1 is the intersection, and it's closer than t2
    // (since t1 uses -b - discriminant)
    // Impale, Poke
    return true ;
  }

  // here t1 didn't intersect so we are either started
  // inside the sphere or completely past it
  if( t2 >= 0 && t2 <= 1 )
  {
    // ExitWound
    return true ;
  }

  // no intn: FallShort, Past, CompletelyInside
  return false ;
}
  
  
}

void drawEnv() {
  //lines between neighbors
  strokeWeight(3);
  stroke(0);
  
  for (int i = 0; i < neighbors.length; i++) {
    for (int j = 0; j < neighbors[i].size(); j++) {
      line(config.get(i).x, config.get(i).y, config.get(neighbors[i].get(j)).x, config.get(neighbors[i].get(j)).y);
    }
  }


  fill(153, 51, 153);
  for (PVector c : config) {
    circle(c.x, c.y, 20);
  }

  fill(0, 255, 255);
  for (PVector c : sol) {
    circle(c.x, c.y, 20);
  }
  
}
