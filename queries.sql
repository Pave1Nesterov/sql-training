--1
SELECT * FROM mechanic;
--2
SELECT gnz, ser$reg_certif, num$reg_certif, date$reg_certif
FROM vehicle;
--3
SELECT DISTINCT gnz FROM maintenance;
--4
SELECT gnz                                                               AS "Государственный номерной знак",
       concat(ser$reg_certif, ' ', num$reg_certif, ' ', date$reg_certif) AS "Свидетельство о регистрации транспортного средства"
FROM vehicle;
--5
SELECT factory_name, legal_addr, phone
FROM factory
ORDER BY factory_name;
--6
SELECT (concat(id_tg, ': ', name, ' - ', note)) AS "Группы транспортных средств"
FROM transpgroup;
--7
SELECT gnz, cost, cost * 0.2
FROM vehicle;
--8
SELECT SUM(cost)::money
FROM vehicle;
--9
SELECT (concat(sname_initials, ', дата рождения ', to_char(born, 'dd.mm.yyyy'))) AS "Лучшие механики предприятия"
FROM mechanic
LIMIT 5;
--10
SELECT sname_initials, to_char(born, 'dd.mm.yyyy'), EXTRACT(YEAR FROM age(born))
FROM mechanic;
--11
SELECT concat(gnz, ' - ', trunc(cost / run, 2), ' руб/км')
FROM vehicle;
--12
SELECT gnz, to_char(date_work, 'dd.mm.yyyy'), to_char(date_work, 'hh.mi.ss')
FROM maintenance;
--13
SELECT gnz, date_use, cost - cost * 0.07 * date_part('year', age(date_use))
FROM vehicle;
--14
SELECT concat(to_char(date_made, 'Day'), ' ', to_char(date_made, 'DDD')) AS "День недели и день года выпуска"
FROM vehicle;
--15
SELECT factory_name, legal_addr, phone
FROM factory
WHERE post_addr = legal_addr
  AND legal_addr LIKE '%Россия%';
--16
SELECT sname_initials, certif_date, work_in_date, date_part('year', age(work_in_date))
FROM mechanic
WHERE date_part('year', age(certif_date)) >= 13
ORDER BY date_part('year', age(certif_date));
--17
SELECT gnz, cost * 0.2, date$reg_certif
FROM vehicle
WHERE cost * 0.2 > 600000;
--18
SELECT gnz, ser$reg_certif, num$reg_certif, date$reg_certif
FROM vehicle
WHERE gnz LIKE '%57 '
ORDER BY right(gnz, 2) DESC;
--19
SELECT gnz, date_work, to_char(date_work, 'Day'), tech_cond_resume
FROM maintenance
WHERE to_char(date_work, 'Day') LIKE 'S%';
--20
SELECT gnz, date_work, to_char(date_work, 'Day'), tech_cond_resume
FROM maintenance
WHERE to_char(date_work, 'Day') IN ('Saturday ', 'Sunday   ')
  AND tech_cond_resume IS NULL;
--21
SELECT model_name
FROM model
WHERE model_name LIKE '___-____';
--22
SELECT sname_initials
FROM mechanic
WHERE sname_initials LIKE ANY (array ['А%', 'Ч%', 'Г%'])
ORDER BY sname_initials;
--23
SELECT factory_name, post_addr, legal_addr, phone
FROM factory
WHERE factory_name LIKE '%!_%' ESCAPE '!' OR post_addr LIKE '%!_%' ESCAPE '!' OR legal_addr LIKE '%!_%' ESCAPE '!';
--24
SELECT to_char(date_work, 'dd.mm.yyyy')
FROM maintenance
WHERE gnz = 'c910ca57'
ORDER BY date_work DESC
LIMIT 1;
--25
SELECT DISTINCT gnz
FROM maintenance
WHERE date_part('year', date_work) = 2018;
--26
SELECT s$diag_chart, n$diag_chart, date_work
FROM maintenance
WHERE s$diag_chart ~ '^[0-9]{4}';
--27
SELECT concat(s$diag_chart, ' ', n$diag_chart)
FROM maintenance
WHERE date_part('year', date_work) = 2019
  AND lower(s$diag_chart) LIKE lower('%ТО%');
