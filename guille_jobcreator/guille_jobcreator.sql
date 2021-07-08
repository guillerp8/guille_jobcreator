USE `es_extended`;

CREATE TABLE `jobblips` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`text` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`coords` VARCHAR(255) NOT NULL DEFAULT '' COLLATE 'utf8mb4_bin',
	`sprite` INT(11) NOT NULL DEFAULT '0',
	`color` INT(11) NOT NULL DEFAULT '0',
	`job` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=27
;

CREATE TABLE `jobcars` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`model` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
	`job` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=36
;

CREATE TABLE `jobclothes` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`job` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`label` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`skin` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=11
;

CREATE TABLE `jobconfigs` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`job` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`shop` INT(11) NULL DEFAULT NULL,
	`car1` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`car2` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`idman` INT(11) NULL DEFAULT NULL,
	`vehmanagement` INT(11) NULL DEFAULT NULL,
	`alerts` INT(11) NULL DEFAULT NULL,
	`obj` INT(11) NULL DEFAULT NULL,
	`handcuff` INT(11) NULL DEFAULT NULL,
	`bill` INT(11) NULL DEFAULT NULL,
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=49
;

CREATE TABLE `jobitems` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`itemType` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`name` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`job` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`price` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=32
;

CREATE TABLE `jobpoints` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`job` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`name` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`coords` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=415
;
