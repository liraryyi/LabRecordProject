<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" +
			request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
	<base href="<%=basePath%>">
	<meta charset="UTF-8">
	<title>上传头像</title>
	<link href="jquery/cropper/cropper.css" rel="stylesheet">
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" rel="stylesheet">
	<style type="text/css">
		body{
			text-align: center;
		}
		#user-photo {
			width:300px;
			height:300px;
			margin-top: 10px;
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

<!--按钮 打开上传图片的模态窗口-->
<button class="btn btn-primary" data-target="#changeModal" data-toggle="modal">打开</button><br/>
<!--放照片的地方-->
<div class="user-photo-box">
	<img id="user-photo" src="">
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


<script src="jquery/jquery-1.11.1-min.js"></script>
<script src="jquery/cropper/cropper.js"></script>
<script src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript">
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
				if (data.status == 0) {
					// 将上传的头像的地址填入，为保证不载入缓存加个随机数
					$('.user-photo').attr('src', '头像地址?t=' + Math.random());
					$('#changeModal').modal('hide');
				} else {
					alert(data.info);
				}
			}
		});
	}

	$(function(){
		initCropperInModal($('#photo'),$('#photoInput'),$('#changeModal'));
	});
</script>
</body>
</html>