Implementation and benchmarks for heapsort, mergesort, quicksort, sortn, snd fcmpsort                           
                                                                                                                
Del T7400 8 core dual Xeon 3gz (no threads)                                                                     
                                                                                                                
By Fried Egg                                                                                                    
fried.egg@verizon.net                                                                                           
Orginal listing on the end                                                                                      
                                                                                                                
                                                                                                                
         Benchmark in seconds for an array of one million numbers                                               
                                                                                                                
         3.75      4.00      4.25      4.50      4.75      5.00                                                 
       +---+---------+---------+---------+---------+---------+--+                                               
       |       3.99 A                                          +                                                
       |       4.00 D   R 4.09                                 |                                                
 sortn +            +---+                                      + sortn                                          
       |                                                       |                                                
       |                   4.24                    4.94  4.93  |                                                
       |                     D                        A  R     |                                                
 rfcmp +                     +------------------------+--+     + rfcmp                                          
       |                                                       |                                                
       |     3.92 3.95 4.08                                    |                                                
       |        A D    R                                       |                                                
 qsort +        +-+----+                                       + qsort                                          
       |                                                       |                                                
       |  3.83         4,14   4.26                             |                                                
       |     A            D   R                                |                                                
 msort +     +------------+---+                                + msort                                          
       |                                    A=Ascending        |                                                
       |    3.87       4.16        4.45     D=Descending       |                                                
       |       A          D           R     R=Random           |                                                
 hsort +       +----------+-----------+                        + hsort                                          
       |                                                       |                                                
       ---+---------+---------+---------+---------+---------+--                                                 
        3.75      4.00      4.25      4.50      4.75      5.00                                                  
                                                                                                                
                                BOUNDS                                                                          
                                                                                                                
In all cases random has the worst possible locality of reference.                                               
Most cache misses?                                                                                              
                                                                                                                
Sortn has the tightest bounds.                                                                                  
                                                                                                                
SAS-L                                                                                                           
Fied Egg Post                                                                                                   
https://listserv.uga.edu/cgi-bin/wa?A2=SAS-L;77d7c166.1902d                                                     
                                                                                                                
More documentaton                                                                                               
http://tinyurl.com/y846udyt                                                                                     
https://www.geeksforgeeks.org/time-complexities-of-all-sorting-algorithms/                                      
                                                                                                                
Not only does Fried Egg post provide implementation of external C functions but adds detailed                   
benchmarks for potential timimg bounds for each sort.                                                           
                                                                                                                
*_                   _                                                                                          
(_)_ __  _ __  _   _| |_                                                                                        
| | '_ \| '_ \| | | | __|                                                                                       
| | | | | |_) | |_| | |_                                                                                        
|_|_| |_| .__/ \__,_|\__|                                                                                       
        |_|                                                                                                     
;                                                                                                               
                                                                                                                
%let dim=1000000;                                                                                               
                                                                                                                
WORK.RANDOM  total obs=1                                                                                        
------------------------                                                                                        
                                                                                                                
/* seed data, to be sorted */                                                                                   
data random;                                                                                                    
  array f[&dim];                                                                                                
  call streaminit(1234);                                                                                        
  do _n_=1 to dim(f);                                                                                           
    f[_n_] = ceil(&dim*rand('uniform'));                                                                        
  end;                                                                                                          
run;                                                                                                            
      F1       F2       F3  ...  F999998  F999999  F1000000                                                     
                                                                                                                
  376501   785498     9567  ...   10859    540987    459853                                                     
                                                                                                                
                                                                                                                
WORK.DESCENDING  total obs=1                                                                                    
----------------------------                                                                                    
                                                                                                                
data descending;                                                                                                
  array f[&dim];                                                                                                
  do _n_=&dim to 1 by -1;                                                                                       
    f[_n_] = _n_;                                                                                               
  end;                                                                                                          
  output;                                                                                                       
run;                                                                                                            
       F1      F2        F3  ... F999998  F999999  F1000000                                                     
                                                                                                                
  1000000   999999  F999998              3        2        1                                                    
                                                                                                                
                                                                                                                
