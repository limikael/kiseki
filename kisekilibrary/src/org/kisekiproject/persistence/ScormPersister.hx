package org.kisekiproject.persistence;

import flash.net.SharedObject;
import haxe.Json;

/**
 * Shared object persister.
 */
class ScormPersister implements IPersister {

	private var _scorm:Scorm;

	/**
	 * Construct.
	 */
	public function new() {
	}

	/**
	 * Load.
	 */
	public function load():PersistenceState {
		if (_scorm==null)
			connect();

		var str:String=_scorm.get("cmi.suspend_data");

		if (str==null || str=="")
			return null;

		var p:PersistenceState=new PersistenceState();
		p.data=Json.parse(str);

		return p;
	}

	/**
	 * Save.
	 */
	public function save(state:PersistenceState):Void {
		if (_scorm==null)
			connect();

		var str:String=Json.stringify(state.data);
		var setRes:Bool=_scorm.set("cmi.suspend_data",str);
		trace("SCORM set suspend: "+setRes);	

		var setRes:Bool=_scorm.set("cmi.core.score.raw", Std.string(state.score));
		trace("SCORM set score("+state.score+"): "+setRes);

		var setRes:Bool=_scorm.set("cmi.completion_status", (state.complete?"completed":"incomplete"));
		trace("SCORM set complete 1: "+setRes);	

		var setRes:Bool=_scorm.set("cmi.core.lesson_status", (state.complete?"completed":"incomplete"));
		trace("SCORM set complete 2: "+setRes);	

		var saveRes:Bool=_scorm.save();
		trace("SCORM save: "+saveRes);
	}

	/**
	 * Connect to scorm.
	 */
	private function connect():Void {
		_scorm=new Scorm();

		var connectResult:Bool=_scorm.connect();

		if (!connectResult)
			throw "Unable to connect to scorm";
	}

	/**
	 * Quit.
	 */
	public function quit():Void {
		if (_scorm==null)
			connect();

		_scorm.disconnect();
	}
}