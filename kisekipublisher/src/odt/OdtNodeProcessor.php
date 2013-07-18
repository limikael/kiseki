<?php

	require_once "odt/OdtStyle.php";
	require_once "odt/OdtNode.php";
	require_once "odt/OdtTextNode.php";
	require_once "odt/OdtImageNode.php";
	require_once "odt/OdtTableNode.php";

	/**
	 * Process xml node(s) into odt nodes.
	 */
	class OdtNodeProcessor {

		private $odt;
		private $nodes;
		private $currentNode;

		/**
		 * Construct.
		 */
		public function OdtNodeProcessor($odt) {
			$this->odt=$odt;
		}

		/**
		 * Process node.
		 */
		public function processNode($textNode) {
			$this->nodes=array();

			$this->processTextNode($textNode,array());

			if ($this->currentNode && $this->currentNode->getText())
				$this->nodes[]=$this->currentNode;

			return $this->nodes;
		}

		/**
		 * Process text nodes.
		 */
		private function processTextNodes($nodes, $styleChain) {
			foreach ($nodes as $node)
				$this->processTextNode($node,$styleChain);
		}

		/**
		 * Precessing text node.
		 */
		private function processTextNode($node, $styleChain) {
			if ($node->nodeName=="office:annotation")
				return;

			if ($node->nodeName=="text:p" || $node->nodeName=="text:h" || $node->nodeName=="text:span")
				$styleChain[]=$this->odt->getStyleByName($node->getAttribute("text:style-name"));

			if ($node->nodeName=="text:a") {
				$st=new OdtStyle($this->odt);
				$st->setTarget($node->getAttribute("xlink:href"));
				$styleChain[]=$st;
			}

			if ($node->nodeType==XML_TEXT_NODE)
				$this->appendText($node->nodeValue, $styleChain);

			if ($node->nodeName=="text:s")
				$this->appendText(" ",$styleChain);

			if ($node->nodeName=="draw:image") {
				if ($this->currentNode && $this->currentNode->getText()) {
					$this->nodes[]=$this->currentNode;
					$this->currentNode=null;
				}

				$imageNode=new OdtImageNode($this->odt);
				$imageNode->parse($node);
				$this->nodes[]=$imageNode;
			}

			if ($node->nodeName=="table:table") {
				if ($this->currentNode && $this->currentNode->getText()) {
					$this->nodes[]=$this->currentNode;
					$this->currentNode=null;
				}

				$tableNode=new OdtTableNode($this->odt);
				$tableNode->parse($node);
				$this->nodes[]=$tableNode;
			}

			if ($node->hasChildNodes() && $node->nodeName!="table:table")
				$this->processTextNodes($node->childNodes,$styleChain);

			if ($node->nodeName=="text:p" || $node->nodeName=="text:h")
				$this->appendText("\n",$styleChain);
		}

		/**
		 * Append text to the current node.
		 */
		private function appendText($s, $styleChain) {
			$styleName=$this->getStyleNameFromChain($styleChain);
			$color=$this->getColorFromChain($styleChain);
			$bold=$this->getBoldFromChain($styleChain);
			$target=$this->getTargetFromChain($styleChain);

			if (!$this->currentNode || 
					$styleName!=$this->currentNode->getStyle() ||
					$color!=$this->currentNode->getColor() ||
					$bold!=$this->currentNode->getBold() ||
					$target!=$this->currentNode->getTarget()) {

				if ($this->currentNode && $this->currentNode->getText())
					$this->nodes[]=$this->currentNode;

				$this->currentNode=new OdtTextNode();
				$this->currentNode->setStyle($styleName);
				$this->currentNode->setColor($color);
				$this->currentNode->setBold($bold);
				$this->currentNode->setTarget($target);
			}

			//echo "style: $styleName text: $s\n";

			$this->currentNode->appendText($s);
		}

		/**
		 * Get style name from chain.
		 */
		private function getStyleNameFromChain($styleChain) {
			$styleName=null;

			foreach ($styleChain as $style)
				if ($style->getDisplayName())
					$styleName=$style->getDisplayName();

			return $styleName;
		}

		/**
		 * Get color from chain.
		 */
		private function getColorFromChain($styleChain) {
			$color=null;

			foreach ($styleChain as $style)
				if ($style->getColor())
					$color=$style->getColor();

			return $color;
		}

		/**
		 * Get bold from chain.
		 */
		private function getBoldFromChain($styleChain) {
			foreach ($styleChain as $style)
				if ($style->getBold())
					return true;

			return false;
		}

		/**
		 * Get target from chain.
		 */
		private function getTargetFromChain($styleChain) {
			foreach ($styleChain as $style)
				if ($style->getTarget())
					return $style->getTarget();

			return null;
		}
	}