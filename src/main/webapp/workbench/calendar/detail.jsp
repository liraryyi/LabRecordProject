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
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<link href="jquery/bootStrap-colorpicker/css/bootstrap-colorpicker.css" type="text/css" rel="stylesheet">

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<!--颜色选择器插件-->
	<script type="text/javascript" src="jquery/bootStrap-colorpicker/js/bootstrap-colorpicker.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});

		showCalendar_remark();

		//使用鼠标操作动态滑入滑出，展示删除和修改按钮
		$("#remarkBody").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		})
		$("#remarkBody").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		})

		//点击确定保存Remark信息
		$("#saveRemarkBtn").click(function (){
			$.ajax({

				url:"workbench/calendar_remark/saveRemarkCalendar.do",
				data :{
					"noteContext": $("#remark").val(),
					"calendarId": "${calendar.id}"
				},
				type:"post",
				dataType : "json",
				success :function (data){
					if (data.success){

						showCalendar_remark();
						$("#remark").val("");
					}else {
						alert("保存失败")
					}
				}
			})
		})

		//点击更新 保存Remark信息
		$("#updateRemarkBtn").click(function (){

			$.ajax({

				url:"workbench/calendar_remark/updateRemarkCalendar.do",
				data :{
					"id":$("#remarkId").val(),
					"noteContent":$("#noteContent").val()
				},
				type:"post",
				dataType : "json",
				success :function (data){
					if (data.success) {
						showCalendar_remark()

						$("#editRemarkModal").modal("hide");
					}else {
						alert("更新失败");
					}
				}
			})
		})

		//为编辑按钮绑定事件，点击打开模态窗口
		$("#updateCalendarBtn").click(function (){

				$.ajax({

					url:"workbench/calendar/getCalendar.do",
					data :{
						"id": "${calendar.id}"
					},
					type:"get",
					dataType : "json",
					success :function (data){

						$("#edit-calendarOwner").val(data.loginAct);
						$("#edit-calendarName").val(data.name);
						$("#edit-startDate").val(data.startDate);
						$("#edit-endDate").val(data.endDate);
						$("#edit-colordemo").val(data.color);
						$("#edit-colordemo").css('background-color',data.color);
						$("#edit-color").text(data.color);
						$("#edit-url").val(data.url);
						$("#edit-description").val(data.description);
					}
				})

				$("#editCalendarModal").modal("show");
		})

		//为更新按钮绑定事件，点击将已经修改的信息保存到数据库中
		$("#edit-updateBtn").click(function (){

			$.ajax({

				url:"workbench/calendar/updateCalendar.do",
				data :{
					"id":"${calendar.id}",
					"loginAct": $.trim($("#edit-calendarOwner").val()),
					"name": $.trim($("#edit-calendarName").val()),
					"startDate": $.trim($("#edit-startDate").val()),
					"endDate":$.trim($("#edit-endDate").val()),
					"color":$.trim($("#edit-color").val()),
					"url":$.trim($("#edit-url").val()),
					"description":$.trim($("#edit-description").val())
				},
				type:"post",
				dataType : "json",
				success :function (data){

					//传过来的数据success
					if (data.success){
						$("#CalendarEditForm")[0].reset();

						$("#editCalendarModal").modal("hide");

						location.reload(true);
					}else {
						alert("保存失败")
					}
				}
			})
		})

		$('#edit-colordemo').colorpicker({
			preferredFormat : "hex" ,
			showAlpha: false
		});
		// 添加change事件 改变背景色
		$('#edit-colordemo').on('change', function (event) {
			$('#edit-colordemo').css('background-color', event.color.toHexString()).val('');
			$("#edit-color").text(event.color.toHexString());
			$("#edit-colordemo").val(event.color.toHexString());
		});

		$(".start_time").datetimepicker({
			//格式化：年月日时分秒
			format: 'yyyy-mm-dd hh:ii',
			//	选择后自动关闭
			autoclose: true,
			//	分钟的步长
			minuteStep: 1,
			//	语言
			language: 'zh-CN',
			//	显示今天按钮
			todayBtn: true,
			//	层级
			bootcssVer: 3,
		}).on('changeDate', function (e) {
			var startDate = $('.start_time').val();
			$(".end_time").datetimepicker('setStartDate', startDate);
			$(".start_time").datetimepicker('hide');
		});
		$('.end_time').datetimepicker({
			format: 'yyyy-mm-dd hh:ii',
			autoclose: true,
			minuteStep: 1,
			language: 'zh-CN',
			todayBtn: true,
			bootcssVer: 3,
		}).on('changeDate', function (e) {
			var returnDate = $(".end_time").val();
			$(".start_time").datetimepicker('setReturnDate', returnDate);
			$(".end_time").datetimepicker('hide');
		});
	});

	//刷新日历活动备注列表
	function showCalendar_remark(){
		$.ajax({

			url:"workbench/calendar_remark/getRemarkCalendarList.do",
			data :{
				"calendarId": "${calendar.id}"
			},
			type:"get",
			dataType : "json",
			success :function (data){

				/**
				 * 分析一下，这里前端需要的参数，传过来的就是Activity_remark对象list
				 * data[{1},{2},{3}]
				 */
				var html ="";

				$.each(data,function (i,n){

					/*
                    javascript:void(0) 将超链接禁用，只能以触发事件的形式操作
                     */
					html += '<div class="remarkDiv" style="height: 60px;">';
					html += '<img title="zhangsan" src="image/efPictrue.PNG" style="width: 30px; height:30px;">';
					html += '<div style="position: relative; top: -40px; left: 40px;" >';
					html += '<h5>'+n.noteContent+'</h5>';
					html += '<font color="gray">日历计划</font> <font color="gray">-</font> <b>${calendar.name}</b> <small style="color: gray;"> '+(n.editFlag==1?n.editTime:n.createTime)+' 由'+(n.editFlag==1?n.editBy:n.createBy)+'</small>';
					html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					html += '<a class="myHref" href="javascript:void(0);" onclick="openUpdateRemark(\''+n.id+'\',\''+n.noteContent+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
					html += '&nbsp;&nbsp;&nbsp;&nbsp;';
					html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
					html += '</div>';
					html += '</div>';
					html += '</div>';
				})

				$("#calendarRemarkDiv").html(html);
			}
		})
	}

	//删除选择的备注信息表
	function deleteRemark(id){

		if (confirm("确定要删除吗？")) {
			$.ajax({

				url: "workbench/calendar_remark/deleteRemarkCalendar.do",
				data: {
					"id": id
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					if (data.success) {
						showCalendar_remark();
					}else {
						alert("删除失败")
					}
				}
			})
		}
	}

	//更新选择的备注信息表
	function openUpdateRemark(id,noteContent){

		$("#remarkId").val(id);

		$("#noteContent").val(noteContent);

		//点击后打开修改市场活动备注的模态窗口
		$("#editRemarkModal").modal("show");

	}
	
