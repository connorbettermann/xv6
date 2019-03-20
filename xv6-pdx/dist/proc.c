#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#ifdef CS333_P2
#include "uproc.h"
#endif //CS333_P2

static char *states[] = {
[UNUSED]    "unused",
[EMBRYO]    "embryo",
[SLEEPING]  "sleep ",
[RUNNABLE]  "runble",
[RUNNING]   "run   ",
[ZOMBIE]    "zombie"
};

#ifdef CS333_P3
struct ptrs {
  struct proc* head;
  struct proc* tail;
};

#define statecount NELEM(states)

#endif //CS333_P3


static struct {
  struct spinlock lock;
  struct proc proc[NPROC];
#ifdef CS333_P3
  struct ptrs list[statecount];
#endif //CS333_P3
#ifdef CS333_P4
  struct ptrs ready[MAXPRIO+1];
  uint PromoteAtTime;
#endif //CS333_P4
} ptable;

static struct proc *initproc;

uint nextpid = 1;
extern void forkret(void);
extern void trapret(void);
static void wakeup1(void* chan);
#ifdef CS333_P3
static void initProcessLists(void);
static void initFreeList(void);
static void stateListAdd(struct ptrs*, struct proc*);
static int stateListRemove(struct ptrs*, struct proc* p);
static void assertState(struct proc *p, enum procstate); 
#endif //CS333_P3
#ifdef CS333_P4
int setpriority(int pid, int priority);
int getpriority(int pid);
#endif // CS333_P4

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}


// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;

  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");

  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid) {
      return &cpus[i];
    }
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

#ifdef CS333_P3
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p = ptable.list[UNUSED].head;
  char *sp;

  acquire(&ptable.lock);
  if(p != NULL) { 
    int rc = stateListRemove(&ptable.list[UNUSED], p);
    if(rc < 0) {
      //Failure to pull froom UNUSED list
      release(&ptable.lock);
      return 0;
    }   
  
    assertState(p, UNUSED);
    p->state = EMBRYO;
    p->pid = nextpid++;
    stateListAdd(&ptable.list[EMBRYO], p);
  }else{
    release(&ptable.lock);
    return 0;
  }
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    acquire(&ptable.lock);
    stateListRemove(&ptable.list[p->state], p);
    assertState(p, EMBRYO);
    p->state = UNUSED;
    stateListAdd(&ptable.list[p->state], p);
    release(&ptable.lock);
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

#ifdef CS333_P1
  p->start_ticks = ticks;
#endif //CS333_P1

#ifdef CS333_P2
  p->cpu_ticks_in = 0;
  p->cpu_ticks_total = 0;
#endif //CS333_P2
  return p;
}

#else
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  int found = 0;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED) {
      found = 1;
      break;
    }
  if (!found) {
    release(&ptable.lock);
    return 0;
  }
  p->state = EMBRYO;
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

#ifdef CS333_P1
  p->start_ticks = ticks;
#endif //CS333_P1

#ifdef CS333_P2
  p->cpu_ticks_in = 0;
  p->cpu_ticks_total = 0;
#endif //CS333_P2
  return p;
}
#endif //CS333_P3

#ifdef CS333_P4
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  acquire(&ptable.lock);
  initProcessLists();
  initFreeList();
  ptable.PromoteAtTime = (ticks + TICKS_TO_PROMOTE);
  release(&ptable.lock);
  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S
  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
  if(p != NULL){
    int rc = stateListRemove(&ptable.list[p->state], p);
    if(rc < 0){
      panic("userinit");
    }
    assertState(p, p->state);
    p->state = RUNNABLE;
    p->priority = MAXPRIO;
    p->budget = DEFAULT_BUDGET;
    stateListAdd(&ptable.ready[MAXPRIO], p);
  }
  release(&ptable.lock);
}


