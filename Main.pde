import java.util.HashSet;
import controlP5.*;
import java.util.*;

// Wrote flight class - China Lynch 10/3/26 2:30pm
// Created 2 search bars for dates - China
ArrayList<Flights> filtered = new ArrayList<Flights>();
ArrayList<String> flightsDisplay = new ArrayList<String>();   // dropdown display
ArrayList<Flights> filteredFlights = new ArrayList<Flights>(); // Alyx Harmon - 25/4

String startDateText = "";
String endDateText = "";
String enteredText = "";
boolean typingStart = false;
boolean typingEnd = false;
boolean typingAirport = false;

// search bar pos
int sx = 60, sy = 180, sw = 200, sh = 30;
int ex = 300;
int ey = 180;

//airport filter search box pos - Nora Holden
int ax = 50;
int ay = 170;
int aw = 210;
int ah = 50;

ArrayList<Flights> listToShow;

String selectedFlightNum = ""; //Alena filter - 23.03.26
HashMap<String, ArrayList<Airline>> flightsByAirline = new HashMap<String, ArrayList<Airline>>();
DropdownList airlineDDL;// Alena filter - 23.03.26
DropdownList flightDDL;// Alena filter - 23.03.26
ArrayList<Flights> filteredAirline = new ArrayList<Flights>();
ArrayList<String> airlineCodes = new ArrayList<String>(); // Alena filter - 23.03.26

// creates dropdown list with no selected option - alyx - 25/4
ControlP5 cp5;
DropdownList statusDDL;

int selectedStatus = -1; 

//data reading - Nora Holden 10/03/2026 2:25pm
ArrayList<Flights> flights = new ArrayList<Flights>(); //creates an empty arraylist
ArrayList<Flights> airportFilter = new ArrayList<Flights>(); // 25/03/2026 17:25 Nora Holden
ArrayList<Airport> airport = new ArrayList<Airport>();
ArrayList<Airline> airline = new ArrayList<Airline>();
Table data;
//Screens - Alyx Harmon - 10/3
ArrayList<Screen> screens;
Screen currentScreen;
//date
PImage homescreenIcon;


//Alena - Scroll Logic 18.03.26
HScrollbar hs;
int visibleFlights = 3;
boolean firstMousePress = false;



//Heatmap - Liam McManus 18/03/2025 9:40pm
HashMap<String, Integer> stateCount = new HashMap<String, Integer>();
HashMap<String, PVector> statePositions = new HashMap<String, PVector>();
HashSet<String> seenAirports = new HashSet<String>(); //hashSet like an array but doesn't allow duplicate values
PImage usaMap;
//heatmap interactive features added - Liam 25.03.2026 9pm
String hoveredState = "";
String selectedState = "";
int minAirports = 0;


