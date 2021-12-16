package io.codegitz;

import io.codegitz.entity.Point;
import io.codegitz.service.DemoService;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

/**
 * @author Codegitz
 * @date 2021/12/15 17:32
 **/
public class AspectjTest {
    @Test
    public void testDemoServiceAspectJ() {
        DemoService demoService = new DemoService();
        demoService.sayHello();
    }

    @Test
    public void testThisJoinPoint() {
        Point point = new Point();
        point.setX(1);
        Assertions.assertEquals(1,point.getX());
    }
}