--28
SELECT s$diag_chart, n$diag_chart, date_work::DATE, tech_cond_resume
FROM maintenance
WHERE date_part('day', date_work + INTERVAL '1 day') = '01';
--29
SELECT gnz, date_made, date_use, ser$reg_certif, num$reg_certif, date$reg_certif
FROM vehicle
WHERE gnz NOT LIKE '%57 '
ORDER BY date_use;
--30
SELECT row_number() OVER () AS "numrow", gnz
FROM vehicle;
--31
SELECT name AS "Производитель", factory_name AS "Завод"
FROM brand
         JOIN factory ON factory.idb = brand.idb
ORDER BY name;
--32
SELECT vehicle.gnz AS "Государственный номерной знак",
       concat_ws(', ', brand.name, marka.name, model_name) AS "Автомобиль"
FROM vehicle
         JOIN brand ON vehicle.idb = brand.idb
         JOIN model ON vehicle.idmo = model.idmo
         JOIN marka ON model.idm = marka.idm;
--33
SELECT gnz, brand.name, factory.phone
FROM vehicle
         JOIN brand ON vehicle.idb = brand.idb
         JOIN factory ON vehicle.idf = factory.idf;
--34
SELECT to_char(date_work, 'dd.mm.yyyy'), sname_initials
FROM maintenance
         JOIN mechanic ON maintenance.id_mech = mechanic.id_mech
WHERE gnz = 'o009oo57'
ORDER BY date_work;
--35
SELECT concat_ws(' ', brand.name, marka.name, model.model_name), gnz
FROM vehicle
         JOIN factory ON vehicle.idf = factory.idf
         JOIN brand ON factory.idb = brand.idb
         JOIN model ON vehicle.idmo = model.idmo
         JOIN marka ON model.idm = marka.idm
WHERE factory.legal_addr LIKE '%Japan%';
--36
SELECT to_char(v1.date_made, 'dd.mm.yyyy')                                                             AS "Дата изготовления",
       v1.gnz,
       concat_ws(' ', v1.ser$reg_certif, v1.num$reg_certif, to_char(v1.date$reg_certif, 'dd.mm.yyyy')) AS "old",
       v2.gnz,
       concat_ws(' ', v2.ser$reg_certif, v2.num$reg_certif, to_char(v2.date$reg_certif, 'dd.mm.yyyy')) AS "new"
FROM vehicle AS v1
         JOIN vehicle AS v2 ON v1.date_made = v2.date_made AND v1.idb = v2.idb AND v1.idm = v2.idm
    AND v1.idmo = v2.idmo AND v1.gnz != v2.gnz AND v1.date$reg_certif < v2.date$reg_certif
    AND concat_ws(' ', v1.ser$reg_certif, v1.num$reg_certif, to_char(v1.date$reg_certif, 'dd.mm.yyyy')) !=
        concat_ws(' ', v2.ser$reg_certif, v2.num$reg_certif, to_char(v2.date$reg_certif, 'dd.mm.yyyy'));
--37
SELECT sname_initials, gnz, date_work
FROM maintenance
         LEFT JOIN mechanic ON maintenance.id_mech = mechanic.id_mech;
--38
SELECT brand.name, factory_name, date_work::DATE, tech_cond_resume
FROM maintenance
         JOIN brand ON maintenance.idb = brand.idb
         JOIN factory ON maintenance.idf = factory.idf
WHERE brand.name = 'BMW'
ORDER BY date_work;
--39
SELECT f1.factory_name, f1.post_addr, f1.legal_addr, f1.phone
FROM factory AS f1
         JOIN factory AS f2 ON f1.legal_addr = f2.legal_addr
WHERE f1.factory_name LIKE '%ОАО АВТОВАЗ';
--40
SELECT mtc2.gnz, to_char(mtc2.date_work, 'dd.mm.yyyy'), to_char(mtc2.date_work, 'HH24:MI')
FROM maintenance AS mtc1
         JOIN mechanic AS m ON mtc1.id_mech = m.id_mech
         JOIN maintenance AS mtc2 ON mtc2.id_mech = m.id_mech
WHERE mtc1.gnz = 'o929ao57';
--41
SELECT v2.gnz, b.name, v2.date_use
FROM vehicle AS v1,
     vehicle AS v2,
     brand AS b
WHERE v1.gnz = 'c172ac57'
  AND v1.ser$reg_certif = v2.ser$reg_certif
  AND v1.idb = b.idb
  AND v2.idb = b.idb
  AND v1.gnz != v2.gnz;
