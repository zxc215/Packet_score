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

table switch_counting_flag {
    actions {
        set_counting_flag;
    }
}

table switch_score_flag {
    actions {
        set_score_flag;
    }
}







counter src_ip_counter_1 {
	type: packets;
	direct: src_ip_1;
}

table src_ip_1 {
	reads {
		ipv4.srcAddr: lpm;
	}
	actions {
		_nop;
	}
}

counter dst_ip_counter_1 {
	type: packets;
	direct: dst_ip_1;
}

table dst_ip_1 {
	reads {
		ipv4.dstAddr: lpm;
	}
	actions {
		_nop;
	}
}

counter proto_counter_1 {
	type: packets;
	direct: proto_1;
}

table proto_1 {
	reads {
		ipv4.protocol: exact;
	}
	actions {
		_nop;
	}
}

counter src_port_counter_1 {
	type: packets;
	direct: src_port_1;
}

table src_port_1 {
	reads {
		l4.sport: range;
	}
	actions {
		_nop;
	}
}

counter dst_port_counter_1 {
	type: packets;
	direct: dst_port_1;
}

table dst_port_1 {
	reads {
		l4.dport: range;
	}
	actions {
		_nop;
	}
}












counter src_ip_counter_2 {
	type: packets;
	direct: src_ip_2;
}

table src_ip_2 {
	reads {
		ipv4.srcAddr: lpm;
	}
	actions {
		_nop;
	}
}

counter dst_ip_counter_2 {
	type: packets;
	direct: dst_ip_2;
}

table dst_ip_2 {
	reads {
		ipv4.dstAddr: lpm;
	}
	actions {
		_nop;
	}
}

counter proto_counter_2 {
	type: packets;
	direct: proto_2;
}

table proto_2 {
	reads {
		ipv4.protocol: exact;
	}
	actions {
		_nop;
	}
}

counter src_port_counter_2 {
	type: packets;
	direct: src_port_2;
}

table src_port_2 {
	reads {
		l4.sport: range;
	}
	actions {
		_nop;
	}
}

counter dst_port_counter_2 {
	type: packets;
	direct: dst_port_2;
}

table dst_port_2 {
	reads {
		l4.dport: range;
	}
	actions {
		_nop;
	}
}












table src_ip_score_1 {
	reads {
		ipv4.srcAddr: lpm;
	}
	actions {
		add_score;
	}
}

table dst_ip_score_1 {
	reads {
		ipv4.dstAddr: lpm;
	}
	actions {
		add_score;
	}
}

table proto_score_1 {
	reads {
		ipv4.protocol: exact;
	}
	actions {
		add_score;
	}
}

table src_port_score_1 {
	reads {
		l4.sport: range;
	}
	actions {
		add_score;
	}
}

table dst_port_score_1 {
	reads {
		l4.dport: range;
	}
	actions {
		add_score;
	}
}






table src_ip_score_2 {
	reads {
		ipv4.srcAddr: lpm;
	}
	actions {
		add_score;
	}
}

table dst_ip_score_2 {
	reads {
		ipv4.dstAddr: lpm;
	}
	actions {
		add_score;
	}
}

table proto_score_2 {
	reads {
		ipv4.protocol: exact;
	}
	actions {
		add_score;
	}
}

table src_port_score_2 {
	reads {
		l4.sport: range;
	}
	actions {
		add_score;
	}
}

table dst_port_score_2 {
	reads {
		l4.dport: range;
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

counter W_G_B_counter {
	type: packets;
	direct: classify;
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

    apply(switch_counting_flag);
    if (counting_flag.flag == 0) {
        apply(src_ip_1);
	    apply(dst_ip_1);
	    apply(proto_1);
	    apply(src_port_1);
	    apply(dst_port_1);
    }



    if (counting_flag.flag == 1) {
        apply(src_ip_2);
	    apply(dst_ip_2);
	    apply(proto_2);
	    apply(src_port_2);
	    apply(dst_port_2);
    }



    apply(switch_score_flag);
    if (score_flag.flag == 0) {
	    apply(src_ip_score_1);
	    apply(dst_ip_score_1);
	    apply(proto_score_1);
	    apply(src_port_score_1);
	    apply(dst_port_score_1);
	}



	if (score_flag.flag == 1) {
	    apply(src_ip_score_2);
	    apply(dst_ip_score_2);
	    apply(proto_score_2);
	    apply(src_port_score_2);
	    apply(dst_port_score_2);
	}



	apply(sum_up);
	apply(classify);
}

control egress {
	
}
