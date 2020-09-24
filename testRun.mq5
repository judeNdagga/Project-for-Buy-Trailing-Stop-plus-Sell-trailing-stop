
#include<Trade\Trade.mqh>
CTrade trade;
input double TakeProfitForBuy=400;
input double StopLossForBuy=200;
input double TakeProfitForBuyLimit=350;
input double StopLossForBuyLimit=250;
input double microlots=0.10;
input double TakeProfitForSell=400;
input double StopLossForSell=200;
input double TakeProfitForSellLimit=300;
input double StopLossForSellLimit=250;
input double BuyTrailingStopLoss=200;
input double SellTrailingStopLoss=200;
input double MoveStopLossforSellTrailingStopBy=10;
input double MoveStopLossforBuyTrailingStopBy=10;
input double NewBuyPosition=0;
input double NewSellPosition=0;


int OnInit()
  {
   return(INIT_SUCCEEDED);
  }
void OnDeinit(const int reason)
  {
   
  }
void OnTick()
  {  //buying 
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   double Balance=AccountInfoDouble(ACCOUNT_BALANCE);
   double Equity=AccountInfoDouble(ACCOUNT_EQUITY);
   
  MqlRates PriceInfo[];
      
  ArraySetAsSeries(PriceInfo,true); 
  
  int PriceData=CopyRates(_Symbol,_Period,0,3,PriceInfo);
  
  
  
  
  
 
 
 
 
 
  //INDICATOOOOOOOOOOORS!!!!!!!!!!!!!!!!!
  int Data=CopyRates(Symbol(),Period(),0,Bars(Symbol(),Period()),PriceInfo);
  //calculate number of candles
  int NumberOfCandles=Bars(Symbol(),Period());
  //convert Number of candles to string
  string NumberOfCandlesText=IntegerToString(NumberOfCandles);
  //calculate highest and lowest candle number
  int HighestCandleNumber=iHighest(NULL,0,MODE_HIGH,100,1);
  int LowestCandleNumber=iLowest(NULL,0,MODE_LOW,100,1);
  //calculate highest and lowest candle price
  double HighestPrice=PriceInfo[HighestCandleNumber].high;
  double LowestPrice=PriceInfo[LowestCandleNumber].low;
  
  if(PriceInfo[0].low<LowestPrice){
  ObjectCreate(_Symbol,NumberOfCandlesText,OBJ_ARROW_BUY,0,TimeCurrent(),(PriceInfo[0].low));
  }
if(PriceInfo[0].high>HighestPrice){
  ObjectCreate(_Symbol,NumberOfCandlesText,OBJ_ARROW_SELL,0,TimeCurrent(),(PriceInfo[0].high));
  } 
  Comment("NumberOfCandles:",NumberOfCandles,"\n",
  "Highestcandlenumber",HighestCandleNumber,"\n",
  "HighestPrice:",HighestPrice,"\n",
  "LowestCandlenumber:",LowestCandleNumber,"\n",
  "LowestPrice:",LowestPrice,"\n",
  "Balance:",Balance,"\n",
  "Equity:",Equity);
  
  
  
  
  
  
 
 
 
 
 //FOR BUYING 
  if(PriceInfo[1].close>PriceInfo[1].open) {
 
  if(PositionsTotal()==NewBuyPosition) 
  {
  //stoploss=10  takeprofit=30
  trade.Buy(microlots,NULL,Ask,Ask-StopLossForBuy* _Point, 0, NULL);
  //buyLimit
  //if((OrdersTotal()==0)&&(PositionsTotal()==0)){
  //trade.BuyLimit(microlots,(Ask-(StopLossForBuyLimit*_Point)),_Symbol,0,(Ask+(TakeProfitForBuyLimit*_Point)),ORDER_TIME_GTC,0,NULL);
  CheckBuyTrailingStop(Ask);
  }
  //trailing stop
  //CheckBuyTrailingStop(Ask);
  
  //change lot-size, takerofit, stoploss
  
 
  
  }
   
  //if(PositionsTotal()==NewBuyPosition){
  //CloseAllBuyPositions();
  //}
  
  
  
  
  
  
  
  
  //FOR SELLING
  if(PriceInfo[1].close<PriceInfo[1].open) {
 
  if(PositionsTotal()==NewSellPosition){
  trade.Sell(microlots,NULL,Bid,Bid+StopLossForSell* _Point,Bid-TakeProfitForSell* _Point,NULL);
  //if((OrdersTotal()==0)&&(PositionsTotal()==0)){
  //trade.SellLimit(0.10,(Bid+(StopLossForSellLimit*_Point)),_Symbol,0,(Bid+(TakeProfitForSellLimit*_Point)),ORDER_TIME_GTC,0,NULL);
  }
  //CheckSellTrailingStop(Bid);
 
  }
 
  
  }
  
  
  
  
  
  
  
  
  
  
  
  
  //METHODS!!!!!!!!
  
  
  
  
  //buy trailing stop
  void CheckBuyTrailingStop(double Ask){
  double BuyStopLoss=NormalizeDouble(Ask-BuyTrailingStopLoss*_Point,_Digits);
  
  //go through all positions
  for(int i=PositionsTotal()-1;i>=0;i--){
  string symbol=PositionGetSymbol(i);//get symbol of position
   
  if(_Symbol==symbol){
  //get ticket number
  ulong BuyPositionTicket=PositionGetInteger(POSITION_TICKET);
  //calculate current stop loss
  double CurrentBuyStopLoss=PositionGetDouble(POSITION_SL);
  
  //if current stop loss is more than 150
  if(CurrentBuyStopLoss<BuyStopLoss){//move stop loss
  trade.PositionModify(BuyPositionTicket,(CurrentBuyStopLoss+MoveStopLossforBuyTrailingStopBy*_Point),0);
  Comment("CurrentBuystopLoss:",CurrentBuyStopLoss);
  }//end if loop
  }//end if loop
  }//end if loop
  
  
  }
  
  //sell trailing stop
  
 // void CheckSellTrailingStop(double Ask){
  //double SellStopLoss=NormalizeDouble(Ask-SellTrailingStopLoss*_Point,_Digits);
  
  //go through all positions
  //for(int i2=PositionsTotal()-1;i2>=0;i2--){
  //string symbol2=PositionGetSymbol(i2);//get symbol of position
  
  //if(_Symbol==symbol2){
  //if(PositionGetInteger(POSITION_TYPE)==ORDER_TYPE_SELL){
  //ulong SellPositionTicket=PositionGetInteger(POSITION_TICKET);
  //calculate current stop loss
  //double CurrentSellStopLoss=PositionGetDouble(POSITION_SL);
  
  //if current stop loss is more than 150
  //if(CurrentSellStopLoss>SellStopLoss){//move stop loss
  //trade.PositionModify(SellPositionTicket,(CurrentSellStopLoss-MoveStopLossforSellTrailingStopBy*_Point),0);
  //}//end if loop
  //}//end if loop
  //}//end if loop
  //}//end for loop
  
  //}
 // void CloseAllBuyPositions(){
  //for(int close=PositionsTotal()-1;close>=0;close--){
  //int ticket=PositionGetTicket(close);
  //int PositionDirection=PositionGetInteger(POSITION_TYPE);
  //if(PositionDirection=POSITION_TYPE_BUY){
  //trade.PositionClose(ticket);
  //} 
  //} 
  //}
double OnTester()
  {
   double ret=0.0;
   return(ret);
  }



