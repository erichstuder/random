package erichstuder.robotsensors;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.UUID;

import erichstuder.robotsensors.R;
import erichstuder.robotsensors.BlockAddingPopup.OnBlockChosenListener;

import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothServerSocket;
import android.bluetooth.BluetoothSocket;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Matrix;
import android.hardware.Camera;
import android.os.Bundle;
import android.os.IBinder;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.DragEvent;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnDragListener;
import android.view.View.OnLongClickListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;

public class PlayAroundActivity extends Activity  implements OnClickListener, OnLongClickListener, OnBlockChosenListener, Camera.PreviewCallback{

	//private StopWatch stopWatch;
	
	private LinearLayout mainBlockContainer;
	private FrameLayout dummyPreview;
	private FrameLayout previewLayout;
	private CameraPreview camPreview;  //wird nur lokal verwendet, allenfalls noch migrieren
	private BlockAddingPopup blockAddingPopup = null;
	
	private DragHandler dragHandler;
	
	//onDrag
	//private float  oldX;
	//private float  oldY;
	//private long   oldMillis;
	//private double fingerSpeed;
	
	
	//für Display unabhängige Anzeige.
	//private DisplayMetrics displayMetrics;
	
	
	
	Block blockForPreview=null;
	
	
	
	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	    setContentView(R.layout.play_around_activity);
	    
	    Log.v("onCreate","a"); 
	    
	    setDefaultUncaughtExceptionHandler();
	    
	    //hier kommen die einzelnen Filter-Elemente rein.
	    mainBlockContainer = (LinearLayout)findViewById(R.id.mainBlockContainer);
	    
	    //Kamera Block ist fix
	    //LinearLayout newLayout = new LinearLayout(this.getApplicationContext()); //neuen Container erstellen
	    Block cameraBlock = new CameraBlock(getApplicationContext());
	    cameraBlock.setOnClickListener(this);
	    mainBlockContainer.addView(cameraBlock);
	    
	    //non-visible Camera-Preview
	    dummyPreview = (FrameLayout) findViewById(R.id.dummyPreview);
	    
	    //main Preview Window
	    previewLayout = (FrameLayout) findViewById(R.id.preview);
	    //preview.setRotation(90);
	    
	    //Popup zum zufügen neuer Blöcke
		blockAddingPopup = new BlockAddingPopup(this);
		blockAddingPopup.setOnBlockChosenListener(this);

		dragHandler = new DragHandler(this);

