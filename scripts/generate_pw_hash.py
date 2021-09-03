#!/usr/bin/env python3

# from notebook.auth import passwd
from jupyter_server.auth import passwd
import argparse

if __name__ == "__main__":
	description_text = 'Generate hash from password'

	parser = argparse.ArgumentParser(description=description_text)
	parser.add_argument('-p', type=str, required=True, help='Input password')


	args = parser.parse_args()

	print(passwd(args.p))
