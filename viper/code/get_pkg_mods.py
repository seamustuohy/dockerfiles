import os.path
import sys

import distlib.database


def to_module(s):
    parts = os.path.splitext(s)[0].split(os.sep)
    if s.endswith('.py'):
        if parts[-1] == '__init__':
            parts.pop()
    elif s.endswith('.so'):
        parts[-1], _, _ = parts[-1].partition('.')
    return '.'.join(parts)


def main():
    dp = distlib.database.DistributionPath()
    dist = dp.get_distribution(sys.argv[1])
    for f, _, _ in dist.list_installed_files():
        if f.endswith(('.py', '.so')):
            print(to_module(f))


if __name__ == '__main__':
    exit(main())
