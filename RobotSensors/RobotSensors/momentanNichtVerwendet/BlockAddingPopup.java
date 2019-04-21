package erichstuder.robotsensors;

import java.util.ArrayList;

import erichstuder.robotsensors.R;
import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;

public class BlockAddingPopup extends PopupWindow implements OnClickListener {
	private OnBlockChosenListener callback;
	//private Activity activity;
	
	BlockManager blockManager = null;
	
	//private PopupWindow popupWindow;
	
	public BlockAddingPopup(Activity activity){
		super();
		LayoutInflater layoutInflater = activity.getLayoutInflater();
	    RelativeLayout popupLayout = (RelativeLayout)layoutInflater.inflate(R.layout.block_adding_popup, null);
	    addBlocks(popupLayout,2,activity.getApplicationContext());
	    
	    this.setContentView(popupLayout);
	    this.setWidth(LayoutParams.WRAP_CONTENT);
	    this.setHeight(LayoutParams.WRAP_CONTENT);
	    
	    
	    
	    //this.
	    //Drawable background = 
	    
	    //this.getBackground().setAlpha(100);
	    
	    //Log.v("BlockAddingPopup",""+background);
	    //background.setAlpha(100);
	    //this.setBackgroundDrawable(background);
	    
	    
	    //blockManager = new BlockManager(activity);
	    
	    //popupWindow = new PopupWindow(popupLayout,LayoutParams.WRAP_CONTENT,LayoutParams.WRAP_CONTENT);
	    //popupWindow.showAsDropDown(activity.findViewById(R.id.menuItemAddBlock));
	    
		
	}
	
	public void setOnBlockChosenListener(OnBlockChosenListener callback) {
		this.callback = callback;
	}
	
	private void addBlocks(RelativeLayout layout, int horizontal, Context context){
		
		ArrayList<Block> blocks = BlockManager.getBlocks(context);

		for(int i=0; i<blocks.size(); i++){
			blocks.get(i).setOnClickListener(this);
			blocks.get(i).setId(i+1); //id 0 geht nicht, weil weiss nicht mehr
		}
		
		layout.addView(blocks.get(0));
		for(int i=1; i<blocks.size(); i++){
			RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT,RelativeLayout.LayoutParams.WRAP_CONTENT);
			if(i % horizontal != 0){
				params.addRule(RelativeLayout.RIGHT_OF,blocks.get(i-1).getId());
				if(i>=horizontal){
					params.addRule(RelativeLayout.BELOW,blocks.get(i-horizontal).getId());
				}
				layout.addView(blocks.get(i),params);
			}
			else{
				params.addRule(RelativeLayout.BELOW,blocks.get(i-horizontal).getId());
				layout.addView(blocks.get(i),params);
			}
		}
	}
	
	public void onClick(View v){
		//Log.v("Hallo22", ""+v.getClass());
		
		
		//if(v.getClass() != Block.class) return;
		
		//((ViewGroup)v.getParent()).removeView(v);
		this.dismiss();				
		
		//Block block = BlockManager.
		
		Block block = BlockManager.getCopy((Block)v);
		
		//LayoutParams params = new LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT, 1.0f);
		//v.setLayoutParams(params);
	    //callback.onBlockChosen(v);
		
		LayoutParams params = new LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT, 1.0f);
		block.setLayoutParams(params);
		callback.onBlockChosen(block);
	}

	public interface OnBlockChosenListener{
		public void onBlockChosen(View block);
	}
}


