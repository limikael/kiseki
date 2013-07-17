<?php

	set_include_path(get_include_path().PATH_SEPARATOR.__DIR__."/../extern/google-api-php-client/src");
	set_include_path(get_include_path().PATH_SEPARATOR.__DIR__);

	require_once "googledrive/GoogleDriveLoader.php";
	require_once "utils/Link.php";
	require_once "utils/ErrorUtil.php";

	require_once "sources/ISource.php";
	require_once "sources/NmeSource.php";
	require_once "sources/GoogleDocsTextSource.php";
	require_once "sources/FileSource.php";

	require_once "targets/ITarget.php";
	require_once "targets/BrowserPreviewTarget.php";
	require_once "targets/ScormTarget.php";
	require_once "targets/FtpTarget.php";

	/**
	 * Kiseki publisher.
	 */
	class KisekiPublisher {

		private $title;
		private $description;

		private $messagesShown;
		private $outputDir;
		private $outputUrl;

		private $sources;
		private $targets;

		/**
		 * Construct.
		 */
		public function KisekiPublisher() {
			$this->title="Kiseki project";
			$this->description="No project description available.";
			$this->sources=array();
			$this->targets=array();
			$this->messagesShown=FALSE;
			$this->setOutputDir("build");
		}

		/**
		 * Set output dir.
		 */
		public function setOutputDir($value) {
			$this->outputDir=ScriptUtil::getScriptDir()."/".$value;
			$this->outputUrl=$value;
		}

		/**
		 * Get output dir.
		 */
		public function getOutputDir() {
			return $this->outputDir;
		}

		/**
		 * Get output url.
		 */
		public function getOutputUrl() {
			return $this->outputUrl;
		}

		/**
		 * Set title.
		 */
		public function setTitle($value) {
			$this->title=$value;
		}

		/**
		 * Get title.
		 */
		public function getTitle() {
			return $this->title;
		}

		/**
		 * Get description.
		 */
		public function getDescription() {
			return $this->description;
		}

		/**
		 * Set description.
		 */
		public function setDescription($value) {
			$this->description=$value;
		}

		/**
		 * Add Source.
		 */
		public function addSource($source) {
			$source->setPublisher($this);
			$this->sources[]=$source;
		}

		/**
		 * Add target.
		 */
		public function addTarget($target) {
			$target->setPublisher($this);
			$this->targets[]=$target;
		}

		/**
		 * Show main page.
		 */
		private function showMain($buildPane=FALSE) {
			$page=array();
			$page["title"]=$this->title;
			$page["description"]=$this->description;

			if ($buildPane)
				$page["buildpane"]=TRUE;

			$page["sourceslinks"]=array();

			foreach ($this->sources as $source)
				if ($source->getLink())
					$page["sourcelinks"][]=$source->getLink();

			$page["targetlinks"]=array();

			foreach ($this->targets as $target)
				if ($target->getLink())
					$page["targetlinks"][]=$target->getLink();

			$page["buildinfo"]="No current build.";

			require __DIR__."/templates/main.tpl.php";
		}

		/**
		 * Print message.
		 */
		public function message($message) {
			if (!$this->messagesShown) {
				@apache_setenv('no-gzip', 1);
				@ini_set('zlib.output_compression', 0);
				@ini_set('implicit_flush', 1);

				$levels=ob_get_level();
				for ($i=0; $i<$levels; $i++) {
					ob_end_flush();
				}

				ob_implicit_flush(TRUE);
				$this->showMain(TRUE);

				$this->messagesShown=TRUE;
				echo "\n";

				for ($i=0; $i<1024; $i++)
					echo "\n";

				echo '<script type="text/javascript">var el=document.getElementById("log");</script>'."\n";

				flush();
			}

			foreach (explode("\n", $message) as $m) {
				echo '<script type="text/javascript">';
				echo 'el.value+="'.addslashes($m).'\n";';
				echo 'el.scrollTop=el.scrollHeight;';
				echo '</script>'."\n";
			}

			flush();
		}

		/**
		 * Compile.
		 */
		private function build() {
			ErrorUtil::errorsAsExceptions();

			$files=scandir($this->getOutputDir());

			$this->message("Building '".$this->title."' ...");

			try {
				foreach ($files as $f)
					if ($f[0]!=".")
						@unlink($this->getOutputDir()."/".$f);

				$this->message("processing");

				foreach ($this->sources as $source) {
					$this->message("processing source");
					$source->process();
				}

				$this->message("sources done, processing targets");

				foreach ($this->targets as $target)
					$target->process();

				$this->message("*** DONE ***");
			}

			catch (Exception $e) {
				$this->message($e->getMessage());
				$this->message($e->getTraceAsString());
				exit();
			}
		}

		/**
		 * Build and preview.
		 */
		private function buildAndPreview() {
			$this->build();

			echo '<script type="text/javascript">';
			echo 'document.getElementById("preview-holder").style.display="block";';
			echo 'var flashvars = {};';
			echo 'var params = {"base": "build"};';
			echo 'var attributes = {id: "Main", name: "Main"};';
			echo 'swfobject.embedSWF("build/main.swf?t='.rand(0,100000).'", "preview-content", "100%", "100%", "11.0.0", "expressInstall.swf", flashvars, params, attributes);';
			echo '</script>'."\n";
		}

		/**
		 * Serve file.
		 */
		private function serveFile($fn) {
			$fn=str_replace("/","",$fn);
			$ext=pathinfo($fn,PATHINFO_EXTENSION);

			switch ($ext) {
				case "css":
					header("Content-type: text/css");
					break;

				case "png":
					header("Content-type: image/png");
					break;

				case "js":
					header("Content-type: text/javascript");
					break;
			}

			readfile(__DIR__."/files/".$fn);
		}

		/**
		 * Dispatch call.
		 */
		public function dispatch() {
			ini_set('display_errors',TRUE);

			if (array_key_exists("file",$_REQUEST)) {
				$this->serveFile($_REQUEST["file"]);
				return;
			}

			if (array_key_exists("action",$_REQUEST))
				$action=$_REQUEST["action"];

			else if (array_key_exists("buildpreview",$_REQUEST))
				$action="buildpreview";

			else if (array_key_exists("build",$_REQUEST))
				$action="build";

			else
				$action="main";

			switch($action) {
				case "build":
					$this->build();
					break;

				case "buildpreview":
					$this->buildAndPreview();
					break;

				case "main":
				default:
					$this->showMain();
			}
		}
	}
