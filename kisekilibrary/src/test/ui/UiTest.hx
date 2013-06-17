package test.ui;

import nme.display.Sprite;
import org.kisekiproject.utils.LogWindow;
import org.kisekiproject.ui.SvgClip;
import org.kisekiproject.ui.ButtonDecorator;
import org.kisekiproject.ui.SvgClipLibrary;
import nme.Assets;

/**
 * UiTest.
 */
class UiTest extends Sprite {

	/**
	 * Construct.
	 */
	public function new() {
		super();

		LogWindow.show();
		trace("hello");

		var library:SvgClipLibrary=SvgClipLibrary.parseAsset("assets/test.svg");

		addChild(library.getClip("Background"));

		var clip:SvgClip;

		clip=library.getClip("Button1");
		clip.firstTextField.text="Prev";
		addChild(new ButtonDecorator(clip));

		clip=library.getClip("Button2");
		clip.firstTextField.text="Next";
		addChild(new ButtonDecorator(clip));
	}
}