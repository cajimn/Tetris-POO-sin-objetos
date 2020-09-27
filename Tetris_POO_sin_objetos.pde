// Representación matricial de la pantalla.
int filas = 22;
int columnas = 12;

// Usar un ArrayList hace más facil la eliminación de filas completas
// Y añadir una nueva fila vacía al principio del grid.
ArrayList<color[]> grid = new ArrayList<color[]>();

// constantes: ancho y largo del cuadrado
float largo;
float ancho;

// Arrays usados para dibujar los tetrominos en sus
// respectivas rotaciones.
int [] T = {58368, 19520, 19968, 35968};
int [] Z = {50688, 19584, 50688, 19584};
int [] S = {27648, 35904, 27648, 35904};
int [] I = {3840 , 17476, 61440, 17476};
int [] O = {26112, 26112, 26112, 26112};
int [] L = {59392, 50240, 11776, 35008};
int [] J = {57856, 17600, 36352, 51328};

int [] figura;
int [] figura2;

int figP = (int) random (0,6);
int numFigura = (int) random (0,6);


// Rotacion inicial.
int tRotation = 2;
int pRotation = 1;

// posiciones de los cuadrados
int movX = 4;
int movY = 0;

float posX;
float posY;

int[] pixel= new int[6];
float posx;
float posy;
// colores RGB.
color[] colores = {
  color(234,230,202), //Borde---0
  color(128, 12, 128), //purple---1-T
  color(230, 12, 12), //red-------2-Z
  color(12, 230, 12), //green-----3-S
  color(9, 239, 230), //cyan------4-I
  color(230, 230, 9), //yellow----5-O
  color(230, 128, 9), //orange----6-L
  color(12, 12, 230)};//blue------7-J

// contadores e Intervalos.
int timerPaso;
int intervaloPaso = 1000;
int timerFilaCompleta;
int intervaloFilaCompleta = 10;

// Fuente para letreros
PFont f;

// banderas
boolean startgame = false;
boolean gameOverBool = false;

//Niveles
int puntaje=0;
int nivel=1;

void setup() {
  // pantalla 420x840 pixels.
  size(504, 504);
  ancho = 252/columnas;
  largo = height/(filas-1);  

  // Inicializar grid
  resetgrid();
  //println();
  //imprimirArrayList();

  // Crear fuente para grids.
  //printArray(PFont.list());
  f = createFont("Consolas Bold", 24);
}

void draw() {

  inicio();

  if (startgame==true) {
    marcadores();    

    if (!gameOverBool) {
      drawgrid();
      nextFigura(figP);
      drawTetromino(numFigura);
      bajadoFiguras();      
      
    } else {gameOver();}
  }
}



void drawTetromino(int numero) {
  switch (numero) {
  case 0:
    fill(colores[1], 80);
    figura = T;   
    break;
  case 1:
    fill(colores[2], 80);
    figura = Z;
    break;
  case 2:
    fill(colores[3], 80);
    figura = S;
    break;
  case 3:
    fill(colores[4], 80);
    figura = I;
    break;
  case 4:
    fill(colores[5], 80);
    figura = O;
    break;
  case 5:
    fill(colores[6], 80);
    figura = L;
    break;
  case 6:
    fill(colores[7], 80);
    figura = J;
    break;
  }

  push();
  translate(0, -largo);
  stroke(0);
  strokeWeight(2);
  for (int i = 0; i <= 15; i++) {
    if ((figura[tRotation] & (1 << 15 - i)) != 0) {
      posX = (i%4)*ancho + movX*ancho;
      posY = (floor(i/4)) * largo + movY*largo;
      rect(posX, posY, ancho, largo, 4);
    } /*else {
     posX = (i%4)*ancho + movX*ancho;
     posY = (floor(i/4)) * largo + movY*largo;
     push();
     fill(colores[0]);
     rect(posX, posY, ancho, largo);
     pop();
     }*/
  }
  pop();
  niveles();
}


void nextFigura(int numero) {
  switch (numero) {
  case 0:
    fill(colores[1]);
    figura = T;   
    break;
  case 1:
    fill(colores[2]);
    figura = Z;
    break;
  case 2:
    fill(colores[3]);
    figura = S;
    break;
  case 3:
    fill(colores[4]);
    figura = I;
    break;
  case 4:
    fill(colores[5]);
    figura = O;
    break;
  case 5:
    fill(colores[6]);
    figura = L;
    break;
  case 6:
    fill(colores[7]);
    figura = J;
    break;
  }
  push();
  translate(265, 25);
  for (int i = 0; i <= 15; i++) {
    if ((figura[2] & (1 << 15 - i)) != 0) {
     posX = (i%4)*ancho + ancho+50;
     posY = (floor(i/4)) * largo + largo;
     rect(posX, posY, ancho, largo, 4);
     }
  }
  pop();
}

