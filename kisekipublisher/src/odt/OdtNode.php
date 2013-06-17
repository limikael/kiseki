<?php

	/**
	 * A node in a ODT document.
	 */
	abstract class OdtNode {

		const TEXT="text";
		const IMAGE="image";

		/**
		 * Get node type.
		 */
		abstract public function getType();

		/**
		 * Get debug string.
		 */
		abstract public function toString();
	}