WORK.ASCENDING  total obs=1                                                                                     
---------------------------                                                                                     
                                                                                                                
data ascending;                                                                                                 
  array f[&dim];                                                                                                
  do i=_n_ to &dim;                                                                                             
    f[_n_] = _n_;                                                                                               
  end;                                                                                                          
  output;                                                                                                       
run;                                                                                                            
      F1       F2       F3  ...  F999998  F999999  F1000000                                                     
                                                                                                                
       1        2        3  ...   999998   999999   1000000                                                     
                                                                                                                
                                                                                                                
*          _       _   _                                                                                        
 ___  ___ | |_   _| |_(_) ___  _ __                                                                             
/ __|/ _ \| | | | | __| |/ _ \| '_ \                                                                            
\__ \ (_) | | |_| | |_| | (_) | | | |                                                                           
|___/\___/|_|\__,_|\__|_|\___/|_| |_|                                                                           
                                                                                                                
;                                                                                                               
                                                                                                                
******************************************************************************;                                 
* YOU NEED TO RUN THE PROC PROTO CODE ON THE END BEFORE RUNNING THE SOLUTION *;                                 
******************************************************************************;                                 
                                                                                                                
My cores are all single threaded,                                                                               
                                                                                                                
fastest to slowest                                                                                              
                                                                                                                
 1. sortn quicksort (tied)                                                                                      
 2. heapsort  mergesort (tied)                                                                                  
 3, fcmpsort                                                                                                    
                                                                                                                
%let dim=1000000;                                                                                               
                                                                                                                
options cmplib=(work.proto work.fcmp) fullstimer;                                                               
data random;                                                                                                    
  array f[&dim];                                                                                                
  call streaminit(1234);                                                                                        
  do _n_=1 to dim(f);                                                                                           
    f[_n_] = ceil(&dim*rand('uniform'));                                                                        
  end;                                                                                                          
run;                                                                                                            
                                                                                                                
sasfile random load; * instataneous;                                                                            
data _null_;                                                                                                    
   set random;                                                                                                  
   array f[&dim];                                                                                               
   call sortn(of f[*]);                                                                                         
run;quit;                                                                                                       
sasfile random close;                                                                                           
                                                                                                                
/*                                                                                                              
NOTE: There were 1 observations read from the data set WORK.RANDOM.                                             
NOTE: DATA statement used (Total process time):                                                                 
      real time           6.21 seconds                                                                          
      user cpu time       5.81 seconds                                                                          
      system cpu time     0.39 seconds                                                                          
      memory              545725.87k                                                                            
      OS Memory           802404.00k                                                                            
      Timestamp           03/01/2019 06:44:45 PM                                                                
      Step Count                        25  Switch Count  0                                                     
*/                                                                                                              
                                                                                                                
sasfile random load; * instataneous;                                                                            
data _null_;                                                                                                    
   set random;                                                                                                  
   array f[&dim];                                                                                               
   call quicksort(f);                                                                                           
run;quit;                                                                                                       
sasfile random close;                                                                                           
                                                                                                                
/*                                                                                                              
NOTE: There were 1 observations read from the data set WORK.RANDOM.                                             
NOTE: DATA statement used (Total process time):                                                                 
      real time           6.03 seconds                                                                          
      user cpu time       5.72 seconds                                                                          
      system cpu time     0.28 seconds                                                                          
      memory              545725.96k                                                                            
      OS Memory           802404.00k                                                                            
      Timestamp           03/01/2019 06:45:37 PM                                                                
      Step Count                        26  Switch Count  0                                                     
*/                                                                                                              
                                                                                                                
sasfile random load; * instataneous;                                                                            
data _null_;                                                                                                    
   set random;                                                                                                  
   array f[&dim];                                                                                               
   call heapsort(f);                                                                                            
run;quit;                                                                                                       
sasfile random close;                                                                                           
                                                                                                                
