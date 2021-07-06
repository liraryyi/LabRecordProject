<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" +
request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript">
		$(function (){

			//设置当前页面始终为顶层窗口
			if (window.top != window){
				window.top.location = window.location;
			}

			//页面加载完毕后，清空用户文本框
			$("#loginAct").val("");

			//页面加载完毕后，让用户的文本框自动获得焦点
			$("#loginAct").focus();

			//登录按钮绑定事件，进行登陆操作
			$("#submitBtn").click(function (){
				login();
			})

			//键盘的回车键绑定事件，进行登陆操作
			$(window).keydown(function (){
				if (event.keyCode ==13){
					login();
				}
			})
		})

		//登录方法,注意普通方法应该写在$(function(){})的外面
		function login() {
			//账号，密码不能为空
			//$.trim():去掉文本中的左右空格
			var loginAct = $.trim($("#loginAct").val());
			var loginPwd = $.trim($("#loginPwd").val());

			if (loginAct == "" || loginPwd == ""){
				$("#msg").html("账号密码不能为空")
				return false;
			}

			//页面局部刷新 ajax
			$.ajax({

				//url:传递到后台的地址
				url:"settings/user/login.do",
				//data:传递给后台的数据
				data :{
					"loginAck":loginAct,
					"loginPwd":loginPwd
				},
				type:"post",
				dataType : "json",
				success :function (data){
					/**
					 * data:传过来的数据json
					 * {"success":true/false  , "msg":"错误的种类"}
					 */
					if (data.success){
						window.location.href = "workbench/index.html";
					} else {
						$("#msg").html(data.msg);
					}
				}
			})
		}

		//如果账号没有激活，点击重新激活
		function show(){
			var msg = $("#msg").val();
			if (msg.match("激活")){
				$("#reSendMail").css("display","inline");
			}
		}

	</script>
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 100%;">
		<img src="image/efPictrue.PNG" style="width: 100%; height: 100%; position: relative; ">
	</div>
	<div style="position: absolute; top: 150px; right: 100px;width:450px;height:400px; background-color: white">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1 >登录</h1>
			</div>
			<form  class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" type="text" placeholder="用户名" id="loginAct">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" type="password" placeholder="密码" id="loginPwd">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						
							<span id="msg" style="color: #c7254e"></span>

					</div>
					<button type="button" id="submitBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
			<div class="page-header" style="width: 80px; height: 15px; position: relative ; top: 20px ;left: 250px">
				<button type="button" class="btn-primary btn-lg btn-block" onclick="window.location.href = 'register.jsp'">注册</button>
			</div>
		</div>
	</div>
</body>
</html>