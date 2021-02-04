import java.util.*;

Camera cam = new Camera();
Random random = new Random();
PVector start = new PVector(-9,9,0);
PVector end = new PVector(9,-9,0);
PVector obsPos = new PVector(0,0,0);
float obsR = 2.0;
float agentR = 0.5;
float confR = obsR + agentR;
ArrayList<PVector> path;
float agentV = 0.01;

DPQ dpq = new DPQ();

void setup(){
  size(1000, 1000, P3D);
  cam.position = new PVector(0, 0, 40);
  
  while (true){
    dpq.genRandomPoints();
    if (dpq.buildGraph()) break;
  }
  path = dpq.dijkstra();  
  beforet = millis();
  println(path);
}


public class DPQ { 
    ArrayList<PVector> randomPoints;
    int nRandomPoint = 100;
    private float dist[]; 
    private Set<Integer> settled; 
    private PriorityQueue<Node> pq; 
    private int V; // Number of vertices 
    //List<List<Node> > adj; 
    LinkedList<Node> adj[];
  
    public DPQ() 
    { 
         
        //pq = new PriorityQueue<Node>(V, new Node()); 
        randomPoints = new ArrayList<PVector>(this.nRandomPoint);
        for (int i = 0; i < this.nRandomPoint; i++) {
          this.randomPoints.add(new PVector(0,0,0));
        }
    } 
    
    boolean buildGraph(){
      settled = new HashSet<Integer>();
      this.randomPoints.add(agentPos);
      this.randomPoints.add(end);
      this.V = this.randomPoints.size(); 
      dist = new float[V];
      pq = new PriorityQueue<Node>(V, new Node()); 
      this.adj = new LinkedList[this.nRandomPoint+2]; 
      for(int i = 0; i < this.nRandomPoint+2 ; i++){ 
          adj[i] = new LinkedList<Node>(); 
      } 
      PVector p1, p2;
      boolean can_reach_end = false;
      for (int i = 0; i < this.nRandomPoint+1; i++) {
        p1 = this.randomPoints.get(i);
        for (int j = i+1; j < this.nRandomPoint+2; j++) {
          p2 = this.randomPoints.get(j);
          if (this.checkCollison(p2.y-p1.y, p1.x-p2.x, p2.x*p1.y-p2.y*p1.x, obsPos.x, obsPos.y, obsR)){
            adj[i].add(new Node(j, 0));
            adj[j].add(new Node(i, 0));
            if (j==this.nRandomPoint+1) can_reach_end = true;
          }
        }
      }    
      return can_reach_end;
    }
    
    void genRandomPoints(){
      int n = 0;
      float x, y;
      PVector tmp;
      while (n<this.nRandomPoint){
        x = -9.5 + random.nextFloat() * 19;
        y = -9.5 + random.nextFloat() * 19;
        tmp = new PVector(x, y, 0);
        if (PVector.dist(tmp, obsPos) > confR){
          this.randomPoints.set(n, tmp);
          n++;
        }            
      }
    }
    
    boolean checkCollison(float a, float b, float c, float x, float y, float radius){
      // Finding the distance of line from center. 
      double dist = (abs(a * x + b * y + c)) /  
                      sqrt(a * a + b * b); 
    
      // Checking if the distance is less than,  
      // greater than or equal to radius. 
      if (radius < dist) return true;
      else return false;
    }
  
    // Function for Dijkstra's Algorithm 
    public ArrayList<PVector> dijkstra() 
    { 
        int src = this.nRandomPoint;
        for (int i = 0; i < V; i++) 
            dist[i] = Float.MAX_VALUE; 
  
        // Add source node to the priority queue 
        pq.add(new Node(src, 0)); 
  
        // Distance to the source is 0 
        dist[src] = 0; 
        //while (settled.size() != V) { 
  
        //    // remove the minimum distance node  
        //    // from the priority queue  
        //    int u = pq.remove().node; 
   
        //    // adding the node whose distance is 
        //    // finalized 
        //    settled.add(u); 
  
        //    e_Neighbours(u); 
        //} 
        Node currentnode = new Node(src, 0);
        int u;
        while (settled.size() != V) { 
  
            // remove the minimum distance node  
            // from the priority queue  
            currentnode = pq.remove(); 
            u = currentnode.node;
            if (settled.contains(u)) continue;
            if (u==this.nRandomPoint+1) break;
   
            // adding the node whose distance is 
            // finalized 
            settled.add(u);  //<>//
            e_Neighbours(u, currentnode);  //<>//
        } 
        ArrayList<PVector> path = new ArrayList<PVector>();
        while(currentnode != null){
          path.add(this.randomPoints.get(currentnode.node));
          currentnode = currentnode.prenode;          
        }
        Collections.reverse(path);
        return path;
    } 
  
