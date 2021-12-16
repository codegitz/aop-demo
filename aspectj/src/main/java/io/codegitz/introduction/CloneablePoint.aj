package io.codegitz.introduction;

public aspect CloneablePoint {

    declare parents: Point implements Cloneable;

    @Override
    public Object Point.clone() throws CloneNotSupportedException {
        // we choose to bring all fields up to date before cloning.
        makeRectangular();
        makePolar();
        return super.clone();
    }

    public static void main(String[] args){
        Point p1 = new Point();
        Point p2 = null;

        p1.setPolar(Math.PI, 1.0);
        try {
            p2 = (Point)p1.clone();
        } catch (CloneNotSupportedException e) {}
        System.out.println("p1 =" + p1 );
        System.out.println("p2 =" + p2 );

        p1.rotate(Math.PI / -2);
        System.out.println("p1 =" + p1 );
        System.out.println("p2 =" + p2 );
    }
}
