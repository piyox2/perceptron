PrintWriter file;
String[] lines;
PVector[] teachers;
PVector w;
int row_num = 0;

void setup() {
  size(450, 450);
  frameRate(50);

  /*
    Creation of teacher data
    to linearly separate positive and negative of x.
  */
  file = createWriter("data/learning_data_rnd.txt");
  for (int i = 0; i < 500; i++) {
    int rnd_x = (int)random(5, 100);
    int rnd_y = (int)random(-100, 100);
    int flag = 1;
    if (i%2 == 0) {
      rnd_x = -rnd_x;
      flag = -flag;
    }
    file.println(rnd_x + "," + rnd_y + "," + flag);
    file.flush();
  }
  file.close();

  lines = loadStrings("learning_data_rnd.txt");
  teachers = new PVector[lines.length];
  w = PVector.random2D().setMag(100);
}

void draw() {
  layout();

  String[] val = split(lines[row_num], ",");
  teachers[row_num] = new PVector(int(val[0]), int(val[1]));

  // Drawing a point
  stroke(100, 100, 255);
  strokeWeight(3);
  for (int n = 0; n <= row_num; n++) {
    point(teachers[n].x, teachers[n].y);
  }
  
  // perceptron
  int kekka = ai(teachers[row_num], w);
  if (int(val[2]) == 1 && kekka == -1) w.add(teachers[row_num]);
  if (int(val[2]) == -1 && kekka == 1) w.sub(teachers[row_num]);
  
  // Generation of normal
  PVector n1 = w.copy().rotate(PI/2);
  PVector n2 = w.copy().rotate(-PI/2);
  stroke(255, 0, 0);
  strokeWeight(3);
  point(w.x, w.y);
  strokeWeight(1);
  line(0, 0, n1.setMag(300).x, n1.setMag(300).y);
  line(0, 0, n2.setMag(300).x, n2.setMag(300).y);

  row_num++;
  if (row_num >= lines.length) noLoop();
}

void layout() {
  background(-1);
  translate(width/2, height/2);
  scale(1, -1);
  stroke(0);
  strokeWeight(1);
  line(-width/2   ,   0, width/2, 0);
  line( width/2-10, -10, width/2, 0);
  line( width/2-10,  10, width/2, 0);
  line(0, -height/2,   0, height/2   );
  line(0,  height/2, -10, height/2-10);
  line(0,  height/2,  10, height/2-10);
  textAlign(RIGHT, BOTTOM);
  textSize(14);
  fill(0);
  text("O", -5, -5);
}

int ai(PVector _v, PVector _w) {
  float kekka = _v.dot(_w);
  if (kekka >= 0) return 1;
  return -1;
}