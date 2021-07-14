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
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<style type="text/css">
	body {
		font-family: Calibri;
		background-color: #f0f0f0;
		padding: 0em 1em;
		overflow-x:hidden;
	}
	td {
		text-overflow: ellipsis; /* for IE */
		-moz-text-overflow: ellipsis; /* for Firefox,mozilla */
		overflow: hidden;
		white-space: nowrap;
		text-align: left
	}
	.tdCheckBox {
		width: 3%;
	}
	.tdDescription{
		width: 50%;
	}
	.tdDate {
		width: 10%;
	}
	.tdGroup{
		width: 10%;
	}
</style>

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<!--分页查询的插件-->
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function(){

		pageList(1,10);

		//为创建按钮绑定事件，点击打开创建线索的模态窗口
		$("#addBtn").click(function (){

			var loginAct = "${user.loginAct}";

			$("#create-IdeaLoginAct").val(loginAct);

			$("#createIdeaModal").modal("show");
		})

		//为保存按钮绑定事件，点击将已经填写好的数据保存到数据库中
		$("#saveBtn").click(function (){

			$.ajax({

				url:"workbench/idea/saveIdea.do",
				data :{

					"loginAct":$.trim($("#create-IdeaLoginAct").val()),
					"name":$.trim($("#create-IdeaName").val()),
					"group":$.trim($("#create-IdeaGroup").val()),
					"state":$.trim($("#create-IdeaState").val()),
					"source":$.trim($("#create-IdeaSource").val()),
					"sourceURL":$.trim($("#create-IdeaSourceURL").val()),
					"isPublic":$.trim($("#create-IdeaIsPublic").val()),
					"createTime":$.trim($("#create-IdeaTime").val()),
					"description":$.trim($("#create-IdeaDescription").val()),

				},
				type:"post",
				dataType : "json",
				success :function (data){
					if (data.success){
						pageList(1,10);
						$("#createIdeaModal").modal("hide");
					}else {
						alert("保存失败")
					}
				}
			})
		})

		//为搜索按钮绑定事件，点击查询
		$("#searchBtn").click(function (){
			//先把搜索框中的信息保存到隐藏域中
			$("#hidden-IdeaName").val($.trim($("#search-IdeaName").val()));
			$("#hidden-IdeaLoginAct").val($.trim($("#search-IdeaLoginAct").val()));
			$("#hidden-IdeaGroup").val($.trim($("#search-IdeaGroup").val()));
			$("#hidden-IdeaState").val($.trim($("#search-IdeaState").val()));
			$("#hidden-IdeaSource").val($.trim($("#search-IdeaSource").val()));
			$("#hidden-IdeaTime").val($.trim($("#search-IdeaTime").val()));
			$("#hidden-IdeaIsPublic").val($.trim($("#search-IdeaIsPublic").val()));
			$("#hidden-IdeaDescription").val($.trim($("#search-IdeaDescription").val()));

			pageList(1,10);
		})

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

		//为selectBox选择框绑定事件，点击全选下面的选择框
		$("#selectBox").click(function (){
			$("input[name = subSelectBox]").prop("checked",this.checked);
		})

		$("#tbodyContext").on("click",$("input[name = subSelectBox]"),function (){

			$("#selectBox").prop("checked",$("input[name = subSelectBox]").length == $("input[name = subSelectBox]:checked").length);
		})

		//为delete按钮绑定事件，点击按复选框（subSelectBox）的checked状态删除查询数据
		$("#deleteBtn").click(function (){

			//找到复选框中所有checked的jquery对象
			var $xz = $("input[name = subSelectBox]:checked");

			if ($xz.length == 0){
				alert("请选择需要删除的记录");
			}else {

				//url:workbench/activity/delete.do?id=xxx&id=xxx
				//拼接参数
				var param = "";

				//遍历$xz中的每一个dom对象遍历出来，取其value值》取得需要删除的记录的id
				for (var i = 0; i < $xz.length; i++) {

					param += "id=" + $($xz[i]).val();
					if (i < $xz.length - 1){
						param += "&"
					}
				}

				if (confirm("是否打算删除该数据")){
					$.ajax({

						url:"workbench/idea/deleteIdea.do",
						data : param,
						type:"post",
						dataType : "json",
						success :function (data){
							//需要传递出来的信息：success：true or false
							if (data.success){
								//删除成功后刷新当前页

								pageList($("#ideaPage").bs_pagination('getOption', 'currentPage')
										,$("#ideaPage").bs_pagination('getOption', 'rowsPerPage'));
							}else {
								alert("数据删除失败")
							}
						}
					})
				}
			}
		})

		//为”修改“按钮绑定事件，点击打开模态窗口
		$("#updateBtn").click(function (){

			//修改时应该只能修改选中的唯一一个复选框的信息
			var $xz = $("input[name = subSelectBox]:checked");
			if ($xz.length == 0){
				alert("请选择您想修改的活动")
			}else if ($xz.length > 1){
				alert("不能同时修改多个活动的信息")
			}else {

				$.ajax({

					url:"workbench/idea/getIdea.do",
					data :{
						"id": $xz.val(),
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
			}
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

						//更新后，原本在哪一页，应该回到哪一页
						/*
						bootstrap的插件
						pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
								,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

						操作后停留在当前页面
						$("#activityPage").bs_pagination('getOption', 'currentPage')

						操作后维持已经设置好的每页展现的记录数
						$("#activityPage").bs_pagination('getOption', 'rowsPerPage')
						*/
						pageList($("#ideaPage").bs_pagination('getOption', 'currentPage')
								,$("#ideaPage").bs_pagination('getOption', 'rowsPerPage'));
					}else {
						alert("保存失败")
					}
				}
			})
		})
	});

	function pageList(pageNo,pageSize){

		//搜索前将隐藏域中的值赋给搜索框
		$("#search-IdeaName").val($.trim($("#hidden-IdeaName").val()));
		$("#search-IdeaLoginAct").val($.trim($("#hidden-IdeaLoginAct").val()));
		$("#search-IdeaGroup").val($.trim($("#hidden-IdeaGroup").val()));
		$("#search-IdeaState").val($.trim($("#hidden-IdeaState").val()));
		$("#search-IdeaSource").val($.trim($("#hidden-IdeaSource").val()));
		$("#search-IdeaTime").val($.trim($("#hidden-IdeaTime").val()));
		$("#search-IdeaIsPublic").val($.trim($("#hidden-IdeaIsPublic").val()));
		$("#search-IdeaDescription").val($.trim($("#hidden-IdeaDescription").val()));

		$.ajax({

			url:"workbench/idea/getIdeaList.do",
			data :{
				//传参--做分页的相关参数
				"pageNo":pageNo,
				"pageSize":pageSize,
				//传参--线索列表
				"name":$.trim($("#search-IdeaName").val()),
				"loginAct":$.trim($("#search-IdeaLoginAct").val()),
				"group":$.trim($("#search-IdeaGroup").val()),
				"state":$.trim($("#search-IdeaState").val()),
				"source":$.trim($("#search-IdeaSource").val()),
				"createTime":$.trim($("#search-IdeaTime").val()),
				"description":$.trim($("#search-IdeaDescription").val()),
				"isPublic":$.trim($("#search-IdeaIsPublic").val()),
			},
			type:"post",
			dataType : "json",
			success :function (data){

				/**
				 * 前端需要的参数：市场活动信息列表
				 * {{市场活动1}，{2}，{3}}
				 * 一会分页插件需要的，查询出来的总记录数
				 * {“total”：100}
				 * {“total：100，“datalist”：[{市场活动1}，{2}，{3}]}
				 */

				var html ="";

				$.each(data.list,function (i,n){
					html +='<tr>';
					html +='<td><input value="'+n.id+'" name="subSelectBox" type="checkbox"/></td>';
					html +='<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/idea/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
					html +='<td>'+n.loginAct+'</td>';
					html +='<td>'+n.group+'</td>';
					html +='<td>'+n.state+'</td>';
					html +='<td>'+n.description+'</td>';
					html +='<td><a style="text-decoration: none;cursor: pointer;" onclick="window.open(\''+n.sourceURL+'\')";">'+n.sourceURL+'</a></td>';
					html +='<td>'+n.createTime+'</td>';
					html +='</tr>';
				})

				$("#tbodyContext").html(html);

				//计算总页数
				var totalPages = data.total%pageSize ==0?data.total/pageSize:data.total/pageSize+1;

				//分页组件
				$("#ideaPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数》需要计算
					totalRows: data.total, // 总记录条数

					visiblePageLinks: 3, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					//回调函数在点击分页组件的时候触发
					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				});
			}
		})
	}
	
