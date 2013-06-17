package org.kisekiproject.signals;

/**
 * Parameter listener.
 */
class ParameterListener {
	public var listener:Dynamic;
	public var parameter:Dynamic;

	public function new(l:Dynamic, p:Dynamic) {
		listener=l;
		parameter=p;
	}
}

/**
 * Signal.
 */
class Signal<Event> {

	private var _parameterListeners:Array<ParameterListener>;
	private var _listeners:Array<Dynamic>;
	private var _connections:Array<Signal<Event>>;

	/**
	 * Construct.
	 */
	public function new() {
		_listeners=new Array<Dynamic>();
		_parameterListeners=new Array<ParameterListener>();
		_connections=new Array<Signal<Event>>();
	}

	/**
	 * Add listener.
	 */
	public function addListener(listener:Dynamic):Void {
		if (!Reflect.isFunction(listener))
			throw "Listener must be a function";

		removeListener(listener);
		_listeners.push(listener);
	}

	/**
	 * Add listener.
	 */
	public function addListenerWithParameter(listener:Dynamic, parameter:Dynamic):Void {
		if (!Reflect.isFunction(listener))
			throw "Listener must be a function";

		removeListener(listener);
		_parameterListeners.push(new ParameterListener(listener,parameter));
	}

	/**
	 * Remove event listener.
	 */
	public function removeListener(listener:Dynamic):Void {
		for (i in 0..._listeners.length) {
			if (Reflect.compareMethods(_listeners[i],listener)) {
				_listeners.splice(i,1);
				return;
			}
		}

		for (i in 0..._parameterListeners.length) {
			if (Reflect.compareMethods(_parameterListeners[i].listener,listener)) {
				_parameterListeners.splice(i,1);
				return;
			}
		}
	}

	/**
	 * Connect to another signal.
	 */
	public function addConnection(signal:Signal<Event>):Void {
		removeConnection(signal);
		_connections.push(signal);
	}

	/**
	 * Remove connection.
	 */
	public function removeConnection(signal:Signal<Event>):Void {
		for (i in 0..._connections.length)
			if (_connections[i]==signal) {
				_connections.splice(i,0);
				return;
			}
	}

	/**
	 * Remove all.
	 */
	public function removeAll():Void {
		_listeners=new Array<Dynamic>();
		_parameterListeners=new Array<ParameterListener>();
		_connections=new Array<Signal<Event>>();
	}

	/**
	 * Dispatch.
	 */
	public function dispatch(?e:Event=null):Void {
		for (listener in _listeners) {
			if (e!=null)
				listener(e);

			else
				listener();
		}

		for (connection in _connections)
			connection.dispatch(e);

		for (parameterListener in _parameterListeners) {
			if (e!=null)
				parameterListener.listener(parameterListener.parameter,e);

			else
				parameterListener.listener(parameterListener.parameter);
		}
	}
}