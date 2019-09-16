<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<html>
<head>
	<title>kubg Admin</title>
	
<script src="/resources/jquery/jquery-3.3.1.min.js"></script>

<link rel="stylesheet" href="/resources/bootstrap/bootstrap.min.css">
<link rel="stylesheet" href="/resources/bootstrap/bootstrap-theme.min.css">
<script src="/resources/bootstrap/bootstrap.min.js"></script>
	
<style>
	body { font-family:'맑은 고딕', verdana; padding:0; margin:0; }
	ul { padding:0; margin:0; list-style:none;  }
 
	div#root { width:90%; margin:0 auto; }
	
	header#header { font-size:60px; padding:20px 0; }
	header#header h1 a { color:#000; font-weight:bold; }
	
	nav#nav { padding:10px; text-align:right; }
	nav#nav ul li { display:inline-block; margin-left:10px; }
 
 		section#container { padding:20px 0; border-top:2px solid #eee; border-bottom:2px solid #eee; }
	section#container::after { content:""; display:block; clear:both; }
	aside { float:left; width:200px; }
	div#container_box { float:right; width:calc(100% - 200px - 20px); }
	
	aside ul li { text-align:center; margin-bottom:10px; }
	aside ul li a { display:block; width:100%; padding:10px 0;}
	aside ul li a:hover { background:#eee; }
	
	footer#footer { background:#f9f9f9; padding:20px; }
	footer#footer ul li { display:inline-block; margin-right:10px; } 
</style>


<style>
/*
#container_box table { width:900px; } 
#container_box table th { font-size:20px; font-weight:bold;
							text-align:center; padding:10px; border-bottom:2px solid #666; }
#container_box table tr:hover { background:#eee; }
#container_box table td { padding:10px; text-align:center; }
#container_box table img { width:150px; height:auto; }
*/
	.orderInfo { border:5px solid #eee; padding:10px 20px; margin:20px 0;} 
	.orderInfo span { font-size:20px; font-weight:bold; display:inline-block; width:90px; }
	
	.orderView li { margin-bottom:20px; padding-bottom:20px; border-bottom:1px solid #999; }
	.orderView li::after { content:""; display:block; clear:both; }
	
	.thumb { float:left; width:200px; }
	.thumb img { width:200px; height:200px; }
	.gdsInfo { float:right; width:calc(100% - 220px); line-height:2; }
	.gdsInfo span { font-size:20px; font-weight:bold; display:inline-block; width:100px; margin-right:10px; }
	
	.deliveryChange { text-align:right; }
	.delivery1_btn,
	.delivery2_btn { font-size:16px; background:#fff; border:1px solid #999; margin-left:10px; }
	
</style>

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
		<aside>
			<%@ include file="../include/aside.jsp" %>
		</aside>
		<div id="container_box">
		 
			
			<div class="orderInfo">
					<c:forEach items="${orderView}" var="orderView" varStatus="status">
						
						<c:if test="${status.first}">
							<p><span>주문자</span>${orderView.userId}</p>
							<p><span>수령인</span>${orderView.orderRec}</p>
							<p><span>주소</span>(${orderView.userAddr1}) ${orderView.userAddr2} ${orderView.userAddr3}</p>
							<p><span>가격</span><fmt:formatNumber pattern="###,###,###" value="${orderView.amount}" /> 원</p>
							<p><span>상태</span>${orderView.delivery}</p>
							
							<div class="deliveryChange">
								<form role="form" method="post" class="deliveryForm">
								
									<input type="hidden" name="orderId" value="${orderView.orderId}" />
									<input type="hidden" name="delivery" class="delivery" value="" />
									
									<button type="button" class="delivery1_btn">배송 중</button>
									<button type="button" class="delivery2_btn">배송 완료</button>
									
									<script>
										$(".delivery1_btn").click(function(){
											$(".delivery").val("배송 중");
											run();
										});
										
										$(".delivery2_btn").click(function(){
											$(".delivery").val("배송 완료");
											run();
											
										});
										
										function run(){
											$(".deliveryForm").submit();
										}
									
									</script>
								</form>
							</div>
						</c:if>
						
					</c:forEach>
				</div>
				
				<ul class="orderView">
					<c:forEach items="${orderView}" var="orderView">					
					<li>
						<div class="thumb">
							<img src="${orderView.gdsThumbImg}" />
						</div>
						<div class="gdsInfo">
							<p>
								<span>상품명</span>${orderView.gdsName}<br />
								<span>개당 가격</span><fmt:formatNumber pattern="###,###,###" value="${orderView.gdsPrice}" /> 원<br />
								<span>구입 수량</span>${orderView.cartStock} 개<br />
								<span>최종 가격</span><fmt:formatNumber pattern="###,###,###" value="${orderView.gdsPrice * orderView.cartStock}" /> 원                   
							</p>
						</div>
					</li>					
					</c:forEach>
				</ul>
			
		</div>
	</section>

	<footer id="footer">
		<div id="footer_box">
			<%@ include file="../include/footer.jsp" %>
		</div>		
	</footer>

</div>
</body>
</html>