</script>
</head>
<body>

    <!--用隐藏域储存搜索框中填写的信息-->
    <input type="hidden" id="hidden-IdeaName"/>
    <input type="hidden" id="hidden-IdeaLoginAct"/>
    <input type="hidden" id="hidden-IdeaGroup"/>
    <input type="hidden" id="hidden-IdeaState"/>
	<input type="hidden" id="hidden-IdeaSource"/>
	<input type="hidden" id="hidden-IdeaTime"/>
	<input type="hidden" id="hidden-IdeaIsPublic"/>
	<input type="hidden" id="hidden-IdeaDescription"/>

	<!-- 创建idea的模态窗口 -->
	<div class="modal fade" id="createIdeaModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建一个想法</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-IdeaLoginAct" class="col-sm-2 control-label">用户名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-IdeaLoginAct">
							</div>
							<label for="create-IdeaName" class="col-sm-2 control-label">想法<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-IdeaName">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-IdeaGroup" class="col-sm-2 control-label">分组</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-IdeaGroup">
								  <option></option>
									<c:forEach items="${IdeaGroup}" var="group">
										<option value="${group.value}">${group.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-IdeaState" class="col-sm-2 control-label">状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-IdeaState">
									<option></option>
									<c:forEach items="${IdeaState}" var="state">
										<option value="${state.value}">${state.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-IdeaSource" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-IdeaSource">
									<option></option>
									<c:forEach items="${IdeaSource}" var="source">
										<option value="${source.value}">${source.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-IdeaSourceURL" class="col-sm-2 control-label">来源URL</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-IdeaSourceURL">
							</div>
						</div>

						<div class="form-group">
							<label for="create-IdeaIsPublic" class="col-sm-2 control-label">是否公开</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-IdeaIsPublic">
									<option></option>
									<option value="1">公开</option>
									<option value="0">私有</option>
								</select>
							</div>
							<label for="create-IdeaTime" class="col-sm-2 control-label">时间</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control start_time" id="create-IdeaTime" readonly="readonly" placeholder="请直接点击选择时间(默认为今天)">
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-IdeaDescription" class="col-sm-2 control-label">想法具体描述</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="create-IdeaDescription"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
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
	

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3 style="text-align: center;
			               font-size: 50px;
			               text-shadow: 0 0px 30px rgba(0, 0, 0, 0.2);">Idea List</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">想法</div>
				      <input class="form-control" type="text" id="search-IdeaName">
				    </div>
				  </div>

					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">用户名</div>
							<input class="form-control" type="text" id="search-IdeaLoginAct">
						</div>
					</div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">分组</div>
						<select class="form-control" id="search-IdeaGroup">
							<option></option>
							<c:forEach items="${IdeaGroup}" var="group">
								<option value="${group.value}">${group.text}</option>
							</c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">状态</div>
						<select class="form-control" id="search-IdeaState">
							<option></option>
							<c:forEach items="${IdeaState}" var="state">
								<option value="${state.value}">${state.text}</option>
							</c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
						<select class="form-control" id="search-IdeaSource">
							<option></option>
							<c:forEach items="${IdeaSource}" var="source">
								<option value="${source.value}">${source.text}</option>
							</c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">时间</div>
				      <input class="form-control start_time" type="text" id="search-IdeaTime">
				    </div>
				  </div>

					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">是否公开</div>
							<select class="form-control" id="search-IdeaIsPublic">
								<option></option>
								<option value="1">公开</option>
								<option value="0">私有</option>
							</select>
						</div>
					</div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">描述</div>
				      <input class="form-control" type="text" id="search-IdeaDescription">
				    </div>
				  </div>


				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>

			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="updateBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"  id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover" width="100%" style="table-layout: fixed">
					<thead>
						<tr style="color: #B3B3B3;">
							<td class="tdCheckBox"><input type="checkbox" id="selectBox" /></td>
							<td>想法</td>
							<td>用户名</td>
							<td class="tdGroup">分组</td>
							<td class="tdGroup">状态</td>
							<td class="tdDescription">描述</td>
							<td>来源URL</td>
							<td class="tdDate">时间</td>
						</tr>
					</thead>
					<tbody id="tbodyContext">

					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 60px;">
				<div id="ideaPage"></div>
			</div>
			
		</div>
		
	</div>


</body>
</html>