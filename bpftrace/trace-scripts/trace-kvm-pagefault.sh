#!/usr/bin/env bpftrace

BEGIN {
	printf("Tracing KVM page fault... Hit Ctrl-C to end.\n");
	printf("%-6s %-16s %-18s %-3s\n", "PID", "COMM", "FaultAddr", "ErroCode");

}

tracepoint:kvm:kvm_page_fault {
	@[kstack, ustack, comm, pid] = count();
	printf("\n\npagefault on cpu %d\n", curtask->on_cpu);
	printf("pid: %-6d, tgid: %-6d vcpuid: %-16d\n", curtask->pid, curtask->tgid, args->vcpu_id);
}

END {
	
}