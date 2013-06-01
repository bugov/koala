
  CREATE TABLE IF NOT EXISTS `category` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `url` varchar(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    `title` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
    `legend` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `url` (`url`,`title`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

  CREATE TABLE IF NOT EXISTS `comment` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `page_id` int(10) unsigned NOT NULL,
    `status` tinyint(3) unsigned NOT NULL DEFAULT '0',
    `create_at` int(11) unsigned NOT NULL,
    `title` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
    `author_id` int(11) unsigned DEFAULT NULL,
    `username` varchar(64) CHARACTER SET utf8 NOT NULL DEFAULT 'Guest',
    `text` text CHARACTER SET utf8 NOT NULL,
    PRIMARY KEY (`id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

  CREATE TABLE IF NOT EXISTS `file` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `author_id` int(11) unsigned NOT NULL,
    `create_at` int(11) unsigned NOT NULL,
    `title` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
    `path` varchar(64) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
    `size` int(11) unsigned DEFAULT NULL,
    `mime_type` varchar(16) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `path` (`path`)
  ) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

  CREATE TABLE IF NOT EXISTS `page` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `url` varchar(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    `title` varchar(64) NOT NULL,
    `category_id` int(11) unsigned DEFAULT NULL,
    `legend` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
    `picture_id` int(11) DEFAULT NULL,
    `status` int(10) unsigned NOT NULL,
    `create_at` int(11) unsigned DEFAULT NULL,
    `modify_at` int(11) unsigned DEFAULT NULL,
    `keywords` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
    `description` varchar(512) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
    `text` text CHARACTER SET utf8 COLLATE utf8_bin,
    `author_id` int(11) unsigned NOT NULL,
    `approver_id` int(11) unsigned DEFAULT NULL,
    `owner_id` int(11) unsigned DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `url` (`url`)
  ) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

  CREATE TABLE IF NOT EXISTS `user` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `username` varchar(32) NOT NULL,
    `email` varchar(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    `password` varchar(40) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    `role` int(4) NOT NULL,
    `create_at` int(11) unsigned NOT NULL,
    `info` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `username` (`username`,`email`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;
