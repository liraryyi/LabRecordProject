
SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `tbl_calendar`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_calendar`;
CREATE TABLE `tbl_calendar` (
  `id` char(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'uuid',
  `loginAct` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `editBy` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `startDate` char(19) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `endDate` char(19) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `color` char(7) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `isPublic` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `group` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for `tbl_calendar_idea_relation`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_calendar_idea_relation`;
CREATE TABLE `tbl_calendar_idea_relation` (
  `id` char(32) NOT NULL,
  `calendarId` char(32) DEFAULT NULL,
  `ideaId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for `tbl_calendar_remark`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_calendar_remark`;
CREATE TABLE `tbl_calendar_remark` (
  `id` char(32) NOT NULL,
  `noteContent` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editFlag` char(1) DEFAULT NULL COMMENT '0表示未修改，1表示已修改',
  `calendarId` char(32) DEFAULT NULL,
  `headPath` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for `tbl_dic_type`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_dic_type`;
CREATE TABLE `tbl_dic_type` (
  `code` varchar(255) NOT NULL COMMENT '编码是主键，不能为空，不能含有中文。',
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for `tbl_dic_value`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_dic_value`;
CREATE TABLE `tbl_dic_value` (
  `id` char(32) NOT NULL COMMENT '主键，采用UUID',
  `value` varchar(255) DEFAULT NULL COMMENT '不能为空，并且要求同一个字典类型下字典值不能重复，具有唯一性。',
  `text` varchar(255) DEFAULT NULL COMMENT '可以为空',
  `orderNo` varchar(255) DEFAULT NULL COMMENT '可以为空，但不为空的时候，要求必须是正整数',
  `typeCode` varchar(255) DEFAULT NULL COMMENT '外键',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Records of tbl_dic_value
-- ----------------------------
INSERT INTO `tbl_dic_value` VALUES ('06e3cbdf10a44eca8511dadfc6896c55', '平平无奇的计划', '平平无奇的计划', '1', 'PlanGroup');
INSERT INTO `tbl_dic_value` VALUES ('06e3cbdf10a44eca8511dddfc6896c55', '平平无奇的想法', '平平无奇的想法', '1', 'IdeaGroup');
INSERT INTO `tbl_dic_value` VALUES ('06e3cbdf10a44eca8533dadfc6896c55', '有点意思的计划', '有点意思的计划', '2', 'PlanGroup');
INSERT INTO `tbl_dic_value` VALUES ('06e3cbdf22a44eca8533dadfc6896c55', '非常伟大的计划', '非常伟大的计划', '3', 'PlanGroup');
INSERT INTO `tbl_dic_value` VALUES ('0fe33840c6d84bf78df55d49b169a894', '有点意思的想法', '有点意思的想法', '2', 'IdeaGroup');
INSERT INTO `tbl_dic_value` VALUES ('12302fd42bd349c1bb768b19600e6b20', '非常伟大的想法', '非常伟大的想法', '3', 'IdeaGroup');
INSERT INTO `tbl_dic_value` VALUES ('1615f0bb3e604552a86cde9a2ad45bea', '灵光乍现', '灵光乍现', '1', 'IdeaSource');
INSERT INTO `tbl_dic_value` VALUES ('176039d2a90e4b1a81c5ab8707268636', '大腿一拍就get到了', '大腿一拍就get到了', '2', 'IdeaSource');
INSERT INTO `tbl_dic_value` VALUES ('1e0bd307e6ee425599327447f8387285', '智慧的王红师姐的讲述', '智慧的王红师姐的讲述', '3', 'IdeaSource');
INSERT INTO `tbl_dic_value` VALUES ('2173663b40b949ce928db92607b5fe57', 'xx文献', 'xx文献', '4', 'IdeaSource');
INSERT INTO `tbl_dic_value` VALUES ('2876690b7e744333b7f1867102f91153', '准备实现-成功就在眼前', '准备实现-成功就在眼前', '1', 'IdeaState');
INSERT INTO `tbl_dic_value` VALUES ('fd677cc3b5d047d994e16f6ece4d3d45', '事实证明这是一个废物想法', '事实证明这是一个废物想法', '3', 'IdeaState');
INSERT INTO `tbl_dic_value` VALUES ('ff802a03ccea4ded8731427055681d48', '已经实现-直接走上巅峰', '已经实现-直接走上巅峰', '2', 'IdeaState');

-- ----------------------------
-- Table structure for `tbl_idea`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_idea`;
CREATE TABLE `tbl_idea` (
  `id` char(32) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `loginAct` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `group` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `sourceURL` varchar(255) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(16) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(16) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `isPublic` char(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- ----------------------------
-- Table structure for `tbl_idea_remark`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_idea_remark`;
CREATE TABLE `tbl_idea_remark` (
  `id` char(32) NOT NULL,
  `loginAct` varchar(255) DEFAULT NULL,
  `noteContent` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editFlag` char(1) DEFAULT NULL COMMENT '0表示未修改，1表示已修改',
  `ideaId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- ----------------------------
-- Table structure for `tbl_plan`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_plan`;
CREATE TABLE `tbl_plan` (
  `id` char(32) NOT NULL,
  `loginAct` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `group` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `startDate` char(16) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `endDate` char(16) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `ideaId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- ----------------------------
-- Table structure for `tbl_plan_state`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_plan_state`;
CREATE TABLE `tbl_plan_state` (
  `id` char(32) NOT NULL,
  `loginAct` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `startDate` char(16) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `endDate` char(16) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `planId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- ----------------------------
-- Table structure for `tbl_state_calendar_relation`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_state_calendar_relation`;
CREATE TABLE `tbl_state_calendar_relation` (
  `id` char(32) NOT NULL,
  `stateId` char(32) DEFAULT NULL,
  `calendarId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- ----------------------------
-- Table structure for `tbl_user`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_user`;
CREATE TABLE `tbl_user` (
  `id` char(32) NOT NULL COMMENT 'uuid',
  `loginAct` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `loginPwd` varchar(255) DEFAULT NULL COMMENT '密码不能采用明文存储，采用密文，MD5加密之后的数据',
  `email` varchar(255) DEFAULT NULL,
  `lockState` char(1) DEFAULT NULL COMMENT '锁定状态为空时表示启用，为0时表示锁定，为1时表示启用。',
  `deptno` char(4) DEFAULT NULL,
  `allowIps` varchar(255) DEFAULT NULL COMMENT '允许访问的IP为空时表示IP地址永不受限，允许访问的IP可以是一个，也可以是多个，当多个IP地址的时候，采用半角逗号分隔。允许IP是192.168.100.2，表示该用户只能在IP地址为192.168.100.2的机器上使用。',
  `createTime` char(19) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `path` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- ----------------------------
-- Table structure for `tbl_verification_code`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_verification_code`;
CREATE TABLE `tbl_verification_code` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `userId` varchar(255) DEFAULT NULL COMMENT '閻劍鍩涚紓鏍у娇',
  `code` char(8) DEFAULT NULL COMMENT '验证码',
  `createTime` char(19) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '閻㈢喐鍨氶弮鍫曟？',
  `expiredTime` char(19) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '閸掓稑缂?0閸掑棝鎸撻崥搴ょ箖閺?',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COMMENT='验证码表';