    // Function to process all the neighbours  
    // of the passed node 
    private void e_Neighbours(int u, Node node) 
    { 
        float edgeDistance = -1; 
        float newDistance = -1; 
        Node tmp;
  
        // All the neighbors of v 
        for (int i = 0; i < adj[u].size(); i++) { 
            Node v = adj[u].get(i); 
  
            // If current node hasn't already been processed 
            if (!settled.contains(v.node)) { 
                edgeDistance = this.randomPoints.get(u).dist(this.randomPoints.get(v.node));//v.cost; 
                newDistance = dist[u] + edgeDistance; 
  
                // If new distance is cheaper in cost 
                if (newDistance < dist[v.node]) 
                    dist[v.node] = newDistance; 
  
                // Add the current node to the queue 
                tmp = new Node(v.node, dist[v.node]);
                tmp.prenode = node;
                pq.add(tmp); 
            } 
        } 
    } 
}

class Node implements Comparator<Node> { 
    public int node; 
    public float cost; 
    public Node prenode;
  
    public Node() 
    { 
    } 
  
    public Node(int node, float cost) 
    { 
        this.node = node; 
        this.cost = cost; 
        this.prenode = null;
    } 
  
    @Override
    public int compare(Node node1, Node node2) 
    { 
        if (node1.cost < node2.cost) 
            return -1; 
        if (node1.cost > node2.cost) 
            return 1; 
        return 0; 
    } 
} 


void drawEnv(){
  background(119, 136, 153);
  
  fill(255, 255, 255);
  square(-10, -10, 20);
  
  fill(119, 136, 153);
  circle(obsPos.x,obsPos.y, 2*obsR);  
  
  fill(164, 196, 0);
  square(-9.5, 8.5, 1);
  square(8.5, -9.5, 1);
  
  strokeWeight(2);
  for (int i = 0; i < path.size()-1; i++) {
    line(path.get(i).x,path.get(i).y,
         path.get(i+1).x, path.get(i+1).y);
  }
}

int current_node_i = 0;
PVector agentPos = start.copy();
PVector direction;
void update(float dt){
  if (current_node_i == path.size() - 1) return;
  float path_length = agentV * dt;
  float dist;
  
  dist = PVector.dist(agentPos, path.get(current_node_i+1));

  if (dist > path_length){
    direction = PVector.sub(path.get(current_node_i+1), path.get(current_node_i));
    direction.normalize();
    agentPos = PVector.add(agentPos, PVector.mult(direction, path_length));
  }else{
    if (current_node_i + 1 == path.size()-1){
      current_node_i = path.size()-1;
      agentPos = path.get(path.size()-1);
    }else{
      while(path_length - dist > 0){
        if (current_node_i + 1 == path.size()-1){
          current_node_i = path.size()-1;
          agentPos = path.get(path.size()-1);
          return;
        }
        path_length -= dist;
        current_node_i += 1;      
        dist = PVector.dist(path.get(current_node_i+1), agentPos);    
        agentPos = path.get(current_node_i);
      }
      direction = PVector.sub(path.get(current_node_i+1), path.get(current_node_i));
      direction.normalize(); 
      agentPos = PVector.add(agentPos, PVector.mult(direction, path_length));
    }
  } 
}

void drawAgent(){
  fill(241, 179, 179);
  circle(agentPos.x,agentPos.y, 2*agentR); 
}

float nowt, beforet, dt;

void draw(){
  
  nowt = millis();
  dt = nowt - beforet;
  beforet = nowt;
  
  cam.Update(dt);
  drawEnv();
  update(dt);
  drawAgent();
   
  
}
