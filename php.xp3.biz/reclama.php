<?php

/*
MySQL Main Database name: 251556
MySQL Database username: 251556
MySQL Database password: 123321qweewq
MySQL Database host: localhost 
*/
header ("Access-Control-Allow-Origin: *");
//$link = mysqli_connect("127.0.0.1", "nacha_base", "7?24ohoW", "nachalosaita_base");
$link = mysqli_connect("localhost", "251556", "123321qweewq", "251556");
mysqli_set_charset($link, "utf8");
$message = 'Реклама размещена.';
$newname = rand(111111,999999).".png";
mysqli_query($link, "DELETE FROM reclama WHERE dtimeexpired<'".date("Y-m-d H:i:s")."'");

	if ($result = mysqli_query($link, "SELECT * FROM users WHERE userid='".$_POST["userid"]."'")) {
		$b=mysqli_num_rows($result);
		if($b>0) 
		{
			$r6 = mysqli_fetch_assoc($result);
			if($r6["bannedr"]=="1")$message = "Подайте запрос на размещение рекламы в\r\n Telegram: @bogdansuvorov";
			else 
			{
				$r0 = mysqli_query($link, "SELECT * FROM reclama WHERE userid='".$_POST["userid"]."'");
				$b=mysqli_num_rows($r0);
				if($b>0) 
				{
					$r01 = mysqli_fetch_assoc($r0);unlink(getcwd()."/img/".$r01["filename"]);
					mysqli_query($link, "UPDATE reclama SET filename='".$newname."',linkname='".$_POST["linkname"]."', dtimeexpired='".date("Y-m-d H:i:s")."' WHERE userid='".$_POST["userid"]."'");
				}else
				{
					$r1 = mysqli_query($link, "SELECT max( id ) as mid FROM reclama");
					$r2 = mysqli_fetch_assoc($r1);$mid=$r2["mid"]+1;
					mysqli_query($link, "INSERT INTO reclama VALUES (".$mid.",'".$_POST["linkname"]."','".$newname."','".$_POST["userid"]."','".date("Y-m-d H:i:s",strtotime("+1 month"))."')");
				}
				
			}	
		} else
		{
			$message = 'Error.';
		}
	}

	if($message == 'Реклама размещена.'){

			$uploadedfile = $_FILES["tmp_name"]['tmp_name'];
			$extension = strtolower(str_replace("image/","",$_FILES["tmp_name"]['type']));
			
			if($extension=="jpg" || $extension=="jpeg" ){
				$uploadedfile = $_FILES["tmp_name"]['tmp_name'];
				$src = imagecreatefromjpeg($uploadedfile);
			}else if($extension=="png"){
				$uploadedfile = $_FILES["tmp_name"]['tmp_name'];
				$src = imagecreatefrompng($uploadedfile);
			}else{
				$uploadedfile = $_FILES["tmp_name"]['tmp_name'];
				$src = imagecreatefromgif($uploadedfile);
			}
			list($width,$height)=getimagesize($uploadedfile);

			$newwidth=165;
			$newheight=70;
			$tmp=imagecreatetruecolor($newwidth,$newheight);

			imagecopyresampled($tmp,$src,0,0,0,0,$newwidth,$newheight, $width,$height);

			$filename = getcwd ()."/img/".$newname;
			imagepng($tmp,$filename,0);
			//$f=fopen('tmp.txt','a');fwrite($f,print_r($_FILES,true));fclose($f);
			
			imagedestroy($src);
			imagedestroy($tmp);		
	}
echo $message;