<!DOCTYPE html>
<!--
This file created by Philip Hutchison, April 2008. http://pipwerks.com/lab/scorm

Updated October 2011. Revision includes updated SCORM wrapper, cleaned up AS3 in SWF,
switch from XHTML to HTML5 markup, and switch from SWFObject 1.5 to SWFObject 2.2.

Licensed under the Creative Commons Attribution 3.0 Unported License.
To view a copy of this license, visit http://creativecommons.org/licenses/by/3.0/ or send a letter to
Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA
-->
<html lang="en">
<head>
<title><? echo $page["title"]; ?></title>
<meta charset="utf-8" />
<style>
body { background: #000000; margin: 0; height: 100%; padding: 0; color: red; text-align: center; }
#flash { width: 100%; height: 100%; margin: 0; display: block; }
</style>

<script src="?file=swfobject.js"></script>

<script>
//Embed the SWF
flashvars={persistence: "so", preventcache: true};
swfobject.embedSWF("?action=swf", "flash", "600", "500", "9", "expressInstall.swf",flashvars);
</script>

</head>

<body>
<div id="flash">This course requires Flash Player version 9 or higher.</div>
</body>
</html>
