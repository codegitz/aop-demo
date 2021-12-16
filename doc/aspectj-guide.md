# Introduction

Many software developers are attracted to the idea of aspect-oriented programming (AOP) but unsure about how to begin using the technology. They recognize the concept of crosscutting concerns, and know that they have had problems with the implementation of such concerns in the past. But there are many questions about how to adopt AOP into the development process. Common questions include:

- Can I use aspects in my existing code?
- What kinds of benefits can I expect to get from using aspects?
- How do I find aspects in my programs?
- How steep is the learning curve for AOP?
- What are the risks of using this new technology?

## Introduction to AspectJ

 present the core of AspectJ's features.

 In the sections immediately following, we are first going to look at join points and how they compose into pointcuts. Then we will look at advice, the code which is run when a pointcut is reached. We will see how to combine pointcuts and advice into aspects, AspectJ's reusable, inheritable unit of modularity. Lastly, we will look at how to use inter-type declarations to deal with crosscutting concerns of a program's class structure. 

### The Dynamic Join Point Model

A critical element in the design of any aspect-oriented language is the join point model. The join point model provides the common frame of reference that makes it possible to define the dynamic structure of crosscutting concerns. This chapter describes AspectJ's dynamic join points, in which join points are certain well-defined points in the execution of the program.

AspectJ provides for many kinds of join points, but this chapter discusses only one of them: method call join points. A method call join point encompasses the actions of an object receiving a method call. It includes all the actions that comprise a method call, starting after all arguments are evaluated up to and including return (either normally or by throwing an exception).

Each method call at runtime is a different join point, even if it comes from the same call expression in the program. Many other join points may run while a method call join point is executing -- all the join points that happen while executing the method body, and in those methods called from the body. We say that these join points execute in the *dynamic context* of the original call join point.

### Pointcuts  

 In AspectJ, *pointcuts* pick out certain join points in the program flow. 

 Pointcuts not only pick out join points, they can also expose part of the execution context at their join points. Values exposed by a pointcut can be used in the body of advice declarations. 

### Advice

 So pointcuts pick out join points. But they don't *do* anything apart from picking out join points. To actually implement crosscutting behavior, we use advice. Advice brings together a pointcut (to pick out join points) and a body of code (to run at each of those join points). 

### Inter-type declarations

Inter-type declarations in AspectJ are declarations that cut across classes and their hierarchies. They may declare members that cut across multiple classes, or change the inheritance relationship between classes. Unlike advice, which operates primarily dynamically, introduction operates statically, at compile-time.

Consider the problem of expressing a capability shared by some existing classes that are already part of a class hierarchy, i.e. they already extend a class. In Java, one creates an interface that captures this new capability, and then adds to *each affected class* a method that implements this interface.

AspectJ can express the concern in one place, by using inter-type declarations. The aspect declares the methods and fields that are necessary to implement the new capability, and associates the methods and fields to the existing classes.

### Aspects

 Aspects wrap up pointcuts, advice, and inter-type declarations in a a modular unit of crosscutting implementation. It is defined very much like a class, and can have methods, fields, and initializers in addition to the crosscutting members. Because only aspects may include these crosscutting members, the declaration of these effects is localized. 

## Development AspectJ

  present facilitate tasks such as debugging, testing and performance tuning of applications.

  the use of aspects in increasingly sophisticated ways. 

### Tracing

To understand the benefit of coding this with AspectJ consider changing the set of method calls that are traced. With AspectJ, this just requires editing the definition of the `tracedCalls` pointcut and recompiling. The individual methods that are traced do not need to be edited.

When debugging, programmers often invest considerable effort in figuring out a good set of trace points to use when looking for a particular kind of problem. When debugging is complete or appears to be complete it is frustrating to have to lose that investment by deleting trace statements from the code. The alternative of just commenting them out makes the code look bad, and can cause trace statements for one kind of debugging to get confused with trace statements for another kind of debugging.

With AspectJ it is easy to both preserve the work of designing a good set of trace points and disable the tracing when it isn t being used. This is done by writing an aspect specifically for that tracing mode, and removing that aspect from the compilation when it is not needed.

This ability to concisely implement and reuse debugging configurations that have proven useful in the past is a direct result of AspectJ modularizing a crosscutting design element the set of methods that are appropriate to trace when looking for a given kind of information.

