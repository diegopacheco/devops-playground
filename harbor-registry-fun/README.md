## Results

<img src="registry-result.png" width="600">

## Scan

```bash
❯ ./scan.sh postgres:latest
Security scanning: postgres:latest
All commands and output from this session will be recorded in container logs, including credentials and sensitive information passed through the command prompt.
If you don't see a command prompt, try pressing enter.

Report Summary

┌────────────────────────────────────────┬──────────┬─────────────────┬─────────┐
│                 Target                 │   Type   │ Vulnerabilities │ Secrets │
├────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ postgres:latest (debian 13.1)          │  debian  │       110       │    -    │
├────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ usr/local/bin/gosu                     │ gobinary │        0        │    -    │
├────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ /etc/ssl/private/ssl-cert-snakeoil.key │   text   │        -        │    1    │
└────────────────────────────────────────┴──────────┴─────────────────┴─────────┘
Legend:
- '-': Not scanned
- '0': Clean (no security findings detected)


postgres:latest (debian 13.1)
=============================
Total: 110 (UNKNOWN: 0, LOW: 100, MEDIUM: 9, HIGH: 1, CRITICAL: 0)

┌─────────────────────────┬─────────────────────┬──────────┬──────────────┬──────────────────────────────────────┬─────────────────┬──────────────────────────────────────────────────────────────┐
│         Library         │    Vulnerability    │ Severity │    Status    │          Installed Version           │  Fixed Version  │                            Title                             │
├─────────────────────────┼─────────────────────┼──────────┼──────────────┼──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ apt                     │ CVE-2011-3374       │ LOW      │ affected     │ 3.0.3                                │                 │ It was found that apt-key in apt, all versions, do not       │
│                         │                     │          │              │                                      │                 │ correctly...                                                 │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2011-3374                    │
├─────────────────────────┼─────────────────────┤          │              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ bash                    │ TEMP-0841856-B18BAF │          │              │ 5.2.37-2+b5                          │                 │ [Privilege escalation possible to other user than root]      │
│                         │                     │          │              │                                      │                 │ https://security-tracker.debian.org/tracker/TEMP-0841856-B1- │
│                         │                     │          │              │                                      │                 │ 8BAF                                                         │
├─────────────────────────┼─────────────────────┤          │              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ bsdutils                │ CVE-2022-0563       │          │              │ 1:2.41-5                             │                 │ util-linux: partial disclosure of arbitrary files in chfn    │
│                         │                     │          │              │                                      │                 │ and chsh when compiled...                                    │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2022-0563                    │
├─────────────────────────┼─────────────────────┤          │              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ coreutils               │ CVE-2017-18018      │          │              │ 9.7-3                                │                 │ coreutils: race condition vulnerability in chown and chgrp   │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2017-18018                   │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2025-5278       │          │              │                                      │                 │ coreutils: Heap Buffer Under-Read in GNU Coreutils sort via  │
│                         │                     │          │              │                                      │                 │ Key Specification                                            │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2025-5278                    │
├─────────────────────────┼─────────────────────┤          │              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ dirmngr                 │ CVE-2022-3219       │          │              │ 2.4.7-21+b3                          │                 │ gnupg: denial of service issue (resource consumption) using  │
│                         │                     │          │              │                                      │                 │ compressed packets                                           │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2022-3219                    │
├─────────────────────────┤                     │          │              ├──────────────────────────────────────┼─────────────────┤                                                              │
│ gnupg                   │                     │          │              │ 2.4.7-21                             │                 │                                                              │
│                         │                     │          │              │                                      │                 │                                                              │
│                         │                     │          │              │                                      │                 │                                                              │
├─────────────────────────┤                     │          │              │                                      ├─────────────────┤                                                              │
│ gnupg-l10n              │                     │          │              │                                      │                 │                                                              │
│                         │                     │          │              │                                      │                 │                                                              │
│                         │                     │          │              │                                      │                 │                                                              │
├─────────────────────────┤                     │          │              ├──────────────────────────────────────┼─────────────────┤                                                              │
│ gpg                     │                     │          │              │ 2.4.7-21+b3                          │                 │                                                              │
│                         │                     │          │              │                                      │                 │                                                              │
│                         │                     │          │              │                                      │                 │                                                              │
├─────────────────────────┤                     │          │              │                                      ├─────────────────┤                                                              │
│ gpg-agent               │                     │          │              │                                      │                 │                                                              │
│                         │                     │          │              │                                      │                 │                                                              │
│                         │                     │          │              │                                      │                 │                                                              │
├─────────────────────────┤                     │          │              │                                      ├─────────────────┤                                                              │
│ gpgconf                 │                     │          │              │                                      │                 │                                                              │
│                         │                     │          │              │                                      │                 │                                                              │
│                         │                     │          │              │                                      │                 │                                                              │
├─────────────────────────┤                     │          │              │                                      ├─────────────────┤                                                              │
│ gpgsm                   │                     │          │              │                                      │                 │                                                              │
│                         │                     │          │              │                                      │                 │                                                              │
│                         │                     │          │              │                                      │                 │                                                              │
├─────────────────────────┼─────────────────────┤          │              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ libapt-pkg7.0           │ CVE-2011-3374       │          │              │ 3.0.3                                │                 │ It was found that apt-key in apt, all versions, do not       │
│                         │                     │          │              │                                      │                 │ correctly...                                                 │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2011-3374                    │
├─────────────────────────┼─────────────────────┤          │              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ libblkid1               │ CVE-2022-0563       │          │              │ 2.41-5                               │                 │ util-linux: partial disclosure of arbitrary files in chfn    │
│                         │                     │          │              │                                      │                 │ and chsh when compiled...                                    │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2022-0563                    │
├─────────────────────────┼─────────────────────┤          │              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ libc-bin                │ CVE-2010-4756       │          │              │ 2.41-12                              │                 │ glibc: glob implementation can cause excessive CPU and       │
│                         │                     │          │              │                                      │                 │ memory consumption due to...                                 │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2010-4756                    │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2018-20796      │          │              │                                      │                 │ glibc: uncontrolled recursion in function                    │
│                         │                     │          │              │                                      │                 │ check_dst_limits_calc_pos_1 in posix/regexec.c               │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2018-20796                   │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2019-1010022    │          │              │                                      │                 │ glibc: stack guard protection bypass                         │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2019-1010022                 │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2019-1010023    │          │              │                                      │                 │ glibc: running ldd on malicious ELF leads to code execution  │
│                         │                     │          │              │                                      │                 │ because of...                                                │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2019-1010023                 │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2019-1010024    │          │              │                                      │                 │ glibc: ASLR bypass using cache of thread stack and heap      │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2019-1010024                 │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2019-1010025    │          │              │                                      │                 │ glibc: information disclosure of heap addresses of           │
│                         │                     │          │              │                                      │                 │ pthread_created thread                                       │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2019-1010025                 │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2019-9192       │          │              │                                      │                 │ glibc: uncontrolled recursion in function                    │
│                         │                     │          │              │                                      │                 │ check_dst_limits_calc_pos_1 in posix/regexec.c               │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2019-9192                    │
├─────────────────────────┼─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│ libc-l10n               │ CVE-2010-4756       │          │              │                                      │                 │ glibc: glob implementation can cause excessive CPU and       │
│                         │                     │          │              │                                      │                 │ memory consumption due to...                                 │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2010-4756                    │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2018-20796      │          │              │                                      │                 │ glibc: uncontrolled recursion in function                    │
│                         │                     │          │              │                                      │                 │ check_dst_limits_calc_pos_1 in posix/regexec.c               │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2018-20796                   │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2019-1010022    │          │              │                                      │                 │ glibc: stack guard protection bypass                         │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2019-1010022                 │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2019-1010023    │          │              │                                      │                 │ glibc: running ldd on malicious ELF leads to code execution  │
│                         │                     │          │              │                                      │                 │ because of...                                                │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2019-1010023                 │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2019-1010024    │          │              │                                      │                 │ glibc: ASLR bypass using cache of thread stack and heap      │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2019-1010024                 │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2019-1010025    │          │              │                                      │                 │ glibc: information disclosure of heap addresses of           │
│                         │                     │          │              │                                      │                 │ pthread_created thread                                       │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2019-1010025                 │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2019-9192       │          │              │                                      │                 │ glibc: uncontrolled recursion in function                    │
│                         │                     │          │              │                                      │                 │ check_dst_limits_calc_pos_1 in posix/regexec.c               │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2019-9192                    │
├─────────────────────────┼─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│ libc6                   │ CVE-2010-4756       │          │              │                                      │                 │ glibc: glob implementation can cause excessive CPU and       │
│                         │                     │          │              │                                      │                 │ memory consumption due to...                                 │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2010-4756                    │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2018-20796      │          │              │                                      │                 │ glibc: uncontrolled recursion in function                    │
│                         │                     │          │              │                                      │                 │ check_dst_limits_calc_pos_1 in posix/regexec.c               │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2018-20796                   │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2019-1010022    │          │              │                                      │                 │ glibc: stack guard protection bypass                         │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2019-1010022                 │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2019-1010023    │          │              │                                      │                 │ glibc: running ldd on malicious ELF leads to code execution  │
│                         │                     │          │              │                                      │                 │ because of...                                                │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2019-1010023                 │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2019-1010024    │          │              │                                      │                 │ glibc: ASLR bypass using cache of thread stack and heap      │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2019-1010024                 │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2019-1010025    │          │              │                                      │                 │ glibc: information disclosure of heap addresses of           │
│                         │                     │          │              │                                      │                 │ pthread_created thread                                       │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2019-1010025                 │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2019-9192       │          │              │                                      │                 │ glibc: uncontrolled recursion in function                    │
│                         │                     │          │              │                                      │                 │ check_dst_limits_calc_pos_1 in posix/regexec.c               │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2019-9192                    │
├─────────────────────────┼─────────────────────┤          │              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ libgcrypt20             │ CVE-2018-6829       │          │              │ 1.11.0-7                             │                 │ libgcrypt: ElGamal implementation doesn't have semantic      │
│                         │                     │          │              │                                      │                 │ security due to incorrectly encoded plaintexts...            │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2018-6829                    │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2024-2236       │          │              │                                      │                 │ libgcrypt: vulnerable to Marvin Attack                       │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2024-2236                    │
├─────────────────────────┼─────────────────────┤          │              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ libgnutls30t64          │ CVE-2011-3389       │          │              │ 3.8.9-3                              │                 │ HTTPS: block-wise chosen-plaintext attack against SSL/TLS    │
│                         │                     │          │              │                                      │                 │ (BEAST)                                                      │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2011-3389                    │
├─────────────────────────┼─────────────────────┤          │              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ libgssapi-krb5-2        │ CVE-2018-5709       │          │              │ 1.21.3-5                             │                 │ krb5: integer overflow in dbentry->n_key_data in             │
│                         │                     │          │              │                                      │                 │ kadmin/dbutil/dump.c                                         │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2018-5709                    │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2024-26458      │          │              │                                      │                 │ krb5: Memory leak at /krb5/src/lib/rpc/pmap_rmt.c            │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2024-26458                   │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2024-26461      │          │              │                                      │                 │ krb5: Memory leak at /krb5/src/lib/gssapi/krb5/k5sealv3.c    │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2024-26461                   │
├─────────────────────────┼─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│ libk5crypto3            │ CVE-2018-5709       │          │              │                                      │                 │ krb5: integer overflow in dbentry->n_key_data in             │
│                         │                     │          │              │                                      │                 │ kadmin/dbutil/dump.c                                         │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2018-5709                    │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2024-26458      │          │              │                                      │                 │ krb5: Memory leak at /krb5/src/lib/rpc/pmap_rmt.c            │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2024-26458                   │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2024-26461      │          │              │                                      │                 │ krb5: Memory leak at /krb5/src/lib/gssapi/krb5/k5sealv3.c    │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2024-26461                   │
├─────────────────────────┼─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│ libkrb5-3               │ CVE-2018-5709       │          │              │                                      │                 │ krb5: integer overflow in dbentry->n_key_data in             │
│                         │                     │          │              │                                      │                 │ kadmin/dbutil/dump.c                                         │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2018-5709                    │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2024-26458      │          │              │                                      │                 │ krb5: Memory leak at /krb5/src/lib/rpc/pmap_rmt.c            │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2024-26458                   │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2024-26461      │          │              │                                      │                 │ krb5: Memory leak at /krb5/src/lib/gssapi/krb5/k5sealv3.c    │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2024-26461                   │
├─────────────────────────┼─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│ libkrb5support0         │ CVE-2018-5709       │          │              │                                      │                 │ krb5: integer overflow in dbentry->n_key_data in             │
│                         │                     │          │              │                                      │                 │ kadmin/dbutil/dump.c                                         │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2018-5709                    │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2024-26458      │          │              │                                      │                 │ krb5: Memory leak at /krb5/src/lib/rpc/pmap_rmt.c            │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2024-26458                   │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2024-26461      │          │              │                                      │                 │ krb5: Memory leak at /krb5/src/lib/gssapi/krb5/k5sealv3.c    │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2024-26461                   │
├─────────────────────────┼─────────────────────┤          │              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ liblastlog2-2           │ CVE-2022-0563       │          │              │ 2.41-5                               │                 │ util-linux: partial disclosure of arbitrary files in chfn    │
│                         │                     │          │              │                                      │                 │ and chsh when compiled...                                    │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2022-0563                    │
├─────────────────────────┼─────────────────────┤          │              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ libldap2                │ CVE-2015-3276       │          │              │ 2.6.10+dfsg-1                        │                 │ openldap: incorrect multi-keyword mode cipherstring parsing  │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2015-3276                    │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2017-14159      │          │              │                                      │                 │ openldap: Privilege escalation via PID file manipulation     │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2017-14159                   │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2017-17740      │          │              │                                      │                 │ openldap: contrib/slapd-modules/nops/nops.c attempts to free │
│                         │                     │          │              │                                      │                 │ stack buffer allowing remote attackers to cause...           │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2017-17740                   │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2020-15719      │          │              │                                      │                 │ openldap: Certificate validation incorrectly matches name    │
│                         │                     │          │              │                                      │                 │ against CN-ID                                                │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2020-15719                   │
├─────────────────────────┼─────────────────────┤          ├──────────────┼──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ libllvm19               │ CVE-2024-7883       │          │ will_not_fix │ 1:19.1.7-3+b1                        │                 │ clang: CMSE secure state may leak from stack to              │
│                         │                     │          │              │                                      │                 │ floating-point registers                                     │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2024-7883                    │
├─────────────────────────┼─────────────────────┤          ├──────────────┼──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ libmount1               │ CVE-2022-0563       │          │ affected     │ 2.41-5                               │                 │ util-linux: partial disclosure of arbitrary files in chfn    │
│                         │                     │          │              │                                      │                 │ and chsh when compiled...                                    │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2022-0563                    │
├─────────────────────────┼─────────────────────┤          │              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ libncursesw6            │ CVE-2025-6141       │          │              │ 6.5+20250216-2                       │                 │ gnu-ncurses: ncurses Stack Buffer Overflow                   │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2025-6141                    │
├─────────────────────────┼─────────────────────┤          │              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ libperl5.40             │ CVE-2011-4116       │          │              │ 5.40.1-6                             │                 │ perl: File:: Temp insecure temporary file handling           │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2011-4116                    │
├─────────────────────────┼─────────────────────┤          │              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ libsmartcols1           │ CVE-2022-0563       │          │              │ 2.41-5                               │                 │ util-linux: partial disclosure of arbitrary files in chfn    │
│                         │                     │          │              │                                      │                 │ and chsh when compiled...                                    │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2022-0563                    │
├─────────────────────────┼─────────────────────┼──────────┤              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ libsqlite3-0            │ CVE-2025-7709       │ MEDIUM   │              │ 3.46.1-7                             │                 │ An integer overflow exists in the FTS5                       │
│                         │                     │          │              │                                      │                 │ https://sqlite.org/fts5.html e ...                           │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2025-7709                    │
│                         ├─────────────────────┼──────────┤              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2021-45346      │ LOW      │              │                                      │                 │ sqlite: crafted SQL query allows a malicious user to obtain  │
│                         │                     │          │              │                                      │                 │ sensitive information...                                     │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2021-45346                   │
├─────────────────────────┼─────────────────────┼──────────┼──────────────┼──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ libssl3t64              │ CVE-2025-9230       │ MEDIUM   │ fixed        │ 3.5.1-1                              │ 3.5.1-1+deb13u1 │ openssl: Out-of-bounds read & write in RFC 3211 KEK Unwrap   │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2025-9230                    │
│                         ├─────────────────────┤          │              │                                      │                 ├──────────────────────────────────────────────────────────────┤
│                         │ CVE-2025-9231       │          │              │                                      │                 │ openssl: Timing side-channel in SM2 algorithm on 64 bit ARM  │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2025-9231                    │
│                         ├─────────────────────┼──────────┤              │                                      │                 ├──────────────────────────────────────────────────────────────┤
│                         │ CVE-2025-9232       │ LOW      │              │                                      │                 │ openssl: Out-of-bounds read in HTTP client no_proxy handling │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2025-9232                    │
├─────────────────────────┼─────────────────────┤          ├──────────────┼──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ libsystemd0             │ CVE-2013-4392       │          │ affected     │ 257.8-1~deb13u2                      │                 │ systemd: TOCTOU race condition when updating file            │
│                         │                     │          │              │                                      │                 │ permissions and SELinux security contexts...                 │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2013-4392                    │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2023-31437      │          │              │                                      │                 │ An issue was discovered in systemd 253. An attacker can      │
│                         │                     │          │              │                                      │                 │ modify a...                                                  │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2023-31437                   │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2023-31438      │          │              │                                      │                 │ An issue was discovered in systemd 253. An attacker can      │
│                         │                     │          │              │                                      │                 │ truncate a...                                                │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2023-31438                   │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2023-31439      │          │              │                                      │                 │ An issue was discovered in systemd 253. An attacker can      │
│                         │                     │          │              │                                      │                 │ modify the...                                                │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2023-31439                   │
├─────────────────────────┼─────────────────────┤          │              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ libtinfo6               │ CVE-2025-6141       │          │              │ 6.5+20250216-2                       │                 │ gnu-ncurses: ncurses Stack Buffer Overflow                   │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2025-6141                    │
├─────────────────────────┼─────────────────────┤          │              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ libudev1                │ CVE-2013-4392       │          │              │ 257.8-1~deb13u2                      │                 │ systemd: TOCTOU race condition when updating file            │
│                         │                     │          │              │                                      │                 │ permissions and SELinux security contexts...                 │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2013-4392                    │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2023-31437      │          │              │                                      │                 │ An issue was discovered in systemd 253. An attacker can      │
│                         │                     │          │              │                                      │                 │ modify a...                                                  │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2023-31437                   │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2023-31438      │          │              │                                      │                 │ An issue was discovered in systemd 253. An attacker can      │
│                         │                     │          │              │                                      │                 │ truncate a...                                                │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2023-31438                   │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2023-31439      │          │              │                                      │                 │ An issue was discovered in systemd 253. An attacker can      │
│                         │                     │          │              │                                      │                 │ modify the...                                                │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2023-31439                   │
├─────────────────────────┼─────────────────────┤          │              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ libuuid1                │ CVE-2022-0563       │          │              │ 2.41-5                               │                 │ util-linux: partial disclosure of arbitrary files in chfn    │
│                         │                     │          │              │                                      │                 │ and chsh when compiled...                                    │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2022-0563                    │
├─────────────────────────┼─────────────────────┼──────────┤              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ libxml2                 │ CVE-2025-9714       │ MEDIUM   │              │ 2.12.7+dfsg+really2.9.14-2.1+deb13u1 │                 │ libxslt: libxml2: Inifinite recursion at exsltDynMapFunction │
│                         │                     │          │              │                                      │                 │ function in libexslt/dynamic.c                               │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2025-9714                    │
│                         ├─────────────────────┼──────────┤              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2025-8732       │ LOW      │              │                                      │                 │ libxml2: libxml2: Uncontrolled Recursion Vulnerability       │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2025-8732                    │
├─────────────────────────┼─────────────────────┼──────────┤              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ libxslt1.1              │ CVE-2025-7425       │ HIGH     │              │ 1.1.35-1.2+deb13u2                   │                 │ libxslt: Heap Use-After-Free in libxslt caused by atype      │
│                         │                     │          │              │                                      │                 │ corruption in xmlAttrPtr                                     │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2025-7425                    │
│                         ├─────────────────────┼──────────┼──────────────┤                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2025-10911      │ MEDIUM   │ fix_deferred │                                      │                 │ libxslt: use-after-free with key data stored cross-RVT       │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2025-10911                   │
│                         ├─────────────────────┼──────────┼──────────────┤                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2015-9019       │ LOW      │ affected     │                                      │                 │ libxslt: math.random() in xslt uses unseeded randomness      │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2015-9019                    │
├─────────────────────────┼─────────────────────┤          │              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ locales                 │ CVE-2010-4756       │          │              │ 2.41-12                              │                 │ glibc: glob implementation can cause excessive CPU and       │
│                         │                     │          │              │                                      │                 │ memory consumption due to...                                 │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2010-4756                    │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2018-20796      │          │              │                                      │                 │ glibc: uncontrolled recursion in function                    │
│                         │                     │          │              │                                      │                 │ check_dst_limits_calc_pos_1 in posix/regexec.c               │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2018-20796                   │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2019-1010022    │          │              │                                      │                 │ glibc: stack guard protection bypass                         │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2019-1010022                 │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2019-1010023    │          │              │                                      │                 │ glibc: running ldd on malicious ELF leads to code execution  │
│                         │                     │          │              │                                      │                 │ because of...                                                │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2019-1010023                 │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2019-1010024    │          │              │                                      │                 │ glibc: ASLR bypass using cache of thread stack and heap      │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2019-1010024                 │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2019-1010025    │          │              │                                      │                 │ glibc: information disclosure of heap addresses of           │
│                         │                     │          │              │                                      │                 │ pthread_created thread                                       │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2019-1010025                 │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2019-9192       │          │              │                                      │                 │ glibc: uncontrolled recursion in function                    │
│                         │                     │          │              │                                      │                 │ check_dst_limits_calc_pos_1 in posix/regexec.c               │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2019-9192                    │
├─────────────────────────┼─────────────────────┤          │              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ login                   │ CVE-2022-0563       │          │              │ 1:4.16.0-2+really2.41-5              │                 │ util-linux: partial disclosure of arbitrary files in chfn    │
│                         │                     │          │              │                                      │                 │ and chsh when compiled...                                    │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2022-0563                    │
├─────────────────────────┼─────────────────────┤          │              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ login.defs              │ CVE-2007-5686       │          │              │ 1:4.17.4-2                           │                 │ initscripts in rPath Linux 1 sets insecure permissions for   │
│                         │                     │          │              │                                      │                 │ the /var/lo ......                                           │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2007-5686                    │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2024-56433      │          │              │                                      │                 │ shadow-utils: Default subordinate ID configuration in        │
│                         │                     │          │              │                                      │                 │ /etc/login.defs could lead to compromise                     │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2024-56433                   │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ TEMP-0628843-DBAD28 │          │              │                                      │                 │ [more related to CVE-2005-4890]                              │
│                         │                     │          │              │                                      │                 │ https://security-tracker.debian.org/tracker/TEMP-0628843-DB- │
│                         │                     │          │              │                                      │                 │ AD28                                                         │
├─────────────────────────┼─────────────────────┤          │              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ mount                   │ CVE-2022-0563       │          │              │ 2.41-5                               │                 │ util-linux: partial disclosure of arbitrary files in chfn    │
│                         │                     │          │              │                                      │                 │ and chsh when compiled...                                    │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2022-0563                    │
├─────────────────────────┼─────────────────────┤          │              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ ncurses-base            │ CVE-2025-6141       │          │              │ 6.5+20250216-2                       │                 │ gnu-ncurses: ncurses Stack Buffer Overflow                   │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2025-6141                    │
├─────────────────────────┤                     │          │              │                                      ├─────────────────┤                                                              │
│ ncurses-bin             │                     │          │              │                                      │                 │                                                              │
│                         │                     │          │              │                                      │                 │                                                              │
├─────────────────────────┼─────────────────────┼──────────┼──────────────┼──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ openssl                 │ CVE-2025-9230       │ MEDIUM   │ fixed        │ 3.5.1-1                              │ 3.5.1-1+deb13u1 │ openssl: Out-of-bounds read & write in RFC 3211 KEK Unwrap   │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2025-9230                    │
│                         ├─────────────────────┤          │              │                                      │                 ├──────────────────────────────────────────────────────────────┤
│                         │ CVE-2025-9231       │          │              │                                      │                 │ openssl: Timing side-channel in SM2 algorithm on 64 bit ARM  │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2025-9231                    │
│                         ├─────────────────────┼──────────┤              │                                      │                 ├──────────────────────────────────────────────────────────────┤
│                         │ CVE-2025-9232       │ LOW      │              │                                      │                 │ openssl: Out-of-bounds read in HTTP client no_proxy handling │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2025-9232                    │
├─────────────────────────┼─────────────────────┼──────────┤              │                                      │                 ├──────────────────────────────────────────────────────────────┤
│ openssl-provider-legacy │ CVE-2025-9230       │ MEDIUM   │              │                                      │                 │ openssl: Out-of-bounds read & write in RFC 3211 KEK Unwrap   │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2025-9230                    │
│                         ├─────────────────────┤          │              │                                      │                 ├──────────────────────────────────────────────────────────────┤
│                         │ CVE-2025-9231       │          │              │                                      │                 │ openssl: Timing side-channel in SM2 algorithm on 64 bit ARM  │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2025-9231                    │
│                         ├─────────────────────┼──────────┤              │                                      │                 ├──────────────────────────────────────────────────────────────┤
│                         │ CVE-2025-9232       │ LOW      │              │                                      │                 │ openssl: Out-of-bounds read in HTTP client no_proxy handling │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2025-9232                    │
├─────────────────────────┼─────────────────────┤          ├──────────────┼──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ passwd                  │ CVE-2007-5686       │          │ affected     │ 1:4.17.4-2                           │                 │ initscripts in rPath Linux 1 sets insecure permissions for   │
│                         │                     │          │              │                                      │                 │ the /var/lo ......                                           │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2007-5686                    │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ CVE-2024-56433      │          │              │                                      │                 │ shadow-utils: Default subordinate ID configuration in        │
│                         │                     │          │              │                                      │                 │ /etc/login.defs could lead to compromise                     │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2024-56433                   │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ TEMP-0628843-DBAD28 │          │              │                                      │                 │ [more related to CVE-2005-4890]                              │
│                         │                     │          │              │                                      │                 │ https://security-tracker.debian.org/tracker/TEMP-0628843-DB- │
│                         │                     │          │              │                                      │                 │ AD28                                                         │
├─────────────────────────┼─────────────────────┤          │              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ perl                    │ CVE-2011-4116       │          │              │ 5.40.1-6                             │                 │ perl: File:: Temp insecure temporary file handling           │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2011-4116                    │
├─────────────────────────┤                     │          │              │                                      ├─────────────────┤                                                              │
│ perl-base               │                     │          │              │                                      │                 │                                                              │
│                         │                     │          │              │                                      │                 │                                                              │
├─────────────────────────┤                     │          │              │                                      ├─────────────────┤                                                              │
│ perl-modules-5.40       │                     │          │              │                                      │                 │                                                              │
│                         │                     │          │              │                                      │                 │                                                              │
├─────────────────────────┼─────────────────────┤          │              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ sysvinit-utils          │ TEMP-0517018-A83CE6 │          │              │ 3.14-4                               │                 │ [sysvinit: no-root option in expert installer exposes        │
│                         │                     │          │              │                                      │                 │ locally exploitable security flaw]                           │
│                         │                     │          │              │                                      │                 │ https://security-tracker.debian.org/tracker/TEMP-0517018-A8- │
│                         │                     │          │              │                                      │                 │ 3CE6                                                         │
├─────────────────────────┼─────────────────────┤          │              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ tar                     │ CVE-2005-2541       │          │              │ 1.35+dfsg-3.1                        │                 │ tar: does not properly warn the user when extracting setuid  │
│                         │                     │          │              │                                      │                 │ or setgid...                                                 │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2005-2541                    │
│                         ├─────────────────────┤          │              │                                      ├─────────────────┼──────────────────────────────────────────────────────────────┤
│                         │ TEMP-0290435-0B57B5 │          │              │                                      │                 │ [tar's rmt command may have undesired side effects]          │
│                         │                     │          │              │                                      │                 │ https://security-tracker.debian.org/tracker/TEMP-0290435-0B- │
│                         │                     │          │              │                                      │                 │ 57B5                                                         │
├─────────────────────────┼─────────────────────┤          │              ├──────────────────────────────────────┼─────────────────┼──────────────────────────────────────────────────────────────┤
│ util-linux              │ CVE-2022-0563       │          │              │ 2.41-5                               │                 │ util-linux: partial disclosure of arbitrary files in chfn    │
│                         │                     │          │              │                                      │                 │ and chsh when compiled...                                    │
│                         │                     │          │              │                                      │                 │ https://avd.aquasec.com/nvd/cve-2022-0563                    │
└─────────────────────────┴─────────────────────┴──────────┴──────────────┴──────────────────────────────────────┴─────────────────┴──────────────────────────────────────────────────────────────┘

/etc/ssl/private/ssl-cert-snakeoil.key (secrets)
================================================
Total: 1 (UNKNOWN: 0, LOW: 0, MEDIUM: 0, HIGH: 1, CRITICAL: 0)

HIGH: AsymmetricPrivateKey (private-key)
════════════════════════════════════════
Asymmetric Private Key
────────────────────────────────────────
 /etc/ssl/private/ssl-cert-snakeoil.key:2-27 (offset: 28 bytes) (added by 'RUN /bin/sh -c set -ex; 		export PYTHOND')
────────────────────────────────────────
   1   -----BEGIN PRIVATE KEY-----
   2 ┌ ****************************************************************
   3 │ ****************************************************************
   4 │ ****************************************************************
   5 │ ****************************************************************
   6 │ ****************************************************************
   7 │ ****************************************************************
   8 │ ****************************************************************
   9 │ ****************************************************************
  10 │ ****************************************************************
  11 │ ****************************************************************
  12 │ ****************************************************************
  13 │ ****************************************************************
  14 │ ****************************************************************
  15 │ ****************************************************************
  16 │ ****************************************************************
  17 │ ****************************************************************
  18 │ ****************************************************************
  19 │ ****************************************************************
  20 │ ****************************************************************
  21 │ ****************************************************************
  22 │ ****************************************************************
  23 │ ****************************************************************
  24 │ ****************************************************************
  25 │ ****************************************************************
  26 │ ****************************************************************
  27 └ ************************
  28   -----END PRIVATE KEY-----
────────────────────────────────────────


pod "trivy-scan" deleted from harbor namespace
```

## Pull Images

```bash
podman pull postgres:latest && podman tag postgres:latest localhost:30500/postgres:latest && podman push localhost:30500/postgres:latest --tls-verify=false
```