void setup()
{
  size(800, 600);

  //drop down menu for status - Alyx Harmon 25/03/2026
  cp5 = new ControlP5(this);
  statusDDL = cp5.addDropdownList("Status Filter")
    .setPosition(310, 170)
    .setSize(200, 250)
    .setItemHeight(20)
    .setBarHeight(50)
    .setColorBackground(color(255))
    .setColorActive(color(255))
    .setColorLabel(color(0))
    .setColorValue(color(0))

    .setColorForeground(color(200, 140, 160));


  statusDDL.addItem("On Time", 0);
  statusDDL.addItem("Cancelled", 1);
  statusDDL.addItem("Delayed", 2);
  statusDDL.addItem("All", 3);
  statusDDL.close();

  homescreenIcon = loadImage("plane.png");// date

  hs = new HScrollbar(width - 30, 170, 16, 400, 10);

  //data reading - Nora Holden 10/03/2026 2:25pm
  // new variables added  for display and filters - Nora Holden 25/03/2026
  data = loadTable("flights2k.csv", "header");

  for (TableRow row : data.rows())
  {
    String origin = row.getString("ORIGIN"); //uses csv header names to find the specific data
    int depTime = row.getInt("DEP_TIME");
    String date = row.getString("FL_DATE");
    date = date.split(" ")[0]; // Fixed input so the 00:00 was cut out - Alyx Harmon 01/04/2026
    String airline= row.getString("MKT_CARRIER");
    int schDepTime = row.getInt("CRS_DEP_TIME");
    int arrTime = row.getInt("ARR_TIME");
    int status = row.getInt("CANCELLED");
    String destination = row.getString("DEST");
     String flightNum = row.getString("MKT_CARRIER_FL_NUM");


    Flights flight = new Flights(airline, status, date, depTime, schDepTime, arrTime, origin, destination,flightNum); // creates an object of each flight using the data
    flights.add(flight); //adds the object to the arraylist
  }

  for (TableRow row : data.rows())
  {
    String code = row.getString("ORIGIN"); //uses csv header names to find the specific data
    String city = row.getString("ORIGIN_CITY_NAME");
    String state= row.getString("ORIGIN_STATE_ABR");
    int wac = row.getInt("ORIGIN_WAC");

    //loop modified so each airport is only counted once - Liam Mc 18/03/25 21:40pm
    if (!seenAirports.contains(code))
    {
      Airport airports = new Airport(code, city, state, wac ); // creates an object of each airport using the data from the row
      airport.add(airports); //adds the object to the arraylist
      seenAirports.add(code);
    }
  }

  // count number of airports per state loop - Liam 18/03/25 10pm
  for (Airport a : airport)
  {
    String state = a.state;

    if (!stateCount.containsKey(state)) //if state not in state hashmap
    {
      stateCount.put(state, 1);        //add state to hashmap with airport count = 1
    } else
    {
      stateCount.put(state, stateCount.get(state) + 1); // else increase airport count by one for that state
    }
  }

  setStatePostions();

  usaMap = loadImage("usaMap3.png");

  //more reading added 9:34am - Nora Holden
  for (TableRow row : data.rows())
  {
    String flightNum = row.getString("MKT_CARRIER"); //uses csv header names to find the specific data
    String carrierCode = row.getString("MKT_CARRIER_FL_NUM");



    Airline airlines = new Airline(flightNum, carrierCode); // creates an object of each airport using the data from the row
    airline.add(airlines); //adds the object to the arraylist
  }

  //Screens - Alyx Harmon - 10/3
  // updated 16/03/2026
  // updated & new screen added 26/3
  screens = new ArrayList<Screen>();

  // homescreen (0)

  Screen homescreen = new HomeScreen(color(220, 200, 255));
  homescreen.addWidget(new Button(50, 30, 200, 50, "Go to Map"));
  homescreen.addWidget(new Button(300, 30, 200, 50, "Find Flights"));
  homescreen.addWidget(new Button(550, 30, 200, 50, "Filter By Date"));

  // map screen (1)

  Screen mapScreen = new MapScreen(color(195, 240, 180));
  mapScreen.addWidget(new Button(50, 30, 200, 50, "Back to Home"));
  mapScreen.addWidget(new Button(300, 30, 200, 50, "Find Flights"));
  mapScreen.addWidget(new Button(550, 30, 200, 50, "Filter By Date"));

  // find flights screen (2)

  Screen flightsScreen = new FlightScreen(color(240, 180, 200));
  flightsScreen.addWidget(new Button(50, 30, 200, 50, "Back to Home"));
  flightsScreen.addWidget(new Button(300, 30, 200, 50, "Go to Map"));
  flightsScreen.addWidget(new Button(550, 30, 200, 50, "Filter By Date"));

  // filter by date screen (3)
  // added new screen 26/03/2026 - Alyx Harmon

  Screen dateFilterScreen = new DateFilterScreen(color(180, 225, 255));
  dateFilterScreen.addWidget(new Button(50, 30, 200, 50, "Back to Home"));
  dateFilterScreen.addWidget(new Button(300, 30, 200, 50, "Go to Map"));
  dateFilterScreen.addWidget(new Button(550, 30, 200, 50, "Find Flights"));

  screens.add(homescreen);
  screens.add(mapScreen);
  screens.add(flightsScreen);
  screens.add(dateFilterScreen);

  currentScreen = homescreen;



  //demonstration of data that has been read in (to consol) - Nora Holden 10/03/2026 2:25pm

  for (Flights flight : flights) //loops through the objects
  {
    // prints data to the console
    println("flight data : " + flight.airline + " + "  + flight.depTime + " + " + flight.date  + " + " + flight.schDepTime + " + " + flight.status);
  }


  for (Airport airports : airport)
  {
    println("airport data : " + airports.code + " + " + airports.city  + " + " + airports.state + " + " + airports.wac);
  }

  for (Airline airlines : airline)
  {
    println("airline data data : " + airlines.flightNum + " + " + airlines.carrierCode);
  }

  //Alena 26.03.26

  cp5 = new ControlP5(this);

  for (int i = 0; i < data.getRowCount(); i++) { //alena now
    String flightNum = data.getString(i, "MKT_CARRIER_FL_NUM");
    String carrier = data.getString(i, "MKT_CARRIER");

    Airline a = new Airline(flightNum, carrier);
    a.setFlightNum(flightNum);
    a.setCarrierCode(carrier);

    if (!flightsByAirline.containsKey(carrier)) { // if airline not seen before
      flightsByAirline.put(carrier, new ArrayList<Airline>());  // add flight to that airline's list
      airlineCodes.add(carrier);
    }

    flightsByAirline.get(carrier).add(a);
  }

  airlineDDL = cp5.addDropdownList("Airlines") //Alena 26.03.26
    .setPosition(550, 150)
    .setSize(200, 400);


  flightDDL = cp5.addDropdownList("Flights") // Alena 26.03.26
    .setPosition(550, 200)
    .setSize(200, 200);


  customizeAirlineDDL();

  customizeFlightDDL();


  airlineDDL.close();
  flightDDL.close();

  airlineDDL.hide();
  flightDDL.hide();
  
}




