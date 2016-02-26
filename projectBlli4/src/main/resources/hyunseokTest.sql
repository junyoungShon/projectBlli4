drop table blli_permanent_dead_posting cascade constraint;
CREATE TABLE blli_permanent_dead_posting (
	posting_url     VARCHAR2(300) NOT NULL,
	posting_title   VARCHAR2(450) NOT NULL,
	constraint pk_permanent_dead_posting primary key(posting_url, posting_title)
);

select * from blli_small_product;

select count(*) from blli_small_product;

select count(*) from blli_small_product where small_product_status = 'dead';

select count(*) from blli_small_product where small_product_status = 'unconfirmed';

select count(*) from blli_small_product group by mid_category;

select * from blli_small_product where mid_category = '캐릭터/패션인형' and small_product_status = 'dead';

select * from blli_small_product where mid_category = '캐릭터/패션인형' and small_product_status = 'unconfirmed';

select count(*) from blli_small_product where mid_category = '캐릭터/패션인형';

select count(*) from blli_small_product where small_product_status = 'confirmedbyadmin';

select * from blli_small_prod_buy_link;

select posting_url, posting_title, posting_content, small_product, small_product_id from(
	select ceil(rownum/5) as page, posting_url, posting_title, posting_content, small_product, small_product_id from(
		select count(*) over (partition by posting_url) as count_posting_url, posting_url, posting_title, 
		posting_content, small_product, small_product_id from blli_posting where posting_status = 'unconfirmed' and small_product like '%' || '위드맘' || '%' order by small_product asc
	) where count_posting_url = 1
) where page = '1'

select small_product_id from blli_small_product where small_product like '%' || '위드맘' || '%' and small_product_status = 'confirmed';

select posting_url, posting_title, posting_content, small_product, small_product_id from(
	select ceil(rownum/5) as page, posting_url, posting_title, posting_content, small_product, small_product_id from(
		select count(*) over (partition by posting_url) as count_posting_url, posting_url, posting_title, 
		posting_content, small_product, small_product_id from blli_posting where posting_status = 'unconfirmed' and small_product_id = '6507320795' order by small_product asc
	) where count_posting_url = 1
) where page = '1'

select * from blli_posting where small_product = '아이배냇 베베레시피 당근 단호박 시금치 20g';

update blli_posting set posting_status = 'unconfirmed' where posting_status = 'confirmed' and posting_photo_link like '%' || 'blogthumb' || '%';

select small_product_id from blli_member_dibs where member_id = 'gonipal@naver.com';

select small_product_id from blli_small_product where small_product_status = 'confirmedbyadmin';
select small_product_id from blli_small_product where small_product_status = 'confirmedbyadmin' and mid_category = '수입기저귀';

select * from blli_small_product where small_product_status = 'confirmed';

select * from blli_small_product where small_product_id = '6733513412';

select * from blli_small_product where small_product  = '똘똘이 옹알이아기';

update blli_posting set posting_status = 'unconfirmed' where posting_status = 'confirmed';

update blli_small_product set small_product_status = 'unconfirmed' where small_product_status = 'confirmed' or small_product_status = 'confirmedbyadmin';

update blli_small_product set db_insert_posting_count = 0;

update blli_posting set posting_status = 'unconfirmed' where posting_status = 'dead';

select * from blli_mid_category;

select * from blli_member;

select count(*) from blli_small_product where small_product_status = 'confirmedbyadmin' or small_product_status = 'confirmed';
select count(*) from blli_small_product where small_product_status = 'confirmedbyadmin';
select count(*) from blli_small_product where small_product_status = 'confirmed';

select count(*) from blli_posting where posting_status = 'unconfirmed';

delete from blli_member where member_id = 'rhslvkf@gmail.com';

update blli_member set authority = 'ROLE_ADMIN' where member_id = 'gonipal@naver.com';
update blli_member set authority = 'ROLE_USER' where member_id = 'gonipal@naver.com';
select * from blli_baby where member_id = 'rhslvkf@gmail.com';

select mid_category_id, min(small_product_whentouse_min), max(small_product_whentouse_max) from blli_small_product where small_product_status = 'confirmed' group by mid_category_id;

select * from blli_member where member_id = 'gonipal@naver.com';

select * from blli_big_category;

