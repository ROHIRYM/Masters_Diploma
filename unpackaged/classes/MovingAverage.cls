public class MovingAverage {
    private final List<Double> window = new List<Double>();
    private final Integer period;
    private double sum;

    public MovingAverage(Integer period) {
        this.period = period;
        sum = 0;
    }

    public void newNum(double num) {
        sum += num;
        window.add(num);
        if (window.size() > period) {
            sum -= window.remove(0);
        }
    }

    public double getAvg() {
        if (window.isEmpty()) return 0.0; // technically the average is undefined
        return sum / window.size();
    }

    public static List<Double> calcMovingAverage(List<Double> sales, Integer period) {
        MovingAverage ma = new MovingAverage(period);
        List<Double> result = new List<Double>();
        for (Double x : sales) {
            ma.newNum(x);
            result.add(ma.getAvg());
        }
        for (Integer i = 1; i < period; i++) {
            result.remove(0);
        }
        Double sum = 0.0;
        for (Integer i = 1; i < result.size(); i++) {
            sum = sum + result.get(i) - result.get(i - 1);
        }
        sum = sum / (result.size() - 1);
        result.add(sales.get(sales.size() - 1) + sum);
        return result;
    }
}