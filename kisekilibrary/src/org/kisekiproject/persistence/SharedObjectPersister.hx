package org.kisekiproject.persistence;

import flash.net.SharedObject;

/**
 * Shared object persister.
 */
class SharedObjectPersister implements IPersister {

	private var _so:SharedObject;

	/**
	 * Construct.
	 */
	public function new() {
		_so=SharedObject.getLocal("state");
	}

	/**
	 * Load.
	 */
	public function load():PersistenceState {
		var state:PersistenceState=new PersistenceState();

		state.data=_so.data.data;
		state.complete=_so.data.complete;
		state.score=_so.data.score;

		return state;
	}

	/**
	 * Save.
	 */
	public function save(persistenceState:PersistenceState):Void {
		_so.data.data=persistenceState.data;
		_so.data.complete=persistenceState.complete;
		_so.data.score=persistenceState.score;
		_so.flush();
	}

	/**
	 * Quit.
	 */
	public function quit():Void {
	}
}