**NYU-DTCC-VIP Final Project 2025 Fall – Ziyi Xu**


**Overview:**

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

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
**Script Explanation:**

1. I start the tool and set up the environment

When I run the script, I pass a program or command to it. The script saves that command so I can run it later with strace.

I also create an output folder and set the file names for everything I will generate. This keeps all logs and SBOM files in one place.

2. I generate the static SBOM using Syft

I use Syft to scan the current directory and create a static SBOM.
The command looks like this:

syft dir:. -o json > sbom-static.json

This gives me a list of all dependencies that already exist on disk before the program runs. It includes packages, libraries, and files in the project folder.

3. I capture runtime libraries using strace

Next, I run the target program under strace to see which files it opens.

strace -f -e trace=file my_program

I filter the output so I keep only lines with .so files. These are the shared libraries loaded at runtime. I save this to a log file called dynamic.log.

This shows me what the program really uses when it runs.

4. I extract unique library paths

From the dynamic log, I extract only the library paths.
I use grep to find the .so filenames and sort them to remove duplicates.

I save the clean list to dynamic-libs.txt.

This becomes the list of all dynamic libraries that my program opened during execution.

5. I merge dynamic libraries into the SBOM

I use my Python script to merge the static SBOM and the dynamic list.

python3 merge_sbom.py sbom-static.json dynamic-libs.txt sbom-merged.json

The script loads the static SBOM, turns each dynamic library into a small SBOM entry, and then adds all these entries to the final SBOM.

This gives me a more complete SBOM that includes both static and dynamic dependencies.

6. I finish the workflow

After the merge step, the script prints a message and stops.
The final output is sbom-merged.json.
This file shows everything the program depends on, both before and during execution.

Summary of My Process

Here is the full process I follow.

I generate a static SBOM with Syft.

I run the program with strace to capture runtime libraries.

I filter the strace output to find all .so libraries.

I extract and clean the list of dynamic libraries.

I merge the static and dynamic libraries into one SBOM.

This gives me a complete view of all dependencies used by the program.





--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
**Reference:**

Here is the link to my VIP notebook for more information:
https://docs.google.com/document/d/1sJQRFBhFeUVOWWgDRHsyU34iOFVJb6PfPyoQlNio9gk/edit?tab=t.0#heading=h.gjdgxs
