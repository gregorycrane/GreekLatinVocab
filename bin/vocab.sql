create table vocab (
  	word varchar(30) not null,
	lemma varchar(30),
	list_id varchar(10) not null,
	list_order int not null,
	gloss varchar(150),
	index vocab_list_id_order(list_id, list_order)
);

create table vocab_list_section (
	list_id varchar(10) not null,
	list_order int not null,
	section_title varchar(100) not null
);

create table vocab_list (
  	list_id varchar(10) not null primary key,
  	list_author varchar(150),
	list_title varchar(150),
	list_nickname varchar(150) not null,
	list_year varchar(4) not null,
	lang varchar(10) not null
);
