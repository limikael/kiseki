package org.kisekiproject.ui;

import format.svg.SVGData;
import nme.Assets;

/**
 * Use an svg as a library of clips.
 */
class SvgClipLibrary {

	private var _svg:SVGData;

	/**
	 * Construct.
	 */
	public function new(svg:SVGData):Void {
		_svg=svg;
	}

	/**
	 * Get clip.
	 */
	public function getClip(id:String=null):SvgClip {
		return new SvgClip(_svg,id);
	}

	/**
	 * Parse.
	 */
	public static function parse(s:String):SvgClipLibrary {
		return new SvgClipLibrary(new SVGData(Xml.parse(s)));
	}

	/**
	 * Parse asset.
	 */
	public static function parseAsset(assetName:String):SvgClipLibrary {
		var s:String=Assets.getText(assetName);

		if (s==null)
			throw "Unable to get asset";

		return parse(s);
	}
}