///////////////////////////////////////////////////////////////DRAW/////////////////////////////////////////////////////

void draw()
{

  background(255);

  statusDDL.hide();

  //Screens - Alyx Harmon - 10/3

  currentScreen.draw();
  if (currentScreen == screens.get(0))
{
airlineDDL.hide();
  flightDDL.hide();
}
  if (currentScreen == screens.get(1))
  {
    drawHeatMap();
    airlineDDL.hide();
  flightDDL.hide();
  }

  if (currentScreen == screens.get(3))
  {
    drawFilterScreen();
    airlineDDL.hide();
    flightDDL.hide();
  }


  if (currentScreen == screens.get(2))
  {
    // status filter - alyx harmon 25/3 8.50pm
    statusDDL.show();
    airlineDDL.show();
    flightDDL.show();

    filteredFlights.clear();  //makes sure flight list is empty


    for (Flights f : flights)  //show all avaliable flights(no filter selected yet)
    {
      boolean matches = true;

      if (selectedStatus == 0) //if they filter by 'on time'
      {
        if (f.depTime != f.schDepTime || f.status == 1) 
        {
          matches = false; // dont show delayed or cancelled
        }
      } else if (selectedStatus == 1) // if filter by 'cancelled'
      {
        if (f.status != 1) // only show cancelled
        {
          matches = false;
        }
      } else if (selectedStatus == 2)  // if filter by delayed
      {
        if (f.depTime <= f.schDepTime || f.status == 1)
        {
          matches = false; // dont show early, on time, or cancelled
        }
      }

      if (matches)
      {
        filteredFlights.add(f); // if flight still matches, show to user
      }
    }
  }


  // ensuring they display on the correct screen when the user selects a screen  17/03/2026 - Nora Holden
  if (currentScreen == screens.get(2) || currentScreen == screens.get(3)  )
  {
    hs.update();
    hs.display();
    fill(255);

    // implementing all filters to work together (simultaneously) - Nora Holden 30/03/2026 14:53pm
    ArrayList<Flights> tempList = new ArrayList<Flights>(flights); //new list to combine all aplicable filters

    listToShow = flights; // logic to update flights when a filter is selected - Nora Holden 25/03/2026

    if (selectedStatus != -1)
    {
      tempList.retainAll(filteredFlights); // all flights from temp list that are also in filteredFlights list stay in the temp list
    }

    if (enteredText.length() > 0)
    {
      tempList.retainAll(airportFilter);
    }
    
    if(filteredAirline.size() > 0)
    {
      tempList.retainAll(filteredAirline);
    }
    
    // date filter - china 
    if (endDateText.length() == 8) {
      tempList.retainAll(filtered);
    }
    

    listToShow = tempList;



    //Alena - Scroll Logic 18.03.26
    float scrollPercent = hs.getPercent();
    int maxStart = listToShow.size() - visibleFlights;

    if (maxStart < 0)
    {
      maxStart = 0;
    }


    int startIndex = int(scrollPercent * maxStart);

    // draws flights - Nora Holden 16/03/2026
    int y = 240;
    int x = 50;
    int a = 90;
    int b = 310;
    for (int i = 0; i < visibleFlights; i++)
    {
      int index = startIndex + i;

      if (index < listToShow.size())
      {
        Flights flight = listToShow.get(index);
        flight.drawFlightBox(x, y, a, b);

        y += 120;
        b += 120;
      }
    }
  } else
  {
    statusDDL.hide();
  }

  if (firstMousePress)
  {
    firstMousePress = false;
  }
}




