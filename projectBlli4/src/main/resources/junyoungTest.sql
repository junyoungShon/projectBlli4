imvestt@hanmail.net

drop table blli_member;

create table blli_member(
	member_id varchar2(50) primary key,
	member_email varchar2(50) not null,
	member_password varchar2(100) not null,
	member_Name varchar2(20) not null,
	member_state number(1) not null,
	recommending_baby_name varchar(20) not null,
	authority varchar2(10) not null
)

create table blli_baby(
	member_id varchar2(50) primary key,
	baby_name varchar2(50) not null,
	baby_birthday date not null,
	baby_sex varchar2(10) not null,
	baby_photo varchar2(200) not null
)
drop table blli_baby

insert into BLLI_MEMBER (member_Id,member_password,member_email,member_name,member_state,recommending_child_name,authority)
		values ('asdf','asdf','asdf','asdf',1,'asdf','ROLE_USER');
		
		
select posting_content from blli_posting where small_product_id=5702689300
drop table blli_recomm_mid_category cascade constraint;
CREATE TABLE blli_recomm_mid_category (
	member_id            VARCHAR2(30) NOT NULL ,
	mid_category         VARCHAR2(50) NOT NULL ,
	category_id          VARCHAR2(30) NOT NULL, -- 추가
	constraint fk_recomm_mid_cate_mem_id foreign key(member_id) references blli_member(member_id),
	constraint fk_recomm_mid_mid_cate foreign key(mid_category,category_id) references blli_mid_category(mid_category,category_id), --수정
	constraint pk_recomm_mid_cate primary key (member_id, mid_category)
);

--회원의 추천 기피 중분류 제품 테이블
CREATE TABLE BLLI_NOT_RECOMM_MID_CATEGORY(
	member_id            VARCHAR2(30) NOT NULL ,
	mid_category         VARCHAR2(50) NOT NULL ,
	mid_category_id          VARCHAR2(30) NOT NULL, -- 추가
	constraint fk_NOT_recomm_mid_cate_mem_id foreign key(member_id) references blli_member(member_id),
	constraint fk_NOT_recomm_mid_mid_cate foreign key(mid_category,category_id) references blli_mid_category(mid_category,category_id), --수정
	constraint pk_NOT_recomm_mid_cate primary key (member_id, mid_category)
)
select * from (select rownum as rn,SMALL_PRODUCT, MID_CATEGORY,mid_CATEGORY_ID, SMALL_PRODUCT_MAKER, SMALL_PRODUCT_WHENTOUSE_MIN, SMALL_PRODUCT_WHENTOUSE_MAX, SMALL_PRODUCT_DIBS_COUNT, 
		SMALL_PRODUCT_MAIN_PHOTO_LINK, SMALL_PRODUCT_SCORE, SMALL_PRODUCT_POSTING_COUNT, NAVER_SHOPPING_RANK, PRODUCT_REGISTER_DAY,small_product_id
		from BLLI_SMALL_PRODUCT
		where MID_CATEGORY = '8191428972' and '1' >= SMALL_PRODUCT_WHENTOUSE_MIN and '1' <= SMALL_PRODUCT_WHENTOUSE_MAX
		order by SMALL_PRODUCT_DIBS_COUNT desc) where rn<3

select 
from recommMidCategory
where
--중분류 추천 제외 대상 쿼리
select bnrmc.mid_category as noRecommendMidCategory
from blli_member bm , BLLI_NOT_RECOMM_MID_CATEGORY bnrmc
where bm.member_id = bnrmc.member_id

--기간에 따른 중분류 추천 제품 쿼리
select  mid_category
from BLLI_MID_CATEGORY
where 0 >= mid_category_whentouse_min and 0<=mid_category_whentouse_min

-- 기간에 따른 중분류 추천 이후 중분류 추천 제외 
select  mid_category,mid_category_info,mid_category_main_photo_link,mid_category_whentouse_min,mid_category_whentouse_max,big_category,category_id
		from BLLI_MID_CATEGORY
		where 0 >= mid_category_whentouse_min and 0<=mid_category_whentouse_min and not mid_category = (select bnrmc.mid_category as noRecommendMidCategory
		from blli_member bm , BLLI_NOT_RECOMM_MID_CATEGORY bnrmc
		where 'imvestt@hanmail.net' = bnrmc.member_id)


### The error occurred while setting parameters
### SQL: select  mid_category,mid_category_info,mid_category_main_photo_link,mid_category_whentouse_min,mid_category_whentouse_max,big_category,category_id   from BLLI_MID_CATEGORY   where 0  = mid_category_whentouse_min and 0<= >mid_category_whentouse_min and not mid_category = (select bnrmc.mid_category as noRecommendMidCategory   from blli_member bm , BLLI_NOT_RECOMM_MID_CATEGORY bnrmc   where bm.member_id = bnrmc.member_id)
### Cause: java.sql.SQLException: ORA-00936: 누락된 표현식
select  mid_category,mid_category_info,mid_category_main_photo_link,mid_category_whentouse_min,mid_category_whentouse_max,big_category,category_id   
from BLLI_MID_CATEGORY   
where 0  = mid_category_whentouse_min and 0<= >mid_category_whentouse_min and not mid_category = 
(select bnrmc.mid_category as noRecommendMidCategory   from blli_member bm , BLLI_NOT_RECOMM_MID_CATEGORY bnrmc   where bm.member_id = bnrmc.member_id)

select  mid_category,mid_category_info,mid_category_main_photo_link,mid_category_whentouse_min,mid_category_whentouse_max,big_category,category_id   
from BLLI_MID_CATEGORY   
where ?  = mid_category_whentouse_min and ?<= >mid_category_whentouse_min and not mid_category = 
(select bnrmc.mid_category as noRecommendMidCategory   from blli_member bm , BLLI_NOT_RECOMM_MID_CATEGORY bnrmc   where ? = bnrmc.member_id)
### Cause: java.sql.SQLException: ORA-00936: 누락된 표현식



