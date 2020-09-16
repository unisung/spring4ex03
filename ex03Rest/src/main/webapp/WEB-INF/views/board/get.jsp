<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../includes/header.jsp" %>    

<div class="row">
	<div class="col-lg-12">
	    <h1 class="page-header">글 상세 보기</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!--  /.row -->

<!-- 본문 -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-info">
			<div class="panel-heading"> 글 상세 보기 페이지</div>
			<!--  /.panel-heading -->
			<div class="panel-body">
				
				<div class="form-group">
					<label>글번호</label>
					<input class="form-control" name="bno" value='<c:out value="${board. bno }"/>' readonly>
				</div>
				
				<div class="form-group">
					<label>제목</label>
					<input class="form-control" name="title" value='<c:out value="${board. title }"/>' readonly>
				</div>
				
				<div class="form-group">
					<label>내용</label>
					<textarea class="form-control" rows="3" name="content" readonly>
					       <c:out value="${board.content }"/>
					 </textarea>
				</div>
				
				<div class="form-group">
					<label>작성자</label>
					<input class="form-control" name="writer" value='<c:out value="${board.writer }"/>' readonly>
				</div>
				
				<button data-oper='modify' class="btn btn-primary">수정</button>
				<button data-oper='list' class="btn btn-default">글목록</button>
 				
				<!--  이동할 폼 생성  -->
				<form id='operForm' action="/board/modify" method="get">
				<input type="hidden" id='bno' name='bno' value='<c:out value="${board.bno}"/>'>
				<input type="hidden" id='pageNum' name='pageNum' value='<c:out value="${cri.pageNum}"/>'>
				<input type="hidden" id='amount' name='amount' value='<c:out value="${cri.amount}"/>'>
				<input type="hidden" id='keyword' name='keyword' value='<c:out value="${cri.keyword}"/>'>
				<input type="hidden" id='type' name='type' value='<c:out value="${cri.type}"/>'>
				</form>
				
			</div><!--  end panel-body -->
		</div><!-- end panel-info -->
	</div><!-- end panel -->

</div><!--  /.row -->

<div class='row'>
	<div class='col-lg-12'>
		
	<div class='panel panel-default'>
	   <div class='panel-heading'>
	     <i class="fa fa-comments fa-fw"></i>댓글
	<button id='addReplyBtn' class="btn btn-primary btn-xs pull-right">댓글달기</button>
	   </div>
	
	<div class="panel-body">
	        <ul class="chat">
	        
	        </ul>
	      
	</div>
	   <div class="panel-footer"></div>
		
		</div>
		</div>

</div>


<!-- 수정/리스트 페이지로이동 처리 스크립트  -->
<script>
$(document).ready(function(){
	 var operForm=$("#operForm");
	 $("button[data-oper='modify']").on("click",function(e){
			operForm.attr("action","/board/modify").submit();
		 });
     
	 $("button[data-oper='list']").on("click",function(e){
		    operForm.find("#bno").remove();
			operForm.attr("action","/board/list").submit();
		 });
});
</script>
<script>

</script>
<script type="text/javascript" src="/resources/js/reply.js"></script>
<script>
console.log("===============");
console.log("JS TEST");

var bnoValue = '<c:out value="${board.bno}"/>';

//for replyService add test
 replyService.add(
  
  {reply:"JS Test", 
	replyer:"tester", 
	bno:bnoValue}//객체
  ,
  function(result){ //함수
    alert("RESULT: " + result);
  }
); 
</script>
<script>
replyService.getList({bno:bnoValue,page:1},
		                        function(list){
	                   for(var i=0,len=list.length||0;i<len;i++){
                                console.log(list[i]);
		}
});
</script>
<script>
 //42번 댓글 삭제
 replyService.remove(42,
		 function(count){
           console.log(count);

     	  if(count==='success'){
         	      alert("REMOVED");
          }
        },
      function(err){
          alert('ERROR....');
          }
);
</script>
<script>
//43번 댓글 수정
replyService.update(
  {rno:43, bno:bnoValue, reply:"ajax로 댓글 수정...."},
  function(result){
	  alert("수정완료....");
	  }
);
</script>
<script>
replyService.get(43,function(data){
	   console.log(data);
});

</script>
<script>
var replyUL =$(".chat");

showList(1);

function showList(page){
	 console.log("show list "+page);

	 replyService.getList({bno:bnoValue,page:page||1},
            function(replyCnt, list){
				console.log("replyCnt: "+replyCnt);
				console.log("list: "+list);
				console.log(list);

                //페이지 번호가 -1로 전달되면 전체 댓글수 재계산후, showList()재호출
				if(page==-1){
                     pageNum=Math.ceil(replyCnt/10.0);
                     showList(pageNum);
                     return;
					}

				var str="";

				//결과가 없을 때 리턴
				if(list==null || list.length==0){
                     return;
					}
                 //댓글 리스트가 있으면
           for(var i=0,len=list.length||0; i<len; i++){
                 str+="<li class='left clearfix' data-rno='"+list[i].rno+"'>";
                 str+=" <div><div class='header'><strong class='primary-font'>["
                        +list[i].rno+"]"+list[i].replyer+"</strong>";
                 str+=" <small class='pull-right text-muted'>"
                         +replyService.displayTime(list[i].replyDate) +"</small></div>";
                 str+=" <p>"+list[i].reply+"</p></div></li>";
               }

               //ul에 추가하기
           replyUL.html(str);
           
           
         }

               
     
			 );
}






</script>

<%@ include file="../includes/footer.jsp"%>