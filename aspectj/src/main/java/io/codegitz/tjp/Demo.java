package io.codegitz.tjp;

/**
 * @author Codegitz
 * @date 2021/12/16 17:46
 **/
public class Demo {
    static Demo d;

    public static void main(String[] args){
        new Demo().go();
    }

    void go(){
        d = new Demo();
        d.foo(1,d);
        System.out.println(d.bar(new Integer(3)));
    }

    void foo(int i, Object o){
        System.out.println("Demo.foo(" + i + ", " + o + ")\n");
    }

    String bar (Integer j){
        System.out.println("Demo.bar(" + j + ")\n");
        return "Demo.bar(" + j  + ")";
    }
}