insert into
"SCOTT"."BLLI_SMALL_PRODUCT" ("SMALL_PRODUCT", "MID_CATEGORY", "CATEGORY_ID", "SMALL_PRODUCT_MAKER", "SMALL_PROPDUCT_WHENTOUSE_MIN", "SMALL_PROPDUCT_WHENTOUSE_MAX", "SMALL_PRODUCT_DIBS_COUNT", 
"SMALL_PRODUCT_MAIN_PHOTO_LINK", "SMALL_PRODUCT_SCORE", "SMALL_PRODUCT_POSTING_COUNT", "NAVER_SHOPPING_LINK", "NAVER_SHOPPING_ORDER", "PRODUCT_REGISTER_DAY") 
values('A사의레토르트이유식12개월용', '레토르트이유식', '50000737', '1', 12, 12, 100, '11', 1, 11, '1', 1, sysdate)

insert into
"SCOTT"."BLLI_SMALL_PRODUCT" ("SMALL_PRODUCT", "MID_CATEGORY", "CATEGORY_ID", "SMALL_PRODUCT_MAKER", "SMALL_PROPDUCT_WHENTOUSE_MIN", "SMALL_PROPDUCT_WHENTOUSE_MAX", "SMALL_PRODUCT_DIBS_COUNT", 
"SMALL_PRODUCT_MAIN_PHOTO_LINK", "SMALL_PRODUCT_SCORE", "SMALL_PRODUCT_POSTING_COUNT", "NAVER_SHOPPING_LINK", "NAVER_SHOPPING_ORDER", "PRODUCT_REGISTER_DAY") 
values('B사의레토르트이유식12개월용', '레토르트이유식', '50000737', '1', 12, 12, 100, '11', 1, 11, '1', 1, sysdate)

insert into
"SCOTT"."BLLI_SMALL_PRODUCT" ("SMALL_PRODUCT", "MID_CATEGORY", "CATEGORY_ID", "SMALL_PRODUCT_MAKER", "SMALL_PROPDUCT_WHENTOUSE_MIN", "SMALL_PROPDUCT_WHENTOUSE_MAX", "SMALL_PRODUCT_DIBS_COUNT", 
"SMALL_PRODUCT_MAIN_PHOTO_LINK", "SMALL_PRODUCT_SCORE", "SMALL_PRODUCT_POSTING_COUNT", "NAVER_SHOPPING_LINK", "NAVER_SHOPPING_ORDER", "PRODUCT_REGISTER_DAY") 
values('C사의레토르트이유식12개월용', '레토르트이유식', '50000737', '1', 12, 12, 0, '11', 1, 11, '1', 1, sysdate)




insert into
"SCOTT"."BLLI_SMALL_PRODUCT" ("SMALL_PRODUCT", "MID_CATEGORY", "CATEGORY_ID", "SMALL_PRODUCT_MAKER", "SMALL_PROPDUCT_WHENTOUSE_MIN", "SMALL_PROPDUCT_WHENTOUSE_MAX", "SMALL_PRODUCT_DIBS_COUNT", 
"SMALL_PRODUCT_MAIN_PHOTO_LINK", "SMALL_PRODUCT_SCORE", "SMALL_PRODUCT_POSTING_COUNT", "NAVER_SHOPPING_LINK", "NAVER_SHOPPING_ORDER", "PRODUCT_REGISTER_DAY") 
values('A사의레토르트이유식13개월용', '레토르트이유식', '50000737', '1', 13, 13, 100, '11', 1, 11, '1', 1, sysdate)

insert into
"SCOTT"."BLLI_SMALL_PRODUCT" ("SMALL_PRODUCT", "MID_CATEGORY", "CATEGORY_ID", "SMALL_PRODUCT_MAKER", "SMALL_PROPDUCT_WHENTOUSE_MIN", "SMALL_PROPDUCT_WHENTOUSE_MAX", "SMALL_PRODUCT_DIBS_COUNT", 
"SMALL_PRODUCT_MAIN_PHOTO_LINK", "SMALL_PRODUCT_SCORE", "SMALL_PRODUCT_POSTING_COUNT", "NAVER_SHOPPING_LINK", "NAVER_SHOPPING_ORDER", "PRODUCT_REGISTER_DAY") 
values('B사의레토르트이유식13개월용', '레토르트이유식', '50000737', '1', 13, 13, 100, '11', 1, 11, '1', 1, sysdate)

insert into
"SCOTT"."BLLI_SMALL_PRODUCT" ("SMALL_PRODUCT", "MID_CATEGORY", "CATEGORY_ID", "SMALL_PRODUCT_MAKER", "SMALL_PROPDUCT_WHENTOUSE_MIN", "SMALL_PROPDUCT_WHENTOUSE_MAX", "SMALL_PRODUCT_DIBS_COUNT", 
"SMALL_PRODUCT_MAIN_PHOTO_LINK", "SMALL_PRODUCT_SCORE", "SMALL_PRODUCT_POSTING_COUNT", "NAVER_SHOPPING_LINK", "NAVER_SHOPPING_ORDER", "PRODUCT_REGISTER_DAY") 
values('C사의레토르트이유식13개월용', '레토르트이유식', '50000737', '1', 13, 13, 0, '11', 1, 11, '1', 1, sysdate)



insert into
"SCOTT"."BLLI_SMALL_PRODUCT" ("SMALL_PRODUCT", "MID_CATEGORY", "CATEGORY_ID", "SMALL_PRODUCT_MAKER", "SMALL_PROPDUCT_WHENTOUSE_MIN", "SMALL_PROPDUCT_WHENTOUSE_MAX", "SMALL_PRODUCT_DIBS_COUNT", 
"SMALL_PRODUCT_MAIN_PHOTO_LINK", "SMALL_PRODUCT_SCORE", "SMALL_PRODUCT_POSTING_COUNT", "NAVER_SHOPPING_LINK", "NAVER_SHOPPING_ORDER", "PRODUCT_REGISTER_DAY") 
values('A사의노리개젖꼭지12개월용', '노리개젖꼭지', '50000746', '1', 12, 12, 100, '11', 1, 11, '1', 1, sysdate)

insert into
"SCOTT"."BLLI_SMALL_PRODUCT" ("SMALL_PRODUCT", "MID_CATEGORY", "CATEGORY_ID", "SMALL_PRODUCT_MAKER", "SMALL_PROPDUCT_WHENTOUSE_MIN", "SMALL_PROPDUCT_WHENTOUSE_MAX", "SMALL_PRODUCT_DIBS_COUNT", 
"SMALL_PRODUCT_MAIN_PHOTO_LINK", "SMALL_PRODUCT_SCORE", "SMALL_PRODUCT_POSTING_COUNT", "NAVER_SHOPPING_LINK", "NAVER_SHOPPING_ORDER", "PRODUCT_REGISTER_DAY") 
values('B사의노리개젖꼭지12개월용', '노리개젖꼭지', '50000746', '1', 12, 12, 100, '11', 1, 11, '1', 1, sysdate)

