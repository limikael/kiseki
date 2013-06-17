package org.kisekiproject.events;

import nme.events.Event;

/**
 * Kiseki content event.
 */
class ContentEvent extends Event {

	public static inline var CHANGE:String="contentChange";
	public static inline var SHOW:String="show";
	public static inline var HIDE:String="hide";

	/**
	 * Construct.
	 */
	public function new(type:String) {
		super(type);
	}
}