#elif defined(CS333_P3)
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  acquire(&ptable.lock);
  initProcessLists();
  initFreeList();
  release(&ptable.lock);
  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S
  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
  if(p != NULL){
    int rc = stateListRemove(&ptable.list[p->state], p);
    if(rc < 0){
      panic("userinit");
    }
    assertState(p, p->state);
    p->state = RUNNABLE;
    stateListAdd(&ptable.list[RUNNABLE], p);
  }
  release(&ptable.lock);
}

#else
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();

  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
  p->state = RUNNABLE;

  release(&ptable.lock);
}
#endif //CS333_P4

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}


#ifdef CS333_P4
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// fork allocates a new embryo and sets it to runnable
//after cloning its parent
int
fork(void)
{
  int i;
  uint pid;

  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    acquire(&ptable.lock);
    kfree(np->kstack);
    np->kstack = 0;
    stateListRemove(&ptable.list[np->state], np);
    np->state = UNUSED;
    //[CONNOR]
    stateListAdd(&ptable.list[UNUSED],np);
    release(&ptable.lock);
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;
  np->uid = curproc->uid;
  np->gid = curproc->gid;

  acquire(&ptable.lock);
  if(np != NULL){
    int rc = stateListRemove(&ptable.list[np->state], np);
    if(rc < 0)
      panic("fork");
    assertState(np, np->state);
    np->state = RUNNABLE;
    np->priority = MAXPRIO;
    np->budget = DEFAULT_BUDGET;
    stateListAdd(&ptable.ready[MAXPRIO], np);
  }
  release(&ptable.lock);

  return pid;
}

#elif defined (CS333_P3)
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// fork allocates a new embryo and sets it to runnable
//after cloning its parent
int
fork(void)
{
  int i;
  uint pid;

  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    acquire(&ptable.lock);
    kfree(np->kstack);
    np->kstack = 0;
    stateListRemove(&ptable.list[np->state], np);
    np->state = UNUSED;
    //[CONNOR]
    stateListAdd(&ptable.list[UNUSED],np);
    release(&ptable.lock);
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;
#ifdef CS333_P2
  np->uid = curproc->uid;
  np->gid = curproc->gid;
#endif //CS333_P2
  acquire(&ptable.lock);
  if(np != NULL){
    int rc = stateListRemove(&ptable.list[np->state], np);
    if(rc < 0)
      panic("fork");
    assertState(np, np->state);
    np->state = RUNNABLE;
    stateListAdd(&ptable.list[RUNNABLE], np);
  }
  release(&ptable.lock);

  return pid;
}

#else
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i;
  uint pid;

  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;
#ifdef CS333_P2
  np->uid = curproc->uid;
  np->gid = curproc->gid;
#endif //CS333_P2

  acquire(&ptable.lock);
  np->state = RUNNABLE;
  release(&ptable.lock);

  return pid;
}
#endif //CS333_P3


#ifdef CS333_P4
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Clone all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  //Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  //Pass abandoned children to init.
  for(int i = 0; i < statecount; i++){
    p = ptable.list[i].head;
    while(p != NULL){
      if(p->parent == curproc){
        p->parent = initproc;
        if(p->state == ZOMBIE)
          wakeup1(initproc);
      }
      p = p->next;
    }
  }
  for(int j = 0; j < MAXPRIO+1; j++){
    p = ptable.ready[j].head;
    while(p != NULL){
      if(p->parent == curproc){
        p->parent = initproc;
        if(p->state == ZOMBIE)
          wakeup1(initproc);
      }
      p = p->next;
    }
  }

  //Jump into the scheduler, never to return
  int rc = stateListRemove(&ptable.list[curproc->state], curproc);
  if(rc < 0){
    release(&ptable.lock);
    panic("exit remove");
  }
  assertState(curproc, curproc->state);
  curproc->state = ZOMBIE;
  stateListAdd(&ptable.list[ZOMBIE], curproc);
  sched();
  panic("zombie exit");
}

