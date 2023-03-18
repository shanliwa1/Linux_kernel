#!/usr/bin/env bpftrace

BEGIN {
	printf("Tracing KVM vcpu entry and exit... Hit Ctrl-C to end.\n");
	printf("%-6s %-6s %-6s %-6s %-18s\n", "PID", "TID", "VCPUID", "PrcessorID", "COMM");

}

tracepoint:kvm:kvm_entry /args->vcpu_id == 0/ {
	 @[kstack, ustack, comm, pid, tid] = count();
	printf("KVM Entry: TID: %-6d, VCPUID %-2d, processor id: %-2d, %-18s\n", tid, args->vcpu_id, cpu, comm);
}

tracepoint:kvm:kvm_exit /args->vcpu_id == 0/ {
	 @[kstack, ustack, comm, pid, tid] = count();
	printf("KVM Exits: TID: %-6d, VCPUID %-2d, processor id: %-2d, %-18s\n", tid, args->vcpu_id, cpu, comm);
}

END {
	
}