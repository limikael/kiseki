<?php

	require_once "documentnode/DocumentNode.php";
	require_once "documentnode/DocumentTable.php";

	/**
	 * Parses an odt into a document node hierarchy.
	 */
	class DocumentNodeParser {

		private $styleHierarchy;
		private $rootNode;
		private $levelNodes;

		/**
		 * Constructor.
		 */
		public function DocumentNodeParser() {
			$this->styleHierarchy=array("Title","Heading 1","Heading 2","Heading 3","Standard");
		}

		/**
		 * Get level by style name.
		 */
		private function getLevelByStyleName($name) {
			for ($i=0; $i<sizeof($this->styleHierarchy); $i++)
				if ($this->styleHierarchy[$i]==$name)
					return $i;

			throw new Exception("Unknown style: ".$name);
		}

		/**
		 * Is this a body node?
		 */
		private function isBodyNode($odtNode) {
			if ($odtNode->getType()==OdtNode::IMAGE)
				return true;

			if ($odtNode->getType()==OdtNode::TABLE)
				return true;

			if ($this->getLevelByStyleName($odtNode->getStyle())==sizeof($this->styleHierarchy)-1)
				return true;

			else
				return false;
		}

		/**
		 * Find current parent.
		 */
		private function findCurrentParent($level) {
			//echo "finding for level $level\n";
			if ($level==0)
				return $this->rootNode;

			$level--;

			while (!isset($this->levelNodes[$level])) {
				if ($level==0)
					return $this->rootNode;

				$level--;
			}

			return $this->levelNodes[$level];
		}

		/**
		 * Create a document node from an odt.
		 */
		public function parseOdt($odt) {
			return $this->parseNodes($odt->getNodes());
		}

		/**
		 * Parse array of nodes.
		 */
		public function parseNodes($nodes) {
			$this->rootNode=new DocumentNode();
			$this->levelNodes=array();
			$currentNode=$this->rootNode;

			foreach ($nodes as $odtNode) {
				if ($this->isBodyNode($odtNode)) {
					switch ($odtNode->getType()) {
						case OdtNode::IMAGE:
							$currentNode->addImage($odtNode);
							break;

						case OdtNode::TEXT:
							if ($odtNode->getColor()!="#ff0000")
								$currentNode->appendBody($odtNode->getText());
							break;

						case OdtNode::TABLE;
							$table=new DocumentTable();
							$table->parseTableNode($odtNode);
							$currentNode->addTable($table);
							break;
					}
				}

				else {
					$currentNode=new DocumentNode();
					$currentNode->setTitle($odtNode->getText());
					$level=$this->getLevelByStyleName($odtNode->getStyle());
					$this->findCurrentParent($level)->addChild($currentNode);
					$this->levelNodes[$level]=$currentNode;
				}
			}

			//echo "root children: ".sizeof($this->rootNode->getChildren());

			return $this->rootNode;
		}
	}