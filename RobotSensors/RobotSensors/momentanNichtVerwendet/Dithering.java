package erichstuder.robotsensors;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;

public class Dithering extends Block {

	private final String name = "Dithering"; //must be overridden
	
	final float R_WEIGHT = 0.2989f;
	final float G_WEIGHT = 0.5870f;
	final float B_WEIGHT = 0.1140f;
	
	public Dithering(Context context) {
		super(context);
		super.setName(name);
	}


	@Override
	public Object doFilter(int[] image, int width, int height) {
		final int THRESHOLD = 128;
		int r,g,b,pixel,brightness,gray,index;
		int[][] accu = new int[width][height];
		final int NR_OF_PIXELS = image.length;
		
		//toGray
		for(int i=0; i<NR_OF_PIXELS; i++){
			//image[i]=image[i] & BLUE_MASK;
			pixel = image[i];
			r = (int)(((pixel >> 16) & 0xFF) * R_WEIGHT);
			g = (int)(((pixel >> 8 ) & 0xFF) * G_WEIGHT);
			b = (int)(((pixel      ) & 0xFF) * B_WEIGHT);
			gray = r+g+b;
			image[i] = gray;//Achtung: Dies ist kein anzeigbares Bild mehr!!!
		}
		
		//dithering
		//aussenrum wird ein rand von 1p Breite nicht berücksichtigt!
		for(int x=1; x<width-1; x++){
			for(int y=1; y<height-1; y++){
				
				index = x+y*width;
				
				pixel = image[index];

				b = pixel & 0xFF; //r=g=b
				brightness = b+accu[x][y];
				
				if(brightness < THRESHOLD){
					
					//bitmap.setPixel(x, y, Color.BLACK);
					image[index] = Color.BLACK;
					
					//try{
						accu[x+1][y  ] += (brightness*7)/16;
					//}catch(Exception e){}
					
					//try{
						accu[x-1][y+1] += (brightness*3)/16;
					//}catch(Exception e){}
					
					//try{
						accu[x  ][y+1] += (brightness*5)/16;
					//}catch(Exception e){}
					
					//try{
						accu[x+1][y+1] += (brightness  )/16;
					//}catch(Exception e){}
					
					
                    /*PointOut(x,59-y);
                    if(x<59        ) picture[(x+1)+ y   *60] += (picture[x+y*60]*7)/16;
					if(x>0  && y<59) picture[(x-1)+(y+1)*60] += (picture[x+y*60]*3)/16;
					if(        y<59) picture[ x   +(y+1)*60] += (picture[x+y*60]*5)/16;
					if(x<59 && y<59) picture[(x+1)+(y+1)*60] += (picture[x+y*60]  )/16;*/

	 			}else{
	 				//bitmap.setPixel(x, y, Color.WHITE);
	 				image[index] = Color.WHITE;
	 				
	 				//brightness = 255-brightness;
	 				//brightness = -brightness;
	 				
					//try{
						//bitmap.setPixel(x+1, y  , Color.red(bitmap.getPixel(x+1, y  ))+((brightness*7)/16));
						accu[x+1][y  ] -= (brightness*7)/16;
					//}catch(Exception e){}
					
					//try{
						//bitmap.setPixel(x-1, y+1, Color.red(bitmap.getPixel(x-1, y+1))+((brightness*3)/16));
						accu[x-1][y+1] -= (brightness*3)/16;
					//}catch(Exception e){}
					
					//try{
						//bitmap.setPixel(x  , y+1, Color.red(bitmap.getPixel(x  , y+1))+((brightness*5)/16));
						accu[x  ][y+1] -= (brightness*5)/16;
					//}catch(Exception e){}
					
					//try{
						//bitmap.setPixel(x+1, y+1, Color.red(bitmap.getPixel(x+1, y+1))+((brightness  )/16));
						accu[x+1][y+1] -= (brightness  )/16;
					//}catch(Exception e){}
	 				
	 				
                 	/*if(x<59        ) picture[(x+1)+ y   *60] -= (((0xFF - picture[x+y*60])*7)/16);
					if(x>0  && y<59) picture[(x-1)+(y+1)*60] -= (((0xFF - picture[x+y*60])*3)/16);
					if(        y<59) picture[ x   +(y+1)*60] -= (((0xFF - picture[x+y*60])*5)/16);
					if(x<59 && y<59) picture[(x+1)+(y+1)*60] -= (((0xFF - picture[x+y*60])  )/16);*/
				}
			}
		}
		return null;
	}
}


