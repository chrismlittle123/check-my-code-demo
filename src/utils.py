# Example Python file with linting violations

# F401: unused imports
import os
import sys
import json

# E501: line too long (over 100 characters)
very_long_variable_name = "This is an extremely long string that goes way beyond the recommended line length limit of 100 characters"

# F841: local variable assigned but never used
def calculate():
    unused_result = 42
    return "done"

print("hello")
