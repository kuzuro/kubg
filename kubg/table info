
-- 회원 테이블
create table tbl_member (
    userId      varchar2(50)    not null,
    userPass    varchar2(100)   not null,
    userName    varchar2(30)    not null,
    userPhon    varchar2(20)    not null,
    userAddr1   varchar2(20)    null,
    userAddr2   varchar2(50)    null,
    userAddr3   varchar2(50)    null,
    regiDate    date            default sysdate,
    verify      number          default 0,
    primary key(userId)
);

-- 상품 테이블
create table tbl_goods (
    gdsNum       number          not null,
    gdsName      varchar2(50)    not null,
    cateCode     varchar2(30)    not null,
    gdsPrice     number          not null,
    gdsStock     number          null,
    gdsDes       varchar(500)    null,
    gdsImg       varchar(200)    null,
    gdsDate      date            default sysdate,
    primary key(gdsNum)   
);

-- 상품 번호용 시퀀스
create sequence tbl_goods_seq;


-- 상품 테이블과 카테고리 테이블 참조
alter table tbl_goods add
    constraint fk_goods_category
    foreign key (cateCode)
        references goods_category(cateCode);
        
-- 상품 테이블에 컬럼 추가
alter table tbl_goods add (gdsThumbImg varchar(200));

        
-- 카테고리 테이블
create table goods_category (
    cateName     varchar2(20)    not null,
    cateCode     varchar2(30)    not null,
    cateCodeRef  varchar2(30)    null,
    primary key(cateCode),
    foreign key(cateCodeRef) references goods_category(cateCode)
);

-- 상품 소감(댓글) 테이블
create table tbl_reply (
    gdsNum      number          not null,
    userId      varchar2(50)    not null,
    repNum      number          not null,
    repCon      varchar2(2000)  not null,
    repDate     date            default sysdate,
    primary key(gdsNum, repNum)  
);

-- 상품 소감(댓글) 시퀀스
create sequence tbl_reply_seq;

-- 상품 소감(댓글) 테이블과 상품 테이블 참조
alter table tbl_reply
    add constraint tbl_reply_gdsNum foreign key(gdsNum)
    references tbl_goods(gdsNum);
    
-- 상품 소감(댓글)과 맴버 테이블 참조
alter table tbl_reply
    add constraint tbl_reply_userId foreign key(userId)
    references tbl_member(userId);

-- 카트 테이블
create table tbl_cart (
    cartNum     number          not null,
    userId      varchar2(50)    not null,
    gdsNum      number          not null,
    cartStock   number          not null,
    addDate     date            default sysdate,
    primary key(cartNum, userId)  
);

-- 카트 테이블 시퀀스
create sequence tbl_cart_seq;

-- 카트 테이블과 맴버 테이블 참조
alter table tbl_cart
    add constraint tbl_cart_userId foreign key(userId)
    references tbl_member(userId);

-- 카트 테이블과 상품 테이블 참조
alter table tbl_cart
    add constraint tbl_cart_gdsNum foreign key(gdsNum)
    references tbl_goods(gdsNum);
    
-- 주문 테이블
create table tbl_order (
    orderId     varchar2(50) not null,
    userId      varchar2(50) not null,
    orderRec    varchar2(50) not null,
    userAddr1   varchar2(20) not null,
    userAddr2   varchar2(50) not null,
    userAddr3   varchar2(50) not null,
    orderPhon   varchar2(30) not null,
    amount      number       not null,
    orderDate   Date         default sysdate,    
    primary key(orderId)
);

-- 주문 테이블과 맴버 테이블 참조
alter table tbl_order
    add constraint tbl_order_userId foreign key(userId)
    references tbl_member(userId);
     
-- 주문 상세 테이블
create table tbl_order_details (
    orderDetailsNum number       not null,
    orderId         varchar2(50) not null,
    gdsNum          number          not null,
    cartStock       number          not null,
    primary key(orderDetailsNum)
);

-- 주문 상세 번호 시퀀스
create sequence tbl_order_details_seq;

-- 주문 상세 테이블과 주문 테이블 참조
alter table tbl_order_details
    add constraint tbl_order_details_orderId foreign key(orderId)
    references tbl_order(orderId);
    
-- 주문 테이블에 배송 컬럼 추가
alter table tbl_order
    add(delivery varchar2(20) default '배송준비');
    
-- 주문 테이블의 컬럼 크기 수정
alter table tbl_order
    modify(userAddr1 varchar2(100));

alter table tbl_order
    modify(userAddr2 varchar2(100));
    
alter table tbl_order
    modify(userAddr3 varchar2(100));