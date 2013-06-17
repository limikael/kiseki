<?php

	require_once __DIR__."/../../src/KisekiPublisher.php";

	session_start();

/*	if (array_key_exists("code",$_GET))
		$_SESSION["code"]=$_GET["code"];

	if (array_key_exists("code",$_SESSION))
		$_GET["code"]=$_SESSION["code"];*/

	$client=new Google_Client();

	$client->setClientId('474936441337.apps.googleusercontent.com');
	$client->setClientSecret('Lyfe-KdyNClf2oMNzktd0UDy');
	$client->setRedirectUri('http://localhost/kiseki/kisekipublisher/test/drive/drivetest.php');
	$client->setScopes(array(
		'https://www.googleapis.com/auth/drive',
		'https://www.googleapis.com/auth/userinfo.email',
		'https://www.googleapis.com/auth/userinfo.profile'
	));

	$service = new Google_DriveService($client);

	if (array_key_exists("accessToken",$_SESSION) && substr($_SESSION["accessToken"],0,1)=="{") {
		echo "using old: ".$_SESSION["accessToken"];
		$client->setAccessToken($_SESSION["accessToken"]);
	}

	else {
		$accessToken=$client->authenticate();
		echo "setting access token: ".$accessToken;
		$_SESSION["accessToken"]=$accessToken;
		$client->setAccessToken($accessToken);
	}

//	echo "got access token: ".$accessToken;


/*	$decoded=json_decode($credentials,TRUE);
	$accessToken=$decoded["access_token"];

	echo "got access token: ".$accessToken;

	$client=new Google_Client();
	$client->setClientId('474936441337.apps.googleusercontent.com');
	$client->setClientSecret('Lyfe-KdyNClf2oMNzktd0UDy');
	$client->setUseObjects(true);
	$client->setAccessToken($credentials);

	echo "here again..";*/


/*	print "Please visit:\n$authUrl\n\n";
	print "Please enter the auth code:\n";
	$authCode = trim(fgets(STDIN));

	// Exchange authorization code for access token
	$accessToken = $client->authenticate($authCode);
	$client->setAccessToken($accessToken);*/

	$file=$service->files->get("1GeD9ezvRob5pDq_31xmbn7_l3S0K9wwd1oR53Nw1kMI");
//	print_r($file);

	$downloadUrl=$file["exportLinks"]["application/vnd.oasis.opendocument.text"];

	//echo $downloadUrl;

	$request=new Google_HttpRequest($downloadUrl);
	$httpRequest=Google_Client::$io->authenticatedRequest($request);
	$body=$httpRequest->getResponseBody();

	echo "download bytes: ".strlen($body)."\n";
//	file_put_contents("donwload.zip",);