#elif defined(CS333_P3)
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Clone all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  //Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  //Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  //Jump into the scheduler, never to return
  int rc = stateListRemove(&ptable.list[curproc->state], curproc);
  if(rc < 0){
    release(&ptable.lock);
    panic("exit remove");
  }
  assertState(curproc, curproc->state);
  curproc->state = ZOMBIE;
  stateListAdd(&ptable.list[ZOMBIE], curproc);
  sched();
  panic("zombie exit");
}

#else
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}
#endif //CS333_P3

#ifdef CS333_P3
int
wait(void)
{
  struct proc *p;
  int havekids;
  uint pid;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
  for(;;){
    havekids = 0;

#ifdef CS333_P4 
    //Search the MLFQ ready list first for children
    //and then proceed to search original lists after
    for(int i = 0; i < MAXPRIO+1; i++){
      p = ptable.ready[i].head;
      while(p != NULL){
        if(p->parent == curproc){
          //p = p->next;
          //continue;
       // }
        //[CONNOR]Proc has kids
          havekids = 1;
          if(p->state == ZOMBIE){
            int rc = stateListRemove(&ptable.list[ZOMBIE], p);
            if(rc < 0){
              release(&ptable.lock);
              panic("wait");
            }
            assertState(p, ZOMBIE);
            pid = p->pid;
            kfree(p->kstack);
            p->kstack = 0;
            freevm(p->pgdir);
            p->pid = 0;
            p->parent = 0;
            p->name[0] = 0;
            p->killed = 0;
            p->state = UNUSED;

            p->priority = 0;

            stateListAdd(&ptable.list[UNUSED], p);
            release(&ptable.lock);
            return pid;
          }
        }
        p = p->next;
      }
    }
#endif //CS333_P4
    
    for(int j = 0; j < statecount; j++){
      p = ptable.list[j].head;
      while(p != NULL){
        if(p->parent == curproc){
          //p = p->next;
          //continue;
        //}
        //[CONNOR]Proc has kids
          havekids = 1;
          if(p->state == ZOMBIE){
            int rc = stateListRemove(&ptable.list[ZOMBIE], p);
            if(rc < 0){
              release(&ptable.lock);
              panic("wait");
            }
            assertState(p, ZOMBIE);
            pid = p->pid;
            kfree(p->kstack);
            p->kstack = 0;
            freevm(p->pgdir);
            p->pid = 0;
            p->parent = 0;
            p->name[0] = 0;
            p->killed = 0;
            p->state = UNUSED;
#ifdef CS333_P4
            p->priority = 0;
#endif //CS333_P4

            stateListAdd(&ptable.list[UNUSED], p);
            release(&ptable.lock);
            return pid;
          }
        }
        p = p->next;
      }
    }
    //No point waiting if we dont have any children
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    //Wait for children to exit
    sleep(curproc, &ptable.lock);
  }
}

#else
// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids;
  uint pid;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
#endif //CS333_P3

#ifdef CS333_P4
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
#ifdef PDX_XV6
  int idle;  // for checking if processor is idle
#endif // PDX_XV6

  for(;;){
    // Enable interrupts on this processor.
    sti();
#ifdef PDX_XV6
    idle = 1;  // assume idle unless we schedule a process
#endif // PDX_XV6
    // [CONNOR] Pull next proc from RUNNABLE list and assert state
    acquire(&ptable.lock);
    
    if(ticks >= ptable.PromoteAtTime){
      promoteAll();
      ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE;
    }
    
    
    for(int i = MAXPRIO; i >= 0; i--){
      p = ptable.ready[i].head;
      if(p == NULL)
        continue;
      else{
        int rc = stateListRemove(&ptable.ready[i], p);
        if(rc < 0){
          release(&ptable.lock);
          panic("scheduler");
        }
        assertState(p, RUNNABLE);
       
     
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
#ifdef PDX_XV6
        idle = 0;  // not idle this timeslice
#endif // PDX_XV6
        c->proc = p;
        switchuvm(p);
        p->state = RUNNING;
    
      //[CONNOR] add process to RUNNING list
        stateListAdd(&ptable.list[RUNNING], p);
#ifdef CS333_P2
        p->cpu_ticks_in = ticks;
#endif //CS333_P2
      
        swtch(&(c->scheduler), p->context);
        switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
        c->proc = 0;
        break;
    
#ifdef PDX_XV6
      }
    }
    
    release(&ptable.lock);
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
    
#endif // PDX_XV6
  }

}
#elif defined(CS333_P3)
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
#ifdef PDX_XV6
  int idle;  // for checking if processor is idle