### Profiling and Logging

 Our second example shows you how to do some very specific profiling. Although many sophisticated profiling tools are available, and these can gather a variety of information and display the results in useful ways, you may sometimes want to profile or log some very specific behavior. In these cases, it is often possible to write a simple aspect similar to the ones above to do the job. 

```
aspect SetsInRotateCounting {
    int rotateCount = 0;
    int setCount = 0;

    before(): call(void Line.rotate(double)) {
        rotateCount++;
    }

    before(): call(void Point.set*(int))
              && cflow(call(void Line.rotate(double))) {
        setCount++;
    }
}
```

In effect, this aspect allows the programmer to ask very specific questions like

> How many times is the `rotate` method defined on `Line` objects called?

and

> How many times are methods defined on `Point` objects whose name begins with "`set`" called in fulfilling those rotate calls?

questions it may be difficult to express using standard profiling or logging tools.

### Pre- and Post-Conditions

 Many programmers use the "Design by Contract" style popularized by Bertand Meyer in *Object-Oriented Software Construction, 2/e*. In this style of programming, explicit pre-conditions test that callers of a method call it properly and explicit post-conditions test that methods properly do the work they are supposed to. 

### Contract Enforcement

 The property-based crosscutting mechanisms can be very useful in defining more sophisticated contract enforcement. One very powerful use of these mechanisms is to identify method calls that, in a correct program, should not exist. 

 When using this aspect, it is impossible for the compiler to compile programs with these illegal calls. This early detection is not always possible. In this case, since we depend only on static information (the `withincode` pointcut picks out join points totally based on their code, and the `call` pointcut here picks out join points statically). Other enforcement, such as the precondition enforcement, above, does require dynamic information such as the runtime value of parameters. 

### Configuration Management

Configuration management for aspects can be handled using a variety of make-file like techniques. To work with optional aspects, the programmer can simply define their make files to either include the aspect in the call to the AspectJ compiler or not, as desired.

Developers who want to be certain that no aspects are included in the production build can do so by configuring their make files so that they use a traditional Java compiler for production builds. To make it easy to write such make files, the AspectJ compiler has a command-line interface that is consistent with ordinary Java compilers.

## Production AspectJ

present implement crossingcutting functionality common in Java applications.

### Change Monitoring

The first example production aspect shows how one might implement some simple functionality where it is problematic to try and do it explicitly. It supports the code that refreshes the display. The role of the aspect is to maintain a dirty bit indicating whether or not an object has moved since the last time the display was refreshed.

Implementing this functionality as an aspect is straightforward. The `testAndClear` method is called by the display code to find out whether a figure element has moved recently. This method returns the current state of the dirty flag and resets it to false. The pointcut `move` captures all the method calls that can move a figure element. The after advice on `move` sets the dirty flag whenever an object moves.

```aspectj
aspect MoveTracking {
    private static boolean dirty = false;

    public static boolean testAndClear() {
        boolean result = dirty;
        dirty = false;
        return result;
    }

    pointcut move():
        call(void FigureElement.setXY(int, int)) ||
        call(void Line.setP1(Point))             ||
        call(void Line.setP2(Point))             ||
        call(void Point.setX(int))               ||
        call(void Point.setY(int));

    after() returning: move() {
        dirty = true;
    }
}
```

### Context Passing

 The crosscutting structure of context passing can be a significant source of complexity in Java programs. Consider implementing functionality that would allow a client of the figure editor (a program client rather than a human) to set the color of any figure elements that are created. Typically this requires passing a color, or a color factory, from the client, down through the calls that lead to the figure element factory. All programmers are familiar with the inconvenience of adding a first argument to a number of methods just to pass this kind of context information. 

### Providing Consistent Behavior

This example shows how a property-based aspect can be used to provide consistent handling of functionality across a large set of operations. This aspect ensures that all public methods of the `com.bigboxco` package log any Errors they throw to their caller (in Java, an Error is like an Exception, but it indicates that something really bad and usually unrecoverable has happened). The `publicMethodCall` pointcut captures the public method calls of the package, and the after advice runs whenever one of those calls throws an Error. The advice logs that Error and then the throw resumes.

```
aspect PublicErrorLogging {
    Log log = new Log();

    pointcut publicMethodCall():
        call(public * com.bigboxco.*.*(..));

    after() throwing (Error e): publicMethodCall() {
        log.write(e);
    }
}
```



# **The AspectJ Language** 

## The Anatomy of an Aspect

