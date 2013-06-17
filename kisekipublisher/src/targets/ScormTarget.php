<?php

	/**
	 * Browser preview target.
	 */
	class ScormTarget implements ITarget {

		private $publisher;
		private $filename;

		/**
		 * Browser preview target.
		 */
		public function ScormTarget($fn) {
			$this->filename=$fn;
		}

		/**
		 * Set publisher.
		 */
		public function setPublisher($p) {
			$this->publisher=$p;
		}

		/**
		 * Get link.
		 */
		public function getLink() {
			if (file_exists($this->publisher->getOutputDir()."/main.swf"))
				return new Link(
					"Download SCORM",
					$this->publisher->getOutputUrl()."/".$this->filename
				);

			return NULL;
		}

		/**
		 * Process.
		 */
		public function process() {
			$files=scandir($this->publisher->getOutputDir());

			$zip=new ZipArchive();
			$zip->open($this->publisher->getOutputDir()."/".$this->filename,ZIPARCHIVE::OVERWRITE);

			foreach ($files as $file) {
				if (is_file($this->publisher->getOutputDir()."/".$file)) {
					$this->publisher->message("Adding file: ".$file);
					$zip->addFile($this->publisher->getOutputDir()."/".$file,$file);
					$allFiles[]=$file;
				}
			}

			foreach (scandir(__DIR__."/../scormfiles") as $file) {
				if ($file[0]!=".") {
					$this->publisher->message("Adding scorm file: ".$file);
					$zip->addFile(__DIR__."/../scormfiles/".$file,$file);
					$allFiles[]=$file;
				}
			}

			$replacements=array(
				"@@TITLE@@"=>$this->publisher->getTitle(),
				"@@DESCRIPTION@@"=>$this->publisher->getDescription(),
				"@@SWF@@"=>"main.swf",
				"@@RESOURCELIST@@"=>""
			);

			foreach ($allFiles as $file)
				$replacements["@@RESOURCELIST@@"].="<file href=\"$file\"/>";

			foreach (scandir(__DIR__."/../scormtemplates") as $file) {
				if ($file[0]!=".") {
					$this->publisher->message("Generating: ".$file);
					$template=file_get_contents(__DIR__."/../scormtemplates/".$file);
					$template=self::replaceAll($replacements,$template);
					$zip->addFromString($file,$template);
				}
			}

			$this->publisher->message("Generating scorm: ".$this->filename);
			$zip->close();
		}

		/**
		 * Replace all occurences.
		 */
		private static function replaceAll($replacements, $template) {
			foreach ($replacements as $key=>$value)
				$template=str_replace($key,$value,$template);

			return $template;
		}
	}