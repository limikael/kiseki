<?php

	require_once __DIR__."/../../src/KisekiPublisher.php";

//	echo "hello";

	$loader=new GoogleDriveLoader();

	$doc=$loader->loadTextDocument("1QgGAv-pGZvODABiG1pcimTodn0OFpsEID0IIDWscAqs");

	echo "got doc ".strlen($doc);

