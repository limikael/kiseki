<?php

	/**
	 * Browser preview target.
	 */
	class FtpTarget implements ITarget {

		private $publisher;

		private $host;
		private $user;
		private $password;
		private $dir;

		/**
		 * Browser preview target.
		 */
		public function FtpTarget($host, $user, $password, $dir) {
			$this->host=$host;
			$this->user=$user;
			$this->password=$password;
			$this->dir=$dir;
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
			return NULL;
		}

		/**
		 * Process.
		 */
		public function process() {
			$this->publisher->message("Uploading to: ".$this->host);

			$conn=ftp_connect($this->host);

			if (!$conn)
				throw new Exception("Unable to connect to ftp server.");

			$res=ftp_login($conn,$this->user,$this->password);

			if (!$res)
				throw new Exception("Unable to login to ftp server.");

			ftp_pasv($conn,TRUE);

			$files=scandir($this->publisher->getOutputDir());

			foreach ($files as $file) {
				if (is_file($this->publisher->getOutputDir()."/".$file)) {
					$this->publisher->message("Uploading: ".$file);

					ftp_put($conn,$this->dir."/".$file,$this->publisher->getOutputDir()."/".$file,FTP_BINARY);
				}
			}

			ftp_close($conn);
		}
	}