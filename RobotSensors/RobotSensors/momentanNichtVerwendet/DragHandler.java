package erichstuder.robotsensors;

import android.app.Activity;
import android.content.Context;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Display;
import android.view.DragEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnDragListener;
import android.widget.LinearLayout;

public class DragHandler implements OnDragListener{
	private enum Position{
		TOP, BOTTOM, MIDDLE_LEFT, MIDDLE_RIGHT
	}
	
	private StopWatch stopWatch;
	
	private DisplayMetrics displayMetrics;
	private Activity activity;
	
	//for the fingerSpeed
	private float oldX;
	private float oldY;
	private long  oldMillis;
	private float fingerSpeed;
	
	Position positionAtStart;
	View subViewAtStart;
	int oldAction;
	

	public DragHandler(Activity activity){
		this.activity = activity;
		
		this.displayMetrics = new DisplayMetrics();
		activity.getWindowManager().getDefaultDisplay().getMetrics(displayMetrics);
		
		oldX = 0;
		oldY = 0;
		oldMillis = 0;
		fingerSpeed = 0;
		
		stopWatch = new StopWatch();
	}
	
	Position findPositionOnView(View view, DragEvent event){
		int viewWidth = view.getWidth();
		int viewHeight = view.getHeight();
		float eventX = event.getX();//links ist null
		float eventY = event.getY();//oben ist null
		
		if(eventY > viewHeight*0.8){
			return Position.BOTTOM;
		}else if(eventY < viewHeight*0.2){
			return Position.TOP;
		}else if(eventX < viewWidth/2){
			return Position.MIDDLE_LEFT;
		}else{
			return Position.MIDDLE_RIGHT;
		}	
	}
	