#endif // PDX_XV6

  for(;;){
    // Enable interrupts on this processor.
    sti();
#ifdef PDX_XV6
    idle = 1;  // assume idle unless we schedule a process
#endif // PDX_XV6
    // [CONNOR] Pull next proc from RUNNABLE list and assert state
    acquire(&ptable.lock);
    p = ptable.list[RUNNABLE].head;
    if(p != NULL){
      int rc = stateListRemove(&ptable.list[RUNNABLE], p);
      //[CONNOR] if error pulling off of RUNNABLE, release lock and continue
      if(rc < 0){
        release(&ptable.lock);
        panic("scheduler");
        continue;
      }
      assertState(p, RUNNABLE);
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
#ifdef PDX_XV6
      idle = 0;  // not idle this timeslice
#endif // PDX_XV6
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
    
      //[CONNOR] add process to RUNNING list
      stateListAdd(&ptable.list[RUNNING], p);
#ifdef CS333_P2
      p->cpu_ticks_in = ticks;
#endif //CS333_P2
      
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    
#ifdef PDX_XV6
    }
    
    release(&ptable.lock);
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
    
#endif // PDX_XV6
  }
}

#else
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
#ifdef PDX_XV6
  int idle;  // for checking if processor is idle
#endif // PDX_XV6

  for(;;){
    // Enable interrupts on this processor.
    sti();

#ifdef PDX_XV6
    idle = 1;  // assume idle unless we schedule a process
#endif // PDX_XV6
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
#ifdef PDX_XV6
      idle = 0;  // not idle this timeslice
#endif // PDX_XV6
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
#ifdef CS333_P2
      p->cpu_ticks_in = ticks;
#endif //CS333_P2
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
#ifdef PDX_XV6
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
#endif // PDX_XV6
  }
}
#endif //CS333_P4

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
#ifdef CS333_P2
  p->cpu_ticks_total += (ticks - p->cpu_ticks_in);
#endif //CS333_P2
#ifdef CS333_P4
  p->budget = p->budget - (ticks - p->cpu_ticks_in);
  if(p->budget <= 0){
    if(p->priority > 0){
      p->priority--;
    }
    p->budget = DEFAULT_BUDGET;
    
  }
#endif //CS333_P4
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

#ifdef CS333_P4
void
yield(void)
{
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  stateListRemove(&ptable.list[curproc->state], curproc);
  assertState(curproc, curproc->state);
  curproc->state = RUNNABLE;
  stateListAdd(&ptable.ready[curproc->priority], curproc);
  sched();
  release(&ptable.lock);
}

#elif defined(CS333_P3)
void
yield(void)
{
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);//DOC: yieldlock
  stateListRemove(&ptable.list[curproc->state], curproc);
  assertState(curproc, curproc->state);
  curproc->state = RUNNABLE;
  stateListAdd(&ptable.list[RUNNABLE], curproc);
  sched();
  release(&ptable.lock);
}

#else
// Give up the CPU for one scheduling round.
void
yield(void)
{
  struct proc *curproc = myproc();

  acquire(&ptable.lock);  //DOC: yieldlock
  curproc->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}
#endif //CS333_P3

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

#ifdef CS333_P3
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();

  if(p == 0)
    panic("sleep");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    if (lk) release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  int rc = stateListRemove(&ptable.list[p->state], p);
  if(rc < 0){
    release(&ptable.lock);
    panic("sleep");
  }
  assertState(p, p->state);
  p->state = SLEEPING;
  stateListAdd(&ptable.list[SLEEPING], p);
  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    if (lk) acquire(lk);
  }
}

