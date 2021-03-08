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

	if ($result = mysqli_query($link, "SELECT * FROM users WHERE userid='".$_POST["userid"]."'")) {
		$b=mysqli_num_rows($result);
		if($b>0) 
		{
			$r6 = mysqli_fetch_assoc($result);
			mysqli_query($link, "UPDATE users SET bannedsites='".$r6["bannedsites"].$_POST["blocksites"]."' WHERE userid='".$_POST["userid"]."'");
		} else
		{
			
		}
	}