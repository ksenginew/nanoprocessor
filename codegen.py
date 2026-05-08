
# nanoprocessor.srcs/sources_1/new/
# nanoprocessor.srcs/sim_1/new/
# assembler/main.py
# 
# create markdown file with filenames and content of the files

import os
import glob

def strip_vhdl_comments(content):
    """Remove VHDL comment lines and blank lines."""
    lines = content.split('\n')
    filtered_lines = []
    for line in lines:
        stripped = line.strip()
        if stripped and not stripped.startswith('--'):
            filtered_lines.append(line)
    return '\n'.join(filtered_lines)

def add_directory_to_output(out, directory_path, section_title):
    """Scan a directory and add all files to the markdown output."""
    if not os.path.isdir(directory_path):
        return out
    
    out += f"### {section_title}\n\n"
    
    # Get all VHDL files sorted
    vhdl_files = sorted(glob.glob(os.path.join(directory_path, "*.vhd")))
    
    for filepath in vhdl_files:
        filename = os.path.basename(filepath)
        out += f"#### {filename}\n\n```vhdl\n"
        
        try:
            with open(filepath, 'r') as f:
                content = f.read()
                content = strip_vhdl_comments(content)
                out += content
        except Exception as e:
            out += f"Error reading file: {e}\n"
        
        out += "\n```\n\n"
    
    return out

def add_file_to_output(out, filepath, display_name):
    """Add a single file to the markdown output."""
    if not os.path.isfile(filepath):
        return out
    
    out += f"## {display_name}\n\n```python\n"
    
    try:
        with open(filepath, 'r') as f:
            content = f.read()
            out += content
    except Exception as e:
        out += f"Error reading file: {e}\n"
    
    out += "\n```\n\n"
    
    return out

out = "## Appendix: Source Code and Testbench\n\n"

# Add source files
out = add_directory_to_output(out, 
    "nanoprocessor.srcs/sources_1/new", 
    "Synthesizable Sources")

# Add simulation testbenches
out = add_directory_to_output(out, 
    "nanoprocessor.srcs/sim_1/new", 
    "Simulation Testbenches")

# Write the output to APPENDIX.md
output_file = "APPENDIX.md"
try:
    with open(output_file, 'w') as f:
        f.write(out)
    print(f"Generated {output_file} successfully")
except Exception as e:
    print(f"Error writing output file: {e}")
