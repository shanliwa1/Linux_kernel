#! /bin/bash

# Everytime a vcpu thread is scheduled to run, the tracepoint:sched:sched_switch will be called.
# See sched_switch tracepoint for args parameters. 

sudo bpftrace -e 'tracepoint:sched:sched_switch / !strncmp(args->next_comm, "qemu-system-x86", 16) / {
	printf("\nvcpu thread sched in:\n");
	printf("\tnuma node id: %d\n", numaid);
	printf("\tprocessor id: %d\n", cpu);
	printf("\tprev_pid: %d\n", args->prev_pid);
	printf("\tprev_comm: %s\n", args->prev_comm);
	printf("\tnext_pid: %d\n", args->next_pid);
	printf("\tnext_comm: %s\n", args->next_comm)}'