--42
SELECT gnz
FROM vehicle
WHERE gnz NOT IN (SELECT DISTINCT gnz FROM maintenance);
--43
SELECT gnz, cost
FROM vehicle
WHERE cost < (SELECT AVG(cost) FROM vehicle);
--44
SELECT gnz
FROM vehicle
WHERE to_char(date_use, 'mm.yyyy') != to_char(date$reg_certif, 'mm.yyyy');
--45
SELECT v.gnz, factory_name, post_addr, phone
FROM vehicle AS v
         JOIN factory AS f ON v.idf = f.idf
WHERE v.idf IN (SELECT idf FROM vehicle WHERE gnz = 'x027kp57')
  AND gnz != 'x027kp57';
--46
SELECT b.name, s.name
FROM brand AS b
         JOIN state AS s ON b.st_id = s.st_id
WHERE idb IN (SELECT idb FROM factory WHERE legal_addr NOT LIKE '%Россия%');
--47
SELECT b.name, f.factory_name, f.legal_addr
FROM factory AS f
         JOIN brand AS b ON f.idb = b.idb
WHERE b.idb IN (SELECT idb
                FROM factory
                WHERE legal_addr LIKE '%Россия%'
                INTERSECT
                SELECT idb
                FROM factory
                WHERE legal_addr NOT LIKE '%Россия%');
--48
SELECT v.gnz,
       concat_ws(',', b.name, mrk.name, mo.model_name),
       v.date_made,
       f.factory_name,
       f.post_addr,
       date_work,
       concat_ws(' ', s$diag_chart, n$diag_chart),
       tech_cond_resume
FROM maintenance AS m
         JOIN vehicle AS v ON m.gnz = v.gnz
         JOIN factory AS f ON v.idf = f.idf
         JOIN brand AS b ON v.idb = b.idb
         JOIN model AS mo ON v.idmo = mo.idmo
         JOIN marka AS mrk ON mo.idm = mrk.idm
WHERE v.gnz = 'a723ak57'
  AND to_char(date_work, 'dd.mm.yyyy') = '06.11.2018';
--49
SELECT DISTINCT (SELECT COUNT(*)
                 FROM maintenance AS m
                          JOIN maintenancetype mt on m.mt_id = mt.mt_id
                 WHERE name LIKE '%ТО%')                       AS "Техническое обслуживание",
                (SELECT COUNT(*)
                 FROM maintenance AS m
                          JOIN maintenancetype mt on m.mt_id = mt.mt_id
                 WHERE name LIKE '%Ремонт%')                   AS "Ремонт",
                (SELECT COUNT(*)
                 FROM maintenance AS m
                          JOIN maintenancetype mt on m.mt_id = mt.mt_id
                 WHERE name LIKE '%Предпродажная подготовка%') AS "Предпродажная подготовка"
FROM maintenance;
--50
SELECT DISTINCT sname_initials
FROM mechanic
         JOIN maintenance AS m1 ON m1.id_mech = mechanic.id_mech
WHERE m1.id_mech IN (SELECT id_mech
                     FROM maintenance AS m2
                     WHERE m1.date_work::DATE = m2.date_work::DATE
                       AND m1.date_work != m2.date_work);
--51
SELECT gnz, date_made, run, date_part('year', age(date_made)), f.legal_addr
FROM vehicle AS v
         JOIN factory AS f ON v.idf = f.idf
WHERE date_part('year', age(date_made)) >= 30 AND f.legal_addr LIKE '%Россия%'
   OR date_part('year', age(date_made)) >= 25 AND f.legal_addr NOT LIKE '%Россия%'
   OR run >= 500000;
--52
SELECT DISTINCT gnz
FROM maintenance
WHERE gnz NOT IN (SELECT gnz
                  FROM maintenance
                  WHERE to_char(date_work, 'Day') NOT LIKE 'F%');
--53
SELECT gnz
FROM maintenance AS mtc1
         JOIN mechanic AS m1 ON mtc1.id_mech = m1.id_mech
         JOIN maintenancetype AS mtt1 ON mtc1.mt_id = mtt1.mt_id
WHERE sname_initials = 'Баженов М.К.'
  AND mtt1.name LIKE '%ТО%'
INTERSECT
SELECT gnz
FROM maintenance AS mtc2
         JOIN mechanic AS m2 ON mtc2.id_mech = m2.id_mech
         JOIN maintenancetype AS mtt2 ON mtc2.mt_id = mtt2.mt_id
WHERE sname_initials = 'Савостьянов А.В.'
  AND mtt2.name LIKE '%Ремонт%';