/*                                                                                                              
NOTE: There were 1 observations read from the data set WORK.RANDOM.                                             
NOTE: DATA statement used (Total process time):                                                                 
      real time           6.21 seconds                                                                          
      user cpu time       5.81 seconds                                                                          
      system cpu time     0.35 seconds                                                                          
      memory              545725.96k                                                                            
      OS Memory           802664.00k                                                                            
      Timestamp           03/01/2019 06:46:28 PM                                                                
      Step Count                        27  Switch Count  0                                                     
*/                                                                                                              
                                                                                                                
                                                                                                                
sasfile random load; * instataneous;                                                                            
data _null_;                                                                                                    
   set random;                                                                                                  
   array f[&dim];                                                                                               
   call mergesort(f);                                                                                           
run;quit;                                                                                                       
sasfile random close;                                                                                           
                                                                                                                
/*                                                                                                              
NOTE: There were 1 observations read from the data set WORK.RANDOM.                                             
NOTE: DATA statement used (Total process time):                                                                 
      real time           6.21 seconds                                                                          
      user cpu time       5.80 seconds                                                                          
      system cpu time     0.39 seconds                                                                          
      memory              545725.96k                                                                            
      OS Memory           802664.00k                                                                            
      Timestamp           03/01/2019 06:49:51 PM                                                                
      Step Count                        30  Switch Count  0                                                     
*/                                                                                                              
                                                                                                                
sasfile random load; * instataneous;                                                                            
data _null_;                                                                                                    
   set random;                                                                                                  
   array f[1000000];                                                                                            
   call fcmpqsort(f, 1, 1000000);                                                                               
run;quit;                                                                                                       
sasfile random close;                                                                                           
                                                                                                                
/*                                                                                                              
NOTE: There were 1 observations read from the data set WORK.RANDOM.                                             
NOTE: DATA statement used (Total process time):                                                                 
      real time           7.15 seconds                                                                          
      user cpu time       6.75 seconds                                                                          
      system cpu time     0.40 seconds                                                                          
      memory              545726.62k                                                                            
      OS Memory           805984.00k                                                                            
      Timestamp           03/01/2019 10:58:35 AM                                                                
      Step Count                        143  Switch Count  0                                                    
*/                                                                                                              
                                                                                                                
                                                                                                                
*                _                                                                                              
 _ __  _ __ ___ | |_ ___                                                                                        
| '_ \| '__/ _ \| __/ _ \                                                                                       
| |_) | | | (_) | || (_) |                                                                                      
| .__/|_|  \___/ \__\___/                                                                                       
|_|                                                                                                             
;                                                                                                               
                                                                                                                
/* external C function, this is the implementation of Quicksort */                                              
proc proto package=work.proto.sort;                                                                             
                                                                                                                
void qsort(double *list/iotype=u, int low, int high);                                                           
                                                                                                                
externc qsort;                                                                                                  
void swap(double *x,double *y)                                                                                  
{                                                                                                               
    double temp;                                                                                                
    temp = *x;                                                                                                  
    *x = *y;                                                                                                    
    *y = temp;                                                                                                  
}                                                                                                               
                                                                                                                
int choose_pivot(int i,int j )                                                                                  
{                                                                                                               
    return((i+j) /2);                                                                                           
}                                                                                                               
                                                                                                                
void qsort(double *list,int m,int n)                                                                            
{                                                                                                               
    int key,i,j,k;                                                                                              
    if( m < n)                                                                                                  
    {                                                                                                           
        k = choose_pivot(m,n);                                                                                  
        swap(&list[m],&list[k]);                                                                                
        key = list[m];                                                                                          
        i = m+1;                                                                                                
        j = n;                                                                                                  
        while(i <= j)                                                                                           
        {                                                                                                       
            while((i <= n) && (list[i] <= key))                                                                 
                i++;                                                                                            
            while((j >= m) && (list[j] > key))                                                                  
                j--;                                                                                            
            if( i < j)                                                                                          
                swap(&list[i],&list[j]);                                                                        
        }                                                                                                       
        /* swap two elements */                                                                                 
        swap(&list[m],&list[j]);                                                                                
                                                                                                                
        /* recursively sort the lesser list */                                                                  
        qsort(list,m,j-1);                                                                                      
        qsort(list,j+1,n);                                                                                      
    }                                                                                                           
}                                                                                                               
externcend;                                                                                                     
                                                                                                                
                                                                                                                
void hsort (double *a/iotype=u, int n);                                                                         
                                                                                                                
