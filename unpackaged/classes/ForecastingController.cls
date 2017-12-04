public class ForecastingController {

    public String tpId {get;set;}
    public String forecastingMethod {get;set;}
    public Buy__c startBuy {get;set;}
    public Buy__c finishBuy {get;set;}
    public String forecastingPeriod {get;set;}
    
    public Boolean isMAVisible {get;set;}
    public Boolean isLSVisible {get;set;}
    public Boolean isESVisible {get;set;}
    
    public List<String> dates {get;set;}
    public List<Double> sales {get;set;}
    public List<Double> ma3Forecast {get;set;}
    public List<Double> ma5Forecast {get;set;}
    public List<Double> lsForecast {get;set;}
    public List<Double> es3Forecast {get;set;}
    public List<Double> es2Forecast {get;set;}
    
    public String datesJ {get;set;}
    public String salesJ {get;set;}
    public String ma3ForecastJ {get;set;}
    public String ma5ForecastJ {get;set;}
    public String lsForecastJ {get;set;}
    public String es3ForecastJ {get;set;}
    public String es2ForecastJ {get;set;}
    
    public List<DateValue> timeSeries {get;set;}
    
    public ForecastingController() {
        startBuy = new Buy__c();
        finishBuy = new Buy__c();
        isMAVisible = false;
        isLSVisible = false;
        isESVisible = false;
    }

    public List<SelectOption> getdynamiclist() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('all', 'All'));
        List<TradingPoint__c> tradingPoints = [SELECT Id, Name FROM TradingPoint__c];
        for (TradingPoint__c tp : tradingPoints) {
            options.add(new SelectOption(tp.Id, tp.Name));
        }
        return options;
    }
    
    public void forecast() {
        isMAVisible = forecastingMethod == 'ALL' || forecastingMethod == 'MA';
        isLSVisible = forecastingMethod == 'ALL' || forecastingMethod == 'LS';
        isESVisible = forecastingMethod == 'ALL' || forecastingMethod == 'ES';
        
        if (isMAVisible || isLSVisible || isESVisible) {
            List<Buy__c> buys;

            if (tpId == null) {
                return;
            } else if (tpId == 'all') {
                buys = [SELECT Sum__c, DateTime__c FROM Buy__c WHERE DateTime__c >= :startBuy.DateTime__c AND DateTime__c <= :finishBuy.DateTime__c ORDER BY DateTime__c ASC];
            } else {
                buys = [SELECT Sum__c, DateTime__c FROM Buy__c WHERE DateTime__c >= :startBuy.DateTime__c AND DateTime__c <= :finishBuy.DateTime__c AND TradingPoint__c = :tpId ORDER BY DateTime__c ASC];
            }
            
            if (buys.size() > 5) {
                if (forecastingPeriod == 'years') {
                    timeSeries = groupByYear(buys);
                } else if (forecastingPeriod == 'months') {
                    timeSeries = groupByMonth(buys);
                } else if (forecastingPeriod == 'days') {
                    timeSeries = groupByDay(buys);
                }
                
                if (timeSeries.size() > 3) {
                    
                    sales = new List<Double>();
                    dates = new List<String>();
                    for (DateValue dv : timeSeries) {
                        sales.add(dv.value);
                        dates.add(dv.tDate.format());
                    }
                    
                    ma3Forecast = isMAVisible ? ForecastingService.calcMovingAverage(sales, 3) : null;
                    ma5Forecast = isMAVisible ? ForecastingService.calcMovingAverage(sales, 5) : null;
                    lsForecast = isLSVisible ? ForecastingService.calcLeastSquares(sales) : null;
                    es3Forecast = isESVisible ? ForecastingService.calcExponentialMovingAverage(sales, (Double)0.3) : null;
                    es2Forecast = isESVisible ? ForecastingService.calcExponentialMovingAverage(sales, (Double)0.2) : null;

                    salesJ = JSON.serialize(sales);
                    datesJ = JSON.serialize(dates);
                    ma3ForecastJ = JSON.serialize(ma3Forecast );
                    ma5ForecastJ = JSON.serialize(ma5Forecast);
                    lsForecastJ = JSON.serialize(lsForecast);
                    es3ForecastJ = JSON.serialize(es3Forecast);                    
                    es2ForecastJ = JSON.serialize(es2Forecast);                    
                } else {
                    isMAVisible = false;
                    isLSVisible = false;
                    isESVisible = false;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.WARNING, 'Not enough information to make forecast!'));
                }
            } else {
                isMAVisible = false;
                isLSVisible = false;
                isESVisible = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.WARNING, 'Not enough information to make forecast!'));
            }
        }
    }
    
    private List<DateValue> groupByYear(List<Buy__c> buys) {
        List<DateValue> result = new List<DateValue>();
        Integer previousYear = buys.get(0).DateTime__c.year();
        DateValue dv = new DateValue((Double)0.0, Date.newInstance(previousYear, 12, 31));
        for (Buy__c b : buys) {
            if (b.DateTime__c.year() != previousYear) {
                result.add(dv);
                previousYear = b.DateTime__c.year();
                dv = new DateValue((Double)0.0, Date.newInstance(previousYear, 12, 31));
            }
            dv.value = dv.value + b.Sum__c;
        }
        result.add(dv);
        return result;
    }

    private List<DateValue> groupByMonth(List<Buy__c> buys) {
        List<DateValue> result = new List<DateValue>();
        Integer previousYear = buys.get(0).DateTime__c.year();
        Integer previousMonth = buys.get(0).DateTime__c.month();
        DateValue dv = new DateValue((Double)0.0, Date.newInstance(buys.get(0).DateTime__c.year(), previousMonth, 28));
        for (Buy__c b : buys) {
            if (b.DateTime__c.month() != previousMonth || b.DateTime__c.year() != previousYear) {
                result.add(dv);
                previousMonth = b.DateTime__c.month();
                previousYear = b.DateTime__c.year();
                dv = new DateValue((Double)0.0, Date.newInstance(b.DateTime__c.year(), previousMonth, 28));
            }
            dv.value = dv.value + b.Sum__c;
        }
        result.add(dv);
        return result;
    }

    private List<DateValue> groupByDay(List<Buy__c> buys) {
        List<DateValue> result = new List<DateValue>();
        Integer previousYear = buys.get(0).DateTime__c.year();
        Integer previousMonth = buys.get(0).DateTime__c.month();
        Integer previousDay = buys.get(0).DateTime__c.day();
        DateValue dv = new DateValue((Double)0.0, Date.newInstance(buys.get(0).DateTime__c.year(), buys.get(0).DateTime__c.month(), previousDay));
        for (Buy__c b : buys) {
            if (b.DateTime__c.day() != previousDay || b.DateTime__c.month() != previousMonth || b.DateTime__c.year() != previousYear) {
                result.add(dv);
                previousMonth = b.DateTime__c.month();
                previousYear = b.DateTime__c.year();
                previousDay = b.DateTime__c.day();
                dv = new DateValue((Double)0.0, Date.newInstance(b.DateTime__c.year(), b.DateTime__c.month(), previousDay));
            }
            dv.value = dv.value + b.Sum__c;
        }
        result.add(dv);
        return result;
    }
            
    public void cancel() {
        startBuy = new Buy__c();
        finishBuy = new Buy__c();
        isMAVisible = false;
        isLSVisible = false;
        isESVisible = false;
    }
    
    public class DateValue {
        public Double value {get;set;}
        public Date tDate {get;set;}
        
        public DateValue(Double v, Date d) {
            this.value = v;
            this.tDate = d;
        }
    }

}