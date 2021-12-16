package io.codegitz.aspectj;

import io.codegitz.entity.Point;

public aspect TraceNonStaticMethods {
    before(Point p): target(p) && call(* *(..)) {
        System.out.println("Entering " + thisJoinPoint + " in " + p);
    }
}