#else
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();

  if(p == 0)
    panic("sleep");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    if (lk) release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    if (lk) acquire(lk);
  }
}
#endif //CS333_P3

#ifdef CS333_P4
static void
wakeup1(void *chan)
{
  struct proc *p = ptable.list[SLEEPING].head;
  struct proc *t;
  
  while(p != NULL){
    if(p->chan == chan) {
      t = p;
      int rc = stateListRemove(&ptable.list[SLEEPING], t);
      if(rc < 0)
        panic("wakeup1");
      assertState(t, SLEEPING);
      t->state = RUNNABLE;
      stateListAdd(&ptable.ready[p->priority], t);
    }
    p = p->next;
  }
}

#elif defined(CS333_P3)
static void
wakeup1(void *chan)
{
  struct proc *p = ptable.list[SLEEPING].head;
  struct proc *t;
  
  while(p != NULL){
    if(p->chan == chan) {
      t = p;
      int rc = stateListRemove(&ptable.list[SLEEPING], t);
      if(rc < 0)
        panic("wakeup1");
      assertState(t, SLEEPING);
      t->state = RUNNABLE;
      stateListAdd(&ptable.list[RUNNABLE], t);
    }
    p = p->next;
  }
}


#else
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
#endif //CS333_P3

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

#ifdef CS333_P4
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock); 
  
  for(int i = 0; i < statecount; i++){
    p = ptable.list[i].head;
    while(p != NULL){
      if(p->pid == pid){
        p->killed = 1;
        if(i == SLEEPING){
          int rc = stateListRemove(&ptable.list[SLEEPING], p);
          if(rc < 0){
            release(&ptable.lock);
            panic("kill");
          }
          assertState(p, SLEEPING);
          p->state = RUNNABLE;
          stateListAdd(&ptable.ready[MAXPRIO], p);
        }
        release(&ptable.lock);
        return 0;
      }
      p = p->next;
    }
  }
  for(int j = 0; j < MAXPRIO+1; j++){
    p = ptable.ready[j].head;
    while(p != NULL){
      if(p->pid == pid){
        p->killed = 1;
        release(&ptable.lock);
        return 0;
      }
      p = p->next;
    }
  }
 
  release(&ptable.lock);
  return -1;
}

#elif defined(CS333_P3)
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(int i = 0; i < statecount; i++){
    p = ptable.list[i].head;
    while(p != NULL){
      if(p->pid == pid){
        int rc = stateListRemove(&ptable.list[i], p);
        if(rc < 0){
          release(&ptable.lock);
          panic("kill");
        }
        assertState(p, i);
        p->killed = 1;
        p->state = RUNNABLE;
        stateListAdd(&ptable.list[RUNNABLE], p);
        release(&ptable.lock);
        return 0;
      }
      p = p->next;
    }
  }
  release(&ptable.lock);
  return -1;
}

#else
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
#endif //CS333_P3

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
#ifdef CS333_P1
int
procdumpP1(struct proc * p, char * state)
{
  cprintf("%d\t%s\t%d.%d\t%s\t%d\t", p->pid, p->name, ((ticks - p->start_ticks)/1000), ((ticks - p->start_ticks)%1000), state, p->sz);
  return 0;
}
#endif //CS333_P1

#ifdef CS333_P4
int
procdumpP4(struct proc * p, char * state)
{
  int ppid;
  char *cpu_decimal_l = "0.";
  char *cpu_decimal_s = "00";
  if(p->parent == NULL)
    ppid = p->pid;
  else
    ppid = p->parent->pid;
  if((p->cpu_ticks_total/SCHED_INTERVAL) > 10)
    cpu_decimal_s = "0";
  if((p->cpu_ticks_total/SCHED_INTERVAL) > 100)
    cpu_decimal_s = "";
  cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d\t%s%s%d\t%s\t%d\t", p->pid, p->name, p->uid, p->gid, ppid, p->priority, ((ticks - p->start_ticks)/TPS), ((ticks - p->start_ticks)%TPS),
    cpu_decimal_l, cpu_decimal_s, (p->cpu_ticks_total)/SCHED_INTERVAL, state, p->sz);
  return 0;
}
#endif //CS333_P4

