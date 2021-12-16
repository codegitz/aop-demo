package io.codegitz.tjp;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.reflect.CodeSignature;

public aspect GetInfo {

    static final void println(String s){ System.out.println(s); }

    pointcut goCut(): cflow(this(Demo) && execution(void go()));

    pointcut demoExecs(): within(Demo) && execution(* *(..));

    Object around(): demoExecs() && !execution(* go()) && goCut() {
        println("Intercepted message: " +
                thisJoinPointStaticPart.getSignature().getName());
        println("in class: " +
                thisJoinPointStaticPart.getSignature().getDeclaringType().getName());
        printParameters(thisJoinPoint);
        println("Running original method: \n" );
        Object result = proceed();
        println("  result: " + result );
        return result;
    }

    static private void printParameters(JoinPoint jp) {
        println("Arguments: " );
        Object[] args = jp.getArgs();
        String[] names = ((CodeSignature)jp.getSignature()).getParameterNames();
        Class[] types = ((CodeSignature)jp.getSignature()).getParameterTypes();
        for (int i = 0; i < args.length; i++) {
            println("  "  + i + ". " + names[i] +
                    " : " +            types[i].getName() +
                    " = " +            args[i]);
        }
    }
}
