package erichstuder.robotsensors;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;

public class LineFollower extends Block{
	
	private final String name = "Line Follower";
	
	final float R_WEIGHT = 0.2989f;
	final float G_WEIGHT = 0.5870f;
	final float B_WEIGHT = 0.1140f;

	public LineFollower(Context context) {
		super(context);
		super.setName(name);
	}

	@Override
	public Object doFilter(int[] image, int width, int height) {

		//final int NR_OF_PIXELS = image.length;
		float r,g,b,gray, darkestValue;
		int pixel;
		int darkestX=0, darkestY=0;
		
		//darkestIndex=0;
		darkestValue=10000;//maximum sollte etwa 255 sein

		//es wird nur ein Fenster am unteren rand der Kamera betrachtet.
		//der Rest wird schwarz.
		for(int x=0; x<width; x++){
			for(int y=height-1; y>=0; y--){//von unten nach oben das bild durchsuche, dadurch ist der gefundene Punkt auch eher unten. (Bei mehreren gleich dunklen Punkten)
				if(y > 0.8*height && x > 0.3*width && x < 0.7*width){
					pixel = image[x+width*y];
					r = ((pixel >> 16) & 0xFF) * R_WEIGHT;
					g = ((pixel >> 8 ) & 0xFF) * G_WEIGHT;
					b = ((pixel      ) & 0xFF) * B_WEIGHT;
					gray = r+g+b;
					
					if(gray < darkestValue){
						darkestValue = gray;
						darkestX = x;
						darkestY = y;
					}
				}
			}
		}

		Bitmap bitmap = Bitmap.createBitmap(width,height,Bitmap.Config.ARGB_8888);
		bitmap.setPixels(image, 0, width, 0, 0, width, height);
		Canvas canvas = new Canvas(bitmap);
		
		Paint paint = new Paint();
		paint.setColor(Color.RED);
		paint.setStyle(Paint.Style.STROKE);
		paint.setStrokeWidth(width/150);//Bildgrössenunabhängig
		canvas.drawCircle(darkestX, darkestY, 20, paint);
		
		//paint.setStrokeWidth(width/150);
		canvas.drawRect((int)(0.3*width), (int)(0.8*height), (int)(0.7*width), height, paint);
		
		//canvas.drawCircle(0, 0, 20, paint);
		
		bitmap.getPixels(image, 0, width, 0, 0, width, height);

		Integer[] ret = {darkestX,
				         darkestY,
				         width,
				         height,
				         (int)darkestValue};
		
		return ret;
	}
}
