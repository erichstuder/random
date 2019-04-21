package erichstuder.robotsensors;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;

public class GreenPassFilter extends Block{

	private final String name = "Green Pass Filter";
	final int GREEN_MASK = Color.GREEN;
	//Activity activity = null;
	Context context = null;
	
	public GreenPassFilter(Context context){
		super(context);
		this.setText(name);
		this.context = context;
	}
	
	public Object doFilter(int[] image, int width, int height){
		final int NR_OF_PIXELS = image.length;
		
		for(int i=0; i<NR_OF_PIXELS; i++){
			image[i]=image[i] & GREEN_MASK;
		}
		
		return null;
	}
	
	
	public String getName(){
		return name;
	}
	
}