package erichstuder.robotsensors;

import android.content.Context;
import android.graphics.Color;

public class BluePassFilter extends Block{
	
	private final String name = "Blue Pass Filter";
	final int BLUE_MASK = Color.BLUE;
	//Activity activity = null;
	//Context context = null;
	
	public BluePassFilter(Context context){
		super(context);
		this.setText(name);
		//this.context = context;
	}
	
	public Object doFilter(int[] image, int width, int height){
		final int NR_OF_PIXELS = image.length;
		
		for(int i=0; i<NR_OF_PIXELS; i++){
			image[i]=image[i] & BLUE_MASK;
		}
		
		return null;
	}
	
	
	public String getName(){
		return name;
	}
	
}