#include "includes/headers.p4"
#include "includes/parser.p4"
#include "includes/actions.p4"

table l4_ports {
	reads {
		ipv4.protocol: exact;
	}
	actions {
		set_tcp_ports;
		set_udp_ports;
	}
}

counter src_ip_counter {
	type: packets;
	direct: src_ip;
}

table src_ip {
	reads {
		ipv4.srcAddr: lpm;
	}
	actions {
		add_score;
	}
}

counter dst_ip_counter {
	type: packets;
	direct: dst_ip;
}

table dst_ip {
	reads {
		ipv4.dstAddr: lpm;
	}
	actions {
		add_score;
	}
}

counter proto_counter {
	type: packets;
	direct: proto;
}

table proto {
	reads {
		ipv4.protocol: exact;
	}
	actions {
		add_score;
	}
}

counter src_port_counter {
	type: packets;
	direct: src_port;
}

table src_port {
	reads {
		l4.sport: exact;
	}
	actions {
		add_score;
	}
}

counter dst_port_counter {
	type: packets;
	direct: dst_port;
}

table dst_port {
	reads {
		l4.dport: exact;
	}
	actions {
		add_score;
	}
}

counter n_flow_counter {
	type: packets;
	direct: sum_up;
}

table sum_up {
	actions {
		add_score;
	}
}

table classify {
	reads {
		score_metadata.score: range;
	}
	actions {
		send_out;
		_drop;
	}
}

control ingress {
	apply(l4_ports);
	apply(src_ip);
	apply(dst_ip);
	apply(proto);
	apply(src_port);
	apply(dst_port);
	apply(sum_up);
	apply(classify);
}

control egress {
	
}