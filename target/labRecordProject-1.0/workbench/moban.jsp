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

    <!--cropper-->
    <link href="jquery/cropper/cropper.css" rel="stylesheet">

    <!--monthly-css-->
    <link rel="stylesheet" href="css/monthly.css">

    <link rel="stylesheet" href="css/template.css">
  </head>

  <body>

  <!-- 修改密码的模态窗口 -->
  <div class="modal fade" id="editPwdModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 70%;">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">
            <span aria-hidden="true">×</span>
          </button>
          <h4 class="modal-title">修改密码</h4>
        </div>
        <div class="modal-body">
          <form class="form-horizontal" role="form">
            <div class="form-group">
              <label for="oldPwd" class="col-sm-2 control-label">原密码</label>
              <div class="col-sm-10" style="width: 300px;">
                <input type="text" class="form-control" id="oldPwd" style="width: 200%;">
              </div>
            </div>

            <div class="form-group">
              <label for="newPwd" class="col-sm-2 control-label">新密码</label>
              <div class="col-sm-10" style="width: 300px;">
                <input type="text" class="form-control" id="newPwd" style="width: 200%;">
              </div>
            </div>

            <div class="form-group">
              <label for="confirmPwd" class="col-sm-2 control-label">确认密码</label>
              <div class="col-sm-10" style="width: 300px;">
                <input type="text" class="form-control" id="confirmPwd" style="width: 200%;">
              </div>
            </div>
            <div class="checkbox"  style="position: relative;top: 30px; left: 10px;">

              <span id="msg" style="color: #c7254e"></span>

            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
          <button type="button" class="btn btn-primary" id="updatePwdBtn">更新</button>
        </div>
      </div>
    </div>
  </div>

  <!--更换头像的模态窗口-->
  <div class="modal fade" id="changeModal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
          <h4 class="modal-title text-primary">
            <i class="fa fa-pencil"></i>
            更换头像
          </h4>
        </div>
        <div class="modal-body">
          <p class="tip-info text-center">
            未选择图片
          </p>
          <div class="img-container hidden">
            <img src="" alt="" id="photo">
          </div>
          <div class="img-preview-box hidden">
            <hr>
            <span>150*150:</span>
            <div class="img-preview img-preview-lg">
            </div>
            <span>100*100:</span>
            <div class="img-preview img-preview-md">
            </div>
            <span>30*30:</span>
            <div class="img-preview img-preview-sm">
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <label class="btn btn-danger pull-left" for="photoInput">
            <input type="file" class="sr-only" id="photoInput" accept="image/*">
            <span>打开图片</span>
          </label>
          <button class="btn btn-primary disabled" disabled="true" onclick="sendPhoto();">提交</button>
          <button class="btn btn-close" aria-hidden="true" data-dismiss="modal">取消</button>
        </div>
      </div>
    </div>
  </div>

  <div>
    <!--导航栏-->
    <div style="height: 50px;width: 100%;">
        <!-- 导航 -->
      <nav class="navbar navbar-default navbar-fixed-top">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed liClass" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <!--1主页-->
          <a class="navbar-brand" href="workbench/calendar/calendar.jsp" target="workareaFrame">My calendar</a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
          <ul class="nav navbar-nav">
            <!--2-->
            <li class="liClass"><a href="workbench/calendar/index.jsp" target="workareaFrame">calendar</a></li>
            <!--3-->
            <li class="liClass"><a href="workbench/idea/index.jsp" target="workareaFrame">idea</a></li>
            <!--4-->
            <li class="liClass"><a href="workbench/plan/index.jsp" target="workareaFrame">plan</a></li>
            <!--5下拉框-->
            <li class="dropdown liClass">
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
            <%--<li><a href="navbar/">Default</a></li>
            <li><a href="navbar-static-top/">Static top</a></li>
            <li><a href="./">Fixed top <span class="sr-only">(current)</span></a></li>--%>

            <!--用户图标-->
            <li class="dropdown" style="float: right">
              <a href="#" class="dropdown-toggle"
                 data-toggle="dropdown"
                 style="height: 50px">

                <!--这里加一个隐藏域保存userId，方便js文件取值-->
                <input type="hidden" id="hidden-userId" value="${user.id}"/>

                <img id="user-photo" alt="" src="${user.path}" class="img-circle" style="width: 30px;height: 30px"/>
                <span style="color: #000000;font-size: 15px">
                                <i>${user.loginAct}</i>
                  <!--这里加一个隐藏域保存loginAct，方便js文件取值-->
                <input type="hidden" id="user-loginAct" value="${user.loginAct}"/>
                  </span>
              </a>
              <div class="dropdown-menu pull-right"
                   style="background: #FFFFFF;width: 320px;overflow: hidden">
                <div style="margin-top: 16px;border-bottom: 1px solid #eeeeee">
                  <div style="text-align: center">
                    <img class="img-circle" src="${user.path}"
                         style="width: 38px;height: 38px;"/>
                  </div>
                  <div style="color: #323534;text-align: center;line-height: 36px;font-size: 15px">
                    <span>${user.loginAct}</span>
                  </div>
                </div>

                <div class="row" style="margin-left: 15px;margin-right: 15px;margin-top: 10px">
                  <div class="col-md-4 text-center grid">
                    <i class="fa fa-user" style="font-size: 25px;line-height: 45px;"></i>
                    <p style="padding: 0px;margin-top: 6px;margin-bottom: 10px;font-size: 12px">
                      该功能还没有开发哦</p>
                  </div>
                  <div class="col-md-4 text-center grid">
                    <i class="fa fa-gear" style="font-size: 25px;line-height: 45px;"></i>
                    <p style="padding: 0px;margin-top: 6px;margin-bottom: 10px;font-size: 12px">
                      该功能还没有开发哦</p>
                  </div>
                  <div class="col-md-4 text-center grid" id="editPwd">
                    <i class="fa fa-key" style="font-size: 25px;line-height: 45px;"></i>
                    <p style="padding: 0px;margin-top: 6px;margin-bottom: 10px;font-size: 12px">
                      密码修改</p>
                  </div>
                </div>

                <div class="row" style="margin-left: 15px;margin-right: 15px;margin-top: 10px">
                  <div class="col-md-4 text-center grid" id="changePhoto">
                    <i class="fa fa-user-circle" style="font-size: 25px;line-height: 45px;"></i>
                    <p style="padding: 0px;margin-top: 6px;margin-bottom: 10px;font-size: 12px">
                      修改头像</p>
                  </div>
                  <div class="col-md-4 text-center grid">
                    <i class="fa fa-comments" style="font-size: 25px;line-height: 45px;"></i>
                    <p style="padding: 0px;margin-top: 6px;margin-bottom: 10px;font-size: 12px">
                      该功能还没有开发哦</p>
                  </div>
                  <div class="col-md-4 text-center grid">
                    <i class="fa fa-heart-o" style="font-size: 25px;line-height: 45px;"></i>
                    <p style="padding: 0px;margin-top: 6px;margin-bottom: 10px;font-size: 12px">
                      该功能还没有开发哦</p>
                  </div>
                </div>


                <div class="row" style="margin-top: 20px">
                  <div class="text-center"
                       style="padding: 15px;margin: 0px;background: #f6f5f5;color: #323534;"
                        onclick="window.location.href='settings/user/quit.do'">
                    <i class="fa fa-sign-out"></i> 退出登入界面
                  </div>
                </div>
              </div>
            </li>
          </ul>

        </div><!--/.nav-collapse -->
      </div>
    </nav>
    </div>

    <div class="jumbotron" style="position: absolute;top: 50px; bottom: 0px; left: 0px; right: 0px; overflow: auto">
      <!-- 工作区 -->
      <div id="workarea" style="position: absolute; top : 0px; left: 0px; width: 100%; height: 100%;">
        <iframe style="border-width: 0px; width: 100%; height: 100%;" name="workareaFrame"></iframe>
      </div>

    </div>

  </div>

    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="https://code.jquery.com/jquery-1.12.4.min.js" integrity="sha384-nvAa0+6Qg9clwYCGGPpDQLVpLNn0fRaROjHqs13t4Ggj3Ez50XnGQqc/r8MhnRDZ" crossorigin="anonymous"></script>
    <script>window.jQuery || document.write('<script src="jquery/jquery-1.11.1-min.js"><\/script>')</script>
    <script src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script src="jquery/cropper/cropper.js"></script>

    <script type="text/javascript" src="js/monthly.js"></script>

    <script type="text/javascript" src="js/template.js"></script>
    <script type="text/javascript">
      $(function (){
        window.open("workbench/calendar/calendar.jsp","workareaFrame");
      })
    </script>
  </body>
</html>
