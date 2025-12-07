import json
import sys
import hashlib

# Arguments:
#   1 = static SBOM file (JSON)
#   2 = dynamic library list (one path per line)
#   3 = output merged SBOM file
static_sbom_file = sys.argv[1]
dynamic_list_file = sys.argv[2]
output_file = sys.argv[3]

# -----------------------------------------------
# Load static SBOM
# -----------------------------------------------
with open(static_sbom_file, "r") as f:
    sbom = json.load(f)

# Ensure "libraries" section exists
if "libraries" not in sbom:
    sbom["libraries"] = []

# -----------------------------------------------
# Load dynamic libraries list
# -----------------------------------------------
with open(dynamic_list_file, "r") as f:
    dynamic_libs = [line.strip() for line in f.readlines() if line.strip()]

# -----------------------------------------------
# Add dynamic libraries to SBOM
# -----------------------------------------------
for lib in dynamic_libs:
    # Create a stable ID using SHA-1 hash
    lib_id = hashlib.sha1(lib.encode()).hexdigest()

    entry = {
        "id": f"dyn-{lib_id}",
        "name": lib.split("/")[-1],
        "path": lib,
        "type": "dynamic-library",
        "source": "strace"
    }

    sbom["libraries"].append(entry)

# -----------------------------------------------
# Save merged SBOM
# -----------------------------------------------
with open(output_file, "w") as f:
    json.dump(sbom, f, indent=2)

print(f"Merged SBOM created: {output_file}")
