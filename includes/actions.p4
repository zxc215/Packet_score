action set_tcp_ports() {
    modify_field(l4.sport, tcp.srcPort);
    modify_field(l4.dport, tcp.dstPort);
}

action set_udp_ports() {
    modify_field(l4.sport, udp.srcPort);
    modify_field(l4.dport, udp.dstPort);
}

action add_score(score_value) {
	add_to_field(score_metadata.score, score_value);
}

action send_out(out_port) {
	modify_field(standard_metadata.egress_spec, out_port);
}

action _drop() {
	drop();
}

action _nop() {
	
}