externc hsort;                                                                                                  
int heapmax (double *a, int n, int i, int j, int k) {                                                           
        int m;                                                                                                  
        m = i;                                                                                                  
        if (j < n && a[j] > a[m]) {                                                                             
                m = j;                                                                                          
        }                                                                                                       
        if (k < n && a[k] > a[m]) {                                                                             
                m = k;                                                                                          
        }                                                                                                       
        return m;                                                                                               
}                                                                                                               
                                                                                                                
void downheap (double *a, int n, int i) {                                                                       
        int j, t;                                                                                               
        while (1) {                                                                                             
                j = heapmax(a, n, i, 2 * i + 1, 2 * i + 2);                                                     
                if (j == i) {                                                                                   
                        break;                                                                                  
                }                                                                                               
                t = a[i];                                                                                       
                a[i] = a[j];                                                                                    
                a[j] = t;                                                                                       
                i = j;                                                                                          
        }                                                                                                       
}                                                                                                               
                                                                                                                
void hsort (double *a, int n) {                                                                                 
        int i;                                                                                                  
        double t;                                                                                               
        for (i = (n - 2) / 2; i >= 0; i--) {                                                                    
                downheap(a, n, i);                                                                              
        }                                                                                                       
        for (i = 0; i < n; i++) {                                                                               
                t = a[n - i - 1];                                                                               
                a[n - i - 1] = a[0];                                                                            
                a[0] = t;                                                                                       
                downheap(a, n - i - 1, 0);                                                                      
        }                                                                                                       
}                                                                                                               
externcend;                                                                                                     
                                                                                                                
void msort (double *a, int n);                                                                                  
                                                                                                                
externc msort;                                                                                                  
void merge (double *a, int n, int m) {                                                                          
    int i, j, k;                                                                                                
    double *x = malloc(n * sizeof (double));                                                                    
    for (i = 0, j = m, k = 0; k < n; k++) {                                                                     
        x[k] = j == n      ? a[i++]                                                                             
             : i == m      ? a[j++]                                                                             
             : a[j] < a[i] ? a[j++]                                                                             
             :               a[i++];                                                                            
    }                                                                                                           
    for (i = 0; i < n; i++) {                                                                                   
        a[i] = x[i];                                                                                            
    }                                                                                                           
    free(x);                                                                                                    
}                                                                                                               
                                                                                                                
void msort (double *a, int n) {                                                                                 
    int m;                                                                                                      
    if (n < 2)                                                                                                  
        return;                                                                                                 
    m = n / 2;                                                                                                  
    msort(a, m);                                                                                                
    msort(a + m, n - m);                                                                                        
    merge(a, n, m);                                                                                             
}                                                                                                               
externcend;                                                                                                     
                                                                                                                
run;                                                                                                            
                                                                                                                
* __                                                                                                            
 / _| ___ _ __ ___  _ __                                                                                        
| |_ / __| '_ ` _ \| '_ \                                                                                       
|  _| (__| | | | | | |_) |                                                                                      
|_|  \___|_| |_| |_| .__/                                                                                       
                   |_|                                                                                          
;                                                                                                               
                                                                                                                
