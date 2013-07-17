<?php

	$s="@start: 5\n@two: 5\nhello\nworld\n@attr: 34\n@x: y\ntest\n@attragain: bla\n@c: 7";
//	$s="hello\nworld\ntest\n@attragain: bla";

	echo $s."\n---\n";

	$attrs=array();

	$found=TRUE;

	while ($found) {
		$found=preg_match("/(\n|^)\\@([A-Za-z]+):([^\n]*)(\n|$$)/",$s,$matches);

		if ($found) {
			$attrs[trim($matches[2])]=trim($matches[3]);

			if ($matches[0][0]=="\n" && $matches[0][strlen($matches[0])-1]=="\n")
				$replace="\n";

			else
				$replace="";

			$s=preg_replace("/(\n|^)\\@([A-Za-z]+):([^\n]*)(\n|$$)/",$replace,$s,1);
		}
	}

	print_r($attrs);

	echo "---\n";
	echo $s;