#! /bin/bash

# Everytime a vcpu thread is scheduled out, the tracepoint:sched:sched_switch will be called.
# See sched_switch tracepoint for args parameters. 

sudo bpftrace -e 'tracepoint:sched:sched_switch / !strncmp(args->prev_comm, "qemu-system-x86", 16) / {
	printf("\nvcpu thread sched in:\n");
	printf("\tprocessor %d on numa node %d\n", cpu, numaid);
	printf("\tqemu/kvm thread %d (%s) sched out\n", args->prev_pid, args->prev_comm);
	printf("\tnext thread %d (%s) sched in\n", args->next_pid, args->next_comm)}'