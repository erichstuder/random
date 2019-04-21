package erichstuder.robotsensors;

import java.util.ArrayList;
import java.util.List;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.media.AudioManager;
import android.os.Build;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.speech.RecognitionListener;
import android.speech.RecognizerIntent;
import android.speech.SpeechRecognizer;
import android.util.Log;

public class SpeechToText implements RecognitionListener{
	
	private SpeechRecognizerCallback callback;
	private SpeechRecognizer speechRecognizer;
	private Intent intent;
	private Activity activity;
	private CountDownTimer countdown;
	private AudioManager audioManager;
	
	public SpeechToText(Activity activity, SpeechRecognizerCallback callback) throws Exception{
		
		//TODO beide NullPointException ändern auf IllegalArgumentException
		if(callback == null){
			throw new NullPointerException("callback must not be null");//unchecked ist in Ordnung
		}else{
			this.callback = callback;
		}
		
		if(activity == null){
			throw new NullPointerException("activity must not be null");//unchecked ist in Ordnung
		}else{
			this.activity = activity;
		}
		
		audioManager = (AudioManager) activity.getSystemService(Context.AUDIO_SERVICE);
		if(audioManager == null){
			throw new Exception("audioManager is null");//muss checked sein, da dies deviceabhängig sein könnte.
		}
		
		speechRecognizer = SpeechRecognizer.createSpeechRecognizer(activity);
		speechRecognizer.setRecognitionListener(this);
		
		//http://android-developers.blogspot.ch/2010/03/speech-input-api-for-android.html
		//check if speech recognition is available
		PackageManager pm = activity.getPackageManager();
		List<ResolveInfo> activities = pm.queryIntentActivities(new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH), 0);
		if(activities.size() == 0){
			throw new Exception("speech recognition not available!");
		}
		
		intent = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH); //gibt sicher kein exception, somit intent nie null
		//intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_WEB_SEARCH);
		
		//intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_PREFERENCE, "en_US");//en-US
		
		//wird nur für (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) benötigt
		//passiert 5s nichts, so ist schluss http://code.google.com/p/android/issues/detail?id=37883
		countdown = new CountDownTimer(5000, 5000) {
		     public void onTick(long millisUntilFinished){}
		     public void onFinish() {
		    	 speechRecognizer.cancel();
		    	 //target.mAudioManager.setStreamMute(AudioManager.STREAM_SYSTEM, true);
		    	 audioManager.setStreamMute(AudioManager.STREAM_SYSTEM, true);
		    	 
		    	 speechRecognizer.startListening(intent);
		     }
		};
	}
	
	/*
	 * Aufnahme starten
	 * 
	 * onReadyForSpeech
	 * - Timer starten										
	 * 														
	 * onBeginning of Speech								Timer abgelaufen
	 * - Timer anhalten										- Aufnahme starten
	 * 														- Schlaufe startet wieder bei onReadyForSpeech
	 * onResults
	 * - Aufnahme starten
	 * - Schlaufe startet wieder bei onReadyForSpeech
	 * 
	 */

	public void start(){
		speechRecognizer.startListening(intent);//passiert 5s nichts, so ist schluss http://code.google.com/p/android/issues/detail?id=37883
	}
	
	public void stop(){
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN){
			if(countdown != null){
				countdown.cancel();
			}
		}
		
		if(speechRecognizer != null){
			speechRecognizer.stopListening();
			//speechRecognizer.destroy();
		}
	}
	

	@Override
	public void onBeginningOfSpeech() {
		// TODO Auto-generated method stub
		//countdown abbrechen
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN){
			if(countdown != null){
				countdown.cancel();
			}
		}
		//Log.v("erich", "onBeginningOfSpeech");
	}

	@Override
	public void onBufferReceived(byte[] buffer) {
		// TODO Auto-generated method stub
		//Log.v("erich", "onBufferReceived");
	}

	@Override
	public void onEndOfSpeech() {
		// TODO Auto-generated method stub
		//Log.v("erich", "onBeginningOfSpeech");
	}

	@Override
	public void onError(int error) {
		// TODO Auto-generated method stub
		//speechRecognizer.startListening(intent);
		//TODO
		//Log.v("erich", "onError: "+error);
	}

	@Override
	public void onEvent(int eventType, Bundle params) {
		// TODO Auto-generated method stub
		//Log.v("erich", "onEvent");
	}

	@Override
	public void onPartialResults(Bundle partialResults) {
		// TODO Auto-generated method stub
		//Log.v("erich", "onBeginningOfSpeech");
	}

	@Override
	public void onReadyForSpeech(Bundle params) {
		if(audioManager!=null){
			//Dieser Aufruf ist auch vor JELLY_BEAN notwendig, da nachdem text erkannt wurde speechRecognizer neu gestartet wird.
			audioManager.setStreamMute(AudioManager.STREAM_SYSTEM, false);//Lautsprecher wieder einschalten
		}
		
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN){
			//5s Countdown starten
			if(countdown != null){
				countdown.start();
			}
		}
		//Log.v("erich", "onReadyForSpeech");
	}

	@Override
	public void onResults(Bundle results) {
		//Log.v("erich", "onResults");
		ArrayList<String> data = results.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION);
		if(data != null){
//			for(String s : data){
//				Log.v("erich", s);
//			}
			this.callback.onSpeechRecognized(data.get(0));
		}
		
		//countdown.cancel() wurde bereits in onBeginningOfSpeech() aufgerufen
		if(audioManager != null){
			audioManager.setStreamMute(AudioManager.STREAM_SYSTEM, true);
		}
		
		if(speechRecognizer != null && intent != null){
			speechRecognizer.startListening(intent);
		}
	}

	@Override
	public void onRmsChanged(float rmsdB) {
		// TODO Auto-generated method stub
		//Log.v("erich", "onRmsChanged "+rmsdB);//called very often
	}
	
	
	//callback
	public interface SpeechRecognizerCallback{
		public void onSpeechRecognized(String string);
	}

}
