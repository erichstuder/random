package erichstuder.robotsensors;

import android.content.Context;
import android.graphics.Color;
import android.graphics.Point;
import android.util.AttributeSet;
import android.widget.Button;


public abstract class Block extends Button{
	
	private String name = null; //must be overridden
	Context context = null;

	public Block(Context context)
	{
		super(context);
		this.setText(name);
		this.context = context;
		//Drawable d = this.getBackground();
		
	}
	
	//blocked
	private Block(Context context, AttributeSet attrs)
	{
		super(context, attrs);	
	}
	
	//blocked
	private Block(Context context, AttributeSet attrs, int defStyle)
	{
		super(context, attrs, defStyle);	
	}
	
	protected void setName(String name){
		this.setText(name);
		this.name = name;
	}
	
	public String getName(){return name;}
	
	public void highlightAsPreview(boolean onOff){
		if(onOff == true){
			this.setText(this.getName() + " (Preview)");
		}else{
			this.setText(this.getName());
		}
	}
	
	public abstract Object doFilter(int[] image, int width, int height);
}
