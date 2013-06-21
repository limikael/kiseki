<?php

	require_once "../../src/KisekiPublisher.php";
	require_once "documentnode/DocumentNode.php";

	$node=DocumentNode::load("Coachspelet.odt");
	$questionNode=$node->findChildByTitle("Question");

	echo $questionNode->getTitle()."\n";
	echo $questionNode->getBody()."\n";

	$table=$questionNode->getFirstTable();
	echo $table->getCell(0,0)."\n";

	foreach ($table->getRows() as $row) {
		echo "row: ".$row->getCell(0).":".$row->getCell(1)."\n";
	}