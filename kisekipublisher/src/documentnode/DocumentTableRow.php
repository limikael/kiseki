<?php

	/**
	 * A row in a table.
	 */
	class DocumentTableRow {

		private $cellNodes;

		/**
		 * Construct.
		 */
		public function DocumentTableRow() {
			$this->cellNodes=array();
		}

		/**
		 * Add a cell node.
		 */
		public function addCellNode($node) {
			$this->cellNodes[]=$node;
		}

		/**
		 * Get cell.
		 */
		public function getCell($index) {
			return $this->cellNodes[$index]->getBody();
		}

		/**
		 * Get cell node.
		 */
		public function getCellNode($index) {
			return $this->cellNodes[$index];
		}

		/**
		 * Get cell node.
		 */
		public function getCellNodes() {
			return $this->cellNodes;
		}

		/**
		 * Get cell bodies.
		 */
		public function getCells() {
			$a=array();

			foreach ($this->cellNodes as $node)
				$a[]=$node->getBody();

			return $a;
		}
	}