/////////////////////////////////////////////////////////////////////MOUSE AND KEY////////////////////////////////////////////////////////
//Screens - Alyx Harmon - 10/3
void mousePressed()
{
  //alena
  firstMousePress = true;

  Button b = currentScreen.getButton(mouseX, mouseY);

  if (b != null)
  {
    if (b.label.equals("Go to Map"))
      currentScreen = screens.get(1);
    else if (b.label.equals("Find Flights")) 
      currentScreen = screens.get(2);
    else if (b.label.equals("Back to Home"))
      currentScreen = screens.get(0);
    else if (b.label.equals("Filter By Date"))
      currentScreen = screens.get(3);
  }


  //slider for heat map - Liam McManus
  if (currentScreen == screens.get(1))
  {
    updateSlider();
    for (String state : statePositions.keySet())
    {
      PVector pos = statePositions.get(state);
      int squareLength = 35;
      if (mouseX > pos.x && mouseX < pos.x + squareLength &&
        mouseY > pos.y && mouseY < pos.y + squareLength)
      {
        if (selectedState.equals(state))
        {
          selectedState = "";
        } else
        {
          selectedState = state;
        }
      }
    }
  }

  // searching flight dates - China Lynch
  if (currentScreen == screens.get(3)) {

    // start search box typing when mouse clicked 
    if (mouseX > sx && mouseX < sx + sw && mouseY > sy && mouseY < sy + sh) {
      typingStart = true;
      typingEnd = false;
      typingAirport = false;
      return;
    }

    // start second search box typing 
    if (mouseX > ex && mouseX < ex + sw && mouseY > ey && mouseY < ey + sh) {
      typingEnd = true;
      typingStart = false;
      typingAirport = false;
      return;
    }
  }

  //boolean added for airport - Nora Holden 26/03/2026 9:46am
  if (currentScreen == screens.get(2)) {
    if (mouseX > ax && mouseX < ax + aw && mouseY > ay && mouseY < ay + ah) {
      typingStart = false;
      typingEnd = false;
      typingAirport = true;
      return;
    }
  }

  
}

void mouseDragged()
{
  updateSlider();
}

//takes in written input - Nora Holden and China Lynch ( two methods merged )
void keyPressed() {

  // when backspace pressed we delete - China Lynch
  if (key == BACKSPACE) {
    if (typingStart && startDateText.length() > 0)
      startDateText = startDateText.substring(0, startDateText.length() - 1);

    if (typingEnd && endDateText.length() > 0)
      endDateText = endDateText.substring(0, endDateText.length() - 1);

    if (typingAirport && enteredText.length() > 0)
      enteredText = enteredText.substring(0, enteredText.length() - 1);
    return;
  }

  // Only ints allowed and booleans - China Lynch (dates filter)
  if (key >= '0' && key <= '9') {

    if (typingStart && startDateText.length() < 8)
      startDateText += key;

    if (typingEnd && endDateText.length() < 8)
      endDateText += key;
  } else // Airport filter on second screen text input - Nora Holden 24/03/2026
  {
    if (typingAirport)
    {
      if (currentScreen == screens.get(2) )
      {
        if (keyCode == BACKSPACE) {
          if (enteredText.length() > 0) {
            enteredText = enteredText.substring(0, enteredText.length()-1);
          }
        } else if (keyCode == DELETE) {
          enteredText = "";
        } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT && keyCode != ENTER) {
          enteredText = enteredText + key;
        }
      }
    }
  }

  // When both dates are 8 digits → start filter - China Lynch
  if (currentScreen == screens.get(3)) {
    if (startDateText.length() == 8 && endDateText.length() == 8) {
      filterFlights();
    }
  }

  //Nora Holden
  if (currentScreen == screens.get(2)) {
    airportFilter();
  }
}

