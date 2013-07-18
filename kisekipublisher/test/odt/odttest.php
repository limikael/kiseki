<?php

	require_once "../../src/KisekiPublisher.php";
	require_once "odt/OdtFile.php";

	$odt=new OdtFile("Lifewellness.zip");

	$nodes=$odt->getNodes();

	foreach ($nodes as $node) {
		echo "node: ".$node->toString()."\n";

		if ($node->getType()==OdtNode::TABLE) {
			$cellNodes=$node->getCellNodes(0,0);
			echo "  topleft".$cellNodes[0]->toString()."\n";
		}
	}