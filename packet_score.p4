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

counter src_ip_others_counter {
	type: packets;
	direct: src_ip_others;
}

table src_ip_others {
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

counter dst_ip_others_counter {
	type: packets;
	direct: dst_ip_others;
}

table dst_ip_others {
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

counter proto_others_counter {
	type: packets;
	direct: proto_others;
}

table proto_others {
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

counter src_port_high_counter {
	type: packets;
	direct: src_port_high;
}

table src_port_high {
	actions {
		add_score;
	}
}

counter src_port_low_counter {
	type: packets;
	direct: src_port_low;
}

table src_low_high {
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

counter dst_port_high_counter {
	type: packets;
	direct: dst_port_high;
}

table dst_port_high {
	actions {
		add_score;
	}
}

counter dst_port_low_counter {
	type: packets;
	direct: dst_port_low;
}

table dst_low_high {
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
	apply(src_ip) {
		miss {
			apply(src_ip_others);
		}
	}
	apply(dst_ip) {
		miss {
			apply(dst_ip_others);
		}
	}
	apply(proto) {
		miss {
			apply(proto_others);
		}
	}
	apply(src_port);
		miss {
			if (l4.sport >= 1024) {
				apply(src_port_high);
			}
			if (l4.sport < 1024) {
				apply(src_port_low);
			}
		}
	apply(dst_port) {
		miss {
			if (l4.dport >= 1024) {
				apply(dst_port_high);
			}
			if (l4.dport < 1024) {
				apply(dst_port_low);
			}
		}
	}
	apply(sum_up);
	apply(classify);
}

control egress {
	
}