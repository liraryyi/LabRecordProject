<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
	<style type="text/css">
		body {
			font-family: Calibri;
			background-color: #f0f0f0;
			padding: 0em 1em;
			overflow-x:hidden;
		}
	</style>

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){

		showIdea_remark();
		updateRelation();

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

		//为”修改“按钮绑定事件，点击打开模态窗口
		$("#updateBtn").click(function (){

				$.ajax({

					url:"workbench/idea/getIdea.do",
					data :{
						"id": "${idea.id}",
					},
					type:"get",
					dataType : "json",
					success :function (data){

						$("#edit-IdeaLoginAct").val(data.loginAct);
						$("#edit-IdeaName").val(data.name);
						$("#edit-IdeaGroup").val(data.group);
						$("#edit-IdeaState").val(data.state);
						$("#edit-IdeaSource").val(data.source);
						$("#edit-IdeaSourceURL").val(data.sourceURL);
						$("#edit-IdeaIsPublic").val(data.isPublic);
						$("#edit-IdeaTime").val(data.createTime);
						$("#edit-IdeaDescription").val(data.description);
					}
				})

				$("#editIdeaModal").modal("show");
		})

		//为更新按钮绑定事件，点击将已经修改的信息保存到数据库中
		$("#edit-updateBtn").click(function (){

			var $xz = $("input[name = subSelectBox]:checked");
			$.ajax({

				url:"workbench/idea/updateIdea.do",
				data :{
					"id":$xz.val(),
					"loginAct": $.trim($("#edit-IdeaLoginAct").val()),
					"name": $.trim($("#edit-IdeaName").val()),
					"group": $.trim($("#edit-IdeaGroup").val()),
					"state":$.trim($("#edit-IdeaState").val()),
					"source":$.trim($("#edit-IdeaSource").val()),
					"sourceURL":$.trim($("#edit-IdeaSourceURL").val()),
					"isPublic":$.trim($("#edit-IdeaIsPublic").val()),
					"createTime":$.trim($("#edit-IdeaTime").val()),
					"description":$.trim($("#edit-IdeaDescription").val())
				},
				type:"post",
				dataType : "json",
				success :function (data){

					//传过来的数据success
					if (data.success){
						$("#ideaEditForm")[0].reset();

						$("#editIdeaModal").modal("hide");

					}else {
						alert("保存失败")
					}
				}
			})
		})

		//点击确定保存Remark信息
		$("#saveRemarkBtn").click(function (){
			$.ajax({

				url:"workbench/idea_remark/saveIdea_remark.do",
				data :{
					"noteContext": $("#remark").val(),
					"ideaId": "${idea.id}",
					"loginAct": "${idea.loginAct}"
				},
				type:"post",
				dataType : "json",
				success :function (data){
					if (data.success){

						showIdea_remark();
						$("#remark").val("");
					}else {
						alert("保存失败")
					}
				}
			})
		})

		//使用鼠标操作动态滑入滑出，展示删除和修改按钮
		$("#remarkBody").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		})
		$("#remarkBody").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		})

		//点击更新 保存Remark信息
		$("#updateRemarkBtn").click(function (){

			$.ajax({

				url:"workbench/idea_remark/updateIdea_remark.do",
				data :{
					"id":$("#remarkId").val(),
					"noteContent":$("#noteContent").val(),
					"loginAct":"${idea.loginAct}",
				},
				type:"post",
				dataType : "json",
				success :function (data){
					if (data.flag) {
						showIdea_remark();

						$("#editRemarkModal").modal("hide");
					}else {
						alert(data.msg);
					}
				}
			})
		})

		//按下回车，展现关联市场活动列表
		$("#ideaName").keydown(function (event){
			if (event.keyCode == 13){
				updateModalRelation();

				//展现完列表后，记得将模态窗口默认的回车行为禁用掉
				return false;
			}
		})

		//为关联按钮绑定事件，点击关联
		$("#bindBtn").click(function (){
			//这里关联的意思是将ideaId和calendarId加入到表tbl_idea_calendar_relation

			//找到复选框中所有checked的jquery对象
			var $xz = $("input[name = xz]:checked");

			if ($xz.length == 0){
				alert("请选择需要关联的市场活动")
			}else{

				//需要传递的数据的形式是
				//workbench/idea/bind.do?iid=xxx&cid=xxx&cid=xxx...
				var param ="iid=${idea.id}&";

				for (var i =0;i<$xz.length;i++){

					//$()将DOM对象转换为jQuery对象
					param +="cid="+$($xz[i]).val();

					if (i<$xz.length-1){
						param +="&";
					}
				}
			}

			$.ajax({

				url:"workbench/idea/bind.do",
				data :param,
				type:"get",
				dataType : "json",
				success :function (data){
					if (data.success){
						updateRelation();
						updateModalRelation();
					}else {
						alert("关联失败");
					}
				}
			})

		})
	});

	//刷新日历活动备注列表
	function showIdea_remark(){
		$.ajax({

			url:"workbench/idea_remark/getRemarkIdeaList.do",
			data :{
				"ideaId": "${idea.id}"
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
					html += '<img alt="" src="'+n.loginAct+'" style="width: 30px; height:30px;">';
					html += '<div style="position: relative; top: -40px; left: 40px;" >';
					html += '<h5>'+n.noteContent+'</h5>';
					html += '<font color="gray">想法</font> <font color="gray">-</font> <b>${idea.name}</b> <small style="color: gray;"> '+(n.editFlag==1?n.editTime:n.createTime)+' 由'+(n.editFlag==1?n.editBy:n.createBy)+'</small>';
					html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					html += '<a class="myHref" href="javascript:void(0);" onclick="openUpdateRemark(\''+n.id+'\',\''+n.noteContent+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
					html += '&nbsp;&nbsp;&nbsp;&nbsp;';
					html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
					html += '</div>';
					html += '</div>';
					html += '</div>';
				})

				$("#IdeaRemarkDiv").html(html);
			}
		})
	}

	//删除选择的备注信息表
	function deleteRemark(id){

		if (confirm("确定要删除吗？")) {
			$.ajax({

				url: "workbench/idea_remark/deleteIdea_remark.do",
				data: {
					"id": id,
					"loginAct":"${user.loginAct}"
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					if (data.flag) {
						showIdea_remark();
					}else {
						alert(data.msg)
					}
				}
			})
		}
	}

	//更新选择的备注信息表
	function openUpdateRemark(id,noteContent){

		$("#remarkId").val(id);

		$("#noteContent").val(noteContent);

		//点击后打开修改想法备注的模态窗口
		$("#editRemarkModal").modal("show");

	}

	//刷新关联日历活动
	function updateRelation(){
		//刷新关联日历活动，根据线索id查找到关联的日历活动
		$.ajax({

			url:"workbench/idea/getActivityList.do",
			data :{
				"ideaId":"${idea.id}"
			},
			type:"get",
			dataType : "json",
			success :function (data){
				/**
				 * 返回的数据：
				 * list{{市场活动1},{2},{3},{4}}
				 */
				var html = "";

				$.each(data,function (i,n){
					html +='<tr>';
					html +='<td>'+n.name+'</td>';
					html +='<td>'+n.startDate+'</td>';
					html +='<td>'+n.endDate+'</td>';
					html +='<td>'+n.loginAct+'</td>';
					html +='<td><a href="javascript:void(0);" onclick="unbind(\''+n.id+'\')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
					html +='</tr>';
				})

				$("#tbodyActivity").html(html);

			}
		})
	}

	//刷新关联日历活动列表
	//这里刷新的时候，我们希望1.正常的连表查询; 2.不显示已经关联好的日历活动
	function updateModalRelation(){

		$.ajax({

			url:"workbench/idea/getCalendarListByName.do",
			data :{
				"ideaId":"${idea.id}",
				"name":$.trim($("#ideaName").val())
			},
			type:"get",
			dataType : "json",
			success :function (data){

				var html = "";

				//这里每一个n就是遍历出来的一个calendar对象
				$.each(data,function (i,n){
					html +='<tr>';
					html +='<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
					html +='<td>'+n.name+'</td>';
					html +='<td>'+n.startDate+'</td>';
					html +='<td>'+n.endDate+'</td>';
					html +='<td>'+n.loginAct+'</td>';
					html +='</tr>';
				})

				$("#calendarTbody").html(html);

			}
		})
	}

	//解除关联
	function unbind(id){
		$.ajax({

			url:"workbench/idea/unbind.do",
			data :{
				"id":id
			},
			type:"post",
			dataType : "json",
			success :function (data){
				if (data.success){
					updateRelation();
				}else {
					alert("解除关联失败")
				}
			}
		})
	}
	
