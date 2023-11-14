-- Название проекта: Анализ факторов, влияющих на прокат велосипедов в Сеуле

-- Цель: 
-- Цель этого проекта - понять факторы, влияющие на прокат велосипедов в Сеуле 
-- и как они меняются в зависимости от времени (почасово, ежедневно, сезонно), погодных условий и праздников.

-- Взглянем на набор данных
SELECT *
FROM seoul_bicycle_rental;

-- Общее количество велосипедов взятых в аренду за сезон:
SELECT Seasons, SUM(`Rented Bike Count`) as TotalRentals
FROM seoul_bicycle_rental
GROUP BY Seasons;

-- Среднее количество велосипедов взятый в аренду за час:
SELECT Hour, AVG(`Rented Bike Count`) as AvgRentals
FROM seoul_bicycle_rental
GROUP BY Hour;

-- Топ 10 дней с наибольшим количеством велосипедов взятых в аренду
SELECT Date, SUM(`Rented Bike Count`) as TotalRentals
FROM seoul_bicycle_rental
GROUP BY Date
ORDER BY TotalRentals DESC
LIMIT 10;

-- Влияние осадков на арендну:
SELECT 
  CASE 
    WHEN `Rainfall(mm)` = 0 THEN 'No Rain'
    WHEN `Rainfall(mm)` BETWEEN 0 AND 2.5 THEN 'Light Rain'
    WHEN `Rainfall(mm)` BETWEEN 2.5 AND 7.6 THEN 'Moderate Rain'
    ELSE 'Heavy Rain'
  END as RainfallCategory,
  AVG(`Rented Bike Count`) as AvgRentals
FROM seoul_bicycle_rental
GROUP BY RainfallCategory;

-- Динамика арендны с течением времени
SELECT Date, TotalRentals,
  TotalRentals - LAG(TotalRentals) OVER (ORDER BY Date) as ChangeFromPrevDay
FROM (
  SELECT Date, SUM(`Rented Bike Count`) as TotalRentals
  FROM seoul_bicycle_rental
  GROUP BY Date
) sub;

-- Влияние праздничных дней на арендну:
SELECT Holiday, AVG(`Rented Bike Count`) as AvgRentals
FROM seoul_bicycle_rental
GROUP BY Holiday;

-- Пиковые часы аренды:
SELECT Hour, Seasons, AvgRentals, RANK() OVER(ORDER BY AvgRentals desc) as "Rank"
FROM (
  SELECT Hour, Seasons, ROUND(AVG(`Rented Bike Count`),0) as AvgRentals
  FROM seoul_bicycle_rental
  GROUP BY Hour, Seasons
  ORDER BY AvgRentals
) a;

-- Аренда в рабочие дни по сравнению с нерабочими днями:
SELECT `Functioning Day`, SUM(`Rented Bike Count`) as TotalRentals
FROM seoul_bicycle_rental
GROUP BY `Functioning Day`;