insert into
"SCOTT"."BLLI_SMALL_PRODUCT" ("SMALL_PRODUCT", "MID_CATEGORY", "CATEGORY_ID", "SMALL_PRODUCT_MAKER", "SMALL_PROPDUCT_WHENTOUSE_MIN", "SMALL_PROPDUCT_WHENTOUSE_MAX", "SMALL_PRODUCT_DIBS_COUNT", 
"SMALL_PRODUCT_MAIN_PHOTO_LINK", "SMALL_PRODUCT_SCORE", "SMALL_PRODUCT_POSTING_COUNT", "NAVER_SHOPPING_LINK", "NAVER_SHOPPING_ORDER", "PRODUCT_REGISTER_DAY") 
values('C사의노리개젖꼭지12개월용', '노리개젖꼭지', '50000746', '1', 12, 12, 0, '11', 1, 11, '1', 1, sysdate)





insert into
"SCOTT"."BLLI_SMALL_PRODUCT" ("SMALL_PRODUCT", "MID_CATEGORY", "CATEGORY_ID", "SMALL_PRODUCT_MAKER", "SMALL_PROPDUCT_WHENTOUSE_MIN", "SMALL_PROPDUCT_WHENTOUSE_MAX", "SMALL_PRODUCT_DIBS_COUNT", 
"SMALL_PRODUCT_MAIN_PHOTO_LINK", "SMALL_PRODUCT_SCORE", "SMALL_PRODUCT_POSTING_COUNT", "NAVER_SHOPPING_LINK", "NAVER_SHOPPING_ORDER", "PRODUCT_REGISTER_DAY") 
values('A사의젖병12개월용', '젖병', '50000743', '1', 12, 12, 100, '11', 1, 11, '1', 1, sysdate)

insert into
"SCOTT"."BLLI_SMALL_PRODUCT" ("SMALL_PRODUCT", "MID_CATEGORY", "CATEGORY_ID", "SMALL_PRODUCT_MAKER", "SMALL_PROPDUCT_WHENTOUSE_MIN", "SMALL_PROPDUCT_WHENTOUSE_MAX", "SMALL_PRODUCT_DIBS_COUNT", 
"SMALL_PRODUCT_MAIN_PHOTO_LINK", "SMALL_PRODUCT_SCORE", "SMALL_PRODUCT_POSTING_COUNT", "NAVER_SHOPPING_LINK", "NAVER_SHOPPING_ORDER", "PRODUCT_REGISTER_DAY") 
values('B사젖병12개월용', '젖병', '50000743', '1', 12, 12, 100, '11', 1, 11, '1', 1, sysdate)

insert into
"SCOTT"."BLLI_SMALL_PRODUCT" ("SMALL_PRODUCT", "MID_CATEGORY", "CATEGORY_ID", "SMALL_PRODUCT_MAKER", "SMALL_PROPDUCT_WHENTOUSE_MIN", "SMALL_PROPDUCT_WHENTOUSE_MAX", "SMALL_PRODUCT_DIBS_COUNT", 
"SMALL_PRODUCT_MAIN_PHOTO_LINK", "SMALL_PRODUCT_SCORE", "SMALL_PRODUCT_POSTING_COUNT", "NAVER_SHOPPING_LINK", "NAVER_SHOPPING_ORDER", "PRODUCT_REGISTER_DAY") 
values('C사의젖병12개월용', '젖병', '50000743', '1', 12, 12, 0, '11', 1, 11, '1', 1, sysdate)



insert into
"SCOTT"."BLLI_SMALL_PRODUCT" ("SMALL_PRODUCT", "MID_CATEGORY", "CATEGORY_ID", "SMALL_PRODUCT_MAKER", "SMALL_PROPDUCT_WHENTOUSE_MIN", "SMALL_PROPDUCT_WHENTOUSE_MAX", "SMALL_PRODUCT_DIBS_COUNT", 
"SMALL_PRODUCT_MAIN_PHOTO_LINK", "SMALL_PRODUCT_SCORE", "SMALL_PRODUCT_POSTING_COUNT", "NAVER_SHOPPING_LINK", "NAVER_SHOPPING_ORDER", "PRODUCT_REGISTER_DAY") 
values('A사의유축기12개월용', '유축기', '50000673', '1', 12, 12, 100, '11', 1, 11, '1', 1, sysdate)

insert into
"SCOTT"."BLLI_SMALL_PRODUCT" ("SMALL_PRODUCT", "MID_CATEGORY", "CATEGORY_ID", "SMALL_PRODUCT_MAKER", "SMALL_PROPDUCT_WHENTOUSE_MIN", "SMALL_PROPDUCT_WHENTOUSE_MAX", "SMALL_PRODUCT_DIBS_COUNT", 
"SMALL_PRODUCT_MAIN_PHOTO_LINK", "SMALL_PRODUCT_SCORE", "SMALL_PRODUCT_POSTING_COUNT", "NAVER_SHOPPING_LINK", "NAVER_SHOPPING_ORDER", "PRODUCT_REGISTER_DAY") 
values('B사유축기12개월용', '유축기', '50000673', '1', 12, 12, 100, '11', 1, 11, '1', 1, sysdate)

insert into
"SCOTT"."BLLI_SMALL_PRODUCT" ("SMALL_PRODUCT", "MID_CATEGORY", "CATEGORY_ID", "SMALL_PRODUCT_MAKER", "SMALL_PROPDUCT_WHENTOUSE_MIN", "SMALL_PROPDUCT_WHENTOUSE_MAX", "SMALL_PRODUCT_DIBS_COUNT", 
"SMALL_PRODUCT_MAIN_PHOTO_LINK", "SMALL_PRODUCT_SCORE", "SMALL_PRODUCT_POSTING_COUNT", "NAVER_SHOPPING_LINK", "NAVER_SHOPPING_ORDER", "PRODUCT_REGISTER_DAY") 
values('C사의유축기12개월용', '유축기', '50000673', '1', 12, 12, 0, '11', 1, 11, '1', 1, sysdate)



