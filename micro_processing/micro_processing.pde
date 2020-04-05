import processing.serial.*;
Serial microbit;

int _num = 10;
Circle[] _circleArr = {};   

void setup(){
  size(640, 480);
  background(255);
  String portName = Serial.list()[1];
  println(portName);
  smooth();
  strokeWeight(1);
  fill(150, 50);
  microbit = new Serial(this, portName, 115200);
  microbit.clear();
  microbit.bufferUntil(10);
}

void draw(){
  background(255);
  for (int i=0; i<_circleArr.length; i++) {
    Circle thisCirc = _circleArr[i];
    thisCirc.updateMe();
  }
}

void serialEvent(Serial microbit){
  String str = microbit.readStringUntil('\n');
  str = trim(str);
  int[] str_split = int(split(str, '\n'));
  println(str_split[0]);

  
  if (str_split[0] == 0){
    println("red");
    drawCircles("red");
  }else if(str_split[0] == 1){
    println("blue");
    drawCircles("blue");
  }else if(str_split[0] == 2){
    println("End Processing.");
    exit();
  }else{
    println("else");
    drawCircles("else");
  }
}

void drawCircles(String col_type) {
  for (int i=0; i<_num; i++) { 
    Circle thisCirc = new Circle(col_type);
    thisCirc.drawMe();
    _circleArr = (Circle[])append(_circleArr, thisCirc);
  }
}

class Circle {

  // properties
  float x, y;
  float radius; 
  color linecol, fillcol; 
  float alph;
  float xmove, ymove;
  
  Circle (String col_type) {
    x = random(width);
    y = random(height);
    radius = random(100) + 10; 
    if (col_type == "red"){
      linecol = color(random(150,255), random(100,150), random(100,150));
      fillcol = color(random(150,255), random(100,150), random(100,150));
    }else if(col_type == "blue"){
      linecol = color(random(100,150), random(100,150), random(150,255));
      fillcol = color(random(100,150), random(100,150), random(150,255));
    }else{
      linecol = color(random(100,255), random(100,255), random(100,255));
      fillcol = color(random(100,255), random(100,255), random(100,255));
    }
    alph = random(255);
    xmove = random(10) - 5;   
    ymove = random(10) - 5;  
  }

  void drawMe() { 
    noStroke(); 
    fill(fillcol, alph);
    ellipse(x, y, radius*2, radius*2);
    stroke(linecol, 150);
    noFill();
    ellipse(x, y, 10, 10);
  }
  
  void updateMe() {
    x += xmove;
    y += ymove;
    if (x > (width+radius)) { x = 0 - radius; }
    if (x < (0-radius)) { x = width+radius; }
    if (y > (height+radius)) { y = 0 - radius; }
    if (y < (0-radius)) { y = height+radius; }
    
   for (int i=0; i<_circleArr.length; i++) {
      Circle otherCirc = _circleArr[i];
      if (otherCirc != this) {  
        float dis = dist(x, y, otherCirc.x, otherCirc.y); 
        float overlap = dis - radius - otherCirc.radius; 
        if (overlap < 0) { 
          float midx, midy;
          if (x < otherCirc.x) {
            midx = x + (otherCirc.x - x)/2;
          } else {
            midx = otherCirc.x + (x - otherCirc.x)/2;
          }
          if (y < otherCirc.y) {
            midy = y + (otherCirc.y - y)/2;
          } else {
            midy = otherCirc.y + (y - otherCirc.y)/2;
          }
          stroke(0, 100);
          noFill();
          overlap *= -1; 
          ellipse(midx, midy, overlap, overlap);
        }
      }
    }
    drawMe();
  }
}
