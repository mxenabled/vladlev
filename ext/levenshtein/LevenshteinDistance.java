public class LevenshteinDistance {
  private static int minimum(int a, int b, int c) {
    return Math.min(Math.min(a, b), c);
  }

  public static int distance(String str1, String str2, long maximumDistance) {
    boolean brokeMax = false;
    int rowMinimum;
    int cost;
    String longestString = (str1.length() > str2.length()) ? str1 : str2;
    String shortestString = (str1.length() > str2.length()) ? str2 : str1;

    if (shortestString.equals(longestString)) { 
      return 0;
    } else if (longestString.length() - shortestString.length() > maximumDistance) {
      return longestString.length();
    } else if (shortestString.length() == 0 || longestString.length() == 0) {
      return longestString.length();
    }

    int[] workingGrid = new int[shortestString.length() + 1];
    int[] calculationGrid = new int[shortestString.length() + 1];
    int[] tempGrid;

    for (int i = 0; i <= shortestString.length(); i++) {
      calculationGrid[i] = i;
    }

    for (int i = 1; i <= longestString.length(); i++) {
      rowMinimum = workingGrid[0] = calculationGrid[0] + 1;

      for (int j = 1; j <= shortestString.length(); j++) {
        cost = (shortestString.charAt(j-1) == longestString.charAt(i-1)) ? 0 : 1;
        workingGrid[j] = minimum(calculationGrid[j]+1, workingGrid[j-1]+1, calculationGrid[j-1]+cost);
        rowMinimum = (workingGrid[j] < rowMinimum) ? workingGrid[j] : rowMinimum;
      }

      if (rowMinimum > maximumDistance) { 
        brokeMax = true;
        break;
      }

      tempGrid = workingGrid;
      workingGrid = calculationGrid;
      calculationGrid = tempGrid;
    }

    return brokeMax ? longestString.length() : calculationGrid[shortestString.length()];
  }

  public static int distance(String str1, String str2) {
    return distance(str1, str2, 9999);
  }

  public static double normalized_distance(String str1, String str2) {
   return normalized_distance(str1, str2, 9999); 
  }

  public static double normalized_distance(String str1, String str2, long maximumDistance) {
    int maxStringLength = (str1.length() > str2.length()) ? str1.length() : str2.length();
    if(maxStringLength == 0) {
      return 0;
    }
    return distance(str1, str2, maximumDistance) / (double)maxStringLength;
  }
}
