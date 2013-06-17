<?php

	require_once "../../kisekipublisher/src/KisekiPublisher.php";

	$p=new KisekiPublisher();
	$p->initializeGoogleDrive("474936441337.apps.googleusercontent.com","Lyfe-KdyNClf2oMNzktd0UDy");
	$p->setTitle("Kiseki Test Course");
	$p->setDescription("Test various kiseki features.");
	$p->addGoogleTextDoc("content.xml","1K2vUhxSas5vDSlxRLDuSjDad7XC2CEmrZ-NNo9DZhTc","content.xml.php");
	$p->dispatch();