////////////////////////////////////////////////////////////////////////////////FILTERS//////////////////////////////////////////////////////////////
//China Lynch
void drawSearchBars() {
  // Start search
  fill(typingStart ? 220 : 240);
  
  rect(sx, sy, sw, sh);
  fill(0);
  text("Start Date (YYYYMMDD): ", sx + 100, sy - 20);
  text(startDateText, sx + 100, sy + 15);

  // End search
  fill(typingEnd ? 220 : 240);
  
  rect(ex, ey, sw, sh);
  fill(0);
  text("End Date (YYYYMMDD):   ", ex + 100, ey - 20);
  text(endDateText, ex + 100, sy + 15);
  noStroke();
}

// implement flight dates filter - China Lynch
void drawFilterScreen() {

  // search bars
  drawSearchBars();
  filterFlights();
}


// Create date range filtering methods - China Lynch 24/03/26 3:30pm
// Adds flights to new ArrayList if in date range
ArrayList<Flights> listOfDateMatch(int startDate, int endDate)
{
  ArrayList<Flights> dateMatch = new ArrayList<Flights>();
  for (Flights f : flights)   // Flights == type, flights == arrayList of flights
  {
    if (f.inRange(startDate, endDate))
    {
      dateMatch.add(f);
    }
  }
  return dateMatch;
}

//China Lynch
void filterFlights() {

  flightsDisplay.clear();
  filtered.clear();

  int start = int(startDateText);
  int end = int(endDateText);

  filtered = listOfDateMatch(start, end);

  for (Flights f : filtered) {
    String label = f.airlineName() + "Departure: " + f.depTime + " " + f.date;
    flightsDisplay.add(label);
  }
  
}


// filters flights to be printed based on inputted text - Nora Holden 25/03/2026
void airportFilter()
{
  airportFilter.clear(); // resets the arraylist

  for (Flights flight : flights)
  {
    if (flight.origin.equalsIgnoreCase(enteredText))
    {
      airportFilter.add(flight);
    }
  }
}

//Alena 26.03.26

void customizeAirlineDDL() { 
  airlineDDL.setColorForeground(color(0)); // border? 
 airlineDDL.setColorBackground(color(255));   // main bar 183, 144, 212
  airlineDDL.setBackgroundColor(color(220, 200, 240));   // dropdown list (lighter)
  airlineDDL.setColorForeground(color(160, 120, 200));   // hover
  airlineDDL.setColorActive(color(0));       // clicked
  airlineDDL.setColorLabel(color(0));                    // text
  airlineDDL.setColorValue(color(0));

  airlineDDL.setItemHeight(30);
  airlineDDL.setBarHeight(30);  

  for (int i = 0; i < airlineCodes.size(); i++) {
    airlineDDL.addItem(airlineCodes.get(i), i);
  }
}

void customizeFlightDDL() { 
  flightDDL.setColorForeground(color(0)); // border?
  flightDDL.setColorBackground(color(255));   // same base   183, 144, 212
  flightDDL.setBackgroundColor(color(220, 200, 240));   // lighter list
  flightDDL.setColorForeground(color(160, 120, 200));   // hover
  flightDDL.setColorActive(color(140, 100, 190));       // clicked
  flightDDL.setColorLabel(color(0));
  flightDDL.setColorValue(color(0));
  flightDDL.setItemHeight(30);
  flightDDL.setBarHeight(30);
}

void controlEvent(ControlEvent theEvent) { 
  
  //Alyx Harmon
   if (theEvent.isFrom(statusDDL))
  {
    selectedStatus = int(theEvent.getValue());
  }
// if the user clicks a status, find the value they clicked & start filtering
  
  //Alena 
if (theEvent.getController().getName().equals("Airlines")) {
  int index = int(theEvent.getValue());
  String selectedCarrier = airlineCodes.get(index);


  // populate flight dropdown
  ArrayList<Airline> flightsList = flightsByAirline.get(selectedCarrier);
  flightDDL.clear();
  for (int i = 0; i < flightsList.size(); i++) {
    flightDDL.addItem(flightsList.get(i).getFlightNum(), i);
  }

  // filter by airline only for now
  filteredAirline.clear();
  for (Flights f : flights) {
    if (f.airline.equalsIgnoreCase(selectedCarrier)) {
      filteredAirline.add(f);
    }
  }
}

if (theEvent.getController().getName().equals("Flights")) {
  int flightIndex = int(theEvent.getValue());

  // get selected airline
  int airlineIndex = int(airlineDDL.getValue());
  String selectedCarrier = airlineCodes.get(airlineIndex);

  ArrayList<Airline> flightsList = flightsByAirline.get(selectedCarrier);
  String selectedFlightNum = flightsList.get(flightIndex).getFlightNum();

  // filter by BOTH airline and flight number
  filterByAirlineAndFlight(selectedCarrier, selectedFlightNum);
}
}

