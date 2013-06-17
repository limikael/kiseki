package org.kisekiproject.persistence;

import org.kisekiproject.utils.ObjectUtil;

/**
 * Persistence state.
 */
class PersistenceState {

	public var data:Dynamic;
	public var score:Int;
	public var complete:Bool;

	/**
	 * Construct.
	 */
	public function new():Void {
		score=0;
		complete=false;
		data={};
	}

	/**
	 * Equals?
	 */
	public function equals(that:PersistenceState):Bool {
		//trace("comparing...");

		if (that==null)
			return false;

		if (score!=that.score)
			return false;

		if (complete!=that.complete)
			return false;

		return ObjectUtil.compare(this.data,that.data);
	}
}