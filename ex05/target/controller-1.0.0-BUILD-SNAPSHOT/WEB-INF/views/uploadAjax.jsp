<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html><html><head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h1> Upload with Ajax</h1>

	<style>
.uploadResult {
	width: 100%;
	background-color: gray;
}

.uploadResult ul {
	display: flex;
	flex-flow: row;
	justify-content: center;
	align-items: center;
}

.uploadResult ul li {
	list-style: none;
	padding: 10px;
}

.uploadResult ul li img {
	width: 100px;
}
</style>

<style>
.bigPictureWrapper {
  position: absolute;
  display: none;
  justify-content: center;
  align-items: center;
  top:0%;
  width:100%;
  height:100%;
  background-color: gray; 
  z-index: 100;
}

.bigPicture {
  position: relative;
  display:flex;
  justify-content: center;
  align-items: center;
}
</style>
<div class='bigPictureWrapper'>
	<div class="bigPicture"></div>
</div>

<div class="uploadDiv">
		<input type="file" name='uploadFile' multiple>
</div>
<div class='uploadResult'>
	<ul></ul>
</div>

<button id='uploadBtn'>Upload</button>

<script src="https://code.jquery.com/jquery-3.3.1.min.js"
		integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
		crossorigin="anonymous">
</script>

<script>
$(document).ready(function(){
/*$('#uploadBtn').on("click",function(e){
		var formData = new FormData();

		var inputFile=$("input[name='uploadFile']");
		var files = inputFile[0].files;

		console.log(files);

		for(var i=0;i<files.length;i++){
			formData.append("uploadFile",files[i]);
			}

		//ajax처리
		$.ajax({
          url:'/uploadAjaxAction',
          processData:false,
          contentType:false,
          data:formData,
          type:'POST',
          success:function(result){
				alert('Uploaded');
              }
			});
}) */

         var regEx = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
         var maxSize = 5242880; //5MB

         function checkExtension(fileName, fileSize){
			if(fileSize >=maxSize){
					alert("파일 사이즈 초과");
					return false;
				}
			if(regEx.test(fileName)){
                  alert("해당 종류의 파일은 업로드 할 수 없습니다.");
                  return false;
				}
				return true;
             }

         var cloneObj = $(".uploadDiv").clone();

 		$("#uploadBtn").on("click", function(e) {
 			var formData = new FormData();
 			var inputFile = $("input[name='uploadFile']");
 			var files = inputFile[0].files;
 			//console.log(files);
 			for (var i = 0; i < files.length; i++) {
 				if (!checkExtension(files[i].name, files[i].size)) {
 					return false;
 				}
 				formData.append("uploadFile", files[i]);
 			}
 			//ajax처리
 			$.ajax({
 	          url:'/uploadAjaxAction',
 	          processData:false,
 	          contentType:false,
 	          data:formData,
 	          type:'POST',
 	          success:function(result){
 					//alert('Uploaded');
					console.log(result);

					showUploadedFile(result);

					$(".uploadDiv").html(cloneObj.html());
 	              }
 				});
});

});

 		    var uploadResult = $('.uploadResult ul');

 		   function showUploadedFile(uploadResultArr){
				var str="";
				$(uploadResultArr).each(function(i,obj){
						if(!obj.image){//false  이미지가 아니면
								str+="<li><img src='/resources/img/attach.png'>"+obj.fileName+"</li>";
							}else{

                            var fileCallPath = encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);
                            var originPath = obj.upLoadPath +"\\"+obj.uuid+"_"+obj.fileName;
                            
                            originPath = originPath.replace(new RegExp(/\\/g),"/");
                            fileCallPath=fileCallPath.replace(new RegExp(/\\/g),"/");
                            
                            console.log(fileCallPath);
                            str+="<li><a href=\"javascript:showImage(\'"+originPath+"\')\">"+
                                     "<img src='display?fileName="+fileCallPath+"'></a>"+
                                     "<span data-file=\' "+fileCallPath+"\' data-type='image'>x</span>"+
                                     "</li>";						       
							}
					});
                  uploadResult.append(str);
 	 		   }

</script>	
	
<script>
function showImage(fileCallPath){
  $(".bigPictureWrapper").css("display","flex").show();
  $(".bigPicture").html("<img src='/display?fileName="+fileCallPath+"'>").animate({width:'100%',height:'100'},1000);
	
}
</script>
</body>
</html>