</script>

</head>
<body>

    <!-- 修改备注的模态窗口 -->
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

	<!-- 关联日历活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联日历活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入日历活动名称，支持模糊查询" id="ideaName">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>用户名</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="calendarTbody">

						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="bindBtn">关联</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改idea的模态窗口 -->
	<div class="modal fade" id="editIdeaModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改这个想法</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" id="ideaEditForm" role="form">

						<div class="form-group">
							<label for="edit-IdeaLoginAct" class="col-sm-2 control-label">用户名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-IdeaLoginAct">
							</div>
							<label for="edit-IdeaName" class="col-sm-2 control-label">想法<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-IdeaName">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-IdeaGroup" class="col-sm-2 control-label">分组</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-IdeaGroup">
									<option></option>
									<c:forEach items="${IdeaGroup}" var="group">
										<option value="${group.value}">${group.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-IdeaState" class="col-sm-2 control-label">状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-IdeaState">
									<option></option>
									<c:forEach items="${IdeaState}" var="state">
										<option value="${state.value}">${state.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-IdeaSource" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-IdeaSource">
									<option></option>
									<c:forEach items="${IdeaSource}" var="source">
										<option value="${source.value}">${source.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-IdeaSourceURL" class="col-sm-2 control-label">来源URL</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-IdeaSourceURL">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-IdeaIsPublic" class="col-sm-2 control-label">是否公开</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-IdeaIsPublic">
									<option></option>
									<option value="1">公开</option>
									<option value="0">私有</option>
								</select>
							</div>
							<label for="edit-IdeaTime" class="col-sm-2 control-label">时间</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control start_time" id="edit-IdeaTime" readonly="readonly" placeholder="请直接点击选择时间(默认不做修改)">
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

						<div style="position: relative;top: 20px;">
							<div class="form-group">
								<label for="edit-IdeaDescription" class="col-sm-2 control-label">想法具体描述</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-IdeaDescription"></textarea>
								</div>
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

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 250px; top: -30px;">
		<div class="page-header">
			<h3>${idea.loginAct}&nbsp;<small>${idea.name}&nbsp;</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='workbench/idea/convert.jsp?ideaId=${idea.id}&name=${idea.name}&loginAct=${idea.loginAct}';"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			<button type="button" class="btn btn-default" id="updateBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" ><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; left: 250px; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">用户名</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${idea.loginAct}&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">想法</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${idea.name}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">分组</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${idea.group}&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">状态</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${idea.state}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${idea.source}&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">URL(来源)</div>
			<div style="width: 300px; height: 20px;position: relative; left: 650px; top: -60px; overflow: hidden;"><b>${idea.sourceURL}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">是否公开</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${idea.isPublic}&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">&nbsp;</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${idea.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${idea.createTime}&nbsp;</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${idea.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${idea.editTime}&nbsp;</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${idea.description}
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

		<div id="IdeaRemarkDiv">
		</div>
		
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
	
	<!-- 日历计划 -->
	<div>
		<div style="position: relative; top: 60px; left: 250px;">
			<div class="page-header">
				<h4>日历计划</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>用户名</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="tbodyActivity">
						<%--<tr>
							<td>发传单</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>
						<tr>
							<td>发传单</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" data-toggle="modal" data-target="#bundModal" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联日历活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>