--54
SELECT sname_initials
FROM mechanic
         JOIN maintenance ON maintenance.id_mech = mechanic.id_mech
WHERE date_part('year', date_work) = '2018'
GROUP BY sname_initials
HAVING COUNT(DISTINCT to_char(date_work, 'mm.yyyy')) >= 12;
--55
SELECT gnz, to_char(date_work, 'dd.mm.yyyy'), tech_cond_resume
FROM maintenance
WHERE gnz NOT IN (SELECT DISTINCT gnz
                  FROM maintenance
                  WHERE date_part('year', date_work) != 2018);
--56
SELECT DISTINCT to_char(date, 'dd.mm')
FROM generate_series('2018-02-01', '2018-02-28', interval '1 DAY') AS date
WHERE to_char(date, 'dd.mm.yyyy') NOT IN (SELECT to_char(date_work, 'dd.mm.yyyy') FROM maintenance)
  AND to_char(date, 'dd.mm.yyyy') != '23.02.2018' AND to_char(date, 'Day') NOT LIKE 'S%';
--57
SELECT COUNT(*)
FROM maintenance
WHERE date_part('year', date_work) = '2017';
--58
SELECT concat(trunc(SUM(cost) * 0.18), ' руб. ', trunc(mod(SUM(cost * 0.18), 1) * 100), ' коп.')
FROM vehicle
WHERE date_part('year', date$reg_certif) = '2016';
--59
SELECT COUNT(*)
FROM vehicle
WHERE gnz LIKE '%57%';
--60
SELECT trunc(AVG(date_part('year', age(born)))::numeric, 2)
FROM mechanic;
--61
SELECT trunc(SUM(cost), 2) AS "Общая стоимость",
       trunc(AVG(cost), 2) AS "Средняя стоимость",
       trunc(SUM(run), 1)  AS "Общий пробег",
       trunc(AVG(run), 1)  AS "Средний пробег"
FROM vehicle;
--62
SELECT brand.name, trunc(AVG(run), 2)
FROM brand
         JOIN vehicle ON vehicle.idb = brand.idb
GROUP BY brand.name;
--63
SELECT brand.name, marka.name, trunc(AVG(vehicle.cost), 2)
FROM vehicle
         JOIN brand ON brand.idb = vehicle.idb
         JOIN marka ON vehicle.idm = marka.idm
GROUP BY brand.name, marka.name;
--64
SELECT marka.name, trunc(AVG(date_part('year', age(date_made)))::numeric, 2)
FROM marka
         JOIN model ON marka.idm = model.idm
         JOIN vehicle ON model.idmo = vehicle.idmo
WHERE marka.name IS NOT NULL
GROUP BY marka.name
UNION
SELECT model_name, trunc(AVG(date_part('year', age(date_made)))::numeric, 2)
FROM marka
         JOIN model ON marka.idm = model.idm
         JOIN vehicle ON model.idmo = vehicle.idmo
WHERE marka.name IS NULL
GROUP BY model_name;
--65
SELECT "Год"
FROM (SELECT date_part('year', date_work) AS "Год", COUNT(*)
      FROM maintenance
      GROUP BY date_part('year', date_work)
      ORDER BY COUNT(*) DESC
      LIMIT 1) AS "t1";
--66
SELECT concat(brand.name, ' ', marka.name, ' (', COUNT(*), ')')
FROM vehicle
         JOIN marka ON vehicle.idm = marka.idm
         JOIN brand ON vehicle.idb = brand.idb
GROUP BY brand.name, marka.name
HAVING COUNT(*) >= 8
ORDER BY COUNT(*) DESC;
--67
SELECT gnz
FROM (SELECT gnz, COUNT(*)
      FROM maintenance
      GROUP BY gnz
      HAVING COUNT(*) = 1) AS "t1";
--68
SELECT gnz, state.name, factory_name, legal_addr, phone
FROM vehicle
         JOIN factory ON vehicle.idf = factory.idf
         JOIN state ON vehicle.st_id = state.st_id
WHERE euro_union = '1';
--69
SELECT gnz, to_char(date_work, 'dd.mm.yyyy'), sname_initials
FROM maintenance
         JOIN mechanic ON maintenance.id_mech = mechanic.id_mech
         JOIN maintenancetype ON maintenance.mt_id = maintenancetype.mt_id
