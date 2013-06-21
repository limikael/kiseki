<?php

	require_once "odt/OdtNode.php";

	/**
	 * A table node in a ODT document.
	 */
	class OdtTableNode extends OdtNode {

		private $odt;
		private $rows;

		/**
		 * Construct.
		 */
		public function OdtTableNode($odt) {
			$this->odt=$odt;
		}

		/**
		 * Get node type.
		 */
		public function getType() {
			return OdtNode::TABLE;
		}

		/**
		 * Parse.
		 */
		public function parse($tableXml) {
			$this->rows=array();

			if ($tableXml->nodeName!="table:table")
				throw new Exception("not a table node");

			foreach ($tableXml->childNodes as $rowXml) {
				if ($rowXml->nodeName=="table:table-row") {
					$cells=array();

					foreach ($rowXml->childNodes as $cellXml) {
						if ($cellXml->nodeName=="table:table-cell") {
							$processor=new OdtNodeProcessor($this->odt);
							$nodes=$processor->processNode($cellXml);
							//echo "nodes in cell: ".sizeof($nodes)."\n";
							$cells[]=$nodes;
						}
					}

					$this->rows[]=$cells;
				}
			}
		}

		/**
		 * Get debug string.
		 */
		public function toString() {
			return "[TableNode nomRows=".sizeof($this->rows)."]";
		}

		/**
		 * Get nodes in cell.
		 */
		public function getCellNodes($row, $col) {
			return $this->rows[$row][$col];
		}

		/**
		 * Get rows.
		 */
		public function getRows() {
			return $this->rows;
		}
	}