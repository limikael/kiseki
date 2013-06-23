<!DOCTYPE html>
<html>
	<head>
		<title>Kiseki Publisher: <?php echo $page["title"]; ?></title>
		<link rel="stylesheet" type="text/css" href="?file=publisher.css" />
		<meta charset="utf-8" />
	</head>
	<body>
		<div id="canvas-wrapper">
			<div id="canvas">
				<h1><?php echo $page["title"]; ?></h1>
				<span class="description"><?php echo $page["description"]; ?></span>
				<hr/>

				<?php if (array_key_exists("buildpane",$page)) { ?>
					<div class="buildpane">
						<h2>Build</h2>
						<textarea id="log"></textarea>
					</div><br/>
					<form action="?">
						<input type="submit" value="Back"/>
					</form>
				<?php } else { ?>
					<div class="leftpane">
						<h2>Build</h2>
						<span class="description">
							Click the button below to rebuild the project in order to preview and download changes.
						</span>
						<br/><br/>
						<form method="get" action="?action=build">
							<input type="hidden" name="action" value="build"/>
							<input type="submit" value="Build"/>
						</form>
					</div>

					<div class="rightpane">
						<h2>Preview & Download</h2>
						<span class="description">
							Use these links to preview and download the application.
						</span>
						<br/>
						<ul>
							<?php foreach ($page["targetlinks"] as $link) { ?>
								<li><a href="<?php echo $link->getUrl(); ?>" 
									   target="<?php echo $link->getTarget(); ?>">
									<?php echo $link->getLabel(); ?>
								</a></li>
							<?php } ?>
						</ul>
					</div>
					<div style="clear: both;"></div>
					<hr/>
					<h2>Documents</h2>
					<span class="description">
						Use these links to edit content documents related to the application.
					</span>
					<br/><br/>
					<?php foreach ($page["sourcelinks"] as $link) { ?>
						<img src="?file=documenticon.png" class="documenticon"/>
						<a href="<?php echo $link->getUrl(); ?>" 
						   target="<?php echo $link->getTarget(); ?>">
							<?php echo $link->getLabel(); ?>
						</a>
						<br/>
					<?php } ?>
					<div style="height: 20px"></div>
				<?php } ?>
			</div>
		</div>
	</body>
</html>