void filterByAirlineAndFlight(String airlineCode, String flightNum) {
  filteredAirline.clear(); // reset filtered list

  for (Flights f : flights) {
    if (f.airline.equalsIgnoreCase(airlineCode) && f.flightNum.equals(flightNum)) {
      filteredAirline.add(f);
    }
  }
}



//////////////////////////////////////////////////////////////////////////////////MAP//////////////////////////////////////

void setStatePostions()
{
  // State positions - Liam 18/03/25 10pm
  //Updated new co-ordinates to fit map better - Liam 01/04/2026
  // WEST
  statePositions.put("WA", new PVector(145, 160));
  statePositions.put("OR", new PVector(130, 210));
  statePositions.put("CA", new PVector(100, 300));
  statePositions.put("NV", new PVector(150, 270));
  statePositions.put("ID", new PVector(190, 220));
  statePositions.put("UT", new PVector(205, 290));
  statePositions.put("AZ", new PVector(200, 360));
  statePositions.put("MT", new PVector(250, 190));
  statePositions.put("WY", new PVector(250, 240));
  statePositions.put("CO", new PVector(270, 300));
  statePositions.put("NM", new PVector(260, 370));

  // MIDWEST
  statePositions.put("ND", new PVector(330, 190));
  statePositions.put("SD", new PVector(330, 230));
  statePositions.put("NE", new PVector(340, 275));
  statePositions.put("KS", new PVector(340, 315));
  statePositions.put("OK", new PVector(360, 360));
  statePositions.put("TX", new PVector(340, 420));
  
  statePositions.put("MN", new PVector(390, 200));
  statePositions.put("IA", new PVector(400, 265));
  statePositions.put("MO", new PVector(415, 320));
  statePositions.put("AR", new PVector(420, 370));
  statePositions.put("LA", new PVector(420, 425));
  
  statePositions.put("WI", new PVector(440, 220));
  statePositions.put("IL", new PVector(450, 285));
  statePositions.put("MS", new PVector(455, 395));
  
  statePositions.put("MI", new PVector(500, 220));
  statePositions.put("IN", new PVector(490, 280));
  statePositions.put("KY", new PVector(500, 320));
  statePositions.put("TN", new PVector(480, 340));
  statePositions.put("AL", new PVector(500, 400));
  
  // EAST COAST
  statePositions.put("OH", new PVector(520, 280));
  statePositions.put("WV", new PVector(560, 300));
  statePositions.put("VA", new PVector(600, 300));
  statePositions.put("NC", new PVector(580, 340));
  statePositions.put("SC", new PVector(580, 380));
  statePositions.put("GA", new PVector(540, 390));
  statePositions.put("FL", new PVector(540, 460));
  
  statePositions.put("PA", new PVector(570, 260));
  statePositions.put("NY", new PVector(590, 220));
  statePositions.put("VT", new PVector(600, 180));
  statePositions.put("NH", new PVector(700, 160));
  statePositions.put("ME", new PVector(640, 160));
  
  statePositions.put("MA", new PVector(700, 200));
  statePositions.put("CT", new PVector(700, 280));
  statePositions.put("RI", new PVector(700, 240));
  statePositions.put("NJ", new PVector(700, 320));
  statePositions.put("DE", new PVector(700, 360));
  statePositions.put("MD", new PVector(700, 400));
  
  // NON-CONTINENTAL
  statePositions.put("AK", new PVector(100, 500));
  statePositions.put("HI", new PVector(200, 500));
}


