#!/bin/bash
echo "Starting container: __IMAGE__"
docker run -d -p 80:80 __IMAGE__
