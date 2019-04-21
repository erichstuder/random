package erichstuder.robotsensors;

import java.util.Locale;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.util.Log;

public final class Eula {
	
	private final static String EULA_ACCEPTED = "EULA_ACCEPTED"; 
	private final static String EULA_TEXT_DE =	"Hallo\n"+
												"\n"+
												"Niemand ist perfekt und so kann auch diese App Fehler enthalten.\n"+
												"Bitte beachte: Für jegliche Schäden wird die Haftung abgelehnt.\n"+
												"\n"+
												"So, das musste mal gesagt werden.\n"+
												"Nun aber viel Spass mit dieser App!";
	
	private final static String EULA_TEXT_EN =	"Hello \n"+
												"\n"+
												"Nobody is perfect and so this app may also contain errors.\n"+
												"Please note: All liability for any damage is disclaimed.";
	
	//No one is perfect and so this app can also contain errors. 
	//Please note: the liability is accepted for any damage. 
	
	//So, that had to be said. 
	//But now a lot of fun with this app!
	
	
	private Eula(){};//constructor blockieren
	
	public static void show(final Activity activity){
	    final SharedPreferences preferences = activity.getPreferences(Context.MODE_PRIVATE);
	    boolean eulaAccepted = preferences.getBoolean(EULA_ACCEPTED, false);
	    
	    //Locale.getDefault().getLanguage().equals(Locale.GERMAN);
	    
	    if(eulaAccepted == true) return;
        
	    AlertDialog.Builder builder = new AlertDialog.Builder(activity);
	    builder.setCancelable(false);
        //.setTitle(title)
	    
	    if(Locale.getDefault().getLanguage().equals(Locale.GERMAN.toString())){
	    	builder.setMessage(EULA_TEXT_DE);
	    }else{
	    	builder.setMessage(EULA_TEXT_EN);
	    }
	    
        builder.setPositiveButton("Ok", new Dialog.OnClickListener() {

            @Override
            public void onClick(DialogInterface dialogInterface, int i) {
                // Mark this version as read.
                SharedPreferences.Editor editor = preferences.edit();
                editor.putBoolean(EULA_ACCEPTED, true);
                editor.commit();
                //dialogInterface.dismiss();
            }
        })
        .setNegativeButton("Cancel", new Dialog.OnClickListener() {

            @Override
            public void onClick(DialogInterface dialog, int which) {
                // Close the activity as they have declined the EULA
                activity.finish();
            }

        });
        builder.create().show();
	}
	
}
