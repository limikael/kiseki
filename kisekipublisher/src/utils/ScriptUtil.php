<?php

	/**
	 * Script util.
	 */
	class ScriptUtil {

		/**
		 * Get the directory where the script is run from.
		 */
		public static function getScriptDir() {
			return dirname($_SERVER["SCRIPT_FILENAME"]);
		}

		/**
		 * Get url for current script.
		 */
		public static function getScriptUrl() {
			return "http://".$_SERVER["SERVER_NAME"].$_SERVER["PHP_SELF"];
		}
	}