// Las clases no necesitan tener necesariamente el nombre de la pestaña
// en una pestaña puedo poner las demas
class Walker8
{
  int x;
  int y;
  private boolean pause = false;
  
  // Almacena cuantas veces se movio en una direccion determinada
  // Donde cada componente esta en este orden
  /*
    
    [0] l&u: 1
    [1] l&d: 2
    [2] left: 3
    [3] up: 4
    [4] down: 5
    [5] right: 6
    [6] r&d: 7
    [7] r&u: 8
    
  */
  int[] movementHistoric;
  IntList allMovements;
  
  // Almacena la posicion inicial del walker
  private int initialx;
  private int initialy;
  
  // Posicion xy relativa al centro de la ventana
  Walker8 (int x, int y)
  {
    allMovements = new IntList();
    
    // Configuracion posicion de inicio
    this.x = (width/2) + x;
    this.y = (height/2) + y;
    
    this.initialx = this.x;
    this.initialy = this.y;
    
    
    // Inicializa todos los movimientos ne 0
    movementHistoric = new int[8];
    for (int i = 0; i < 8; i++)
    {
      movementHistoric[i] = 0;
    }
  }
  
  int getInitialX()
  {
    return this.initialx;
  }
  int getInitialY()
  {
    return this.initialy;
  }
  
  void saveMovementHistoric(int stepx, int stepy)
  {
    // Left
    if (stepx == -1 && stepy == 0)
    {
      movementHistoric[2] ++; // One step to left
      allMovements.append(3);
    }
    else if (stepx == -1 && stepy == -1) // L&U
    {
      movementHistoric[0] ++; // One step to left and up
      allMovements.append(1);
    }
    else if (stepx == -1 && stepy == 1) // L&D
    {
      movementHistoric[1] ++; // One step to left and down
      allMovements.append(2);
    }
    else if (stepx == 1 && stepy == 0) // Right
    {
      movementHistoric[5] ++; // One step to right
      allMovements.append(6);
    }
    else if (stepx == 1 && stepy == -1) // R&U
    {
      movementHistoric[7] ++; // One step to right and up
      allMovements.append(8);
    }
    else if (stepx == 1 && stepy == 1) // R&D
    {
      movementHistoric[6] ++; // One step to right and down
      allMovements.append(7);
    }
    else if (stepx == 0 && stepy == -1) // Up
    {
      movementHistoric[3] ++; // One step to up
      allMovements.append(4);
    }
    else if (stepx == 0 && stepy == 1) // Down
    {
      movementHistoric[4] ++; // One step to down
      allMovements.append(5);
    }
    
  }
  
  void step()
  {
    // Se multiplica por 8 para evitar que de pasos en el mismo lugar devido al strijeWeight(8)
    if (!pause)
    {
      /*
      Se resta -1 para asegurar que se pueda mover a la izq
      cuando de 2 -> 1
      cuando de 1 -> 0
      cuando de 0 -> -1
      */
      int stepx = int(random(3)) - 1;
      int stepy = int(random(3)) - 1;
    
    
    
    
      // Guarda en un array cuantos passos se han dado en una direccion
      saveMovementHistoric(stepx, stepy);
      
      x += stepx*2;
      y += stepy*2;
    }
  }  
    
  void display()
  {
    strokeWeight(10);
    stroke(135);
    point(x, y);
  }
  
  void draw()
  {
    step();
    display();
  }
  
  void gaussianStep()
  {
    /*
      Cuando hay un paso gaussiano los mas probable es que se mueva en una de las siguientes 4 direcciones
      up, down, left, right dejando a las diagonales como las menos probables
      esto se debe a que la media de la funcion randomGaussian() esta en '
      y lo mas probable es que en cada ciclo, el stepy o el stepx sea igual a 0
      y es mucho menos probable que ambos tengan valores distintos de 0 en un mismo ciclo
    */
    if (!pause)
    {
      int stepx = int(randomGaussian());
      int stepy = int(randomGaussian());
      
      
      // Se multiplica por 8 para evitar que de pasos en el mismo lugar devido al strijeWeight(8)
    
      // Guarda en un array cuantos passos se han dado en una direccion
      saveMovementHistoric(stepx, stepy);
      
      // Se multiplica por 8 para evitar que de pasos en el mismo lugar devido al strijeWeight(8)
      x += stepx*2;
      y += stepy*2;
    }
  }
  
  void drawGaussian()
  {
    gaussianStep();
    display();
  }
  
  void pause()
  {
    pause = true;
  }
  
}