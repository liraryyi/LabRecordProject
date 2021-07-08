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


      <!--修改头像-->
      body{
        text-align: center;
      }
      #photo {
        max-width:100%;
        max-height:350px;
      }
      .img-preview-box {
        text-align: center;
      }
      .img-preview-box > div {
        display: inline-block;;
        margin-right: 10px;
      }
      .img-preview {
        overflow: hidden;
      }
      .img-preview-box .img-preview-lg {
        width: 150px;
        height: 150px;
      }
      .img-preview-box .img-preview-md {
        width: 100px;
        height: 100px;
      }
      .img-preview-box .img-preview-sm {
        width: 50px;
        height: 50px;
        border-radius: 50%;
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
            <li><a href="./">Fixed top <span class="sr-only">(current)</span></a></li>

            <!--用户图标-->
            <li class="dropdown" style="float: right">
              <a href="#" class="dropdown-toggle"
                 data-toggle="dropdown"
                 style="height: 50px">
                <img id="user-photo" alt="" src="${user.path}" class="img-circle" style="width: 30px;height: 30px"/>
                <span style="color: #000000;font-size: 15px">
                                <i>${user.loginAct}</i>
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
                    <span>username</span>
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

       //点击修改密码，弹出修改密码的模态窗口
       $("#editPwd").click(function (){

          $("#editPwdModal").modal("show");
          $("#oldPwd").val("");
          $("#newPwd").val("");
          $("#confirmPwd").val("");
          $("#msg").text("");

       });

       //点击更新密码，对密码进行修改
       $("#updatePwdBtn").click(function (){

          var oldPwd = $("#oldPwd").val();
          var newPwd = $("#newPwd").val();
          var confirmPwd = $("#confirmPwd").val();

          if (newPwd.length<6 ||newPwd.length>16){
            $("#msg").text("密码应该在6位至16位之间");
            return false;
          }

          if (newPwd != confirmPwd){
            $("#msg").text("新密码与确认密码不一致");
            return false;
          }

          $.ajax({

            url:"settings/user/editPwd.do",
            data :{
              "loginAct":"${user.loginAct}",
              "oldPwd":oldPwd,
              "newPwd":newPwd
            },
            type:"post",
            dataType : "json",
            success :function (data){
              if (data.flag){
                $("#msg").text(data.msg);

                var time=3;
                var timer = setInterval(function(){
                  if(time==0){
                    $("#editPwdModal").modal("hide");
                    clearInterval(timer);
                  }else{
                    time--;
                  }
                },1000)

              }else {
                $("#msg").text(data.msg);
              }
            }
          })
        })

      })

      $(".dropdown").mouseover(function () {
        $(this).addClass("open");
      });

      $(".dropdown").mouseleave(function () {
        $(this).removeClass("open");
      });

      //修改头像
      var initCropperInModal = function(img, input, modal){
        var $image = img;
        var $inputImage = input;
        var $modal = modal;
        var options = {
          aspectRatio: 1, // 纵横比
          viewMode: 2,
          preview: '.img-preview' // 预览图的class名
        };
        // 模态框隐藏后需要保存的数据对象
        var saveData = {};
        var URL = window.URL || window.webkitURL;
        var blobURL;

        $modal.on('show.bs.modal',function () {
          // 如果打开模态框时没有选择文件就自动点击“打开图片”按钮
          if(!$inputImage.val()){
            $inputImage.click();
          }
        }).on('shown.bs.modal', function () {
          // 重新创建
          $image.cropper( $.extend(options, {
            ready: function () {
              // 当剪切界面就绪后，恢复数据
              if(saveData.canvasData){
                $image.cropper('setCanvasData', saveData.canvasData);
                $image.cropper('setCropBoxData', saveData.cropBoxData);
              }
            }
          }));
        }).on('hidden.bs.modal', function () {
          // 保存相关数据
          saveData.cropBoxData = $image.cropper('getCropBoxData');
          saveData.canvasData = $image.cropper('getCanvasData');
          // 销毁并将图片保存在img标签
          $image.cropper('destroy').attr('src',blobURL);
        });

        if (URL) {
          $inputImage.change(function() {
            var files = this.files;
            var file;
            if (!$image.data('cropper')) {
              return;
            }
            if (files && files.length) {
              file = files[0];
              if (/^image\/\w+$/.test(file.type)) {

                if(blobURL) {
                  URL.revokeObjectURL(blobURL);
                }
                blobURL = URL.createObjectURL(file);

                // 重置cropper，将图像替换
                $image.cropper('reset').cropper('replace', blobURL);

                // 选择文件后，显示和隐藏相关内容
                $('.img-container').removeClass('hidden');
                $('.img-preview-box').removeClass('hidden');
                $('#changeModal .disabled').removeAttr('disabled').removeClass('disabled');
                $('#changeModal .tip-info').addClass('hidden');

              } else {
                window.alert('请选择一个图像文件！');
              }
            }
          });
        } else {
          $inputImage.prop('disabled', true).addClass('disabled');
        }
      }
      //修改头像
      var sendPhoto = function(){
        // 得到PNG格式的dataURL
        var photo = $('#photo').cropper('getCroppedCanvas', {
          width: 300,
          height: 300
        }).toDataURL('image/png');

        $.ajax({
          url: 'settings/user/savePhoto.do', // 要上传的地址
          type: 'post',
          data: {
            'id':"${user.id}",
            'imgData': photo
          },
          dataType: 'json',
          success: function (data) {
            if (data.flag) {
              // 将上传的头像的地址填入
              $('.img-circle').attr('src', data.imgPath);
              $('#changeModal').modal('hide');
            } else {
              alert(data.msg);
            }
          }
        });
      }
      //修改头像
      $(function(){
        initCropperInModal($('#photo'),$('#photoInput'),$('#changeModal'));

        $("#changePhoto").click(function (){
          $("#changeModal").modal("show");
        })
      });

    </script>
  </body>
</html>