		//stopWatch = new StopWatch();
	    
	   
        try {
        	camPreview = new CameraPreview(this, 0); //allenfalls prüfen wie viele Kameras es gibt und dann die entsprechende eingeben.
        	camPreview.setPreviewCallback(this);
        	dummyPreview.addView(camPreview);
        } catch (Exception e){
        	Log.v("onCreate", e.toString());
        }
	}
	
	private static void setDefaultUncaughtExceptionHandler() {
	    try {
	        Thread.setDefaultUncaughtExceptionHandler(new Thread.UncaughtExceptionHandler() {

	            @Override
	            public void uncaughtException(Thread t, Throwable e) {
	                //logger.error("Uncaught Exception detected in thread {}", t, e);
	            	Log.v("uncaught exception",e.toString() +"  "+ t.toString());
	            	StackTraceElement[] a = e.getStackTrace();
	            	for(StackTraceElement x : a){
	            		Log.v("uncaught exception",x.toString());
	            	}
	            	Log.v("uncaught exception",a.toString());
	            	
	            	SaveVariable.saveString("log.txt","uncaught exception  " + a.toString());
	            }
	        });
	    } catch (SecurityException e) {
	    	
	        Log.v("Could not set the Default Uncaught Exception Handler", e.toString());
	    	
	    }
	}
	
	
    protected void onStart(){
    	super.onStart();
    	Log.v("onStart","a"); 
    }
    
    protected void onRestart(){
    	super.onRestart();
    	Log.v("onRestart","a");
    }

    protected void onResume(){
    	super.onResume();
    	Log.v("onResume","a");
    }

    protected void onPause(){
    	super.onPause();
    	//camPreview.stopPreview();
    	Log.v("onPause","a");
    }

    protected void onStop(){
    	super.onStop();
    	Log.v("onStop","a");
    }
	
	public void onDestroy(){
		super.onDestroy();
		Log.v("onDestroy","a");
	}
	    
	
	
	
	
	
	public boolean onLongClick(View v){
		View.DragShadowBuilder dsb = new View.DragShadowBuilder(v);
		v.startDrag(null, dsb, v, 0);
		
		return true;
	}
	
    private void waitMillis(int milliSeconds) {
        try {
            Thread.sleep(milliSeconds);

        } catch (InterruptedException e) {
        	Log.v("waitMillis",e.toString());
        }
    }
    

    
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.drag_drop, menu);
        //menu.add
        
        //MenuInflater m = getMenuInflater();
        //menu.
        
        //View v = (View)this.findViewById(R.id.menuItemDeleteBlock);
        //Log.v("onPreviewFrame",""+v);
        //Log.v("onPreviewFrame",""+menu.findItem(R.id.menuItemDeleteBlock));
        
        //v.setOnDragListener(this);
        
        return true;
    }
	
    //@Override
    public boolean onOptionsItemSelected(MenuItem item) {
    	
	    int itemId = item.getItemId();
    	switch(itemId){
    		case R.id.menuItemAddBlock:
    			if(!blockAddingPopup.isShowing()){
    				blockAddingPopup.showAsDropDown(findViewById(itemId));
    	    	}else{
    	    		blockAddingPopup.dismiss();
    	    	}
    		break;
    		default:
    		break;
    	}
    	return false;
    }
    
    public void onBlockChosen(View v){
	    v.setOnDragListener(dragHandler);
	    v.setOnClickListener(this);
	    v.setLongClickable(true);
	    v.setOnLongClickListener(this);
	    
	    //v.destroyDrawingCache();
	    //v.refreshDrawableState();
	    
	    //Hier muss noch geprüft werden, ob der Block überhaupt so platziert werden kann.
	    //Block b = new CameraBlock(this.getApplicationContext());
	    //v.setBackgroundDrawable(b.getBackground());
	    //v.get
	    
		LinearLayout newLayout = new LinearLayout(this.getApplicationContext()); //neuen Container erstellen
		newLayout.addView(v); //Element in Container einfügen
		mainBlockContainer.addView((View)newLayout);
    }
    
    public void onClick(View v){
    	//blockForPreview setzen;
    	//wird dann in "onPreviewFrame" ausgewertet
    	
    	if(blockForPreview!=null){
    		blockForPreview.highlightAsPreview(false);
    	}
    	
    	Block b = (Block)v;
    	blockForPreview = b;
    	b.highlightAsPreview(true);
    	
    	
    	/*FrameLayout preview = (FrameLayout) findViewById(R.id.preview);
    	ImageView imageView = new ImageView(this.getApplicationContext());
    	((Block)v).doFilter();
    	imageView.setImageBitmap(bm);
    	preview.addView(imageView);*/
    }
    
    public void onPreviewFrame(byte[] data, Camera camera){
    	camera.setPreviewCallback(null);
    	Log.v("onPreviewFrame","0");
    	
    	ImageView previewImageView = new ImageView(this.getApplicationContext());
    	//LayoutParams params = new LayoutParams(LayoutParams.WRAP_CONTENT,LayoutParams.WRAP_CONTENT);
    	//previewImageView.setLayoutParams(params);
    	
    	final int HEIGHT = camera.getParameters().getPreviewSize().height;
    	final int WIDTH = camera.getParameters().getPreviewSize().width;
    	int[] rgb = ImageToolbox.convertYUV420_NV21toRGB8888(data, WIDTH, HEIGHT);

    	//BlockContainer analysieren und die entsprechenden Filterungen durchführen
    	
        //bitmap = blueFilter.doFilter(bitmap);
    	//blueFilter.doFilter2(rgb);
    	
    	for(int i=0;i<mainBlockContainer.getChildCount();i++){
    		View view = mainBlockContainer.getChildAt(i);
    		if(view.getClass() == LinearLayout.class ){
    			view = ((LinearLayout)view).getChildAt(0);
    		}
    		//Log.v("onPreviewFrame",""+mainBlockContainer.getChildCount());
    		
    		//Der Block kann irgendwann einmal gelöscht oder verschoben werden
    		//Dies würde zu einer NullPointerException führen.
    		Block block = (Block)view;
    		if(block!=null){
    			block.doFilter(rgb,WIDTH,HEIGHT);
    		}
    		
    		if(view == blockForPreview){
    			Matrix rotateRight = new Matrix();
	        	rotateRight.preRotate(90);

	        	Bitmap bitmap = Bitmap.createBitmap(rgb, WIDTH, HEIGHT, Bitmap.Config.ARGB_8888);
	        	bitmap = Bitmap.createBitmap(bitmap, 0, 0, WIDTH, HEIGHT, rotateRight, true);
	        	
	        	//bitmap = Bitmap.createScaledBitmap(bitmap, bitmap.getWidth()/20, bitmap.getHeight()/20, false);
	        	
	            
	        	//previewImageView.setRotation(90);
	        	previewImageView.setImageBitmap(bitmap);
	        	
	        	previewLayout.removeAllViews();
	        	previewLayout.addView(previewImageView);
	    	}
    	}
    	camera.setPreviewCallback(this);
        //Log.v("onPreviewFrame","4");
    }
}