/* create wrapper for C function to allow data step execution */                                                
proc fcmp inlib=work.proto outlib=work.fcmp.sort;                                                               
                                                                                                                
  subroutine quicksort(a[*]);                                                                                   
    outargs a;                                                                                                  
    call qsort(a, 0, dim(a)-1);                                                                                 
  endsub;                                                                                                       
                                                                                                                
  subroutine heapsort(a[*]);                                                                                    
    outargs a;                                                                                                  
    call hsort(a, dim(a));                                                                                      
  endsub;                                                                                                       
                                                                                                                
  subroutine mergesort(a[*]);                                                                                   
    outargs a;                                                                                                  
    call msort(a, dim(a));                                                                                      
  endsub;                                                                                                       
                                                                                                                
  subroutine swap (a[*], x, y) ;                                                                                
    outargs a ;                                                                                                 
    t = a[x] ; a[x] = a[y] ; a[y] = t ;                                                                         
  endsub ;                                                                                                      
                                                                                                                
  subroutine fcmpqsort (a[*], l, h) ;                                                                           
    outargs a ;                                                                                                 
    if l >= h then return ;                                                                                     
    i = floor (divide (l + h, 2)) ;                                                                             
    if a[l] gt a[i] then call swap (a, l, i) ;                                                                  
    if a[l] gt a[h] then call swap (a, l, h) ;                                                                  
    if a[i] gt a[h] then call swap (a, i, h) ;                                                                  
    call swap (a, i, l) ;                                                                                       
    p = a[l] ;                                                                                                  
    i = l ;                                                                                                     
    j = h + 1 ;                                                                                                 
    do until (i >= j) ;                                                                                         
      do until (a[i] ge    p) ; i ++ 1 ; end ;                                                                  
      do until (p    ge a[j]) ; j +- 1 ; end ;                                                                  
      if i < j then call swap (a, i, j) ;                                                                       
    end ;                                                                                                       
    call swap (a, l, j) ;                                                                                       
    if j - 1 <= h - j then do ;                                                                                 
      call fcmpqsort (a, l, j - 1) ;                                                                            
      call fcmpqsort (a, j + 1, h) ;                                                                            
    end ;                                                                                                       
    else do ;                                                                                                   
      call fcmpqsort (a, j + 1, h) ;                                                                            
      call fcmpqsort (a, l, j - 1) ;                                                                            
    end ;                                                                                                       
  endsub ;                                                                                                      
                                                                                                                
quit;                                                                                                           
                                                                                                                
