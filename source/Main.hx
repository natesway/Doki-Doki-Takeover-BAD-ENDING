package;

#if android
import android.content.Context;
import android.os.Build;
#end
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import lime.system.System;
import openfl.Lib;
import openfl.display.Sprite;
#if CRASH_HANDLER
import haxe.CallStack;
import haxe.Exception;
import haxe.Log;
import openfl.errors.Error;
import openfl.events.ErrorEvent;
import openfl.events.UncaughtErrorEvent;
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class Main extends Sprite
{
	public static var fpsVar:FPSCounter;

	public function new():Void
	{
		super();

		#if android
		if (VERSION.SDK_INT > 30)
			Sys.setCwd(Path.addTrailingSlash(Context.getObbDir()));
		else
			Sys.setCwd(Path.addTrailingSlash(Context.getExternalFilesDir()));
		#elseif ios
		Sys.setCwd(System.documentsDirectory);
		#end

		#if CRASH_HANDLER
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
		#end

		ClientPrefs.loadDefaultKeys();

		FlxG.signals.gameResized.add(onResizeGame);

		addChild(new FlxGame(1280, 720, TitleState, 60, 60, true, false));

		#if android
		FlxG.android.preventDefaultKeys = [BACK];
		#end

		fpsVar = new FPSCounter(10, 3, 0xFFFFFF);

		if (fpsVar != null)
			fpsVar.visible = ClientPrefs.showFPS;

		addChild(fpsVar);

		#if html5
		FlxG.mouse.visible = false;
		#end
	}

	#if CRASH_HANDLER
	private inline function onUncaughtError(event:UncaughtErrorEvent):Void
	{
		event.preventDefault();
		event.stopImmediatePropagation();

		final log:Array<String> = [];

		if (Std.isOfType(event.error, Error))
			log.push(cast(event.error, Error).message);
		else if (Std.isOfType(event.error, ErrorEvent))
			log.push(cast(event.error, ErrorEvent).text);
		else
			log.push(Std.string(event.error));

		for (item in CallStack.exceptionStack(true))
		{
			switch (item)
			{
				case CFunction:
					log.push('C Function');
				case Module(m):
					log.push('Module [$m]');
				case FilePos(s, file, line, column):
					log.push('$file [line $line]');
				case Method(classname, method):
					log.push('$classname [method $method]');
				case LocalFunction(name):
					log.push('Local Function [$name]');
			}
		}

		final msg:String = log.join('\n');

		#if sys
		try
		{
			if (!FileSystem.exists('crash'))
				FileSystem.createDirectory('crash');

			File.saveContent('crash/BadEnding_' + Date.now().toString().replace(' ', '-').replace(':', "'") + '.txt', msg);
		}
		catch (e:Exception)
			Log.trace('Couldn\'t save error message "${e.message}"', null);
		#end

		Log.trace(msg, null);
		Lib.application.window.alert(msg, 'Error!');
		System.exit(1);
	}
	#end

	private inline function onResizeGame(width:Int, height:Int):Void
	{
		if (FlxG.cameras != null && (FlxG.cameras.list != null && FlxG.cameras.list.length > 0))
		{
			for (camera in FlxG.cameras.list)
			{
				if (camera != null && (camera.filters != null && camera.filters.length > 0))
				{
					// Shout out to Ne_Eo for bringing this to my attention.
					@:privateAccess
					if (camera.flashSprite != null)
					{
						camera.flashSprite.__cacheBitmap = null;
						camera.flashSprite.__cacheBitmapData = null;
					}
				}
			}
		}
		@:privateAccess
		if (FlxG.game != null)
		{
			FlxG.game.__cacheBitmap = null;
			FlxG.game.__cacheBitmapData = null;
		}
	}
}