#ifdef CS333_P2
int
procdumpP2(struct proc * p, char * state)
{
  int ppid;
  char *cpu_decimal_l = "0.";
  char *cpu_decimal_s = "00";
  if(p->parent == NULL)
    ppid = p->pid;
  else
    ppid = p->parent->pid;
  if((p->cpu_ticks_total/SCHED_INTERVAL) > 10)
    cpu_decimal_s = "0";
  if((p->cpu_ticks_total/SCHED_INTERVAL) > 100)
    cpu_decimal_s = "";
  cprintf("%d\t%s\t%d\t%d\t%d\t%d.%d\t%s%s%d\t%s\t%d\t", p->pid, p->name, p->uid, p->gid, ppid,((ticks - p->start_ticks)/TPS), ((ticks - p->start_ticks)%TPS),
    cpu_decimal_l, cpu_decimal_s, (p->cpu_ticks_total)/SCHED_INTERVAL, state, p->sz);
  return 0;
}
#endif //CS333_P2

void
procdump(void)
{
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

#if defined(CS333_P4)
#define HEADER "\nPID\tNAME\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\tPCs\n"
#elif defined(CS333_P2)
#define HEADER "\nPID\tName\tUID\tGID\tPPID\tElasped\tCPU\tState\tSize\tPCs\n"
#elif defined(CS333_P1)
#define HEADER "\nPID\tName\tElapsed\tState\tSize\tPCs\n"
#else
#define HEADER "\n"
#endif

  cprintf(HEADER);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";

#if defined(CS333_P4)
    procdumpP4(p, state);
#elif defined(CS333_P2)
    procdumpP2(p, state);
#elif defined(CS333_P1)
    procdumpP1(p,state);
#else
    cprintf("%d\t%s\t%s\t", p->pid, p->name, state);
#endif
    
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

#ifdef CS333_P2

int
setuid(uint inuid)
{

  if(inuid >= 0 && inuid <= 32767)
  {
    acquire(&ptable.lock);
    myproc()->uid = inuid;
    release(&ptable.lock);
    return 0;
  }
  else
    return -1;
}

int
setgid(uint ingid)
{

  if(ingid >= 0 && ingid <= 32767)
  {
    acquire(&ptable.lock);
    myproc()->gid = ingid;
    release(&ptable.lock);
    return 0 ;
  }
  else
    return -1;
}

int
getuid(void)
{
  return myproc()->uid;
}

int
getgid(void)
{
  return myproc()->gid;
}

int
getppid(void)
{
  if(myproc()->parent == NULL)
    return myproc()->pid;
  else
    return myproc()->parent->pid;
}

int
getprocs(uint max, struct uproc *table)
{
  struct proc *p;
  int procnum;    //num of procs copied, element in table

  acquire(&ptable.lock);
  
  for(procnum = 0, p = ptable.proc; procnum < max && p < &ptable.proc[NPROC]; p++, procnum++)
  {
    if(p->state == UNUSED || p->state == EMBRYO)
    {
      //skip proc
      continue;
    }
    else
    {
      table[procnum].pid = p->pid;
      safestrcpy(table[procnum].name, p->name, sizeof(p->name));
      table[procnum].uid = p->uid;
      table[procnum].gid = p->gid;
#ifdef CS333_P4
      table[procnum].priority = p->priority;
#endif //CS333_P4
      if(p->parent == NULL)
        table[procnum].ppid = p->pid;
      else
        table[procnum].ppid = p->parent->pid;
      table[procnum].elapsed_ticks = (ticks - p->start_ticks);
      table[procnum].CPU_total_ticks = (p->cpu_ticks_total);
      table[procnum].size = p->sz;
      switch (p->state)
      {
        case RUNNABLE:
        {
          safestrcpy(table[procnum].state, "runble", STRMAX);
          break;
        }
        case SLEEPING:
        {
          safestrcpy(table[procnum].state, "sleep ", STRMAX);
          break;
        }
        case RUNNING:
        {
          safestrcpy(table[procnum].state, "run  ", STRMAX);
          break;
        }
        case ZOMBIE:
        {
          safestrcpy(table[procnum].state, "zombie", STRMAX);
          break;
        }
        case UNUSED:  
        {
          break;
        }
        case EMBRYO:
        {
          break;
        }
      }  
    }
   
  }
  release(&ptable.lock);
  return procnum;
}
#endif //CS333_P2

#ifdef CS333_P3

static void
stateListAdd(struct ptrs* list, struct proc* p)
{
  if((*list).head == NULL){
    (*list).head = p;
    (*list).tail = p;
    p->next = NULL;
  }else{
    ((*list).tail)->next = p;
    (*list).tail = ((*list).tail)->next;
    ((*list).tail)->next = NULL;
  }
}

static int
stateListRemove(struct ptrs* list, struct proc* p)
{
  if((*list).head == NULL || (*list).tail == NULL || p == NULL){
    return -1;
  }

  struct proc* current = (*list).head;
  struct proc* previous = 0;

  if(current == p){
    (*list).head = ((*list).head)->next;
    // prevent tail remaining assigned when we've removed the only item
    // on the list
    if((*list).tail == p){
      (*list).tail = NULL;
    }
    return 0;
  }

  while(current){
    if(current == p){
      break;
    }

    previous = current;
    current = current->next;
  }

  //Process not found hit eject.
  if(current == NULL){
    return -1;
  }

  //Process found.Set the appropriate next pointer
  if(current == (*list).tail){
    (*list).tail = previous;
    ((*list).tail)->next = NULL;
  }else{
    previous->next = current->next;
  }

  //Make sure p->next doesn't point into the list.
  p->next = NULL;

  return 0;
}

static void
initProcessLists()
{
  int i;

  for(i = UNUSED; i <= ZOMBIE; i++){
    ptable.list[i].head = NULL;
    ptable.list[i].tail = NULL;
  }
#ifdef CS333_P4
  for(i = 0; i <= MAXPRIO; i++) {
    ptable.ready[i].head = NULL;
    ptable.ready[i].tail = NULL;
  }
#endif //CS333_P4
}

static void
initFreeList(void)
{
  struct proc* p;

  for(p = ptable.proc; p < ptable.proc + NPROC; ++p){
    p->state = UNUSED;
    stateListAdd(&ptable.list[UNUSED], p);
  }
}

static void
assertState(struct proc *p, enum procstate state)
{
  if(p->state != state){
    cprintf("State mismatch: Current state is %s and should be %s", states[p->state], states[state]);
    panic("State Mismatch");
  }
  else
    return;
}

void
readydump(void)
{
  struct proc *p = ptable.list[RUNNABLE].head;
#ifdef CS333_P4
  acquire(&ptable.lock);
  cprintf("---Ready List Processes---]\n");
  for(int i = MAXPRIO; i >= 0; i--){
    p = ptable.ready[i].head;
    cprintf("Priority %d:", i);
    if(p == NULL){
      cprintf("List Empty\n");
      continue;
    }
    else{
      while(p != NULL){
        cprintf("(%d, %d) --> ", p->pid, p->budget);
        p = p->next;
      }
    }
    cprintf("\n");
  }
  release(&ptable.lock);
  return;
#endif //CS333_P4

  acquire(&ptable.lock);
  cprintf("---Ready List Processes---\n");
  if(p == NULL){
    cprintf("Ready List is Empty!\n");
    release(&ptable.lock);
    return;
  }
  while(p != NULL){
    cprintf("-> %d ", p->pid);
    p = p->next;
  }
  cprintf("\n");
  release(&ptable.lock);
  return;
}

void
freedump(void)
{
  struct proc *p = ptable.list[UNUSED].head;
  int count= 0;
  acquire(&ptable.lock);
  if(p == NULL){
    cprintf("Free List is Empty!\n");
    release(&ptable.lock);
    return;
  }
  while(p != NULL){
    count++;
    p = p->next;
  }
  cprintf("Free List Size: %d\n", count);
  release(&ptable.lock);
  return;
}

void
sleepdump(void)
{
  struct proc *p = ptable.list[SLEEPING].head;
  acquire(&ptable.lock);
  cprintf("---Sleeping List Processes---\n");
  if(p == NULL){
    cprintf("Sleeping List is Empty!\n");
    release(&ptable.lock);
    return;
  }
  while(p != NULL){
    cprintf("-> %d ", p->pid);
    p = p->next;
  }
  cprintf("\n");
  release(&ptable.lock);
  return;
}

void
zombiedump(void)
{
  struct proc *p = ptable.list[ZOMBIE].head;
  acquire(&ptable.lock);
  cprintf("---Zombie List Processes---\n");
  if(p == NULL){
    cprintf("Zombie List is Empty!\n");
    release(&ptable.lock);
    return;
  }
  while(p != NULL){
    cprintf("-> (%d,%d) ", p->pid, p->parent->pid);
    p = p->next;
  }
  cprintf("\n");
  release(&ptable.lock);
  return;
}
#endif //CS333_P3

#ifdef CS333_P4
int
setpriority(int pid, int priority)
{
  struct proc *p;
  if(pid > 32767 || pid < 0){
    return -1;
  }
  if(priority > MAXPRIO || priority < 0){
    return -1;
  }
  acquire(&ptable.lock);
  for(int i = 0; i < MAXPRIO+1; i++){
    p = ptable.ready[i].head;
    while(p != NULL){
      if(p->pid == pid){
        if(p->priority == priority){
          p->budget = DEFAULT_BUDGET;
          release(&ptable.lock);
          return 0;
        }
        stateListRemove(&ptable.ready[i], p);
        p->priority = priority;
        p->budget = DEFAULT_BUDGET;
        stateListAdd(&ptable.ready[priority], p);
        release(&ptable.lock);
        return 0;
      }
      p = p->next;
    }
  }
  for(int j = 0; j < statecount; j++){
    p = ptable.list[j].head;
    while(p != NULL){
      if(p->pid == pid){
        p->priority = priority;
        release(&ptable.lock);
        return 0;
      }
      p = p->next;
    }
  }
  release(&ptable.lock);
  return -1;
}

int
getpriority(int pid)
{
  struct proc *p;
  int prio;
  if(pid > 32767 || pid < 0){
    return -1;
  }
  acquire(&ptable.lock);
  for(int i = 0; i < MAXPRIO+1; i++){
    p = ptable.ready[i].head;
    while(p != NULL){
      if(p->pid == pid){
        prio = p->priority;
        release(&ptable.lock);
        return prio;
      }
      p = p->next;
    }
  }
  for(int j = 0; j < statecount; j++){
    p = ptable.list[j].head;
    while(p != NULL){
      if(p->pid == pid){
        prio = p->priority;
        release(&ptable.lock);
        return prio;
      }
      p = p->next;
    }
  }
  return -1;
}

int
promoteAll(void)
{
  
  struct proc *p;

  if(MAXPRIO == 0){
    return 0;
  }
  for(int i = 0; i < MAXPRIO; i++){
    p = ptable.ready[i].head;
    while(p != NULL){
      stateListRemove(&ptable.ready[i], p);
      p->priority = p->priority + 1;
      p->budget = DEFAULT_BUDGET;
      stateListAdd(&ptable.ready[i+1], p);
      p = p->next;
    }
  }
  
  return 0;
}

#endif // CS333_P4