*           _       _             _                                                                             
  ___  _ __(_) __ _(_)_ __   __ _| |                                                                            
 / _ \| '__| |/ _` | | '_ \ / _` | |                                                                            
| (_) | |  | | (_| | | | | | (_| | |                                                                            
 \___/|_|  |_|\__, |_|_| |_|\__,_|_|                                                                            
              |___/                                                                                             
;                                                                                                               
                                                                                                                
Might as well throw my hat into the ring here.                                                                  
                                                                                                                
Quicksort is one of several with the same time complexity.                                                      
Heapsort and Mergesort are two others, so I added implementations                                               
for those algorithms and included the recursive fcmp                                                            
implementation of quicksort from Paul's email for comparison as well.                                           
                                                                                                                
SAS 9.4M5, Windows 7                                                                                            
1,000,000 element array 150 tests (randomly, descending and ascending)                                          
i7-5600U CPU @ 2.60GHz                                                                                          
                                                                                                                
algorithm | duration LSMEAN                                                                                     
----------|----------------                                                                                     
hsort     |            4.16                                                                                     
msort     |            4.08                                                                                     
qsort     |            3.98                                                                                     
rfcmp     |            4.67                                                                                     
sortn     |            4.03                                                                                     
                                                                                                                
The results are interesting at a quick glance.  Most notably, my test with the fcmp                             
native implementation of quicksort isn't nearly as far off as those shared by Paul or Bart.                     
These results are also in line with what I'm used to seeing from FCMP, where there isn't                        
a tremendous consequence from using recursion.                                                                  
The next observation is that we've actually been able to beat sortn,                                            
slthough barely (and at fewer elements sortn pretty much always won by a larger margin).                        
                                                                                                                
More granular results                                                                                           
                                                                                                                
algorithm | data       | duration LSMEAN                                                                        
----------|------------|----------------                                                                        
hsort     | ascending  |      3.87599998                                                                        
hsort     | descending |      4.15660000                                                                        
hsort     | random     |      4.45227272                                                                        
msort     | ascending  |      3.83099995                                                                        
msort     | descending |      4.14281252                                                                        
msort     | random     |      4.25512499                                                                        
qsort     | ascending  |      3.90571431                                                                        
qsort     | descending |      3.94775003                                                                        
qsort     | random     |      4.07537502                                                                        
rfcmp     | ascending  |      4.83790909                                                                        
rfcmp     | descending |      4.23671428                                                                        
rfcmp     | random     |      4.93380003                                                                        
sortn     | ascending  |      3.99276919                                                                        
sortn     | descending |      4.00469230                                                                        
sortn     | random     |      4.09400004                                                                        
                                                                                                                
                                                                                                                
*                _                                                                                              
 _ __  _ __ ___ | |_ ___                                                                                        
| '_ \| '__/ _ \| __/ _ \                                                                                       
| |_) | | | (_) | || (_) |                                                                                      
| .__/|_|  \___/ \__\___/                                                                                       
|_|                                                                                                             
;                                                                                                               
                                                                                                                
/* external C function, this is the implementation of Quicksort */                                              
proc proto package=work.proto.sort;                                                                             
                                                                                                                
void qsort(double *list/iotype=u, int low, int high);                                                           
                                                                                                                
externc qsort;                                                                                                  
void swap(double *x,double *y)                                                                                  
{                                                                                                               
    double temp;                                                                                                
    temp = *x;                                                                                                  
    *x = *y;                                                                                                    
    *y = temp;                                                                                                  
}                                                                                                               
                                                                                                                
int choose_pivot(int i,int j )                                                                                  
{                                                                                                               
    return((i+j) /2);                                                                                           
}                                                                                                               
                                                                                                                
void qsort(double *list,int m,int n)                                                                            
{                                                                                                               
    int key,i,j,k;                                                                                              
    if( m < n)                                                                                                  
    {                                                                                                           
        k = choose_pivot(m,n);                                                                                  
        swap(&list[m],&list[k]);                                                                                
        key = list[m];                                                                                          
        i = m+1;                                                                                                
        j = n;                                                                                                  
        while(i <= j)                                                                                           
        {                                                                                                       
            while((i <= n) && (list[i] <= key))                                                                 
                i++;                                                                                            
            while((j >= m) && (list[j] > key))                                                                  
                j--;                                                                                            
            if( i < j)                                                                                          
                swap(&list[i],&list[j]);                                                                        
        }                                                                                                       
        /* swap two elements */                                                                                 
        swap(&list[m],&list[j]);                                                                                
                                                                                                                
        /* recursively sort the lesser list */                                                                  
        qsort(list,m,j-1);                                                                                      
        qsort(list,j+1,n);                                                                                      
    }                                                                                                           
}                                                                                                               
externcend;                                                                                                     
                                                                                                                
                                                                                                                
void hsort (double *a/iotype=u, int n);                                                                         
                                                                                                                
externc hsort;                                                                                                  
int heapmax (double *a, int n, int i, int j, int k) {                                                           
        int m;                                                                                                  
        m = i;                                                                                                  
        if (j < n && a[j] > a[m]) {                                                                             
                m = j;                                                                                          
        }                                                                                                       
        if (k < n && a[k] > a[m]) {                                                                             
                m = k;                                                                                          
        }                                                                                                       
        return m;                                                                                               
}                                                                                                               
                                                                                                                
void downheap (double *a, int n, int i) {                                                                       
        int j, t;                                                                                               
        while (1) {                                                                                             
                j = heapmax(a, n, i, 2 * i + 1, 2 * i + 2);                                                     
                if (j == i) {                                                                                   
                        break;                                                                                  
                }                                                                                               
                t = a[i];                                                                                       
                a[i] = a[j];                                                                                    
                a[j] = t;                                                                                       
                i = j;                                                                                          
        }                                                                                                       
}                                                                                                               
                                                                                                                
void hsort (double *a, int n) {                                                                                 
        int i;                                                                                                  
        double t;                                                                                               
        for (i = (n - 2) / 2; i >= 0; i--) {                                                                    
                downheap(a, n, i);                                                                              
        }                                                                                                       
        for (i = 0; i < n; i++) {                                                                               
                t = a[n - i - 1];                                                                               
                a[n - i - 1] = a[0];                                                                            
                a[0] = t;                                                                                       
                downheap(a, n - i - 1, 0);                                                                      
        }                                                                                                       
}                                                                                                               
externcend;                                                                                                     
                                                                                                                
void msort (double *a, int n);                                                                                  
                                                                                                                
externc msort;                                                                                                  
void merge (double *a, int n, int m) {                                                                          
    int i, j, k;                                                                                                
    double *x = malloc(n * sizeof (double));                                                                    
    for (i = 0, j = m, k = 0; k < n; k++) {                                                                     
        x[k] = j == n      ? a[i++]                                                                             
             : i == m      ? a[j++]                                                                             
             : a[j] < a[i] ? a[j++]                                                                             
             :               a[i++];                                                                            
    }                                                                                                           
    for (i = 0; i < n; i++) {                                                                                   
        a[i] = x[i];                                                                                            
    }                                                                                                           
    free(x);                                                                                                    
}                                                                                                               
                                                                                                                
void msort (double *a, int n) {                                                                                 
    int m;                                                                                                      
    if (n < 2)                                                                                                  
        return;                                                                                                 
    m = n / 2;                                                                                                  
    msort(a, m);                                                                                                
    msort(a + m, n - m);                                                                                        
    merge(a, n, m);                                                                                             
}                                                                                                               
externcend;                                                                                                     
                                                                                                                
run;                                                                                                            
                                                                                                                
* __                                                                                                            
 / _| ___ _ __ ___  _ __                                                                                        
| |_ / __| '_ ` _ \| '_ \                                                                                       
|  _| (__| | | | | | |_) |                                                                                      
|_|  \___|_| |_| |_| .__/                                                                                       
                   |_|                                                                                          
