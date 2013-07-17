<?php

	/**
	 * A style in a ODT document.
	 */
	class OdtStyle {

		private $name;
		private $parent;
		private $displayName;
		private $odt;
		private $isDefined;
		private $color;
		private $bold;

		/**
		 * Constructor.
		 */
		public function OdtStyle($odt) {
			$this->odt=$odt;
			$this->bold=false;
		}

		/**
		 * Explicitly defined?
		 */
		public function setIsDefined($value) {
			$this->isDefined=$value;
		}

		/**
		 * Parse style node.
		 */
		public function parse($node) {
			if ($node->nodeName!="style:style")
				throw new Exception("unexpected: ".$node->nodeName." in style declaration.");

			$this->name=$node->getAttribute("style:name");
			if (!$this->name)
				throw new Exception("Style doesn't have a name: ".$node->ownerDocument->saveXML($node));

			$parentName=$node->getAttribute("style:parent-style-name");
			if ($parentName)
				$this->parent=$this->odt->getStyleByName($parentName);

			foreach ($node->getElementsByTagName("text-properties") as $textProperties) {
				//echo "parsing style prop..\n";
				$this->color=$textProperties->getAttribute("fo:color");

				if ($textProperties->getAttribute("fo:font-weight")=="bold")
					$this->bold=true;
			}

			$this->displayName=$node->getAttribute("style:display-name");
		}

		/**
		 * Get name.
		 */
		public function getName() {
			return $this->name;
		}

		/**
		 * Get display name.
		 */
		public function getDisplayName() {
			if ($this->isDefined) {
				if ($this->displayName)
					return $this->displayName;

				return $this->name;
			}

			if ($this->parent)
				return $this->parent->getDisplayName();

			return null;
		}

		/**
		 * Get color.
		 */
		public function getColor() {
			if ($this->color)
				return $this->color;

			if ($this->parent)
				return $this->parent->getColor();

			return "#000000";
		}

		/**
		 * Get bold.
		 */
		public function getBold() {
			return $this->bold;
		}
	}