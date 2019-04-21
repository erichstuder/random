package erichstuder.robotsensors;

import android.content.Context;
import android.graphics.Color;
import android.util.Log;

public class EdgeFilter extends Block{
	private final String name = "Edge Filter";

	final int NON_TRANSPARENT = Color.BLACK;
	final float R_WEIGHT = 0.2989f;
	final float G_WEIGHT = 0.5870f;
	final float B_WEIGHT = 0.1140f;
	
	Context context = null;
	
	public EdgeFilter(Context context){
		super(context);
		this.setText(name);
		this.context = context;
	}
	
	public Object doFilter(int[] image, int width, int height){
		final int NR_OF_PIXELS = image.length;
		int r,g,b,pixel,gray,h,v;
		int val00, val01, val02, val10, val12, val20, val21, val22;
		int[] ret = new int[NR_OF_PIXELS];
		
		int xl,xr,yuW,ydW;
		
		//Math m = Math.;

	    //   Horizontal                               Vertical
	    //   -1  0   1        pix00 pix01 pix02        1  2  1
	    //   -2  0   2  <-->  pix10 pix11 pix12  <-->  0  0  0
	    //   -1  0   1        pix20 pix21 pix22       -1 -2 -1

		for(int i=0; i<NR_OF_PIXELS; i++){
			//image[i]=image[i] & BLUE_MASK;
			pixel = image[i];
			r = (int)(((pixel >> 16) & 0xFF) * R_WEIGHT);
			g = (int)(((pixel >> 8 ) & 0xFF) * G_WEIGHT);
			b = (int)(((pixel      ) & 0xFF) * B_WEIGHT);
			gray = r+g+b;
			image[i] = gray;//Achtung: Dies ist kein anzeigbares Bild mehr!!!
		}
		
		for(int x=1; x<width-1; x++){
			for(int y=1; y<height-1; y++){
				//index = x+y*WIDTH;
				xl = x-1;
				xr = x+1;
				yuW =(y-1)*width;
				ydW =(y+1)*width;
				
				val00 = image[xl + yuW];
				val01 = image[x  + yuW];
				val02 = image[xr + yuW];
				
				val10 = image[xl + y * width];
				val12 = image[xr + y * width];
				
				val20 = image[xl + ydW];
				val21 = image[x  + ydW];
				val22 = image[xr + ydW];
				
				//pixel = ((val02-val00) + 2*(val12-val10) + (val22-val20) + (val00-val20) + 2*(val01-val21) + (val02-val22))/8;
				//pixel = (val02 + val12 - val10 - val20 + val01 - val21)/3;
				
				h = (val02-val00) + 2*(val12-val10) + (val22-val20);
				v = (val00-val20) + 2*(val01-val21) + (val02-val22);
				
				pixel = (int)(Math.sqrt(h*h+v*v)/5);//kann es ein, dass der maximale Wert bei 4.47 * 255 liegt??
				//pixel = (int)((h*h+v*v)/25);
				
				//pixel = Math.abs(pixel);
				
				//if(pixel<0){pixel*=-1;}
				
				image[xl + yuW] = NON_TRANSPARENT+(pixel<<16)+(pixel<<8)+pixel;
				//ret[x+y*width] = Color.BLUE;
				//Log.v("uncaught exception",""+pixel);
			}
			
		}
		//image = ret;
		return null;
	}
	
	public String getName(){
		return name;
	}

}
