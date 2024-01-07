package flixel.mobile;

import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxTileFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.mobile.FlxButton;
import flixel.util.FlxDestroyUtil;
import flixel.FlxG;
import openfl.utils.Assets;

enum FlxDPadMode
{
	UP_DOWN;
	LEFT_RIGHT;
	UP_LEFT_RIGHT;
	LEFT_FULL;
	RIGHT_FULL;
	NONE;
}

enum FlxActionMode
{
	A;
	B;
	A_B;
	A_C;
	A_B_C;
	A_B_X_Y;
	A_B_C_X_Y;
	A_B_C_X_Y_Z;
	NONE;
}

/**
 * A virtual gamepad.
 * It's easy to customize the layout.
 *
 * @author Ka Wing Chin
 * @author Mihai Alexandru (M.A. Jigsaw)
 */
class FlxVirtualPad extends FlxSpriteGroup
{
	public var buttonLeft:FlxButton = new FlxButton(0, 0);
	public var buttonUp:FlxButton = new FlxButton(0, 0);
	public var buttonRight:FlxButton = new FlxButton(0, 0);
	public var buttonDown:FlxButton = new FlxButton(0, 0);

	public var buttonA:FlxButton = new FlxButton(0, 0);
	public var buttonB:FlxButton = new FlxButton(0, 0);
	public var buttonC:FlxButton = new FlxButton(0, 0);
	public var buttonX:FlxButton = new FlxButton(0, 0);
	public var buttonY:FlxButton = new FlxButton(0, 0);
	public var buttonZ:FlxButton = new FlxButton(0, 0);

	/**
	 * Create a virtual gamepad.
	 *
	 * @param dPad The D-Pad mode. `LEFT_FULL` for example.
	 * @param action The action buttons mode. `A_B_C` for example.
	 */
	public function new(dPad:FlxDPadMode = LEFT_FULL, action:FlxActionMode = A_B_C):Void
	{
		super();

		switch (dPad)
		{
			case UP_DOWN:
				add(buttonUp = createButton(0, FlxG.height - 255, 'up', 0xFFFF0513));
				add(buttonDown = createButton(0, FlxG.height - 135, 'down', 0xFFFF0513));
			case LEFT_RIGHT:
				add(buttonLeft = createButton(0, FlxG.height - 135, 'left', 0xFFFF0513));
				add(buttonRight = createButton(127, FlxG.height - 135, 'right', 0xFFFF0513));
			case UP_LEFT_RIGHT:
				add(buttonUp = createButton(105, FlxG.height - 243, 'up', 0xFFFF0513));
				add(buttonLeft = createButton(0, FlxG.height - 135, 'left', 0xFFFF0513));
				add(buttonRight = createButton(207, FlxG.height - 135, 'right', 0xFFFF0513));
			case LEFT_FULL:
				add(buttonUp = createButton(105, FlxG.height - 345, 'up', 0xFFFF0513));
				add(buttonLeft = createButton(0, FlxG.height - 243, 'left', 0xFFFF0513));
				add(buttonRight = createButton(207, FlxG.height - 243, 'right', 0xFFFF0513));
				add(buttonDown = createButton(105, FlxG.height - 135, 'down', 0xFFFF0513));
			case RIGHT_FULL:
				add(buttonUp = createButton(FlxG.width - 258, FlxG.height - 408, 'up', 0xFFFF0513));
				add(buttonLeft = createButton(FlxG.width - 384, FlxG.height - 309, 'left', 0xFFFF0513));
				add(buttonRight = createButton(FlxG.width - 132, FlxG.height - 309, 'right', 0xFFFF0513));
				add(buttonDown = createButton(FlxG.width - 258, FlxG.height - 201, 'down', 0xFFFF0513));
			case NONE: // do nothing
		}

		switch (action)
		{
			case A:
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 'a', 0xFFFF0513));
			case B:
				add(buttonB = createButton(FlxG.width - 132, FlxG.height - 135, 'b', 0xFFFF0513));
			case A_B:
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 'b', 0xFFFF0513));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 'a', 0xFFFF0513));
			case A_C:
				add(buttonC = createButton(FlxG.width - 258, FlxG.height - 135, 'c', 0xFFFF0513));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 'a', 0xFFFF0513));
			case A_B_C:
				add(buttonC = createButton(FlxG.width - 384, FlxG.height - 135, 'c', 0xFFFF0513));
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 'b', 0xFFFF0513));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 'a', 0xFFFF0513));
			case A_B_X_Y:
				add(buttonX = createButton(FlxG.width - 510, FlxG.height - 135, 'x', 0xFFFF0513));
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 'b', 0xFFFF0513));
				add(buttonY = createButton(FlxG.width - 384, FlxG.height - 135, 'y', 0xFFFF0513));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 'a', 0xFFFF0513));
			case A_B_C_X_Y:
				add(buttonC = createButton(FlxG.width - 384, FlxG.height - 135, 'c', 0xFFFF0513));
				add(buttonX = createButton(FlxG.width - 258, FlxG.height - 255, 'x', 0xFFFF0513));
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 'b', 0xFFFF0513));
				add(buttonY = createButton(FlxG.width - 132, FlxG.height - 255, 'y', 0xFFFF0513));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 'a', 0xFFFF0513));
			case A_B_C_X_Y_Z:
				add(buttonX = createButton(FlxG.width - 384, FlxG.height - 255, 'x', 0xFFFF0513));
				add(buttonC = createButton(FlxG.width - 384, FlxG.height - 135, 'c', 0xFFFF0513));
				add(buttonY = createButton(FlxG.width - 258, FlxG.height - 255, 'y', 0xFFFF0513));
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 'b', 0xFFFF0513));
				add(buttonZ = createButton(FlxG.width - 132, FlxG.height - 255, 'z', 0xFFFF0513));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 'a', 0xFFFF0513));
			case NONE: // do nothing
		}

		scrollFactor.set();
	}

	/**
	 * Clean up memory.
	 */
	override public function destroy():Void
	{
		super.destroy();

		buttonLeft = FlxDestroyUtil.destroy(buttonLeft);
		buttonUp = FlxDestroyUtil.destroy(buttonUp);
		buttonDown = FlxDestroyUtil.destroy(buttonDown);
		buttonRight = FlxDestroyUtil.destroy(buttonRight);

		buttonA = FlxDestroyUtil.destroy(buttonA);
		buttonB = FlxDestroyUtil.destroy(buttonB);
		buttonC = FlxDestroyUtil.destroy(buttonC);
		buttonX = FlxDestroyUtil.destroy(buttonX);
		buttonY = FlxDestroyUtil.destroy(buttonY);
		buttonZ = FlxDestroyUtil.destroy(buttonZ);
	}

	private function createButton(x:Float, y:Float, key:String, color:Int = 0xFFFFFF):FlxButton
	{
		var graphic:FlxGraphic = FlxG.bitmap.add('assets/vpad/$key.png');

		var button:FlxButton = new FlxButton(x, y);
		button.frames = FlxTileFrames.fromGraphic(graphic, FlxPoint.weak(Std.int(graphic.width / 3), graphic.height));
		button.solid = false;
		button.immovable = true;
		button.scrollFactor.set();
		button.color = color;
		button.alpha = 0.4;
		#if FLX_DEBUG
		button.ignoreDrawDebug = true;
		#end
		return button;
	}
}
