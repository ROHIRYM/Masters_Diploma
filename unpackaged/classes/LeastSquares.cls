public class LeastSquares {

    public static Double calcLeastSquares(List<Double> sales) {
        Integer indexesSum = 0;
        for (Integer i = 0; i < sales.size(); i++) {
            indexesSum = indexesSum + i + 1;
        }
        Integer indexesSquaresSum = 0;
        for (Integer i = 0; i < sales.size(); i++) {
            indexesSquaresSum = indexesSquaresSum + (i+1)*(i+1);
        }
        Double salesSum = 0.0;
        for (Integer i = 0; i < sales.size(); i++) {
            salesSum = salesSum + sales.get(i);
        }
        Double salesIndexesSum = 0.0;
        for (Integer i = 0; i < sales.size(); i++) {
            salesIndexesSum = salesIndexesSum + sales.get(i)*(i+1);
        }
        Double alpha = (indexesSquaresSum*salesSum - indexesSum*salesIndexesSum)/(sales.size()*indexesSquaresSum - indexesSum*indexesSum);
        Double beta = (sales.size()*salesIndexesSum - indexesSum*salesSum)/(sales.size()*indexesSquaresSum - indexesSum*indexesSum);
        return alpha + (sales.size()+1)*beta;
    }

}