select * from(
	select ceil(rownum/10) as page, bl.small_product_id, bl.min_price, sp.small_product, sp.small_product_main_photo_link, sp.small_product_ranking,
	sp.small_product_whentouse_min, sp.small_product_whentouse_max, sp.db_insert_posting_count, sp.small_product_score,sp.small_product_dibs_count from(
		select b.small_product_id, min(b.buy_link_price) as min_price from (
			select bsp.small_product_id from (
				select mid_category_id from blli_mid_category where big_category like '%' || '분유' || '%'
			)bmc, blli_small_product bsp where bmc.mid_category_id = bsp.mid_category_id and bsp.small_product_status = 'confirmed'
		)s, blli_small_prod_buy_link b where s.small_product_id = b.small_product_id  group by b.small_product_id
	)bl, blli_small_product sp where bl.small_product_id = sp.small_product_id order by sp.small_product_score desc
) where page = '1'

select * from(
	select ceil(rownum/10) as page, bl.small_product_id, bl.min_price, sp.small_product, sp.small_product_main_photo_link, sp.small_product_ranking,
	sp.small_product_whentouse_min, sp.small_product_whentouse_max, sp.db_insert_posting_count, sp.small_product_score,sp.small_product_dibs_count from(
		select b.small_product_id, min(b.buy_link_price) as min_price from (
			select mid_category_id from blli_mid_category where big_category like '%' || #{searchWord} || '%'
		)s, blli_small_prod_buy_link b where s.small_product_id = b.small_product_id  group by b.small_product_id
	)bl, blli_small_product sp where bl.small_product_id = sp.small_product_id order by sp.small_product_score desc
) where page = '1';

select bsp.small_product_id from (
	select mid_category_id from blli_mid_category where big_category like '%' || '분유' || '%'
)bmc, blli_small_product bsp where bmc.mid_category_id = bsp.mid_category_id and bsp.small_product_status = 'confirmed'

select * from blli_big_category;

select ceil(count(*)/10) from blli_small_product where mid_category = #{searchWord} and small_product_status = 'confirmed'

select ceil(count(*)/10) from(
	select mid_category_id from blli_mid_category where big_category = #{searchWord}
)bmc, blli_small_product bsp where bmc.mid_category_id = bsp.mid_category_id and small_product_status = 'confirmed';

select ceil(count(*)/10) from(
	select mid_category_id from blli_mid_category where big_category like '%' || '' || '%'
)bmc, blli_small_product bsp where bmc.mid_category_id = bsp.mid_category_id and bsp.small_product_status = 'confirmed';

select * from blli_small_product where small_product_status = 'confirmed';

select * from blli_posting where posting_content like '%' || '분유' || '%';

select * from(
			select ceil(rownum/5) as page, bl.small_product_id, bl.min_price, sp.small_product, sp.small_product_main_photo_link, sp.small_product_ranking,
			sp.small_product_whentouse_min, sp.small_product_whentouse_max, sp.db_insert_posting_count, sp.small_product_score,sp.small_product_dibs_count from(
				select b.small_product_id, min(b.buy_link_price) as min_price from (
					select bsp.small_product_id from (
						select mid_category_id from blli_mid_category where big_category like '%' || '' || '%'
			)bmc, blli_small_product bsp where bmc.mid_category_id = bsp.mid_category_id and bsp.small_product_status = 'confirmed'
		)s, blli_small_prod_buy_link b where s.small_product_id = b.small_product_id  group by b.small_product_id
	)bl, blli_small_product sp where bl.small_product_id = sp.small_product_id order by sp.small_product_score desc
) where page = '1' order by small_product_id

select small_product_id, posting_url, posting_title, posting_content, posting_score, posting_like_count, posting_dislike_count, posting_photo_link, posting_author, posting_date, posting_rank from(
	select ceil(rownum/5) as page, small_product_id, posting_url, posting_title, posting_content, posting_score, posting_like_count, posting_dislike_count, posting_photo_link, posting_author, posting_date, posting_rank from(
		select bp.small_product_id, bp.posting_url, bp.posting_title, bp.posting_content, bp.posting_score, bp.posting_like_count, bp.posting_dislike_count, bp.posting_photo_link, bp.posting_author, bp.posting_date, bp.posting_rank from(
			select small_product_id, posting_url, posting_title, posting_content, posting_score, posting_like_count, posting_dislike_count, posting_photo_link, posting_author, posting_date, posting_rank
			from blli_posting where posting_title like '%' || '리틀미미' || '%' or posting_content like '%' || '리틀미미' || '%' and posting_status = 'confirmed' order by posting_score desc
		)bp, blli_small_product bsp where bp.small_product_id = bsp.small_product_id and bsp.small_product_status = 'confirmed' order by posting_url desc
	)
) where page = '17'

select count(*) from(
	select small_product_id from blli_posting 
	where posting_title like '%' || '리틀미미' || '%' or posting_content like '%' || '리틀미미' || '%' and posting_status = 'confirmed'
)bp, blli_small_product bsp where bp.small_product_id = bsp.small_product_id and bsp.small_product_status = 'confirmed'

select register_day from blli_small_product;