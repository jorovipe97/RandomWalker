import org.gicentre.utils.stat.*; // Importa las clases de graficacion
import interfascia.*;

/*
  El juego consiste en en decir si luego de un numero x de pasos
  el walker saldra del circulo y por que lado saldra
*/

// Cada vez que da un paso en alguna direccion se considerara que se realizo un esperimento
// para configurar cuantas veces se puede realizar el experimento
// se debe modificar la siguiente variable.
int canDoXSteps = 1000;
int stepsRealizados = 0;

BarChart histograma;
float[] data;
String[] dataLabels;

Walker8 walker8;
int circleDiameter;

PVector initStep, actualStep;
PFont gameOverText;
PImage circleDirections;

// Calculador de datos estadisticos
Statistics stats;
float[] meanArr;

// Interfascia stuff
GUIController guiController;
IFLabel label;
IFLabel label2;
IFLabel label3;
IFLabel label4;
IFLabel label5;
IFLabel label6;

 
void setup() {
  // interfascia stuffs
  guiController = new GUIController (this);  
  label = new IFLabel ("Mean: ", 720+30, height-(270+15));
  label2 = new IFLabel ("Mediana: ", 720+30, height-(270));
  label3 = new IFLabel ("Mediana: ", 720+30, height-(270-15));
  label4 = new IFLabel ("Mediana: ", 720+30, height-(270-15-15));
  label5 = new IFLabel ("Mediana: ", 720+30, height-(270-15-15-15));
  label6 = new IFLabel ("Mediana: ", 720+30, height-(270-15-15-15-15));
  guiController.add (label);
  guiController.add (label2);
  guiController.add (label3);
  guiController.add (label4);
  guiController.add (label5);
  guiController.add (label6);
  
  // Statistic lib stuff
  meanArr = new float[8];
  stats = new Statistics();
  
  // Set the bg color only one time
  background(255);
  
  gameOverText = createFont("Arial", 48, true);
  circleDirections = loadImage("circle_directions.png");
  
  // El segundo argumento es para que quede en la mitad de la 
  // parte superior de la pantalla
  data = new float[8];
  walker8 = new Walker8(1280/4, -720/4);
  // Draw a elipse
  // Ten en cuenta que la posicion de la elpice es la misma posicion inicial del walker
  // para cambiar la posicion de la elipse debes cambiar la posicion inicial del walker
  stroke(0);
  circleDiameter = 100;
  strokeWeight(2);
  ellipse(walker8.getInitialX(), walker8.getInitialY(), circleDiameter, circleDiameter);
  image(circleDirections, walker8.getInitialX()-circleDirections.width/2, walker8.getInitialY()-circleDirections.width/2);
  initStep = new PVector(walker8.getInitialX(), walker8.getInitialY());
  actualStep = new PVector(walker8.getInitialX(), walker8.getInitialY());
  
  // Convierte los datos del array de int to float para que el ploter los pueda entender
  for (int i = 0; i < 8; i++)
  {
    data[i] = (float) walker8.movementHistoric[i]; // 4 categorias
  }
  dataLabels = new String[] {"1 L&U", "2 L&D", "3 Left", "4 Up", "5 Down", "6 Right", "7 R&D", "8 R&U"};
  
  size(1280,720);
  histograma = new BarChart(this);
  histograma.setData(data);
  histograma.setBarLabels(dataLabels);
  
  // Axis scaling
  histograma.setMinValue(0);
  histograma.setMaxValue(40);
  histograma.setBarGap(8);
  
  histograma.showValueAxis(true);
  histograma.showCategoryAxis(true);
  
  // Para poder calcular la media debo darle un valor a cada paso, a continuacion se dira que valores se dan
  /*
    
    l&u: 1
    l&d: 2
    left: 3
    up: 4
    down: 5
    right: 6
    r&d: 7
    r&u: 8
    
  */
}
 
void draw() {
  background(255);
  strokeWeight(2);
  ellipse(walker8.getInitialX(), walker8.getInitialY(), circleDiameter, circleDiameter);
  image(circleDirections, walker8.getInitialX()-circleDirections.width/2, walker8.getInitialY()-circleDirections.width/2);
  
  // Realizar un paso
  walker8.drawGaussian();
    
  
  // Se guarda el paso en un vector para luego calcular si el walker salio del circulo con facilidad
  actualStep.x = walker8.x;
  actualStep.y = walker8.y;
  
  for (int i = 0; i < 8; i++)
  {
    data[i] = (float) walker8.movementHistoric[i]; // 4 categorias
    
    switch (i)
    {
      case 0:
        meanArr[i] = (float) (walker8.movementHistoric[i] * (i+1));
        break;
      case 1:
        meanArr[i] = (float) (walker8.movementHistoric[i] * (i+1));
        break;
      case 2:
        meanArr[i] = (float) (walker8.movementHistoric[i] * (i+1));
        break;
      case 3:
        meanArr[i] = (float) (walker8.movementHistoric[i] * (i+1));
        break;
      case 4:
        meanArr[i] = (float) (walker8.movementHistoric[i] * (i+1));
        break;
      case 5:
        meanArr[i] = (float) (walker8.movementHistoric[i] * (i+1));
        break;
      case 6:
        meanArr[i] = (float) (walker8.movementHistoric[i] * (i+1));
        break;
      case 7:
        meanArr[i] = (float) (walker8.movementHistoric[i] * (i+1));
        break;
    }
  }
  label.setLabel("Mean: " + stats.mean(meanArr, walker8.movementHistoric));
  label2.setLabel("Mediana: " + stats.median(walker8.allMovements));
  label3.setLabel("Moda: " + stats.moda(walker8.movementHistoric));
  label4.setLabel("Varianza: " + stats.varianza(walker8.allMovements));
  label5.setLabel("Desv Estandar: " + stats.desviacionEstandar());
  label6.setLabel("Range: " + stats.range(walker8.allMovements));
  
  histograma.setData(data);
  histograma.setMaxValue(max(data)+40);
  
  histograma.draw(15, height-(270+15), 480, 270);
  if (stepsRealizados >= canDoXSteps)
  {
    // Se dio el numero de pasos aximo y no se ha ganado aun.
    gameOver();
  }
  else if (initStep.dist(actualStep) > circleDiameter/2)
  {
    // El walker logro salir del circulo
    walkerOutOfCircle();
  }  
  else
  {
    // Incrementara esta variable solo si ninguna de las condiciones anteriores es true
    stepsRealizados++;
  }
  
}



void walkerOutOfCircle()
{
  walker8.pause();
  println("El walker ha salido del circulo");
  textFont(gameOverText, 48);                  // STEP 3 Specify font to be used
  fill(0);                         // STEP 4 Specify font color 
  text("El walker ha salido del circulo", 100, 100);
  resetDefaultText();
}

void gameOver()
{
  walker8.pause();
  println("se ha perdido el juego");
  textFont(gameOverText, 48);                  // STEP 3 Specify font to be used
  fill(0);                         // STEP 4 Specify font color 
  text("Game Over ", 100, 100);
  resetDefaultText();
}

void resetDefaultText()
{
  PFont defau = createFont("Lucida Sans", 12);
  textFont(defau, 12);
}