<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String basePath = request.getScheme() + "://" + request.getServerName() + ":" +
          request.getServerPort() + request.getContextPath() + "/";
%>
<!doctype html>
<html lang="en">
<head>
  <base href="<%=basePath%>">
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->

  <title>Fixed Top Navbar Example for Bootstrap</title>

  <!-- Bootstrap core CSS -->
  <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" rel="stylesheet">
  <!--字体-->
  <link href="https://fonts.googleapis.com/css?family=Yanone+Kaffeesatz" rel="stylesheet" type="text/css">
  <!--monthly-css-->
  <link rel="stylesheet" href="css/monthly.css">
  <style type="text/css">
    body {
      font-family: Calibri;
      background-color: #f0f0f0;
      padding: 0em 1em;
    }
    #mycalendar {
      width: 100%;
      margin: 2em auto 0 auto;
      max-width: 80em;
      border: 1px solid #666;
    }

  </style>
</head>

<body>
    <h1 style="font-family: 'Yanone Kaffeesatz', sans-serif;
			text-align: center;
			font-size: 50px;
			text-shadow: 0 0px 30px rgba(0, 0, 0, 0.2);">my calendar</h1>
    <!--生成日历的div-->
    <div class="monthly" id="mycalendar"></div>



<!-- Bootstrap core JavaScript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script src="https://code.jquery.com/jquery-1.12.4.min.js" integrity="sha384-nvAa0+6Qg9clwYCGGPpDQLVpLNn0fRaROjHqs13t4Ggj3Ez50XnGQqc/r8MhnRDZ" crossorigin="anonymous"></script>
<script>window.jQuery || document.write('<script src="jquery/jquery-1.11.1-min.js"><\/script>')</script>
<script src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script src="jquery/cropper/cropper.js"></script>

<script type="text/javascript" src="js/monthly.js"></script>
<script type="text/javascript">

  $(function (){

    $.ajax({

      url:"workbench/calendar/getMonthly.do",
      data :{
        loginAct:"${user.loginAct}"
      },
      type:"get",
      dataType : "json",
      success :function (data){

        var sampleEvents = {"monthly":data};

        //加载日历
        $('#mycalendar').monthly({
          mode: 'event',
          dataType: 'json',
          events: sampleEvents
        });
      }
    });

  })

</script>
</body>
</html>