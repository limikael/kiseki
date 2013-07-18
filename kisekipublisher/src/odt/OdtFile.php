<?php

	require_once "odt/OdtStyle.php";
	require_once "odt/OdtNode.php";
/*	require_once "odt/OdtTextNode.php";
	require_once "odt/OdtImageNode.php";*/
	require_once "odt/OdtNodeProcessor.php";

	/**
	 * ODT file parser.
	 */
	class OdtFile {

		private $zip;
		private $contentDom;
		private $stylesDom;
		private $stylesByName;
		private $nodes;

		/**
		 * Constructor.
		 */
		public function OdtFile($filename) {
			$this->zip=new ZipArchive();
			$res=$this->zip->open($filename);

			if (!$res)
				throw new Exception("Unable to open zip file.");

			$this->stylesByName=array();
			$this->nodes=array();

			$this->contentDom=$this->getDomFromZip("content.xml");
			$this->stylesDom=$this->getDomFromZip("styles.xml");

			$this->parseStyles();
			$this->parseText();
		}

		/**
		 * Get dom from zip file.
		 */
		private function getDomFromZip($name) {
			$file=$this->zip->getFromName($name);
			if (!$file)
				throw new Exception("File not found in zip: ".$name);

			$dom=new DOMDocument();
			$res=$dom->loadXML($file);
			if (!$res)
				throw new Exception("Unable to parse xml.");

			return $dom;
		}

		/**
		 * Get first immidiate child node by name.
		 */
		private function getChildElement($node, $name) {
			foreach ($node->childNodes as $child) {
				if ($child->nodeType==XML_ELEMENT_NODE && $child->nodeName==$name)
					return $child;
			}

			throw new Exception("Node ".$node->nodeName." doesn't have child node ".$name);
		}

		/**
		 * Parse styles.
		 */
		private function parseStyles() {
			$contentNode=$this->getChildElement($this->stylesDom,"office:document-styles");
			$stylesNode=$this->getChildElement($contentNode,"office:styles");
			$this->parseStyleNodes($stylesNode,true);

			$contentNode=$this->getChildElement($this->contentDom,"office:document-content");
			$stylesNode=$this->getChildElement($contentNode,"office:automatic-styles");
			$this->parseStyleNodes($stylesNode,false);
		}

		/**
		 * Parse style nodes.
		 */
		public function parseStyleNodes($parent, $isDefined) {
			foreach ($parent->childNodes as $node) {
				if ($node->nodeName!="style:default-style" &&
						$node->nodeName!="text:notes-configuration") {
					$style=new OdtStyle($this);
					$style->setIsDefined($isDefined);
					$style->parse($node);

					$this->stylesByName[$style->getName()]=$style;
				}
			}
		}

		/**
		 * Get style by name.
		 */
		public function getStyleByName($name) {
			$style=$this->stylesByName[$name];
			if (!$style)
				throw new Exception("Style not found: "+$name);

			return $style;
		}

		/**
		 * Parse text.
		 */
		private function parseText() {
			$contentNode=$this->getChildElement($this->contentDom,"office:document-content");
			$bodyNode=$this->getChildElement($contentNode,"office:body");
			$textNode=$this->getChildElement($bodyNode,"office:text");

			$processor=new OdtNodeProcessor($this);
			$this->nodes=$processor->processNode($textNode);
		}

		/**
		 * Get nodes.
		 */
		public function getNodes() {
			return $this->nodes;
		}

		/**
		 * Get image file.
		 */
		public function getImage($imageFile) {
			//echo "getting image: $imageFile";
			$res=$this->zip->getFromName($imageFile);

			if (!$res)
				throw new Exception("Image not found in archive: ".$imageFile);

			return $res;				
		}
	}