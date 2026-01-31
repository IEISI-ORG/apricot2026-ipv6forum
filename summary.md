## Summary

IPv6 requires effort to optimise a deployment and not just stand up dual stack and hope for the best.

### 🔑 Key Concepts

**1. The "Find and Fix" Loop**
Achieving high IPv6 utilization isn't passive. It requires an active cycle of **Measuring** (NetFlow/Akvorado), **Identifying** laggard applications (like BitTorrent), and **Intervening** (configuration changes) to force IPv6 compliance.

**2. The "Resolution Delay" Hack**
You are exploiting the mechanics of **Happy Eyeballs v2 (RFC 8305)**. By using a local caching resolver (Unbound), you eliminate DNS latency. This ensures the 250ms "Connection Attempt Delay" timer always triggers, mathematically forcing the OS to prefer IPv6 (per RFC 6724) before it ever attempts IPv4.

**3. The "IPv4 Floor"**
Even with aggressive optimization, there is a hard limit (currently ~10%) of traffic that remains IPv4. This consists of:
*   **Vendor Negligence:** IoT devices (e.g., Ring cameras) hardcoded for IPv4.
*   **Legacy Giants:** Major services (Amazon.com main site, GitHub main site) that lag in deployment.
*   **Infrastructure:** ISP-specific caching or management traffic.

**4. DNS-Aware Dynamic EAM (Proposed)**
Proposing a novel edge solution: a dynamic extension to **RFC 7757 (EAM)**. Instead of standard NAT464 (double translation), a local daemon would monitor DNS to dynamically map IPv4-only legacy devices directly to IPv6 APIs via SIIT, reducing overhead.

---

### 🚀 Key Takeaways

**1. Optimization Beats Waiting**
While the global internet (e.g., Germany) hovers around ~66% IPv6 adoption, a managed SOHO environment can manually achieve **>90%** today. We are effectively living 5 years in the future.

**2. BitTorrent is the Canary in the Coal Mine**
Peer-to-peer traffic is the perfect stress test. Identifying that BitTorrent clients default to IPv4 on "Any Interface" bindings—and fixing it—proved to be the single biggest lever, lifting the entire network average from 67% to over 80%.

**3. Latency is the Control Variable**
The "Race" between IPv4 and IPv6 is rigged by latency. If you control local DNS latency (Unbound), you control the outcome of the race.

**4. The Hardware Gap**
We have the methodology, but we lack the vendor support. The presentation culminates in a specific call to action: **MikroTik needs native 464XLAT (CLAT/PLAT) support** to tackle the final 10% of legacy traffic without complex workarounds.

