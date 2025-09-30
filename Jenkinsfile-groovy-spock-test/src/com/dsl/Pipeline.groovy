package com.dsl

class Pipeline {

    def steps

    Pipeline(steps) {
        this.steps = steps
    }

    void build() {
        steps.sh 'echo "Building application"'
    }

    void test() {
        steps.sh 'echo "Running tests"'
    }

    void runCommand(steps) {
        steps.sh 'echo "Hello"'
    }
}