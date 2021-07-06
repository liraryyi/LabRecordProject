<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" +
            request.getServerPort() + request.getContextPath() + "/";
%>

<html>
<head>
    <base href="<%=basePath%>">
    <title>Title</title>
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript">
        $(function (){
            show();
        })
        function show(){
            var msg = "${msg}";
            if (msg.match("重新发邮件")){
              $("#reSendMail").css("display","inline");
            }
            if (msg.match("查收")){
                $("#reSendMail").css("display","inline");
            };
            if (msg.match("通过")){
                $("#login").css("display","inline");
            }
        }
    </script>
</head>
<body>
<h1>${msg}</h1>
<p><a id="reSendMail" style="display: none;" href="settings/user/repeatedMail.do?code='${userId}'">点击重发邮件</a></p>
<p><a id="login" style="display: none;" href="login.jsp">点击进入登录页面</a></p>
</body>
</html>