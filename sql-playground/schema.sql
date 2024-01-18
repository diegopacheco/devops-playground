CREATE TABLE `users` (
  `auid` int(10) UNSIGNED NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(150) NOT NULL,
  `createdate` datetime NOT NULL,
  `isActive` tinyint(1) NOT NULL
);


CREATE TABLE `userprofile` (
  `apid` int(10) UNSIGNED NOT NULL,
  `auid` int(10) UNSIGNED NOT NULL,
  `firstname` varchar(50) NOT NULL,
  `lastname` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(45) NOT NULL
);
