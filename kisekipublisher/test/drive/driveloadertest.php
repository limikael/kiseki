<?php

	require_once __DIR__."/../../src/KisekiPublisher.php";

//	echo "hello";

	$loader=new GoogleDriveLoader();

	$doc=$loader->loadTextDocument("1M8eaq2vFTrIMjT1W14zJvTz-kxz1PO2l1i3lQtrDO8g");

	echo "got doc ".strlen($doc);

	file_put_contents("doc.zip",$doc);
