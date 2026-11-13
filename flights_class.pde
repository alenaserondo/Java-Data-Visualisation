
class Flights  
{
  String date;
  int dateInt;
  int dateSorted;
  String dateOnly;
  String airline;
  int schDepTime;
  int depTime;
  int status;
  color statusCol; 
  String message;
  String airlineName;
  int arrTime;
color airlineColor;
String origin;
String destination;
String flightNum;

 
  Flights(String airline, int status, String date, int depTime, int schDepTime, int arrTime, String origin, String destination, String flightNum) // new variables added  for display and filters 
  {
    this.status = status;
    this.date = date;
    this.depTime = depTime;
    this.schDepTime = schDepTime;
    this.airline = airline;
    this.arrTime = arrTime;
    this.origin = origin;
    this.destination = destination;
    this.flightNum = flightNum;
    
    //Fix date filter 
    dateOnly = date.split(" ")[0]; // remove extras
    try {
      String[] parts = split(dateOnly, '/'); 
      if(parts.length == 3) {
        // MM/DD/YYYY -> YYYYMMDD
        this.dateInt = int(parts[2] + parts[0] + parts[1]);
      }
    } catch (Exception e) {
      this.dateInt = 0; 
    }
  }
  
  // Checks if flight is in range of dates user gives 
  // Date in form YYYYMMDD
  boolean inRange(int start, int end) 
  {
    return (dateInt >= start && dateInt <= end);
  }
  
  // Updated booleans to be boolean functions
  boolean cancelled()
  {
  if (status == 1)
    {
      return true;
    } else
    {
      return false;
    }
  }

  // Fixed late logic for visualisations 
  boolean late()
  {
    return (depTime > schDepTime);
  }
  
 


String airlineName()
  {
     if( airline.equals("AA"))
    {
      
      return airlineName = "American Airlines";
    }
    else if( airline.equals("AS"))
    {
      return airlineName = "Alaska Airlines";
    }
    else if( airline.equals("WN"))
    {
      return airlineName = "Southwest Airlines";
    }
    else if( airline.equals("B6"))
    {
      return airlineName = "Jet Blue Airlines";
    }
    else if( airline.equals("HA"))
    {
      return airlineName = "Hawaiian Airlines";
    }
        else if( airline.equals("NK"))
    {
      return airlineName = "Spirit Airlines";
    }
    else if( airline.equals("G4"))
    {
      return airlineName = "Allegiant Air"; 
    }
    else if( airline.equals("F9"))
    {
      return airlineName = "Frontier Airlines";
    }
     else if( airline.equals("DL"))
    {
      return airlineName = "Delta Air Lines";
    }
     else if( airline.equals("UA"))
    {
      return airlineName = "United Airlines";
    }
    else
    {
      return airlineName = "";
    }
    
    
  }
  
color airlineColour()
{
  if (airline.equals("AA"))
  {
    return airlineColor = color(160, 60, 70);
  } 
  else if (airline.equals("AS"))
  {
    return airlineColor = color(60, 110, 120);
  } 
  else if (airline.equals("B6"))
  {
    return airlineColor = color(120, 170, 185);
  } 
  else if (airline.equals("HA"))
  {
    return airlineColor = color(130, 90, 150);
  } 
  else if (airline.equals("NK"))
  {
    return airlineColor = color(210, 210, 120);
  } 
  else if (airline.equals("G4"))    
  {
    return airlineColor = color(170, 173, 64);
  }
  else if( airline.equals("F9"))
    {
      return airlineColor = color(64, 128, 69);
    }
     else if( airline.equals("DL"))
    {
      return airlineColor = color(189, 72, 89);
    }
    else if( airline.equals("UA"))
    {
      return airlineColor = color(84, 160, 184);
    }
  else
  {
    return airlineColor = color(80, 120, 160);
  }
}

  
  // Draws flight visualizations 
  void drawFlightBox(int x,int y, int a , int b)
  {
    int hours = depTime / 100;
    int minutes = depTime % 100;
    
    int aHours = arrTime / 100;
    int aMins = arrTime % 100;
    int lengthH = abs(aHours  - hours); 
    int lengthM = abs(aMins - minutes);
    //int lHours = length / 100;
    //int lMinutes = length % 100;
    int z = 700;
    int w = 100;
    airlineColor = airlineColour();
    airlineName = airlineName();
    
      
    //updates to code to show locations 
    //stroke(0);
    fill(177, 178, 179);
    rect(x, y, z - 40, w);//10,10,10,10
    fill(statusCol);
    rect(x +( z -40), y, 30, w);
    fill(airlineColor);
    rect(x , y, 70, w);
    fill(0);
    text(airline , a - 5, b - 20);
    text(airlineName , a + 120, b - 40);
    text( date, a +120, b - 0);
    text( origin, a + 310, b - 40);
    text ( hours, a +300, b );
    text( ":", a+ 315, b );
    text(minutes, a + 330, b );
    text( destination, a + 410, b - 40);
    text ( aHours, a +400, b );
    text( ":", a+ 415, b );
    if ( aMins < 10)
    {
      text("0" + aMins, a + 430, b );
    }
    else{
    text(aMins, a + 430, b ); }
     if (cancelled())  // updated to show differnce if cancelled 
    {
      text ( "----", a + 560, b - 20);
    }
    else{
      if (lengthM > 9 )
      {
         text(lengthH, a + 540, b - 20);
      }
      else{
    text(lengthH, a + 550, b - 20); }
    text( ":", a+ 560, b - 20 );
    if(lengthM < 10) 
    {
      text("0" + lengthM, a + 575, b - 20);
    }
    else {
    text(lengthM, a + 575, b - 20);}
    
    }
    text("h", a + 590, b - 20);
    rect( a +345, b - 1, a -50, 2);

   // Fixed colour setting loops to work with functions 
   
   // Rotate text
    if (late())
    {
     statusCol = color(#FFA30D); // orange
      pushMatrix();              
      translate( x + ( z - 25), y + w/2);       
      rotate(-HALF_PI); 
      fill(0);
      text("DELAYED", 0,0);       
      popMatrix(); 
    }
    else if (cancelled())
    {
      statusCol = color(#DB6161); // red
      pushMatrix();              
      translate( x + ( z - 25), y + w/2);       
      rotate(-HALF_PI); 
      fill(0);
      text("CANCELLED", 0,0);       
      popMatrix();
    }
    else
    {
     statusCol = color(#73B497); // green
      pushMatrix();              
      translate( x + ( z - 25), y + w/2);       
      rotate(-HALF_PI); 
      fill(0);
      text("ON TIME", 0,0);
      popMatrix();
    }
  }
  
}