void bajadoFiguras(){
  if (millis() - timerPaso >= intervaloPaso) {
    darPaso();
    timerPaso = millis();
    niveles();
  }
  if (millis() - timerFilaCompleta >= intervaloFilaCompleta) {
    filasCompletas();
    timerFilaCompleta = millis();
  }
}

void drawgrid() {
  fondo();
  push();
  stroke(0);
  strokeWeight(2);
  translate(0, -largo);
  for (int i=0; i < filas; i++) {
    push();
    stroke(0);
    strokeWeight(1);
    line(0, i*largo, width/2, i*largo);
    pop();
    for (int j=0; j < columnas; j++) {
      push();
      stroke(0);
      strokeWeight(1);
      line(j*ancho, 0, j*ancho, height);
      pop();
      if (j == 0 || j == columnas - 1 || i == filas - 1) {
        fill(colores[0]);
        rect(j*ancho, i*largo, ancho, largo, 4);
      } else if (grid.get(i)[j] != 0) {
        fill(grid.get(i)[j]);
        rect(j*ancho, i*largo, ancho, largo, 4);
      }
    }
  }
  pop();
}

void keyPressed() {
  if (keyCode == ENTER) {
    startgame =true;
  }
  if (!gameOverBool) {
    if (key == 'a' || keyCode == LEFT) {
      if (!colisionIzquierda()) 
        movX--;
    } else if (key == 'd' || keyCode == RIGHT) {
      if (!colisionDerecha()) 
        movX++;
    } else if (key == 's' || keyCode == DOWN) {
      if (!colisionAbajo()) 
        darPaso();
    } else if (key == ' ') {
      if (!colisionAbajo()) {
        darPaso();
        push();
        if (!colisionAbajo()) {
          timerPaso=10;
        }
        pop();
      }
    } else if (key == 'w' || keyCode == UP) {
      pRotation = tRotation;
      tRotation = (tRotation + 1)%4;
      // Agregada esta condición para evitar bugs en las rotaciones cerca de un borde.
      if (colisionRotacion()) tRotation = pRotation;
    }
  } else {
    if (keyCode == ENTER) {
      resetgrid();
      resetVariables();
      resetMarcadores();
      //timerPaso=millis();
    }
  }
}

boolean colisionIzquierda() {
  int posMX;
  int posMY;
  for (int j = 0; j < 4; j++)
  {
    for (int i = j; i < 16; i += 4) {
      if ((figura[tRotation] & (1 << 15 - i)) != 0) {
        posMX = (i%4) + movX;
        posMY = ((i/4)|0) + movY;
        if (grid.get(posMY)[posMX-1] != 0)
          return true;
      }
    }
  }
  return false;
}

boolean colisionDerecha() {
  int posMX;
  int posMY;
  for (int j = 0; j < 4; j++)
  {
    for (int i = j; i < 16; i += 4) {
      if ((figura[tRotation] & (1 << i)) != 0) {
        posMX = ((15-i)%4) + movX;
        posMY = (((15-i)/4)|0) + movY;
        if (grid.get(posMY)[posMX+1] != 0)
          return true;
      }
    }
  }
  return false;
}

boolean colisionAbajo() {
  int posMX;
  int posMY;
  for (int i = 0; i < 16; i ++) {
    if ((figura[tRotation] & (1 << i)) != 0) {
      posMX = ((15-i)%4) + movX;
      posMY = (floor((15-i)/4)) + movY;
      if (grid.get(posMY+1)[posMX] != 0) {
        return true;
      }
    }
  }
  return false;
}

boolean colisionRotacion() {
  int posMX;
  int posMY;
  for (int i = 0; i <= 15; i++) {
    if ((figura[tRotation] & (1 << 15 - i)) != 0) {
      posMX = (i%4) + movX;
      posMY = (floor(i/4)) + movY;
      if (grid.get(posMY)[posMX] != 0) return true;
    }
  }
  return false;
}

void siguienteFigura() {
  int posMX;
  int posMY;
  for (int i = 0; i <= 15; i++) {
    if ((figura[tRotation] & (1 << 15 - i)) != 0) {
      puntaje +=1;
      posMX = (i%4) + movX;
      posMY = (floor(i/4)) + movY;
      grid.get(posMY)[posMX] = colores[numFigura+1];
    }
  }
  resetVariables();
}

void darPaso() {
  if (!colisionAbajo()) {
    movY++;
  } else {
    int i;
    for (i = 1; i < (columnas - 1)  &&  grid.get(1)[i] == 0; i++) {
    }
    gameOverBool = i < (columnas - 1);
    if (!gameOverBool) siguienteFigura();
  }
}

void filasCompletas() {
  for (int i = filas - 2; i >= 0; i--) {
    int j = 0;
    for (j = 1; j < 11 && grid.get(i)[j] != 0; j++) {
    }
    if (j == 11) {
      puntaje += 20;
      grid.remove(i);
      grid.add(0, new color[columnas]);
      grid.get(0)[0] = colores[0];
      grid.get(0)[columnas-1] = colores[0];
    }
  }
}

