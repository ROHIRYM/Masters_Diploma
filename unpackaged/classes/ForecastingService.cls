public class ForecastingService {

    public static List<Double> calcLeastSquares(List<Double> sales) {
        return new List<Double>{sales.get(0), LeastSquares.calcLeastSquares(sales)};
    }
    
    public static List<Double> calcMovingAverage(List<Double> sales, Integer period) {
        return MovingAverage.calcMovingAverage(sales, period);
    }
    
    public static List<Double> calcExponentialMovingAverage(List<Double> sales, Double alpha) {
        return ExponentialMovingAverage.calcExponentialMovingAverage(sales, alpha);
    }
}