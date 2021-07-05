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

    <!--用户图标css-->
    <link rel="stylesheet" href="jquery/font-awesome-4.7.0/css/font-awesome.css">

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

    <!-- Fixed navbar -->
    <nav class="navbar navbar-default navbar-fixed-top">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <!--1主页-->
          <a class="navbar-brand" href="workbench/index.jsp">Project name</a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
          <ul class="nav navbar-nav">
            <!--2-->
            <li class="active"><a href="workbench/calendar/index.jsp">修改日历</a></li>
            <!--3-->
            <li><a href="#">About</a></li>
            <!--4-->
            <li><a href="#">Contact</a></li>
            <!--5下拉框-->
            <li class="dropdown">
              <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Dropdown <span class="caret"></span></a>
              <ul class="dropdown-menu">
                <li><a href="#">Action</a></li>
                <li><a href="#">Another action</a></li>
                <li><a href="#">Something else here</a></li>
                <li role="separator" class="divider"></li>
                <li class="dropdown-header">Nav header</li>
                <li><a href="#">Separated link</a></li>
                <li><a href="#">One more separated link</a></li>
              </ul>
            </li>
          </ul>
          <!--右边的3个-->
          <ul class="nav navbar-nav navbar-right">
            <li><a href="navbar/">Default</a></li>
            <li><a href="navbar-static-top/">Static top</a></li>
            <li class="active"><a href="./">Fixed top <span class="sr-only">(current)</span></a></li>

            <!--用户图标-->
            <li class="dropdown" style="float: right">
              <a href="#" class="dropdown-toggle"
                 data-toggle="dropdown"
                 style="height: 50px">
                <img alt="" class="img-circle" src="photo.jpg" width="30px" height="30px"/>
                <span style="color: #FFFFFF;font-size: 15px">
                                <i>username</i>
                  </span>
              </a>
              <div class="dropdown-menu pull-right"
                   style="background: #FFFFFF;width: 320px;overflow: hidden">
                <div style="margin-top: 16px;border-bottom: 1px solid #eeeeee">
                  <div style="text-align: center">
                    <img class="img-circle" src="photo.jpg"
                         style="width: 38px;height: 38px;"/>
                  </div>
                  <div style="color: #323534;text-align: center;line-height: 36px;font-size: 15px">
                    <span>username</span>
                  </div>
                </div>

                <div class="row" style="margin-left: 15px;margin-right: 15px;margin-top: 10px">
                  <div class="col-md-4 text-center grid">
                    <i class="fa fa-user" style="font-size: 25px;line-height: 45px;"></i>
                    <p style="padding: 0px;margin-top: 6px;margin-bottom: 10px;font-size: 12px">
                      个人中心</p>
                  </div>
                  <div class="col-md-4 text-center grid">
                    <i class="fa fa-gear" style="font-size: 25px;line-height: 45px;"></i>
                    <p style="padding: 0px;margin-top: 6px;margin-bottom: 10px;font-size: 12px">
                      账号管理</p>
                  </div>
                  <div class="col-md-4 text-center grid">
                    <i class="fa fa-key" style="font-size: 25px;line-height: 45px;"></i>
                    <p style="padding: 0px;margin-top: 6px;margin-bottom: 10px;font-size: 12px">
                      密码修改</p>
                  </div>
                </div>

                <div class="row" style="margin-left: 15px;margin-right: 15px;margin-top: 10px">
                  <div class="col-md-4 text-center grid">
                    <i class="fa fa-user-circle" style="font-size: 25px;line-height: 45px;"></i>
                    <p style="padding: 0px;margin-top: 6px;margin-bottom: 10px;font-size: 12px">
                      修改头像</p>
                  </div>
                  <div class="col-md-4 text-center grid">
                    <i class="fa fa-comments" style="font-size: 25px;line-height: 45px;"></i>
                    <p style="padding: 0px;margin-top: 6px;margin-bottom: 10px;font-size: 12px">
                      消息</p>
                  </div>
                  <div class="col-md-4 text-center grid">
                    <i class="fa fa-heart-o" style="font-size: 25px;line-height: 45px;"></i>
                    <p style="padding: 0px;margin-top: 6px;margin-bottom: 10px;font-size: 12px">
                      帮助中心</p>
                  </div>
                </div>


                <div class="row" style="margin-top: 20px">
                  <div class="text-center"
                       style="padding: 15px;margin: 0px;background: #f6f5f5;color: #323534;">
                    <i class="fa fa-sign-out"></i> 退出登入界面
                  </div>
                </div>
              </div>
            </li>
          </ul>

        </div><!--/.nav-collapse -->
      </div>
    </nav>
    <div class="container">

<!--      &lt;!&ndash; Main component for a primary marketing message or call to action &ndash;&gt;
      <div class="jumbotron">
        <h1>Navbar example</h1>
        <p>This example is a quick exercise to illustrate how the default, static and fixed to top navbar work. It includes the responsive CSS and HTML, so it also adapts to your viewport and device.</p>
        <p>To see the difference between static and fixed top navbars, just scroll.</p>
        <p>
          <a class="btn btn-lg btn-primary" href="components/#navbar" role="button">View navbar docs &raquo;</a>
        </p>
      </div>-->
      <div class="jumbotron">
      <h1>我的日历</h1>
        <!--生成日历的div-->
      <div class="monthly" id="mycalendar"></div>
      </div>

    </div> <!-- /container -->


    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="https://code.jquery.com/jquery-1.12.4.min.js" integrity="sha384-nvAa0+6Qg9clwYCGGPpDQLVpLNn0fRaROjHqs13t4Ggj3Ez50XnGQqc/r8MhnRDZ" crossorigin="anonymous"></script>
    <script>window.jQuery || document.write('<script src="jquery/jquery-1.11.1-min.js"><\/script>')</script>
    <script src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

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
        })
      })


      $(".dropdown").mouseover(function () {
        $(this).addClass("open");
      });

      $(".dropdown").mouseleave(function () {
        $(this).removeClass("open");
      });
/*      $(window).load( function() {
        $('#mycalendar').monthly({
          mode: 'event',
          dataType: 'json',
          events: sampleEvents
        });
      });*/
    </script>
  </body>
</html>
