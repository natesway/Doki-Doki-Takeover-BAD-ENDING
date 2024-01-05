package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;

class FlashingState extends MusicBeatState
{
	var bg:FlxSprite;
	var selected:Bool = false;

	override function create()
	{
		bg = new FlxSprite(0, 0).loadGraphic(Paths.image('DDLCIntroWarning', 'preload'));
		bg.alpha = 0;
		bg.screenCenter(X);
		add(bg);

		FlxTween.tween(bg, {alpha: 1}, 1, {ease: FlxEase.quadOut});

		super.create();
	}

	override function update(elapsed:Float)
	{
		var pressedEnter:Bool = controls.ACCEPT;

		#if mobile
		for (touch in FlxG.touches.list)
			if (touch.justPressed)
				pressedEnter = true;
		#end

		if (pressedEnter && !selected)
		{
			selected = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			FlxTween.tween(bg, {alpha: 0}, 1, {
				onComplete: function(twn:FlxTween)
				{
					// TODO: change URL based on if the build is going on GB or GJ
					TitleState.hasPassedFlashing = true;
					ClientPrefs.firststart = false;
					ClientPrefs.saveSettings();
					MusicBeatState.switchState(new TitleState());
				}
			});
		}

		super.update(elapsed);
	}
}
