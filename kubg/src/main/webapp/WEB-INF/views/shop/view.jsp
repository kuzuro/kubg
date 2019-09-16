<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<html>
<head>
	<title>kubg</title>
	
	<script src="/resources/jquery/jquery-3.3.1.min.js"></script>
	
	<link rel="stylesheet" href="/resources/css/user/shop/default.css" />
	
	<style>
		div.goods div.goodsImg { float:left; width:350px; }
		div.goods div.goodsImg img { width:350px; height:auto; }
		
		div.goods div.goodsInfo { float:right; width:330px; font-size:22px; }
		div.goods div.goodsInfo p { margin:0 0 20px 0; }
		div.goods div.goodsInfo p span { display:inline-block; width:100px; margin-right:15px; } 
		
		div.goods div.goodsInfo p.cartStock input { font-size:22px; width:50px; padding:5px; margin:0; border:1px solid #eee; }
		div.goods div.goodsInfo p.cartStock button { font-size:26px; border:none; background:none; } 
		div.goods div.goodsInfo p.addToCart { text-align:right; }
		div.goods div.goodsInfo p.addToCart button { font-size:22px; padding:5px 10px; border:1px solid #eee; background:#eee;}
		div.goods div.gdsDes { font-size:18px; clear:both; padding-top:30px; }
	</style>
	

	<style>
		section.replyForm { padding:30px 0; }
		section.replyForm div.input_area { margin:10px 0; }
		section.replyForm textarea { font-size:16px; font-family:'맑은 고딕', verdana; padding:10px; width:500px;; height:150px; }
		section.replyForm button { font-size:20px; padding:5px 10px; margin:10px 0; background:#fff; border:1px solid #ccc; }
		
		section.replyList { padding:30px 0; }
		section.replyList ol { padding:0; margin:0; }
		section.replyList ol li { padding:10px 0; border-bottom:2px solid #eee; }
		section.replyList div.userInfo { }
		section.replyList div.userInfo .userName { font-size:24px; font-weight:bold; }
		section.replyList div.userInfo .date { color:#999; display:inline-block; margin-left:10px; }
		section.replyList div.replyContent { padding:10px; margin:20px 0; }
		section.replyList div.replyFooter { margin-bottom:10px; }
		
		section.replyList div.replyFooter button { font-size:14px; border: 1px solid #999; background:none; margin-right:10px; }
		
	</style>
	
	<style>
		div.replyModal { position:relative; z-index:1; display:none; }
		div.modalBackground { position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0, 0, 0, 0.8); z-index:-1; }
		div.modalContent { position:fixed; top:20%; left:calc(50% - 250px); width:500px; height:250px; padding:20px 10px; background:#fff; border:2px solid #666; }
		div.modalContent textarea { font-size:16px; font-family:'맑은 고딕', verdana; padding:10px; width:500px; height:200px; }
		div.modalContent button { font-size:20px; padding:5px 10px; margin:10px 0; background:#fff; border:1px solid #ccc; }
		div.modalContent button.modal_cancel { margin-left:20px; }
	</style>
	
		
<script>
function replyList() {
	
	var gdsNum = ${view.gdsNum};
	
	// 비동기식 데이터 요청
	$.getJSON("/shop/view/replyList" + "?n=" + gdsNum, function(data){
		var str = "";
		
		$(data).each(function(){
			
			console.log(data);
			
			// 날짜 데이터를 보기 쉽게 변환
			var repDate = new Date(this.repDate);
			repDate = repDate.toLocaleDateString("ko-US")
							
			// HTML코드 조립
			str += "<li data-repNum='" + this.repNum + "'>" //"<li data-gdsNum='" + this.gdsNum + "'>"
				 + "<div class='userInfo'>"
				 + "<span class='userName'>" + this.userName + "</span>"
				 + "<span class='date'>" + repDate + "</span>"
				 + "</div>"
				 + "<div class='replyContent'>" + this.repCon + "</div>"
				 
				 + "<c:if test='${member != null}'>"
				 
				 + "<div class='replyFooter'>"
				 + "<button type='button' class='modify' data-repNum='" + this.repNum + "'>M</button>"
				 + "<button type='button' class='delete' data-repNum='" + this.repNum + "'>D</button>"
				 + "</div>"
				 
				 + "</c:if>"
				 
				 + "</li>";											
		});
		
		// 조립한 HTML코드를 추가
		$("section.replyList ol").html(str);
	});
	
}
</script>
		
</head>
<body>
<div id="root">
	<header id="header">
		<div id="header_box">
			<%@ include file="../include/header.jsp" %>
		</div>
	</header>

	<nav id="nav">
		<div id="nav_box">
			<%@ include file="../include/nav.jsp" %>
		</div>
	</nav>
	
	<section id="container">
		<div id="container_box">
		
			<section id="content">
				
				<form role="form" method="post">
					<input type="hidden" name="gdsNum" value="${view.gdsNum}" />
				</form>
				
				<div class="goods">
					<div class="goodsImg">
						<img src="${view.gdsImg}">
					</div>
					
					<div class="goodsInfo">
						<p class="gdsName"><span>상품명</span>${view.gdsName}</p>
						
						<p class="cateName"><span>카테고리</span>${view.cateName}</p>
						
						<p class="gdsPrice">
							<span>가격 </span><fmt:formatNumber pattern="###,###,###" value="${view.gdsPrice}" /> 원
						</p>
						
						<p class="gdsStock">
							<span>재고 </span><fmt:formatNumber pattern="###,###,###" value="${view.gdsStock}" /> EA
						</p>
						
						<c:if test="${view.gdsStock != 0}">
						
						<p class="cartStock">
							<span>구입 수량</span>
							<button type="button" class="plus">+</button>
							<input type="number" class="numBox" min="1" max="${view.gdsStock}" value="1" readonly="readonly"/>
							<button type="button" class="minus">-</button>
							
							<input type="hidden" value="${view.gdsStock}" class="gdsStock_hidden" />
							
							<script src="/resources/js/user/shop/stockBtn.js"></script>
													
							
						</p>
						
						<p class="addToCart">
							<button type="button" class="addCart_btn">카트에 담기</button>
							<script>
								$(".addCart_btn").click(function(){
									
									var gdsNum = $("#gdsNum").val();
									var cartStock = $(".numBox").val();
									
									var data = {
											gdsNum : gdsNum,
											cartStock : cartStock
											};
									
									$.ajax({
										url : "/shop/view/addCart",
										type : "post",
										data : data,
										success : function(result){
											
											if(result == 1) {
												alert("카트 담기 성공");
												$(".numBox").val("1");
											} else {
												alert("회원만 사용할 수 있습니다.")
												$(".numBox").val("1");
											}
										},
										error : function(){
											alert("카트 담기 실패");
										}
									});
								});
							</script>
						</p>
						
						</c:if>
						
						<c:if test="${view.gdsStock == 0}">
							<p>상품 수량이 부족합니다.</p>						
						</c:if>
					</div>
					
					<div class="gdsDes">${view.gdsDes}</div>
				</div>
				
				
				<div id="reply">
				
					<c:if test="${member == null }">
						<p>소감을 남기시려면 <a href="/member/signin">로그인</a>해주세요</p>
					</c:if>
					
					<c:if test="${member != null}">
					<section class="replyForm">
						<form role="form" method="post" autocomplete="off">
						
							<input type="hidden" name="gdsNum" id="gdsNum" value="${view.gdsNum}">
						
							<div class="input_area">
								<textarea name="repCon" id="repCon"></textarea>
							</div>
							
							<div class="input_area">
								<button type="button" id="reply_btn">소감 남기기</button>
								
								<script>
									$("#reply_btn").click(function(){
										
										var formObj = $(".replyForm form[role='form']");
										var gdsNum = $("#gdsNum").val();
										var repCon = $("#repCon").val();
										
										// ReplyVO 형태로 데이터 생성
										var data = {
												gdsNum : gdsNum,
												repCon : repCon
												};
										
										$.ajax({
											url : "/shop/view/registReply",
											type : "post",
											data : data,
											success : function(){
												replyList();  // 리스트 새로고침
												$("#repCon").val("");  // 텍스트에어리어를 초기화
											}
										});
									});
								</script>
								
							</div>
							
						</form>
					</section>
					</c:if>
					
					<section class="replyList">

						<ol>
						<%--
						<c:forEach items="${reply}" var="reply">
							<li>
					   			<div class="userInfo">
					    			<span class="userName">${reply.userName}</span>
					    			<span class="date"><fmt:formatDate value="${reply.repDate}" pattern="yyyy-MM-dd" /></span>
					   			</div>
					   			<div class="replyContent">${reply.repCon}</div>
					  		</li>
					  	</c:forEach>
					  	 --%>
					 	</ol>     
					 	
					 	<script>
							replyList();
						</script>
						
						<script>
						
							$(document).on("click", ".modify", function(){
								//$(".replyModal").attr("style", "display:block;");
								$(".replyModal").fadeIn(200);
								
								var repNum = $(this).attr("data-repNum");
								var repCon = $(this).parent().parent().children(".replyContent").text();
								
								$(".modal_repCon").val(repCon);
								$(".modal_modify_btn").attr("data-repNum", repNum);
								
							});
													
							// 스크립트로 인해 생성된 HTML의 이벤트는 .click() 메서드를 사용할 수 없음
							$(document).on("click", ".delete", function(){
								
								// 사용자에게 삭제 여부를 확인
								var deletConfirm = confirm("정말로 삭제하시겠습니까?"); 
								
								if(deletConfirm) {
								
									var data = {repNum : $(this).attr("data-repNum")};  // ReplyVO 형태로 데이터 생성
									
									$.ajax({
										url : "/shop/view/deleteReply",
										type : "post",
										data : data,
										success : function(result){
											
											// result의 값에 따라 동작
											if(result == 1) {
												replyList();  // 리스트 새로고침
											} else {
												alert("작성자 본인만 할 수 있습니다.")  // 본인이 아닌 경우										
											}
										},
										error : function(){
											// 로그인하지 않아서 에러가 발생한 경우
											alert("로그인하셔야합니다.")
										}
									});
								}
							});
						
						</script>

					</section>
				
				
				</div>
			</section>
			
			<aside id="aside">
				<%@ include file="../include/aside.jsp" %>
			</aside>
			
		</div>
	</section>

	<footer id="footer">
		<div id="footer_box">
			<%@ include file="../include/footer.jsp" %>
		</div>		
	</footer>

</div>


<div class="replyModal">

	<div class="modalContent">
		
		<div>
			<textarea class="modal_repCon" name="modal_repCon"></textarea>
		</div>
		
		<div>
			<button type="button" class="modal_modify_btn">수정</button>
			<button type="button" class="modal_cancel">취소</button>
		</div>
		
	</div>

	<div class="modalBackground"></div>
	
</div>

<script>
$(".modal_modify_btn").click(function(){
	var modifyConfirm = confirm("정말로 수정하시겠습니까?");
	
	if(modifyConfirm) {
		var data = {
					repNum : $(this).attr("data-repNum"),
					repCon : $(".modal_repCon").val()
				};  // ReplyVO 형태로 데이터 생성
		
		$.ajax({
			url : "/shop/view/modifyReply",
			type : "post",
			data : data,
			success : function(result){
				
				if(result == 1) {
					replyList();
					$(".replyModal").fadeOut(200);
				} else {
					alert("작성자 본인만 할 수 있습니다.");							
				}
			},
			error : function(){
				alert("로그인하셔야합니다.")
			}
		});
	}
	
});

$(".modal_cancel").click(function(){
	//$(".replyModal").attr("style", "display:none;");
	$(".replyModal").fadeOut(200);
});
</script>


</body>
</html>
