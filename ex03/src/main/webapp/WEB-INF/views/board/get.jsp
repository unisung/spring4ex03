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


<%@ include file="../includes/footer.jsp"%>