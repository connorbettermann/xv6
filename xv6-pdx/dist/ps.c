#ifdef CS333_P4
#include "types.h"
#include "user.h"
#include "uproc.h"

int
main(int argc, char *argv[]) 
{
  int max = 72;  //values: 1, 16, 64, 72
  int numprocs = 0;
  int i;
  char *cpu_decimal_l = "0";
  char *cpu_decimal_s = ".00";

  struct uproc *table = malloc(sizeof(struct uproc) * max);  //allocate memory for uproc table to be filled

  numprocs = getprocs(max, table);
  if(numprocs == 0)
  {
    printf(1, "No Processess\n");
  }
  else
  {
    printf(1, "PID\tNAME\tUID\tGID\tPPID\tPrio\tELAPSED\tCPU\tSTATE\tSIZE\t\n");
    
    for(i = 0; i < numprocs; i++)
    {
      if(table[i].pid)
      {
        if((table[i].CPU_total_ticks/SCHED_INTERVAL) > 10)
          cpu_decimal_s = ".0";
        if((table[i].CPU_total_ticks/SCHED_INTERVAL) > 100)
          cpu_decimal_s = ".";
        printf(1,"%d\t%s\t%d\t%d\t%d\t%d\t%d.%d\t%s%s%d\t%s\t%d\t\n",
          table[i].pid, table[i].name, table[i].uid, table[i].gid, 
          table[i].ppid, table[i].priority, table[i].elapsed_ticks/TPS, table[i].elapsed_ticks%TPS, 
          cpu_decimal_l, cpu_decimal_s,table[i].CPU_total_ticks/SCHED_INTERVAL, 
          table[i].state, table[i].size);
      }
    }
  }
  free(table);
  exit();
}

#endif //CS333_P4
