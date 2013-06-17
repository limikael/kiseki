<?php

	require_once "odt/OdtNode.php";

	/**
	 * A node in a ODT document.
	 */
	class OdtTextNode extends OdtNode {

		private $text;
		private $style;
		private $color;

		/**
		 * Constructor.
		 */
		public function OdtTextNode() {
			$this->text="";
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
		 * String rep.
		 */
		public function toString() {
			$t=str_replace("\n", "", substr($this->text, 0,80));
			return "[TextNode style=\"".$this->style."\" color=\"".$this->color."\" text=\"".$t."\"]";
		}
	}