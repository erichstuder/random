package erichstuder.robotsensors;

import android.graphics.Bitmap;
import android.graphics.Bitmap.Config;
import android.graphics.YuvImage;
import android.util.Log;

public class UniversalImage {
	
	byte[] yuvData = null;
	Bitmap bitmap = null;
	Thread yuvToBitmap = null;
	//Thread bitmapToYuv = null;
	
	
	public UniversalImage(final byte[] yuvData, final int width, final int height){
		this.yuvData = yuvData;
		
		yuvToBitmap = new Thread(){
			public void run() {
				int[] argb = ImageToolbox.convertYUV420_NV21toRGB8888(yuvData, width, height);
				//Bitmap.createBitmap(argb, width, height, Config.ARGB_8888);
				bitmap = Bitmap.createBitmap(width, height, Config.ARGB_8888);
				bitmap.setPixels(argb, 0, width, 0, 0, width, height);
				
                //this.notifyAll();
            }
		};
		yuvToBitmap.start();
		//t.is
	}
	
	public Bitmap getBitmap(){
		if(yuvToBitmap!= null && yuvToBitmap.isAlive()){
			try {
				Log.v("erich","join");
				yuvToBitmap.join();
				Log.v("erich","join end");
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return bitmap;
	}
}
