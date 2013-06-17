package test.resources;

import nme.display.Sprite;
import org.kisekiproject.utils.LogWindow;
import org.kisekiproject.resources.ResourceLoader;

/**
 * Resources test.
 */
class ResourcesTest extends Sprite {

	private var _resourceLoader:ResourceLoader;

	/**
	 * Construct.
	 */
	public function new() {
		super();
		
		LogWindow.show();

		trace("testing resource loader...");

		_resourceLoader=new ResourceLoader();
		_resourceLoader.addItem("buildicon.png");
		_resourceLoader.addItem("buildicon.png");
		_resourceLoader.onComplete.addListener(onResourcesLoaded);
		_resourceLoader.load();
	}

	/**
	 * Resources loaded..
	 */
	private function onResourcesLoaded():Void {
		addChild(_resourceLoader.getBitmap("buildicon.png"));
		trace("resources loaded..");
	}
}