	//subView: View that lies under my finger
	//event: Contains also the dragged view.
	public boolean onDrag (View subView, DragEvent event){
		/*
		 * Mittels drag sind 3 Operationen möglich:
		 * 
		 * - einen Block rausschmeissen (löschen). Dazu wird die Geschwindigkeit des Fingers aufgezeichnet.
		 * Überschreitet diese beim Loslassen einen Schwellwert, wird der Block gelöscht.
		 * 
		 * - einen Block zu anderen Blöcken auf einer Zeile hinzusetzen.
		 * 
		 * - einen Block alleine auf eine neue Zeile setzen.
		 */

		//Element das gerade gezogen wird.
		View dragedView = (View)event.getLocalState();
		int action = event.getAction();
		switch(action){
			case DragEvent.ACTION_DRAG_STARTED:
				//Vorbereitungen für Drag-Geschwindigkeitsmessung
				oldX = event.getX();
				oldY = event.getY();
				oldMillis = System.currentTimeMillis();
				fingerSpeed = 0;
			break;
			
			case DragEvent.ACTION_DRAG_ENTERED:
			break;
			
			case DragEvent.ACTION_DRAG_LOCATION: //Drag ist über einem Objekt das auf den callback hört
				//fingerSpeed
				long millis = System.currentTimeMillis();
				int[] pt = new int[2];
				subView.getLocationOnScreen(pt);
				float x = pt[0] + event.getX();
				float y = pt[1] + event.getY();
				
				float s = (float)Math.sqrt(Math.pow(oldX - x,2) + Math.pow(oldY - y,2)); //geometrische Addition
				
				//DisplayMetrics displayMetrics = new DisplayMetrics();
				//getWindowManager().getDefaultDisplay().getMetrics(displayMetrics);
				
				/* Der Finger soll für das Rausschmeissen eines Elements immer gleich schnell sein.
				 * Die Geschwindigkeit wird zunächst in Pixel/Millisekunde berechnet.
				 * Danach wird sie durch die Dichte der Pixel korrigiert.
				 * Bei höherer Pixeldichte müssen die Pixel/Millisekunde höher sein, um das Element rauszuschmeissen.
				 * Dies entspricht dann der gleichen absoluten Finger-Geschwindigkeit auf dem Display. */
				fingerSpeed = s/(millis-oldMillis) * displayMetrics.density;			
				
				oldX = x;
				oldY = y;
				oldMillis = millis;
				//fingerSpeed
				
				Position position = findPositionOnView(subView, event);
				switch(position){
					case TOP:
					case BOTTOM:
						if(!stopWatch.isRunning()){
							stopWatch.reset();
							stopWatch.start();
							positionAtStart = position;
							subViewAtStart = subView;
						}
						
						if(stopWatch.elapsedTimeMillis() < 300){//Erfahrungswert
							if(positionAtStart != position || !subView.equals(subViewAtStart) || oldAction != DragEvent.ACTION_DRAG_LOCATION){
								stopWatch.stop();
								stopWatch.reset();
								stopWatch.start();
								positionAtStart = position;
								subViewAtStart = subView;
							}
						}else{
							stopWatch.stop();
							
							ViewGroup dragedViewParent       = (ViewGroup)dragedView.getParent();
							ViewGroup dragedViewParentParent = (ViewGroup)dragedViewParent.getParent();
							
							ViewGroup subViewParent       = (ViewGroup)subView.getParent();
							ViewGroup subViewParentParent = (ViewGroup)subViewParent.getParent();
							//dragedViewParentParent == subViewParentParent ist immer true!!!
							
							
							if(subView.equals(dragedView) && dragedViewParent.getChildCount()==1){//über der gleichen View und nur ein Element auf dieser Zeile
								//do nothing
							//}else if(subView.equals(dragedView) && dragedViewParent.getChildCount()>1){//über der gleichen View aber mehr als ein Element auf dieser Zeile 
								//take care of removing myself!!!
							}else if(Math.abs(dragedViewParentParent.indexOfChild(dragedViewParent)-subViewParentParent.indexOfChild(subViewParent))==1 && dragedViewParent.getChildCount()==1){//über der View direkt nebenan und die gezogene View ist alleine auf ihrer Zeile
								//do nothing
							}else{
								int verticalIndex = subViewParentParent.indexOfChild(subViewParent);
								
								dragedViewParent.removeView(dragedView); //gezogenes Element am alten Standort entfernen
								if(dragedViewParent.getChildCount() == 0){dragedViewParentParent.removeView(dragedViewParent);}//Container entfernen

								LinearLayout newLayout = new LinearLayout(activity.getApplicationContext()); //neuen Container erstellen
								newLayout.addView(dragedView); //gezogenes Element in Container einfügen
								
								if(position==Position.TOP){
									insertChildInViewGroup(subViewParentParent, newLayout, verticalIndex);
								}else{//position==Position.BOTTOM
									insertChildInViewGroup(subViewParentParent, newLayout, verticalIndex+1);
								}
							}
						}
					break;
					case MIDDLE_LEFT:
					case MIDDLE_RIGHT:
						if(!stopWatch.isRunning()){
							stopWatch.reset();
							stopWatch.start();
							positionAtStart = position;
							subViewAtStart = subView;
						}
						
						if(stopWatch.elapsedTimeMillis() < 300){//Erfahrungswert
							if(positionAtStart != position || !subView.equals(subViewAtStart) || oldAction != DragEvent.ACTION_DRAG_LOCATION){
								stopWatch.stop();
								stopWatch.reset();
								stopWatch.start();
								positionAtStart = position;
								subViewAtStart = subView;
							}
						}else{
							stopWatch.stop();
							
							if(!subView.equals(dragedView)){//wenn ich immer noch auf dem selben Button bin, dann nichts machen
								ViewGroup parent = (ViewGroup)dragedView.getParent();
								parent.removeView(dragedView);
								
								ViewGroup newParent = ((ViewGroup)subView.getParent());
								int subViewIndex = newParent.indexOfChild(subView);
								
								if(position == Position.MIDDLE_LEFT){
									insertChildInViewGroup(newParent, dragedView, subViewIndex);
								}else{//position == Position.MIDDLE_RIGHT
									insertChildInViewGroup(newParent, dragedView, subViewIndex+1);
								}
							}
						}
					break;
				}
			break;
			
			case DragEvent.ACTION_DRAG_EXITED:
			break;
			
			case DragEvent.ACTION_DROP:
				if(fingerSpeed>0.3){ //Erfahrungswert;
					ViewGroup parent = (ViewGroup)dragedView.getParent();
					parent.removeView(dragedView);
					if(parent.getChildCount() == 0){((ViewGroup)parent.getParent()).removeView(parent);}//Container entfernen
				}
			break;
			
			case DragEvent.ACTION_DRAG_ENDED:
			break;
			
			default:
				Log.v("onDrag","ungültige Action: "+event.getAction());
			break;
		}
		
		oldAction = action;
		return true;
	}
	
    //the view is insertet into the viewGroup. The ViewGroup becomes one element longer
    //No Element is deleted.
    private void insertChildInViewGroup(ViewGroup viewGroup, View view, int index){
    	
    	viewGroup.getChildAt(index);
    	
		View child = view;
		int childCount = viewGroup.getChildCount();
		for(int i=index ; i<childCount ; i++){
			View temp = viewGroup.getChildAt(i);

			viewGroup.removeViewAt(i);
			viewGroup.addView(child, i);
			child = temp;
		}
		viewGroup.addView(child);
    }
}