;                                                                                                               
                                                                                                                
/* create wrapper for C function to allow data step execution */                                                
proc fcmp inlib=work.proto outlib=work.fcmp.sort;                                                               
                                                                                                                
  subroutine quicksort(a[*]);                                                                                   
    outargs a;                                                                                                  
    call qsort(a, 0, dim(a)-1);                                                                                 
  endsub;                                                                                                       
                                                                                                                
  subroutine heapsort(a[*]);                                                                                    
    outargs a;                                                                                                  
    call hsort(a, dim(a));                                                                                      
  endsub;                                                                                                       
                                                                                                                
  subroutine mergesort(a[*]);                                                                                   
    outargs a;                                                                                                  
    call msort(a, dim(a));                                                                                      
  endsub;                                                                                                       
                                                                                                                
  subroutine swap (a[*], x, y) ;                                                                                
    outargs a ;                                                                                                 
    t = a[x] ; a[x] = a[y] ; a[y] = t ;                                                                         
  endsub ;                                                                                                      
                                                                                                                
  subroutine fcmpqsort (a[*], l, h) ;                                                                           
    outargs a ;                                                                                                 
    if l >= h then return ;                                                                                     
    i = floor (divide (l + h, 2)) ;                                                                             
    if a[l] gt a[i] then call swap (a, l, i) ;                                                                  
    if a[l] gt a[h] then call swap (a, l, h) ;                                                                  
    if a[i] gt a[h] then call swap (a, i, h) ;                                                                  
    call swap (a, i, l) ;                                                                                       
    p = a[l] ;                                                                                                  
    i = l ;                                                                                                     
    j = h + 1 ;                                                                                                 
    do until (i >= j) ;                                                                                         
      do until (a[i] ge    p) ; i ++ 1 ; end ;                                                                  
      do until (p    ge a[j]) ; j +- 1 ; end ;                                                                  
      if i < j then call swap (a, i, j) ;                                                                       
    end ;                                                                                                       
    call swap (a, l, j) ;                                                                                       
    if j - 1 <= h - j then do ;                                                                                 
      call fcmpqsort (a, l, j - 1) ;                                                                            
      call fcmpqsort (a, j + 1, h) ;                                                                            
    end ;                                                                                                       
    else do ;                                                                                                   
      call fcmpqsort (a, j + 1, h) ;                                                                            
      call fcmpqsort (a, l, j - 1) ;                                                                            
    end ;                                                                                                       
  endsub ;                                                                                                      
                                                                                                                
