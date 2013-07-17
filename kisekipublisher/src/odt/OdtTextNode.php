<?php

	require_once "odt/OdtNode.php";

	/**
	 * A node in a ODT document.
	 */
	class OdtTextNode extends OdtNode {

		private $text;
		private $style;
		private $color;
		private $bold;

		/**
		 * Constructor.
		 */
		public function OdtTextNode() {
			$this->text="";
			$this->bold=false;
		}

		/**
		 * Get node type.
		 */
		public function getType() {
			return OdtNode::TEXT;
		}

		/**
		 * Set style.
		 */
		public function setStyle($value) {
			$this->style=$value;
		}

		/**
		 * Append text.
		 */
		public function appendText($value) {
			//echo "before: **".$this->text."**";
			$this->text.=$value;
			//echo "appending: $value\n";
		}

		/**
		 * Get style name.
		 */
		public function getStyle() {
			return $this->style;
		}

		/**
		 * Get text.
		 */
		public function getText() {
			return trim($this->text);
		}

		/**
		 * Get text.
		 */
		public function getRawText() {
			return $this->text;
		}

		/**
		 * Get color.
		 */
		public function getColor() {
			return $this->color;
		}

		/**
		 * Set color.
		 */
		public function setColor($value) {
			$this->color=$value;
		}

		/**
		 * Get bold.
		 */
		public function getBold() {
			return $this->bold;
		}

		/**
		 * Set bold.
		 */
		public function setBold($value) {
			$this->bold=$value;
		}

		/**
		 * String rep.
		 */
		public function toString() {
			//$t=str_replace("\n", "", substr($this->text, 0,80));
			$t=str_replace("\n", "#", $this->text);
			return '[TextNode style="'.$this->style.'" color="'.$this->color.'" bold="'.$this->bold.'" text="'.$t.'"]';
		}
	}