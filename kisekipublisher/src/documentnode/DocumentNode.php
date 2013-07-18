<?php

	/**
	 * Treat a word processor document as a hierarchy of nodes.
	 */
	class DocumentNode {

		private $title;
		private $body;
		private $htmlBody;
		private $images;
		private $tables;
		private $attributes;
		private $children;
		private $imageTargetDir;
		private $usedImages;

		/**
		 * Document node.
		 */
		public function DocumentNode() {
			$this->children=array();
			$this->attributes=array();
			$this->images=array();
			$this->imageTargetDir=".";
			$this->usedImages=array();
			$this->tables=array();
			$this->body="";
			$this->htmlBody="";
		}

		/**
		 * Set target dir for images.
		 */
		public function setImageTargetDir($dir) {
			$this->imageTargetDir=$dir;

			foreach ($this->children as $child)
				$child->setImageTargetDir($dir);

			foreach ($this->tables as $table)
				$table->setImageTargetDir($dir);
		}

		/**
		 * Get title of the node.
		 */
		public function getTitle() {
			return str_replace('"',"",$this->title);
		}

		/**
		 * Get body of the node.
		 */
		public function getBody() {
			return trim(str_replace('"',"",$this->body));
		}

		/**
		 * Get body of the node.
		 */
		public function getHtmlBody() {
			return nl2br(trim(str_replace('"',"",$this->htmlBody)));
		}

		/**
		 * Add image.
		 */
		public function addImage($imageOdtNode) {
			$this->images[]=$imageOdtNode;
		}

		/**
		 * Add table.
		 */
		public function addTable($documentTable) {
			$this->tables[]=$documentTable;
		}

		/**
		 * Tables?
		 */
		public function hasTables() {
			return sizeof($this->tables)!=0;
		}

		/**
		 * Get first table.
		 */
		public function getFirstTable() {
			if (!$this->hasTables())
				throw new Exception("Node doesn't have any tables.");

			return $this->tables[0];
		}

		/**
		 * Get tables.
		 */
		public function getTables() {
			return $this->tables;
		}

		/**
		 * Get images.
		 */
		public function getImages() {
			$a=array();

			foreach ($this->images as $image)
				$a[]=$image->getFileName();

			return $a;
		}

		/**
		 * Are there any images?
		 */
		public function hasImages() {
			return sizeof($this->images)!=0;
		}

		/**
		 * Use image.
		 */
		public function useImage($filename) {
			$this->usedImages[]=$filename;

			foreach ($this->images as $image) {
				if ($image->getFileName()==$filename) {
					$res=file_put_contents($this->imageTargetDir."/".$image->getFileName(),$image->getImage());

					if (!$res)
						throw new Exception("Unable to write ".$image->getFileName());

					return $image->getFileName();
				}
			}

			throw new Exception("Image not found in node: ".$filename);
		}

		/**
		 * Use first image.
		 */
		public function useFirstImage() {
			if (!$this->hasImages())
				throw new Exception("Node does not have any images.");

			$firstImage=$this->images[0];
			return $this->useImage($firstImage->getFileName());
		}

		/**
		 * Does the attribute exist?
		 */
		public function hasAttribute($name) {
			return array_key_exists($name, $this->attributes);
		}

		/**
		 * Get attribute.
		 */
		public function getAttribute($name) {
			return $this->attributes[$name];
		}

		/**
		 * Get child nodes.
		 */
		public function getChildren() {
			return $this->children;
		}

		/**
		 * Get child by title.
		 */
		public function getChildByTitle($name) {
			foreach ($this->children as $child)
				if ($child->getTitle()==$name)
					return $child;

			throw new Exception("Section ".$this->getTitle()." doesn't have a section named ".$name);
		}

		/**
		 * Internal.
		 */
		private function findChildByTitleInternal($name) {
			if ($this->getTitle()==$name)
				return $this;

			foreach ($this->children as $child) {
				$cand=$child->findChildByTitleInternal($name);

				if ($cand)
					return $cand;
			}

			return null;
		}

		/**
		 * Find child by title.
		 */
		public function findChildByTitle($name) {
			$child=$this->findChildByTitleInternal($name);

			if (!$child)
				throw new Exception("Section ".$this->getTitle()." doesn't have a section named ".$name);

			return $child;
		}

		/**
		 * Get children by title.
		 */
		public function getChildrenByTitle($name) {
			$res=array();

			foreach ($this->children as $child)
				if ($child->getTitle()==$name)
					$res[]=$child;

			return $res;
		}

		/**
		 * Get child by title.
		 */
		public function getFirstChild() {
			if (sizeof($this->children)<1)
				throw new Exception("Element ".$this->getTitle()." does not have any children.");
				
			return $this->children[0];
		}

		/**
		 * Add child.
		 */
		public function addChild($value) {
			$this->children[]=$value;
		}

		/**
		 * Set title.
		 */
		public function setTitle($value) {
			$this->title=$value;
		}

		/**
		 * Append to body.
		 */
		public function appendBody($value, $bold, $anchorTarget) {
			$found=TRUE;

			while ($found) {
				$found=preg_match("/(\n|^)\\@([A-Za-z]+):([^\n]*)(\n|$$)/",$value,$matches);

				if ($found) {
					$attrs[trim($matches[2])]=trim($matches[3]);

					if ($matches[0][0]=="\n" && $matches[0][strlen($matches[0])-1]=="\n")
						$replace="\n";

					else
						$replace="";

					$value=preg_replace("/(\n|^)\\@([A-Za-z]+):([^\n]*)(\n|$$)/",$replace,$value,1);
				}
			}

			if ($anchorTarget)
				$this->htmlBody.='<a href="'.$anchorTarget.'">';

			if ($bold)
				$this->htmlBody.="<b>";

			$this->htmlBody.=$value;

			if ($bold)
				$this->htmlBody.="</b>";

			if ($anchorTarget)
				$this->htmlBody.='</a>';

			$this->body.=$value;
		}

		/**
		 * Spaces.
		 */
		private function spaces($num) {
			$res="";

			for ($i=0; $i<$num; $i++)
				$res.=" ";

			return $res;
		}

		/**
		 * Format.
		 */
		public function format($indent=0) {
			$res=$this->spaces($indent)."[".$this->title."]\n";
			$res.=$this->spaces($indent+2).$this->body."\n";
			foreach ($this->children as $child)
				$res.=$child->format($indent+2);

			return $res;
		}

		/**
		 * Get used images.
		 */
		public function getUsedImages() {
			$res=$this->usedImages;

			foreach ($this->children as $child)
				$res=array_merge($res,$child->getUsedImages());

			foreach ($this->tables as $table)
				$res=array_merge($res,$table->getUsedImages());

			return $res;
		}

		/**
		 * Load.
		 */
		public static function load($fn) {
			$odt=new OdtFile($fn);
			$parser=new DocumentNodeParser();
			return $parser->parseOdt($odt);
		}
	}