quit;                                                                                                           
                                                                                                                
/* register function packages to enable use in data step */                                                     
options cmplib=(work.proto work.fcmp);                                                                          
                                                                                                                
%let dim=10; *10000000; *number of elements to sort;                                                            
%let n=150; *number of tests;                                                                                   
                                                                                                                
/* seed data, to be sorted */                                                                                   
data random;                                                                                                    
  array f[&dim];                                                                                                
  call streaminit(1234);                                                                                        
  do _n_=1 to dim(f);                                                                                           
    f[_n_] = ceil(&dim*rand('uniform'));                                                                        
  end;                                                                                                          
  output;                                                                                                       
  stop;                                                                                                         
run;                                                                                                            
                                                                                                                
data descending;                                                                                                
  array f[&dim];                                                                                                
  do _n_=&dim to 1 by -1;                                                                                       
    f[_n_] = _n_;                                                                                               
  end;                                                                                                          
  output;                                                                                                       
  stop;                                                                                                         
run;                                                                                                            
                                                                                                                
data ascending;                                                                                                 
  array f[&dim];                                                                                                
  do i=_n_ to &dim;                                                                                             
    f[_n_] = _n_;                                                                                               
  end;                                                                                                          
  output;                                                                                                       
  stop;                                                                                                         
run;                                                                                                            
                                                                                                                
proc print data=descending;                                                                                     
vars f999999-f1000000;                                                                                          
run;quit;                                                                                                       
                                                                                                                
/* for pretty ttest */                                                                                          
proc format;                                                                                                    
  value algorithm(default=5)                                                                                    
    1 = 'qsort'                                                                                                 
    2 = 'sortn'                                                                                                 
    3 = 'hsort'                                                                                                 
    4 = 'msort'                                                                                                 
    5 = 'rfcmp';                                                                                                
run;                                                                                                            
                                                                                                                
options fullstimer;                                                                                             
                                                                                                                
/* load seed data into buffer to minimize file I/O variability from timer */                                    
sasfile random load;                                                                                            
sasfile descending load;                                                                                        
sasfile ascending load;                                                                                         
                                                                                                                
/* run repeated tests to compare group means of duration(real time) */                                          
data metrics;                                                                                                   
  a = 'data _null_;set &set;array f[&dim];call quicksort(f);run;';                                              
  b = 'data _null_;set &set;array f[&dim];call sortn(of f[*]);run;';                                            
  c = 'data _null_;set &set;array f[&dim];call heapsort(f);run;';                                               
  d = 'data _null_;set &set;array f[&dim];call mergesort(f);run;';                                              
  e = 'data _null_;set &set;array f[&dim];call fcmpqsort(f, 1, &dim);run;';                                     
                                                                                                                
  array y[3] $ 10 _temporary_ ('random' 'descending' 'ascending');                                              
  array z[5] a b c d e;                                                                                         
                                                                                                                
  call streaminit(datetime());                                                                                  
  do run=1 to &n;                                                                                               
    algorithm=rand('integer',5);                                                                                
    seed=y[rand('integer', 3)];                                                                                 
    call symputx('set',seed);                                                                                   
    start=datetime();                                                                                           
    rc = dosubl(resolve(z[algorithm]));                                                                         
    duration=datetime() - start;                                                                                
    output;                                                                                                     
  end;                                                                                                          
  drop a b;                                                                                                     
  format algorithm algorithm.;                                                                                  
  format start datetime23.;                                                                                     
  format duration mmss8.3;                                                                                      
run;                                                                                                            
                                                                                                                
/* close seed data to clear memory */                                                                           
sasfile random close;                                                                                           
sasfile descending close;                                                                                       
sasfile ascending close;                                                                                        
                                                                                                                
/* data science? */                                                                                             
proc glm data=metrics;                                                                                          
  class algorithm seed;                                                                                         
  model duration=algorithm|seed;                                                                                
  lsmeans algorithm algorithm*seed;                                                                             
  run;                                                                                                          
quit;                                                                                                           
...                                                                                                             
                                                                                                                
                                                                                                                
