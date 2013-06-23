<?php

	require_once __DIR__."/../../src/KisekiPublisher.php";

	$client=new Google_Client();

	$client->setClientId('474936441337-1dbuifbat2iceacknbq4bbh6160te3pm.apps.googleusercontent.com');

	$key=file_get_contents("privatekey.p12");
	$client->setAssertionCredentials(new Google_AssertionCredentials(
		"474936441337-1dbuifbat2iceacknbq4bbh6160te3pm@developer.gserviceaccount.com",
		array('https://www.googleapis.com/auth/drive'),
		$key)
	);

	$service = new Google_DriveService($client);

	$file=$service->files->get("1QgGAv-pGZvODABiG1pcimTodn0OFpsEID0IIDWscAqs");

	$downloadUrl=$file["exportLinks"]["application/vnd.oasis.opendocument.text"];

	echo "downloadurl: ".$downloadUrl."\n";

	$request=new Google_HttpRequest($downloadUrl);
	$httpRequest=Google_Client::$io->authenticatedRequest($request);
	$body=$httpRequest->getResponseBody();

	echo "download bytes: ".strlen($body)."\n";
