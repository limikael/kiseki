<?php $document=$document->getFirstChild(); ?>

<course>
	<Intro>
		<? $intro=$document->getChildByTitle("Intro Page")->getFirstChild(); ?>
		<header><? echo $intro->getTitle();?></header>
		<body><? echo $intro->getBody();?></body>
		<? if ($intro->hasImages()) { ?>
			<img src="<? echo $intro->useFirstImage(); ?>"/>
		<? } ?>
	</Intro>

	<? foreach ($document->getChildrenByTitle("Decision Page") as $i=>$decision) { ?>
		<Decision id="decision_<? echo $i; ?>">
			<transcript><? echo $decision->getBody(); ?></transcript>
			<question><? echo $decision->getChildByTitle("Question")->getBody(); ?></question>
			<audiostart><? echo $decision->getAttribute("start"); ?></audiostart>
			<audioend><? echo $decision->getAttribute("end"); ?></audioend>
			<audio src="prospectingcall.mp3"/>
			<alternatives>
				<? foreach ($decision->getChildrenByTitle("Alternative") as $alternative) { ?>
					<DecisionAlternative>
						<buttontext><? echo $alternative->getChildByTitle("Button Text")->getBody(); ?></buttontext>
						<feedback><? echo $alternative->getChildByTitle("Feedback")->getBody(); ?></feedback>
						<score><? echo $alternative->getAttribute("score"); ?></score>
						<? if ($alternative->hasAttribute("correct")) { ?>
							<correct>true</correct>
						<? } ?>
					</DecisionAlternative>
				<? } ?>
			</alternatives>
		</Decision>
	<? } ?>
</course>