WHERE maintenancetype.name = 'Предпродажная подготовка';
--70
SELECT name
FROM (SELECT brand.name, SUM(cost)
      FROM vehicle
               JOIN brand ON vehicle.idb = brand.idb
      GROUP BY brand.name
      ORDER BY SUM(cost) DESC
      LIMIT 1) AS "t1";
--71
SELECT COUNT(*)
FROM maintenance
         JOIN mechanic ON maintenance.id_mech = mechanic.id_mech
         JOIN transpgroup ON maintenance.id_tg = transpgroup.id_tg
WHERE sname_initials LIKE 'Кротов К.О.%'
  AND transpgroup.name LIKE 'Автобус%';
--72
SELECT concat(gnz, ' ', brand.name, ' ', marka.name, ' ', model.model_name, ' Свидетельство о регистрации ',
              ser$reg_certif, ' №', num$reg_certif, ' выдано: ', date$reg_certif),
       date_use
FROM vehicle
         JOIN brand ON vehicle.idb = brand.idb
         JOIN model ON vehicle.idmo = model.idmo
         JOIN marka ON vehicle.idm = marka.idm
WHERE date$reg_certif - date_use > 14;
--73
SELECT brand.name, factory_name, factory.legal_addr, factory.phone
FROM factory
         JOIN brand ON factory.idb = brand.idb
         JOIN state ON brand.st_id = state.st_id
WHERE factory.legal_addr LIKE '%Россия%'
  AND euro_union IS NULL
UNION
SELECT brand.name, factory_name, factory.post_addr, factory.phone
FROM factory
         JOIN brand ON factory.idb = brand.idb
         JOIN state ON brand.st_id = state.st_id
WHERE factory.legal_addr LIKE '%Россия%'
  AND euro_union = '1';
--74
SELECT brand.name, COUNT(*)
FROM maintenance
    JOIN brand ON maintenance.idb = brand.idb
    JOIN maintenancetype ON maintenance.mt_id = maintenancetype.mt_id
WHERE date_part('year', date_work) = '2018' AND maintenancetype.name = 'Ремонт'
GROUP BY brand.name
ORDER BY COUNT(*)
LIMIT 1;
--75
SELECT sname_initials
FROM maintenance
         JOIN mechanic ON maintenance.id_mech = mechanic.id_mech
GROUP BY sname_initials
HAVING COUNT(tech_cond_resume) > (SELECT COUNT(tech_cond_resume)
                                  FROM maintenance
                                           JOIN mechanic ON maintenance.id_mech = mechanic.id_mech
                                  WHERE sname_initials = 'Голубев Д.Н.');
--76
SELECT gnz, concat_ws(' ', brand.name, marka.name, model.model_name)
FROM vehicle
         JOIN brand ON vehicle.idb = brand.idb
         JOIN marka ON vehicle.idm = marka.idm
         JOIN model ON vehicle.idmo = model.idmo
WHERE date$reg_certif IN (SELECT date$reg_certif
                          FROM vehicle
                          GROUP BY date$reg_certif
                          HAVING COUNT(*) > 1);
--77
SELECT gnz, COUNT(*)
FROM maintenance
GROUP BY gnz
UNION
SELECT gnz, COUNT(*)
FROM vehicle
WHERE gnz NOT IN (SELECT DISTINCT gnz
                  FROM maintenance)
GROUP BY gnz;
--78
SELECT gnz FROM (
SELECT DISTINCT gnz,
                MIN(count) OVER (PARTITION BY gnz) AS "С 2016 по 2018",
                MAX(count) OVER (PARTITION BY gnz) AS "Всего"
FROM (SELECT gnz, COUNT(*) AS count
      FROM maintenance
      WHERE date_part('year', date_work) BETWEEN 2016 AND 2018
      GROUP BY gnz
      UNION ALL
      SELECT *
      FROM (SELECT gnz, COUNT(*) AS count FROM maintenance GROUP BY gnz) AS "t1"
      WHERE gnz IN (SELECT gnz
                    FROM maintenance
                    WHERE date_part('year', date_work) BETWEEN 2016 AND 2018
                    GROUP BY gnz)
      ORDER BY gnz, count) AS "t2") AS "t3"
WHERE "С 2016 по 2018" >= "Всего" * 0.8;
--79
SELECT sname_initials, born, certif_date, work_in_date FROM mechanic
WHERE sname_initials NOT LIKE '%а _._.' AND certif_date >= born + interval '60 years'
  AND date_part('year', born + interval '60 years') < 2018