select SMALL_PRODUCT, MID_CATEGORY,CATEGORY_ID, SMALL_PRODUCT_MAKER, SMALL_PROPDUCT_WHENTOUSE_MIN, SMALL_PROPDUCT_WHENTOUSE_MAX, SMALL_PRODUCT_DIBS_COUNT, 
SMALL_PRODUCT_MAIN_PHOTO_LINK, SMALL_PRODUCT_SCORE, SMALL_PRODUCT_POSTING_COUNT, NAVER_SHOPPING_LINK, NAVER_SHOPPING_ORDER, PRODUCT_REGISTER_DAY from BLLI_SMALL_PRODUCT

select rownum as rn,SMALL_PRODUCT, MID_CATEGORY, SMALL_PRODUCT_DIBS_COUNT
from BLLI_SMALL_PRODUCT
where MID_CATEGORY = '유축기'
order by SMALL_PRODUCT_DIBS_COUNT desc

select * from (select rownum as rn,SMALL_PRODUCT, MID_CATEGORY,CATEGORY_ID, SMALL_PRODUCT_MAKER, SMALL_PROPDUCT_WHENTOUSE_MIN, SMALL_PROPDUCT_WHENTOUSE_MAX, SMALL_PRODUCT_DIBS_COUNT, 
SMALL_PRODUCT_MAIN_PHOTO_LINK, SMALL_PRODUCT_SCORE, SMALL_PRODUCT_POSTING_COUNT, NAVER_SHOPPING_LINK, NAVER_SHOPPING_ORDER, PRODUCT_REGISTER_DAY
from BLLI_SMALL_PRODUCT
where MID_CATEGORY = '유축기' and 12  >= SMALL_PROPDUCT_WHENTOUSE_MIN and 12<= SMALL_PROPDUCT_WHENTOUSE_MAX
order by SMALL_PRODUCT_DIBS_COUNT desc) where rn<3



insert into "SCOTT"."BLLI_POSTING" ("POSTING_URL", "SMALL_PRODUCT", "SMALL_PRODUCT_ID", "POSTING_TITLE", "POSTING_SUMMARY", "POSTING_CONTENT", "POSTING_MEDIA_COUNT", "POSTING_PHOTO_LINK", "POSTING_AUTHOR", "POSTING_DATE", "POSTING_ORDER", "POSTING_REPLY_COUNT", "POSTING_STATUS") 
values('http://blog.naver.com/dear_hyde/220517255806', 'Cowala 트루 오리지널 골드+ 3...', '7903518970', '[코알라분유] 뉴질랜드 코알라 조제분...', 'asdfasdf', 'asdfasdf', 5, 'http://postfiles6.na...', '디어 태브라더', '2014-05-05', 1, 1, '1')


