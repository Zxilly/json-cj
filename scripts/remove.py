import os
import glob

def process_gcov_files(directory: str):
    for file_path in glob.glob(os.path.join(directory, '**', '*.gcov'), recursive=True):
        with open(file_path, 'r') as file:
            content = file.read()
        if 'Source:std.core' in content:
            os.unlink(file_path)
            print(f'Deleted file: {file_path}')


# get base directory relative to this script
base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), os.pardir, 'cov_output'))
process_gcov_files(base_dir)