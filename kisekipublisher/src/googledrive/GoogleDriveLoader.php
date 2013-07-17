<?php

	require_once "Google_Client.php";
	require_once "contrib/Google_DriveService.php";
	require_once "utils/ScriptUtil.php";

	/**
	 * Google drive loader.
	 */
	class GoogleDriveLoader {

		private $clientJsonFile;
		private $privateKeyFile;

		private $client;
		private $service;

		private $redirectQuery;
		private $initialized;

		/**
		 * Constructor.
		 */
		public function GoogleDriveLoader($clientJsonFile=NULL, $privateKeyFile=NULL) {
			if (!$clientJsonFile)
				$clientJsonFile=__DIR__."/client.json";

			if (!$privateKeyFile)
				$privateKeyFile=__DIR__."/privatekey.p12";

			$this->clientJsonFile=$clientJsonFile;
			$this->privateKeyFile=$privateKeyFile;
			$this->initialized=FALSE;
		}

		/**
		 * Initialize
		 */
		public function initialize() {
			/*echo "about to initialize..".$this->clientJsonFile."<br/>";
			exit();*/
			$clientJson=json_decode(file_get_contents($this->clientJsonFile),TRUE);

			//print_r($clientJson);

			$this->client=new Google_Client();
			$this->client->setClientId($clientJson["web"]["client_id"]);

			$key=file_get_contents($this->privateKeyFile);
			$this->client->setAssertionCredentials(new Google_AssertionCredentials(
				$clientJson["web"]["client_email"],
				array('https://www.googleapis.com/auth/drive'),
				$key)
			);

			$this->service=new Google_DriveService($this->client);

			$this->initialized=TRUE;
		}

		/**
		 * Load text document.
		 */
		public function loadTextDocument($id) {
/*			echo "will initialize";
			exit();*/

			if (!$this->initialized)
				$this->initialize();

/*			echo "getting file ".($this->service->files);
			echo "init done..";
			exit();*/

			$file=$this->service->files->get($id);

/*			echo "got file: ";
			print_r($file);
			exit();*/

/*			if (!$file) {
				echo "unable";
				exit();
			}*/

			$downloadUrl=$file["exportLinks"]["application/vnd.oasis.opendocument.text"];

			$request=new Google_HttpRequest($downloadUrl);
			$httpRequest=Google_Client::$io->authenticatedRequest($request);
			$body=$httpRequest->getResponseBody();

			return $body;
		}
	}