select posting_url,small_product,small_product_id,posting_title,posting_summary,posting_content,posting_score,posting_like_count,
		posting_dislike_count,posting_media_count,posting_photo_link,posting_total_residence_time,posting_view_count,posting_scrap_count,posting_author,posting_date
		from blli_posting
		where posting_status = 'confirmed'
		order by posting_score asc;
		
		
		create table persistent_logins (username varchar(64) not null, series varchar(64) primary key, token varchar(64) not null, last_used timestamp not null)
		
		
		
		select * from(
		select rownum rn ,posting_url,small_product,small_product_id,posting_title,posting_summary,posting_content,posting_score,posting_like_count,
		posting_dislike_count,posting_media_count,posting_photo_link,posting_total_residence_time,posting_view_count,posting_scrape_count,posting_author,posting_date
		from(
		select posting_url,small_product,small_product_id,posting_title,posting_summary,posting_content,posting_score,posting_like_count,
		posting_dislike_count,posting_media_count,posting_photo_link,posting_total_residence_time,posting_view_count,posting_scrape_count,posting_author,posting_date
		from blli_posting
		where posting_status = 'confirmed' and small_product_id = 5666321696
		order by posting_score desc)
		) where rn = 3
		
		select count(*) from blli_small_product
		select * from
		(select rownum as rn,mid_category_id,small_product_id,small_product_dibs_count,detail_view_count,naver_shopping_rank,product_register_day,product_db_insert_date from blli_small_product
		)where rn>500
		select rownum as rn,mid_category_id,small_product_id,small_product_dibs_count,detail_view_count,naver_shopping_rank,product_register_day,product_db_insert_date from blli_small_product where small_product_id = null
		select count(*) from blli_posting
		update blli_small_product set small_product_status = 'confirmed'
		update blli_posting set posting_status = 'confirmed'
		
		select posting_url,small_product_id,posting_like_count,posting_dislike_count,posting_total_residence_time/posting_view_count as avgResi
		posting_media_count,posting_total_residence_time,posting_view_count,posting_scrape_count,posting_rank,posting_date,posting_reply_count,posting_db_insert_date
		from blli_posting
		where posting_status = 'confirmed'
		order by asc
		select small_product_id,small_product_dibs_count,detail_view_count,naver_shopping_rank,product_register_day,product_db_insert_date from blli_small_product
		update blli_posting set posting_db_insert_date = sysdate 
		update blli_small_product set product_db_insert_date = sysdate 
		update blli_small_product set detail_view_count = 0 
		update blli_small_product set detail_view_count = 0 
		update blli_posting set posting_db_insert_date = '2015-02-03'
		select * from blli_posting where posting_url='http://blog.naver.com/mykid0430/220491426583'
		select * from blli_small_product where small_product_score < 70
		select * from blli_small_product where small_product_status = 'confirmed'
		select avg(small_product_score) from blli_small_product where small_product_status = 'confirmed'
		select avg(posting_score) from blli_posting where posting_status = 'confirmed' 
		select avg(small_product_score) from blli_small_product where small_product_status = 'confirmed' 
		
		select small_product_score from blli_small_product where small_product_score>100 and  small_product_status = 'confirmed'
		select posting_score from blli_posting where posting_score>100 and small_product_status = 'confirmed' 
		
		select posting_score from blli_posting
		
		select count(*) from blli_posting where posting_status = 'confirmed'
		
		update blli_mid_category set small_product_count = 1000;
		select mid_category_id,small_product_id,small_product_dibs_count,detail_view_count,naver_shopping_rank,product_register_day,product_db_insert_date from blli_small_product
		select sum(buy_link_click_count) from blli_small_prod_buy_link where small_product_id =7909155651
		update blli_small_prod_buy_link set buy_link_click_count = 1   where small_product_id =7909155651
		
		select small_product_id,small_product_score from blli_small_product where mid_category_id = '50000217' and small_product_status ='confirmed' order by small_product_score desc;
		
		update blli_posting set posting_status = 'unconfirmed' where posting_url = 'http://blog.naver.com/hee2752/130575057'
		update blli_posting set posting_status = 'unconfirmed' where small_product_id = '7610052389'
		update blli_posting set posting_status = 'confirmed' where small_product_id = '5702689300'
		update blli_posting set posting_status = 'confirmed' where posting_status = 'dead'
		update blli
		select * from (select rownum as rn , word,word_count,small_product_id from blli_word_cloud where small_product_id ='5702689300' order by word_count desc) 
		select rownum as rn , word,word_count,small_product_id from blli_word_cloud where small_product_id ='5702689300' order by word_count desc
		select * from(
		select rownum as rn , word,word_count,small_product_id from (
		select  word,word_count,small_product_id from blli_word_cloud where small_product_id ='5702689300' order by word_count desc))where rn < 21
		select posting_url from blli_posting where posting_photo_link = 'scrawlImage/postingImage/ff19811141954194a1aa6844a601aa04.jpg' 
		 
		
		select small_product from blli_small_product where small_product_id = 5702689300
		
		
		select * from(
		select rownum rn ,posting_url,small_product,small_product_id,posting_title,posting_summary,posting_content,posting_score,posting_like_count,
		posting_dislike_count,posting_media_count,posting_photo_link,posting_total_residence_time,posting_view_count,posting_scrape_count,posting_author,posting_date
		from(
		select posting_url,small_product,small_product_id,posting_title,posting_summary,posting_content,posting_score,posting_like_count,
		posting_dislike_count,posting_media_count,posting_photo_link,posting_total_residence_time,posting_view_count,posting_scrape_count,posting_author,posting_date
		from blli_posting
		where posting_status = 'confirmed' and small_product_id = '8191428972'
		order by posting_score desc)
		) where rn >= 0 and rn < 6
		
		update blli_small_product  set  small_product_whentouse_max = 1 where  small_product_whentouse_max = 11
		
		select * from blli_small_product where small_product_whentouse_max = 11
		
		select * from 
		(select 
		bsp.rownum as rn,bsp.SMALL_PRODUCT, bsp.MID_CATEGORY,bsp.mid_CATEGORY_ID, bsp.SMALL_PRODUCT_MAKER, 
		bsp.SMALL_PRODUCT_WHENTOUSE_MIN, bsp.SMALL_PRODUCT_WHENTOUSE_MAX, bsp.SMALL_PRODUCT_DIBS_COUNT, 
		bsp.SMALL_PRODUCT_MAIN_PHOTO_LINK, bsp.SMALL_PRODUCT_SCORE, bsp.SMALL_PRODUCT_POSTING_COUNT, bsp.NAVER_SHOPPING_RANK, bsp.PRODUCT_REGISTER_DAY,bsp.small_product_id
		from BLLI_SMALL_PRODUCT bsp,
		where MID_CATEGORY_id = #{recommMid} and #{babyMonthAge}  >= SMALL_PRODUCT_WHENTOUSE_MIN and #{babyMonthAge} <= SMALL_PRODUCT_WHENTOUSE_MAX
		order by SMALL_PRODUCT_DIBS_COUNT desc) 
		where rn<3
		select * from blli_small_product where sns_share_count >0 
		
		select * from (
			select buy_link_price,rownum as rn from blli_small_prod_buy_link where small_product_id = '7909155651' 
		) where rn =1
		
		select count(*) from blli_small_product where small_product like '모빌'
		
		유아의자	86	유아소파	50000592
		insert into Monthly_product_and_n_mid (Monthly_Product_ID,MiD_CATEGORY,MiD_CATEGORY_ID) values  ('86','유아소파','50000592')

select monthly_product_id from blli_monthly_product

	select mid_category_id from monthly_product_and_n_mid where monthly_product_id ='1'
	select * from (
		select  mid_category_id,mid_category_main_photo_link from blli_mid_category where mid_category_id = (
			select rownum rn mid_category_id from monthly_product_and_n_mid where monthly_product_id ='103'AND ROWNUM = 1
		) AND rn = 1
	)

	select m.mid_category_id as mid_category_id , m.mid_category_main_photo_link as mid_category_main_photo_link, mp.monthly_product_id as monthly_product_id
	from blli_mid_category m , monthly_product_and_n_mid mp
	where m.mid_category_id = mp.mid_category_id and mp.monthly_product_id = '103' 
	
	select * from blli_small_product where mid_category = '젖병세정제';
	select * from blli_mid_category where mid_category_id='50000603';
	select * from blli_small_product where small_product_status = 'confirmed'
	select count(*) from blli_posting where posting_status = 'confirmed'
	
	
	select * from(
			select ceil(rownum/5) as page, bl.small_product_id, bl.min_price, sp.small_product, sp.small_product_main_photo_link, sp.small_product_ranking,
			sp.small_product_whentouse_min, sp.small_product_whentouse_max, sp.db_insert_posting_count, sp.small_product_score,sp.small_product_dibs_count from(
				select b.small_product_id, min(b.buy_link_price) as min_price from (
					select small_product_id from blli_small_product where mid_category = '무릎보호대'  and small_product_status = 'confirmed'
				)s, blli_small_prod_buy_link b where s.small_product_id = b.small_product_id  group by b.small_product_id
			)bl, blli_small_product sp where bl.small_product_id = sp.small_product_id order by sp.small_product_score desc
		) where page = 1 order by small_product_id
	
	CREATE TABLE blli_member (
	member_id            VARCHAR2(30) NOT NULL primary key,
	member_email         VARCHAR2(50) NULL ,
	member_password      VARCHAR2(100) NOT NULL ,
	member_name          VARCHAR2(30) NOT NULL ,
	member_state         NUMBER(2) default 0 ,
	--recommending 		NUMBER(1) NOT NULL, 삭제 
	authority            VARCHAR2(20),
	mail_agree          NUMBER(1) default 0
);	
create table book(
	title varchar2(30) not null primary key,
	author varchar2(30) not null,
	area number(20) default 0,
	width number(10) default 0,
	height number(10) default 0
);
insert into "SCOTT"."book"  title,author,width,height values ('장한솔씨의 야근피하기','장한솔',10,10);
insert into "SCOTT"."BOOK" ("TITLE", "AUTHOR", "AREA", "WIDTH", "HEIGHT") values('장한솔씨의집착', '장한솔', 0, 10, 10)

