parser start {
    return parse_ethernet;
}

#define ETHERTYPE_IPV4 0x0800

header ethernet_t ethernet;

parser parse_ethernet {
    extract(ethernet);
    return select(latest.etherType) {
        ETHERTYPE_IPV4 : parse_ipv4;
        default: ingress;
    }
}

header ipv4_t ipv4;

#define PROTO_TCP 6
#define PROTO_UDP 17

parser parse_ipv4 {
    extract(ipv4);
    return select(latest.protocol) {
        PROTO_TCP : parse_tcp;
	PROTO_UDP : parse_udp;
        default: ingress;
    }
}

header tcp_t tcp;
header udp_t udp;

parser parse_tcp {
    extract(tcp);
    return ingress;
}

parser parse_udp {
    extract(udp);
    return ingress;
}

