
variable "settings" {
  description = "Common SG Settings to enforce"
  type        = map(any)

  default = {
      prefix_list_max_entries = 5
  }
}

variable "zones" {
  description = "Map of known zones (cidr blocks) and thier descriptions"
  type        = map(list(string))

  default = {
    web-internal = ["10.1.0.0/16",    "Internal Web Zone"]
    app-internal = ["10.2.0.0/16",    "Internal App Zone"]
    db-internal  = ["10.3.0.0/16",    "Internal DB Zone"]
    lb-internal  = ["10.4.0.0/16",    "Internal Loadbalancer Zone"]
    lb-external  = ["10.100.0.0/16",  "External Loadbalancer Zone"]
    all          = ["0.0.0.0/0",      "Any Zone"]
    on-prem      = ["192.168.0.0/16", "On Prem Zone"]

    # This is a fallback zone to pass to lookup() as default. It does not open anything, because it should never be used.
    _ = ["", ""]
  }
}

variable "rules" {
  description = "Map of known security group rules (define as 'name' = ['from port', 'to port', 'protocol', 'description'])"
  type        = map(list(any))

  # Protocols (tcp, udp, icmp, all - are allowed keywords) or numbers (from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml):
  # All = -1, IPV4-ICMP = 1, TCP = 6, UDP = 17, IPV6-ICMP = 58
  default = {
    # HTTP
    http-80-tcp   = [80, 80, "tcp", "HTTP"]
    http-8080-tcp = [8080, 8080, "tcp", "HTTP"]
    # HTTPS
    https-443-tcp  = [443, 443, "tcp", "HTTPS"]
    https-8443-tcp = [8443, 8443, "tcp", "HTTPS"]
    # Web
    web-jmx-tcp = [1099, 1099, "tcp", "JMX"]
    # Zookeeper
    zookeeper-2181-tcp     = [2181, 2181, "tcp", "Zookeeper"]
    zookeeper-2182-tls-tcp = [2182, 2182, "tcp", "Zookeeper TLS (MSK specific)"]
    zookeeper-2888-tcp     = [2888, 2888, "tcp", "Zookeeper"]
    zookeeper-3888-tcp     = [3888, 3888, "tcp", "Zookeeper"]
    zookeeper-jmx-tcp      = [7199, 7199, "tcp", "JMX"]
    # Open all ports & protocols
    all-all       = [-1, -1, "-1", "All protocols"]
    all-tcp       = [0, 65535, "tcp", "All TCP ports"]
    all-udp       = [0, 65535, "udp", "All UDP ports"]
    all-icmp      = [-1, -1, "icmp", "All IPV4 ICMP"]
    all-ipv6-icmp = [-1, -1, 58, "All IPV6 ICMP"]

    # This is a fallback rule to pass to lookup() as default. It does not open anything, because it should never be used.
    _ = ["", "", ""]
  }
}

variable "groups" {
  description = "Map of groups of security group rules to use to generate modules (see update_groups.sh)"
  type        = map(map(list(string)))

  # Valid keys - ingress_rules, egress_rules, ingress_with_self, egress_with_self
  default = {
    web = {
      ingress_rules     = ["http-80-tcp", "http-8080-tcp", "https-443-tcp", "web-jmx-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
      ingress_zones     = ["web-internal", "lb-internal"]
      egress_zones      = ["web-internal", "app-internal"]
    }
    zookeeper = {
      ingress_rules     = ["zookeeper-2181-tcp", "zookeeper-2182-tls-tcp", "zookeeper-2888-tcp", "zookeeper-3888-tcp", "zookeeper-jmx-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
      ingress_zones     = ["app-internal", "web-internal"]
      egress_zones      = ["app-internal", "db-internal"]
    }
  }
}