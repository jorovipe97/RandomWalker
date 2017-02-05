class Statistics
{
  float mean;
  float median;
  String moda;
  float varianza;
  float desviacionEstandar;
  int range;
  
  Statistics()
  {
  }
  
  /*
    El segundo argumento almacena el array del histograma para obtener el numero de veces que se ha realizado el experimento
  */
  float mean(float[] values, int[] n)
  {
    int nTotal = 0;
    for (int j=0; j< n.length; j++)
    {
      nTotal += n[j];
    }
    
    float sum=0;
    for (int i=0; i< values.length; i++)
    {
      sum += values[i];
    }
    mean = sum/nTotal;
    println("Mean " + mean);
    return mean;
  }
  
  float median(IntList allMovs)
  {
    allMovs.sort();
    
    if (allMovs.size() < 2)
      return -1;
    
    // Test usando bitwise operators
    if ((allMovs.size() & 1) == 1)
    {
      // El numero es impar
      median = allMovs.get( ((allMovs.size()+1)/2)-1 );
    }
    else
    {
      // El numero es par  
      median = (1/2)*(allMovs.get( (allMovs.size()/2)-1 ) + allMovs.get( ((allMovs.size()/2) + 1)-1 ));
    }
    return median;
  }
  
  String moda(int[] histogramData)
  {
    IntList histo = new IntList();
    
    for (int i = 0; i < histogramData.length; i++)
    {
      histo.append(histogramData[i]);
    }
    
    int max = histo.max(); 
    int iMax = -1;
    
    for (int i = 0; i < histogramData.length; i++)
    {
      if (max == histogramData[i])
      {
        iMax =  i;
      }
    }
      
    switch(iMax)
    {
      case 0:
        moda = "Left&Up";
        break;
      case 1:
        moda = "Left&Down";
        break;
      case 2:
        moda = "Left";
        break;
      case 3:
        moda = "Up";
        break;
      case 4:
        moda = "Down";
        break;
      case 5:
        moda = "Right";
        break;
      case 6:
        moda = "Right&Down";
        break;
      case 7:
        moda = "Right&Up";
        break;  
    }
       
    return moda;
  }
  
  float varianza(IntList allMovs)
  {
    float sumCuadrados = 0;
    float _2MeanSum = 0;
    float sumMean = 0;
    
    for (int i = 0; i < allMovs.size(); i++)
    {
      sumCuadrados += Math.pow(allMovs.get(i), 2);
      _2MeanSum += allMovs.get(i);
    }
    _2MeanSum *= -2*mean;
    sumMean =  allMovs.size() * (float) Math.pow(mean, 2);
    
    varianza = (sumCuadrados + _2MeanSum + sumMean)/(allMovs.size()-1);
    
    return varianza;
  }
  
  float desviacionEstandar()
  {
    desviacionEstandar = (float) Math.sqrt(this.varianza);
    return desviacionEstandar;
  }
  
  int range(IntList allMovs)
  {
    if (allMovs.size() < 2)
      return -1;
    
    range = allMovs.max() - allMovs.min();
    return range;
  }
  
}