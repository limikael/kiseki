<?php

	/**
	 * Browser preview target.
	 */
	class BrowserPreviewTarget implements ITarget {

		private $publisher;

		/**
		 * Browser preview target.
		 */
		public function BrowserPreviewTarget() {
		}

		/**
		 * Set publisher.
		 */
		public function setPublisher($p) {
			$this->publisher=$p;
		}

		/**
		 * Get link.
		 */
		public function getLink() {
			if (file_exists($this->publisher->getOutputDir()."/main.swf"))
				return new Link(
					"Preview application in browser",
					$this->publisher->getOutputUrl()."/main.swf"
				);

			return NULL;
		}

		/**
		 * Process.
		 */
		public function process() {
		}
	}