// draw heatmap function - Liam 18/03/26 10pm
// heatmap appearence updated and now also includes states with zero airports - Liam 19/03/2026 1:45pm
// interactive features added to heatmap (hover over state for more info) - Liam 25/03/2026 9pm
void drawHeatMap()
{

  image(usaMap, 0, 140, width -100, height -200);

  int squareLength = 35;
  int maxValue = 0;
  int minIntensity = 100;
  for (int value : stateCount.values())
  {
    if (value> maxValue) maxValue = value;
  }

  for (String state : statePositions.keySet())
  {
    int count = 0;
    if (stateCount.containsKey(state))
    {
      count = stateCount.get(state);
    }
    if (count < minAirports)
    {
      continue;
    }
    PVector pos = statePositions.get(state);



    float intensity = map(count, 0, maxValue, minIntensity, 255);
    fill(intensity, 0, 255);
    rect(pos.x, pos.y, squareLength, squareLength);

    fill(0);
    textAlign(CENTER, CENTER);
    textSize(12);
    text(state, pos.x + squareLength/2, pos.y + squareLength/2);

    if (mouseX > pos.x && mouseX < pos.x + squareLength
      && mouseY > pos.y && mouseY < pos.y + squareLength)
    {
      hoveredState = state;
    }
  }

  if (hoveredState != "")
  {
    int count = 0;
    if (stateCount.containsKey(hoveredState))
    {
      count = stateCount.get(hoveredState);
    }

    fill(255);
    stroke(150);
    rect(mouseX, mouseY-25, 140, 25);

    fill(0);
    textAlign(LEFT, CENTER);
    textSize(16);
    text(hoveredState + ": " + count + " airports", mouseX + 5, mouseY - 12);
    hoveredState = "";
  }

  if (selectedState != "")
  {
    stroke (0);


    for (TableRow row : data.rows())
    {
      String originState = row.getString("ORIGIN_STATE_ABR");
      String destState = row.getString("DEST_STATE_ABR");

      if (originState.equals(selectedState))
      {
        if (statePositions.containsKey(destState))
        {
          PVector start = statePositions.get(originState);
          PVector end = statePositions.get(destState);

          noFill();
          bezier(start.x + squareLength /2, start.y + squareLength / 2,
            start.x, start.y - 50,
            end.x, end.y-50,
            end.x + squareLength / 2, end.y );
        }
      }
    }
  }
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(26);

  text("Airports per State Heatmap", 410, 120);

  // gradient legend added - Liam 19/03/25 8:20 am
  //draw map legend
  int legendX = 300;
  int legendY = 540;
  int legendWidth = 300;
  int legendHeight = 20;

  // draw gradient bar
  for (int i = 0; i < legendWidth; i++)
  {
    float value = map(i, 0, legendWidth, 0, maxValue);
    float intensity = map(value, 0, maxValue, minIntensity, 255);

    stroke(intensity, 0, 255);
    line(legendX + i, legendY, legendX + i, legendY + legendHeight);
  }

  noStroke();


  //border around legend
  noFill();
  stroke(0);
  rect(legendX, legendY, legendWidth, legendHeight);
  noStroke();

  // labels
  fill(0);
  textAlign(CENTER);
  textSize(12);

  text("0", legendX, legendY + legendHeight + 15);
  text(maxValue, legendX + legendWidth, legendY + legendHeight + 15);

  // slider added - Liam 26/03/2026 11pm
  float handleX = map(minAirports, 0, maxValue, legendX, legendX + legendWidth);
  float handleY = legendY;

  fill(255, 0, 0);
  //stroke(0);
  rect(handleX, handleY, 10, legendHeight);

  fill(0);
  textAlign(CENTER);
  textSize(14);
  text("Min Airports: " + minAirports, legendX + legendWidth/2, legendY - 25);


  text("Number of Airports", legendX + legendWidth/2, legendY - 10);
}

void updateSlider()
{
  int legendX = 300;
  int legendY = 540;
  int legendWidth = 300;

  if (mouseX> legendX && mouseX < legendX + legendWidth &&
    mouseY > legendY && mouseY < legendY + 20)
  {
    float percent = map(mouseX, legendX, legendX + legendWidth, 0, 1.01);

    int maxValue = 0;
    for (int value : stateCount.values())
    {
      if (value>maxValue) maxValue = value;
    }

    minAirports = int(percent * maxValue);
  }
}


