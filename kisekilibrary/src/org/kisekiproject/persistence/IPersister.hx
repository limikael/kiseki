package org.kisekiproject.persistence;

/**
 * Persist.
 */
interface IPersister {

	function load():PersistenceState;

	function save(state:PersistenceState):Void;

	function quit():Void;

}