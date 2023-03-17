#!/usr/bin/env bpftrace

BEGIN {
	printf("Tracing KVM page fault... Hit Ctrl-C to end.\n");
	printf("%-6s %-16s %-18s %-3s\n", "PID", "COMM", "FaultAddr", "ErroCode");

}

tracepoint:kvm:kvm_page_fault {
	@[kstack, ustack, comm, pid] = count();
	printf("\n\npagefault on cpu %d\n", cpu);
	printf("pid: %-6d, thread id: %-6d\n", pid, tid);
	printf("curtask->tgid: %-6d, curtask->pid: %-6d vcpuid: %-16d\n", curtask->tgid, curtask->pid, args->vcpu_id);
}

END {
	
}