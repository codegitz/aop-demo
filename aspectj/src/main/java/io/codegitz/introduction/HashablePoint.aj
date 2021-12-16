package io.codegitz.introduction;

import java.util.Hashtable;

public aspect HashablePoint {

   @Override
   public int Point.hashCode() {
      return (int) (getX() + getY() % Integer.MAX_VALUE);
   }

   @Override
   public boolean Point.equals(Object o) {
      if (o == this) { return true; }
      if (!(o instanceof Point)) { return false; }
      Point other = (Point)o;
      return (getX() == other.getX()) && (getY() == other.getY());
   }

   public static void main(String[] args) {
      Hashtable h = new Hashtable();
      Point p1 = new Point();

      p1.setRectangular(10, 10);
      Point p2 = new Point();

      p2.setRectangular(10, 10);

      System.out.println("p1 = " + p1);
      System.out.println("p2 = " + p2);
      System.out.println("p1.hashCode() = " + p1.hashCode());
      System.out.println("p2.hashCode() = " + p2.hashCode());

      h.put(p1, "P1");
      System.out.println("Got: " + h.get(p2));
   }
}