UNION
SELECT sname_initials, born, certif_date, work_in_date FROM mechanic
WHERE sname_initials LIKE '%а _._.' AND certif_date >= born + interval '55 years'
  AND date_part('year', born + interval '55 years') < 2018
UNION
SELECT sname_initials, born, certif_date, work_in_date FROM mechanic
WHERE sname_initials NOT LIKE '%а _._.' AND certif_date >= born + interval '65 years'
  AND date_part('year', born + interval '65 years') > 2018
UNION
SELECT sname_initials, born, certif_date, work_in_date FROM mechanic
WHERE sname_initials LIKE '%а _._.' AND certif_date >= born + interval '60 years'
  AND date_part('year', born + interval '60 years') > 2018;
--80
SELECT maintenance.gnz, concat_ws(', ', brand.name, marka.name, model_name),
       concat_ws(' ', ser$reg_certif, num$reg_certif, to_char(date$reg_certif, 'dd.mm.yyyy')),
       to_char(date_work, 'dd.mm.yyyy'), sname_initials, tech_cond_resume
FROM maintenance
    JOIN brand ON maintenance.idb = brand.idb
    JOIN marka ON maintenance.idm = marka.idm
    JOIN model ON maintenance.idmo = model.idmo
    JOIN vehicle ON maintenance.gnz = vehicle.gnz
    JOIN mechanic ON maintenance.id_mech = mechanic.id_mech;
--81
SELECT concat(trunc(t1.count/t2.count::numeric * 100, 2), '%')
FROM (SELECT COUNT(tech_cond_resume)
      FROM maintenance JOIN mechanic ON maintenance.id_mech = mechanic.id_mech
      WHERE sname_initials = 'Савостьянов А.В.') AS t1,
     (SELECT COUNT(tech_cond_resume) FROM maintenance) AS t2;
--82
SELECT DISTINCT vehicle.gnz                       AS "Государственный номерной знак",
                date_part('year', age(date_made)) AS "Возраст",
                run                               AS "Пробег",
                last_date_work.max::date          AS "Дата последнего ремонта"
FROM vehicle,
     (SELECT gnz, MAX(date_work) FROM maintenance GROUP BY gnz) AS last_date_work,
     transpgroup
WHERE vehicle.id_tg = transpgroup.id_tg
  AND vehicle.gnz = last_date_work.gnz
  AND (transpgroup.name IN ('Специальные автомобили', 'Специализированные автомобили',
                            'Спортивные автомобили', 'Спортивные мотоциклы')
    OR run > 100000 OR date_part('year', age(date_made)) >= 3);
--83
SELECT gnz, brand.name, marka.name, model_name, transpgroup.name,
       date_work, tech_cond_resume, sname_initials
FROM maintenance
    JOIN brand ON maintenance.idb = brand.idb
    JOIN marka ON maintenance.idm = marka.idm
    JOIN model ON maintenance.idmo = model.idmo
    JOIN transpgroup ON maintenance.id_tg = transpgroup.id_tg
    JOIN mechanic ON maintenance.id_mech = mechanic.id_mech
    JOIN factory ON maintenance.idf = factory.idf
    JOIN maintenancetype AS mtt ON maintenance.mt_id = mtt.mt_id
WHERE factory.legal_addr LIKE '%Japan%' AND mtt.name LIKE 'ТО%'
  AND mtt.name NOT LIKE '%для японских%';
--84
SELECT gnz, EXTRACT(epoch FROM lead(date_work) OVER(PARTITION BY gnz ORDER BY date_work)) -
            EXTRACT(epoch FROM date_work) AS "Интервал"
FROM maintenance
ORDER BY "Интервал"
LIMIT 1;
--85
(SELECT name, COUNT(tech_cond_resume)
FROM maintenance AS m JOIN maintenancetype AS mtt ON m.mt_id = mtt.mt_id
WHERE name LIKE 'ТО-_'
GROUP BY name
ORDER BY name)
UNION ALL
(SELECT name, COUNT(tech_cond_resume)
FROM maintenance AS m JOIN maintenancetype AS mtt ON m.mt_id = mtt.mt_id
WHERE name LIKE 'ТО%японских%'
GROUP BY name
ORDER BY name);
--86
--87
SELECT brand.name,
       "0-6"."от 0 до 6 лет",
       "7-10"."от 7 до 10 лет",
       "11-13"."от 11 до 13 лет",
       "14-18"."от 14 до 18 лет",
       "18+"."старше 18 лет"
