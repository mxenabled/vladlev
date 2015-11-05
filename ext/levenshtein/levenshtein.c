#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#ifndef TRUE
#define TRUE 1  
#define FALSE 0
#endif

#define ALLOC malloc
#define FREE free

/* Used to swap calc and work grids while looping */
#define LV_SWAP(t, a, b) { t = a; a = b; b = t;}
#define LV_MIN(a, b, c) ((a <= b) ? ((a <= c) ? a : c) : ((b <= c) ? b : c));

/* using a structure that will be filled on init with the variables that will makeup the distance constraints */
typedef struct{
  char* a; 
  char* b; 
  int a_length;
  int b_length;
  int maximum_allowable_distance;
} LevenConstraints;

int levenshtein_intern(LevenConstraints* leven)
{
  /* Check the minimum distance to keep from calculating anything when it isn't really needed
   * Efficient use of the levenshtein call includes a maximum_allowable_distance (or distance threshold) */
  if ((leven->b_length - leven->a_length) > leven->maximum_allowable_distance || (leven->a_length == 0 || leven->b_length == 0)) {
    return (int)leven->b_length;
  }

  /* no reason to run levenshtein when equal */
  if (leven->a_length == leven->b_length && strcmp(leven->a, leven->b) == 0) {
    return (int)0;
  }

  leven->a_length++;
  leven->b_length++;

  int x, *grid_odd, *grid_even, i, j, cost, row_min, distance, *work_grid, *calc_grid, *tmp;
  unsigned int broke_max = FALSE;

  grid_even = ALLOC(sizeof(int) * (leven->a_length));
  grid_odd = ALLOC(sizeof(int) * (leven->a_length));

  if(grid_even == NULL || grid_odd == NULL) {
    return (int)9999;   /* error occured - cannot allocate memory */
  }  

  work_grid = grid_odd;
  calc_grid = grid_even;

  for(x = 0; x < leven->a_length; x++)
    grid_even[x] = x;

  for(i = 1; i < leven->b_length; i++) {     
    row_min = work_grid[0] = calc_grid[0] + 1;

    for(j = 1; j < leven->a_length; j++) {
      cost = (leven->a[j-1] == leven->b[i-1]) ? 0 : 1;
      work_grid[j] = LV_MIN(calc_grid[j]+1, work_grid[j-1]+1, calc_grid[j-1] + cost);
      row_min = (work_grid[j] < row_min) ? work_grid[j] : row_min;            
    }

    if(row_min > leven->maximum_allowable_distance) { 
      broke_max = TRUE; 
      break;
    }

    LV_SWAP(tmp, work_grid, calc_grid);
  }

  distance = (broke_max == TRUE) ? (leven->b_length - 1) : calc_grid[leven->a_length-1];  

  FREE(grid_odd);
  FREE(grid_even);  

  return (int) distance;
}

int levenshtein_extern(char* a, char* b, int max_distance)
{
  int a_len = (a == NULL) ? 0 : strlen(a);
  int b_len = (b == NULL) ? 0 : strlen(b);

  LevenConstraints* leven = malloc(sizeof(LevenConstraints));
  leven->a = (a_len > b_len) ? b : a;
  leven->b = (a_len > b_len) ? a : b;
  leven->a_length = strlen(leven->a);
  leven->b_length = strlen(leven->b);

  int distance = leven->b_length;

  if(max_distance < 0) {
    max_distance = (a_len > b_len) ? a_len : b_len;
  }

  leven->maximum_allowable_distance = max_distance;

  distance = levenshtein_intern(leven);  
  FREE(leven);

  return distance;
}

double normalized_levenshtein_extern(char* a, char* b, int max_distance)
{
  int a_len = (a == NULL) ? 0 : strlen(a);
  int b_len = (b == NULL) ? 0 : strlen(b);

  int max_string_length = (a_len > b_len) ? a_len : b_len;
  if(max_string_length == 0) {
    return 0;
  }
  return levenshtein_extern(a, b, max_distance) / (double)max_string_length;
}
