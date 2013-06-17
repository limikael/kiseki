<?php

	require_once "../../src/KisekiPublisher.php";

	$p=new KisekiPublisher();
	$p->initializeGoogleDrive("474936441337.apps.googleusercontent.com","Lyfe-KdyNClf2oMNzktd0UDy");
	$p->setTitle("Be Deric Lipski");
	$p->setDescription("Deric Lipski, Real Estate Broker, Easton, Massachusetts.");
	$p->addGoogleTextDoc("content.xml","1K2vUhxSas5vDSlxRLDuSjDad7XC2CEmrZ-NNo9DZhTc","content.xml.php");
	/*$p->setSwf("Salesdemo.swf");
	$p->addFile("Salesdemo.xml");*/
	$p->dispatch();