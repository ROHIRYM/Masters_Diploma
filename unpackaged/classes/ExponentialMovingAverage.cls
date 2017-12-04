public class ExponentialMovingAverage {
    private Double alpha;
    private Double oldValue;
    public ExponentialMovingAverage(Double alpha) {
        this.alpha = alpha;
    }

    public Double average(Double value) {
        if (oldValue == null) {
            oldValue = value;
            return value;
        }
        Double newValue = oldValue + alpha * (value - oldValue);
        oldValue = newValue;
        return newValue;
    }

    public static List<Double> calcExponentialMovingAverage(List<Double> sales, Double alpha) {
        ExponentialMovingAverage exponentialMovingAverage = new ExponentialMovingAverage(alpha);
        List<Double> result = new List<Double>();
        for (Integer i = 0; i < sales.size(); i++) {
            result.add(exponentialMovingAverage.average(sales.get(i)));
        }
        return result;
    }

}