package io.codegitz.aspectj;

public aspect AspectDemoByAspectJ {

    pointcut sayHello(): execution(* io.codegitz.service.DemoService.sayHello());

    before(): sayHello() {
        System.out.println("AspectDemoByAspectJ before say");
    }
    after(): sayHello() {
        System.out.println("AspectDemoByAspectJ after say");
    }
}
