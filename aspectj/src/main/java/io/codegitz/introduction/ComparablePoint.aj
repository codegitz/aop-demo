package io.codegitz.introduction;

public aspect ComparablePoint {

   declare parents: Point implements Comparable;

   public int Point.compareTo(Object o) {
      return (int) (this.getRho() - ((Point)o).getRho());
   }

   public static void main(String[] args){
      Point p1 = new Point();
      Point p2 = new Point();

      System.out.println("p1 =?= p2 :" + p1.compareTo(p2));

      p1.setRectangular(2,5);
      p2.setRectangular(2,5);
      System.out.println("p1 =?= p2 :" + p1.compareTo(p2));

      p2.setRectangular(3,6);
      System.out.println("p1 =?= p2 :" + p1.compareTo(p2));

      p1.setPolar(Math.PI, 4);
      p2.setPolar(Math.PI, 4);
      System.out.println("p1 =?= p2 :" + p1.compareTo(p2));

      p1.rotate(Math.PI / 4.0);
      System.out.println("p1 =?= p2 :" + p1.compareTo(p2));

      p1.offset(1,1);
      System.out.println("p1 =?= p2 :" + p1.compareTo(p2));
   }
}

