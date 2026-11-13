// Alyx Harmon - screen & button classes - 10/3
class Screen
{
  ArrayList<Button> widgets;
  color bgColor;
  
  Screen(color bgColor)
  {
    this.bgColor = bgColor;
    widgets = new ArrayList<Button>();
  }
  
  void addWidget(Button b)
  {
    widgets.add(b);
  }
  
  void draw()
  {
    background(bgColor);
    
    for (Button b : widgets)
      b.draw();
  }
  
  Button getButton(int mx, int my)
  {
    for (Button b: widgets)
    {
      if (b.isClicked(mx,my))
      return b;
    }
    return null;
  }
}
/////////////////////////////////////////////////////////////////////////////////////
class HomeScreen extends Screen // Alyx Harmon 16/3 15.30pm - added subclasses for each screen
{
  HomeScreen(color c)
  {
    super(c);
  }
  
  void draw()
  {
    background(bgColor);
    
    fill(red(bgColor)-40, green(bgColor)-40, blue(bgColor)-40);
    rect(0,0, width, 110);
    
    fill(0);
    textSize(40);
    text("Welcome To Flight Finder", 400, 150);
    textSize(20);
    text("Select a page to visit above", 400, 200);
    
    image(homescreenIcon, 150, 200);
    
    
    for (Button b : widgets)
      b.draw();
  }
}

class MapScreen extends Screen
{
  MapScreen(color c)
  {
    super(c);
  }
  
  void draw()
  {
    background(bgColor);
    
    fill(red(bgColor)-40, green(bgColor)-40, blue(bgColor)-40);
    rect(0,0, width, 110);
    
    fill(0);
    textSize(20);
    //text("Map of flight departures", 400, 565);
    
    fill(255);
    rect(25, 135, 750, 400);
    
    //// put map here ////
    
    for (Button b: widgets)
      b.draw();
  }
}

class FlightScreen extends Screen
{
  FlightScreen(color c)
  {
    super(c);
  }
  
  void draw()
  {
    background(bgColor);
    
    fill(red(bgColor)-40, green(bgColor)-40, blue(bgColor)-40);
    rect(0,0, width, 110);
    
    //airport filter display - Nora Holden 24/03/2026
    fill(0);
    textSize(20);
    text("Filter search by:", 400, 140);
    fill(255);
    //rect(50, 170, 700, 50);
    fill(typingAirport ? 240 : 255);
    rect(50, 170, 200,50); 
    fill(0);
    text("search by airport:", 30, 170, 200, 50);
    fill(0);
    textAlign(LEFT, TOP);
    text(enteredText, 210, 190, 200, 50);
    
    //// search bar drop box here ////
    
    for (Button b: widgets)
      b.draw();
  }
}

class DateFilterScreen extends Screen - 26/3
{
  DateFilterScreen(color c)
  {
    super(c);
  }
  
  void draw()
  {
    background(bgColor);
    
    fill(red(bgColor)-40, green(bgColor)-40, blue(bgColor)-40);
    
    rect(0,0, width, 110);
    
    fill(0);
    
    textSize(20);
    text("Choose Departure and Return date:", 400, 130);
    
    
    for (Button b: widgets)
      b.draw();
  }
}
  



////////////////////////////////////////////////////////
//Alyx - 10/3
class Button
{
  int x,y,w,h;
  String label;
  
  Button(int x, int y, int w, int h, String label)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
  }
  
  void draw()
  {
    noStroke();
    fill(255);
    rect(x,y,w,h);
    
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(20);
    

    
    text(label, x + w/2, y + h/2);
  }
  
  boolean isClicked(int mx, int my)
  {
    return mx > x
    && mx < x + w
    && my > y
    && my < y + h;
  }
}
