import java.util.*;
//multiply all values by 5
final int MULT = 50;
PVector start = new PVector(-9, -9, 0);
PVector goal = new PVector(9, 9, 0);
int dist = 3;
float obstacleR = 2;
float agentV = 0.0025;
  
PriorityQueue<Integer> pq = new PriorityQueue<Integer>(new distComparator()); 

ArrayList<PVector> config = new ArrayList<PVector>();
ArrayList<PVector> sol;
ArrayList<PVector> sol1;

int numNodes = 10;

//Represent our graph structure as 3 lists
ArrayList<Integer>[] neighbors = new ArrayList[numNodes];  //A list of neighbors can can be reached from a given node
Boolean[] visited = new Boolean[numNodes]; //A list which store if a given node has been visited
int[] parent = new int[numNodes]; //A list which stores the best previous node on the optimal path to reach this node
float[] distances = new float[numNodes];

int current_node_i = 0;
PVector agentPos = start.copy();
PVector direction;

float nowt, beforet, dt;

void setup() {
  size(1000, 1000, P3D);
  camera(0, 0, (height/2.0) / tan(PI*30.0 / 180.0), 0, 0, 0, 0, 1, 0);

  // Initalize the lists which represent our graph 
  for (int i = 0; i < numNodes; i++) { 
    neighbors[i] = new ArrayList<Integer>(); 
    visited[i] = false;
    parent[i] = -1; //No parent yet
    distances[i] = MAX_FLOAT;
  }

  sample();
  neighboring();
  //sol1 = bfs();
  //println(sol1);
  sol = a_star();
  println(sol);
  beforet = millis();
}

void sample() {
  int i = 2;

  config.add(start);
  while (i < numNodes) {
    float xr = random(-9, 9);
    float yr = random(-9, 9);
    PVector p = new PVector(xr, (yr), 0);
    if (PVector.dist(p, new PVector(0, 0, p.z)) > obstacleR + 0.5) {
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


//https://dzenanhamzic.com/2016/12/16/a-star-a-algorithm-implementation-in-java/
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
    println(current); 
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

ArrayList<PVector> bfs() {
  //Set start and goal
  int start = 0;
  int goal = numNodes-1;

  ArrayList<Integer> fringe = new ArrayList(); 

  visited[start] = true;
  fringe.add(start);

  while (fringe.size() > 0) {
    int currentNode = fringe.get(0);
    fringe.remove(0);
    if (currentNode == goal) {
      break;
    }
    for (int i = 0; i < neighbors[currentNode].size(); i++) {
      int neighborNode = neighbors[currentNode].get(i);
      if (!visited[neighborNode]) {
        visited[neighborNode] = true;
        parent[neighborNode] = currentNode;
        fringe.add(neighborNode);
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
  for (int j = 0; j < config.size(); j++) {
    for (int k = j+1; k < config.size(); k++) {
      if (k != j) {
        PVector p1 = config.get(j);
        PVector p2 = config.get(k);
        if (checkCollison(p2.y-p1.y, p1.x-p2.x, p2.x*p1.y-p2.y*p1.x, 0, 0, obstacleR)) {
          neighbors[j].add(k);
        }
      }
    }
  }


  println("List of Neighbors:");
  println(neighbors);
}

//https://www.geeksforgeeks.org/check-line-touches-intersects-circle/
boolean checkCollison(float a, float b, float c, float x, float y, float radius) {
  float dist = (abs(a * x + b * y + c)) /  
    sqrt(a * a + b * b); 
  if (radius +0.5 < dist)
    return true;
  else return false;
}

void drawEnv() {
  background(255, 255, 204);
  strokeWeight(4);
  stroke(218, 165, 32);  
  line(495, 495, 495, -495);
  line(495, -495, -495, -495);
  line(-495, -495, -495, 495);
  line(-495, 495, 495, 495);
  rotate(1.5*PI);

  strokeWeight(1);
  stroke(0);
  fill(218, 165, 32);
  circle(0, 0, 2*MULT*2);

  //lines between neighbors
  for (int i = 0; i < neighbors.length; i++) {
    for (int j = 0; j < neighbors[i].size(); j++) {
      line(config.get(i).x*MULT, config.get(i).y*MULT, config.get(neighbors[i].get(j)).x*MULT, config.get(neighbors[i].get(j)).y*MULT);
    }
  }


  fill(153, 51, 153);
  for (PVector c : config) {
    circle(c.x*MULT, c.y*MULT, 0.3*MULT);
  }

  fill(0, 255, 255);
  for (PVector c : sol) {
    circle(c.x*MULT, c.y*MULT, 0.3*MULT);
  }

  //goal
  fill(0, 255, 0);
  circle(9*MULT, 9*MULT, 0.5*MULT);
}

void update(float dt) {
  // reached goal
  if (current_node_i == sol.size() - 1) return;

  float path_length = agentV * dt;
  float dist;

  dist = PVector.dist(agentPos, sol.get(current_node_i+1));

  if (dist > path_length) {
    direction = PVector.sub(sol.get(current_node_i+1), sol.get(current_node_i));
    direction.normalize();
    agentPos = PVector.add(agentPos, PVector.mult(direction, path_length));
  } else {
    if (current_node_i + 1 == sol.size()-1) {
      current_node_i = sol.size()-1;
      agentPos = sol.get(sol.size()-1);
    } else {
      while (path_length - dist > 0) {
        if (current_node_i + 1 == sol.size()-1) {
          current_node_i = sol.size()-1;
          agentPos = sol.get(sol.size()-1);
          return;
        }
        path_length -= dist;
        current_node_i += 1;      
        dist = PVector.dist(sol.get(current_node_i+1), agentPos);    
        agentPos = sol.get(current_node_i);
      }
      direction = PVector.sub(sol.get(current_node_i+1), sol.get(current_node_i));
      direction.normalize(); 
      agentPos = PVector.add(agentPos, PVector.mult(direction, path_length));
    }
  }
}

void draw() {

  nowt = millis();
  dt = nowt - beforet;
  beforet = nowt;

  drawEnv();
  update(dt);
  fill(255, 0, 0);
  circle(agentPos.x*MULT, agentPos.y*MULT, 0.5*MULT*2);
}
