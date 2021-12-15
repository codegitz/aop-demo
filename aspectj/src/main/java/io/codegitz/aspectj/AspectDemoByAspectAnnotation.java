package io.codegitz.aspectj;

import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;

/**
 * @author Codegitz
 * @date 2021/12/15 18:05
 **/
@Aspect
public class AspectDemoByAspectAnnotation {

    @Pointcut("execution(* io.codegitz.service.DemoService.sayHello())")
    public void sayHello(){}

    @Before("sayHello()")
    public void before(){
        System.out.println("AspectDemoByAspectAnnotation before say");
    }

    @After("sayHello()")
    public void after(){
        System.out.println("AspectDemoByAspectAnnotation after say");
    }
}