FROM brand,
     (SELECT DISTINCT name,
                      concat(trunc((MIN("0-6 temp".count)
                                    OVER (PARTITION BY "0-6 temp".name ORDER BY "0-6 temp".name, "0-6 temp".count))::numeric /
                                   (MAX("0-6 temp".count) OVER (PARTITION BY "0-6 temp".name))::numeric * 100),
                             ' %') AS "от 0 до 6 лет"
      FROM (SELECT name, COUNT(*) AS count
            FROM vehicle
                     JOIN brand ON vehicle.idb = brand.idb
            WHERE date_part('year', age(date_made)) <= 6
            GROUP BY name
            UNION
            SELECT DISTINCT name, 0
            FROM vehicle
                     JOIN brand ON vehicle.idb = brand.idb
            WHERE name NOT IN (SELECT DISTINCT name
                               FROM vehicle
                                        JOIN brand ON vehicle.idb = brand.idb
                               WHERE date_part('year', age(date_made)) <= 6
                               GROUP BY name)
            UNION
            SELECT name, COUNT(*)
            FROM vehicle
                     JOIN brand ON vehicle.idb = brand.idb
            GROUP BY name) AS "0-6 temp"
      ORDER BY name) AS "0-6",
     (SELECT DISTINCT name,
                      concat(trunc((MIN("7-10 temp".count)
                                    OVER (PARTITION BY "7-10 temp".name ORDER BY "7-10 temp".name, "7-10 temp".count))::numeric /
                                   (MAX("7-10 temp".count) OVER (PARTITION BY "7-10 temp".name))::numeric * 100),
                             ' %') AS "от 7 до 10 лет"
      FROM (SELECT name, COUNT(*) AS count
            FROM vehicle
                     JOIN brand ON vehicle.idb = brand.idb
            WHERE date_part('year', age(date_made)) >= 7
              AND date_part('year', age(date_made)) <= 10
            GROUP BY name
            UNION
            SELECT DISTINCT name, 0
            FROM vehicle
                     JOIN brand ON vehicle.idb = brand.idb
            WHERE name NOT IN (SELECT DISTINCT name
                               FROM vehicle
                                        JOIN brand ON vehicle.idb = brand.idb
                               WHERE date_part('year', age(date_made)) >= 7
                                 AND date_part('year', age(date_made)) <= 10
                               GROUP BY name)
            UNION
            SELECT name, COUNT(*)
            FROM vehicle
                     JOIN brand ON vehicle.idb = brand.idb
            GROUP BY name) AS "7-10 temp"
      ORDER BY name) AS "7-10",
     (SELECT DISTINCT name,
                      concat(trunc((MIN("11-13 temp".count)
                                    OVER (PARTITION BY "11-13 temp".name ORDER BY "11-13 temp".name, "11-13 temp".count))::numeric /
                                   (MAX("11-13 temp".count) OVER (PARTITION BY "11-13 temp".name))::numeric * 100),
                             ' %') AS "от 11 до 13 лет"
      FROM (SELECT name, COUNT(*) AS count
            FROM vehicle
                     JOIN brand ON vehicle.idb = brand.idb
            WHERE date_part('year', age(date_made)) >= 11
              AND date_part('year', age(date_made)) <= 13
            GROUP BY name
            UNION
            SELECT DISTINCT name, 0
            FROM vehicle
                     JOIN brand ON vehicle.idb = brand.idb
            WHERE name NOT IN (SELECT DISTINCT name
                               FROM vehicle
                                        JOIN brand ON vehicle.idb = brand.idb
                               WHERE date_part('year', age(date_made)) >= 11
                                 AND date_part('year', age(date_made)) <= 13
                               GROUP BY name)
            UNION
            SELECT name, COUNT(*)
            FROM vehicle
                     JOIN brand ON vehicle.idb = brand.idb
            GROUP BY name) AS "11-13 temp"
      ORDER BY name) AS "11-13",
    (SELECT DISTINCT name,
                      concat(trunc((MIN("14-18 temp".count)
                                    OVER (PARTITION BY "14-18 temp".name ORDER BY "14-18 temp".name, "14-18 temp".count))::numeric /
                                   (MAX("14-18 temp".count) OVER (PARTITION BY "14-18 temp".name))::numeric * 100),
                             ' %') AS "от 14 до 18 лет"
      FROM (SELECT name, COUNT(*) AS count
            FROM vehicle
                     JOIN brand ON vehicle.idb = brand.idb
            WHERE date_part('year', age(date_made)) >= 14
              AND date_part('year', age(date_made)) <= 18
            GROUP BY name
            UNION
            SELECT DISTINCT name, 0
            FROM vehicle
                     JOIN brand ON vehicle.idb = brand.idb
            WHERE name NOT IN (SELECT DISTINCT name
                               FROM vehicle
                                        JOIN brand ON vehicle.idb = brand.idb
                               WHERE date_part('year', age(date_made)) >= 14
                                 AND date_part('year', age(date_made)) <= 18
                               GROUP BY name)
            UNION
            SELECT name, COUNT(*)
            FROM vehicle
                     JOIN brand ON vehicle.idb = brand.idb
            GROUP BY name) AS "14-18 temp"
      ORDER BY name) AS "14-18",
    (SELECT DISTINCT name,
                      concat(trunc((MIN("18+ temp".count)
                                    OVER (PARTITION BY "18+ temp".name ORDER BY "18+ temp".name, "18+ temp".count))::numeric /
                                   (MAX("18+ temp".count) OVER (PARTITION BY "18+ temp".name))::numeric * 100),
                             ' %') AS "старше 18 лет"
      FROM (SELECT name, COUNT(*) AS count
            FROM vehicle
                     JOIN brand ON vehicle.idb = brand.idb
            WHERE date_part('year', age(date_made)) > 18
            GROUP BY name
            UNION
            SELECT DISTINCT name, 0
            FROM vehicle
                     JOIN brand ON vehicle.idb = brand.idb
            WHERE name NOT IN (SELECT DISTINCT name
                               FROM vehicle
                                        JOIN brand ON vehicle.idb = brand.idb
                               WHERE date_part('year', age(date_made)) > 18
                               GROUP BY name)
            UNION
            SELECT name, COUNT(*)
            FROM vehicle
                     JOIN brand ON vehicle.idb = brand.idb
            GROUP BY name) AS "18+ temp"
      ORDER BY name) AS "18+"
