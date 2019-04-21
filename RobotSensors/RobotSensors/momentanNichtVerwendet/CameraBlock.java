package erichstuder.robotsensors;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;

public class CameraBlock extends Block{
	private final String name = "Camera Block";
	
	//Feld: isPlacable=false;
	
	//Activity activity = null;
	//Context context = null;
	
	public CameraBlock(Context context){
		super(context);
		this.setText(name);
		//this.context = context;
	}
		
	public Object doFilter(int[] image, int width, int height){ return null; }
	
	
	public String getName(){
		return name;
	}
}
