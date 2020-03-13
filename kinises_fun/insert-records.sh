#!/bin/bash

aws kinesis put-record --stream-name Foo --partition-key 123 --data testdata 
