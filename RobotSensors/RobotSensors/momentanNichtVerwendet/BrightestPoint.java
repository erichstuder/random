package erichstuder.robotsensors;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Point;

public class BrightestPoint /*extends Block*/{
	
	private final String name = "Brightest Point";
	
	final static float R_WEIGHT = 0.2989f;
	final static float G_WEIGHT = 0.5870f;
	final static float B_WEIGHT = 0.1140f;

	public BrightestPoint(/*Context context*/) {
		//super(context);
		//super.setName(name);
	}

	public static float doFilter(int[] image, int width, int height, Point pt) {
		final int NR_OF_PIXELS = image.length;
		float r,g,b,grey, brightestValue;
		int pixel;
		int brightestX, brightestY, brightestIndex;
		
		brightestIndex=0;
		brightestValue=0;

		for(int i=0; i<NR_OF_PIXELS; i++){
			pixel = image[i];
			r = ((pixel >> 16) & 0xFF) * R_WEIGHT;
			g = ((pixel >> 8 ) & 0xFF) * G_WEIGHT;
			b = ((pixel      ) & 0xFF) * B_WEIGHT;
			grey = r+g+b;
			
			if(grey > brightestValue){
				brightestValue = grey;
				brightestIndex = i;
			}
		}
		
		brightestX = brightestIndex % width;
		brightestY = brightestIndex / width;
		
		Bitmap bitmap = Bitmap.createBitmap(width,height,Bitmap.Config.ARGB_8888);
		bitmap.setPixels(image, 0, width, 0, 0, width, height);
		Canvas canvas = new Canvas(bitmap);
		
		Paint paint = new Paint();
		paint.setColor(Color.RED);
		paint.setStyle(Paint.Style.STROKE);
		paint.setStrokeWidth(10);
		canvas.drawCircle(brightestX, brightestY, 20, paint);
		/*canvas.drawCircle(0, 0, 20, paint);
		canvas.drawCircle(0, height, 20, paint);
		canvas.drawCircle(width, 0, 20, paint);
		canvas.drawCircle(width, height, 20, paint);*/
		
		
		bitmap.getPixels(image, 0, width, 0, 0, width, height);
		
		//if(intensity != null){
			//intensity = Float.valueOf(brightestValue);
			
		//}
		if(pt!=null){
			pt.set(brightestX, brightestY);
		}
		return brightestValue;

//		Integer[] ret = {brightestX,
//				         brightestY,
//				         width,
//				         height,
//				         (int)brightestValue};
//		
//		return ret;
	}
}
