#!/bin/bash

kind get clusters | xargs -I {} kind delete cluster --name {}