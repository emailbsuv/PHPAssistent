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
$config = json_decode($_POST["config"],true);
$contact = json_decode($_POST["contact"],true);
$config1=array();$config2=array();
			
	if ($result = mysqli_query($link, "SELECT * FROM sites")) {
		$b=mysqli_num_rows($result);
		if($b>0) 
		{
			$rz1 = mysqli_query($link, "SELECT * FROM users WHERE userid='".$_POST["userid"]."'");
			$rz2 = mysqli_fetch_assoc($rz1);
			while($r6 = mysqli_fetch_assoc($result))
			{
				if(strpos($rz2["bannedsites"],$r6["domain"])==false)
				$config1[]=array($r6["country"],$r6["domain"],$r6["intervaldays"],$r6["messenger"],$r6["contact"]);
			}
			
			for($i=0;$i<count($config);$i++)
			{
				$i0 = -1;
				for($i1=0;$i1<count($config1);$i1++)
				   if($config[$i][1]==$config1[$i1][1])$i0=$i1;
			    if($rz2["banned"] != "1")
			    if($i0==-1){
					$r1 = mysqli_query($link, "SELECT max( id ) as mid FROM sites");
					$r2 = mysqli_fetch_assoc($r1);$mid=$r2["mid"]+1;
					mysqli_query($link, "INSERT INTO sites VALUES (".$mid.",'".$config[$i][0]."','".$config[$i][1]."','".$config[$i][2]."','".$contact[0]."','".$contact[1]."','".$_POST["userid"]."')");
				}
			}
			for($i=0;$i<count($config1);$i++)
			{
				$i0 = -1;
				for($i1=0;$i1<count($config);$i1++)
				   if($config1[$i][1]==$config[$i1][1])$i0=$i1;
			    if($i0==-1)$config2[]=$config1[$i];
			}			
		}else
		{
			for($i=0;$i<count($config);$i++)
			if($rz2["banned"] != "1")	
			{
				$r1 = mysqli_query($link, "SELECT max( id ) as mid FROM sites");
				$r2 = mysqli_fetch_assoc($r1);$mid=$r2["mid"]+1;
				mysqli_query($link, "INSERT INTO sites VALUES (".$mid.",'".$config[$i][0]."','".$config[$i][1]."','".$config[$i][2]."','".$contact[0]."','".$contact[1]."','".$_POST["userid"]."')");
			}

		}
	}
	//if(count($usersmsgs)>0){$f=fopen('tmp.txt','a');fwrite($f,print_r(myjson_encode($dialogs)."\r\n\r\n",true));fclose($f);}
   // $f=fopen('tmp.txt','a');fwrite($f,print_r($_POST["config"],true));fclose($f);
//echo print_r(json_encode(json_decode("[[\"Russia1\",\"www.hh.ru1\",\"2021-03-05 23:38:29\",\"12\"]]",true)),true);
echo json_encode($config2);