This lesson explains the parts of AspectJ's aspects. By reading this lesson you will have an overview of what's in an aspect and you will be exposed to the new terminology introduced by AspectJ.



### An Example Aspect

Here's an example of an aspect definition in AspectJ:

```
 1 aspect FaultHandler {
 2
 3   private boolean Server.disabled = false;
 4
 5   private void reportFault() {
 6     System.out.println("Failure! Please fix it.");
 7   }
 8
 9   public static void fixServer(Server s) {
10     s.disabled = false;
11   }
12
13   pointcut services(Server s): target(s) && call(public * *(..));
14
15   before(Server s): services(s) {
16     if (s.disabled) throw new DisabledException();
17   }
18
19   after(Server s) throwing (FaultException e): services(s) {
20     s.disabled = true;
21     reportFault();
22   }
23 }
```

The `FaultHandler` consists of one inter-type field on `Server` (line 03), two methods (lines 05-07 and 09-11), one pointcut definition (line 13), and two pieces of advice (lines 15-17 and 19-22).

This covers the basics of what aspects can contain. In general, aspects consist of an association of other program entities, ordinary variables and methods, pointcut definitions, inter-type declarations, and advice, where advice may be before, after or around advice. The remainder of this lesson focuses on those crosscut-related constructs.



### Pointcuts

AspectJ's pointcut definitions give names to pointcuts. Pointcuts themselves pick out join points, i.e. interesting points in the execution of a program. These join points can be method or constructor invocations and executions, the handling of exceptions, field assignments and accesses, etc. Take, for example, the pointcut definition in line 13:

```
pointcut services(Server s): target(s) && call(public * *(..))
```

This pointcut, named `services`, picks out those points in the execution of the program when `Server` objects have their public methods called. It also allows anyone using the `services` pointcut to access the `Server` object whose method is being called.

The idea behind this pointcut in the `FaultHandler` aspect is that fault-handling-related behavior must be triggered on the calls to public methods. For example, the server may be unable to proceed with the request because of some fault. The calls of those methods are, therefore, interesting events for this aspect, in the sense that certain fault-related things will happen when these events occur.

Part of the context in which the events occur is exposed by the formal parameters of the pointcut. In this case, that consists of objects of type `Server`. That formal parameter is then being used on the right hand side of the declaration in order to identify which events the pointcut refers to. In this case, a pointcut picking out join points where a Server is the target of some operation (target(s)) is being composed (`&&`, meaning and) with a pointcut picking out call join points (call(...)). The calls are identified by signatures that can include wild cards. In this case, there are wild cards in the return type position (first *), in the name position (second *) and in the argument list position (..); the only concrete information is given by the qualifier `public`.

Pointcuts pick out arbitrarily large numbers of join points of a program. But they pick out only a small number of *kinds* of join points. Those kinds of join points correspond to some of the most important concepts in Java. Here is an incomplete list: method call, method execution, exception handling, instantiation, constructor execution, and field access. Each kind of join point can be picked out by its own specialized pointcut that you will learn about in other parts of this guide.



### Advice

A piece of advice brings together a pointcut and a body of code to define aspect implementation that runs at join points picked out by the pointcut. For example, the advice in lines 15-17 specifies that the following piece of code

```
{
  if (s.disabled) throw new DisabledException();
}
```

is executed when instances of the `Server` class have their public methods called, as specified by the pointcut `services`. More specifically, it runs when those calls are made, just before the corresponding methods are executed.

The advice in lines 19-22 defines another piece of implementation that is executed on the same pointcut:

```
{
  s.disabled = true;
  reportFault();
}
```

But this second method executes after those operations throw exception of type `FaultException`.

There are two other variations of after advice: upon successful return and upon return, either successful or with an exception. There is also a third kind of advice called around. You will see those in other parts of this guide.

## Join Points and Pointcuts

Consider the following Java class:

```
class Point {
    private int x, y;

    Point(int x, int y) { this.x = x; this.y = y; }

    void setX(int x) { this.x = x; }
    void setY(int y) { this.y = y; }

    int getX() { return x; }
    int getY() { return y; }
}
```

In order to get an intuitive understanding of AspectJ's join points and pointcuts, let's go back to some of the basic principles of Java. Consider the following a method declaration in class Point:

```
void setX(int x) { this.x = x; }
```

This piece of program says that that when method named `setX` with an `int` argument called on an object of type `Point`, then the method body `{ this.x = x; }` is executed. Similarly, the constructor of the class states that when an object of type `Point` is instantiated through a constructor with two `int` arguments, then the constructor body `{ this.x = x; this.y = y; }` is executed.

