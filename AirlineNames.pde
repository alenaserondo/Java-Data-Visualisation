class Airline {
  
  // Alena Serondo - Airline class 

    private String flightNum;
    private String carrierCode;
    
Airline(String flightNum, String carrierCode)
{
this.flightNum = flightNum; 
this.carrierCode = carrierCode; 
}

  public String getFlightNum(){
    return flightNum;
  }
  
  public String getCarrierCode(){
    return carrierCode;
  }
  
  public void setFlightNum(String flightNumber){
    flightNum = flightNumber;
  }
  
  public void setCarrierCode(String airlineCarrierCode){
    carrierCode = airlineCarrierCode;
  }


}
