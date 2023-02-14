--zadaca 1
set schema 'public';
create table doktorispit
(
    broj_pecat   int primary key,
    ime_i_prezime varchar(250) not null,
    id            int         not null,
    foreign key (id) references specijalizacijaispit (id)
);

insert into doktorispit(broj_pecat, ime_i_prezime, id) VALUES
(10,'ivana a',1),
(20,'ivona a',2),
(30,'natasa a',3);
select * from doktorispit;

create table specijalizacijaispit
(
    id         int primary key,
    naziv      varchar(250) not null
);

insert into specijalizacijaispit(id, naziv) VALUES
(1,'kardio'),
(2,'nervno'),
(3,'gastro');

select * from specijalizacijaispit;

create table klinikaispit
(
    id              int primary key,
    ime_klinika     varchar(250) not null unique
);

insert into klinikaispit(id,ime_klinika)values
                                            (1,'drzavna klinika'),
                                            (2,'osmi septemvri'),
                                            (3,'sistina');
select * from klinikaispit;

create table telefonski_brojispit
(
    telefonski_broj char not null,
    id              int not null,
    ime_klinika varchar(250) not null ,
    foreign key (id) references klinikaispit (id)
);
insert into telefonski_brojispit(telefonski_broj, id, ime_klinika) values
('1',1,'drzavna klinika'),
('4',2,'osmi septemvri'),
('7',3,'sistina');
select * from telefonski_brojispit;

-- alter table klinika
-- add constraint unikatno_ime unique (ime_klinika);

create table oddelispit
(
    id_oddel     int primary key,
    specijalnost varchar(250) not null,
    id           int         not null,
    foreign key (id) references klinikaispit (id)
);

insert into oddelispit (id_oddel, specijalnost, id)
values (1,'srce',1),
       (2,'srce2',2),
       (3,'srce3',3);

select * from oddelispit;

create table doktor_raboti_vo_oddelispit
(
    broj_pecat        int not null,
    id_oddel          int not null,
    primary key (broj_pecat, id_oddel),
    vraboten_od_datum date not null,
    vraboten_do_datum date
);

insert into doktor_raboti_vo_oddelispit(broj_pecat, id_oddel, vraboten_od_datum, vraboten_do_datum) VALUES
 (100,1,'2020-10-10',null);

insert into doktor_raboti_vo_oddelispit(broj_pecat, id_oddel, vraboten_od_datum, vraboten_do_datum) VALUES
 (200,2,'2020-10-11','2022-10-10'),
 (300,2,'2018-10-11',null);


select * from doktor_raboti_vo_oddelispit;



--vtora zadaca
-- Да се прикажат сите градови чии имиња завршуваат на „а“ заедно со
-- клиентите кои се од тој град. Треба да се излистаат и градовите во кои немаме клиенти.
-- Резултат: (id_grad, ime_grad, embg, ime, prezime, adresa_ziveenje)

set schema 'banka';

--gradot da zavrsuva na a
select *
from grad
where ime_grad ilike '%a';

select *
from chovek;
select *
from klient;

select g.id_grad         as id_grad,
       g.ime_grad        as ime_grad,
       k.embg_klient     as embg,
       c.ime             as ime,
       c.prezime         as prezime,
       k.adresa_ziveenje as adresa_ziveenje
from grad as g
         left join klient k on g.id_grad = k.id_grad
         left join chovek c on k.embg_klient = c.embg
where ime_grad ilike '%a';


--treta zadaca
-- Да се прикаже вкупната сума на сите трансакции извршени во
-- последните 70 дена, во секоја валута посебно.
-- Резултат: (valuta, vkupno)
select *from transakcija;

select valuta as valuta, sum(suma) as vkupno
from transakcija
where vreme_izvrsuvanje between now() - interval '70 days' and now()
group by valuta;

--cetvrta zadaca
-- Да се излистаат сите клиенти и бројот на отворени сметки за секој од
-- нив. Доколку клиентот нема отворена сметка, да се прикаже 0.
-- Резултат: (embg, ime, prezime, adresa_ziveenje, broj_smetki)
select * from smetka; --broj smetka --embg klient
select * from klient; --embg klient
select k.embg_klient as embg,
       c.ime as ime,
       c.prezime as prezime,
       k.adresa_ziveenje as adresa_ziveenje,
       count(broj_smetka) as broj_smetki from smetka as s
left join klient k on s.embg_klient = k.embg_klient
left join chovek c on k.embg_klient = c.embg
group by 1,2,3,4;

--petta zadaca
-- Да се излистаат сите шефови, на вработени кои работат во филијала во Битола.
-- Резултат: (embg, ime, prezime)

select * from vraboten; --embg datum_vrabotuvanje id_dogovor id_filijala rbaotno_mesto
select * from filijala; --id filijala adresa filijala id grad
--c.embg as embg, c.ime as ime, c.prezime as prezime

select c.embg,c.ime,c.prezime from vraboten v
join filijala f on f.id_filijala = v.id_filijala
join grad g on f.id_grad = g.id_grad
join chovek c on c.embg = v.embg_shef
where g.ime_grad ilike 'Bitola' or g.ime_grad ilike 'Битола';


--sesta zadaca
-- Да се пресмета промена на салдото на секоја сметка посебно, во секој
-- месец во кој имало барем една трансакција. Промена на салдото е вкупна сума на приливи
-- минус вкупна сума на одливи
-- Резултат: (broj_smetka, godina, mesec, promena)