void gameOver() {
  background(80, 80, 180);
  push();
  translate(width/2, height/5);
  textFont(f);
  textAlign(CENTER, CENTER);

  stroke(75,54,33);
  strokeWeight(5);
  fill(255, 240, 0);
  rectMode(CENTER);
  rect(0, 0, 240, 70, 10);

  fill(40);
  textSize(35);
  text("GAME OVER", 0, 0);

  fill(0, 0, 255);
  textSize(34);
  text("GAME OVER", 0, 0);
//
  fill(255,50,0);
  translate(0, height/4);
  rect(0, 4, 310, 130, 10);

  fill(40);
  textSize(34.5);
  text("Your score was", 0, -20);

  fill(0, 0, 255);
  textSize(34);
  text("Your score was", 0, -20);
  text(puntaje, 0, 35);
//
  fill(255,230,00);
  translate(0, height/4);
  rect(0, 40, 350, 80, 10);
  
  fill(40);
  textSize(30.5);
  text("¡Try Again!", 0, 20);
  text("Press Enter", 0, 50);
  
  fill(0, 0, 255);
  textSize(30);
  text("¡Try Again!", 0, 20);
  text("Press Enter", 0, 50);


  pop();
}

void resetgrid() {
  grid = new ArrayList<color[]>();
  // ArrayList de arrays con ceros en sus elementos.
  for (int k = 0; k < filas; k++) {
    grid.add(new color[columnas]);
  }
  //imprimirArrayList();
  for (int i = 0; i < filas; i++) {
    for (int j = 0; j < columnas; j++) {
      if (j == 0 || j == columnas - 1 || i == filas - 1)
        grid.get(i)[j] = colores[0];
    }
  }
}

void resetVariables() {
  numFigura = figP;
  figP=(int)random(0,6);
  tRotation = 2;
  movX = 4;
  movY = 0;
  gameOverBool = false;
  timerPaso = millis();
  timerFilaCompleta = millis();
}

void imprimirArrayList() {
  for (int i = 0; i < filas; i++) {
    for (int j = 0; j < columnas; j++) {
      print(grid.get(i)[j] + " ");
    }
    println();
  }
}

void niveles() {

  if (puntaje >= 120) {
    nivel=2;
    timerPaso=timerPaso-20;
  }
  if (puntaje >= 240) {
    nivel=3;
    timerPaso=timerPaso-20;
  }
  if (puntaje >= 360) {
    nivel=4;
    timerPaso=timerPaso-20;
  }
  if (puntaje >= 480) {
    nivel=5;
    timerPaso=timerPaso-20;
  }
  if (puntaje >= 600) {
    nivel=6;
    timerPaso=timerPaso-20;
  }
  if (puntaje >= 720) {
    nivel=7;
    timerPaso=timerPaso-20;
  }
  if (puntaje >= 840) {
    nivel=8;
    timerPaso=timerPaso-20;
  }
  if (puntaje >= 960) {
    nivel=9;
    timerPaso=timerPaso-20;
  }
}

void marcadores() {
  background(80, 80, 180);
  fill(130);
  rect(0, 0, 252, height);
  push();
  fill(0, 0, 255);
  translate(width*10/13.3, height/3);
  textFont(f);
  textAlign(CENTER, CENTER);

  stroke(75,54,33);
  strokeWeight(5);
  fill(255, 230, 0);
  rectMode(CENTER);
  rect(0, 4, 200, 70, 10);

  fill(40);
  textSize(20);
  text("Nivel: "+nivel, 0, 0);

  fill(0, 0, 255);
  textSize(20);
  text("Nivel: "+nivel, 0, 0);
  
  translate(0, height/4);
  
  fill(255,50,0);
  rect(0, 4, 150, 150, 10);
  
  fill(40);
  textSize(20);
  text("Score", 0, -20);

  fill(0, 0, 255);
  textSize(20);
  text("Score", 0, -20);
  textSize(40);
  text(puntaje, 0,20);
  
  pop();
}

void inicio() {
  push();
  background(80, 80, 180);
  translate(width/2, height/2);
  textFont(f);
  textAlign(CENTER, CENTER);

  stroke(75,54,33);
  strokeWeight(5);
  fill(255, 230, 0);
  rectMode(CENTER);
  rect(0, 4, 240, 70, 10);

  fill(40);
  textSize(18);
  text("Press ENTER to start", 0, 0);

  fill(0, 0, 255);
  textSize(18);
  text("Press ENTER to start", 0, 0);
  pop();
  
  
}

void resetMarcadores(){
  puntaje=0;
  nivel=1;
}

void fondo(){
  push();
  //frameRate(1);
  fill(colores[(int)random(0,7)]);
  noStroke();
  posx=(int)random(width/2,width);
  for(int i=0; i<height;i++){
    rect(posx,i,1,2);
  }
  pop();
}