WHERE brand.name = "7-10".name
  AND brand.name = "11-13".name
  AND brand.name = "14-18".name
  AND brand.name = "0-6".name
  AND brand.name = "18+".name
ORDER BY name;
--88
--89
SELECT DISTINCT vehicle.gnz, concat_ws(' ', brand.name, marka.name, model_name),
                date$reg_certif, t1.first_repair, t1.first_repair - t2.date_reg AS "Интервал"
FROM vehicle,
     (SELECT gnz, MIN(date_work)::DATE AS first_repair
      FROM maintenance JOIN maintenancetype ON maintenance.mt_id = maintenancetype.mt_id
      WHERE maintenancetype.name = 'Ремонт'
      GROUP BY gnz) AS t1,
     (SELECT gnz, MIN(date$reg_certif) AS date_reg
      FROM vehicle
      GROUP BY gnz) AS t2,
     brand, marka, model
WHERE vehicle.idb = brand.idb AND vehicle.idm = marka.idm AND vehicle.idmo = model.idmo
  AND vehicle.gnz = t1.gnz AND vehicle.gnz = t2.gnz AND t1.first_repair - t2.date_reg <= 365;
--90
SELECT m1.gnz, date_work, sname_initials
FROM maintenance AS m1 JOIN mechanic AS mech1 ON m1.id_mech = mech1.id_mech,
     (SELECT gnz, mech2.id_mech, date_part('year', date_work) AS year
      FROM maintenance AS m2 JOIN mechanic AS mech2 ON m2.id_mech = mech2.id_mech
      WHERE m2.id_mech = mech2.id_mech) AS t1
WHERE m1.gnz = t1.gnz AND m1.id_mech != t1.id_mech AND date_part('year', m1.date_work) = t1.year
GROUP BY m1.gnz, m1.date_work, mech1.sname_initials
ORDER BY m1.gnz DESC;
--91
SELECT SUM(t1.cost * t1.count / vehicle_count.count) AS "Медиана",
       round(sqrt(SUM(t1.cost^2 * t1.count / vehicle_count.count) - SUM(t1.cost * t1.count / vehicle_count.count)^2)) AS "Разброс"
FROM (SELECT cost, COUNT(*)
      FROM vehicle
      GROUP BY cost) AS t1,
    (SELECT COUNT(*) FROM vehicle) AS vehicle_count;