# RFC Validation: Happy Eyeballs v2 & Address Selection

This document audits the technical assertions made in the APRICOT 2026 presentation regarding the interaction between local DNS caching (Unbound), Default Address Selection (RFC 6724), and Happy Eyeballs Version 2 (RFC 8305).

## 1. Assertion: "IPv6 is strictly preferred by the OS"

**Claim:** When a dual-stack host resolves a domain, the operating system sorts the IPv6 (`AAAA`) record above the IPv4 (`A`) record.

**Validation: RFC 6724 — Default Address Selection for IPv6**
*Status: **Verified***

The presentation relies on the "Policy Table" defined in **Section 2.1**. The standard mandates that native IPv6 addresses have a higher precedence value than IPv4 mapped addresses.

> **From RFC 6724, Section 2.1:**
>
> "The default policy table gives IPv6 addresses higher precedence than IPv4 addresses."
>
> | Prefix | Precedence | Label |
> | :--- | :--- | :--- |
> | `::1/128` | 50 | 0 |
> | `::/0` **(IPv6)** | **40** | 1 |
> | `::ffff:0:0/96` **(IPv4)** | **35** | 4 |

**Implication:** When `getaddrinfo()` returns a list of IP addresses to the application (browser), the IPv6 address is mathematically required to be at the top of the list unless specific admin overrides exist.

---

## 2. Assertion: "The 250ms 'Head Start' for IPv6"

**Claim:** Browsers implementing Happy Eyeballs v2 will wait approximately 250ms after sending the IPv6 SYN packet before attempting IPv4.

**Validation: RFC 8305 — Happy Eyeballs Version 2**
*Status: **Verified***

RFC 8305 obsoletes the older RFC 6555. It introduces the "Connection Attempt Delay." Since IPv6 is sorted first (per RFC 6724 above), the browser attempts it immediately. It then starts a timer before trying the next address (IPv4).

> **From RFC 8305, Section 5 (Connection Attempts):**
>
> "The Connection Attempt Delay governs the amount of time that a User Agent (UA) waits between connection attempts...
>
> **One recommended value for a default delay is 250 milliseconds.**"

> **From RFC 8305, Section 2 (Overview):**
>
> "This approach maximizes the probability that a connection will be established over IPv6... while preventing the user from waiting for a timeout."

**Implication:** In a network where the IPv6 RTT is normal (< 250ms), the IPv6 TCP handshake completes before the "Connection Attempt Delay" timer expires. The IPv4 connection is **never actually attempted**.

---

## 3. Assertion: "Fast DNS eliminates the 'Race' condition"

**Claim:** Using a local resolver (Unbound) ensures that A and AAAA records arrive simultaneously, preventing the browser from reacting to a slow AAAA record by falling back to IPv4.

**Validation: RFC 8305 — Section 3 (DNS Resolution)**
*Status: **Verified***

Happy Eyeballs v2 handles scenarios where one DNS record type arrives slower than the other using a "Resolution Delay."

> **From RFC 8305, Section 3:**
>
> "If the DNS client returns only one address family... the user agent SHOULD wait a short time for the other address family... This is the **Resolution Delay**.
>
> A recommended value for the Resolution Delay is **50 milliseconds**."

**The Unbound Effect:**
In the presentation's architecture, Unbound caches both records locally.
1. The browser requests `A` and `AAAA`.
2. Unbound responds to both in microseconds (effectively 0ms).
3. The "Resolution Delay" (50ms) is satisfied immediately because both answers are present.
4. The browser proceeds immediately to **Section 5 (Connection)**.
5. Because of **RFC 6724**, IPv6 is first in the list.
6. The browser connects via IPv6.

## Conclusion

The presentation's argument is technically sound. By reducing DNS latency to near-zero:

1. You eliminate the **Resolution Delay** (waiting for slow DNS).
2. You force the client solely into the **Connection Attempt Delay** phase.
3. Since IPv6 is sorted first, it is granted a **250ms exclusivity window**.

Unless the IPv6 path is broken or has >250ms latency, **IPv4 is mathematically excluded from the race.**

---

**References:**
- [RFC 6724 - Default Address Selection for IPv6](https://datatracker.ietf.org/doc/html/rfc6724)
- [RFC 8305 - Happy Eyeballs Version 2](https://datatracker.ietf.org/doc/html/rfc8305)

