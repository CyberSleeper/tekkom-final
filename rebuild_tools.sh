#!/bin/bash
echo "Cleaning old class files..."
find . -name "*.class" -type f -delete

echo "Compiling JLex..."
javac JLex/Main.java

echo "Compiling java_cup..."
javac java_cup/Main.java java_cup/runtime/*.java

echo "Running compile.sh..."
./compile.sh
