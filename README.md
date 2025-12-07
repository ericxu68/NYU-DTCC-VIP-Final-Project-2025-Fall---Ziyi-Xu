**NYU-DTCC-VIP Final Project 2025 Fall – Ziyi Xu**


This project builds a toolchain that can:

1. Automatically generate a Software Bill of Materials (SBOM)

2. Capture dynamic linked libraries that load during runtime

3. Add those runtime libraries back into the SBOM

Most SBOM tools, like Syft, only detect dependencies found on the filesystem. However, many programs load additional shared libraries dynamically during execution. These dynamic libraries do not appear in a static SBOM, which makes the SBOM incomplete.

To solve this problem, I created a combined workflow that includes:

1. Static analysis using Syft

2. Runtime tracing using strace

3. Automatic SBOM merging with a Python script

This process produces a runtime-aware SBOM. It shows both the static dependencies and the libraries actually used during execution. The result is a more accurate and complete SBOM that improves software supply chain visibility and security.

Here is the link to my VIP notebook for more information:
https://docs.google.com/document/d/1sJQRFBhFeUVOWWgDRHsyU34iOFVJb6PfPyoQlNio9gk/edit?tab=t.0#heading=h.gjdgxs
