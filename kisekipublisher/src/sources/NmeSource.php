<?php

	/**
	 * Nme compiled source.
	 */
	class NmeSource implements ISource {

		private $publisher;
		private $nmeOutputDir;
		private $appFileName;

		/**
		 * Construct.
		 */
		public function NmeSource($outputDir, $appFileName) {
			$this->nmeOutputDir=$outputDir;
			$this->appFileName=$appFileName;
		}

		/**
		 * Get label.
		 */
		public function getLabel() {
			return NULL;
		}

		/**
		 * Get link.
		 */
		public function getLink() {
			return NULL;
		}

		/**
		 * Set publisher.
		 */
		public function setPublisher($p) {
			$this->publisher=$p;
		}

		/**
		 * Process.
		 */
		public function process() {
			$this->publisher->message("Processing NME source: ".$this->appFileName);

			$sourcefile=$this->nmeOutputDir."/flash/bin/".$this->appFileName.".swf";
			$targetfile=$this->publisher->getOutputDir()."/main.swf";

			copy($sourcefile,$targetfile);
			$perms=fileperms($targetfile);
			chmod($targetfile,$perms|0060);
		}
	}