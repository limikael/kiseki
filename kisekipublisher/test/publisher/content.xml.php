<?php $document=$document->getFirstChild(); ?>

<course>
	<Intro>
		<?php $intro=$document->getChildByTitle("Intro Page")->getFirstChild(); ?>
		<header><?php echo $intro->getTitle();?></header>
		<body><?php echo $intro->getBody();?></body>
		<?php if($intro->hasImages()) { ?>
			<img src="<?php echo $intro->useFirstImage(); ?>"/>
		<?php } ?>
	</Intro>

	<?php foreach ($document->getChildrenByTitle("Decision Page") as $i=>$decision) { ?>
		<Decision id="decision_<?php echo $i; ?>">
			<transcript><?php echo $decision->getBody(); ?></transcript>
			<question><?php echo $decision->getChildByTitle("Question")->getBody(); ?></question>
			<audiostart><?php echo $decision->getAttribute("start"); ?></audiostart>
			<audioend><?php echo $decision->getAttribute("end"); ?></audioend>
			<audio src="prospectingcall.mp3"/>
			<alternatives>
				<?php foreach ($decision->getChildrenByTitle("Alternative") as $alternative) { ?>
					<DecisionAlternative>
						<buttontext><?php echo $alternative->getChildByTitle("Button Text")->getBody(); ?></buttontext>
						<feedback><?php echo $alternative->getChildByTitle("Feedback")->getBody(); ?></feedback>
						<score><?php echo $alternative->getAttribute("score"); ?></score>
						<?php if ($alternative->hasAttribute("correct")) { ?>
							<correct>true</correct>
						<?php } ?>
					</DecisionAlternative>
				<?php } ?>
			</alternatives>
		</Decision>
	<?php } ?>
</course>
