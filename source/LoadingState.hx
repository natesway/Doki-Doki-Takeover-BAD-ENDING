package;

import flixel.FlxG;
import flixel.FlxState;

class LoadingState
{
	public static inline function loadAndSwitchState(target:FlxState, stopMusic = false)
	{
		MusicBeatState.switchState(getNextState(target, stopMusic));
	}

	private static function getNextState(target:FlxState, stopMusic = false):FlxState
	{
		final weekDir:String = StageData.forceNextDirectory;

		StageData.forceNextDirectory = null;

		var directory:String = 'shared';

		if (weekDir != null && weekDir.length > 0)
			directory = weekDir;

		Paths.setCurrentLevel(directory);

		trace('Setting asset folder to ' + directory);

		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();

		return target;
	}
}
