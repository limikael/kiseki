<?php

	/**
	 * Interface.
	 */
	interface ISource {

		public function setPublisher($publisher);
		public function getLink();
		public function process();

	}
