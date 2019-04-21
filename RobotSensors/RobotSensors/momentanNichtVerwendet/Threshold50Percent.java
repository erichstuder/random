package erichstuder.robotsensors;

import android.content.Context;
import android.graphics.Color;

public class Threshold50Percent extends Block {
	
	private final String name = "Threshold 50%";
	final float R_WEIGHT = 0.2989f;
	final float G_WEIGHT = 0.5870f;
	final float B_WEIGHT = 0.1140f;
	Context context = null;
	
	public Threshold50Percent(Context context){
		super(context);
		this.setText(name);
		this.context = context;
	}

	@Override
	public String getName() {
		return name;
	}

	
	@Override
	public Object doFilter(int[] image, int width, int height) {
		final int NR_OF_PIXELS = image.length;
		int r,g,b,pixel,gray;
		
		for(int i=0; i<NR_OF_PIXELS; i++){
			//image[i]=image[i] & BLUE_MASK;
			pixel = image[i];
			r = (int)(((pixel >> 16) & 0xFF) * R_WEIGHT);
			g = (int)(((pixel >> 8 ) & 0xFF) * G_WEIGHT);
			b = (int)(((pixel      ) & 0xFF) * B_WEIGHT);
			gray = r+g+b;
			if(gray > 127){
				image[i] = Color.WHITE;
			}else{
				image[i] = Color.BLACK;
			}
		}
		
		return null;
	}
	
	
}
