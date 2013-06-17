<?php

	/**
	 * A browser link.
	 */
	class Link {

		private $url;
		private $label;

		/**
		 * Link.
		 */
		public function Link($label, $url) {
			$this->label=$label;
			$this->url=$url;
		}

		/**
		 * Get label.
		 */
		public function getLabel() {
			return $this->label;
		}

		/**
		 * Get url.
		 */
		public function getUrl() {
			return $this->url;
		}

		/**
		 * Get target.
		 */
		public function getTarget() {
			return $this->label;
		}
	}
