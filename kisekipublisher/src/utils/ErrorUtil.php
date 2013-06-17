<?php

	/**
	 * Error handler.
	 */
	function ErrorUtil_errorHandler($errno, $errstr, $errfile, $errline ) {
		//echo "throwing for ***$errstr ...***";
    	throw new ErrorException($errstr, 0, $errno, $errfile, $errline);
    	//echo "throwed...";
	}

	/**
	 * Utility class for error handling.
	 */
	class ErrorUtil {

		/**
		 * Make sure errors cause exceptions.
		 */
		public static function errorsAsExceptions() {
			//echo "installing...";
			set_error_handler("ErrorUtil_errorHandler");
		}
	}