UPDATE BOOK SET AREA = (SELECT WIDTH*HEIGHT FROM BOOK ) where area!= (SELECT WIDTH*HEIGHT FROM BOOK );



select monthly_product,monthly_product_id,

select bmp.monthly_product,bmp.min_usable_month,bmp.monthly_product_photolink,mpanm.monthly_product_id,mpanm.mid_category_id,mpanm.mid_category
from blli_monthly_product bmp , monthly_product_and_n_mid mpanm
where bmp.monthly_product_id = mpanm.monthly_product_id and bmp.min_usable_month = 0


select count(*) from blli_posting where small_product_id = '5707728498';

		

select distinct min_usable_month from blli_monthly_product order by min_usable_month asc

select distinct t.mid_category_id as mid_category_id ,count(*)over(partition by t.mid_category_id) as mid_category_count
from(
select distinct bsp.small_product_id as small_product_id, bsp.mid_category_id as mid_category_id 
from blli_monthly_product bmp,blli_mid_category bmc ,blli_small_product bsp,monthly_product_and_n_mid mpanm
where bmp.monthly_product_id = mpanm.monthly_product_id and mpanm.mid_category_id = bsp.mid_category_id  and bsp.small_product_status='confirmedbyadmin' 
and bmp.min_usable_month = -1
) t
where t.mid_category_id = '50000745'


select count(*) 
from blli_mid_category bmc ,blli_small_product bsp
where bsp.small_product_status='confirmedbyadmin' 


select t.mid_category_id,count(*)over (partition by t.mid_category_id)
from(
	select distinct t.mid_category_id as mid_category_id ,count(*)over(partition by t.mid_category_id) as mid_category_count
	from(
	select distinct bsp.small_product_id as small_product_id, bsp.mid_category_id as mid_category_id 
	from blli_monthly_product bmp,blli_mid_category bmc ,blli_small_product bsp,monthly_product_and_n_mid mpanm
	where bmp.monthly_product_id = mpanm.monthly_product_id and mpanm.mid_category_id = bsp.mid_category_id  and bsp.small_product_status='confirmedbyadmin' 

	) t
) t where t.mid_category_count >4



select distinct t.min_usable_month as minUsableMonth ,count(*)over (partition by  t.min_usable_month) as totalCount
from(
	select distinct t.mid_category_id as mid_category_id ,count(*)over(partition by t.mid_category_id) as mid_category_count, t.min_usable_month as min_usable_month
	from(
	select distinct bsp.small_product_id as small_product_id, bsp.mid_category_id as mid_category_id ,bmp.min_usable_month as min_usable_month
	from blli_monthly_product bmp,blli_mid_category bmc ,blli_small_product bsp,monthly_product_and_n_mid mpanm
	where bmp.monthly_product_id = mpanm.monthly_product_id and mpanm.mid_category_id = bsp.mid_category_id  and bsp.small_product_status='confirmedbyadmin' 

	) t
) t where t.mid_category_count >4 order by t.min_usable_month asc


select * from blli_posting where small_product_id= '5707788643' and posting_status = 'unconfirmed'

