<?php

	require_once "documentnode/DocumentTableRow.php";

	/**
	 * A table in a word processor document.
	 */
	class DocumentTable {

		private $rows;

		/**
		 * Construct.
		 */
		public function DocumentTable() {
		}

		/**
		 * Parse table node.
		 */
		public function parseTableNode($tableNode) {
			$this->rows=array();

			foreach ($tableNode->getRows() as $row) {
				$tableRow=new DocumentTableRow();

				foreach ($row as $cells) {
					$parser=new DocumentNodeParser();
					$tableRow->addCellNode($parser->parseNodes($cells));
				}

				$this->rows[]=$tableRow;
			}
		}

		/**
		 * Get cell.
		 */
		public function getRow($index) {
			return $this->rows[$index];
		}

		/**
		 * Get rows.
		 */
		public function getRows() {
			return $this->rows;
		}

		/**
		 * Get cell.
		 */
		public function getCell($row, $col) {
			return $this->rows[$row]->getCell($col);
		}
	}