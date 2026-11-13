// Airport Class written by Liam Mc 10/03/26 2:25pm
// Improvents made to defensive code by Liam Mc 12/03/26 8:30am
class Airport
{
  String code;
  String city;
  String state;
  int wac;
  
  Airport(String code, String city, String state, int wac)
  {
    setCode(code);
    setCity(city);
    setState(state);
    setWac(wac);
  }
  
  
  void setCode(String code)
  {
    if(code == null)
    {
      this.code = "UNK";
    }
    else if(code.length() == 3)
    {
      this.code = code;  
    }
    else
    {
      this.code = "UNK";
    }
    
  }
  void setCity(String city)
  {
    if(city == null)
    {
      this.city = "Unknown";
    }
    else
    {
      this.city = city;
    }
  }
  
  void setState(String state)
  {
    if(state == null) this.state = "Unkown";
    else if(state.length() == 2)
    {
      this.state = state;
    }
    else
    { 
      this.state = "Unknown";
    }
  }
  
  void setWac(int wac)
  {
    if(wac < 100 && wac > 0)
    {
      this.wac = wac;
    }
    else
    {
      this.wac = -1;
    }
  }
}