select count(*) over() , t.posting_title,t.posting_url from(
			select count(*) over (partition by posting_url) as count_posting_url, small_product_id,posting_title,posting_url from blli_posting where posting_status = 'unconfirmed'
		) t where count_posting_url = 2 and small_product_id = '5707788643'
		
				select count(*) from(
			select small_product_id from blli_posting where posting_status = 'unconfirmed'
		) where small_product_id = '5707788643'
		
		select posting_url, posting_title, posting_content, small_product, small_product_id from(
			select ceil(rownum/5) as page, posting_url, posting_title, posting_content, small_product, small_product_id from(
				select  posting_url, posting_title, 
				posting_content, small_product, small_product_id from blli_posting where posting_status = 'unconfirmed' order by small_product asc
			) where small_product_id = '5707788643'
		) where page =2
		
		select * from blli_posting where posting_url = 'http://blog.naver.com/again4820/220575736266'
		select * from blli_posting where posting_url = 'http://blog.naver.com/unchanging1/220465806082'
		select * from blli_posting where posting_url = 'http://blog.naver.com/cjsqmffl0629/220388553963'
		
		select posting_url, posting_title, posting_content, small_product, small_product_id from(
			select ceil(rownum/5) as page, posting_url, posting_title, posting_content, small_product, small_product_id from(
				select posting_url, posting_title, 
				posting_content, small_product, small_product_id from blli_posting where posting_status = 'unconfirmed' order by small_product asc
			) where small_product_id = '5707788643'
		) where page = 1
		
		
		select * from(
			select ceil(row_num/5) as page, posting_url, posting_title, small_product, posting_content, small_product_id from(
				select (dense_rank() over (order by posting_url)) row_num, posting_url, posting_title, small_product, posting_content, small_product_id from(
					select count(*) over (partition by posting_url) as small_product_count, posting_url, posting_title, small_product, 
					posting_content, small_product_id from blli_posting where posting_status = 'unconfirmed' 
				) where small_product_count > 1 and small_product_id='5707788643' order by posting_url
			) 
		) where page =1 
		
		
             18 [리뷰] 유피스 일회용젖병 후기 :: 더블하트 호환           http://blog.naver.com/again4820/220575736266
    1 http://blog.naver.com/002jhkjhk/220316107081   흡수력 좋은 기저귀 오보소 플라워 팬티 기저귀로 봄을 맞이해요! 오보소 2015 플라워 4단계 대형 팬티형 38매       흡수력 좋은 기저귀 오보소 플라워 팬티 기저귀로 봄을 맞이해요! [오보소 팬티형 기저귀/ 흡수력 좋은 기저귀/ 오보소 기저귀/ 기저귀 추천] 이제 정말 완연한 봄인것 같아요! 밖에 나가면 꽃들도 많이 피어있고 날씨도 정말 포근하네요. 추웠던 겨울이 지나고 봄이 오듯 우리 아이의 기저귀 컨디션도 꽁꽁 얼어있던 겨울이였던 날들과 달리 오보소 플라워 팬티 기저귀를 사용하고 나서 완연한 봄으로 바뀌었네요. 정말 사용하면서 느낀 점으로는 기존에기저귀를 대량으로 사둔 바람에 밴드형으로 계속사용했었는데 아이가걷고 뛰고 많이 움직이다 보니 연약한 피부에 계속쓸려서 상처가 나서 마음이 아팠는데 강력한 흡수력은 물론 아이의 피부를 부드럽게 감싸주는 오보소 기저귀사용으로 역시 아이가 크면 기저귀 선택의 중요성에 대해 한번더 실감하게 되었어요. 그럼 제가 사용한 오보소 플라워 팬티 기저귀의 제품에 대해서 자세한 설명과 함께 그에 따른 궁금증을 풀어 드리도록 할깨요! ▽▼▽▼▽▼▽▼▽▼ 먼저 배송시의 모습이예요! 육아 용품이 배송되어 올때 이렇게 아이 제품에 대하여 소중히 다루어 달라는 안내 문구가 있으면 잘 만들어서 잘 배송되어 손상없이 전달되기를 바라는 마음이 전달되어서 기분이 좋더라구요. 안내문구 덕분인지 조심히 다뤄져 잘 받았네요. 오보소에서 생산되는 제품들의 라인업을 보니 정말 생각보다 종류도 많고 다양하게 소비자의 구매 욕구에 맞추어서 다양한 라인업으로 구성되어 있더라구요. 끈임없는 제품의 개발과 라인업으로 소비자의 구매 만족도를 높여주는 오보소네요. 더욱이오보소가 2014년 한국 소비자 만족 지수에서 1위를 차지했더라구요. 한국 소비자원 품질 평가에서 흡수력 및 핵심 품질이 뛰어나다는 평가를 받은 오보소! 아직 사용전이라 어떨지 정말 궁금하더라구요. 드디어 모습을 드러낸 오보소 팬티 기저귀! 이름답게 포장지에도 봄을 알리듯 꽃이 한 가득 피어있네요~ 오보소 플라워 팬티형은 걷기 시작하는 아기때부터 잘걷고 활발한 아기까지 10~36개월의 아기가 사용 할 수 있도록 3단계로 나누어서 판매되고 있는데요. 아기의 월령과 체중에 맞게 선택하면 된다고 하네요~ 참고하시라고 개월수와 몸무게에 따른 사이즈 선택표를 적어봤어요. L 대형 : 9~13㎏ : 10~22개월 XL 특대형 : 12~16㎏ : 20~30개월 XXL 점보 : 15 ㎏~ : 24~36개월 제조 날짜와 유통 기한은 앞면에 잘보이는 곳에 배치되어있어서 구입시 꼼꼼히 확인하고 살 수 있구요. 저는 22개월의 아이라 XL 특대형 사이즈로 사용했어요. 대형은 38매, 특대형은 32매 점보형은 26매가 한 팩 구성이랍니다. 픔질 표시란도 꼼꼼히 빠짐사항 없이 잘 기록 되어 있구요. 그리고 사용 상 주의사항도 꼭 읽어 봐야할 항목이죠~ ▽▼▽▼▽▼ 오보소 플라워 기저귀는 남녀 공용으로 사용할 수 있고 오보소 플라워 팬티기저귀의 특징을 잘 알 수 있도록 특징들을 그림과 함께 잘 요약해 두었네요. 팩의 앞쪽에는 이동시에 편하게 들고 다닐수 있도록 손잡이형으로 되어 있어 사용하기 편리하고 절취선이 있어서 깔끔하게 기저귀를 개봉할 수 있어 편했어요! 절취선을 따라 쭉 포장팩을 뜯으면 우리 아이가 사용할 기저귀가 이렇게 한가득 나와요~ 신난다잉~~ㅋㅋ ▽▼▽▼▽▼▽▼▽ 기저귀의 디자인을 그럼 살펴 볼깨요~ 요즘 기저귀도 패션이라고 다들 말하더라구요. 그럼 그 패션을 살펴 봅시다! 기저귀의 앞면의 모습! 그리고 뒷면의 모습이예요! 벨크로의 디자인도 각기 다른 디자인으로 총 12가지 디자인으로 다양하게 만들어서 아이의 인지 발달을 돕는 다채로운 색상과 아이들의 해맑은 웃음을 형상화 한 꽃 디자인으로 우리 아기들이 꽃으로 피어나는 아름다움 교감을 하게 해주는 오보소 플라워~ 예전에 오늘은 멀입지? 했었던 광고가 문득 생각나더라더라구요. 아이의 기분에 맞게 하루 하루 다른 패션으로아이가 입는 즐거움을 선사해 줄 수 있겠어요! 예쁜디자인과 함께 오보소기저귀 팬티형의 특징들도꼼꼼히 알려드려요! 빠른 교체시기를 알려주어서 아이의 기저귀 속사정 쾌적하게 지켜줄 수 있도록 앞뒤로 길게 교체 알림선이 있어서 아기가 소변후 색이 변한것을 보고 바로 바로 갈아 줄 수 있어 편했어요! 그리고 아이가 걷기 시작하면서 기저귀 선택에 있어 항상 주의 깊게 보는 부분중 하나인 신축성! 오보소 팬티 기저귀는 어떨지 한번 늘려 볼깨요!! 혼자서 사진을 찍다보니 느낌이 제대로 안 사는데 정말 양쪽으로 손을 넣어서 쭉 당겨보면 셔링벨트가 부드럽게 쫘악 늘어나더라구요~ 처음엔 기저귀를 봤을때 허리부분이 타이트하지 않을까 했는데 이렇게 부드럽게 쫘악늘어나느것을 보고 "아~ 이게 기술력이구나."하고 하고 실감하게 되었네요! 그리고 아이의 허리부분도 셔링밴드로 부드럽게 전체적으로 아이의 허리를 신축성있게 감싸주어서 쪼이지 않고 또한 부드럽고 통기성이있어서 아이의 피부를 숨쉬게 해주고 부드럽게 감싸주더라구요. 예전에 타사 기저귀를 사용했을땐 신축성이 없어 아이가 움직일때마다 쓸려서 진짜 허리부분에 상처로 그득했었거든요.ㅠㅠ 아이가 걷기 시작하면 정말 많이 움직여서 정신이 없는데요. 그런 아이들의 격한 움직임 하나 하나에도 대소변이 새지 않도록 이중으로 샘방지가 되어 있어서 아이의 많은 움직임에도 사고가 발생하지 않아서 외출시 기저귀가 새어서 난감했었던 일들. 이제는 걱정없겠어요!! 그리고 이중 샘방지의 셔링도 부드럽고 잘 늘어나게 디자인 되어 있어서 아이의 다양한 체형에도 조이지 않고 부드럽게 잘 감싸 주더라구요! 팬티형으로 아이의 기저귀를 교체해 줄 때 절취선을 따라 뜯어서 사용하면 되는데 교체시 절취선을 쉽게 찾을 수 있도록 앞뒤 높낮이에 차이를 두어서 쉽게 찾아서 교환하기가 쉽도록 되어 있더라구요~ 배려가 느껴지네요~ 절취선을 따라 뜯었을때 깔끔하게 절취선을 따라 일자로 뜯어지기 때문에 지저분하지 않고 정리해서 버릴때도 깔금하게 정리된체로 버릴수 있어 좋더라구요. 다른 기저귀와 달리 패드안을 펼쳐보았을때 눈에 띄는것이 있었는데요. 파란 패드가 인상적이였는데 이 패트는 BLUE A.D.L패드로 고가의 첨단소재로 신속한 흡수 역류및 뭉침 방지에 탁월한 기능을 한다고 하더라구요. 그래서 얼마나 흡수하는 지 궁금해서 일 회 소변양과 다량의 소변량을 준비해서 기저귀에 부어 보았어요. 옴마! 그랬더니 200CC는 정말 금방 흡수되어버리고 설마했던 900CC의 물도 언제 넘칠듯 기저귀 가득물을 부었는지 모르게 흡수되어 버렸어요. 200CC의 경우 물을 부었을때 7초정도 만에 홀안으로 물이 모두 흡수되어 바깥으로 물이 보이지 않는 것이 눈에 보이고 휴지로 초가 조금지나 미용티슈로 꾹꾹눌려서 베어나옴을 확인했더니 전혀 베어나오는거시 없었어요. 그리고 900CC의 경우에는 3분정도가 지나자 완벽하게 바깥 기저귀에서 물이 안쪽으로 다 스며들어서 위층의 물을 다 흡수한 상태가 되더라구요.. 신기 방기.. 흡수한 물의 양을 체크하기 위해 무게로 달라진 기저귀의 양을 체크해 보았어요~ 저울이 작아 물을 많이 흡수한 기저귀의 무게가 정확히 측정 되지 않은듯 ::하네요. 요래 요래 부운 물을 모두 흡수한 오보소 기저귀! 실험후 기저귀가 과연 뭉치지 않고 잘 흡수했는지 궁금해서 단면을 잘라보았어요! 대박!!! 두깨의 차이가 느껴지시나요? 오랜 기간 유아용 기저귀를 생산해 온 노하우를 통해 펄프와 흡수제를 가장 이상적인 배합비를 통해서 놀라운 흡수력을 자랑하게 되었다고 해요. 아이가 깊은잠을 잘때면 기저귀를 갈아주지 못해서 오랫동안 기저귀를 갈아주지 못해 찝찝했는데 오보소 기저귀라면 아이가 잘때에도 밤새 소변이 잘 흡수되어서 오랜시간동안에도아이가 편안하게 숙면을 취할수 있겠어요! 외출시 엉덩이 부분에 기저귀를 찬 형태가 드러나면 멋스럽지 않잖아요! 얇은 두깨로 아이의 엉덩이 라인을 살려주는 선사해주는 오보소 플라워 팬티 기저귀의 핏을 공개할깨요! 이렇게 우리 아이의 엉덩이에도 봄이 왔을을 알리는 꽃이 한가득 피어 있네요~ 쩍벌다리를 해도 부드럽게 셔링된 이중 샘방지로 아이의 다리를 전체적으로 부드럽게 감싸주고 새지않도록 해주니까 아이의 다양한 표지션에도 샐 걱정없어요! 앞 뒤 높이차가 있어 절취선을 찾기 쉬워서 도망 다니는 아이를 잡고 빠르게 기저귀를 교체해 줄 수 있어서 넘 편하더라구요. 그리고 아이의 허리부분과 배부분을 부드럽고 신축성있게 감싸주어서 팬티 기저귀가 흘러내리지 않아서 좋았구요! 또 밥을 엄청 많이 먹어 배가 불렸을때도 신축성있게 늘어나 쪼이지 않도록 부드러운 착용감을 선사해 주어서 아이가 불편해 하지 않터라구요. 정말 편안해 보이지 않나요?ㅎㅎ 이렇게 마음껏 움직여도 전혀 불편감이 없어요! 열심히 스티커 놀이도 하구요. 아빠가 출장 기념으로 사주신 레고도 맘껏 가지고 놀고 있어요. 그리고 간식을 먹을 때도 오보소 기저귀와 함께 하고 있네요. 사용후 정리 할때도 뒷정리 데이프로 돌돌말아서 정리해주니 부피감도 줄고 냄새도 나지 않아 정말 만족스러워요! 24시간 아이와 한 몸이 되어 아이의 엉덩이 건강을 빠른 흡수력으로 늘 뽀송하게 만들어주는 오보소 기저귀! 아이 몸에 뚜껍지 않게 엉덩이라인과 맞게 예쁘게 밀착되어서 바지를 입었을때도 기저귀라인으로 엉덩이가 두껍게 튀어나오지 않아서 아이의 엉덩이 라인을 살린 핏으로 외출시에도 자신감이 업업! 우리 아이에게도 불어온 봄! 오보소 플라워 팬티기저귀 덕분에 아이의 엉덩이에도 봄이 왔네요! 흡수력은 기본에 편안감과 감각있는 디자인으로 우리 아이의 기저귀 역사에 봄을 가져다 주신 오보소에게 감사하네요! 오보소 팬티형 기저귀 ! 오보소 플라워 팬티 기저귀 사용해 보니 정말 만족스러워요! ▽▼▽ 7906428056