</script>

</head>
<body scroll="no" style="overflow-x:hidden">

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
			</ul>
		</div><!--/.nav-collapse -->
	</div>
</nav>

	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel1">修改备注</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <label for="noteContent" class="col-sm-2 control-label">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

	<!-- 修改日历活动的模态窗口 -->
	<div class="modal fade" id="editCalendarModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改日历计划</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form" id="CalendarEditForm">

						<div class="form-group">
							<label for="edit-calendarOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-calendarOwner">
							</div>
							<label for="edit-calendarName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-calendarName">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control start_time" id="edit-startDate">
							</div>
							<label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control end_time" id="edit-endDate">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-colordemo" class="col-sm-2 control-label">颜色</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-colordemo" value="" placeholder="点击可以选择颜色" readonly >
								<span id="edit-color"></span>
							</div>
							<label for="edit-url" class="col-sm-2 control-label">URL</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-url">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="edit-updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<div class="jumbotron">
	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 250px; top: -30px;">
		<div class="page-header">
			<h3>${calendar.name} &nbsp;<small>${calendar.startDate}&nbsp; ~ ${calendar.endDate}&nbsp;</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="updateCalendarBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; left: 250px; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">用户名 &nbsp;</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${calendar.loginAct} &nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称&nbsp;</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${calendar.name} &nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期&nbsp;</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${calendar.startDate}&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期&nbsp;</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${calendar.endDate}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">颜色&nbsp;</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${calendar.color}&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">URL&nbsp;</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${calendar.url}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者&nbsp;</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${calendar.createBy}&nbsp;&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${calendar.createTime} &nbsp;</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${calendar.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${calendar.editTime} &nbsp;</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述&nbsp;</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b style="width: 250px; word-break: break-all">
					&nbsp;${calendar.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; left: 250px; top: 30px;" id="remarkBody">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<div id="calendarRemarkDiv"></div>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="saveRemarkBtn">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
	</div>
</body>
</html>