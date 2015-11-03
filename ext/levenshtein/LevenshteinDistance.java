public class LevenshteinDistance {
  private static int minimum(int a, int b, int c) {
    return Math.min(Math.min(a, b), c);
  }

  public static int distance(String str1, String str2, long maximumDistance) {
    boolean brokeMax = false;
    int rowMinimum;
    int cost;
    String shortestString = (str1.length() > str2.length()) ? str1 : str2;
    String longestString = (str1.length() > str2.length()) ? str2 : str1;

    if (longestString.equals(shortestString)) { 
      return 0;
    } else if (longestString.length() - shortestString.length() > maximumDistance) {
      return shortestString.length();
    } else if (longestString.length() == 0 || shortestString.length() == 0) {
      return shortestString.length();
    }

    int[] workingGrid = new int[longestString.length()];
    int[] calculationGrid = new int[longestString.length()];
    int[] tempGrid;

    for (int i = 0; i < longestString.length(); i++) {
      calculationGrid[i] = i;
    }

    for (int i = 1; i < shortestString.length(); i++) {
      rowMinimum = workingGrid[0] = calculationGrid[0] + 1;

      for (int j = 1; j < longestString.length(); j++) {
        cost = (longestString.charAt(j-1) == shortestString.charAt(i-1)) ? 0 : 1;
        workingGrid[j] = minimum(calculationGrid[j]+1, workingGrid[j-1]+1, calculationGrid[j-1] + cost);
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

    return brokeMax ? shortestString.length() : calculationGrid[longestString.length()-1];
  }

  public static int distance(String str1, String str2) {
    return distance(str1, str2, 9999);
  }
}
