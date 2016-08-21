-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Czas generowania: 21 Sie 2016, 15:46
-- Wersja serwera: 10.1.13-MariaDB
-- Wersja PHP: 7.0.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `roleplay`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `rp_buildings`
--

CREATE TABLE `rp_buildings` (
  `UID` int(9) NOT NULL,
  `name` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `description` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `enterX` float NOT NULL,
  `enterY` float NOT NULL,
  `enterZ` float NOT NULL,
  `enterDimension` int(11) NOT NULL,
  `exitX` float NOT NULL,
  `exitY` float NOT NULL,
  `exitZ` float NOT NULL,
  `ownerType` int(11) NOT NULL,
  `owner` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `rp_characters`
--

CREATE TABLE `rp_characters` (
  `UID` int(9) NOT NULL,
  `global` int(9) NOT NULL,
  `name` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `skin` int(3) NOT NULL,
  `money` int(9) NOT NULL DEFAULT '1000',
  `health` int(3) NOT NULL DEFAULT '100'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `rp_groups`
--

CREATE TABLE `rp_groups` (
  `UID` int(11) NOT NULL,
  `name` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `bank` int(11) NOT NULL,
  `leaderRank` int(11) NOT NULL,
  `leader` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `specialPermissions` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `rp_groups_members`
--

CREATE TABLE `rp_groups_members` (
  `UID` int(11) NOT NULL,
  `charUID` int(11) NOT NULL,
  `groupUID` int(11) NOT NULL,
  `rank` int(11) NOT NULL,
  `dutyTime` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `rp_groups_ranks`
--

CREATE TABLE `rp_groups_ranks` (
  `UID` int(11) NOT NULL,
  `groupID` int(11) NOT NULL,
  `name` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `salary` int(11) NOT NULL DEFAULT '0',
  `skin` int(11) DEFAULT NULL,
  `permissions` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `rp_items`
--

CREATE TABLE `rp_items` (
  `UID` int(9) NOT NULL,
  `name` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `used` int(1) NOT NULL DEFAULT '0',
  `ownerType` int(9) NOT NULL,
  `owner` int(9) NOT NULL,
  `type` int(9) NOT NULL,
  `properties` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `posX` float DEFAULT NULL,
  `posY` float DEFAULT NULL,
  `posZ` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `rp_logs`
--

CREATE TABLE `rp_logs` (
  `UID` int(9) NOT NULL,
  `type` int(11) NOT NULL,
  `time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ipAddress` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `globalID` int(9) NOT NULL,
  `charID` int(9) NOT NULL,
  `details` varchar(512) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `rp_objects`
--

CREATE TABLE `rp_objects` (
  `UID` int(11) NOT NULL,
  `model` int(11) NOT NULL,
  `posX` float NOT NULL,
  `posY` float NOT NULL,
  `posZ` float NOT NULL,
  `rotX` float NOT NULL,
  `rotY` float NOT NULL,
  `rotZ` float NOT NULL,
  `ownerType` int(11) NOT NULL,
  `owner` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `rp_vehicles`
--

CREATE TABLE `rp_vehicles` (
  `UID` int(9) NOT NULL,
  `model` int(3) NOT NULL,
  `health` int(4) NOT NULL DEFAULT '1000',
  `panelStates` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0,0,0,0,0,0,0',
  `doorStates` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0,0,0,0,0,0',
  `wheelStates` varchar(15) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0,0,0,0',
  `color` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0,0,0,0,0,0,0,0,0,0,0,0',
  `fuel` float NOT NULL DEFAULT '10',
  `mileage` float NOT NULL DEFAULT '0',
  `ownerType` int(2) NOT NULL DEFAULT '0',
  `owner` int(9) NOT NULL DEFAULT '0',
  `parkX` float NOT NULL DEFAULT '0',
  `parkY` float NOT NULL DEFAULT '0',
  `parkZ` float NOT NULL DEFAULT '0',
  `parkRX` int(7) NOT NULL DEFAULT '0',
  `parkRY` int(7) NOT NULL DEFAULT '0',
  `parkRZ` int(7) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Indeksy dla zrzutów tabel
--

--
-- Indexes for table `rp_buildings`
--
ALTER TABLE `rp_buildings`
  ADD PRIMARY KEY (`UID`);

--
-- Indexes for table `rp_characters`
--
ALTER TABLE `rp_characters`
  ADD PRIMARY KEY (`UID`);

--
-- Indexes for table `rp_groups`
--
ALTER TABLE `rp_groups`
  ADD PRIMARY KEY (`UID`);

--
-- Indexes for table `rp_groups_members`
--
ALTER TABLE `rp_groups_members`
  ADD PRIMARY KEY (`UID`);

--
-- Indexes for table `rp_groups_ranks`
--
ALTER TABLE `rp_groups_ranks`
  ADD PRIMARY KEY (`UID`);

--
-- Indexes for table `rp_items`
--
ALTER TABLE `rp_items`
  ADD PRIMARY KEY (`UID`);

--
-- Indexes for table `rp_logs`
--
ALTER TABLE `rp_logs`
  ADD PRIMARY KEY (`UID`);

--
-- Indexes for table `rp_objects`
--
ALTER TABLE `rp_objects`
  ADD PRIMARY KEY (`UID`);

--
-- Indexes for table `rp_vehicles`
--
ALTER TABLE `rp_vehicles`
  ADD PRIMARY KEY (`UID`);