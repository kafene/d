#!/usr/bin/env rdmd

import std.stdio;
import std.string;

void main()
{
    foreach (int i; 1..101) {
        if (i % 3 == 0) {
            writeln(i % 5 == 0 ? "FizzBuzz" : "Fizz");
        } else if (i % 5 == 0) {
            writeln("Buzz");
        } else {
            format("%d", i).writeln();
        }
    }
}
