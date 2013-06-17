<?php

	require_once "odt/OdtFile.php";
	require_once "documentnode/DocumentNodeParser.php";
	require_once "utils/ScriptUtil.php";

	/**
	 * Process a google text doc.
	 */
	class GoogleDocsTextSource implements ISource {

		private $template;
		private $id;
		private $target;
		private $documentNode;
		private $label;
		private $publisher;

		/**
		 * Process a google text doc.
		 */
		public function GoogleDocsTextSource($googleDriveLoader, $target, $template, $id, $label) {
			$this->googleDriveLoader=$googleDriveLoader;
			$this->label=$label;
			$this->target=$target;
			$this->id=$id;
			$this->template=$template;
		}

		/**
		 * Set publisher.
		 */
		public function setPublisher($publisher) {
			$this->publisher=$publisher;
		}

		/**
		 * Get edit link.
		 */
		public function getLink() {
			return new Link($this->label,"https://docs.google.com/document/d/".$this->id."/edit");
		}

		/**
		 * Run the template.
		 */
		private function runTemplate($documentNode) {
			$document=$documentNode;

			ob_start();
			include ScriptUtil::getScriptDir()."/".$this->template;
			$contents=ob_get_contents();
			ob_end_clean();

			return $contents;
		}

		/**
		 * Process the document.
		 */
		public function process() {
			$this->googleDriveLoader->setRedirectQuery("action=build");

			$contents=$this->googleDriveLoader->loadTextDocument($this->id);

			$this->publisher->message("Processing: ".$this->label." -> ".$this->target);

			$filename=sys_get_temp_dir()."/odt".rand();
			file_put_contents($filename,$contents);
			$odt=new OdtFile($filename);
			@unlink($filename);

			$parser=new DocumentNodeParser();
			$this->documentNode=$parser->parseOdt($odt);
			$this->documentNode->setImageTargetDir($this->publisher->getOutputDir());

			$output=$this->runTemplate($this->documentNode);
			file_put_contents($this->publisher->getOutputDir()."/".$this->target,$output);

			foreach ($this->documentNode->getUsedImages() as $imagefilename) {
				$this->publisher->message("  used image: ".$imagefilename);
				/*$im=$odt->getImage($imagefilename);
				file_put_contents($this->publisher->getOutputDir()."/".$imagefilename,$im);*/
			}
		}

		/**
		 * Get used images.
		 */
/*		public function getUsedImages() {
			return $this->documentNode->getUsedImages();
		}*/
	}