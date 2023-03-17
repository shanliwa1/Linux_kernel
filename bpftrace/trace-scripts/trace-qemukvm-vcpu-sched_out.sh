#! /bin/bash

# Everytime a vcpu thread is scheduled out, the tracepoint:sched:sched_switch will be called.
# See sched_switch tracepoint for args parameters. 

sudo bpftrace -e 'tracepoint:sched:sched_switch / !strncmp(args->prev_comm, "qemu-system-x86", 16) / {
	printf("\nvcpu thread sched in:\n");
	printf("\tcurtask->on_cpu %d\n", curtask->on_cpu);
	printf("\tprev_pid: %d\n", args->prev_pid);
	printf("\tprev_comm %s\n", args->prev_comm);
	printf("\tnext_pid: %d\n", args->next_pid);
	printf("\tnext_comm %s\n", args->next_comm)}'