One pattern that emerges from these descriptions is

> When something happens, then something gets executed.

In object-oriented programs, there are several kinds of "things that happen" that are determined by the language. We call these the join points of Java. Join points consist of things like method calls, method executions, object instantiations, constructor executions, field references and handler executions. (See the 



Pointcuts pick out these join points. For example, the pointcut

```
pointcut setter(): target(Point) &&
                   (call(void setX(int)) ||
                    call(void setY(int)));
```

picks out each call to `setX(int)` or `setY(int)` when called on an instance of `Point`. Here's another example:

```
pointcut ioHandler(): within(MyClass) && handler(IOException);
```

This pointcut picks out each the join point when exceptions of type `IOException` are handled inside the code defined by class `MyClass`.

Pointcut definitions consist of a left-hand side and a right-hand side, separated by a colon. The left-hand side consists of the pointcut name and the pointcut parameters (i.e. the data available when the events happen). The right-hand side consists of the pointcut itself.



### Some Example Pointcuts

Here are examples of pointcuts picking out

- when a particular method body executes

  `execution(void Point.setX(int))`

- when a method is called

  `call(void Point.setX(int))`

- when an exception handler executes

  `handler(ArrayOutOfBoundsException)`

- when the object currently executing (i.e. `this`) is of type `SomeType`

  `this(SomeType)`

- when the target object is of type `SomeType`

  `target(SomeType)`

- when the executing code belongs to class `MyClass`

  `within(MyClass)`

- when the join point is in the control flow of a call to a `Test`'s no-argument `main` method

  `cflow(call(void Test.main()))`

Pointcuts compose through the operations `or` ("`||`"), `and` ("`&&`") and `not` ("`!`").

- It is possible to use wildcards. So

  1. `execution(* *(..))`
  2. `call(* set(..))`

  means (1) the execution of any method regardless of return or parameter types, and (2) the call to any method named

   

  set

   

  regardless of return or parameter types -- in case of overloading there may be more than one such

   

  set

   

  method; this pointcut picks out calls to all of them.

  

- You can select elements based on types. For example,

  1. `execution(int *())`
  2. `call(* setY(long))`
  3. `call(* Point.setY(int))`
  4. `call(*.new(int, int))`

  means (1) the execution of any method with no parameters that returns an

   

  int

  , (2) the call to any

   

  setY

   

  method that takes a

   

  long

   

  as an argument, regardless of return type or declaring type, (3) the call to any of

   

  Point

  's

   

  setY

   

  methods that take an

   

  int

   

  as an argument, regardless of return type, and (4) the call to any classes' constructor, so long as it takes exactly two

   

  int

  s as arguments.

  

- You can compose pointcuts. For example,

  1. `target(Point) && call(int *())`
  2. `call(* *(..)) && (within(Line) || within(Point))`
  3. `within(*) && execution(*.new(int))`
  4. `!this(Point) && call(int *(..))`

  means (1) any call to an

   

  int

   

  method with no arguments on an instance of

   

  Point

  , regardless of its name, (2) any call to any method where the call is made from the code in

   

  Point

  's or

   

  Line

  's type declaration, (3) the execution of any constructor taking exactly one

   

  int

   

  argument, regardless of where the call is made from, and (4) any method call to an

   

  int

   

  method when the executing object is any type except

   

  Point

  .

  

- You can select methods and constructors based on their modifiers and on negations of modifiers. For example, you can say:

  1. `call(public * *(..))`
  2. `execution(!static * *(..))`
  3. `execution(public !static * *(..))`

  which means (1) any call to a public method, (2) any execution of a non-static method, and (3) any execution of a public, non-static method.

  

- Pointcuts can also deal with interfaces. For example, given the interface

  ```
  interface MyInterface { ... }
  ```

  the pointcut `call(* MyInterface.*(..))` picks out any call to a method in `MyInterface`'s signature -- that is, any method defined by `MyInterface` or inherited by one of its a supertypes.



### call vs. execution

When methods and constructors run, there are two interesting times associated with them. That is when they are called, and when they actually execute.

AspectJ exposes these times as call and execution join points, respectively, and allows them to be picked out specifically by `call` and `execution` pointcuts.

So what's the difference between these join points? Well, there are a number of differences:

Firstly, the lexical pointcut declarations `within` and `withincode` match differently. At a call join point, the enclosing code is that of the call site. This means that `call(void m()) && withincode(void m())` will only capture directly recursive calls, for example. At an execution join point, however, the program is already executing the method, so the enclosing code is the method itself: `execution(void m()) && withincode(void m())` is the same as `execution(void m())`.

Secondly, the call join point does not capture super calls to non-static methods. This is because such super calls are different in Java, since they don't behave via dynamic dispatch like other calls to non-static methods.

The rule of thumb is that if you want to pick a join point that runs when an actual piece of code runs (as is often the case for tracing), use `execution`, but if you want to pick one that runs when a particular *signature* is called (as is often the case for production aspects), use `call`.



### Pointcut composition

Pointcuts are put together with the operators and (spelled `&&`), or (spelled `||`), and not (spelled `!`). This allows the creation of very powerful pointcuts from the simple building blocks of primitive pointcuts. This composition can be somewhat confusing when used with primitive pointcuts like `cflow` and `cflowbelow`. Here's an example:

`cflow(*`P`*)` picks out each join point in the control flow of the join points picked out by *`P`*. So, pictorially:

```
  P ---------------------
    \
     \  cflow of P
      \
```

What does `cflow(*`P`*) && cflow(*`Q`*)` pick out? Well, it picks out each join point that is in both the control flow of *`P`* and in the control flow of *`Q`*. So...

```
          P ---------------------
            \
             \  cflow of P
              \
               \
                \
  Q -------------\-------
    \             \
     \  cflow of Q \ cflow(P) && cflow(Q)
      \             \
```

Note that *`P`* and *`Q`* might not have any join points in common... but their control flows might have join points in common.

But what does `cflow(*`P`* && *`Q`*)` mean? Well, it means the control flow of those join points that are both picked out by *`P`* and picked out by *`Q`*.

```
   P && Q -------------------
          \
           \ cflow of (P && Q)
            \
```

and if there are *no* join points that are both picked by *`P`* and picked out by *`Q`*, then there's no chance that there are any join points in the control flow of `(*`P`* && *`Q`*)`.

Here's some code that expresses this.

```
public class Test {
    public static void main(String[] args) {
        foo();
    }
    static void foo() {
        goo();
    }
    static void goo() {
        System.out.println("hi");
    }
}

aspect A  {
    pointcut fooPC(): execution(void Test.foo());
    pointcut gooPC(): execution(void Test.goo());
    pointcut printPC(): call(void java.io.PrintStream.println(String));

    before(): cflow(fooPC()) && cflow(gooPC()) && printPC() && !within(A) {
        System.out.println("should occur");
    }

    before(): cflow(fooPC() && gooPC()) && printPC() && !within(A) {
        System.out.println("should not occur");
    }
}
```

The `!within(*`A`*)` pointcut above is required to avoid the `printPC` pointcut applying to the `System.out.println` call in the advice body. If this was not present a recursive call would result as the pointcut would apply to its own advice. (See [the section called “Infinite loops”](https://www.eclipse.org/aspectj/doc/released/progguide/pitfalls-infiniteLoops.html) for more details.)



### Pointcut Parameters

Consider again the first pointcut definition in this chapter:

```
  pointcut setter(): target(Point) &&
                     (call(void setX(int)) ||
                      call(void setY(int)));
```

As we've seen, this pointcut picks out each call to `setX(int)` or `setY(int)` methods where the target is an instance of `Point`. The pointcut is given the name `setters` and no parameters on the left-hand side. An empty parameter list means that none of the context from the join points is published from this pointcut. But consider another version of version of this pointcut definition:

```
  pointcut setter(Point p): target(p) &&
                            (call(void setX(int)) ||
                             call(void setY(int)));
```

This version picks out exactly the same join points. But in this version, the pointcut has one parameter of type `Point`. This means that any advice that uses this pointcut has access to a `Point` from each join point picked out by the pointcut. Inside the pointcut definition this `Point` is named `p` is available, and according to the right-hand side of the definition, that `Point p` comes from the `target` of each matched join point.

Here's another example that illustrates the flexible mechanism for defining pointcut parameters:

```
  pointcut testEquality(Point p): target(Point) &&
                                  args(p) &&
                                  call(boolean equals(Object));
```

This pointcut also has a parameter of type `Point`. Similar to the `setters` pointcut, this means that anyone using this pointcut has access to a `Point` from each join point. But in this case, looking at the right-hand side we find that the object named in the parameters is not the target `Point` object that receives the call; it's the argument (also of type `Point`) passed to the `equals` method when some other `Point` is the target. If we wanted access to both `Point`s, then the pointcut definition that would expose target `Point p1` and argument `Point p2` would be

```
  pointcut testEquality(Point p1, Point p2): target(p1) &&
                                             args(p2) &&
                                             call(boolean equals(Object));
```

Let's look at another variation of the `setters` pointcut:

```
pointcut setter(Point p, int newval): target(p) &&
                                      args(newval) &&
                                      (call(void setX(int)) ||
                                       call(void setY(int)));
```

In this case, a `Point` object and an `int` value are exposed by the named pointcut. Looking at the the right-hand side of the definition, we find that the `Point` object is the target object, and the `int` value is the called method's argument.

The use of pointcut parameters is relatively flexible. The most important rule is that all the pointcut parameters must be bound at every join point picked out by the pointcut. So, for example, the following pointcut definition will result in a compilation error:

```
  pointcut badPointcut(Point p1, Point p2):
      (target(p1) && call(void setX(int))) ||
      (target(p2) && call(void setY(int)));
```

because  , and`p2`is only bound when calling`setY`  .



### Example: `HandleLiveness`

The example below consists of two object classes (plus an exception class) and one aspect. Handle objects delegate their public, non-static operations to their `Partner` objects. The aspect `HandleLiveness` ensures that, before the delegations, the partner exists and is alive, or else it throws an exception.

```
  class Handle {
    Partner partner = new Partner();

    public void foo() { partner.foo(); }
    public void bar(int x) { partner.bar(x); }

    public static void main(String[] args) {
      Handle h1 = new Handle();
      h1.foo();
      h1.bar(2);
    }
  }

  class Partner {
    boolean isAlive() { return true; }
    void foo() { System.out.println("foo"); }
    void bar(int x) { System.out.println("bar " + x); }
  }

  aspect HandleLiveness {
    before(Handle handle): target(handle) && call(public * *(..)) {
      if ( handle.partner == null  || !handle.partner.isAlive() ) {
        throw new DeadPartnerException();
      }
    }
  }

  class DeadPartnerException extends RuntimeException {}
```



### Writing good pointcuts

During compilation, AspectJ processes pointcuts in order to try and optimize matching performance. Examining code and determining if each join point matches (statically or dynamically) a given pointcut is a costly process. (A dynamic match means the match cannot be fully determined from static analysis and a test will be placed in the code to determine if there is an actual match when the code is running). On first encountering a pointcut declaration, AspectJ will rewrite it into an optimal form for the matching process. What does this mean? Basically pointcuts are rewritten in DNF (Disjunctive Normal Form) and the components of the pointcut are sorted such that those components that are cheaper to evaluate are checked first. This means users do not have to worry about understanding the performance of various pointcut designators and may supply them in any order in their pointcut declarations.

However, AspectJ can only work with what it is told, and for optimal performance of matching the user should think about what they are trying to achieve and narrow the search space for matches as much as they can in the definition. Basically there are three kinds of pointcut designator: kinded, scoping and context:

- Kinded designators are those which select a particular kind of join point. For example: execution, get, set, call, handler
- Scoping designators are those which select a group of join points of interest (of probably many kinds). For example: within, withincode
- Contextual designators are those that match (and optionally bind) based on context. For example: this, target, @annotation

A well written pointcut should try and include at least the first two types (kinded and scoping), whilst the contextual designators may be included if wishing to match based on join point context, or bind that context for use in the advice. Supplying either just a kinded designator or just a contextual designator will work but could affect weaving performance (time and memory used) due to all the extra processing and analysis. Scoping designators are very fast to match, they can very quickly dismiss groups of join points that should not be further processed - that is why a good pointcut should always include one if possible.

## Advice

Advice defines pieces of aspect implementation that execute at well-defined points in the execution of the program. Those points can be given either by named pointcuts (like the ones you've seen above) or by anonymous pointcuts. Here is an example of an advice on a named pointcut:

```
  pointcut setter(Point p1, int newval): target(p1) && args(newval)
                                         (call(void setX(int) ||
                                          call(void setY(int)));

  before(Point p1, int newval): setter(p1, newval) {
      System.out.println("About to set something in " + p1 +
                         " to the new value " + newval);
  }
```

And here is exactly the same example, but using an anonymous pointcut:

```
  before(Point p1, int newval): target(p1) && args(newval)
                                (call(void setX(int)) ||
                                 call(void setY(int))) {
      System.out.println("About to set something in " + p1 +
                         " to the new value " + newval);
  }
```

Here are examples of the different advice:

This before advice runs just before the join points picked out by the (anonymous) pointcut:

```
  before(Point p, int x): target(p) && args(x) && call(void setX(int)) {
      if (!p.assertX(x)) return;
  }
```

This after advice runs just after each join point picked out by the (anonymous) pointcut, regardless of whether it returns normally or throws an exception:

```
  after(Point p, int x): target(p) && args(x) && call(void setX(int)) {
      if (!p.assertX(x)) throw new PostConditionViolation();
  }
```

This after returning advice runs just after each join point picked out by the (anonymous) pointcut, but only if it returns normally. The return value can be accessed, and is named `x` here. After the advice runs, the return value is returned:

```
  after(Point p) returning(int x): target(p) && call(int getX()) {
      System.out.println("Returning int value " + x + " for p = " + p);
  }
```

This after throwing advice runs just after each join point picked out by the (anonymous) pointcut, but only when it throws an exception of type `Exception`. Here the exception value can be accessed with the name `e`. The advice re-raises the exception after it's done:

```
  after() throwing(Exception e): target(Point) && call(void setX(int)) {
      System.out.println(e);
  }
```

This around advice traps the execution of the join point; it runs *instead* of the join point. The original action associated with the join point can be invoked through the special `proceed` call:

```
void around(Point p, int x): target(p)
                          && args(x)
                          && call(void setX(int)) {
    if (p.assertX(x)) proceed(p, x);
    p.releaseResources();
}
```

## Inter-type declarations

Aspects can declare members (fields, methods, and constructors) that are owned by other types. These are called inter-type members. Aspects can also declare that other types implement new interfaces or extend a new class. Here are examples of some such inter-type declarations:

This declares that each `Server` has a `boolean` field named `disabled`, initialized to `false`:

```
  private boolean Server.disabled = false;
```

It is declared , which means that it is private*to the aspect*    



This declares that each `Point` has an `int` method named `getX` with no arguments that returns whatever `this.x` is:

```
  public int Point.getX() { return this.x; }
```

Inside the body,   



This publically declares a two-argument constructor for `Point`:

```
  public Point.new(int x, int y) { this.x = x; this.y = y; }
```



This publicly declares that each `Point` has an `int` field named `x`, initialized to zero:

```
  public int Point.x = 0;
```

Because this is publically declared, it is an error if   



This declares that the `Point` class implements the `Comparable` interface:

```
  declare parents: Point implements Comparable;
```

Of course, this will be an error unless  .

This declares that the `Point` class extends the `GeometricObject` class.

```
  declare parents: Point extends GeometricObject;
```



An aspect can have several inter-type declarations. For example, the following declarations

```
  public String Point.name;
  public void Point.setName(String name) { this.name = name; }
```

publicly declare that Point has both a String field    



An inter-type member can only have one target type, but often you may wish to declare the same member on more than one type. This can be done by using an inter-type member in combination with a private interface:

```
  aspect A {
    private interface HasName {}
    declare parents: (Point || Line || Square) implements HasName;

    private String HasName.name;
    public  String HasName.getName()  { return name; }
  }
```

This declares a marker interface , and also declares that any type that is either`Point` , or`Square`implements that interface. It also privately declares that all`HasName`object have a`String`field called`name`    



As you can see from the above example, an aspect can declare that interfaces have fields and methods, even non-constant fields and methods with bodies.



### Inter-type Scope

AspectJ allows private and package-protected (default) inter-type declarations in addition to public inter-type declarations. Private means private in relation to the aspect, not necessarily the target type. So, if an aspect makes a private inter-type declaration of a field

```
  private int Foo.x;
```

Then code in the aspect can refer to 's`x`field, but nobody else can. Similarly, if an aspect makes a package-protected introduction,

```
  int Foo.x;
```

then everything in the aspect's package (which may or may not be `Foo`'s package) can access `x`.



### Example: `PointAssertions`

The example below consists of one class and one aspect. The aspect privately declares the assertion methods of `Point`, `assertX` and `assertY`. It also guards calls to `setX` and `setY` with calls to these assertion methods. The assertion methods are declared privately because other parts of the program (including the code in `Point`) have no business accessing the assert methods. Only the code inside of the aspect can call those methods.

```java
  class Point  {
      int x, y;

      public void setX(int x) { this.x = x; }
      public void setY(int y) { this.y = y; }

      public static void main(String[] args) {
          Point p = new Point();
          p.setX(3); p.setY(333);
      }
  }

  aspect PointAssertions {

      private boolean Point.assertX(int x) {
          return (x <= 100 && x >= 0);
      }
      private boolean Point.assertY(int y) {
          return (y <= 100 && y >= 0);
      }

      before(Point p, int x): target(p) && args(x) && call(void setX(int)) {
          if (!p.assertX(x)) {
              System.out.println("Illegal value for x"); return;
          }
      }
      before(Point p, int y): target(p) && args(y) && call(void setY(int)) {
          if (!p.assertY(y)) {
              System.out.println("Illegal value for y"); return;
          }
      }
  }
```

## thisJoinPoint

AspectJ provides a special reference variable, `thisJoinPoint`, that contains reflective information about the current join point for the advice to use. The `thisJoinPoint` variable can only be used in the context of advice, just like `this` can only be used in the context of non-static methods and variable initializers. In advice, `thisJoinPoint` is an object of type [`org.aspectj.lang.JoinPoint`](https://www.eclipse.org/aspectj/doc/released/api/org/aspectj/lang/JoinPoint.html).

One way to use it is simply to print it out. Like all Java objects, `thisJoinPoint` has a `toString()` method that makes quick-and-dirty tracing easy:

```
  aspect TraceNonStaticMethods {
      before(Point p): target(p) && call(* *(..)) {
          System.out.println("Entering " + thisJoinPoint + " in " + p);
      }
  }
```

The type of `thisJoinPoint` includes a rich reflective class hierarchy of signatures, and can be used to access both static and dynamic information about join points such as the arguments of the join point:

```
  thisJoinPoint.getArgs()
```

In addition, it holds an object consisting of all the static information about the join point such as corresponding line number and static signature:

```
  thisJoinPoint.getStaticPart()
```

If you only need the static information about the join point, you may access the static part of the join point directly with the special variable `thisJoinPointStaticPart``thisJoinPointStaticPart``thisJoinPoint`



It is always the case that

```
   thisJoinPointStaticPart == thisJoinPoint.getStaticPart()

   thisJoinPoint.getKind() == thisJoinPointStaticPart.getKind()
   thisJoinPoint.getSignature() == thisJoinPointStaticPart.getSignature()
   thisJoinPoint.getSourceLocation() == thisJoinPointStaticPart.getSourceLocation()
```

One more reflective variable is available: `thisEnclosingJoinPointStaticPart`. This, like `thisJoinPointStaticPart`, only holds the static part of a join point, but it is not the current but the enclosing join point. So, for example, it is possible to print out the calling source location (if available) with

```
   before() : execution (* *(..)) {
     System.err.println(thisEnclosingJoinPointStaticPart.getSourceLocation())
   }
```

# Examples

## Introduction

This chapter consists entirely of examples of AspectJ use.

The examples can be grouped into four categories:

| **technique**   | Examples which illustrate how to use one or more features of the language. |
| --------------- | ------------------------------------------------------------ |
| **development** | Examples of using AspectJ during the development phase of a project. |
| **production**  | Examples of using AspectJ to provide functionality in an application. |
| **reusable**    | Examples of reuse of aspects and pointcuts.                  |

## Obtaining, Compiling and Running the Examples

The examples source code is part of the AspectJ distribution which may be downloaded from the AspectJ project page ( http://eclipse.org/aspectj ).

Compiling most examples is straightforward. Go the `*`InstallDir`*/examples` directory, and look for a `.lst` file in one of the example subdirectories. Use the `-arglist` option to `ajc` to compile the example. For instance, to compile the telecom example with billing, type

```
ajc -argfile telecom/billing.lst
```

To run the examples, your classpath must include the AspectJ run-time Java archive (`aspectjrt.jar`). You may either set the `CLASSPATH` environment variable or use the `-classpath` command line option to the Java interpreter:

```
(In Unix use a : in the CLASSPATH)
java -classpath ".:InstallDir/lib/aspectjrt.jar" telecom.billingSimulation
(In Windows use a ; in the CLASSPATH)
java -classpath ".;InstallDir/lib/aspectjrt.jar" telecom.billingSimulation
```

