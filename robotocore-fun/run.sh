#!/bin/bash
export PATH="/opt/homebrew/bin:$PATH"
mvn clean package -q -DskipTests
java -cp "target/robotocore-fun-1.0.0.jar:target/libs/*" com.robotocore.Main
