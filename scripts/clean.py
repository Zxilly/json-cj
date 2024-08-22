import os
import glob
import platform
    
def process_gcov_files(directory: str):
    for file_path in glob.glob(os.path.join(directory, '**', '*.gcov'), recursive=True):
        with open(file_path, 'r') as file:
            content = file.readlines()

        if len(content) == 0:
            os.unlink(file_path)
            print(f'Deleted file: {file_path}')
            continue

        fl = content[0]

        if 'Source:std.core' in fl:
            os.unlink(file_path)
            print(f'Deleted file: {file_path}')
            continue
        
        # rewrite the path separator
        if platform.system() == 'Windows':
            fl = fl.replace('/', '\\')
        else:
            fl = fl.replace('\\', '/')
        
        content[0] = fl

        with open(file_path, 'w') as file:
            file.writelines(content)


# get base directory relative to this script
base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), os.pardir, 'cov_output'))
process_gcov_files(base_dir)