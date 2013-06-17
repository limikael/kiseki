<?php

	/**
	 * File source.
	 */
	class FileSource implements ISource {

		private $filename;
		private $publisher;

		/**
		 * Construct.
		 */
		public function FileSource($fn) {
			$this->filename=$fn;
		}

		/**
		 * Set publisher.
		 */
		public function setPublisher($p) {
			$this->publisher=$p;
		}

		/**
		 * Link.
		 */
		public function getLink() {
			return NULL;
		}

		/**
		 * Process.
		 */
		public function process() {
			$tofile=basename($this->filename);
			$this->publisher->message("Resource: ".$this->filename." -> ".$tofile);
			copy(ScriptUtil::getScriptDir()."/".$this->filename,$this->publisher->getOutputDir()."/".$tofile);
		}
	}