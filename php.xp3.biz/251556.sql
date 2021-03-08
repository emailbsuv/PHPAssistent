-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- Хост: localhost
-- Время создания: Мар 08 2021 г., 07:27
-- Версия сервера: 10.3.22-MariaDB-log
-- Версия PHP: 7.2.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `251556`
--

-- --------------------------------------------------------

--
-- Структура таблицы `reclama`
--

CREATE TABLE `reclama` (
  `id` int(11) NOT NULL,
  `linkname` varchar(250) NOT NULL,
  `filename` varchar(10) NOT NULL,
  `userid` varchar(9) NOT NULL,
  `dtimeexpired` varchar(20) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `reclama`
--

INSERT INTO `reclama` (`id`, `linkname`, `filename`, `userid`, `dtimeexpired`) VALUES
(1, 'https://account.rabota.ua/ua/jobsearch/notepad/cvs', '672496.png', '55695369', '2021-04-08 06:49:38');

-- --------------------------------------------------------

--
-- Структура таблицы `sites`
--

CREATE TABLE `sites` (
  `id` int(11) NOT NULL,
  `country` varchar(50) NOT NULL,
  `domain` varchar(50) NOT NULL,
  `intervaldays` varchar(3) NOT NULL,
  `messenger` varchar(15) NOT NULL,
  `contact` varchar(50) NOT NULL,
  `userid` varchar(9) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `sites`
--

INSERT INTO `sites` (`id`, `country`, `domain`, `intervaldays`, `messenger`, `contact`, `userid`) VALUES
(2, 'USA', 'www.monster.com', '7', 'Telegram', '@bogdansuvorov', ''),
(3, 'USA', 'www.linkedin.com', '7', 'Telegram', '@bogdansuvorov', ''),
(4, 'USA', 'www.careerbuilder.com', '7', 'Telegram', '@bogdansuvorov', ''),
(5, 'Ukraine', 'www.rabota.ua', '7', 'Telegram', '@bogdansuvorov', ''),
(6, 'Ukraine', 'www.trud.ua', '20', 'Telegram', '@bogdansuvorov', ''),
(7, 'Ukraine', 'www.work.ua', '7', 'Telegram', '@bogdansuvorov', ''),
(8, 'Turkey', 'www.kariyer.net', '7', 'Telegram', '@bogdansuvorov', ''),
(9, 'Turkey', 'www.careerjet.com.tr', '7', 'Telegram', '@bogdansuvorov', ''),
(10, 'Turkey', 'www.elemanonline.com.tr', '7', 'Telegram', '@bogdansuvorov', ''),
(11, 'Turkey', 'www.yenibiris.com', '7', 'Telegram', '@bogdansuvorov', ''),
(12, 'Russia', 'www.hh.ru', '2', 'Telegram', '@bogdansuvorov', ''),
(13, 'Russia', 'www.rabota.ru', '5', 'Telegram', '@bogdansuvorov', ''),
(14, 'Russia', 'www.superjob.ru', '5', 'Telegram', '@bogdansuvorov', ''),
(15, 'France', 'www.ouestjob.com', '7', 'Telegram', '@bogdansuvorov', ''),
(16, 'France', 'www.apec.fr', '7', 'Telegram', '@bogdansuvorov', ''),
(17, 'France', 'www.meteojob.com', '7', 'Telegram', '@bogdansuvorov', ''),
(18, 'USA', 'www.indeed.com', '7', 'Telegram', '@bogdansuvorov', '');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `userid` varchar(9) NOT NULL,
  `lastvisitdatetime` varchar(20) NOT NULL,
  `hoursonline` varchar(6) NOT NULL,
  `banned` varchar(1) NOT NULL,
  `bannedr` varchar(1) NOT NULL,
  `bannedsites` mediumtext NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id`, `userid`, `lastvisitdatetime`, `hoursonline`, `banned`, `bannedr`, `bannedsites`) VALUES
(1, '55695369', '2021-03-08 07:00:00', '2', '0', '0', '');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `reclama`
--
ALTER TABLE `reclama`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `sites`
--
ALTER TABLE `sites`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
