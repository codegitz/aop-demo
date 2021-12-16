package io.codegitz.introduction;

/**
 * @author Codegitz
 * @date 2021/12/16 18:21
 **/
public class Point {

    protected double x = 0;
    protected double y = 0;
    protected double theta = 0;
    protected double rho = 0;

    protected boolean polar = true;
    protected boolean rectangular = true;

    public double getX(){
        makeRectangular();
        return x;
    }

    public double getY(){
        makeRectangular();
        return y;
    }

    public double getTheta(){
        makePolar();
        return theta;
    }

    public double getRho(){
        makePolar();
        return rho;
    }

    public void setRectangular(double newX, double newY){
        x = newX;
        y = newY;
        rectangular = true;
        polar = false;
    }

    public void setPolar(double newTheta, double newRho){
        theta = newTheta;
        rho = newRho;
        rectangular = false;
        polar = true;
    }

    public void rotate(double angle){
        setPolar(theta + angle, rho);
    }

    public void offset(double deltaX, double deltaY){
        setRectangular(x + deltaX, y + deltaY);
    }

    protected void makePolar(){
        if (!polar){
            theta = Math.atan2(y,x);
            rho = y / Math.sin(theta);
            polar = true;
        }
    }

    protected void makeRectangular(){
        if (!rectangular) {
            y = rho * Math.sin(theta);
            x = rho * Math.cos(theta);
            rectangular = true;
        }
    }

    @Override
    public String toString(){
        return "(" + getX() + ", " + getY() + ")["
                + getTheta() + " : " + getRho() + "]";
    }

    public static void main(String[] args){
        Point p1 = new Point();
        System.out.println("p1 =" + p1);
        p1.setRectangular(5,2);
        System.out.println("p1 =" + p1);
        p1.setPolar( Math.PI / 4.0 , 1.0);
        System.out.println("p1 =" + p1);
        p1.setPolar( 0.3805 , 5.385);
        System.out.println("p1 =" + p1);
    }
}
