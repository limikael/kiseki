<?php

	require_once "Google_Client.php";
	require_once "contrib/Google_DriveService.php";
	require_once "utils/ScriptUtil.php";

	/**
	 * Google drive loader.
	 */
	class GoogleDriveLoader {

		private $clientId;
		private $clientSecret;

		private $client;
		private $service;

		private $redirectQuery;
		private $initialized;

		/**
		 * Constructor.
		 */
		public function GoogleDriveLoader($clientId, $clientSecret) {
			$this->clientId=$clientId;
			$this->clientSecret=$clientSecret;
			$this->initialized=FALSE;
		}

		/**
		 * Query to be sent along the redirect url.
		 */
		public function setRedirectQuery($q) {
			$this->redirectQuery=$q;
		}

		/**
		 * Initialize
		 */
		public function initialize() {
			if (!session_id())
				session_start();

			$this->client=new Google_Client();
			$this->client->setClientId($this->clientId);
			$this->client->setClientSecret($this->clientSecret);

			$url=ScriptUtil::getScriptUrl();
			if ($this->redirectQuery)
				$url.="?".$this->redirectQuery;

			$this->client->setRedirectUri($url);
			$this->client->setScopes(array('https://www.googleapis.com/auth/drive'));

			$this->service=new Google_DriveService($this->client);

			if (array_key_exists("googleAccessToken",$_SESSION) && substr($_SESSION["googleAccessToken"],0,1)=="{") {
				$this->client->setAccessToken($_SESSION["googleAccessToken"]);
			}

			else {
				$googleAccessToken=$this->client->authenticate();
				//echo "setting access token: ".$googleAccessToken;
				$_SESSION["googleAccessToken"]=$googleAccessToken;
				$this->client->setAccessToken($googleAccessToken);
			}

			$this->initialized=TRUE;
		}

		/**
		 * Load text document.
		 */
		public function loadTextDocument($id) {
			if (!$this->initialized)
				$this->initialize();

			$file=$this->service->files->get($id);
			$downloadUrl=$file["exportLinks"]["application/vnd.oasis.opendocument.text"];

			$request=new Google_HttpRequest($downloadUrl);
			$httpRequest=Google_Client::$io->authenticatedRequest($request);
			$body=$httpRequest->getResponseBody();

			return $body;
		}
	}