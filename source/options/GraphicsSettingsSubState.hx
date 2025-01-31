package options;

#if DISCORD_ALLOWED
import Discord.DiscordClient;
#end
import openfl.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import openfl.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class GraphicsSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Graphics';
		rpcTitle = 'Graphics Settings Menu'; // for Discord Rich Presence

		#if !(mobile || switch)
		var option:Option = new Option('Fullscreen', 'If checked, runs the game in fullscreen.', 'fullscreen', 'bool', false);
		option.onChange = onChangeFullscreen;
		addOption(option);
		#end

		#if !html5 // Apparently other framerates isn't correctly supported on Browser? Probably it has some V-Sync shit enabled by default, idk
		var option:Option = new Option('Framerate', "Pretty self explanatory, isn't it?", 'framerate', 'int', 60);
		addOption(option);
		option.minValue = 60;
		option.maxValue = 330; // Originally 240 but increased to 2x of 165
		option.displayFormat = '%v FPS';
		option.onChange = onChangeFramerate;
		#end

		// I'd suggest using "Low Quality" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Low Quality', // Name
			'If checked, disables some background details,\ndecreases loading times and improves performance.', // Description
			'lowQuality', // Save data variable name
			'bool', // Variable type
			false); // Default value
		addOption(option);

		var option:Option = new Option('Anti-Aliasing', 'If unchecked, disables anti-aliasing, increases performance\nat the cost of sharper visuals.',
			'globalAntialiasing', 'bool', true);
		option.showBoyfriend = true;
		option.onChange = onChangeAntiAliasing; // Changing onChange is only needed if you want to make a special interaction after it changes the value
		addOption(option);

		var option:Option = new Option('Shaders', // Name
			'If unchecked, disables shaders.\nIt\'s used for some visual effects, and also CPU intensive for weaker PCs.', // Description
			'shaders', // Save data variable name
			'bool', // Variable type
			true); // Default value
		addOption(option);

		var option:Option = new Option('GPU Textures*',
			'If checked, renders textures on the GPU instead,\ndecreasing memory usage.\n\n*Experimental, may cause issues.', 'gpuTextures', 'bool', true);
		addOption(option);

		super();
	}

	function onChangeAntiAliasing()
	{
		for (sprite in members)
		{
			var sprite:Dynamic = sprite; // Make it check for FlxSprite instead of FlxBasic
			var sprite:FlxSprite = sprite; // Don't judge me ok
			if (sprite != null && (sprite is FlxSprite) && !(sprite is FlxText))
			{
				sprite.antialiasing = ClientPrefs.globalAntialiasing;
			}
		}
	}

	function onChangeFramerate()
	{
		if (ClientPrefs.framerate != FlxG.drawFramerate)
		{
			FlxG.updateFramerate = ClientPrefs.framerate;
			FlxG.drawFramerate = ClientPrefs.framerate;
			FlxG.game.focusLostFramerate = ClientPrefs.framerate;
		}
	}

	#if !(mobile || switch)
	function onChangeFullscreen()
	{
		FlxG.fullscreen = ClientPrefs.fullscreen;
	}
	#end
}
