<?php

	require_once "odt/OdtNode.php";

	/**
	 * An image node in a ODT document.
	 */
	class OdtImageNode extends OdtNode {

		private $file;
		private $odt;

		/**
		 * Constructor.
		 */
		public function OdtImageNode() {
		}

		/**
		 * Set reference to odt.
		 */
		public function setOdt($value) {
			$this->odt=$value;
		}

		/**
		 * Get node type.
		 */
		public function getType() {
			return OdtNode::IMAGE;
		}

		/**
		 * Get file.
		 */
		public function getFileName() {
			$p=pathinfo($this->file);
			return $p["basename"];
		}

		/**
		 * Get file path.
		 */
		public function getFilePath() {
			return $this->file;
		}

		/**
		 * Parse.
		 */
		public function parse($node) {
			$this->file=$node->getAttribute("xlink:href");
		}

		/**
		 * Get image.
		 */
		public function getImage() {
			return $this->odt->getImage($this->file);
		}

		/**
		 * String rep.
		 */
		public function toString() {
			return "[ImageNode file=\"".$this->file."\" size=\"".strlen($this->getImage())."\"]";
		}
	}