#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>

#include <linux/unistd.h>
#include <sched.h>

/*
 * This declaration isn't used and looks useless. But for some
 * reason I don't understand at all, for some versions of perl
 * with some build configurations running on some systems,
 * this declaration is the difference between XS code that works
 * (specifically, passing t/11-exercise-all.t) and code that
 * segfaults. For the same reason, the  cpu_set_t  variables
 * in  xs_sched_getaffinity_get_affinity()  below are declared
 * static . 
 *
 * Any insights into this issue would be profoundly appreciated.
 */
char ___linux_sched_getaffinity_dummy[4096];

void diag()
{
  fprintf(stderr,"---\n");
  fprintf(stderr,"diag CPU_SETSIZE=%d\n", CPU_SETSIZE);
  fprintf(stderr,"diag sizeof(__cpu_mask)=%d\n", sizeof(__cpu_mask));
  fprintf(stderr,"diag __NCPUBITS=%d\n", __NCPUBITS);
  fprintf(stderr,"diag sizeof(cpu_set_t)=%d\n", sizeof(cpu_set_t));
  fprintf(stderr,"diag sizeof(pid_t)=%d\n", sizeof(pid_t));
}


MODULE = Sys::CpuAffinity        PACKAGE = Sys::CpuAffinity


long
xs_sched_getaffinity_get_affinity(pid,debug_flag)
	int pid
	int debug_flag
  CODE:
    int i, z;
    long r;
    static cpu_set_t _set2, *_set1;

    if(debug_flag) diag();
    if(debug_flag) fprintf(stderr,"getaffinity0\n");
    _set1 = &_set2;
    if(debug_flag) fprintf(stderr,"getaffinity1 pid=%d size=%d cpuset=%p\n",
                           (int) pid, (int) CPU_SETSIZE, (void *) _set1);
    /* RT 94560: CPU_SETSIZE might be less than sizeof(cpu_set_t) ? */
    z = sched_getaffinity((pid_t) pid, sizeof(cpu_set_t), _set1);
    if(debug_flag) fprintf(stderr,"getaffinity2\n");
    if (z) {
      if(debug_flag) fprintf(stderr,"getaffinity3 z=%d err=%d\n", z, errno);
      r = 0;
    } else {
      if(debug_flag) fprintf(stderr,"getaffinity5\n");
      for (i = 0, r = 0; i < __NCPUBITS; i++) {
        if(debug_flag) fprintf(stderr,"getaffinity6 i=%d r=%ld\n", i, r);
        if (CPU_ISSET(i, &_set2)) {
          if(debug_flag) fprintf(stderr,"getaffinity7\n");
          r |= 1L << i;
          if(debug_flag) fprintf(stderr,"getaffinity8 r=%ld\n", r);
        }
        if(debug_flag) fprintf(stderr,"getaffinity9\n");
      }
      if(debug_flag) fprintf(stderr,"getaffinitya\n");
    }
    RETVAL = r;
  OUTPUT:
    RETVAL




