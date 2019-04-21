package erichstuder.robotsensors;

import java.util.ArrayList;

import android.app.Activity;
import android.content.Context;

//this class knows all possible Blocks.
//creation of Blocks happens through this class.



/*private static Block[] blocks = {
	new BlueFilter(),
	new RedFilter(),
	new GreenFilter()

};*/

public class BlockManager {

	//private ArrayList<Block> blocks = null;
	
	/*public BlockManager(Context context){

		//Add here every possible Block, it's the only place you have to.
		blocks = new ArrayList<Block>();
		blocks.add(new RedFilter(context));
		blocks.add(new GreenFilter(context));
		blocks.add(new BlueFilter(context));
		
	}*/
	
	
	private BlockManager(){} //blockieren des Konstruktors	(korrekt??)
	
	public static ArrayList<Block> getBlocks(Context context){
		ArrayList<Block> blocks = new ArrayList<Block>();
		
		//Add here every possible Block, it's the only place you have to.
		blocks.add(new RedPassFilter(context));
		blocks.add(new GreenPassFilter(context));
		blocks.add(new BluePassFilter(context));
		blocks.add(new ToGrayFilter(context));
		blocks.add(new EdgeFilter(context));
		blocks.add(new RedStopFilter(context));
		blocks.add(new GreenStopFilter(context));
		blocks.add(new BlueStopFilter(context));
		blocks.add(new Gain2xFilter(context));
		blocks.add(new Threshold50Percent(context));
		blocks.add(new Dithering(context));
		/////////////////////////////////blocks.add(new BrightestPoint(context));
		blocks.add(new LineFollower(context));
		
		
		
		return blocks;
	} 
	
	//returns an Array in witch every possible Block is contained once.
	/*public ArrayList<Block> getBlocks(){
		return blocks;
	}*/
	
	public static Block getCopy(Block block){
		ArrayList<Block> blocks = getBlocks(block.getContext());
		for(Block b:blocks){
			if(b.getName() == block.getName()){
				return b;
			}
		}
		return null;
	}

}

